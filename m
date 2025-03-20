Return-Path: <kvm+bounces-41609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8984A6B0D0
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:31:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A1043B0209
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:30:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E9DA22B8AD;
	Thu, 20 Mar 2025 22:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NxiYTMWu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBED22AE6D
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509821; cv=none; b=oaI/gzDadGkWW/zT9liWpAj1xfkBFg/luM9K+YHH3sjHvPhWOYDAc27KKGXdcACPk0+kAzvVkrieZrmIb/1bLLFQtZiCLRp7sr+Kru18Usm/PAhUvqEjIDL93DtpFLGW0sH7p35KWYql52dcvXJkLDDLjtlzPfJB4Qfux4+R0dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509821; c=relaxed/simple;
	bh=mcdOHqdvr5mWX43tmVNCNvrcVyVncAfoI4evLJOOr1A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gMDsxdNKLD/SrNHbC+hY8SIkvXtQnKEQTpeVAEC6Mr+FZwyYU3WPbpRtblH9Vt4nkzWWoUWgotspNgX8vitwCQXWUD9RIMSrYno0jcfmUWKlQNFQlNRfm6jnSt3jydbjxP/DruC5Uwwxfb6g9htKJcxYn1KEGMqnrRgkZ2vMvlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NxiYTMWu; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2235189adaeso25861435ad.0
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509819; x=1743114619; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WV3LW27U1S6CRR8HQ+KHd++BnCAdzjihbbqDVw/7qvo=;
        b=NxiYTMWug6pRMp6q/tW3gJpZqHR01/fFa6pMUBCyHNpdmrYU0+lyfc57PfEpMPXE9z
         ja1/N3L+OiSGZmr2nCjpAU+c66IN5CmYFAaO8Htz8Ngavck6vs/o9p8HSQmRyU312L3o
         U5BfuEsqpqinmKIVzK8iZNwyzqNtXmULoUL0NCvt32i1x0h41Qwn1dtU4iZQ7iuLiOhL
         t2JgtbQQdaztIPrpxgXVgsMwo/GUEks/sahPu5xygQcSp2weLbOhKs3RHIHwE0V5Rq1R
         03gofp8qul8bet71gO0mB3x32zhtAndHgitiMP4FuIOGMvnFbJjNytazd9MhKALQPXGE
         r1Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509819; x=1743114619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WV3LW27U1S6CRR8HQ+KHd++BnCAdzjihbbqDVw/7qvo=;
        b=oKLw1BL2keso9tQVaR2MXE5vo1O0Sbj4keD9uNXd9yk6S7DRgc9fcv7m6lSGmejYng
         OmMrQ7CZrzl3Lhu9sA1CNAzS7L1UVS9RVVgd2A79ls4Vul/7IbhARy8bsIeHRPFiKnRx
         DRWdpYuNJrNfwch4H5rtufh+PgEIl41XqCet8oaITjvFw7o7nK3847LyKnDxKufJlHK6
         gEPkqG/eO9/9fHpmxp4g+lM3yy7I69dj39RaglaDaa/O5OOZ2GJBLcaNBIkO9QlLNUgj
         EpSgPTq7r/MEo0x2pIJ1YmUxWFH+AX4xyirqax7U2eefeAN/IyzWXRQ+9lLxx3VGZoAV
         JYQQ==
X-Gm-Message-State: AOJu0YzGtoRTpFVJV5Lipa+gmSRuiAgxSvzyq76gAryEaqM7vmxjt3Ns
	IDhI8B7SUTrHryjTzYbyLnzqC1wZJRqPhTlY1ZHy6sFtHfgsNh8ArpCe2i6mUqg=
X-Gm-Gg: ASbGncu1Nc3PvzATqgjlsQ7YfTlITynFouomBxRlBaeIFh8Etgu3rLC1GzhNZt2NlBB
	31F45V1ty+1gXLsKb/Br1jWys7VhAW9G155Jy7k7Cx33q3lIfRFXyoDq3zTXTCESMrIUY3Ow1dl
	hhJ1t00bUin6mscYAPtGMutuXRaUjY6mzdTuH/UDtWehehGGs0RwEWVsdfTPf4zIuGs+m01y0Vd
	XPe4dlJ+RZz69KF02b47uRZ8pjDYlqq86XZs0Rr0LXodeQYhSY1CWYfZMNUs3bIt+Tba6x2kwS7
	QOOwJA99F3SPwpBhy/BB1X+beSh0ZmFIH+qK0K7kAtbx
X-Google-Smtp-Source: AGHT+IED8IFTqMazkDY9snv2i72ahMAdbHAQB5NY/WUQDtMA8YVwdGtezdctsB52KsHL2IZ1WgTdvw==
X-Received: by 2002:a17:902:db06:b0:223:5187:a886 with SMTP id d9443c01a7336-22780af52cdmr16943575ad.22.1742509819670;
        Thu, 20 Mar 2025 15:30:19 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:19 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 06/30] exec/cpu-all: remove exec/page-protection include
Date: Thu, 20 Mar 2025 15:29:38 -0700
Message-Id: <20250320223002.2915728-7-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/cpu-all.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index eb029b65552..4a2cac1252d 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -19,7 +19,6 @@
 #ifndef CPU_ALL_H
 #define CPU_ALL_H
 
-#include "exec/page-protection.h"
 #include "exec/cpu-common.h"
 #include "exec/cpu-interrupt.h"
 #include "exec/tswap.h"
-- 
2.39.5


