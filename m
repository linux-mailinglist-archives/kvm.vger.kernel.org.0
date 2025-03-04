Return-Path: <kvm+bounces-40022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D4478A4DD88
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 13:09:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D856A18960B4
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 12:10:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAB3B20298D;
	Tue,  4 Mar 2025 12:09:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB561FF601;
	Tue,  4 Mar 2025 12:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741090182; cv=none; b=RSoKzq8IZ6xkbm4EjSDHCHWPUikvMJed6hIlfg7F5wWMVrgdvlw//asHOkjdWkongHt6+Um56kBF0gZt/R2H8Fu03TU3/t1Wsb7tHtDHM/PDCldUDOy1O91t2uZREouPfsr4KTelxmsxZQ8JNrukQqLE8QLSVc0W9IerCXYpmbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741090182; c=relaxed/simple;
	bh=4S8tqaK0XJCLIv/7Rv3hJVe8rj1mH8s+KkdKMp6uzeo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=DaXZqM0wD0MrA8Ot0rtwhQJD1l3t48U+XdoRWzCJZd2X9Xux6zoGaUno/KUm39M88Xu/y2sNlX4ZXXSKUlMCUSKXd6C4qLPVELtoZ5XYRJjeUDkDf9qmRSBzCjgNW0EI9btFvx1GPYZL8vOjBrFtOeDDynft8NV7oVub34d4d8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Z6ZBX3494z2DkHc;
	Tue,  4 Mar 2025 20:05:24 +0800 (CST)
Received: from dggpemf200006.china.huawei.com (unknown [7.185.36.61])
	by mail.maildlp.com (Postfix) with ESMTPS id D7E721A016C;
	Tue,  4 Mar 2025 20:09:35 +0800 (CST)
Received: from [10.67.120.129] (10.67.120.129) by
 dggpemf200006.china.huawei.com (7.185.36.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 4 Mar 2025 20:09:35 +0800
Message-ID: <91fcdfca-3e7b-417c-ab26-7d5e37853431@huawei.com>
Date: Tue, 4 Mar 2025 20:09:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: alloc_pages_bulk: remove assumption of populating
 only NULL elements
To: Dave Chinner <david@fromorbit.com>
CC: Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Shameer
 Kolothum <shameerali.kolothum.thodi@huawei.com>, Kevin Tian
	<kevin.tian@intel.com>, Alex Williamson <alex.williamson@redhat.com>, Chris
 Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba
	<dsterba@suse.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep
 Dhavale <dhavale@google.com>, Carlos Maiolino <cem@kernel.org>, "Darrick J.
 Wong" <djwong@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Jesper
 Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Trond Myklebust
	<trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck Lever
	<chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, Neil Brown
	<neilb@suse.de>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo
	<Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Luiz Capitulino
	<luizcap@redhat.com>, Mel Gorman <mgorman@techsingularity.net>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
	<linux-erofs@lists.ozlabs.org>, <linux-xfs@vger.kernel.org>,
	<linux-mm@kvack.org>, <netdev@vger.kernel.org>, <linux-nfs@vger.kernel.org>
References: <20250228094424.757465-1-linyunsheng@huawei.com>
 <Z8a3WSOrlY4n5_37@dread.disaster.area>
Content-Language: en-US
From: Yunsheng Lin <linyunsheng@huawei.com>
In-Reply-To: <Z8a3WSOrlY4n5_37@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemf200006.china.huawei.com (7.185.36.61)

On 2025/3/4 16:18, Dave Chinner wrote:

...

> 
>>
>> 1. https://lore.kernel.org/all/bd8c2f5c-464d-44ab-b607-390a87ea4cd5@huawei.com/
>> 2. https://lore.kernel.org/all/20250212092552.1779679-1-linyunsheng@huawei.com/
>> CC: Jesper Dangaard Brouer <hawk@kernel.org>
>> CC: Luiz Capitulino <luizcap@redhat.com>
>> CC: Mel Gorman <mgorman@techsingularity.net>
>> CC: Dave Chinner <david@fromorbit.com>
>> CC: Chuck Lever <chuck.lever@oracle.com>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> Acked-by: Jeff Layton <jlayton@kernel.org>
>> ---
>> V2:
>> 1. Drop RFC tag and rebased on latest linux-next.
>> 2. Fix a compile error for xfs.
> 
> And you still haven't tested the code changes to XFS, because
> this patch is also broken.

I tested XFS using the below cmd and testcase, testing seems
to be working fine, or am I missing something obvious here
as I am not realy familiar with fs subsystem yet:

Step to setup the xfs:
dd if=/dev/zero of=xfs_image bs=1M count=1024
losetup -f xfs_image
losetup -a
./mkfs.xfs /dev/loop0
mkdir xfs_test
mount /dev/loop0 xfs_test/

Test shell file:
#!/bin/bash

# Configuration parameters
DIR="/home/xfs_test"              # Directory to perform file operations
FILE_COUNT=100              # Maximum number of files to create in each loop
MAX_FILE_SIZE=1024          # Maximum file size in KB
MIN_FILE_SIZE=10            # Minimum file size in KB
OPERATIONS=10               # Number of create/delete operations per loop
TOTAL_RUNS=10000               # Total number of loops to run

# Check if the directory exists
if [ ! -d "$DIR" ]; then
    echo "Directory $DIR does not exist. Please create the directory first!"
    exit 1
fi

echo "Starting file system test on: $DIR"

for ((run=1; run<=TOTAL_RUNS; run++)); do
    echo "Run $run of $TOTAL_RUNS"

    # Randomly create files
    for ((i=1; i<=OPERATIONS; i++)); do
        # Generate a random file size between MIN_FILE_SIZE and MAX_FILE_SIZE (in KB)
        FILE_SIZE=$((RANDOM % (MAX_FILE_SIZE - MIN_FILE_SIZE + 1) + MIN_FILE_SIZE))
        # Generate a unique file name using timestamp and random number
        FILE_NAME="$DIR/file_$(date +%s)_$RANDOM"
        # Create a file with random content
        dd if=/dev/urandom of="$FILE_NAME" bs=1K count=$FILE_SIZE &>/dev/null
        echo "Created file: $FILE_NAME, Size: $FILE_SIZE KB"
    done

    # Randomly delete files
    for ((i=1; i<=OPERATIONS; i++)); do
        # List all files in the directory
        FILE_LIST=($(ls $DIR))
        # Check if there are any files to delete
        if [ ${#FILE_LIST[@]} -gt 0 ]; then
            # Randomly select a file to delete
            RANDOM_FILE=${FILE_LIST[$RANDOM % ${#FILE_LIST[@]}]}
            rm -f "$DIR/$RANDOM_FILE"
            echo "Deleted file: $DIR/$RANDOM_FILE"
        fi
    done

    echo "Completed run $run"
done

echo "Test completed!"


> 
>> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
>> index 5d560e9073f4..b4e95b2dd0f0 100644
>> --- a/fs/xfs/xfs_buf.c
>> +++ b/fs/xfs/xfs_buf.c
>> @@ -319,16 +319,17 @@ xfs_buf_alloc_pages(
>>  	 * least one extra page.
>>  	 */
>>  	for (;;) {
>> -		long	last = filled;
>> +		long	alloc;
>>  
>> -		filled = alloc_pages_bulk(gfp_mask, bp->b_page_count,
>> -					  bp->b_pages);
>> +		alloc = alloc_pages_bulk(gfp_mask, bp->b_page_count - filled,
>> +					 bp->b_pages + filled);
>> +		filled += alloc;
>>  		if (filled == bp->b_page_count) {
>>  			XFS_STATS_INC(bp->b_mount, xb_page_found);
>>  			break;
>>  		}
>>  
>> -		if (filled != last)
>> +		if (alloc)
>>  			continue;
> 
> alloc_pages_bulk() now returns the number of pages allocated in the
> array. So if we ask for 4 pages, then get 2, filled is now 2. Then
> we loop, ask for another 2 pages, get those two pages and it returns
> 4. Now filled is 6, and we continue.

It will be returning 2 instead of 4 for the second loop if I understand
it correctly as 'bp->b_pages + filled' and 'bp->b_page_count - filled'
is passing to alloc_pages_bulk() API now.

> 
> Now we ask alloc_pages_bulk() for -2 pages, which returns 4 pages...
> 
> Worse behaviour: second time around, no page allocation succeeds
> so it returns 2 pages. Filled is now 4, which is the number of pages
> we need, so we break out of the loop with only 2 pages allocated.
> There's about to be kernel crashes occur.....
> 
> Once is a mistake, twice is compeltely unacceptable.  When XFS stops
> using alloc_pages_bulk (probably 6.15) I won't care anymore. But
> until then, please stop trying to change this code.
> 
> NACK.
> 
> -Dave.

