Return-Path: <kvm+bounces-50795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 92ED4AE96DD
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 09:35:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEB4A3B7A6A
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 07:34:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B00252586EA;
	Thu, 26 Jun 2025 07:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="kngJ9mEN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D6A23B634
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 07:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750923308; cv=none; b=sfbEt60tC+2iKqBiPhJlEHPm/7uu2npunzqME4hHY14Zr2UKVi17RMYKMRHFBAP9aLNC2FslTflwV65SNuy5F0y348KqjarCrHX48ci4DL3EFdiDpjxI3ZP/rfQOx2KM6DQ3RmwGbAsMz+eOKQHOsHUkdCa9W6/0VqlSj+6fLWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750923308; c=relaxed/simple;
	bh=V0t40/cDarifkRk2kNKvj8xTlqukAfLR+XcsTBAmKOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JsglrNioy0BI109z/vn30ZRONCauXjuMXNBIONryuUmcIWPDj4uGUtZ9OCFyPCB8mscQs/cedl/tpukYj9oF3r6P2eg2I8QC6Yym70xKGCpa2xlwi+sM4fm2+Pm9n/IBam52EJJwflvGRM5vodJgXWdvaCRqM4DDErNzzB/in8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=kngJ9mEN; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3a6d77b43c9so610902f8f.3
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 00:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750923304; x=1751528104; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F/uuUvpHNAh5eceFxSujhVaziUUgi2G09SfMmIp8+2c=;
        b=kngJ9mENRfTcDWqK4udcpiDhc0TK9s0ItOdMTRQ5zrBRDxyr8DUoFH+JKExcoPwcn+
         /okJlyAzlApJAH+8E8cteiUxJRadVcwhvywHRut11+VuWVaXJwc8u1ZwgPdMe+5XmCkz
         kjlbvnCQmSse3VNw5JSSMTIkntVMbUuyi0Lmz2Vx1pv41PXWjxEwifiL3d+6REp52lXX
         4ui6TPTrkxbS7CFkJUCWH5f8+WHfTv3WuZo7DBQ7/fPTTdVsm58XwP2i1vNfgagasoR8
         eX/EfPqY/z4WThdAmEB5rFwwENMdlJG+yOrSACMSCSPKvC9Ea392A1Jtj+U1UNT/vs1Z
         aqYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750923304; x=1751528104;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F/uuUvpHNAh5eceFxSujhVaziUUgi2G09SfMmIp8+2c=;
        b=rj1SoqHJ3VZzWGsvR0Uqq0GeDt4ixlhE3ru7r1OSdX3Qh858tK6fmQPi41rdJVLBFR
         RByBcv1prHnykztTE8HAHqYEoFVuV4nsjjahsxkv7tbLcm/OMbhpUG4j+yo/z96ytm46
         +zL+KQociSV1mqXyeOZ8hh9DRIEz9BxyLC4mkTITdYKFu1I/0lVTu8o6yh9DdHYgFewR
         VCaFUbiM1wyXutTOZJVp1O5JMSDeioDdkDLMXZ+H69YE5OOReI5kKfy/7E0EN8IbCPI6
         0WSqJysWZjQFwcCVyGWzPLLh8hlBGSgsQRMVuseN55nySfAygXsPM8fctL/pdTwnRz8B
         UjfA==
X-Forwarded-Encrypted: i=1; AJvYcCVrclHEupSKdjFozLSAOEdpCz3epUl98XCpP5wpKjJlkP5Ty4CenHteft2qZyeggmXTx0I=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvVoGyZU4qk7s+OkgcvbkN3ALx44w39ReyV+PN26WGUNNt6Tfc
	u3wJft3oHHDjcnSf/ffGEz/NpejGW2lmXC6DV5mc2gmLQPPpyJ665DbL5UznAu23cWs=
X-Gm-Gg: ASbGncsJfKuNtl/Pvc6MG+OPD5P7O4kxY2rNlvlx9/DULTsNdkSVNckOUz4hlVwbKKP
	IPWPpy1ngsCDPIjqXkunZ78+rw84N/4B/QbpEkz6YZSwNqHUMgPjFSn28UcnpXjl+t0yIwAwYa/
	ObUBW3OLY3BzIJ9yRkR7YgMVkaak2U5VGCICLKPzx3S2GjQ9lQUX+pslU/wq/bs3z45yXRyNdTV
	YemMpghmVjCb488TDB0lXrD/V92HQSufkQKHFVsojZpPB0pKNHYmvza93kVezci2+rjeT77qbAp
	+CgPIM2//HMO7kdcOtT7jPrao66WSaEBAU+IPeBzW4VO9dwzmnegWu8NSEcNEj3RnEYlmF5YJyC
	w4h9JR/R3FHA7ge1qkbwN3LPx/QCiErqZrPPc0iBBlumYCHakcVF7cVM=
X-Google-Smtp-Source: AGHT+IH3HYX1US0UcqGP9fmbnL/NFruUf1VpoJ8DZk4odvZXBFjMICzZc2sI/P3s8TfkF+VbmMsDdg==
X-Received: by 2002:a05:6000:178e:b0:3a5:3e47:8af5 with SMTP id ffacd0b85a97d-3a6ed637801mr5372513f8f.27.1750923303730;
        Thu, 26 Jun 2025 00:35:03 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e80f259dsm6692451f8f.50.2025.06.26.00.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 00:35:03 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Chao Gao <chao.gao@intel.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>,
	Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH v2 01/13] x86: cet: Pass virtual addresses to invlpg
Date: Thu, 26 Jun 2025 09:34:47 +0200
Message-ID: <20250626073459.12990-2-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250626073459.12990-1-minipli@grsecurity.net>
References: <20250626073459.12990-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

Correct the parameter passed to invlpg.

The invlpg instruction should take a virtual address instead of a physical
address when flushing TLBs. Using shstk_phys results in TLBs associated
with the virtual address (shstk_virt) not being flushed, and the virtual
address may not be treated as a shadow stack address if there is a stale
TLB. So, subsequent shadow stack accesses to shstk_virt may cause a #PF,
which terminates the test unexpectedly.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/cet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/cet.c b/x86/cet.c
index 42d2b1fc043f..51a54a509a47 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -100,7 +100,7 @@ int main(int ac, char **av)
 	*ptep |= PT_DIRTY_MASK;
 
 	/* Flush the paging cache. */
-	invlpg((void *)shstk_phys);
+	invlpg((void *)shstk_virt);
 
 	/* Enable shadow-stack protection */
 	wrmsr(MSR_IA32_U_CET, ENABLE_SHSTK_BIT);
-- 
2.47.2


