Return-Path: <kvm+bounces-4207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4288E80F1E0
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 17:07:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D689BB20D79
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 16:07:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B22577651;
	Tue, 12 Dec 2023 16:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HSVz3T3B"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3107B8E
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 08:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702397255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AX13QLp52fxcEAzzU06zAooOoCuVylV9op9xhQpaESU=;
	b=HSVz3T3BwYhorFfv82e5JokdYrEE5khb++O8K6jISwIVkdhLzxL67okt5lnz1z67HN+5yl
	zBJ25Fg/snSvwZjNNuM77EAl8BFUW8CEeMq3W5eyyiMK+/1kKcOkVHdtT368EWT1yQ2ERS
	wWCZ/iRikHN/EpUz8LSySJePfjKD37Y=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-322-IGB0rNJIM3yU2uwRxROx1A-1; Tue, 12 Dec 2023 11:07:33 -0500
X-MC-Unique: IGB0rNJIM3yU2uwRxROx1A-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-33608b14b3cso4119091f8f.0
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 08:07:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702397252; x=1703002052;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AX13QLp52fxcEAzzU06zAooOoCuVylV9op9xhQpaESU=;
        b=bq8BhxDK6i16dUDbjDSsMtr36PwxrU7fV2bxzesRbjq5qw3bKRiBfat4P5q0TeM11Z
         +t905wvp2LHz5vvEHGLhkEMlMK3NwlIYLx5S1E6mL0J4RYzrZ3bCq9ayq+2K6HE3cyO4
         iAeWBtJ4Q3K6LbZrq3lYgRPbwnxbShVUtbo5WFGW4OOlVeHMKLYuiLxfgaMyTxv52RMh
         iVdtOj0XY+YmItgq/55HSW6nKQ9zCuEOGnqRj2XYKw19BejuBIrLwAUEiDOyWdg9mtOz
         9lSqMzl2rEFFPb1QQMQJR/LL+kvaYYB7jBU5vZUC3Mj18CzjvBVmiIwlMejU9FrwP0QM
         G1vQ==
X-Gm-Message-State: AOJu0YzBAkM67H6PNpTHQuztya1AL0KdVYVjLikcRwsyRZ1Rr1Ubslg/
	PTNryIstUK9fHIk7WPsgm70xvUr9NVm4injcHwQPiEJHuKsftFigIsgYYkHU5ir/jS+3i1AwsV8
	i22dF+jRTrR3k
X-Received: by 2002:a05:600c:4507:b0:40c:5a4:b0dc with SMTP id t7-20020a05600c450700b0040c05a4b0dcmr3068544wmo.113.1702397252407;
        Tue, 12 Dec 2023 08:07:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFjMQpzQc5MhAj09eWUFTjXsAB04BjM7/TN5+rFoi67i9ZNVTdke0Lk83q2ohgUcY7xbEkJsA==
X-Received: by 2002:a05:600c:4507:b0:40c:5a4:b0dc with SMTP id t7-20020a05600c450700b0040c05a4b0dcmr3068536wmo.113.1702397252048;
        Tue, 12 Dec 2023 08:07:32 -0800 (PST)
Received: from [10.32.181.74] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id f9-20020a05600c154900b0040c4be1af17sm5548133wmg.21.2023.12.12.08.07.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Dec 2023 08:07:31 -0800 (PST)
Message-ID: <4a26883e-1acf-421a-9055-07ba9fea783c@redhat.com>
Date: Tue, 12 Dec 2023 17:07:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kvm: x86: use a uapi-friendly macro for BIT
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Dionna Glaze <dionnaglaze@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <20231207001142.3617856-1-dionnaglaze@google.com>
 <ZXh78TApz80DAWUb@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZXh78TApz80DAWUb@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/23 16:27, Sean Christopherson wrote:
>> -#define KVM_PMU_EVENT_FLAG_MASKED_EVENTS BIT(0)
>> +#define KVM_PMU_EVENT_FLAG_MASKED_EVENTS _BITUL(0)
> It's not just BIT(), won't BIT_ULL() and GENMASK_ULL() also be problematic?  And
> sadly, I don't see an existing equivalent for GENMASK_ULL().

BIT_ULL() is easy enough, as you point out:

@@ -550,7 +550,7 @@ struct kvm_pmu_event_filter {
         (GENMASK_ULL(7, 0) | GENMASK_ULL(35, 32))
  #define KVM_PMU_MASKED_ENTRY_UMASK_MASK                (GENMASK_ULL(63, 56))
  #define KVM_PMU_MASKED_ENTRY_UMASK_MATCH       (GENMASK_ULL(15, 8))
-#define KVM_PMU_MASKED_ENTRY_EXCLUDE           (BIT_ULL(55))
+#define KVM_PMU_MASKED_ENTRY_EXCLUDE           (_BITULL(55))
  #define KVM_PMU_MASKED_ENTRY_UMASK_MASK_SHIFT  (56)

  /* for KVM_{GET,SET,HAS}_DEVICE_ATTR */

And I'll squash it into Dionna's patch since she has already a conversion
for KVM_EXIT_HYPERCALL_LONG_MODE.  For the others, I'll send a patch.

Paolo


