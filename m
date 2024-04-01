Return-Path: <kvm+bounces-13311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E6C748947F6
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 01:51:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C6402827BA
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 23:51:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E079657315;
	Mon,  1 Apr 2024 23:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f6ZyMnM5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7039057318
	for <kvm@vger.kernel.org>; Mon,  1 Apr 2024 23:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712015466; cv=none; b=o7QBahh1bH0JEyOxEC1eIpYNtfwMn/L1vkdTGm8+dz+sJH8ZAqMT9+F5SHOSOnFbNyKN0TFW/1vEoI9wAL4XUHagHmGLFOgc0KCs75+8+18GOxhb1s6Xk+HCK5mnUCDth1ZUJtHBiCimhA3CUVtGp7Va9Rw9+WrSZUvY/RpqPho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712015466; c=relaxed/simple;
	bh=pkzd7SgxeJNPPKKHqsNiBOlbYW/EXgesx/dYMSHxWjk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LaYPeLTxe9oo6JeOqvtopDvxwJ9fXtQCwgrA+QlKvWTXxTsEib0cayC0XEHYtfzpAP3ld/VAnJbtwi6VUHoOz3MyPxuNLq9zWjEUpcsqC72tunIlJeUEklesxnyGwk94EX24TwJQ6LqbkeyxzJbCl45YLOfj718fMcbcHtbkbzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f6ZyMnM5; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61473afbc93so26862587b3.0
        for <kvm@vger.kernel.org>; Mon, 01 Apr 2024 16:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712015463; x=1712620263; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1g6pYXpWHBOD2MDlBRyGkChDZtQgMSL8vaI9tZWPK0Q=;
        b=f6ZyMnM5vuHA4ICJEbRIjWdYKTMNlFFOBAylQDft2l68uYpF7nTy9iAwSGzzqiAMeC
         mcc6M/mXqMoYLczKBfn19PmocTyGG66A7+ipRHdljVc4fAqekwoNCqQOTuRtWHXl6Xly
         TI/BS6VPIUF882rmmjTa4PlpQegnk89bRAfgaxAEPW2An3vW9+SVNN2CSqthSE26RrAF
         6ZMhKxp64ne6kpUFbhajbeg3KtSr5JarldCV+K3Nk11DhCtgZ24QOs7rKFarJhXLV+tR
         3f5rSAzKCFj0kHFns1c/JNntnme/ejidtL7V6H0dFJTFyu29j+KOQ0vyRRbpgjir5grB
         qgmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712015463; x=1712620263;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1g6pYXpWHBOD2MDlBRyGkChDZtQgMSL8vaI9tZWPK0Q=;
        b=ENtFOB2C1pyEl0iO3SKIXU2V5ttm+dtuT4ntznTMYXU2w0UYe2uJ1IP2WNk4pNtH/0
         pMQeREnXy5wt1bC6O8+yHI1BM3O6W++2ldwYF1s2nZwSdrj486xxBI1aIrvIc1Xs3MbN
         4UpW75NAXkRizum3IIoJNJWs56IrIvOUFpFqV+j512Nl1uDpMd6KC+GkGpVdnWiI7YVF
         Vy19iUzvlChnPUud5m/fY8hj3djKKynA/jRFT9m7iDwchg5JSrnyMuQcD9TxCJCU5wkI
         xV/EdOY4jul3vtqcKvNWDdNTo715iABazU5u9NjAS7ouBdEjxkVhOUU9QGXvPpQcWm8h
         76uA==
X-Forwarded-Encrypted: i=1; AJvYcCWEBJZMHqPR0zTe4VFKs80FTRtnlAWcAHD0pC3jwGzw1yGtRLJ2eNToIGkkTed2jRwa3f/IQpyKs9V3Nv8NUYFQHwWm
X-Gm-Message-State: AOJu0YyCcJIyv/haAr7cfeLFiFvYmWiZbJJa/2v/VH3n66GAkkdT09/8
	acSi/Lnm549gPnBFegpPVQQCWXAIiTfGTbwrx4G3aJVg5+F/4jrCoW4zs9H9YEU4nmTwnw/Ps7b
	v2w==
X-Google-Smtp-Source: AGHT+IHDJnLRXxiHT94GcHIuy5t5eWh/WvL5yNJvhDb6xyfn7pj5u6mSygkbLXqOb+58I2sCwOwr3/U2yvQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:7b03:0:b0:611:3077:2de7 with SMTP id
 w3-20020a817b03000000b0061130772de7mr2707188ywc.3.1712015463438; Mon, 01 Apr
 2024 16:51:03 -0700 (PDT)
Date: Mon, 1 Apr 2024 16:51:01 -0700
In-Reply-To: <31e473b8-8721-4421-9ebc-e7053e914030@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <0000000000009b38080614c49bdb@google.com> <31e473b8-8721-4421-9ebc-e7053e914030@gmail.com>
Message-ID: <ZgtIZbO166oe8rNw@google.com>
Subject: Re: [syzbot] [kvm?] WARNING in mmu_free_root_page
From: Sean Christopherson <seanjc@google.com>
To: Phi Nguyen <phind.uet@gmail.com>
Cc: syzbot <syzbot+dc308fcfcd53f987de73@syzkaller.appspotmail.com>, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 01, 2024, Phi Nguyen wrote:
> On 3/29/2024 11:55 AM, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    928a87efa423 Merge tag 'gfs2-v6.8-fix' of git://git.kernel..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=127c0546180000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=f64ec427e98bccd7
> > dashboard link: https://syzkaller.appspot.com/bug?extid=dc308fcfcd53f987de73
> > compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=110481f1180000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=177049a5180000
> > 
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-928a87ef.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/7979568a5a16/vmlinux-928a87ef.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/1bc6e1d480e3/bzImage-928a87ef.xz
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+dc308fcfcd53f987de73@syzkaller.appspotmail.com

...

> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > 
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > 
> > If the report is already addressed, let syzbot know by replying with:
> > #syz fix: exact-commit-title
> > 
> > If you want syzbot to run the reproducer, reply with:
> > #syz test: git://repo/address.git branch-or-commit-hash
> > If you attach or paste a git patch, syzbot will apply it before testing.
> > 
> > If you want to overwrite report's subsystems, reply with:
> > #syz set subsystems: new-subsystem
> > (See the list of subsystem names on the web dashboard)
> > 
> > If the report is a duplicate of another one, reply with:
> > #syz dup: exact-subject-of-another-report
> > 
> > If you want to undo deduplication, reply with:
> > #syz undup
> > 
> Shadow TDP
> 
> #syz test:
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master

> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 992e651540e8..b4275dc22d21 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3591,7 +3591,7 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
>  void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
>                         ulong roots_to_free)
>  {
> -       bool is_tdp_mmu = tdp_mmu_enabled && mmu->root_role.direct;
> +       bool is_tdp_mmu = tdp_mmu_enabled;

This isn't a proper fix.  It would actually make a relative benign bug (taking
mmu_lock for write instead of read) far worse (taking mmu_lock for read instead
of write).  The reproducer doesn't fail because it's not actually running nested
VMs, just doing fun things with KVM_SET_CPUID2.

The issue is that kvm_mmu_after_set_cpuid() clobbers the entire role, which
results in mmu->root_role.direct being garbage.  That results in a false negative,
but as above it's quite benign as it simply means KVM takes mmu_lock for write,
when acquiring for read would suffice.

kvm_mmu_page_role.invalid already exists, we just have never used it for the
root_role.  Unless I'm missing something, the below is the simplest fix.  I'll
post a patch tomorrow, assuming testing goes well.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 77d1072b130d..2a6c573e0c63 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5540,9 +5540,9 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
         * that problem is swept under the rug; KVM's CPUID API is horrific and
         * it's all but impossible to solve it without introducing a new API.
         */
-       vcpu->arch.root_mmu.root_role.word = 0;
-       vcpu->arch.guest_mmu.root_role.word = 0;
-       vcpu->arch.nested_mmu.root_role.word = 0;
+       vcpu->arch.root_mmu.root_role.invalid = 1;
+       vcpu->arch.guest_mmu.root_role.invalid = 1;
+       vcpu->arch.nested_mmu.root_role.invalid = 1;
        vcpu->arch.root_mmu.cpu_role.ext.valid = 0;
        vcpu->arch.guest_mmu.cpu_role.ext.valid = 0;
        vcpu->arch.nested_mmu.cpu_role.ext.valid = 0;


