Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1E95F6FB3
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 22:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiJFUtM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 16:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbiJFUsm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 16:48:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1397CCAE41
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 13:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665089267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=adT/t+2LUPY67D+MO5ugA68nSE+1uLG2teBX8ALBZRs=;
        b=UZVuPDvwpGYIOy9PhkhR0yx9KEgzRfdDXYi4CsKVCR8As66SVMh4RrQ9Ef8J+vKVTX6QkE
        t1X4tNyOn3j3lKRUS2lmqwp4uaNcpTtKO5+1B3tmIQdJLbJJdlGf5JvnDcTHc69OskQZJO
        RPUQDMDqMU1rdAocoMO8bbKMAoPpWXU=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-526-s1c9_PgzMDmTGeDENKV4zA-1; Thu, 06 Oct 2022 16:47:46 -0400
X-MC-Unique: s1c9_PgzMDmTGeDENKV4zA-1
Received: by mail-qk1-f200.google.com with SMTP id x22-20020a05620a259600b006b552a69231so2368323qko.18
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 13:47:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=adT/t+2LUPY67D+MO5ugA68nSE+1uLG2teBX8ALBZRs=;
        b=Kzw3JPQDSQoJDznPmVCoPbCunS6WoW8mU8FcGZWAAQ1IApZHp44Pi5b/qiCINfM3TR
         yGbw4lKrtmJjmha5azqCqaFl/FvCrbf8X4VoHqX5k0HRtapHfePxoOLLJ6z3ruErXZc5
         b5IojeDAHPPMjMExujX71SoRh26VbnvFdyLqtMHyqamK1iowzTLL0kGmbQOjxElClDvw
         CeB9wRpRC7SsRwoOZKu1hc8+aRyZ7JY59qMC7nSUwnIBV+ABHz+CykHfD8dxzJqdfkzS
         Cux1NeBQWvM1Bve2HrxAETmwtkwCmqRPjnfitpKr+WZ+LYn6FkStZwsXzNL9t9Z46Ypr
         Toig==
X-Gm-Message-State: ACrzQf3u0A5o0csNajneCK6GJePrM9m4f9SE9QcYIgm1nbC0c6fOEOOQ
        Ovm2QUB2zfmfi5xrE7YRL/fMnKkj88ONxsPnXjrhViA77wkP8nmz7S0djLjPhonskRxygs1RoOE
        n3vFHWS24OGbw
X-Received: by 2002:ac8:5c8b:0:b0:35c:cfba:560d with SMTP id r11-20020ac85c8b000000b0035ccfba560dmr1781680qta.557.1665089265891;
        Thu, 06 Oct 2022 13:47:45 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5PcrNxp4hySpihSobbNgNfKLDpUy/y0qblsbVrVjie3fkLDVXAespXYmjgnhOvHx0IMoOnxg==
X-Received: by 2002:ac8:5c8b:0:b0:35c:cfba:560d with SMTP id r11-20020ac85c8b000000b0035ccfba560dmr1781660qta.557.1665089265683;
        Thu, 06 Oct 2022 13:47:45 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id l11-20020a37f90b000000b006b8e8c657ccsm49514qkj.117.2022.10.06.13.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 13:47:45 -0700 (PDT)
Date:   Thu, 6 Oct 2022 16:47:43 -0400
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v3 0/3] kvm/mm: Allow GUP to respond to non fatal signals
Message-ID: <Yz8+7/1uCzcGumBS@x1n>
References: <20220817003614.58900-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220817003614.58900-1-peterx@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 16, 2022 at 08:36:11PM -0400, Peter Xu wrote:
> v3:
> - Patch 1
>   - Added r-b for DavidH
>   - Added support for hugetlbfs
> - Patch 2 & 3
>   - Comment fixes [Sean]
>   - Move introduction of "interruptible" parameter into patch 2 [Sean]
>   - Move sigpending handling into kvm_handle_bad_page [Sean]
>   - Renamed kvm_handle_bad_page() to kvm_handle_error_pfn() [Sean, DavidM]
>   - Use kvm_handle_signal_exit() [Sean]

Any further comments from kvm side?  Thanks,

-- 
Peter Xu

