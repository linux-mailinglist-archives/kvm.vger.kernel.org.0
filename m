Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFDA54CC269
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 17:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbiCCQQj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 11:16:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbiCCQQi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 11:16:38 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE603198D37
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 08:15:52 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id c16-20020a17090aa61000b001befad2bfaaso4810800pjq.1
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 08:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mv0smpu4JE27qdx15rrPIo6Ihz2dECF550z94CZa+WM=;
        b=btRsR4FSKG8rI9eC9kem6lV2NI6CQTfpc8yRqxPNbKbl8F1TW1n2TbtB90/tISBXeK
         vgx+9Y/+5TvWk5QhQWMICDQ5B2CrFuGefPOS+JaUQFg9uCjkdhtwtPkrmVlDN/F9X3FF
         RIhHBD3TndsHwWWF49KXjkcwkqfn6an942+P4k6j22ALMXWeTHfjis4MH0iHDDNg8TZt
         3mHFA2jcmWlwVMcCj1uAvKc6J9KQFrWrjiJr0Tw5bdrxYbr5PyXG27x+U4D5YqYf4LN4
         qyT/+DNdYxLC5w0Q17bERBurXJEb3yixI5A1zl5TrzTnnjgHDBkWuV9RjjkB1BbTpiQM
         tfzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mv0smpu4JE27qdx15rrPIo6Ihz2dECF550z94CZa+WM=;
        b=yF9deDiTD8GK5MP84Jyk/hMzZmQP3wW9ewEez6iMHsQEKH93H92usUAwBfEo4UrIRi
         yx9FwxQ/OTpkRC7ZVMR0hRBHCFkprYHnCXZoHC2CocHmPYXOv3Ojxs1U0ZfdMoImXplN
         wRiApOdRZ0M/aE7ndGNjCgdCUa87QRcq6kuM+jyTmuwIW95OeJXEgJu92K91JN+9BY6D
         jagYAOR9OVClMSGzc3AjP7bA7uJ7bqcH9T3oJ1tqOUevgQpA/2MQlFBEJpVrQj3fhKKb
         8CoG32zHIY+3i4tRuqhly8EEJxPA207MhnHHGVgOShjPajyHnNeRsrBbBH4Olr1g4h4a
         felQ==
X-Gm-Message-State: AOAM530f6u4qyIuvQ0T1Z+iom/2Yb30mx458DGa1pQY9WQOpRIUDcOl9
        WfvFJzd+Mbe2UzMKtpG3puxiBQ==
X-Google-Smtp-Source: ABdhPJwuOa7e0ey7hsgFW9q3MDQvmDxNGdKSfl0Bqn91oHZZ7+3KFFLwXGuYXgZsIN+mCv4YUN8SrA==
X-Received: by 2002:a17:90b:3a81:b0:1bf:8b5:f924 with SMTP id om1-20020a17090b3a8100b001bf08b5f924mr6112303pjb.153.1646324151982;
        Thu, 03 Mar 2022 08:15:51 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z5-20020a056a00240500b004e15d39f15fsm3112403pfh.83.2022.03.03.08.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 08:15:51 -0800 (PST)
Date:   Thu, 3 Mar 2022 16:15:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>
Subject: Re: [PATCH v4 1/8] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
Message-ID: <YiDps0lOKITPn4gv@google.com>
References: <20220301060351.442881-1-oupton@google.com>
 <20220301060351.442881-2-oupton@google.com>
 <4e678b4f-4093-fa67-2c4e-e25ec2ced6d5@redhat.com>
 <Yh5pYhDQbzWQOdIx@google.com>
 <b839fa78-c8ec-7996-dba7-685ea48ca33d@redhat.com>
 <Yh/Y3E4NTfSa4I/g@google.com>
 <4d4606f4-dbc9-d3a4-929e-0ea07182054c@redhat.com>
 <Yh/nlOXzIhaMLzdk@google.com>
 <YiAdU+pA/RNeyjRi@google.com>
 <78abcc19-0a79-4f8b-2eaf-c99b96efea42@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78abcc19-0a79-4f8b-2eaf-c99b96efea42@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 03, 2022, Paolo Bonzini wrote:
> On 3/3/22 02:43, Sean Christopherson wrote:
> > > Maybe I can redirect you to a test case to highlight a possible
> > > regression in KVM, as seen by userspace;-)
> > Regressions aside, VMCS controls are not tied to CPUID, KVM should not be mucking
> > with unrelated things.  The original hack was to fix a userspace bug and should
> > never have been mreged.
> 
> Note that it dates back to:
> 
>     commit 5f76f6f5ff96587af5acd5930f7d9fea81e0d1a8
>     Author: Liran Alon <liran.alon@oracle.com>
>     Date:   Fri Sep 14 03:25:52 2018 +0300
> 
>     KVM: nVMX: Do not expose MPX VMX controls when guest MPX disabled
>     Before this commit, KVM exposes MPX VMX controls to L1 guest only based
>     on if KVM and host processor supports MPX virtualization.
>     However, these controls should be exposed to guest only in case guest
>     vCPU supports MPX.
> 
> It's not to fix a userspace bug, it's to support userspace that doesn't
> know about using KVM_SET_MSR for VMX features---which is okay since unlike
> KVM_SET_CPUID2 it's not a mandatory call.

I disagree, IMO failure to properly configure the vCPU model is a userspace bug.
Maybe it was a userspace bug induced by a haphazard and/or poorly documented KVM
ABI, but it's still a userspace bug.  One could argue that KVM should disable/clear
VMX features if userspace clears a related CPUID feature, but _setting_ a VMX
feature based on CPUID is architecturally wrong.  Even if we consider one or both
cases to be desirable behavior in terms of creating a consistent vCPU model, forcing
a consistent vCPU model for this one case goes against every other ioctl in KVM's
ABI.

If we consider it KVM's responsibility to propagate CPUID state to VMX MSRs, then
KVM has a bunch of "bugs".

  X86_FEATURE_LM => VM_EXIT_HOST_ADDR_SPACE_SIZE, VM_ENTRY_IA32E_MODE, VMX_MISC_SAVE_EFER_LMA

  X86_FEATURE_TSC => CPU_BASED_RDTSC_EXITING, CPU_BASED_USE_TSC_OFFSETTING,
                     SECONDARY_EXEC_TSC_SCALING

  X86_FEATURE_INVPCID_SINGLE => SECONDARY_EXEC_ENABLE_INVPCID

  X86_FEATURE_MWAIT => CPU_BASED_MONITOR_EXITING, CPU_BASED_MWAIT_EXITING

  X86_FEATURE_INTEL_PT => SECONDARY_EXEC_PT_CONCEAL_VMX, SECONDARY_EXEC_PT_USE_GPA,
                          VM_EXIT_CLEAR_IA32_RTIT_CTL, VM_ENTRY_LOAD_IA32_RTIT_CTL

  X86_FEATURE_XSAVES => SECONDARY_EXEC_XSAVES
