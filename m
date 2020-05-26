Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7820E1E1B21
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 08:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729956AbgEZGRg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 02:17:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:32870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726746AbgEZGRf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 02:17:35 -0400
Received: from kernel.org (unknown [87.70.212.59])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35DCB207CB;
        Tue, 26 May 2020 06:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590473855;
        bh=mialz6+4JExXiplq4nSrBLYzTjZOqrM1xhFXpnEOLgc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xEQnl9quZ9K04sqX5aILNnhy4om7uaT4xNs8TjpQH8TUR9KN3E3yxcAJNvX/uG07T
         CdBG05n9SnX45opvfvn4Yr1hTS2GDC6g8fqiXMpisVFocklxDZj3pHqQgeqKEhsipU
         A/b525HTRdHf10ZM/LvBwefG6D27z5bGPfzDjNag=
Date:   Tue, 26 May 2020 09:17:21 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     "Kirill A. Shutemov" <kirill@shutemov.name>,
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
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFC 00/16] KVM protected memory extension
Message-ID: <20200526061721.GB48741@kernel.org>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <42685c32-a7a9-b971-0cf4-e8af8d9a40c6@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42685c32-a7a9-b971-0cf4-e8af8d9a40c6@oracle.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 25, 2020 at 04:47:18PM +0300, Liran Alon wrote:
> 
> On 22/05/2020 15:51, Kirill A. Shutemov wrote:
> 
> Furthermore, I would like to point out that just unmapping guest data from
> kernel direct-map is not sufficient to prevent all
> guest-to-guest info-leaks via a kernel memory info-leak vulnerability. This
> is because host kernel VA space have other regions
> which contains guest sensitive data. For example, KVM per-vCPU struct (which
> holds vCPU state) is allocated on slab and therefore
> still leakable.

Objects allocated from slab use the direct map, vmalloc() is another story.

> >   - Touching direct mapping leads to fragmentation. We need to be able to
> >     recover from it. I have a buggy patch that aims at recovering 2M/1G page.
> >     It has to be fixed and tested properly
>
> As I've mentioned above, not mapping all guest memory from 1GB hugetlbfs
> will lead to holes in kernel direct-map which force it to not be mapped
> anymore as a series of 1GB huge-pages.
> This have non-trivial performance cost. Thus, I am not sure addressing this
> use-case is valuable.

Out of curiosity, do we actually have some numbers for the "non-trivial
performance cost"? For instance for KVM usecase?


-- 
Sincerely yours,
Mike.
