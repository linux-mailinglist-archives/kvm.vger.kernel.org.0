Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550EF293588
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 09:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729601AbgJTHNA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 03:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728706AbgJTHNA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 03:13:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0A0C061755;
        Tue, 20 Oct 2020 00:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WCNIsXqbUXOzIVXmiOYfRO/Rzg9TJllAtewiaSP3GKM=; b=ZxA8J6JPfMDUEAIlDegD6VN7Mw
        kTiSBVZpDoHIFc4FUAK5xxpb0h6osBndnpMCaK/V1S6gc0r57wzZp9JD6kkTt+hkDnUGLeZCVRIVP
        IKEFiR3euGhM133RXC6Fp3cWuP6Oml7l8/eoDxl361J46PF0VmzPOtnnImaWoSmmmyDGhIjNqpL+x
        5s7tw6oaMt3QnNrabjpPBEfwikdlJBvW9w7+fapOwvAHAj6CRWWlY230ozrl2jLS1CnOmgtU7cuU+
        QQVzmuM2RoJrYg5qyKb0gyilwxREcsCLvLj4/LkszvTE0hBeN6YQ+NXqSlRqODdHQowUqhPJQn8Wc
        LApoqxOw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kUloh-0002R6-8F; Tue, 20 Oct 2020 07:12:19 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 914613011FE;
        Tue, 20 Oct 2020 09:12:17 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 807E02038FA06; Tue, 20 Oct 2020 09:12:17 +0200 (CEST)
Date:   Tue, 20 Oct 2020 09:12:17 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
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
Subject: Re: [RFCv2 15/16] KVM: Unmap protected pages from direct mapping
Message-ID: <20201020071217.GU2611@hirez.programming.kicks-ass.net>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
 <20201020061859.18385-16-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020061859.18385-16-kirill.shutemov@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 20, 2020 at 09:18:58AM +0300, Kirill A. Shutemov wrote:
> If the protected memory feature enabled, unmap guest memory from
> kernel's direct mappings.
> 
> Migration and KSM is disabled for protected memory as it would require a
> special treatment.

How isn't disabling migration a problem? Are we going to back allocation
by CMA instead?
