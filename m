Return-Path: <kvm+bounces-27198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E8BE97D1DE
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 09:40:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BD782B22AF7
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 07:40:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40A2F7E111;
	Fri, 20 Sep 2024 07:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="LoUFRYLz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188FF78C6C
	for <kvm@vger.kernel.org>; Fri, 20 Sep 2024 07:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726817972; cv=none; b=Pr9KjSF+D7CimKBrZCLQJGSIv0TvtHxEBGgpUqiq1jG4mXBbUNRNoHz81dMSvkQxXF/II5hsBhc9YRmCbkzrE3eX0uxt/5CU2rAG2hAdM3km1oUKwxmDYeRy07BA/jjGtNPz4FndgK+wVeCSystwEP92UjW5C0d3sGttAWSwaZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726817972; c=relaxed/simple;
	bh=H2dmJr8hpjnnkdgnm3AAwF3pNuKwnFfGeFFtmmrBeZo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZUsiccwTDssKs5tezbGdhAK0RBurI4zV3Y7lzhKzWQFTCFPLNioDx68gu3cuo6TGjif/u4Ddvg5pk+ScLQxIq8JZ/zapHA131lpjPwg7KhzVOi/Mvq7DznE252wJCxysFGZMlcNo8oNWPiggC/exxC9JmBGQbpugJNkb45X1MSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=LoUFRYLz; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-205909afad3so21735435ad.2
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2024 00:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1726817970; x=1727422770; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=56knnfie3gn40U1586qIcyfLVXwVK5l1OK1pmMi2fA0=;
        b=LoUFRYLzxWPzVjkoFV9ao0yf/yF09mqx+0jqO39Uk0Z7jIBuwE3Fd/H238IuD6/jZX
         3rne++r3wl/LLYumWU3MVL5NKxzkeKqoc9IeoZut4dtixnpjZZj+xIOJIxhRQrH7iJQK
         j+/NqbYzfh7L3v1cooKZ79aJm8Zbirjz6Lf8tzuy/JS8P+hj3yQfnt+AhDqmIEk/AH4p
         TLCV+K5G2KUeFq+H7SeuiF0+XJM0RchFYDxsVtmJ+yqlRMxUpdFMXfsBa+nQtJhblyu2
         9YTx7CpiHsZvP+Pgg0wpwVF6qhjJLJic9ZAx4Vx0FAwSMZQCI2t2jOiVImFXRHki8jDM
         BKqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726817970; x=1727422770;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=56knnfie3gn40U1586qIcyfLVXwVK5l1OK1pmMi2fA0=;
        b=IdsYfNYChYXtK2PCFDrbgTMxzHixZKDi9sjsfoJMUEtw0cVerLdSWAeDkb52UBpGj2
         wOgYvBIeZgGYNXUM8DNlXlY0cz6divCaHjhmf/EDd+JFDUMhW41tkwHc51oZTQC/byxw
         UgQMETSGNGxMSz8JoUcGCJeUJPNJPV7yMHgdwCcKoIblxMGrAQ0FMbWEEmDsxnfQSbGc
         QVYYGtF1QOYAdaKiRtynDeG62o2fIj9nl2M0smyAIn68BNYUfXL0hjyEo33P1sk9hVF3
         hdbzXGecC8KS0OzadPHB/CThMHRdmWV3Jf+A8r9qeihm8x9ZQqmf+W8Fo42PNOu8uNeR
         Wvug==
X-Forwarded-Encrypted: i=1; AJvYcCVNCMlFGh5ebrlVFRfm3UI87yuAIsiCm0vV4V5XwvIrvJOZRC2igJ/JHNLfmXVn7eHTJb0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7PmrxTd0VuGi3d4PMbj/6UfXFuOkB0PIGcao1MofE65yGz1eS
	K4sGSxEj2SsXAt4ONRzvMD+zFuk8+nDFfG9xcgcoiBz4hobobZnzmlbQxqlz9yk=
X-Google-Smtp-Source: AGHT+IFdJWu48cTXjfm7pmPi0SJjjpoM8oaSNh7cs+sv8ppa+Eh8rcIfQI/ARHDbsMfIMGKI31JoxA==
X-Received: by 2002:a17:903:8c8:b0:205:410c:f3b3 with SMTP id d9443c01a7336-208d8442483mr26756335ad.59.1726817970349;
        Fri, 20 Sep 2024 00:39:30 -0700 (PDT)
Received: from [127.0.1.1] (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-207946fcaa4sm89645805ad.212.2024.09.20.00.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2024 00:39:29 -0700 (PDT)
From: Max Hsu <max.hsu@sifive.com>
Date: Fri, 20 Sep 2024 15:39:05 +0800
Subject: [PATCH RFC 3/3] riscv: KVM: Add Svukte extension support for
 Guest/VM
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240920-dev-maxh-svukte-rebase-v1-3-7864a88a62bd@sifive.com>
References: <20240920-dev-maxh-svukte-rebase-v1-0-7864a88a62bd@sifive.com>
In-Reply-To: <20240920-dev-maxh-svukte-rebase-v1-0-7864a88a62bd@sifive.com>
To: Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>
Cc: Palmer Dabbelt <palmer@sifive.com>, linux-riscv@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 Max Hsu <max.hsu@sifive.com>, Samuel Holland <samuel.holland@sifive.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1319; i=max.hsu@sifive.com;
 h=from:subject:message-id; bh=H2dmJr8hpjnnkdgnm3AAwF3pNuKwnFfGeFFtmmrBeZo=;
 b=owEB7QES/pANAwAKAdID/Z0HeUC9AcsmYgBm7SalRgR20+oKL/qOJCPUSe6TlQ9TxOvvbzCZ3
 /oFZ1j4YAyJAbMEAAEKAB0WIQTqXmcbOhS2KZE9X2jSA/2dB3lAvQUCZu0mpQAKCRDSA/2dB3lA
 vWC7DAC6wEj/n9CbTmnWTmX1V13illBvFuFZRuglicYsApqy50khOjplX6PJZuGQ95zwOU7MgL0
 R3EiVMLLWH+svNhI0RKdAYZgkYaC+ebdN6rmtFUPZoTDzYN29PcsufuUTCYGVx6yhvRJ6tUsKz5
 XsfgxNU5bsp2/TrTrtpBr9ikId9PSeSaZjSvYX+XjxRKaRAUBl1ZEOjWlR6QKCMo0GO4KW5CSWx
 jptrxxQmq5XHZvg6nChHyWTNRYK6hDH2Kn6+AjKgyNIjnl/0QzAv4UalKsaHJk5wiwJWMQ3oCa4
 lQcTWE/+8v3Dtz9RlFFQHkuyEY06ph9ETUWB9+qstgSGitlZYBMi9uaOTRlXgoK9XF1yo0VmF7L
 p/gBoLYn0F29Vo7Zu2MiEfzlww2NgqTkTtIHEt5VgQZac5TIQq52VSoq/Bwz8S+4LBKeb1gOeR6
 bCoaMInYzf6Jur0ktZwEGciz7Mw/YS+SFW3LprnqtS5bHDVHzRYf9Tp9JY0o4dbSO3Yuw=
X-Developer-Key: i=max.hsu@sifive.com; a=openpgp;
 fpr=EA5E671B3A14B629913D5F68D203FD9D077940BD

Add KVM ISA extension ONE_REG interface to allow VMM tools to
detect and enable Svukte extension for Guest/VM.

Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
Signed-off-by: Max Hsu <max.hsu@sifive.com>
---
 arch/riscv/include/uapi/asm/kvm.h | 1 +
 arch/riscv/kvm/vcpu_onereg.c      | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index e97db3296456e19f79ca02e4c4f70ae1b4abb48b..41b466b7ffaec421e8389d3f5b178580091a2c98 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -175,6 +175,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZCF,
 	KVM_RISCV_ISA_EXT_ZCMOP,
 	KVM_RISCV_ISA_EXT_ZAWRS,
+	KVM_RISCV_ISA_EXT_SVUKTE,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index b319c4c13c54ce22d2a7552f4c9f256a0c50780e..67237d6e53882a9fcd2cf265aa1704f25cc4a701 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -41,6 +41,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	KVM_ISA_EXT_ARR(SVINVAL),
 	KVM_ISA_EXT_ARR(SVNAPOT),
 	KVM_ISA_EXT_ARR(SVPBMT),
+	KVM_ISA_EXT_ARR(SVUKTE),
 	KVM_ISA_EXT_ARR(ZACAS),
 	KVM_ISA_EXT_ARR(ZAWRS),
 	KVM_ISA_EXT_ARR(ZBA),

-- 
2.43.2


