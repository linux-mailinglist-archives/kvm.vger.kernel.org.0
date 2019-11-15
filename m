Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAAA2FD2E1
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 03:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfKOCSJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 21:18:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:50611 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726533AbfKOCSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 21:18:08 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Nov 2019 18:18:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,306,1569308400"; 
   d="scan'208";a="199047942"
Received: from guptapadev.jf.intel.com (HELO guptapadev.amr) ([10.7.198.56])
  by orsmga008.jf.intel.com with ESMTP; 14 Nov 2019 18:18:07 -0800
Date:   Thu, 14 Nov 2019 18:11:19 -0800
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>,
        "Gupta, Pawan Kumar" <pawan.kumar.gupta@intel.com>,
        kirill.shutemov@linux.intel.com
Subject: Re: [FYI PATCH 0/7] Mitigation for CVE-2018-12207
Message-ID: <20191115021119.GB18745@guptapadev.amr>
References: <1573593697-25061-1-git-send-email-pbonzini@redhat.com>
 <23353382-53ea-8b20-7e30-763ef6df374c@siemens.com>
 <ea5a084b-e047-6677-b8fe-d7bb6f8c0ef8@redhat.com>
 <dffb19ab-daa2-a513-531e-c43279d8a4bf@intel.com>
 <6C0513A5-6C73-4F17-B73B-6F19E7D9EAF0@gmail.com>
 <6a317558-44c0-5a21-0310-4ae49048134f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a317558-44c0-5a21-0310-4ae49048134f@intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 13, 2019 at 09:26:24PM -0800, Dave Hansen wrote:
> On 11/13/19 5:17 PM, Nadav Amit wrote:
> > But is it always the case? Looking at __split_large_page(), it seems that the
> > TLB invalidation is only done after the PMD is changed. Can't this leave a
> > small time window in which a malicious actor triggers a machine-check on 
> > another core than the one that runs __split_large_page()?
> 
> It's not just a split.  It has to be a change that results in
> inconsistencies between two entries in the TLB.  A normal split doesn't
> change the resulting final translations and is never inconsistent
> between the two translations.
> 
> To have an inconsistency, you need to change the backing physical
> address (or cache attributes?).  I'd need to go double-check the erratum
> to be sure about the cache attributes.
> 
> In any case, that's why we decided that normal kernel mapping
> split/merges don't need to be mitigated.  But, we should probably
> document this somewhere if it's not clear.
> 
> Pawan, did we document the results of the audit you did anywhere?

Kirill Shutemov did the heavy lifting, thank you Kirill. Below were the
major areas probed: 

1. Can a non-privileged user application induce this erratum?

	Userspace can trigger switching between 4k and 2M (in both
	directions), but kernel already follows the protocol to avoid
	this issue due to similar errata in AMD CPUs. [1][2]

2. If kernel can accidentally induce this?

	__split_large_page() in arch/x86/mm/pageattr.c was the suspect [3]. 

	The locking scheme described in the comment only guarantees that
	TLB entries for 4k and 2M/1G will have the same page attributes
	until TLB flush. There is nothing that would protect from having
	multiple TLB entries of different sizes with the same attributes.

	But the erratum can be triggered only when:

		Software modifies the paging structures so that the same
		linear address is translated using a large page (2 MB, 4
		MB, or 1 GB) with a different physical address or memory
		type.

	And in this case the physical address and memory type is
	preserved until TLB is flushed, so it should be safe.

Thanks,
Pawan

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/mm/huge_memory.c#n2190
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/mm/khugepaged.c#n1038
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/mm/pageattr.c#n1020
