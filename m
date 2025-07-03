Return-Path: <kvm+bounces-51510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 67E08AF7EEB
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 19:33:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B7884A1988
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 17:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34CF228CF58;
	Thu,  3 Jul 2025 17:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RbaGpbKW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C24128641E
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 17:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751564000; cv=none; b=SPIadIRDeOVF41JjfF3gO8U7y3CEWPnTtB+fyz8DQaRIfVZ0PpMnyMhPXt7ciCKiX34qsnk8LcWjJDXOUXrkOzIOHv7NerUM6E7BxD+iq+YMP5GLNVnCR+zftmA1UwCLP+lPadRw9QkntMET8bbYeHd+/ycUgLjfn18P+DeoP9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751564000; c=relaxed/simple;
	bh=4KDm+9RfFQyZb64EFhKrtF4Y23m5BvXW3KljR85Cew8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IGmVYxPehSCgozMhBk4YyMSKEDASrdZnEdnFfXIbkZGWA/G46wYXT/0u3/7RYQp9wNFJe/w2txK9FnGW2yxJP/UPaizx7uPdowvQyocwnBsyhcQ/Sv9LjPYqFB03fRa7j6HtgurhmjQpp0Sr/PxisDka/qUJ5N7MmABGlfqE9qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RbaGpbKW; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3a5257748e1so37251f8f.2
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 10:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751563996; x=1752168796; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GAzT+CGbAi3kvmYQ13E5MHk/eJNqjsj98Rjqkr8WsQ8=;
        b=RbaGpbKWomkR/sqCtWutJMWGnvdGlpGfhQT/+KfpZkuYfv9qz/kVPWdAwXXiSVPIDf
         qQU8RoVbpvgoA6Wwl7vzz9AiHA3sFNdXNLx7Q7U0VPr2jsverGgkpyGRVPqzFM8WjF51
         qFcRnQ0uOgUmg/ydjM3uXQ02Piv6kdq4mPiuva028WeU5METCNWFRxLFR7lypW6B7oSh
         vBIU1ChGPTp+3GdYNUOoI6WGsEllLxUzmm8k3STJPVFaSkiRdw6A6Cw0r6AVfihEA4ik
         LLUCotiZrcQPk45bjIakYcMYVR7WC0F2IHYKdp4W3f846RctMcpYj73RSNU8LZ8PfTNF
         HKLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751563996; x=1752168796;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GAzT+CGbAi3kvmYQ13E5MHk/eJNqjsj98Rjqkr8WsQ8=;
        b=FJlvJCSPYEhjOH61g+wBBTlD2yVcjg38OcPLejGWlHHoSZTdHr6BSkjRQvrjqm7sgh
         DjYUIQZz5l8UykUSDMvSjYiKfwj1e7LJYk/xnF383mLdpswJKPZOQ4s7OE3zz3TzgAMa
         Nmr1vlSW3Yn63ymaxa13XU32GYG8U6Mp3Sj5Gvpua8speEc6mvQi/sQh468zdLfmT9V2
         RgQCsdYrpdc323HlXZ+3njdy3LEKpfHTvOiXDsfH9r7SQvMIekbqBJ5Y7IO261XLjeQR
         d8JfbNYGOvMz/98p1mIKx4t6D3DADMkaFEMnVL5YqoRavfvpHqKdYmdbcFIcsFSueQXD
         1+/A==
X-Forwarded-Encrypted: i=1; AJvYcCWRUYJz4r6VmV+fWa0YQX0mMtILOnC+WmyxeDHe58cldXjN2UihT8rn75j+2ttqwBzn0kE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/Dal6lSG2zX9myrw73O/xYhGipoexw3Pj3LxPy9CvEco4jb5I
	5yMm/GsTq4tgTNw+VlbhRpC7XspsMwkFni1FkqTtQQkG7q4kniIfeIfG3v8OwtQPuw8=
X-Gm-Gg: ASbGncuWjP0EOQL/bDM+w6gx9D6pCHJATwd9hHhd9WnhRiH77n7XhstZN0b/OLU7l/x
	8hpDuMQxiXxEctrMCMp4Kf9ji2B37hk0Y9PvJ4abR2snUYxz8hUyqGmtFC3fGKQnQsclPIsH3RP
	3o88ayVcJibBfVCgyKSltb/PelIlbDveo4gCxQF2sVTqNhurBKQ2KneQGAhuWd1NnhhQgqjpPrO
	qlyJBfa23q5EY66cDawArro4NcS1hIvCpW2kN90h+NIWG43yr5hljQR/Nxe3bpHZTQChLj3V6WU
	ihIgpC+D4ayfiUXiAfSCqMiJ8eRbCx5eSG+cWYwcBjgGp4c8enZZc94oIhlH4ABH9jQBE21j80/
	XxWA/aY54cd4zjR6X1nfTuwfj4Fl6qavvyCIs
X-Google-Smtp-Source: AGHT+IGh9RS69JWNJgwXCxoG24NZSngb1bZPnTE9GAXQAWzmNTnSn2b0+ZIFTnOK3Brqe8Us0t3MKw==
X-Received: by 2002:a05:6000:26cd:b0:3a5:3a3b:6a3a with SMTP id ffacd0b85a97d-3b201ba1ebdmr6134479f8f.54.1751563995936;
        Thu, 03 Jul 2025 10:33:15 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b47225a2dcsm309045f8f.71.2025.07.03.10.33.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 10:33:15 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org
Subject: [PATCH v6 05/39] accel/kvm: Remove kvm_init_cpu_signals() stub
Date: Thu,  3 Jul 2025 19:32:11 +0200
Message-ID: <20250703173248.44995-6-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703173248.44995-1-philmd@linaro.org>
References: <20250703173248.44995-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since commit 57038a92bb0 ("cpus: extract out kvm-specific code
to accel/kvm") the kvm_init_cpu_signals() stub is not necessary.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/stubs/kvm-stub.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index ecfd7636f5f..b9b4427c919 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -105,11 +105,6 @@ unsigned int kvm_get_free_memslots(void)
     return 0;
 }
 
-void kvm_init_cpu_signals(CPUState *cpu)
-{
-    abort();
-}
-
 bool kvm_arm_supports_user_irq(void)
 {
     return false;
-- 
2.49.0


