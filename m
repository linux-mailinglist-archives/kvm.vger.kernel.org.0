Return-Path: <kvm+bounces-20992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C11CD927FC6
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:31:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2FEB1C2170B
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 01:31:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E2E612B87;
	Fri,  5 Jul 2024 01:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hh2dY77I"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F76EECF
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 01:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720143050; cv=none; b=Tyf1s6iEARPsBiND4MvogHWcjRDQ7RKDIKPAVl7dj64ndOEVPabt397XoQOHHFFk/EasKzzuvQaWt3cOXnwHh+hEngWdsxmQL53jGrR98PaqohtwvrmM0bhGjlJaASSN0IIpd0EAtWUlWp3OtcufhXFF6i1AoVf8MX+tRlmKRac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720143050; c=relaxed/simple;
	bh=b1KFjrHIxvI8jgSgd4bJYAuJiLdVGAj7jOM75ne/lrc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cVflaDC8nuZbgh0jw0MsRE57J3cr0duaXgiuN3MgrhfvvCGAk+KlJmgSFieo3c20pZhAmRN/cin0brCgQBRkX81lanAka8cjC4mZUBgN3VtEvIyEnQedFUMq71s3/BLPcBF+fbMqxe9613PnfdwH1hH+c3pk2KM6/IjIojBtn5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hh2dY77I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720143047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nh3E9KkkAhpYyCrnjfD6rjhdH8UezPd9bJ8upEPnys4=;
	b=Hh2dY77IiIQKCpwRhzkAOyIjU9EbUk71tK5kZ6UinzTyiMxeohLHX2ZnZV+rgbissDIbIf
	d51L/BrRkY9XBs82ZMT5ipHexJ3Sxu77hOhQp1sTiI6GRrwx87Q7UTgsvpjs9Ln6BQTuYU
	Chjoai3H73AwOnSe0VTOOqY8KYueiTE=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-2-WabX4YJhPUS_HEYyHBcgPw-1; Thu, 04 Jul 2024 21:30:45 -0400
X-MC-Unique: WabX4YJhPUS_HEYyHBcgPw-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-79d112a9f8aso132051085a.2
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 18:30:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720143045; x=1720747845;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Nh3E9KkkAhpYyCrnjfD6rjhdH8UezPd9bJ8upEPnys4=;
        b=BSnYQ/wjkg5VrI5PzcCQzEIhfoCjsXiScDRz9tgrLGERr3Gtqeqy3QVER1JwxJZjPL
         Zz/GCmKIVXfzg0s93vLkiQBbHr45P1IXa74eWgEaCvNfeHvciQrhVgeW+PsoS3cyfRzo
         SuW58pSgl+uysLYRQjYlg0+VFVebdNleEAFFf4i97KUvmhQN4rUzlmNtqP2/O7cTb29E
         uD6gGiUvS6Y4he0FvflSSGO1fYv77gPYmBmA5mz+TvFf6zbN+OABRhJrOVUWyVj/8VnO
         N6wk4n5atFVc9gi645jxA+EpWhZ9km5zpOazTyEvcJfgAV9bG7Yafj5yg0YzNCwwxuPy
         mV3g==
X-Gm-Message-State: AOJu0Yz6BYNkL9CVbS9/qfcZDbNSyB1P00Z27vR5v56FSPHBX5Ujg4Lm
	xhuSHce5VEe28RIBl6iPlfXLb505EARQKRSpX70wBjpx09PD+ODJ3VQJ6zlAXt5P0ub/ykHrmTz
	99R4SzP6N7knio1PP0qClyTvFUHg8i8OrC5FBMvD1RIbKenMAMw==
X-Received: by 2002:a05:620a:5652:b0:79d:75f0:e91b with SMTP id af79cd13be357-79eeded1c62mr379507085a.0.1720143044989;
        Thu, 04 Jul 2024 18:30:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFW2sVNKVe1kjmam9dwHPQKpWfza+eAvYyhoHb0g9AzFonL3o5DNaZvNia17QTPD1lvnrJGng==
X-Received: by 2002:a05:620a:5652:b0:79d:75f0:e91b with SMTP id af79cd13be357-79eeded1c62mr379505585a.0.1720143044754;
        Thu, 04 Jul 2024 18:30:44 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79d692f05dcsm731005485a.92.2024.07.04.18.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 18:30:44 -0700 (PDT)
Message-ID: <20d3017a8dd54b345104bf2e5cb888a22a1e0a53.camel@redhat.com>
Subject: Re: [PATCH v2 24/49] KVM: x86: #undef SPEC_CTRL_SSBD in cpuid.c to
 avoid macro collisions
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 21:30:43 -0400
In-Reply-To: <20240517173926.965351-25-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-25-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> Undefine SPEC_CTRL_SSBD, which is #defined by msr-index.h to represent the
> enable flag in MSR_IA32_SPEC_CTRL, to avoid issues with the macro being
> unpacked into its raw value when passed to KVM's F() macro.  This will
> allow using multiple layers of macros in F() and friends, e.g. to harden
> against incorrect usage of F().
> 
> No functional change intended (cpuid.c doesn't consume SPEC_CTRL_SSBD).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 8efffd48cdf1..a16d6e070c11 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -639,6 +639,12 @@ static __always_inline void kvm_cpu_cap_init(u32 leaf, u32 mask)
>  	kvm_cpu_caps[leaf] &= raw_cpuid_get(cpuid);
>  }
>  
> +/*
> + * Undefine the MSR bit macro to avoid token concatenation issues when
> + * processing X86_FEATURE_SPEC_CTRL_SSBD.
> + */
> +#undef SPEC_CTRL_SSBD
> +
>  void kvm_set_cpu_caps(void)
>  {
>  	memset(kvm_cpu_caps, 0, sizeof(kvm_cpu_caps));

Hi,

Maybe we should instead rename the 
SPEC_CTRL_SSBD to 'MSR_IA32_SPEC_CTRL_SSBD' and together with it, other fields of this msr.
It seems that at least some msrs in this file do this.

Best regards,
	Maxim Levitsky


