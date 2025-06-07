Return-Path: <kvm+bounces-48697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60EC4AD0CE1
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 12:40:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E3263AFA44
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 10:39:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83EA821CC71;
	Sat,  7 Jun 2025 10:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ImfyPyac"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E1613AD38;
	Sat,  7 Jun 2025 10:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749292793; cv=none; b=QFKtwe/4ELy/pveYnlt7w4udpHzK23LsWyOR9UG0iztLRPwZFe9zRSyxfOKR3FLqAL3kJfmD3AtuYm4paESztOyGtspa8oVSdo5M1Bg1NdQ6eG8bcaLIxAFmo4pOYMpdadlGggDqpANnHE0ATASrDqwZlMapCncyoMvPQAT8RY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749292793; c=relaxed/simple;
	bh=RE3tXUrM4bm7+iA5yAKQLpWH6JZaXZuYLqtW3Y+ttLA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=t9Q7bsCyLLo6AomutX+grnpAk8e6XRLV60SvwPNzN9fTrs7sTN44ctjcUJZLRQrUChO12QlHmEMRRQo3XZ61xxSpOG64Q0Vfquu7IvtjtEOer7EjmGuO3TSsPQKdo0OqiJNcw7r8YWZW+OxdTLUWZ4kbG1TfaEz/EC5yIbwdJcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ImfyPyac; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3a4fd1ba177so2049546f8f.0;
        Sat, 07 Jun 2025 03:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749292790; x=1749897590; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WPyo+f5u+pZwh1nTlph78auP3X9q253JZ2K1lN/sHWs=;
        b=ImfyPyaceX/d/wSbXfKskXKuQXLJHyohT/vqp4ZlghInDqcGESeMU8L7h8JFIEgbZL
         c6qWCH9tJLAC8kiq8EtTNOS3CMkGg45mdeWl4dlPW6vWHJu6dHzaIc6cNTCZ0wjidXhw
         Zr7n4t505RbLuq+T+EBERgSlKGDZP3WZXwAF5WZB1nanpZdtzRrkoVLDPb2d6Ic/hDGi
         yv9udSS3EnD600toQBEhTpXbczbsVV5gPY+G7+1PfhIoL09QuGwBLTL8qX/5Cykd+QCV
         D1IxpQXa5VMZx8fecTsybrpcLM1Ux4WKNarMB8jz8M93zlkg3feq4ok0NTlEMek58jpJ
         J6Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749292790; x=1749897590;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WPyo+f5u+pZwh1nTlph78auP3X9q253JZ2K1lN/sHWs=;
        b=dvFvmx1R0Py6KrGdI2MT7SfjddxCTe2zkouphxr911an4cksEIFIN7M32IQ0epPPmi
         qal0eEC2ARhw4g7qOKp2CKVN9Xkd5zOj9ORSmclnS4G6Bq33sv9JeSjh4WR4Wg6j+Neg
         nImuVBKazO5aOQhTQIJES98BEENFFM6ENH8OtKmHrRXlQ6peOEWzgqAfy3dMhI5SSfdy
         ZFKNJntZh9kiT1ssWo+rc5F9Uz6NANK+ZWzQpjN7MfF174zpGEvGo5OoQOBMgkwguKYd
         7fWGwv6+1FK7eABjoSsUgGeVtYsgidAkWVHFBs0EzoTIG2S3Rfsr8/koFB63jhWYXeUJ
         1ufA==
X-Forwarded-Encrypted: i=1; AJvYcCUCiChWayNzBnm5Fb56uGbmpFG7AUtrqHbsZzvcdhQPcle9nikCD3b6k4mOE5b0iJUvgYNYTmNPGL/MMOtf@vger.kernel.org, AJvYcCUiBL0qUtTIpjeMuv9ucqylHIczudqbb/CJDi67Yvd0LsZgbb3A9Rub22X061FCTYq22ys=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiUuwGdo94RGubEipvGtcYOTyLgbAz7ZyJCzvR8OVHBnf/pFkI
	7vF0WWUNzlS5JzgI8U4TBheIAIvznvamE+4yHiLTFlNqt4rjPb0e7wLr
X-Gm-Gg: ASbGncsD3usjggmFy5Ng69yM+T1loghYuRLIQw1B7egt2R7xcpIjbj8QnXMnwZl98oB
	kIRPa2VqFmllwvMXV8O5jXVvdOcX8OxT11FDdovq6RGdWYQWRlAU9QBuYQBaQNJjxSBQo4ReYGr
	rDgI0AdD7h2nMm5g+1iQtkors3lT2Cyj6MHLbFlMD/qONDP8uZoUCgABzIgBkY/VNSwbSsFdisl
	xpg0bLveFp/gtTdCFNtHaG10mF0fzxC8UPVzS7Q7Z0pIGPQGZEM2nSkFZM4BSl8EXzkfGZDXLbI
	uVNeleO7D/pDaymhqbIvHX9pOjo+JLFyzg3c4HXYqpjp78bUpo3E
X-Google-Smtp-Source: AGHT+IEgr9eZctityaMoUBJwBvcE46VmtYvzipkVJHROPn3XPlopibChXb5SVwSHCBWrSPdIP/nhfA==
X-Received: by 2002:a05:6000:2088:b0:3a4:dfbe:2b14 with SMTP id ffacd0b85a97d-3a531327dfcmr4560249f8f.16.1749292790064;
        Sat, 07 Jun 2025 03:39:50 -0700 (PDT)
Received: from pc ([196.235.97.142])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a532452d7esm4242508f8f.85.2025.06.07.03.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jun 2025 03:39:49 -0700 (PDT)
Date: Sat, 7 Jun 2025 11:39:47 +0100
From: Salah Triki <salah.triki@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: salah.triki@gmail.com
Subject: [PATCH] kvm: preemption must be disabled when calling
 smp_call_function_many
Message-ID: <aEQW81I9kO5-eyrg@pc>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

{Disable, Enable} preemption {before, after} calling
smp_call_function_many().

Signed-off-by: Salah Triki <salah.triki@gmail.com>
---
 virt/kvm/kvm_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index eec82775c5bf..ab9593943846 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -209,7 +209,10 @@ static inline bool kvm_kick_many_cpus(struct cpumask *cpus, bool wait)
 	if (cpumask_empty(cpus))
 		return false;
 
+	preempt_disable();
 	smp_call_function_many(cpus, ack_kick, NULL, wait);
+	preempt_enable();
+
 	return true;
 }
 
-- 
2.43.0


