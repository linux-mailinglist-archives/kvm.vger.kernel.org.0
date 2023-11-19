Return-Path: <kvm+bounces-2018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED8837F081C
	for <lists+kvm@lfdr.de>; Sun, 19 Nov 2023 18:33:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2878D1C208F7
	for <lists+kvm@lfdr.de>; Sun, 19 Nov 2023 17:33:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69F051946B;
	Sun, 19 Nov 2023 17:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SDYGI/V2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C506E186
	for <kvm@vger.kernel.org>; Sun, 19 Nov 2023 09:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700415198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BJ5/P1hMR2md3N3SnJ8/RD2V4pYxtTfoSa35OnUgrmE=;
	b=SDYGI/V2tUKsbQQLzem5WeVZuMMO4ei6o20JUCacib/c5jvqohLt3MPX0tG07wobuYYN6G
	Dl/+eIRnTmJiTpv9vxaGbITI6BzI8qdgJLgMsSDlfRexxL3ZSejJ9akUSA9huq7c4y8t6l
	gbQcbTZWkqPLK/PIzTrHsbJ7bVi0rM0=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-1FC7fkkgNM2y_iZGMoCiTw-1; Sun, 19 Nov 2023 12:33:16 -0500
X-MC-Unique: 1FC7fkkgNM2y_iZGMoCiTw-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-50aa9aee5f9so853123e87.3
        for <kvm@vger.kernel.org>; Sun, 19 Nov 2023 09:33:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700415195; x=1701019995;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BJ5/P1hMR2md3N3SnJ8/RD2V4pYxtTfoSa35OnUgrmE=;
        b=F2S1OrIfcnrE6k/fk4jpRos4ikoKDUBrFJPoMLUenY917RrTiFKc3WeRpiDuA8yZwS
         uNKwCtpUKlv+yTejnIz0Jx3oDYdG3Ib/QZsjD9qFeYnXSRANLrzAb4I8nwlB6G9Rekgq
         ShOou2igZFvHidwzgcYKfdj8qvVpcdPvnjtQCO3eDaxqOFCfkEOQoJ6wQGDBHUR3+PU5
         ax+LZXrOc8XLX1WuxJwSsOrpnYjGF1ZcqMVTd5NWOCHt5qngWuDIbBpAimYpbVPD6HVj
         buP/wfhPjRm5kI9z1QQFB8R40Xh8DwnON7k6g/mbeef2xLm9hr3/XDldI/QdRQmzPs2h
         bHZg==
X-Gm-Message-State: AOJu0YyFUIRCqwrdQ+xKj17htOh05IQjnZVPjqR07xD5otS8IXi+rKH0
	LKWippiL3P13PEjVx/5c4zNKAtYGdc+uOuKzwnN/thaqIjSRgrpt8C61xqOSK++YB/jyJ8g8M8+
	sYX9ppL3ghb2P
X-Received: by 2002:a05:6512:5ce:b0:50a:40b6:2d32 with SMTP id o14-20020a05651205ce00b0050a40b62d32mr3359406lfo.54.1700415195088;
        Sun, 19 Nov 2023 09:33:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEZ1GRryURuL0SD5yTRUtiL11CZ0hD0YLCJ927i0Y7aWv6qoa6xLN8QeyBVV2cFreruPfklyA==
X-Received: by 2002:a05:6512:5ce:b0:50a:40b6:2d32 with SMTP id o14-20020a05651205ce00b0050a40b62d32mr3359399lfo.54.1700415194821;
        Sun, 19 Nov 2023 09:33:14 -0800 (PST)
Received: from starship ([77.137.131.4])
        by smtp.gmail.com with ESMTPSA id d16-20020adffbd0000000b003313902cef5sm8556911wrs.93.2023.11.19.09.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Nov 2023 09:33:14 -0800 (PST)
Message-ID: <5adae6067e0d05a4421616f9153bc865cd200a15.camel@redhat.com>
Subject: Re: [PATCH 5/9] KVM: x86: Drop unnecessary check that
 cpuid_entry2_find() returns right leaf
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 19 Nov 2023 19:33:11 +0200
In-Reply-To: <20231110235528.1561679-6-seanjc@google.com>
References: <20231110235528.1561679-1-seanjc@google.com>
	 <20231110235528.1561679-6-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2023-11-10 at 15:55 -0800, Sean Christopherson wrote:
> Drop an unnecessary check that cpuid_entry2_find() returns the correct
> leaf when getting CPUID.0x7.0x0 to update X86_FEATURE_OSPKE, as
> cpuid_entry2_find() never returns an entry for the wrong function.  And
> not that it matters, but cpuid_entry2_find() will always return a precise
> match for CPUID.0x7.0x0 since the index is significant.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 6777780be6ae..36bd04030989 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -284,7 +284,7 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
>  	}
>  
>  	best = cpuid_entry2_find(entries, nent, 7, 0);
> -	if (best && boot_cpu_has(X86_FEATURE_PKU) && best->function == 0x7)
> +	if (best && boot_cpu_has(X86_FEATURE_PKU))
>  		cpuid_entry_change(best, X86_FEATURE_OSPKE,
>  				   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
>  

Makes sense.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


