Return-Path: <kvm+bounces-38514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ED3CAA3ACEF
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 01:06:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA57A188DDF1
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 00:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B9B74A0F;
	Wed, 19 Feb 2025 00:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GnO7XE5J"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8C02F2E
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 00:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739923611; cv=none; b=RCsSEo5Nx7E/Z0RlFSd8s5xlaSmPZgi2XlVjU18aYZPPkv7exkxsGT9Bkfeh4Wlxq/MdLtn+fpo+ZefcVfxsRfk8d3Lx4RH8R6VUgdR9CUQ1VoIWY7yB5odo2XsD2VXCqCx6p2QUCiKIil41+BllpGz7VXrgs/ADsdU1ELvG+yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739923611; c=relaxed/simple;
	bh=USwZfulwIDMh1T5ZPwasKIJKIlfuhWQDAc+3qNTvsJM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=W18pyq15t4pADFav6X6VB3Vm1PW48HTR/Lclj8HQUT2ui851fEhq4dux6QO3eF4d8ANbkeVy2tmnJr9PPBRx8FqvVRbZZl/3G50GBWdVgMY0uCeABgAtO70rmR0k3rxy3cq6dDGzz4fmbjx7dUWtuoDWue/wEKJW98QaZVHPeM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GnO7XE5J; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739923608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6RFL3SZXv5gl2kJFOfmaj2YV8nowEcUudo95xd1wH54=;
	b=GnO7XE5JCeylJ+zWHtrhW3Al1HcjMKEof/uz08B0VyUm/rIWiQ5OoF3ojPCplr1Ag9Ip8r
	2s4u5I/CJFvorvttTPgV32pRvEJSDZGb7ZQO8BGHdYUuJsghGcxRtgJWVEl1d9xLHmcDzz
	ssXOVA21GqxPnjvVYLnZMPKjQ8nAxw8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-206-OzW80gpANMSphBsQ4RfO9A-1; Tue, 18 Feb 2025 19:06:47 -0500
X-MC-Unique: OzW80gpANMSphBsQ4RfO9A-1
X-Mimecast-MFC-AGG-ID: OzW80gpANMSphBsQ4RfO9A_1739923607
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7c09be677e7so65527685a.0
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 16:06:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739923607; x=1740528407;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6RFL3SZXv5gl2kJFOfmaj2YV8nowEcUudo95xd1wH54=;
        b=eZhHWHIikgqGYA3f8BMwk8acCMTi7R0lA6FM3OTTLe43XCX6FVoZE7bkIWGvq9IEdy
         p074oqhEN0Vxu4xsBilPofVLTF4fOM7Bx4ZO4WATjljqYJN19gEzY3hhYXaPWg6RiWxJ
         bbGrjGhKgcIa9MlFR9d85nDkwsuja58PriM2AsiErktKOfMErmMbv0EaZCGv1zp9u6xD
         y9n1NOcgzQ/VOUoBEhTISJzxIfbju//Bog5MCrrKCl0HOQpMIAcHUNctYxyzX0uRKwVW
         yjeJZJgfaAxxvD74nllregJ2iGW+G1c429aWY0lsOKNcft58Gh42KUEpyJfJO9X9v3Rj
         Jhsw==
X-Gm-Message-State: AOJu0YztbyZELQlxL92ke5tNO526e6Sy0M+5JE66Camxjpxv/aIMfM7D
	xz12mXUNydVFjYd9aDphFUYPWP49hrrC/1J4Pbji4HZFAo5DAwuOp3HmuYk0XeKTGGY7PND/CS0
	0GGQUhR2iW/1lyRPa0hKY4IIIxeIlipYh4+mmlOpNC6VBdce9ggWuEsdNXc2CEXgVLguk4EuvGX
	EIlQ9MQbYr1lzGj43pHH/ehSpiN4uIxXxHvw==
X-Gm-Gg: ASbGnct1RcOTHheCdLMsHwryaa1jbz7KO4pdZIDw+OtAM40LcYjmtLa2nUnh8HlfJVK
	TTwBaS/AmwoPhmNvxcQmJJAC0vUYVu7bWtgfJfqL2CLkaS5M/HkNVqxf0hpjz97NI5nuLPg2m83
	5x83uFbFdGbme9QvM7ozi66RLvBPvzDXjtocMrSfRMeWLKTpxoH5SWHHnFvKmaA0EWXZnjz7SEX
	KD8ZcsSSckN5GJ51iD+EUyz2UB3pA7lNjuyeRtvvk0OoJ7gr3H9Z7JYIfGF79YvoFRTDQr8Grg4
	DK6R
X-Received: by 2002:a05:620a:468c:b0:7c0:9d54:bc9b with SMTP id af79cd13be357-7c0b4d22387mr317517385a.13.1739923605988;
        Tue, 18 Feb 2025 16:06:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFktPUfjFhXS9Jsmm8m8gDmUB45KZfDoMfpZYbroNwcngfbbX/FP6K804YXgOiQLQmuO/NoVg==
X-Received: by 2002:a05:620a:468c:b0:7c0:9d54:bc9b with SMTP id af79cd13be357-7c0b4d22387mr317514685a.13.1739923605646;
        Tue, 18 Feb 2025 16:06:45 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c0a80b8c67sm197292585a.109.2025.02.18.16.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 16:06:45 -0800 (PST)
Message-ID: <186facf21094071fef085a7b5bad477271b0be8f.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] pmu_lbr: drop check for MSR_LBR_TOS != 0
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>
Date: Tue, 18 Feb 2025 19:06:44 -0500
In-Reply-To: <20241002235658.215903-1-mlevitsk@redhat.com>
References: <20241002235658.215903-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2024-10-02 at 19:56 -0400, Maxim Levitsky wrote:
> While this is not likely, it is valid for the MSR_LBR_TOS
> to contain 0 value, after a test which issues a series of branches, if the
> number of branches recorded was divisible by the number of LBR msrs.
> 
> This unfortunately depends on the compiler, the number of LBR registers,
> and it is not even deterministic between different runs of the test,
> because interrupts, rescheduling, and various other events can affect total
> number of branches done.
> 
> Therefore drop the check, instead of trying to fix it.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  x86/pmu_lbr.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
> index c6f010847..8ca8ed044 100644
> --- a/x86/pmu_lbr.c
> +++ b/x86/pmu_lbr.c
> @@ -98,7 +98,6 @@ int main(int ac, char **av)
>  	lbr_test();
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
>  
> -	report(rdmsr(MSR_LBR_TOS) != 0, "The guest LBR MSR_LBR_TOS value is good.");
>  	for (i = 0; i < max; ++i) {
>  		if (!rdmsr(lbr_to + i) || !rdmsr(lbr_from + i))
>  			break;

Hi,

This is the other kvm-unit-tests patch that I have a ticket open for,
and I would like to get this merged and close the ticket.

Thanks,
Best regards,
	Maxim Levitsky


