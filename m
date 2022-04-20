Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 997C65086E1
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 13:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378014AbiDTL2D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 07:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378009AbiDTL2B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 07:28:01 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987826433
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 04:25:15 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id t13so1332468pgn.8
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 04:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5aKqoFa3PS3ofFsonmsRpILD1LHcN5f7ZDBzSGfsEbM=;
        b=XQt2qNB5u6pQxEF1HwDnEhc6NcPf+VkZSZq4w0mIY/jogwXW+sK8aZ+cXC1l/ZoHHU
         YGJJ0QjeSA8J/aP2zERHCpNEU3ZfqCQbGxKungKtD9r+4XedTyeDSfRcUxooSnaWKFZL
         gmBkBO0EgiRISNHALM9twlHmgO13HJIMrXTzGyTt3t9Zq1+0HHINUA5lb9iti/692dK7
         XNwIASZYWRnzfxyd35UsIcbXGhLyRkWH9A1fSsA4t0pkykVdUL5pNqHyfrVPlWjtkNB0
         2AxqTk60EGXEazaomUtuNqeeov959Q79Wt+MaAJB+BqYakQk9AYKGFLtAo09qwlMu30z
         /cCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5aKqoFa3PS3ofFsonmsRpILD1LHcN5f7ZDBzSGfsEbM=;
        b=nDAyqO8Siq2RlUOhTY20GprbslQCIzKtTiG6majVfvTBfK8Iwf1XppYnBQ8mYkVRHx
         0TZ8vRS6tBkD5cgAqtq2d15Wpi/AhlzoVjb9jBmXIsp1ZGFt5XVvKt3e8YND73+vFXQr
         ADRG02NXK7n1ivf/i/lxyH1Rl1t2RmT3/yzKLu+2bqjbd1CD9QmB8RqZyqtMbHCsZOqb
         cBN+a78Q8KNAPVFy//7e6VoL7G4u01Tzt5RUZ0iqYajAiEVWbV2GPq2zJD3zB3YHfnj9
         r7AWdvsWSViq5kUnbkn6ik3zm8WlL6P2yUWhJegs0+nSHvS5XDlMZBpYwHK7Wawy0W6L
         M6rg==
X-Gm-Message-State: AOAM530ECtPTNA5pOWDIFNAejaeOOvjRtNchTCM5NMb2B3mPgp7AhbTV
        12Yus4giObxIwJ6U4DVrnI3Npw==
X-Google-Smtp-Source: ABdhPJxvck0UJetQTLnRjK9sgifn28nUcX1A1ECsvY4RrQIudiYMG8WNofzA4+8hhV4Kj+KU6N0HvQ==
X-Received: by 2002:a05:6a00:16c5:b0:505:c572:7c2a with SMTP id l5-20020a056a0016c500b00505c5727c2amr22726073pfc.46.1650453915154;
        Wed, 20 Apr 2022 04:25:15 -0700 (PDT)
Received: from localhost.localdomain ([122.167.88.101])
        by smtp.gmail.com with ESMTPSA id u12-20020a17090a890c00b001b8efcf8e48sm22529274pjn.14.2022.04.20.04.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 04:25:14 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v2 3/7] RISC-V: KVM: Treat SBI HFENCE calls as NOPs
Date:   Wed, 20 Apr 2022 16:54:46 +0530
Message-Id: <20220420112450.155624-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220420112450.155624-1-apatel@ventanamicro.com>
References: <20220420112450.155624-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

