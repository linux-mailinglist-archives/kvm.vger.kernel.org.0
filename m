Return-Path: <kvm+bounces-41623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5756DA6B0DF
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:32:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B09D94A3880
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:32:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D542D22D4F3;
	Thu, 20 Mar 2025 22:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rMuc9IU2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC9022D788
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509834; cv=none; b=Akyluf2nrn3+1Y2WsBmuBBjsIY5ged/yakhJKILHCiiID8+4+HxyXu3k0b6hrBcLipFKeGNmAezdbfDBzJeYYTfolXqRbxeDoFcsqQEhPKSlnE4K+C1hD0e/5D7GOhbbrb0pEfy2i9EKJ90MTNjHcZTyT/aLfanjPNxp+Tn7b5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509834; c=relaxed/simple;
	bh=k9MtLjxvHtMf1ojeSdFvdJVTcmy8hZOXMf4EdWaNOC4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hz7kFuBWsQNH++jl1CtnwykwOQ0O8r2yc4oEF8NbAz6cng9m6l4ohFxXSTr/zE1ep+Iyt4TcrapssbY9fyTRKmivqOTR2DrFednoWyf8jwVX55P/bkpauoNmjic0PtYnWCAWudjKsBEUTMTJRUeoqB5uPGE+eRXIK3T/1dykslg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rMuc9IU2; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-223fd89d036so26352545ad.1
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509832; x=1743114632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4+5iQ3rOTBSPEFMTgcjt+dky/l4beaGAM9ptuF8lc/c=;
        b=rMuc9IU2Z43FqhfstTJdoQ05LKy5RyTQ+nN8+SGHr4+AIeNxN0rpCciuXRbKm9Gsdb
         HSPwGe/1T/XVffbqdMkYS/g1a/Ak4hEVK+fhaSUy82kIaZZc7gEMJfqF6zjELbCbU4Pw
         RA9YYJ1XQinSBr2SGqZ3BC7ciE6xGpAuKTi8Ith4UkclZ0Ekrfb+e4Q6NcmXNZCp4+ka
         d9lSrs2dqXcd/255vWgrPlFsjLK+mY0cWQ2+7RV6aOsiJR0ESNqhvb1R9GqymC1zxtsb
         xMm+qSWpIpJzC7IiaNLS5Pv3lEbghErq2jlLLmkDIrhvB2xyNv16L91uYRWjDWtTrUrU
         QaJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509832; x=1743114632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4+5iQ3rOTBSPEFMTgcjt+dky/l4beaGAM9ptuF8lc/c=;
        b=MwRotF57at3JIrtMLkH0ZzDHVjnrfn7wJqgdFv9iO4vhiih587tNwjsLspM6NpPERZ
         W6r+eRGOKL/XIGZyQ+idSTQ0PbxDpjtqBPSJjVDGkeuUeFwBjf+nyproAGMB2TxiKNYb
         v+o+OCdTCOY2ooQ9kNb/NUO6B1DnFhNryqNolZGwtKYWRp4cmuFyy0ZyzoA3T0FuCIBe
         65omwaggZrsdPz+R4zGwLPNMxwT5C2fpXbGo5P8W+h6KDYkAMt387tFqqC7WKjZ9n4cv
         d9H5j3wCXeF2E+ad72hj6Ig+BLAvEnbyrFnWGtY5xvq4i3HrYAbe4SFJMg+61zy9k6d6
         m+1w==
X-Gm-Message-State: AOJu0YzD23zIVNZfSrkcVoXBknj7A7kG6yFQdjqUvIDCAtYf42VuoXSD
	Lw70l7IYvTc+TlsncxGsIfgYf01apjAlKi8ZR1QMxWqr6gx7bMUjwt11XTj4O+Q=
X-Gm-Gg: ASbGncspveyodP1EiGBw0fm9sdubFWAsj8mhrR5ULwNOLdKOkx6uRJdelLO/DrtHHVg
	g909yEE019I/T7sZqov3+f9HXqRHXaTfO4zY8rGo+aYradz7ZcyZz0bDEGCuopf+alZoVXA52HH
	Z+DipaomIWhJp8eKPm/SABcTuvZhdBzMF8/6V1kQ2G3LVOmUelv8xVKU1Jhlu6BsVJSZtUwKlAn
	+PmIwnMKE8ZY1oTssai99a6TIxzoAeQkNXMd0oY7knFqvqnuA5hT1KDuTNUvKTTHMr1ZY0/fQYr
	onb0e8neJ4vDkqdA26qDO5kyfilToOSvIQ3Mo69eGsVW
X-Google-Smtp-Source: AGHT+IFZleVXELavrvrw7HY5fmpI4AcmTcQwLh35eXn6L+ltqmgswJc0Gwxa0tcE3YRrZRjHRWIdoA==
X-Received: by 2002:a17:903:94f:b0:223:5de7:6c81 with SMTP id d9443c01a7336-22780db3061mr18350425ad.27.1742509831956;
        Thu, 20 Mar 2025 15:30:31 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:31 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 20/30] target/arm/cpu: always define kvm related registers
Date: Thu, 20 Mar 2025 15:29:52 -0700
Message-Id: <20250320223002.2915728-21-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This does not hurt, even if they are not used.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/cpu.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index a8a1a8faf6b..ab7412772bc 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -971,7 +971,6 @@ struct ArchCPU {
      */
     uint32_t kvm_target;
 
-#ifdef CONFIG_KVM
     /* KVM init features for this CPU */
     uint32_t kvm_init_features[7];
 
@@ -984,7 +983,6 @@ struct ArchCPU {
 
     /* KVM steal time */
     OnOffAuto kvm_steal_time;
-#endif /* CONFIG_KVM */
 
     /* Uniprocessor system with MP extensions */
     bool mp_is_up;
-- 
2.39.5


