Return-Path: <kvm+bounces-27899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3307198FF4B
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 11:05:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1AA22807DD
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 09:05:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6084146D7E;
	Fri,  4 Oct 2024 09:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dHaQyyoH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A1A146588
	for <kvm@vger.kernel.org>; Fri,  4 Oct 2024 09:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728032729; cv=none; b=n5UdwaCTHLhhIKwNusrAYggb2/pXM9oJPKAlCsOjlvCny9JQ9hGOR82UEyXMQcw38OJjGqo4UT+IIuT4nmgUn7F8iloZkKLf9AttWBUuTty57xsZqiShWKDGCfbhGP0ydBdns3endqgUwVhfROps1Ff/5g/23u3/5fjOCzmDmoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728032729; c=relaxed/simple;
	bh=Sq4OcjY0EeQRIC1hZSJmdjUw6cPr6dDZEOS3Jwdd+DI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Df4Gz8OJgBbAXfMOuafgmWIe9ECCBNoEM5D0tH3y0dBabj9lvpyjEY1sBkGpoGua07gdIcc/mx41G6CegAdM4E5oTQtc9SQBltP+Pm1OdyyNwX4WQucRAoFsPL8exDujP9tDr9Szh8Q7P5G1s5gRIpFH28YRI0t+F3TSV+SNBio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dHaQyyoH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728032726;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+34TNPttbqJWXuUaZlwkoaWIFsW5o7Y4R1pY/2NowPU=;
	b=dHaQyyoHI59FqUxtM0OP9D0ai1NDrjOIPxiqNAjlSk/TusMfYWQGLaK+8VJCnecFEfOaCs
	/EhAQXFFxXkM8LIGY6zhfxO2T/I38T3FOH+qPkjvgCrRUSGdRuGGm6WHUYDM2KappxFVEP
	Rar18fDmGm99Xk/NrbpSJvAa4yDUkoc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-670-OVoPDMfGNLKVgGU97sAAfA-1; Fri, 04 Oct 2024 05:05:23 -0400
X-MC-Unique: OVoPDMfGNLKVgGU97sAAfA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-37cd1fb9497so1451302f8f.1
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2024 02:05:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728032722; x=1728637522;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+34TNPttbqJWXuUaZlwkoaWIFsW5o7Y4R1pY/2NowPU=;
        b=d4MTjxRpDsyMHaKjDhfcBe6DkzFd7U+ExKM6dlU/tzBMfJ9wl5GYTnkLlxmx7eV75/
         Q7pxo6xiFa8zQz/QaI+5Uy/XGosxUkxMinyNMXa2xvb3jfezukbuX4KDIpKUJrWsMcNW
         ujEK21iVWh1ra4MDTsqxRUmpw0COT/gPveQ80CMPV8H3VZEHEWatGR9vQokqKmHlCeNm
         3WVlLQ1YX+DIkDl+p5bGwIR3qBUPCzkl7f/iz86rKQ34BanVchRl22bm0ByogJtVepbe
         D+9ikjgIgpMBPRemhSIlBlCzKeJYyVyqf3ibGkhDAaQ5EXIcw+l3N8Ov24PKM2iEhn0O
         4R5w==
X-Gm-Message-State: AOJu0Yy+RlbaEBbNMXPOxgKd8CJeoxhDFIe0oXXfQLzCy0tnZrHyx3aL
	jioeDqYFQbkN8SRm9LCbvcDjq94P+l4OWBSPjtpQI7jX6N13vhOMk0Ru6tmEmuknYCFT+ZVQgY9
	cl1DCpz7YIW+Py6fUqNdY+2VofbOr2dJPAtn+DuaehiKkQfbKMg==
X-Received: by 2002:a05:6000:1884:b0:37c:cce8:4acc with SMTP id ffacd0b85a97d-37d049ea723mr4822645f8f.13.1728032722407;
        Fri, 04 Oct 2024 02:05:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHZI65a4E0MWEudDsjrxjK4F+K9QmGtEmB+a+SuWRzGXeJWhv4eMOaxMFsitqPTzNLlOrah9g==
X-Received: by 2002:a05:6000:1884:b0:37c:cce8:4acc with SMTP id ffacd0b85a97d-37d049ea723mr4822609f8f.13.1728032721982;
        Fri, 04 Oct 2024 02:05:21 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42f86a0afc1sm10545735e9.1.2024.10.04.02.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2024 02:05:21 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/11] KVM: selftests: Drop manual CR4.OSXSAVE enabling
 from CR4/CPUID sync test
In-Reply-To: <20241003234337.273364-8-seanjc@google.com>
References: <20241003234337.273364-1-seanjc@google.com>
 <20241003234337.273364-8-seanjc@google.com>
Date: Fri, 04 Oct 2024 11:05:20 +0200
Message-ID: <87ldz4i6gf.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> Now that CR4.OSXSAVE is enabled by default, drop the manual enabling from
> CR4/CPUID sync test and instead assert that CR4.OSXSAVE is enabled.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
> index da818afb7031..28cc66454601 100644
> --- a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
> @@ -27,12 +27,9 @@ static void guest_code(void)
>  		[KVM_CPUID_EAX] = X86_FEATURE_OSXSAVE.function,
>  		[KVM_CPUID_ECX] = X86_FEATURE_OSXSAVE.index,
>  	};
> -	uint64_t cr4;
>  
> -	/* turn on CR4.OSXSAVE */
> -	cr4 = get_cr4();
> -	cr4 |= X86_CR4_OSXSAVE;
> -	set_cr4(cr4);
> +	/* CR4.OSXSAVE should be enabled by default (for selftests vCPUs). */
> +	GUEST_ASSERT(get_cr4() & X86_CR4_OSXSAVE);
>  
>  	/* verify CR4.OSXSAVE == CPUID.OSXSAVE */
>  	GUEST_ASSERT(this_cpu_has(X86_FEATURE_OSXSAVE));

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


