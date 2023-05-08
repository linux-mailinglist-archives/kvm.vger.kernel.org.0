Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACC06FB439
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234527AbjEHPrv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234478AbjEHPro (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:47:44 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335A546B1
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:47:24 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-9659c5b14d8so756603166b.3
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560842; x=1686152842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1L1xoMwaMAqCyoSzSt4AhGEwqRQKjBIsHlRxClFZIMI=;
        b=WpaeCR5CJhFhLNyygPXAd6nAB3PZl3MeVPZPOTH8zg708fJpKt4rtBunqPiv03I52Q
         JevPqUODWZ2g3zjT2uz04oT9OTbWH5KIllBsTsecOaPZRBasvpHI/sII5YI6es6PlcNq
         JYaDd572YOOEkPUqogD2iyr0HNq1m3jDC65F/g1Kv8uk7Ruurr4B3DX969VVhi5tIb7j
         gqrrhqPg8yLrM/JueR73U0Oyr3yjtqhOeVwFMfMJFMEUSdUc8cTzo+490d0AGWWqlTOU
         5MpdeinP48ocRpXUjDSeMLNSRPtTQdECEA7OCTRttrjdgctBY7rxTpdsZ2Uq/dCb8xbp
         kRzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560842; x=1686152842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1L1xoMwaMAqCyoSzSt4AhGEwqRQKjBIsHlRxClFZIMI=;
        b=TroiX48IAv7XNxx8yZMO18lY+F16xKDkOkGjdOB/dYTb/r+CKa/CPU55bIo6AvrzDZ
         kryveuiWJ36/jfDTlaBcuvlq//D7lcDNuSAnCKbbncc0uNx+q/jILRuBuNBxGvoZFd0X
         +71eRUnQJZBZPL8SBGQtPlTHhddRtuOKic94xMcnz9QTunQGNHEEslfSCsMrgJHtUoWB
         0TR1C24116XVpKDeTY4MgcY40NOPUii1CBiXlLFfj2bnfnXtnQmGy0NQ1K0kX1+wCAZQ
         4K8FHQ+t1ozR0AoHu420PtcrtK5hgUatlb/ntKPTvdXcIoKkKAtpku/MQpvs/WXTjyr1
         7Nwg==
X-Gm-Message-State: AC+VfDwueZ3w6vacXuE0LFDehEsagblp/kVhGHXAHIjFjQp4Idq99hd7
        p2CiGjg+0gzS8e95qtZDfEXz8PyawzHxyKpaXaFsag==
X-Google-Smtp-Source: ACHHUZ4tPF4QyIMzbRXYhP3TpdrpjZXZkQSwnPbyAOICm5QtvDVhfZ0NNa1FQ0wPymYEBjT7BPCELw==
X-Received: by 2002:a17:907:3d86:b0:967:5c5f:e45c with SMTP id he6-20020a1709073d8600b009675c5fe45cmr2679075ejc.0.1683560842666;
        Mon, 08 May 2023 08:47:22 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id md1-20020a170906ae8100b0094b5ce9d43dsm121822ejb.85.2023.05.08.08.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:47:22 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Subject: [PATCH 5.15 5/8] KVM: X86: Don't reset mmu context when X86_CR4_PCIDE 1->0
Date:   Mon,  8 May 2023 17:47:06 +0200
Message-Id: <20230508154709.30043-6-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230508154709.30043-1-minipli@grsecurity.net>
References: <20230508154709.30043-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

[ Upstream commit 552617382c197949ff965a3559da8952bf3c1fa5 ]

X86_CR4_PCIDE doesn't participate in kvm_mmu_role, so the mmu context
doesn't need to be reset.  It is only required to flush all the guest
tlb.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210919024246.89230-2-jiangshanlai@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 arch/x86/kvm/x86.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 27900d4017a7..515033d01b12 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1081,9 +1081,10 @@ static bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 
 void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned long cr4)
 {
-	if (((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS) ||
-	    (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
+	if ((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS)
 		kvm_mmu_reset_context(vcpu);
+	else if (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE))
+		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_post_set_cr4);
 
-- 
2.39.2

