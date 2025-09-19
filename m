Return-Path: <kvm+bounces-58120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CAC06B883CD
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 09:43:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8A8F0B61D51
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 07:37:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48BCA2D876C;
	Fri, 19 Sep 2025 07:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="ILMwbVmv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1330C2D6E6F
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 07:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758267472; cv=none; b=WnChMg9RYORPhxFob4Lrgi5iMfXw53VDRuA62c29EnNFg4FaItzNOVl7De8j7OXbxeheim44gVpuQc80DKzsn4YPCfomnUc2Hx6uYDyc6bKZBqoOUdkJMxFNLb4454O/EhVzfZlsk4ylxmh+/Q1WHonHS3V9w1IKCdIdiU/QR8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758267472; c=relaxed/simple;
	bh=+YpuvhJCI/yShT1rtWNvOFpxGI7l/ehsFRhKIaNPItU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkylIjFnpn8jgf1+V/7Oh+a5aVXY2Id4KT5s225l6ry5i5r/cgaGjQt5XN6O+tuKG2OPlTBaR40M3/tdcsyPiDOJk/G2jL9x1YUF/6Su/R0MK+5V0emhNA35kSNUMSHEEjfhHSZG9rwgxP2VsV1IrD3JR4SWAi85+M/3snbhirQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=ILMwbVmv; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-76e2ea933b7so1793242b3a.1
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 00:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758267470; x=1758872270; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kcpuRb5Zady/Ndj7TK1NVXuo7wdyupAjCmRtQU7qg78=;
        b=ILMwbVmvePhwb63VcL6xWvyq86V2LqZ5vXnadEgJSykWDZwrQbtAnlaKSLd3nA6aMV
         jjV2urD+9mkl06Sa4OQeeh7HWIPO0kMaFmaEAXwdo2FOU60uZ4RIqvqs0I8QlAOBoBxT
         9axFeZevbtti6CXIFJ0keSVca9dPy7hVEEoe1iHCa5009KqC2o7FtDiXeVWQUJOJUvZb
         Lt1y55GTQZmmN1H8cm3gYunoYcwbpSViiSdjlmuPTwSpG+TvAmJzVz6zuk9aIX2gMFCj
         0auPMTS8G7O/CtzigwFHBUHWa9W30oulwiCRzilvQtvO3eJtrZtv0yciY/YDCRyhwVpk
         dTLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758267470; x=1758872270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kcpuRb5Zady/Ndj7TK1NVXuo7wdyupAjCmRtQU7qg78=;
        b=twniCv1Gf7ilIUqyFzkzTGEwy227VmKsx8ezpvXLx5V/ZT2jr8Z/ivE3KN0lBvo5EB
         32FZ/vNAgpJXiIJKVu6/MZs3jSGc6aX5kLXY3FCkJgmmrX9EGIzDrs3MCElC88lqSa56
         V7DUHLK00/EZa9Fpww+KFElhoDGBml4pDnJkqY+ubCCI87ANSkEIjq8pnGVepTAqeqzI
         P5ZLngWfI7lwsk+OCyPG4CT2Vz0NFjvgMt7n4ZpPWZtd3JeORPDnDUsS9yrQjAcZwI5w
         sZKOlWa37y1iiE/gX7m1bnGdTkFuMacTo91XDsT1GqxubwkHCN0DRLyzbCd7ynu9JwvR
         RrGw==
X-Forwarded-Encrypted: i=1; AJvYcCWhWLZoAgcOm3CpRjSc94+oJcQKzC8qEg/VdIlrViyR28s1aarijCbGbsHVeyNyW8pGCsw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYrHxPNlCzI7uJV88xBEcnHPBazhmB06CmvesR8pPHb7R/Fs+J
	XLVrwsnPSWmZWXWAt293m9rOPNbztTJ+Ngakmd4ssA33k3SBejVZ3QV2Xp+rajjrZ/M=
X-Gm-Gg: ASbGncuyGej/2PS6GGQr8qypsZZINLpVq/j4cwbNBSbf+jRYLlqOCra9oOMYZRmkLtu
	HRHMSHG6z2a25iEwJPdwbMtPIq+BEMv7Cj+mjc11oj4P8zj388Olzqofd9ea4I+m3krPt8c/y03
	wSY/xtN8G+s2hOG+ir2sQlpcnG4wiWDQjEPix6uzgA0wZ1ZtgDqWXOT042oMOwG5WGxyzOHpiER
	i1dbc5CcOqqlbt77XiJMDnDnHf61PitKWRMJembrsiJLfwn0q1cza3k9dcXuvwezrFGgISOxcX2
	BV9G5GCyq7dtH8R7cE6J4aVSN501jYBqtmSlrSYUZAqXHVnbSbwlBJi0UVp4r3whJioxcerfVV1
	r61iPnUUtt5HDwiaB1SxNze/baQLeC28ICkczIHOgid7Vk8tC/IbLC4FKcrH80mTTsV2cRZUWhK
	Hcwkl52MLljyAOWlhozPem9OyZBxiUNfVAF5+6ftp9GA==
X-Google-Smtp-Source: AGHT+IEgACB1Se8zkEhUh/liD5ZfRMe2E7bZVsNaOovjpda2dN5kxeT40rB2jna9QVBQYl1FDLn0SQ==
X-Received: by 2002:a05:6a20:258e:b0:248:f6f1:200a with SMTP id adf61e73a8af0-2844b5ca29cmr7654865637.1.1758267470068;
        Fri, 19 Sep 2025 00:37:50 -0700 (PDT)
Received: from J9GPGXL7NT.bytedance.net ([61.213.176.57])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b550fd7ebc7sm2679096a12.19.2025.09.19.00.37.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 19 Sep 2025 00:37:49 -0700 (PDT)
From: Xu Lu <luxu.kernel@bytedance.com>
To: corbet@lwn.net,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	will@kernel.org,
	peterz@infradead.org,
	boqun.feng@gmail.com,
	mark.rutland@arm.com,
	parri.andrea@gmail.com,
	ajones@ventanamicro.com,
	brs@rivosinc.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	pbonzini@redhat.com,
	shuah@kernel.org
Cc: devicetree@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	apw@canonical.com,
	joe@perches.com,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	Xu Lu <luxu.kernel@bytedance.com>
Subject: [PATCH v3 2/8] dt-bindings: riscv: Add Zalasr ISA extension description
Date: Fri, 19 Sep 2025 15:37:08 +0800
Message-ID: <20250919073714.83063-3-luxu.kernel@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250919073714.83063-1-luxu.kernel@bytedance.com>
References: <20250919073714.83063-1-luxu.kernel@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add description for the Zalasr ISA extension

Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
---
 Documentation/devicetree/bindings/riscv/extensions.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index ede6a58ccf534..100fe53fb0731 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -242,6 +242,11 @@ properties:
             is supported as ratified at commit 5059e0ca641c ("update to
             ratified") of the riscv-zacas.
 
+        - const: zalasr
+          description: |
+            The standard Zalasr extension for load-acquire/store-release as frozen
+            at commit 194f0094 ("Version 0.9 for freeze") of riscv-zalasr.
+
         - const: zalrsc
           description: |
             The standard Zalrsc extension for load-reserved/store-conditional as
-- 
2.20.1


