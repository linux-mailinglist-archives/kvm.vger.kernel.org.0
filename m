Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCE9313E1D
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 19:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbhBHSxq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 13:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235832AbhBHSwQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 13:52:16 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B09C061786
        for <kvm@vger.kernel.org>; Mon,  8 Feb 2021 10:51:34 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id d85so15503232qkg.5
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 10:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FREB4k4pL+/EwQVi/jq4eIfgwfGwgd8/O2V49WmG3yI=;
        b=ayKBiVUeDmZgutOHEL4vMvTvHca+pVKQbcb658vawwG09uauE5m3ic5gN6c9JkzeTX
         HGjYLobolsvKN/n9h49zmwT9Nf+FhGtdx+spz++X3Q0NB3znozLYOu+Qdt8ShcpBJ7gJ
         Wgoe4nJSIHNuvgGHCdn9+HAGCM3L8K90nEXC7tOC9Ht1wLXziklRqWIiN7+njvhCJxGV
         u8wDnYz+fsyNBQKkwR8jDwcXvXBHHeXX/L28GBohrBDWsLiCtakt8qbuEYDTbHafl2NP
         jN6MmoSdE5Gryh2iz+rHB+pGMoQ2Q/eY5JpUSeBnyruSNGaJ1wjwA5t8B4qAF5p52D2d
         jb5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FREB4k4pL+/EwQVi/jq4eIfgwfGwgd8/O2V49WmG3yI=;
        b=oCQ5W6GCQ0GbtYEuKtVTCh5pxq4lvPgiSYVx643DYWmE+9FxxwxDwtHThy8NrTmcIT
         S1iOvjg1FvgJeFpRQiG6gHgBq2BZGpG2dfKEj7gE7rrarW3lUcyp8OlQi2Yhs79e9vIW
         nlI4EXxiZWuFhGrEzVblj7NbN4rYXdiKu3Lrxo+p252Qt/2avNYRVO/DO2zbSUAtxfly
         sMXiPnl9H6XeFqJl+d51ZQteaZO/W4uEBHUdRoIDHtJom1xrJAxYXsZuVbWPblEjkvf6
         wid0TeX8k1k1fmNzy59diaQ0hD36jUWQKrEicIfkE+mZUai2vYPUKsIehDft2S+5f7UQ
         9yNg==
X-Gm-Message-State: AOAM532iMj8MDHRUBiIEmy5Lozik7jiDfry2YHfxvCG4jsPp+aZ7mdbf
        j9D0ULnAA6oblRf1EpXZ4YlNJg==
X-Google-Smtp-Source: ABdhPJyWgaNBTCVawkQVPK0b06TB5cBGj1xy2Hg+/c/xFkZeuj/u1FCWtQfIhSeg/PKdKxAppdWkGg==
X-Received: by 2002:a37:5905:: with SMTP id n5mr18045893qkb.191.1612810294198;
        Mon, 08 Feb 2021 10:51:34 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id w188sm17159979qkc.19.2021.02.08.10.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 10:51:33 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1l9BdF-0052Tc-8p; Mon, 08 Feb 2021 14:51:33 -0400
Date:   Mon, 8 Feb 2021 14:51:33 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Peter Xu <peterx@redhat.com>, dan.j.williams@intel.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] KVM: do not assume PTE is writable after follow_pfn
Message-ID: <20210208185133.GW4718@ziepe.ca>
References: <20210205103259.42866-1-pbonzini@redhat.com>
 <20210205181411.GB3195@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205181411.GB3195@xz-x1>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 05, 2021 at 01:14:11PM -0500, Peter Xu wrote:

> But I do have a question on why dax as the only user needs to pass in the
> notifier to follow_pte() for initialization.

Not sure either, why does DAX opencode something very much like
page_mkclean() with dax_entry_mkclean()?

Also it looks like DAX uses the wrong notifier, it calls
MMU_NOTIFY_CLEAR but page_mkclean_one() uses
MMU_NOTIFY_PROTECTION_PAGE for the same PTE modification sequence??

page_mkclean() has some technique to make the notifier have the right
size without becoming entangled in the PTL locks..

Jason
