Return-Path: <kvm+bounces-45058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 29C5BAA5AEB
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:26:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8EC57169146
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:26:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC40E27E1C5;
	Thu,  1 May 2025 06:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xpdSj43i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73ED27CCF2
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080659; cv=none; b=ZPgS2gnYxyUL9wsEL5lIpTVu/tWUc1/J76ZT9KFFrL24062SiXIheJL+axLqf/Y0bz2aDp4XPDgQfWXDa7M7ZWVvj66h+nwKCWGYg9+bdvbsfybr/vG/Ijps5m7pp7UKpUg3vihu/ypqz1X83ANlwqAFZ9mDfiQZOe+sr8+yFWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080659; c=relaxed/simple;
	bh=ZxasN3Ct0O/wyIn5+fwGEkBV75sUorRCrCfSIEK428M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxDIFR3VDy42G7rM3b6sUB0tc1dl4MKcKaDucoTobQkskG4R6G5Ds1KQMi2kMBZsMgJC3v7TPMNU4q4pDl2ND5h+aSXdAnTnoVhrx3SrH8WFqTZcxCl+15vrhc0AG1ClFTgA+holKni/iEnArnGVDmKUG//n1u+bqQZC99PRByk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xpdSj43i; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7370a2d1981so562787b3a.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080657; x=1746685457; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/+UcETAhnH3DlTkfNI6L/xaOrQDoZAiJi/JTij8z890=;
        b=xpdSj43ipAQdIVNix7+ySulX8Q5+0t11A1roHivtAHnWb/af9GB+bY6cT7k446VJjP
         VpGzM3Q0qQIMKdZWBtXHKURhv4FOtqJuFeDFSoYQuuI5hsAlVllbYgz4mi4AqMFNG9mQ
         nr3V+pHbqIn44jhm7q8dyIBE/8AsJJ3skLpaK11V+j2mXWdvrrcQ4KtIc0+87uVEN52B
         xmvJY4HxplJYx7L00CkPFKYhtJQzN0JYfRF3jfs6QQLkiNLvWeAZblgape6rir94Ebgb
         pcIslMRu1YaTYITT0fuvu1JGnBbhEb76bPQm5Oi0GCbcDuJ2VsQ3H5HMGAw7WNpt6XQv
         EX8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080657; x=1746685457;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/+UcETAhnH3DlTkfNI6L/xaOrQDoZAiJi/JTij8z890=;
        b=A6mHE3qIcf1uDzOCkm8XCVTGmvanz11peDA9Ol7jkBXv8dKAg0hQmnk6hWZw4c+exA
         ax6vcZZQ2q4DDIXicAs9xYcPhTYRToyUhP22C9LZU6TcUcSr/2N17fPoQIBNWT++p17p
         KJfMN2WcHShYsg61LsfzvlvLtsxVcc3z+6JMt+4xbe//9qOOP1QVo8MkNr4EzFS54iig
         N258IRUu8KqK26qwk5RNIeDb6+FxJk+mUHreE44e4UAtFBtPhzzLIFM0kQN3MZihjuz3
         uuZSEBZl9xNI8epVD85C6IDiXxwn+jGf+kYelilKelTVMsJcTMGPH/XcH78C6bqP9JQv
         uGQw==
X-Forwarded-Encrypted: i=1; AJvYcCUmlprlUB+4xBMFMlsgRBgF5JAGP33dG6KobgZo7URGp9nybHbFKqja4ye2e1XPxgwy4Nc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1NjktuU40xYhoUq+xorm0ZpQY75ue8aAuZODlfjFbaQkH9R9I
	Al1ZOI4QhLwh5AbaFnyOxnfSZIsh3rjciTJtpasnBohm+GiYwTfs1G87L3roy58=
X-Gm-Gg: ASbGncthseatV+nnBtBCNJqS1hkBdoHAgp8C+9gHhfg45dnvKNitkf+pkn79UyLkBpz
	mcBVH1DcoxeFZhQA0Ax3UGzkaj2QoHZPcjLj+YoFMNxe+Hmm+WB2wPXoaf8YIv2ATk8L2V7GYOe
	g2eX0GVv/8K/MhG5AVDGlgzMG1CJEqQAxg1wBimaNGdikgKeTpnRfcn5NrHFqqJYajzNMqTUb2u
	4ZTFCl0Kdlslk+Qz+WEJHv3DRS1390NUFcWOQCG/DM8R8gwUzYCdzazaPGRCbP1/BPNFKVpDeDc
	hvpMWl1n1b4B/OOg2ed7FwW8+drgY3vLF8sP76DA
X-Google-Smtp-Source: AGHT+IFO6fCxSsP/dkbciCPmyGC6hhrBvi4oVC/NIhTt06uVNHhT90PcCmbCBk2ph/cAM14rqRmSmg==
X-Received: by 2002:a05:6a21:6802:b0:1f5:839e:ece8 with SMTP id adf61e73a8af0-20ba6a201b2mr3247198637.2.1746080657340;
        Wed, 30 Apr 2025 23:24:17 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:24:16 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 29/33] target/arm/ptw: replace target_ulong with uint64_t
Date: Wed, 30 Apr 2025 23:23:40 -0700
Message-ID: <20250501062344.2526061-30-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/ptw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/arm/ptw.c b/target/arm/ptw.c
index d0a53d0987f..424d1b54275 100644
--- a/target/arm/ptw.c
+++ b/target/arm/ptw.c
@@ -1660,7 +1660,7 @@ static bool get_phys_addr_lpae(CPUARMState *env, S1Translate *ptw,
     uint64_t ttbr;
     hwaddr descaddr, indexmask, indexmask_grainsize;
     uint32_t tableattrs;
-    target_ulong page_size;
+    uint64_t page_size;
     uint64_t attrs;
     int32_t stride;
     int addrsize, inputsize, outputsize;
@@ -1733,7 +1733,7 @@ static bool get_phys_addr_lpae(CPUARMState *env, S1Translate *ptw,
      * validation to do here.
      */
     if (inputsize < addrsize) {
-        target_ulong top_bits = sextract64(address, inputsize,
+        uint64_t top_bits = sextract64(address, inputsize,
                                            addrsize - inputsize);
         if (-top_bits != param.select) {
             /* The gap between the two regions is a Translation fault */
-- 
2.47.2


