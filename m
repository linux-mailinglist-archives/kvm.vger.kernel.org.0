Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5D7D87FD3
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437121AbfHIQYt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:24:49 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50532 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406171AbfHIQYt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 12:24:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xrswoPf44Z03S3Xl/6YllPqCJtXJb0iLf7341inGhrY=; b=L/+gVqcnLKq6HpffUaAVFqOEg/
        w/yz5wAhB2ZX9xaTvGMhg3d/oxasNMn6WEoztRV50n1/KEjpJ/9nDd9FhWMHF4+yBMe6p4P69i0YJ
        pppEFS+j5sas14zZhl8onbamHjBNJAs8PQuUgusm75o4tCRktPw3NQkaAtyIvtnC2RCm1rWjWrhao
        +5SPhkhUQvBoOhYBvhyoozqezG0bD0P7iq+/VCAdq1eq6PHxF+7UHNYbkNFeG5LNBc16apjYo84JG
        CXoNZDvJJeDtCQAJLwU5ZcyJFjSozwDjepJrwhTnhs6AYo6XzJR3ok/b5uFooBeE/plaXChgCdihB
        2w9t3wAQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hw7h6-0006cM-Uc; Fri, 09 Aug 2019 16:24:44 +0000
Date:   Fri, 9 Aug 2019 09:24:44 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Adalbert =?utf-8?B?TGF6xINy?= <alazar@bitdefender.com>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Samuel =?iso-8859-1?Q?Laur=E9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@kvack.org,
        Yu C <yu.c.zhang@intel.com>,
        Mihai =?utf-8?B?RG9uyJt1?= <mdontu@bitdefender.com>,
        Mircea =?iso-8859-1?Q?C=EErjaliu?= <mcirjaliu@bitdefender.com>
Subject: DANGER WILL ROBINSON, DANGER
Message-ID: <20190809162444.GP5482@bombadil.infradead.org>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-72-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190809160047.8319-72-alazar@bitdefender.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 09, 2019 at 07:00:26PM +0300, Adalbert Lazăr wrote:
> +++ b/include/linux/page-flags.h
> @@ -417,8 +417,10 @@ PAGEFLAG(Idle, idle, PF_ANY)
>   */
>  #define PAGE_MAPPING_ANON	0x1
>  #define PAGE_MAPPING_MOVABLE	0x2
> +#define PAGE_MAPPING_REMOTE	0x4

Uh.  How do you know page->mapping would otherwise have bit 2 clear?
Who's guaranteeing that?

This is an awfully big patch to the memory management code, buried in
the middle of a gigantic series which almost guarantees nobody would
look at it.  I call shenanigans.

> @@ -1021,7 +1022,7 @@ void page_move_anon_rmap(struct page *page, struct vm_area_struct *vma)
>   * __page_set_anon_rmap - set up new anonymous rmap
>   * @page:	Page or Hugepage to add to rmap
>   * @vma:	VM area to add page to.
> - * @address:	User virtual address of the mapping	
> + * @address:	User virtual address of the mapping

And mixing in fluff changes like this is a real no-no.  Try again.

