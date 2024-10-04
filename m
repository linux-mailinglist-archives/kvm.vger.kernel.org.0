Return-Path: <kvm+bounces-27898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 881C198FF44
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 11:04:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B73691C21A25
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 09:04:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3988146A63;
	Fri,  4 Oct 2024 09:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YEZ8+xlv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E58145A07
	for <kvm@vger.kernel.org>; Fri,  4 Oct 2024 09:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728032661; cv=none; b=c3WhfdSQ5ajpjezE+HGOp/5C/AEhlnbKtcwm4DlsmdQdADaCJJ5lMz7bA0Nw2fZlXqVdnOhfc1vBZfh1d41xST3wb8Yo8CbW2RuwA8/9LgGkpNyCCw2YtHTIHrwqaSxdX5uIKVl4rkvqKZKzGpCeAg5O93sHsruGP1ZeFhDTZFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728032661; c=relaxed/simple;
	bh=ZnnyuXNFVICI+SzzG8WbBqu6A9lH+PhQvaNki3KNcEI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Yg23ROk8+S++tl5aYQMpIEpRjFniSc6iSj00rMJdQSt2wCSwcw9WBFF65NjC5tzKGqEhXPDkHRorn4cljk92W593NIAXgtL8oC59ywaWa8LeXY9snWuHiP3E1NSsKTe8kFw05yPe6OOIEXhtyxuMlo0o51+DsABlqrvaF4Bs9Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YEZ8+xlv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728032657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pm6ndtAn1q8+idFufOTXT4a/EfTyQS3zONVFfujpzYE=;
	b=YEZ8+xlvpVsiObVgmyYL/X3z2cvrdfiVlwRDoVp88gcaoHB6MLjPTDxP0bMWUzdId+Xj9T
	S85tvqoAX1uyEirVQOA2WQS8rw4TwPkK/poLH3j3lKa5NH//6nZqfHZT+0HNyxY0g3FBbJ
	eBaTkJFkGJq/WuzRfBbycQcw6KGhS10=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-19-i1ymEBDVMKSwAQ9lp0gXQA-1; Fri, 04 Oct 2024 05:04:14 -0400
X-MC-Unique: i1ymEBDVMKSwAQ9lp0gXQA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-37cdd84aa87so1296615f8f.1
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2024 02:04:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728032653; x=1728637453;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pm6ndtAn1q8+idFufOTXT4a/EfTyQS3zONVFfujpzYE=;
        b=wxNs50g5mZHn9FYUbcvLuANe7dZ57pInzCAnw30j3zLgyn51RgLlK+PY0/n0d/f0Sm
         JCgGB+mKmRkdE/d18OsRqLvZD7F/+HmdKmj9nVB+wrGzgRVo5ENsIFYVuJyi+2zEaQqC
         rihd6597Mb9vjUCB4qpKoEmStaO65Wznh5AryQoc33ZwLnKWeMBwyxaCmEPceKUS2fLq
         Hd7Hwpwj6/Oup1vWIeLHYzcYANvgOhMhuaYr4Y9mxFvHdANFSsyPBHobVF3jaBjsz23h
         t1TWL1SCgi5KxkOVLWl2JIaJOAlAElkiqIP0IjfnSyiwqv7Sh8mEwh78wSu4RS20QMBT
         8W9Q==
X-Gm-Message-State: AOJu0YyyN9iYGUesPlH1/MTT7AfzlnFX5zWKM1E6GloKnLEM2TVnENks
	pl8TCb49AhmWS5xrKr8OzQBoin217iHsRfEdSGXx3IrQYSZKmf05RUJIghz3ETwR0XpxL/k1Erg
	15qrFMuBLmjMnDgME6ZQTBDeqV0MGlfVI5Zo653tfI2aMwE5gGQ==
X-Received: by 2002:a5d:59a2:0:b0:374:bb1b:d8a1 with SMTP id ffacd0b85a97d-37d0e746f3cmr1415463f8f.13.1728032652899;
        Fri, 04 Oct 2024 02:04:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHfG1MFeWmhwXUn9wRJSt39ET0vsHHWNvNq9ie+ynt77MAK8P20ZOwDvzMFKZTuF3rhJrk1Fw==
X-Received: by 2002:a5d:59a2:0:b0:374:bb1b:d8a1 with SMTP id ffacd0b85a97d-37d0e746f3cmr1415441f8f.13.1728032652515;
        Fri, 04 Oct 2024 02:04:12 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d082e6ecbsm2829776f8f.116.2024.10.04.02.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2024 02:04:12 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] KVM: selftests: Verify XCR0 can be "downgraded"
 and "upgraded"
In-Reply-To: <20241003234337.273364-7-seanjc@google.com>
References: <20241003234337.273364-1-seanjc@google.com>
 <20241003234337.273364-7-seanjc@google.com>
Date: Fri, 04 Oct 2024 11:04:11 +0200
Message-ID: <87o740i6ic.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> Now that KVM selftests enable all supported XCR0 features by default, add
> a testcase to the XCR0 vs. CPUID test to verify that the guest can disable
> everything except the legacy FPU in XCR0, and then re-enable the full
> feature set, which is kinda sorta what the test did before XCR0 was setup
> by default.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
> index a4aecdc77da5..c8a5c5e51661 100644
> --- a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
> @@ -79,6 +79,11 @@ static void guest_code(void)
>  	ASSERT_ALL_OR_NONE_XFEATURE(supported_xcr0,
>  				    XFEATURE_MASK_XTILE);
>  
> +	vector = xsetbv_safe(0, XFEATURE_MASK_FP);
> +	__GUEST_ASSERT(!vector,
> +		       "Expected success on XSETBV(FP), got vector '0x%x'",
> +		       vector);
> +
>  	vector = xsetbv_safe(0, supported_xcr0);
>  	__GUEST_ASSERT(!vector,
>  		       "Expected success on XSETBV(0x%lx), got vector '0x%x'",

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


