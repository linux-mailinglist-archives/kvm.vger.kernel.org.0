Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 759A177D0C8
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 19:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238755AbjHORTn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 13:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238707AbjHORTN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 13:19:13 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0517B1BCD;
        Tue, 15 Aug 2023 10:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692119951; x=1723655951;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IOB6egI1P24F5biT3CsDzSkUO+xJDoBD1NOa36eza/w=;
  b=KZA55ttxImdfat01Tx3P5+QAA6gpaQlO4e6dXN0lRmWXdZGJi5BflaIX
   x5aBEoyn3fWUi9O5D+tfS23Kv/g/0Q0Zho9GaCPJYmNIgIytMl83BloUl
   3YxzYBvFAcLV5wQHQZCbuR3pWAtLR/21tMq1p8NhsA3EHp2Qm4xiL4MSj
   gYoy6o3dE4Ifv9S7CRxxJ5KK/j0hMXlWIYfxSSeimQVO9IA6iKw30zBG4
   Z9GJxjCTXDAHJqYLUlF3wM1oGcTxEzFtCaueLI/jjwh8JOGJdj/OH1q0p
   d9Srq/woilkkJz0XUDh2VZTopE5t3K3IjnJ9Gytwo9F4FbKIHcZsWNAvc
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="436229847"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="436229847"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 10:19:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="907693407"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="907693407"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 10:19:07 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>
Subject: [PATCH 7/8] KVM: gmem: Avoid race with kvm_gmem_release and mmu notifier
Date:   Tue, 15 Aug 2023 10:18:54 -0700
Message-Id: <c3128665745b58500f71f46db6969d02cabcc8db.1692119201.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1692119201.git.isaku.yamahata@intel.com>
References: <cover.1692119201.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add slots_lock around kvm_flush_shadow_all().  kvm_gmem_release() via
fput() and kvm_mmu_notifier_release() via mmput() can be called
simultaneously on process exit because vhost, /dev/vhost_{net, vsock}, can
delay the call to release mmu_notifier, kvm_mmu_notifier_release() by its
kernel thread.  Vhost uses get_task_mm() and mmput() for the kernel thread
to access process memory.  mmput() can defer after closing the file.

kvm_flush_shadow_all() and kvm_gmem_release() can be called simultaneously.
With TDX KVM, HKID releasing by kvm_flush_shadow_all() and private memory
releasing by kvm_gmem_release() can race.  Add slots_lock to
kvm_mmu_notifier_release().

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 virt/kvm/kvm_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 49380cd62367..4855d0b7a859 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -927,9 +927,16 @@ static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	int idx;
 
+	/*
+	 * Avoide race with kvm_gmem_release().
+	 * This function is called via mmu notifier, mmu_release().
+	 * kvm_gmem_release() is called via fput() on process exit.
+	 */
+	mutex_lock(&kvm->slots_lock);
 	idx = srcu_read_lock(&kvm->srcu);
 	kvm_flush_shadow_all(kvm);
 	srcu_read_unlock(&kvm->srcu, idx);
+	mutex_unlock(&kvm->slots_lock);
 }
 
 static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
-- 
2.25.1

