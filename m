Return-Path: <kvm+bounces-38343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AFEAAA37D6A
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 09:47:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5A98B7A3C30
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 08:46:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83D661AE863;
	Mon, 17 Feb 2025 08:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="CxbrPuFE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1430B1AAE01
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 08:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739781917; cv=none; b=O5n5KC5qLLWbax6sjZffU3OdWFC0G1//u6dlbqVvd3evlx2JOzFd+R7eK6q/8ot9xPB1XTsujZ9buWzDtmJhc6eSsFaLqvZFq3hp/Ir4t8clCg2JCt3Y8mmXXjPkNkb/3UAwg4ftzCHjzKC7aoYrsZs6C6sL4a54J4jmrfImGrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739781917; c=relaxed/simple;
	bh=4KWL7WT4m2P9Gzuj6XBNp3VWAe3nw+1IhcUCc4X7DHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAg18iUUVY1LK9WeyOTSn0i+DKdMNvRrNBODVAQTAFDEQOMldPl4bpU4QBrYKSdTxNYM3HcXrxKIErXdh4K6hxyVvkR6OaTARNKzZXU4t/i3KsI7OetY4KNBWwfkpyQmeo8nTilh0cRvudIwPdIZQ06GjR9+J6AbL/wa8T9euw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=CxbrPuFE; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4396e9ee133so8576035e9.0
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 00:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1739781914; x=1740386714; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tUiohrMXynF4IhELzrFmGh0geLQ0Ng2lOgwpKuwejQg=;
        b=CxbrPuFE5cerjU+oX0UCAN6SJlWfaT4dtNFADNy9//P0fK8FV1y/bzJntSwlQD9wSt
         Yl34LsKS91cH8ma9PYaSo1qsY99yz9TPxslCvW0ZaJU3tWX+eRV2pIHwqLkLT9VGmaYH
         molh6ZwTLG2WPSnjSJbsTiB2ZBvuQqac0i12lE478Uj6Edvf2pZa8wuE70P2kRRy3RPu
         n2s+igJ6YDEQvEHa9XDlFGXE0K2VkE3tnOynClSCw+FKiObkJi+vf2xIpkETdo7VY1qR
         vgtNcK2o0bgvVTuweXHt9cHvGH1lZHOVSVhtp9040a1hL95uO/mBuf1IovF8qoWs5mCE
         3MKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739781914; x=1740386714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tUiohrMXynF4IhELzrFmGh0geLQ0Ng2lOgwpKuwejQg=;
        b=wOpRQ+ORsOEJk1qTkpjjILojDnDKkZZqTuJZ52awZAAwq9b8omiNV31QVaVDZZYiaQ
         KLbQxzZB1YbNUPypwhvOuQbc7ryPB19KVn4Fe/nYn7VUdiva0/BC9eCuxpG5tqVC5hzv
         wvBEcKA4G7TRsVN2R7oC64jXZCRL+HuTAuMjwKpenrtRLsFw07AHtz5wP6QhEolNYcN9
         QW3n3MkYgO1ay46jPxi1BIUL8cORXmZdUUUp/2CdDIkNtzXGPLTKRV2XWU0O4wATnMsf
         S9s3Eig+jjsfsuwYwAObWGSPfmdIc735RUa1E6d0IJspqR7hUwzTRvBOtGDfr61jI2tS
         xuCw==
X-Gm-Message-State: AOJu0YxkTdBHAtfucTa8e6CYMJ8JRhrPQnM24Wq44MAkRX8ayMNIzx/z
	nGwlt122bXpBaY1tW3EBN+Q7hB2Cp3X2SsVse81eD5TvaCNXzdvh8NnTJkIAjbl0qthr1gegpxB
	j
X-Gm-Gg: ASbGncvBn1NZXQ6YMyEAC5xJmkutCGyHnUbwQXFrRobS8Qgkr9WqGuBeBwDz0RSc4jo
	XQ81JvVLQPJ4NIO+qK757tln8rgJwy0HdavR0gxioHeA4ZecD1mdj0DRlUPNw00wBsCvVFgKEA1
	+IxWm7r6+5PHZ4+LTxcBERK7ZX+rF5t98Mmg6r0a5JpR8JtzWuIzPHaJwv/RcoIz2uwD1W5Vc+E
	6IXFn33+1gC3R3YGoIGn+CDnenzTL1X5f0bDo4BgelUn+h5J53MkRSCzAQXCP6NQO4wkF/sUEKX
	j8o=
X-Google-Smtp-Source: AGHT+IELeloq+YGu7jeWFNzVErrIwYQyO3BkZOQqDo2NauOC4G+f26bXlMmY85lR2Dzf3d+ItLp71w==
X-Received: by 2002:a5d:64a7:0:b0:38d:ae1e:2f3c with SMTP id ffacd0b85a97d-38f33c2886emr8174108f8f.25.1739781914336;
        Mon, 17 Feb 2025 00:45:14 -0800 (PST)
Received: from localhost ([2a02:8308:a00c:e200::766e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258b4491sm11387499f8f.7.2025.02.17.00.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2025 00:45:14 -0800 (PST)
From: Andrew Jones <ajones@ventanamicro.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: anup@brainfault.org,
	atishp@atishpatra.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	cleger@rivosinc.com
Subject: [PATCH 5/5] riscv: KVM: Fix SBI sleep_type use
Date: Mon, 17 Feb 2025 09:45:12 +0100
Message-ID: <20250217084506.18763-12-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250217084506.18763-7-ajones@ventanamicro.com>
References: <20250217084506.18763-7-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The spec says sleep_type is 32 bits wide and "In case the data is
defined as 32bit wide, higher privilege software must ensure that it
only uses 32 bit data." Mask off upper bits of sleep_type before
using it.

Fixes: 023c15151fbb ("RISC-V: KVM: Add SBI system suspend support")
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_sbi_system.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_system.c b/arch/riscv/kvm/vcpu_sbi_system.c
index 5d55e08791fa..bc0ebba89003 100644
--- a/arch/riscv/kvm/vcpu_sbi_system.c
+++ b/arch/riscv/kvm/vcpu_sbi_system.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/kvm_host.h>
+#include <linux/wordpart.h>
 
 #include <asm/kvm_vcpu_sbi.h>
 #include <asm/sbi.h>
@@ -19,7 +20,7 @@ static int kvm_sbi_ext_susp_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 
 	switch (funcid) {
 	case SBI_EXT_SUSP_SYSTEM_SUSPEND:
-		if (cp->a0 != SBI_SUSP_SLEEP_TYPE_SUSPEND_TO_RAM) {
+		if (lower_32_bits(cp->a0) != SBI_SUSP_SLEEP_TYPE_SUSPEND_TO_RAM) {
 			retdata->err_val = SBI_ERR_INVALID_PARAM;
 			return 0;
 		}
-- 
2.48.1


