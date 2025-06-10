Return-Path: <kvm+bounces-48882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87F8DAD45D6
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 00:23:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 347763A6C23
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 22:22:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5584D28B7D0;
	Tue, 10 Jun 2025 22:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YawCn5VN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D711F28AB07
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749594181; cv=none; b=SJdVHHaWKav7pvgb0LXFVwGPqwzIrv/R4rKsYiRCasZS4lN7JXB8Thch2/mtqtRPLVr6mCGNkyYA3xQjGVyK/FAEQB+aequwLu4W7hjOghjStNoWxdZvvJwQQ0YzHrymldvuJL5OkaSlD6gJS19cDUguc5E8dvfRvIFXucgPG34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749594181; c=relaxed/simple;
	bh=XjgsdEhFvFB0B+RbA+5aNhRmFbtruOCW5OEOXUP/KY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=idnYX18vawCJ9dGcLCJMZZwLhgNjoTCwnD4sIXBagcW2uc5W0I7bnUuGbrL8h9y+5ycxO8lCrhOOSVeVgzgBlqW3t09/teVi64d/KcTdn8VqJ6dh83cPkUgnyAyih5K+X7gbSaGSnEMDTBfuTBTniSuiHcCEedIp4dOZY/En52Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YawCn5VN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749594178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hLuQnm8GtR1mcurBIw5pIZijzYYYehwuFe+H/mrbon4=;
	b=YawCn5VN+mFNRJlZP08f0md661NpDLBs1kKCUQ7gASoZES+4w9Ui8RQ8wW4q2LAxrX67xW
	FfNFJUS83/fhlDp/qlDhDoNl3tLsL9xsFJWcU2gvNG+WJQrOa+1tPt09wfF9iCN6bIQJma
	LAvNSKtD8ABTn+lGeKaLXy2BfaeBCzA=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-8Hy53thANI-0gtqEINTaLw-1; Tue, 10 Jun 2025 18:22:45 -0400
X-MC-Unique: 8Hy53thANI-0gtqEINTaLw-1
X-Mimecast-MFC-AGG-ID: 8Hy53thANI-0gtqEINTaLw_1749594164
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-72bc266dc24so6886102a34.2
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:22:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749594162; x=1750198962;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hLuQnm8GtR1mcurBIw5pIZijzYYYehwuFe+H/mrbon4=;
        b=lXJogKCRwmrayN0JPadTpisj7g0yhujn9feCu5IA1eeAtZeNn1AthadSeYw5t+CjfH
         UkWk9Ye47pG1iwJLPNsA0LVCcH2TzW+h+q+0OX4vwhUSrCImD9qc5V7pgewD1Zgic22z
         n8LOcvvure75dIPv7poqe480ynfoc6OP0E+cGLg6C8i0+MZleRKlSJDVu7Cbcoax+RHE
         rFciAMEN2Ot7lsFopqEQs5pQBrql+CSX0C+52KNQooaSvAlwW/YX5kdmoeW4RIgZ3GZY
         gfmEMbEuOKeAgYPPPQ8wOsAR8uY3QQ3yNMUqGgjqs8loo31dKztw9Di1qWtqbJJQeqnh
         i6Pg==
X-Forwarded-Encrypted: i=1; AJvYcCWTSwBkT5ncevgCCfllrAG2Ow3sT4BGuiyUYEpbde++afRpAW1+iCkUmt8FXFc6E5hVU6U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHubktI1AvUk9uQqyi/Uc8u4v5yT3ijwG9BM2Bh5H3pJSLw5EF
	iSUSEZOSWxvlMvLPpw3/XoqA+S+APLPHkHNhOLPvQhy7+toKrqGAoAz/a0a0yyKoqabbN51cZdf
	nekmrOkPKZ1+8brOvkxDZWvK9fXTBWF9IP4F8ifB4hHpg2v2/5ZatwjeINC0MFA==
X-Gm-Gg: ASbGncv5pVeb1hs6zh25BlR2yTyCv0yBEkWwyogEY774oLfQxwCOWK+lagw1EkzvAJc
	GMdSy3apxRXfZqnO4tIxUkP56VLIBVW/LT70LaU6IME9JeMv4/cK+f+AGxn84q7R3/i3q3Wzl5p
	IiScCGbxBS38Kq4zx84W/pLgrwkMKG+9v0LXq7GqYJ1+VapK/jRedeKLzfBP4tv+cCXTxnRsOYS
	j2vUmw+zaEDCj8GJnh2YIOHc8meUAn+rosEM8bkhLGo+/jFhrR6TJkjlTSDe4ENTo33je1DVVup
	u9i2roe2ZPbbuw==
X-Received: by 2002:a05:6808:6f8b:b0:408:e711:9a8 with SMTP id 5614622812f47-40a5d1678e4mr805209b6e.15.1749594161858;
        Tue, 10 Jun 2025 15:22:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZPFHzLV7Sg4ZkCQBoFbsxw1VThpMG4z5lPpBVju0VP9CmUB6NZzQ74WH9fhjymqKd3HA8wA==
X-Received: by 2002:a05:622a:a18:b0:494:b924:1374 with SMTP id d75a77b69052e-4a713c4544cmr20646161cf.43.1749594147540;
        Tue, 10 Jun 2025 15:22:27 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a611150cb0sm78624171cf.11.2025.06.10.15.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 15:22:26 -0700 (PDT)
Date: Tue, 10 Jun 2025 18:22:22 -0400
From: Peter Xu <peterx@redhat.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: akpm@linux-foundation.org, pbonzini@redhat.com, shuah@kernel.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, muchun.song@linux.dev,
	hughd@google.com, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, jack@suse.cz,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	jannh@google.com, ryan.roberts@arm.com, david@redhat.com,
	jthoughton@google.com, graf@amazon.de, jgowans@amazon.com,
	roypat@amazon.co.uk, derekmn@amazon.com, nsaenz@amazon.es,
	xmarcalx@amazon.com
Subject: Re: [PATCH v3 1/6] mm: userfaultfd: generic continue for non
 hugetlbfs
Message-ID: <aEiwHjl4tsUt98sh@x1.local>
References: <20250404154352.23078-1-kalyazin@amazon.com>
 <20250404154352.23078-2-kalyazin@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250404154352.23078-2-kalyazin@amazon.com>

On Fri, Apr 04, 2025 at 03:43:47PM +0000, Nikita Kalyazin wrote:
> Remove shmem-specific code from UFFDIO_CONTINUE implementation for
> non-huge pages by calling vm_ops->fault().  A new VMF flag,
> FAULT_FLAG_USERFAULT_CONTINUE, is introduced to avoid recursive call to
> handle_userfault().

It's not clear yet on why this is needed to be generalized out of the blue.

Some mentioning of guest_memfd use case might help for other reviewers, or
some mention of the need to introduce userfaultfd support in kernel
modules.

> 
> Suggested-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>  include/linux/mm_types.h |  4 ++++
>  mm/hugetlb.c             |  2 +-
>  mm/shmem.c               |  9 ++++++---
>  mm/userfaultfd.c         | 37 +++++++++++++++++++++++++++----------
>  4 files changed, 38 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 0234f14f2aa6..2f26ee9742bf 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1429,6 +1429,9 @@ enum tlb_flush_reason {
>   * @FAULT_FLAG_ORIG_PTE_VALID: whether the fault has vmf->orig_pte cached.
>   *                        We should only access orig_pte if this flag set.
>   * @FAULT_FLAG_VMA_LOCK: The fault is handled under VMA lock.
> + * @FAULT_FLAG_USERFAULT_CONTINUE: The fault handler must not call userfaultfd
> + *                                 minor handler as it is being called by the
> + *                                 userfaultfd code itself.

We probably shouldn't leak the "CONTINUE" concept to mm core if possible,
as it's not easy to follow when without userfault minor context.  It might
be better to use generic terms like NO_USERFAULT.

Said that, I wonder if we'll need to add a vm_ops anyway in the latter
patch, whether we can also avoid reusing fault() but instead resolve the
page faults using the vm_ops hook too.  That might be helpful because then
we can avoid this new FAULT_FLAG_* that is totally not useful to
non-userfault users, meanwhile we also don't need to hand-cook the vm_fault
struct below just to suite the current fault() interfacing.

Thanks,

-- 
Peter Xu


