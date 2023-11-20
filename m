Return-Path: <kvm+bounces-2061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A8C177F124E
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 12:41:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69C8A1F23A30
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 11:41:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F8E318025;
	Mon, 20 Nov 2023 11:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ewkzzpWi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFAD5A2
	for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 03:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700480492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=swE9wxIOeeL1PspQs0232ldIEtHI+X7hXeMJbKKzyGw=;
	b=ewkzzpWiL/EEaBIu9IzUNJOY9FDEzMTsaLqd95CcvfWcjCuswD98DHnhYEy/y0Y41IKamN
	rYQIZ1s0FTCydDKmKa10NCrxOKh4EonIIhvKDJnjSmVnD0jIQLP19NJRFjcWX8KmG3BETN
	p19bLmdBN5808Cg24/hO/b9tRewsLxk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-mQYIng1xNxGdYoI_AUetgw-1; Mon, 20 Nov 2023 06:41:30 -0500
X-MC-Unique: mQYIng1xNxGdYoI_AUetgw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-32f8cb825c5so2135965f8f.2
        for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 03:41:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700480489; x=1701085289;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=swE9wxIOeeL1PspQs0232ldIEtHI+X7hXeMJbKKzyGw=;
        b=TmJPg8SKgw+823dzgvT8lUcJR/C7UvYPYskEizbxxWQ/+9ORTllEuY0wCsJOZ+Zon8
         Q/2viYETAAZpaP2y5i5BIMVpHtJS7KpjZZPJ7+iFVsTxyNBk8Zl+qZAI/iAQ0zfFLfl/
         LWMgsNjBjY4xY1kHJ5RiA5X/fpPfIda6WXjy/NWqZDnWwG5nkkR79AaR7drMZIXe3gKK
         ObNJYO/lpcYBzbOqDkmArIEydii5tx1yRgYuNm9g2PHgQCP6s8dkvLnE0vztbk1ZYPxS
         5TjGHb0Am8oaXgBGSTf+0M5ov3cTAzKwXwq0WDA80mcqVhxhO9lCSRWSUmml36Zi969J
         EcVw==
X-Gm-Message-State: AOJu0YziMy7UEu4+6o9MXLDREc8PcLl5aG2ezxjuPquqpIevWeEKwMiH
	9/o+O90V8EMMGt4uUxWVrCDhYh/xazUL2vr6ZNlQKAzM8z3MMk3aA8vjerXBoQJcS30DHNkKafQ
	OOWT+R8QHMcxuChGp4j/R
X-Received: by 2002:adf:f2c6:0:b0:32f:7a65:da64 with SMTP id d6-20020adff2c6000000b0032f7a65da64mr3982796wrp.65.1700480489574;
        Mon, 20 Nov 2023 03:41:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG1wq/YjI8amSdfeudpCxfoQrHACBtiD5i2N7Xg7UmvujvliqdnYvkRrqxVMMvr8xgq3WVP9w==
X-Received: by 2002:adf:f2c6:0:b0:32f:7a65:da64 with SMTP id d6-20020adff2c6000000b0032f7a65da64mr3982791wrp.65.1700480489305;
        Mon, 20 Nov 2023 03:41:29 -0800 (PST)
Received: from starship ([77.137.131.4])
        by smtp.gmail.com with ESMTPSA id j14-20020a5d604e000000b0032da319a27asm10982777wrt.9.2023.11.20.03.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Nov 2023 03:41:29 -0800 (PST)
Message-ID: <459306993401d3904dd5e375aea9e5b837773ff3.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: fix kvm_has_noapic_vcpu updates when fail to
 create vcpu
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Li RongQing <lirongqing@baidu.com>, x86@kernel.org, kvm@vger.kernel.org
Date: Mon, 20 Nov 2023 13:41:27 +0200
In-Reply-To: <20231117122633.47028-1-lirongqing@baidu.com>
References: <20231117122633.47028-1-lirongqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2023-11-17 at 20:26 +0800, Li RongQing wrote:
> Static key kvm_has_noapic_vcpu should be reduced when fail
> to create vcpu, this patch fixes it
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  arch/x86/kvm/x86.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 41cce50..2a22e66 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11957,7 +11957,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	kfree(vcpu->arch.mci_ctl2_banks);
>  	free_page((unsigned long)vcpu->arch.pio_data);
>  fail_free_lapic:
> -	kvm_free_lapic(vcpu);
> +	if (!lapic_in_kernel(vcpu))
> +		static_branch_dec(&kvm_has_noapic_vcpu);
> +	else
> +		kvm_free_lapic(vcpu);
>  fail_mmu_destroy:
>  	kvm_mmu_destroy(vcpu);
>  	return r;

Makes sense.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


