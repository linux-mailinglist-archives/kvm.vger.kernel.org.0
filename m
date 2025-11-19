Return-Path: <kvm+bounces-63634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B16BC6C187
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 01:07:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 67FA32BEAE
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 00:07:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F02FF200C2;
	Wed, 19 Nov 2025 00:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g76JaYDJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E5F1CFBA
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 00:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763510839; cv=none; b=CQpMXkdXlimbRKjcDRklaD5sUrpS2ILdAoxm3FVYEKXY5fbP+A5vxyrpbwKgMOKgWZir7QTY0557vDYewH02tQYNbEscaFveNO1midZqlHdaanmWP9bkflhzInGCG3NQNLdACHIyxslQmOTQ3W1yt9WJthY2AbtmUNUtvUbrO2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763510839; c=relaxed/simple;
	bh=lQMYt2P3T+GKPSK1Ld6EOk0j8Fk/mirQ4F+8wJyIlq8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cK1gPHH0Q1jIs451C3Ib1mc6AAhgs04dhXhD3IKO0JO8zqEpdD850+L3As2DIy/vA6IGAmKYj7lCBFcmu9lhxlPhlY1YghV6z4Gsz5o6LubEziaznbKVfJIxKbg90W815pJLJ9fTVcf4WNJ8gGdzCp62YP+wyPsjMKdn07cCChg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g76JaYDJ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-341616a6fb7so7506032a91.0
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 16:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763510836; x=1764115636; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FNvrUld3T4yzjssA7VkjPDUOxJWjO6mLj3SJ9eonnyA=;
        b=g76JaYDJzKZVrbifiGgJ6pImz0yvK2KWDaTO3lVKgEuzywk98DZYtFhaQzpM1Nk7uM
         st+6LTW4G8lNapTq/rvgVfkVDXBzU0/MWPreNwFGKPrRMiqwodSKFqi8UPWeOpt6dw0e
         e+umas4rF8EgNLO2jzd40D3VS5d+YYUrDDFL+o3uaXtlWYR8HQtuXwJdlG6d1YZ3THVS
         ylwt1pjjmeeT7W1dRjso59sL7UYWR7FYy53WYxVoNUEBWxR7MLT8LqwSGPNAqPiTOuwu
         kjqVU9fcmzJsgvAJ0D+qJNQrnYvYLzIEsRixpL6q7/baNYftB/yZ44vje9BaiuE2dE3g
         sang==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763510836; x=1764115636;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FNvrUld3T4yzjssA7VkjPDUOxJWjO6mLj3SJ9eonnyA=;
        b=SqSPlnoUy++yQzBhMOhgiYRDwwEVVLxTHvMYzcpvrlR9jbuCPGPRQ1hvGE4Ewxcqni
         YK7550Th1w1vrV/wAwrzWEl5NiiXMU1cqrp9mJYwA0h6cX9XNCIZ1hzPDoMGp3+KRhxR
         MZo8eg46Wi8Z0nLOttbyh9h5eCksS0O+lHO88JdT4vbmkR/B+89srw6TF71OJY4Y2IOR
         Frwcp/5oBir1b/bpN9JH9z/kpp5j1c1JmwLytdHDG2oGDwlcPfCaAZL/8dYZeMVHqXRB
         7KAQrF4nxCHIrC2GPNflcGN1cMFXMeLgwLpJlO73CQ+Fewo+yIzRTwpCP4+sXDQBXJS8
         Hd+g==
X-Forwarded-Encrypted: i=1; AJvYcCUUOXrRKnBFrY+fDHELqW08DJpQ89b30PcxwcaGzDrvhpFOceobP4rsy5RWiOz2g0gMWOU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUn7KeF18AZLp2bPowfI+74s7CVMJDrIGdQWOvp/r5jqQakEVa
	9vRsIViS24k7nwzuQUW7PkVRQe2T0YsvLHcP1wO48vHLNYI0HJRKOakUa2B0vJB4+Y/g8YPt4hE
	COlO7Tw==
X-Google-Smtp-Source: AGHT+IGBhKmQ5VYgF2pg90+OiWeBm8qSimQGl/xWRiXJ3AQzUbKI9UkKdeezSi3S4CmaurJS5lv+NCM++Fk=
X-Received: from pjbee11.prod.google.com ([2002:a17:90a:fc4b:b0:33b:bb95:de6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c06:b0:32e:64ca:e84e
 with SMTP id 98e67ed59e1d1-343f9ea0b0dmr19879393a91.15.1763510835966; Tue, 18
 Nov 2025 16:07:15 -0800 (PST)
Date: Tue, 18 Nov 2025 16:07:14 -0800
In-Reply-To: <vh3yjo36ortltqjrcsegllzbpkmum2c5ywna25q3ah25txlv74@4edzsqjjs73c>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
 <n5cjwr3klovu7tqcchptvmr6yieyhvnv5muv7zyvcbo5itskew@6rzo4ohctdhv>
 <CALMp9eQuWx--Ef7Sxasq=MZMGPTg2ZUL0CXHH+Hvj7YEL_ipVg@mail.gmail.com>
 <gcyh7dlszzaj3wnp3fu3x6loedfhzds55kxvubxm53deb4yodm@3xk4mt32nf3j>
 <aR0GI81ZASDYeFP_@google.com> <vh3yjo36ortltqjrcsegllzbpkmum2c5ywna25q3ah25txlv74@4edzsqjjs73c>
Message-ID: <aR0KMgdyQoXfU4V6@google.com>
Subject: Re: [PATCH v2 00/23] Extend test coverage for nested SVM
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 19, 2025, Yosry Ahmed wrote:
> On Tue, Nov 18, 2025 at 03:49:55PM -0800, Sean Christopherson wrote:
> > On Tue, Nov 18, 2025, Yosry Ahmed wrote:
> > > On Tue, Nov 18, 2025 at 03:00:26PM -0800, Jim Mattson wrote:
> > > > On Tue, Nov 18, 2025 at 2:26=E2=80=AFPM Yosry Ahmed <yosry.ahmed@li=
nux.dev> wrote:
> > > > >
> > > > > On Tue, Oct 21, 2025 at 07:47:13AM +0000, Yosry Ahmed wrote:
> > > > > > There are multiple selftests exercising nested VMX that are not=
 specific
> > > > > > to VMX (at least not anymore). Extend their coverage to nested =
SVM.
> > > > > >
> > > > > > This version is significantly different (and longer) than v1 [1=
], mainly
> > > > > > due to the change of direction to reuse __virt_pg_map() for nes=
ted EPT/NPT
> > > > > > mappings instead of extending the existing nested EPT infrastru=
cture. It
> > > > > > also has a lot more fixups and cleanups.
> > > > > >
> > > > > > This series depends on two other series:
> > > > > > - "KVM: SVM: GIF and EFER.SVME are independent" [2]
> > > > > > - "KVM: selftests: Add test of SET_NESTED_STATE with 48-bit L2 =
on 57-bit L1" [3]
> > > > >
> > > > > v2 of Jim's series switches all tests to use 57-bit by default wh=
en
> > > > > available:
> > > > > https://lore.kernel.org/kvm/20251028225827.2269128-4-jmattson@goo=
gle.com/
> > > > >
> > > > > This breaks moving nested EPT mappings to use __virt_pg_map() bec=
ause
> > > > > nested EPTs are hardcoded to use 4-level paging, while __virt_pg_=
map()
> > > > > will assume we're using 5-level paging.
> > > > >
> > > > > Patch #16 ("KVM: selftests: Use __virt_pg_map() for nested EPTs")=
 will
> > > > > need the following diff to make nested EPTs use the same paging l=
evel as
> > > > > the guest:
> > > > >
> > > > > diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools=
/testing/selftests/kvm/lib/x86_64/vmx.c
> > > > > index 358143bf8dd0d..8bacb74c00053 100644
> > > > > --- a/tools/testing/selftests/kvm/lib/x86/vmx.c
> > > > > +++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
> > > > > @@ -203,7 +203,7 @@ static inline void init_vmcs_control_fields(s=
truct vmx_pages *vmx)
> > > > >                 uint64_t ept_paddr;
> > > > >                 struct eptPageTablePointer eptp =3D {
> > > > >                         .memory_type =3D X86_MEMTYPE_WB,
> > > > > -                       .page_walk_length =3D 3, /* + 1 */
> > > > > +                       .page_walk_length =3D get_cr4() & X86_CR4=
_LA57 ? 4 : 3, /* + 1 */
> > > >=20
> > > > LA57 does not imply support for 5-level EPT. (SRF, IIRC)
> >=20
> > Yuuuup.  And similarly, MAXPHYADDR=3D52 doesn't imply 5-level EPT (than=
k you TDX!).
> >=20
> > > Huh, that's annoying. We can keep the EPTs hardcoded to 4 levels and
> > > pass in the max level to __virt_pg_map() instead of hardcoding
> > > vm->pgtable_levels.
> >=20
> > I haven't looked at the series in-depth so I don't know exactly what yo=
u're trying
> > to do, but why not check MSR_IA32_VMX_EPT_VPID_CAP for PWL5?
>=20
> The second part of the series reuses __virt_pg_map() to be used for
> nested EPTs (and NPTs). __virt_pg_map() uses vm->pgtable_levels to find
> out how many page table levels we have.
>=20
> So we need to either:
>=20
> (a) Always use the same number of levels for page tables and EPTs.
>=20
> (b) Make __virt_pg_map() take the number of page table levels as a
>   parameter, and always pass 4 for EPTs (for now).
>=20
> I suggested (a) initially, but it doesn't work because we can
> technically have LA57 but not MSR_IA32_VMX_EPT_VPID_CAP, so we need to
> do (b). We can still check MSR_IA32_VMX_EPT_VPID_CAP and use PWL5 for
> EPTs, but that's an orthogonal change at this point.
>=20
> Anyway, do you prefer that I resend the series on top of Jim's v2, or do
> you want to wait and see if you'll fix it up (or apply a part of it
> before I rebase the rest)?

Hold off for now, sending v3 of a 23-patch series at this point isn't likel=
y to
make things go faster :-)

