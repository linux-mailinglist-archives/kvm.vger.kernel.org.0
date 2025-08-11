Return-Path: <kvm+bounces-54357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C40BB1FDA0
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 04:14:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 809F518978E1
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 02:14:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A90E9270EC3;
	Mon, 11 Aug 2025 02:13:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1208F21D3F8;
	Mon, 11 Aug 2025 02:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754878439; cv=none; b=Ygeu6ni4dNAUGjIzASZx/BGnUpJLf2mO1KZ5+B5AJgt4WogIQ0+eoeHnCU4MMgXnHxFn01QASSF4beAy4n5eUXKB6ENr8HMWeWn8k7+iD5FuX1Rm+2R9/ialTpoOoFtHhLXVEQkLgQeMW0dCuj4RM/Jsr1O5iCOfn/S0hd++27w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754878439; c=relaxed/simple;
	bh=7vAkJtKo3FveG5MTxuL5gAc7sv8e8abfVuekYqY2PPc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CrRlw4VqW7eWB+EQXGjtMhoZHuaPzBud9xojBf0MjGruiouqptC4URSnkpPz9HMINUecUAzSXXsxdyh1u6b3srzmB3JuZ2xgbJAKFEUvzXXtvMAb8oB7k9ZkDfUU4Set/jFwbJDj0/3us2A6gz6ROBp9mSzkrU/j0p1PJPYsm5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxYa_bUZlooxg+AQ--.12809S3;
	Mon, 11 Aug 2025 10:13:47 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJDxQ+TYUZloMZtBAA--.48509S5;
	Mon, 11 Aug 2025 10:13:46 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] LoongArch: KVM: Add IRR and ISR register read emulation
Date: Mon, 11 Aug 2025 10:13:42 +0800
Message-Id: <20250811021344.3678306-4-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250811021344.3678306-1-maobibo@loongson.cn>
References: <20250811021344.3678306-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxQ+TYUZloMZtBAA--.48509S5
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

With 7A1000 user manual, there is register PCH_PIC_INT_IRR_START
and PCH_PIC_INT_ISR_START, add read access emulation in function
loongarch_pch_pic_read() here.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/pch_pic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/loongarch/kvm/intc/pch_pic.c b/arch/loongarch/kvm/intc/pch_pic.c
index 70b8cbeea869..2e2613c436f6 100644
--- a/arch/loongarch/kvm/intc/pch_pic.c
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -158,6 +158,12 @@ static int loongarch_pch_pic_read(struct loongarch_pch_pic *s, gpa_t addr, int l
 	case PCH_PIC_POLARITY_START ... PCH_PIC_POLARITY_END:
 		data = s->polarity;
 		break;
+	case PCH_PIC_INT_IRR_START:
+		data = s->irr;
+		break;
+	case PCH_PIC_INT_ISR_START:
+		data = s->isr;
+		break;
 	default:
 		ret = -EINVAL;
 	}
-- 
2.39.3


