Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0338B35C6FD
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 15:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241662AbhDLNGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 09:06:05 -0400
Received: from mail.skyhub.de ([5.9.137.197]:32972 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241655AbhDLNGD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 09:06:03 -0400
Received: from zn.tnic (p200300ec2f052100338fe73c52330fca.dip0.t-ipconnect.de [IPv6:2003:ec:2f05:2100:338f:e73c:5233:fca])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 98C921EC03A0;
        Mon, 12 Apr 2021 15:05:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1618232743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=t5OPFg3BlJZVYDrFe4E03BZrpdCr/WXWjwTH1yDJrU8=;
        b=DByvbxIo8cF2XQWnCk3SvDu9G+PWCG9n5Hepw/e66gd7Cq4DPBsaCMw9spqnMEQf7wZfqe
        949QomuG/TukIlvPPqeEe6m/WskcbXd1lIBtSd1JD0B1GncZxzXZDM6IekTMuYZbCOaot+
        +YpjWsvKUF7mE7ttofdPQERqG+xUDYw=
Date:   Mon, 12 Apr 2021 15:05:42 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part1 PATCH 13/13] x86/kernel: add support to validate
 memory when changing C-bit
Message-ID: <20210412130542.GD24283@zn.tnic>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-14-brijesh.singh@amd.com>
 <20210412114901.GB24283@zn.tnic>
 <f9a69ad8-54bb-70f1-d606-6497e5753bb0@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f9a69ad8-54bb-70f1-d606-6497e5753bb0@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021 at 07:55:01AM -0500, Brijesh Singh wrote:
> The cur_entry is updated by the hypervisor. While building the psc
> buffer the guest sets the cur_entry=0 and the end_entry point to the
> last valid entry. The cur_entry is incremented by the hypervisor after
> it successfully processes one 4K page. As per the spec, the hypervisor
> could get interrupted in middle of the page state change and cur_entry
> allows the guest to resume the page state change from the point where it
> was interrupted.

This is non-obvious and belongs in a comment above it. Otherwise it
looks weird.

> Since we can get interrupted while executing the PSC so just to be safe
> I re-initialized the scratch scratch area with our buffer instead of
> relying on old values.

Ditto.

> As per the spec the caller must check that the cur_entry > end_entry to
> determine whether all the entries are processed. If not then retry the
> state change. The hypervisor will skip the previously processed entries.
> The snp_page_state_vmgexit() is implemented to return only after all the
> entries are changed.

Ditto.

This whole mechanism of what the guest does and what the HV does, needs
to be explained in a bigger comment somewhere around there so that it is
clear what's going on.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
