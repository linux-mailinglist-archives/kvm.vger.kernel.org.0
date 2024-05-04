Return-Path: <kvm+bounces-16566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C61ED8BBB37
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 14:29:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86807282B1D
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 12:29:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5ACE225DA;
	Sat,  4 May 2024 12:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QSDCZQEV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7641C695
	for <kvm@vger.kernel.org>; Sat,  4 May 2024 12:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714825745; cv=none; b=CwWa4kPoQoWNVsSXYh1OxyTaW/WWaTMJxHu6kznwHj5GE1+o9wsdkqhcE0SsgBxqwxvrLDSz9/M/dlCZWb3YJd1wv7K0z9cJrT2b0YJPTx36wIaJdS/FtsWtV9izONpNJDW8HDdgKqsRq8NTueaGckSZTZxBZ0xDe0lvIsV6K1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714825745; c=relaxed/simple;
	bh=3IMBQaEpa1y9SNdkQQibNEoE11sGpfaodGUOK2Gpll8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvnHdDDw5S44qYl8KVSOfmN79ehjjRbYtfvK+jkdG6EA/r7UlnXb+033btbN1a5V5SqulAGYRjv3C7ZD3iJYWA8dArOFBDjaMUR/fbzg2++SB4yqYyINDYjUFCIpg+rB1/NaBunZ9rxQI4R1qwTRe0QMSYlAlNLRJrbGmY23Z38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QSDCZQEV; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5d81b08d6f2so418814a12.0
        for <kvm@vger.kernel.org>; Sat, 04 May 2024 05:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714825743; x=1715430543; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nFe1uWytdimmtEZbjI3zC2F1410iNZlNbtoiOiPVBV0=;
        b=QSDCZQEVOH7XUAWNArmxtBFcI0+CWRu4S57ZwmMVoxVBzyjjC1vgGSUWLPIlmBa93E
         FJqRpWg2g7CpfnqHBC11kguUBmULIiPZoWLhQndQSOn18xRA14HYDkS8wzVS/UYVFBAP
         K/ss8g00ddQQmDKO3+XMuVAeDFuby1ZPPmjKnm5pxWG/ngcxudgOAe3wFbyeeRaqm4sF
         +scGkhp+eYuSTe4Z6avHMPckESLaFlDdSeF6zgyiwcTmWH5CPESt4LhFm9v//eqWfSre
         50+CmZDGyJetcLts+esix4syMJX0XSxawiLY25o2F9IhngcBMlGbUrP8E+7q8jqlThPz
         b8dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714825743; x=1715430543;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nFe1uWytdimmtEZbjI3zC2F1410iNZlNbtoiOiPVBV0=;
        b=d+xi3D8aodm8O5LiAEqX2EsyECJLes5eqVsCGM8DeXk8gKPHGaXwLHJRMc412C9MRS
         qi8OgGBafnoVXti11hDABqtPUYgQfr7kLQrc++DUzBzFFd0+eVjIPOKRBAsSYLj9iawd
         FQZSyIphx9IGP7OppJo80cYfmxyxIlEyUe3HmdQly0EOmiumoUBYxr8hIx3ePEIm+c9U
         AscH5joJ5VSVgqymLfBfvKu1/Js6kvw9NQ3go56g4Mbq+IMxAWqi61tLTxHtOCpUrn/f
         S+Hfbb5ZWY1hLpS7x/bSdZFqRUb7La1/MmXOgv8H1d3mwpRcOnij5YCVtlATN9bGutdP
         QBcA==
X-Forwarded-Encrypted: i=1; AJvYcCX18UsHrNLcV6hbTHMViIsug4zrwRnQa88uCJqeHRZv5Oq21O/2whuWXTLjQoQJHKk8rmsYfsea05+gucGEJMdRO8vB
X-Gm-Message-State: AOJu0YzoxbzJQTODZTWEC1bVHF7+nzFUnG3gE1n4lLtbjE9N2wr+Oi8Y
	mQySkEmdxnQSXFPTaC7NyWc3s2QKoGYqEKsigP25T1RMlMo5LkbG
X-Google-Smtp-Source: AGHT+IFU5PoRxx+mTNW7TKy4wefEqAB9Vnc58pFz6n9Y7PrQ01UGoWnU/ypMDlEI1b/QoE5Vxl0sIw==
X-Received: by 2002:a05:6a20:9187:b0:1a7:5e8f:8707 with SMTP id v7-20020a056a20918700b001a75e8f8707mr7337295pzd.26.1714825742844;
        Sat, 04 May 2024 05:29:02 -0700 (PDT)
Received: from wheely.local0.net (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000a9000b006f4473daa38sm3480068pfl.128.2024.05.04.05.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 05:29:02 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v9 03/31] powerpc: Mark known failing tests as kfail
Date: Sat,  4 May 2024 22:28:09 +1000
Message-ID: <20240504122841.1177683-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240504122841.1177683-1-npiggin@gmail.com>
References: <20240504122841.1177683-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mark the failing h_cede_tm and spapr_vpa tests as kfail.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/spapr_vpa.c | 3 ++-
 powerpc/tm.c        | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/powerpc/spapr_vpa.c b/powerpc/spapr_vpa.c
index c2075e157..46fa0485c 100644
--- a/powerpc/spapr_vpa.c
+++ b/powerpc/spapr_vpa.c
@@ -150,7 +150,8 @@ static void test_vpa(void)
 		report_fail("Could not deregister after registration");
 
 	disp_count1 = be32_to_cpu(vpa->vp_dispatch_count);
-	report(disp_count1 % 2 == 1, "Dispatch count is odd after deregister");
+	/* TCG known fail, could be wrong test, must verify against PowerVM */
+	report_kfail(true, disp_count1 % 2 == 1, "Dispatch count is odd after deregister");
 
 	report_prefix_pop();
 }
diff --git a/powerpc/tm.c b/powerpc/tm.c
index 6b1ceeb6e..d9e7f455d 100644
--- a/powerpc/tm.c
+++ b/powerpc/tm.c
@@ -133,7 +133,8 @@ int main(int argc, char **argv)
 		report_skip("TM is not available");
 		goto done;
 	}
-	report(cpus_with_tm == nr_cpus,
+	/* KVM does not report TM in secondary threads in POWER9 */
+	report_kfail(true, cpus_with_tm == nr_cpus,
 	       "TM available in all 'ibm,pa-features' properties");
 
 	all = argc == 1 || !strcmp(argv[1], "all");
-- 
2.43.0


