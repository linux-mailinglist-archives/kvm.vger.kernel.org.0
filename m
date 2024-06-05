Return-Path: <kvm+bounces-18897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A82CE8FCE1C
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 15:00:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C3F71F29B59
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 13:00:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4D461B1510;
	Wed,  5 Jun 2024 12:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="iAZOCUTk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A5A1B14FE
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 12:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717589748; cv=none; b=UFxT4sziinTHfNQKoHELE7LJ3N4guSI7DhhvK5m0Gf2TqLIdJrJfZRHUai2i074bCIkleLiP+Mnu9HTuSTM0KfTpkuc1EQRkFer5bilAc3IMnCfXFpoBGAp5QaT/adbzawsirqiAGjFPTYglV6ZduNc05UT5wOANGB3zh0rLyZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717589748; c=relaxed/simple;
	bh=7vv9BIxOlTAnkVcmOEbkz5pJ3DyqNEvdcN47CRhSbiU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=q02P3LOvo6XkoVPUAGbp8ukqDLA9nHy4Sd3Qe7dkpqOWzLtbwxj3GQBFfbtGSFdp90TkA+qAEyJu4L07J3NOP3Q8S/oCL7z44eNMSaiAvwDC+HWz54enHy6IkIWNpxqOP60EoRdwNPXUiP4T/9zsTnSasBfsCtAHqbTYJH32PP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=iAZOCUTk; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-70259bdcf7cso3142728b3a.0
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 05:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1717589746; x=1718194546; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GpvzkiCxKozJEFTOhtS0qkQgzMcSqTc8pxD/W7VEhXs=;
        b=iAZOCUTk8lI8+n+8mWwcJ0NmiEDHnk1vcO8fqJcwNa0tQM5nv5fkI+3Jy8YP29dF81
         D8Ah6eBR6hqtGY6jF+B0ABj2UMKQ+19NoS/ElCSdkB/CF1so69yUqThKEprEROcAeorn
         jkikUg9Yk0U4yWWGRVYcRBiHwUWfUpXGYIAzH1Zk4zTT8JuPjvpieLXJ1WRZUDRwRtyy
         9HAZUfiPtVB/BVhCMJ3gA+qIxKvHporUhrs9oAYtD2vWfvU2/JtUX+x6Hy5yWDddL9yu
         d0jjyMjXhHH8SZPRiBBooR5p5w47z3QLpyx4u54qsryesmJVdYyn5BfqYstzeKFJs/jZ
         SLiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717589746; x=1718194546;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GpvzkiCxKozJEFTOhtS0qkQgzMcSqTc8pxD/W7VEhXs=;
        b=Zb9Kgf7OW5J1J0Fj0qBGWbaGd0jK5UduVO/V9GK52VGBTG4cCftf1DT90F2IAMZJod
         32gd+GovlHqNHmU4p5DUhoBUfjeeiYfx9srPSYFFJhitdjjWaKnuCD2LkayEeRzYgzl4
         BO9pedrPP1lCqtbMYS8xzFslZoXwOqqVFHN1enENOYCiUCuZ/OXf6+F9j9V5FHS9yyd9
         zhuPWJQn7RF+VbUBjbLIGfTEPG+kFYA0lb4oIzQ+xWq3UY7J/XRlBinkaf+orXMlfh9G
         Z6qtC6+9augnAqj8vXftN7LX4u0feQTmJkP94s/hnlk9vd7Ftz7FElj0EKqYt/SPidpw
         pZJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSAcdGWtITi0rFPR0QoCITG2pDV0uxi8IOS/KKMXshV/u6Mec0J+jx7SjeA3/yW5ANYkgikn1Hv7OK05OA8286Tp56
X-Gm-Message-State: AOJu0YwPJo3PNHecAavxu0/OJX3Pq0jBWQh8+nowTDwSz/+Aapzrh8gA
	HRpcJ55AK/vyfMHixZVsjxskxacLTwjU2JQUy9Oa95neD4LKhO74krBkFQsaK2U=
X-Google-Smtp-Source: AGHT+IHxvvSw4LHcVUp46xf5eLnBwmt4LaRfb4YBe++3w64DoItEt1ztOFnT7PyaQMcSTm6fON3nVA==
X-Received: by 2002:a05:6a00:1991:b0:6ed:de6e:dd24 with SMTP id d2e1a72fcca58-703e597aa21mr2623604b3a.16.1717589744922;
        Wed, 05 Jun 2024 05:15:44 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-703ee672fb3sm885379b3a.216.2024.06.05.05.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 05:15:44 -0700 (PDT)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: apatel@ventanamicro.com,
	alex@ghiti.fr,
	ajones@ventanamicro.com,
	greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	devicetree@vger.kernel.org
Subject: [PATCH v5 2/4] dt-bindings: riscv: Add Svade and Svadu Entries
Date: Wed,  5 Jun 2024 20:15:08 +0800
Message-Id: <20240605121512.32083-3-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240605121512.32083-1-yongxuan.wang@sifive.com>
References: <20240605121512.32083-1-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Add entries for the Svade and Svadu extensions to the riscv,isa-extensions
property.

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
---
 .../devicetree/bindings/riscv/extensions.yaml | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index 468c646247aa..1e30988826b9 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -153,6 +153,36 @@ properties:
             ratified at commit 3f9ed34 ("Add ability to manually trigger
             workflow. (#2)") of riscv-time-compare.
 
+        - const: svade
+          description: |
+            The standard Svade supervisor-level extension for raising page-fault
+            exceptions when PTE A/D bits need be set as ratified in the 20240213
+            version of the privileged ISA specification.
+
+            Both Svade and Svadu extensions control the hardware behavior when
+            the PTE A/D bits need to be set. The default behavior for the four
+            possible combinations of these extensions in the device tree are:
+            1. Neither svade nor svadu in DT: default to svade.
+            2. Only svade in DT: use svade.
+            3. Only svadu in DT: use svadu.
+            4. Both svade and svadu in DT: default to svade (Linux can switch to
+               svadu once the SBI FWFT extension is available).
+
+        - const: svadu
+          description: |
+            The standard Svadu supervisor-level extension for hardware updating
+            of PTE A/D bits as ratified at commit c1abccf ("Merge pull request
+            #25 from ved-rivos/ratified") of riscv-svadu.
+
+            Both Svade and Svadu extensions control the hardware behavior when
+            the PTE A/D bits need to be set. The default behavior for the four
+            possible combinations of these extensions in the device tree are:
+            1. Neither svade nor svadu in DT: default to svade.
+            2. Only svade in DT: use svade.
+            3. Only svadu in DT: use svadu.
+            4. Both svade and svadu in DT: default to svade (Linux can switch to
+               svadu once the SBI FWFT extension is available).
+
         - const: svinval
           description:
             The standard Svinval supervisor-level extension for fine-grained
-- 
2.17.1


