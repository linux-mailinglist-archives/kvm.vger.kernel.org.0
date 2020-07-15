Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596442207C1
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 10:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730435AbgGOIsN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 04:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729377AbgGOIsN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 04:48:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0709CC061755;
        Wed, 15 Jul 2020 01:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2hxetUaUv/Sl3bYl89m2PSXLP2Q6opXZZBO3eaTSzBk=; b=WW8YoVzkyFTNUO9zvgWo2fwDzD
        Lqc0L2K1pu7x6Aoez048E/g4JFKPhwgeWkwrPWMYTj0CoOm8R+ljR0SxX8amd6+eXuJX/CS9zmIBP
        943484iheiZFam8/iMWZxomMZnKu3B5V7HkQa0b7F7vNyE0OOpFL410o1HVKURFQzX7WfnAynrSRq
        tPJdTgs6yJAUqRMlfeetU4QyxaCqG8Ix+u5Od6IdthJP8fJ/XDceikh2bSZdYT0a33CAF8phFpOoh
        sMIvkBLrFGVTnISkOolA4A/ruDGcTPVcQFmN13Opjlbj/piWe6oHWmXOLLCQdHnbZ2fe1g5NLgJOf
        CE8x9iDA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvd50-0007wY-B1; Wed, 15 Jul 2020 08:47:54 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id BB2203028C8;
        Wed, 15 Jul 2020 10:47:52 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A994F2145CCC2; Wed, 15 Jul 2020 10:47:52 +0200 (CEST)
Date:   Wed, 15 Jul 2020 10:47:52 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 63/75] x86/sev-es: Handle #DB Events
Message-ID: <20200715084752.GD10769@hirez.programming.kicks-ass.net>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200714120917.11253-64-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714120917.11253-64-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 14, 2020 at 02:09:05PM +0200, Joerg Roedel wrote:

> @@ -1028,6 +1036,16 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
>  	struct ghcb *ghcb;
>  
>  	lockdep_assert_irqs_disabled();
> +
> +	/*
> +	 * #DB is special and needs to be handled outside of the intrumentation_begin()/end().
> +	 * Otherwise the #VC handler could be raised recursivly.
> +	 */
> +	if (error_code == SVM_EXIT_EXCP_BASE + X86_TRAP_DB) {
> +		vc_handle_trap_db(regs);
> +		return;
> +	}
> +
>  	instrumentation_begin();

Wait what?! That makes no sense what so ever.
