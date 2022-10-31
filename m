Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1A1613BF5
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 18:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbiJaRLg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 13:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbiJaRLQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 13:11:16 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D8013CCD
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 10:11:14 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id q1so11213098pgl.11
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 10:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CkUMnMVKvzE+p/CRDEzav12+PQBdsh0ERBJzkQePF9Q=;
        b=cn9lSzDjeAimVb8ApMPS7mI3xEZyntNjDjGnRDQD4aANEi0Z7iFJWxPclfigiXZBvb
         MssYz75PElmDx1Ojh7yPu2ZdwDPS3yDQNegQDM8hwHDUbGLkmwLKmLpoK3ipVkLnxRqY
         MhAWeo64f17EfwGKlN1cCzALx3BnNcB0fod+4AUEnaTnPOPHtLq8JrggLG1oEZAA7hIe
         fmIqX7VPx2qXuYmURYD8HDDR3nal7EohCaHqKIXb3SLJXSuAYgNvp9xHB1ffkjvknsKa
         dUU5e/F8aLsC64bR3iqe1/0f9JcPQFuCjCpV6gtK+qNoJi6Gkfn0Insy7zNDxBHyb4XA
         JTlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CkUMnMVKvzE+p/CRDEzav12+PQBdsh0ERBJzkQePF9Q=;
        b=qw1ShoS3xWEN8vYj6jHCiypr55SP8aSlvH/l6oB/QPl1T+OxiT/kU4S21X1KmswSAo
         RMYTGrm2mvUgCz6CUI0o/OEErR7Yf2AAgZAFqSKPyWAtJP26n67NGmmG09gYnPuYcrnz
         onhabVwiVc8qJjZ5aib50HeymtY2bUB2swr3KR7exn5m7VtCh6KTRImZyCvRznvUGvLf
         +/Jejsfe7mZulaVnOw36HtiL6Gul0FQRLaMRS2LbO5foCYjoY/4TBKDQHR8qjxFgtNwV
         Pp2jTIjl9MLa6sB1FQib/7ivPvRs99gV1NYKksn64g6SjHnN2Sz2A5lNbQYGuRD9tiUw
         uHvQ==
X-Gm-Message-State: ACrzQf1+HsANpWjgzkO/LGHGOOArZcsNuPANBWFhcDOt3x1DBAZYg8s+
        k1Gux8/A6lAx4l4KOfW0pq7GHg==
X-Google-Smtp-Source: AMsMyM4Q1Y7F8REea+pQ9CB2GCAgjQ+aGMVaeNlbucBqRkoWq2c74ZBmf4HZgUC4sTnXXalbvoL/Uw==
X-Received: by 2002:a63:242:0:b0:46f:357f:ac75 with SMTP id 63-20020a630242000000b0046f357fac75mr13694507pgc.575.1667236274122;
        Mon, 31 Oct 2022 10:11:14 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d16-20020a170903231000b00177efb56475sm4749198plh.85.2022.10.31.10.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 10:11:13 -0700 (PDT)
Date:   Mon, 31 Oct 2022 17:11:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Li <ercli@ucdavis.edu>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v5 05/15] KVM: nVMX: Let userspace set nVMX MSR to any
 _host_ supported value
Message-ID: <Y2ABrnRzg729ZZNI@google.com>
References: <20220607213604.3346000-1-seanjc@google.com>
 <20220607213604.3346000-6-seanjc@google.com>
 <20221031163907.w64vyg5twzvv2nho@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031163907.w64vyg5twzvv2nho@linux.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 01, 2022, Yu Zhang wrote:
> Hi Sean & Paolo,
> 
> On Tue, Jun 07, 2022 at 09:35:54PM +0000, Sean Christopherson wrote:
> > Restrict the nVMX MSRs based on KVM's config, not based on the guest's
> > current config.  Using the guest's config to audit the new config
> > prevents userspace from restoring the original config (KVM's config) if
> > at any point in the past the guest's config was restricted in any way.
> 
> May I ask for an example here, to explain why we use the KVM config
> here, instead of the guest's? I mean, the guest's config can be
> adjusted after cpuid updates by vmx_vcpu_after_set_cpuid(). Yet the
> msr settings in vmcs_config.nested might be outdated by then.

vmcs_config.nested never becomes out-of-date, it's read-only after __init (not
currently marked as such, that will be remedied soon).

The auditing performed by KVM is purely to guard against userspace enabling
features that KVM doesn't support.  KVM is not responsible for ensuring that the
vCPU's CPUID model match the VMX MSR model.

An example would be if userspace loaded the VMX MSRs with a default model, and
then enabled features one-by-one.  In practice this doesn't happen because it's
more performant to gather all features and do a single KVM_SET_MSRS, but it's a
legitimate approach that KVM should allow.

> Another question is about the setting of secondary_ctls_high in
> nested_vmx_setup_ctls_msrs().  I saw there's a comment saying:
> 	"Do not include those that depend on CPUID bits, they are
> 	added later by vmx_vcpu_after_set_cpuid.".

That's a stale comment, see the very next commit, 8805875aa473 ("Revert "KVM: nVMX:
Do not expose MPX VMX controls when guest MPX disabled""), as well as the slightly
later commit 9389d5774aca ("Revert "KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL
VM-{Entry,Exit} control"").

> But since cpuid updates can adjust the vmx->nested.msrs.secondary_ctls_high,
> do we really need to clear those flags for secondary_ctls_high in this
> global config?

As above, the comment is stale, KVM should not manipulate the VMX MSRs in response
to guest CPUID changes.  The one exception to this is reserved CR0/CR4 bits.  We
discussed quirking that behavior, but ultimately decided not to because (a) no
userspace actually cares and and (b) KVM would effectively need to make up behavior
if userspace allowed the guest to load CR4 bits via VM-Enter or VM-Exit that are
disallowed by CPUID, e.g. L1 could end up running with a CR4 that is supposed to
be impossible according to CPUID.

> Could we just set 
> 	msrs->secondary_ctls_high = vmcs_conf->cpu_based_2nd_exec_ctrl?

KVM already does that in upstream (with further sanitization).  See commit
bcdf201f8a4d ("KVM: nVMX: Use sanitized allowed-1 bits for VMX control MSRs").

> If yes, code(in nested_vmx_setup_ctls_msrs()) such as
> 	if (enable_ept) {
> 		/* nested EPT: emulate EPT also to L1 */
> 		msrs->secondary_ctls_high |=
> 			SECONDARY_EXEC_ENABLE_EPT;

This can't be completely removed, though unless I'm missing something, it can and
should be shifted to the sanitization code, e.g.

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 8f67a9c4a287..0c41d5808413 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6800,6 +6800,7 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 
        msrs->secondary_ctls_high = vmcs_conf->cpu_based_2nd_exec_ctrl;
        msrs->secondary_ctls_high &=
+               SECONDARY_EXEC_ENABLE_EPT |
                SECONDARY_EXEC_DESC |
                SECONDARY_EXEC_ENABLE_RDTSCP |
                SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
@@ -6820,9 +6821,6 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
                SECONDARY_EXEC_SHADOW_VMCS;
 
        if (enable_ept) {
-               /* nested EPT: emulate EPT also to L1 */
-               msrs->secondary_ctls_high |=
-                       SECONDARY_EXEC_ENABLE_EPT;
                msrs->ept_caps =
                        VMX_EPT_PAGE_WALK_4_BIT |
                        VMX_EPT_PAGE_WALK_5_BIT |


> or 
> 	if (cpu_has_vmx_vmfunc()) {
> 		msrs->secondary_ctls_high |=
> 			SECONDARY_EXEC_ENABLE_VMFUNC;

This one is still required.  KVM never enables VMFUNC for itself, i.e. it won't
be set in KVM's VMCS configuration.

> and other similar ones may also be uncessary.


