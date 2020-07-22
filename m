Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672F52292ED
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 10:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgGVIFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 04:05:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:41976 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726141AbgGVIFf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 04:05:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0EB4CAFE8;
        Wed, 22 Jul 2020 08:05:41 +0000 (UTC)
Date:   Wed, 22 Jul 2020 10:05:30 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Mike Stunes <mstunes@vmware.com>
Cc:     Joerg Roedel <joro@8bytes.org>, "x86@kernel.org" <x86@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
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
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v4 51/75] x86/sev-es: Handle MMIO events
Message-ID: <20200722080530.GH6132@suse.de>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200714120917.11253-52-joro@8bytes.org>
 <40D5C698-1ED2-4CCE-9C1D-07620A021A6A@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40D5C698-1ED2-4CCE-9C1D-07620A021A6A@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hmm, I have a theory ...

On Tue, Jul 21, 2020 at 09:01:44PM +0000, Mike Stunes wrote:
> If I remove the call to probe_roms from setup_arch, or remove the calls to romchecksum from probe_roms, this kernel boots normally.
> 
> Please let me know of other tests I should run or data that I can collect. Thanks!

... can you please try the attached diff?

diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index 251d0aabc55a..e1fea7a38019 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -389,7 +389,8 @@ static bool vc_slow_virt_to_phys(struct ghcb *ghcb, struct es_em_ctxt *ctxt,
 	pgd_t *pgd;
 	pte_t *pte;
 
-	pgd = pgd_offset(current->active_mm, va);
+	pgd = __va(read_cr3_pa());
+	pgd = &pgd[pgd_index(va)];
 	pte = lookup_address_in_pgd(pgd, va, &level);
 	if (!pte) {
 		ctxt->fi.vector     = X86_TRAP_PF;
