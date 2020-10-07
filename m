Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36FD286934
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 22:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbgJGUiL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 16:38:11 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:12977 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbgJGUiL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 16:38:11 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7e26c60000>; Wed, 07 Oct 2020 13:36:22 -0700
Received: from [10.2.85.86] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 7 Oct
 2020 20:38:07 +0000
Subject: Re: [PATCH 03/13] misc/habana: Stop using frame_vector helpers
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
CC:     <kvm@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-s390@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        "Omer Shpigelman" <oshpigelman@habana.ai>,
        Ofir Bitton <obitton@habana.ai>,
        "Tomer Tayar" <ttayar@habana.ai>,
        Moti Haimovski <mhaimovski@habana.ai>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Pawel Piskorski <ppiskorski@habana.ai>
References: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
 <20201007164426.1812530-4-daniel.vetter@ffwll.ch>
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <3ad0e02d-4ab1-6fe1-6f4d-e381e4f37afe@nvidia.com>
Date:   Wed, 7 Oct 2020 13:38:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201007164426.1812530-4-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602102982; bh=yuAqwELlY3ofogWejN6SHZgdy41opvCmSytBHCnrmlM=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=gkOESIFvST6yyyeEgFKkiQRXYOtpgRUWeYyLwOa1FV2fmm34StbJHEvT6/hefXbTF
         xQ5nn+kqRWOwunENSo9IP5Lo5y5nN9tPB4tTxUUuOz36HzzB8u4YUokcoSih1paZp1
         iqDA4flNnMiDdmuvv8CAmblsoAkRum7AwT19P0coSQH2qKBBXTUhdPsklGBWwXSHQX
         7efraicZvRAnr9vc/8TadqcYL//GjjpaAZ1oQSTjhKsV1h5QKMX5Hs9Pn90pDZZX7J
         IoWfb1Cuv66sCbIsRxg7Q4JDNsMnO9gIotzTS7WBwb4gZZBJmE6cjlekHA3M2H2VFv
         vsHWewdIAlmrA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/7/20 9:44 AM, Daniel Vetter wrote:
...
> @@ -1414,15 +1410,10 @@ void hl_unpin_host_memory(struct hl_device *hdev, struct hl_userptr *userptr)
>   							userptr->sgt->nents,
>   							userptr->dir);
>   
> -	pages = frame_vector_pages(userptr->vec);
> -	if (!IS_ERR(pages)) {
> -		int i;
> -
> -		for (i = 0; i < frame_vector_count(userptr->vec); i++)
> -			set_page_dirty_lock(pages[i]);
> -	}
> -	put_vaddr_frames(userptr->vec);
> -	frame_vector_destroy(userptr->vec);
> +	for (i = 0; i < userptr->npages; i++)
> +		set_page_dirty_lock(userptr->pages[i]);
> +	unpin_user_pages(userptr->pages, userptr->npages);
> +	kvfree(userptr->pages);

Same thing here as in patch 1: you can further simplify by using
unpin_user_pages_dirty_lock().

>   
>   	list_del(&userptr->job_node);
>   
> 

thanks,
-- 
John Hubbard
NVIDIA
