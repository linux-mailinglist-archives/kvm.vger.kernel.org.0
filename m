Return-Path: <kvm+bounces-60095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 39AC2BE0022
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 20:10:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A77C11882A89
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 18:10:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D51CC30103D;
	Wed, 15 Oct 2025 18:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DzkIzk+E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B290886342
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 18:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760551822; cv=none; b=csD4uBUGbgr2uAD9KHpeoTQWbAGPzRxUXoDZ01KZT3XnbA1URKlCa6mZt9USosdrt9Y9AgG4YMc4U9OSixZY/Wpj+raxRIHBpD3V6D88bDcSLrGLsVaU5mPnOdmzQdzU8MC+wHRa79HbH+7B5gTRtxBPnNl3Q1Df7kI1Wc/xZ2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760551822; c=relaxed/simple;
	bh=Jq7eXp8fib1FIP6eeCceInS/a/aZXhfZhn0wG7S3u/Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dvsYihXNUAG1mzIaxVTvbKwrm9Joy+V0d6pq1Qh/u7grRu6eN92NIahurlkAHXTxlyV1+yT7hFClPXPJfMF+/IJhZeTkyTgRAZJNJp4btcUoFBoMYFZ8aaGwX2LM3rxhdtEwLJGGziUpoVX1aQCXaskE+KZbeA6VVgkcNbqfEhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DzkIzk+E; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eddb7e714so9493778a91.1
        for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 11:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760551820; x=1761156620; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A7VWrlGpJstNEPnOR+6vF9r6jJA3jjpAi47oFTgwahw=;
        b=DzkIzk+E9963cOfDLUa44fVKBGTVBctH6SF+qeYVLGEmPuAdU3eS/401I36+32POL1
         FQIfZpmzBYffluVGnvNCW5nUFoQer3rlUUI5LfDaExkN1pf8qxoEZanjp3EeipqpzOrp
         EMWh7PzB18WkNElIYVvb9+dRj+uGcdDki1k3a2NAi1/ZFZ1Awvg1V2WjWSX+OfrNlZDc
         1ZWkPKdN4ainLvBZI9eldvxtsjWKDFdhx1hwe899U7JjLvuTCqXSbeivxjgYB1IZFviK
         P+dRQeZs/IVfibjDvF/bfBgW0Z4Ry6CPutDRepfg3MFDb9ZKQrzyWRByuSySkcEW0J2Z
         8w7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760551820; x=1761156620;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A7VWrlGpJstNEPnOR+6vF9r6jJA3jjpAi47oFTgwahw=;
        b=F551eVh055Ew1zG1AZZiY1y9e1mGt3/HDtioVvdf+6jMP5rk57AAprpksmLEI4euzh
         ZworfTDTegriOH9WUMzfBUKSnQHNzVNCJf8iURwPML6Lylx3ucTx4LEXHAbAZ2LJ4rg9
         VIXRG2ZcjvJkPLUinr/vbVgx7ey5JlIDz4fQP9hsWGorNT1Li0jRddUS68KC1amRUcoh
         fuMNfAvbXAxmVIwKH4h6/9A0M5MLI4iBFKI/aXtcylrb0fYvjwrfnTZLC7jlGqbFBZ6/
         lRnmxRky3fPWH18fVRjhMea/Rj6qR9EoA9FcRn1JTZbpUxF0qlqbEY8c382MmXaasp+0
         +09g==
X-Forwarded-Encrypted: i=1; AJvYcCUWF4fK0TWJCRcrLwrLpcfzeZfE1AS2rm46sB21FYgvLAMHR+42Iuz13uVclIAUxcaGEnA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yztbp8Lc3SCbFblUEQEX5Vt3tlpqUDTdJkDolLat1Wif+YjNyfR
	zf9YskpXU4e4ecd0sbCVxQWgOQcllrEMhNYjI3lIwAk6rxPzVfK9OdEGC3U5Ch/dTIVlGqLfXc2
	BspQ2tw==
X-Google-Smtp-Source: AGHT+IFmybnsEOrIWbHshrhKc7Un8LMYT9HibOiZ3oGXQOVv28zVE4H0/7+CB4wu6CGtwBvzjybc6kehs9s=
X-Received: from pjbse5.prod.google.com ([2002:a17:90b:5185:b0:33b:51fe:1a88])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b81:b0:33b:6ef4:c904
 with SMTP id 98e67ed59e1d1-33b6ef4cbbcmr18963431a91.20.1760551819966; Wed, 15
 Oct 2025 11:10:19 -0700 (PDT)
Date: Wed, 15 Oct 2025 11:02:58 -0700
In-Reply-To: <20250924145421.2046822-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250924145421.2046822-1-xin@zytor.com>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
Message-ID: <176055120017.1529012.10789026388840299534.b4-ty@google.com>
Subject: Re: [PATCH v1] KVM: nVMX: Use vcpu instead of vmx->vcpu when vcpu is available
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	"Xin Li (Intel)" <xin@zytor.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="utf-8"

On Wed, 24 Sep 2025 07:54:21 -0700, Xin Li (Intel) wrote:
> Prefer using vcpu directly when available, instead of accessing it
> through vmx->vcpu.

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: nVMX: Use vcpu instead of vmx->vcpu when vcpu is available
      https://github.com/kvm-x86/linux/commit/f505c7b16fbe

--
https://github.com/kvm-x86/linux/tree/next

