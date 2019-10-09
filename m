Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D79AD0B41
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 11:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730514AbfJIJcR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 05:32:17 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46406 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730069AbfJIJcR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 05:32:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=48pe5fCaWDIwrzy6iukfLBqQeWQALW/aO1iPRgAYzPk=; b=Qr7myM7ZXdn2gg2NbRatgtVte
        4xY/GjCZbskHfRr4Cczc+KOR1pRiR951pP6CQP5A+9339Mz1PM0p+aWCtg/uHmI9D4mHzlKcokwP2
        xw7RDSd0CZg2//zf3knh2p0OwG/cfLZkun5oitVOXrAw86jmuFq8XL+g+uDc4aQlkReuoWm6ySIVq
        SFM5DZr5QaqMhdcEGN82EcXStgfvOuJQzilPfDkj7FlEQQAmdrr2Uu50ySAANCXb3sdpR49504dyH
        RW276ytHQtKwThS9bSL7wqGxYRNXg2xw7sc9QXciwiDfYmhXc6+OHzqJE3XNeZAzGNHWRZNhsVI3H
        VMyWaJ8bA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iI8KK-00045E-MD; Wed, 09 Oct 2019 09:32:12 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id BDAEC305DE2;
        Wed,  9 Oct 2019 11:31:18 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8167B2022BA0D; Wed,  9 Oct 2019 11:32:10 +0200 (CEST)
Date:   Wed, 9 Oct 2019 11:32:10 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Like Xu <like.xu@linux.intel.com>, kvm@vger.kernel.org,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: x86/vPMU: Add lazy mechanism to release
 perf_event per vPMC
Message-ID: <20191009093210.GK2328@hirez.programming.kicks-ass.net>
References: <20190930072257.43352-1-like.xu@linux.intel.com>
 <20190930072257.43352-4-like.xu@linux.intel.com>
 <20191001082321.GL4519@hirez.programming.kicks-ass.net>
 <e77fe471-1c65-571d-2b9e-d97c2ee0706f@linux.intel.com>
 <20191008121140.GN2294@hirez.programming.kicks-ass.net>
 <d492e08e-bf14-0a8b-bc8c-397f8893ddb5@linux.intel.com>
 <bfd23868-064e-4bf5-4dfb-211d36c409c1@redhat.com>
 <20191009081602.GI2328@hirez.programming.kicks-ass.net>
 <795f5e36-0211-154f-fcf0-f2f1771bf724@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <795f5e36-0211-154f-fcf0-f2f1771bf724@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 09, 2019 at 11:21:30AM +0200, Paolo Bonzini wrote:
> On 09/10/19 10:16, Peter Zijlstra wrote:

> >> bool bitfields preserve the magic behavior where something like this:
> >>
> >>   foo->x = y;
> >>
> >> (x is a bool bitfield) would be compiled as
> >>
> >>   foo->x = (y != 0);
> > 
> > This is confusion; if y is a single bit bitfield, then there is
> > absolutely _NO_ difference between these two expressions.
> 
> y is not in a struct so it cannot be a single bit bitfield. :) If y is
> an int and foo->x is a bool bitfield, you get the following:
> 
> 	foo->x = 6;	/* foo->x is 1, it would be 0 for int:1 */
> 	foo->x = 7;	/* foo->x is 1, it would be 1 for int:1 */
> 

Urgh, reading hard. You're right!
