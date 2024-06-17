Return-Path: <kvm+bounces-19762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A5D3490A864
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 10:30:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4CEE61F21DC2
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 08:30:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8224719007F;
	Mon, 17 Jun 2024 08:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HVBqAP1l"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059BB17F5
	for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 08:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718613026; cv=none; b=C3GW2gYIAzGcehPb4tV1tuQ+klQUV1PBFPB7nG3ux99c1ruSMTte9Kti5891dfQieQICw7rH8ReGOTNJbCCHXdtVwQaZ9kvuAzg8KSMVWcz+OprAf8wSJofnmS489pUDsiSryyG/DnDkUeUTkPEucJ5osItQqCbmfQC2cVMChGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718613026; c=relaxed/simple;
	bh=Rp8Vag3LpLJew9S8yyg2rydHRn43gYTX8ZVb4PT2038=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=grFwiXbQnChNcVPl/F3qSqqFjLJlZF5CaLacnousmwG1T2TUkUkaHQiERDTT341YI2ejrgSaQTbtRFEEl/zhRnlpoTUkPoTtRTP6FIx6RDpjIr5g6dhxRx/8x4TudMgQfESkjIuEth6PLDpbf/Zz2zvQEU5uDEIdijPPGH7PpNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HVBqAP1l; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718613023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fWmPEshK6jnpSxKwNMhgkWuskIMin3QviDgO84RstYo=;
	b=HVBqAP1lYE3MfF/2LzNQGwcjHwOoePltmjL7RsXfKkiQxV2niQsaWVhC8UGDP+5L2a2puf
	eW3zqzkQqXYcMI+yVLH59WX8/+f+bEiKFXlS+eAuR3ifbmnp0v4fe98jDrP1YZjGFZVZ3h
	raZ4U6Vm4flyZfH6NgCg2veTtyru3ps=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-kQPZdEdZMYa8vo7Gj0WxlQ-1; Mon, 17 Jun 2024 04:30:20 -0400
X-MC-Unique: kQPZdEdZMYa8vo7Gj0WxlQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-36083bd1b12so2109255f8f.1
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 01:30:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718613019; x=1719217819;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fWmPEshK6jnpSxKwNMhgkWuskIMin3QviDgO84RstYo=;
        b=hf7Rcl197vDE/9PlE5uxKy4arIn62HLlfcVdjDotvPfc+V3s9KnpjL1W2dqcEa5quS
         heqJuUtT//oD0MAb68JWBff+4zo9H1/DHgMk4f9//BQg7Ah0z6Bit0GvMrlt1Vc7+ftE
         couMVT1qRHw6MSwQF0EdpbV9lQCmYpooetzGLxBCoenYenPDkkeU1JlYJXtji/C14tKx
         1wkH8HPk8XA+RhQlDuxdz9f8xRoEsv/rCGyGTZoeUOvXwxAUN/z1SFYzMzAC7gYgfG6l
         80oJFKb+KRDNTZ2iA9rCOxiulmud7Ov5VY7JxnFbMJnTGaPbvn4Mg1NSoTTX8whOAFja
         +y/A==
X-Forwarded-Encrypted: i=1; AJvYcCVghj2kd5RBQwK7iM3vrgHrwm3YteKLL3o+KHPJWdt5eFK+7JPVBYyMpnMD5OZK2MI3tZ4fA/bg176iXicrKMxBahFC
X-Gm-Message-State: AOJu0Yy1QhEHoBF5pMzyerrzJjQVd42dYR0SB+cDuQDkjTtiUu7jF1us
	bHmWmogG2NqV8bNbISnKGNGiGtCOn8WR/dgmCtIcPpNontvNepvJZKi6/2S/VJIaO2RVCEiGG5i
	4X/eMMo7haneHWhUJfG7jqDSf80F6L/RuBqQMmPwqDfrwlLxM7HEmXN8ft3GU+qkqCu+FbulU2m
	AyeP5GlCH5LssKneHxbmsNx+Vy2wNtjPJ60Q==
X-Received: by 2002:adf:fccf:0:b0:360:9d39:7867 with SMTP id ffacd0b85a97d-3609d3978e1mr93491f8f.67.1718613019152;
        Mon, 17 Jun 2024 01:30:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHW/e+n9DByo/+tCUrn78vk4tjFDZIStn036LAJlSNbehDums9iwbVCxwMMjjpFDCItaHhYLg==
X-Received: by 2002:adf:fccf:0:b0:360:9d39:7867 with SMTP id ffacd0b85a97d-3609d3978e1mr93461f8f.67.1718613018701;
        Mon, 17 Jun 2024 01:30:18 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3607509c8b7sm11296968f8f.26.2024.06.17.01.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 01:30:17 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Li RongQing <lirongqing@baidu.com>
Cc: pbonzini@redhat.com, wanpengli@tencent.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org
Subject: Re: [PATCH] x86/kvm: fix the decrypted pages free in kvmclock
In-Reply-To: <20240611024835.43671-1-lirongqing@baidu.com>
References: <20240611024835.43671-1-lirongqing@baidu.com>
Date: Mon, 17 Jun 2024 10:30:16 +0200
Message-ID: <87frtcrmxz.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Li RongQing <lirongqing@baidu.com> writes:

> When set_memory_decrypted() fails, pages may be left fully or partially
> decrypted. before free the pages to return pool, it should be encypted via
> set_memory_encrypted(), and if encryption fails, leak the pages

Out of curiosity,

shouldn't we rather try to make set_memory_decrypted() more atomic to
avoid the need to hunt down all users of the API? E.g. in Hyper-V's
__vmbus_establish_gpadl() I see:

     ret = set_memory_decrypted((unsigned long)kbuffer,
                                PFN_UP(size));
     if (ret) {
             dev_warn(&channel->device_obj->device,
	     ...

doesn't it have the exact same issue you're trying to address for kvmclock?

>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  arch/x86/kernel/kvmclock.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index 5b2c152..5e9f9d2 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -228,7 +228,8 @@ static void __init kvmclock_init_mem(void)
>  		r = set_memory_decrypted((unsigned long) hvclock_mem,
>  					 1UL << order);
>  		if (r) {
> -			__free_pages(p, order);
> +			if (!set_memory_encrypted((unsigned long)hvclock_mem, 1UL << order))
> +				__free_pages(p, order);
>  			hvclock_mem = NULL;
>  			pr_warn("kvmclock: set_memory_decrypted() failed. Disabling\n");
>  			return;

-- 
Vitaly


