Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60C64FC65A
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 23:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350117AbiDKVNN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 17:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350071AbiDKVNI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 17:13:08 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E7C2AE24
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 14:10:48 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id l3-20020a170903244300b001570540beb6so5012362pls.16
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 14:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5tb57VTUj7RznBKumT5V0V4sQN1PJknWB+EFTfgC840=;
        b=RMCbNHtoYWPcEkJzuzyfXlxy2zAVP1QniIXjlRQ/38Vf2MAk8bUqhhZQQ1rfRgEkN7
         iBFVV//DIZhLtJpSOZXjJ463UdO0OZlGKCrMUGuNiBlxc/9oDmHZoJ5AeLpxVtqcsDEZ
         QpuapmLzielQA8/GeJdvDYqEO3BUf3yi+4PjGRwolGhc8rGoreBldynhMPodiOanCNPK
         ioUbvaqNl6AceqrQGv17BhinSlaxCrUMttGzCVQuokjdno0ZOX1AwgSon2157QhmzM/b
         gHOQWXUaE84GKJI2CKpFBaC2wYJfzlWtofn/faxjtVxMZaE2/HA2+ewIr8M+DoGtFrCH
         ZtBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5tb57VTUj7RznBKumT5V0V4sQN1PJknWB+EFTfgC840=;
        b=RHiByTrkO4+8IkXwWDG5MgbHwcNlyS/jj1ZFYDEJyrTLzDmnpF/9B+vCLCYu+StIrf
         ssR632f67j5MBZpY9W+s2twzd/msHJ6mKl70JGtrzOCd3HbDShMddvxaHU7M0WMw7ePU
         N1NaQ/ny5C42SrBNkWfh3tizRiq1NFUYEATVYknfdk+Dv4nU8p78m6yxRMBjOp3mM6JV
         8iBvRanoL7WIn66h/qf722ozCVd+w90D1i8YWvm8Cec8m4A7Bfdv2VCeXDyCtEUSPFNB
         UBrueK7jjhOwCDbi1bB54dXpZHxdn5943WQ2cGNkWKBYBW1FpBFgrcQuAjx9Ox4NDAKu
         jM5Q==
X-Gm-Message-State: AOAM5306lVrMpZQK8LnQ/RQnx//f5xZcRvajRJXXXXWiBSvI9908/oHT
        veZjEQVu9u1Ifx88Nk4lOoQjCUAX2kYR
X-Google-Smtp-Source: ABdhPJxsL6DdyjLp5LTJtC5jEC9w+gspSh7pE1TloQ0jtcg6QxneuVU1IA0CrHD2zbY1tajWnb1t8UWE1G8x
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:a2d0:faec:7d8b:2e0b])
 (user=bgardon job=sendgmr) by 2002:a17:902:d5ce:b0:158:48db:9719 with SMTP id
 g14-20020a170902d5ce00b0015848db9719mr10966080plh.7.1649711447424; Mon, 11
 Apr 2022 14:10:47 -0700 (PDT)
Date:   Mon, 11 Apr 2022 14:10:11 -0700
In-Reply-To: <20220411211015.3091615-1-bgardon@google.com>
Message-Id: <20220411211015.3091615-7-bgardon@google.com>
Mime-Version: 1.0
References: <20220411211015.3091615-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v4 06/10] KVM: x86/MMU: Factor out updating NX hugepages state
 for a VM
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Dunn <daviddunn@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Factor out the code to update the NX hugepages state for an individual
VM. This will be expanded in future commits to allow per-VM control of
Nx hugepages.

No functional change intended.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 69a30d6d1e2b..caaa610b7878 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6144,6 +6144,15 @@ static void __set_nx_huge_pages(bool val)
 	nx_huge_pages = itlb_multihit_kvm_mitigation = val;
 }
 
+static void kvm_update_nx_huge_pages(struct kvm *kvm)
+{
+	mutex_lock(&kvm->slots_lock);
+	kvm_mmu_zap_all_fast(kvm);
+	mutex_unlock(&kvm->slots_lock);
+
+	wake_up_process(kvm->arch.nx_lpage_recovery_thread);
+}
+
 static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 {
 	bool old_val = nx_huge_pages;
@@ -6166,13 +6175,9 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 
 		mutex_lock(&kvm_lock);
 
-		list_for_each_entry(kvm, &vm_list, vm_list) {
-			mutex_lock(&kvm->slots_lock);
-			kvm_mmu_zap_all_fast(kvm);
-			mutex_unlock(&kvm->slots_lock);
+		list_for_each_entry(kvm, &vm_list, vm_list)
+			kvm_update_nx_huge_pages(kvm);
 
-			wake_up_process(kvm->arch.nx_lpage_recovery_thread);
-		}
 		mutex_unlock(&kvm_lock);
 	}
 
-- 
2.35.1.1178.g4f1659d476-goog

