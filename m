Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A5F6E45E6
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 12:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjDQK7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 06:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjDQK6y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 06:58:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961A66198
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 03:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681728951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1wWR6LdExfwjEsSRDi6jXKipEXf+Q0zIDWbRNdZy7RQ=;
        b=LA7zYhjDS/oQF9/rcDrkkGntGnW+ebwCriv90C318xtI/qdBAgW48yfFHvMaNsJa0cXmKw
        VuFtSvKwg10Ms/xsUD3mVzfhViwl4tQ3AVKvtGiNKC+S90cjOY3FA2+6pBZrEoDbOILuCW
        PLrob+WU0Y7cjc7zVx21XkJ7fRoTmDw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-333-Ds4dGVa3Mka6E5wB2QKsVQ-1; Mon, 17 Apr 2023 06:55:50 -0400
X-MC-Unique: Ds4dGVa3Mka6E5wB2QKsVQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-2f69e5def13so387453f8f.0
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 03:55:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681728949; x=1684320949;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1wWR6LdExfwjEsSRDi6jXKipEXf+Q0zIDWbRNdZy7RQ=;
        b=FCtin5ITNcKvh949LUNaBtYeLTY53QYVYDzVQ3lKUZDuUgHC2QlOXaCuC2nEE/WjOs
         bb4cpEUiFxFOZItVHCI1Xf2Br2I02aIPsHOkgYz5pIYjvsVPLITL8+Wkg5Qy/XPno0DU
         Zw39OYeG7Ehs7R9n5oG0wUB91kdbJoaq4c75DtBD6S7OkmHPlDatFxWGMQVsSULsnZ2a
         oJgJNDANfY1WjB73c5X5gYI0xBUCi7ppUnwnLtu/YNpLgzpg1iG03yQ612tZ10hX2W6t
         KQqFws8JMKJfzTWjNJPAsax5rIFOKBtBG2GXUUkMnQAM+rfXiFKb1QaENwz7FOL9hjHW
         9DCw==
X-Gm-Message-State: AAQBX9cOv1JVTpXvOh+u9Um/gPj2vmiwxfUheBYrAyorQ1jxUDTfJVu7
        Ps4qTlig5oo9Ip2Qt7jVoo6w0izQq02xGTDtkfqf3tD/A9ARAn6Y0seNG6HKbeVA8K5+gQjNkLg
        oDFHUvH2Q/43D
X-Received: by 2002:a5d:564a:0:b0:2ee:fc1b:b7ba with SMTP id j10-20020a5d564a000000b002eefc1bb7bamr5554687wrw.39.1681728949288;
        Mon, 17 Apr 2023 03:55:49 -0700 (PDT)
X-Google-Smtp-Source: AKy350b4mqRWHxHUhRiKtx3CxYgUioujgL380Qdaxi7z1qv8uqaf0xsSOnV1ktQrpGXmyp9r8e6DcA==
X-Received: by 2002:a5d:564a:0:b0:2ee:fc1b:b7ba with SMTP id j10-20020a5d564a000000b002eefc1bb7bamr5554664wrw.39.1681728948942;
        Mon, 17 Apr 2023 03:55:48 -0700 (PDT)
Received: from ?IPV6:2003:cb:c700:fc00:db07:68a9:6af5:ecdf? (p200300cbc700fc00db0768a96af5ecdf.dip0.t-ipconnect.de. [2003:cb:c700:fc00:db07:68a9:6af5:ecdf])
        by smtp.gmail.com with ESMTPSA id c22-20020a05600c0ad600b003f16fc33fbesm5319894wmr.17.2023.04.17.03.55.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 03:55:48 -0700 (PDT)
Message-ID: <887ad211-b63e-5f04-9a55-66027a8dc1cc@redhat.com>
Date:   Mon, 17 Apr 2023 12:55:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v3 2/7] mm/gup: remove unused vmas parameter from
 pin_user_pages_remote()
Content-Language: en-US
To:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        iommu@lists.linux.dev
Cc:     Matthew Wilcox <willy@infradead.org>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>
References: <cover.1681558407.git.lstoakes@gmail.com>
 <59022490ef05da7310e6abd7f42df933bebdda2a.1681558407.git.lstoakes@gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <59022490ef05da7310e6abd7f42df933bebdda2a.1681558407.git.lstoakes@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15.04.23 14:09, Lorenzo Stoakes wrote:
> No invocation of pin_user_pages_remote() uses the vmas parameter, so remove
> it. This forms part of a larger patch set eliminating the use of the vmas
> parameters altogether.
> 
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

