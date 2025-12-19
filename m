Return-Path: <kvm+bounces-66313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E96E5CCF06B
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 09:47:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 792BE30285CF
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 08:47:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF58B2D837B;
	Fri, 19 Dec 2025 08:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NoMqqA0L";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="uD8Xhqoc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0588F1F75A6
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 08:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766134053; cv=none; b=ehyBZKwoZyN1ic4Ee3WCukW0GkdCkgeOLZOl9+PtEjSHv5Kr+AkY6JAlk9OpKm3aQcwQSD2DPAKfwJwFxeGuOnOgSUD1cVAde6lTFmzuS+SjGawwcMkKDG9zYihD+NvU+Pw6DMSsjUGnvZoeyCZIaN8zy+89zp1Uz+UhXhqm+70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766134053; c=relaxed/simple;
	bh=UuoQMBsB9KwsiYIqm1+yrcyZ9LTCOUdJJ0zqDFIr28s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M1TWJphi3QHrt4k8LO1nh3CsBpLd5GPpLiZljiQarkPhPJnSc5RVx0ec5ddeXgiSk65wBT7Y0pYXBKkutt3PV+rH8N5Rb8wVHgWF/W8QYWAn7RjNtwrSj9F9Px15N5uAl3VQjdECxm5k8mp4vEZTdoBMXrK+Z7HRpDLmxUsfyzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NoMqqA0L; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=uD8Xhqoc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766134050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mgi1ljnMft8Woyb4i+pZ6FjM5BDFzittOUer22e9iHs=;
	b=NoMqqA0Ly3pk06S0NcxcUvDVvV4/LO/l1LY5CR9yG1ml4AgLlILnObzK1LKQj09fDs2qD7
	dFbI4/gg6rO/iTJUJKGN3Tx68tklUeS5hRKMZFg1DsUf49Xl54lzTWd0eOy3mTFuM3YlM8
	WtqUS1cx745hlWeeY3d377c5J2+8HYI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-426-4hEX6-cyPcef3GzO4EMxnQ-1; Fri, 19 Dec 2025 03:47:29 -0500
X-MC-Unique: 4hEX6-cyPcef3GzO4EMxnQ-1
X-Mimecast-MFC-AGG-ID: 4hEX6-cyPcef3GzO4EMxnQ_1766134048
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-430f4609e80so701527f8f.3
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 00:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766134048; x=1766738848; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mgi1ljnMft8Woyb4i+pZ6FjM5BDFzittOUer22e9iHs=;
        b=uD8XhqocwMm4BYxUZ46U1IBZUDD0aHgqX7F6OOsS1WOa6CE6zvTTVY3tE5CtoWSC6M
         SRAyjk2SMWMCIQIjU5nDgFVsQk/f/BfQwJkmBAd8sJCHPrj20MRtW/NgOrcMKnhbMTiT
         qvwn9ScPceFkxekaxGYbj9cL/7etGZ3tROAjhZwdWgAdBj/DL1FHpfRuq2l2MvJ3Ojlm
         i4bPjJoyc6jq0BuDd3rDOwLX6H6RVsZdb06g9hO7qY4BcZc6r9DZelVMrPdNqGpuSR7C
         MLPaMBg8YRKSbxb2MTXMh1DyNod+2+CAnxGNAmd/gziDjJJU4yaG6k5dW3y3sxWO1Vtg
         pMQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766134048; x=1766738848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Mgi1ljnMft8Woyb4i+pZ6FjM5BDFzittOUer22e9iHs=;
        b=ecwwk8mXXe7xklc0QHmNpM5Q65mdYvk6J8uJ0EQBcV9R8vUYKTWySSi6SjivTJafST
         5YilcIdfZvcJbr1/9JaQ7vbzP5KwKdx9au0q9iTleYSvKYpgGsVvO+/WPrp3jIbh/pxN
         bdtsEEnWmY/3lEQ6Z0UtkMwBLe+DetgAuUjWkocHcod4pf+OGKSS0vtS6YBa0jD7QWTT
         VddJm4xiMv4+H0+E0cqsk3xeazan3AZkjYT72OTW1XLYy7n97rx5cQReEDKEdSl2OGDV
         QTMUs0s5KZmJm8NukiuLOmeo04ot+SqALcoRlrf3ZQnKfAFCijFfZn/gNRk1wjPoSnsE
         RLJA==
X-Forwarded-Encrypted: i=1; AJvYcCWH5JXtP6g9LxRZw8jA7fj3fxcfKr0Tt39f1JzM0qHYwP1qY+gL+P2MGdvHUiJ6TaFuDf0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6vceCxccdd6PST1ZnUUx/tAUFOWU8SQuN/hSI1TPPqVsYZ4pN
	GLgYsWL8fYoCoChFzvS6lFpGdY4wGlWcdApA5Jo7t7oqPMsgVQxMk1WnXAr8VJIJew5fWc6IVMs
	s6FvpZh4aIkSvT6CKmmTlt+88YUNuYvxkc5d5sLPyC72C/lQWj8MFcQ==
X-Gm-Gg: AY/fxX79vdB5ty3U2BQKVX6ww34V4Rt9sjttICQjtBfA1RoT6qXzckFLdH8qnWtQTZ7
	rbo2ooa8g4krQUZttPtaJE95HuOGOob9LwNUzM5KW3xF/emFiWOaQYXypKtF7jdvTsgWw01Iy0k
	mGT3WKnpajCg4WkP/THZ++PaLamZ5c1qOJ9UQRAJ2CTqYSFkMBM6lyJ5jCGDojL3hLaFVgBwe2/
	HAUII/NQ3i6C9j6/9vwQWGf8VOC73yJTolSpVRZPpytmBCCE+clh3ufVkPZZev+LumryT3/HdCJ
	JD2NPRgEVGVEpmRp6gM09BWtOMYP6751u7/Iymrf/Paq7ny6qfLkt9GgMbVIXwMhToy9sA==
X-Received: by 2002:a05:6000:25c2:b0:430:fc63:8c0 with SMTP id ffacd0b85a97d-4324e4c9d5dmr2163437f8f.22.1766134048259;
        Fri, 19 Dec 2025 00:47:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGofWmp5nks1CsuTO5gfaDwPulkVUlLa2aYaxOaunUCaP9TRE4TyL4Ari0miMoDkufzeFIFPg==
X-Received: by 2002:a05:6000:25c2:b0:430:fc63:8c0 with SMTP id ffacd0b85a97d-4324e4c9d5dmr2163413f8f.22.1766134047865;
        Fri, 19 Dec 2025 00:47:27 -0800 (PST)
Received: from imammedo ([213.175.37.14])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea1aef7sm3718542f8f.7.2025.12.19.00.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 00:47:27 -0800 (PST)
Date: Fri, 19 Dec 2025 09:47:26 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, Peter Xu
 <peterx@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] x86/cstart: Delete "local" version of
 save_id() to fix x2APIC SMP bug
Message-ID: <20251219094726.5f970468@imammedo>
In-Reply-To: <20251218232618.2504147-1-seanjc@google.com>
References: <20251218232618.2504147-1-seanjc@google.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 Dec 2025 15:26:18 -0800
Sean Christopherson <seanjc@google.com> wrote:

> Delete cstart.S's version of save_id() to play nice with 32-bit SMP tests
> on CPUs that support x2APIC.  The local version assumes xAPIC mode and so
> depending on the underlying "hardware" (e.g. AVIC vs. APICv vs. emulated,
> and with or without KVM_X86_QUIRK_LAPIC_MMIO_HOLE), may mark the wrong CPU
> as being online.
> 
> Fixes: 0991c0ea ("x86: fix APs with APIC ID more that 255 not showing in id_map")
> Cc: Igor Mammedov <imammedo@redhat.com>
> Cc: Peter Xu <peterx@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Acked-by: Igor Mammedov <imammedo@redhat.com>

> ---
>  x86/cstart.S | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/x86/cstart.S b/x86/cstart.S
> index dafb330d..49ba4818 100644
> --- a/x86/cstart.S
> +++ b/x86/cstart.S
> @@ -84,13 +84,6 @@ prepare_32:
>  
>  smp_stacktop:	.long stacktop - per_cpu_size
>  
> -save_id:
> -	movl $(APIC_DEFAULT_PHYS_BASE + APIC_ID), %eax
> -	movl (%eax), %eax
> -	shrl $24, %eax
> -	lock btsl %eax, online_cpus
> -	retl
> -
>  ap_start32:
>  	setup_segments
>  	mov $-per_cpu_size, %esp
> 
> base-commit: 31d91f5c9b7546471b729491664b05c933d64a7a


