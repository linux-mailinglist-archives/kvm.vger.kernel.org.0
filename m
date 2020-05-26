Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3181E2F3E
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 21:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389663AbgEZTpU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 15:45:20 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:9690 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389360AbgEZTpU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 15:45:20 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ecd717c0000>; Tue, 26 May 2020 12:43:56 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 26 May 2020 12:45:19 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 26 May 2020 12:45:19 -0700
Received: from [10.2.50.17] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 May
 2020 19:45:18 +0000
Subject: Re: [PATCH 1/1] vfio/spapr_tce: convert get_user_pages() -->
 pin_user_pages()
To:     Souptick Joarder <jrdr.linux@gmail.com>
CC:     LKML <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>
References: <20200523014347.193290-1-jhubbard@nvidia.com>
 <CAFqt6zYmYQ93jbKNAjDpiH7exjyGv8E-2xHW++yV5CiYMyL5ew@mail.gmail.com>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <40a4e26f-b89b-a3db-6936-f94b9bb4fc9d@nvidia.com>
Date:   Tue, 26 May 2020 12:45:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <CAFqt6zYmYQ93jbKNAjDpiH7exjyGv8E-2xHW++yV5CiYMyL5ew@mail.gmail.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590522236; bh=/XnNrvzb9RLbuq2lH//zFeUnFIDYaIiAnPILKTFB44A=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ZkEgKRfrAfi9lRHILxBG7yG6OSKh6fkLuxThz66yrmzGY/6rYE2zNqc4TBJJtIwdz
         lghpnqH4YUsDN/NppuiFUu5Rgqo+2z8ZY/0gOSDjnwFPrMmGtdVgzAgRCsDk/58Y5q
         LdkVddbL8/CIz47hUA3EWTqnrdiwZOhfys7ris0SpU3jP21kg0ckJY34mOhoER+jP8
         nlI0NxtieLK3p9p1Q1p7R+XlHR1Ux6wFyCIb8KpSEygIJYyg9PJKGNzu4RCNtrU5kj
         RnmV5uOG5VnTn9c2I79MRJfAg1g8eSdoONeVfapKgB9gfLt1LjkfjqmQOk1Mu8U+MG
         I14CdS/mnKs9Q==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-05-26 12:28, Souptick Joarder wrote:
>> @@ -486,7 +486,7 @@ static int tce_iommu_use_page(unsigned long tce, unsigned long *hpa)
>>          struct page *page = NULL;
>>          enum dma_data_direction direction = iommu_tce_direction(tce);
>>
>> -       if (get_user_pages_fast(tce & PAGE_MASK, 1,
>> +       if (pin_user_pages_fast(tce & PAGE_MASK, 1,
>>                          direction != DMA_TO_DEVICE ? FOLL_WRITE : 0,
>>                          &page) != 1)
>>                  return -EFAULT;
> 
> There are few places where nr_pages is passed as 1 to get_user_pages_fast().
> With similar conversion those will be changed to pin_user_pages_fast().
> 
> Does it make sense to add an inline like - pin_user_page_fast(), similar to
> get_user_page_fast_only() ( now merged in linux-next) ?
> 

Perhaps not *just* yet, IMHO. There are only two places so far: here, and
dax_lock_page(). And we don't expect that many places, either, because
pin_user_pages*(), unlike get_user_pages(), is more likely to operate on
a bunch of pages at once. Although, that could change if we look into the
remaining call sites and find more single-page cases that need a gup-to-pup
conversion.

get_user_pages*() has a few more situations (Case 4, in
Documentation/core-api/pin_user_pages.rst: struct page manipulation) in
which it operates on single pages. Those will remain get_user_pages*()
calls, or perhaps change to get_user_page().


thanks,
-- 
John Hubbard
NVIDIA
