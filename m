Return-Path: <kvm+bounces-43967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B1A03A99200
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 17:38:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1EC6445DEC
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 15:31:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69204280CF0;
	Wed, 23 Apr 2025 15:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZfJBUchs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D422857C1;
	Wed, 23 Apr 2025 15:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421679; cv=none; b=lxlaGjwx7U971h6KXunKixmH86yrLkPxTbX0DNaVSNbZmRMNJ3qCKKuK010bILrC2k5RUlkPs4VcCaXaF0+fC7gDqiKhubzjJLpErqHDSStAtscLVGFaiB2G7z0CfUGBsfdSfbtma8+frIga19R3180v50ybIGQEot4sQgm2HsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421679; c=relaxed/simple;
	bh=ocihTxHKjDV8ZWlIROTSWda+Ts4l5IXkFmD+6cfyN3U=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:Content-Type:
	 MIME-Version; b=SrkITh4CpzUqYD/gTS8HvdC9fvbjvRvXfRR4nG4HPDErlSsLM260muQD00uel7n3hLwdj7pT54CYkUYW5qE9Kd6INQ8eZAMrvzqTmDO94P9sajIdWJ0cRCgI6CCob6KCBQmhk9TrBW08J06wR1GFES79ECqgrbX9ky22uZhWHx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZfJBUchs; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43cf034d4abso60913025e9.3;
        Wed, 23 Apr 2025 08:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745421675; x=1746026475; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Li+3GRicRppsnv6S7lrbfl1VCvjPKVNnD9s3Fy6S0jw=;
        b=ZfJBUchsLmhZSw8kjb5tjqYOoQtgKTmDMPNgbqWdt/klShPIOpIbfS0UKYMEYk/MOA
         J3Ws5izkymByCIpJC9T13a0Ot+U+5wj4By3fxR96FvXmdgEB+uZavXrNrjgtdTutYIdY
         FIF3+GowNvaKETZTbML8BwBiZ4oiLjwG6tGZGNVQTr3wN4FrveUPAYY/onAoSpIIFo6D
         qCdKfmmiifqKrSH99zJY/uWBGfDwf4+50R6TjnSa67X3eNcpTY00W/ry/28lXiKQA0RJ
         LZMVzGVUd6ay+BllHxps4cBrcD0rMVU6mlk526t67k5SprC9rAf+JGZ0m8GBrA09NPAg
         kY8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745421675; x=1746026475;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Li+3GRicRppsnv6S7lrbfl1VCvjPKVNnD9s3Fy6S0jw=;
        b=Gxn5iJ2aI8rKo7DW8iPdjZN79uWQbSJYY6qYyJRlxyv1xhBLY0wWCk3VZSBnbBV9eH
         50tDsvyXFkw/gonLcyH8Nw/IudDb30oLKkIfKjaedDrvDG89dqO1Ju+WBBNc22E34mrL
         xc0IwSGKwDXGqlqQAz650EVfuM/JZ8wIfuSN8ghFvg2XSBEfTSSm0GHcTsYqGMlFIzgb
         FW0ewrqQdJGAoCTO7MHkicpzExKwEtRwQ95+w9dnaE0mPwUwxRhKG/7BIpEZo+yQ9Mqx
         w6iPt8P3NQv1XenmE6qqdpXJ3pwygIURd+fkVNcIGfUQA3Z9x5ODOkAdtqEKzLNHITUH
         nduA==
X-Forwarded-Encrypted: i=1; AJvYcCU8JId/rKfrXOAk9usKVwIkyaqTr4440t3QjTo0GWH85Mzf9TzassAypbcSo6CCi6FX6v6XnMGFUEflMv8m@vger.kernel.org, AJvYcCWH7vJ2hnmBJpbW6L0iRw3UIVEzuztQlae3j5S/3M/U5gYZv3vmXMlqsOFp/H/85/lA000=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6CQsVaI4C9UYePm2M41c2wHmAxSv0B+y6OL4MLm3Y9XTjWNk3
	Z54EaUHiF5Ok4U8V1XQ3OsfFSKH4yIfN4yR3XssSF4GrCEdRj4y7MYUbQ14k
X-Gm-Gg: ASbGncubF68dsRrA2rsnXZx7XKAnrzZhLVxtcYw+NKB1d0gpXeg/JCun+zSANbby3HF
	2uFNhsizOJcTingCsxeOfGVzYH9rpzHH/Iy8UxWjUxzKqrHepCQdEaj9BImElfJ0k5LMW2nPM44
	a7fYTDFFfpKyM2C8MpaL8L7LPFbE2T2XRL5wYV1LTnEXWmBox5npRSj1tptlXpI9sf/OID9STfq
	pUCJbEXYQwMGRZg3X0F5D4fzoRx0gnihFws3/O5HSaZcOoBM47CSLLOXwLFschqZYsFdccp5TSo
	TD1FlWkQfDuMUktmRYih7K8JyfqGsimnOfcWUfnVLgxNTnjRzsZleRQ5IPIUMgMNk3m8dq7pyGR
	kBnX6NV2TmHRBwPG2mXRQvQ==
X-Google-Smtp-Source: AGHT+IENHJTw1XWaNUx/Z8DhUmtsOHouN2kWNcGXTJkXEi3Tx5xDITR7zmfelv88F8OaG9mu2r1gXw==
X-Received: by 2002:a05:600c:8716:b0:43d:745a:5a50 with SMTP id 5b1f17b1804b1-4406abb420dmr179538155e9.19.1745421674445;
        Wed, 23 Apr 2025 08:21:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:5d29:f42d:c06f:b161:cbfc:6bf0? ([2001:b07:5d29:f42d:c06f:b161:cbfc:6bf0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-44092d22f69sm28990695e9.10.2025.04.23.08.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 08:21:14 -0700 (PDT)
Message-ID: <15e24c455fb9fca05b5af504251019b905b1bd77.camel@gmail.com>
Subject: Re: [PATCH 31/67] KVM: SVM: Extract SVM specific code out of
 get_pi_vcpu_info()
From: Francesco Lavra <francescolavra.fl@gmail.com>
To: seanjc@google.com
Cc: baolu.lu@linux.intel.com, dmatlack@google.com, dwmw2@infradead.org, 
	iommu@lists.linux.dev, joao.m.martins@oracle.com, joro@8bytes.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mlevitsk@redhat.com, 
	pbonzini@redhat.com
Date: Wed, 23 Apr 2025 17:21:12 +0200
In-Reply-To: <20250404193923.1413163-32-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On 2025-04-04 at 19:38, Sean Christopherson wrote:
> @@ -876,20 +874,21 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd
> *irqfd, struct kvm *kvm,
>  	 * 3. APIC virtualization is disabled for the vcpu.
>  	 * 4. IRQ has incompatible delivery mode (SMI, INIT, etc)
>  	 */
> -	if (new && new->type =3D=3D KVM_IRQ_ROUTING_MSI &&
> -	    !get_pi_vcpu_info(kvm, new, &vcpu_info, &svm) &&
> -	    kvm_vcpu_apicv_active(&svm->vcpu)) {
> +	if (new && new && new->type =3D=3D KVM_IRQ_ROUTING_MSI &&

The `&& new` part is redundant.

