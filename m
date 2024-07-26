Return-Path: <kvm+bounces-22303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 40DE893CFD9
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 10:50:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E78E1282A63
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 08:50:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A643C17838D;
	Fri, 26 Jul 2024 08:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="aw53i/qI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D015178374
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 08:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721983792; cv=none; b=RFZ2ePHt/sHObBwOD0TlqISKJwTqjj71sTYzGNoJN06unv1opdrdotJBtaeRhuWLUPzjb73EIUj573/qbjIWLC42HBf/1bws6o5El4OvrYyqIFsdUeAw9mhtEfmDoXUt56Xap8ztSLbsPPHQBL7xNRzR/qkTEUeNZHNhDK/+Bdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721983792; c=relaxed/simple;
	bh=ILHUKWuww4mYCtVLOkmdik2BoPCIr2tYG5YBOYvnnpI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=pgff+v0xQ+32VwdQHoI8ZLTRfBlgNea4A2JLJ4FQ+cVUk5x6vSDK2hLHTgNblwAIAFyKluARMFveERmORnzNRQq+fed83eq9T0k2HNOXXNOZZb2trCcnsPmYJrkBNmrT572NlgsLxMznTqaCkiAngRZ29biGyTJ7lhlUQ+INbsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=aw53i/qI; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-5ce739c2650so416545eaf.1
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 01:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1721983790; x=1722588590; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=77ZeIPjPX018h5j/Du3ed2s3nc75ljoul3aJ99owNM0=;
        b=aw53i/qIRvCeDd21uKlmH1h+htwFIepjlpqUmZdFCz19IgTK027/DPid/x2UuLUANl
         kF6bBCsBNJZNvRD4yJNP0q+geJfvDte8rPhigaqIjiAPftgv0lVsC2fwYHfRkWz3iQNt
         0IbQ38mmRaJhEEbm1bGOSKFPZS0iF7p+0nx4U+XWMM19aGT1UctZD2WvD8JuqVlg4Gbl
         kymzQD+jFRDYy9zz/Vz2seCQ9Olwaevwri6F8q3ihDwOSWGrxBez21Ee8xFcWIQGh1GD
         rciumSIteKAh5/XfB/wm95qpHNwVkL2qJ4WKXkaf/Vh2QFLEDNZR1kUv24ZSmnsTqwhl
         thfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721983790; x=1722588590;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=77ZeIPjPX018h5j/Du3ed2s3nc75ljoul3aJ99owNM0=;
        b=RV5vbn1ZVXZ559LEUuUfm+Qg6/htJll3L9Uhnw9pIXGSBlQTfZAGuB95p3gaPrx+ne
         9hKxa7RjfBSPgZkAIYVeOJY6eVsbu6GKwUU3Rpp3af3wFTtSpiwBxGwRQzsrzaXiT1Oe
         uFf5tMcQLOndQe9Cn0WOe1LmcQRrxIgaZnrq0F9IdyRV//odMpWeDev8sJVM1SE2TQD/
         ZBJx4uKj0OCv0pb35OggDicVRjwT2foV+c40nNupbAT+A8biDY6GxIHf2ccVhx6k6m4P
         eTHyDfDFqt1H7Q72Z0YuxJ2RihCNPkXCJh0zk0PytvMJXLgBYbD9Rmnmcz2/ATiiBUU3
         2yeA==
X-Forwarded-Encrypted: i=1; AJvYcCUwX5zNm6Fbnt03m6odTmINhY6WwYL9H5nz6eZKFX2s07PC151jgRLOvVYRccKVE+OaWLQ6/AXk94G0MBZxCRIa0C/r
X-Gm-Message-State: AOJu0YxWo2fueBDWxciq+cE7sTjrC7g2dtBRp2+25q7kD8qNfi9R8/N/
	YTgLJJ0n4ZyM483vj5eG4uWHKokxD4OX6LTls/+ZZzKjNqT+HdyvI5TTa5f0BHQ=
X-Google-Smtp-Source: AGHT+IFWUVeizwcBPBvvU0CwwN+HhSdGaM3PUv2PgwHw7ovlutORf8Wnz0oqxg0bCN2ABKZmavFvLQ==
X-Received: by 2002:a05:6358:784:b0:1a4:8048:56df with SMTP id e5c5f4694b2df-1acf88fa089mr701897855d.22.1721983790331;
        Fri, 26 Jul 2024 01:49:50 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7a9f816db18sm2049645a12.33.2024.07.26.01.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jul 2024 01:49:50 -0700 (PDT)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	devicetree@vger.kernel.org
Subject: [PATCH v8 2/5] dt-bindings: riscv: Add Svade and Svadu Entries
Date: Fri, 26 Jul 2024 16:49:27 +0800
Message-Id: <20240726084931.28924-3-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240726084931.28924-1-yongxuan.wang@sifive.com>
References: <20240726084931.28924-1-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Add entries for the Svade and Svadu extensions to the riscv,isa-extensions
property.

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
---
 .../devicetree/bindings/riscv/extensions.yaml | 28 +++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index a06dbc6b4928..b3885756766d 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -153,6 +153,34 @@ properties:
             ratified at commit 3f9ed34 ("Add ability to manually trigger
             workflow. (#2)") of riscv-time-compare.
 
+        - const: svade
+          description: |
+            The standard Svade supervisor-level extension for SW-managed PTE A/D
+            bit updates as ratified in the 20240213 version of the privileged
+            ISA specification.
+
+            Both Svade and Svadu extensions control the hardware behavior when
+            the PTE A/D bits need to be set. The default behavior for the four
+            possible combinations of these extensions in the device tree are:
+            1) Neither Svade nor Svadu present in DT => It is technically
+               unknown whether the platform uses Svade or Svadu. Supervisor
+               software should be prepared to handle either hardware updating
+               of the PTE A/D bits or page faults when they need updated.
+            2) Only Svade present in DT => Supervisor must assume Svade to be
+               always enabled.
+            3) Only Svadu present in DT => Supervisor must assume Svadu to be
+               always enabled.
+            4) Both Svade and Svadu present in DT => Supervisor must assume
+               Svadu turned-off at boot time. To use Svadu, supervisor must
+               explicitly enable it using the SBI FWFT extension.
+
+        - const: svadu
+          description: |
+            The standard Svadu supervisor-level extension for hardware updating
+            of PTE A/D bits as ratified in the 20240528 version of the
+            privileged ISA specification. Please refer to Svade dt-binding
+            description for more details.
+
         - const: svinval
           description:
             The standard Svinval supervisor-level extension for fine-grained
-- 
2.17.1


