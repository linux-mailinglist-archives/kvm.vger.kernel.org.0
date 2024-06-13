Return-Path: <kvm+bounces-19587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76818907539
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 16:34:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95EB41C21D93
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 14:34:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7725214658F;
	Thu, 13 Jun 2024 14:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sYv5PwDn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9DC14430A
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 14:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718289205; cv=none; b=I+A4LewcmbOkQBFX5/b7/ZLmmZ4AqGQi2qB5Dm3/H/4V90asOJOl5UqlYbRSlj4qSC/vaWsOd9Z8yUf4iO2HY2TSFG2QeOjJznTPiYZ2YDb/ixac2TVRqfkfD8k6TrDTpw0HjYXliMA9LXD4qai0nIJgQT5X2pEql5RUhghZkBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718289205; c=relaxed/simple;
	bh=36k0SvBf/xqZeOaPdRVVmeSGR1kCRx71+MzeGyhBGoo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=sqp5eoR+Vdp6FV30G1vb/zkC0TkY1k/IITsRfShbzkLsK3ZBEQLMQREM8gPuGmACV33/lIxeWV6wuaSPSc6+iiSD4OHwW1qVlj1bwYEmBaJ7osi2xdLYVlOB63Mg5r6oZ1cb6/7xES2jAuhmLnBV0Lw70AvQUtoHuBCu3K0JjwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sYv5PwDn; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-35f22d3abf1so1049474f8f.1
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 07:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718289201; x=1718894001; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m6U1CejGzjWUwZtad2oj4Tzh3DOcxhD9vinE0KAneMg=;
        b=sYv5PwDniEjZ5EGlIWZEB+W7R83U/wvW7Sk9WZvBdh9qP0Sqjywc4cuzDPtedNqTqX
         DAKem/ueqwKWiFPwE3jgWOdYCpOfzIFenL2wlV+98OOtsLLCnnBdNBUNNWL9ejtQXfqt
         MZbRIWPS7wQQIRDPcDymXPjKHHDgh5WWYA4/LLrrSTDyeR2nMZ4Kf0dowSVXtiNAwRic
         nYjACNvRJ4oGwzS25zPTwQl3kwqlZPFskWXMkzpy2N7XYCSbQgyYkRrrZiSeAqzIviMV
         HlxTbl1fEEcyhQAvUZBOsKfo7xCTo8qRUd9zQAi2kFhIy/bw3na0D1XMLQKXk2XHS7d9
         MmEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718289201; x=1718894001;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m6U1CejGzjWUwZtad2oj4Tzh3DOcxhD9vinE0KAneMg=;
        b=WqhcgF4vMrrT3QXa0FsEgiTdYPLToywW2eaWfwoG5UkjisLEG1k04YTLFXW83D7u61
         nfbgQp6R4XkXkZFY0thL6KjciNnesU39AYpdjUVMqWB0imem54wzXLI4DbwD98tWfDMu
         g7HAnoF8g22Crv+J+sgpS7uLVDTO00e5wRL7eBU0yE4/YxQDb37xevP9i650fTe7iVSn
         thpW1gJ7S6+SC/+oxNf7q4TdX1Jg70IBB3UQlOUWJ+Ym98+Eeqokikf3FUZdsDaM/6cQ
         usdh+jAGnAEbkvr/o43u3k4AwjZSs8hMfVwLGRPAaFWNEoEEEaHUASX221eMG5wC+uub
         V3hQ==
X-Forwarded-Encrypted: i=1; AJvYcCVv2EHKvHE9JtoEf4XsNqXWQKNZ6F6FklPnfB1MCpq+aZ0va1V/oXBwcOFj0I4z1025P4ZAwKoHpkFBNmz8HXQxl0LF
X-Gm-Message-State: AOJu0YyavQUwHsC5BsHTAKKATDIT7K0iYdDkxY/h7mDPBVTtGqzIhJ0+
	8LXlpnbt7ZtuuC0KBwdaiPRRtlb3ZJ3hfn7mJy6AqRlUKr4SOU0BanOv2MUcjewYdcporroKknU
	z
X-Google-Smtp-Source: AGHT+IEL71vJla7SdEu7h2w8oi8ZuIynKyftPuJdsCsgUx9vcPoZ8C1LBzMrSr8Hgt+9Gwu3fYiC3Q==
X-Received: by 2002:a05:6000:dcb:b0:35f:27ec:ffee with SMTP id ffacd0b85a97d-35fe8926a2dmr3951164f8f.45.1718289200747;
        Thu, 13 Jun 2024 07:33:20 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3607509c890sm1905357f8f.28.2024.06.13.07.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 07:33:19 -0700 (PDT)
Date: Thu, 13 Jun 2024 17:33:16 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Yi Wang <foxywang@tencent.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] KVM: fix an error code in kvm_create_vm()
Message-ID: <02051e0a-09d8-49a2-917f-7c2f278a1ba1@moroto.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

This error path used to return -ENOMEM from the where r is initialized
at the top of the function.  But a new "r = kvm_init_irq_routing(kvm);"
was introduced in the middle of the function so now the error code is
not set and it eventually leads to a NULL dereference.  Set the error
code back to -ENOMEM.

Fixes: fbe4a7e881d4 ("KVM: Setup empty IRQ routing when creating a VM")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 virt/kvm/kvm_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 07ec9b67a202..ea7e32d722c9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1212,8 +1212,10 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	for (i = 0; i < KVM_NR_BUSES; i++) {
 		rcu_assign_pointer(kvm->buses[i],
 			kzalloc(sizeof(struct kvm_io_bus), GFP_KERNEL_ACCOUNT));
-		if (!kvm->buses[i])
+		if (!kvm->buses[i]) {
+			r = -ENOMEM;
 			goto out_err_no_arch_destroy_vm;
+		}
 	}
 
 	r = kvm_arch_init_vm(kvm, type);
-- 
2.43.0


