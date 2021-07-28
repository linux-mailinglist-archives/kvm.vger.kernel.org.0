Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5AF3D8C22
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 12:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235966AbhG1Kqr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 06:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232514AbhG1Kqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 06:46:45 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2ACC061757;
        Wed, 28 Jul 2021 03:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YQ6n99gglRIs882rM3VAbrraBMVYq36xoGa1dJkdE1U=; b=jYFNUJ65XiqIDkOlUy2lMGnAg2
        MJ+YjxSokjtG8XrRp1WQd2hfx98seC1/Bp1d0Vk7r4qoSxRjInphARNmUnpKBdfVXsLA5kEJbbpiM
        /cNVPpASl/QBu1IhkUdCB8kmuRMBUMN+Re5KM5hd3a0O3ZIvCM9jumtMUQjW4o8weqy+9mrXsGqCQ
        XEGDiEulhNWxMb2By0BUNfOcYxzFLgJ9svhj81JyeuqqGQlHsRcYfWida6ZXH7I6vQEVTcEU6jI2P
        r5IlGgOsRshykl8cCY61PNkDGgZ0FH6Wp3yH45YDf9sbcd5Vl6SioBdeuQzBxZv3zMe+toHip1JrY
        GCEsSA0w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m8h4b-003gLS-Td; Wed, 28 Jul 2021 10:46:02 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3287330005A;
        Wed, 28 Jul 2021 12:46:00 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 186A721071BE8; Wed, 28 Jul 2021 12:46:00 +0200 (CEST)
Date:   Wed, 28 Jul 2021 12:46:00 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Suleiman Souhlal <suleiman@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        ssouhlal@freebsd.org, joelaf@google.com, senozhatsky@chromium.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>
Subject: Re: [RFC PATCH 0/2] KVM: Support Heterogeneous RT VCPU
 Configurations.
Message-ID: <YQE1aB0/6B1FReZg@hirez.programming.kicks-ass.net>
References: <20210728073700.120449-1-suleiman@google.com>
 <YQEQ9zdlBrgpOukj@hirez.programming.kicks-ass.net>
 <20210728103253.GB7633@fuller.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728103253.GB7633@fuller.cnet>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 07:32:53AM -0300, Marcelo Tosatti wrote:
> Peter, not sure what exactly are you thinking of? (to solve this
> particular problem with pv deadline scheduling).
> 
> Shouldnt it be possible to, through paravirt locks, boost the priority
> of the non-RT vCPU (when locking fails in the -RT vCPU) ?

No. Static priority scheduling does not compose. Any scheme that relies
on the guest behaving 'nice' is unacceptable.
