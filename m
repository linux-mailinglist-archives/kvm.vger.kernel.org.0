Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D169748096
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 11:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbjGEJPo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 05:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbjGEJPm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 05:15:42 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED7E1713
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 02:15:41 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-1b09276ed49so6057116fac.1
        for <kvm@vger.kernel.org>; Wed, 05 Jul 2023 02:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1688548540; x=1691140540;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WbwVyC6fOUxdMPZng6GXOKeTpMZw4Uea4VKPOQCS1kA=;
        b=hoBRqNpxZLjhjng/wvEo1GY+oC9pDRblaGFYgrepCrMMWzyZEGZN8/tY+kS6kAVONe
         1DUEQ8wF0HXMnWSPBqD7AiBrkw3J9p3CF8d1/6XD3m0rDYSR3xc6kiewP4do5ugZe8Ij
         fBUpzBDkLHPjRzgfNtyiLxy/wKq+/zQyKRCLbI/DFJBYMXdbjgz1/Fmh3KdOiVnStgsa
         TmE7L7+JL1M10IboIONEXvwqneMdrlou00fIvieX9YZ/81oF//GQW5OiNavYdyTmVc5J
         v6GVFKzmiNKnCQZm0pUecLZv1tvrEJSrmU1o84k036yZ2Eckv9TEKgF3EpfgM6R48qFu
         zUQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688548540; x=1691140540;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WbwVyC6fOUxdMPZng6GXOKeTpMZw4Uea4VKPOQCS1kA=;
        b=KksrU7M89sDaPJnrCkENXDu6pCnPXJ47DOjquOe99f2lC6PthSCEysEt7LVMz9sJQr
         6NUX2zkPH84XvYqZN0HyZK5aAeUvBS75vP6FtMn4ProLobbqEFRyvirjCyySvQ/jjSMg
         fytbooxYWpybtiYW/JDMqH/Ff1hA5mS6PEhvtK0Ana1kILUvMjemzZn1hjZiRI03sqkc
         ltINPRvlxjteZixWFRpmVW1VyHvOY3n5e9Um1g/srZjtLEWjPo1zCwAQljFKw+4GKnVp
         8kEb9NsxNF9QhcVzCWHEZczZt3OM22yTUezPJvxcBTjdyNg1Yyd5LOWFaUyhEDCpkGaw
         1YUg==
X-Gm-Message-State: ABy/qLYzjFJ3USM33I9UjhTODztvzQ5BprwJgSRmcqgWfyOUSC1BtqqD
        N+CpqN8iXjIjEa/9iMrp0tw5eQ==
X-Google-Smtp-Source: ACHHUZ6P6BGgfJQ/l26Ogon7fmyXPy5Gtkf+9NSeBNJqUqQElHKeOCgNEcWp4DJV889yGyelvkfq3w==
X-Received: by 2002:a05:6870:c192:b0:1b0:37cf:5af9 with SMTP id h18-20020a056870c19200b001b037cf5af9mr19169800oad.2.1688548540392;
        Wed, 05 Jul 2023 02:15:40 -0700 (PDT)
Received: from grind.. (201-69-66-110.dial-up.telesp.net.br. [201.69.66.110])
        by smtp.gmail.com with ESMTPSA id s3-20020a4aa383000000b0055e489a7fdasm2637414ool.0.2023.07.05.02.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jul 2023 02:15:39 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH] RISC-V: KVM: provide UAPI for host SATP mode
Date:   Wed,  5 Jul 2023 06:15:35 -0300
Message-ID: <20230705091535.237765-1-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
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

KVM userspaces need to be aware of the host SATP to allow them to
advertise it back to the guest OS.

Since this information is used to build the guest FDT we can't wait for
the SATP reg to be readable. We just need to read the SATP mode, thus
we can use the existing 'satp_mode' global that represents the SATP reg
with MODE set and both ASID and PPN cleared. E.g. for a 32 bit host
running with sv32 satp_mode is 0x80000000, for a 64 bit host running
sv57 satp_mode is 0xa000000000000000, and so on.

Add a new userspace virtual config register 'satp_mode' to allow
userspace to read the current SATP mode the host is using with
GET_ONE_REG API before spinning the vcpu.

'satp_mode' can't be changed via KVM, so SET_ONE_REG is allowed as long
as userspace writes the existing 'satp_mode'.

Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
---
 arch/riscv/include/asm/csr.h      | 2 ++
 arch/riscv/include/uapi/asm/kvm.h | 1 +
 arch/riscv/kvm/vcpu.c             | 7 +++++++
 3 files changed, 10 insertions(+)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index b6acb7ed115f..be6e5c305e5b 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -46,6 +46,7 @@
 #ifndef CONFIG_64BIT
 #define SATP_PPN	_AC(0x003FFFFF, UL)
 #define SATP_MODE_32	_AC(0x80000000, UL)
+#define SATP_MODE_SHIFT	31
 #define SATP_ASID_BITS	9
 #define SATP_ASID_SHIFT	22
 #define SATP_ASID_MASK	_AC(0x1FF, UL)
@@ -54,6 +55,7 @@
 #define SATP_MODE_39	_AC(0x8000000000000000, UL)
 #define SATP_MODE_48	_AC(0x9000000000000000, UL)
 #define SATP_MODE_57	_AC(0xa000000000000000, UL)
+#define SATP_MODE_SHIFT	60
 #define SATP_ASID_BITS	16
 #define SATP_ASID_SHIFT	44
 #define SATP_ASID_MASK	_AC(0xFFFF, UL)
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index f92790c9481a..0493c078e64e 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -54,6 +54,7 @@ struct kvm_riscv_config {
 	unsigned long marchid;
 	unsigned long mimpid;
 	unsigned long zicboz_block_size;
+	unsigned long satp_mode;
 };
 
 /* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 8bd9f2a8a0b9..b31acf923802 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -313,6 +313,9 @@ static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
 	case KVM_REG_RISCV_CONFIG_REG(mimpid):
 		reg_val = vcpu->arch.mimpid;
 		break;
+	case KVM_REG_RISCV_CONFIG_REG(satp_mode):
+		reg_val = satp_mode >> SATP_MODE_SHIFT;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -395,6 +398,10 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 		else
 			return -EBUSY;
 		break;
+	case KVM_REG_RISCV_CONFIG_REG(satp_mode):
+		if (reg_val != (satp_mode >> SATP_MODE_SHIFT))
+			return -EINVAL;
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
2.41.0

