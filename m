Return-Path: <kvm+bounces-52646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 881E3B079B4
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 17:25:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E4BCC7BCA66
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 15:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 587FF2F546C;
	Wed, 16 Jul 2025 15:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MighXWEU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AF3291C3B
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 15:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752679393; cv=none; b=hZ3+RtE8OorNKbVMER8akNMMv32ms7utCMDn83uJC3va2kBrMbgCJWPni6WnSX2zG2frG0ez6SiJnTa3m+TSeCcRdiSdnYuzX6K7aJ+i7ybcw3DGaHiVBxkBBcRjCtbk/O4JpXcYeUHCjN8pw5HjsLW0DuGYiJIz4iwrfEKkDAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752679393; c=relaxed/simple;
	bh=vMTqPP+6hRnC8KSmRmuaiUDWv7LwGHOKrFpBtQvXb0Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OBtpLOZMpXrU3hRstY2u+YiCNhQgMlLyaUWGX9aaXbWNF+EqqWqyKUZNvPFNzaQw3bt9ieSUjiGoaKpIJ5Dn0YBOSXjm85OqhwR7+6ncf4aYvoeItGfOaNaekjxxOgsfy6Wbu0ehrUjtB6sICns/kTldhbHx+px86HLd/0Z0J0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MighXWEU; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31366819969so44045a91.0
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 08:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752679390; x=1753284190; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WwpljzDZuqwMskm2tic+OBYPfr5JC6dHkTuTGvwL8MI=;
        b=MighXWEUjurE3gLc5KZNGxCvC4owfeYJQ+951nqO9HmpU8ee+sYUYjqoHKj7uuPDzS
         n7I159/PguWQwVoezSZKeNPTvOv8Bolw7sJX5G7td4eMSWTiGdfiSuA/sqIsmPVPrr7j
         pbqNiPwGSnKLCIJhmTcryWE9vk0rowQrWXlIcnCvqZycSLhdaJcQncQjo0bH1XP77M8F
         0VB8cfn5JzKx+Z9tCzZXnvH5Q46yLM9u4ecbnCAUD/GcoUigglKYPUffmCGLLBraW5TS
         RVMTvh1sLvVzH8bXD8gFR0fBOarn6D09XepkHu56/IFhJGgY1TZrm4Jw45BBZStpYwAk
         YIew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752679390; x=1753284190;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WwpljzDZuqwMskm2tic+OBYPfr5JC6dHkTuTGvwL8MI=;
        b=Lgm6nSICUD2gpKU3q4tN0D1tP8aLTOoXjJbQbaPvkFNV7Xf4+7ZH3dcpw+YHBcNnY2
         bF0HZr6vjaz8jNCUCGPpfZX4EugjSAuAfCq6aEJox2R6obwWrOGMFRL9qJ+LTUJwp5Y3
         AX/v9k2ZS1+NvtM11HoN4qk+m287l4FWhyE+e1TKWQP3pOyiu6ImXAhXrf/OnI9kwCVD
         CJYF/nzrPFwiijVJBaJJYje4r3jlEIxonmFh50dAIl64laLOALdy0F2tSa82T54dd3WR
         8IiNDnMfPu7CvnQZtiG4Hkgv2yM4uXKFtOQLo4D9eRhaenTfYX7IN7Bm9GxQb6KnAybT
         Etbg==
X-Gm-Message-State: AOJu0YyyWui+S/tfm7gm0gaUkn2vfCeRGPQDKeAYkVqu5aeHPVsoItIE
	2AhW+d7XPh4TENU7reLF8KYuxwExWbLjTFUap9M3glj99zN1fqxcvm/cdrfn5HMos2JP7PhDNUQ
	AglzJMg==
X-Google-Smtp-Source: AGHT+IFmGBmTlWKZZF0mdM3myKSr0azToc5tQH6o7fqNOcb7x4qSKMo3FJ0Wc56gzWm7MYI9bYn2QWmmSbg=
X-Received: from pjh16.prod.google.com ([2002:a17:90b:3f90:b0:312:eaf7:aa0d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c89:b0:313:2768:3f6b
 with SMTP id 98e67ed59e1d1-31c9e77ce91mr5085592a91.27.1752679390400; Wed, 16
 Jul 2025 08:23:10 -0700 (PDT)
Date: Wed, 16 Jul 2025 08:23:08 -0700
In-Reply-To: <6877331d.a00a0220.3af5df.000c.GAE@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <6877331d.a00a0220.3af5df.000c.GAE@google.com>
Message-ID: <aHfD3MczrDpzDX9O@google.com>
Subject: Re: [syzbot] [kvm?] WARNING in kvm_read_guest_offset_cached
From: Sean Christopherson <seanjc@google.com>
To: syzbot <syzbot+bc0e18379a290e5edfe4@syzkaller.appspotmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 15, 2025, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    155a3c003e55 Merge tag 'for-6.16/dm-fixes-2' of git://git...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=103e858c580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8d5ef2da1e1c848
> dashboard link: https://syzkaller.appspot.com/bug?extid=bc0e18379a290e5edfe4
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=153188f0580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16f6198c580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-155a3c00.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/725a320dfe66/vmlinux-155a3c00.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/9f06899bb6f3/bzImage-155a3c00.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+bc0e18379a290e5edfe4@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 6107 at arch/x86/kvm/../../../virt/kvm/kvm_main.c:3459 kvm_read_guest_offset_cached+0x3f5/0x4b0 virt/kvm/kvm_main.c:3459
> Modules linked in:
> CPU: 0 UID: 0 PID: 6107 Comm: syz.0.16 Not tainted 6.16.0-rc6-syzkaller-00002-g155a3c003e55 #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:kvm_read_guest_offset_cached+0x3f5/0x4b0 virt/kvm/kvm_main.c:3459
> Code: 0f 01 e8 3e 6c 61 00 e9 9b fc ff ff e8 14 25 85 00 48 8b 3c 24 31 d2 48 89 ee e8 16 bf fa 00 e9 2e fe ff ff e8 fc 24 85 00 90 <0f> 0b 90 bb ea ff ff ff e9 4d fe ff ff e8 e9 24 85 00 48 8b 74 24
> RSP: 0018:ffffc9000349f960 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff888050329898 RCX: ffffffff8136ca66
> RDX: ffff88803cfa8000 RSI: ffffffff8136cd84 RDI: 0000000000000006
> RBP: 0000000000000004 R08: 0000000000000006 R09: 0000000000000008
> R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000004
> R13: ffffc90003921000 R14: 0000000000000000 R15: ffffc900039215a0
> FS:  000055558378f500(0000) GS:ffff8880d6713000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 0000000025de6000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  apf_pageready_slot_free arch/x86/kvm/x86.c:13452 [inline]

kvm_pv_enable_async_pf() sets vcpu->arch.apf.msr_en_val even if the gpa is bad,
which leaves the cache in an empty state.  Something like so over a few patches
fixes the problem:

---
 arch/x86/kvm/x86.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1c49bc681c4..0fbbf297b3c8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3547,11 +3547,16 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return 0;
 }
 
-static inline bool kvm_pv_async_pf_enabled(struct kvm_vcpu *vcpu)
+static bool __kvm_pv_async_pf_enabled(u64 msr_en_val)
 {
 	u64 mask = KVM_ASYNC_PF_ENABLED | KVM_ASYNC_PF_DELIVERY_AS_INT;
 
-	return (vcpu->arch.apf.msr_en_val & mask) == mask;
+	return (msr_en_val & mask) == mask;
+}
+
+static inline bool kvm_pv_async_pf_enabled(struct kvm_vcpu *vcpu)
+{
+	return __kvm_pv_async_pf_enabled(vcpu->arch.apf.msr_en_val);
 }
 
 static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
@@ -3573,22 +3578,21 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 	if (!lapic_in_kernel(vcpu))
 		return data ? 1 : 0;
 
+	if (__kvm_pv_async_pf_enabled(data) &&
+	    kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.apf.data, gpa,
+				      sizeof(u64)))
+		return 1;
+
 	vcpu->arch.apf.msr_en_val = data;
-
-	if (!kvm_pv_async_pf_enabled(vcpu)) {
-		kvm_clear_async_pf_completion_queue(vcpu);
-		kvm_async_pf_hash_reset(vcpu);
-		return 0;
-	}
-
-	if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.apf.data, gpa,
-					sizeof(u64)))
-		return 1;
-
 	vcpu->arch.apf.send_always = (data & KVM_ASYNC_PF_SEND_ALWAYS);
 	vcpu->arch.apf.delivery_as_pf_vmexit = data & KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT;
 
-	kvm_async_pf_wakeup_all(vcpu);
+	if (kvm_pv_async_pf_enabled(vcpu)) {
+		kvm_clear_async_pf_completion_queue(vcpu);
+		kvm_async_pf_hash_reset(vcpu);
+	} else {
+		kvm_async_pf_wakeup_all(vcpu);
+	}
 
 	return 0;
 }

base-commit: 2a046f6a4ecce47ada50dba529ec726dd0d34351
--

