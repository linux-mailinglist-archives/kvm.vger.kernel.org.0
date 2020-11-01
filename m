Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193282A1BEC
	for <lists+kvm@lfdr.de>; Sun,  1 Nov 2020 06:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgKAFWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Nov 2020 01:22:20 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:8613 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgKAFWS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Nov 2020 01:22:18 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9e460b0000>; Sat, 31 Oct 2020 22:22:19 -0800
Received: from [10.2.59.55] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 1 Nov
 2020 05:22:12 +0000
Subject: Re: [PATCH v5 05/15] mm/frame-vector: Use FOLL_LONGTERM
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
CC:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>
References: <20201030100815.2269-1-daniel.vetter@ffwll.ch>
 <20201030100815.2269-6-daniel.vetter@ffwll.ch>
 <446b2d5b-a1a1-a408-f884-f17a04b72c18@nvidia.com>
 <CAKMK7uGDW2f0oOvwgryCHxQFHyh3Tsk6ENsMGmtZ-EnH57tMSA@mail.gmail.com>
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <1f7cf690-35e2-c56f-6d3f-94400633edd2@nvidia.com>
Date:   Sat, 31 Oct 2020 22:22:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAKMK7uGDW2f0oOvwgryCHxQFHyh3Tsk6ENsMGmtZ-EnH57tMSA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604208139; bh=BviMObXYl4DBSbzSpkoK8hvibl+1Fsc4El3qoj9SER4=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=GDRHpOkpxs1Ufq2SOGdgYR/E9XR+fbuJ8LSdEQnzZVakY5/3RHLrlV0EUPacqB1hx
         sgcaxSS6kL92YgOCYxV61/vKgMeyJzWv3pbsiGOiPG2yzztyrS+M509X+WJsspP0iX
         eGYfmD7CUw9Sc7vfW/dXMJFEk0m7LtD6SNXFGO5vEh2idfKwEVzJ6ZAWx2tcCRv74B
         z9sCh7r8+3axv5dd8sfK1ThmV84FPNw8fCBM1IYOZ3eSLI6P+VCNYX5tGFWyGGRpnN
         ra2SHoMsB7AY6QbBfc+xZFCAcf9OI3Wzgrvev7r6iT4kkq15E1JGpS1HdFytcI+8SG
         6LGq3w3+17JOQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/31/20 7:45 AM, Daniel Vetter wrote:
> On Sat, Oct 31, 2020 at 3:55 AM John Hubbard <jhubbard@nvidia.com> wrote:
>> On 10/30/20 3:08 AM, Daniel Vetter wrote:
...
>> By removing this check from this location, and changing from
>> pin_user_pages_locked() to pin_user_pages_fast(), I *think* we end up
>> losing the check entirely. Is that intended? If so it could use a comment
>> somewhere to explain why.
> 
> Yeah this wasn't intentional. I think I needed to drop the _locked
> version to prep for FOLL_LONGTERM, and figured _fast is always better.
> But I didn't realize that _fast doesn't have the vma checks, gup.c got
> me a bit confused.

Actually, I thought that the change to _fast was a very nice touch, btw.

> 
> I'll remedy this in all the patches where this applies (because a
> VM_IO | VM_PFNMAP can point at struct page backed memory, and that
> exact use-case is what we want to stop with the unsafe_follow_pfn work
> since it wreaks things like cma or security).
> 
> Aside: I do wonder whether the lack for that check isn't a problem.
> VM_IO | VM_PFNMAP generally means driver managed, which means the
> driver isn't going to consult the page pin count or anything like that
> (at least not necessarily) when revoking or moving that memory, since
> we're assuming it's totally under driver control. So if pup_fast can
> get into such a mapping, we might have a problem.
> -Daniel
>

Yes. I don't know why that check is missing from the _fast path.
Probably just an oversight, seeing as how it's in the slow path. Maybe
the appropriate response here is to add a separate patch that adds the
check.

I wonder if I'm overlooking something, but it certainly seems correct to
do that.

  thanks,
-- 
John Hubbard
NVIDIA
