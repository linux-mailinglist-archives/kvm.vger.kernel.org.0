Return-Path: <kvm+bounces-11934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B75C87D456
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 20:06:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B23D5B244B4
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 19:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C90A50A98;
	Fri, 15 Mar 2024 19:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PYwjmUOy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61C04EB22
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 19:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710529571; cv=none; b=aLnrKq9BgFDYcCumytNvuJU/CmKMViafF40eAdrra5bYdpQQ60eNsNzv2Xioj8mmfFLqJy0fh/VQmRuM5ThGVhyjb3n0JC9FAJLzjaiQ7pB5mtvtHVTxhhc9K9zWs0FgpFN6BlKZggjaQwMYilbfi+tGLjMGJL1XUnxrJvp7+RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710529571; c=relaxed/simple;
	bh=c93ef35sRshYiC2AATmcCqw9XtaXh937E9AR1Bv4Ue4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k1syKroS2yhDysRFDNof0zeGKZwatQ2dBGqwjKgF/ogxRkc9vRFD2wVN1UcHEMuJpWX9VpLCuzxTO2VzY91K8rojOTcy1uyjtiufke/EvlxsHqvig9EPOAuOPCfS4R2zTebT1ESNtlGDpsUoGIrEylPvaVeH1R5tRReZ5cxItAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PYwjmUOy; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5cdfd47de98so2073377a12.1
        for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 12:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710529567; x=1711134367; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WxcfU/8IwLCHkk68SMZvcwY7f//etTaSB7/1VZllKVU=;
        b=PYwjmUOyHSpGEbq7TB5uDIomPhC67T1taiz8iVt7DnaAKz/wfacvOx5h3pyh9+GGx4
         uafqexKIiEVLfq5WJksUiFDghTsFzJ0UijwbNDaewR66NtnHDZ6EVBWJWPSHhJEhzD2E
         OHxN9Gs98TtKzrt8T274mfu5kb0gegYaEx9ELYgrXFNdu2I9003uut8Ck4kWSOODeIOO
         r2PzNviUR/vQ4qgnIFqXOvncgdzykSFn85Udws7zJfmYVqb4S+ap8yOYVCwKA39BmrLC
         wv7dCEmcRtgYxAaI32SOrEuldsT+8SOGwrdnNWan6ztj8hWl+kvWqdm2ME1UV+OYjVaW
         9stg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710529567; x=1711134367;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WxcfU/8IwLCHkk68SMZvcwY7f//etTaSB7/1VZllKVU=;
        b=GrvrnAKS35wqY/hUjesFWWFYoqy91oi6Ffc+vBun3wysDJsEqEVTVtuHfWi+lfu9SB
         MryJJUqezKPjOF+sqkGV4mhT6zYGxqjMZC7eSGIYYzD1uSDEOkAbL7vGXUNWYrUiCMpv
         4LvOHKGpuIp2twPOrmacNt7ZdLjqUryjewGo68aEURdyHI+bZGVn0XgZO1zcWSTxevnX
         /m1HSnZO6Qz4Vjwaof8E2qpPph/mjcQNn79shg+2WhFrAsobGDDG8ryrIt7QoutWSDWa
         G/Kcu6hHU6bTZPw7tlqFgzOYtgFF4Y9mv3vLHE75i8Ife3nrT8uV/iyCCFzHWyTDOhrp
         fpfg==
X-Forwarded-Encrypted: i=1; AJvYcCU3vaX0KMNkIsHJ+7cheHAi2I74eTdVLZ00JPV5pAhAZYpsNVcXqUQEdf5UfLCPK4qRIonkG+AyM34PWOwCxFCg+yq3
X-Gm-Message-State: AOJu0YxvQFh11WEgMy4+YAzWlBo11eqDefxW3A2og22ozCZi1RL2VvQa
	421xJbJXZLyGBVuDkQxcg/96VHPznwmmltZWN/6/MolHT3WySYsCGI16ETxjvpWPl/VubvJTXv0
	pZA==
X-Google-Smtp-Source: AGHT+IHC9H6HmVEZ9R3YvdGB88rcppNGxPLVqEAHI5Osd5hvODzSOEigb8O/uxQXqUmWxJ4aOH1WTmCcxrI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:dc08:0:b0:5cf:c149:8dc with SMTP id
 s8-20020a63dc08000000b005cfc14908dcmr13261pgg.11.1710529567041; Fri, 15 Mar
 2024 12:06:07 -0700 (PDT)
Date: Fri, 15 Mar 2024 12:06:05 -0700
In-Reply-To: <ZfSTh4bLuAMlF6Er@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <000000000000c6526f06137f18cc@google.com> <CALzav=euH_n9WXG29CFd10urh85O4Mw2L=StEizVmh27CYzrtQ@mail.gmail.com>
 <ZfSTh4bLuAMlF6Er@google.com>
Message-ID: <ZfScHYPW5ZV6Gx2k@google.com>
Subject: Re: [syzbot] [kvm?] WARNING in clear_dirty_gfn_range
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: syzbot <syzbot+900d58a45dcaab9e4821@syzkaller.appspotmail.com>, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org, 
	vipinsh@google.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 15, 2024, David Matlack wrote:
> On 2024-03-15 11:07 AM, David Matlack wrote:
> > On Tue, Mar 12, 2024 at 4:34=E2=80=AFPM syzbot
> > <syzbot+900d58a45dcaab9e4821@syzkaller.appspotmail.com> wrote:
> > >
> > > ------------[ cut here ]------------
> > > WARNING: CPU: 1 PID: 5165 at arch/x86/kvm/mmu/tdp_mmu.c:1526 clear_di=
rty_gfn_range+0x3d6/0x540 arch/x86/kvm/mmu/tdp_mmu.c:1526
> > > Modules linked in:
> > > CPU: 1 PID: 5165 Comm: syz-executor417 Not tainted 6.8.0-syzkaller-01=
185-g855684c7d938 #0
> > > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debia=
n-1.16.2-1 04/01/2014
> > > RIP: 0010:clear_dirty_gfn_range+0x3d6/0x540 arch/x86/kvm/mmu/tdp_mmu.=
c:1526
> > > Call Trace:
> > >  <TASK>
> > >  kvm_tdp_mmu_clear_dirty_slot+0x24f/0x2e0 arch/x86/kvm/mmu/tdp_mmu.c:=
1557
> > >  kvm_mmu_slot_leaf_clear_dirty+0x38b/0x490 arch/x86/kvm/mmu/mmu.c:678=
3
> > >  kvm_mmu_slot_apply_flags arch/x86/kvm/x86.c:12962 [inline]
> > >  kvm_arch_commit_memory_region+0x299/0x490 arch/x86/kvm/x86.c:13031
> > >  kvm_commit_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c:1=
751 [inline]
> > >  kvm_set_memslot+0x4d3/0x13e0 arch/x86/kvm/../../../virt/kvm/kvm_main=
.c:1994
> > >  __kvm_set_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c:21=
29 [inline]
> > >  __kvm_set_memory_region+0xdbc/0x1520 arch/x86/kvm/../../../virt/kvm/=
kvm_main.c:2020
> > >  kvm_set_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c:2150=
 [inline]
> > >  kvm_vm_ioctl_set_memory_region arch/x86/kvm/../../../virt/kvm/kvm_ma=
in.c:2162 [inline]
> > >  kvm_vm_ioctl+0x151c/0x3e20 arch/x86/kvm/../../../virt/kvm/kvm_main.c=
:5152
> >=20
> > The reproducer uses nested virtualization to launch an L2 with EPT
> > disabled. This creates a TDP MMU root with role.guest_mode=3D1, which
> > triggers the WARN_ON() in kvm_tdp_mmu_clear_dirty_slot() because
> > kvm_mmu_page_ad_need_write_protect() returns false whenever PML is
> > enabled and the shadow page role.guest_mode=3D1.

Nit, kvm_mmu_page_ad_need_write_protect() returns %true, not %false.  Your =
analysis
is correct, I think you just mistyped.

> >=20
> > If I'm reading prepare_vmcs02_constant_state() correctly, we always
> > disable PML when running in L2.

Ya.

> So when enable_pml=3D1 and L2 runs with EPT disabled we are blind to dirt=
y
> tracking L2 accesses.

Ow.

> +Vipin
>=20
> I believe this was introduced by 6.4 commit 5982a5392663 ("KVM: x86/mmu:
> Use kvm_ad_enabled() to determine if TDP MMU SPTEs need wrprot").
>=20
> I see two options to fix:
>=20
>   1. Allow PML to be enabled when L2 is running with EPT is disabled.
>   2. Fix the TDP MMU logic to write-protect role.guest_mode=3D1 SPTEs.
>=20
> (1.) sounds more complicated and will require more testing.

It's not terribly complicated, but I 100% agree it's too complicated for a =
bugfix
that is destined for stable.  And long term, I don't even know that it's so=
mething
we'd want to bother actively supporting, as any amount of complexity beyond=
 "PML
is disabled for L2" is probably dead weight since not using TDP is quite un=
common
these days.

> (2.) is quite simple since an entire TDP MMU tree is either guest_mode=3D=
0 or
> guest_mode=3D1.
>=20
> Example fix (fixes syzbot repro but otherwise untested):
>=20
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 6ae19b4ee5b1..eb6fb8d9c00c 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1498,6 +1498,24 @@ void kvm_tdp_mmu_try_split_huge_pages(struct kvm *=
kvm,
>  	}
>  }
> =20
> +static inline u64 tdp_mmu_dirty_bit(struct kvm_mmu_page *root, bool forc=
e_wrprot)

No "inline" on local statics, formletter incoming...

Do not use "inline" for functions that are visible only to the local compil=
ation
unit.  "inline" is just a hint, and modern compilers are smart enough to in=
line
functions when appropriate without a hint.

A longer explanation/rant here: https://lore.kernel.org/all/ZAdfX+S323JVWNZ=
C@google.com

> +{
> +	if (force_wrprot || kvm_mmu_page_ad_need_write_protect(root) || !kvm_ad=
_enabled())
> +		return PT_WRITABLE_MASK;
> +
> +	return shadow_dirty_mask;
> +}
> +
> +static inline bool tdp_mmu_dirty_bit_invalid_for_spte(struct tdp_iter *i=
ter, u64 dbit)
> +{
> +	/*
> +	 * The decision of whether to clear the D-bit or W-bit is made based on
> +	 * the root, as all TDP MMU SPTEs within a root should require the same
> +	 * modifications. This check ensures that is actually the case.
> +	 */
> +	return dbit =3D=3D shadow_dirty_mask && spte_ad_need_write_protect(iter=
->old_spte);
> +}
> +
>  /*
>   * Clear the dirty status of all the SPTEs mapping GFNs in the memslot. =
If
>   * AD bits are enabled, this will involve clearing the dirty bit on each=
 SPTE.
> @@ -1508,7 +1526,7 @@ void kvm_tdp_mmu_try_split_huge_pages(struct kvm *k=
vm,
>  static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *=
root,
>  			   gfn_t start, gfn_t end)
>  {
> -	u64 dbit =3D kvm_ad_enabled() ? shadow_dirty_mask : PT_WRITABLE_MASK;
> +	u64 dbit =3D tdp_mmu_dirty_bit(root, false);

Hrm, I like common helpers, but I dislike "blind" booleans even more.  My v=
ote
would be to do this:

	u64 dbit =3D wrprot ? PT_WRITABLE_MASK : tdp_mmu_dirty_bit(root);

if we want to hide the PT_WRITABLE_MASK vs. shadow_dirty_mask.  Though I'm =
tempted
to vote for open coding the bit selection, e.g.

	u64 dbit =3D (wrprot || tdp_mmu_force_wrprot(root)) ? PT_WRITABLE_MASK :
							    shadow_dirty_mask;

and

	u64 dbit =3D tdp_mmu_force_wrprot(root) ? PT_WRITABLE_MASK :
						shadow_dirty_mask;

For tdp_mmu_force_wrprot(), the "what" is pretty clear, i.e. readers only n=
eed
to look at the implementation if they care _why_ KVM forces write-protectio=
n.

But with tdp_mmu_dirty_bit(), even the "what" isn't clear, i.e. it's not ob=
vious
that the options are hardware's D-bit and the writable bit.

>  	struct tdp_iter iter;
>  	bool spte_set =3D false;
> =20
> @@ -1523,8 +1541,7 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, =
struct kvm_mmu_page *root,
>  		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
>  			continue;
> =20
> -		KVM_MMU_WARN_ON(kvm_ad_enabled() &&
> -				spte_ad_need_write_protect(iter.old_spte));
> +		KVM_MMU_WARN_ON(tdp_mmu_dirty_bit_invalid_for_spte(&iter, dbit));
> =20
>  		if (!(iter.old_spte & dbit))
>  			continue;
> @@ -1570,8 +1587,7 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm,
>  static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *=
root,
>  				  gfn_t gfn, unsigned long mask, bool wrprot)
>  {
> -	u64 dbit =3D (wrprot || !kvm_ad_enabled()) ? PT_WRITABLE_MASK :
> -						   shadow_dirty_mask;
> +	u64 dbit =3D tdp_mmu_dirty_bit(root, wrprot);
>  	struct tdp_iter iter;
> =20
>  	lockdep_assert_held_write(&kvm->mmu_lock);
> @@ -1583,8 +1599,7 @@ static void clear_dirty_pt_masked(struct kvm *kvm, =
struct kvm_mmu_page *root,
>  		if (!mask)
>  			break;
> =20
> -		KVM_MMU_WARN_ON(kvm_ad_enabled() &&
> -				spte_ad_need_write_protect(iter.old_spte));
> +		KVM_MMU_WARN_ON(tdp_mmu_dirty_bit_invalid_for_spte(&iter, dbit));

I would definitely prefer to keep this open coded as:

		KVM_MMU_WARN_ON(dbit !=3D PT_WRITABLE_MASK &&
				spte_ad_need_write_protect(iter.old_spte));

IMO, that's self-explanatory, i.e. doesn't need a comment, and doesn't requ=
ire
hunting down the tdp_mmu_dirty_bit_invalid_for_spte() to see what the fuss =
is
about.

