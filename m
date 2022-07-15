Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97C3576A45
	for <lists+kvm@lfdr.de>; Sat, 16 Jul 2022 01:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiGOXAZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 19:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbiGOXAX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 19:00:23 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC7F3C144
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 16:00:21 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id c18-20020a17090a8d1200b001ef85196fb4so5895463pjo.4
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 16:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=4mRUe9k6N29Y8TY671ys1SOzt46CXKbNlnzYh7VBMGg=;
        b=BY+ofGKbdhxI2uO5Nyqd5dE57NYG6j6ZefdgDGiAMMy15vVMXVMCrAxkz/HmhpImK+
         Grv+x99LKg2/2a7c8R/phTxEvCikiuo0xcEF+jCO7cRYnO7Jz86w6MRWzcHiUpAcmpse
         0iTfrjC1O28pwL1VrBCVYAXfp8Eo9G1UJBI8jOC23NXXn0vDG7ZLCMOn05PaeAjhfClh
         wO0w2V7+MZ1Bl/hlLPcPW45z8QlYCjNcKvOAYamGbWsL9h7BLrpWxBRhmOYPC/bkhtLM
         qUA7RMiIQSituv4YUDa3XRxArvCtVaN2kUHvfSpAQ6HYdnbb4MjeiIsma9YMnf6/n2C4
         1sNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=4mRUe9k6N29Y8TY671ys1SOzt46CXKbNlnzYh7VBMGg=;
        b=WFxlVkW3f2BJlrfjlU9Vhb36h/ah4RlooGLFwyyIXxl0uwhrELn64TJ+xjmt6FWz8T
         yt7y24cQT160/LurP5xq4Oz7jGzN4/RkFjTzyaQbrScactNLNHO7eNj8W9nLnGfvG96I
         7HRgy2JYgBTQNucrahZ4X/EB/4hrSeNzm7AnoSp1/8qhfyD6DNkfGitvQvYqI9OKGS0X
         DAea0Xl2FaKY/gWcR3fPj0AkojnaEkwoVw9/LQ2ULDepDnSWUJ7ijTkVl/KxrjWXeqAJ
         SnbpEi+ffuPqzyoo6KCmUh4BXxbvPnpt0Fr0OivpgrvLr1kZv2+M7ZpjgZ2oQqaEWc45
         Xb6w==
X-Gm-Message-State: AJIora/NK0JlxUtQWs8uuIEfXnXDf6KfkWZo2N9IbsGgeyB+GfObFgAZ
        4Gj3Y1fioxRt9EQPniuvIMiKIRVdyqE=
X-Google-Smtp-Source: AGRyM1smbVwsZvafhg6YAk0nSxXgCOlfpSnfKN9p9HtlEhf/jQcGocWbnbcv1Ozn+bbDrtBXCdl//YT/YPo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d54b:b0:16b:eea4:77da with SMTP id
 z11-20020a170902d54b00b0016beea477damr15632782plf.45.1657926021275; Fri, 15
 Jul 2022 16:00:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 23:00:13 +0000
In-Reply-To: <20220715230016.3762909-1-seanjc@google.com>
Message-Id: <20220715230016.3762909-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220715230016.3762909-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH 1/4] KVM: x86: Reject loading KVM if host.PAT[0] != WB
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

Reject KVM if entry '0' in the host's IA32_PAT MSR is not programmed to
writeback (WB) memtype.  KVM subtly relies on IA32_PAT entry '0' to be
programmed to WB by leaving the PAT bits in shadow paging and NPT SPTEs
as '0'.  If something other than WB is in PAT[0], at _best_ guests will
suffer very poor performance, and at worst KVM will crash the system by
breaking cache-coherency expecations (e.g. using WC for guest memory).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f389691d8c04..12199c40f2bc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9141,6 +9141,7 @@ static struct notifier_block pvclock_gtod_notifier = {
 int kvm_arch_init(void *opaque)
 {
 	struct kvm_x86_init_ops *ops = opaque;
+	u64 host_pat;
 	int r;
 
 	if (kvm_x86_ops.hardware_enable) {
@@ -9179,6 +9180,20 @@ int kvm_arch_init(void *opaque)
 		goto out;
 	}
 
+	/*
+	 * KVM assumes that PAT entry '0' encodes WB memtype and simply zeroes
+	 * the PAT bits in SPTEs.  Bail if PAT[0] is programmed to something
+	 * other than WB.  Note, EPT doesn't utilize the PAT, but don't bother
+	 * with an exception.  PAT[0] is set to WB on RESET and also by the
+	 * kernel, i.e. failure indicates a kernel bug or broken firmware.
+	 */
+	if (rdmsrl_safe(MSR_IA32_CR_PAT, &host_pat) ||
+	    (host_pat & GENMASK(2, 0)) != 6) {
+		pr_err("kvm: host PAT[0] is not WB\n");
+		r = -EIO;
+		goto out;
+	}
+
 	r = -ENOMEM;
 
 	x86_emulator_cache = kvm_alloc_emulator_cache();
-- 
2.37.0.170.g444d1eabd0-goog

