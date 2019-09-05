Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6882EAAAA3
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 20:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbfIESKD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 14:10:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49592 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726837AbfIESKC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 14:10:02 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B0961315C009;
        Thu,  5 Sep 2019 18:10:01 +0000 (UTC)
Received: from redhat.com (unknown [10.20.6.178])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 925325D6A3;
        Thu,  5 Sep 2019 18:09:57 +0000 (UTC)
Date:   Thu, 5 Sep 2019 14:09:55 -0400
From:   Jerome Glisse <jglisse@redhat.com>
To:     Mircea CIRJALIU - MELIU <mcirjaliu@bitdefender.com>
Cc:     Adalbert =?utf-8?B?TGF6xINy?= <alazar@bitdefender.com>,
        Matthew Wilcox <willy@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Samuel =?iso-8859-1?Q?Laur=E9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Yu C <yu.c.zhang@intel.com>,
        Mihai =?utf-8?B?RG9uyJt1?= <mdontu@bitdefender.com>
Subject: Re: DANGER WILL ROBINSON, DANGER
Message-ID: <20190905180955.GA3251@redhat.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-72-alazar@bitdefender.com>
 <20190809162444.GP5482@bombadil.infradead.org>
 <1565694095.D172a51.28640.@15f23d3a749365d981e968181cce585d2dcb3ffa>
 <20190815191929.GA9253@redhat.com>
 <20190815201630.GA25517@redhat.com>
 <VI1PR02MB398411CA9A56081FF4D1248EBBA40@VI1PR02MB3984.eurprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <VI1PR02MB398411CA9A56081FF4D1248EBBA40@VI1PR02MB3984.eurprd02.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 05 Sep 2019 18:10:02 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 23, 2019 at 12:39:21PM +0000, Mircea CIRJALIU - MELIU wrote:
> > On Thu, Aug 15, 2019 at 03:19:29PM -0400, Jerome Glisse wrote:
> > > On Tue, Aug 13, 2019 at 02:01:35PM +0300, Adalbert Lazăr wrote:
> > > > On Fri, 9 Aug 2019 09:24:44 -0700, Matthew Wilcox <willy@infradead.org>
> > wrote:
> > > > > On Fri, Aug 09, 2019 at 07:00:26PM +0300, Adalbert Lazăr wrote:
> > > > > > +++ b/include/linux/page-flags.h
> > > > > > @@ -417,8 +417,10 @@ PAGEFLAG(Idle, idle, PF_ANY)
> > > > > >   */
> > > > > >  #define PAGE_MAPPING_ANON	0x1
> > > > > >  #define PAGE_MAPPING_MOVABLE	0x2
> > > > > > +#define PAGE_MAPPING_REMOTE	0x4
> > > > >
> > > > > Uh.  How do you know page->mapping would otherwise have bit 2
> > clear?
> > > > > Who's guaranteeing that?
> > > > >
> > > > > This is an awfully big patch to the memory management code, buried
> > > > > in the middle of a gigantic series which almost guarantees nobody
> > > > > would look at it.  I call shenanigans.
> > > > >
> > > > > > @@ -1021,7 +1022,7 @@ void page_move_anon_rmap(struct page
> > *page, struct vm_area_struct *vma)
> > > > > >   * __page_set_anon_rmap - set up new anonymous rmap
> > > > > >   * @page:	Page or Hugepage to add to rmap
> > > > > >   * @vma:	VM area to add page to.
> > > > > > - * @address:	User virtual address of the mapping
> > > > > > + * @address:	User virtual address of the mapping
> > > > >
> > > > > And mixing in fluff changes like this is a real no-no.  Try again.
> > > > >
> > > >
> > > > No bad intentions, just overzealous.
> > > > I didn't want to hide anything from our patches.
> > > > Once we advance with the introspection patches related to KVM we'll
> > > > be back with the remote mapping patch, split and cleaned.
> > >
> > > They are not bit left in struct page ! Looking at the patch it seems
> > > you want to have your own pin count just for KVM. This is bad, we are
> > > already trying to solve the GUP thing (see all various patchset about
> > > GUP posted recently).
> > >
> > > You need to rethink how you want to achieve this. Why not simply a
> > > remote read()/write() into the process memory ie KVMI would call an
> > > ioctl that allow to read or write into a remote process memory like
> > > ptrace() but on steroid ...
> > >
> > > Adding this whole big complex infrastructure without justification of
> > > why we need to avoid round trip is just too much really.
> > 
> > Thinking a bit more about this, you can achieve the same thing without
> > adding a single line to any mm code. Instead of having mmap with
> > PROT_NONE | MAP_LOCKED you have userspace mmap some kvm device
> > file (i am assuming this is something you already have and can control the
> > mmap callback).
> > 
> > So now kernel side you have a vma with a vm_operations_struct under your
> > control this means that everything you want to block mm wise from within
> > the inspector process can be block through those call- backs
> > (find_special_page() specificaly for which you have to return NULL all the
> > time).
> > 
> > To mirror target process memory you can use hmm_mirror, when you
> > populate the inspector process page table you use insert_pfn() (mmap of
> > the kvm device file must mark this vma as PFNMAP).
> > 
> > By following the hmm_mirror API, anytime the target process has a change in
> > its page table (ie virtual address -> page) you will get a callback and all you
> > have to do is clear the page table within the inspector process and flush tlb
> > (use zap_page_range).
> > 
> > On page fault within the inspector process the fault callback of vm_ops will
> > get call and from there you call hmm_mirror following its API.
> > 
> > Oh also mark the vma with VM_WIPEONFORK to avoid any issue if the
> > inspector process use fork() (you could support fork but then you would
> > need to mark the vma as SHARED and use unmap_mapping_pages instead of
> > zap_page_range).
> > 
> > 
> > There everything you want to do with already upstream mm code.
> 
> I'm the author of remote mapping, so I owe everybody some explanations.
> My requirement was to map pages from one QEMU process to another QEMU 
> process (our inspector process works in a virtual machine of its own). So I had 
> to implement a KSM-like page sharing between processes, where an anon page
> from the target QEMU's working memory is promoted to a remote page and 
> mapped in the inspector QEMU's working memory (both anon VMAs). 
> The extra page flag is for differentiating the page for rmap walking.
> 
> The mapping requests come at PAGE_SIZE granularity for random addresses 
> within the target/inspector QEMUs, so I couldn't do any linear mapping that
> would keep things simpler. 
> 
> I have an extra patch that does remote mapping by mirroring an entire VMA
> from the target process by way of a device file. This thing creates a separate 
> mirror VMA in my inspector process (at the moment a QEMU), but then I 
> bumped into the KVM hva->gpa mapping, which makes it hard to override 
> mappings with addresses outside memslot associated VMAs.

Not sure i understand, you are saying that the solution i outline above
does not work ? If so then i think you are wrong, in the above solution
the importing process mmap a device file and the resulting vma is then
populated using insert_pfn() and constantly keep synchronize with the
target process through mirroring which means that you never have to look
at the struct page ... you can mirror any kind of memory from the remote
process.

Am i miss-understanding something here ?

Cheers,
Jérôme
