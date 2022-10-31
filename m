Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 619B9613CC8
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 19:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiJaSBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 14:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiJaSBC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 14:01:02 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CE713D65
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:01:01 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id r10-20020a17090a1bca00b002137a500398so5504567pjr.5
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aUUVUYLJgnj5nzWDJA+dYUJX2dFbOs68FlBZpKyOozw=;
        b=P2J16cF793ifwqTCC0EdUFrQ2FRNlTxY/nI8PZx42sfdUlN54Srk6PXTk56bmnrgRw
         gmz/g5yN6a5QpSh540yg10dV+OGaxFAyvULKwkl2R1bUnTz22Jq+fU+n1pA+OFopfyrd
         XpP5pOj2ROnVWFSAf2+isXaaQzf9C4+MR4cnONE3Ks682/KmC5vihD3NolJAmuoAyMWl
         EufmZMsgrAEWq1jy9g+vxTF99uHH54A4hBNMum+Z8auCdoQu8TeMHMREUggvQe31VejH
         75jvcWcIFECgrdr8iYhv4b+GW3a5uf7AG061GiKFx/jhNDdKkXOd/88kQ1amJNjCNpT+
         UcWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aUUVUYLJgnj5nzWDJA+dYUJX2dFbOs68FlBZpKyOozw=;
        b=J/FXBH8L3eKaQyVzpWiRRx5VBH6YR9uqBzIHf01BuwCcIFNCwSocmfHWBMXwSBE3Lc
         TnkkCjoMXF02WMp5bGtUgvkeB8T3ATqUd6N+UlzNvQDJMwuNOPYolDncaa8c1x1y7jfG
         oZEAfjklKHqKblq26xgqRcZZ6o23ODVuRTBxNJwCAl99hnwuEiB9oNpn8jhtg63A4GiY
         7SOYTyh6xAKyKpTT4yNjnIeSNvw/ZDRToqjI8T61aq+pAw4dJfnqyW6eQR0gtUBZrP7l
         dnwxIEVnFK6H6FVYM80C5iGaFwgpRMkecrUbx/MvktRENyakpXBl/WRAECB83IFyLNOS
         daJQ==
X-Gm-Message-State: ACrzQf2MJl7yKACllj8vsq23DwJoho0CZW+HRxxkR+te0InaXXFeicL1
        wy6NQkYj4jnm8N4iWp48+d9AJ75JGFG0Kg==
X-Google-Smtp-Source: AMsMyM7fLiVjT+1I9jOFEUqauPgMViKbSr71pSRXC3LOApPNFLOlAdUynqW6YBqzwvkfyBQNXeqApDxohtSUrg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:aa7:8c44:0:b0:56c:f21f:5e0e with SMTP id
 e4-20020aa78c44000000b0056cf21f5e0emr15607974pfd.35.1667239261063; Mon, 31
 Oct 2022 11:01:01 -0700 (PDT)
Date:   Mon, 31 Oct 2022 11:00:41 -0700
In-Reply-To: <20221031180045.3581757-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221031180045.3581757-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221031180045.3581757-7-dmatlack@google.com>
Subject: [PATCH v3 06/10] KVM: selftests: Copy KVM PFERR masks into selftests
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Colton Lewis <coltonlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vipin Sharma <vipinsh@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
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

Copy KVM's macros for page fault error masks into processor.h so they
can be used in selftests.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index e8ca0d8a6a7e..f7249cb27e0d 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -882,4 +882,27 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 #define XSTATE_XTILE_DATA_MASK		(1ULL << XSTATE_XTILE_DATA_BIT)
 #define XFEATURE_XTILE_MASK		(XSTATE_XTILE_CFG_MASK | \
 					XSTATE_XTILE_DATA_MASK)
+
+#define PFERR_PRESENT_BIT 0
+#define PFERR_WRITE_BIT 1
+#define PFERR_USER_BIT 2
+#define PFERR_RSVD_BIT 3
+#define PFERR_FETCH_BIT 4
+#define PFERR_PK_BIT 5
+#define PFERR_SGX_BIT 15
+#define PFERR_GUEST_FINAL_BIT 32
+#define PFERR_GUEST_PAGE_BIT 33
+#define PFERR_IMPLICIT_ACCESS_BIT 48
+
+#define PFERR_PRESENT_MASK	BIT(PFERR_PRESENT_BIT)
+#define PFERR_WRITE_MASK	BIT(PFERR_WRITE_BIT)
+#define PFERR_USER_MASK		BIT(PFERR_USER_BIT)
+#define PFERR_RSVD_MASK		BIT(PFERR_RSVD_BIT)
+#define PFERR_FETCH_MASK	BIT(PFERR_FETCH_BIT)
+#define PFERR_PK_MASK		BIT(PFERR_PK_BIT)
+#define PFERR_SGX_MASK		BIT(PFERR_SGX_BIT)
+#define PFERR_GUEST_FINAL_MASK	BIT_ULL(PFERR_GUEST_FINAL_BIT)
+#define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
+#define PFERR_IMPLICIT_ACCESS	BIT_ULL(PFERR_IMPLICIT_ACCESS_BIT)
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
-- 
2.38.1.273.g43a17bfeac-goog

