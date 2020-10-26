Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84208298EEF
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 15:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1781069AbgJZOQF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 10:16:05 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42862 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1780372AbgJZOQF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 10:16:05 -0400
Received: by mail-qk1-f194.google.com with SMTP id b18so4683433qkc.9
        for <kvm@vger.kernel.org>; Mon, 26 Oct 2020 07:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3S2YjeCUC6K3doI4vgMQKoCwvJ4YN6LMw0KanLSj+uM=;
        b=MocRZOBqXvmKFTBQqlf9654tnqlf+n6zq+i2QdNLLQNEIAKlRxznKNH8lCVuCZXtx8
         sL2hKpGdKOCK17bDT9PJq98n7qUnhsRxnYoL99XDVZ6GR99eNglEwr2LPb973O7RQ7HA
         pDW4sDBWyUQViJzK19iQsGqbK+MeQAGCD5TQEeKrBoKzCOYX/duYkiXTcQ4Qp8ccSABs
         Hftqzs+se0kaaq/6hY4MO1EHYC4oBnMYtT0YdyYt/VzKZq3XOZwc/e29IfN7g/5xfmSM
         QqCOBeeAbUr2ljY3/WF8B6umAyrwtt7+dYB8AO4wemgwHV5cww4O71ZknMmTdweIplAH
         m9wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3S2YjeCUC6K3doI4vgMQKoCwvJ4YN6LMw0KanLSj+uM=;
        b=kq32TCwk77AUj/TczU4IyiY5op7Llaa4SB8LY+dNSkK3qhdmG3EcErJJtXfDrsfQFa
         tbLC4inCWS18r9zUYyGaWrGh2pnXJAI3x/bnxVcULkp8UzqmUuofoq2+HUeNMb+DZukE
         NZF6r2F+LcGcyIVjEIjZQ2g8Bd3TckcBl3c8ssY7JRuL3mZrTRCxeXA17KmOO/qOE5JI
         ampVkcv3ruHeas8zzsuVgMUvnCe5radKIPt4vBVPveiAiRed7h8Zg0Z++nmTnH6gdv02
         cx8NMoCg6+UvuobqkCS2wMnGwI7jVGMlXkmzJ4KwaiYtLpKhCNwqsdiHvflTvwJHCAKI
         0lMw==
X-Gm-Message-State: AOAM530J6G2lbjEEsCmbkpHFmHeTX70qjFq/M6Zlh0IOaKWXo2M5Zj8P
        HkffsrL3iAzTadPgl5GpZzwhQg==
X-Google-Smtp-Source: ABdhPJyf953+FiRgW2dasVQsjm4zhSEzqYl6uwWT9W1zEpP8TS/DVtOK2Vqx2OZ03E5I04lE/XNsLg==
X-Received: by 2002:a05:620a:849:: with SMTP id u9mr17366693qku.419.1603721762676;
        Mon, 26 Oct 2020 07:16:02 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id y77sm6331920qkb.57.2020.10.26.07.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 07:16:01 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kX3I1-008TP8-5d; Mon, 26 Oct 2020 11:16:01 -0300
Date:   Mon, 26 Oct 2020 11:16:01 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     John Hubbard <jhubbard@nvidia.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFCv2 08/16] KVM: Use GUP instead of copy_from/to_user() to
 access guest memory
Message-ID: <20201026141601.GT36674@ziepe.ca>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
 <20201020061859.18385-9-kirill.shutemov@linux.intel.com>
 <c8b0405f-14ed-a1bb-3a91-586a30bdf39b@nvidia.com>
 <20201022114946.GR20115@casper.infradead.org>
 <30ce6691-fd70-76a2-8b61-86d207c88713@nvidia.com>
 <20201026042158.GN20115@casper.infradead.org>
 <ee308d1d-8762-6bcf-193e-85fea29743c3@nvidia.com>
 <20201026132830.GQ20115@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026132830.GQ20115@casper.infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 26, 2020 at 01:28:30PM +0000, Matthew Wilcox wrote:

> > > It's been five years since DAX was merged, and page pinning still
> > > doesn't work.  How much longer before the people who are pushing it
> > > realise that it's fundamentally flawed?
> > 
> > Is this a separate rant about *only* DAX, or is general RDMA in your sights
> > too? :)
> 
> This is a case where it's not RDMA's _fault_ that there's no good API
> for it to do what it needs to do.  There's a lot of work needed to wean
> Linux device drivers off their assumption that there's a struct page
> for every byte of memory.

People who care seem to have just given up and are using RDMA ODP, so
I'm not optimistic this DAX issue will ever be solved. I've also
almost removed all the struct page references from this flow in RDMA,
so if there is some way that helps it is certainly doable.

Regardless of DAX the pinning indication is now being used during
fork() for some good reasons, and seems to make sense in other use
cases. It just doesn't seem like a way to solve the DAX issue.

More or less it seems to mean that pages pinned cannot be write
protected and more broadly the kernel should not change the PTEs for
those pages independently of the application. ie the more agressive
COW on fork() caused data corruption regressions...

I wonder if the point here is that some page owners can't/won't
support DMA pinning and should just be blocked completely for them.

I'd much rather have write access pin_user_pages() just fail than oops
the kernel on ext4 owned VMAs, for instance.

Jason
