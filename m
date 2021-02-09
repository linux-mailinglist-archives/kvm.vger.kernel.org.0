Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F783144D4
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 01:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbhBIAYu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 19:24:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51109 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229996AbhBIAYq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 19:24:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612830198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TP6uJnqeuWbRiNKlKQkquP+smnR+VHjueUIpOLLNaCQ=;
        b=LV1Wa+2kQJ5K9DaiVPmeFeHRK/7NO7xQ/6A99xN/BHGzSAK7Czd8M4OmIzkkjmNvcMjBM7
        tox5RwzGLhNqq7jc7RFp+ObiZ18e8s42Z8M1Zzcw0gFD5/nRFnHxKBz4okQyPREG1lo930
        bYBwbtd6DBAgDYjIPybDAnIcXnQKY/Y=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-aghktJexMJajA42beas3Ag-1; Mon, 08 Feb 2021 19:23:17 -0500
X-MC-Unique: aghktJexMJajA42beas3Ag-1
Received: by mail-qt1-f198.google.com with SMTP id v22so3670825qto.16
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 16:23:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TP6uJnqeuWbRiNKlKQkquP+smnR+VHjueUIpOLLNaCQ=;
        b=HGIT354U56YUVWo2bNdH+K8oW7y0pmu9eC6AryHSYB9D8mb5/XgpEGjpE3WAIWVOxD
         EZ5PGjw9s2KPU3GaDtD0gydzVRrMVw+A+0FTqaTweJp1ekajPv3scDum55WfYN4gWjCZ
         Y4LZ4ORNwjLEi2ACsWD3MyUnMyp+VcwStFq+xaNr8OQwN5FjhNl+eFqwhcQadADh/S7P
         QiyT0GDnUfDHBFIikn8Qz9/gAg9DoNzZvPwLKTDMSj9+vRUinHyDUnrtyfDZYNZsXKG+
         Lb/KDe9UAMiv3nd0gu4cWdmbquboJrXyNv9tQ4nE53WVJQJlPK/3eeZLzMA7N8zg4LwS
         G3eg==
X-Gm-Message-State: AOAM531mn2v1W0yDWvCVTYF10u3cZLUvL1IKEd/c+9n9d1MflVPbSkXn
        HNLc4GG+aL3uzY6oQxIt0iVEvi8K9yX2DV/1tcYFiy3AoAkraaEX4uGuLeN5s3kCyUiolbngScm
        WAyzVAuekMJSP
X-Received: by 2002:a05:620a:544:: with SMTP id o4mr21023314qko.285.1612830196950;
        Mon, 08 Feb 2021 16:23:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzWNs4U+EA9v9RcX9qjKDT/ZuKzhasdvMhBjPXS/jV1Gn6jl2zjma9dO8fkqgPdHV9iV1j83A==
X-Received: by 2002:a05:620a:544:: with SMTP id o4mr21023305qko.285.1612830196770;
        Mon, 08 Feb 2021 16:23:16 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-182.dsl.bell.ca. [174.93.89.182])
        by smtp.gmail.com with ESMTPSA id d71sm17505236qkc.75.2021.02.08.16.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 16:23:16 -0800 (PST)
Date:   Mon, 8 Feb 2021 19:23:14 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     dan.j.williams@intel.com, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] KVM: do not assume PTE is writable after follow_pfn
Message-ID: <20210209002314.GC78818@xz-x1>
References: <20210205103259.42866-1-pbonzini@redhat.com>
 <20210205181411.GB3195@xz-x1>
 <20210208185133.GW4718@ziepe.ca>
 <20210208220259.GA71523@xz-x1>
 <20210208232625.GA4718@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210208232625.GA4718@ziepe.ca>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 08, 2021 at 07:26:25PM -0400, Jason Gunthorpe wrote:
> On Mon, Feb 08, 2021 at 05:02:59PM -0500, Peter Xu wrote:
> > On Mon, Feb 08, 2021 at 02:51:33PM -0400, Jason Gunthorpe wrote:
> > > On Fri, Feb 05, 2021 at 01:14:11PM -0500, Peter Xu wrote:
> > > 
> > > > But I do have a question on why dax as the only user needs to pass in the
> > > > notifier to follow_pte() for initialization.
> > > 
> > > Not sure either, why does DAX opencode something very much like
> > > page_mkclean() with dax_entry_mkclean()?
> > > 
> > > Also it looks like DAX uses the wrong notifier, it calls
> > > MMU_NOTIFY_CLEAR but page_mkclean_one() uses
> > > MMU_NOTIFY_PROTECTION_PAGE for the same PTE modification sequence??
> > > 
> > > page_mkclean() has some technique to make the notifier have the right
> > > size without becoming entangled in the PTL locks..
> > 
> > Right.  I guess it's because dax doesn't have "struct page*" on the
> > back, so it
> 
> It doesn't? I thought DAX cases did?

I'm not familiar with dax at all.. but it seems so: e.g. dax_iomap_pte_fault()
looks like the general fault handler for dax mappings, in which there's calls
to things like vmf_insert_mixed_mkwrite() trying to install ptes with raw pfn.
Or I could also be missing something very important..  Thanks,

-- 
Peter Xu

