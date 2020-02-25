Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D11EA16B96E
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 07:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbgBYGJ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 01:09:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38674 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727005AbgBYGJ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 01:09:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582610964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0IoUDI0r2nKt/KLH2gl0wTcdvg0oCDvDokn7okiLyHg=;
        b=R4Kf+dOoIrZfig0mugI2di0BsODBOtZtaylwB/xm/qf3avyTjlsveNw53EQoQv4W2cg9of
        QdTKyFpouMVjtJlUu+iQvv3Wv4pcHznNe7TQPkYnxYDYSIxOLE5B8sn4iAD3hxytv9ipfk
        I1AxJymjBV4hsiENLb+V79YWeU4BhMQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-KEF-yYO0OPWKOZhO7cB7og-1; Tue, 25 Feb 2020 01:09:20 -0500
X-MC-Unique: KEF-yYO0OPWKOZhO7cB7og-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FB92107ACC5;
        Tue, 25 Feb 2020 06:09:19 +0000 (UTC)
Received: from [10.72.13.170] (ovpn-13-170.pek2.redhat.com [10.72.13.170])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA7141001902;
        Tue, 25 Feb 2020 06:09:09 +0000 (UTC)
Subject: Re: [PATCH v2 0/7] vfio/pci: SR-IOV support
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dev@dpdk.org" <dev@dpdk.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "thomas@monjalon.net" <thomas@monjalon.net>,
        "bluca@debian.org" <bluca@debian.org>,
        "jerinjacobk@gmail.com" <jerinjacobk@gmail.com>,
        "Richardson, Bruce" <bruce.richardson@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
References: <158213716959.17090.8399427017403507114.stgit@gimli.home>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D79A8A7@SHSMSX104.ccr.corp.intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a6c04bac-0a37-f4c0-876e-e5cf2a8a6c3f@redhat.com>
Date:   Tue, 25 Feb 2020 14:09:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D79A8A7@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/2/25 =E4=B8=8A=E5=8D=8810:33, Tian, Kevin wrote:
>> From: Alex Williamson
>> Sent: Thursday, February 20, 2020 2:54 AM
>>
>> Changes since v1 are primarily to patch 3/7 where the commit log is
>> rewritten, along with option parsing and failure logging based on
>> upstream discussions.  The primary user visible difference is that
>> option parsing is now much more strict.  If a vf_token option is
>> provided that cannot be used, we generate an error.  As a result of
>> this, opening a PF with a vf_token option will serve as a mechanism of
>> setting the vf_token.  This seems like a more user friendly API than
>> the alternative of sometimes requiring the option (VFs in use) and
>> sometimes rejecting it, and upholds our desire that the option is
>> always either used or rejected.
>>
>> This also means that the VFIO_DEVICE_FEATURE ioctl is not the only
>> means of setting the VF token, which might call into question whether
>> we absolutely need this new ioctl.  Currently I'm keeping it because I
>> can imagine use cases, for example if a hypervisor were to support
>> SR-IOV, the PF device might be opened without consideration for a VF
>> token and we'd require the hypservisor to close and re-open the PF in
>> order to set a known VF token, which is impractical.
>>
>> Series overview (same as provided with v1):
> Thanks for doing this!
>
>> The synopsis of this series is that we have an ongoing desire to drive
>> PCIe SR-IOV PFs from userspace with VFIO.  There's an immediate need
>> for this with DPDK drivers and potentially interesting future use
> Can you provide a link to the DPDK discussion?
>
>> cases in virtualization.  We've been reluctant to add this support
>> previously due to the dependency and trust relationship between the
>> VF device and PF driver.  Minimally the PF driver can induce a denial
>> of service to the VF, but depending on the specific implementation,
>> the PF driver might also be responsible for moving data between VFs
>> or have direct access to the state of the VF, including data or state
>> otherwise private to the VF or VF driver.
> Just a loud thinking. While the motivation of VF token sounds reasonabl=
e
> to me, I'm curious why the same concern is not raised in other usages.
> For example, there is no such design in virtio framework, where the
> virtio device could also be restarted, putting in separate process (vho=
st-user),
> and even in separate VM (virtio-vhost-user), etc.


AFAIK, the restart could only be triggered by either VM or qemu. But=20
yes, the datapath could be offloaded.

But I'm not sure introducing another dedicated mechanism is better than=20
using the exist generic POSIX mechanism to make sure the connection=20
(AF_UINX) is secure.


>   Of course the para-
> virtualized attribute of virtio implies some degree of trust, but as yo=
u
> mentioned many SR-IOV implementations support VF->PF communication
> which also implies some level of trust. It's perfectly fine if VFIO jus=
t tries
> to do better than other sub-systems, but knowing how other people
> tackle the similar problem may make the whole picture clearer. =F0=9F=98=
=8A
>
> +Jason.


I'm not quite sure e.g allowing userspace PF driver with kernel VF=20
driver would not break the assumption of kernel security model. At least=20
we should forbid a unprivileged PF driver running in userspace.

Thanks

