Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252173625F4
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 18:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236513AbhDPQqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 12:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235595AbhDPQqx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 12:46:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947DBC061574;
        Fri, 16 Apr 2021 09:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BxSXtPsAmxUFlWPdD98J/97elcMLJtVAfMQiYC0wrec=; b=nS9gVgOCNBVzeS3pqL5W4rnkMr
        aJPl02WUaeZA81Upi/OJP409n6KoLw5d8mcWR1zbyR3sRlv3hWbP5IATF7arA4qjeE2dYjUz7jtk2
        hkT9rqZA5KXsM3f1MBCDH6wckYcadrBJOeTcSh8a5k8zp1u40wZMEEl9OGDBA8wtTBBeKEz4IcJTO
        IDPmCDeLvJRDctFn+NglDOY+rpPbvZODAksJGozKVR0R1K36mHGFor4GcQtHcTvdAmP0oR8h7+DxW
        aNZcG/TM1aoyO6aSzAv0HEmqXT426M26Ii64sQNZv6AB8/hqbY68PvJKE2sTrzV7PK7iDrulkxgsg
        WC+0UejQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lXRbW-00ACjP-BC; Fri, 16 Apr 2021 16:46:04 +0000
Date:   Fri, 16 Apr 2021 17:46:02 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Peter Gonda <pgonda@google.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFCv2 00/13] TDX and guest memory unmapping
Message-ID: <20210416164602.GN2531743@casper.infradead.org>
References: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 16, 2021 at 06:40:53PM +0300, Kirill A. Shutemov wrote:
> TDX integrity check failures may lead to system shutdown host kernel must
> not allow any writes to TD-private memory. This requirment clashes with
> KVM design: KVM expects the guest memory to be mapped into host userspace
> (e.g. QEMU).
> 
> This patchset aims to start discussion on how we can approach the issue.
> 
> The core of the change is in the last patch. Please see more detailed
> description of the issue and proposoal of the solution there.

This seems to have some parallels with s390's arch_make_page_accessible().
Is there any chance to combine the two, so we don't end up with duplicated
hooks all over the MM for this kind of thing?

https://patchwork.kernel.org/project/kvm/cover/20200214222658.12946-1-borntraeger@de.ibm.com/

and recent THP/Folio-related discussion:
https://lore.kernel.org/linux-mm/20210409194059.GW2531743@casper.infradead.org/
