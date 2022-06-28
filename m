Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F25EE55D36A
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344870AbiF1KIv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 06:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245666AbiF1KIs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 06:08:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7D7C72F38D
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 03:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656410926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u+o55GKWidSxIU5eLLFrD8Z2HcDtDkzMZqRenvhiXG4=;
        b=eMHCycrk+sHT6y/DT6uayX4Y8xui+XKpbN2F2OJtud8jI4PiOb8fo46GuXtEvL3DtOmrFF
        AYcFRSzcXufoMpDE2GtDvgIALsw4l1k/plzcIs1OqA4Hw4FabtnsJWUpjvPzp2i1HTJZh9
        Lq/jXf6rzAHyUvxSZluvUwaVc8w6VkI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-i4EVvDy-P9KgTow_syPA8Q-1; Tue, 28 Jun 2022 06:08:43 -0400
X-MC-Unique: i4EVvDy-P9KgTow_syPA8Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BBFCB1C00AC6;
        Tue, 28 Jun 2022 10:08:42 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 690BE1121314;
        Tue, 28 Jun 2022 10:08:40 +0000 (UTC)
Message-ID: <b2e294055f792ec77c907ea27f8a9b21e3b3477c.camel@redhat.com>
Subject: Re: [PATCH 00/14] KVM: nVMX: Use vmcs_config for setting up nested
 VMX MSRs
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Tue, 28 Jun 2022 13:08:39 +0300
In-Reply-To: <87h745umst.fsf@redhat.com>
References: <20220627160440.31857-1-vkuznets@redhat.com>
         <0739589fe08c75c563e10cb41388640c7e050a52.camel@redhat.com>
         <87h745umst.fsf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-28 at 12:04 +0200, Vitaly Kuznetsov wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> 
> > On Mon, 2022-06-27 at 18:04 +0200, Vitaly Kuznetsov wrote:
> > > Changes since RFC:
> > > - "KVM: VMX: Extend VMX controls macro shenanigans" PATCH added and the
> > >   infrastructure is later used in other patches [Sean] PATCHes 1-3 added
> > >   to support the change.
> > > - "KVM: VMX: Clear controls obsoleted by EPT at runtime, not setup" PATCH
> > >   added [Sean].
> > > - Commit messages added.
> > > 
> > > vmcs_config is a sanitized version of host VMX MSRs where some controls are
> > > filtered out (e.g. when Enlightened VMCS is enabled, some know bugs are 
> > > discovered, some inconsistencies in controls are detected,...) but
> > > nested_vmx_setup_ctls_msrs() uses raw host MSRs instead. This may end up
> > > in exposing undesired controls to L1. Switch to using vmcs_config instead.
> > > 
> > > Sean Christopherson (1):
> > >   KVM: VMX: Clear controls obsoleted by EPT at runtime, not setup
> > > 
> > > Vitaly Kuznetsov (13):
> > >   KVM: VMX: Check VM_ENTRY_IA32E_MODE in setup_vmcs_config()
> > >   KVM: VMX: Check CPU_BASED_{INTR,NMI}_WINDOW_EXITING in
> > >     setup_vmcs_config()
> > >   KVM: VMX: Tweak the special handling of SECONDARY_EXEC_ENCLS_EXITING
> > >     in setup_vmcs_config()
> > >   KVM: VMX: Extend VMX controls macro shenanigans
> > >   KVM: VMX: Move CPU_BASED_CR8_{LOAD,STORE}_EXITING filtering out of
> > >     setup_vmcs_config()
> > >   KVM: VMX: Add missing VMEXIT controls to vmcs_config
> > >   KVM: VMX: Add missing VMENTRY controls to vmcs_config
> > >   KVM: VMX: Add missing CPU based VM execution controls to vmcs_config
> > >   KVM: nVMX: Use sanitized allowed-1 bits for VMX control MSRs
> > >   KVM: VMX: Store required-1 VMX controls in vmcs_config
> > >   KVM: nVMX: Use sanitized required-1 bits for VMX control MSRs
> > >   KVM: VMX: Cache MSR_IA32_VMX_MISC in vmcs_config
> > >   KVM: nVMX: Use cached host MSR_IA32_VMX_MISC value for setting up
> > >     nested MSR
> > > 
> > >  arch/x86/kvm/vmx/capabilities.h |  16 +--
> > >  arch/x86/kvm/vmx/nested.c       |  37 +++---
> > >  arch/x86/kvm/vmx/nested.h       |   2 +-
> > >  arch/x86/kvm/vmx/vmx.c          | 198 ++++++++++++++------------------
> > >  arch/x86/kvm/vmx/vmx.h          | 118 +++++++++++++++++++
> > >  5 files changed, 229 insertions(+), 142 deletions(-)
> > > 
> > Sorry that I was a bit out of loop on this, so before I review it,
> > does this patch series solve the eVMCS issue we had alone,
> > or we still need the eVMCS version patch series as well?
> 
> "[PATCH 00/11] KVM: VMX: Support TscScaling and EnclsExitingBitmap whith
> eVMCS" adds new features, namely TSC scaling for both KVM-on-Hyper-V and
> Hyper-V-on-KVM. This series doesn't add any features but avoids the
> problem reported by Anirudh by properly filtering values in L1 VMX MSRs.
> 
> TL;DR: Both series are needed.
> 

Roger that!

Best regards,
	Maxim Levitsky

