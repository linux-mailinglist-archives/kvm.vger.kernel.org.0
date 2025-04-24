Return-Path: <kvm+bounces-44179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DB28A9B0C2
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:27:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46D4F4A4E72
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:27:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ACF3297A52;
	Thu, 24 Apr 2025 14:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A/BNi9dr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1798C2951B1
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 14:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504075; cv=none; b=Ri4E6KPaOMEVrpRyO1RD173IpFDQqSuT7qX2GRUv3tae/NNvvPKhGcUzdYrKKYFwviOb8pS6oPm58PAYHekY65tzy8uJxpgmhzujbbiud+pFqM7SmwWzekVTZjGGmYR2qRSRGvsOugiq2rmrfWlay0yQoPAAoZc3nAFK2HKOPHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504075; c=relaxed/simple;
	bh=N53i4bFiZ0PwECXO+3O9PEZg7KbhghQli4Mhy0f7goE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MM2VeY7eKPdsD9WQv7HwHzJj9gvO7vHMiCD0o6dH/u+xRPMvqy2fPm+AIHeCGdx7KpS+eYBGRbdiW1slKueHyywZnqklvL6kz6HnliUVa3QXVUNf/nm0W/g5Bma9WOvFtZ7U/XITYHd3dBF/Z37Ffu1NKreEiu1MPzSywp/cKkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=A/BNi9dr; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-39c0dfad22aso841015f8f.2
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 07:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504070; x=1746108870; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3i+gLyWtr6XPiioNUTryX7U5TAHJs0bj5+QGltLz/R0=;
        b=A/BNi9drAEtZYzDLWDDHNkbHoLQ7G/rSzO6lWtT9wJBxxPLNRLXjqG2CV9Xf5QbQBT
         Sd9zeNztMZUVOCRA5OflPbZpQ0GAQKMtgYOZVkl6AYSf1iMSjRA5bELWM2/2Ro5G2jLp
         uJnN4FsqDjPExjGbLQI6o4GhGLVBgLi7/xUjnivg4y9khXjgA3Dmmzsi1UOyqNBUNBT8
         MVi1QC4XXmiTDjqog5ZbsG6l9kZaoZlE4hgdKAohqlGXx7MczFhDs/rVxT/XoUHclq03
         v+rEjUJ0/gcda3IVfMtpZfSgpUg8mpRx1XLX5Yctye5hH+r06rdmsphQr+bWu8Cqrz5t
         eCpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504070; x=1746108870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3i+gLyWtr6XPiioNUTryX7U5TAHJs0bj5+QGltLz/R0=;
        b=ZNYVEFWIkuQZ7dwDxmHuZ9Zid9ePG7oAe8MTaGvnxOlZkSuvLM8STTLlakVSt+dvwr
         IK/8CxYlmgRE+mmleiQL7YOO7Mi0NU5kP3m+3etkG2euQBt1DkZ0yZoe+Kxyo0ySMIl7
         OCQNTqpuwPmxLwUunPT/AvVXNBVpjqyFwr3eqwTs9TFvYBTsNe+KCiY7dIK/qIWVYER3
         lVW5lgtDOohHIteI3QlRFD/Z2/SXivJGSFL5L9dk298J6AL73IXOmaKch7fi80f4hTLX
         bFSL114Hz5hqjwK3e524j59nGl2h+nK/z+kH8u55uh7/bU+8Qk6fN5qmVmTBNouL1aN4
         ATnA==
X-Forwarded-Encrypted: i=1; AJvYcCWc/JMtFNZG0ZeOc8vUe6FUWeoL3cGWsaG/fKO4bzoV/cjbRu+ACsdSMt5yhZ/WYj06CO8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkiMfNGJ7Ev59wTiIn27kTilsRDWiWLhIwKiPHBb/jv+ArQtI+
	NEq4N2AZtGAAJl1KXZQF42dHYqrUv6vGynaKzCVqmX9Mk6L9Drfld2R6ifaT/94=
X-Gm-Gg: ASbGncv0ZMpU6iDIMMV5yWH6TbCRItbJYYzvYTOE4mzu8e/zhTZO8Z3SHuzZPyf/0an
	O43CyWW1YYdW1Od4gmZ5J+HvFHoVTdtt5LmgVnP1HajAFGv4HUBxiahuMLZfMdNQaKIm7LA9hPn
	phcMQJzknzii2LhBig96J5dg0rjBXXoKy2ninwovvik+YS0jY7iH2QB4R+5M9rHYCEBb14aMZ9u
	evS2wGDQhkJwPpSn2vbeT85Ogp2T0wyZUkDs808DrytPIT5jltyawWj0yzkpVvsqbiwiVIjbDPn
	hZEyb1eIxFCLUVxpTbaKusoJZZfU1zOa5Pp/IB7J0Xrm2qss0YfgD8yszkgMoN1tCJZOBOwXYiQ
	ekF0tnulRQirSokrW
X-Google-Smtp-Source: AGHT+IFOk65S5hPF/j31g7Of/aiN0lBptA3ImD/zObUzEDJUJE+zLunCG1fROxNheO7aYYEMJ9HW0A==
X-Received: by 2002:a5d:5f87:0:b0:38d:b325:471f with SMTP id ffacd0b85a97d-3a06cf5ac50mr2557177f8f.15.1745504070317;
        Thu, 24 Apr 2025 07:14:30 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:29 -0700 (PDT)
From: Karim Manaouil <karim.manaouil@linaro.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Karim Manaouil <karim.manaouil@linaro.org>,
	Alexander Graf <graf@amazon.com>,
	Alex Elder <elder@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
	Quentin Perret <qperret@google.com>,
	Rob Herring <robh@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>,
	Will Deacon <will@kernel.org>,
	Haripranesh S <haripran@qti.qualcomm.com>,
	Carl van Schaik <cvanscha@qti.qualcomm.com>,
	Murali Nalajala <mnalajal@quicinc.com>,
	Sreenivasulu Chalamcharla <sreeniva@qti.qualcomm.com>,
	Trilok Soni <tsoni@quicinc.com>,
	Stefan Schmidt <stefan.schmidt@linaro.org>
Subject: [RFC PATCH 34/34] KVM: gunyah: enable KVM for Gunyah
Date: Thu, 24 Apr 2025 15:13:41 +0100
Message-Id: <20250424141341.841734-35-karim.manaouil@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250424141341.841734-1-karim.manaouil@linaro.org>
References: <20250424141341.841734-1-karim.manaouil@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enable KVM to act as the interface to create and manage Qualcomm's
Gunyah-based virtual machines [1].

[1] https://www.qualcomm.com/developer/blog/2024/08/learn-about-gunyah--qualcomm-s-open-source--lightweight-hypervis

Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 arch/arm64/kvm/gunyah.c      | 12 ++++++++++++
 drivers/virt/gunyah/gunyah.c |  3 +++
 include/linux/gunyah.h       |  1 +
 3 files changed, 16 insertions(+)

diff --git a/arch/arm64/kvm/gunyah.c b/arch/arm64/kvm/gunyah.c
index 23b9128bf5b1..91f0260ef3f5 100644
--- a/arch/arm64/kvm/gunyah.c
+++ b/arch/arm64/kvm/gunyah.c
@@ -2071,3 +2071,15 @@ void kvm_arch_free_vm(struct kvm *kvm)
 
 	kfree(ghvm);
 }
+
+int kvm_gunyah_init(void)
+{
+	int err;
+
+	err = kvm_init(sizeof(struct kvm_vcpu), 0, THIS_MODULE);
+	if (err)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_gunyah_init);
diff --git a/drivers/virt/gunyah/gunyah.c b/drivers/virt/gunyah/gunyah.c
index 3e795e3ba881..629c812fbac0 100644
--- a/drivers/virt/gunyah/gunyah.c
+++ b/drivers/virt/gunyah/gunyah.c
@@ -28,6 +28,9 @@ static int gunyah_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	if (!kvm_gunyah_init())
+		pr_info("KVM for Gunyah is available!\n");
+
 	return devm_of_platform_populate(&pdev->dev);
 }
 
diff --git a/include/linux/gunyah.h b/include/linux/gunyah.h
index 26fdfa3174da..7d43449c4547 100644
--- a/include/linux/gunyah.h
+++ b/include/linux/gunyah.h
@@ -421,4 +421,5 @@ enum gunyah_error
 gunyah_hypercall_vcpu_run(u64 capid, unsigned long *resume_data,
 			  struct gunyah_hypercall_vcpu_run_resp *resp);
 
+int kvm_gunyah_init(void);
 #endif
-- 
2.39.5


