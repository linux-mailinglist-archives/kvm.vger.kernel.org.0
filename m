Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B21A3DBC81
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 17:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbhG3PqF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 11:46:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29735 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231732AbhG3PqC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Jul 2021 11:46:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627659957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v843r1H19fuvp9lOYve4s5WGr4F2Kw+kURwizO/7O5c=;
        b=UD3n/Wg33EXMcpyCQ8rYRnsI3gPTMZZNYMLFzUBTXli9PejDSkTsLFSgASru8NntYdh7a3
        6wo4X1N9/GkW399HRb25yUc1UWdXKeV+PykNjY/qfxT1wJjw2V6hQo3nrFJoTgUir6psUV
        NYYUlc7lEcnIQcrcy8pr3RJm7BRKxkA=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-A14W6u5iPxCa88EAejFC_A-1; Fri, 30 Jul 2021 11:45:56 -0400
X-MC-Unique: A14W6u5iPxCa88EAejFC_A-1
Received: by mail-qt1-f198.google.com with SMTP id v7-20020ac874870000b029024e8ccfcd07so4519606qtq.11
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 08:45:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v843r1H19fuvp9lOYve4s5WGr4F2Kw+kURwizO/7O5c=;
        b=Ul1hFsX9dtkApMUKLqI/WTgHj+jjwS27q071bG72oKn7yBMYjlxAnvlyBqIG6vvRa7
         lg/bVee+s3glaFqknvqOFy1Fr7LJJ2Sgq0bBzhOp9jWUXIB/ZPW6ISUVOJuUdzjKW0WQ
         yi2qI/DPm6RnCAjGVIGwtMIVIxvp9IHOUp3bSFGPwZWec0A7XoJMfYsWYUDOdRFBTwAC
         uID9CBZyISxQe0wWKLQwU7+gb1Re/Q8euxgxzgM4GaB1KGanQuBLN9mgR7x8ZaRcefFM
         3fqLUWSXlrzErd1x9pu1+QidTMxZJA+POPi03/O56t+dMpq44JaL7n8OVnfligKRf+o6
         yfoA==
X-Gm-Message-State: AOAM532B8iOF9VfnN5UWkzrAwpQkOx4NgL4vl+B2TzeL1SDlniJ0/5k9
        QeAauNejd0shE/7Xl2vrvRsHU2DRzeS8kuxbTBhIVu2ZK8CpJ/2PjJo2FrJRb5ziJ//70EJzVvi
        ruWTAofEIrNDH
X-Received: by 2002:a37:9c06:: with SMTP id f6mr2876489qke.86.1627659955645;
        Fri, 30 Jul 2021 08:45:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWeRvDhIJ9F0bX4i2icD9PnnSiOFPbOzhKHxUdd15Tr9p1tA6mPJsh/VKc26FhSw7eDPIZ4w==
X-Received: by 2002:a37:9c06:: with SMTP id f6mr2876468qke.86.1627659955378;
        Fri, 30 Jul 2021 08:45:55 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id d4sm735084qty.15.2021.07.30.08.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 08:45:54 -0700 (PDT)
Date:   Fri, 30 Jul 2021 11:45:53 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 8/9] KVM: X86: Optimize pte_list_desc with per-array
 counter
Message-ID: <YQQesQVqWSOvb5ET@t490s>
References: <20210625153214.43106-1-peterx@redhat.com>
 <20210625153415.43620-1-peterx@redhat.com>
 <YQHGXhOc5gO9aYsL@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YQHGXhOc5gO9aYsL@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 09:04:30PM +0000, Sean Christopherson wrote:
> >  struct pte_list_desc {
> >  	u64 *sptes[PTE_LIST_EXT];
> > +	/*
> > +	 * Stores number of entries stored in the pte_list_desc.  No need to be
> > +	 * u64 but just for easier alignment.  When PTE_LIST_EXT, means full.
> > +	 */
> > +	u64 spte_count;
> 
> Per my feedback to the previous patch, this should be above sptes[] so that rmaps
> with <8 SPTEs only touch one cache line.  No idea if it actually matters in
> practice, but I can't see how it would harm anything.

Since at it, I'll further move "more" to be at the entry too, so I think it
optimizes full entries case too.

/*
 * Slight optimization of cacheline layout, by putting `more' and `spte_count'
 * at the start; then accessing it will only use one single cacheline for
 * either full (entries==PTE_LIST_EXT) case or entries<=6.
 */
struct pte_list_desc {
	struct pte_list_desc *more;
	/*
	 * Stores number of entries stored in the pte_list_desc.  No need to be
	 * u64 but just for easier alignment.  When PTE_LIST_EXT, means full.
	 */
	u64 spte_count;
	u64 *sptes[PTE_LIST_EXT];
};

Thanks,

-- 
Peter Xu

