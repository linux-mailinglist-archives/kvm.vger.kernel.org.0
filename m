Return-Path: <kvm+bounces-37118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47295A25584
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 10:12:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D06997A0F4A
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 09:11:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AACD1FBEB1;
	Mon,  3 Feb 2025 09:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AAfGQVgA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05F9179BD
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 09:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738573925; cv=none; b=X/23bIxh3LZ3TDYXvF4u1b80S4OeRUxvgVMw0SrUZ9Oq0yb1yD3tbdorSGwBWFbwyKHZR+eiMJ1MYs2020oH5xljfUTHiFbqkjRxRuRLDni8yXolR+BISkECXR/6WSjtUel7AUjs5I5pzS0v+LStX0UwpggPl+yXVpcd+Ntecx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738573925; c=relaxed/simple;
	bh=A6qL2lJK/Nom1zOt88cLkLCxXouorPkPyxiaFfqYbcc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ewicTKX5MBHLGatr4uinhnierQQWwuoQKU2GfyQPjyPToP/GPmddX937nFCuxzKb58op+pGjZ9cAC98DKnAkyK2ygoTq8b44yY2TN3wOXKVTvEFaJS37bziAQpXOkw5o86/XcRE276iMun6AZaKCMEo+n0xZIBWsyi7aBw7CURE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AAfGQVgA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738573922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=q03R5p2z5FXajymfIggRleHLWbUu4vhp/X+iL+8n9A8=;
	b=AAfGQVgA4KBddx+HtsCMoebZwyci8SBtqqcLgMIOMUEeydrmgNQSe1B1FySEf1W5ELBsUv
	hfkdKVHpPcWYqN+mSmSpD5r8jVFzwGWtlrYVTK4RpeRr6GN4ex04H53a/4PCnSvawQuoms
	Smmpx0xiTdrW/07mP4ulf30J+LHae8M=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-AAtS24EzN-C50CzkII0BjA-1; Mon, 03 Feb 2025 04:12:01 -0500
X-MC-Unique: AAtS24EzN-C50CzkII0BjA-1
X-Mimecast-MFC-AGG-ID: AAtS24EzN-C50CzkII0BjA
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-385e49efd59so1512563f8f.0
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 01:12:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738573920; x=1739178720;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q03R5p2z5FXajymfIggRleHLWbUu4vhp/X+iL+8n9A8=;
        b=jsVUVCAPqP+Nm5h6M6kSE/TvWr3wdfzkXOFotILU7l/BCueUskuofcau1kpvOBujD0
         cAj0Pz0nsCimMx6XPrsAmaioyCnSKXF4fKEnZm62+FFnASlZJKj+p0OX4WyKRA8mqUjv
         bC29CnONjBK486g/ws/lqx4fHZzxG3IREDIar71hUpfviZ1Wi4Mdyb1qbXnAd0uh1LnP
         Pvf7QVgiI4PYDT5VrOy+To/HN54isswIAAUSmr0d0hQ7JVCgv25hpLQP+FsA2kja8LKE
         DBChflvz4sG+oaPm7Gz/sE0Ax/T8fVLP6YBbIbW8HzH5FX7Ie9CGhFXF8FQ1UQnvEEb4
         4U9w==
X-Gm-Message-State: AOJu0YxSun99QsE4wtKCjoxx2h96MaDjfZbNaYAECIhxcUCpZ97j4WnR
	l3emTQ+kceaHDt129zxL2Vya6+TIkZg/1+TlgbJWwhwJVKyYsSwFnpnEzb+IHwEjLBq2EDZ9OQn
	0RgIX2asTGBe67ZBNrlCQ228P49jrJRVEibcjceNK7whTpcBlNg==
X-Gm-Gg: ASbGnctFvw9/tixXNKMZDag2U/DnXHiXQGcodL1bGLj/cUyMJgZonKccFidj7rpZWqP
	AVRYbfRuGpNVcTNwSawTFsA0R/CGTSlEw7xjLoCmE/pd7UWblmi4YJdDIZE2SU4eDG3CyLOA57j
	4uRI1cel1yJSmmtbPesRuJaZCf2yrJRIJltjZ8a3AOb2E59FaAmqXOl04SmIghMhF6/nR2Jvba4
	nhKCanxH7tl/NVDaJkz+l4pzg78E/Y/MH6/KuN/zFZC7/Ysnhs6sRC7PTwDuz3pS7RZ7tWgFSWE
	vr8lOc5jKhBSaDkhrGaqwTKm531wXw==
X-Received: by 2002:a05:6000:2c3:b0:38a:888c:679c with SMTP id ffacd0b85a97d-38c520a309dmr16900145f8f.42.1738573920069;
        Mon, 03 Feb 2025 01:12:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH/Pr5Qp6n+RD2Xx73vdE9kKWccLl0xo0m7ronXnRyfqQL4R5C0hR5ebw4VYl7Vxd2uWo2UvA==
X-Received: by 2002:a05:6000:2c3:b0:38a:888c:679c with SMTP id ffacd0b85a97d-38c520a309dmr16900126f8f.42.1738573919688;
        Mon, 03 Feb 2025 01:11:59 -0800 (PST)
Received: from [10.33.192.228] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c5c0ec315sm12060502f8f.4.2025.02.03.01.11.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2025 01:11:59 -0800 (PST)
Message-ID: <f8e9a3eb-bfd8-419f-8aa8-2bd94b2b2a4e@redhat.com>
Date: Mon, 3 Feb 2025 10:11:57 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests GIT PULL 00/18] s390x: new edat, diag258 and
 STFLE tests; fixes for genprotimg >= 2.36.0; cleanups for snippets and
 makefiles
To: Nico Boehr <nrb@linux.ibm.com>, pbonzini@redhat.com,
 andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20250203083606.22864-1-nrb@linux.ibm.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250203083606.22864-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/02/2025 09.35, Nico Boehr wrote:
> Hi Paolo and/or Thomas,
> 
> Changes in this pull request:
> - cpacf query function were reworked in the kernel, that fix was
>    cherry-picked by Nina. This fixes issues with possible incorrect
>    instruction format
> - Claudio extended the edat test for a special case with a 2G page at
>    the end of memory to ensure the correct addressing exception happens.
> - I added a test for diag258 where we had some issues with
>    virtual-physical address confusion.
> - Nina took the time to add library functions that help exiting from a
>    snippet s390x.
> - Nina contributed a test for STFLE interpretive execution. Thank you!
> - Marc did a lot of magic fixing issues in our Makefiles. This fixes
>    several issues with out-of-tree-builds. We now also build out-of-tree
>    in our downstream CI to avoid unpleasant surprises for maintainers :)
>    Marc, thanks for contributing your Makefile knowledge and for turning my
>    complaints into something productive
> - Janosch also invested some time to clean up snippets and Makefiles,
>    which made the code a lot nicer, thanks for that as well!
> - we have a compatibility issue with genprotimg
>    versions >= 2.36.0. Thanks Marc to fixing that. You should upgrade
>    kvm-unit-tests if you use genprotimg >= 2.36.0!
> 
> Note that there are two checkpatch errors:
>> ERROR: space prohibited before that ':' (ctx:WxW)
> I would suggest to ignore them, the code really looks ugly otherwise.
> 
> Thanks
> Nico

Thanks, merged now.

  Thomas


