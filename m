Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019A5268F39
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 17:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbgINPLG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 11:11:06 -0400
Received: from mga12.intel.com ([192.55.52.136]:49958 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgINPKn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 11:10:43 -0400
IronPort-SDR: miyeDnmuLLeex+Prc1eTQcv9PcF6i4+LBCvjXYVvf5rkp5ziBjwfmXDvdeDhlvRKOlC4T4J4Mf
 qxs0pmiFZj9Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="138598591"
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="138598591"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 08:10:41 -0700
IronPort-SDR: KkLa6eYD0Q7rxcvdqHWuq1CSPJH4bi5Sw1Sv+VGHkpe2kxGCTHMLroycW1flryiElnZiQyKrht
 4GUDwyeMdrXQ==
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="287649586"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 08:10:40 -0700
Date:   Mon, 14 Sep 2020 08:10:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <jroedel@suse.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Colin King <colin.king@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH tip] KVM: nSVM: avoid freeing uninitialized pointers in
 svm_set_nested_state()
Message-ID: <20200914151039.GC6855@sjchrist-ice>
References: <20200914133725.650221-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914133725.650221-1-vkuznets@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 03:37:25PM +0200, Vitaly Kuznetsov wrote:
> The save and ctl pointers are passed uninitialized to kfree() when
> svm_set_nested_state() follows the 'goto out_set_gif' path. While
> the issue could've been fixed by initializing these on-stack varialbles
> to NULL, it seems preferable to eliminate 'out_set_gif' label completely
> as it is not actually a failure path and duplicating a single svm_set_gif()
> call doesn't look too bad.
> 
> Fixes: 6ccbd29ade0d ("KVM: SVM: nested: Don't allocate VMCB structures on stack")
> Addresses-Coverity: ("Uninitialized pointer read")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reported-by: Joerg Roedel <jroedel@suse.de>
> Reported-by: Colin King <colin.king@canonical.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
