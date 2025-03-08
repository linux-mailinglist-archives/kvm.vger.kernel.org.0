Return-Path: <kvm+bounces-40477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4258EA578CE
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 07:44:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48DE3173C40
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 06:44:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C84419C552;
	Sat,  8 Mar 2025 06:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="XVgz4JYP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A25914B086
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 06:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741416240; cv=none; b=rH/F//Nwz28d+PpqKhPs+WD7Yv2NdkaLayhNDuBeplXsIqREGbhPE+Oq4n31NQOkaHagPESYzdivk4ajM28Qcnd32xbBpPoeXIO33XqvHhhk6wD9P9MQOPzKo3Fd59BGXUyGL0SIYLn1ZlOxdTondE6KSjk0Zlw6G0kYW1wyE7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741416240; c=relaxed/simple;
	bh=UtKF8Vg/8ur3x9ZZufYsKRKBGlH122N5R3zj7Hw67+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LfOJI9vArH6WoamMaMNjpftL25vKllESq/IqhGqKPVVVLXsQOLP9+6rW9SR0bfIZyP1nKBqv97nQICAG+365IfLHlEUmHbhW+KzyESQ4PoNjZ2P0y4Ak25OZ29sAjHbdeaXt4e8Q1KUSuxCjmRmfKn+z8IVsiwY8ZSQe/t5svwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=XVgz4JYP; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-22359001f1aso65318795ad.3
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 22:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1741416237; x=1742021037; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L7XYd6bILvV5S9oc7kfROdvIGE+piMUFy2TT1wDFAAs=;
        b=XVgz4JYPbICcYstIjrVqj42hOBnrp1eXLLfvNDdBC8iohlUs8vJlpZFFfy0v7Gk7hR
         uJV2w6kFuLuQHvLiRg73yX/FWNvclFt941gRoWvfOtKpP9wVSyi3vYjme8uGSUCTRbTh
         Id/K4ob38oUXP1yAjqFPAoM/nIbmkM1Wgpn9Xn3U/NzIZcUNiPuW9/nBuXJHRnvp1N18
         4CoBETKcRJV+gN4jJ6zaeKkMsixI3KtURKfpbQ/8grjrm7LrjKNBBgbjILpdJnK2yuJp
         7hAUDfVmsCRX/8XvxpIpy/Md2vp5bxSzNyEdsZxh1y33ZtUgsRQbLjlzRnLy7I5jMsEA
         8RwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741416237; x=1742021037;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L7XYd6bILvV5S9oc7kfROdvIGE+piMUFy2TT1wDFAAs=;
        b=hlBZqNh75S2XsbWDBe5jBhjjCbq9pNwHghkT2xSZlXMgyisa5uIeE2wdGdJAay56jb
         Zl1tstQgDrtNMlgrXA7usm9is2wdq6g+VrHE07BdFkHFgVOuB211HZUkEUz++EWkpQsi
         675EXQ4vywaTF9BB7gGQQ/Qb4+KeaVvOmpWkYvonVjqTfZ7SJHhb6BnABMlklPbBmkbY
         tsCI81+jUKpGUeRX6F/unxdtlsG67uYakUXjKcRKey8KwwjsUl0stA+yriojqNwYIRaA
         7mqjAtE0QKftRQMKgrc916g/tWI6fBnGUNXKju9LRpo7hD7emNOcfr34Z9pMeLqCMubz
         olZA==
X-Forwarded-Encrypted: i=1; AJvYcCUke4Q7ZLXxFqv/XlLS4hkjhBIsVVX5k3hYEpZo9irJYHmJTeYbc6OQeuQfRtH4ShIm/gE=@vger.kernel.org
X-Gm-Message-State: AOJu0YybHl6N51ZZlI8v5HZwTftVVkpZFlO7uwlGMZsqOc3ZWC5Ez6Yb
	sP5daCz26aNe92SyeuYqmG2Nd/IE5wRld1tN7HTslNqC2IA2GNE6vo4sCT2LwjI=
X-Gm-Gg: ASbGncvp8d1FcPhkYD8qrbBsqhTrSuc3O2oKpQT50MNAotWPU6KO14to/pVwCtbiQ0s
	G72ElQAFh+BNFhld66GeEdSzq3/paP+DPGZKEmFKt8qCmmkzkuo3QVWnwJC2VD1MTcA3Twe6H//
	7Kub5y6LsbtFziyjT37WWd9VCT3abR1OT4fVU8URK/0P95P1jXo0oWDPsE5aJ4GIljnTANi9ZJ9
	SJ7DUHgMa773w7F27heHQps50yxaii4deQnchgbf4ceaXaBmxjm12UVZ+NLfjYQa2sEovtoBo98
	p1YuI7MrpS2xeXWTD/4JrX8T7jQnExGnlD5SZ15p9w/xmKkMTlrs9rDKCy6cjrV7djxv97uMSQl
	mHV8Rp8svO0QzdU2ZOv5F
X-Google-Smtp-Source: AGHT+IF/hoytkHf/78nzK/gEIzqXnGG5MP6Y8FgGhVp8Zx6LE+l7N0K13IdyKh5Omm9Q6AhxhqYyLg==
X-Received: by 2002:a17:903:98b:b0:223:397f:46be with SMTP id d9443c01a7336-22428ad4a09mr106979815ad.47.1741416237682;
        Fri, 07 Mar 2025 22:43:57 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109e816csm40661065ad.54.2025.03.07.22.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 22:43:57 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tqnuc-0000000ALct-08Dn;
	Sat, 08 Mar 2025 17:43:54 +1100
Date: Sat, 8 Mar 2025 17:43:53 +1100
From: Dave Chinner <david@fromorbit.com>
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>, Neil Brown <neilb@suse.de>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Luiz Capitulino <luizcap@redhat.com>,
	Mel Gorman <mgorman@techsingularity.net>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	netdev@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH v2] mm: alloc_pages_bulk: remove assumption of populating
 only NULL elements
Message-ID: <Z8vnKRJlP78DHEk6@dread.disaster.area>
References: <20250228094424.757465-1-linyunsheng@huawei.com>
 <Z8a3WSOrlY4n5_37@dread.disaster.area>
 <91fcdfca-3e7b-417c-ab26-7d5e37853431@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91fcdfca-3e7b-417c-ab26-7d5e37853431@huawei.com>

On Tue, Mar 04, 2025 at 08:09:35PM +0800, Yunsheng Lin wrote:
> On 2025/3/4 16:18, Dave Chinner wrote:
> 
> ...
> 
> > 
> >>
> >> 1. https://lore.kernel.org/all/bd8c2f5c-464d-44ab-b607-390a87ea4cd5@huawei.com/
> >> 2. https://lore.kernel.org/all/20250212092552.1779679-1-linyunsheng@huawei.com/
> >> CC: Jesper Dangaard Brouer <hawk@kernel.org>
> >> CC: Luiz Capitulino <luizcap@redhat.com>
> >> CC: Mel Gorman <mgorman@techsingularity.net>
> >> CC: Dave Chinner <david@fromorbit.com>
> >> CC: Chuck Lever <chuck.lever@oracle.com>
> >> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> >> Acked-by: Jeff Layton <jlayton@kernel.org>
> >> ---
> >> V2:
> >> 1. Drop RFC tag and rebased on latest linux-next.
> >> 2. Fix a compile error for xfs.
> > 
> > And you still haven't tested the code changes to XFS, because
> > this patch is also broken.
> 
> I tested XFS using the below cmd and testcase, testing seems
> to be working fine, or am I missing something obvious here
> as I am not realy familiar with fs subsystem yet:

That's hardly what I'd call a test. It barely touches the filesystem
at all, and it is not exercising memory allocation failure paths at
all.

Go look up fstests and use that to test the filesystem changes you
are making. You can use that to test btrfs and NFS, too.

-Dave.

-- 
Dave Chinner
david@fromorbit.com

