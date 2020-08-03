Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9986723AC1B
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 20:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgHCSEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 14:04:13 -0400
Received: from mga05.intel.com ([192.55.52.43]:60206 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgHCSEN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 14:04:13 -0400
IronPort-SDR: cEs78MnnjhQk+Hi8S8FXpgGZNmOUaHmm2O9dik9Wu0EpRVf0iSA4iLhHilqyXqIg1Fmm8+w+D6
 qJd6l9Qe8LpA==
X-IronPort-AV: E=McAfee;i="6000,8403,9702"; a="237032806"
X-IronPort-AV: E=Sophos;i="5.75,430,1589266800"; 
   d="scan'208";a="237032806"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2020 11:04:12 -0700
IronPort-SDR: 70E1dYBz6MBC0h7yuhWDhL52de+GN+4dI/uC0V82q++Gn7MIvtXTL6u+ZDNRBzEr9VPpJPwNld
 8yProVIDgh+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,430,1589266800"; 
   d="scan'208";a="396210316"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga001.fm.intel.com with ESMTP; 03 Aug 2020 11:04:12 -0700
Date:   Mon, 3 Aug 2020 11:04:12 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH v3 1/4] KVM: SVM: nested: Don't allocate VMCB structures
 on stack
Message-ID: <20200803180411.GE3151@linux.intel.com>
References: <20200803122708.5942-1-joro@8bytes.org>
 <20200803122708.5942-2-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803122708.5942-2-joro@8bytes.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 03, 2020 at 02:27:05PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Do not allocate a vmcb_control_area and a vmcb_save_area on the stack,
> as these structures will become larger with future extenstions of
> SVM and thus the svm_set_nested_state() function will become a too large
> stack frame.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
> @@ -1110,15 +1123,15 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	 */
>  	cr0 = kvm_read_cr0(vcpu);
>          if (((cr0 & X86_CR0_CD) == 0) && (cr0 & X86_CR0_NW))
> -                return -EINVAL;
> +                goto out_free;

Pre-existing issue, but this could opportunistically fix a spaces vs. tabs
issue.

ERROR: code indent should use tabs where possible
#71: FILE: arch/x86/kvm/svm/nested.c:1126:
+                goto out_free;$

WARNING: please, no spaces at the start of a line
#71: FILE: arch/x86/kvm/svm/nested.c:1126:
+                goto out_free;$

