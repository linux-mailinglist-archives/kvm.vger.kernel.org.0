Return-Path: <kvm+bounces-13523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0FA1898519
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 12:35:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 50850B26115
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 10:34:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5671823DC;
	Thu,  4 Apr 2024 10:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="mm9b3dRn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF27763EE
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 10:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712226868; cv=none; b=UxxVJWMkB7SwNe0V0AZJBMpf7sdCH5INF3WmKMau7GhzQt++UKjdwDtgIomzIyTJlE11hoAN95Brh0HPfCNj44RirFD4MQzIb1gkW+nqTWHSxTJrwMGgjGJLykjR+7clTPfKxkk4y7iTMPsc7Q2VutpX5k36xR7/AcV3EjHjTK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712226868; c=relaxed/simple;
	bh=IstxSeMIkFWqG2adq+Av3TovwemxYp/teD9978fHvcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=comuUIzaoNOOo6y2Elk1AsBYJ/aK+N81wtCTA21mgA9runfVmvh/oDwDXJUpCstPBjhFY4D50n9umMbudnT7JIH9G4Q3Vtn5fXupgS1e+HeIGm81OAUKbrINaJB/e5TEp9vGKkk7qL5oh/4KljB81OIssEpvrdKNsiPZGlv/ewA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=mm9b3dRn; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-33e9115d501so358958f8f.0
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 03:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1712226864; x=1712831664; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mPiFpAJVCXedUpD6zmcxIwwzHItSuIZnjTos+8U6SVo=;
        b=mm9b3dRn89IsJK0o13XLLrj+UWgaEvi/DAydtIdQN6wrve7NlpHAVuuaKGvpdSrzCy
         AVfKV5syWn+HcSojxPa0KGayCviM3NzKuwhTob1zZ4vJ30CNwcMKiGxouiYtnaXNG9cN
         cb5vXXysvxA7VZvQoe+qpm0uYrxxzXlEso0ja9RTZTx+IyiGgPGZlBZxp5DOz4EkbTxU
         rZJT8UqUR09k/JRekFkZbRffJcLCVrdYqYodV20EFlYqJ3DGicajCWby5IIBvywV5mDn
         GIuK8cLkeimFSVnaNTqsJIn+2ffkLvJgNkYE23KZ4CSRzt5HFjnN968ZmfrTehJZu3YF
         lOrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712226864; x=1712831664;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mPiFpAJVCXedUpD6zmcxIwwzHItSuIZnjTos+8U6SVo=;
        b=jlUK8asf+VM5MwxAz1bRGayHy2orDHALXNcTlDii8J4TaBQsQ4AXzKQARnOgk0b2CS
         h/EtlVE+lvlqP1XGqH/xbol4YAi4TbmJ9e37cfs59b9fSIfryIu0Xhx5GFIv3fgyavJs
         Xx/G+AyyEoseh/ohuOXzhSsE/tqIZe8akEy9f7LtMHJ5r9HBdsArhgNgYAuLx9k9075G
         ExSLzkFIVCtYh2iSyik/uaxQXLWYcJKwvW3OZ/Iw4H1anWR9AdSq8fHfohj0QEa5J9Uu
         V3RoCBjGO98xhnxQS+ZnhBNEHxG/Ww6iCzAexNB2E3WOwxvsuqpof7ZM49/lnHMNklid
         +b4g==
X-Forwarded-Encrypted: i=1; AJvYcCWhtxvuWQDG6gxg3aUbbFyxzgMbOTkMWb/RDne48IQ/b1wnPApkAry8F2RpZY+ntaeJaoFEWXZ58vz5x3AmKtCzdep6
X-Gm-Message-State: AOJu0YwRrAlAaI5SyFzlwbXBu+EX7neCxUpm3cAv31ISM+gejxLmvN99
	gldbkCxOzmQAwBbaHzfH7oB1FfL7f5csxbH6YG2MVo/X3VmOapRskjHUYQCmvzY=
X-Google-Smtp-Source: AGHT+IHEYXaDR5DHH4zoY4KhwUJQmkXXvB18af+Ebcotdmut1GqJvAgC8qaCJXy0+ZACV7Kq2Mh0hg==
X-Received: by 2002:a05:600c:3b0a:b0:416:2b72:1f5b with SMTP id m10-20020a05600c3b0a00b004162b721f5bmr650188wms.2.1712226863709;
        Thu, 04 Apr 2024 03:34:23 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:555b:1d2e:132d:dd32])
        by smtp.gmail.com with ESMTPSA id ju8-20020a05600c56c800b00416253a0dbdsm2171340wmb.36.2024.04.04.03.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 03:34:23 -0700 (PDT)
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
	linux-kselftest@vger.kernel.org
Subject: [PATCH 1/5] dt-bindings: riscv: add Zimop ISA extension description
Date: Thu,  4 Apr 2024 12:32:47 +0200
Message-ID: <20240404103254.1752834-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240404103254.1752834-1-cleger@rivosinc.com>
References: <20240404103254.1752834-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add description for the Zimop (May-Be-Operations) ISA extension which
was ratified in commit 58220614a5f of the riscv-isa-manual.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 Documentation/devicetree/bindings/riscv/extensions.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index 468c646247aa..616370318a66 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -363,6 +363,11 @@ properties:
             ratified in the 20191213 version of the unprivileged ISA
             specification.
 
+        - const: zimop
+          description:
+            The standard Zimop extension version 1.0, as ratified in commit
+            58220614a5f ("Zimop is ratified/1.0") of the riscv-isa-manual.
+
         - const: ztso
           description:
             The standard Ztso extension for total store ordering, as ratified
-- 
2.43.0


