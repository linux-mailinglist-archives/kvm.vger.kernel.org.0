Return-Path: <kvm+bounces-19718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3A29909361
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 22:29:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70CA9288071
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 20:29:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE4581AB53E;
	Fri, 14 Jun 2024 20:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="qGTNRSE+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA3D18412B
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 20:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718396949; cv=none; b=CMPVxd5iTqjRhbSonxBP60EuPtwRAzNNybtwTpJdFT2/THdTNicXrX0UQEOIs4prbgD6OlcZAh8BkhGuVHE/YMvfj4HRL0r4OWwwJo+8/79epZsMRWjvM34EswJ0BUpSU+NtRQBeDIGGj2PzgVWFCXyjKQmgntuB+X4DlGx/3ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718396949; c=relaxed/simple;
	bh=Pd2HdXuVe2UBhoq2K89r5XG0/ruO202WXRk+Va9TcqY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ATIuexFpBv5VXR4TljTZa5ODtedGlSyRa7+RMdt7MkBJmJmV5JgRaqOV/M6qm+B+31kZCvWiCUWyOun8WfP66wcZWZ7YXlIBo2InJ9vHcjd7Fa7uZq5tl2LZkteMWVHwqBIaiWwsM11ERX3/szsa/m3P4w7/Qa/XlouRYzPn+bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=qGTNRSE+; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-57cb9efd8d1so3651624a12.0
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 13:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1718396946; x=1719001746; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YDvFl+EPL3F7DYWyyu2ZaTt9wg+uT9SOWROUYajJpQk=;
        b=qGTNRSE+0/ReIJPqFXn8KEGcMc8ilrPDJWrU3HbdEzpayNXdrZuRJkr3cOfSRKBkFA
         Zst0Gcj91kBI7KYJCI2pa65YnMjkyih8r4VvPPNudOK2665lrGqxCzvxs800qNuXsWa7
         i7Py8Fi7s1Wb05l8GOtX7+z6gieLRvdBW/RvkhZ6x8PkfON9P0tnyp6Lua2e0RdbJZad
         uWAxVpghXz6GDsXiW0mSC/7nHhshYxy9Vv7cV+64+8tIijAh7+l8R1AE6hdfNUNtfbrI
         UW2gEFAVzbfCfYI3DCE0Tz54cuV8wNEYYA6zcfnPWR46VmCkKpBuVC7Mhywak7rjUyVO
         T2Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718396946; x=1719001746;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YDvFl+EPL3F7DYWyyu2ZaTt9wg+uT9SOWROUYajJpQk=;
        b=GUDdxOljTUTieU2uWO5kwFzIesU3DR5PWjko7kxYQn1VoMR20LYcYL70PNBadyJN6Q
         UDfRMi02imCo2qyeIzHIC70/2LMpg7eKYLTC5aAygFjMpCt13YQS9fe5PrDGH4EFycBx
         WoIcViUvjCY2x57b5fNjf9tXf1opTYwRvdHSEuT8HQPiT8vCuEDGqzEMhQMgT9s+utBz
         C4H7RT0xg1WK/Ridcp7ost+ERaRqCR0epLF7Xp8JlDoUSQJQ79kM7xqn9KSOzIEXvQAa
         xsJn25m0v2o7fIDgqbK22NVoWHTmmG6ldl6c2gt9HzQ9lPy7TVHxtu07UZpj2/RJg8iy
         1Kqw==
X-Gm-Message-State: AOJu0YzbLMFlz+4MR+Aknwkh8pX59K+xtobHg1563X7uw0CGzYuoAIDe
	oqY1tLYdOj7OQnPyqI/y5W0sU1s7zfzhW5U6CEhO/4QcEmfu34EisX+tka4kgOQ=
X-Google-Smtp-Source: AGHT+IE/Fu7sIvNHatCktQF57qVLGzqP8NIDqZ0rpV7HIZCCBXqmuqPGGPxxUFO8NGSgy+dpQsvPNw==
X-Received: by 2002:a17:906:d7a2:b0:a6f:1c58:754a with SMTP id a640c23a62f3a-a6f5245cd05mr425115166b.24.1718396945762;
        Fri, 14 Jun 2024 13:29:05 -0700 (PDT)
Received: from bell.fritz.box (p200300f6af332a00214df27025e50a49.dip0.t-ipconnect.de. [2003:f6:af33:2a00:214d:f270:25e5:a49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56ed3685sm217474166b.126.2024.06.14.13.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 13:29:05 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH v3 3/5] KVM: x86: Prevent excluding the BSP on setting max_vcpu_ids
Date: Fri, 14 Jun 2024 22:28:57 +0200
Message-Id: <20240614202859.3597745-4-minipli@grsecurity.net>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240614202859.3597745-1-minipli@grsecurity.net>
References: <20240614202859.3597745-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

If the BSP vCPU ID was already set, ensure it doesn't get excluded when
limiting vCPU IDs via KVM_CAP_MAX_VCPU_ID.

[mks: provide commit message, code by Sean]
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 arch/x86/kvm/x86.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 686606f61dee..eeb35fb1573a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6701,7 +6701,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			break;
 
 		mutex_lock(&kvm->lock);
-		if (kvm->arch.max_vcpu_ids == cap->args[0]) {
+		if (kvm->arch.bsp_vcpu_id > cap->args[0]) {
+			;
+		} else if (kvm->arch.max_vcpu_ids == cap->args[0]) {
 			r = 0;
 		} else if (!kvm->arch.max_vcpu_ids) {
 			kvm->arch.max_vcpu_ids = cap->args[0];
-- 
2.30.2


