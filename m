Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B020910EFA8
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 19:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbfLBS7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 13:59:41 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55522 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727960AbfLBS7l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Dec 2019 13:59:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575313179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xHVdnribHROCprX42oK+sO39UEOdlO/Er0CYVvgYuxY=;
        b=RyxdHTKCRtWEGifukA5cnV6ewCgzcq0av8tNG3I/RICpLqzxbsZ7m1Thl1etmlT2Tv9Cli
        P8BRdX9/E1+WUvRd83gehrcsAw6WVjz8cCvBMMIj7gn6wNbQxQMBtBYpCI8mqVgcwGpBdw
        c5NoUWTtMaXKQpzZVojzCM4PjSvfc0w=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-WSmxqOpaOy-dv6O-5dtCUw-1; Mon, 02 Dec 2019 13:59:38 -0500
Received: by mail-qv1-f70.google.com with SMTP id r8so393533qvp.3
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2019 10:59:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Y0FYmPwzu9gexxX3miu/BQ5UsoJK0QS2CjNZdYYEyUw=;
        b=ce3euyKI/0AKLY8ZS+FucGYGG6lIwXDZ2xslLcDkFqoHa9ROgg16/tinD+CGo3eCwD
         34UAE3P6lSANnwhFhiQSyqbDSMn68vnaShloowPcxWYAJY3ajDe6Y0Mp54rwcXdgplHn
         B4pYsA2gJbvSRKQ8D/5/0Y+s1YUSKPKN3TrHE2ELBOcccjTGmZG1QY4yzzSzeD8H7N+I
         rFDbpgvHIE8i1tU1xTV96SujIUGy0lH6ztTTq/5daP1nDGtg2LMplrlC7OuyWSFSp82T
         1EHUKxVSEBR1v4l0egorP5LHlkcy1E4npi6pQPAk2YAnbA8mQJP/RU8P9L8SeBAlulkW
         MKPw==
X-Gm-Message-State: APjAAAV18zE1hCdbJNMeDMzRw/wtd6iFAK2JE9zIFqZB21C9l2CrcC9E
        F9UQKk2hA/b3cxyu848hs6DBCuOnGTOc72nbDXp3QQqcv9fY4FjLtPy1SQagsY82k8MBIg7WKNu
        Nk1FKIEI3wUWz
X-Received: by 2002:aed:204d:: with SMTP id 71mr969422qta.116.1575313177975;
        Mon, 02 Dec 2019 10:59:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqyl7pBr23YluBRFDZ4/fKPJnD9cok9J0wZ1rQBLGCQW7UnnKuNfyyZ6uiORP4ugO5LfhiICFw==
X-Received: by 2002:aed:204d:: with SMTP id 71mr969400qta.116.1575313177628;
        Mon, 02 Dec 2019 10:59:37 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id o2sm248207qkf.68.2019.12.02.10.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 10:59:36 -0800 (PST)
Date:   Mon, 2 Dec 2019 13:59:35 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 3/3] KVM: X86: Fixup kvm_apic_match_dest() dest_mode
 parameter
Message-ID: <20191202185935.GB10882@xz-x1>
References: <20191129163234.18902-1-peterx@redhat.com>
 <20191129163234.18902-4-peterx@redhat.com>
 <87mucbcchj.fsf@vitty.brq.redhat.com>
 <20191202173152.GB4063@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <20191202173152.GB4063@linux.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-MC-Unique: WSmxqOpaOy-dv6O-5dtCUw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 02, 2019 at 09:31:52AM -0800, Sean Christopherson wrote:
> On Mon, Dec 02, 2019 at 10:18:00AM +0100, Vitaly Kuznetsov wrote:
> > Peter Xu <peterx@redhat.com> writes:
> >=20
> > > The problem is the same as the previous patch on that we've got too
> > > many ways to define a dest_mode, but logically we should only pass in
> > > APIC_DEST_* macros for this helper.
> >=20
> > Using 'the previous patch' in changelog is OK until it comes to
> > backporting as the order can change. I'd suggest to spell out "KVM: X86=
:
> > Use APIC_DEST_* macros properly" explicitly.
>=20
> Even that is bad practice IMO.  Unless there is an explicit dependency on
> a previous patch, which does not seem to be the case here, the changelog
> should fully describe and justify the patch without referencing a previou=
s
> patch/commit.
>=20
> Case in point, I haven't looked at the previous patch yet and have no ide=
a
> why *this* patch is needed or what it's trying to accomplish.

I'll improve both commit messages.

>=20
> > >
> > > To make it easier, simply define dest_mode of kvm_apic_match_dest() t=
o
> > > be a boolean to make it right while we can avoid to touch the callers=
.
> > >
> > > Signed-off-by: Peter Xu <peterx@redhat.com>
> > > ---
> > >  arch/x86/kvm/lapic.c | 5 +++--
> > >  arch/x86/kvm/lapic.h | 2 +-
> > >  2 files changed, 4 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > index cf9177b4a07f..80732892c709 100644
> > > --- a/arch/x86/kvm/lapic.c
> > > +++ b/arch/x86/kvm/lapic.c
> > > @@ -791,8 +791,9 @@ static u32 kvm_apic_mda(struct kvm_vcpu *vcpu, un=
signed int dest_id,
> > >  =09return dest_id;
> > >  }
> > > =20
> > > +/* Set dest_mode to true for logical mode, false for physical mode *=
/
> > >  bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *so=
urce,
> > > -=09=09=09   int short_hand, unsigned int dest, int dest_mode)
> > > +=09=09=09   int short_hand, unsigned int dest, bool dest_mode)
> > >  {
> > >  =09struct kvm_lapic *target =3D vcpu->arch.apic;
> > >  =09u32 mda =3D kvm_apic_mda(vcpu, dest, source, target);
> > > @@ -800,7 +801,7 @@ bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, s=
truct kvm_lapic *source,
> > >  =09ASSERT(target);
> > >  =09switch (short_hand) {
> > >  =09case APIC_DEST_NOSHORT:
> > > -=09=09if (dest_mode =3D=3D APIC_DEST_PHYSICAL)
> > > +=09=09if (dest_mode =3D=3D false)
> >=20
> > I must admit this seriously harm the readability of the code for
> > me. Just look at the=20
> >=20
> >  if (dest_mode =3D=3D false)
> >=20
> > line without a context and try to say what's being checked. I can't.
> >=20
> > I see to solutions:
> > 1) Adhere to the APIC_DEST_PHYSICAL/APIC_DEST_LOGICAL (basically - just
> > check against "dest_mode =3D=3D APIC_DEST_LOGICAL" in the else branch)
> > 2) Rename the dest_mode parameter to 'dest_mode_is_phys' or something
> > like that.
>=20
> For #2, it should be "logical" instead of "phys" as APIC_DEST_PHYSICAL is
> the zero value.
>=20
> There's also a third option:
>=20
>   3) Add a WARN_ON_ONCE and fix the IO APIC callers, e.g.:
>=20
> =09WARN_ON_ONCE(dest_mode !=3D APIC_DEST_PHYSICAL ||
> =09=09     dest_mode !=3D APIC_DEST_LOGICAL);
>=20
> =09if (dest_mode =3D=3D APIC_DEST_PHYSICAL)
> =09=09return kvm_apic_match_physical_addr(target, mda);
> =09else
> =09=09return kvm_apic_match_logical_addr(target, mda);
>=20
> Part of me likes the simplicity of #2, but on the other hand I don't like
> the inconsistency with respect to @short_hand and @dest, which take in
> "full" values.  E.g. @short_hand would also be problematic for a caller
> that uses a bitfield.

IMHO the best way is that we should always use a boolean for dest mode
internally because it's always a true or false flag, and we only
convert it to other forms when needed (e.g. when applying that bit to
an IOAPIC entry).  But here I think I'll go with the 3rd option to
avoid code churns (I think it's also what Vitaly suggested as the 1st
option).

>=20
> Side topic, the I/O APIC callers should explicitly pass APIC_DEST_NOSHORT
> instead of 0.

I'll fix that too.

(I also missed suggested-by/reported-by for Vitaly)

Thank you both for your reviews,

--=20
Peter Xu

