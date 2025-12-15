Return-Path: <kvm+bounces-65970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4945ACBE682
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 15:52:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4F68830249AB
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 14:51:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6261337102;
	Mon, 15 Dec 2025 14:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M5TOH3/1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="InIzFwdO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0116E336EE0
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 14:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765809839; cv=none; b=UOLgRF1aa65yu7ynkxjxG3EwO60UXeB86WJyKzwWAULaGP2kLiJzK4MlOFgLvxtFaWlK8cx5iEbKJR9TZR49ATjVUd8OKmDO1X7AieidjCeMM4jl7xITX98wgEZQRQ8V4LPQcVeX7iV6Z9NSaST4vcvPh1hnKgbzNahBdhNr2Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765809839; c=relaxed/simple;
	bh=RzdY0R6cG+aTzXVIrX1t6/9tOgEfYVhCd8vqifyXyO8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HoOx7CLbm2U3k+e4MDuc3mm9XZTnkCfU+7Obyi3+Y0/4txAVlU9h8iNmlExRfbsVatXSP/fc8McUuNdva8BaA9kdeikw73XoNXY4b/2DTqgmWv1+RlprjcipKGBIGHgU/1MrKgFQSPgQ3ABLOKOrxGsem7Ct7HdmJXU4+rzCE00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M5TOH3/1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=InIzFwdO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765809836;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KbmBVMaKs2SCvs0kY5sFfZiNDopO0kTBitZ0Y6fYXHo=;
	b=M5TOH3/1ramwLoZvUsQiJR/DLc7FCax5QssRjeVCN4e6Vv/L5UL+CHafNf8w+Bsbz+OFE9
	ph5h05Fj2J7sC/FSHlBCmnNjJos1qFFgPC/ffX1OVmChyqaY2GINVlwIzYDVY4199IDe9G
	CfKXkuU0PVszjXLEO1B6TgihpYSpurE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-2-iPyIuc_fPPiX7safDmuyqA-1; Mon, 15 Dec 2025 09:43:55 -0500
X-MC-Unique: iPyIuc_fPPiX7safDmuyqA-1
X-Mimecast-MFC-AGG-ID: iPyIuc_fPPiX7safDmuyqA_1765809834
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-430fc153d50so826936f8f.1
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 06:43:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765809834; x=1766414634; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=KbmBVMaKs2SCvs0kY5sFfZiNDopO0kTBitZ0Y6fYXHo=;
        b=InIzFwdOzhJDv98tb/9tw3AJQTQzo6bgMtVB7v+85wAwjI+9zM3Ajzst4tZ0Ovb+bq
         g8YuxHv58ti9ZdOHhqDnLyjYvl5gikgG6I5XgKOqXfSE2GyuBaP57GZHdMbj5aFsKoGu
         NSVWAUDflLnle6hV2oHfSX7J0KF9/2rOCpETCtHYaA9RgDWFlpXPL4bhTA2Qx6sH3v1V
         XlaP3CgHYUt8M7EYioC/nz4CdtDjCkXdlDQuWlRKjVfRy0sAsSdEn2Zr3jzdolt9W/uc
         I1zRuTh5pbVTPupKEEz3R6l6egqu3tCDvhKyGhT2DKL5qfPP0RhOeMMsT59vieYD61TR
         68Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765809834; x=1766414634;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KbmBVMaKs2SCvs0kY5sFfZiNDopO0kTBitZ0Y6fYXHo=;
        b=JKmdbhhKYBUpe+h2ZNgoizCsOgRQRt5GCarF+8mgohrI+5mzDNvJ52FgMHll5rMseV
         L3+EFLomHmuR6fapkgQT+p1DwFYmJVJd+6jmz+4L7337qZQyxADDuBHYOhcJqopOWWKN
         X43GmdLu03GceaKAf9pXCsH6JvUewkpY8UfF7lnYPJSTPZj3sYqt1PXIe6lqnEKtUlpw
         45PjXy0BeiYJinQbLgtKVpMO/NvMVHJxrwaAPGJ5whlFhU85/jfCEWYQ1KVsIIXWRt8b
         c6PH+B6fmnXoWE8EONMHbC0d+4VRs/b6GnNdusYeqZFRSeIRYimft3ilIr5Qt7PHHgkq
         vL8A==
X-Forwarded-Encrypted: i=1; AJvYcCV2diBINh1KMKIVARFHcHU2AAVRrRtQzWFfms7o4UFRKaMbVjU1H6Z7OVXCqElXSqVMQBg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrsGY58BXdyvH3tmsdbQRdGCBrcucx3ZEhwqTSJiA/BA7Dg6e6
	6ipI0+559OUyOQ3eTRzdsAfT52/Mgq49BMjIhb+C1jRYM50ywARw+vW1LhyJeOW8uuihy1VdHQC
	CuIaySlryeKu0qz+kALv/Q7qKmyHpQKTWBP/OBbdk9Sxx1qz+fwZDPA==
X-Gm-Gg: AY/fxX5cRR0E9NnkDSZH/GaNtiHbh89HOn1X+Nh65NfoenduoohZfRKbhbv50ONsRMo
	aFbmJsnALJtTU4VFeqPby49ciK5a7drPc3tnhpI1cGpWpopKldWuBQMpvmRcQwhxkO7oRinrWQ1
	HHg923luza0WJf8qjLkXzMjr+cjNvNiqNFniy70QI15xh5m38R6r8CoFeZuQ125ex0panO6OyG6
	3dlf3XQ0EZbG1jPyNbt/wzBRMByDwix3lTUcetPHxOiJ9Di+zMSRUom4Wn/ADmodmZw4Df9yrIH
	N+8O+2mW40WatIxXOe5rPFFr5KA3XNxOXlqtczeTHIjmgf4n9sLvNIbCqYrkc7RPHCMDXJhSdP8
	e+ZFJtn5+ZlTWbUBJmDGr68s17zAowWu+LWq9eEXiWz2FpYHkzyL+9WsWlIFVtxTXqruicOx4PP
	IijRQCDFYApPREwK8=
X-Received: by 2002:a05:6000:2003:b0:430:fdfc:7ddf with SMTP id ffacd0b85a97d-430fdfc7f3dmr3346994f8f.42.1765809834227;
        Mon, 15 Dec 2025 06:43:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGE8z7d28O5QIYZWoRf+K+IW6v0b/UhSS4nFlmnvJmnnvSIBIqZMZaI0o6LAB3W1sR28YpbMw==
X-Received: by 2002:a05:6000:2003:b0:430:fdfc:7ddf with SMTP id ffacd0b85a97d-430fdfc7f3dmr3346950f8f.42.1765809833591;
        Mon, 15 Dec 2025 06:43:53 -0800 (PST)
Received: from [192.168.10.48] ([151.95.145.106])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-430f6e78a7csm12109808f8f.34.2025.12.15.06.43.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Dec 2025 06:43:53 -0800 (PST)
Message-ID: <159ced33-46e4-4b86-85e7-eda01406f768@redhat.com>
Date: Mon, 15 Dec 2025 15:43:51 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] thread-pool: Fix thread race
To: Marc Morcos <marcmorcos@google.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>,
 "Dr . David Alan Gilbert" <dave@treblig.org>
Cc: "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20251213001443.2041258-1-marcmorcos@google.com>
 <20251213001443.2041258-3-marcmorcos@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20251213001443.2041258-3-marcmorcos@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/25 01:14, Marc Morcos wrote:
>   
>           req->ret = ret;

Better use qatomic_set here---will fix it myself, thanks!

Paolo

> -        /* Write ret before state.  */
> -        smp_wmb();
> -        req->state = THREAD_DONE;
> +        /* _release to write ret before state.  */
> +        qatomic_store_release(&req->state, THREAD_DONE);
>   
>           qemu_bh_schedule(pool->completion_bh);
>           qemu_mutex_lock(&pool->lock);
> @@ -180,7 +184,8 @@ static void thread_pool_completion_bh(void *opaque)
>   
>   restart:
>       QLIST_FOREACH_SAFE(elem, &pool->head, all, next) {
> -        if (elem->state != THREAD_DONE) {
> +        /* _acquire to read state before ret.  */
> +        if (qatomic_load_acquire(&elem->state) != THREAD_DONE) {
>               continue;
>           }
>   
> @@ -189,9 +194,6 @@ restart:
>           QLIST_REMOVE(elem, all);
>   
>           if (elem->common.cb) {
> -            /* Read state before ret.  */
> -            smp_rmb();
> -
>               /* Schedule ourselves in case elem->common.cb() calls aio_poll() to
>                * wait for another request that completed at the same time.
>                */
> @@ -223,12 +225,12 @@ static void thread_pool_cancel(BlockAIOCB *acb)
>       trace_thread_pool_cancel_aio(elem, elem->common.opaque);
>   
>       QEMU_LOCK_GUARD(&pool->lock);
> -    if (elem->state == THREAD_QUEUED) {
> +    if (qatomic_read(&elem->state) == THREAD_QUEUED) {
>           QTAILQ_REMOVE(&pool->request_list, elem, reqs);
>           qemu_bh_schedule(pool->completion_bh);
>   
> -        elem->state = THREAD_DONE;
> -        elem->ret = -ECANCELED;
> +        qatomic_set(&elem->ret, -ECANCELED);
> +        qatomic_store_release(&elem->state, THREAD_DONE);
>       }
>   
>   }


