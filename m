Return-Path: <kvm+bounces-9575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B9095861D7E
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 21:22:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 540C61F21D2D
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 20:22:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 702C014CABB;
	Fri, 23 Feb 2024 20:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HXswtQXg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6B414938C
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 20:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708719672; cv=none; b=gSt+9OaFhZeJ9xSzdOu4bbEf8sBePWgpM7jw8KlbN1vythBz3RV1DUVi4WCzE7fYezj+Twn4WdbfERg4Co8E36qyp1Gwp+Hh8Y1WEr6p2YLh756UaxTwXZKO4NCQRH7xNiMY5+RRD/K/Ntb3CsGihEbgXpY9Q+JbfK20eb8TWTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708719672; c=relaxed/simple;
	bh=HGThLVUxXYbVSOOZxCrgBI4/8udXcy4h8pBaZ8gILd4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eZc6UJqws00m8j1YwIcJEPv9pIRHexswxhafRDZ6uWQgRx/jI8WAJJM26AaskF1G0yDfnYZb7dS5Yjh66TC5ckH+72CyCosqGGeeTie/pbs2MtmDwe4Y3BI7jdjCHarCqpZUJUdpFuH9O7lDeqaN52AZ7lUk+xR/RmILI9C87Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HXswtQXg; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e4d0e28cd1so846430b3a.0
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 12:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708719670; x=1709324470; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SJIQNAlIsKGXsg0lFIYuueKE4jyUGKIK5OKq5RD486Q=;
        b=HXswtQXgBREBdmoKabdRaJen+fLGcnUNFTYOZR0tnm9hpXuuoYpSAZNymOK8xD+le3
         jYmcz0L+2WUypcToslY5SxvCEFPysoh21Iggl0rgdd1iS6rAONBBQNNfKRMGPcIjhD6W
         v55MlgkPuqkZYUbiBdtto5WuB4gOjTd3i4CW2fUv65qZ8huv4XlKiYYjklgLGJDPCr4t
         bQN7fHpdL4qOgJL40fZxWc56rXnPp58R4DBUfPNBGb4x/epv1uIqeStMICjtB1sJeEGa
         mujKs29fcmSIgxmfeb8hAUBf8140LMIffBdbI7DC8AJQV8uvEihwb8ozLO3J9QzwIdB/
         liiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708719670; x=1709324470;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SJIQNAlIsKGXsg0lFIYuueKE4jyUGKIK5OKq5RD486Q=;
        b=D4K9s3POB1KWBv3zrC/43E38IsdkLfh/bRlbfeG+t6Diozdo8y0QN9vVNv0pg6CUnj
         HYRvKtM/fR2nBeSzslAIFzkjRw3N9S2dBTlvg2t3qolDuW/8PeUOTYCMKFRjSwtGhTo0
         FQJwgVj55GhoS1OFiDGGyoIHHbvkBBeDVeRWXG7dIlTztfBjnZHa9QLi04VjRIqy5kX+
         vyUUH9qGniDSrc3WxHJaOgVNOl7D4a/Zi7Ew2mIt5hZMy9BpmUtJIYwebFKp9EJU5nlC
         i2CGBQoPFJdWzJm7f78mM0iRgVOysFQ7e77oEuNsAkis5QrEaz0grpe+0vwxGWJhykyB
         ICdA==
X-Gm-Message-State: AOJu0Yy+IXB6FzRu84qj+LIPp8F3xRhMx5PEKjJWG7Bs6t6GzBTIgB1j
	W+q5biagpkJGm3E5KAB8inzIIaGmIH6YYxT/keNZrkcy5lFJ8HGMQEPRDFw/oxHc5TqFDKNtHpN
	ujg==
X-Google-Smtp-Source: AGHT+IFTnRQtCDzRnGZQfMKCP1Sben1lkat4SJ0r2UaFSBXl30JLLLG//l2lC62khs4DclZsMGiqGb9wwLU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3cd1:b0:6e4:8aa4:387b with SMTP id
 ln17-20020a056a003cd100b006e48aa4387bmr67638pfb.1.1708719670527; Fri, 23 Feb
 2024 12:21:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Feb 2024 12:21:03 -0800
In-Reply-To: <20240223202104.3330974-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223202104.3330974-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223202104.3330974-3-seanjc@google.com>
Subject: [PATCH v2 2/3] KVM: VMX: return early if msr_bitmap is not supported
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongli Zhang <dongli.zhang@oracle.com>
Content-Type: text/plain; charset="UTF-8"

From: Dongli Zhang <dongli.zhang@oracle.com>

The vmx_msr_filter_changed() may directly/indirectly calls only
vmx_enable_intercept_for_msr() or vmx_disable_intercept_for_msr(). Those
two functions may exit immediately if !cpu_has_vmx_msr_bitmap().

vmx_msr_filter_changed()
-> vmx_disable_intercept_for_msr()
-> pt_update_intercept_for_msr()
   -> vmx_set_intercept_for_msr()
      -> vmx_enable_intercept_for_msr()
      -> vmx_disable_intercept_for_msr()

Therefore, we exit early if !cpu_has_vmx_msr_bitmap().

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7470a7fb1014..014cf47dc66b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4127,6 +4127,9 @@ static void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 i;
 
+	if (!cpu_has_vmx_msr_bitmap())
+		return;
+
 	/*
 	 * Redo intercept permissions for MSRs that KVM is passing through to
 	 * the guest.  Disabling interception will check the new MSR filter and
-- 
2.44.0.rc0.258.g7320e95886-goog


