Return-Path: <kvm+bounces-34020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97CDA9F5B14
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 01:08:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6761D188458B
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 00:08:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D065D70817;
	Wed, 18 Dec 2024 00:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I7kOSCkQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F9D3596D
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 00:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734480206; cv=none; b=rZSMQb1Y76McyXgtg6KJ6SFkdTObmdJjdKbrgjNllhzGEQvDZMqJMLyFLPU2vU1g40xMH4ezxwlsdYkms9u0l3hXznb+PXyOuaLJeG6OdtC6LgVdMfqCu/UNV+z1m1G66lOTiShwfqbzHpg4zz4fYT7Kf8szIZ/ckyaaFIjNalY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734480206; c=relaxed/simple;
	bh=NSMSQX69n+ZOWKOumU9eGjQjw6XAhiIIhUWYBTncc18=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nZWu8NNyFdVM4DI3ehI48JW9vU40vExIMOMh/I14ZUQpaEQzt6vkEcaeAreO1xZe04hAN17gDU0SiyAbAptS0eeBV4y1oNIjNE70HNJ5BMuNlOWVdDe2LdUw96DAhPcxlpFLa1z1IwMDgWh8c4GKNj7xqvwH2itytJY5Iot50TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I7kOSCkQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734480202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VvmJ+CqaqeToMgMuDFmCeT3MDz3+kzBsmlyYC/rHsN0=;
	b=I7kOSCkQTrQWvmSUYS4P15bKZVBF71aQAzHs1ia8wkMNbisqDYKMuZYMMKGq+v9rzK8x1k
	caBXgjhRlQVz5PhqhzZm+MxK+0sqb+4fcSVyTn7k+Exs4nuussxzdNZwoh+vX8Yh/wZuWH
	onwDjTRPBw+zYr+N3Gompu7+pOQFQpw=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-MGF79KeOOgyYpTOuRFa4wA-1; Tue, 17 Dec 2024 19:03:21 -0500
X-MC-Unique: MGF79KeOOgyYpTOuRFa4wA-1
X-Mimecast-MFC-AGG-ID: MGF79KeOOgyYpTOuRFa4wA
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-844e6476afeso416918939f.0
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 16:03:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734480200; x=1735085000;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VvmJ+CqaqeToMgMuDFmCeT3MDz3+kzBsmlyYC/rHsN0=;
        b=p0f+7C6W6Z+ObjHSkzFlo2CK2atGzwH3B3AyCGXMD4lHKt6XdECOkbg7L+HCgu8dz1
         cNPn2oLsynAqzALuYIuVnbOvpWMC3kwxJZVpyVTDa3bkNplg4Fs+A3UebhKuspiK4oYo
         j2/f+Gd5Oq9BIIho697RTN1Z1Vga0oZbmPF2uAXwVpjo54rtzmt07yCyzlvHkoeRlhk8
         45WkmjI5SGJCamgc6wZOeOkHG6afOPE0oUa7cBnewCE8hJqKkHzmCa0zYWtc1LbWhPUi
         qZwTIZ1dtR0VuSqw+so7nzEzXSYmU9juvKluleZjSh1Lrrx0CqRsgPIc+dvRGpii6Y0m
         QzWA==
X-Gm-Message-State: AOJu0Yz+mTo5cVlhqIUX2WGV3N0nwZM3U+dDDyGHoMrrADLn1wG864iB
	xUr5zHbFGf8rpi80ctkoEjBzqEv3CjLKZBa9MYPTAZL1sun4cB/GDAhucYY0TEAUR3Uj0KYZb95
	B1L7W/cqHsqX9V7Pz47sYBYv5AH0BmZH1UjPhLNtqLofM/xKS1A==
X-Gm-Gg: ASbGncvJuCplh8i342QEgfQC67yWbnKSU0u7ajJkQLcuhJFOSkXvkOfm+CnDT7EIEWS
	3dBREo+qSrZ/FYW80VaHQtqT1T7OQGk0fIdH25h80iMzoymSpzu6LCoDULh6HsWkGCcW4lIG3fL
	0DV3ZnYOqYGpVJ2hmSRpOkEODp2tjxeTtBxoRvS3nsU77b0kp9wWZxBf9t0MNaqtXDcermrWdNW
	0wKfXvqmTNvIkSxHz5IruK3Ie6cK9/a27hPN3lhgsSYacv6XYE5s4oI
X-Received: by 2002:a05:6602:14d0:b0:835:4b2a:e52b with SMTP id ca18e2360f4ac-847585d72bemr82149439f.10.1734480200464;
        Tue, 17 Dec 2024 16:03:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEfpU/btENnVM27N0VJ4nHbdYuAaCJ/rQA4svcBFZjOZUVMhayktZikmu2cS2T/Nonrx/K5Kw==
X-Received: by 2002:a05:6602:14d0:b0:835:4b2a:e52b with SMTP id ca18e2360f4ac-847585d72bemr82147539f.10.1734480200147;
        Tue, 17 Dec 2024 16:03:20 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e5e3b754d9sm1941942173.144.2024.12.17.16.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:03:19 -0800 (PST)
Message-ID: <2587c4e8d912b461e793155e7749d0e03067b0d6.camel@redhat.com>
Subject: Re: [PATCH 20/20] KVM: selftests: Allow running a single iteration
 of dirty_log_test
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Xu
	 <peterx@redhat.com>
Date: Tue, 17 Dec 2024 19:03:18 -0500
In-Reply-To: <20241214010721.2356923-21-seanjc@google.com>
References: <20241214010721.2356923-1-seanjc@google.com>
	 <20241214010721.2356923-21-seanjc@google.com>
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
> Now that dirty_log_test doesn't require running multiple iterations to
> verify dirty pages, and actually runs the requested number of iterations,
> drop the requirement that the test run at least "3" (which was really "2"
> at the time the test was written) iterations.
> 
> Opportunistically use atoi_positive() to do the heavy lifting.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index ccc5d9800bbf..05b06476bea4 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -880,7 +880,7 @@ int main(int argc, char *argv[])
>  		}
>  	}
>  
> -	TEST_ASSERT(p.iterations > 2, "Iterations must be greater than two");
> +	TEST_ASSERT(p.iterations > 0, "Iterations must be greater than two");
You didn't update the assert message.

>  	TEST_ASSERT(p.interval > 0, "Interval must be greater than zero");
>  
>  	pr_info("Test iterations: %"PRIu64", interval: %"PRIu64" (ms)\n",



