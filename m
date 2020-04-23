Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74D21B6576
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 22:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgDWUe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 16:34:28 -0400
Received: from mga07.intel.com ([134.134.136.100]:42895 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbgDWUe2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 16:34:28 -0400
IronPort-SDR: VAtVVIkPnEVAwufiCRL2eY0S5sFWbPoS0epttwpj4uoP7lmXNztWC4PUONWKQpc9ZVh7iuWueS
 1qxZIq7VN5hg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 13:34:25 -0700
IronPort-SDR: EI6Ve9nnUVyb2g3jV9TsSYsL0FC4/+jzmNMl1+ZNvkzCyZ6IqOTd3GUkgjEJuulHr5wLVISCjn
 H2pJtnmhT8QA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,309,1583222400"; 
   d="scan'208";a="301316877"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.147])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Apr 2020 13:34:24 -0700
Date:   Thu, 23 Apr 2020 13:34:24 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH] KVM: SVM: Change flag passed to GUP fast in
 sev_pin_memory()
Message-ID: <20200423203424.GA3997014@iweiny-DESK2.sc.intel.com>
References: <20200423152419.87202-1-Janakarajan.Natarajan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423152419.87202-1-Janakarajan.Natarajan@amd.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 23, 2020 at 10:24:19AM -0500, Janakarajan Natarajan wrote:
> When trying to lock read-only pages, sev_pin_memory() fails because FOLL_WRITE
> is used as the flag for get_user_pages_fast().
> 
> Commit 73b0140bf0fe ("mm/gup: change GUP fast to use flags rather than a write
> 'bool'") updated the get_user_pages_fast() call sites to use flags, but
> incorrectly updated the call in sev_pin_memory(). As the original coding of this
> call was correct, revert the change made by that commit.
> 
> Fixes: 73b0140bf0fe ("mm/gup: change GUP fast to use flags rather than a write 'bool'")
> Signed-off-by: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  arch/x86/kvm/svm/sev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index cf912b4aaba8..89f7f3aebd31 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -345,7 +345,7 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>  		return NULL;
>  
>  	/* Pin the user virtual address. */
> -	npinned = get_user_pages_fast(uaddr, npages, FOLL_WRITE, pages);
> +	npinned = get_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pages);
>  	if (npinned != npages) {
>  		pr_err("SEV: Failure locking %lu pages.\n", npages);
>  		goto err;
> -- 
> 2.17.1
> 
