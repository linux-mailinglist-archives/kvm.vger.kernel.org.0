Return-Path: <kvm+bounces-37644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C210A2D1D2
	for <lists+kvm@lfdr.de>; Sat,  8 Feb 2025 00:55:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E1583ACA8F
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 23:55:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28AB31DB546;
	Fri,  7 Feb 2025 23:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zXlN33DZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5FE156F45
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 23:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738972501; cv=none; b=F0GPXB0aT83pwKUjA+nbfPb1iPurGq51/e5p6udS0E2qxxWbclMLZFjvKer/y7+Nbq7wnwnF45ooYNOr1OSOubWyeo5Rab/JNyTO0rk5RwzwPcK2QgyNfZfIGxIQyrANXDTfW3tDZb2x8dOv9Se7r10HkQWVvq+E36WaxLk+h3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738972501; c=relaxed/simple;
	bh=UVvLgwfCounOnrHXmOoc6CadJ+VvDRpp8Fv+GMeJNeA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=laQoj8bG3ViqZkIrpqVDxx6QTSWydqGF+i29/0jbQ27TD74498xJJIwaZBb/C7ERXJF4cIXTxR2SeSmGA8flI2O/hg2ygsxstu8RLjrc9HCqmM9NpY3fGrvHW7M7TxfK55sRwqqFeq+4KlHFYn+yGze08buCHrm1HJOxuj4ig1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zXlN33DZ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f9da17946fso8463095a91.3
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2025 15:54:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738972499; x=1739577299; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o8KCUdLYRsIgiWA7YWjb0mVWZNtsNn+oAmNkK2l8kL8=;
        b=zXlN33DZV2dBezv3mJo4NxtT8KbUOrbQvqs/zcw0bTkGigD82OfVVcxsqw65Lka6GN
         T5CB02+XWzK2tjW4yCLw5zBUGJ98Na5SX6Ca0gqq5OlAIokt9gzffrYfgz62oAwbSp50
         VwEv9/m9GGK2yC/8N4zuLLtGFBp8eOsdERXMXr1hV1kxv3DFRwLPAM7lzM291twmsJzy
         XWER3mpZgjvNV6/VR5zI/0a6krso83gPtOmv7k3m2D9MFoySuSRsjkgqRUSAje4xAIVp
         cOs6IJ+dCSGfzsbZY2dOLbkH+r+XsgxnDzfo20edlV+Z/jWWV0e4nE3yAYycfhiBT4BA
         IsUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738972499; x=1739577299;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o8KCUdLYRsIgiWA7YWjb0mVWZNtsNn+oAmNkK2l8kL8=;
        b=ExeLQ+XH/x4NXJpialGS0h1+cbWDBvHLVcmZBpC5E3hIpncE1nnwNtH5hLpuNCHaP8
         2jNL8KqHbiYeFQ4ERrbH7rdAHk02QkIvfnDe1FGyFROLrrjC5ysJDhrFmwUxmSrbe+NO
         fKCIkeQp7/gPaqdLWhAW0Bqjs2FmHqCUsCNXAGQeauiA/2oiBWytQdzPBGsOAfxRolYV
         wsi9zfIDUsnSS81CRqairtn2PANj3aJdjXphXGuyVGKw0ZbkAIsJxD6RN9AkhGiJpxPc
         Oph772dHBus7BYJ1tTrL0E9tUdO8ybfiVNCoKs+g9OIc9YLHr2avpHJX80kx6jP1gAs9
         cThg==
X-Gm-Message-State: AOJu0YzXIsI6itHkMyGYVH7aCkhHrk6Vce+lntG3oaFlL602OHH67Ps9
	3zGhPJzlNG8KA1nZn0jDY/QWwdRTZuLs0apbsh2ocTSt/P4/ZLu+XLJIwP35GmBHuRRzP3AouSI
	HQg==
X-Google-Smtp-Source: AGHT+IG/1dCrPWpFUXe2OFL0QktRMfDQ/u7x8ScFe5HfYbiJDZ+YehnhgbJGzeywg7eIz3DKMxclH1x64IA=
X-Received: from pgbcm3.prod.google.com ([2002:a05:6a02:a03:b0:aa5:c436:1469])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3115:b0:1e1:9fef:e975
 with SMTP id adf61e73a8af0-1ee03b42a75mr9208939637.26.1738972499009; Fri, 07
 Feb 2025 15:54:59 -0800 (PST)
Date: Fri, 7 Feb 2025 15:54:57 -0800
In-Reply-To: <CADH9ctBs1YPmE4aCfGPNBwA10cA8RuAk2gO7542DjMZgs4uzJQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CADH9ctBs1YPmE4aCfGPNBwA10cA8RuAk2gO7542DjMZgs4uzJQ@mail.gmail.com>
Message-ID: <Z6adUeCZaCUmHRTm@google.com>
Subject: Re: Problem with vmrun in an interrupt shadow
From: Sean Christopherson <seanjc@google.com>
To: Doug Covelli <doug.covelli@broadcom.com>
Cc: kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 07, 2025, Doug Covelli wrote:
> To test support for nested virtualization I was running a VM (L2) on a
> debug build of ESX (L1) on VMware Workstation/KVM (L0).  This
> consistently resulted in an ASSERT in L1 firing as the interrupt
> shadow bit in the VMCB was set on an #NPF exit that occurred when
> vectoring through the IDT to deliver an interrupt to L2.
> 
> Some details from our exit recorder are below.  Basically what
> happened is that L1 resumed L2 after handling an I/O exit and
> attempted to inject an internal interrupt with vector 0x68.  This
> resulted in a #NPF exit when vectoring through the IDT to deliver the
> interrupt to the guest with the interrupt shadow bit set which our
> code is not expecting.  There is no reason for the interrupt shadow
> bit to be set and neither L1 or L0 were setting it.
> 
> This turns out to be due to a quirk where on AMD 'vmrun' after an
> 'sti' will cause the interrupt shadow bit to leak into the guest state
> in the VMCB. Jim Mattson discovered this back when he was with VMware
> and checked in a fix to make sure that our 'vmrun' is not immediately
> after an 'sti':
> 
>         sti             /* Enable interrupts during guest execution */
>         mov             svmPhysCurrentVMCB(%rip), %rax
>         vmrun           /* Must not immediately follow STI. See PR 150935 */
> 
> PR 150935 describes exactly the same problem I am seeing with KVM.
> For KVM the 'vmrun' is immediately after a 'sti' though:
> 
>         /* Enter guest mode */
>         sti
> 
> 1:      vmrun %rax
> 
> I confirmed that moving the 'sti' after the mov instruction in the
> VMware code causes the same exact ASSERT to fire.  I discussed this
> with Jim and Sean and they suggested sending an e-mail to this list.
> Jim also mentioned that this was introduced by [1] a few years back.
> It would be hard to argue that this isn't an AMD bug but it seems best
> to workaround it in SW.  It would be great if someone could fix this
> but if folks are too busy I can ask Zach to include it in the patches
> he is working on.

I'll post a patch and a regression test.  It took me ~15 minutes to realize the
key is taking an exit while injecting an event, i.e. before executing anything
in the guest.  ~3 minutes to re-learn nested_exceptions_test.c, and 2 seconds
to add a testcase:

diff --git a/tools/testing/selftests/kvm/x86/nested_exceptions_test.c b/tools/testing/selftests/kvm/x86/nested_exceptions_test.c
index 3eb0313ffa39..3641a42934ac 100644
--- a/tools/testing/selftests/kvm/x86/nested_exceptions_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_exceptions_test.c
@@ -85,6 +85,7 @@ static void svm_run_l2(struct svm_test_data *svm, void *l2_code, int vector,
 
        GUEST_ASSERT_EQ(ctrl->exit_code, (SVM_EXIT_EXCP_BASE + vector));
        GUEST_ASSERT_EQ(ctrl->exit_info_1, error_code);
+       GUEST_ASSERT(!ctrl->int_state);
 }
 
 static void l1_svm_code(struct svm_test_data *svm)
@@ -122,6 +123,7 @@ static void vmx_run_l2(void *l2_code, int vector, uint32_t error_code)
        GUEST_ASSERT_EQ(vmreadz(VM_EXIT_REASON), EXIT_REASON_EXCEPTION_NMI);
        GUEST_ASSERT_EQ((vmreadz(VM_EXIT_INTR_INFO) & 0xff), vector);
        GUEST_ASSERT_EQ(vmreadz(VM_EXIT_INTR_ERROR_CODE), error_code);
+       GUEST_ASSERT(!vmreadz(GUEST_INTERRUPTIBILITY_INFO));
 }
 
 static void l1_vmx_code(struct vmx_pages *vmx)


