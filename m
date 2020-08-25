Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8925F25224B
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 22:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgHYU7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 16:59:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53996 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726149AbgHYU7O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Aug 2020 16:59:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598389152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xaM1BniRdV7s6zyBckfA1mE3ZyTG9PC4cGNHi1/r0LU=;
        b=enhCOzMMhAPB8WTpjzCQEDvUg23OT6uzaYHJ52z8VvRLrlyh3gMXFqrQXQJyQlUx+aKhRZ
        +WWKNOaKdubtRC5/kK2p3sIAzrBFX8674jzVAxK8A+hrmGg9HB10Uu1+njvmnMnjFwqQ6p
        RAiepEIUFF6IbJfQAd/SsAVSQKyHwoA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-ivEAD0N5PhKq_e9-UvbeDw-1; Tue, 25 Aug 2020 16:59:11 -0400
X-MC-Unique: ivEAD0N5PhKq_e9-UvbeDw-1
Received: by mail-qk1-f200.google.com with SMTP id 1so155598qki.22
        for <kvm@vger.kernel.org>; Tue, 25 Aug 2020 13:59:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xaM1BniRdV7s6zyBckfA1mE3ZyTG9PC4cGNHi1/r0LU=;
        b=R8ctsU5/tBUdfKwz0ceyAERSfN7iGoT+MsNCh7Yi8etMcA70d5LpJK1WKggLQSvN7u
         hskKtd8DHFIG9QY1aJzdfLXlZsPnWrzWYKTXAX67K0rJyuwkqL10FPA+V+7GHNMM4XCT
         71yw9HiIhfwLLogLHMOU2r7zup0BZHes7fnbXi31Q4WLov7viyGLYU8xTwqQe8B/nr9i
         Hb20v6WvcHSaauzyxl91XSYsVAZtLNqkpbHoMSlJKa/mD4nzb+zoWOyfFQAYqwbBiyBu
         ccyp/eZPdvq+0jotGiRdsFcmCI2blSIf+ASZCPw5pYC7Q+NiHJBsV4xNgM4hk8RzN+7g
         ZiUA==
X-Gm-Message-State: AOAM530UAUGPjFEH9qebIRvh3SO2pqcN1PzF49xGBBwzyl6Tg+oM/UHg
        pU4R8bvuaHV4Zqu2kjhw4MsPm5CI/a7KUHZIln+uq3MWQyAS7pf927yM7GEvruHAgTa32561BIg
        /Kd7CpOvrwp1U
X-Received: by 2002:a37:a011:: with SMTP id j17mr11600603qke.258.1598389150483;
        Tue, 25 Aug 2020 13:59:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0NoiPkbiaDV/kCJQZdlozQUvTfCnzvSsS0NfWm4N4KroTsK/ZYDgUxBZJwZaMG89yIXBKJQ==
X-Received: by 2002:a37:a011:: with SMTP id j17mr11600581qke.258.1598389150110;
        Tue, 25 Aug 2020 13:59:10 -0700 (PDT)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-11-70-53-122-15.dsl.bell.ca. [70.53.122.15])
        by smtp.gmail.com with ESMTPSA id l5sm20009qkk.134.2020.08.25.13.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 13:59:09 -0700 (PDT)
Date:   Tue, 25 Aug 2020 16:59:07 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Ming Mao <maoming.maoming@huawei.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        alex.williamson@redhat.com, cohuck@redhat.com,
        jianjay.zhou@huawei.com, weidong.huang@huawei.com,
        aarcange@redhat.com
Subject: Re: [PATCH V2] vfio dma_map/unmap: optimized for hugetlbfs pages
Message-ID: <20200825205907.GB8235@xz-x1>
References: <20200814023729.2270-1-maoming.maoming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200814023729.2270-1-maoming.maoming@huawei.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 14, 2020 at 10:37:29AM +0800, Ming Mao wrote:
> +static long hugetlb_page_vaddr_get_pfn(unsigned long vaddr, long npage,
> +						unsigned long pfn)
> +{
> +	long hugetlb_residual_npage;
> +	long contiguous_npage;
> +	struct page *head = compound_head(pfn_to_page(pfn));
> +
> +	/*
> +	 * If pfn is valid,
> +	 * hugetlb_residual_npage is greater than or equal to 1.
> +	 */
> +	hugetlb_residual_npage = hugetlb_get_residual_pages(vaddr,
> +						compound_order(head));
> +	if (hugetlb_residual_npage < 0)
> +		return -1;
> +
> +	/* The page of vaddr has been gotten by vaddr_get_pfn */
> +	contiguous_npage = min_t(long, (hugetlb_residual_npage - 1), npage);
> +	if (!contiguous_npage)
> +		return 0;
> +	/*
> +	 * Unlike THP, the splitting should not happen for hugetlb pages.
> +	 * Since PG_reserved is not relevant for compound pages, and the pfn of
> +	 * PAGE_SIZE page which in hugetlb pages is valid,
> +	 * it is not necessary to check rsvd for hugetlb pages.
> +	 * We do not need to alloc pages because of vaddr and we can finish all
> +	 * work by a single operation to the head page.
> +	 */
> +	atomic_add(contiguous_npage, compound_pincount_ptr(head));
> +	page_ref_add(head, contiguous_npage);
> +	mod_node_page_state(page_pgdat(head), NR_FOLL_PIN_ACQUIRED, contiguous_npage);

I think I asked this question in v1, but I didn't get any answer... So I'm
trying again...

Could I ask why manual referencing of pages is done here rather than using
pin_user_pages_remote() just like what we've done with vaddr_get_pfn(), and let
try_grab_page() to do the page reference and accountings?

I feel like this at least is against the FOLL_PIN workflow of gup, because
those FOLL_PIN paths were bypassed, afaict.

> +
> +	return contiguous_npage;
> +}

-- 
Peter Xu

