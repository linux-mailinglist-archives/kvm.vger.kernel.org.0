Return-Path: <kvm+bounces-42937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E508A80C32
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 15:28:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54B3D4E7D84
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 13:21:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36A7112BF24;
	Tue,  8 Apr 2025 13:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iCtqfoOy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76153288B1
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 13:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744118466; cv=none; b=pexnV0VYQ0Ko/icsRMQ7TRHKnTCqYSq/d2Cu6646PeNJwuPnXsrfoDfVtOkjiQ3j5IDPGG0rGECa5Y1KCLfoKZPop+VVq/Og/toZS63TyhDGmXZcdQCpXanyqraCQJOjdaw7rZ8ElSK0G1j1YL920ifbGRaKx5tuimpOyJIVj/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744118466; c=relaxed/simple;
	bh=4jPJPXMgY6/GNH/PWCQbZnehb4Ap/K+ZFSF2TYMKD2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPHBv7RCH8g+t8pStT2VmBri1GNrEmnj1NcvOK1u2FaVsm9l5S+G769HB2V9sbOSXGbP/dXaQkMOCZnJCGXDxZuLUtdHbclI2r3IhmXkJ5GXUTm79kGR9HzjLNbntXaC9YhrjeTTG9wuTvSSftmFwNYbwaU1UBxE1+ASTGPg718=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iCtqfoOy; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43cfecdd8b2so43622245e9.2
        for <kvm@vger.kernel.org>; Tue, 08 Apr 2025 06:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744118463; x=1744723263; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SRH4HHKjDjKZC1O9fqzVBp1Dw5VmTF9lQVHJ5oF2lVI=;
        b=iCtqfoOyLw8q7F5zRgYxxy+5T8GMFWs//6xkaZXO2h//Chp4n4qM3MILjIHjdL9jOb
         yJe4orsakDzThUsiuO4tIYKuRg0ABdvvDLrpaH3brWb25lj9FaoMIkByvVlzXXB05z3D
         yrEYliAKony3ZyYIxNH0QzrXu5YMskfsDK8+G3P6SiVJ83mcEwMlG20qRoLDQI+EpAw1
         YC9aIknGqsHxvCSvyWrQI4IKowg8VABDQOWANU1PdhvYGYGD0ZpDvehMPGTF+UOaenyy
         8uqdrcLueviYDWzk24e6pgr7/Q4CrBPRlE52jIidOKP43OlH6CRAq75g3Fi8ugDkhpyz
         WA+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744118463; x=1744723263;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SRH4HHKjDjKZC1O9fqzVBp1Dw5VmTF9lQVHJ5oF2lVI=;
        b=H0XRLCZeyqklMghFckhr0UI5VoH6tY21BdbtGy7wIj7bzjPj496eZAfVPS9HIucmdl
         VWvoZwS7hnHXDTk0+FBJnjDOjcyTT24D93sjJAS1JSOo3BwGuEDFkECLy61NzlTrCKnn
         JWS5tgal6IXX+gLK9TMOsfoTONkqQy6ZCc07WRjiC8NNAjSrjeZtOnmjrvUQTUgrux3r
         yJMpTvsxGcCeckHF4qXbMLKxG6wgyVL4Q2UrLxGqUFPlim2hx5ya2tFVsbnOdaMwY3xF
         IXneLWWb+TBNJVC93kkZ+3Pab/vtRv0EiwlsoWurqzj3SytCViw8VBkecVH9ieP/4Y6F
         Guhw==
X-Forwarded-Encrypted: i=1; AJvYcCWNwg0ZebCPop2Q6kBPQCy9qOsNDywHpzxxT2VkFuT46dmnteNAxZ4lonQmN1BBKb3PP2s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8mTdNSXR4OaHt8UINISwTb4R7PUucCFrVBsjRa7xGKJQ0kGn5
	lmoCE+VvoCKFNDtPIP0o57ShdtOCU8EcbtTpkI2pXVic2NJtvwjD5GuTN7UU7RI=
X-Gm-Gg: ASbGncuNsIavt7+DXnA0TFNv0wpeuT5E8vZKZ61zct1UPRIa2kCFlcTdO7axYCL0Q1i
	QCRvdT0w1vDa7F66Vv2vfzQjoz2g902C2U2nspMSIviVXcFOPm2ilF5501apXXyUCjgiD5Hajwy
	wsoNNNvJIgOEtPozq/T+STcS8KO0zhc7m5k1+x6NqpyZfRUzta2THIZZWIc+azAQ31iZK67+45S
	6kDLawkXkZmOAHgmaIbgtd5eA3pYC6vlZxoVfHCpT/MhG3R2Efki4iC4S/uRsdecZx9GSc4vT24
	rxnR29EYDGw0jG4F0mZ43nQHHRNJeU1EZAVA5HOGlQr/C3FjV3f0cjm4ooqbPBv9xafcASUYsQ=
	=
X-Google-Smtp-Source: AGHT+IGXvBRS2ISmkSgOkaf9NDWmbD8mKXwPO0SBtc5D+QUv2VkxB2qWcK8BGtwXEr2R0/0t367Gpg==
X-Received: by 2002:a05:600c:4e0e:b0:43c:fda5:41e9 with SMTP id 5b1f17b1804b1-43ed0da5960mr184760875e9.31.1744118462693;
        Tue, 08 Apr 2025 06:21:02 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec36699e0sm162159705e9.35.2025.04.08.06.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 06:21:02 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v4 1/5] configure: arm64: Don't display 'aarch64' as the default architecture
Date: Tue,  8 Apr 2025 14:20:50 +0100
Message-ID: <20250408132053.2397018-3-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408132053.2397018-2-jean-philippe@linaro.org>
References: <20250408132053.2397018-2-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexandru Elisei <alexandru.elisei@arm.com>

--arch=aarch64, intentional or not, has been supported since the initial
arm64 support, commit 39ac3f8494be ("arm64: initial drop"). However,
"aarch64" does not show up in the list of supported architectures, but
it's displayed as the default architecture if doing ./configure --help
on an arm64 machine.

The help text for --arch changes from:

   --arch=ARCH            architecture to compile for (aarch64). ARCH can be one of:
                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64

to:

    --arch=ARCH            architecture to compile for (arm64). ARCH can be one of:
                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 configure | 1 +
 1 file changed, 1 insertion(+)

diff --git a/configure b/configure
index 52904d3a..010c68ff 100755
--- a/configure
+++ b/configure
@@ -43,6 +43,7 @@ else
 fi
 
 usage() {
+    [ "$arch" = "aarch64" ] && arch="arm64"
     cat <<-EOF
 	Usage: $0 [options]
 
-- 
2.49.0


