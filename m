Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6208618FA25
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 17:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbgCWQoG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 12:44:06 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46837 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727461AbgCWQoG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 12:44:06 -0400
Received: by mail-qk1-f196.google.com with SMTP id u4so4103951qkj.13
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 09:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gOqUZhrB3tbP37O07iZXzI++c1tt+580wf55GATS2SM=;
        b=CHkzV0CUaFfnHgtED9IRJD4ztA7/XKt6w3TMqe+emVP/CoIvuvXtYA2Rntt9fhIupT
         FDhFCWE3zOJ+1mdE4OhnqVBGkGJplnaoVMH6yWifoIndPxyJWU6t2TbUiHx+Fabkz4AU
         Bo6VUH5I/z+vdpQyLloUPnUFcyCsVgk/ZKOq7fZWdshq+tD1F2JqhgynUuOC9Clph639
         oYUZtEi9XKMwwJh4wsqKYBmavQEBgUhAg1WuJMXTB5ek2FIUwDvyCE3rofJYHNfQbqHY
         1ibApMJdvmmqRPne6+/xBnr+WdEY9aK5/EWxYtSutuEpgLnfjdVKLjxpd/vvow8QZIkD
         0bzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gOqUZhrB3tbP37O07iZXzI++c1tt+580wf55GATS2SM=;
        b=c+5vxoz1ZTaMxTAxLx5St+XI6el5FH3B2rON900z+lKbB0iy/X//vG2AogbHlFS1w4
         Mr5wNfXGE5wIn5lfaWnKTy2ot67ComeXt3znuhOWuma0Gsf35HA9oBfOHVRP6hopvbu1
         W1aFbsWQ5gHl3L7FQEkgUJE1m6+Nxy/TYYZD8MVzEBd7LYmQ3MgbKYspVXsbwasw38N8
         61KzfI4ByT/w3f5MBobL3d3snI5hAMjWnTICnt/7GuioKefmOfQtneLkbdmsRwC5zTJC
         3uJm6wELPAJOhCeCfSIu3XriC9xGwvjeCl09IGLACK4Rqv+/lWVKqVhQwy24546U0JOF
         hclg==
X-Gm-Message-State: ANhLgQ0I4h2WTnEaf8PuSve24/qiOqMU/2tR60phSQYuJ1RZDhss+XbO
        aGNIhRIbd2yI8WdqUraGB53oqg==
X-Google-Smtp-Source: ADFU+vtcop8zgZHP+bMT/hRGVH1iCEYh7uqN8r13iYqMZjJ4sAKMDQgt2z2v/hovRrjc1FG+Yk1+6Q==
X-Received: by 2002:a05:620a:84d:: with SMTP id u13mr21724625qku.94.1584981845232;
        Mon, 23 Mar 2020 09:44:05 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id f13sm12827393qte.53.2020.03.23.09.44.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 23 Mar 2020 09:44:04 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jGQBH-0005fK-Aj; Mon, 23 Mar 2020 13:44:03 -0300
Date:   Mon, 23 Mar 2020 13:44:03 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org,
        arei.gonglei@huawei.com, weidong.huang@huawei.com,
        weifuqiang@huawei.com, kvm@vger.kernel.org, linux-mm@kvack.org,
        Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/hugetlb: fix a addressing exception caused by
 huge_pte_offset()
Message-ID: <20200323164403.GZ20941@ziepe.ca>
References: <1582342427-230392-1-git-send-email-longpeng2@huawei.com>
 <51a25d55-de49-4c0a-c994-bf1a8cfc8638@oracle.com>
 <5700f44e-9df9-1b12-bc29-68e0463c2860@huawei.com>
 <e16fe81b-5c4c-e689-2f48-214f2025df2f@oracle.com>
 <20200323144030.GA28711@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323144030.GA28711@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 23, 2020 at 07:40:31AM -0700, Sean Christopherson wrote:
> On Sun, Mar 22, 2020 at 07:54:32PM -0700, Mike Kravetz wrote:
> > On 3/22/20 7:03 PM, Longpeng (Mike, Cloud Infrastructure Service Product Dept.) wrote:
> > > 
> > > On 2020/3/22 7:38, Mike Kravetz wrote:
> > >> On 2/21/20 7:33 PM, Longpeng(Mike) wrote:
> > >>> From: Longpeng <longpeng2@huawei.com>
> > I have not looked closely at the generated code for lookup_address_in_pgd.
> > It appears that it would dereference p4d, pud and pmd multiple times.  Sean
> > seemed to think there was something about the calling context that would
> > make issues like those seen with huge_pte_offset less likely to happen.  I
> > do not know if this is accurate or not.
> 
> Only for KVM's calls to lookup_address_in_mm(), I can't speak to other
> calls that funnel into to lookup_address_in_pgd().
> 
> KVM uses a combination of tracking and blocking mmu_notifier calls to ensure
> PTE changes/invalidations between gup() and lookup_address_in_pgd() cause a
> restart of the faulting instruction, and that pending changes/invalidations
> are blocked until installation of the pfn in KVM's secondary MMU completes.
> 
> kvm_mmu_page_fault():
> 
> 	mmu_seq = kvm->mmu_notifier_seq;
> 	smp_rmb();
> 
> 	pfn = gup(hva);
> 
> 	spin_lock(&kvm->mmu_lock);
> 	smp_rmb();
> 	if (kvm->mmu_notifier_seq != mmu_seq)
> 		goto out_unlock: // Restart guest, i.e. retry the fault
> 
> 	lookup_address_in_mm(hva, ...);

It works because the mmu_lock spinlock is taken before and after any
change to the page table via invalidate_range_start/end() callbacks.

So if you are in the spinlock and mmu_notifier_count == 0, then nobody
can be writing to the page tables. 

It is effectively a full page table lock, so any page table read under
that lock do not need to worry about any data races.

Jason
