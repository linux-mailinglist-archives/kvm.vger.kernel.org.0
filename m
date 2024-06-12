Return-Path: <kvm+bounces-19442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CD7F9051A1
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 13:52:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 959CDB241A0
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 11:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30BE916F846;
	Wed, 12 Jun 2024 11:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MqOqwi/1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A5D16F288
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 11:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718193106; cv=none; b=KqypajhPHFr5v6ts18ZX9p9Qt7Hh6vj5oJzVpsQG5KACRhF8GpEE5q3AxofAhiDhzBpGa9Gg0tfIajd2ogEEbHC49Od9EOs8E/gLRRjsFZej/0S2Mmfe2LHNuhZWAzuo8NU8J6DqAVLx1dbhZy7UP1vGI44erBF/o4NRooFk7n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718193106; c=relaxed/simple;
	bh=Iap+yq/UFPMhzwMJN1/W29xopjf+UPCfBHcc+afOI+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqLJUroPC3k70tQFxsFIdQet44BEU6MkygZzyqHEhg6A517jKAsJ/KXvzhkafRoFLtZTV0rXcVGBPvwcSJH46DA/vwcW8gx+Kng/Fh6hnGaFm5KVtN03Yh0wNwyo+MQUz4EvHYeTYAAYuAb4Mw/EJ+5O6Vj59OSH48o7plvxRvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MqOqwi/1; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-35f236a563cso1673188f8f.2
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 04:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718193102; x=1718797902; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ts2smytxY9xlqDn06N5ZqiAGp4oK5EeYYIBFYgm141E=;
        b=MqOqwi/12tRyx06FZsWZCfP1wvIWGqsOsevlrnRo/kDCrABrJasNNoHqyOnHXG9nAy
         fNAy8KlYwCoymLcuS5OBYJNOXqLYvppe7k0SVSjiRfMZmtLkwaQKHb+Ri89zwnjaMCXz
         2TzCRRooM4fN1as7wdzUcAOuxNnQXz4TyjlLUEL+P16cdLza1ZgJiDpKU8srCeW59GBP
         qPI8SgFm4L3uPBxv3jVevR+ZY/s3bCuEuACv9/1SY+tGAM598YxNyPSL8bCppk7gY0Kp
         gG7KnR3usgr6XsK+uuj3FCQPcGzi8m+RDYdtDsVIB5i2+9xw1EZUPnGLnJnQP1jv6N7p
         lq2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718193102; x=1718797902;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ts2smytxY9xlqDn06N5ZqiAGp4oK5EeYYIBFYgm141E=;
        b=sk+7x1zcEALOsOtScFyOvOMkcxzd1Oy7QEBCvRiZbyL6q/0oWA8HFmPJL0AsTWsRaE
         65R0kqnN3k2NZBPqQWGY5br9Js1vJs+lSr+rLa9aFUlz/ZQpY/Vn9slwKjNKEgDsbtLq
         RfJEPoLJ9/ESqTkSNQDgKTUcdbQIRl+be0TX6jgbHiZDvUE/WPPwIg0tv4mRO7PZEkNE
         dkoms+FmCErhm6huy3p8aof82MqhKu21zeD6MaMEHOF5cJVnMWnPNnxk2wGZaK0p7UVw
         BoZbb8SbaxcKvCe5gif5rJimxSgpE4kXn8G2oABva1eMo060DwaQ7+Jj86wNtlBcLGpT
         HTsA==
X-Forwarded-Encrypted: i=1; AJvYcCVsf3cUeZBUtlePDj3FVK+OmInLaYx4pVWrAljN5FnWyXNKILo7QWK3pUWTftZTXCCH6DJCCTqm/trUx0XBCbJndn+L
X-Gm-Message-State: AOJu0YwY2VrXpCDXuITIBKS0on0svngv0ERdAEA/zQL++agOwiCJOceN
	R4yVX4hXECV7fmdu5fOcGWduNSdJ+P9Ay0fS5Bhk/tDpVmsxepSu8VClK0iiLXE=
X-Google-Smtp-Source: AGHT+IGB21Kf+Yq70AofnMnKtJ/sAErPjS2QGuOdCNlXD6VJnixK2VEnojOvLWIJ653dzNytJ5zyZA==
X-Received: by 2002:a05:6000:196c:b0:35f:1c6b:2b24 with SMTP id ffacd0b85a97d-35fe88c9498mr1167357f8f.29.1718193101706;
        Wed, 12 Jun 2024 04:51:41 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35f23fe7a64sm8174762f8f.89.2024.06.12.04.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 04:51:41 -0700 (PDT)
From: Dan Carpenter <dan.carpenter@linaro.org>
To: error27@gmail.com,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Brijesh Singh <brijesh.singh@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: SVM: Fix an error code in sev_gmem_post_populate()
Date: Wed, 12 Jun 2024 14:50:39 +0300
Message-ID: <20240612115040.2423290-4-dan.carpenter@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240612115040.2423290-2-dan.carpenter@linaro.org>
References: <20240612115040.2423290-2-dan.carpenter@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The copy_from_user() function returns the number of bytes which it
was not able to copy.  Return -EFAULT instead.

Fixes: dee5a47cc7a4 ("KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 arch/x86/kvm/svm/sev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 70d8d213d401..14bb52ebd65a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2220,9 +2220,10 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
 		if (src) {
 			void *vaddr = kmap_local_pfn(pfn + i);
 
-			ret = copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE);
-			if (ret)
+			if (copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE)) {
+				ret = -EFAULT;
 				goto err;
+			}
 			kunmap_local(vaddr);
 		}
 
-- 
2.43.0


