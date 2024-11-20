Return-Path: <kvm+bounces-32158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B62BC9D3D53
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 15:17:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 769C3281637
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 14:17:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0802F1D5CCD;
	Wed, 20 Nov 2024 14:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="cd7sfR+k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3721B5ED2
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 14:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732111790; cv=none; b=YLmEDh5ML8xuS6u2Cd/wJh2oqdPcV6DUYE9wIB7ZkKdEa6GsZjfJMZRTOSE3ik+Xnn3D+0jT8Xg2ar6IaawbJ+HDNjy87jvU+9XvtectDP2sJPFB3rEGbFDhmEKF7zR45fmtJBbqg4/reQY/fQzMkESe0jn8GPGmgPC77XIeI58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732111790; c=relaxed/simple;
	bh=G4f8dg0A+liIdlqDQ5PGVlbXce8P3mr8X0xg0tMM1ms=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rKD1nQE70h54L1UM9fLbKR3/ucb2hP6gqz+bZA/sDo7HVUZ6z8VIK+pbvttIZOXWRMUCIVKPIBqDeXIfJHMVsGrWl4S4TuT9gnDC1u2vie1uqrqBpe80FaCuJhDg1nRVmi2rriSVx1ypHsZJ9C581xZyK2z6lvP3Q3HDzLBNuEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=cd7sfR+k; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-20c7ee8fe6bso20498365ad.2
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 06:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1732111787; x=1732716587; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tlIs8ciSuCEurat2M6T5aQe/KW2jWkSeCjmg9uXPSa0=;
        b=cd7sfR+kIPJc5DJpKoR8guCdM6q4TTy6DonvW8d9LukT+Kzr8gJz9lBS9RgDU70xL0
         nCpGrV/7nx6eQquocsXWsCUR4HkY0qNuVirqy0nstW/9kRi2s0RyMRPvpicZhK4iwTLI
         pxjahehG1xzXMx9HLDeqCwwSa6lNgKQkrE/q6pExd7XW2t3RcQiGiG9jN8bzgteE+uLO
         S0tMwxK+HyXbJWILZpvvJCboyu60XDScsAJR1xdPUkBuNs8Thw5SxOx6sb97MWrYXuAG
         JP8HsJTi2metLbk7exk/ofeS/JZ22oKK0+1KoWzN5fZ/qTONzQzhoE6zBNLPgkduozWt
         L3OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732111787; x=1732716587;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tlIs8ciSuCEurat2M6T5aQe/KW2jWkSeCjmg9uXPSa0=;
        b=SRNV/VNkmwT4FIZlMMVLNu5nbTMo9fOHkAtubchS555CvIogmecNrEYD6iR0uQDGjl
         UslV2PXdfwhn+4iST5ZLLGiGBWnCgczSqKJzojya1XwXq38s7Oq/rIb90J8EO28T7qoM
         9mxBSFdqQo3MwBkPx+4N+i0wZDC0fqNFt0p3iWyBYxRvlrwFHty/gF2Z+LqsiYx8nFeC
         J2knvxll4Yd7KY2U8IJBsqqFa3vSHoBQtAnrK2gK8JKtRIi6ZxnYv/OzIxrH+5hHhUC/
         kQr9DcToYdWQ+QkjvqomhTSh/MbKAe9Kf0w7zxQ3K0onlVGoHbAW3OVitt7rSA3cK4NS
         Mlpw==
X-Forwarded-Encrypted: i=1; AJvYcCX4rrAoHPt/1q+EjaEwmJoE5Q5U2kLztDfr1GkrDEl3xfe8xwkYZc26cG1KPXpsdyrDJk0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyA8PslWO9++9w1dwLnbf2TvtvOwA4WiOq3+jO3o6A/xUj8LfhW
	+fAqg/CebeBeX3qYqxh0tYTFqvmw60RJx+VHq5DOCCkDpxmBgGHjwWSr+HzdlN4=
X-Gm-Gg: ASbGncvZ4aDXRTYA8vfE5UDxZNXPoy8JhzfCuOVCsZq19t4+MulaLap/XCmh7TM75fB
	KQEpDtgG5hM8cle/Ivbe29ng6IE8yueQjQKu0eD7U0jEEPwFyY/8jADwqsWDlPoQ+Vfs8k3fXLh
	DCvR4xUWNOwyAV+XYGafCDq4R+Fl/2YS7LvRUe5j6xoOqPBHPh0WJFrHnoLMKftYOvuTVKvtSNr
	RoDdRiBXNeUJ1Q2Nzh0gU6fFrwIb8UASXdYjo2IMwQIw1O6lEDvB/+uE51cybS9SzEYtSg34jYI
	FtajQg==
X-Google-Smtp-Source: AGHT+IFrtEPOuxYYxZ/A2XZltJcWpegyv2Dbfy8kT3MJUJFj7OhNvu/6CxPQYQZcLvYMlhhsU3kN5g==
X-Received: by 2002:a17:902:f549:b0:212:deb:71e8 with SMTP id d9443c01a7336-2126a372c24mr30209125ad.2.1732111787242;
        Wed, 20 Nov 2024 06:09:47 -0800 (PST)
Received: from [127.0.1.1] (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211d0f474fcsm92502505ad.213.2024.11.20.06.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 06:09:46 -0800 (PST)
From: Max Hsu <max.hsu@sifive.com>
Date: Wed, 20 Nov 2024 22:09:32 +0800
Subject: [PATCH RFC v3 1/3] dt-bindings: riscv: Add Svukte entry
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241120-dev-maxh-svukte-v3-v3-1-1e533d41ae15@sifive.com>
References: <20241120-dev-maxh-svukte-v3-v3-0-1e533d41ae15@sifive.com>
In-Reply-To: <20241120-dev-maxh-svukte-v3-v3-0-1e533d41ae15@sifive.com>
To: Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>
Cc: Palmer Dabbelt <palmer@sifive.com>, linux-riscv@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 Max Hsu <max.hsu@sifive.com>, Samuel Holland <samuel.holland@sifive.com>, 
 Deepak Gupta <debug@rivosinc.com>, Alexandre Ghiti <alexghiti@rivosinc.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1502; i=max.hsu@sifive.com;
 h=from:subject:message-id; bh=G4f8dg0A+liIdlqDQ5PGVlbXce8P3mr8X0xg0tMM1ms=;
 b=owEB7QES/pANAwAKAdID/Z0HeUC9AcsmYgBnPe2k4LuiDqPUonIF/e/ODWE2vS7bEQWO/KzSL
 gPzEPspzxiJAbMEAAEKAB0WIQTqXmcbOhS2KZE9X2jSA/2dB3lAvQUCZz3tpAAKCRDSA/2dB3lA
 vQbzC/9AwP3Nmt74myupKpFJKZXM2QnkuxXGfXcitojEe/gMao05/SkOAHIsf3yJj3RhoV0WzvR
 FiV5XbmZ+jumctRNOxQGgnrBoQV8SpcEOjGN/XKYE1k4eP6d1jtU4WOskADAWK5VSeqDLp+VYYI
 YrcM7vbZ2iimjRdPfPsoasi4+OaiXAaz0eIaM3CHawJR4neDhyVpOzZwBD7IETt90VeEkzrVP4K
 3ltoTNi7EZ+udq7q7ndYCxi/MXYKCvimTV3M39pHneUSPY2cyxtlJu+n9EWZJYL84J9yZtGPlYG
 m2tZd0oX6xwiv1Uh5Z9tqs4UWN35Y8LutJjkKG7vm1Bg9H967btc6VGXZUki6zBLKR5bW16GxZo
 ktGe6dTU9hn2GEOtZjuRD8CmLsTFWW2tMjULAX4WL6++j6B2UgjhxMQ2/2Tjbstu89shjOa0XVf
 b5G5ilXCiSxfoO+EIIhInJ34nsUQzIaicdyBt0mzyfUlH1UiV+E2MVjn0TY15eiqGYZCI=
X-Developer-Key: i=max.hsu@sifive.com; a=openpgp;
 fpr=EA5E671B3A14B629913D5F68D203FD9D077940BD

Add an entry for the Svukte extension to the riscv,isa-extensions
property.

Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Deepak Gupta <debug@rivosinc.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Max Hsu <max.hsu@sifive.com>
---
 Documentation/devicetree/bindings/riscv/extensions.yaml | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index af7e5237b2c03085611daad9e1e39aa93cc8ae95..bf177274b5c6f4cd1c842b4221ca5bbfc2960a0a 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -189,6 +189,15 @@ properties:
             memory types as ratified in the 20191213 version of the privileged
             ISA specification.
 
+        - const: svukte
+          description:
+            The standard Svukte supervisor-level extension for making user-mode
+            accesses to supervisor memory raise page faults in constant time,
+            mitigating attacks that attempt to discover the supervisor
+            software's address-space layout. Currently under review as Pull
+            Request number 1564 at commit 81dc9277 ("Svukte v0.3") of
+            riscv-isa-manual.
+
         - const: svvptc
           description:
             The standard Svvptc supervisor-level extension for

-- 
2.43.2


