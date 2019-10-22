Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64C88E0D92
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 23:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731949AbfJVVBW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 17:01:22 -0400
Received: from mga12.intel.com ([192.55.52.136]:15244 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730146AbfJVVBW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 17:01:22 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 14:01:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,217,1569308400"; 
   d="scan'208";a="196569094"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 22 Oct 2019 14:01:21 -0700
Date:   Tue, 22 Oct 2019 14:01:20 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc:     linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, pbonzini@redhat.com,
        rkrcmar@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, boris.ostrovsky@oracle.com,
        jgross@suse.com, peterz@infradead.org, will@kernel.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        mikelley@microsoft.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v7 2/5] x86/kvm: Change print code to use pr_*() format
Message-ID: <20191022210120.GQ2343@linux.intel.com>
References: <1571649076-2421-1-git-send-email-zhenzhong.duan@oracle.com>
 <1571649076-2421-3-git-send-email-zhenzhong.duan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571649076-2421-3-git-send-email-zhenzhong.duan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 21, 2019 at 05:11:13PM +0800, Zhenzhong Duan wrote:
> pr_*() is preferred than printk(KERN_* ...), after change all the print
> in arch/x86/kernel/kvm.c will have "kvm_guest: xxx" style.
> 
> No functional change.
> 
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krcmar <rkrcmar@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> ---
>  arch/x86/kernel/kvm.c | 30 ++++++++++++++++--------------
>  1 file changed, 16 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 3bc6a266..249f14a 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -7,6 +7,8 @@
>   *   Authors: Anthony Liguori <aliguori@us.ibm.com>
>   */
>  
> +#define pr_fmt(fmt) "kvm_guest: " fmt

Sort of a silly nit, especially since I suggested kvm_guest...

What about using kvm-guest instead of kvm_guest to be consistent with
kvm-clock, the other prolific logger in a KVM guest.

E.g.

  kvm-clock: cpu 1, msr 551e041, secondary cpu clock
  kvm-guest: setup async PF for cpu 1
  kvm-guest: stealtime: cpu 1, msr 277695f40
  kvm-clock: cpu 2, msr 551e081, secondary cpu clock
  kvm-guest: setup async PF for cpu 2
  kvm-guest: stealtime: cpu 2, msr 277715f40
  kvm-clock: cpu 3, msr 551e0c1, secondary cpu clock
  kvm-guest: setup async PF for cpu 3
  kvm-guest: stealtime: cpu 3, msr 277795f40
  kvm-clock: cpu 4, msr 551e101, secondary cpu clock
  
instead of

  kvm-clock: cpu 1, msr 551e041, secondary cpu clock
  kvm_guest: setup async PF for cpu 1
  kvm_guest: stealtime: cpu 1, msr 277695f40
  kvm-clock: cpu 2, msr 551e081, secondary cpu clock
  kvm_guest: setup async PF for cpu 2
  kvm_guest: stealtime: cpu 2, msr 277715f40
  kvm-clock: cpu 3, msr 551e0c1, secondary cpu clock
  kvm_guest: setup async PF for cpu 3
  kvm_guest: stealtime: cpu 3, msr 277795f40
  kvm-clock: cpu 4, msr 551e101, secondary cpu clock
