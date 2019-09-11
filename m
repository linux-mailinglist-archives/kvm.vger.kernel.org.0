Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC177B046D
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 21:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730253AbfIKTIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 15:08:41 -0400
Received: from mga12.intel.com ([192.55.52.136]:57045 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728415AbfIKTIl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 15:08:41 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Sep 2019 12:08:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,494,1559545200"; 
   d="scan'208";a="209765510"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 11 Sep 2019 12:08:41 -0700
Date:   Wed, 11 Sep 2019 12:08:41 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Bill Wendling <morbo@google.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] x86: remove memory constraint from "mov"
 instruction
Message-ID: <20190911190840.GG1045@linux.intel.com>
References: <CAGG=3QWteHe8zCdXQVQv+42pMO2k4XvAbj_A=ptRUi9E2AwT2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGG=3QWteHe8zCdXQVQv+42pMO2k4XvAbj_A=ptRUi9E2AwT2w@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 09, 2019 at 02:19:20PM -0700, Bill Wendling wrote:
> The "mov" instruction to get the error code shouldn't move into a memory
> location. Don't allow the compiler to make this decision. Instead
> specify that only a register is appropriate here.

I'd prefer the changelog to say something like:

  Remove a bogus memory contraint as x86 does not have a generic
  memory-to-memory "mov" instruction.

Saying "shouldn't move into a memory location" makes it sound like there's
an unwanted side effect when the compiler selects memory, though I suppose
you could argue that a build error is an unwanted side effect :-).

Out of curiosity, do any compilers actually generate errors because of
this, or is it simply dead code?

> 
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  lib/x86/desc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/x86/desc.c b/lib/x86/desc.c
> index 5f37cef..451f504 100644
> --- a/lib/x86/desc.c
> +++ b/lib/x86/desc.c
> @@ -263,7 +263,7 @@ unsigned exception_error_code(void)
>  {
>      unsigned short error_code;
> 
> -    asm("mov %%gs:6, %0" : "=rm"(error_code));
> +    asm("mov %%gs:6, %0" : "=r"(error_code));
>      return error_code;
>  }
