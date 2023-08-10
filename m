Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4768B77844F
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 01:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbjHJXt2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 19:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbjHJXtX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 19:49:23 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507752D4B
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 16:49:23 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-26814a0122dso1807534a91.1
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 16:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691711363; x=1692316163;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0MxTrgQSzrtixzHynHiQH/awbsTAu12j+2kwyEuuwhY=;
        b=D41wM5/g3u8d/j3OyazCXF0tL/NoX3Es3irpgu4hQ1Zgy074Lje5t9CTlosGNkkzAm
         e1sZp2u9aBlvHNlEgivhCI8oKjSUi+JvPSw7+/UNJyCMlcLmc8jJ774LkjyYS+DYUJFB
         jJXaEsQ9nWtG1YR1q3edXWTfYPsE83IkpENakCI09mLgVyLvUaLBS/WIJ5ACFTsMd3LG
         fcfy2KDrQ8AFUa+JUrjH7UtkBYlnZRNSOBcWByOpaQCMFUiVrsV+xahHmGGfigoD4gAz
         h4Rq9diDLjmbuMfrOQUi/mL8LoHBCme/6haejzJllsBHpRBd0FaJuwt/TCZjFVjo+y30
         YJjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691711363; x=1692316163;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0MxTrgQSzrtixzHynHiQH/awbsTAu12j+2kwyEuuwhY=;
        b=lFkZrcR40QHn6igXYKH++ECxgtNWbTwWYj4bdp9hJyWkd5O/uBtfkYAZflctuUlVgk
         dwETbs+cqWBS+49KsbHWIsNRAtYVIrcw48X3S8MlIm93LbBkIuLb4geISGIKQf9h9QLs
         qOku8XfmiutBs3Y7id7HwVwO3BCi5+OtxcpYWrNNwi7OgA53zffZY+5TskK7PK1NrlVm
         MquifGsWjbqRNluCDlzA08FrWca6kb0gGTqWJpCtclIlCtCcHurHEmh67Fozi60+p5JU
         Bgxy0RgBhos45NCc3wfO6FYWsHsIy84C6djge65DZeP1snQcGC/xx0G8NCRg6WTnZrpm
         8Cvw==
X-Gm-Message-State: AOJu0YzDHvoJmrjJRrdXqKjFlbPcGoompPVCVgAhY6/8BkiZtFluXchI
        th4ZE6JAiIi1GEf7Zms8r3VW6oBdw3c=
X-Google-Smtp-Source: AGHT+IF/lPSs9aOyNYVS1bB8AZE/Rk+qNG5yILbpN5ko3BioLARcITcQLr6Dvq3NRP6NXPvfjwb70yA+bws=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:612:b0:263:3727:6045 with SMTP id
 gb18-20020a17090b061200b0026337276045mr90090pjb.4.1691711362872; Thu, 10 Aug
 2023 16:49:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 10 Aug 2023 16:49:17 -0700
In-Reply-To: <20230810234919.145474-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230810234919.145474-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230810234919.145474-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: SVM: Don't inject #UD if KVM attempts emulation of
 SEV guest w/o insn
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wu Zongyo <wuzongyo@mail.ustc.edu.cn>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't inject a #UD if KVM attempts to emulate an instruction for an SEV
guest without a prefilled buffer, and instead resume the guest and hope
that it can make forward progress.  When commit 04c40f344def ("KVM: SVM:
Inject #UD on attempted emulation for SEV guest w/o insn buffer") added
the completely arbitrary #UD behavior, there were no known scenarios where
a well-behaved guest would induce a VM-Exit that triggered emulation, i.e.
it was thought that injecting #UD would be helpful.

However, now that KVM (correctly) attempts to re-inject INT3/INTO, e.g. if
a #NPF is encountered when attempting to deliver the INT3/INTO, an SEV
guest can trigger emulation without a buffer, through no fault of its own.
Resuming the guest and retrying the INT3/INTO is architecturally wrong,
e.g. the vCPU will incorrectly re-hit code #DBs, but for SEV guests there
is literally no other option that has a chance of making forward progress.

Drop the #UD injection for all flavors of emulation, even though that
means that a *misbehaving* guest will effectively end up in an infinite
loop instead of getting a #UD.  There's no evidence that suggests that an
unexpected #UD is actually better than hanging the vCPU, e.g. a soft-hung
vCPU can still respond to IRQs and NMIs to generate a backtrace.

Reported-by: Wu Zongyo <wuzongyo@mail.ustc.edu.cn>
Closes: https://lore.kernel.org/all/8eb933fd-2cf3-d7a9-32fe-2a1d82eac42a@mail.ustc.edu.cn
Fixes: 6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction")
Cc: stable@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 212706d18c62..581958c9dd4d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4725,18 +4725,24 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
 	 * and cannot be decrypted by KVM, i.e. KVM would read cyphertext and
 	 * decode garbage.
 	 *
-	 * Inject #UD if KVM reached this point without an instruction buffer.
-	 * In practice, this path should never be hit by a well-behaved guest,
-	 * e.g. KVM doesn't intercept #UD or #GP for SEV guests, but this path
-	 * is still theoretically reachable, e.g. via unaccelerated fault-like
-	 * AVIC access, and needs to be handled by KVM to avoid putting the
-	 * guest into an infinite loop.   Injecting #UD is somewhat arbitrary,
-	 * but its the least awful option given lack of insight into the guest.
+	 * Resume the guest if KVM reached this point without an instruction
+	 * buffer.  This path should *almost* never be hit by a well-behaved
+	 * guest, e.g. KVM doesn't intercept #UD or #GP for SEV guests.  But if
+	 * a #NPF occurs while the guest is vectoring an INT3/INTO, then KVM
+	 * will attempt to re-inject the INT3/INTO and skip the instruction.
+	 * In that scenario, retrying the INT3/INTO and hoping the guest will
+	 * make forward progress is the only option that has a chance of
+	 * success (and in practice it will work the vast majority of the time).
+	 *
+	 * This path is also theoretically reachable if the guest is doing
+	 * something odd, e.g. if the guest is triggering unaccelerated fault-
+	 * like AVIC access.  Resuming the guest will put it into an infinite
+	 * loop of sorts, but there's no hope of forward progress and injecting
+	 * an exception will at best yield confusing behavior, not to mention
+	 * break the INT3/INTO+#NPF case above.
 	 */
-	if (unlikely(!insn)) {
-		kvm_queue_exception(vcpu, UD_VECTOR);
+	if (unlikely(!insn))
 		return false;
-	}
 
 	/*
 	 * Emulate for SEV guests if the insn buffer is not empty.  The buffer
-- 
2.41.0.694.ge786442a9b-goog

