Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C57FB6E84EC
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233342AbjDSW2d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233626AbjDSW2J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:28:09 -0400
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D96AD31
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:26:37 -0700 (PDT)
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-51b0f9d7d70so287740a12.1
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681943046; x=1684535046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nDYPek2GW62ZjpMwmsxfE9d0xDPaKHdBMm+cEZKc8s8=;
        b=gbm655ZKGYsSplRJThxaUIliJsDtxxCNHAd8Jsh9rquTj5wgjudHgZwJA550iZsQk9
         VB0SQu2x2QDE7zie14SgvIe7dnOfITMaMnMjD/onrUT0al1gT1sDadgULueeivhnEmTD
         JNLdLb2hMXSDd97f9GLtgcoOoiKtiFWFueifxdMTSbyKE0Z6Gv5tcQoRd/Nk8sLhR8hd
         DGNAlG+7Czxou3KoS1S39Pu0wydKlsp73goQ0cZbb90x0/1svTeMdjxcJ4JUnBS4z1ue
         xceJZmumlSVFCncTt6FuOgv+xYSVDvprfYgxAUggRJ/YOlKDghslSrOk6KKM64ujkV1m
         0exg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681943046; x=1684535046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nDYPek2GW62ZjpMwmsxfE9d0xDPaKHdBMm+cEZKc8s8=;
        b=gzd1Iad/u8JwSKY2eSeLw2BCj18rzkQZHbhv/cz+gBahNhQKVo1/Y5EY+RQMQrba9D
         CLnhvq2YVRVEm3DNjhO4BzZ9nt2lllH3pknjG9Hpw703laebYE56Ge3KIkLmqVKN2VqW
         Mal4lV50ax8+iGbwNkX/HrQyQcQyCJAU/vowwD4MXmDgXIhzVwtvtqtIZl8ruK4R/D1r
         IEY7W9A7pYUyXdVSOx3aJ4Ilfdc1IlDY2SUTMVIIp43KhbAAy6gRTA4Z/uPixkSK+5/I
         5a9W/QBsj9sqXETjfFdi/XwX9Q1Re43oH+ksceRUk48O0YWy3S8a3KHialA062w67REP
         HGoQ==
X-Gm-Message-State: AAQBX9eLz9hpI88HT0a8R+jau9nIAGFGmL44wi7/1CoZh8+MGDwS2Zqa
        7yk1hdZV6oOYRYhMdplM3tN5X3B1XCHolVh5sZ4=
X-Google-Smtp-Source: AKy350ZvU/B8LPyorDIQytWlfNOBgumMg9x+NGoZu6TjngTCY2lrTTdfxOrkdp5JkE0zcFgeJL83hQ==
X-Received: by 2002:a17:903:120e:b0:1a6:c12d:9020 with SMTP id l14-20020a170903120e00b001a6c12d9020mr7842484plh.24.1681943046020;
        Wed, 19 Apr 2023 15:24:06 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id e4-20020a170902744400b001a681fb3e77sm11867810plt.44.2023.04.19.15.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:24:05 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>, Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Uladzislau Rezki <urezki@gmail.com>
Subject: [RFC kvmtool 02/10] riscv: Define a command line option for CoVE VM
Date:   Wed, 19 Apr 2023 15:23:42 -0700
Message-Id: <20230419222350.3604274-3-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230419222350.3604274-1-atishp@rivosinc.com>
References: <20230419222350.3604274-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The user should be able configure the VMM to instantiate a CoVE VM via
a command line. Add the new option cove-vm.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 riscv/include/kvm/kvm-config-arch.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index aed4fbf..01276ea 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -10,6 +10,7 @@ struct kvm_config_arch {
 	u64		custom_mimpid;
 	bool		ext_disabled[KVM_RISCV_ISA_EXT_MAX];
 	bool		sbi_ext_disabled[KVM_RISCV_SBI_EXT_MAX];
+	bool		cove_vm;
 };
 
 #define OPT_ARCH_RUN(pfx, cfg)						\
@@ -66,6 +67,7 @@ struct kvm_config_arch {
 		    "Disable SBI Experimental Extensions"),		\
 	OPT_BOOLEAN('\0', "disable-sbi-vendor",				\
 		    &(cfg)->sbi_ext_disabled[KVM_RISCV_SBI_EXT_VENDOR],	\
-		    "Disable SBI Vendor Extensions"),
+		    "Disable SBI Vendor Extensions"),			\
+	OPT_BOOLEAN('\0', "cove-vm", &(cfg)->cove_vm, "CoVE VM"),
 
 #endif /* KVM__KVM_CONFIG_ARCH_H */
-- 
2.25.1

