Return-Path: <kvm+bounces-66921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 62FDBCEE1D2
	for <lists+kvm@lfdr.de>; Fri, 02 Jan 2026 10:59:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 515C33010990
	for <lists+kvm@lfdr.de>; Fri,  2 Jan 2026 09:59:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C4FD2D8393;
	Fri,  2 Jan 2026 09:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pn+lg3Oj";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="lLEsGTuY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03812D24A0
	for <kvm@vger.kernel.org>; Fri,  2 Jan 2026 09:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767347950; cv=none; b=bVR9Y6hi6S9pYe9RIlUa0s70ZkLPpPl4cfXMppB5iWShm0fPQNOITZPzbKG9qIRzIwee1eTAS4UCSkBz5lg19p2HnR6nWHHSGg9kY3FqJlQdz7+O7gB17/DK6lSREpur8Km67xrVUYtp5hqxaIqv0Qh35bZyFN98DMwotpmhxV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767347950; c=relaxed/simple;
	bh=xwN5SJgpKv5d/dw9zKfPpCMUcx2M/mX4rbiBa7U8+Ns=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=HH1/r+W6nQh4SgHubbzht4aBgy+CFHWYm6pDb6qQXMc6tpmlD1nd38f9G6Do+L1DYYq3Vr3lYCaarHZvH1gZ1BsQqzrkMxTsDrpV6DN4+TOVF5m2L3mKqPkOL+cGaDW0PY3nP4+Ko9UYd/6eTL4hfQ8HKhplN0zIl5Bfgo3wPYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pn+lg3Oj; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=lLEsGTuY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767347946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PUxS4f8mPvClX+DwiPHnFyp+SWqUM3DkFf5Rfhn2JeY=;
	b=Pn+lg3OjevG037qfDADhk0/Zv/gtSg1MxC4Nnv5rsKreksaO4c9lI4xfKoPpVKNXJjVt+G
	1u67Q8tHzZh9wUuJG79vQv6KSiM0ZgF+LCY+D0j/P6WYfwxksfYWVRkktCh5zH6lkft2o/
	5Ouj65JKUQkzCfZ0pm65RONnpFD2d3A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-IuzVANp6ORuX5auCesDKEQ-1; Fri, 02 Jan 2026 04:59:03 -0500
X-MC-Unique: IuzVANp6ORuX5auCesDKEQ-1
X-Mimecast-MFC-AGG-ID: IuzVANp6ORuX5auCesDKEQ_1767347942
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-430f5dcd4d3so6496495f8f.1
        for <kvm@vger.kernel.org>; Fri, 02 Jan 2026 01:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767347942; x=1767952742; darn=vger.kernel.org;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=PUxS4f8mPvClX+DwiPHnFyp+SWqUM3DkFf5Rfhn2JeY=;
        b=lLEsGTuY8U/CWI/26HlcDFTaNpeLJUNCGkYyXSlhQ8hbSDR3vKmqoQCIu3wIF0/cDq
         2xZfnRLBFQsrAdcm8Z8SpWCuIGUwB2qIfmZ5FG+/xQVVtQT0YTKbj2wjrkhYC6H0TFIv
         s0yV+cmoB3IzlobwMb3hX5QiTzD3rVqTMaGDo/77LWodWmieepLR5pE7pQ95EeX9EVCZ
         e1AXxGhayydsfZDfFRPGwvKj8OwaI0KxULEMh0nfPJtxA4paQusEOkiSqOy46QGoNkDY
         2UH3U5ACx80VsEx4OBAIgS+60ILP7RUO0vF6cS2QD3Z6w3CBJ3B42canI77tC1aKK7A7
         CNEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767347942; x=1767952742;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PUxS4f8mPvClX+DwiPHnFyp+SWqUM3DkFf5Rfhn2JeY=;
        b=QRgDXSpXba76sJobG2/K6PmhzZITuUH0mJEiTNVNtY6LEE25O//IOTce/8IIGyNhgh
         oOq13Rh/za3vortmspzxve8ucLJZQNhV3Pqh/2f744/W/zX0ldLNdLlG23fMJrNz6I4t
         DtzqQBBuQ8OPYLkDr88P9ut0g4aUVXNBzVxiFjgD4zZLTvyZGFX7XKM6QXHm3iA3ck+e
         ea8/ohnPNBv0hE8g6YsIuRi8VZ8hKAG8kzZfx8qr5W8musNq1l9HmErKn63ZOa6jMk1d
         Qv4Y/yQLdkGXMRYDL9Ev0W1s5OlA5o95GY2oLeJxCi3dB+GZ82ONUx4Rt5WOdzAv2mdA
         zheA==
X-Gm-Message-State: AOJu0Yy/URmSl+MG/IEdEedGRe4C1IfgJw98tN2azucNlaBOFBlfggkS
	BtQ6MdhZBdg9W1CLdqBtREmx6GA1aadEuks2JYHCoFYVcsDLr9risQ+dHoXSHAmbDJ2ayWTaqcg
	HJZYZ4YT+9cHHl7na+gVpqYS2dgf6kxPALx4Gw1iWiw52XoEl61Vx9A==
X-Gm-Gg: AY/fxX7utrGk0YcGk2op/MjCmMxioUWPoaNr/6ANGJjfqbRKdXO1r8PVIoajU9tiKdT
	eUlrKDJOzTDVnnJDVhFMSoISy0Nxi7fi4cmhVvaEk+7XaICloi7TD2BlFii5oMUTqddaKQ2Yemf
	010i3NgOMOScUQB9abBkJs890ZAKcQePFReylNrY4tTw4WHUE1FmtQqhD3McQPczt/vvjRQQpJb
	IjLuqqxWPDvV681DvKb4tbPtUtSQoft4N54Oi76yml0xxHoDHXFH7d7sUC8nIG/6lfZiFRheMwD
	NUZldMo7t7OeW3a29U7C5Cq/hpq49FDPG2dLV1ypsVlX2s1o/aEmBjZbeSqQ6R+wLzCFKyL7qZI
	egvhwcg==
X-Received: by 2002:a05:6000:1052:b0:432:84f0:9683 with SMTP id ffacd0b85a97d-43284f0971dmr22484617f8f.24.1767347942190;
        Fri, 02 Jan 2026 01:59:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHXb22RGg1w4fy3z8I/bvF7q1MbAh1dJe/WDLMVTEQmMTtkYSsT5t/aZbCWXfL696OPjB6p8w==
X-Received: by 2002:a05:6000:1052:b0:432:84f0:9683 with SMTP id ffacd0b85a97d-43284f0971dmr22484602f8f.24.1767347941743;
        Fri, 02 Jan 2026 01:59:01 -0800 (PST)
Received: from fedora (g3.ign.cz. [91.219.240.17])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea1b1b1sm83175299f8f.3.2026.01.02.01.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jan 2026 01:59:01 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang
 Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui
 <decui@microsoft.com>, Long Li <longli@microsoft.com>
Cc: kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>, Yosry
 Ahmed <yosry.ahmed@linux.dev>
Subject: Re: [PATCH v2 8/8] KVM: SVM: Assert that Hyper-V's
 HV_SVM_EXITCODE_ENL == SVM_EXIT_SW
In-Reply-To: <20251230211347.4099600-9-seanjc@google.com>
References: <20251230211347.4099600-1-seanjc@google.com>
 <20251230211347.4099600-9-seanjc@google.com>
Date: Fri, 02 Jan 2026 10:58:59 +0100
Message-ID: <87eco8bajg.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> Add a build-time assertiont that Hyper-V's "enlightened" exit code is that,
> same as the AMD-defined "Reserved for Host" exit code, mostly to help
> readers connect the dots and understand why synthesizing a software-defined
> exit code is safe/ok.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/hyperv.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/arch/x86/kvm/svm/hyperv.c b/arch/x86/kvm/svm/hyperv.c
> index 3ec580d687f5..4f24dcb45116 100644
> --- a/arch/x86/kvm/svm/hyperv.c
> +++ b/arch/x86/kvm/svm/hyperv.c
> @@ -10,6 +10,12 @@ void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> +	/*
> +	 * The exit code used by Hyper-V for software-defined exits is reserved
> +	 * by AMD specifically for such use cases.
> +	 */
> +	BUILD_BUG_ON(HV_SVM_EXITCODE_ENL != SVM_EXIT_SW);
> +
>  	svm->vmcb->control.exit_code = HV_SVM_EXITCODE_ENL;
>  	svm->vmcb->control.exit_info_1 = HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH;
>  	svm->vmcb->control.exit_info_2 = 0;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Alternatively (or additionally?) to BUG_ON, I guess we could've

#define HV_SVM_EXITCODE_ENL SVM_EXIT_SW 

unless including SVM's headers into include/hyperv/hvgdk.h is too big of
a mess.

-- 
Vitaly


