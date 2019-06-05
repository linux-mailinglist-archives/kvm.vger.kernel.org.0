Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96EA735F3D
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2019 16:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbfFEO2t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jun 2019 10:28:49 -0400
Received: from mga03.intel.com ([134.134.136.65]:59555 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727864AbfFEO2t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jun 2019 10:28:49 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 07:28:48 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga006.fm.intel.com with ESMTP; 05 Jun 2019 07:28:48 -0700
Date:   Wed, 5 Jun 2019 07:28:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Eugene Korenevsky <ekorenevsky@gmail.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 1/2] kvm: vmx: fix limit checking in
 get_vmx_mem_address()
Message-ID: <20190605142848.GB26328@linux.intel.com>
References: <20190604220221.GA23558@dnote>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190604220221.GA23558@dnote>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 05, 2019 at 01:02:21AM +0300, Eugene Korenevsky wrote:
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
> exn = off > limit + 1 - operand_len
> 
> but not
> 
> exn = off + operand_len > limit
> 
> as for now.

Probably worth adding a note in the changelog about the access size
being hardcoded to quadword.  It's difficult to correlate the code with
the changelog without the context of the following patch to add 'len'.
 
> Signed-off-by: Eugene Korenevsky <ekorenevsky@gmail.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index f1a69117ac0f..fef3d7031715 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4115,7 +4115,7 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
>  		 */
>  		if (!(s.base == 0 && s.limit == 0xffffffff &&
>  		     ((s.type & 8) || !(s.type & 4))))
> -			exn = exn || (off + sizeof(u64) > s.limit);
> +			exn = exn || (off > s.limit + 1 - sizeof(u64));

Adjusting the limit will wrap a small limit, e.g. s.limit=3 will check
@off against 0xfffffffc.  And IMO, "off + sizeof(u64) - 1 > s.limit" is
more intuitive anyways, e.g. it conveys that we're calculating the
address of the last byte being accessed and checking to see if that would
cause a limit violation.

On a related note, there's a pre-existing wrap bug for 32-bit KVM since
@off is a 32-bit value (gva_t is unsigned long), but that's easily fixed
by casting @off to a u64.

>  	}
>  	if (exn) {
>  		kvm_queue_exception_e(vcpu,
> -- 
> 2.21.0
> 
