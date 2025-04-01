Return-Path: <kvm+bounces-42395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0854DA781C1
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 19:56:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A910816D357
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 17:56:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB96D20DD72;
	Tue,  1 Apr 2025 17:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="snGltB86"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668012040A4
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 17:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743530198; cv=none; b=LQyNU9lAl4MKNHll5rU/zwwEMESS16F5cQky3me6pQsMQmDlnGVOfmrzZL0l3GbsHMbLoIaMtOowiv1k73A5Cw/Hspj8HhlyoJhsEHrfXxs+V3sSDJtVlnRqIjttBhMqyw2aRon39u88CFamH+bEUNisqKtxnD4LPx18XAKvINM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743530198; c=relaxed/simple;
	bh=JY/McJ0AfPTWrwEuCB0Y4tX5FQiivcdCF5ulAN/9/k0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bgVoVlu0U+ErfmIiQDzonLZKUa5bjy9QFgjYsXhv5EyyZ72Qh1Zn+VNxbt6SRqF8Ip8O8bgahlRJiItlbbls4NhvUUxgHLHN2H/mN3ouPU0vw1IwN70VqyBdcj7OfEurm+sBo4yjSwi07e+gRZq+tMkpsO2V7+r1vDgRc48/vRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=snGltB86; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff798e8c90so9622992a91.1
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 10:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743530196; x=1744134996; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qoqh5w7v6sEF/zJAyXyVye9BB0n7cEU53dS3BSwT4ds=;
        b=snGltB86sVlySJqfmWZX2jUih07kkvUDvyRj6i5mR7+u+LFxLzL67PycRsan6Y4IGE
         Od3Qmt+I00gdNB100T9LmSu15wIgDUo2n9lQ/8I/JdsbSwoX3aHc9aKbC1yLaskBrgok
         vJolC45lEEOFc/Rdt5bJYqD6BM966xNQONtjHBhEpWxO51SxJjxmHuXpj7nNQG1vl55B
         UNw0AXm5V52Fwio/wX56hZFDmH3mzCWx4Tyi2pllsOfUfDoRfXBZAHjaY+WK5rw6Dm0J
         n58VfGaXm/POONdXmAQWkHyTBsnXkN0CBotKfXotoaWOFJCiZtp81+PxWnoGA7JjcI1e
         g3Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743530196; x=1744134996;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Qoqh5w7v6sEF/zJAyXyVye9BB0n7cEU53dS3BSwT4ds=;
        b=kdsiEIDgBcY4moV0cED8IaWNYeFzyfJfXnoKd/05M0k8nnIaBMokQ/Hm+7MkXzpaYL
         Q3E7M2CbUiu/EaOBpWpMVMo4rXGonu+sJYBujKWR4WLFgy/9PmQoQVAShduGmLfLSXnz
         s3ndDLSEZ8X5UgRfCz3hbp+Uf5jDns/bHDTrhWxbsxtgMaqaTOqpNHspCcCKAjI23i6z
         fJ4qDDUuh/g8mRcST2Q4CWswW9Un/pHZ6PVnIYNRCDS2TlcVqgoELWGGDiOJ6kDE+Y6C
         4sZOv/5+DZsFMP7GK0pM8fYtDBkPlDc+QBocrsbtFp2LkMdLlfgBlViWQ83XrpQvmn9K
         KKOw==
X-Forwarded-Encrypted: i=1; AJvYcCVz+NC7EsNCeUe19TJu2smrEnkhD+SLhs6S7JDyG7g0QBt3DfnucVj7qahjDfn7NQlDHGU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaS/byikHqJe9kDyBCXtAepZX6Jpzh6eGCKMKKeJycIx52Ga0y
	+pIBjTLF/3qviRIJxnRfsjCYLYOiTXe/k27Pnw8vvHrT65sq1v8IrXXiIsmPnlGAXzmA0mMw6Pj
	iDw==
X-Google-Smtp-Source: AGHT+IH+MvNYmYhEz8ZKuhfDMkVTnE4dMnSFnMG49oA9TpYeZSiC5C72BuaWvZUrJMa4rmOOs2d7G4zOFVI=
X-Received: from pfbit9.prod.google.com ([2002:a05:6a00:4589:b0:736:5b36:db8f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:88c9:0:b0:732:5276:4ac9
 with SMTP id d2e1a72fcca58-7398037e929mr18764281b3a.9.1743530195575; Tue, 01
 Apr 2025 10:56:35 -0700 (PDT)
Date: Tue, 1 Apr 2025 10:56:34 -0700
In-Reply-To: <37b9903a-e8fc-4d57-a1ae-2bd2f26a9974@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318153316.1970147-1-chao.gao@intel.com> <20250318153316.1970147-2-chao.gao@intel.com>
 <37b9903a-e8fc-4d57-a1ae-2bd2f26a9974@intel.com>
Message-ID: <Z-wo0gUbWoJhQHBw@google.com>
Subject: Re: [PATCH v4 1/8] x86/fpu/xstate: Always preserve non-user
 xfeatures/flags in __state_perm
From: Sean Christopherson <seanjc@google.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, tglx@linutronix.de, dave.hansen@intel.com, 
	pbonzini@redhat.com, peterz@infradead.org, rick.p.edgecombe@intel.com, 
	weijiang.yang@intel.com, john.allen@amd.com, bp@alien8.de, xin3.li@intel.com, 
	Maxim Levitsky <mlevitsk@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Mitchell Levy <levymitchell0@gmail.com>, Samuel Holland <samuel.holland@sifive.com>, 
	Li RongQing <lirongqing@baidu.com>, Adamos Ttofari <attofari@amazon.de>, 
	Vignesh Balasubramanian <vigbalas@amd.com>, Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 01, 2025, Chang S. Bae wrote:
> On 3/18/2025 8:31 AM, Chao Gao wrote:
> >=20
> > When granting userspace or a KVM guest access to an xfeature, preserve =
the
> > entity's existing supervisor and software-defined permissions as tracke=
d
> > by __state_perm, i.e. use __state_perm to track *all* permissions even
> > though all supported supervisor xfeatures are granted to all FPUs and
> > FPU_GUEST_PERM_LOCKED disallows changing permissions.
> >=20
> > Effectively clobbering supervisor permissions results in inconsistent
> > behavior, as xstate_get_group_perm() will report supervisor features fo=
r
> > process that do NOT request access to dynamic user xfeatures, whereas a=
ny
> > and all supervisor features will be absent from the set of permissions =
for
> > any process that is granted access to one or more dynamic xfeatures (wh=
ich
> > right now means AMX).
> >=20
> > The inconsistency isn't problematic because fpu_xstate_prctl() already
> > strips out everything except user xfeatures:
> >=20
> >          case ARCH_GET_XCOMP_PERM:
> >                  /*
> >                   * Lockless snapshot as it can also change right after=
 the
> >                   * dropping the lock.
> >                   */
> >                  permitted =3D xstate_get_host_group_perm();
> >                  permitted &=3D XFEATURE_MASK_USER_SUPPORTED;
> >                  return put_user(permitted, uptr);
> >=20
> >          case ARCH_GET_XCOMP_GUEST_PERM:
> >                  permitted =3D xstate_get_guest_group_perm();
> >                  permitted &=3D XFEATURE_MASK_USER_SUPPORTED;
> >                  return put_user(permitted, uptr);
> >=20
> > and similarly KVM doesn't apply the __state_perm to supervisor states
> > (kvm_get_filtered_xcr0() incorporates xstate_get_guest_group_perm()):
> >=20
> >          case 0xd: {
> >                  u64 permitted_xcr0 =3D kvm_get_filtered_xcr0();
> >                  u64 permitted_xss =3D kvm_caps.supported_xss;
> >=20
> > But if KVM in particular were to ever change, dropping supervisor
> > permissions would result in subtle bugs in KVM's reporting of supported
> > CPUID settings.  And the above behavior also means that having supervis=
or
> > xfeatures in __state_perm is correctly handled by all users.
> >=20
> > Dropping supervisor permissions also creates another landmine for KVM. =
 If
> > more dynamic user xfeatures are ever added, requesting access to multip=
le
> > xfeatures in separate ARCH_REQ_XCOMP_GUEST_PERM calls will result in th=
e
> > second invocation of __xstate_request_perm() computing the wrong ksize,=
 as
> > as the mask passed to xstate_calculate_size() would not contain *any*
> > supervisor features.
> >=20
> > Commit 781c64bfcb73 ("x86/fpu/xstate: Handle supervisor states in XSTAT=
E
> > permissions") fudged around the size issue for userspace FPUs, but for
> > reasons unknown skipped guest FPUs.  Lack of a fix for KVM "works" only
> > because KVM doesn't yet support virtualizing features that have supervi=
sor
> > xfeatures, i.e. as of today, KVM guest FPUs will never need the relevan=
t
> > xfeatures.
> >=20
> > Simply extending the hack-a-fix for guests would temporarily solve the
> > ksize issue, but wouldn't address the inconsistency issue and would lea=
ve
> > another lurking pitfall for KVM.  KVM support for virtualizing CET will
> > likely add CET_KERNEL as a guest-only xfeature, i.e. CET_KERNEL will no=
t
> > be set in xfeatures_mask_supervisor() and would again be dropped when
> > granting access to dynamic xfeatures.
> >=20
> > Note, the existing clobbering behavior is rather subtle.  The @permitte=
d
> > parameter to __xstate_request_perm() comes from:
> >=20
> > 	permitted =3D xstate_get_group_perm(guest);
> >=20
> > which is either fpu->guest_perm.__state_perm or fpu->perm.__state_perm,
> > where __state_perm is initialized to:
> >=20
> >          fpu->perm.__state_perm          =3D fpu_kernel_cfg.default_fea=
tures;
> >=20
> > and copied to the guest side of things:
> >=20
> > 	/* Same defaults for guests */
> > 	fpu->guest_perm =3D fpu->perm;
> >=20
> > fpu_kernel_cfg.default_features contains everything except the dynamic
> > xfeatures, i.e. everything except XFEATURE_MASK_XTILE_DATA:
> >=20
> >          fpu_kernel_cfg.default_features =3D fpu_kernel_cfg.max_feature=
s;
> >          fpu_kernel_cfg.default_features &=3D ~XFEATURE_MASK_USER_DYNAM=
IC;
> >=20
> > When __xstate_request_perm() restricts the local "mask" variable to
> > compute the user state size:
> >=20
> > 	mask &=3D XFEATURE_MASK_USER_SUPPORTED;
> > 	usize =3D xstate_calculate_size(mask, false);
> >=20
> > it subtly overwrites the target __state_perm with "mask" containing onl=
y
> > user xfeatures:
> >=20
> > 	perm =3D guest ? &fpu->guest_perm : &fpu->perm;
> > 	/* Pairs with the READ_ONCE() in xstate_get_group_perm() */
> > 	WRITE_ONCE(perm->__state_perm, mask);
>=20
> This changelog appears to be largely derived from Sean=E2=80=99s previous=
 email.

FWIW, I wrote the changelog.  I'm sure I derived many of the details from m=
y
original mail, but I would rather not redirect future readers to lore to fu=
lly
understand the change.

https://lore.kernel.org/all/20231103224402.347278-1-seanjc@google.com

> I think it can be significantly shortened to focus on the key points, suc=
h
> as:

I strongly prefer the extremely verbose version.  I wrote the code, and in =
all
honesty, the below short version doesn't help me understand the full scope =
of
the change (I have long since paged out the context).  From a KVM perspecti=
ve,
capturing why this flaw isn't problematic (yet!) is just as important as fi=
xing
the issue.

> x86/fpu/xstate: Preserve non-user bits in permission handling
>=20
> When granting userspace or a KVM guest access to an xfeature, the task
> leader=E2=80=99s perm->__state_perm (host or guest) is overwritten, unint=
entionally
> discarding non-user bits. Additionally, supervisor state permissions are
> always granted.
>=20
> The current behavior presents the following issues:
>=20
>  *  Inconsistencies in permission handling =E2=80=93 Supervisor permissio=
ns are
>     universally granted, and the FPU_GUEST_PERM_LOCKED bit is explicitly
>     set to prevent permission changes.
>=20
>  *  Redundant permission setting =E2=80=93 Since supervisor state permiss=
ions
>     are always granted, the permitted mask already includes them, making
>     it unnecessary to set them again.
>=20
> Ensure that __xstate_request_perm() does not inadvertently drop
> supervisor and software-defined permissions. Also, avoid redundantly
> granting supervisor state permissions, and document this behavior in the
> code comments.
>=20
> Clarify the presence of non-user feature and flag bits in the field
> description.
>=20

