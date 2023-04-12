Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374D56E00FF
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 23:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbjDLVfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 17:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjDLVf2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 17:35:28 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06C676A6
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 14:35:26 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v200-20020a252fd1000000b00b8f548a72bbso862051ybv.9
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 14:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681335326; x=1683927326;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j57tzoPl16sC9ByxrSzcSJpXXHgYa+UwHfuGAFzOM3I=;
        b=hPL8324f0dvuI9qEQzWCYrweNFqgGmr995W+iPkc+3GRVTRuBih5b/Tk+omn/cNuoJ
         QJdd85nlJ+8gvBlpPMGC2W5MkTQLs/SUWLfnjqPap4MmVSGebtW35hwDOjZMMG8REtua
         /lSLjpb4oFMt1H05FLzLPNItsS8aB/fITd6xVpVMffErvEaAjrQWdlIKMqUdcPA/heHg
         VoN+2vk5kF95IclXeJ7opZl6vuf12QAxytef0yL5vmQDLvQICDV+IE0uA8hk6P6YyXbR
         8T1OpFbeK2s2/ufzJ+ZIT92Ohgl6rhkbVKN2MsQE2rgAtc+yORcHLQWC9t+kfbYn1oae
         i8tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335326; x=1683927326;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j57tzoPl16sC9ByxrSzcSJpXXHgYa+UwHfuGAFzOM3I=;
        b=M65Hp8Ox/1/Oyc8wiUCBg0vuVIUJR2zCQ/O/f5fiiTIbU8p2vjiIvA2jmsAUG9E0IR
         Dqh5zLVUEQkpEySBAMP5p+1qAT0QjMW94Jasy27hwvZchbS7nKGjLQeHoTgT1us4har7
         HZTdS65DySfFO/QjMSPikH8sm+k2XD2czNdrYP+vQbFtjKEPuouWRSo/L6ZDu9z2e44W
         NbIysZgQVLxi5ntOSPSdOj2SO7/lorjmdlqcoUD7WQcecyV9m+IFlFqYKSmxnJ1VkhCJ
         V/A6TpoWLhAeoYUj4mtj9I2b3t7d6sJ/2k7pKNiDQE2PP7jOsm+Dw+Lk83u7YHsn92JW
         8T1g==
X-Gm-Message-State: AAQBX9cFtBc4kv5r3U9qZ6z8sEjLku8LBxYg1E9NHScp8hCg14HPfdDa
        72jEAi/tk+RmS2IcLlgrG3IOczvqvqu/Bg==
X-Google-Smtp-Source: AKy350YnELcVqu3F38lVRb+xr7cHeJqZPpveoy9dsreWoQEbFvuQJOfQLeL37xkM4q0cAPIFSLawdQnrHh266A==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a81:4319:0:b0:545:62cb:3bcf with SMTP id
 q25-20020a814319000000b0054562cb3bcfmr12058ywa.2.1681335326021; Wed, 12 Apr
 2023 14:35:26 -0700 (PDT)
Date:   Wed, 12 Apr 2023 21:35:00 +0000
In-Reply-To: <20230412213510.1220557-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230412213510.1220557-13-amoorthy@google.com>
Subject: [PATCH v3 12/22] KVM: x86: Annotate -EFAULTs from kvm_handle_page_fault()
From:   Anish Moorthy <amoorthy@google.com>
To:     pbonzini@redhat.com, maz@kernel.org
Cc:     oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com,
        amoorthy@google.com, bgardon@google.com, dmatlack@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
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

Implement KVM_CAP_MEMORY_FAULT_INFO for -EFAULTs caused by
kvm_handle_page_fault().

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7391d1f75149d..937329bee654e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4371,8 +4371,11 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 
 #ifndef CONFIG_X86_64
 	/* A 64-bit CR2 should be impossible on 32-bit KVM. */
-	if (WARN_ON_ONCE(fault_address >> 32))
+	if (WARN_ON_ONCE(fault_address >> 32)) {
+		kvm_populate_efault_info(vcpu, round_down(fault_address, PAGE_SIZE),
+								 PAGE_SIZE);
 		return -EFAULT;
+	}
 #endif
 
 	vcpu->arch.l1tf_flush_l1d = true;
-- 
2.40.0.577.gac1e443424-goog

