Return-Path: <kvm+bounces-60467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B8D8BBEF3E7
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 06:22:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 848184EAD28
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 04:22:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2CC62C08CC;
	Mon, 20 Oct 2025 04:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="JAwoh/o3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810CA2BEFF6
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 04:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760934089; cv=none; b=L4cJBxz1tsT3rIjpYYeQKwRmFNxjeNFBhnKoLeBr+zjVbLb0ihwm1vfZe5sZQL7puAYvz2xKHKOQSvYH6Q0UvHNRQjo6dQjRdjfAUvak0wf7ueW9aJkK3jXas0rRKsd15bhJC7yknIr2wdFK+Nz6vPnn+Sl9alUeOvNR4fgiRno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760934089; c=relaxed/simple;
	bh=+YpuvhJCI/yShT1rtWNvOFpxGI7l/ehsFRhKIaNPItU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2wCz5DcrF3AocJMmHty76ESEHAMqDetw+8kdd3lfvv5dtZe48Fqpt5Hp2INalJakery6vcupDuPwbcwdDhcmRqJhEzAIR47IiqVbcMzJxQ46fDZDxIjZFapT8QIKKtcGIK0QCpQLNUCkfDtWXf6c1hLM9UqOGKruxyoOk8sBPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=JAwoh/o3; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b62e7221351so3258780a12.1
        for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 21:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1760934087; x=1761538887; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kcpuRb5Zady/Ndj7TK1NVXuo7wdyupAjCmRtQU7qg78=;
        b=JAwoh/o3l/iy2sFi1ugjUdmHcjBCKevt+8mUOi1sqitp2FwVzGYui3vaZBOuiytuPT
         e1QgVvpp8M5J2ent8fcwzPtqA7OxuFbUDUYhKVO4Kbhp96nSM5O5t+VXW7j/qC2NcDx2
         6xEbZ5nnhwBGTMxHfwBZjfhnuuljD+Z+WTzEz/o9N71R3A5ar1111AqE3jcJCEJR6AlT
         9QI0q9WlWcKyNqJSz5mApRiEwnVH2gndZhW/zopueiEBRED1jTgJchUZY93SftSQ94C/
         DDQVY/VCrnTGtWXCarpbGgVly96YeFbemv55XWqGgSmoTT4c0Cz0A2LCvcZp7DK+9Sc9
         KbVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760934087; x=1761538887;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kcpuRb5Zady/Ndj7TK1NVXuo7wdyupAjCmRtQU7qg78=;
        b=LoDATDWYAkvKOD0hdbySdzCRe9WbdQrEubszGx2v20K9x8V+iLZAnBAH5Pf6vsR0Bk
         fHlnOw24gMZgSfanHRj0+yH1PylsIajjjfrqqu3RW10tvCTZISql4ws1LXWLqSIBeiDa
         dAfQ13HjXL7SzaWrQBBQ72hLuDkeXl5eEeIjlNNJ1AXXw58vlgldVJtWbTJ2GC1/+Ep8
         5jeZY5FDQS4+iGMFlDaVdeNZrrp9o5fGIV9Sxjh6zSQVvDDblEXlKZxbyVwanqZrYGns
         6vIbhnc/pK2jzOqZmyLs8Vp22+uaytEvZUGVN5ilmeltQNuw+E34RX8lJ42oe1yHBlAA
         hVTw==
X-Forwarded-Encrypted: i=1; AJvYcCUL2uKAkk90+3Ao6orcZy7GjStGCQH2qTxCWyAWE5y0AZ40RhRnLJ0sCBPIBUhi800/3LY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlG5To9irgkLozEolb6fhtuEoC4Ws81OmNMN5GZ+EkhZli4OAZ
	9Z957hFiUCB+QxgrDR3geRkZDKR6Uz6vPPCNimozygCIWPCIywQPZC6JWQJQDwy2I50=
X-Gm-Gg: ASbGncs801jAQP2WMu75czLxf1MQI5uQcSRIfUcMv/cgVgJXk2s6xlHOUaMgxZPRgfF
	tSyfO8PZ5n6dyEG67hTs/xrWw4l7/LeHKXfQSA4onMRj6N+U/9vaeHJrRvZjOBeAcBeC9Fmioj1
	lBkj4Qzv10GATLjQpQZM7/UQWdpvPgB3kmD2NdEBdlPwSeZr7Mdfejic11+oOipOr8QdPjnZmhy
	yAsTpw3hnlFWK44lg7OLqSTSAlJuXKF2jw17kySOIlbBW9halqNdgMY4z6x7XlyW16UtCn3I/n8
	2UL2KfruDdDB0uoUqSPzeyRE/b4vM0QMKiUkEU63NFYeK9poWoBpu6N3XWr3jV9ZI6NbWgHuEkZ
	qGH7Y7pfuQb77cOP4piW8DrPl0vr/KeWgaFx0+beqiPD/sTualzzOnHJHu2cQxYR8wkHHZOegsc
	yyOTpmjTbxQ102l4zttP7i3hCrRZhBboqLj6MGiMlDUk0aDdNFDf9LPpxRoI+fKQYLvrVfIAkfu
	g==
X-Google-Smtp-Source: AGHT+IFwTwTOglfCAcnv2eeIJKbKLKoLeYRBKMVD09UkBscMOUOH5n7kgqBF6beeLtv4Tcs3gbZbaw==
X-Received: by 2002:a17:902:db0b:b0:264:70da:7a3b with SMTP id d9443c01a7336-290cb27af60mr170024945ad.49.1760934087485;
        Sun, 19 Oct 2025 21:21:27 -0700 (PDT)
Received: from J9GPGXL7NT.bytedance.net ([61.213.176.55])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29246ec14e9sm68762035ad.9.2025.10.19.21.21.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Oct 2025 21:21:27 -0700 (PDT)
From: Xu Lu <luxu.kernel@bytedance.com>
To: corbet@lwn.net,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	will@kernel.org,
	peterz@infradead.org,
	boqun.feng@gmail.com,
	mark.rutland@arm.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	pbonzini@redhat.com,
	shuah@kernel.org,
	parri.andrea@gmail.com,
	ajones@ventanamicro.com,
	brs@rivosinc.com,
	guoren@kernel.org
Cc: linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	apw@canonical.com,
	joe@perches.com,
	lukas.bulwahn@gmail.com,
	Xu Lu <luxu.kernel@bytedance.com>
Subject: [PATCH v4 02/10] dt-bindings: riscv: Add Zalasr ISA extension description
Date: Mon, 20 Oct 2025 12:20:48 +0800
Message-ID: <20251020042056.30283-3-luxu.kernel@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251020042056.30283-1-luxu.kernel@bytedance.com>
References: <20251020042056.30283-1-luxu.kernel@bytedance.com>
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


