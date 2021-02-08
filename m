Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D06314284
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 23:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhBHWEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 17:04:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38934 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229972AbhBHWEd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 17:04:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612821786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lTX0pF9nf8RNJQU7qZz8qZTgTzfq7MWAZYxVYVxWqa8=;
        b=bY3sFMy3NOaD6WNQ4AzVLfSgaiTMS0yCqGKyor08in4jZb8fF5bFmCbaCacJd1CVefPovE
        mr+s/DMqsLRk7U9rJZjrUNXoFOpdwqB3LCR/kI9Fk1bF2uSmcbzuxIRWzrp5arkbbN2Qo8
        rTNM3VWaLrKe41hUMiGwZNR64AP5f2Q=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-RTCfNJa4MoSN1SrFAxKCng-1; Mon, 08 Feb 2021 17:03:04 -0500
X-MC-Unique: RTCfNJa4MoSN1SrFAxKCng-1
Received: by mail-qt1-f198.google.com with SMTP id f7so10688695qtd.9
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 14:03:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lTX0pF9nf8RNJQU7qZz8qZTgTzfq7MWAZYxVYVxWqa8=;
        b=bPYDa9TlkxAnzQLJfVwkeeNSKhX0hwFlpsHF/+QPxeudobIhJ28OW+qGEr41u3xNO6
         ArtHDFoAXyP9sKbcTqR0L8soDjQFZa2qEwdid6l7YXrrrzc1/U+xpDbGnoZwAIyErjOv
         0igL4Xk6AfODUBoZLtWzadWsYq/b4iiw5HRzM6GPuHugo8ndvy7LF68pfTCRvGQlZiGk
         IEZoKToNIbLxtm0tGR59Rv1OcXjA1xrDa3lldsAXi1INCXEdISeONHlqM4JW9u1eIb9U
         G6HIvwzKug2Qrd9uWoFusDOqpvxcqvIjZUA3YjMAqS5UkbS75LWWLNfhh1hDfmGiR2Fl
         w/qQ==
X-Gm-Message-State: AOAM530jzZ2EmPvXmUUBcUoxXxfYrGXQtEoRSshbCVzBD6tHbpNg7+L1
        VxfNq6jH7PxJzXT46yBchpUc19unF+wyoftieiQkoH5A5bIk1WTesXdqU+HKci1W4SMFQHC7h8A
        6dnlBj9Eb0Y50
X-Received: by 2002:ac8:1283:: with SMTP id y3mr16782053qti.328.1612821783543;
        Mon, 08 Feb 2021 14:03:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxcP//hjTyuOLVPNFX+cbxbejOsxicI0aDwcP+30/uSNwdFb2okin6reP+9lxD9CelvjcyuBg==
X-Received: by 2002:ac8:1283:: with SMTP id y3mr16781975qti.328.1612821782460;
        Mon, 08 Feb 2021 14:03:02 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-182.dsl.bell.ca. [174.93.89.182])
        by smtp.gmail.com with ESMTPSA id 199sm18235920qkm.126.2021.02.08.14.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 14:03:01 -0800 (PST)
Date:   Mon, 8 Feb 2021 17:02:59 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     dan.j.williams@intel.com, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] KVM: do not assume PTE is writable after follow_pfn
Message-ID: <20210208220259.GA71523@xz-x1>
References: <20210205103259.42866-1-pbonzini@redhat.com>
 <20210205181411.GB3195@xz-x1>
 <20210208185133.GW4718@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210208185133.GW4718@ziepe.ca>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 08, 2021 at 02:51:33PM -0400, Jason Gunthorpe wrote:
> On Fri, Feb 05, 2021 at 01:14:11PM -0500, Peter Xu wrote:
> 
> > But I do have a question on why dax as the only user needs to pass in the
> > notifier to follow_pte() for initialization.
> 
> Not sure either, why does DAX opencode something very much like
> page_mkclean() with dax_entry_mkclean()?
> 
> Also it looks like DAX uses the wrong notifier, it calls
> MMU_NOTIFY_CLEAR but page_mkclean_one() uses
> MMU_NOTIFY_PROTECTION_PAGE for the same PTE modification sequence??
> 
> page_mkclean() has some technique to make the notifier have the right
> size without becoming entangled in the PTL locks..

Right.  I guess it's because dax doesn't have "struct page*" on the back, so it
can't directly use page_mkclean().  However the whole logic does look very
similar, so maybe they can be merged in some way.

Thanks,

-- 
Peter Xu

