Return-Path: <kvm+bounces-20971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97118927F7D
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 02:58:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B83A3B2163F
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 00:58:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC66620EB;
	Fri,  5 Jul 2024 00:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dhpo6eGD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D03B2579
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 00:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141124; cv=none; b=tuMEPU5f+THnfubQSegBdIKuy0ME4kmuRiegJGK2EQ58OVshxx1q0giI+Q/KnawYrbv1thPF2ozewXX3pZpVSypkje6XuzsxDDVXYaiDWBRw1sfAvbawnmQAgbgpWNCw1VRW5h509N3FjMr1q22kq4JDvojQZhODCjaA6lEPO5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141124; c=relaxed/simple;
	bh=VocEeIcd/FXfuJ+JYbUhdbxRAvE4uj34aaDRIeuJFwo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RJ4ENtD6fs2nt6yfSDP6R6N5lyRPkpMBs9yk3XaZYbbY21f6ISZOC4VvEyexyFkPyHdy8jiqi5KcqksdKlgvGksYLBD2XoN+rbX7macgjsNo7T98QNyM6K+sLPC1H22xW8dT+zZZGNiWaxDTdWCITzqm0WN2+mJg6xASyXLBUF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dhpo6eGD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720141121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yBft8HzPsKQdo71AmXPwgwDDSRvuWQe++1hA5/bW3JE=;
	b=Dhpo6eGDKP7UYTjm+BhYG+N9F3ySu92KTyUBgOOxg81zQ/R0OXXl/gbKccK3ShWo5Vk0/1
	z3ibgKhK8r+SsioltHOfVKcBV/MgPgLrWA0xc6ed72InZx6usA9fT4K/svCQgnA+/YvGmK
	+KaDo8wOteBJrBi9YoRweh0MREadnqk=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-Ppvvdct_OVm4MZOhHYQ1BQ-1; Thu, 04 Jul 2024 20:58:40 -0400
X-MC-Unique: Ppvvdct_OVm4MZOhHYQ1BQ-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-44501497419so16523921cf.3
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 17:58:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720141119; x=1720745919;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yBft8HzPsKQdo71AmXPwgwDDSRvuWQe++1hA5/bW3JE=;
        b=XDzet5hrCifkaVKioQGRI1T+niEY6IdHJb5AmUDlrnldZvmuLE3liIzAyRL9EcrqBI
         wBong8qiCJJBtfwzXSqxwUP8fQ4gYKiSAHLuVoD0057bOJ8Rp3Lhys8WChi+9c2ObnOH
         +N+oivaPxSxVy/aOoHbDbdkmvEyj1AwSdrj/qGTpEnr5uKphJLcYDEoqz1lMshkVn1+y
         5blQJefnfMHUobBLE5iw7+zUqSYv+X8N2PF38Fx+08sdy27ct75Ew4syx59lZi3CPzz8
         VKphfjh8H93JUhBhVOBEdGKSNCbXzF7H2oNSazm/GoOlo5ZVKwZQ1LpvhhR5jknY04yK
         v61Q==
X-Gm-Message-State: AOJu0YygopFPyIK7/P7KGpQeRlWIE3Kc77ypexYyLKT9pE9m5NO8VBjC
	iUdCBqKJr+K7uOyZkFESM+T0CEz8+hyzMv9omZsSRLBDCXJC79p5bBA/Pm8B1fawFYhwuoE/6hp
	3iYjhiqCtS8pVK2ShkYDFISt7q/vksFUNccb6Sa0+ygPSN7V8wA==
X-Received: by 2002:ac8:5851:0:b0:446:5fe5:5e6e with SMTP id d75a77b69052e-447cbf0276amr38482591cf.17.1720141119685;
        Thu, 04 Jul 2024 17:58:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0J29caQaADHKA8b8iQ6B27XY+0DYEZoK133EmNU8wXbtUhq5IQscTDcaOotdzR+1HPGcO9Q==
X-Received: by 2002:ac8:5851:0:b0:446:5fe5:5e6e with SMTP id d75a77b69052e-447cbf0276amr38482421cf.17.1720141119282;
        Thu, 04 Jul 2024 17:58:39 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4465143ac82sm65015101cf.43.2024.07.04.17.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 17:58:39 -0700 (PDT)
Message-ID: <6a8aee9425a47290c7401d4926041c0611d69ff6.camel@redhat.com>
Subject: Re: [PATCH v2 05/49] KVM: selftests: Assert that the @cpuid passed
 to get_cpuid_entry() is non-NULL
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 20:58:38 -0400
In-Reply-To: <20240517173926.965351-6-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-6-seanjc@google.com>
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
> Add a sanity check in get_cpuid_entry() to provide a friendlier error than
> a segfault when a test developer tries to use a vCPU CPUID helper on a
> barebones vCPU.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/lib/x86_64/processor.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index c664e446136b..f0f3434d767e 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -1141,6 +1141,8 @@ const struct kvm_cpuid_entry2 *get_cpuid_entry(const struct kvm_cpuid2 *cpuid,
>  {
>  	int i;
>  
> +	TEST_ASSERT(cpuid, "Must do vcpu_init_cpuid() first (or equivalent)");
> +
>  	for (i = 0; i < cpuid->nent; i++) {
>  		if (cpuid->entries[i].function == function &&
>  		    cpuid->entries[i].index == index)

Hi,

Maybe it is better to do this assert in __vcpu_get_cpuid_entry() because the assert might confuse the
reader, since it just tests for NULL but when it fails, it complains that you need to call some function.

There is also another call to get_cpuid_entry() in kvm_cpu_fms but this call can't have this issue.

Besides this nitpick, looks good to me.

Best regards,
	Maxim Levitsky


