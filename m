Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7EED7A4A4D
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 14:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241991AbjIRM6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 08:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242036AbjIRM60 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 08:58:26 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5682138
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 05:57:49 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-5780001d312so3249717a12.0
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 05:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1695041869; x=1695646669; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8NMJrD+DJLbJV3iwMT7tndl51Y/nhmykJEirAlnEkHg=;
        b=gPns6fndYwgQFgMrK7R2XuiqdIMbQRDDfY9jZsFhWcBs1HKyekjdb1uiS66QGpT4rR
         t0BhaAKmBFfl4CYwPa/1Ghc8uYSet8SFlkTvp+hcuMn9UGbFIdgsWigSuo6g58na40rn
         +xHhrO2CPUpnEf3Ol2TTN4bjfMopUuXi8ZK/NgqMRtbJshc0lOAmbV7fQbVUwTv2QJOI
         EdlypZsBdztzrSoT9502zaS6rCsyfZMrXlew0QYOZgK69TNqjeViJaJBlE+RLae+07S1
         qtH71GbSKdUUY99ElGmovWdGngagfDn60HgPMpYnkN4drfqn/7WjzcApHjSbmPdwv2Ko
         LKTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695041869; x=1695646669;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8NMJrD+DJLbJV3iwMT7tndl51Y/nhmykJEirAlnEkHg=;
        b=qn3FDWL7dolG7XoQhSyYdCsF52S+8/uzE0lOHRfja4RDJ/QVscvvUPtagiuzosQjpW
         npKohqForQLQgZ6cHN5NXdEqTsU+YwRUR5lX67G+NJWyYqhxfClK6QGHporXq95tpJhU
         lGe5UiPxDi6k3NTxagqpEGG/Jkhwn6P2wm2hsFdz/BHjusLVXYz6SMgWWbHNvXxALp+m
         lXodgDgq4zTn7HTLTWHxGkoXwSD0mFqaxq+DR5XrG4XiBx7bkbDvK55DEp1B9TTirjYp
         +cFOjLCo2fpweCw/WFNix1iM+Xrmt4D9IpC7/Tmc+1wYZ7owYhShIJG9UNTvhlHWuNiz
         N99w==
X-Gm-Message-State: AOJu0Yz0JkJ1k++Y5Z+V9DOYqLDTwi1WcKmDMxD7ZarQmf00c1BxbRIL
        l8EuMLsWUOE/+sAu/yVnb1clrg==
X-Google-Smtp-Source: AGHT+IFVdIccX45/W3XfGFVCPW5/xV02B4CCmNcm36uHeh302ZxibEA30tifWAOOZwaH5JWFVsJxeQ==
X-Received: by 2002:a17:90a:1c16:b0:274:b4ce:7040 with SMTP id s22-20020a17090a1c1600b00274b4ce7040mr7428953pjs.23.1695041868859;
        Mon, 18 Sep 2023 05:57:48 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id n14-20020a17090ac68e00b002680b2d2ab6sm8890237pjt.19.2023.09.18.05.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 05:57:48 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v2 2/6] riscv: Add Svnapot extension support
Date:   Mon, 18 Sep 2023 18:27:26 +0530
Message-Id: <20230918125730.1371985-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230918125730.1371985-1-apatel@ventanamicro.com>
References: <20230918125730.1371985-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the Svnapot extension is available expose it to the guest via
device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index df71ed4..2724c6e 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -19,6 +19,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"ssaia", KVM_RISCV_ISA_EXT_SSAIA},
 	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
 	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
+	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT},
 	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
 	{"zbb", KVM_RISCV_ISA_EXT_ZBB},
 	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index b0a7e25..863baea 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -34,6 +34,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-svinval",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVINVAL],	\
 		    "Disable Svinval Extension"),			\
+	OPT_BOOLEAN('\0', "disable-svnapot",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVNAPOT],	\
+		    "Disable Svnapot Extension"),			\
 	OPT_BOOLEAN('\0', "disable-svpbmt",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVPBMT],	\
 		    "Disable Svpbmt Extension"),			\
-- 
2.34.1

