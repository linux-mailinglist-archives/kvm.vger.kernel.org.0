Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6631A1FA0
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 13:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgDHLNf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 07:13:35 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56996 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728100AbgDHLNf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 07:13:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=owW3+5nk1emkhI4cOviK2xmpja0Eslb3d5NnNfm4ABY=; b=oteVl0qlOAfP5bhgb67Zr9x8Uc
        bRuCew67l9BV+/JRZuTjgTOAHnBFS5SKoNK/HOyOWZ59WupxVuibCY5+05oGbheDiG5HWHmy8S4cY
        +f2xrfMQsZOvUZYjTabyUzPGHWusJiCu9h6qxdvvNWt8LZz5G6NWmIgJo/wOSFsGaPB/EH1LWEyba
        Uxs0oqH+RwuSDxacMYmzB3oEW+Nr+dQgn9MZPS9f+gEO3+8AdQmbcC07SK3Pp7nDys4oWPuoeuDtv
        ySERjY/R8FKfZKJ7RXVPmUhhFomNX8N+JCj4eARuV9FGrPbDsyi2jNOaJLHBEZLyhuKvECYTaU5Ar
        fS+QjguQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jM8e4-0005mx-Gs; Wed, 08 Apr 2020 11:13:24 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id E0E2E300130;
        Wed,  8 Apr 2020 13:13:22 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 944032BA90A62; Wed,  8 Apr 2020 13:13:22 +0200 (CEST)
Date:   Wed, 8 Apr 2020 13:13:22 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Ankur Arora <ankur.a.arora@oracle.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com,
        jpoimboe@redhat.com, namit@vmware.com, mhiramat@kernel.org,
        jgross@suse.com, bp@alien8.de, vkuznets@redhat.com,
        pbonzini@redhat.com, boris.ostrovsky@oracle.com,
        mihai.carabas@oracle.com, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC PATCH 15/26] x86/alternatives: Non-emulated text poking
Message-ID: <20200408111322.GU20713@hirez.programming.kicks-ass.net>
References: <20200408050323.4237-1-ankur.a.arora@oracle.com>
 <20200408050323.4237-16-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408050323.4237-16-ankur.a.arora@oracle.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 07, 2020 at 10:03:12PM -0700, Ankur Arora wrote:
> +static void __maybe_unused sync_one(void)
> +{
> +	/*
> +	 * We might be executing in NMI context, and so cannot use
> +	 * IRET as a synchronizing instruction.
> +	 *
> +	 * We could use native_write_cr2() but that is not guaranteed
> +	 * to work on Xen-PV -- it is emulated by Xen and might not
> +	 * execute an iret (or similar synchronizing instruction)
> +	 * internally.
> +	 *
> +	 * cpuid() would trap as well. Unclear if that's a solution
> +	 * either.
> +	 */
> +	if (in_nmi())
> +		cpuid_eax(1);
> +	else
> +		sync_core();
> +}

That's not thinking staight; what do you think the INT3 does when it
happens inside an NMI ?
