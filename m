Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5661E391A84
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 16:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbhEZOot (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 10:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234951AbhEZOos (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 10:44:48 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7128C061574;
        Wed, 26 May 2021 07:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LMFF8VTnEm5kj35Myws1C3qxUFhbJOOxFDs5F+/lqOg=; b=JeZPPKazDKGzh6J0X3JIPQ5rmj
        mtKGeMKDyhgFn5IzTf0Y6pA3rkcWzJytlQxZXAVGsM8riOG20rBGL7lnPUlr5DHqwLiZ93zBl4m44
        /jQLSQTzpz8ED3pIvVY35Da24jT85PS2bjCjR4g7bmR3398d/L08BrjvCrfALR/Pwemt05BQDzE24
        bXud+h0A6EWKBj9ucHnPRw2pvGW0xITn1ztIh9HV2ZmtVCQloh6opQp0FbELnkxiM77IVj+xdvzcG
        aYd1q8yWQ5f6hOC6/QQe9Dm/3iKmttzn1pHDiTqJgXDN5304mKQcFL8DASK/zNHZgo/Fel3m2L21s
        Kgj2SPiA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1llukL-000foH-34; Wed, 26 May 2021 14:43:04 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 613BD300242;
        Wed, 26 May 2021 16:43:03 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 320BC201FF8B9; Wed, 26 May 2021 16:43:03 +0200 (CEST)
Date:   Wed, 26 May 2021 16:43:03 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Masanori Misono <m.misono760@gmail.com>
Cc:     David Woodhouse <dwmw@amazon.co.uk>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Rohit Jain <rohit.k.jain@oracle.com>,
        Ingo Molnar <mingo@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/1] Make vCPUs that are HLT state candidates for
 load balancing
Message-ID: <YK5ed8ixweIAsvlL@hirez.programming.kicks-ass.net>
References: <20210526133727.42339-1-m.misono760@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526133727.42339-1-m.misono760@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 26, 2021 at 10:37:26PM +0900, Masanori Misono wrote:
> is_vcpu_preempted() is also used in PV spinlock implementations to mitigate
> lock holder preemption problems,

It's used to abort optimistic spinners.

> etc. A vCPU holding a lock does not do HLT,

Optimistic spinning is actually part of mutexes and rwsems too, and in
those cases we might very well end up in idle while holding the lock.
However; in that case the task will have been scheduled out and the
optimistic spin loop will terminate due to that (see the ->on_cpu
condition).

> so I think this patch doesn't affect them.

That is correct.

> However, pCPU may be
> running the host's thread that has higher priority than a vCPU thread, and
> in that case, is_vcpu_preempted() should return 0 ideally.

No, in that case vcpu_is_preempted() really should return true. There is
no saying how long the vcpu is gone for.

