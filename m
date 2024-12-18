Return-Path: <kvm+bounces-34014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A24DD9F5AE5
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 01:02:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A498B16A77A
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 00:02:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EDC614F9EE;
	Wed, 18 Dec 2024 00:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X0+yxISe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0AE3E47B
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 00:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734480112; cv=none; b=Ljysdr2fN0hjUMVO0whwRhtIkOYGD7m62Oj+J8UbZH7GWOdf7r1LgSk87RnyiiIMu8QeqjDIyK2bGti60cDp6lEqv6/t5WIu8xRg27/bAa/MLyofpciCSAZC+gqwGI428K51BhsWfFxPTnbrRFp9xsf6oX+9bG6Y9rdlvjqyCH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734480112; c=relaxed/simple;
	bh=RPV8NHETpwZrch0i9HHKPge5aSu8SMdjDOs4Cf7tn0s=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gcRQDxVFDsMt5F5oVlzmBSCiO8BSHmH5PJiw83B4Id9i6uaynCYQmDRK2PSzz4De4gR5FKFYfhA0UAeNXtbGaEY1he01kByS0LEMkYoiUUzvkTFeT+3SjXKHgcfAelafHDWB9gX+WSmZkvKWP29/GfbDzZyVzivNNrRq1nnQ1NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X0+yxISe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734480110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sy0SEHtU7ymBdc8kQss3/cZ8WyWlAJFyiuBskKegsD8=;
	b=X0+yxISe609yR8Nk2WafiXA+TeDqUKQlLjItvAyHhxOXvdsaRtoxX+f1sG7yvQZTI04+iP
	etwTTsd0A7Ec/U1ilCqF3+smv9zs1tZqaolY42ZlvPbV+eLM09U4wQb4MCivL+k7L04RMf
	w4VycmTWr3rWUK+fw2yNayff2EXqQyU=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-Iva2_BXqM8iOVLaSeIhvpQ-1; Tue, 17 Dec 2024 19:01:48 -0500
X-MC-Unique: Iva2_BXqM8iOVLaSeIhvpQ-1
X-Mimecast-MFC-AGG-ID: Iva2_BXqM8iOVLaSeIhvpQ
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a7e0d5899bso121398685ab.0
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 16:01:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734480108; x=1735084908;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Sy0SEHtU7ymBdc8kQss3/cZ8WyWlAJFyiuBskKegsD8=;
        b=JaIjA7EYoR0gzZKkVp0pa62cKSF8SZqhaYr4MhdeHwpByuduwB8HusZEUu1yMvT41G
         P8Pb0lTwL4FowgBWcWhmCm7hzb20okLDNFhg8C53TB/kDNXWYqHl9Z0U41mlXxmOnO6A
         6PQlwa99Qjwu8Z+b4Ytvc1Hhr/pTPObU+Uqh9VRbj6QShM6SX5TWsXvvkDmhPWCjZYCF
         VERFvZknmpWvGl3hdL40w3viSp//hyXZWJOyFQDPzt3hQn7nTCaVWwWAT4HtJSq+oxY/
         uP8wdFoWoetm18m6X/YVFtlYwW4puvzYsG+Fc7EtDhn5QL+efelc+wToR6iKvJsbIX//
         9cdA==
X-Gm-Message-State: AOJu0YzxUHfE4wFyjp7Gpq43qRuLJWCxXV3bhwuVmbzMOAziJWX0qN6U
	tNQ/EYIyIsJueHD9OeYJx38uzIkMq6IY17F5EyuY5ztWQEqaMOyJvO7hKrjYlpscZZe1EpBQRcj
	QSlALW7doqaqBVojUAjqiTYyaQ7X2rAL5XfJ7cuT272RbwP0yMA==
X-Gm-Gg: ASbGncs9GgSNYK2pt55sK5iyKGm/pSYDJUvg9s/dNk+G9vBJ7xMFVIccRUCZjTYNKxF
	gs4G4QxYMRDahZOFZV3GMzZRhyRCMUCdeyo5NoUJqVQ5c0NNFHSIrRGxzd4q7+UXn8rpNMgVxW/
	YEAvZ/ohzdSlMbCCSejGfavhXI9oxka/gxZO+OkvZtf4AxWHAa4W7D3HKH8xTHExOv4j1iVOhNr
	q/J1OJDf6ZaVPFZWXolPAcutzE6MRCNT6KtB5seqc2I8RqF8xhLhCxq
X-Received: by 2002:a05:6e02:154e:b0:3a7:e0c0:5f27 with SMTP id e9e14a558f8ab-3bdc003ea1bmr8673765ab.2.1734480108082;
        Tue, 17 Dec 2024 16:01:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGqtSauAxLKaUv+ErPKawDuRLvkDraDsEBvKGe7S9rN3lJjO5tHsFC+fcSFJpA5qzRD6QhHCQ==
X-Received: by 2002:a05:6e02:154e:b0:3a7:e0c0:5f27 with SMTP id e9e14a558f8ab-3bdc003ea1bmr8673535ab.2.1734480107802;
        Tue, 17 Dec 2024 16:01:47 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e5e378c1f9sm1895487173.134.2024.12.17.16.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:01:47 -0800 (PST)
Message-ID: <57871d28eeda31c34ce10f60b55fe6cc9c137748.camel@redhat.com>
Subject: Re: [PATCH 13/20] KVM: selftests: Print (previous) last_page on
 dirty page value mismatch
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Xu
	 <peterx@redhat.com>
Date: Tue, 17 Dec 2024 19:01:46 -0500
In-Reply-To: <20241214010721.2356923-14-seanjc@google.com>
References: <20241214010721.2356923-1-seanjc@google.com>
	 <20241214010721.2356923-14-seanjc@google.com>
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
> Print out the last dirty pages from the current and previous iteration on
> verification failures.  In many cases, bugs (especially test bugs) occur
> on the edges, i.e. on or near the last pages, and being able to correlate
> failures with the last pages can aid in debug.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index d7cf1840bd80..fe8cc7f77e22 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -566,8 +566,10 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
>  				}
>  			}
>  
> -			TEST_FAIL("Dirty page %lu value (%lu) != iteration (%lu)",
> -				  page, val, iteration);
> +			TEST_FAIL("Dirty page %lu value (%lu) != iteration (%lu) "
> +				  "(last = %lu, prev_last = %lu)",
> +				  page, val, iteration, dirty_ring_last_page,
> +				  dirty_ring_prev_iteration_last_page);
>  		} else {
>  			nr_clean_pages++;
>  			/*
> @@ -590,9 +592,10 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
>  			 *     value "iteration-1".
>  			 */
>  			TEST_ASSERT(val <= iteration,
> -				    "Clear page %"PRIu64" value %"PRIu64
> -				    " incorrect (iteration=%"PRIu64")",
> -				    page, val, iteration);
> +				    "Clear page %lu value (%lu) > iteration (%lu) "
> +				    "(last = %lu, prev_last = %lu)",
> +				    page, val, iteration, dirty_ring_last_page,
> +				    dirty_ring_prev_iteration_last_page);
>  			if (val == iteration) {
>  				/*
>  				 * This page is _just_ modified; it

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


