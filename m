Return-Path: <kvm+bounces-34008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D10229F5AD9
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 01:00:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 278031664B4
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 00:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0921B1FBC8E;
	Tue, 17 Dec 2024 23:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D0hOVvW1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E301FA276
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 23:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734479998; cv=none; b=KuBGEDXik+HxyNx0hkOu+lStO0QN06svV4Z1UVCckfFOvLValZQ5nr0q59pZyECpt0+oxCZfvAXXgIQC5rSHVx9JYlz+qOsNVpKJK613MvTv0xZgp5dRSyUBJ8pNlR+aAtQETOUwH7bnZlZXfeebKyB1e38aNaqkCHSDPqn4z34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734479998; c=relaxed/simple;
	bh=fsAyV5klwA3VGeTat+gH7+ziK6NrS00UgT0xJ1bDgjE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ke9+BCamHI87Zui6IXH1qUZSqOc/nIFn3zDTEw+HlsuqqgNJC1SrSpKVW+KJjNLIiqc7KpASCrmckW3DUakzMVhgf5lqaTscvPtH8hYH/bWQSX3mPW279f4yBY4DYa1INB8BGg+j6Q1f9gVGBPE7vMlyS81Lt+zToPIYTUDoC/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D0hOVvW1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734479995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3XICajvF+UE5msVoxqjl7D4goByHARb39vCTHT5As9o=;
	b=D0hOVvW1g8v4S1cXKGe8aqstxAPmVIlwBlxeiWGLdC2PGfdnqr/GjvTkdbmn3aXU84CSoh
	HLbTnyKug/uGlG4lVSPuNfRHEYncEtif9NL/I07bdngoZdEVwU2SDG7hOj9Ivue/5Dh28s
	SXt8jK5d6jgekOZTu/Q5V8hn2Z31uc8=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-232-_NTffqYGOYKqp-aeAGCedQ-1; Tue, 17 Dec 2024 18:59:54 -0500
X-MC-Unique: _NTffqYGOYKqp-aeAGCedQ-1
X-Mimecast-MFC-AGG-ID: _NTffqYGOYKqp-aeAGCedQ
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a817be161bso2514395ab.1
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 15:59:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734479993; x=1735084793;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3XICajvF+UE5msVoxqjl7D4goByHARb39vCTHT5As9o=;
        b=B+zBtDajjXjiY/1fu4E1QIGEh/xr3/49UH09sTM2HLsP/6zCA76mH3dLAl2i5f5Ugj
         HMFQdKyayoxc8WSPactJcJHGKgWuDxxokccVA0su9zIFbwTkhRhH0WSo+7hdWK67R4Dx
         2Yqef2ycFdSKi/HSEDX9WtUMl/gsrBYBK2o92pWltZhBUPDJlFxmhJUQOfXUNecZ5Rgw
         PDWU7Ne+9XM+Tet9sy9mI5W4R66HVjBzutfcBm26bhNcX9Y+ZH3kLJ2LOR0LEHEb2OnG
         z6e09chfL9roGSDpSZPUTkPNEGll2F6Won5FOySprVQ4UFqgQ5BnRyteN5FLLHlsvsBn
         jrwQ==
X-Gm-Message-State: AOJu0YzW2DI1eHKa5wk82+Z/CdwucHpMyfW/7NB8CCeygfXez6zKoigm
	flOYcNYsiqdpTl5ZOfYB3w1hTae/ZRbGiPSL5tyGuMIXseElLCiOLsVF0ULOupmrcpSvKNPAliV
	RNo8PJFgGu33MNdPKzPWsUu7tC1S/RtucFqVjRMBWCHpkYIEATNA4sthX9w==
X-Gm-Gg: ASbGncs+miw3MDVfh9ljHBDxcqvlXyPYerTU74TfoD8zOK907LXyEpiEhcspSSiuh8C
	MqcEqDdS7Rtb7QJ8oTGUKE4sR63UyQQCfIn8DHrCYyGpZ3vNMsSXpamO9WsdNouPO31M4oWr8wB
	0vbrPk398G49Cz2TKATi/CRU2OmesIvgf2U5Ih9D02F11aTun39Rb+ND4QeK6hn/D068ffvXpL9
	YGMe5UJbsZflXOIynpk5gEpvoC0+CkiUSqsu7sS8385DphYK2QU7J/D
X-Received: by 2002:a92:c145:0:b0:3a8:13d5:bd2c with SMTP id e9e14a558f8ab-3bb076fd9d6mr48150755ab.2.1734479993204;
        Tue, 17 Dec 2024 15:59:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHhCDMg38v5g9RlVDFusVQ/aIduylu6YABtGkFjlLrb/bza5klf0U79dLAhaVsglSJoEdEX8Q==
X-Received: by 2002:a92:c145:0:b0:3a8:13d5:bd2c with SMTP id e9e14a558f8ab-3bb076fd9d6mr48150695ab.2.1734479992908;
        Tue, 17 Dec 2024 15:59:52 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e5e378241dsm1890850173.116.2024.12.17.15.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 15:59:52 -0800 (PST)
Message-ID: <beec72cefd8518aecbf3ecb652c8e79ba71ff266.camel@redhat.com>
Subject: Re: [PATCH 06/20] KVM: selftests: Read per-page value into local
 var when verifying dirty_log_test
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Xu
	 <peterx@redhat.com>
Date: Tue, 17 Dec 2024 18:59:51 -0500
In-Reply-To: <20241214010721.2356923-7-seanjc@google.com>
References: <20241214010721.2356923-1-seanjc@google.com>
	 <20241214010721.2356923-7-seanjc@google.com>
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
> Cache the page's value during verification in a local variable, re-reading
> from the pointer is ugly and error prone, e.g. allows for bugs like
> checking the pointer itself instead of the value.

You should note that there are no functional changes in this patch.

Besides this,

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 08cbecd1a135..5a04a7bd73e0 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -520,11 +520,10 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
>  {
>  	uint64_t page, nr_dirty_pages = 0, nr_clean_pages = 0;
>  	uint64_t step = vm_num_host_pages(mode, 1);
> -	uint64_t *value_ptr;
>  	uint64_t min_iter = 0;
>  
>  	for (page = 0; page < host_num_pages; page += step) {
> -		value_ptr = host_test_mem + page * host_page_size;
> +		uint64_t val = *(uint64_t *)(host_test_mem + page * host_page_size);
>  
>  		/* If this is a special page that we were tracking... */
>  		if (__test_and_clear_bit_le(page, host_bmap_track)) {
> @@ -545,11 +544,10 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
>  			 * the corresponding page should be either the
>  			 * previous iteration number or the current one.
>  			 */
> -			matched = (*value_ptr == iteration ||
> -				   *value_ptr == iteration - 1);
> +			matched = (val == iteration || val == iteration - 1);
>  
>  			if (host_log_mode == LOG_MODE_DIRTY_RING && !matched) {
> -				if (*value_ptr == iteration - 2 && min_iter <= iteration - 2) {
> +				if (val == iteration - 2 && min_iter <= iteration - 2) {
>  					/*
>  					 * Short answer: this case is special
>  					 * only for dirty ring test where the
> @@ -597,7 +595,7 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
>  			TEST_ASSERT(matched,
>  				    "Set page %"PRIu64" value %"PRIu64
>  				    " incorrect (iteration=%"PRIu64")",
> -				    page, *value_ptr, iteration);
> +				    page, val, iteration);
>  		} else {
>  			nr_clean_pages++;
>  			/*
> @@ -619,11 +617,11 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
>  			 *     we'll see that page P is cleared, with
>  			 *     value "iteration-1".
>  			 */
> -			TEST_ASSERT(*value_ptr <= iteration,
> +			TEST_ASSERT(val <= iteration,
>  				    "Clear page %"PRIu64" value %"PRIu64
>  				    " incorrect (iteration=%"PRIu64")",
> -				    page, *value_ptr, iteration);
> -			if (*value_ptr == iteration) {
> +				    page, val, iteration);
> +			if (val == iteration) {
>  				/*
>  				 * This page is _just_ modified; it
>  				 * should report its dirtyness in the



