Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCF92578789
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 18:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbiGRQiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 12:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235171AbiGRQho (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 12:37:44 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA44A2B192
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 09:37:43 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id o12so11121948pfp.5
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 09:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=jy5bSdPEBHXtGkQFa13jOzIoiz6rP1xz8tt7o64b2cQ=;
        b=NQ8j8x3+91cla9P71GlmIQUO+YiZKXDcdHt+gmAIJSyrqZNEBDY7FGlpbRiJEXD7z5
         5gxU7bKwBE5tqn+nDr7r5g1/e3FGcQBK88Na+AQMAVF1OCFExs6cbMGQ+s1B1+cEohQ1
         NXmfWaxoq5DLxu+ykiAgCzknCkII2GtmkS8hwFmLTSrNhJ6xpdCcFYTLUlndlc4xbUd6
         /jSAY8VxUGhxgMnxWk/J+fAkuiiWrd/yLVKLcUFhsdhg2Inh4cyF9vBNC7+cKjRLYCk2
         tKplmn6UcTnyhBIbul2q9qfUpQE6gCkdm3y6emya2m8sOenvJygT8xsc8zSuNtja/Rw+
         Pomw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=jy5bSdPEBHXtGkQFa13jOzIoiz6rP1xz8tt7o64b2cQ=;
        b=z2wpxfvNAP5xNn1Pl1XgFHJDHa66m+blyIgvbWsM4fBFvfpkdlZSQ4X8ldItDAEeeu
         rLk1QaJxWSS4b1MhcYy+zrki4DAA8R+fpwthj1l+qFefA7KImZrJBWAey0wyQL/u/B+N
         fKrzMICE7M8I8IXQcxARacVkf83DuEMhDkk7eLNJL0bdNnLlZ0mVppOXRBX7t78ioq1R
         BBtxuVrYK3qcRKiXf9eoD6UCwMYDIcMyjCtmhbgqIzTJcPwYoYQFNIhlsCpwhut22BH2
         9lPw3ESZ+3blQZPtY6LX1YPJFdq+hy+8woWTFuoiE9oLGZpiEoY9Q1RWftCiGN3A8KOy
         2rzw==
X-Gm-Message-State: AJIora91GdmFGbBvEhZj6+muafLz02Jh+4f7UeNAppBtBUyN+pvaZRFe
        CrRMWEtgxpbb26xgoglsW482KA==
X-Google-Smtp-Source: AGRyM1tPcVAhq6pbK/P4T7cMXNm+4Qu9OOTYXv56xIwOeYZf0YvWayAr/HgaK8nqSxXHiudex4yu6Q==
X-Received: by 2002:a05:6a00:22d5:b0:52b:af2:9056 with SMTP id f21-20020a056a0022d500b0052b0af29056mr28550724pfj.80.1658162263152;
        Mon, 18 Jul 2022 09:37:43 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id ha15-20020a17090af3cf00b001efa332d365sm9489636pjb.33.2022.07.18.09.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 09:37:42 -0700 (PDT)
Date:   Mon, 18 Jul 2022 16:37:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH v2 02/24] KVM: VMX: Drop bits 31:16 when shoving
 exception error code into VMCS
Message-ID: <YtWMUsjfkv+JcOXe@google.com>
References: <20220715204226.3655170-1-seanjc@google.com>
 <20220715204226.3655170-3-seanjc@google.com>
 <547250051f1578b7ddf60311be46b3eb7990ccc6.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <547250051f1578b7ddf60311be46b3eb7990ccc6.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 18, 2022, Maxim Levitsky wrote:
> On Fri, 2022-07-15 at 20:42 +0000, Sean Christopherson wrote:
> > Deliberately truncate the exception error code when shoving it into the
> > VMCS (VM-Entry field for vmcs01 and vmcs02, VM-Exit field for vmcs12).
> > Intel CPUs are incapable of handling 32-bit error codes and will never
> > generate an error code with bits 31:16, but userspace can provide an
> > arbitrary error code via KVM_SET_VCPU_EVENTS.  Failure to drop the bits
> > on exception injection results in failed VM-Entry, as VMX disallows
> > setting bits 31:16.  Setting the bits on VM-Exit would at best confuse
> > L1, and at worse induce a nested VM-Entry failure, e.g. if L1 decided to
> > reinject the exception back into L2.
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c |  9 ++++++++-
> >  arch/x86/kvm/vmx/vmx.c    | 11 ++++++++++-
> >  2 files changed, 18 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 8c2c81406248..05c34a72c266 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -3822,7 +3822,14 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
> >         u32 intr_info = nr | INTR_INFO_VALID_MASK;
> >  
> >         if (vcpu->arch.exception.has_error_code) {
> > -               vmcs12->vm_exit_intr_error_code = vcpu->arch.exception.error_code;
> > +               /*
> > +                * Intel CPUs will never generate an error code with bits 31:16
> > +                * set, and more importantly VMX disallows setting bits 31:16
> > +                * in the injected error code for VM-Entry.  Drop the bits to
> > +                * mimic hardware and avoid inducing failure on nested VM-Entry
> > +                * if L1 chooses to inject the exception back to L2.
> 
> Very small nitpick:
> I think I would still prefer to have a mention that AMD CPUs can have error code > 16 bit,
> The above comment kind of implies this, but it would be a bit more clear, but I don't
> have a strong preference on this.

Agreed, I'll reword this to make it abundantly clear that setting bits 31:16 is
architecturally allowed and done by AMD, and that this is purely an Intel oddity.

> > +                */
> > +               vmcs12->vm_exit_intr_error_code = (u16)vcpu->arch.exception.error_code;
> >                 intr_info |= INTR_INFO_DELIVER_CODE_MASK;
> >         }
> >  
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index b0cc911a8f6f..d2b3d30d6afb 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -1621,7 +1621,16 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu)
> >         kvm_deliver_exception_payload(vcpu);
> >  
> >         if (has_error_code) {
> > -               vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, error_code);
> > +               /*
> > +                * Despite the error code being architecturally defined as 32
> > +                * bits, and the VMCS field being 32 bits, Intel CPUs and thus
> > +                * VMX don't actually supporting setting bits 31:16.  Hardware
> > +                * will (should) never provide a bogus error code, but KVM's
> > +                * ABI lets userspace shove in arbitrary 32-bit values.  Drop

I'll update this to mention AMD CPUs as well.

> > +                * the upper bits to avoid VM-Fail, losing information that
> > +                * does't really exist is preferable to killing the VM.
> > +                */
> > +               vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, (u16)error_code);
> >                 intr_info |= INTR_INFO_DELIVER_CODE_MASK;
> >         }
> >  
> 
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Best regards,
>  Maxim Levitsky
> 
> 
