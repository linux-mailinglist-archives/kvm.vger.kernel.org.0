Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04935F4D1F
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 02:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiJEAns (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 20:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiJEAnr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 20:43:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7F75EDF1
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 17:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664930625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OxezRVUr9qvTxCa+BV2hj9fEMMA7fVFANs6SsCeL2BI=;
        b=NAGZSlvSNflCkmEf4hAB6O1gbtZJ4deUePcMaYsf/KafR+wHZ9iu/ndZsMMWFUkUZm7O1Z
        dxfCtX4KICV3rUdRu1s1kgm+GJmcVaqetA9GaTFXnJhId9xfyy1u+nlhRKEfAh/ggWrPVH
        if5tmitl0WvyooGQfIt1QuvaIMu7vvg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-360-xV5jDXayMfixpF9DM3uGVg-1; Tue, 04 Oct 2022 20:43:42 -0400
X-MC-Unique: xV5jDXayMfixpF9DM3uGVg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD938380114C;
        Wed,  5 Oct 2022 00:43:38 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-56.bne.redhat.com [10.64.54.56])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0524F35429;
        Wed,  5 Oct 2022 00:43:19 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        peterx@redhat.com, catalin.marinas@arm.com, bgardon@google.com,
        shuah@kernel.org, andrew.jones@linux.dev, will@kernel.org,
        dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev,
        seanjc@google.com, shan.gavin@gmail.com
Subject: [PATCH v5 2/7] KVM: x86: Move declaration of kvm_cpu_dirty_log_size() to kvm_dirty_ring.h
Date:   Wed,  5 Oct 2022 08:41:49 +0800
Message-Id: <20221005004154.83502-3-gshan@redhat.com>
In-Reply-To: <20221005004154.83502-1-gshan@redhat.com>
References: <20221005004154.83502-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index aa381ab69a19..f11b6a9388b5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2083,8 +2083,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
 #define GET_SMSTATE(type, buf, offset)		\
 	(*(type *)((buf) + (offset) - 0x7e00))
 
-int kvm_cpu_dirty_log_size(void);
-
 int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 
 #define KVM_CLOCK_VALID_FLAGS						\
diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
index 66508afa0b40..fe5982b46424 100644
--- a/include/linux/kvm_dirty_ring.h
+++ b/include/linux/kvm_dirty_ring.h
@@ -66,6 +66,7 @@ static inline void kvm_dirty_ring_free(struct kvm_dirty_ring *ring)
 
 #else /* CONFIG_HAVE_KVM_DIRTY_RING */
 
+int kvm_cpu_dirty_log_size(void);
 u32 kvm_dirty_ring_get_rsvd_entries(void);
 int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size);
 
-- 
2.23.0

