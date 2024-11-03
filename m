Return-Path: <kvm+bounces-30428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 88C539BA83F
	for <lists+kvm@lfdr.de>; Sun,  3 Nov 2024 22:08:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 10593B211BE
	for <lists+kvm@lfdr.de>; Sun,  3 Nov 2024 21:08:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C32018BC27;
	Sun,  3 Nov 2024 21:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I+OUu+88"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BD515C14B
	for <kvm@vger.kernel.org>; Sun,  3 Nov 2024 21:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730668127; cv=none; b=jcTLqS2dt3nl+8p7Sfl+CEo6CuWUT4OOqDiXowgffN72KfLLJez0nDQWkFj3o/GI6E8qx0AFD/E36+2FcXwJRJh13XXP9raDPyv6fZVajR+HVZvKAZMJTDivwiaWSliED//zvnrkKNw5dbSLek5nvINiDB0OwWmP1lP5oZt8FPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730668127; c=relaxed/simple;
	bh=+8v+ggopx/XqPhgfLrK3Us50u0pOgwDpfv7iovs2Jjs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TyNreLEeCq2XtLfcAqJWTsXk9dQtDnbREDHqu2ltqRnxLY4Q8+Rh4Y75wQMkyunFNMkgOi63OLo/TfaatM4XxgSPLxsLdj6Tccs7LVt9FVU+cKIXSMobmsIYKiUXfoCYmOWPmjKitUVb2pRFfkgTv+a2e5COlK+GtnvLoPRReQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I+OUu+88; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730668123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sHvOPnUVhJl58EReDLGQJOJD3YNbsS7PeX8Cqm5yVsw=;
	b=I+OUu+88kTHFnPUsZf+12RBAtbM2SgzjF9awlptBLbIpGKk2IbpjfCjFyZ4cNwdmvb+jqf
	gOlqbBMwCRAu5OCV0mR48cKeqcHZJm0NEyPV+qWi5EGq5gRjoUOnCZDcQlz907qdszFF9n
	N0w3/04RzvVr+PZTw+pBYpilcU3xbvA=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-ZTvvlDnJPNuH8NWHIb20Zw-1; Sun, 03 Nov 2024 16:08:41 -0500
X-MC-Unique: ZTvvlDnJPNuH8NWHIb20Zw-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7b154948b29so681668485a.0
        for <kvm@vger.kernel.org>; Sun, 03 Nov 2024 13:08:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730668121; x=1731272921;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sHvOPnUVhJl58EReDLGQJOJD3YNbsS7PeX8Cqm5yVsw=;
        b=e2egkCRfyIqDqaspcWdbxkrVJSeIA+vMxpWdLgIhmyC29/9cbztXVxdaqnz/gasAxq
         Zt96xaUiNQUlP2NGTVDCouQHC3mBibtRfgQAUHEZ6BGNY8x0eiy/xxMk7a2LwevVUBjb
         YjYGLhty2cTRgBplzrhrAcf5v4ENNkJ80W+JZPsJul1n97Sww669nfTK7/+Gi3R+7HBj
         jquvkWJrANTbLV0pHe+NBQ0JUaJrR/JFPoMX2n6aTjejxT3Q7tCmWKgiJS8Dyh8y2Iuu
         uI8YqUHwItcRW9uGZna7yW2giVIf0yH6pnaGp1cgjR/Kwhpeu2W/yJaOT39w44KC4C2i
         w5oQ==
X-Gm-Message-State: AOJu0YylnXK82xhuJil1jnaC6jwxsanPLOdQDjbbYHphPTjO7phzi+jd
	djkeW5P04fVc7FR7vo4fEOyMrC5jO3XLWRZiFnkaPyI1M70DS7EjNn9VQJOsqbZCk9AqlQy2bvg
	ti/e/YAtU7t20n+8bS+nlVP4pea/oIpXxf0X6W/3zPCh1H8V6HtDEQe1KOAWLJHVL2foGKehfdu
	+qHSE+U3ISPdnuayWWCxfwPDuu5wNwaKnPmw==
X-Received: by 2002:a05:620a:4503:b0:7b1:4806:351f with SMTP id af79cd13be357-7b2f2555e72mr2085228085a.59.1730668121132;
        Sun, 03 Nov 2024 13:08:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHEysVg5hjCDPNL4Ud2Z3GLPTfS7LYnvafrxT9IBp2QnKCwdPgapyjiKvbuzQjlTpPeQfWffw==
X-Received: by 2002:a05:620a:4503:b0:7b1:4806:351f with SMTP id af79cd13be357-7b2f2555e72mr2085225085a.59.1730668120683;
        Sun, 03 Nov 2024 13:08:40 -0800 (PST)
Received: from starship ([2607:fea8:fc01:760d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b2f3a82e77sm363541685a.105.2024.11.03.13.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 13:08:40 -0800 (PST)
Message-ID: <f13e0e2b7cb68637ceb788f5ca51516231838579.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 0/5] Collection of tests for canonical
 checks on LA57 enabled CPUs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>
Date: Sun, 03 Nov 2024 16:08:39 -0500
In-Reply-To: <20240907005440.500075-1-mlevitsk@redhat.com>
References: <20240907005440.500075-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-09-06 at 20:54 -0400, Maxim Levitsky wrote:
> This is a set of tests that checks KVM and CPU behaviour in regard to
> canonical checks of various msrs, segment bases, instructions that
> were found to ignore CR4.LA57 on CPUs that support 5 level paging.
> 
> Best regards,
> 	Maxim Levitsky
> 
> Maxim Levitsky (5):
>   x86: add _safe and _fep_safe variants to segment base load
>     instructions
>   x86: add a few functions for gdt manipulation
>   x86: move struct invpcid_desc descriptor to processor.h
>   Add a test for writing canonical values to various msrs and fields
>   nVMX: add a test for canonical checks of various host state vmcs12
>     fields.
> 
>  lib/x86/desc.c      |  39 ++++-
>  lib/x86/desc.h      |   9 +-
>  lib/x86/msr.h       |  42 ++++++
>  lib/x86/processor.h |  58 +++++++-
>  x86/Makefile.x86_64 |   1 +
>  x86/canonical_57.c  | 346 ++++++++++++++++++++++++++++++++++++++++++++
>  x86/pcid.c          |   6 -
>  x86/vmx_tests.c     | 183 +++++++++++++++++++++++
>  8 files changed, 667 insertions(+), 17 deletions(-)
>  create mode 100644 x86/canonical_57.c
> 
> -- 
> 2.26.3
> 
> 

Hi,
A very kind ping on this patch series.

Best regards,
     Maxim Levitsky


