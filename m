Return-Path: <kvm+bounces-9805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F60E8670D1
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:26:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09CB5289A8B
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:26:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E2CB5A4CD;
	Mon, 26 Feb 2024 10:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iLovgzVn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB4463B
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 10:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942358; cv=none; b=Gp/1ZGcjCsbb+/gawbsXzrn51i0gMHhqvhP+AYCM9mXgfAPPhxzq4ewU8i8dO6wrxLBpHjzC4DjgYaWj2FgimykvDdlmWnlu4mobgQ5Oyp+3e4EeXafhhBgEQNjUtKyIr6ry4X1VM4eIDS8oHbou5otkT5uV98WlA7WFH5Z1p+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942358; c=relaxed/simple;
	bh=LzOczZFA3yn85YvMfDeKnlbMu7vuO7KImSNwck1ZH4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urgaf41N6giRwXQeiwg6kvZfKHPtsxlyxW3fA2oo839pvIedo0Wxs+VDV3MTTHBOisA4jGY2/qQ0Y2QofNxE64xQfa0HfLDTNu9AuKVF4EGpCgyLKPmAAm9w9kjzOJyKl/ixVyd0pMZjLRKH1Py3VaDEi/cldf2vFqWHAWL6EQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iLovgzVn; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6e459b39e2cso1542292b3a.1
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 02:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942357; x=1709547157; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TeVEas1ZLpqr2asMqS0auNiXWMhirPfualOJ/EV9PjE=;
        b=iLovgzVntSNFQxSXlCfcoJe/iMsyPSb6LMfN0R+BKilBxUShPBTziBNg9P5DUg1AiI
         AZU4+qkQr/Omwlak3P/nIz0thJPI1O6K+0s5KO9RS4LgO4L1mc28rKDXoJ90qqO1pzhr
         kG24DdDfwnsTdxoTtM5LUNeNBtcFIP1i23Bvi5CQdDfAQUApjcJn8jujJd/oqvfQERYw
         az6tW7MprWRQpJjCfJ+nNLwT53r25M7JefiLWop2OLyDTzL9s4L/UE38/dPceLZQYvu3
         BBu2g3UyLoYtkxOrriL809T91WxRimVLpmbuLAAeSnZe7LzDMUhGq5k3JEBJ+a0ERXtk
         i/8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942357; x=1709547157;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TeVEas1ZLpqr2asMqS0auNiXWMhirPfualOJ/EV9PjE=;
        b=R87plAeejMnkb4T/rLUUncwE/Q/v1VchfUu0p4ugtJ5OWjbL0cEH4wfgMc1tcj0kuO
         qus+GRaCOPjNk0ksKuGOkwd3mR3x+zgYTFLqUj6tTkXVNzlybYJemRmpqB6GAKdMMVdQ
         kl6td6qq5PT9bp02BgV/oH7L9A5WU9ZsjN9GIoe3gECa5+74klbR85KLKgXruzkHujOU
         zrcQcGJJZPZHzEwTvAcbHTG0AKfmbsCsYCBiuTrJbcQDs0E3Oyxby5Msm30R9TVBptbQ
         5YEDsRVNaLKAyonQSFT+V2OPr8Rh4Tbt7eVa84BeLDDNAFKVjjGIqkqfOuffTv1Nn1D4
         UO5w==
X-Forwarded-Encrypted: i=1; AJvYcCVhRquxf8cU0AkcNrlF19oh5uWO4SjWfqu0xexhqGhgTc/DSS4SkXZ6mwpx7zsvO+2F/LJVS8JBBaCT4wN1sZ9dO+Uo
X-Gm-Message-State: AOJu0YxVSYcw2haTy5sQlvTe46Xh116jCqlglvmAyxg32zn2lsHus9J5
	5/lJZl164ivaGkXYsEkT2vTchiD79bfN36h3mQQPY9Xcr2plvWY7
X-Google-Smtp-Source: AGHT+IFZb8KSXVwaYaL5+k/TtLqr++IQfWJzFlxrLVPvDhupsY+JsnD/JLPMimtgjw99ZNSYaPwMNw==
X-Received: by 2002:a05:6a20:daa8:b0:1a0:eb43:421b with SMTP id iy40-20020a056a20daa800b001a0eb43421bmr6637119pzb.28.1708942356894;
        Mon, 26 Feb 2024 02:12:36 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:12:36 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 01/32] powerpc: Fix KVM caps on POWER9 hosts
Date: Mon, 26 Feb 2024 20:11:47 +1000
Message-ID: <20240226101218.1472843-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240226101218.1472843-1-npiggin@gmail.com>
References: <20240226101218.1472843-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM does not like to run on POWER9 hosts without cap-ccf-assist=off.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/run | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/powerpc/run b/powerpc/run
index e469f1eb3..5cdb94194 100755
--- a/powerpc/run
+++ b/powerpc/run
@@ -24,6 +24,8 @@ M+=",accel=$ACCEL$ACCEL_PROPS"
 
 if [[ "$ACCEL" == "tcg" ]] ; then
 	M+=",cap-cfpc=broken,cap-sbbc=broken,cap-ibs=broken,cap-ccf-assist=off"
+elif [[ "$ACCEL" == "kvm" ]] ; then
+	M+=",cap-ccf-assist=off"
 fi
 
 command="$qemu -nodefaults $M -bios $FIRMWARE"
-- 
2.42.0


