Return-Path: <kvm+bounces-51444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9845BAF7143
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:00:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6BD94E4F94
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:59:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D3EA2E3382;
	Thu,  3 Jul 2025 10:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XUgK921j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B73B2E266C
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540363; cv=none; b=r39hgidJ97Osv3ZqaNWY2ITMWntMnyZu8b/7coIDncSk0HQA0/tiDnRvjb5MokKwRKliKIoYSgYEMp+UZZrrkZbJ/psZc39qoF+a0SDwXcnuNyjU0fmPu48j2yHL7E/3V9Lsjra0sRAfGmaRhW39nEsZNTEOGNihXBVxgOmjwBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540363; c=relaxed/simple;
	bh=p4v5+xFQO3bIoTjIeunVHI9ztp+MZVY9SK6UWvAZyg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sqwa3y2GVSeMwWvA09hA88p2UHebTCoBVtv3FrHPw9ebJWb6JCWYmn6dx4JU3h36AN5pt91yvdX8B2kB4+s+zyp/bqu4rVObk3Oo9QDctLpNgaYUFFoghDrdFlkgx9QqdmoJ79xmosPHl9AqI+PCDOKTqS+QVZQT121VdONEuFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XUgK921j; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45348bff79fso55568665e9.2
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540360; x=1752145160; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zOj2l0QjwiOWVtDmZos93I73sy6okOj775eGXYWLug4=;
        b=XUgK921jTVrtoVpX76Zps7F9PLgMy+Een0BzRc7kvsxRw5D4xKWdybhWlOgAnokkyG
         ooYY5qwILsgbKQ8/+keEQ3SDXRjV2XfkVyZQJu3tLD+dQOw+rxM5SDjExLszkCDJYWUC
         CdN2Bk9EGQYL1F0E6JD7fJTS78DBHWPoGh0MY72lXnULos2Qma6gZEEfsuvc8a+CE81T
         3EoUauVkJ+xROWGTWI9wlxDD/4eXvAd8d7qTeCZwf7GDUJ26pPnmICQl0xg9k86EMcti
         skr1BAZeK5zYkWRwXJzGhogq/TRRawmrkG0xT87Wd9lbN2FJdN522DjkmuRuHoCv8fAU
         TrJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540360; x=1752145160;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zOj2l0QjwiOWVtDmZos93I73sy6okOj775eGXYWLug4=;
        b=P31rCP+4uREKfLvuuGRc1/+J0Lz19pgJyj8hyS3mBAy6kcCc1+d6PCoVqw96xBdfdL
         UWVfJFw/hfW06KqgSOHz4hEW2WP6qEXk3isxSOs2uUeyGC1DlQXOuvtnCH47okwURE37
         qwsdN0TavendPxWotsRlIG0EcvAmHfwAeN9tQGOB+kodWIc6N/VL5NkZA41FbZe6OEIl
         oK+Klv7R8PwWkaFg1QEQ6DORyMPuiZQoQdrUMv5QR0nbRhqDHmTXEUGz3K5qzj895a/L
         qAlmNLUIfj2no0if1d+gCHJVpvtdm4NNPsN7o5FEnAJYJKtZLCiLLN45yQD851cjX/fb
         S7dg==
X-Forwarded-Encrypted: i=1; AJvYcCVRXOCs3fawWGGE+OPo9h6DmuudzMk9j2G4eQ2jbGskqAfHmuO7uoPgplBaHLmwQQrPQA8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yys6nCYiFMa5e1oJmn0E65tmjqvo+4tVOtM2laCXQmIYrhw2+qM
	Ros+/G8tSZlMQsjDbG1YP3cKuM+w+QS6pnXcAPRHb+wKOO1OkPYcMwkEspedEljm1UQ=
X-Gm-Gg: ASbGncs5MYjv1KL4m+8E5mYf7JMbaAFqD+YtLVXy8oZKbupR2Bu6vgQ59sliWT/zXwU
	XZTQuW2TrXyhJ1YSQwRWpZYugQiLjL/FuJfS0Q47hJhsn3/Z+tG4tYrMxN1bKL1RvZfKpaG8bMg
	ooqOOTbQ+TNLPFj+q92KlWU+Wztk10Uo3iY9xFd/Ss5MvBsqW4Fl49oqr9d0M6++M7z071tdid9
	mDh5IUiU5qe1Fc3DcLzG+ygN3UZhRvGZFdBfl6gkjyU7FUoplF/AfQhBs4OzB1NhhRV6Op6XVel
	6RNvRSi47PPxaMNVjgCmTnpncDzDzxywATv5+J/5TLWv1CHHe/idqJo7UaaPxoGXC1i6M16dsyL
	uEitbDsPiUTQ=
X-Google-Smtp-Source: AGHT+IHoayANiPOkuTLi8ug1zCVOH/mAiXBkNOtM7bZ4tNPWn87D4+AzaCT/cMsJ55dAh9k4I6N40Q==
X-Received: by 2002:a05:600c:548e:b0:453:5c30:a1d0 with SMTP id 5b1f17b1804b1-454acdecbf0mr15392135e9.21.1751540359747;
        Thu, 03 Jul 2025 03:59:19 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a88c8013fesm18582853f8f.38.2025.07.03.03.59.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:59:19 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 41/69] accel/kvm: Remove kvm_cpu_synchronize_state() stub
Date: Thu,  3 Jul 2025 12:55:07 +0200
Message-ID: <20250703105540.67664-42-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since commit 57038a92bb0 ("cpus: extract out kvm-specific code
to accel/kvm") the kvm_cpu_synchronize_state() stub is not
necessary.

Fixes: e0715f6abce ("kvm: remove kvm specific functions from global includes")
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/stubs/kvm-stub.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index b9b4427c919..68cd33ba973 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -29,10 +29,6 @@ void kvm_flush_coalesced_mmio_buffer(void)
 {
 }
 
-void kvm_cpu_synchronize_state(CPUState *cpu)
-{
-}
-
 bool kvm_has_sync_mmu(void)
 {
     return false;
-- 
2.49.0


