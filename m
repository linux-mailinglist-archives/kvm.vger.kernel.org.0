Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F0F4F053D
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 19:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244279AbiDBRmq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Apr 2022 13:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241167AbiDBRmm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Apr 2022 13:42:42 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6F3DFF9
        for <kvm@vger.kernel.org>; Sat,  2 Apr 2022 10:40:50 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id k5-20020a056e02134500b002c9af0334e2so3732377ilr.11
        for <kvm@vger.kernel.org>; Sat, 02 Apr 2022 10:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gTC6wbFjulJGpnpdlR2cK65pyxNM9FH8zxgBPKIedMA=;
        b=IWfMP6PPwTJ7suUb8PtMClWLhu9Q7lmuLZmLxHUiZhB7qG4ONiUnCn55RSteRI6Lj5
         WnEriAXO/P4p+M1csdNAB/x8uJiummx6Y0/TAZvBpSRquz7KG9vvI9Z6+/yhFBG80bUu
         39n7syXyAT1fsyP29qR+jYISRWRnLync2LwfFqLxLJaprc1qfO6clU6/t+z5WaogkP/5
         pF2RgGe/XeZ5vptUf4kb+iPKSZrA25QUiVI1NECCavK79JLnaNP1nDRCJ8PGXkQUIXcp
         9MIuPc1dQkdbiiC/Rw1s3I6v/S07jCmPozzTf7mjzKbEIjMM3oXDFA7NbxxInFHCcbGP
         OarA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gTC6wbFjulJGpnpdlR2cK65pyxNM9FH8zxgBPKIedMA=;
        b=WJVNkIMlfTlqUrltvXn6y1s/x2qRM1Arv3ks6RTaYDn5K/4PHbpgZbIbE7dBLt+xpU
         KXme77X9N2uKjSYCnkGheE7CXiIdykEmaMYlMJv/8nhxaB+yDpJuyHbpOLFTxv+g6gZU
         UFgOgB844l2+zfAYh0HeSK8bMrU4CWjHwz1SX6JhaHpHT1di8egfT0/CWev0YLndar0s
         GAVUli5jGVLC7FrIucT+EBE8MMzYE439mv9FXgtv/Y/Kw2pWz3LY0dt3fsBjmVNYPclu
         dSgYVL2VPfHuElCyhsq7jLMZyobzg9z7W17c/BE/ZN6wPahEROiKCzZ9bnxnExNd0VF/
         t/MA==
X-Gm-Message-State: AOAM533pDUUbjwNhMytBdbqgWXHcZbaNoW2tZphJ1Wrbu/cPs6SgyAwx
        sBx90h+g7svu8WdnJWP6BLVs6LPel8E=
X-Google-Smtp-Source: ABdhPJxh22igukLOyB7xjQIkB7xrRakZ5rtTFEJOHvXCH6QTQaKRf4Vev65C2RCw3Khe1CzIiG7PGVWShMA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:6810:0:b0:2ca:1ff:e32e with SMTP id
 d16-20020a926810000000b002ca01ffe32emr2313380ilc.212.1648921249504; Sat, 02
 Apr 2022 10:40:49 -0700 (PDT)
Date:   Sat,  2 Apr 2022 17:40:41 +0000
In-Reply-To: <20220402174044.2263418-1-oupton@google.com>
Message-Id: <20220402174044.2263418-2-oupton@google.com>
Mime-Version: 1.0
References: <20220402174044.2263418-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH 1/4] KVM: arm64: vgic: Don't assume the VM debugfs directory exists
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, stable@kernel.org
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

Unfortunately, there is no guarantee that KVM was able to instantiate a
debugfs directory for a particular VM. To that end, KVM shouldn't even
attempt to create new debugfs files in this case. If the specified
parent dentry is NULL, debugfs_create_file() will instantiate files at
the root of debugfs.

Since it is possible to create the vgic-state file outside of a VM
directory, the file is not cleaned up when a VM is destroyed.
Nonetheless, the corresponding struct kvm is freed when the VM is
destroyed.

Plug the use-after-free by plainly refusing to create vgic-state when
KVM fails to create a VM debugfs dir.

Cc: stable@kernel.org
Fixes: 929f45e32499 ("kvm: no need to check return value of debugfs_create functions")
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/vgic/vgic-debug.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index f38c40a76251..cf1364a6fabc 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -271,6 +271,9 @@ DEFINE_SEQ_ATTRIBUTE(vgic_debug);
 
 void vgic_debug_init(struct kvm *kvm)
 {
+	if (!kvm->debugfs_dentry)
+		return;
+
 	debugfs_create_file("vgic-state", 0444, kvm->debugfs_dentry, kvm,
 			    &vgic_debug_fops);
 }
-- 
2.35.1.1094.g7c7d902a7c-goog

