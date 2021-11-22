Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36B24590FD
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 16:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239609AbhKVPNF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 10:13:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235929AbhKVPNE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 10:13:04 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585B6C06173E
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 07:09:58 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id a2so16758751qtx.11
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 07:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5VTof+3edSRysBWJfMrn+QjeSl3KM16l29/PC/dx3o4=;
        b=GgW+p5PeHc0bQly0v21nzAJ3y6uv9j+6GJjj3/kSRMtOhXgQUdo630hHq9WFNfMw3+
         7jwm/pEg3OMqP3OSiHN9g6X2ApOK6D6i97qPCojv4hHg6bX3hTJX1VRV9wv9AJivwnTz
         NMbrhhMDJdFriocGD9Q87qSC2eg3XWgnsBQvzED4l/rtGH5c3J9RkR24eZLMQVocatzk
         16fEwCdt4zSVbLzcMUR1znohS2vSzntWqte0ryaXUwXGyQptkpXIcQYp/zc6kdLcBhqC
         Cg6yB3MWTxm24NNgtuPBXuKgfkuCI4/QoYWo4AoHhvWYPVXt8w84jQYnFFi6M8A4ngDL
         vRoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5VTof+3edSRysBWJfMrn+QjeSl3KM16l29/PC/dx3o4=;
        b=u57IyR/hbGJkAYuvxlUOoH52UEsPoJKZC6qlbMxcTDe6C/f8Rjq0pm5uXqtbfPeGYr
         kXa6/NT5HTG0K/agLHsNnWP7LjfqUhuBfzLW11/Av2+leR/8e2gnGe++Bf5yL1HhfYW1
         TeCwSruKDxxv88m5rbLNFowVBgMBW1BkykLuWmxQmwpkr6JhU2tiHL3JMOcMhX+bcM4v
         4ufqUDUQ/lYrQ0FwoR2DkVHy3Hm9sqYfjeK8SmfYGXLz8rc2ewOQgOZ1753m1+VZZVTq
         eGmicQ9sTRZ2UXG/1E/UlcBQPsLCzmT3FgMv02a1uy2MPSIc+p1LNuB2sALiDznlh0x/
         XYBw==
X-Gm-Message-State: AOAM53199TzNkP/Ys63Ol23wBsc9pgJV4+pRPxquxcsKqGhAwXEwnll1
        BIAmzN+W1ruDzQQiFm88nPmCMQ==
X-Google-Smtp-Source: ABdhPJyRLMA8XcwBk54ljNUHf6oDk+V6lmAhSa4hBpytn+jTTywY+jUzb27EMb9+9wB5t9Defs2Bqw==
X-Received: by 2002:a05:622a:189:: with SMTP id s9mr31877263qtw.352.1637593797445;
        Mon, 22 Nov 2021 07:09:57 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id b9sm4563076qtb.53.2021.11.22.07.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 07:09:57 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mpAxA-00DtLu-8c; Mon, 22 Nov 2021 11:09:56 -0400
Date:   Mon, 22 Nov 2021 11:09:56 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     David Hildenbrand <david@redhat.com>
Cc:     Chao Peng <chao.p.peng@linux.intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        Hugh Dickins <hughd@google.com>,
        Jeff Layton <jlayton@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        luto@kernel.org, john.ji@intel.com, susie.li@intel.com,
        jun.nakajima@intel.com, dave.hansen@intel.com, ak@linux.intel.com
Subject: Re: [RFC v2 PATCH 01/13] mm/shmem: Introduce F_SEAL_GUEST
Message-ID: <20211122150956.GS876299@ziepe.ca>
References: <20211119134739.20218-1-chao.p.peng@linux.intel.com>
 <20211119134739.20218-2-chao.p.peng@linux.intel.com>
 <20211119151943.GH876299@ziepe.ca>
 <df11d753-6242-8f7c-cb04-c095f68b41fa@redhat.com>
 <20211119160023.GI876299@ziepe.ca>
 <4efdccac-245f-eb1f-5b7f-c1044ff0103d@redhat.com>
 <20211122133145.GQ876299@ziepe.ca>
 <56c0dffc-5fc4-c337-3e85-a5c9ce619140@redhat.com>
 <20211122140148.GR876299@ziepe.ca>
 <d2b46b84-8930-4304-2946-4d4a16698b24@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2b46b84-8930-4304-2946-4d4a16698b24@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021 at 03:57:17PM +0100, David Hildenbrand wrote:
> On 22.11.21 15:01, Jason Gunthorpe wrote:
> > On Mon, Nov 22, 2021 at 02:35:49PM +0100, David Hildenbrand wrote:
> >> On 22.11.21 14:31, Jason Gunthorpe wrote:
> >>> On Mon, Nov 22, 2021 at 10:26:12AM +0100, David Hildenbrand wrote:
> >>>
> >>>> I do wonder if we want to support sharing such memfds between processes
> >>>> in all cases ... we most certainly don't want to be able to share
> >>>> encrypted memory between VMs (I heard that the kernel has to forbid
> >>>> that). It would make sense in the use case you describe, though.
> >>>
> >>> If there is a F_SEAL_XX that blocks every kind of new access, who
> >>> cares if userspace passes the FD around or not?
> >> I was imagining that you actually would want to do some kind of "change
> >> ownership". But yeah, the intended semantics and all use cases we have
> >> in mind are not fully clear to me yet. If it's really "no new access"
> >> (side note: is "access" the right word?) then sure, we can pass the fd
> >> around.
> > 
> > What is "ownership" in a world with kvm and iommu are reading pages
> > out of the same fd?
> 
> In the world of encrypted memory / TDX, KVM somewhat "owns" that memory
> IMHO (for example, only it can migrate or swap out these pages; it's
> might be debatable if the TDX module or KVM actually "own" these pages ).

Sounds like it is a swap provider more than an owner?

Jason
