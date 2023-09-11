Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2814F79B729
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236043AbjIKUtg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243925AbjIKSU1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 14:20:27 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5B6110
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 11:20:22 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d7ea08906b3so4599390276.1
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 11:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694456422; x=1695061222; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QOZagYLVvMwdP4ZquuVdD0LNGhQZ+2J5uBbCbimIq58=;
        b=66hb55mmnbk21vR2RhN5bmdhtMUyNmvO3IlpldiI4U/IskhXzp8+pphSTEUWZ6DVG8
         +2Ya4HOU6ckoTshThS3ZI5RZ709WzGrS6W+CANsb8rNmyLlBLD7SQ1iKeaCHZbXrnQEL
         U07lPU8jJO9ivS0GGJ90BtInEDpB2w1NBQWSCfb8TjzwpHfGVnY//J2BdfFqccvODG50
         YnojAm6jeWeXWx8oWiuCvx3R7Mp3gmNbf2mgEqUbP6pKImmc+c5SLmUzj3LYdsuxtE7e
         BWwNAUO/QmiwoPiLTremvau1CD54zRLXZujdl6jy1VC1W83k6DNa2KbIE9Pd7KbJY6Qy
         sdKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694456422; x=1695061222;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QOZagYLVvMwdP4ZquuVdD0LNGhQZ+2J5uBbCbimIq58=;
        b=f4Qb+KuIVXQACQxb0Xh1tSNq5pEsXReq6y92S64B/HZQYdMgqZ3g0ThK2g9h9fujmA
         VBtEa0E59jcJCii1zH/aFb00NsinvkLnUpoFu1G/VC1Ypaf4QRxud+Wdn8132F4fheVm
         t0kERr2Kr4ZwX8nWaD4jg4S28OGe4axJqbltApKpRbx3Xb+eCeFBQVw8Dr6fqd4Agl56
         Ps5rjT3i4a7MdlE68ojrDUt0fXCpyR4/1CMq4K0g6zlOAh83EkNqir/pEfRjka6s85dZ
         pBwMT6ZVZBYIRf8bx8dtd8PMLx6tkt1E43e1Vvcrt4SrDYZYw1qFrMPv3uilQzWZ45Fa
         QSQA==
X-Gm-Message-State: AOJu0YztOCPZgytwGIs/JlxXx+LjGLgbWLhxsPbgy6GMQdzkJAomhaRf
        7UkNM9VIYDW22KOf5H5fPRxyIn14fzA=
X-Google-Smtp-Source: AGHT+IHrc3vniepujsVfDmzwEXVNthZSy+eXdPeYKf98xDuh8eZXwR03Pkxjzu7QiaqpL10FmRBq025pf+o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:108f:b0:d78:3c2e:b186 with SMTP id
 v15-20020a056902108f00b00d783c2eb186mr239003ybu.5.1694456422006; Mon, 11 Sep
 2023 11:20:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 11 Sep 2023 11:20:13 -0700
In-Reply-To: <20230911182013.333559-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230911182013.333559-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230911182013.333559-4-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 3/3] nVMX: Add a testcase for running L2 with
 EP4TA that points at MMIO
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a testcase in test_ept_eptp() to verify that KVM doesn't inject a
triple fault (or any other unexpected "error") if L1 runs L2 with an
EP4TA that points at MMIO memory.  For a very, very long time, KVM
synthesized a triple fault in response to a "legal-but-garbage" EP4TA
_before_ completing emulation of nested VM-Enter, which is architectural
wrong and triggered various warnings in KVM.

Use the TPM base address for the MMIO backing, as KVM doesn't emulate a
TPM (in-kernel) and practically the address is guaranteed to be MMIO.

Drop the manual test for 4-level EPT support, as __setup_ept() performs
said check/test.

Link: https://lore.kernel.org/all/20230729005200.1057358-6-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 9afca475..69a7c4a2 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4663,7 +4663,12 @@ static void test_ept_eptp(void)
 	u32 i, maxphysaddr;
 	u64 j, resv_bits_mask = 0;
 
-	report(is_4_level_ept_supported(), "4-level EPT support check");
+	if (__setup_ept(0xfed40000, false)) {
+		report_skip("%s : EPT not supported", __func__);
+		return;
+	}
+
+	test_vmx_valid_controls();
 
 	setup_dummy_ept();
 
-- 
2.42.0.283.g2d96d420d3-goog

