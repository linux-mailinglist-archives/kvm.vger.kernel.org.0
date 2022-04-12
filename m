Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFCDC4FDDEA
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 13:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348378AbiDLL1W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 07:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352827AbiDLLZm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 07:25:42 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1142C135
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 03:08:39 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id q142so16775362pgq.9
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 03:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5aKqoFa3PS3ofFsonmsRpILD1LHcN5f7ZDBzSGfsEbM=;
        b=ipNGq4iM0/5nlKBcJA0RfUYvp9Rr6U2GBDVhfGzDbwMM7QRqxO3tkO71gzVyoaVmyw
         pxYq72frVesdN580nWmwdlgZjtdbjkHgDPRknZvPvC77QqSIPucZ3kzcs1iduI71F9VD
         CJuegbEDoSDKgK4VR/rjXyqXmEcsk2DgX+ILLvm86Q0Bh1BaVgux/GspmTOI+cb5pEjI
         pxDAf5zVkqsYVX2BwgHBGLurHEQXOUE2Thu28cfE0yA5NfkFaKHm2Tj7ynpHHaMVos5Q
         eeaNbwd5u3GbYkrSh8PslJkhe7B1bvA14msLKO6BZE18MLW3Iuwk3h3bp1834tybWMuk
         CGHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5aKqoFa3PS3ofFsonmsRpILD1LHcN5f7ZDBzSGfsEbM=;
        b=Oef094i9Fvn0YDoAV5K2V4z05OttR5wUojFny2gUUgLKxiUph2uFZHUFmXcnJrCtR+
         k406TgkpeP2eB35p6RzNKT/qzmZ5RUp+QF+w+Duvx2zztMiqaqjcvKXGbvH+Xr6OBb+c
         pvDKozKvbEEgTb9GOR7s5zvONUof16DczkMnpOLc5b8q/kDAmY+XT2XzpqxQi1PE1ALK
         MfUfcmRLxdoancTFvYeMMlbYe44JgC9E9hyY5EO43aM7k46sd6yYVsDrkCMpFp0nSNMx
         ErLj8JrV41KOeESZEbco0mrkkOTC1j5JAo8bdrhPUjcVGl/O1woy0eLRmtvo0wVc/awr
         SCww==
X-Gm-Message-State: AOAM532YuMI7t+hz4qYNPn5oms2fJctxiRbs10sqbI7D5QaN+ZgaYO6L
        qq519FGLn54ZoG3drRLnGmI1+w==
X-Google-Smtp-Source: ABdhPJwMUMajCWSxEXnVkYfknKU+dGYsenmvrM0qkhhwA3pG3r6bUDiyxS+dtaTDRrgSBmM0/+q7sg==
X-Received: by 2002:aa7:88ca:0:b0:505:d092:16c8 with SMTP id k10-20020aa788ca000000b00505d09216c8mr6642112pff.22.1649758119472;
        Tue, 12 Apr 2022 03:08:39 -0700 (PDT)
Received: from localhost.localdomain ([122.182.197.47])
        by smtp.gmail.com with ESMTPSA id j9-20020a056a00130900b004f73df40914sm37515088pfu.82.2022.04.12.03.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 03:08:38 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 3/6] RISC-V: KVM: Treat SBI HFENCE calls as NOPs
Date:   Tue, 12 Apr 2022 15:37:10 +0530
Message-Id: <20220412100713.1415094-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412100713.1415094-1-apatel@ventanamicro.com>
References: <20220412100713.1415094-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We should treat SBI HFENCE calls as NOPs until nested virtualization
is supported by KVM RISC-V. This will help us test booting a hypervisor
under KVM RISC-V.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_sbi_replace.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
index 0f217365c287..3c1dcd38358e 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -117,7 +117,11 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 	case SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA_VMID:
 	case SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA:
 	case SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA_ASID:
-	/* TODO: implement for nested hypervisor case */
+		/*
+		 * Until nested virtualization is implemented, the
+		 * SBI HFENCE calls should be treated as NOPs
+		 */
+		break;
 	default:
 		ret = -EOPNOTSUPP;
 	}
-- 
2.25.1

