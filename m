Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDAAC1F1E56
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 19:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387567AbgFHR3X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 13:29:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:12672 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730697AbgFHR3W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 13:29:22 -0400
IronPort-SDR: TkRODIQiUQCJlXzq7ghxlfdz+jDAX14ny9tZ6sz4B54ceGJeLgtUb6Fe7P0Fwlb9oSwZ7+MV+2
 Hqb3RqJ92eGA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2020 10:29:21 -0700
IronPort-SDR: qptkctbUJUSvQAC1ycvjADfEDhUrhHOX5yl1OzzQxI56au3vxE+MjQ88fkKwTx8lv1vlJ4i/FY
 fWhF3aO1hQDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,487,1583222400"; 
   d="scan'208";a="258747153"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga007.fm.intel.com with ESMTP; 08 Jun 2020 10:29:21 -0700
Date:   Mon, 8 Jun 2020 10:29:21 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Liam Merwick <liam.merwick@oracle.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Brad Campbell <lists2009@fnarfbargle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] x86/cpu: Reinitialize IA32_FEAT_CTL MSR on BSP during
 wakeup
Message-ID: <20200608172921.GC8223@linux.intel.com>
References: <20200605200728.10145-1-sean.j.christopherson@intel.com>
 <b2ac2400-dbc1-f6bc-a397-17f1ae10bd83@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2ac2400-dbc1-f6bc-a397-17f1ae10bd83@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 08, 2020 at 11:12:35AM +0100, Liam Merwick wrote:
> On 05/06/2020 21:07, Sean Christopherson wrote:
> >Reinitialize IA32_FEAT_CTL on the BSP during wakeup to handle the case
> >where firmware doesn't initialize or save/restore across S3.  This fixes
> >a bug where IA32_FEAT_CTL is left uninitialized and results in VMXON
> >taking a #GP due to VMX not being fully enabled, i.e. breaks KVM.
> >
> >Use init_ia32_feat_ctl() to "restore" IA32_FEAT_CTL as it already deals
> >with the case where the MSR is locked, and because APs already redo
> >init_ia32_feat_ctl() during suspend by virtue of the SMP boot flow being
> >used to reinitialize APs upon wakeup.  Do the call in the early wakeup
> >flow to avoid dependencies in the syscore_ops chain, e.g. simply adding
> >a resume hook is not guaranteed to work, as KVM does VMXON in its own
> >resume hook, kvm_resume(), when KVM has active guests.
> >
> >Reported-by: Brad Campbell <lists2009@fnarfbargle.com>
> >Cc: Maxim Levitsky <mlevitsk@redhat.com>
> >Cc: Paolo Bonzini <pbonzini@redhat.com>
> >Cc: kvm@vger.kernel.org
> 
> Should it have the following tag since it fixes a commit introduced in 5.6?
> Cc: stable@vger.kernel.org # v5.6

It definitely warrants a backport to v5.6.  I didn't include a Cc to stable
because I swear I had seen an email fly by that stated an explicit Cc is
unnecessary/unwanted for tip-tree patches, but per a recent statement from
Boris it looks like I'm simply confused[*].  I'll add the Cc in v2.

[*] https://lkml.kernel.org/r/20200417164752.GF7322@zn.tnic

> >Fixes: 21bd3467a58e ("KVM: VMX: Drop initialization of IA32_FEAT_CTL MSR")
> >Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
