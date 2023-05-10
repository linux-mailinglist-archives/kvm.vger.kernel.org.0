Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB436FD9A5
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 10:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236605AbjEJIjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 04:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236420AbjEJIjO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 04:39:14 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DAC1713
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 01:38:44 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 46e09a7af769-6ab0a942f46so1955933a34.2
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 01:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1683707924; x=1686299924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vLxp3S0f1awUfUEHEN2CCeWxyqxQ+kK0R236OPFTD+Q=;
        b=LioKhy+D0FIZ7nGQpjXQKDSDc4LsX67rcXpsrCBcczNORM9Yj6a5lM5AQpT4zky1VB
         s6isWlzB8Lpg92pUzqwLMQLeCR7YqkPdrKFLMv0Omy+ZIpuNFZLDRCLPBNdPcpW80qO9
         MolcVS5CU7TE1ypjAeNAHQeCNQpnrmj4c7diIQdp+ff59y+QNuEX2fQ1rDKq3hexo1CS
         Wa927LRS2DTiYS6IrMV6OA+zoLAQYdnMfUjVrgQUlNeyKDNjQDhiEg12Yqge4AG7J7NZ
         HP5oy0bk9EumBV0uMFuZ3udCAEhY5HHHiHxdWCH6XIqZlyQkAQBNPN4lFd5fHYcDW6a0
         w0fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683707924; x=1686299924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vLxp3S0f1awUfUEHEN2CCeWxyqxQ+kK0R236OPFTD+Q=;
        b=dBTZthaCYyphJTpcd5Anuaenma+zmX+lM6YD37yIfuxVwPJhLkgN3JX0gcJIgbK6Iz
         yoprnqWFmENLHf1zODzG3LrGktavwmJS7nSvTAkCsyPZVozVIlGehk2UtSEQ6f5TEJhn
         rbi4ydPKPR3fj8qAuXZAKPmx0VFXiusMod0kurQx8YzDm5nra3KPmsm4cm4cqLPaipWw
         AQrm73GeKqIGL8fATUl6UrqStupj8Y3iYb7GlOJH9m+2qC92GMQXNR89OctkZJd8NBS3
         D733CyfvM9VzldkY4V2QDykCxKTPq1WhdNydqJYQ5JaSETIU+IL2D8J5o93B0rUbwdDu
         ZTuA==
X-Gm-Message-State: AC+VfDzQGZzXJ9XjYIcXvc2mxQheXpiZNsgTdwWUHhR3JW/qtzgis4RP
        ScjqZTs0hnJC3oB8pCCitYfGwQ==
X-Google-Smtp-Source: ACHHUZ7vniKGbmrZ1k4vNnbCDyzT137B/5VmjbIiqx0sjLRC6bECiSL2I1h9SAtb+3h/XWIgO8zIvg==
X-Received: by 2002:a9d:76c8:0:b0:6a6:389f:ad9c with SMTP id p8-20020a9d76c8000000b006a6389fad9cmr2397800otl.28.1683707923997;
        Wed, 10 May 2023 01:38:43 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id n12-20020a9d64cc000000b006a65be836acsm6049711otl.16.2023.05.10.01.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 01:38:43 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH kvmtool 7/8] riscv: Add Ssaia extension support
Date:   Wed, 10 May 2023 14:07:47 +0530
Message-Id: <20230510083748.1056704-8-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230510083748.1056704-1-apatel@ventanamicro.com>
References: <20230510083748.1056704-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the Ssaia extension is available expose it to the guest.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index a76dc37..df71ed4 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -16,6 +16,7 @@ struct isa_ext_info {
 
 struct isa_ext_info isa_info_arr[] = {
 	/* sorted alphabetically */
+	{"ssaia", KVM_RISCV_ISA_EXT_SSAIA},
 	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
 	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
 	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index b12605d..b0a7e25 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -25,6 +25,9 @@ struct kvm_config_arch {
 	OPT_U64('\0', "custom-mimpid",					\
 		&(cfg)->custom_mimpid,					\
 		"Show custom mimpid to Guest VCPU"),			\
+	OPT_BOOLEAN('\0', "disable-ssaia",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SSAIA],	\
+		    "Disable Ssaia Extension"),				\
 	OPT_BOOLEAN('\0', "disable-sstc",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SSTC],	\
 		    "Disable Sstc Extension"),				\
-- 
2.34.1

