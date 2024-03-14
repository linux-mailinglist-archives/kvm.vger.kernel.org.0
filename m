Return-Path: <kvm+bounces-11828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FF4787C43C
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 21:24:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2027EB21616
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 20:24:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B7F976054;
	Thu, 14 Mar 2024 20:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HFM++K7D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400667317E
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 20:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710447878; cv=none; b=cYItYlP8QJcOKnvG2OCN03AIzi7anLCp33QLklU/dsAcUDnebxC0dPpRmuvB9cN0aFC+0ufSby9js3FASJ2ExHzUq8O1VJuOUoWc5EBZSAFOZbJjmocM9CGT96clcpvr9WdNAlYKbI3IZBu7c9N/KxezVIb3zZq4MgjGaShU8Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710447878; c=relaxed/simple;
	bh=dGbffwfi9F8o5vKXOK784z8lOxK3B61CBLe05LF4uDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i/v1Omr1/vKvRUxhr8WPzvj34R5p57GqFNWWaMKzZSHGAvpRIvX4SgS36rUbnw4PQtgUT0BfGPqOUlbN+VSOdkbjajDmbww2/62wi1//cWoj7MeGaARkA/HzAxcRv6s002Qka4tZjBmd8+wsoftfez25YhFasTEZUgQSPUlnm7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HFM++K7D; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a466f6318e9so156636066b.0
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 13:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710447875; x=1711052675; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KeVadU2hZeC83X7EyIxA1rm2PDaUR9fvRb0RDycrigU=;
        b=HFM++K7DS9n3auHGlSq0b/iJ4dzTd9XK+5FpDgDikFfs+DNzZr/T6LTlEcMWB5bmTk
         MmiIUieOyAnY3UPQFT7XzoHsKrHUQpNvbkkGGsB0SW3hc1kHzbGqKb2VUr94sUkHHziN
         K7nUaSCDLnJOWKTPV4XQUlVxtY/phbZHbM1MkPxfpZEnD+Uuj4nYROHKXcic+42z3Lwj
         svtHNdPfVx269uSjQg/+1DVKMWebjxU7NB6LgaSCPbhl0PfXsPwkyWkIZ2RL1azVNNF7
         dgcZw+akvFuCzEYwoJfvws4qEPZH5BN0qdg+A+JdCw8trHxQ9jBpis16s4fOGi1U5++Y
         d+GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710447875; x=1711052675;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KeVadU2hZeC83X7EyIxA1rm2PDaUR9fvRb0RDycrigU=;
        b=DQj57DKJuPN0Kjp5IncSawxzTUGMsUfyg1z3CrL0WMUIvVJXH1XUOB2e0z0Xr6So32
         pyXiRijGM5800o/Qa/5LBTvpWtxX+pBQ/HO6TIY3v+hLU+/f0EQcFknXlh+hBU+Oflkz
         lNkVy/Hc0mSMe76DhEypy0/PsoNqj01wTR1FlI7pQuAzQDGVAcv107ToV+X2lve6Y5L+
         JRbtxyD+FxfHvPFgIrMrhVtfaYorxvQ6pFe4nTO8QOqvZVhsQ/He6298Wm/0ZXVMKhPQ
         pgPQa14vKW+Uu4vmLmBT1tqLNN4stTupKdNJ9eRqLLMgNd5uDRqTirK7KX2N7RcXKGYv
         59lw==
X-Forwarded-Encrypted: i=1; AJvYcCUkC1mNLh2wONQe8OXDf/dQfXnXG40AerOxRm2wGoqvzCYkcCUYWuPaSAmmFKUud1qG7MkYojETkgfVkAlyLnaey7RE
X-Gm-Message-State: AOJu0YzHdABug41mnj9/HlWQh1uYijrm/yWau2wPam5AHj9b2I2Bx8iZ
	VlrKkAN6kNO7GshlcyDmLGGyVvSGPkHG8yqVcFXiFYWT7P8W4uz/2TrU+EG9kA==
X-Google-Smtp-Source: AGHT+IHucnNpHcGZETVpGOJfR1+fsfUsDKCT0Rc1DvLZfkdGAS5fojQQqY/5p5KP8nfAh80FDRV5yA==
X-Received: by 2002:a17:906:bc56:b0:a46:5e38:29d7 with SMTP id s22-20020a170906bc5600b00a465e3829d7mr1861511ejv.10.1710447875391;
        Thu, 14 Mar 2024 13:24:35 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id vi2-20020a170907d40200b00a45c8b6e965sm1012429ejc.3.2024.03.14.13.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 13:24:35 -0700 (PDT)
Date: Thu, 14 Mar 2024 20:24:31 +0000
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 05/10] KVM: arm64: nVHE: Add EL2 sync exception handler
Message-ID: <cebafe40b170589d52e2ef66f3bfac7396fa1f56.1710446682.git.ptosi@google.com>
References: <cover.1710446682.git.ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1710446682.git.ptosi@google.com>

Introduce handlers for EL2{t,h} synchronous exceptions distinct from
handlers for other "invalid" exceptions when running with the nVHE host
vector. This will allow a future patch to handle CFI (synchronous)
errors without affecting other classes of exceptions.

Remove superfluous SP overflow check from the non-synchronous handlers.

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/nvhe/host.S | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 27c989c4976d..1b9111c2b480 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -183,7 +183,7 @@ SYM_FUNC_END(__host_hvc)
 .endif
 .endm
 
-.macro invalid_host_el2_vect
+.macro host_el2_sync_vect
 	.align 7
 
 	/*
@@ -221,6 +221,11 @@ SYM_FUNC_END(__host_hvc)
 	b	__hyp_do_panic
 .endm
 
+.macro invalid_host_el2_vect
+	.align 7
+	b	__hyp_panic
+.endm
+
 /*
  * The host vector does not use an ESB instruction in order to avoid consuming
  * SErrors that should only be consumed by the host. Guest entry is deferred by
@@ -233,12 +238,12 @@ SYM_FUNC_END(__host_hvc)
  */
 	.align 11
 SYM_CODE_START(__kvm_hyp_host_vector)
-	invalid_host_el2_vect			// Synchronous EL2t
+	host_el2_sync_vect			// Synchronous EL2t
 	invalid_host_el2_vect			// IRQ EL2t
 	invalid_host_el2_vect			// FIQ EL2t
 	invalid_host_el2_vect			// Error EL2t
 
-	invalid_host_el2_vect			// Synchronous EL2h
+	host_el2_sync_vect			// Synchronous EL2h
 	invalid_host_el2_vect			// IRQ EL2h
 	invalid_host_el2_vect			// FIQ EL2h
 	invalid_host_el2_vect			// Error EL2h

-- 
Pierre

