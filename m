Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1DF445C310
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 14:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352194AbhKXNfR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 08:35:17 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:49620 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344294AbhKXNcC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 08:32:02 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id ADB911FD37;
        Wed, 24 Nov 2021 13:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637760531; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kmul1IbP0GnECy1ymvqNlUCJsoqlTASzkS58dvywssg=;
        b=ZEJ5PnuBiszih5UXgJaGfk48htnkxlak3oSlR+gsJcxUaDIvq/C+QihbR+cSOgBpG+zgd8
        +K0SHfJOVuvCZ5p8/tLlFazoWL73VNlxHc0nIKokDCaJgYq3FFrzJdjBvkcNLTPEHdH7Nw
        dl52rAA+SWMLMAv737DIisN9S0JnLz8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637760531;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kmul1IbP0GnECy1ymvqNlUCJsoqlTASzkS58dvywssg=;
        b=z67fHxRWZigT6qf7YYjcA3is5C6hHq/rq3j5Mp8klzhWcoWQddC+zDx+5goR1ptD0YeIIc
        jRvrdCjFrPiJ1ZDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 175E313F20;
        Wed, 24 Nov 2021 13:28:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id fhDpAxM+nmEsRQAAMHmgww
        (envelope-from <jroedel@suse.de>); Wed, 24 Nov 2021 13:28:51 +0000
Date:   Wed, 24 Nov 2021 14:28:49 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     Michael Sterritt <sterritt@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-coco@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
        marcorr@google.com, pgonda@google.com
Subject: Re: [PATCH v2] x86/sev-es: Fix SEV-ES INS/OUTS instructions for
 word, dword, and qword
Message-ID: <YZ4+EYF8dhrzRy2h@suse.de>
References: <20211119232757.176201-1-sterritt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119232757.176201-1-sterritt@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 19, 2021 at 03:27:57PM -0800, Michael Sterritt wrote:
> Properly type the operands being passed to __put_user()/__get_user().
> Otherwise, these routines truncate data for dependent instructions
> (e.g., INSW) and only read/write one byte.
> 
> Tested: Tested by sending a string with `REP OUTSW` to a port and then
> reading it back in with `REP INSW` on the same port. Previous behavior
> was to only send and receive the first char of the size. For example,
> word operations for "abcd" would only read/write "ac". With change, the
> full string is now written and read back.
> 
> Fixes: f980f9c31a923 (x86/sev-es: Compile early handler code into kernel image)
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Marc Orr <marcorr@google.com>
> Reviewed-by: Peter Gonda <pgonda@google.com>
> Signed-off-by: Michael Sterritt <sterritt@google.com>

Reviewed-by: Joerg Roedel <jroedel@suse.de>

