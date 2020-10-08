Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA61287145
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 11:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbgJHJMl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 05:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgJHJMl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 05:12:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6937C061755;
        Thu,  8 Oct 2020 02:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iYkgmBFwBFTGLh4X6+sAeZSb4T2DgVQdFEDy9/+a90o=; b=b6J+u0XhcBjH42FDZ6+k0NTFvd
        PVj+PGjbsQ8c+Xog+CESns9qI9/H3+dqxAWg2Zk4ZOmx3iI0yRsoIFOr/aKC9ETzKQD9724tWdd2M
        sx8qzhDqsfjeDK0ayKnmlgmqZcSgeX6kfX1aDVOvwzwg8RJwrBz4nhTH5mCaM3lkOhSeFvgCCWqy1
        2uVz0mAi0Ud3r3GAChUbhdrktZaCne0lTqSR9bLa34Zvu+QfyQ3v8kbgQjSNBeKMfBlv4L4KfYmy/
        mogZoTOSdZUKgblsvH/YdzcxUAg8qQFj/XVpZERbAhpv/760DnSqlk0VE8XbcRwzODQUVZcAwREX8
        AF7+pORQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kQRyP-0000ve-TJ; Thu, 08 Oct 2020 09:12:30 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D33CC300455;
        Thu,  8 Oct 2020 11:12:25 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B8C1320C2330C; Thu,  8 Oct 2020 11:12:25 +0200 (CEST)
Date:   Thu, 8 Oct 2020 11:12:25 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     x86@kernel.org, kvm <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] x86/ioapic: Handle Extended Destination ID field in
 RTE
Message-ID: <20201008091225.GV2628@hirez.programming.kicks-ass.net>
References: <803bb6b2212e65c568c84ff6882c2aa8a0ee03d5.camel@infradead.org>
 <20201007122046.1113577-1-dwmw2@infradead.org>
 <20201007122046.1113577-3-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007122046.1113577-3-dwmw2@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 07, 2020 at 01:20:44PM +0100, David Woodhouse wrote:
> @@ -1861,7 +1863,8 @@ static void ioapic_configure_entry(struct irq_data *irqd)
>  	 * ioapic chip to verify that.
>  	 */
>  	if (irqd->chip == &ioapic_chip) {
> -		mpd->entry.dest = cfg->dest_apicid;
> +		mpd->entry.dest = cfg->dest_apicid & 0xff;
> +		mpd->entry.ext_dest = cfg->dest_apicid >> 8;
>  		mpd->entry.vector = cfg->vector;
>  	}
>  	for_each_irq_pin(entry, mpd->irq_2_pin)

All the other sites did memset(0) before the assignment, and this the
extra unconditional write of 0 to ext_dest is harmless.

This might be true for this site too, but it wasn't immediately obvious.
