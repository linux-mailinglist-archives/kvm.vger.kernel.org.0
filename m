Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B470838E64D
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 14:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbhEXMKh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 08:10:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20826 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232785AbhEXMKf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 08:10:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621858147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jfVfjsdTY3heP1QKS11wD9j4Ahl6hvZeJZpiwdwAoEU=;
        b=Pe30Qep/xeoOrSedVuO2zfYjO5nJLxEKE8Ho3SkErTGDmmOzmWBrfGM06qPlXOaISrDnWH
        7CGxRmAEMsatbX+vSLmJva2xbSM26TVi721MDMk7a+gov8m9cBglpEDLfgFUCoGZc1zu4v
        5bYQorF/+kba5qX9XQyAhtYBL4KAxY0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-Bv1ckKJLM8quvdAo_noqaA-1; Mon, 24 May 2021 08:09:03 -0400
X-MC-Unique: Bv1ckKJLM8quvdAo_noqaA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5ED5A107ACE3;
        Mon, 24 May 2021 12:09:02 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D56A1ACC7;
        Mon, 24 May 2021 12:08:59 +0000 (UTC)
Message-ID: <ea9a392d018ced61478482763f7a59472110104c.camel@redhat.com>
Subject: Re: [PATCH v2 0/7] KVM: nVMX: Fixes for nested state migration when
 eVMCS is in use
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Date:   Mon, 24 May 2021 15:08:57 +0300
In-Reply-To: <20210517135054.1914802-1-vkuznets@redhat.com>
References: <20210517135054.1914802-1-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-05-17 at 15:50 +0200, Vitaly Kuznetsov wrote:
> Changes since v1 (Sean):
> - Drop now-unneeded curly braces in nested_sync_vmcs12_to_shadow().
> - Pass 'evmcs->hv_clean_fields' instead of 'bool from_vmentry' to
>   copy_enlightened_to_vmcs12().
> 
> Commit f5c7e8425f18 ("KVM: nVMX: Always make an attempt to map eVMCS after
> migration") fixed the most obvious reason why Hyper-V on KVM (e.g. Win10
>  + WSL2) was crashing immediately after migration. It was also reported
> that we have more issues to fix as, while the failure rate was lowered 
> signifincatly, it was still possible to observe crashes after several
> dozens of migration. Turns out, the issue arises when we manage to issue
> KVM_GET_NESTED_STATE right after L2->L2 VMEXIT but before L1 gets a chance
> to run. This state is tracked with 'need_vmcs12_to_shadow_sync' flag but
> the flag itself is not part of saved nested state. A few other less 
> significant issues are fixed along the way.
> 
> While there's no proof this series fixes all eVMCS related problems,
> Win10+WSL2 was able to survive 3333 (thanks, Max!) migrations without
> crashing in testing.
> 
> Patches are based on the current kvm/next tree.
> 
> Vitaly Kuznetsov (7):
>   KVM: nVMX: Introduce nested_evmcs_is_used()
>   KVM: nVMX: Release enlightened VMCS on VMCLEAR
>   KVM: nVMX: Ignore 'hv_clean_fields' data when eVMCS data is copied in
>     vmx_get_nested_state()
>   KVM: nVMX: Force enlightened VMCS sync from nested_vmx_failValid()
>   KVM: nVMX: Reset eVMCS clean fields data from prepare_vmcs02()
>   KVM: nVMX: Request to sync eVMCS from VMCS12 after migration
>   KVM: selftests: evmcs_test: Test that KVM_STATE_NESTED_EVMCS is never
>     lost
> 
>  arch/x86/kvm/vmx/nested.c                     | 110 ++++++++++++------
>  .../testing/selftests/kvm/x86_64/evmcs_test.c |  64 +++++-----
>  2 files changed, 115 insertions(+), 59 deletions(-)
> 

Hi Vitaly!

In addition to the review of this patch series, I would like
to share an idea on how to avoid the hack of mapping the evmcs
in nested_vmx_vmexit, because I think I found a possible generic
solution to this and similar issues:

The solution is to always set nested_run_pending after 
nested migration (which means that we won't really
need to migrate this flag anymore).

I was thinking a lot about it and I think that there is no downside to this,
other than sometimes a one extra vmexit after migration.

Otherwise there is always a risk of the following scenario:

  1. We migrate with nested_run_pending=0 (but don't restore all the state
  yet, like that HV_X64_MSR_VP_ASSIST_PAGE msr,
  or just the guest memory map is not up to date, guest is in smm or something
  like that)

  2. Userspace calls some ioctl that causes a nested vmexit

  This can happen today if the userspace calls 
  kvm_arch_vcpu_ioctl_get_mpstate -> kvm_apic_accept_events -> kvm_check_nested_events

  3. Userspace finally sets correct guest's msrs, correct guest memory map and only
  then calls KVM_RUN

This means that at (2) we can't map and write the evmcs/vmcs12/vmcb12 even
if KVM_REQ_GET_NESTED_STATE_PAGES is pending,
but we have to do so to complete the nested vmexit.

To some extent, the entry to the nested mode after a migration is only complete
when we process the KVM_REQ_GET_NESTED_STATE_PAGES, so we shoudn't interrupt it.

This will allow us to avoid dealing with KVM_REQ_GET_NESTED_STATE_PAGES on
nested vmexit path at all. 

Best regards,
	Maxim Levitsky


