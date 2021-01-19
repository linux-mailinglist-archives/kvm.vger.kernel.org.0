Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F0D2FB42E
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 09:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731301AbhASIgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 03:36:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28846 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730004AbhASIgW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 03:36:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611045295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=exmrZ/6vymYFyD9ipg+t6sb8kPfC89qM4+qnKpuaTAg=;
        b=a7B5rScRkq/917FNM/2nHl+D9zZJ5RxfCiwMT8VciiYoU+v06xPz/28VbOT+fphX+tHwdM
        VTBbK8ldGDjohiIXKmQaubYeAPYP1oei0XzCnSN/9ob7mE/OkwaNzdP3op8QuY96TZJHvC
        x5lxRexjf/RMycTADn1uVG1czQ+akBc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-HzeH01mdPoiYhDERGSwrmA-1; Tue, 19 Jan 2021 03:34:51 -0500
X-MC-Unique: HzeH01mdPoiYhDERGSwrmA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32AEB1842142;
        Tue, 19 Jan 2021 08:34:48 +0000 (UTC)
Received: from gondolin (ovpn-113-246.ams2.redhat.com [10.36.113.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7BC6D6A8F9;
        Tue, 19 Jan 2021 08:34:27 +0000 (UTC)
Date:   Tue, 19 Jan 2021 09:34:24 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        David Hildenbrand <david@redhat.com>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        pair@us.ibm.com, brijesh.singh@amd.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Ram Pai <linuxram@us.ibm.com>, qemu-devel@nongnu.org,
        frankja@linux.ibm.com, Halil Pasic <pasic@linux.ibm.com>,
        thuth@redhat.com, Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Greg Kurz <groug@kaod.org>, qemu-s390x@nongnu.org,
        rth@twiddle.net, Marcelo Tosatti <mtosatti@redhat.com>,
        qemu-ppc@nongnu.org, pbonzini@redhat.com,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Boris Fiuczynski <fiuczy@linux.ibm.com>
Subject: Re: [for-6.0 v5 11/13] spapr: PEF: prevent migration
Message-ID: <20210119093424.165cfebb.cohuck@redhat.com>
In-Reply-To: <2f358741-a9a5-a5d6-715c-c3dba85fbb17@de.ibm.com>
References: <20201218124111.4957eb50.cohuck@redhat.com>
        <20210104071550.GA22585@ram-ibm-com.ibm.com>
        <20210104134629.49997b53.pasic@linux.ibm.com>
        <20210104184026.GD4102@ram-ibm-com.ibm.com>
        <20210105115614.7daaadd6.pasic@linux.ibm.com>
        <20210105204125.GE4102@ram-ibm-com.ibm.com>
        <20210111175914.13adfa2e.cohuck@redhat.com>
        <20210113124226.GH2938@work-vm>
        <20210114112517.GE1643043@redhat.com>
        <20210114235125.GO435587@yekko.fritz.box>
        <20210118173912.GF9899@work-vm>
        <2f358741-a9a5-a5d6-715c-c3dba85fbb17@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 Jan 2021 09:28:22 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 18.01.21 18:39, Dr. David Alan Gilbert wrote:
> > * David Gibson (david@gibson.dropbear.id.au) wrote: =20
> >> On Thu, Jan 14, 2021 at 11:25:17AM +0000, Daniel P. Berrang=C3=A9 wrot=
e: =20
> >>> On Wed, Jan 13, 2021 at 12:42:26PM +0000, Dr. David Alan Gilbert wrot=
e: =20
> >>>> * Cornelia Huck (cohuck@redhat.com) wrote: =20
> >>>>> On Tue, 5 Jan 2021 12:41:25 -0800
> >>>>> Ram Pai <linuxram@us.ibm.com> wrote:
> >>>>> =20
> >>>>>> On Tue, Jan 05, 2021 at 11:56:14AM +0100, Halil Pasic wrote: =20
> >>>>>>> On Mon, 4 Jan 2021 10:40:26 -0800
> >>>>>>> Ram Pai <linuxram@us.ibm.com> wrote: =20
> >>>>> =20
> >>>>>>>> The main difference between my proposal and the other proposal i=
s...
> >>>>>>>>
> >>>>>>>>   In my proposal the guest makes the compatibility decision and =
acts
> >>>>>>>>   accordingly.  In the other proposal QEMU makes the compatibili=
ty
> >>>>>>>>   decision and acts accordingly. I argue that QEMU cannot make a=
 good
> >>>>>>>>   compatibility decision, because it wont know in advance, if th=
e guest
> >>>>>>>>   will or will-not switch-to-secure.
> >>>>>>>>    =20
> >>>>>>>
> >>>>>>> You have a point there when you say that QEMU does not know in ad=
vance,
> >>>>>>> if the guest will or will-not switch-to-secure. I made that argum=
ent
> >>>>>>> regarding VIRTIO_F_ACCESS_PLATFORM (iommu_platform) myself. My id=
ea
> >>>>>>> was to flip that property on demand when the conversion occurs. D=
avid
> >>>>>>> explained to me that this is not possible for ppc, and that havin=
g the
> >>>>>>> "securable-guest-memory" property (or whatever the name will be)
> >>>>>>> specified is a strong indication, that the VM is intended to be u=
sed as
> >>>>>>> a secure VM (thus it is OK to hurt the case where the guest does =
not
> >>>>>>> try to transition). That argument applies here as well.   =20
> >>>>>>
> >>>>>> As suggested by Cornelia Huck, what if QEMU disabled the
> >>>>>> "securable-guest-memory" property if 'must-support-migrate' is ena=
bled?
> >>>>>> Offcourse; this has to be done with a big fat warning stating
> >>>>>> "secure-guest-memory" feature is disabled on the machine.
> >>>>>> Doing so, will continue to support guest that do not try to transi=
tion.
> >>>>>> Guest that try to transition will fail and terminate themselves. =
=20
> >>>>>
> >>>>> Just to recap the s390x situation:
> >>>>>
> >>>>> - We currently offer a cpu feature that indicates secure execution =
to
> >>>>>   be available to the guest if the host supports it.
> >>>>> - When we introduce the secure object, we still need to support
> >>>>>   previous configurations and continue to offer the cpu feature, ev=
en
> >>>>>   if the secure object is not specified.
> >>>>> - As migration is currently not supported for secured guests, we ad=
d a
> >>>>>   blocker once the guest actually transitions. That means that
> >>>>>   transition fails if --only-migratable was specified on the command
> >>>>>   line. (Guests not transitioning will obviously not notice anythin=
g.)
> >>>>> - With the secure object, we will already fail starting QEMU if
> >>>>>   --only-migratable was specified.
> >>>>>
> >>>>> My suggestion is now that we don't even offer the cpu feature if
> >>>>> --only-migratable has been specified. For a guest that does not wan=
t to
> >>>>> transition to secure mode, nothing changes; a guest that wants to
> >>>>> transition to secure mode will notice that the feature is not avail=
able
> >>>>> and fail appropriately (or ultimately, when the ultravisor call fai=
ls).
> >>>>> We'd still fail starting QEMU for the secure object + --only-migrat=
able
> >>>>> combination.
> >>>>>
> >>>>> Does that make sense? =20
> >>>>
> >>>> It's a little unusual; I don't think we have any other cases where
> >>>> --only-migratable changes the behaviour; I think it normally only st=
ops
> >>>> you doing something that would have made it unmigratable or causes
> >>>> an operation that would make it unmigratable to fail. =20
> >>>
> >>> I agree,  --only-migratable is supposed to be a *behavioural* toggle
> >>> for QEMU. It must /not/ have any impact on the guest ABI.
> >>>
> >>> A management application needs to be able to add/remove --only-migrat=
able
> >>> at will without changing the exposing guest ABI. =20
> >>
> >> At the qemu level, it sounds like the right thing to do is to fail
> >> outright if all of the below are true:
> >>  1. --only-migratable is specified
> >>  2. -cpu host is specified
> >>  3. unpack isn't explicitly disabled
> >>  4. the host CPU actually does have the unpack facility
> >>
> >> That can be changed if & when migration support is added for PV. =20
> >=20
> > That sounds right to me. =20
>=20
> as startup will fail anyway if the guest cpu model enables unpack, but th=
e host
> cpu does not support it this can be simplified to forbid startup in qemu =
if
> --only-migratable is combined with unpack being active in the guest cpu m=
odel.
>=20
> This is actually independent from this patch set.

Yep, I think we should just go ahead and fix this.

>  maybe just
> something like
>=20
> diff --git a/target/s390x/cpu_models.c b/target/s390x/cpu_models.c
> index 35179f9dc7ba..3b85ff4e31b2 100644
> --- a/target/s390x/cpu_models.c
> +++ b/target/s390x/cpu_models.c
> @@ -26,6 +26,7 @@
>  #include "qapi/qmp/qdict.h"
>  #ifndef CONFIG_USER_ONLY
>  #include "sysemu/arch_init.h"
> +#include "sysemu/sysemu.h"
>  #include "hw/pci/pci.h"
>  #endif
>  #include "qapi/qapi-commands-machine-target.h"
> @@ -878,6 +879,11 @@ static void check_compatibility(const S390CPUModel *=
max_model,
>          return;
>      }
> =20
> +    if (only_migratable && test_bit(S390_FEAT_UNPACK, model->features)) {
> +        error_setg(errp, "The unpack facility is not compatible with "
> +                  "the --only-migratable option");
> +    }
> +
>      /* detect the missing features to properly report them */
>      bitmap_andnot(missing, model->features, max_model->features, S390_FE=
AT_MAX);
>      if (bitmap_empty(missing, S390_FEAT_MAX)) {
>=20
>=20

Want to send this as a proper patch?

