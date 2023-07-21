Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78EE875D7A0
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 00:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjGUWno (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 18:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbjGUWnm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 18:43:42 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1624FE4C
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 15:43:42 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b8a7734734so14224725ad.2
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 15:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689979421; x=1690584221;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EqN+mkVwiz0JYePPsvbJE9Of00MhnNzfwNJUrTtqx34=;
        b=uPbc6qjTF+37bLOVeLN5oBf/3QUeWpvQQj3Os3hzKIn+9w+stgDfD/wRvHH6vvS1vz
         Jdb1/CGaRKexplycNPtMGXN+Tg/RyJbt630Xs8IeS3SMFNv5PCsghbo+kYJFygNjCFpF
         sVNhgSsW83NY1COiSao1pWUPh1AtIrckRNYwIAGc+050XIyJvUElwzdbPqwTGeusV0wO
         MmoVQyd6hZXWLdmSuWxhFzejY1yhd7tNiH5rpZy3iuO0rqNdjsPMj90Dn4Tac+hSKGnn
         8AHG8NIUVhg6+9rueuzf1vrfPuAWZzW4D3IejKxilXlQAwYf9OjIQqNCdXkMDdc9uB2Q
         IB8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689979421; x=1690584221;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EqN+mkVwiz0JYePPsvbJE9Of00MhnNzfwNJUrTtqx34=;
        b=gI5O8y+v0vLM7z337uEB9v40rIXSAYYieEmt1aETk0vakRI42VaubqfDF4L3HtqKm8
         DCc1LzO8u7+8uLRnhWiLvTVbDxYWTkxJDNPIHWssV0UUoPIFXEBa2iGXxDbS9sVHQIqr
         jt+elsNXFTBYbs7eNJUcf4D0RMZMOjYIYlwZqiCF2Xjm5xgxT642r9u6gjXTgo1yjbYx
         ZkZrNKh3XYJp8G8qKFPciiKivt/cqTQHE8ywMDr2EVY6pNWY3esWJiC2lWYgZysFiQ5d
         ssRVLC4FzofW7Mj6xwJq0Es5ZIvyzTU9AVlZuTVatCDIQtTksv0/GnphfaZhMfr8MjNC
         TvFg==
X-Gm-Message-State: ABy/qLYA3jl12RL85scLzfvFsOglqlgwyC7AC7iGTs2te+qKTNLLsvsb
        nj0JHc2/28o3wmhU6K4DlWrKQa511Cc=
X-Google-Smtp-Source: APBJJlGxj6qSv326g8m5rQzyp+BHE+VykBcM7ioa5QFILiq54tA6coBcY4UbtZwO/j7CN0cMbdg2fYkn1PA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:32cd:b0:1a6:4ce8:3ed5 with SMTP id
 i13-20020a17090332cd00b001a64ce83ed5mr12524plr.4.1689979421568; Fri, 21 Jul
 2023 15:43:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 15:43:36 -0700
In-Reply-To: <20230721224337.2335137-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230721224337.2335137-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721224337.2335137-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: x86: Acquire SRCU read lock when handling fastpath
 MSR writes
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Thelen <gthelen@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Temporarily acquire kvm->srcu for read when potentially emulating WRMSR in
the VM-Exit fastpath handler, as several of the common helpers used during
emulation expect the caller to provide SRCU protection.  E.g. if the guest
is counting instructions retired, KVM will query the PMU event filter when
stepping over the WRMSR.

  dump_stack+0x85/0xdf
  lockdep_rcu_suspicious+0x109/0x120
  pmc_event_is_allowed+0x165/0x170
  kvm_pmu_trigger_event+0xa5/0x190
  handle_fastpath_set_msr_irqoff+0xca/0x1e0
  svm_vcpu_run+0x5c3/0x7b0 [kvm_amd]
  vcpu_enter_guest+0x2108/0x2580

Alternatively, check_pmu_event_filter() could acquire kvm->srcu, but this
isn't the first bug of this nature, e.g. see commit 5c30e8101e8d ("KVM:
SVM: Skip WRMSR fastpath on VM-Exit if next RIP isn't valid").  Providing
protection for the entirety of WRMSR emulation will allow reverting the
aforementioned commit, and will avoid having to play whack-a-mole when new
uses of SRCU-protected structures are inevitably added in common emulation
helpers.

Fixes: dfdeda67ea2d ("KVM: x86/pmu: Prevent the PMU from counting disallowed events")
Reported-by: Greg Thelen <gthelen@google.com>
Reported-by: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a6b9bea62fb8..8c073a4af484 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2172,6 +2172,8 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 	u64 data;
 	fastpath_t ret = EXIT_FASTPATH_NONE;
 
+	kvm_vcpu_srcu_read_lock(vcpu);
+
 	switch (msr) {
 	case APIC_BASE_MSR + (APIC_ICR >> 4):
 		data = kvm_read_edx_eax(vcpu);
@@ -2194,6 +2196,8 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 	if (ret != EXIT_FASTPATH_NONE)
 		trace_kvm_msr_write(msr, data);
 
+	kvm_vcpu_srcu_read_unlock(vcpu);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(handle_fastpath_set_msr_irqoff);
-- 
2.41.0.487.g6d72f3e995-goog

