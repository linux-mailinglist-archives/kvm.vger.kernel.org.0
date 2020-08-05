Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FC623C369
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 04:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgHECWo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 22:22:44 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50688 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725999AbgHECWo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Aug 2020 22:22:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596594162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=brvuOtXy+L7Dz9s43GrQwnnfbEFFwpeLPvBNMPPwy+g=;
        b=gDe3XFR1fKJhbO94zNYZ+/DAs4vXAq4nDvyzUPu1x+hqQgqsw9RR/iDKqr2dLCweni2+CT
        ybQ/Ape0bprmnD7+d3DQDgiKY5g2fIVIREkYX9wdks+ZtWCRidvjiumZYlsLHSO/bLLHOv
        UQ6OPH/HxjdqtpRFuT7qouWf86ElemA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-s2FpGy-zML-YABoViCCMlQ-1; Tue, 04 Aug 2020 22:22:40 -0400
X-MC-Unique: s2FpGy-zML-YABoViCCMlQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E19518FF662;
        Wed,  5 Aug 2020 02:22:38 +0000 (UTC)
Received: from [10.72.13.71] (ovpn-13-71.pek2.redhat.com [10.72.13.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA2238AC05;
        Wed,  5 Aug 2020 02:22:16 +0000 (UTC)
Subject: Re: device compatibility interface for live migration with assigned
 devices
To:     Cornelia Huck <cohuck@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        libvir-list@redhat.com, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        corbet@lwn.net, openstack-discuss@lists.openstack.org,
        shaohe.feng@intel.com, kevin.tian@intel.com, eskultet@redhat.com,
        jian-feng.ding@intel.com, dgilbert@redhat.com,
        zhenyuw@linux.intel.com, hejie.xu@intel.com, bao.yumeng@zte.com.cn,
        smooney@redhat.com, intel-gvt-dev@lists.freedesktop.org,
        berrange@redhat.com, dinechin@redhat.com, devel@ovirt.org
References: <20200713232957.GD5955@joy-OptiPlex-7040>
 <9bfa8700-91f5-ebb4-3977-6321f0487a63@redhat.com>
 <20200716083230.GA25316@joy-OptiPlex-7040> <20200717101258.65555978@x1.home>
 <20200721005113.GA10502@joy-OptiPlex-7040>
 <20200727072440.GA28676@joy-OptiPlex-7040> <20200727162321.7097070e@x1.home>
 <20200729080503.GB28676@joy-OptiPlex-7040>
 <20200804183503.39f56516.cohuck@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c178a0d3-269d-1620-22b1-9010f602d8ff@redhat.com>
Date:   Wed, 5 Aug 2020 10:22:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200804183503.39f56516.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/8/5 上午12:35, Cornelia Huck wrote:
> [sorry about not chiming in earlier]
>
> On Wed, 29 Jul 2020 16:05:03 +0800
> Yan Zhao <yan.y.zhao@intel.com> wrote:
>
>> On Mon, Jul 27, 2020 at 04:23:21PM -0600, Alex Williamson wrote:
> (...)
>
>>> Based on the feedback we've received, the previously proposed interface
>>> is not viable.  I think there's agreement that the user needs to be
>>> able to parse and interpret the version information.  Using json seems
>>> viable, but I don't know if it's the best option.  Is there any
>>> precedent of markup strings returned via sysfs we could follow?
> I don't think encoding complex information in a sysfs file is a viable
> approach. Quoting Documentation/filesystems/sysfs.rst:
>
> "Attributes should be ASCII text files, preferably with only one value
> per file. It is noted that it may not be efficient to contain only one
> value per file, so it is socially acceptable to express an array of
> values of the same type.
>                                                                                   
> Mixing types, expressing multiple lines of data, and doing fancy
> formatting of data is heavily frowned upon."
>
> Even though this is an older file, I think these restrictions still
> apply.


+1, that's another reason why devlink(netlink) is better.

Thanks

