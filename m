Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEA8414F38B
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 22:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgAaVEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 16:04:25 -0500
Received: from mga12.intel.com ([192.55.52.136]:57876 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbgAaVEZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 16:04:25 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 13:04:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,387,1574150400"; 
   d="scan'208";a="218725860"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 31 Jan 2020 13:04:24 -0800
Date:   Fri, 31 Jan 2020 13:04:24 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: VMX: Extend VMX's #AC handding
Message-ID: <20200131210424.GG18946@linux.intel.com>
References: <20200131201743.GE18946@linux.intel.com>
 <5CD544A4-291A-47A1-80D1-F77FE0444925@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5CD544A4-291A-47A1-80D1-F77FE0444925@amacapital.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 31, 2020 at 12:57:51PM -0800, Andy Lutomirski wrote:
> 
> > On Jan 31, 2020, at 12:18 PM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > 
> > This is essentially what I proposed a while back.  KVM would allow enabling
> > split-lock #AC in the guest if and only if SMT is disabled or the enable bit
> > is per-thread, *or* the host is in "warn" mode (can live with split-lock #AC
> > being randomly disabled/enabled) and userspace has communicated to KVM that
> > it is pinning vCPUs.
> 
> How about covering the actual sensible case: host is set to fatal?  In this
> mode, the guest gets split lock detection whether it wants it or not. How do
> we communicate this to the guest?

KVM doesn't advertise split-lock #AC to the guest and returns -EFAULT to the
userspace VMM if the guest triggers a split-lock #AC.

Effectively the same behavior as any other userspace process, just that KVM
explicitly returns -EFAULT instead of the process getting a SIGBUS.
