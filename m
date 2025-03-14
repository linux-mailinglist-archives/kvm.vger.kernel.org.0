Return-Path: <kvm+bounces-41082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8126CA6154C
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 16:51:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C40CD3BC1CB
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 15:51:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CB062036EC;
	Fri, 14 Mar 2025 15:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="O1tpEXo1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743E4202C3B
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 15:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741967481; cv=none; b=rw986n+c7ueN5tHhsTJBIE09mWAlKO491L9cKonZt9S+UkTvRutDOjBpi/GNLCu/QA1389n1jfsPR+55M2q7LFGSg4qTRLxxNLv83daQRx3cpYiQPpDReS3Z5yM9Nz2SCU+Dq6nj/zwJBRinWNavLi9ThpDMEW1AhIquOz+GYoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741967481; c=relaxed/simple;
	bh=/7OM+oNyDXmm/2LdOGMTaA6SqbTbV/e/lr9qj1j+GQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIVRIMVjOVpOkHRWrBorr8siLvTWhVYFD6SPp9g09jxLa/WoKlchHRIt0sWzwNXs34ybuX5w2riWuRmGa9U7xP2293SnjdVwk/3eVnw5QkaEsHFZCd05ZGzs0Jf2xg+q/LC4baZCIkZxHMVqJhX8J2XxoXhkqKWW+zeXPSS4wIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=O1tpEXo1; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-38f403edb4eso1277269f8f.3
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 08:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741967477; x=1742572277; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=++RCXC80KQUw+yCRaKjq5JOqlP9+bD2jusr4EJFhpro=;
        b=O1tpEXo1rm8Fnwax8+WfHMVfWQoVhGxBRz7Je9zIkLlr7nNn0TrRkPsisEzz/7lZKm
         rHxpaV9u7wJbVaugBor4lUMAZbuqhB6IgcgGs6cPaBXRBx3LJxxQJpbI9toN4pz9nz7+
         1NMehv87Pkvhfbyw4QMClz3lXp2K5StppzbS6BgEie3uMzQhsUPIgQ6OV38akuqnN3Cl
         xppYGjQdXPPUIo8q4W8LRcUBjN73w0hWb1UYH3/bRTJmDKIHa6acwLtgwAYqIYsN+pse
         phbNPVb2fO1j2EDVHGZ6IVjXSokpqSq4iO6f5T1JH/A7ZNWboqZjPKRBgC7V7D+JPxOz
         6WcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741967477; x=1742572277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=++RCXC80KQUw+yCRaKjq5JOqlP9+bD2jusr4EJFhpro=;
        b=ctmE/Ziwe4G7XqzotVDbuVfz2WrE/m3VwwzLAxXx55fyQcjgsym6P4082iNmN1mrqM
         n8P9lpYexR0ALYoYVvTURFjtvUbap23FHCseoP+ls7ldFY+bwRoOgk3+0y+0kBgGO5L4
         lry1Wv4F1RcB/eeC7MeES7Z5j6+tVaKEjI83Ed9WQ32ZaUbD+qPebt7F/EHCCRzWpaXj
         CHiTKeQOOT2vtmlP529qDUQqdlB3pWNvIqj3IyxZ4ScIVANhmVX1RW/0sTS01a1fvX0I
         2X4zJSP+lM6iLN5yA5Yka+9/WV1cMEh2360L+pi8uWqCuAvyH8fjEQBVUCnQzVIz8Pfy
         FiDg==
X-Forwarded-Encrypted: i=1; AJvYcCVMvmYDVvUStAJoEZhyvcj8AzSaC2hbm93gT3GeGe/B3pM067+gUUXUXtKTBlQ2k6c5Lds=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvM5h5EeCMbUffIjqmIsujQzOVW0Dh/R1bmTnKQC96udI0OCAU
	BSoDQ5fwRDXHjieFCad19w4Jf1t82ANUZT5cR7rRXUeSMwZm2w+C1jvXjjwLmaM=
X-Gm-Gg: ASbGncsIgOaSbHCh8o9aqXXb3TuozEteBkCdnxaj973FJb1p5+93UNvBQgW7AFydq1U
	vvx2Ovx6grRL1shsoqli05vCpkwk/uGud9THu3xywm1ln57+Koyb5j2ZxMiSnSpvGukBfPt0udv
	kH/TnhTw9h54S1bQRP7EF4Nz5Br2y4IJyzR9qUUYC1biehx8VmTToBu4qwn/Pyu0yv7LQo/IQF2
	x94xkFejA+LDMu/y3/z1mbuuTh6HyYl330v8zkBFielIRKeitwX5eenVi5KZ1Q5+Dfw+XuvHopa
	3A4r0Ialb56tO/J9XGu2KY3eFrp5DGlPv259MMlfB63z3fPDMrqitnrEd+W1d7k=
X-Google-Smtp-Source: AGHT+IEMzZIo8rHTV1Dy8xpK/5z2eXt1opT7nvqywgo9i0ShyunydBCLs1cS/ckJWtUYCIoMRCwBHg==
X-Received: by 2002:adf:a454:0:b0:391:4ca:490 with SMTP id ffacd0b85a97d-3971e3a5680mr3380574f8f.29.1741967477465;
        Fri, 14 Mar 2025 08:51:17 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d21d67819sm15249945e9.21.2025.03.14.08.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 08:51:17 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v2 5/5] arm64: Use -cpu max as the default for TCG
Date: Fri, 14 Mar 2025 15:49:05 +0000
Message-ID: <20250314154904.3946484-7-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250314154904.3946484-2-jean-philippe@linaro.org>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In order to test all the latest features, default to "max" as the QEMU
CPU type on arm64.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arm/run | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arm/run b/arm/run
index 561bafab..84232e28 100755
--- a/arm/run
+++ b/arm/run
@@ -45,7 +45,7 @@ if [ -z "$qemu_cpu" ]; then
 			qemu_cpu+=",aarch64=off"
 		fi
 	elif [ "$ARCH" = "arm64" ]; then
-		qemu_cpu="cortex-a57"
+		qemu_cpu="max"
 	else
 		qemu_cpu="cortex-a15"
 	fi
-- 
2.48.1


