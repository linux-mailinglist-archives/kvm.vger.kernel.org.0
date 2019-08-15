Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B210D8F452
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 21:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731745AbfHOTTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 15:19:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44440 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731405AbfHOTTf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 15:19:35 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1DE043090FD8;
        Thu, 15 Aug 2019 19:19:35 +0000 (UTC)
Received: from redhat.com (unknown [10.20.6.178])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 29BE219C6A;
        Thu, 15 Aug 2019 19:19:31 +0000 (UTC)
Date:   Thu, 15 Aug 2019 15:19:29 -0400
From:   Jerome Glisse <jglisse@redhat.com>
To:     Adalbert =?utf-8?B?TGF6xINy?= <alazar@bitdefender.com>
Cc:     Matthew Wilcox <willy@infradead.org>, kvm@vger.kernel.org,
        linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
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
        Mihai =?utf-8?B?RG9uyJt1?= <mdontu@bitdefender.com>,
        Mircea =?iso-8859-1?Q?C=EErjaliu?= <mcirjaliu@bitdefender.com>
Subject: Re: DANGER WILL ROBINSON, DANGER
Message-ID: <20190815191929.GA9253@redhat.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-72-alazar@bitdefender.com>
 <20190809162444.GP5482@bombadil.infradead.org>
 <1565694095.D172a51.28640.@15f23d3a749365d981e968181cce585d2dcb3ffa>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1565694095.D172a51.28640.@15f23d3a749365d981e968181cce585d2dcb3ffa>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Thu, 15 Aug 2019 19:19:35 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 13, 2019 at 02:01:35PM +0300, Adalbert Lazăr wrote:
> On Fri, 9 Aug 2019 09:24:44 -0700, Matthew Wilcox <willy@infradead.org> wrote:
> > On Fri, Aug 09, 2019 at 07:00:26PM +0300, Adalbert Lazăr wrote:
> > > +++ b/include/linux/page-flags.h
> > > @@ -417,8 +417,10 @@ PAGEFLAG(Idle, idle, PF_ANY)
> > >   */
> > >  #define PAGE_MAPPING_ANON	0x1
> > >  #define PAGE_MAPPING_MOVABLE	0x2
> > > +#define PAGE_MAPPING_REMOTE	0x4
> > 
> > Uh.  How do you know page->mapping would otherwise have bit 2 clear?
> > Who's guaranteeing that?
> > 
> > This is an awfully big patch to the memory management code, buried in
> > the middle of a gigantic series which almost guarantees nobody would
> > look at it.  I call shenanigans.
> > 
> > > @@ -1021,7 +1022,7 @@ void page_move_anon_rmap(struct page *page, struct vm_area_struct *vma)
> > >   * __page_set_anon_rmap - set up new anonymous rmap
> > >   * @page:	Page or Hugepage to add to rmap
> > >   * @vma:	VM area to add page to.
> > > - * @address:	User virtual address of the mapping	
> > > + * @address:	User virtual address of the mapping
> > 
> > And mixing in fluff changes like this is a real no-no.  Try again.
> > 
> 
> No bad intentions, just overzealous.
> I didn't want to hide anything from our patches.
> Once we advance with the introspection patches related to KVM we'll be
> back with the remote mapping patch, split and cleaned.

They are not bit left in struct page ! Looking at the patch it seems
you want to have your own pin count just for KVM. This is bad, we are
already trying to solve the GUP thing (see all various patchset about
GUP posted recently).

You need to rethink how you want to achieve this. Why not simply a
remote read()/write() into the process memory ie KVMI would call
an ioctl that allow to read or write into a remote process memory
like ptrace() but on steroid ...

Adding this whole big complex infrastructure without justification
of why we need to avoid round trip is just too much really.

Cheers,
Jérôme
