Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E351E176024
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 17:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgCBQif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 11:38:35 -0500
Received: from mga05.intel.com ([192.55.52.43]:14401 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726872AbgCBQif (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 11:38:35 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 08:38:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,507,1574150400"; 
   d="scan'208";a="233222802"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 02 Mar 2020 08:38:34 -0800
Date:   Mon, 2 Mar 2020 08:38:34 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jan Kiszka <jan.kiszka@web.de>, kvm <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] kvm: x86: Make traced and returned value of kvm_cpuid
 consistent again
Message-ID: <20200302163834.GA6244@linux.intel.com>
References: <dd33df29-2c17-2dc8-cb8f-56686cd583ad@web.de>
 <688edd4d-81ad-bb6b-f166-4fb26a90bb9e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <688edd4d-81ad-bb6b-f166-4fb26a90bb9e@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 02, 2020 at 05:11:57PM +0100, Paolo Bonzini wrote:
> Queued, thanks.

Too fast, too fast!

On Sun, Mar 01, 2020 at 11:47:20AM +0100, Jan Kiszka wrote:
> From: Jan Kiszka <jan.kiszka@siemens.com>
>
> After 43561123ab37, found is not set correctly in case of leaves 0BH,
> 1FH, or anything out-of-range.

No, found is set correctly, kvm_cpuid() should return true if and only if
an exact match for the requested function is found, and that's the original
tracing behavior of "found" (pre-43561123ab37).

> This is currently harmless for the return value because the only caller
> evaluating it passes leaf 0x80000008.

No, it's 100% correct.  Well, technically it's irrelevant because the only
caller, check_cr_write(), passes %false for check_limit, i.e. found will be
true if and only if entry 0x80000008 exists.  But, in a purely hypothetical
scenario where the emulator passed check_limit=%true, the intent of "found"
is to report that the exact leaf was found, not if some random entry was
found.

> However, the trace entry is now misleading due to this inaccuracy. It is
> furthermore misleading because it reports the effective function, not
> the originally passed one. Fix that as well.
>
> Fixes: 43561123ab37 ("kvm: x86: Improve emulation of CPUID leaves 0BH and 1FH")
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> ---
>  arch/x86/kvm/cpuid.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index b1c469446b07..79a738f313f8 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1000,13 +1000,12 @@ static bool cpuid_function_in_range(struct kvm_vcpu *vcpu, u32 function)
>  bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>              u32 *ecx, u32 *edx, bool check_limit)
>  {
> -     u32 function = *eax, index = *ecx;
> +     u32 orig_function = *eax, function = *eax, index = *ecx;
>       struct kvm_cpuid_entry2 *entry;
>       struct kvm_cpuid_entry2 *max;

Rather than add another variable, this can be cleaned up to remove "max".
cpuid_function_in_range() also has a bug.  I've got patches, in the process
of whipping up a unit test.
