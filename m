Return-Path: <kvm+bounces-48474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94DA0ACE9E7
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 08:15:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C5EB3AB48E
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 06:15:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6338E1FC7CB;
	Thu,  5 Jun 2025 06:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="HQMiZLzv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210C61A5BA0
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 06:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749104115; cv=none; b=Z9I5WGgb/BGpN/VxclrztSGV/VanZkK0yJ1rbdP7belnxIojJRs4AiEXiN8vxqNM1pq+8MJ9G0ypPZKFGSOFb9Rlmk/9J+5adtaSfvZTr6w5kdkCKhRETY7X6r3+LjvRUxf20zpuUB9DTqm4T9eqqjMxPcU826VSVTbnO5RtVK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749104115; c=relaxed/simple;
	bh=woPsQAQ8aD5eXj0e0btcPjRxg9lkePKpxbumcqyxfL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=teVChwLZlsJ0tgMJmLgsD31o43UzwvQDAqUL/qnvD0hY8YuinAzZiisX9oXzZyaCs26yDEtX4mYSFOuoHtLeMkF+yQJXWkiCXDDbvJsolLSYhg4uI9NOiX+jB/LvipXH/Ccxp/o+skJzXUwe87uP3ZSF7zlYjiVfnyifl8VkzqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=HQMiZLzv; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-306b6ae4fb2so631512a91.3
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 23:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1749104113; x=1749708913; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z6EY1voNzcSK9ojB16bH1YicliuGIt5A/zH/wdqEteM=;
        b=HQMiZLzvOlXsupNKAvH/OVWXXbToYao3hUldDJs2IBQHuAXs/Fuq0Wq2rh/V1pAHit
         fRP9hBEEEhe/C74RlQurjfnuPIc3v002vt/sbaLHJH+UKGv7LvqZJ1bloFoASdg1A+ym
         inQ3uVXUIOpm8/ue9KFyFwuwSv9sDdBV5OJmImXt3/HL1br1SVpWZcR+U10vW5kLbVfX
         biFqiBN2mn3ndborCkXGERy5oCpWIiZNcdu9BYVrYdFEjuCnYtQpp0pIhAMPiMA+jZFd
         lvz8F0v5GOQzrikSq1IRQdyrlnA+cEs5E6SscWW+boIxqF7l9o1INaoeosUCvjXCL0ov
         ODiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749104113; x=1749708913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z6EY1voNzcSK9ojB16bH1YicliuGIt5A/zH/wdqEteM=;
        b=qcl+pxT4ROL7VkeG9onrzI2rKkfFmms/URFl9qkQA/dPP73CfXYv3DxeirgDRUj9Am
         ezI4x4P/OJk/TH1GnqwbjKRd+/9oFrBxbl2YvMMpqi2Diulqpzhdb5dQSQ6skw7O7aYG
         oc9l7578mABpcJgyDF+jAEDr5NMsPjRXEToFyazPwnIWcO883VnK7ZynBEthlrUb4sxE
         1hqec/6PXAp2wBN0P4KtIhC3eHUIuuDouwGb7iEj8W4C4wbvZphImxQmAo5TCgRQ/vbC
         nmtAFuIDwWIzNTQm1gOdrZmuz4p2GQiPJeClSiCchhUF9gwT4DIlCXJdPsbUppLDHFxl
         gAbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXf65O6rV8pt1R6TORzKTTv8LkAnXHMhNumVm0DSzcYvp+LolHU+U/WO3CAchYm6SBkBEc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyr795wfEmF+lXNSeUEqn85FAqDd6P860IoEenMfFe6gX76VCAs
	K7JKEJSGgWwEe6f3PYTBKc3AfPaOvbztljxoOo5LnYbw73BtAdkh4tCEP2KTCozRG0k=
X-Gm-Gg: ASbGncsd8ZZbTDbKjw0TU7fUObNe4xDhSZQc25CWUvXcEyAMiiTx8jhfIo1phJjqlb4
	MSwKsbwSyLeqZLuGX2vCo+J+tsvbLj8ata0YtEmwTC7Fn5Uk8eJqZ9v5ijCXsjcJx1xk5jrD9W6
	rnG/YQY7iVDjWz6AQGg7dy6fbY+bJCUJeBjWRLn2ugAHKcZaaPKrqeEsxh627CAL3dcAGwz8i93
	6GFJaNetiniOZzOvgyD8JuidO5MAV0fdSIPiO79/WiBGQlZhGKVZI628+5kj/Ho1UZaQtxDRbh5
	O5poF7/cduTrbMmCyHW8dk7nvoPtKSRypaJQufJ8byozzmitOyUQte2IfYVP6Ep/EyxY02gKtIm
	sIIu0JAKkIMvBLJqg
X-Google-Smtp-Source: AGHT+IFFxi4gniZBsMh1uNNeEYBLb4/KPrhz9tn6tI1ZmsRYmgudY+gvcTjARMukQYkeSUEQVSE1LA==
X-Received: by 2002:a17:90b:164b:b0:312:959:dc42 with SMTP id 98e67ed59e1d1-3130cd15a69mr8793286a91.11.1749104113144;
        Wed, 04 Jun 2025 23:15:13 -0700 (PDT)
Received: from localhost.localdomain ([14.141.91.70])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3132c0bedc7sm716026a91.49.2025.06.04.23.15.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 23:15:12 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 02/13] RISC-V: KVM: Don't treat SBI HFENCE calls as NOPs
Date: Thu,  5 Jun 2025 11:44:47 +0530
Message-ID: <20250605061458.196003-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250605061458.196003-1-apatel@ventanamicro.com>
References: <20250605061458.196003-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The SBI specification clearly states that SBI HFENCE calls should
return SBI_ERR_NOT_SUPPORTED when one of the target hart doesn’t
support hypervisor extension (aka nested virtualization in-case
of KVM RISC-V).

Fixes: c7fa3c48de86 ("RISC-V: KVM: Treat SBI HFENCE calls as NOPs")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_sbi_replace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
index 9752d2ffff68..b17fad091bab 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -127,9 +127,9 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 	case SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA_ASID:
 		/*
 		 * Until nested virtualization is implemented, the
-		 * SBI HFENCE calls should be treated as NOPs
+		 * SBI HFENCE calls should return not supported
+		 * hence fallthrough.
 		 */
-		break;
 	default:
 		retdata->err_val = SBI_ERR_NOT_SUPPORTED;
 	}
-- 
2.43.0


