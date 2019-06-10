Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6333BB7F
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2019 20:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388309AbfFJSBE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jun 2019 14:01:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39778 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388052AbfFJSBE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jun 2019 14:01:04 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1CF3E3DBC5;
        Mon, 10 Jun 2019 18:01:04 +0000 (UTC)
Received: from flask (unknown [10.43.2.83])
        by smtp.corp.redhat.com (Postfix) with SMTP id 3E3275C231;
        Mon, 10 Jun 2019 18:01:02 +0000 (UTC)
Received: by flask (sSMTP sendmail emulation); Mon, 10 Jun 2019 20:01:01 +0200
Date:   Mon, 10 Jun 2019 20:01:01 +0200
From:   Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2] KVM: nVMX: Stash L1's CR3 in vmcs01.GUEST_CR3 on
 nested entry w/o EPT
Message-ID: <20190610180101.GB6604@flask>
References: <20190607185534.24368-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190607185534.24368-1-sean.j.christopherson@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Mon, 10 Jun 2019 18:01:04 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

2019-06-07 11:55-0700, Sean Christopherson:
> KVM does not have 100% coverage of VMX consistency checks, i.e. some
> checks that cause VM-Fail may only be detected by hardware during a
> nested VM-Entry.  In such a case, KVM must restore L1's state to the
> pre-VM-Enter state as L2's state has already been loaded into KVM's
> software model.
> 
> L1's CR3 and PDPTRs in particular are loaded from vmcs01.GUEST_*.  But
> when EPT is disabled, the associated fields hold KVM's shadow values,
> not L1's "real" values.  Fortunately, when EPT is disabled the PDPTRs
> come from memory, i.e. are not cached in the VMCS.  Which leaves CR3
> as the sole anomaly.
> 
> A previously applied workaround to handle CR3 was to force nested early
> checks if EPT is disabled:
> 
>   commit 2b27924bb1d48 ("KVM: nVMX: always use early vmcs check when EPT
>                          is disabled")
> 
> Forcing nested early checks is undesirable as doing so adds hundreds of
> cycles to every nested VM-Entry.  Rather than take this performance hit,
> handle CR3 by overwriting vmcs01.GUEST_CR3 with L1's CR3 during nested
> VM-Entry when EPT is disabled *and* nested early checks are disabled.
> By stuffing vmcs01.GUEST_CR3, nested_vmx_restore_host_state() will
> naturally restore the correct vcpu->arch.cr3 from vmcs01.GUEST_CR3.
> 
> These shenanigans work because nested_vmx_restore_host_state() does a
> full kvm_mmu_reset_context(), i.e. unloads the current MMU, which
> guarantees vmcs01.GUEST_CR3 will be rewritten with a new shadow CR3
> prior to re-entering L1.
> 
> vcpu->arch.root_mmu.root_hpa is set to INVALID_PAGE via:
> 
>     nested_vmx_restore_host_state() ->
>         kvm_mmu_reset_context() ->
>             kvm_mmu_unload() ->
>                 kvm_mmu_free_roots()
> 
> kvm_mmu_unload() has WARN_ON(root_hpa != INVALID_PAGE), i.e. we can bank
> on 'root_hpa == INVALID_PAGE' unless the implementation of
> kvm_mmu_reset_context() is changed.
> 
> On the way into L1, VMCS.GUEST_CR3 is guaranteed to be written (on a
> successful entry) via:
> 
>     vcpu_enter_guest() ->
>         kvm_mmu_reload() ->
>             kvm_mmu_load() ->
>                 kvm_mmu_load_cr3() ->
>                     vmx_set_cr3()
> 
> Stuff vmcs01.GUEST_CR3 if and only if nested early checks are disabled
> as a "late" VM-Fail should never happen win that case (KVM WARNs), and
> the conditional write avoids the need to restore the correct GUEST_CR3
> when nested_vmx_check_vmentry_hw() fails.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---

Surprisingly robust, well done.

Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>
