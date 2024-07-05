Return-Path: <kvm+bounces-20975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81751927F86
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:03:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B31D61C21CBF
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 01:03:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E099FB65A;
	Fri,  5 Jul 2024 01:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gwNx8LlK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E55FBA47
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 01:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141380; cv=none; b=C2ZzIr2Twop8pSQs3hiM06lXs91gJoxq/t28XROEmnYTo7MNtxVgjRJa0f9nRUDNowtbX49FJfS/svvr21HAkCJPdJa1Z8Q6NQUghu068dEvdOJIupw9jd0Ub/KezSbCdrWo651XVfNLKiMAftFHTMz3DGVWNZId3paddWb/bqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141380; c=relaxed/simple;
	bh=eN/qlqR3Zo5kCHr/OMGtGHTTRM/b2jase/Y9KkmY4rc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=evIAIu5Il1eBLgnVyDqxJd8LwLcCvqK6oMJvgZXI+M1mCIw5AqiaPZK8MgFKtWzzrkiI3uyiTcOFwdoooa1CwfwgTIGRvY3CsxCOOzSnhlNHGhYefuFxC1MnaWNLv1vmpAJ7GJZVV5i3XvJYNWppLRZoqpOVbdR+3nSe0pNhg/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gwNx8LlK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720141377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/3rY5xknhh3FOvB98bwxPhUCsuh04Yjf4LYAQaj0PBE=;
	b=gwNx8LlKNRBpx24oR0wrq0Um+8nE3A0slbPYGoDJKPqktWcrNcKuY88MXf3r1Ye4QzlG7M
	K28Afro26/YHOL050TboqbB8IxinWiJHC2+OajzPG9MDe3a4YmoIUAtty8rTzauzn9Bkbq
	LiRptZQeECMb2vEEaggcJP0t1OctZ8k=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-xHItZTKFOkeGCAg5jtsOOg-1; Thu, 04 Jul 2024 21:02:56 -0400
X-MC-Unique: xHItZTKFOkeGCAg5jtsOOg-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-79cca28445bso112721985a.1
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 18:02:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720141376; x=1720746176;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/3rY5xknhh3FOvB98bwxPhUCsuh04Yjf4LYAQaj0PBE=;
        b=myONq1IYQ4oIHhxAU+1za/Rg0Og+7zlq3qBbk469RZ8G8F4j8+SVEXWugmejW+Rk9n
         7Sx7q66t1uEV2UXecIT8SBqzzTq9v5IHvGOxD3Wky6ASbbGgEyA9Lk79K/U0rCkwmN3H
         R0yEHi6ouJcANJ4uMbtA8xhUp4FrgQ9p+p++/+Hc9ucmUbceEWS1bY6yPk2gc7A3M9oi
         a6wL9iT2k07WFInE+aLdtQ8NnFTeJsbB+08nna5nI7Hr3ElZudLiUaHRMgY+qL3CvdUt
         T+zxZV8UBQKz+iAzWYk62/USZb4M0UFTJrSBcEEFqEGqdGsDUdvg08lNOv87YNMFjBUK
         LZcQ==
X-Gm-Message-State: AOJu0YzY1Qg4t38pOkw5mVeKhSNpPuUFeMSVk4WM11P3L56+NGpv6KfG
	ay4FH462NU1KMzYZHG0Ca0Os4QQhGONzIxAd5+W3NFCJMRMVibL5n6RJeWCRBttouAWn0ThZPAH
	hPhhAtdushejxh3Jo4SxU5nQVOy3P0h7dy+Md7vroZg90fj/xVQ==
X-Received: by 2002:a05:620a:5610:b0:79e:f730:e2d7 with SMTP id af79cd13be357-79ef730e37cmr29294585a.51.1720141375941;
        Thu, 04 Jul 2024 18:02:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG81lv5DHPL7+sh38G2+I4b5M1hylBqtBNC/YO+HHkQMOM5Mg/mwn6+A4Sg5Y6rqZY1Y1HwQQ==
X-Received: by 2002:a05:620a:5610:b0:79e:f730:e2d7 with SMTP id af79cd13be357-79ef730e37cmr29292385a.51.1720141375649;
        Thu, 04 Jul 2024 18:02:55 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79d692eff08sm725026485a.83.2024.07.04.18.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 18:02:55 -0700 (PDT)
Message-ID: <4076d0c617d3e94ea742855f80a497c532107e88.camel@redhat.com>
Subject: Re: [PATCH v2 09/49] KVM: x86/pmu: Drop now-redundant refresh()
 during init()
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 21:02:54 -0400
In-Reply-To: <20240517173926.965351-10-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-10-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-05-17 at 10:38 -0700, Sean Christopherson wrote:
> Drop the manual kvm_pmu_refresh() from kvm_pmu_init() now that
> kvm_arch_vcpu_create() performs the refresh via kvm_vcpu_after_set_cpuid().
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/pmu.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index a593b03c9aed..31920dd1aa83 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -797,7 +797,6 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
>  
>  	memset(pmu, 0, sizeof(*pmu));
>  	static_call(kvm_x86_pmu_init)(vcpu);
> -	kvm_pmu_refresh(vcpu);
>  }
>  
>  /* Release perf_events for vPMCs that have been unused for a full time slice.  */

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


