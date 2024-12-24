Return-Path: <kvm+bounces-34362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C2EE9FBFD3
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 16:55:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4088D7A1EEE
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 15:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D92EA1D79B3;
	Tue, 24 Dec 2024 15:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C0jbxoKx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A5B8836
	for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 15:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735055690; cv=none; b=N862CGD4dhJud3hq/4rAUchf3gxVirMlrIKzrfzttL5hey/iB6iRu6czuq5VTfsL/PSHEuin/4T7iEFUbPmtAgxLqKXpRkQZjU82xSfQQvvL+ph4RxchrOx5Kk8VHGEVYtHaDFA3nqPbYlE+S1I3ZxVo4Io34GyOweHrzO2iW/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735055690; c=relaxed/simple;
	bh=2wTlXP8fR0Ybm0G7Y4TnNqEDVkel59WBciWf4E9XnoI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FnNKCrf7ytmp7Y0X1PouSPboYVGPw61lM0wqO6p9dJjiBkEdsm/mdETCsf4MCH/1HcNc6wjCvkVZ19dJJvaqsb/proebQQY2i5FC4Djuochcr5RLxPICvozI/CUL8/tGuTZNGEooYkAyuMWH22OzmyiJwJE++rFuOsqfiOkXy9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C0jbxoKx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735055686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pQPQBK3F62z6akTtDMAEGfDEtkQU09o6OnOmv2Ax/wE=;
	b=C0jbxoKxxhjAZVEnTaYaHEpLU8tD7uuRMlrwJaxnI7lym2oWqvbLP8mKpZ417p6dcyuXOA
	nXq7tJzQ99h1RzhbAn43Wnr3EMNIPR9WypRUwAxIrOJ4cjaz+9ECgeK7jFLXpuxL7POPWw
	UdSi4M5vijZl9yCIWdP2rRaSsFIkiW8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-ERnKmNWONB6jetAKyyFsWg-1; Tue, 24 Dec 2024 10:54:45 -0500
X-MC-Unique: ERnKmNWONB6jetAKyyFsWg-1
X-Mimecast-MFC-AGG-ID: ERnKmNWONB6jetAKyyFsWg
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-385fdff9db5so1954980f8f.0
        for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 07:54:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735055684; x=1735660484;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pQPQBK3F62z6akTtDMAEGfDEtkQU09o6OnOmv2Ax/wE=;
        b=jRsWvu/uzBiW0QeV/tXwKheFFkfJpvSQEuJ/6fGRU8M3jg2SvsqyY6o8jM9DbCq+4S
         1qBzNEMZFptlDQPzIMN3cyAdutswUa8oF6UKgkDBuYnrv6TZ2Uy398JlDSPTmJmp3Ty1
         b3x8J+y33j3vk3ObQG8qHNrDta4xydStDKqv5J88YsL2GVxp0KiaA5wTdHkjF7XQnMd1
         Yo0de11uTaSGwOgYjVNXITfQThwyZdMgvwqDPU7p5vln9HeyH4zDD5ayZ6J271j/hOuz
         xPNP1h4Jzqv79GOJZPT28il+DUbPbDSigFf65Gwj4Wczjko8MAeftwLCL47MQpV/6fSc
         cCog==
X-Forwarded-Encrypted: i=1; AJvYcCUL7krpRShzvRaDoq6GWlKrRsQpByiedNWdZmKWxZB6cePAUeqFmEIYrQ3kBy0JD8UxzA8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMg2BWvpATQSMdlFUKCLKWb2Pq302xxVnE5mxlEJV+iCvYFEzZ
	3T2V4FlvT7/dWDILDYHFHPI6veGJ7lLnQx4FZc9vXvXPsg1gMTVpCB4BcHYkJtNmGgknliaMbqx
	v/pVXiu+ActScgOpF/7G81Y4gQq9kMghUS8Mb6U78oFV9Km+u2w==
X-Gm-Gg: ASbGncuEKlpjASu/3GpcD/Tv133QZ1KQj+hDhKlHDJNa7xUuZACe5YjIjcwFK60ysCk
	RL1wmRIX7lwDbz58Xl0rX96IdR3GiQ5iyKoBaV7GoOXKtZRIMEH6ncknCemWBL39vQifkY0i2wt
	NaP+ys48SUmaL3HS6eZ9+3ssAA63Ngx97SO0esfpCT3/tiWTt0WIt++1cfUqtifG7Y3sr13BK/y
	cfw3Mzm60mxhixoue/c7T54z7DFzYL3B2WIIc1kz/LB+aoOsRxyOBV/3Jy7
X-Received: by 2002:a05:6000:18a4:b0:385:cf9d:2720 with SMTP id ffacd0b85a97d-38a221fb1b4mr13707796f8f.23.1735055684159;
        Tue, 24 Dec 2024 07:54:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFiJ6dOOb2ZXcY8eI4jxEc9RtVJ0acqzKGJNNsIjsvrgCxL/LV/rbybZ2Hmp8mx3SwrhmxD5g==
X-Received: by 2002:a05:6000:18a4:b0:385:cf9d:2720 with SMTP id ffacd0b85a97d-38a221fb1b4mr13707776f8f.23.1735055683785;
        Tue, 24 Dec 2024 07:54:43 -0800 (PST)
Received: from [192.168.10.27] ([151.62.105.73])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38a1c832e69sm14302199f8f.35.2024.12.24.07.54.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2024 07:54:43 -0800 (PST)
Message-ID: <5463356b-827f-4c9f-a76e-02cd580fe885@redhat.com>
Date: Tue, 24 Dec 2024 16:54:41 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/11] target/i386/kvm: Replace
 ARRAY_SIZE(msr_handlers) with KVM_MSR_FILTER_MAX_RANGES
To: Zhao Liu <zhao1.liu@intel.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, "Michael S . Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, Tao Su <tao1.su@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20241106030728.553238-1-zhao1.liu@intel.com>
 <20241106030728.553238-12-zhao1.liu@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20241106030728.553238-12-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/24 04:07, Zhao Liu wrote:
> kvm_install_msr_filters() uses KVM_MSR_FILTER_MAX_RANGES as the bound
> when traversing msr_handlers[], while other places still compute the
> size by ARRAY_SIZE(msr_handlers).
> 
> In fact, msr_handlers[] is an array with the fixed size
> KVM_MSR_FILTER_MAX_RANGES, so there is no difference between the two
> ways.
> 
> For the code consistency and to avoid additional computational overhead,
> use KVM_MSR_FILTER_MAX_RANGES instead of ARRAY_SIZE(msr_handlers).

I agree with the consistency but I'd go the other direction.

Paolo

> Suggested-by: Zide Chen <zide.chen@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> Reviewed-by: Zide Chen <zide.chen@intel.com>
> ---
> v4: new commit.
> ---
>   target/i386/kvm/kvm.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 013c0359acbe..501873475255 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -5885,7 +5885,7 @@ static int kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
>   {
>       int i, ret;
>   
> -    for (i = 0; i < ARRAY_SIZE(msr_handlers); i++) {
> +    for (i = 0; i < KVM_MSR_FILTER_MAX_RANGES; i++) {
>           if (!msr_handlers[i].msr) {
>               msr_handlers[i] = (KVMMSRHandlers) {
>                   .msr = msr,
> @@ -5911,7 +5911,7 @@ static int kvm_handle_rdmsr(X86CPU *cpu, struct kvm_run *run)
>       int i;
>       bool r;
>   
> -    for (i = 0; i < ARRAY_SIZE(msr_handlers); i++) {
> +    for (i = 0; i < KVM_MSR_FILTER_MAX_RANGES; i++) {
>           KVMMSRHandlers *handler = &msr_handlers[i];
>           if (run->msr.index == handler->msr) {
>               if (handler->rdmsr) {
> @@ -5931,7 +5931,7 @@ static int kvm_handle_wrmsr(X86CPU *cpu, struct kvm_run *run)
>       int i;
>       bool r;
>   
> -    for (i = 0; i < ARRAY_SIZE(msr_handlers); i++) {
> +    for (i = 0; i < KVM_MSR_FILTER_MAX_RANGES; i++) {
>           KVMMSRHandlers *handler = &msr_handlers[i];
>           if (run->msr.index == handler->msr) {
>               if (handler->wrmsr) {


