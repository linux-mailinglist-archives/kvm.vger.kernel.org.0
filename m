Return-Path: <kvm+bounces-19495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43C69905B9A
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 21:01:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 500D71C21B4F
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 19:01:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C3C782D7C;
	Wed, 12 Jun 2024 19:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U7rBTd73"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5A58289B
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 19:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718218890; cv=none; b=MTlLL/WJEjnfthkFXtccxSpyfe1XsPy6D2HbOzv1KFiz3NhHi0+J5iqkE7cD8mwQaKePBEH4lavQOPsD+IS2PL5iJce6ZcFXnr2jCmhVu4ugflpg8syq0R+e1tEarydxNfqOMoVYaO7eNMfMSc33DRpH/1csBG3NR8cJprJLCKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718218890; c=relaxed/simple;
	bh=AseQd2+4j0qK8Epv3lD8diUdJD7Ug5tirMLr9oZymMY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=irfx14LUZB95E3dNOhLrxRdMymvKJob3HmwSM8oQlLHD7NBqlUdypj0gBcULkMszgXnHfeFCKlGiAznO4MA4qoCbMB8trNFthn6W7kTV0Pgtw1e8rN5VCW5gmUtD4fTgsbH83NYEd2INKZFnG26PnEcvQ6MV9u/BXJ/8lYExx/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U7rBTd73; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2c2d4ea53c7so953484a91.1
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 12:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718218889; x=1718823689; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vDtqfDjGLfYavvJSVhz3M2lQ76c0XqmZ/HVevtHn9Vo=;
        b=U7rBTd73bXxpFUkb5ogUBTd4OovbIbxmwODJbkJ2SvTU7cd4SPcGuimDzbhCdlIVDU
         xwKx5gfmcjI6NcJR/Uae+ur1BKABXic9YquTffh+Mqh235nSaSOfXkSnWnbtoSlsryn8
         QKxUIox8cnz3//8Up8lojiIVOsjP4ZUsVxddOPvCADVD6Wmmjf2s9d3yVIYnQ1XZWjws
         5V0M6F2INPIL1FBQ/ITQFq7kZn1X8lN3IJ5B7xNCcg3UOwJ6QPj2zn5gE3/4DBnXez0O
         qejGJAyIQfgqApgEh3Cx7Jw6irI9Wro1Ybz9YOT56v96vMkYZhueqx3RouJPjqUSX/9u
         Yvbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718218889; x=1718823689;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vDtqfDjGLfYavvJSVhz3M2lQ76c0XqmZ/HVevtHn9Vo=;
        b=U9WwcktResrBCsbK3QE8Y+2pA2IBrriB5Ob4EAZxovZALu9pqTLHxrzR1BSSdCrLrZ
         r4aJFdsO/I0RaEECLd4+lLQkuy17ORDK1QzOHuD+I9chyNgEqO3z3KFxpGJOOo+57UZz
         svuc57E8zQI1G9qy/byYsWJSMQzKTMU6fJ+FmOyAxw/31MnZDLhF+gJv3r5IYNepS881
         /UI0aVBdbL1kqp1ny+KGKdJ1JvCC4L4bNnSzbM4MSAPJp/O0aD/qJtiAs21fGWt9NTWc
         MqKJs73q7WBAkZCtCcRpGYOQ/FAFnz496eGKv8OnuKSLHeqhKoNfMpaxIF/cF37q6OwG
         0qqA==
X-Forwarded-Encrypted: i=1; AJvYcCX4lnN/dbCTdfq5R8cYYOhVLuKNDj9Od8XLXgFXyZWiKsqmjgpAwPUDo2CnVpiMNgJJIuJC6T5IgZrUP8OEmafrTXAl
X-Gm-Message-State: AOJu0YwYHlc6liJfjcWfAtB9FeANd+ZeQDhl/qSyX4CyYy1ReiaW7sBc
	VD04izXz6cZucKCpBBbKCPzMV7/wz0AhgSrJJKXJfb9XmkB7vo/BOf4NlomNDKpqWV5mofyqhF6
	MdQ==
X-Google-Smtp-Source: AGHT+IFQ7ZZ2aJGSa+6VejpbdfW55qBkZINR7dzx7tyQxsgiM7xFleXtXf+8F9N1D4k7cEdpTjyK5nSAVgc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:5904:b0:2c2:d12e:c344 with SMTP id
 98e67ed59e1d1-2c4bdb380b6mr2089a91.2.1718218888598; Wed, 12 Jun 2024 12:01:28
 -0700 (PDT)
Date: Wed, 12 Jun 2024 12:01:27 -0700
In-Reply-To: <20240612104500.425012-2-usama.anjum@collabora.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240612104500.425012-1-usama.anjum@collabora.com> <20240612104500.425012-2-usama.anjum@collabora.com>
Message-ID: <Zmnwhx0Y0qh0x03J@google.com>
Subject: Re: [PATCH 2/2] selftests: kvm: replace exit() with ksft_exit_fail_msg()
From: Sean Christopherson <seanjc@google.com>
To: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kernel@collabora.com, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 12, 2024, Muhammad Usama Anjum wrote:
> The KSFT_FAIL, exit code must be used instead of exit(254).

This needs more justification.  KVM selftests have worked just fine for 6+ years
using exit(254), so stating they "must" use KSFT_FAIL is obviously not true.

I'm not personally opposed to switching to KSFT_FAIL, but it is a potentially
breaking change.  E.g. some of Google's internal test infrastructure explicitly
relies on the exit code being 254.  I don't _think_ that infrastructure interacts
with KVM selftests, nor do I think that forcing upstream KVM selftests to sacrifice
TAP compliance just to play nice with someone's crusty test infrastructure is a
good tradeoff, but this and all of the TAP compliance work needs to be done with
more thought and care.

> The 254 code here seems like anciant relic.

As above, AFAICT it comes from Google's internal test infrastructure (KVM selftests
came from Google).

> Its even better if we use ksft_exit_fail_msg() which will print out "Bail
> out" meaning the test exited without completing. This string is TAP protocol
> specific.

This is debatable and not obviously correct.  The documentation says:

  Bail out!
  As an emergency measure a test script can decide that further tests are
  useless (e.g. missing dependencies) and testing should stop immediately. In
  that case the test script prints the magic words

which suggests that a test should only emit "Bail out!" if it wants to stop
entirely.  We definitely don't want KVM selftests to bail out if a TEST_ASSERT()
fails in one testcase.

> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---
>  tools/testing/selftests/kvm/lib/assert.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/assert.c b/tools/testing/selftests/kvm/lib/assert.c
> index 33651f5b3a7fd..db648a7ac429b 100644
> --- a/tools/testing/selftests/kvm/lib/assert.c
> +++ b/tools/testing/selftests/kvm/lib/assert.c
> @@ -87,7 +87,7 @@ test_assert(bool exp, const char *exp_str,
>  
>  		if (errno == EACCES)
>  			ksft_exit_skip("Access denied - Exiting\n");
> -		exit(254);
> +		ksft_exit_fail_msg("\n");
>  	}
>  
>  	return;
> -- 
> 2.39.2
> 

