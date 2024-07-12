Return-Path: <kvm+bounces-21487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84C1392F714
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 10:39:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E2CA6B219A7
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 08:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B4791448E6;
	Fri, 12 Jul 2024 08:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="BtVV/AGU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBA8142633
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 08:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720773554; cv=none; b=Yd6uAA1xXqh05+6MRA3dvKQoCi0T2/afJvmB5T4CVA14mVVCG5MrJQHjSKWPz2GWq40Ci3+TM+xCTHU4OBIXi1TkudgNZ3tzOa8BBeoTZP892mNJ/xDh/o5NlCVUlWthAT5UoJioAQ5Yf7R4iiuUKgYrEuVXTB8lPtrM77TvLiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720773554; c=relaxed/simple;
	bh=HyKnjgHnajVWdAjv50AK0JmCEqgbEGPN3v54AqK7auo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=glqdCusGbNXEulX+I44kRxRmCIEhdfFrUPiLTjkQnwpPxYrj/PgMsLxoNjZDcx/wnmV48qmC8OriE7JFidGP94NS6HNlW62oJROhx66Njy6Z1ZpDdmhvKQ5sKQq+nqOngS2PxENZxAkOaRj0bWAnFxSyxmvr88y9BAmGQbGDODg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=BtVV/AGU; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-70b04cb28acso1454600b3a.0
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 01:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1720773552; x=1721378352; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=s8FxVWkBbUSRwzKSDXaD3IouygOhaOZodT8e7MKio/0=;
        b=BtVV/AGUzPc9mO+Esgacpo5S+0MRDepHc/tmeP9jDd6NCJELeWOB0QgCXwySQJAxc9
         gZvL6R3TO5rNwfuH4tdYCnYzLvIQ6v1RcVQopnvg0F68RYBAX4j1GgARqnDJs53eQTEN
         +jDoRMR5r0s+IDF7WSXhfGdDJBZOKybNql91JFKgn/X69Eadvd96gb+dpYx5xyIALhV6
         8WwoPvmx5TLYXkdqOl5n3byFByf57a0w+Q7TxvTooWNVq3j2hdysGVnN2QohTMSihP9a
         NK/cafxRWzM8c0KQWSkpaQp/8+dIFN+LkNEBnCQDE2HEHVzVweVIKK7qkiCXKmKgwIVg
         dLGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720773552; x=1721378352;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s8FxVWkBbUSRwzKSDXaD3IouygOhaOZodT8e7MKio/0=;
        b=cS9tc0YDz0KStFKrDXazi/fs9qnbHJacccQQtzdAVyuLpwIajEHhHtoTV+GsA/sg9z
         bs1Ummzxo6KJwaJdctKOg/LM/Jkym+E10NwCkDouPkD+GOzmoMNKydBQAj52jwn3JpRu
         4GTV3wassLgR+G2313BmwjCHLaDd8fS5Lv0iaKHCrA8gVyqRv0wvxDorYvYk84MoC3Px
         riPY/6gx/TZsYuI6tl/yj+hmNeUkRVnPz5fW+x9TpE2q7y5wfAzp6DKq87jpinkbFaKD
         57kvxamCTaGlMGpcYVq0trVqMNultc3v5ILJiZA6kL5wZiXg9NDj5khe/Bv5/slcG9gA
         QrtA==
X-Forwarded-Encrypted: i=1; AJvYcCXlkTshuXev31mWnWRoP1/QMyBSmd4kgGvnsaKe5ijPYuR9xOkghE4Wm8Ck95fMC5YgsRVwZJU62W2NN3LWTiCRUx0N
X-Gm-Message-State: AOJu0Yx+bx6nh6xHp887UNwBml8Vs8+w533JqUPcEihD/cqE6JctMe8L
	Q4b9vF4HrAZu5jFj0jZWLb/8s2iHot3LkE7DoLU9XUJr4rg9SB4UrCwvCBrSN5Y=
X-Google-Smtp-Source: AGHT+IGFZpUIicB4zZC9hrvnR3WIEBPWN8+7c0RwydpX4SwJwlx7pWYViWf5LIEdN2ZgdD/fy0d2ww==
X-Received: by 2002:a05:6a00:8d95:b0:70a:f521:52da with SMTP id d2e1a72fcca58-70b6c976927mr2334016b3a.16.1720773552263;
        Fri, 12 Jul 2024 01:39:12 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b438c7099sm6894194b3a.84.2024.07.12.01.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jul 2024 01:39:12 -0700 (PDT)
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
Subject: [PATCH v7 2/4] dt-bindings: riscv: Add Svade and Svadu Entries
Date: Fri, 12 Jul 2024 16:38:46 +0800
Message-Id: <20240712083850.4242-3-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240712083850.4242-1-yongxuan.wang@sifive.com>
References: <20240712083850.4242-1-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Add entries for the Svade and Svadu extensions to the riscv,isa-extensions
property.

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
---
 .../devicetree/bindings/riscv/extensions.yaml | 28 +++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index 468c646247aa..e91a6f4ede38 100644
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
+            of PTE A/D bits as ratified at commit c1abccf ("Merge pull request
+            #25 from ved-rivos/ratified") of riscv-svadu. Please refer to Svade
+            dt-binding description for more details.
+
         - const: svinval
           description:
             The standard Svinval supervisor-level extension for fine-grained
-- 
2.17.1


