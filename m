Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2193642DFBC
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 18:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhJNQ4m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 12:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbhJNQ4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 12:56:40 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B00CC061570
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 09:54:35 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id q5so6076482pgr.7
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 09:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DxjJWbKincMlvSXC/FY3Ala2ok6WlFlcTqLiBRO6M/w=;
        b=TmOfNDnpZ594weM/2UNFzn+MY2mLVQtNlWPXx1nvRjNLRuk3e4qJSZ+hf870+QB2jR
         agy34dupqT+XlQu0aOc5FFWJkU7NrAo35nTYXfcP1hVKEEJPOCK6m9qlcrztza4Rdx9V
         gTLuI0kzy0ZIf+ljd82tD/Qq0iMg4ZFRRqQzVCdh5zG/QjM/PkK/tP64E2fGXdFNVRk+
         QPtSuqkBVFKKaUwSqa9cVDsu6SzCzg7Rg6SaCHVzSB+CPCVTtpPilbwGB4rBpGwdc3Ib
         qKHpgWBPd6ro+VOtbcgwcyhyeTWuKZV0bpMxJ0Q/ixHV2LGaM2/3erKqDn/DF70aoeoB
         EWmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DxjJWbKincMlvSXC/FY3Ala2ok6WlFlcTqLiBRO6M/w=;
        b=DboWXNZm01GQBmL4bEjjvSB84O283HEG2aIWST6irP+u/WSYfcKER4xMukNAMJoIYN
         6mdRPRviW5PuSVp9tN8NnAT6aCX+iaytoreFPzg9pVJKiceRBr4bk5eZGsLmEYQObk+3
         xGXzZgoL/mQNqyQNu+Tu8TfHnOC2vUExYvKfo73/spNNvTRSdIitBcVPB11wDMZej0Xx
         sOYdUlDXGuBJTr8zCilVN3HG4ri5maudycNE3wDQvM3GJU1EQkpJN+7L7cgsNVk/OUnb
         /RgSPcJ8XRnswhudxqNshNXDKdWRvpqCNSOgzHYK8ojXquHq0XcX0GCInGtyvfBzOG/0
         CuyA==
X-Gm-Message-State: AOAM530nF53+VWnUNLlYse3YEiEWy5hd1zTK23n11QtSQZcGwbFQb8eM
        GaFeiNGabhQnWxw2qwlnW4RPYA==
X-Google-Smtp-Source: ABdhPJxMtGllP8NiZbEk0on6Wf4jCwBWbZKO6nNiOAtImB19UfktQycjNgLkgeaQaEGg3IeQfOfgiA==
X-Received: by 2002:a63:d205:: with SMTP id a5mr5010873pgg.30.1634230474404;
        Thu, 14 Oct 2021 09:54:34 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m186sm3131409pfb.165.2021.10.14.09.54.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 09:54:33 -0700 (PDT)
Date:   Thu, 14 Oct 2021 16:54:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Vipin Sharma <vipinsh@google.com>, pbonzini@redhat.com,
        dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: VMX: Add a wrapper for reading
 INVPCID/INVEPT/INVVPID type
Message-ID: <YWhgxjAwHhy0POut@google.com>
References: <20211011194615.2955791-1-vipinsh@google.com>
 <YWSdTpkzNt3nppBc@google.com>
 <CALMp9eRzPXg2WS6-Yy6U90+B8wXm=zhVSkmAym4Y924m7FM-7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRzPXg2WS6-Yy6U90+B8wXm=zhVSkmAym4Y924m7FM-7g@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 11, 2021, Jim Mattson wrote:
> On Mon, Oct 11, 2021 at 1:23 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, Oct 11, 2021, Vipin Sharma wrote:
> > > -     if (type > 3) {
> > > +     if (type > INVPCID_TYPE_MAX) {
> >
> > Hrm, I don't love this because it's not auto-updating in the unlikely chance that
> > a new type is added.  I definitely don't like open coding '3' either.  What about
> > going with a verbose option of
> >
> >         if (type != INVPCID_TYPE_INDIV_ADDR &&
> >             type != INVPCID_TYPE_SINGLE_CTXT &&
> >             type != INVPCID_TYPE_ALL_INCL_GLOBAL &&
> >             type != INVPCID_TYPE_ALL_NON_GLOBAL) {
> >                 kvm_inject_gp(vcpu, 0);
> >                 return 1;
> >         }
> 
> Better, perhaps, to introduce a new function, valid_invpcid_type(),
> and squirrel away the ugliness there?

Oh, yeah, definitely.  I missed that SVM's invpcid_interception() has the same
open-coded check.

Alternatively, could we handle the invalid type in the main switch statement?  I
don't see anything in the SDM or APM that architecturally _requires_ the type be
checked before reading the INVPCID descriptor.  Hardware may operate that way,
but that's uArch specific behavior unless there's explicit documentation.


diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 89077160d463..c8aade2e2a20 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3119,11 +3119,6 @@ static int invpcid_interception(struct kvm_vcpu *vcpu)
        type = svm->vmcb->control.exit_info_2;
        gva = svm->vmcb->control.exit_info_1;

-       if (type > 3) {
-               kvm_inject_gp(vcpu, 0);
-               return 1;
-       }
-
        return kvm_handle_invpcid(vcpu, type, gva);
 }

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1c8b2b6e7ed9..ad2e794d4cb2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5504,11 +5504,6 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
        vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
        type = kvm_register_read(vcpu, (vmx_instruction_info >> 28) & 0xf);

-       if (type > 3) {
-               kvm_inject_gp(vcpu, 0);
-               return 1;
-       }
-
        /* According to the Intel instruction reference, the memory operand
         * is read even if it isn't needed (e.g., for type==all)
         */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d9273f536f9d..a3657db6daf9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12382,7 +12382,8 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
                return kvm_skip_emulated_instruction(vcpu);

        default:
-               BUG(); /* We have already checked above that type <= 3 */
+               kvm_inject_gp(vcpu, 0);
+               return 1;
        }
 }
 EXPORT_SYMBOL_GPL(kvm_handle_invpcid);
