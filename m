Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E1E54BD24
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 23:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235491AbiFNV6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 17:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355510AbiFNV6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 17:58:37 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C11A2182C
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 14:58:36 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id j15-20020a17090a738f00b001e345e429d2so4195906pjg.0
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 14:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ebS8dne3mnDpirg5LR725mOTZXQcHNFKEGxHVUOffsM=;
        b=VOwSyBvRR60i3AzxCfJhD5+jngE1w8CYRvv8U8CK6pDoMBqQQF3kymLu/Jhj/Ht8Wu
         tsUDCkoUg3wR2qxrZlzyReHtjtB/Ue0KVWcMHJO232lmeNnTU0jmy5LHaNksHjvBKOqj
         A3mZlVivN46URKThiboEbJrzzdyRLdzI0mnFc7JGTBd3Fl6BfSJ1Bu0/2mhq7FJbkwBW
         n0ULn4Mj4aH+laV/eA5fLJqPbrVXsioPLv60mDy0bBQRkPGatFGl282hjjDcviWkkh1h
         C7jke03Z+rNSjxHv/WhUudNUhUT/73YExrWmzV2ypLTeiq+OpVM4priwcbU77a3K++o+
         W6UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ebS8dne3mnDpirg5LR725mOTZXQcHNFKEGxHVUOffsM=;
        b=uwFgD/wRPlOSjea6cQDIpICoutzKnjRfrfBkVlGiDf5eZvf4c4aB3CgjKl4Y6B/Rxb
         g7IO4d+PlQeGGaVl3RmP4m7LF3ARvl3oaR2ukYI1qwBjI+di4neI0LtBpeg1HeShwTQe
         gPEjZYeNshsKB4GRJf8B5wk47ihuAPRNUeFwuFDsY608OYNZTqLz5JtuMjmpb9q2CkI7
         3Nc96F71pjwJAu6IE0epLC1yAT0UjIzrxBBcOxBkbJNiULExlRvgEdbGlRCBYsX8m9MV
         8ih40XgkYenb9rO6hogC2nKAZZqXQyfGlx2qIOrnP53O/enmrl+BvoJzhmBbpUpoV19r
         /PfQ==
X-Gm-Message-State: AJIora/RxdqIIkHbtDdQxl9JAkzRszU6Tyf7/dqzfv+55jxQUu7q5uvp
        bNZe99zimFo/NZv3BjQ6tjDq0djIwgw=
X-Google-Smtp-Source: AGRyM1vMQ6nhSdUpnQYVSpnpt2k+LMXtZ71PU0X63rWRBPPfkzBD6InMr8CLS1qvxKaEQ0bcMvu1i2cChow=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:64c2:b0:168:c298:bdee with SMTP id
 y2-20020a17090264c200b00168c298bdeemr6090894pli.82.1655243916084; Tue, 14 Jun
 2022 14:58:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 21:58:27 +0000
In-Reply-To: <20220614215831.3762138-1-seanjc@google.com>
Message-Id: <20220614215831.3762138-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220614215831.3762138-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 1/5] KVM: nVMX: Snapshot pre-VM-Enter BNDCFGS for
 !nested_run_pending case
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lei Wang <lei4.wang@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If a nested run isn't pending, snapshot vmcs01.GUEST_BNDCFGS irrespective
of whether or not VM_ENTRY_LOAD_BNDCFGS is set in vmcs12.  When restoring
nested state, e.g. after migration, without a nested run pending,
prepare_vmcs02() will propagate nested.vmcs01_guest_bndcfgs to vmcs02,
i.e. will load garbage/zeros into vmcs02.GUEST_BNDCFGS.

If userspace restores nested state before MSRs, then loading garbage is a
non-issue as loading BNDCFGS will also update vmcs02.  But if usersepace
restores MSRs first, then KVM is responsible for propagating L2's value,
which is actually thrown into vmcs01, into vmcs02.

Restoring L2 MSRs into vmcs01, i.e. loading all MSRs before nested state
is all kinds of bizarre and ideally would not be supported.  Sadly, some
VMMs do exactly that and rely on KVM to make things work.

Note, there's still a lurking SMM bug, as propagating vmcs01.GUEST_BNDFGS
to vmcs02 across RSM may corrupt L2's BNDCFGS.  But KVM's entire VMX+SMM
emulation is flawed as SMI+RSM should not toouch _any_ VMCS when use the
"default treatment of SMIs", i.e. when not using an SMI Transfer Monitor.

Link: https://lore.kernel.org/all/Yobt1XwOfb5M6Dfa@google.com
Fixes: 62cf9bd8118c ("KVM: nVMX: Fix emulation of VM_ENTRY_LOAD_BNDCFGS")
Cc: stable@vger.kernel.org
Cc: Lei Wang <lei4.wang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7d8cd0ebcc75..66c25bb56938 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3382,7 +3382,8 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	if (!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
 		vmx->nested.vmcs01_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
 	if (kvm_mpx_supported() &&
-		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
+	    (!vmx->nested.nested_run_pending ||
+	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
 		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
 
 	/*
-- 
2.36.1.476.g0c4daa206d-goog

