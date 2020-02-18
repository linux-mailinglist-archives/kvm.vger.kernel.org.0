Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA2F16337D
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 21:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgBRUwp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 15:52:45 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46140 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgBRUwp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 15:52:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZLV5B0Oe5V3A3am0TKkqk6VF/vK01E8jyGD9x4e9Qto=; b=lGj6GCwK3pYVbmhC7wAkbGT77c
        MpjHKddJ4FJ06yW9/iEesocmUDzdnivOyjpXwYhUjnAFB3pCdyYLw8Y0ZW1ZlBVbSp/pdg+yvowwC
        MA9tq5OTlqsiQ/CN8tVj+nE+hmIGWEzBz4FdLy/MwZTfD+VQKorz2m9rdL5sBjPondZtnjqNZ4LVe
        kdV3iROHN5gzPJrVkA6N/7Y95oXlE6zMenu3N7DS/lxKvOyHd8gm43weUay6JFwoIADgKtWPfyoSW
        wI+nLrwaTtLNj6CUvfUo/YuiyYHv3LJxtVvg2H43zSuZO+zuDVsM9bxCk/PY/B5KLqljIDix5jWlK
        KsScsuFQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j49rD-0004Rq-5k; Tue, 18 Feb 2020 20:52:39 +0000
Date:   Tue, 18 Feb 2020 12:52:39 -0800
From:   Matthew Wilcox <willy@infradead.org>
To:     "Longpeng(Mike)" <longpeng2@huawei.com>
Cc:     mike.kravetz@oracle.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        arei.gonglei@huawei.com, weidong.huang@huawei.com,
        weifuqiang@huawei.com, kvm@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: avoid get wrong ptep caused by race
Message-ID: <20200218205239.GE24185@bombadil.infradead.org>
References: <1582027825-112728-1-git-send-email-longpeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1582027825-112728-1-git-send-email-longpeng2@huawei.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 18, 2020 at 08:10:25PM +0800, Longpeng(Mike) wrote:
>  {
> -	pgd_t *pgd;
> -	p4d_t *p4d;
> -	pud_t *pud;
> -	pmd_t *pmd;
> +	pgd_t *pgdp;
> +	p4d_t *p4dp;
> +	pud_t *pudp, pud;
> +	pmd_t *pmdp, pmd;

Renaming the variables as part of a fix is a really bad idea.  It obscures
the actual fix and makes everybody's life harder.  Plus, it's not even
renaming to follow the normal convention -- there are only two places
(migrate.c and gup.c) which follow this pattern in mm/ while there are
33 that do not.

