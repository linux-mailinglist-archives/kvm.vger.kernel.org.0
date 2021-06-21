Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1504D3AECD0
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 17:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbhFUPyg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 11:54:36 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:58256 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbhFUPyg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Jun 2021 11:54:36 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id AF7651FD42;
        Mon, 21 Jun 2021 15:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624290740; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aWl5oiozFnzBHCGQMAccuUiysRNNMrHrEHi6rCshBRA=;
        b=WvmxKlxAVRMoYFZIQoXIPooX5wqG7nsGBl+LsiA7+M6E9y4KVPieWil2p8dFCcd8G9nUUN
        qS7Y5Hbp2OE/9TUlOEMrvgBaYZspbqKZJKPjqItATXWXrZ3hxUh4msyj+5qjo31hvt8j1H
        u9KXe73ra8DEwhH4Vgsamdg+i3A1CH0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624290740;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aWl5oiozFnzBHCGQMAccuUiysRNNMrHrEHi6rCshBRA=;
        b=XmFjjm32wWes2zR6ngx/UexJ1qoTZ1+FIXXuqeeotDr0TK+NLnrAtHNKwGdlbV5Vye6sVf
        GPUJSIdoexk6UNAg==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id F250C118DD;
        Mon, 21 Jun 2021 15:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624290740; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aWl5oiozFnzBHCGQMAccuUiysRNNMrHrEHi6rCshBRA=;
        b=WvmxKlxAVRMoYFZIQoXIPooX5wqG7nsGBl+LsiA7+M6E9y4KVPieWil2p8dFCcd8G9nUUN
        qS7Y5Hbp2OE/9TUlOEMrvgBaYZspbqKZJKPjqItATXWXrZ3hxUh4msyj+5qjo31hvt8j1H
        u9KXe73ra8DEwhH4Vgsamdg+i3A1CH0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624290740;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aWl5oiozFnzBHCGQMAccuUiysRNNMrHrEHi6rCshBRA=;
        b=XmFjjm32wWes2zR6ngx/UexJ1qoTZ1+FIXXuqeeotDr0TK+NLnrAtHNKwGdlbV5Vye6sVf
        GPUJSIdoexk6UNAg==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id e1mDObO10GC1HgAALh3uQQ
        (envelope-from <jroedel@suse.de>); Mon, 21 Jun 2021 15:52:19 +0000
Date:   Mon, 21 Jun 2021 17:52:18 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org, hpa@zytor.com,
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
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v7 0/2] x86/sev: Fixes for SEV-ES Guest Support
Message-ID: <YNC1sn9VxnKxP0iC@suse.de>
References: <20210618115409.22735-1-joro@8bytes.org>
 <YNCQbmC6kuL4K1Mp@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNCQbmC6kuL4K1Mp@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 21, 2021 at 03:13:18PM +0200, Peter Zijlstra wrote:
> On Fri, Jun 18, 2021 at 01:54:07PM +0200, Joerg Roedel wrote:
> > Joerg Roedel (2):
> >   x86/sev: Make sure IRQs are disabled while GHCB is active
> >   x86/sev: Split up runtime #VC handler for correct state tracking
> 
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Thanks Peter, also for your help with improving this code.
