Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE15436576
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2019 22:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfFEU1s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jun 2019 16:27:48 -0400
Received: from mga03.intel.com ([134.134.136.65]:18942 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbfFEU1s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jun 2019 16:27:48 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 13:27:47 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga007.fm.intel.com with ESMTP; 05 Jun 2019 13:27:47 -0700
Date:   Wed, 5 Jun 2019 13:27:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Eugene Korenevsky <ekorenevsky@gmail.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 2/2] kvm: vmx: segment limit check: use access length
Message-ID: <20190605202746.GE26328@linux.intel.com>
References: <20190605200055.GA25739@dnote>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605200055.GA25739@dnote>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 05, 2019 at 11:00:55PM +0300, Eugene Korenevsky wrote:
> There is an imperfection in get_vmx_mem_address(): access length is ignored
> when checking the limit. To fix this, pass access length as a function argument.
> The access length is obvious since it is used by callers after
> get_vmx_mem_address() call.
> 
> Note: both handle_vmread() and handle_vmwrite() should use is_long_mode()
> instead of is_64_bit_mode() because VMREAD/VMWRITE opcodes are invalid in
> compatibility mode and there is no any reason for extra checking CS.L.
> 
> Signed-off-by: Eugene Korenevsky <ekorenevsky@gmail.com>
> ---
> Changes in v2 since v1: fixed logical bug (`len` argument was not used inside
> get_vmx_mem_address() function); fixed the subject
> Changes in v3 since v2: replace is_64_bit_mode() with is_long_mode() in
> handle_vmwrite()

Replacing is_64_bit_mode() with is_long_mode() in various functions
should be done as a preqreq patch, if only to explain in the changelog
that VMX instructions #UD in compatibility mode.
