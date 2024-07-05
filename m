Return-Path: <kvm+bounces-21009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F9DD92805B
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 04:23:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60FFC1C239FC
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 02:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DDD31BDDC;
	Fri,  5 Jul 2024 02:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a0/cF8/c"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CD73C463
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 02:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720146151; cv=none; b=hwe3eZNZV3L6RrRi2VoRxuD3q7WnpA3oGjcpwPFOQMvU82OdEXSrxBceMDlLP3e2RFyjLcyJuAhzKEhmAqQhUab2z5+2RRIxuuLkurYlsBDT85plwRcmlYhSpl3RXtdFpj9Dq5lQmVdwpdDKQ8T3/9qEZ9znKTFSAAK+UL3E4Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720146151; c=relaxed/simple;
	bh=NapZZUDRrPOjOD7hmeC6ooeeQO+UVoWf3ur+giJO5Qo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aAThTv9MOTvS+PFxOK8iIH0HUjMZkttmUnU79yxAXxKW2iDKXsy6CR7cUwmLIO2hqu5PnX0G//HTLDIrm2naijRlEmm4GL7OJe1FNPY7Z/jYcUCM3s5pMbQ6uhO75UcRyvT0WkgDyYD2Rh/p7llEVpieS90oAdaOmP7MNNxkUz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a0/cF8/c; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720146149;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tjyYkaA/WHaUDnxoizRMJYe279ct6UcqrvUL0yfxjPU=;
	b=a0/cF8/cCr4KMa4a7V46+0XWL52tPN0xH5ody1ExJn0Q7TY60LQslmkF349QLRP65jMtjS
	JkRA2PWH8HJen7C2RJNw8gA17Sj3ALWcDHDF22o12LUnrshFGRfsxtP8o/FWQFedUHwO3V
	w5iuCcWUsLogFssnCxbnqhORDczb7qI=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-NHv4aD-jO-Kj8TL25uHZ7w-1; Thu, 04 Jul 2024 22:22:27 -0400
X-MC-Unique: NHv4aD-jO-Kj8TL25uHZ7w-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-650f766a1c6so19965077b3.0
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 19:22:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720146147; x=1720750947;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tjyYkaA/WHaUDnxoizRMJYe279ct6UcqrvUL0yfxjPU=;
        b=KqkF8SeiPLSuoBL4w7uittN1RtFa48bG9UdIalPHqP9sSY42+0Cumu2h2PMvrmyX32
         9u7urh5cPcInBS3wLQmaLao9/D72tIbgGX/sUEbRUaGHukTigugD4WLn80nar7E3CnsQ
         /bzHWrWiFDDaDsx9oDGNbTujFEqag9Qjf6j/RY1DopqgUTsLE5Rp4h4pGxrMmh2znWsH
         rKLvDjT5xXbOFvBesN+FXYRA+YBsHtYvB9LjQ8rdwZMY7k6jj+iiMFOClIliqGLk0+6Q
         oPkkrKyHvPlCoRbqhnInhHY/Gd8Vfeds6rf0nDPEq8Cu610UFxVGL0Ky2vPfOf2RzQuF
         tgxg==
X-Gm-Message-State: AOJu0Yz+E+fHgS1uUiYxQedseU1TN7ioKIiohWdrQttnmHZvIf856TUX
	i5t1RsY8C9BLIpJss3B6nmJ3KutPx2V/Y1ukXzVxPGA1VeotyE3O/lBsh4Sz16zqeDMbdn+eYpw
	LnT0Et4dvPys/411PcHqOHNmHIAgC8gUbux/pHUzLdlb5uLULMA==
X-Received: by 2002:a81:8388:0:b0:64b:69f0:f8ed with SMTP id 00721157ae682-652d8036fbdmr31922387b3.51.1720146147243;
        Thu, 04 Jul 2024 19:22:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGLgnTKFCfkEiR+QoUwT2JIVvTCvhP6onUBXVZAlhfg+gaU00wMZsc+aVt5WRSkm7f9Rp2w7A==
X-Received: by 2002:a81:8388:0:b0:64b:69f0:f8ed with SMTP id 00721157ae682-652d8036fbdmr31922287b3.51.1720146146972;
        Thu, 04 Jul 2024 19:22:26 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79d69308142sm731282385a.117.2024.07.04.19.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 19:22:26 -0700 (PDT)
Message-ID: <f8e58280c31e7f37c36277928b48a3e4bde5d795.camel@redhat.com>
Subject: Re: [PATCH v2 42/49] KVM: x86: Drop unnecessary check that
 cpuid_entry2_find() returns right leaf
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 22:22:25 -0400
In-Reply-To: <20240517173926.965351-43-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-43-seanjc@google.com>
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
> Drop an unnecessary check that kvm_find_cpuid_entry_index(), i.e.
> cpuid_entry2_find(), returns the correct leaf when getting CPUID.0x7.0x0
> to update X86_FEATURE_OSPKE.  cpuid_entry2_find() never returns an entry
> for the wrong function.  And not that it matters, but cpuid_entry2_find()
> will always return a precise match for CPUID.0x7.0x0 since the index is
> significant.
> 
> No functional change intended.
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 258c5fce87fc..8256fc657c6b 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -351,7 +351,7 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>  	}
>  
>  	best = kvm_find_cpuid_entry_index(vcpu, 7, 0);
> -	if (best && boot_cpu_has(X86_FEATURE_PKU) && best->function == 0x7)
> +	if (best && boot_cpu_has(X86_FEATURE_PKU))
>  		cpuid_entry_change(best, X86_FEATURE_OSPKE,
>  				   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
>  

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


