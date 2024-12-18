Return-Path: <kvm+bounces-34019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 14FA49F5B13
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 01:07:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 558511626E8
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 00:07:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 458A81A0AE9;
	Wed, 18 Dec 2024 00:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SNKJBj5a"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9FB19D892
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 00:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734480196; cv=none; b=XVsISstPu8wNtJkaX75eReaHEX8me46/GFwhNibot5IqHVbd5udBcuo9CWO8XoX+nySLtTYnyNxRy1YztlbDs30DLC44gDstkYxtXNtPNyJuO0g0lf1mGopvxnd4/hjZMgHPKEm62CO1XUehfAW3E+RCx3HHTTDwLz7kVIsDTyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734480196; c=relaxed/simple;
	bh=dCJ50PBrPKca+uCIfbJcxjFM+AfbluTjYGrl7FsqjyY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iAsg3HLo7ErrlEkYYYsDWGQ9LXWUU6NEowHz4JCKbacjKKyFp1DXz3hht9eMQ9BH7N4fGXmud0Fd44Iq99bhaGBZ//wTUlYghXrqJ03f9P3oKGekvS7CJY50ERZC/uitAkE//u1lON9v3Xtnu6O2JDVQy1BF0hm+Lx5gAmfchRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SNKJBj5a; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734480193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=euCr6wi/cnWh3ZO95NgGNByJiDPswzoDdf0BlpgWP40=;
	b=SNKJBj5aS+Q7HBsJp55MhpmaoKBnY4wKVbEHOicDXxKqpRBDc2F+DUrfc2L4RxRGQKp/qw
	Leb0g90A6OcF4E5kZT3ITZLfY0YVKCv/p5ycSc8vuK+uApvjzm2qeh15UFBkGwjohY6n+G
	P8ScU8YuizdNGUdAHy789VEkpjAKtvE=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-K5lVlJfsMTmgTOlSS8ZqPQ-1; Tue, 17 Dec 2024 19:03:12 -0500
X-MC-Unique: K5lVlJfsMTmgTOlSS8ZqPQ-1
X-Mimecast-MFC-AGG-ID: K5lVlJfsMTmgTOlSS8ZqPQ
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a7d60252cbso2364055ab.0
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 16:03:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734480192; x=1735084992;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=euCr6wi/cnWh3ZO95NgGNByJiDPswzoDdf0BlpgWP40=;
        b=iBH3dJB5NBZ4MT6587VrO1oUU14rEsOdONnJudMoW4PEs1PwGh2jhzqN62qe3Aqtad
         rwMdFgR1U0Re+mMjAnGdsZwMkTh19pWwmu7S/c3l1ZsDszS2wDd/yrrBy23dq5SSh7bH
         KpH+X2wg7JbVHEG6WXTVWnDB2UeFzKzYfj6jBdAPwbH6IwqmVbyWLGIrFSXcJ3Zl3f+m
         7iiMUJND4Oi2ggLVF9eGb0UDzVMAdSMoGfXh4jdY6BCJnUjPNBPUTUeceI/S4S58f8qK
         AtwloNsE36Dt97I5IxvU/hCGu6riv8FcUOJorvsZcvEOlT+hEcRP5ORk7z8AEPw0K49x
         Yw1w==
X-Gm-Message-State: AOJu0Yw7gP6Rz8C0xqSU+cEmcJIkMqmJP203G7hVF1YGqh1vDBo8wK6p
	MBs2mpU0Q7MPxoIT5NEyz072Y370xBPMhiyeZ95dlaThQMEXfKVVDjwk/EurQGi933m9r72eCvn
	B+mtTZQM7sj1mCJmUPulUJOrGSByaYpVSvv3jo/DqRWNkM/K7/Q==
X-Gm-Gg: ASbGncvkt04puXcMa84uA5RQL7rMw8YUMe7cOegEqqoet277+vvlWjBiJSbIAf3meNy
	prM1Poh/swdwRje2QASFdaX8kjxxuaL88uCTSzuoZUg+I7g3RoTsYuJLJfRya5w7J3xijXYu+ya
	v3QzNK0kVwtoppT6mV2JN8q2Q5OXafhLiKHy0mm8q5EbSDPHUb+Is0FGYaW8EuQXi9rR1FpazNz
	ch/lwjsowAamopMrt4YW5qvJF1xGIkB5XZqUgl2VGl1uUDLsMIdbAFF
X-Received: by 2002:a05:6e02:18ca:b0:3a9:d0e6:abf2 with SMTP id e9e14a558f8ab-3bb0ac12780mr63506195ab.10.1734480191910;
        Tue, 17 Dec 2024 16:03:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF4yEcgdLBxwvTkvC/JJF6nW5pNHSx4+QXywD30kBwjYVYvsLZoVt5oDQEP/sYzY5g89o04Rg==
X-Received: by 2002:a05:6e02:18ca:b0:3a9:d0e6:abf2 with SMTP id e9e14a558f8ab-3bb0ac12780mr63505975ab.10.1734480191622;
        Tue, 17 Dec 2024 16:03:11 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3b24cf3add9sm23650165ab.62.2024.12.17.16.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:03:11 -0800 (PST)
Message-ID: <05e4e80281850efea857982f39f6848ff5e4594b.camel@redhat.com>
Subject: Re: [PATCH 19/20] KVM: selftests: Fix an off-by-one in the number
 of dirty_log_test iterations
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Xu
	 <peterx@redhat.com>
Date: Tue, 17 Dec 2024 19:03:10 -0500
In-Reply-To: <20241214010721.2356923-20-seanjc@google.com>
References: <20241214010721.2356923-1-seanjc@google.com>
	 <20241214010721.2356923-20-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-12-13 at 17:07 -0800, Sean Christopherson wrote:
> Actually run all requested iterations, instead of iterations-1 (the count
> starts at '1' due to the need to avoid '0' as an in-memory value for a
> dirty page).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index f156459bf1ae..ccc5d9800bbf 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -695,7 +695,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  
>  	pthread_create(&vcpu_thread, NULL, vcpu_worker, vcpu);
>  
> -	for (iteration = 1; iteration < p->iterations; iteration++) {
> +	for (iteration = 1; iteration <= p->iterations; iteration++) {
>  		unsigned long i;
>  
>  		sync_global_to_guest(vm, iteration);
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>



