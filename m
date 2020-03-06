Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8C317C2D5
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 17:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgCFQY5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 11:24:57 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23716 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726166AbgCFQY5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Mar 2020 11:24:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583511896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7YQYjXtX5SKdhVMtcrZUxIhpmnZ5HnjhJ3UoT3fYhZg=;
        b=iEXBrwMkiHjbK0UjTS7nUVB+vaJ5FZoSJPmSSqDS3GBeCOmF9lRbywmPN21lO83rGhehd2
        OfXKVWQ7OLVzBXiNoDweQ7eMPdtZBmoVR8I1VGCwlt/ER6ycGV1BGRe8FwVPcQJ33Az5SY
        vWZ37/zlX5g806SKMvtb3Bo5uEvEae8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-mnL3Hbc1OhqwozznM0zX_A-1; Fri, 06 Mar 2020 11:24:52 -0500
X-MC-Unique: mnL3Hbc1OhqwozznM0zX_A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9D1EDBF1;
        Fri,  6 Mar 2020 16:24:50 +0000 (UTC)
Received: from x1.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CDA8660C63;
        Fri,  6 Mar 2020 16:24:46 +0000 (UTC)
Date:   Fri, 6 Mar 2020 09:24:45 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dev@dpdk.org" <dev@dpdk.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "thomas@monjalon.net" <thomas@monjalon.net>,
        "bluca@debian.org" <bluca@debian.org>,
        "jerinjacobk@gmail.com" <jerinjacobk@gmail.com>,
        "Richardson, Bruce" <bruce.richardson@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: Re: [PATCH v2 0/7] vfio/pci: SR-IOV support
Message-ID: <20200306092445.1bd4611c@x1.home>
In-Reply-To: <3e8db1d0-8afc-f1e9-e857-aead4717fa11@redhat.com>
References: <158213716959.17090.8399427017403507114.stgit@gimli.home>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D79A8A7@SHSMSX104.ccr.corp.intel.com>
        <a6c04bac-0a37-f4c0-876e-e5cf2a8a6c3f@redhat.com>
        <20200305101406.02703e2a@w520.home>
        <3e8db1d0-8afc-f1e9-e857-aead4717fa11@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 6 Mar 2020 11:35:21 +0800
Jason Wang <jasowang@redhat.com> wrote:

> On 2020/3/6 =E4=B8=8A=E5=8D=881:14, Alex Williamson wrote:
> > On Tue, 25 Feb 2020 14:09:07 +0800
> > Jason Wang <jasowang@redhat.com> wrote:
> > =20
> >> On 2020/2/25 =E4=B8=8A=E5=8D=8810:33, Tian, Kevin wrote: =20
> >>>> From: Alex Williamson
> >>>> Sent: Thursday, February 20, 2020 2:54 AM
> >>>>
> >>>> Changes since v1 are primarily to patch 3/7 where the commit log is
> >>>> rewritten, along with option parsing and failure logging based on
> >>>> upstream discussions.  The primary user visible difference is that
> >>>> option parsing is now much more strict.  If a vf_token option is
> >>>> provided that cannot be used, we generate an error.  As a result of
> >>>> this, opening a PF with a vf_token option will serve as a mechanism =
of
> >>>> setting the vf_token.  This seems like a more user friendly API than
> >>>> the alternative of sometimes requiring the option (VFs in use) and
> >>>> sometimes rejecting it, and upholds our desire that the option is
> >>>> always either used or rejected.
> >>>>
> >>>> This also means that the VFIO_DEVICE_FEATURE ioctl is not the only
> >>>> means of setting the VF token, which might call into question whether
> >>>> we absolutely need this new ioctl.  Currently I'm keeping it because=
 I
> >>>> can imagine use cases, for example if a hypervisor were to support
> >>>> SR-IOV, the PF device might be opened without consideration for a VF
> >>>> token and we'd require the hypservisor to close and re-open the PF in
> >>>> order to set a known VF token, which is impractical.
> >>>>
> >>>> Series overview (same as provided with v1): =20
> >>> Thanks for doing this!
> >>>    =20
> >>>> The synopsis of this series is that we have an ongoing desire to dri=
ve
> >>>> PCIe SR-IOV PFs from userspace with VFIO.  There's an immediate need
> >>>> for this with DPDK drivers and potentially interesting future use =20
> >>> Can you provide a link to the DPDK discussion?
> >>>    =20
> >>>> cases in virtualization.  We've been reluctant to add this support
> >>>> previously due to the dependency and trust relationship between the
> >>>> VF device and PF driver.  Minimally the PF driver can induce a denial
> >>>> of service to the VF, but depending on the specific implementation,
> >>>> the PF driver might also be responsible for moving data between VFs
> >>>> or have direct access to the state of the VF, including data or state
> >>>> otherwise private to the VF or VF driver. =20
> >>> Just a loud thinking. While the motivation of VF token sounds reasona=
ble
> >>> to me, I'm curious why the same concern is not raised in other usages.
> >>> For example, there is no such design in virtio framework, where the
> >>> virtio device could also be restarted, putting in separate process (v=
host-user),
> >>> and even in separate VM (virtio-vhost-user), etc. =20
> >>
> >> AFAIK, the restart could only be triggered by either VM or qemu. But
> >> yes, the datapath could be offloaded.
> >>
> >> But I'm not sure introducing another dedicated mechanism is better than
> >> using the exist generic POSIX mechanism to make sure the connection
> >> (AF_UINX) is secure.
> >>
> >> =20
> >>>    Of course the para-
> >>> virtualized attribute of virtio implies some degree of trust, but as =
you
> >>> mentioned many SR-IOV implementations support VF->PF communication
> >>> which also implies some level of trust. It's perfectly fine if VFIO j=
ust tries
> >>> to do better than other sub-systems, but knowing how other people
> >>> tackle the similar problem may make the whole picture clearer. =F0=9F=
=98=8A
> >>>
> >>> +Jason. =20
> >>
> >> I'm not quite sure e.g allowing userspace PF driver with kernel VF
> >> driver would not break the assumption of kernel security model. At lea=
st
> >> we should forbid a unprivileged PF driver running in userspace. =20
> > It might be useful to have your opinion on this series, because that's
> > exactly what we're trying to do here.  Various environments, DPDK
> > specifically, want a userspace PF driver.  This series takes steps to
> > mitigate the risk of having such a driver, such as requiring this VF
> > token interface to extend the VFIO interface and validate participation
> > around a PF that is not considered trusted by the kernel. =20
>=20
>=20
> I may miss something. But what happens if:
>=20
> - PF driver is running by unprivileged user
> - PF is programmed to send translated DMA request
> - Then unprivileged user can mangle the kernel data

ATS is a security risk regardless of SR-IOV, how does this change it?
Thanks,

Alex

> > We also set
> > a driver_override to try to make sure no host kernel driver can
> > automatically bind to a VF of a user owned PF, only vfio-pci, but we
> > don't prevent the admin from creating configurations where the VFs are
> > used by other host kernel drivers.
> >
> > I think the question Kevin is inquiring about is whether virtio devices
> > are susceptible to the type of collaborative, shared key environment
> > we're creating here.  For example, can a VM or qemu have access to
> > reset a virtio device in a way that could affect other devices, ex. FLR
> > on a PF that could interfere with VF operation.  Thanks, =20
>=20
>=20
> Right, but I'm not sure it can be done only via virtio or need support=20
> from transport (e.g PCI).
>=20
> Thanks
>=20
>=20
> >
> > Alex
> > =20

