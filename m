Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07DF44C0C12
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238282AbiBWF1c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238418AbiBWF0y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:26:54 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BBC6BDE2
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:22 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2d07ae1145aso162074087b3.4
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Kqez4sz2gXA92s/yKdI0Sadgd/VKyd58nC75f61sH3c=;
        b=kY6HPVZ5+V/4ADSj5gTm7IQPleGSUbrDBXkArXIMxRp8wv39Fiygf+bF+YqLodOTpp
         AZsLSr13DzroNgqyc8IDfXzcQUL9DyFnAH4zuxHj+73S9iVBPAI2bhK64r7+IZ9iPw2j
         l6U45p4hnLVXIe3HFpHe4qJp9mEpOsCgXDx6xEMFZlJGN4bxSQMLkshnkvHzcWhTYszS
         3RalZYOgTpQ3xR1RbA6oUKLNH9FzKB/Oq6geEXx6xglDHFlrVYGZZaZlqsNdHMvuOFaS
         qOuzTGhwZjX65TLhLW2uhuxlSD1GB251cNcp9nHh4Mb+0b/OHXDC3ll2brbPttKVPhId
         WuIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Kqez4sz2gXA92s/yKdI0Sadgd/VKyd58nC75f61sH3c=;
        b=0IHfklyOYvERuCvKcrLwM5tSWU6tdZYszVJ34LXb6edAkDn+JwcxMYK5AThY17sc+j
         ZwnscXl1gsBI/dvbKCHgITruDUdE4Fwr7l8wqyoQMjtluB27T1M9CZhq6Hek8UHZRyhL
         gq2rCGgXLB3ahCSjEBU5UMEq7kkKoS8jy9gniv3BXA1OIXthLmnsMSYfbbbdlE76lgzo
         7RMSkFTHA1hItco8uy53BZgHHJd1H4Zg5AeZRN7ChDUaWggRrPhQ2iYnZMNJLnBRW3Kr
         I+7Z7/IA9+5FthWGdXIgOcFa/hVpriRncslDBIVsPHKrwv5PSL6BCgkvIsol8qAXeT20
         E3+Q==
X-Gm-Message-State: AOAM530UUyCQDUWyPqJmSnUuGi2XN01n01SXrHAlkGtmBwPoRbhh6POR
        RegQvYXg0Cl4i4mVCkqL9zdRU4okp9Q/
X-Google-Smtp-Source: ABdhPJwRpDGu9uCaO7SUVy/qucopgnc8bRss4/HLiRU4Az2YJmA6Oz65Xuo4RY/0idM9yle+QHSTEPNKFl9M
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a25:34c9:0:b0:623:fc5f:b98 with SMTP id
 b192-20020a2534c9000000b00623fc5f0b98mr27190113yba.195.1645593912355; Tue, 22
 Feb 2022 21:25:12 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:22:15 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-40-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 39/47] mm: asi: Skip conventional L1TF/MDS mitigations
From:   Junaid Shahid <junaids@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     Ofir Weisse <oweisse@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com, pjt@google.com,
        alexandre.chartre@oracle.com, rppt@linux.ibm.com,
        dave.hansen@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, luto@kernel.org, linux-mm@kvack.org
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

From: Ofir Weisse <oweisse@google.com>

If ASI is enabled for an mm, then the L1D flushes and MDS mitigations
will be taken care of ASI. We check if asi is enabled by checking
current->mm->asi_enabled. To use ASI, a cgroup flag must be set before
the VM process is forked - causing a flag mm->asi_enabled to be set.

Signed-off-by: Ofir Weisse <oweisse@google.com>


---
 arch/x86/kvm/vmx/vmx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e0178b57be75..6549fef39f2b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6609,7 +6609,11 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 
 	kvm_guest_enter_irqoff();
 
-	vmx_flush_sensitive_cpu_state(vcpu);
+        /* If Address Space Isolation is enabled, it will take care of L1D
+         * flushes, and will also mitigate MDS. In other words, if no ASI -
+         * flush sensitive cpu state. */
+        if (!static_asi_enabled() || !mm_asi_enabled(current->mm))
+                vmx_flush_sensitive_cpu_state(vcpu);
 
 	asi_enter(vcpu->kvm->asi);
 
-- 
2.35.1.473.g83b2b277ed-goog

