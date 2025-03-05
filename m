Return-Path: <kvm+bounces-40163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 69E1FA502E7
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 15:57:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9EBC188D21C
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 14:50:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36F8C24C076;
	Wed,  5 Mar 2025 14:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HMSXwVby"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96E724E4A0
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 14:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741186195; cv=none; b=JDb0VzDP6A4Ftcv8Ul+hsjXkdj9X8hLVd/eOoxfHwMOV7PyZRHbtNVyJazLMqb6olVn/JFqeCFs+ph7m2vX0Z3IHnuJJvCTMUzPvbEYNt9C44q4fh/xov6jSOOPimyRYRUMWwv9sDjZCcDqz/FYHmVN5Fy13cfYcOe+MMu4xxtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741186195; c=relaxed/simple;
	bh=x29h9M6n8nq7NdPnqRKffAT+4udR1rBlR+7/BBJPG6U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ldODdVp0y2IsiTWg9egOl/Q2H2dkt+DJPnjhIwwQqtLX1wQwop219Um/YDoBcDk3NORJONtrm14cbIbnNYtdgeToEgA1+3BHoK/rHRTZ6GJkIktJeMX+TO5BG+mx+5XipuUqDC3FCyeloY1DeNlpcqVRNIUbLiivS0coS2CE/ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HMSXwVby; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741186192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YM84sfhKyVCM1WHnPi0ugQYCezGBxRCWusGn++RPss0=;
	b=HMSXwVby2bqKOk405hjMFQjOq2pUrdiXgK3b73Z4e+6QHlQMNMXLFk18emABFPdVO5h/EC
	I+LcBzOf7bXhC7nJT1FUZgCT2BYCxCes/1uGbUIvcNozVQgmGJLFc4Zr93q+HPUD7gu660
	t3NH7ZrWc6+h2ECiCKbvzzQxSIE7/nc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-156-h5k52nWHNd6Kfse8xe7sRQ-1; Wed, 05 Mar 2025 09:49:41 -0500
X-MC-Unique: h5k52nWHNd6Kfse8xe7sRQ-1
X-Mimecast-MFC-AGG-ID: h5k52nWHNd6Kfse8xe7sRQ_1741186180
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3912539665cso274007f8f.1
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 06:49:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741186180; x=1741790980;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YM84sfhKyVCM1WHnPi0ugQYCezGBxRCWusGn++RPss0=;
        b=IgucCQtj80d0z4U3+ln/MivYEGCXYNy81MzHj4g+q0R6nXbDKhhTzw76xKLR6CpYLc
         ZF2fEHTGIvxMSSjlhhCXG48sZEqDr/8hbfqCPzhtoh5rO+TOxP6nzt35FVpLo74gf3Ul
         1FN7QJOmRByqClpTdHm4eYaiFqrlM1m3PLdYRj5VgeFyJB4AwHqiT5Me6M6sklzv3veY
         USiXFuJ3Sjf4qY2f2J2ZkPu3x55Ea4Nq1E+keUi6vc4gHOa3b2ZmjhUEsGJ9naqXpB/D
         efSFScxuZMv2hUnUE80BozEkhanuuz3YsYW6yb/aVajXAYHv8HOvycfysmFPZD1qPzqB
         bQnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVWO6URc89O5SMCCqyqKwUoNR97q2ow25PIJDY4Z7J84LVXeNI7NQnGIccJiycDcGv44ds=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBWm2JITb3pvI2o/+eyae7IMKAsfVwTAuAdeGTZqvLRit6cDGU
	VX9MUsOxZngWeb8gh5Vs4/8uH/Rt1Sk7O8KwRyV2woTIM3E7S0koRW/OODj3MVthulfeZk8CZCL
	+54o38mCWeuQi1Gd2XkVbrm6a53oNWtyv3t/J3tJ36zRESFor/w==
X-Gm-Gg: ASbGncu3EdbDLRT1obHA/mPg4FalOmylwL2vXrYuIHorWwVjJtUGAjsg4Mn2Xv5kC6e
	edBJ4EqSXQx97rI182VtUXF+U75735NR+HViQtee6/IrjINQ830Jz9DitCxXG8eb54rr6FR+hBl
	bNf9wM0r6+tvbLfw4yEjh9iXOz/en3LnjLLq/CwuNIPGptn+LK9/4/iW3Y6mr6k1zwPGuxExWEN
	imfBClJ9g7zVDiK1M+DIOkBIWwuOCVu4mtfKE/L+lVnYuCa8bGOL58hNOaa/QxthpoQUwuC8NxB
	C4G0D0OTYmXD9QQ5xc1qqZWN4F+HikcGLHbpXH6FyuUsiRs=
X-Received: by 2002:adf:e183:0:b0:391:22e2:ccd2 with SMTP id ffacd0b85a97d-39122e2d080mr1812869f8f.3.1741186180344;
        Wed, 05 Mar 2025 06:49:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHpZB4BYpB9A76P4a45l7m/RU6UnuwhTcw/rRDIfT7W5uDFJhJmK1bfyR7MVaBtIvxiEQk6Ng==
X-Received: by 2002:adf:e183:0:b0:391:22e2:ccd2 with SMTP id ffacd0b85a97d-39122e2d080mr1812850f8f.3.1741186180022;
        Wed, 05 Mar 2025 06:49:40 -0800 (PST)
Received: from [192.168.224.123] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e479609asm20954791f8f.2.2025.03.05.06.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 06:49:39 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 6.12] KVM: e500: always restore irqs
Date: Wed,  5 Mar 2025 15:49:38 +0100
Message-ID: <20250305144938.212918-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[ Upstream commit 87ecfdbc699cc95fac73291b52650283ddcf929d ]

If find_linux_pte fails, IRQs will not be restored.  This is unlikely
to happen in practice since it would have been reported as hanging
hosts, but it should of course be fixed anyway.

Cc: stable@vger.kernel.org
Reported-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/powerpc/kvm/e500_mmu_host.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index c664fdec75b1..3708fa48bee9 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -481,7 +481,6 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 		if (pte_present(pte)) {
 			wimg = (pte_val(pte) >> PTE_WIMGE_SHIFT) &
 				MAS2_WIMGE_MASK;
-			local_irq_restore(flags);
 		} else {
 			local_irq_restore(flags);
 			pr_err_ratelimited("%s: pte not present: gfn %lx,pfn %lx\n",
@@ -490,8 +489,9 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 			goto out;
 		}
 	}
+	local_irq_restore(flags);
+
 	kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
-
 	kvmppc_e500_setup_stlbe(&vcpu_e500->vcpu, gtlbe, tsize,
 				ref, gvaddr, stlbe);
 
-- 
2.48.1


