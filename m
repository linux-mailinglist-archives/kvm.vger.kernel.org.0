Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7C95624058
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 11:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiKJKu6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 05:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiKJKut (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 05:50:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D77611C04
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 02:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668077392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HmEjMGKRiSLAThTLqtDmoaFom/cHpQ3vOA926P7l/34=;
        b=a73S8X8UIQJAxuXJK8jb98ZOn7UgolewENZkJ8gK4YNkzxWjCe6bJ4BzGnE26QaVP4L0M4
        JleqJk6KJLasHBNeosymYkeDxi4uwl/2AcSwimj7tHtAkwKrn4LL8Xhy7HF0vH8Kr9SEGR
        EPaIp1wzeX5yBFC+fWe/bD7ZhSH5G2U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-154-ft8dNLtPOs-Ig0GLOagbpg-1; Thu, 10 Nov 2022 05:49:48 -0500
X-MC-Unique: ft8dNLtPOs-Ig0GLOagbpg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DCB061C09B72;
        Thu, 10 Nov 2022 10:49:47 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-49.bne.redhat.com [10.64.54.49])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A70C1415114;
        Thu, 10 Nov 2022 10:49:41 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, maz@kernel.org,
        seanjc@google.com, shuah@kernel.org, catalin.marinas@arm.com,
        andrew.jones@linux.dev, ajones@ventanamicro.com,
        bgardon@google.com, dmatlack@google.com, will@kernel.org,
        suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com, peterx@redhat.com, oliver.upton@linux.dev,
        zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: [PATCH v10 2/7] KVM: Move declaration of kvm_cpu_dirty_log_size() to kvm_dirty_ring.h
Date:   Thu, 10 Nov 2022 18:49:09 +0800
Message-Id: <20221110104914.31280-3-gshan@redhat.com>
In-Reply-To: <20221110104914.31280-1-gshan@redhat.com>
References: <20221110104914.31280-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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

