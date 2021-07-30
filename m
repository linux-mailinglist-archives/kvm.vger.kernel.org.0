Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41CA53DC0C0
	for <lists+kvm@lfdr.de>; Sat, 31 Jul 2021 00:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbhG3WFN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 18:05:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20583 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232978AbhG3WFJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Jul 2021 18:05:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627682703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FfXjy58FasEdIFi4ZWT72LgLttnZ5Iij0BOop3iMW7A=;
        b=HP3UC0P5LFqQAccVzSJKwe+lggWCjHQrT4kuug+KlsoxmSF1FF6kT10hhUkESmGvtGdV3t
        b8qq5iE8YwjePg807/d5NcBpVmEx3CnP2GoeYDjLLUO2RTgVdJrL0NhWR5PIhKQZUTIxFi
        7LURc1cI5bX+NvIMs1QIb7uhkREdw3Y=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-IjTtpinnMkeY83tx9rbMdQ-1; Fri, 30 Jul 2021 18:05:02 -0400
X-MC-Unique: IjTtpinnMkeY83tx9rbMdQ-1
Received: by mail-qt1-f200.google.com with SMTP id v7-20020ac874870000b029024e8ccfcd07so5125668qtq.11
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:05:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FfXjy58FasEdIFi4ZWT72LgLttnZ5Iij0BOop3iMW7A=;
        b=lb6cRyV5yhfa59RQYhqd3TxIYKyvl1C+uAz79XzZfnHuowqZcok8+xCqTQSNtk/ZdE
         p+/zflhzhp2cmcIV8TF69PZUjzbECi/xFgIuWgX8BNMAEx6rSEILAFjHvahQVGPnWW5g
         Ejj83wI6AMZoMJ8K4EO5c5g/6LCLRdtlBL9xlPVlS8BRh0HMW/wsfmt/t/SufFGl3joz
         sg5wc17BNFtSD9D3pFSXx+OuClNR2D1uiaZaX3zrkqBuASiNMegJS6rgSLl1uxOGtOMX
         GGSfB9fDn2LyDzeyO4U/UaoDtCQTZOHutdgXuYrm2sqefkEHNKI+hZkBCejwehW/geKq
         2BKg==
X-Gm-Message-State: AOAM532Qj10Van7YuQI3XiUG6rjimtMpCLii9j+s0ubAAYKw4P9kWL9M
        +Fa2AjULAhLMqEp6OJpHen1CVgXykbPzmqp9fCkcLtUlOU13okibSH1NFJ6Dxq8c3vN8fWyRPJa
        I4rrnLeJWC+sj4c0pRMwPtwwBkLwTZPJOmVXvvDIeJCPk+xXbWvNNa4MeRLyaCA==
X-Received: by 2002:ad4:59c6:: with SMTP id el6mr5069441qvb.61.1627682702055;
        Fri, 30 Jul 2021 15:05:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyH4DMk7eOeaMahyezhFuknnvxsQN34SBZyghGosNbzTWVGxLOwL+A9XhXocD3T6vS3E8BoDA==
X-Received: by 2002:ad4:59c6:: with SMTP id el6mr5069414qvb.61.1627682701786;
        Fri, 30 Jul 2021 15:05:01 -0700 (PDT)
Received: from t490s.. (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id l12sm1199651qtx.45.2021.07.30.15.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 15:05:00 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>, peterx@redhat.com,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 3/7] KVM: X86: Introduce kvm_mmu_slot_lpages() helpers
Date:   Fri, 30 Jul 2021 18:04:51 -0400
Message-Id: <20210730220455.26054-4-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210730220455.26054-1-peterx@redhat.com>
References: <20210730220455.26054-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce kvm_mmu_slot_lpages() to calculcate lpage_info and rmap array size.
The other __kvm_mmu_slot_lpages() can take an extra parameter of npages rather
than fetching from the memslot pointer.  Start to use the latter one in
kvm_alloc_memslot_metadata().

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/x86.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 916c976e99ab..e44d8f7781b6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -299,6 +299,20 @@ static struct kmem_cache *x86_fpu_cache;
 
 static struct kmem_cache *x86_emulator_cache;
 
+static inline unsigned long
+__kvm_mmu_slot_lpages(struct kvm_memory_slot *slot, unsigned long npages,
+		      int level)
+{
+	return gfn_to_index(slot->base_gfn + npages - 1,
+			    slot->base_gfn, level) + 1;
+}
+
+static inline unsigned long
+kvm_mmu_slot_lpages(struct kvm_memory_slot *slot, int level)
+{
+	return __kvm_mmu_slot_lpages(slot, slot->npages, level);
+}
+
 /*
  * When called, it means the previous get/set msr reached an invalid msr.
  * Return true if we want to ignore/silent this failed msr access.
@@ -11443,8 +11457,7 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
 		int lpages;
 		int level = i + 1;
 
-		lpages = gfn_to_index(slot->base_gfn + npages - 1,
-				      slot->base_gfn, level) + 1;
+		lpages = __kvm_mmu_slot_lpages(slot, npages, level);
 
 		linfo = kvcalloc(lpages, sizeof(*linfo), GFP_KERNEL_ACCOUNT);
 		if (!linfo)
-- 
2.31.1

