Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E4C6E848C
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbjDSWSg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232020AbjDSWSR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:18:17 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DAC940D7
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:17:54 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1a5197f00e9so4657725ad.1
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942674; x=1684534674;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uwIdkHCarryXV50I6knz0ZklcYwS0nTZYHahvAAioGA=;
        b=JAfyJwlLZTLpeO+0a9mP+Qz17gHyrei/u3hvU+Y1oEWg9aDIafnfffPw2WLQocmCE5
         thEwftksAEQCxymE79XbmXlY3CV86W6kKDPWDlsoieUM1U98liDXsdwKh0TtzMRMco/6
         2qgFOkWb8NmcTouc/FLGToAZLWlsyjEWM3W1S9eitYQ6PZtGjRV1E0Bh4dYyak7MqlLF
         NqImRVNGkomVidir55QeblFMKk81mgA2duY/+3llfMenErvbAqjZMXeQVvmExrFa536W
         fZATF/TIP+lPFweeamhhj205CiSSkghmiFgf4j0xA47+WlMqYFC57GJCbBbKkv5f7DR4
         f0PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942674; x=1684534674;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uwIdkHCarryXV50I6knz0ZklcYwS0nTZYHahvAAioGA=;
        b=jc4pizBfSkWIoUR7oVc9CnWhacekD3nFSIaG68iwbJo0MaqW5frRUYNU+LBdvIcKJa
         6QvU4Xxad8UU8AZvwULjoa8JEG/cJ2F5Duy/ekgxWjkkA1eJxH+oFj9Jc1uZs/MgExuq
         Dr2Ke8ORwn9mPv6oo7gYCJe5KtEIImbPxPCo3GnModIhq7dpFrJSEYJ2iWqVioxTFAzN
         xbOKU03VXbn9NghUKNp24xBHs1iobw3FTlw/5f0OKDGx4bz0Lp4YcZS74Pleah4owS7v
         C9UoQpbqE+pgzHvWDHD/qT9lPgdVcjmoawkvKvvgE9nCBXKhMEf9yfCMdyL9qMMIv4KN
         MpNQ==
X-Gm-Message-State: AAQBX9fjyyJmGnHLKHzMUuo+O2XZL9m2ha/MoVsgqzaOWvKTUAJROopL
        wzZIwpxC5y8SHG8NzN4IRZRy9A==
X-Google-Smtp-Source: AKy350aOeQnqsiOOnUYsijZU0I/0P7RvEF6TJy/X0/H7ROAFo8Dof2s5JoE26B/8+FVZEZPKo3gc/w==
X-Received: by 2002:a17:902:ce88:b0:1a1:f5dd:2dd5 with SMTP id f8-20020a170902ce8800b001a1f5dd2dd5mr8081414plg.13.1681942674035;
        Wed, 19 Apr 2023 15:17:54 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:17:53 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>, Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Uladzislau Rezki <urezki@gmail.com>
Subject: [RFC 11/48] RISC-V: KVM: Use the new VM IOCTL for measuring pages
Date:   Wed, 19 Apr 2023 15:16:39 -0700
Message-Id: <20230419221716.3603068-12-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230419221716.3603068-1-atishp@rivosinc.com>
References: <20230419221716.3603068-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The newly introduced VM IOCTL allow the VMM to measure the pages used
to load the blobs. Hookup the VM ioctl.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vm.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index 29d3221..1b59a8f 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/uaccess.h>
 #include <linux/kvm_host.h>
+#include <asm/kvm_cove.h>
 
 const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS()
@@ -209,5 +210,20 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
-	return -EINVAL;
+	struct kvm *kvm = filp->private_data;
+	void __user *argp = (void __user *)arg;
+	struct kvm_riscv_cove_measure_region mr;
+
+	switch (ioctl) {
+	case KVM_RISCV_COVE_MEASURE_REGION:
+		if (!is_cove_vm(kvm))
+			return -EINVAL;
+		if (copy_from_user(&mr, argp, sizeof(mr)))
+			return -EFAULT;
+
+		return kvm_riscv_cove_vm_measure_pages(kvm, &mr);
+	default:
+		return -EINVAL;
+	}
+
 }
-- 
2.25.1

