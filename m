Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A5256CFA9
	for <lists+kvm@lfdr.de>; Sun, 10 Jul 2022 17:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiGJPLq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Jul 2022 11:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGJPLp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Jul 2022 11:11:45 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC0CBCA3
        for <kvm@vger.kernel.org>; Sun, 10 Jul 2022 08:11:44 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id v4-20020a17090abb8400b001ef966652a3so6109647pjr.4
        for <kvm@vger.kernel.org>; Sun, 10 Jul 2022 08:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZiGKAq8E/61V/xfD2osUhAigUxFAGIjOAFkVRU11S5c=;
        b=SwASqhsqF/uwpbfqLellpCwOiSzS2k5/C73tZViHwi+wlDrtSvqy/CLZnD2QvQx14O
         05Hik6bMxgJLrqyo0hAR3hJVC2DjtGviASL9QpxRfJ2Mr7prJ0NLHiUeNc6BuYBZft4X
         ZTAqYVdhB8j7EjMsADYyuJSDB4RG6atPSLW3MPkjzoKYaSrWiG9MEd4+xUmzJ7pjW7n0
         v8/5ZFNEOPxeviRy8dbKLUM+VbcoYbCkWE78lVU+ATrf/m6cHHGj76Xk5hFSN2VmLNRw
         k84hTH7nPLuk9tK4wybq6iny6+lXDfG8UDKS9AImQNoG7IoP2xyJCGkMNzNNgc+CpBIZ
         UO2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZiGKAq8E/61V/xfD2osUhAigUxFAGIjOAFkVRU11S5c=;
        b=iFJ7tbJmQzb6AWwTxmWSWegwlQGBl88zQ0soDkOuqyc90O9jW5UhESbVtX03c79hY3
         fIdy9WwROeJ5149HE0WVQXDA4WGkwlH8AU4koe/Gg7+ua9BQqtjvgNtzyhzKRDtPhnqf
         S06nEpMLRSsoYs4KAyT4ok02W02s1Fm53QrjwjwdRKRhSohHxCvQ0pMfZGZBUuV3ZHp1
         GScaWfGt9HtL77xXgmZ6R3mEYLWDZes56o56ygt03asN6fnBvxUCRkk7RwuY4GysYVfk
         wNtjrNUM2MnIVeXWdj9etFkgV4vJZd1s+pBMKssctpN4EHgJRFS7lP1tYm727fwmS2iZ
         72gw==
X-Gm-Message-State: AJIora/1TH6rRJy0H5wJ3iWr2llR6t+4XhNUjmAbNQ1f3qkRTvgklT+6
        Rr06ogcjXtGJLH9UqWwx8Hfvwg==
X-Google-Smtp-Source: AGRyM1sR9ZDu/2Ia1wh+BMIiL0MAl4yRxaD0cHdlrNSxgTTfrD37Fazff0AZYrTaHIbPHcXWL6e9XQ==
X-Received: by 2002:a17:90b:1c86:b0:1ee:e795:a6a with SMTP id oo6-20020a17090b1c8600b001eee7950a6amr11794505pjb.205.1657465903563;
        Sun, 10 Jul 2022 08:11:43 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([122.167.98.167])
        by smtp.gmail.com with ESMTPSA id a200-20020a621ad1000000b0052ab37ef3absm3014756pfa.116.2022.07.10.08.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jul 2022 08:11:42 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Bin Meng <bmeng.cn@gmail.com>,
        Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH] RISC-V: KVM: Fix SRCU deadlock caused by kvm_riscv_check_vcpu_requests()
Date:   Sun, 10 Jul 2022 20:41:05 +0530
Message-Id: <20220710151105.687193-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kvm_riscv_check_vcpu_requests() is called with SRCU read lock held
and for KVM_REQ_SLEEP request it will block the VCPU without releasing
SRCU read lock. This causes KVM ioctls (such as KVM_IOEVENTFD) from
other VCPUs of the same Guest/VM to hang/deadlock if there is any
synchronize_srcu() or synchronize_srcu_expedited() in the path.

To fix the above in kvm_riscv_check_vcpu_requests(), we should do SRCU
read unlock before blocking the VCPU and do SRCU read lock after VCPU
wakeup.

Fixes: cce69aff689e ("RISC-V: KVM: Implement VCPU interrupts and
requests handling")
Reported-by: Bin Meng <bmeng.cn@gmail.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/vcpu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index b7a433c54d0f..5d271b597613 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -845,9 +845,11 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
 
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_SLEEP, vcpu)) {
+			kvm_vcpu_srcu_read_unlock(vcpu);
 			rcuwait_wait_event(wait,
 				(!vcpu->arch.power_off) && (!vcpu->arch.pause),
 				TASK_INTERRUPTIBLE);
+			kvm_vcpu_srcu_read_lock(vcpu);
 
 			if (vcpu->arch.power_off || vcpu->arch.pause) {
 				/*
-- 
2.34.1

