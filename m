Return-Path: <kvm+bounces-40527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F0B1BA5848D
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 14:41:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD580188D3B2
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 13:41:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D89611DDA09;
	Sun,  9 Mar 2025 13:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dZy+j99A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6041CC8B0;
	Sun,  9 Mar 2025 13:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741527670; cv=none; b=CseRxX/+UU46QL+ZWParpah/6OGC5r4exa1Incuka7ri6NP+BNKYk89B69773AR6/dn8nZOvWZl9hrbN3xSSXkZRVYfZyKzsPMXmLkeRhxRtfFOniJYGC/knylrjnFHbcdhUDlQB1eil4vU63SlAcJEtJmArH0oGGed6y3Bw0ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741527670; c=relaxed/simple;
	bh=fLQGO5wiRlZUKjdUjb206YTBiUBA4D9ukOUBp9rUGdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pVZdJh3pH/MJCkmowACkVdNLpbYBHA+fKCFcWVxGl041bWcPoFfDnWYZKAw2gQJfCEpeAqXHT8Ypl/rlxaH8GVEyqRLNdHA3nlbdNbTFW2bIat+CmH30Psg4NLFO3eB0nRFP9UHC5GGOEEhRwzneTnrMYylUUdUXpqWsklq6pJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dZy+j99A; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-2239c066347so56554275ad.2;
        Sun, 09 Mar 2025 06:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741527668; x=1742132468; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LbqFVYGZKiXAHZ9rqZe+rnsj7EpBf3DH/8Ue+vs/s7U=;
        b=dZy+j99A6lc+e7y/Qzm6Q/1YoWVfMsfZGoIK0xCSx8Lwc5xeDjobk9XNJd/XQiJQcl
         fKTkMAID7+x41913IaPmy7gthptTfzpQCY6E9bgYEl7g9VUtH7rszLt3z9xOq14xzg7P
         cz5V0nBjPCzBMASmcwDMaNVNolWbqo/D/cjl5Zy5P7V/HASGSFU2BFnE4apStu40BYDv
         9an5/hEmzDW1YKnddc/OdDjymcY2wWBHIVm5h/vmFl4T1LcNr583+O/w7ggHosgXtrVK
         hW+fKFL/J6a80Vq746AxAp3tMPTKTvMdHQIp5ptlKp9v0TRdDq9eTICjhMDm7VyhTupm
         ui4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741527668; x=1742132468;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LbqFVYGZKiXAHZ9rqZe+rnsj7EpBf3DH/8Ue+vs/s7U=;
        b=WFRCj04H7h5vMg7NHlu7BYMTq1l5XByuzvyWvVADkqIZNcZkmb11QI3pEVDAN0o8Ou
         gVvssHzJqtSnT7ZKuATB+xo3DgGXSZTS6PNgi4XRlI+lkNWG4MwrfuNJJR0YcbgUo194
         328PbtsAb8jME0rK4gwhWqtmFWC4nd0/XPH1v/fnXcFMnfds9zY/R77VMQUV4jE5EaaL
         NoAK26PBqJUBCP6pOTDo3L3EumhzYvn62tSlHs7rfVeq9LO6MybQ+CZENdMadNwoPP8z
         9qsm1MJHz0UXqE7NxBtBDmy2qZ+w8SOv1YRk05VLIEQRlO/u24CKLzGPeOQ76+T80i7m
         VnkA==
X-Forwarded-Encrypted: i=1; AJvYcCU4pxKYCowU7A0H88lZIu1N7tPwQcBBEIJIe/Z39TiPE2qGuxOOBph/QM9XOusUOYoVa0bhBfMAPMz/eos=@vger.kernel.org, AJvYcCX0WUPa+TwSxc5Miy2+Z595KX+nprvF+KjotaUHSpvFwlI0tMUqy1gqJDbx+4SXY7e6VsD2Kk014x5PP87K@vger.kernel.org, AJvYcCXDaD8JcHay07zKcbU1GHcyE95AUMCxDMx/Lin50xLMNPDJ9HlaL3EZKm+r7mPJBx9iIl0=@vger.kernel.org, AJvYcCXKttusgU40iG9k4AOvniQ1Ji9na6JPjvMqOiDp/5NoOJdkdqIVbSSUshxJa0xA/9PIkci5cgkf@vger.kernel.org, AJvYcCXPgiTER58b3naZxw7Nv0LzRavi41sCfH8KMcQpmDL1LsIFuKp4HzL8nuiK/Ko8YBjuruH8TZSOTA6E@vger.kernel.org, AJvYcCXpYURkqSH2a27S1k6L4gK6XM7GREtpsp9IqzjLLdyjy3eNLHgKouqmn7X1qbKZccuBtMcrsk3MC6bE@vger.kernel.org
X-Gm-Message-State: AOJu0YwT5GiCO+CGOMi4fz838i7o3QhNpxlxhJ2CLYVsEEi2oYiXhuKi
	08LCEUGi5oz7hqtIVi4qJzSb71/rVgYbBYVibPOaeG8TATTwuWPK
X-Gm-Gg: ASbGnctlwAfgPZ6UvKrp6DxeT8cTrjY+6xcODqrIBWSHh3i5aFgropbQ9tEUjxT+aWp
	4Ijy96OUipYiuJ3zq4Qv018FlTVdQE38mE9r3+1c4DkI0sNdpdPWQ4OhbNX23Tl9dxYudAo3yRw
	6qMHFebk0EyT5zcNDv32nIx+swtfCYVApWvBx13OLddNujtpX0saIZksmwgAZaxllj74OYvXfce
	hrjz59n6TQnXI3X0NRyX5YiEQIY+WN3VO7/eNM5nSr5hULcsBz3q/bHvNEVgYBY/wgaFylsv/dU
	q+bxUN4phtCu7JSBcRB74e3q48qW/1HKPZ8LFWykh4bwocUEHmfpn+eMSymRyVqjlfacXp5DEsi
	NF7YIgRQ1t3tPAgXjump9bh4t3M2KQQ==
X-Google-Smtp-Source: AGHT+IFypNCMIn41ibdTDNx4lnj5ojm64dR+2U0xpw0STk3CxsR4PZycEa3AfGJqpDAqBoyMWdx6gQ==
X-Received: by 2002:a05:6a00:2e17:b0:736:5c8e:bab8 with SMTP id d2e1a72fcca58-736aa9c1effmr17581861b3a.3.1741527667817;
        Sun, 09 Mar 2025 06:41:07 -0700 (PDT)
Received: from ?IPV6:2409:8a55:301b:e120:c508:514a:4065:877? ([2409:8a55:301b:e120:c508:514a:4065:877])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736d4d14f66sm619646b3a.82.2025.03.09.06.40.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Mar 2025 06:41:07 -0700 (PDT)
Message-ID: <cce03970-d66f-4344-b496-50ecf59483a6@gmail.com>
Date: Sun, 9 Mar 2025 21:40:52 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: alloc_pages_bulk: remove assumption of populating
 only NULL elements
To: Dave Chinner <david@fromorbit.com>, Yunsheng Lin <linyunsheng@huawei.com>
Cc: Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
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
 Tom Talpey <tom@talpey.com>, Luiz Capitulino <luizcap@redhat.com>,
 Mel Gorman <mgorman@techsingularity.net>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
 linux-nfs@vger.kernel.org
References: <20250228094424.757465-1-linyunsheng@huawei.com>
 <Z8a3WSOrlY4n5_37@dread.disaster.area>
 <91fcdfca-3e7b-417c-ab26-7d5e37853431@huawei.com>
 <Z8vnKRJlP78DHEk6@dread.disaster.area>
Content-Language: en-US
From: Yunsheng Lin <yunshenglin0825@gmail.com>
In-Reply-To: <Z8vnKRJlP78DHEk6@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/8/2025 2:43 PM, Dave Chinner wrote:

...

>> I tested XFS using the below cmd and testcase, testing seems
>> to be working fine, or am I missing something obvious here
>> as I am not realy familiar with fs subsystem yet:
> 
> That's hardly what I'd call a test. It barely touches the filesystem
> at all, and it is not exercising memory allocation failure paths at
> all.
> 
> Go look up fstests and use that to test the filesystem changes you
> are making. You can use that to test btrfs and NFS, too.

Thanks for the suggestion.
I used the below xfstests to do the testing in a VM, the smoke testing
seems fine for now, will do a full testing too:
https://github.com/tytso/xfstests-bld

Also, it seems the fstests doesn't support erofs yet?

> 
> -Dave.
> 


