Return-Path: <kvm+bounces-34016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DC5179F5AFD
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 01:05:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4027C18924C0
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 00:05:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 447671714B5;
	Wed, 18 Dec 2024 00:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TAhM7/Ks"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD724155382
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 00:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734480174; cv=none; b=Rd+8EeDta774Qg/RxVMleaWtXgMRQdvzSCFPItO7TRZgBxLOky6UQt4TuWL1RfsdWxDZDmvTqAldBc5VghK1Aoz4LPeiiphjM2QW4CX7lU+KuEMeyIXj5eGNhfF4pvuvQlTABw+9cPRpGevDp3r1jSU2GZwZjBB3+IIXmc2qo6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734480174; c=relaxed/simple;
	bh=lt8ky7ZpF/9dqaloG1UpQK25UoXzGUgtBgmV5QUauvM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=shrX0+72wE975XXDJe2mbMYw3Ai15Nms0bHA9JdVqmyOx5DMFs+MdqTaWtkz4m2ko3/Sx+DYitB3Hs4jpUB4NfBjC/BpdqWvQcdTYo7CygSAuJFEmyZ7QDFakvUJMcYuMwIh7hNzyjw3dmZ4EulfAP0Ug0oaaQo69b+QdO9aVMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TAhM7/Ks; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734480171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j077zAEFv1KDTZ4emlDdtZv2eMWpxvsnBzeSJzo3REo=;
	b=TAhM7/Ksujmv+/s5dQsLnDIyBvarMDUhIPrnJk4P4kBwevnsf1EXiWJvcJXX8QM9huwCP0
	rJ/jJuVkVN3G1h0ERPIHP13Ioy4xF4lTn183iDH3hzjzmazN3GykvmYMyRVWnNDvtnIeln
	xU9twESXj7bRY9kQh9QaQ1rfdgpxgwE=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-543-qA5eT_w1MqWqv36y3macjw-1; Tue, 17 Dec 2024 19:02:50 -0500
X-MC-Unique: qA5eT_w1MqWqv36y3macjw-1
X-Mimecast-MFC-AGG-ID: qA5eT_w1MqWqv36y3macjw
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-844e344b0b5so494154839f.0
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 16:02:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734480170; x=1735084970;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j077zAEFv1KDTZ4emlDdtZv2eMWpxvsnBzeSJzo3REo=;
        b=la+5jUSucMdCKjXXqTC9b84NBW6m0rvufZHMx+CnZTdlZaSaB2+1QYaMLTmJ2ONN8t
         6k79ZFd3k74f2md7nzNyDKKUoylL7XxMi8pWTvfuCLtMbzSqloY+lScaXB4nODQVwdnV
         DIK980JiR/kB6MNfAe0KzPl1Bn4W2CzbDt8X0o3qETXhTP5GGuZTyDdNimVNqtSg2mzI
         NG/fcHm9y+P0qkx9y5TTN1PpUkbZhVJ3NqX0J1cZtsr9FRwZqzbquJ5e0wX27KeKLNm8
         A4ifXAAk/aG7dyUqLZWGRzBXaEWEh8df94JjMhLpQeY7y9V9uOmh5sv883sRwsiRxOgs
         u7Hg==
X-Gm-Message-State: AOJu0YxS2QwThUR8RKWQVWgod8BzqMYO6wQ7W1cHXcpW6VCNi6sjzlxC
	eAqdXsLgcg6ZwZZTxTjhZiAfCL0Y9cPB8vDE63sGlmV8iEYQbjP6bGDxPxGvT4ABaVOgVeqMRdH
	Qvvn0kpRRAwxob63m+MROsh7pCh2M+FZKdRePwKHJrBIxubTNuw==
X-Gm-Gg: ASbGncv8kfTBqB5i2YVB+nrhLp8yNKM264Zs99enbl9h+mY20FwncLYpCBZgeyFUW86
	1BTTQAkpcrZ6pApnVr6SFyW8cIyfclq3djmoUrJkmNTQd3DOFpkEQl9AfMnm7ANK2ZJlzIMorKN
	ZCRkCN8LSr0JUn7Gzxt6G9hWdSCAddMhbjf/yd1JiUBLjbbt6o1B+sVD7TaNzAKovtRW4qw4MMk
	Ar/aAY17ev8hHB+PO2+0DUcPFBkUc+EJN+kBxOb/Exl23PsT6ZX6vyM
X-Received: by 2002:a05:6e02:164b:b0:3a7:7558:a6ea with SMTP id e9e14a558f8ab-3bdc0bc8239mr10812305ab.10.1734480169072;
        Tue, 17 Dec 2024 16:02:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF+W4SQfKhd60InvRuUqmwBd/RmkWU7jcD4h5PXX3dL7NWINYO2eCqr5SyBs0dBuyYO1fy8cg==
X-Received: by 2002:a05:6e02:164b:b0:3a7:7558:a6ea with SMTP id e9e14a558f8ab-3bdc0bc8239mr10812065ab.10.1734480168811;
        Tue, 17 Dec 2024 16:02:48 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e5e0a3de9bsm1929513173.50.2024.12.17.16.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:02:48 -0800 (PST)
Message-ID: <a0554bb2f9412bdb95d980bc15c51bd590d3aadb.camel@redhat.com>
Subject: Re: [PATCH 15/20] KVM: sefltests: Verify value of dirty_log_test
 last page isn't bogus
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Xu
	 <peterx@redhat.com>
Date: Tue, 17 Dec 2024 19:02:47 -0500
In-Reply-To: <20241214010721.2356923-16-seanjc@google.com>
References: <20241214010721.2356923-1-seanjc@google.com>
	 <20241214010721.2356923-16-seanjc@google.com>
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
> Add a sanity check that a completely garbage value wasn't written to
> the last dirty page in the ring, e.g. that it doesn't contain the *next*
> iteration's value.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 3a4e411353d7..500257b712e3 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -514,8 +514,9 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long **bmap)
>  				 * last page's iteration), as the value to be
>  				 * written may be cached in a CPU register.
>  				 */
> -				if (page == dirty_ring_last_page ||
> -				    page == dirty_ring_prev_iteration_last_page)
> +				if ((page == dirty_ring_last_page ||
> +				     page == dirty_ring_prev_iteration_last_page) &&
> +				    val < iteration)
>  					continue;
>  			} else if (!val && iteration == 1 && bmap0_dirty) {
>  				/*
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>



