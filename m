Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE17855E035
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344059AbiF1JIQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 05:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343954AbiF1JIO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 05:08:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED4981038
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 02:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656407293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BXAG5b0n3utC+xKu/ur4SDi+QqaWJ5b7MPRWdkNFMEA=;
        b=KTgLWEc41nUPWAIyXKMVJSLU34M8BofDey9USaHtsqQQ1WzT9SfQXPZz3/xL/Yitg3m8NA
        K9bg3jrvLOPFxqF6Whd0GlefjytMF0YEF+k7pVKHFVCwVGk+pO+jCpGAtgf4GaDMK11R1f
        ZDGO8a6dFYySxQvo0SDp/MdPu8Q/yWA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-FYALN4vtN4yD3bN7U9-Tsw-1; Tue, 28 Jun 2022 05:08:09 -0400
X-MC-Unique: FYALN4vtN4yD3bN7U9-Tsw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4474F2999B40;
        Tue, 28 Jun 2022 09:08:09 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD37E404E4C8;
        Tue, 28 Jun 2022 09:08:06 +0000 (UTC)
Message-ID: <0739589fe08c75c563e10cb41388640c7e050a52.camel@redhat.com>
Subject: Re: [PATCH 00/14] KVM: nVMX: Use vmcs_config for setting up nested
 VMX MSRs
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 28 Jun 2022 12:08:05 +0300
In-Reply-To: <20220627160440.31857-1-vkuznets@redhat.com>
References: <20220627160440.31857-1-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-27 at 18:04 +0200, Vitaly Kuznetsov wrote:
> Changes since RFC:
> - "KVM: VMX: Extend VMX controls macro shenanigans" PATCH added and the
>   infrastructure is later used in other patches [Sean] PATCHes 1-3 added
>   to support the change.
> - "KVM: VMX: Clear controls obsoleted by EPT at runtime, not setup" PATCH
>   added [Sean].
> - Commit messages added.
> 
> vmcs_config is a sanitized version of host VMX MSRs where some controls are
> filtered out (e.g. when Enlightened VMCS is enabled, some know bugs are 
> discovered, some inconsistencies in controls are detected,...) but
> nested_vmx_setup_ctls_msrs() uses raw host MSRs instead. This may end up
> in exposing undesired controls to L1. Switch to using vmcs_config instead.
> 
> Sean Christopherson (1):
>   KVM: VMX: Clear controls obsoleted by EPT at runtime, not setup
> 
> Vitaly Kuznetsov (13):
>   KVM: VMX: Check VM_ENTRY_IA32E_MODE in setup_vmcs_config()
>   KVM: VMX: Check CPU_BASED_{INTR,NMI}_WINDOW_EXITING in
>     setup_vmcs_config()
>   KVM: VMX: Tweak the special handling of SECONDARY_EXEC_ENCLS_EXITING
>     in setup_vmcs_config()
>   KVM: VMX: Extend VMX controls macro shenanigans
>   KVM: VMX: Move CPU_BASED_CR8_{LOAD,STORE}_EXITING filtering out of
>     setup_vmcs_config()
>   KVM: VMX: Add missing VMEXIT controls to vmcs_config
>   KVM: VMX: Add missing VMENTRY controls to vmcs_config
>   KVM: VMX: Add missing CPU based VM execution controls to vmcs_config
>   KVM: nVMX: Use sanitized allowed-1 bits for VMX control MSRs
>   KVM: VMX: Store required-1 VMX controls in vmcs_config
>   KVM: nVMX: Use sanitized required-1 bits for VMX control MSRs
>   KVM: VMX: Cache MSR_IA32_VMX_MISC in vmcs_config
>   KVM: nVMX: Use cached host MSR_IA32_VMX_MISC value for setting up
>     nested MSR
> 
>  arch/x86/kvm/vmx/capabilities.h |  16 +--
>  arch/x86/kvm/vmx/nested.c       |  37 +++---
>  arch/x86/kvm/vmx/nested.h       |   2 +-
>  arch/x86/kvm/vmx/vmx.c          | 198 ++++++++++++++------------------
>  arch/x86/kvm/vmx/vmx.h          | 118 +++++++++++++++++++
>  5 files changed, 229 insertions(+), 142 deletions(-)
> 
Sorry that I was a bit out of loop on this, so before I review it,
does this patch series solve the eVMCS issue we had alone,
or we still need the eVMCS version patch series as well?

Best regards,
	Maxim Levitsky

