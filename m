Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2894B9735
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 04:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbiBQDu2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 22:50:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbiBQDuZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 22:50:25 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23AFC4280
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 19:50:11 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id a13-20020a170902ee8d00b0014f308fed09so1966677pld.12
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 19:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=vRtM/cROOx5FsqNMttv0pPiPYqWySn+ox7xCpR/R9pQ=;
        b=VXI/EO5uA+etW0dY+bDcMbof9vcOt9SX4c8MIwKYL2KjJK778sgRC4ONa+S96Tq0kC
         2DNAkeg32L87pidTLjIxaGqseJc+3T5vMuB+w+93GZkI2D2TVXTTsK9tLKdq55IVduJd
         HY6Yt6e7ITaZd1JWGm6SAif/ms7rSjFues9sLIJCzp12Jt5VwgzXhnRJusVMPVi7fx7K
         EGLTgjyoji9r7qxZ7uhq821QmUs0eEGMKzsvl5mW4BzjI4gNlfYLd+rvssbuo7pt2BsP
         pXyzTyGwbqarreY8cymIKeiUQtmMLmNlCpb2jOchN184vkaWtt52ENyHw4o+hy9Vex4V
         c4Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=vRtM/cROOx5FsqNMttv0pPiPYqWySn+ox7xCpR/R9pQ=;
        b=ygdg777sxR7g4Sb+rL0Fv5zarvCaBS5JabB0FbR7eevYTsrohQEdGqx7Swa2sPqPRz
         W0dSndX81/HFwFB5Il6Vp8D0lqAsIrOGUAr8p4v1kPW5rZ6VH63zayNysr1s8quwRhtX
         16i5hL6LLzzp0CWZuA5mIXZocltUmwXWEmsrNBUsrS1IXiUNiOnS4HmaFc6ZzFctzt07
         uMwchfVkA4jOYu1KBG5z+0fB9TWeQ48nsSgWTvkyJUztwoFX+ldygmPX+hYq1I3wOq4z
         WhWAcA5lExyTkc8jVfiEBzVcemFsHQ90YWF11JXT1o1yVAitYqzlSc2Iza5GkQW843fB
         5iNQ==
X-Gm-Message-State: AOAM532+EmGgvaQOXRF8OcIfirHEAC1dCkzEx7ZTD3Gx6AwZq9u3UIX9
        87Chopm9j5b2sSc7YRKoa8qsb/G4+CE=
X-Google-Smtp-Source: ABdhPJz43oeS5F0siXWsZh061o21n+qfPtthgPIgTIT8DyUX6v2rSoMU2ZNvcsVNXhRZGwvcQO+2wDnOY7E=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:1f4d:b0:1bb:a657:ace5 with SMTP id
 y13-20020a17090a1f4d00b001bba657ace5mr2283133pjy.39.1645069811410; Wed, 16
 Feb 2022 19:50:11 -0800 (PST)
Date:   Wed, 16 Feb 2022 19:49:46 -0800
Message-Id: <20220217034947.180935-1-reijiw@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH 1/2] KVM: selftests: kvm_vm_elf_load() and elfhdr_get() should
 close fd
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_vm_elf_load() and elfhdr_get() open one file each, but they
never close the opened file descriptor.  If a test repeatedly
creates and destroys a VM with vm_create_with_vcpus(), which
(directly or indirectly) calls those two functions, the test
might end up getting a open failure with EMFILE.
Fix those two functions to close the file descriptor.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 tools/testing/selftests/kvm/lib/elf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftests/kvm/lib/elf.c
index 13e8e3dcf984..9b23537a3caa 100644
--- a/tools/testing/selftests/kvm/lib/elf.c
+++ b/tools/testing/selftests/kvm/lib/elf.c
@@ -91,6 +91,7 @@ static void elfhdr_get(const char *filename, Elf64_Ehdr *hdrp)
 		"  hdrp->e_shentsize: %x\n"
 		"  expected: %zx",
 		hdrp->e_shentsize, sizeof(Elf64_Shdr));
+	close(fd);
 }
 
 /* VM ELF Load
@@ -190,4 +191,5 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
 				phdr.p_filesz);
 		}
 	}
+	close(fd);
 }
-- 
2.35.1.473.g83b2b277ed-goog

