Return-Path: <kvm+bounces-40001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EA64A4D7BC
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 10:18:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FB0F3ABD22
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 09:17:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36BBC1FCCF7;
	Tue,  4 Mar 2025 09:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fuxu++ZY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11841F4CA6
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 09:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741079873; cv=none; b=l9XTuFc92HO2vKSTDJicKUmg/j/IESXl+I8IC8CWmfU/kD4x6p4qYqwbCUI7FTGdsVZadS7l75z0dvGbgHLg0HyP3DFra3YUVQO1I4nEpaDTRRz6i6IF55cI2jPqiTYwGEJMZf5x5t2keHyO5bvzoQs4L3R9aAOpfIvQ08cpBuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741079873; c=relaxed/simple;
	bh=EYwd2Jf8ZA0KU9xC36aNCIR5lDQhcFK0j7Q6bTeAt5o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aGkIqEw9ctL6xmAEn59Yp0h+PebzhmTLr5DvHXOmhQ9GMVxPVZJ8Pe63/oEPN7hv4W//smq/RGaBU6+FeIIZYrkmkpatlvQTCXdPani5omrsi8Hr6NJg7Bzli0NUD3Vv+iP2yLHqV/BA4CimqDuecp8uK87II4x1zEAPdsJMMcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fuxu++ZY; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5e53b3fa7daso3553496a12.2
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 01:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1741079869; x=1741684669; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=U7nVbwpLU0+lp6Hc0ee6jvbH0Pu/dJ0Otg1V1qw972I=;
        b=fuxu++ZYVsqoY3xjWsoTqcXMgLBOCtHww6PZHUOFjz5ZCu+QqJYXzitd9nUrbOXdjP
         vlId1tD1GAFFDUCt4mtRLBehfFm2IgtoWyfO8hYTXTsnU1JseV1C8hw5Zamf3QEi8Pl6
         +DMmdH4u8snN/q8RavL3eaoQBoqjPBE2cz4VWdIrhOaXchpJgr6lSoBlL7nkBCv5wouJ
         unrymmFLGE0qhL/SferbZsj0JrR51NjppLcZExBfAWFN9AzRFpF4I31CILKK8ufUUOIs
         fnDizfeEvpw7uJNhqMuJSL8Lucj8/ma28e/HsVdlu4Gq2Z/5XQ2dljW3BkNmPVPbf9pa
         EZXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741079869; x=1741684669;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U7nVbwpLU0+lp6Hc0ee6jvbH0Pu/dJ0Otg1V1qw972I=;
        b=bNa3EBH/RijNzGyHwLknuBxEZbfisJl0QnT83NezVETPklGhDfCQqOcKIOgDmzDS3b
         LsbBg5OSJwzgfSP9xm4NykNa66FUDLdmEjXqDgH2SmGbS3qqDfL9iaVGeKZ+f8DklTDL
         Ehjr/1ygOsGLPArVbMhqnkX0r6JpPOiMq0ka3vlf8ZbSBIupyiAxb/b7bEoGKmg4ny+h
         NRc9+/6pEqF8N8qt4d/IK++cPkk+D4Aqu9F+kgXQ6YIyClcdFka8DQGIHckEd8qbmyFP
         Q851czXjna/V2BvD2/X6agzrMk0YzGJXeF1yuCNwhSrWiUywJPrdf3pg9NgsjhWSeuNQ
         Ff5g==
X-Forwarded-Encrypted: i=1; AJvYcCWvDnJMsPlyH8S7urdtdlDyuylmvXqdkc5bTw8wRDcLclmdvw9ZWMsyp8WK0S0qNZUFhY0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0cUM9h7u5ONIOosrIe5QeXeipFyPez79VBDRzjBsc7gHUJCsJ
	wp8qwquhsY94Pss5KCCXrco0iKgUXBMjTAPSbv1/cVmBwrBlL6CCKe3Vhfv5bfg=
X-Gm-Gg: ASbGncsHddLGOgLsD7zO9BbzJ0ECdfArca+SiwwrHu2++/UQELv6QJ0mZdAupGiJamS
	W08qJu3+GLZi2lxwu9p4E9kjXXRFiny+WG6GuKO3LF+grio1H6ApByeQSSQflbkbOVhfUJsOswr
	mVgxNMR5D6RVfvsI+ImdNAffeljBfsLO4AodRwpn7h1n8YkuolMVvcaMMhVy4oU/g343Aar6uOO
	HlaIKl32xBW1xEFux87/hnfL6ImS2xxPe5fgdr6NX8RFX7atiRVk8vn7wUcE1lu2nLB4q4IGtDX
	JIGmR/MD+T90QePSTOowi3Njp4Q6mzfs3hARG6on/4DiYTzaArJb+USG2U1FISG3Z5ROZnW+
X-Google-Smtp-Source: AGHT+IFEBbxQyaP0/2DWYOKB8ElC0B8gdpp7QbNW8c37nqwtwNfKPMEljUeKpMeGoOykV8PZYEcmVQ==
X-Received: by 2002:a05:6402:2789:b0:5e0:52df:d569 with SMTP id 4fb4d7f45d1cf-5e4d6b852d0mr16127811a12.28.1741079868692;
        Tue, 04 Mar 2025 01:17:48 -0800 (PST)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223501f9dd8sm90968655ad.57.2025.03.04.01.17.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 01:17:48 -0800 (PST)
Message-ID: <6f4017dc-2b3d-4b1a-b819-423acb42d999@suse.com>
Date: Tue, 4 Mar 2025 19:47:34 +1030
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: alloc_pages_bulk: remove assumption of populating
 only NULL elements
To: Yunsheng Lin <linyunsheng@huawei.com>, Yishai Hadas <yishaih@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Carlos Maiolino <cem@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Trond Myklebust <trondmy@kernel.org>,
 Anna Schumaker <anna@kernel.org>, Chuck Lever <chuck.lever@oracle.com>,
 Jeff Layton <jlayton@kernel.org>, Neil Brown <neilb@suse.de>,
 Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>,
 Tom Talpey <tom@talpey.com>
Cc: Luiz Capitulino <luizcap@redhat.com>,
 Mel Gorman <mgorman@techsingularity.net>, Dave Chinner
 <david@fromorbit.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org,
 netdev@vger.kernel.org, linux-nfs@vger.kernel.org
References: <20250228094424.757465-1-linyunsheng@huawei.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <20250228094424.757465-1-linyunsheng@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2025/2/28 20:14, Yunsheng Lin 写道:
> As mentioned in [1], it seems odd to check NULL elements in
> the middle of page bulk allocating, and it seems caller can
> do a better job of bulk allocating pages into a whole array
> sequentially without checking NULL elements first before
> doing the page bulk allocation for most of existing users.
> 
> Through analyzing of bulk allocation API used in fs, it
> seems that the callers are depending on the assumption of
> populating only NULL elements in fs/btrfs/extent_io.c and
> net/sunrpc/svc_xprt.c while erofs and btrfs don't, see:
> commit 91d6ac1d62c3 ("btrfs: allocate page arrays using bulk page allocator")

If you want to change the btrfs part, please run full fstests with 
SCRATCH_DEV_POOL populated at least.

[...]
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index f0a1da40d641..ef52cedd9873 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -623,13 +623,26 @@ int btrfs_alloc_page_array(unsigned int nr_pages, struct page **page_array,
>   			   bool nofail)
>   {
>   	const gfp_t gfp = nofail ? (GFP_NOFS | __GFP_NOFAIL) : GFP_NOFS;
> -	unsigned int allocated;
> +	unsigned int allocated, ret;
>   
> -	for (allocated = 0; allocated < nr_pages;) {
> -		unsigned int last = allocated;
> +	/* Defragment page_array so pages can be bulk allocated into remaining
> +	 * NULL elements sequentially.
> +	 */
> +	for (allocated = 0, ret = 0; ret < nr_pages; ret++) {
> +		if (page_array[ret]) {

You just prove how bad the design is.

All the callers have their page array members to initialized to NULL, or 
do not care and just want alloc_pages_bulk() to overwrite the 
uninitialized values.

The best example here is btrfs_encoded_read_regular().
Now your code will just crash encoded read.

Read the context before doing stupid things.

I find it unacceptable that you just change the code, without any 
testing, nor even just check all the involved callers.

> +			page_array[allocated] = page_array[ret];
> +			if (ret != allocated)
> +				page_array[ret] = NULL;
> +
> +			allocated++;
> +		}
> +	}
>   
> -		allocated = alloc_pages_bulk(gfp, nr_pages, page_array);
> -		if (unlikely(allocated == last)) {
> +	while (allocated < nr_pages) {
> +		ret = alloc_pages_bulk(gfp, nr_pages - allocated,
> +				       page_array + allocated);

I see the new interface way worse than the existing one.

All btrfs usage only wants a simple retry-until-all-fulfilled behavior.

NACK for btrfs part, and I find you very unresponsible not even bother 
running any testsuit and just submit such a mess.

Just stop this, no one will ever take you serious anymore.

Thanks,
Qu


