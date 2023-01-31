Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73AFE68218C
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 02:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbjAaBwK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 20:52:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjAaBwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 20:52:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE24E29405
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 17:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675129878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mBv8DJNmeWTzhqoixUePfk7DvfX/r91Bih49ZwlSTgg=;
        b=BRj1USuTPFBumDJbbmKkNbKFcQ9lnE38qXmFeSCSvZiL9Ha9lTYM92+KETImf6FeFEWrOP
        OLaF10Un446oJBSAbln5qD/FImdqT7fapt9Rfo1zG2ChuRFj8He7Su2LJg603zJ0L/ZoCt
        pZzjYztEKYpMbzL2bKMtobod6E7mxe8=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-648-Bh2MP0weNb-MDDZDdxjyhg-1; Mon, 30 Jan 2023 20:51:16 -0500
X-MC-Unique: Bh2MP0weNb-MDDZDdxjyhg-1
Received: by mail-pj1-f71.google.com with SMTP id nb8-20020a17090b35c800b0022bb3fd0718so5297015pjb.4
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 17:51:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mBv8DJNmeWTzhqoixUePfk7DvfX/r91Bih49ZwlSTgg=;
        b=EEBwAK+o5pVb3Nz0altFgH8aLhV8nONN4i6tVggF5U6IHkM2AZfr2q6ahUn0s4YqHF
         Yh5NFb1Fv1VCDB31KSCdBh77SXf0w2sQ0/8aXYAztGVmL03umyR8+J5vOlzcITny5O+M
         B7pVwQB09FGUltPqv0j9qjS1DUdiVDnULz1J2eO55DJWsPgo5DIYHGkIyqalHuyUdEQL
         PyERp93GO6b0375V9to2Ka//YIBPA6rl1RJN27QoM86A41Gx90RxW2EneNxnC54kcVoY
         N+5JmOVhxfkIBmersIWemkn1k+npqQzw+b+APNKgWiHbvW2LD9qawzxuuch7Q/BCqzYq
         CBJg==
X-Gm-Message-State: AO0yUKXhJwHMZeLjhl5vvHBj3L47y1wHkU8n+3A+QZP0b3Zj/J5RZcsJ
        Xm17VmpCHnVBcZsH4UU90fHwW1zD8kgqHGCVz5SCGJPOpFRn1bRAeoqqSSE8k51MCFr22jb0aKK
        MnigDKKxuzN5x
X-Received: by 2002:a17:902:d487:b0:196:15af:e6de with SMTP id c7-20020a170902d48700b0019615afe6demr29574980plg.68.1675129875390;
        Mon, 30 Jan 2023 17:51:15 -0800 (PST)
X-Google-Smtp-Source: AK7set8JSjJ+sRvtPcXP6fVdufCYZ8fk74MG4aecVDj2Iej+5W2CdxzxrzRUj04G/QWJkYRImmyA4Q==
X-Received: by 2002:a17:902:d487:b0:196:15af:e6de with SMTP id c7-20020a170902d48700b0019615afe6demr29574939plg.68.1675129875072;
        Mon, 30 Jan 2023 17:51:15 -0800 (PST)
Received: from [10.72.13.217] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id o17-20020a170902d4d100b00196077ba463sm8430985plg.123.2023.01.30.17.51.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 17:51:14 -0800 (PST)
Message-ID: <ba3adefd-f2d8-d074-4dfc-5677c3cd71a3@redhat.com>
Date:   Tue, 31 Jan 2023 09:51:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 12/23] ceph: use bvec_set_page to initialize a bvec
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>, Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Mike Marshall <hubcap@omnibond.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        devel@lists.orangefs.org, io-uring@vger.kernel.org,
        linux-mm@kvack.org
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-13-hch@lst.de>
 <CAOi1vP_b77Pq=hYmFMi1zGGRMee2uNjbAbHz_gCCoByOdbRqLw@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP_b77Pq=hYmFMi1zGGRMee2uNjbAbHz_gCCoByOdbRqLw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 31/01/2023 02:02, Ilya Dryomov wrote:
> On Mon, Jan 30, 2023 at 10:22 AM Christoph Hellwig <hch@lst.de> wrote:
>> Use the bvec_set_page helper to initialize a bvec.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> ---
>>   fs/ceph/file.c | 10 +++++-----
>>   1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 764598e1efd91f..6419dce7c57987 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -103,11 +103,11 @@ static ssize_t __iter_get_bvecs(struct iov_iter *iter, size_t maxsize,
>>                  size += bytes;
>>
>>                  for ( ; bytes; idx++, bvec_idx++) {
>> -                       struct bio_vec bv = {
>> -                               .bv_page = pages[idx],
>> -                               .bv_len = min_t(int, bytes, PAGE_SIZE - start),
>> -                               .bv_offset = start,
>> -                       };
>> +                       struct bio_vec bv;
>> +
>> +                       bvec_set_page(&bv, pages[idx],
> Hi Christoph,
>
> There is trailing whitespace on this line which git complains about
> and it made me take a second look.  I think bvec_set_page() allows to
> make this more compact:
>
>          for ( ; bytes; idx++, bvec_idx++) {
>                  int len = min_t(int, bytes, PAGE_SIZE - start);
>
>                  bvec_set_page(&bvecs[bvec_idx], pages[idx], len, start);
>                  bytes -= len;
>                  start = 0;
>          }
>
This looks better.

Thanks

