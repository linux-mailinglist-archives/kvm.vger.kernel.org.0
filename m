Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83F12620818
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 05:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbiKHENl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 23:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233240AbiKHENc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 23:13:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFDD1B9C6
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 20:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667880755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HmEjMGKRiSLAThTLqtDmoaFom/cHpQ3vOA926P7l/34=;
        b=LNKalIFS+CKAP0Sw2P0yKLQ8yLk5f1mQO9H3MJoN8FZV24fIK0oGbfU5CtLe4hWXAA4Bwr
        3wgmeeZfAngMZFAbWpCbXiJA3seJ8ipLi69k/iyD8dZjGHnl35KhDMYPrzxpYg7DJqa0FY
        +Yak3ML/8W5OneSiif0oBZid/EoMV4E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-9L2SkMYkN6GXuR7UDn8spw-1; Mon, 07 Nov 2022 23:12:30 -0500
X-MC-Unique: 9L2SkMYkN6GXuR7UDn8spw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 864C529AA3BA;
        Tue,  8 Nov 2022 04:12:29 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-78.bne.redhat.com [10.64.54.78])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 20E1435429;
        Tue,  8 Nov 2022 04:12:22 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        shuah@kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
        ajones@ventanamicro.com, bgardon@google.com, dmatlack@google.com,
        will@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com, maz@kernel.org, peterx@redhat.com,
        oliver.upton@linux.dev, seanjc@google.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com
Subject: [PATCH v9 2/7] KVM: Move declaration of kvm_cpu_dirty_log_size() to kvm_dirty_ring.h
Date:   Tue,  8 Nov 2022 12:10:34 +0800
Message-Id: <20221108041039.111145-3-gshan@redhat.com>
In-Reply-To: <20221108041039.111145-1-gshan@redhat.com>
References: <20221108041039.111145-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Not all architectures like ARM64 need to override the function. Move
its declaration to kvm_dirty_ring.h to avoid the following compiling
warning on ARM64 when the feature is enabled.

  arch/arm64/kvm/../../../virt/kvm/dirty_ring.c:14:12:        \
  warning: no previous prototype for 'kvm_cpu_dirty_log_size' \
  [-Wmissing-prototypes]                                      \
  int __weak kvm_cpu_dirty_log_size(void)

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 2 --
 include/linux/kvm_dirty_ring.h  | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7551b6f9c31c..b4dbde7d9eb1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2090,8 +2090,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
 #define GET_SMSTATE(type, buf, offset)		\
 	(*(type *)((buf) + (offset) - 0x7e00))
 
-int kvm_cpu_dirty_log_size(void);
-
 int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 
 #define KVM_CLOCK_VALID_FLAGS						\
diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
index 9c13c4c3d30c..199ead37b104 100644
--- a/include/linux/kvm_dirty_ring.h
+++ b/include/linux/kvm_dirty_ring.h
@@ -66,6 +66,7 @@ static inline void kvm_dirty_ring_free(struct kvm_dirty_ring *ring)
 
 #else /* CONFIG_HAVE_KVM_DIRTY_RING */
 
+int kvm_cpu_dirty_log_size(void);
 u32 kvm_dirty_ring_get_rsvd_entries(void);
 int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size);
 
-- 
2.23.0

