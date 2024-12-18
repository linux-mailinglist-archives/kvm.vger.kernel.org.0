Return-Path: <kvm+bounces-34013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CFC519F5AE3
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 01:02:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC31E7A55AC
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 00:02:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8898F148838;
	Wed, 18 Dec 2024 00:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cJM7yZ9c"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092853DBB6
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 00:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734480108; cv=none; b=r81JkfXT0Mm67eOS2f5h7NJRdhwpGShAkNCzDgGJcvspmDKdG2uEPf5VIFzNC5Sh4DuvUl/9u3/+cAfhHtuMdfzS8pir1boVmuXWFoP8NLivEEGBxRDyqSmEmo1tPXHbMqIQ9DTeExwucaUnQD6tIdx2LRoDQgP9+s9wbJKTEGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734480108; c=relaxed/simple;
	bh=JiXlXiUjE1IBrDYN/SUtdzXJkxACykOuXaw93Gy2l9Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GU7syaKpQu83On4dX5z3A/Nw5+uIncFVV10BWkszKJA7svbx5Ffknz5DbRxBkHpI1gJkeMmgLjl8tAOBqB/pUKR8KqzFu+HxGziNK2BCzJM6AtHxzUDJXFymgDdim5AxWbnzX9fNCPKlZV6e4xHCOvkLObhmwEgwAfkEg0jHrb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cJM7yZ9c; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734480106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UsNVKjOASwq4KE2b1hXrv9KRHdzcUQ3w6sF0EtrACnM=;
	b=cJM7yZ9cku23Evv1u7w1UlQlBu4BYz80321i+kkDXJsQVfD7Bc5O9VdtLsnrpEA3z+ZF3n
	9rOyxN7tmMxxOM9+bWSgHAsi+TJQDaRK95RWDP9OljNOXdw+u7O6harucBVRdWv4BxUwTV
	bTtBdi4mxRB0rAJBDJFjYQp2kb7ugLY=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-mmBt1iNUNMeUzdfvObwSBw-1; Tue, 17 Dec 2024 19:01:43 -0500
X-MC-Unique: mmBt1iNUNMeUzdfvObwSBw-1
X-Mimecast-MFC-AGG-ID: mmBt1iNUNMeUzdfvObwSBw
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a814c7d58eso56872285ab.1
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 16:01:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734480102; x=1735084902;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UsNVKjOASwq4KE2b1hXrv9KRHdzcUQ3w6sF0EtrACnM=;
        b=KbDkSITLM5STF/piOaPtzWPg9OKAakVnQyxQXOS9hZeVa5FvLNInhU6wI3A2G3DjfF
         GCXrpkEWeaBMDfBBpF7PguUZJ2cQVbCVwhKzFg2ugm1dgpGHGic7tI+8nCC0M6ZbWNRb
         9DVXc0Siv0BZ0yiBXnzBmxin6HZYEr2un2Ov/roup2yoSvAInjORjg1Iv8wWH1dHWMhk
         HKSrTlQxTRuKy9TA3NQcnISx6bZK1NtshLj6O5/oO5g3lv9mOmZIy3MJR4e7uuMhHHY3
         DP4gn4SGAnQjr5SROpaunqZJL5GrmoRZ473LVLFkSFO+4YQKGdaokJ05tPYu1JutjPaH
         ffDg==
X-Gm-Message-State: AOJu0Yx2nJZWQCy2qwYEP0BXT4Bo6ARhk5p50o+a0Ok/b3a41oILg1++
	SbUxpgSq6ktZoxUK5zEdaG4Sn0vm+/Cy7bAV7kH2b7OepnGK4kSXCXGVnC3VxJfGAS66RAcahQR
	BZfxZmA1y6mBh6rUJP/s1B9VioxMMs9zzV5nkjoUvF35UF3RFBA==
X-Gm-Gg: ASbGnctBrS+gbxdYCaW7fk4m5LG+uBco11gAM6gq9AInMEGgX34Z0ddPyQP1hQiSvCX
	UHzx2Y7e/6LVF+dPTzdO6IGViVG5nsbNrxNzabM7+IQ8R5jQjcimL5Q0e+B15CgllgJjFY7wEk/
	DszEiPsZtYdKKGAPzAVgqzCb0YWgxQ0pswoLzI8URb3uuFNEenkv01w97/dhIXEQsBVg030aL+R
	0nAh/MTRS0+z13dBywEtvfZ9NZQdBVJsVEKjVIl+GJE9NTN8SoVMi8M
X-Received: by 2002:a05:6e02:1fc9:b0:3a7:a29b:c181 with SMTP id e9e14a558f8ab-3bdc174e846mr8418885ab.13.1734480102327;
        Tue, 17 Dec 2024 16:01:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG8jQmSd1gG/4Nn/wyVkdbfoq9bmQI4O7K4i7SmgMIXP2ob4+QZ7XfyCxcc/tjBWRqzF/FwAQ==
X-Received: by 2002:a05:6e02:1fc9:b0:3a7:a29b:c181 with SMTP id e9e14a558f8ab-3bdc174e846mr8418615ab.13.1734480101878;
        Tue, 17 Dec 2024 16:01:41 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3b248132048sm23388435ab.17.2024.12.17.16.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:01:41 -0800 (PST)
Message-ID: <44e222665405cd334e3da170c076de704084054e.camel@redhat.com>
Subject: Re: [PATCH 12/20] KVM: selftests: Use continue to handle all "pass"
 scenarios in dirty_log_test
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Xu
	 <peterx@redhat.com>
Date: Tue, 17 Dec 2024 19:01:40 -0500
In-Reply-To: <20241214010721.2356923-13-seanjc@google.com>
References: <20241214010721.2356923-1-seanjc@google.com>
	 <20241214010721.2356923-13-seanjc@google.com>
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
> When verifying pages in dirty_log_test, immediately continue on all "pass"
> scenarios to make the logic consistent in how it handles pass vs. fail.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 8544e8425f9c..d7cf1840bd80 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -510,8 +510,6 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
>  		}
>  
>  		if (__test_and_clear_bit_le(page, bmap)) {
> -			bool matched;
> -
>  			nr_dirty_pages++;
>  
>  			/*
> @@ -519,9 +517,10 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
>  			 * the corresponding page should be either the
>  			 * previous iteration number or the current one.
>  			 */
> -			matched = (val == iteration || val == iteration - 1);
> +			if (val == iteration || val == iteration - 1)
> +				continue;
>  
> -			if (host_log_mode == LOG_MODE_DIRTY_RING && !matched) {
> +			if (host_log_mode == LOG_MODE_DIRTY_RING) {
>  				if (val == iteration - 2 && min_iter <= iteration - 2) {
>  					/*
>  					 * Short answer: this case is special
> @@ -567,10 +566,8 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
>  				}
>  			}
>  
> -			TEST_ASSERT(matched,
> -				    "Set page %"PRIu64" value %"PRIu64
> -				    " incorrect (iteration=%"PRIu64")",
> -				    page, val, iteration);
> +			TEST_FAIL("Dirty page %lu value (%lu) != iteration (%lu)",
> +				  page, val, iteration);
>  		} else {
>  			nr_clean_pages++;
>  			/*

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


