Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDBE9578316
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 15:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235234AbiGRNEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 09:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234827AbiGRNEo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 09:04:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F2C1F101C7
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 06:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658149477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pq697dkSbkJHWHiUNa883UT9b9ZvrgQ/5h9EpUiAWMw=;
        b=geaZ/b9ivcOuZPaZAQ2wjmBOI0O/3AUnmhzhJmkTuZ8N/f7a2OnZwZOH+cIPl/ft608BbF
        lMgPvqoUHgHFx+r3gLs2njmU/jcYhyTN2QJaJpNu5l+Pr5dF0Xj81ullBmPUNkOMuFCijl
        DH+GCeQwwcXy7rgIXzLGUhpUeEsukyc=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-6GRbyqmeOPCnR95vZ_4EUw-1; Mon, 18 Jul 2022 09:04:36 -0400
X-MC-Unique: 6GRbyqmeOPCnR95vZ_4EUw-1
Received: by mail-qk1-f199.google.com with SMTP id l189-20020a37bbc6000000b006af2596c5e8so9387538qkf.14
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 06:04:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=pq697dkSbkJHWHiUNa883UT9b9ZvrgQ/5h9EpUiAWMw=;
        b=jk42HJ9u2YCssDwjXqMTbNtu5wgfXd1dVmlReoo2I1LLzD00mc9TklN4GGiENa5PPZ
         99k+WkF6levYkcXbcBxwb+P0xQPmE1g0nkJEtogNWpB9ZI1m0rZo7QvKfapw1mI1PfB2
         yYsozsycR0Igw2zBCds/0MA8boJhvVPFOObmvxhCvxhscoHa23uucXIGywaL0dmd38SW
         jzQIBXFP/II90HtqQjo5EfcWeHfQWfg+05Vb+fu8v1G4yX5tNMr8f+gY/j7/FwuY7ef6
         jiKXZzIZ6snIJ/U1NsYzngLTiJhdudMlNEcDnqscmUIIhBJQ1dE5BvaLzW3t6NAy0Mfo
         njGw==
X-Gm-Message-State: AJIora+/YXlZrB/NPdqywTx8cX1vk77GMHaS5kOQPZ8D2WF8JYbEb7rr
        GJ8uvY6TnU7yNZMSbb8EmpKqqkBiFRZtg+qx4C0oXRWkdzDPjZTZtyS4YltJv8pXASR3E8A14Gx
        3s5NIPX6bBcII
X-Received: by 2002:a05:620a:4249:b0:6b4:7631:3c82 with SMTP id w9-20020a05620a424900b006b476313c82mr17391620qko.195.1658149476220;
        Mon, 18 Jul 2022 06:04:36 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s9BqAAqNaO0yArOz/6XucY9ror4zH+9IGWV8HGbbomJFTJinXrHG0ZLzyNVTqixDTUyJ28wg==
X-Received: by 2002:a05:620a:4249:b0:6b4:7631:3c82 with SMTP id w9-20020a05620a424900b006b476313c82mr17391596qko.195.1658149475935;
        Mon, 18 Jul 2022 06:04:35 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id f13-20020a05620a408d00b006b5df4d2c81sm6162993qko.94.2022.07.18.06.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 06:04:35 -0700 (PDT)
Message-ID: <ba44764be5eb8b2282e7b9aa2b493b583b8e4bd5.camel@redhat.com>
Subject: Re: [PATCH v2 17/24] KVM: nVMX: Add a helper to identify
 low-priority #DB traps
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Mon, 18 Jul 2022 16:04:31 +0300
In-Reply-To: <20220715204226.3655170-18-seanjc@google.com>
References: <20220715204226.3655170-1-seanjc@google.com>
         <20220715204226.3655170-18-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-07-15 at 20:42 +0000, Sean Christopherson wrote:
> Add a helper to identify "low"-priority #DB traps, i.e. trap-like #DBs
> that aren't TSS T flag #DBs, and tweak the related code to operate on any
> queued exception.  A future commit will separate exceptions that are
> intercepted by L1, i.e. cause nested VM-Exit, from those that do NOT
> trigger nested VM-Exit.  I.e. there will be multiple exception structs
> and multiple invocations of the helpers.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index a0a4eddce445..c3fc8b484785 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3859,14 +3859,24 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
>   * from the emulator (because such #DBs are fault-like and thus don't trigger
>   * actions that fire on instruction retire).
>   */
> -static inline unsigned long vmx_get_pending_dbg_trap(struct kvm_vcpu *vcpu)
> +static unsigned long vmx_get_pending_dbg_trap(struct kvm_queued_exception *ex)
>  {
> -       if (!vcpu->arch.exception.pending ||
> -           vcpu->arch.exception.vector != DB_VECTOR)
> +       if (!ex->pending || ex->vector != DB_VECTOR)
>                 return 0;
>  
>         /* General Detect #DBs are always fault-like. */
> -       return vcpu->arch.exception.payload & ~DR6_BD;
> +       return ex->payload & ~DR6_BD;
> +}
> +
> +/*
> + * Returns true if there's a pending #DB exception that is lower priority than
> + * a pending Monitor Trap Flag VM-Exit.  TSS T-flag #DBs are not emulated by
> + * KVM, but could theoretically be injected by userspace.  Note, this code is
> + * imperfect, see above.
> + */
> +static bool vmx_is_low_priority_db_trap(struct kvm_queued_exception *ex)
> +{
> +       return vmx_get_pending_dbg_trap(ex) & ~DR6_BT;
>  }
>  
>  /*
> @@ -3878,8 +3888,9 @@ static inline unsigned long vmx_get_pending_dbg_trap(struct kvm_vcpu *vcpu)
>   */
>  static void nested_vmx_update_pending_dbg(struct kvm_vcpu *vcpu)
>  {
> -       unsigned long pending_dbg = vmx_get_pending_dbg_trap(vcpu);
> +       unsigned long pending_dbg;
>  
> +       pending_dbg = vmx_get_pending_dbg_trap(&vcpu->arch.exception);
>         if (pending_dbg)
>                 vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS, pending_dbg);
>  }
> @@ -3949,7 +3960,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>          * prioritize SMI over MTF and trap-like #DBs.
>          */
>         if (vcpu->arch.exception.pending &&
> -           !(vmx_get_pending_dbg_trap(vcpu) & ~DR6_BT)) {
> +           !vmx_is_low_priority_db_trap(&vcpu->arch.exception)) {
>                 if (block_nested_exceptions)
>                         return -EBUSY;
>                 if (!nested_vmx_check_exception(vcpu, &exit_qual))


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

