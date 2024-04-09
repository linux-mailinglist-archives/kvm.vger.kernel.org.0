Return-Path: <kvm+bounces-13943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BCBA89CFC1
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 03:21:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9EF051C23BE3
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 01:21:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D9198BF9;
	Tue,  9 Apr 2024 01:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1AgBQzVh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B6963B9
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 01:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712625684; cv=none; b=Vz4VlE3ppfUIqv7co6XsziKrTTGaosZm/xG43GpwP/l12XEbi/KP2xzqqmGicviqNzL/+lT8N6/HZZps65Kx2LRFqp6WVEg16x26wRKKYZaMc9iHsr/D/gRHFtyGBQmfjyYn3TUWY2VtpUaTNnDM27njqeIFcpbIGE+zWuNh7J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712625684; c=relaxed/simple;
	bh=HLb3lzTl8sakQLxebX64cAFyuxzRJONTupHQAaLnEhc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jxwHedvfVIpXFKuvVIir42U4sIkKcls5txP+5BJsLR6118nJFv/SuybQpEbvpUFb7rWRXCn8Pv6f+s5P6pjBgCIfDw8+3uCtF9z7kJUlmixryvXDl2fd8lhMxMCsvF0+gmnvI0Tr15xcG0wozUGf7b9XuluyhnF7KRBfzTYITNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1AgBQzVh; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1e2bbb6049eso24470475ad.0
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 18:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712625682; x=1713230482; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DOboyqOmohbafhdvLzQ0D4l7iWv9fFGfP8r0CMbFChY=;
        b=1AgBQzVhdwOsycJqWH10ruQ8m+NPcKnwIhrIs+Mot4gZWtocWpoLfB8HG+xJafjjVR
         PnVBbC1hdmOS9O/u/zRH80j6//K+88t1kA7KqqGFKok71QjwPqf2kHUMEJpLycmt8jjV
         Qvi80XPG5aNyFE8l9tsNfYIdryOS8CB3zQTANJz99uM5zJVd9+hCDb+a7ku0yR58sytf
         Dmcs0nDTrq6b/Grt69a3Xp4VmMT3w5L2eHza6YAu2kf4gAQDemJyIAaqalF++eZdShn7
         jLQS5YKCju5mPR5Y4qdx1WVpUkRbTp1oG7nPdaH3DICKP/UONBTIVSs2Wv64/tjTKZPX
         zlDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712625682; x=1713230482;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DOboyqOmohbafhdvLzQ0D4l7iWv9fFGfP8r0CMbFChY=;
        b=iRGn+zwKXAm1eMwt0a/uQINYHjwd4y5w0vDFeiBc+asyB3aSJhXQ2XXq6Db1/pgcDK
         fabArRNKXXaxXGi9C1LgAR8tgVCMq406s8SbMAlckvVHhqE9O2DBp2r37yPwHr9Cyy4I
         4rKhuMTh7oUOM+B4u5vYgAG4h7muULsPQJAO13gkzec27z0rsRcR2o0ZpCHkzpmyXA+h
         e0oP2P5mW5AswAVneh4J6daPH8Go6GcUHYheLlhoTvxJ0SxFAbFaT2xtU5uZy+/xJ1fc
         62E301kOnIaSlrTnzAhnLbAp1xZTRketoAQzDmOYjZU7T88Df1ATGo1e1oeu4kR92nMj
         oYuA==
X-Gm-Message-State: AOJu0Yym6i9tmAppook4J3H4zvTfWUlQRetvZ8pPm3LQyhY6YIneULA3
	naN0CiTzpQuB+pEiJ4pCuLgKCc8SGb85fb3PG83CMtQllAmtBBio/p8hdHeK4mzZTmploB6gmjj
	dag==
X-Google-Smtp-Source: AGHT+IHqFrHMa7zvZVYCVZteRx1klk5aQx2fqWK/tBoc1XrugycZfp9s9t1gg8Ky3mKSw7Fs1naZwSgjsK4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:da83:b0:1e3:c934:61d1 with SMTP id
 j3-20020a170902da8300b001e3c93461d1mr59865plx.10.1712625682465; Mon, 08 Apr
 2024 18:21:22 -0700 (PDT)
Date: Mon, 8 Apr 2024 18:21:21 -0700
In-Reply-To: <43d1ade0461868016165e964e2bc97f280aee9d4.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240404121327.3107131-1-pbonzini@redhat.com> <20240404121327.3107131-8-pbonzini@redhat.com>
 <43d1ade0461868016165e964e2bc97f280aee9d4.camel@intel.com>
Message-ID: <ZhSYEVCHqSOpVKMh@google.com>
Subject: Re: [PATCH v5 07/17] KVM: x86: add fields to struct kvm_arch for CoCo features
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 05, 2024, Rick P Edgecombe wrote:
> On Thu, 2024-04-04 at 08:13 -0400, Paolo Bonzini wrote:
> > =C2=A0
> > =C2=A0struct kvm_arch {
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned long vm_type;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned long n_used_mm=
u_pages;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned long n_request=
ed_mmu_pages;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned long n_max_mmu=
_pages;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned int indirect_s=
hadow_pages;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u8 mmu_valid_gen;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u8 vm_type;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bool has_private_mem;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bool has_protected_state;
>=20
> I'm a little late to this conversation, so hopefully not just complicatin=
g
> things. But why not deduce has_private_mem and has_protected_state from t=
he
> vm_type during runtime? Like if kvm.arch.vm_type was instead a bit mask w=
ith
> the bit position of the KVM_X86_*_VM set, kvm_arch_has_private_mem() coul=
d
> bitwise-and with a compile time mask of vm_types that have primate memory=
.
> This also prevents it from ever transitioning through non-nonsensical sta=
tes
> like vm_type =3D=3D KVM_X86_TDX_VM, but !has_private_memory, so would be =
a little
> more robust.

LOL, time is a circle, or something like that.  Paolo actually did this in =
v2[*],
and I objected, vociferously.

KVM advertises VM types to userspace via a 32-bit field, one bit per type. =
 So
without more uAPI changes, the VM type needs to be <=3D31.  KVM could embed=
 the
"has private memory" information into the type, but then we cut down on the=
 number
of possible VM types *and* bleed has_private_memory into KVM's ABI.

While it's unlikely KVM will ever support TDX without has_private_memory, i=
t's
entirely possible that KVM could add support for an existing VM "base" type=
 that
doesn't currently support private memory.  E.g. with some massaging, KVM co=
uld
support private memory for SEV and SEV-ES.  And then we need to add an enti=
rely
new VM type just so that KVM can let it use private memory.

Obviously KVM could shove in bits after the fact, e.g. store vm_type as a u=
64
instead of u32 (or u8 as in this patch), but then what's the point?  Burnin=
g a
byte instead of a bit for per-VM flag is a complete non-issue, and booleans=
 tend
to yield code that's easier to read and easier to maintain.

[*] https://lore.kernel.org/all/ZdjL783FazB6V6Cy@google.com

> Partly why I ask is there is logic in the x86 MMU TDX changes that tries =
to
> be generic but still needs special handling for it. The current solution =
is
> to look at kvm_gfn_shared_mask() as TDX is the only vm type that sets it,=
 but
> Isaku and I were discussing if we should check something else, that didn'=
t
> appear to be tying together to unrelated concepts:
> https://lore.kernel.org/kvm/20240319235654.GC1994522@ls.amr.corp.intel.co=
m/
>=20
> Since it's down the mail, the relevant snippet:
> "
> > >  void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
> > >                                    struct kvm_memory_slot *slot)
> > >  {
> > > -       kvm_mmu_zap_all_fast(kvm);
> > > +       if (kvm_gfn_shared_mask(kvm))

Whatever you do that is TDX specific and an internal KVM thing is likely th=
e wrong
thing :-)

The main reason KVM doesn't do a targeted zap on memslot removal is because=
 of ABI
baggage that we _think_ is limited to interaction with VFIO.  Since KVM doe=
sn't
have any ABI for TDX *or* SNP, I want to at least entertain the option of d=
oing
a target zap for SNP as well as TDX, even though it's only truly "necessary=
" for
TDX, in quotes because it's not strictly necessary, e.g. KVM could BLOCK th=
e S-EPT
entries without fully removing the mappings.

Whether or not targeted zapping is optimal for SNP (or any VM type) is very=
 much
TBD, and likely highly dependent on use case, but at the same time it would=
 be
nice to not rule it out completely.

E.g. ChromeOS currently has a use case where they frequently delete and rec=
reate
a 2GiB (give or take) memslot.  For that use case, zapping _just_ that mems=
lot is
likely far superious than blasting and rebuilding the entire VM.  But if us=
erspace
deletes a 1TiB for some reason, e.g. for memory unplug?, then the fast zap =
is
probably better, even though it requires rebuilding all SPTEs.

> > There seems to be an attempt to abstract away the existence of Secure-
> > EPT in mmu.c, that is not fully successful. In this case the code
> > checks kvm_gfn_shared_mask() to see if it needs to handle the zapping
> > in a way specific needed by S-EPT. It ends up being a little confusing
> > because the actual check is about whether there is a shared bit. It
> > only works because only S-EPT is the only thing that has a
> > kvm_gfn_shared_mask().
> >=20
> > Doing something like (kvm->arch.vm_type =3D=3D KVM_X86_TDX_VM) looks wr=
ong,
> > but is more honest about what we are getting up to here. I'm not sure
> > though, what do you think?
>=20
> Right, I attempted and failed in zapping case.  This is due to the restri=
ction
> that the Secure-EPT pages must be removed from the leaves.  the VMX case =
(also
> NPT, even SNP) heavily depends on zapping root entry as optimization.

As above, it's more nuanced than that.  KVM has come to depend on the fast =
zap,
but it got that way *because* KVM has historical zapped everything, and use=
rspace
has (unknowingly) relied on that behavior.

> I can think of
> - add TDX check. Looks wrong
> - Use kvm_gfn_shared_mask(kvm). confusing

Ya, even if we end up making it a hardcoded TDX thing, dress it up a bit.  =
E.g.
even if KVM checks for a shared mask under the hood, add a helper to captur=
e the
logic, e.g. kvm_zap_all_sptes_on_memslot_deletion(kvm).

> - Give other name for this check like zap_from_leafs (or better name?)
>   The implementation is same to kvm_gfn_shared_mask() with comment.
>   - Or we can add a boolean variable to struct kvm

If we _don't_ hardcode the behavior, a per-memslot flag or a per-VM capabil=
ity
(and thus boolean) is likely the way to go.  My off-the-cuff vote is probab=
ly for
a per-memslot flag.

