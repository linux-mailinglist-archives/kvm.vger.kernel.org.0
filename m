Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6DE39BB1D
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 16:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhFDOvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 10:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbhFDOvi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 10:51:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F091DC061766
        for <kvm@vger.kernel.org>; Fri,  4 Jun 2021 07:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=UkYO4kgIrmSYqJOD2dr1KMVGd/NjjhOMxYRFRaU03ZY=; b=u+PtbC1q+b0OmaDDFCRsvIx4kq
        FBWqGgQ2Vx2BUTNyH/NZ+dgFO7MSEozzd6h/G0Jl9ZghU/ijGgAMa6FPIHTjBAhWt2OcyOrwN25dV
        VOqcCthsnMMZnNIB0f2gafoNHfvEdpnGB1TAaJq4e1cuPnpQJ/q0hibRvV2vSWaMjA3q+ZqE4pykV
        7ldFrFT/dO+ahA5XcAjDMBgc5YY+EOOZGSdPamxj6VqWx5BkCpUKh8uqTsyjoetLo10vLaSfpFEAg
        1GW4z9eAdQ5LSOiF7twCjeZ7Ejw8FlTxEOBstwOQgoFP4ng0jCgPjoPn25dZQR/vXIFdoSQ+x2h1n
        PNC500uQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lpB8c-00DFwZ-HI; Fri, 04 Jun 2021 14:49:33 +0000
Date:   Fri, 4 Jun 2021 15:49:30 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Sean Christopherson <seanjc@google.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Cc:     linux-mm@kvack.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org
Subject: PageTransCompoundMap confusion
Message-ID: <YLo9egOQUiGo7CBO@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I'm a bit confused about what PageTransCompoundMap() is supposed to do.
What it actually does is check that the specific page (which may or
may not be a head page) is not mapped by a PTE.  I don't understand why
you'd care how some (other?) process does or does not have it mapped.
What I _think_ you want to know is "Can I map this page with a PMD entry
in the guest".  And the answer to that is simply:

bool kvm_is_transparent_hugepage(kvm_pfn_t pfn)
{
	struct page *head = compound_head(pfn_to_page(pfn));
	return compound_order(head) >= HPAGE_PMD_ORDER;
}

but maybe there's some reason you don't want to map hugetlbfs or other
sufficiently large compound pages with PMDs?

Looking at the one caller of kvm_is_transparent_hugepage(), I'd be
tempted to inline the above into transparent_hugepage_adjust()
and call get_page() directly instead of indirecting through
kvm_get_pfn().
