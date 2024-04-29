Return-Path: <kvm+bounces-16164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D08F38B5D1D
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 17:16:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0ECE81C216C8
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 15:16:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B65EC130A5D;
	Mon, 29 Apr 2024 15:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="TGtG0D+N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D672C12FF7B
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 15:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714403203; cv=none; b=i+a/fSOLj+YKwvO4alav57FZ+GPvqaxBxsH4Hf6fzEaaQ8S+kbdCGGEZf0FhrM0ezZpLh2v84iPnPNj0CrkJQKLYRVw4lECg4+QDaGqp6pT45oUNKmMyVSkeHf3q0aQkURQDAhaVYt0fovPtz3uG/fkrj0upMGh0aaMGa4CjAWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714403203; c=relaxed/simple;
	bh=Vz0s8AKnndRQ8cJTZ/3LH6Q9O7ZuS04mMnmJYlpWcHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=chTj88fQ0KW/PgfXRriw34oLcX+vrRPdlsjSieKBHfipb0gr+/cpt9fCffP/GaWhYLBBgbMg8pk+zU/aceePEBQiuzf+zHbeu5+Aas6hr194GZEH6OHThu5p+J/Hje9mTWdDXR5YUIFiwL42CI3Eot40Y98duBe7lZvIrTuVPjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=TGtG0D+N; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-34a42d6e216so1009546f8f.1
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 08:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1714403199; x=1715007999; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SqUXz3P/ILbAY/obovxuw/ulwPrEeHHfsINnJJgombQ=;
        b=TGtG0D+NO03h/g4dC0sjRWWTD8RE1bQxfPlh0K2n3VVrA5cijDnFZWUdkVoIsSp3Vk
         pQzru1V1j2O45ymuYH9rnNDUsdX/X2Z5gZVXgK+Uc3FnDeehOdfqtVKqVLHQGxv+gPN9
         iKQVhseuvseAtsaeaweTuNU+nxPahcWoWpQWxmMLmuw54Z7PwlvjVUwUu7owbr0EJbPj
         uMedyUiCP1nY673rbpkyAg4y7fY25VJF6KSy+KYCMuxUI1JfZwmQ4coTHyPS68BslQzj
         Fu2GdMp/sCD6MMeei2Cq70zQ8qDzywnj4mQ0D/mckrXWpN97c7FUxhtryeWkKrl13fp2
         OYbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714403199; x=1715007999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SqUXz3P/ILbAY/obovxuw/ulwPrEeHHfsINnJJgombQ=;
        b=pi0ZtPx/7jpSFVWZswzKPmynm2XQeIFdMekJs7EGn6O2lh8cOYO9EBp2tG8CJx0C1I
         YlYCq/VAGVW+Z+t8nMpeK4kfC8ClrFr1dhIniTHThLMfAkJFMCBbi0ObJxOgZOnT57Yz
         9YHzzzrg5vHOXPWNv6x89LHOaHxjY9IkrKZUCnkfm2uI5Ab9b6m8feovgy3N7+exLjAO
         WeT7deTthvryVJttpX82FbBBiszkpXhKXUlJqusDP6sYHoLRSY6oADLSOGWiJqBmG9yy
         nlVlIzssYXKzjVgsq8z8ebcQKFR5I3tFJMnfisH/OWFyUm5w3IjiTk5qGyypAl/iSylz
         oShg==
X-Forwarded-Encrypted: i=1; AJvYcCXX3kfG91MRvf87yUIi8rC7GXTMdBzTAQH1hda5epxZtlbFZYXrl80rPU80MIeijXrv61yAWEzVPEtVxuW7/Oem3sXI
X-Gm-Message-State: AOJu0YwM0K6IjXo5rQ0emZSZzMgwe1Evs3ecUIEVDbKZQKdCRupc1L/q
	r1/vWpoqlZ1g+L3NOgOgCAmxWd/053b0I/LQBFhiguH18HMw9MQTXkJtvok4uo4=
X-Google-Smtp-Source: AGHT+IFHvS3936PWqb9eOOBo7Us0cNxw774lksEfZ3wjvn8w+VLShJLTz+TShTqKy/ncT5mbVPbyOQ==
X-Received: by 2002:a05:600c:354c:b0:418:f770:ba0 with SMTP id i12-20020a05600c354c00b00418f7700ba0mr8123230wmq.0.1714403199360;
        Mon, 29 Apr 2024 08:06:39 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:2fec:d20:2b60:e334])
        by smtp.gmail.com with ESMTPSA id l23-20020a05600c1d1700b00418f99170f2sm39646638wms.32.2024.04.29.08.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 08:06:38 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Anup Patel <anup@brainfault.org>,
	Shuah Khan <shuah@kernel.org>
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Atish Patra <atishp@atishpatra.org>,
	linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH v4 07/11] dt-bindings: riscv: add Zcmop ISA extension description
Date: Mon, 29 Apr 2024 17:05:00 +0200
Message-ID: <20240429150553.625165-8-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240429150553.625165-1-cleger@rivosinc.com>
References: <20240429150553.625165-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add description for the Zcmop (Compressed May-Be-Operations) ISA
extension which was ratified in commit c732a4f39a4 ("Zcmop is
ratified/1.0") of the riscv-isa-manual.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
---
 .../devicetree/bindings/riscv/extensions.yaml        | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index 81bce4fa2424..1952d20b8996 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -252,6 +252,11 @@ properties:
             merged in the riscv-isa-manual by commit dbc79cf28a2 ("Initial seed
             of zc.adoc to src tree.").
 
+        - const: zcmop
+          description:
+            The standard Zcmop extension version 1.0, as ratified in commit
+            c732a4f39a4 ("Zcmop is ratified/1.0") of the riscv-isa-manual.
+
         - const: zfa
           description:
             The standard Zfa extension for additional floating point
@@ -549,6 +554,13 @@ properties:
                 const: zca
             - contains:
                 const: f
+      # Zcmop depends on Zca
+      - if:
+          contains:
+            const: zcmop
+        then:
+          contains:
+            const: zca
 
 allOf:
   # Zcf extension does not exist on rv64
-- 
2.43.0


