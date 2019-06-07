Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7B838E30
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 17:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbfFGPAJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 11:00:09 -0400
Received: from mga03.intel.com ([134.134.136.65]:18517 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728408AbfFGPAJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 11:00:09 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jun 2019 08:00:08 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga007.fm.intel.com with ESMTP; 07 Jun 2019 08:00:07 -0700
Date:   Fri, 7 Jun 2019 08:00:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Eugene Korenevsky <ekorenevsky@gmail.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v5 1/3] kvm: vmx: fix limit checking in
 get_vmx_mem_address()
Message-ID: <20190607150007.GB9083@linux.intel.com>
References: <20190607060248.GA29087@dnote>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190607060248.GA29087@dnote>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 07, 2019 at 09:02:48AM +0300, Eugene Korenevsky wrote:
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
> Also avoid integer overflow of `off` at 32-bit KVM by casting it to u64.
> 
> Note: access length is currently sizeof(u64) which is incorrect. This
> will be fixed in the subsequent patch.
> 
> Signed-off-by: Eugene Korenevsky <ekorenevsky@gmail.com>

When sending a new revision of a patch, please add any supplied tags to
the changelog, e.g. Reviewed-by, Tested-by, Acked-by, etc...  For example,
my Reviewed-by for v4 of this patch.

The one situation where you don't want to carry tags is if you make
non-trivial changes to a patch, e.g. person X reviews a patch but then
it gets reworked based on feedback from person Y, in which case the
Reviewed-by from X should be dropped as they haven't reviewed the new
code.

Thans for the patches!

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
