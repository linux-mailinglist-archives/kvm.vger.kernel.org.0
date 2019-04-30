Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 177B5FFD1
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 20:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbfD3Sma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 14:42:30 -0400
Received: from mga18.intel.com ([134.134.136.126]:51516 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbfD3Sma (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 14:42:30 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Apr 2019 11:42:29 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by orsmga002.jf.intel.com with ESMTP; 30 Apr 2019 11:42:29 -0700
Date:   Tue, 30 Apr 2019 11:42:29 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH] x86/kvm/mmu: reset MMU context when 32-bit guest
 switches PAE
Message-ID: <20190430184229.GE32170@linux.intel.com>
References: <20190430173326.1956-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430173326.1956-1-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 30, 2019 at 07:33:26PM +0200, Vitaly Kuznetsov wrote:
> Commit 47c42e6b4192 ("KVM: x86: fix handling of role.cr4_pae and rename it
> to 'gpte_size'") introduced a regression: 32-bit PAE guests stopped

"gpte_is_8_bytes" is really confusing in this case. :-(  Unfortunately I
can't think I can't think of a better name that isn't ridiculously verbose.

> working. The issue appears to be: when guest switches (enables) PAE we need
> to re-initialize MMU context (set context->root_level, do
> reset_rsvds_bits_mask(), ...) but init_kvm_tdp_mmu() doesn't do that
> because we threw away is_pae(vcpu) flag from mmu role. Restore it to
> kvm_mmu_extended_role (as we now don't need it in base role) to fix
> the issue.

The change makes sense, but I'm amazed that there's a kernel that can
actually trigger the bug.  The extended role tracks CR0.PG, so I'm pretty
sure hitting this bug requires toggling CR4.PAE *while paging is enabled*.
Which is legal, but crazy.  E.g. my 32-bit Linux VM runs fine with and
without PAE enabled.

> Fixes: 47c42e6b4192 ("KVM: x86: fix handling of role.cr4_pae and rename it to 'gpte_size'")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

> ---
> - RFC: it was proven multiple times that mmu code is more complex than it
>   appears (at least to me) :-)

LOL, maybe you're just more optimistic than most people.  Every time I
look at the code I say something along the lines of "holy $&*#".

> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/mmu.c              | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a9d03af34030..c79abe7ca093 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -295,6 +295,7 @@ union kvm_mmu_extended_role {
>  		unsigned int valid:1;
>  		unsigned int execonly:1;
>  		unsigned int cr0_pg:1;
> +		unsigned int cr4_pae:1;
>  		unsigned int cr4_pse:1;
>  		unsigned int cr4_pke:1;
>  		unsigned int cr4_smap:1;
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index e10962dfc203..d9c7b45d231f 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -4781,6 +4781,7 @@ static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu)
>  	union kvm_mmu_extended_role ext = {0};
>  
>  	ext.cr0_pg = !!is_paging(vcpu);
> +	ext.cr4_pae = !!is_pae(vcpu);

This got me thinking, I wonder if we can/should leave the CR4 bits clear
if !is_paging().  Technically I think we're unnecessarily purging the MMU
when the guest is toggling CR4 bits with CR0.PG==0.  And I think we can
also git rid of the oddball nx flag in struct kvm_mmu.  I'll play around
with the code and hopefully send a patch or two.

>  	ext.cr4_smep = !!kvm_read_cr4_bits(vcpu, X86_CR4_SMEP);
>  	ext.cr4_smap = !!kvm_read_cr4_bits(vcpu, X86_CR4_SMAP);
>  	ext.cr4_pse = !!is_pse(vcpu);
> -- 
> 2.20.1
> 
