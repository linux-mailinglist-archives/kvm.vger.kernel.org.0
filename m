Return-Path: <kvm+bounces-20659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B8B1E91BBA0
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 11:39:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E24A1F21DA0
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 09:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF8DE152E03;
	Fri, 28 Jun 2024 09:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="TP58STNX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0D9154BE8
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 09:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719567489; cv=none; b=Rp1bKg2d8JErrxMdR/dyMyeqn2qFzo+2vdlYrSWOp05vxZsUAxbqaab2J3+28K7rC+C/TBoMmTvLytD4G+JNjuTL1+8Ip6WENh0D5lVXb8IX/LA/O77+kcA4mx3So6X0cvhHauE90oSqcM9fFXrPNvezrupdRIFjksw7Bhi2Vyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719567489; c=relaxed/simple;
	bh=ONgrN1lIcSl02qRIHLXZVgvQprShqnN5GII+tATavQA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=lmEhHf3DJ4GskFe81qX3QnGNVAohzkZf4MXQb+kTKAz361GJoIbivbnHlFHFWs/FNNi/q9NfeU+kK2/zSRxcK8utmvTlOxYYS8xtbRVJ9KjQFgNkNoiaYxcPUFKq5XAj+Er1Ib1ia6FgEjkhKaP8Q10jJyHXmsyffRoSlQyOQdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=TP58STNX; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-652fd0bb5e6so255512a12.0
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 02:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1719567487; x=1720172287; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YA0dWEkzXvI8/KpPhKTDAN4RTMFwdU95qGVE5ffUQFc=;
        b=TP58STNXnKWesOPeYw6CQD20/ccvXIziu1010ZZdWxfsijNKFEgzUvRvblm5Vpqui9
         adVcWsInbecAF5L8hvaixOEK9wgOf8UKsQuT8WJ424ikxU6wRGYzG3LGGrn/lDyPc8tz
         xoqZ2a1Ap2evwEW9xLhn1GDPIjKauBXfN9HLGFezuxilDkyOiFweQfdxdokjkDT66emd
         mKVvYQKhrvMKIqL+j4eHrJdGL5CsPLTfRiPyL5d8M+aidV21nxtKOESJh6xbHkKHP8Fc
         1h0UtAsioLro56DyoZmMk1Yk90UVyX5MzlnpSdS+o+64G/lddWAZttqFw+ljF04rNPVy
         m9wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719567487; x=1720172287;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YA0dWEkzXvI8/KpPhKTDAN4RTMFwdU95qGVE5ffUQFc=;
        b=N/UpXHpi0DU9sK8hVEh94/ZOkkelVsA+l2IWCfKTiRRvZZq5x8GjEsaRHrGMTqhyXn
         slPu5+j2/7xnZXlYYa2arlbbirYK5Y3PyE0fLJjG15y9j1ssNlpohA/VznZ+dhVyhORs
         xRHzrYrSaGalVumLwzI77q1WgGTo8uRk1Y+SrumK+HMRQCTPCI4QtOycUV+2ZS+fzcHO
         gVpYuE0TtYuV5xQDKmyBT7Fj+AkNU6A5Axm2L/iArShYXwTdydHm/Lfwm5RsoYkbwlqm
         8iTHamnOv11rDiN8caZ+HfhMLc8M+f4ThVHixdSYz9yTbUjDrQQBKQOgqa3zoTSxN40B
         719A==
X-Forwarded-Encrypted: i=1; AJvYcCXITEO3adsGFy1G38OUSI7WZy0mzMC7maw9tvf6qgOMn66uicBLbnxvSUmf2zAkd4oGXqjH9MXQiBUcuuIuzszdtg1h
X-Gm-Message-State: AOJu0YzJ74wcYL0hLPuI7eXkyjgC16L9WkWpfeFvuul2SYntwT99+RXv
	k6nBTV7IeF1PgxVCJ2dwVLczm0O00TpdAnys0jeECQLW4w+/0leUTVz00n5bRIw=
X-Google-Smtp-Source: AGHT+IEr7EQCj6dcAAmXxE9nTudy+Q1tr3NBQMPkn5K3OhDpK9au3cIf3F6kgtczs2qpjnr6GuG+cA==
X-Received: by 2002:a05:6a20:6a90:b0:1bd:91aa:79a0 with SMTP id adf61e73a8af0-1bd91aa7a7dmr7189755637.12.1719567486974;
        Fri, 28 Jun 2024 02:38:06 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fac10c6c8dsm11087155ad.26.2024.06.28.02.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jun 2024 02:38:06 -0700 (PDT)
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
Subject: [PATCH v6 2/4] dt-bindings: riscv: Add Svade and Svadu Entries
Date: Fri, 28 Jun 2024 17:37:06 +0800
Message-Id: <20240628093711.11716-3-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240628093711.11716-1-yongxuan.wang@sifive.com>
References: <20240628093711.11716-1-yongxuan.wang@sifive.com>
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
index 468c646247aa..c3d053ce7783 100644
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
+               unknown whether the platform uses Svade or Svadu. Supervisor may
+               assume Svade to be present and enabled or it can discover based
+               on mvendorid, marchid, and mimpid.
+            2) Only Svade present in DT => Supervisor must assume Svade to be
+               always enabled. (Obvious)
+            3) Only Svadu present in DT => Supervisor must assume Svadu to be
+               always enabled. (Obvious)
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


