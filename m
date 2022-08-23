Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8089C59CD65
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 02:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239165AbiHWAqx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 20:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239144AbiHWAqu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 20:46:50 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5F14CA35
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 17:46:47 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id a19-20020aa780d3000000b0052bccd363f8so5237014pfn.22
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 17:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=5wbHjJjCu3OWrOn0g8QSFmD92QscX6sNHkdnPnrNJvc=;
        b=GGOXmJOAwFS6LKwoOWp4bp7t6wNw/r+7YZKC8GNGkd18DnlB6LfP9CL34RL2KPfceG
         AXZl8PPfPtapEOLbCmJ/rNGm5f6yciTGJoywKkjojZNxw+GL1YEMWcjzDhmGBCk/MdMy
         4t7Q1LoMp7rN7dy2pMFqxMAJGP7jixHUwhGq1q/8ObLjXUCDxT+pRv0n8APeUo1COdXm
         hZwjDYvOa5gy4NpGGIl+jhzRr9f9Ii2wUpWXASQIPm5HwhVrZhUzyQI6uum045xl3TUP
         3jXo+RDzJG2rD4y1NqG9xsCTA/WKZF3fW3AxCEi9F87GMBLRezoaX2KOatGvk8ccetqZ
         Mr+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=5wbHjJjCu3OWrOn0g8QSFmD92QscX6sNHkdnPnrNJvc=;
        b=cyHNZwyTbzvoKNXmJ/1gOHmDqF6+bh3gZWXkZ5jwY/sZiATAkkLnaRCeCElPsYBhUu
         9gqbvMIrxBjKTB5i9tZWI2u9/JsqvjRmID4IxCQL02l906iREEK8JLnupv1WWn1AcRex
         NufM743RTYLISm13Kfo8a929QUJ4xx0DEhDQPqPNr3VQQ7B5zLL3bL/w9fEg3Kt31X2b
         Zbr92d6w0WovbFshAmhTGL5a8M8wPczValnKXj/mL3w6elePGC+q3JT4ftdZgYwxye2p
         Q24slGa0b7/g67G5H75i6tBNA8ER469CyJ9yVNAOSa6bcXX+cFmDnNiA88f0PJ6SuIoi
         yV9Q==
X-Gm-Message-State: ACgBeo3UZenpxOnLqVc3k5Ntu8XaG4LNi+lrsIW+GrEl6vkMdxApkbT8
        tdB+TS4CtYrRKiU5xP7ZugQ69cvL6DqJsOkJ
X-Google-Smtp-Source: AA6agR4dQrwU/uwhH/YBd8bM5leaexCVvoGHCx2rlR/Vt0DcZKu7/ZnqA8s5ncAFX9MqU3Pk76hGv0BKG2GC/oz4
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a05:6a00:15cb:b0:52e:6100:e7a7 with
 SMTP id o11-20020a056a0015cb00b0052e6100e7a7mr22724154pfu.23.1661215606877;
 Mon, 22 Aug 2022 17:46:46 -0700 (PDT)
Date:   Tue, 23 Aug 2022 00:46:37 +0000
In-Reply-To: <20220823004639.2387269-1-yosryahmed@google.com>
Message-Id: <20220823004639.2387269-3-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220823004639.2387269-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v7 2/4] KVM: mmu: add a helper to account memory used by KVM MMU.
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Oliver Upton <oupton@google.com>
Cc:     Huang@google.com, Shaoqin <shaoqin.huang@intel.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        Yosry Ahmed <yosryahmed@google.com>
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

Add a helper to account pages used by KVM for page tables in memory
secondary pagetable stats. This function will be used by subsequent
patches in different archs.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Marc Zyngier <maz@kernel.org>
---
 include/linux/kvm_host.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f4519d3689e1..04c7e5f2f727 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2247,6 +2247,19 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
 
+/*
+ * If more than one page is being (un)accounted, @virt must be the address of
+ * the first page of a block of pages what were allocated together (i.e
+ * accounted together).
+ *
+ * kvm_account_pgtable_pages() is thread-safe because mod_lruvec_page_state()
+ * is thread-safe.
+ */
+static inline void kvm_account_pgtable_pages(void *virt, int nr)
+{
+	mod_lruvec_page_state(virt_to_page(virt), NR_SECONDARY_PAGETABLE, nr);
+}
+
 /*
  * This defines how many reserved entries we want to keep before we
  * kick the vcpu to the userspace to avoid dirty ring full.  This
-- 
2.37.1.595.g718a3a8f04-goog

