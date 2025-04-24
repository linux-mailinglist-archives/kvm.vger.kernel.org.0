Return-Path: <kvm+bounces-44188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E4B79A9B262
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 17:32:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 005C41B8760C
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 15:32:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62AA6223DFF;
	Thu, 24 Apr 2025 15:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="A5y48r78"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E50C1F873F
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 15:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745508744; cv=none; b=A3xXd6G+/t3NSmJ3VUHEJZmsiTVb82DyPgqb1wJZd5cfpLnihPVD0RTsUZLM6yJVk98Z3mdgViw6memq3Lan79TEC3v2UjwogVxFRt4eAPSSWpGnaL5eLDBNGG7xY0O7AYvjVWwxvz19Ctsp91VJBPe9yZuZtGzHFD30WchjBSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745508744; c=relaxed/simple;
	bh=2sxhCNXNz+uusMd8m0WOoiM5IIhIVXykeDlCg+8yVbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZ7uALLh4+arpMZern9gJmurE9eDeytoNeMJAe9PI8hrnOIzhcLMQkgm9bMyF1oBrX47Wacl+Mo0FtS0gwwjiBKQALYiEQaFJ96bmc4sI4t5BXZ6SJakZ4ugXvQ4eM6Cc68PzRkIGxKnEpvLw/1t2pNwq08+HdMPpfXr37tkHKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=A5y48r78; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b07d607dc83so984680a12.1
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 08:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745508742; x=1746113542; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R0IwKIyhJe48lUgNI7YxfwAQ5b4aIzLCl3JBaAqKrgA=;
        b=A5y48r78uMUCoQay9+Li/tvVlY2fZvYadagkbseDfyZcnM/vJg2Rq6caxhTvtoYNh4
         VSbj+hmGmdkYZ3H5FjuJPbwRc3zZc9wnKdtwHDNVTVAb0lLtCoKJFL8NX0dDhTpKeuYt
         NP2yN+ANDAeR/tfd95uiPQR/TL62mF/aADEFSl+nl4BkYn2pCpH8PsyoNreYioN5P99+
         AbqfHBg2sC5NdQ+4YGF0Hzij+TJPTJh1Yq2OBEIEpgXHTthExp2i5+8M2A2osmkPGp4G
         zx7sdBYioTw9pRMcAZ2uGxspy1KyCwHXJ8E//QdZJSiwsDxecvHjU+J4K6pPlY0bfu9t
         VzkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745508742; x=1746113542;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R0IwKIyhJe48lUgNI7YxfwAQ5b4aIzLCl3JBaAqKrgA=;
        b=hEiPSvYY0L+TroydZphhh7DVPwZ8jOuF2GQ+RI6+1UP5ZbkR+SAS6vARseBDaB9W7B
         wxcpSfZ2xEaYD3JYPgCtiUlnWIZFYiGyvojlMbdMvyfXdyuSxkjaYpajGFHUIQclFxUx
         eFnr60A49a3UQMPit/XRpPg6eILXTDsDn9q0yGUgSmNLYyLqV/mQYkg7W29gZVXsub6H
         AGSggT05Mx1xo4XgVzkMMSsREjR3EOR+ZquprPWQoKIRP/T8vX3imhWEqWHZoFAysFpH
         6MK7iPiko/YiBx8V/CUZH2ICl2LZvtxJxgdDaellp+Yrnmb6E/0+u1QEDiLYwZeosw2w
         7Ftw==
X-Forwarded-Encrypted: i=1; AJvYcCWqARGVpbaK9wW92unxPwNNII53q6Co1o4HFcw+T+kaarxutp1HJrYafslcJYDuajTbPmI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJzAnr8CFooLygvie+KHUTMOi4t3x4CXghCzkIIzYAOAhX540i
	OyNgC1XYmV2/1bib7uZX5DaaQuksfzJqfWoOorIMjeLNNOgpKn5jtHQhieXw1SA=
X-Gm-Gg: ASbGncuFzzIGkroM4PWSz2MEC2EdrDE+moMLdnwyGjTSWGwyX64S1jTLQ4KrVA6K37R
	CXyfemJE5XxnDW6XDn1dyjhd3YivFy1mB+oaiaoMtM2sUY7AGNTFvIFcoKmo7bqnqBwsIcHQjkW
	7eXyCST27i91bGiL0fmmdZHtFa+DOSw55EsogUP1sVTNSXPDtzXGk4czo5f24wEjK0n95PjvYkn
	4C7oJB42UEL3z2JUqdwIfCh86v9P0dFiczGjRDe9P7TRc8By7HRX2vFNCNt6OU3sNtuhJmlIjWX
	99mrvIybmDJj2UzqiAc6VC7tYvJenIlE4ayIAZrpOrY3Iswcqvc0mcJJma4GZLg1N0IHxXHT0F+
	iyldM
X-Google-Smtp-Source: AGHT+IFqUwAdYQm6RR1he8AWnRduhYm8oDtl2Xyb6GC02q2qn/lBuEeE5OoIuJrnbDInb+D4TZkF8g==
X-Received: by 2002:a05:6300:218c:b0:1f5:6f61:a0ac with SMTP id adf61e73a8af0-20444e7b205mr3285038637.5.1745508742164;
        Thu, 24 Apr 2025 08:32:22 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b15f8597f5csm1360610a12.43.2025.04.24.08.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 08:32:21 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v2 03/10] riscv: Add Zabha extension support
Date: Thu, 24 Apr 2025 21:01:52 +0530
Message-ID: <20250424153159.289441-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250424153159.289441-1-apatel@ventanamicro.com>
References: <20250424153159.289441-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the Zabha extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index c1e688d..ddd0b28 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -28,6 +28,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT},
 	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
 	{"svvptc", KVM_RISCV_ISA_EXT_SVVPTC},
+	{"zabha", KVM_RISCV_ISA_EXT_ZABHA},
 	{"zacas", KVM_RISCV_ISA_EXT_ZACAS},
 	{"zawrs", KVM_RISCV_ISA_EXT_ZAWRS},
 	{"zba", KVM_RISCV_ISA_EXT_ZBA},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index ae01e14..d86158d 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -61,6 +61,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-svvptc",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVVPTC],	\
 		    "Disable Svvptc Extension"),			\
+	OPT_BOOLEAN('\0', "disable-zabha",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZABHA],	\
+		    "Disable Zabha Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zacas",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZACAS],	\
 		    "Disable Zacas Extension"),				\
-- 
2.43.0


