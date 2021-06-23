Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9A33B173F
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 11:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhFWJwA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 05:52:00 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33330 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbhFWJv7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 05:51:59 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C1ECE21970;
        Wed, 23 Jun 2021 09:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624441781; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ux+joYOB/UsMHX7POd5I9X3miorAtdiYmMYNa+mcW6E=;
        b=mpcL6YYNLF0eM6WXm1Q4WixD/1Y0RnUjjEOMj46KrRfzIvpiyEyvAz2w4RPKVf8tHkkxoL
        6S7sXh6xbj3f802IhtyD/00gI6cHXGKk3DM6+mNDgFt2DUmLwag5CRxqHvdI5KzJCzSv13
        WIGLqCJgTEuPkg1lftiUMCsBAGXzPEI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624441781;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ux+joYOB/UsMHX7POd5I9X3miorAtdiYmMYNa+mcW6E=;
        b=nV2ZmUFlTFTEi4JFefYmjQ6Nsp0O9ka/R/08BSGYZLCHK4k+RdQVrxkZ5IGj8UMTmpFkR8
        GOMXtbRIVPf1eQDA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id EBBD211A97;
        Wed, 23 Jun 2021 09:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624441781; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ux+joYOB/UsMHX7POd5I9X3miorAtdiYmMYNa+mcW6E=;
        b=mpcL6YYNLF0eM6WXm1Q4WixD/1Y0RnUjjEOMj46KrRfzIvpiyEyvAz2w4RPKVf8tHkkxoL
        6S7sXh6xbj3f802IhtyD/00gI6cHXGKk3DM6+mNDgFt2DUmLwag5CRxqHvdI5KzJCzSv13
        WIGLqCJgTEuPkg1lftiUMCsBAGXzPEI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624441781;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ux+joYOB/UsMHX7POd5I9X3miorAtdiYmMYNa+mcW6E=;
        b=nV2ZmUFlTFTEi4JFefYmjQ6Nsp0O9ka/R/08BSGYZLCHK4k+RdQVrxkZ5IGj8UMTmpFkR8
        GOMXtbRIVPf1eQDA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id FdfVN7QD02ATSgAALh3uQQ
        (envelope-from <jroedel@suse.de>); Wed, 23 Jun 2021 09:49:40 +0000
Date:   Wed, 23 Jun 2021 11:49:39 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
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
Subject: Re: [PATCH 2/3] x86/sev: Add defines for GHCB version 2 MSR protocol
 requests
Message-ID: <YNMDs5iuhCxeII/U@suse.de>
References: <20210622144825.27588-1-joro@8bytes.org>
 <20210622144825.27588-3-joro@8bytes.org>
 <YNLXQIZ5e1wjkshG@8bytes.org>
 <YNL/wpVY1PmGJASW@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNL/wpVY1PmGJASW@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 23, 2021 at 11:32:50AM +0200, Borislav Petkov wrote:
> Ok, so I took a critical look at this and it doesn't make sense to have
> a differently named define each time you need the [63:12] slice of
> GHCBData. So you can simply use GHCB_DATA(msr_value) instead, see below.
> 
> Complaints?

Looks good to me.

