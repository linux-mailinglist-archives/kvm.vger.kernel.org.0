Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C56B76BAFE
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 19:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbjHARTy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 13:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbjHARTw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 13:19:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4643D2125
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 10:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690910342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iHJDHQhMPESpDTCc7d6m6CZ7cgDoS6a5SZpOnu6DMTE=;
        b=F2uu4HPQLWCB+h9vvUU80Bahh7m8WU1ajh221U6cZTYZ4urCAj0Uvu/I3Wq2ORavgD41b1
        AGWFxCPXQ26bZjPJ0QNdHAtN7pQ06for5jOBpquli1F3+wYqaSqWP5QS2fQ/Fp1pvd4stj
        beQ/qzv23/IYHC5AnCun/WnqAR34XsA=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-Z3Svu-Y3PFydesu-nd3krQ-1; Tue, 01 Aug 2023 13:05:05 -0400
X-MC-Unique: Z3Svu-Y3PFydesu-nd3krQ-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-63d2b88325bso12293596d6.1
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 10:05:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690909504; x=1691514304;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iHJDHQhMPESpDTCc7d6m6CZ7cgDoS6a5SZpOnu6DMTE=;
        b=OIYvJtnlg3AZ2kg0uS9wD4aFTaIWYPYH5H57POLwJGEYO7khtMn7fRZ9AagC5Ii2AT
         U99hqlehMEjFWUgNSGELiaDnF78TPcIi32rbOflXtmo3MTMRPxQin2++J+W8JhLJxd67
         YkpidOIUtFQ6lBQWUUcNEJVoCBqqVaa/HYnh4HEIpIUTj0ZjnzYaLus5q97uKngS7JzQ
         4b7aancnQBV9EZrW7BjuN2fSqXr+YEe9EG/+gr+CS9CsnjiZ8F1k01nqsjyNVDeSjwCo
         yINHf7u4zOHr+p5NUjR3uVREJdVG7vIzup1Rps0yyfPEPltjVCWg/k7Opt2oDt3UZUZf
         qL6Q==
X-Gm-Message-State: ABy/qLbnD4ZQwoYV9OYZyVnAAP0erTX/6j975B9T8+AGKsjZBSC2eKTK
        zXcElNv48yCGuHpXZ6aMqkU37yjGIhXqy18Wpepp5XnLHtwKax+G8lMmxCj0dNbWv4GCEyR0eQD
        keUuNJ2FVoCm3
X-Received: by 2002:ad4:5b83:0:b0:63c:f5fd:d30f with SMTP id 3-20020ad45b83000000b0063cf5fdd30fmr13776737qvp.1.1690909504489;
        Tue, 01 Aug 2023 10:05:04 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFaaBdvX372gnIc+hqJabCioknXLsWVusS1Xd1tIAYtUq1mP4VO3uaCM3OMaXWQ6+iPT5cVCQ==
X-Received: by 2002:ad4:5b83:0:b0:63c:f5fd:d30f with SMTP id 3-20020ad45b83000000b0063cf5fdd30fmr13776714qvp.1.1690909504219;
        Tue, 01 Aug 2023 10:05:04 -0700 (PDT)
Received: from x1n (cpe5c7695f3aee0-cm5c7695f3aede.cpe.net.cable.rogers.com. [99.254.144.39])
        by smtp.gmail.com with ESMTPSA id e30-20020a0caa5e000000b0063d10086876sm4807945qvb.115.2023.08.01.10.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 10:05:03 -0700 (PDT)
Date:   Tue, 1 Aug 2023 13:04:50 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        liubo <liubo254@huawei.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hugh Dickins <hughd@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>,
        Mel Gorman <mgorman@suse.de>, Shuah Khan <shuah@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/8] mm/gup: reintroduce FOLL_NUMA as
 FOLL_HONOR_NUMA_FAULT
Message-ID: <ZMk7MqApTDZXzwKX@x1n>
References: <20230801124844.278698-1-david@redhat.com>
 <20230801124844.278698-2-david@redhat.com>
 <ZMkpM95vdc9wgs9T@x1n>
 <30d86a2d-4af2-d840-91be-2e68c73a07bd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <30d86a2d-4af2-d840-91be-2e68c73a07bd@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 01, 2023 at 06:15:48PM +0200, David Hildenbrand wrote:
> On 01.08.23 17:48, Peter Xu wrote:
> > On Tue, Aug 01, 2023 at 02:48:37PM +0200, David Hildenbrand wrote:
> > > @@ -2240,6 +2244,12 @@ static bool is_valid_gup_args(struct page **pages, int *locked,
> > >   		gup_flags |= FOLL_UNLOCKABLE;
> > >   	}
> > > +	/*
> > > +	 * For now, always trigger NUMA hinting faults. Some GUP users like
> > > +	 * KVM really require it to benefit from autonuma.
> > > +	 */
> > > +	gup_flags |= FOLL_HONOR_NUMA_FAULT;
> > 
> > Since at it, do we want to not set it for FOLL_REMOTE, which still sounds
> > like a good thing to have?
> 
> I thought about that, but decided against making that patch here more
> complicated to eventually rip it again all out in #4.

I thought that was the whole point of having patch 4 separate, because we
should assume patch 4 may not exist in (at least) some trees, so I ignored
patch 4 when commenting here, and we should not assume it's destined to be
removed here.

> 
> I fully agree that FOLL_REMOTE does not make too much sense, but let's
> rather keep it simple for this patch.

It's fine - I suppose this patch fixes whatever we're aware of that's
broken with FOLL_NUMA's removal, so it can even be anything on top when
needed.  I assume I'm happy to ack this with/without that change, then:

Acked-by: Peter Xu <peterx@redhat.com>

PS: I still hope that the other oneliner can be squashed here directly; it
literally changes exact the same line above so reading this patch alone can
be affected.  You said there you didn't want the commit message to be too
long here, but this is definitely not long at all!  I bet you have similar
understanding to me on defining "long commit message". :) I'd never worry
that.  Your call.

Thanks,

-- 
Peter Xu

