Return-Path: <kvm+bounces-18111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F3638CE441
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 12:33:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3D081C212E6
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 10:33:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB87386254;
	Fri, 24 May 2024 10:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="aPIaG9VV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB04885C62
	for <kvm@vger.kernel.org>; Fri, 24 May 2024 10:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716546810; cv=none; b=hMcup8VIIi09FxDuBj3EQKdePL9hAc90uQ6A071/DNQPbSRhwpYQkEssc5U32n9vgO+I8a21ql14UCZ3mf/USVx2870WDLQrKXZc/EpDzmSzZOp8y/Po3GEuSIAPUrM80ZxiTs5gATuRIHZfTgO6+kYLsPq7py1H+KZKUXPUMpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716546810; c=relaxed/simple;
	bh=7KSzKeVUxTubbWTdZkaThLkN6uyNJEOkaQHyDvgih/0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=fvHwqmaGhWhXyEwGquItY04N/dKZwyFJtEoHliRA0eyRVz2AhKGGxur/eGHnxAoH2CT1PH4NlEz7KpIqx8708HHqP+N+1pUnsinAKUzsgJI9AGi3GhOjU/k0sEAkl5ZWSPpbEBcjBrgIfEwm+OhkXJurNczd0oQS1wWjacgB/Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=aPIaG9VV; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-68187b5d3fcso495424a12.0
        for <kvm@vger.kernel.org>; Fri, 24 May 2024 03:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1716546807; x=1717151607; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=e3SGsbWgTHauNPsqsrqXr871vIXrZYnzi0FhV+x1ZyM=;
        b=aPIaG9VVrD1akFcWvmxZ0wrwQbZyD6ME/9mK41eZlFxOfxGUd80yxDIgQj/XjxtD5c
         nd2HO0USvj3mQUDEQCL0/6fGC/b4HC3uxzM90wv06UAsVQ7nSSfl5DcLww04mnjsdaY3
         w7+G/YkRIeXrt1oxzb63q+Gon4dOD7jwugJgQlU/5haE3HsqvYFedMfaNX3qqaRvhHNA
         0OFCY1CVGSLJZbITyHHQiN1ItWZNdZh7/DlDusSKZ+8Ou6z4Vz5mKPXfzGHD41CgbX48
         PFJm0WZpmKitnguE3ciSBT0laJutyqS5gq6w/R26X6+nbOifsQ54982+/lFiQaZA3loY
         5euA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716546807; x=1717151607;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e3SGsbWgTHauNPsqsrqXr871vIXrZYnzi0FhV+x1ZyM=;
        b=P4gpl9y9ERXRXTkahBKiUNlOS8vL/1Y+Ce4zbaebNR1pU5cm+VRutAPjegHecLoLUF
         1IQgmdq+js9dxMfE4faPJAgmJintDjv7ddbPGT/me4vbnBF6uPaywW867fQxKY16+Bwy
         eCl4BxKHBjartCPMp6FLLJqxlsiWNbm9c0w2uDm4qgOkaTJzts2M//bRI841xfcRAS5+
         da2ZJTmyqOV6ErFzTUQ2goFD9p0sQjXqR+GDoQq3GRhRYG0NUhwbnK4wGR5OHzCLrnab
         kE5uh7txExXv8Zo85lFOEH+imqJZeedaggikRGCL7Gd4LTAHtCo/JwIk4Zmp5Q7WcSlm
         Avgg==
X-Forwarded-Encrypted: i=1; AJvYcCXhU4R7a2TQqf3RzEXN6EjekXhPtGAtFZ51WoBqJw2ZG7TJPla6jF7w3XuRwZ+xamMeiR0eNhBWYA3lRS53uP0mQVJV
X-Gm-Message-State: AOJu0Yzusma6zHM5PZxL9vo0kVtOpQfLifPi88iPy/k5GHlmF6A60qNy
	2NnEvWs0mLEdcVNfkBM3trBXazx63MgFy7kS7KVSnwPeFhwt8Uims1sW12G1x6k=
X-Google-Smtp-Source: AGHT+IFEjxRzuXtqnwpdjXGqqrpyzXepAeYnCHRfGHkAZfMRQCAGjZk7T+Jgmy6wAMTVGHMbBmV98A==
X-Received: by 2002:a05:6a21:2786:b0:1ae:3f36:28cf with SMTP id adf61e73a8af0-1b212f64d53mr1876119637.56.1716546807028;
        Fri, 24 May 2024 03:33:27 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f44c756996sm10936625ad.8.2024.05.24.03.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 03:33:26 -0700 (PDT)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	cleger@rivosinc.com,
	alex@ghiti.fr,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 2/5] dt-bindings: riscv: Add Svadu Entry
Date: Fri, 24 May 2024 18:33:02 +0800
Message-Id: <20240524103307.2684-3-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240524103307.2684-1-yongxuan.wang@sifive.com>
References: <20240524103307.2684-1-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Add an entry for the Svadu extension to the riscv,isa-extensions property.

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 Documentation/devicetree/bindings/riscv/extensions.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index 468c646247aa..598a5841920f 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -153,6 +153,12 @@ properties:
             ratified at commit 3f9ed34 ("Add ability to manually trigger
             workflow. (#2)") of riscv-time-compare.
 
+        - const: svadu
+          description: |
+            The standard Svadu supervisor-level extension for hardware updating
+            of PTE A/D bits as ratified at commit c1abccf ("Merge pull request
+            #25 from ved-rivos/ratified") of riscv-svadu.
+
         - const: svinval
           description:
             The standard Svinval supervisor-level extension for fine-grained
-- 
2.17.1


