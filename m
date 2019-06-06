Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7DA737C12
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 20:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730511AbfFFSSh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 14:18:37 -0400
Received: from mga14.intel.com ([192.55.52.115]:43197 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727559AbfFFSSh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 14:18:37 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 11:18:36 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga005.jf.intel.com with ESMTP; 06 Jun 2019 11:18:36 -0700
Date:   Thu, 6 Jun 2019 11:18:36 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Eugene Korenevsky <ekorenevsky@gmail.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v4 1/2] kvm: vmx: fix limit checking in
 get_vmx_mem_address()
Message-ID: <20190606181835.GH23169@linux.intel.com>
References: <20190605211739.GA21798@dnote>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190605211739.GA21798@dnote>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 06, 2019 at 12:17:39AM +0300, Eugene Korenevsky wrote:
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
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
