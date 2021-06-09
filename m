Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 239043A1A55
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 17:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236170AbhFIQBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 12:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbhFIQBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 12:01:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C44FC061574;
        Wed,  9 Jun 2021 08:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QFACyy0y7HrUHjJ9cPsUOZAld6dTw9TIGvy3FNUUEgI=; b=ez+gR39/yIG6DsvQX0y7KALGqu
        OMULMPUpfNufKUvUdlEHN9s2LEkIYgMxMfPfQeyQyt1wGMKGeUjcrWNkr7BLGGvaSSV7rC4R0cTtA
        byA46TmoajpBqD9QCw0smhbVGAyfuECZ9PZXPoFgfdwS4ZDlew+syrpxouv9W9pOhFcEi2ZVOfCpM
        Zvg1XsScqRW6Vnr1UcQMDERu1VKEejBJYgg0tsaBFC8rNIbU/TJIQvAxrAXuro5+TzC2mFXbiLv0X
        89qLCoy/65c33llcaRR67OL30Tz3FXndfAlaBhPMJkPK+YIF5ltu0md10TfhTvsXYyvRXKKutc8Mq
        +/s34mJA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lr0bt-000fa4-Ku; Wed, 09 Jun 2021 15:59:26 +0000
Date:   Wed, 9 Jun 2021 16:59:17 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, david@redhat.com,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2 1/2] mm/vmalloc: export __vmalloc_node_range
Message-ID: <YMDlVdB8m62AhbB7@infradead.org>
References: <20210608180618.477766-1-imbrenda@linux.ibm.com>
 <20210608180618.477766-2-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608180618.477766-2-imbrenda@linux.ibm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021 at 08:06:17PM +0200, Claudio Imbrenda wrote:
> The recent patches to add support for hugepage vmalloc mappings added a
> flag for __vmalloc_node_range to allow to request small pages.
> This flag is not accessible when calling vmalloc, the only option is to
> call directly __vmalloc_node_range, which is not exported.
> 
> This means that a module can't vmalloc memory with small pages.
> 
> Case in point: KVM on s390x needs to vmalloc a large area, and it needs
> to be mapped with small pages, because of a hardware limitation.
> 
> This patch exports __vmalloc_node_range so it can be used in modules
> too.

No.  I spent a lot of effort to mak sure such a low-level API is
not exported.
