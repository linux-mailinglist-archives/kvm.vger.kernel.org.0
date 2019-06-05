Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A24F36579
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2019 22:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfFEUaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jun 2019 16:30:02 -0400
Received: from mga17.intel.com ([192.55.52.151]:60146 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726305AbfFEUaC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jun 2019 16:30:02 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 13:30:01 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga008.fm.intel.com with ESMTP; 05 Jun 2019 13:30:01 -0700
Date:   Wed, 5 Jun 2019 13:30:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Eugene Korenevsky <ekorenevsky@gmail.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 1/2] kvm: vmx: fix limit checking in
 get_vmx_mem_address()
Message-ID: <20190605203001.GF26328@linux.intel.com>
References: <20190605195729.GA25699@dnote>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190605195729.GA25699@dnote>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 05, 2019 at 10:57:29PM +0300, Eugene Korenevsky wrote:
> Intel SDM vol. 3, 5.3:
> The processor causes a
> general-protection exception (or, if the segment is SS, a stack-fault
> exception) any time an attempt is made to access the following addresses
> in a segment:
> - A byte at an offset greater than the effective limit
> - A word at an offset greater than the (effective-limit – 1)
> - A doubleword at an offset greater than the (effective-limit – 3)
> - A quadword at an offset greater than the (effective-limit – 7)
> 
> Therefore, the generic limit checking error condition must be
> 
> exn = (off > limit + 1 - access_len) = (off + access_len - 1 > limit)
> 
> but not
> 
> exn = (off + access_len > limit)
> 
> as for now.
> 
> Note: access length is incorrectly set to sizeof(u64). This will be fixed in
> the subsequent patch.
> 
> Signed-off-by: Eugene Korenevsky <ekorenevsky@gmail.com>
> ---
> Changes in v3 since v2: fixed limit checking condition to avoid underflow;
> added note
> 
>  arch/x86/kvm/vmx/nested.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index f1a69117ac0f..93df72597c72 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4115,7 +4115,7 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
>  		 */
>  		if (!(s.base == 0 && s.limit == 0xffffffff &&
>  		     ((s.type & 8) || !(s.type & 4))))
> -			exn = exn || (off + sizeof(u64) > s.limit);
> +			exn = exn || (off + sizeof(u64) - 1 > s.limit);

This still has a wrap bug in 32-bit KVM, e.g. off == 0xffffffff will
incorrectly pass the limit check due to wrapping its unsigned long.

>  	}
>  	if (exn) {
>  		kvm_queue_exception_e(vcpu,
> -- 
> 2.21.0
> 
