Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD5F15923E
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 15:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730267AbgBKOua (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 09:50:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42424 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgBKOua (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 09:50:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qWnHe7FrDz9eGFNLgL+pqzJ1ZkJDW34fv36AbfxXMr8=; b=cY+vxpu+iRqOion51hgN8KX8MM
        1ztoOSVH+loxUd+9cbzHUqhSuxSF3LOfJv8duUXhxKH2Z1IHwKMBH/at+c/Cr80ky3sxlR8qCQGvU
        aVr63GLxbE7ign3Eo81P5zChu8DcE0DuXWqtrdUZzLUQ6fsI5sw8gFrovEGfgeXMmH96vtXSW4wfO
        u3TY0WQCVUDMYijkbo0rt/loz5YVkvXyit/W4w49yjooJCHdaGaBY+7tkvMXitWtLnxCLfJi5reXz
        /knDm8dNgLTOgNnS5d+atTm7sAaC7tWVOA+UV4/lKoCh28QH0WVTf2P1CeSseDiFdoJg0jFZcRFC0
        XIvV5OOg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j1Wra-00065I-Nz; Tue, 11 Feb 2020 14:50:10 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id EE03C300446;
        Tue, 11 Feb 2020 15:48:19 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B1B3D2B8BECD3; Tue, 11 Feb 2020 15:50:08 +0100 (CET)
Date:   Tue, 11 Feb 2020 15:50:08 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [RFC PATCH 00/62] Linux as SEV-ES Guest Support
Message-ID: <20200211145008.GT14914@hirez.programming.kicks-ass.net>
References: <20200211135256.24617-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200211135256.24617-1-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 02:51:54PM +0100, Joerg Roedel wrote:
> NMI Special Handling
> --------------------
> 
> The last thing that needs special handling with SEV-ES are NMIs.
> Hypervisors usually start to intercept IRET instructions when an NMI got
> injected to find out when the NMI window is re-opened. But handling IRET
> intercepts requires the hypervisor to access guest register state and is
> not possible with SEV-ES. The specification under [1] solves this
> problem with an NMI_COMPLETE message sent my the guest to the
> hypervisor, upon which the hypervisor re-opens the NMI window for the
> guest.
> 
> This patch-set sends the NMI_COMPLETE message before the actual IRET,
> while the kernel is still on a valid stack and kernel cr3. This opens
> the NMI-window a few instructions early, but this is fine as under
> x86-64 Linux NMI-nesting is safe. The alternative would be to
> single-step over the IRET, but that requires more intrusive changes to
> the entry code because it does not handle entries from kernel-mode while
> on the entry stack.
> 
> Besides the special handling above the patch-set contains the handlers
> for the #VC exception and all the exit-codes specified in [1].

Oh gawd; so instead of improving the whole NMI situation, AMD went and
made it worse still ?!?
