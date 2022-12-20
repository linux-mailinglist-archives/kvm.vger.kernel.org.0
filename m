Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E95652532
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 18:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbiLTRKl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 12:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234006AbiLTRKe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 12:10:34 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30AE31DD
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 09:10:32 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3bd1ff8fadfso148806077b3.18
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 09:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7E771XF831j78EC9wHgqyf1bBOlyl41KPHcKn96cIz0=;
        b=cUP6jYJGTm9vLBS9l72XdoVuhGamuCPt/M8zIuDS1kr112Qsg/PV4PpA8VIbWe8xjJ
         pc2VpDOcH4sLcq+tnN+BRXcH/SUXmAgARYEQFxWxydSKazcDT+Jrqv+dw4XAiqIYed83
         Xjii/6VfQpefbVpU/xp/dszenyQA3vSiBANniys1CAzefc1Zz0JO+MADxl12bZg7tXOF
         sQSJ3LuagpFuWgWrZbrYNPbqYiqAcYw2s9WTrtALkzPylhRy9mbYF2CSNAeE0JjvDSHc
         z3AzEIbP4YFJnVQGxoByz0bW42xSDRgUNBpcDsZb5xOEkAObs/HKSe3sB/3YYR9SIkpz
         qBiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7E771XF831j78EC9wHgqyf1bBOlyl41KPHcKn96cIz0=;
        b=hPNMcd9L1MvGBnNFMbyuGtQnItfl9YAfWqfEC9io1BI52vrwSTWtKiWAVXaD1w7C+u
         0TExQqn5vGikAfNpJ/kNVYq+PspwGF85uaOYux2FeIBT9PxPhMre7cuC8ZrP02fYPFwa
         mIwS/T38bF7iPsn9xeTv7KmddPcvj2kiVj0JchWjP+8mTIzJDOwRRNu3lAD60g8zT3F3
         YQzL/dW0vBrB8FzypY7mJTIVYvPCyfOX/72dceglbB8lwM8ov1ep9AmUdzlOanscilTN
         UBuGlF/JrN9PYb/QnpqfBrYUKGp/zEPcDAd4wdS2D+iHHGL+nfMpPpSyLa9nPC2mdKiJ
         Jh8w==
X-Gm-Message-State: ANoB5pn8RSZzXceTRly3aTu/N1P35qQsBRbrNqovppG0e9eKWjdkf6j+
        iOsk3VBMOVDqqSEPuVDUKI9Rid6ooOw=
X-Google-Smtp-Source: AA0mqf5xHxTFI0JKE9RZW3A3HiRczrW2+7ROK1/yUNF/kf2CFGXC38TY6GLa2k3IJDc4AzI79PkeNy286ys=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:1343:0:b0:3b7:7be7:ee90 with SMTP id
 64-20020a811343000000b003b77be7ee90mr6489502ywt.352.1671556231478; Tue, 20
 Dec 2022 09:10:31 -0800 (PST)
Date:   Tue, 20 Dec 2022 09:09:21 -0800
In-Reply-To: <20221220170921.2499209-1-reijiw@google.com>
Mime-Version: 1.0
References: <20221220170921.2499209-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221220170921.2499209-2-reijiw@google.com>
Subject: [PATCH 1/1] KVM: selftests: kvm_vm_elf_load() and elfhdr_get() should
 close fd
From:   Reiji Watanabe <reijiw@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Andrew Jones <andrew.jones@linux.dev>,
        Reiji Watanabe <reijiw@google.com>
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

kvm_vm_elf_load() and elfhdr_get() open one file each, but they
never close the opened file descriptor.  If a test repeatedly
creates and destroys a VM with __vm_create(), which
(directly or indirectly) calls those two functions, the test
might end up getting a open failure with EMFILE.
Fix those two functions to close the file descriptor.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
---
 tools/testing/selftests/kvm/lib/elf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftests/kvm/lib/elf.c
index 9f54c098d9d0..ca7c3422e312 100644
--- a/tools/testing/selftests/kvm/lib/elf.c
+++ b/tools/testing/selftests/kvm/lib/elf.c
@@ -90,6 +90,7 @@ static void elfhdr_get(const char *filename, Elf64_Ehdr *hdrp)
 		"  hdrp->e_shentsize: %x\n"
 		"  expected: %zx",
 		hdrp->e_shentsize, sizeof(Elf64_Shdr));
+	close(fd);
 }
 
 /* VM ELF Load
@@ -189,4 +190,5 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
 				phdr.p_filesz);
 		}
 	}
+	close(fd);
 }
-- 
2.39.0.314.g84b9a713c41-goog

