Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B2C36849A
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 18:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236603AbhDVQPs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 12:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235232AbhDVQPr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 12:15:47 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456CCC06174A
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 09:15:12 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id h20so23791172plr.4
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 09:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hPrnw+6gYREfgVmbG9la+vlv6dGyfI3xfHXyLaBNaY0=;
        b=gScS+XjDdPxVnNlif6QF4Ktr6IKwhe4aH5TJDc6JBaZWQ2DitrRN8UJvq/dfOzR3DW
         ovBVyy6Gxt0d3lGIoRzMFZH8FYMUXylkFbEjmxwf34wbaWdzDaDBYeRPjN2YUYgQi6uC
         Srkldqp9AkSmKS2B0oY6zw+WrWSPFlxwVmfNI3r8ogY5WLnqS83VfFVc3/c/P8/aa9tQ
         yzFBJCmdtRrmq3QmKB/eeLiiLCFbAVwsKJ4cY6aW4mz5w4F+Zw4ElhKDREydU31wRTCz
         Y9Sf/N88Va6bZme1WGuaPYig4QnkAR4VXy+8/W7y+/DPmQ1r1sCTmEMxQnvMJQOIx22R
         vFFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hPrnw+6gYREfgVmbG9la+vlv6dGyfI3xfHXyLaBNaY0=;
        b=dyaVweCR2Lay8Ue4HjfrzIKhrG3X65WX42gbGWXKF2js0jiqQpUuBTmFm6uoOMiSuL
         9DcF8vj5K+ti/1lWTqpTf008fROglmVEwKNwUkboBJAu80Y7otujaOyFUSD205UM08U3
         +Pth8KtvyR4kuGR5/fAlCYloB23gX3E3IkNX9lKERtKV82Qr60ctnOxMF+MLE9lCAO4M
         qAN1pdd4NWuhGGJCFwk607NEBU6bOMGqVjv0zTbdQ3XshO/uiKeg+i67VUH6xCdMvd+/
         dhXtw/c3qTnKaHw38D3s72FYijSn55mcsF2WqDhQjUXcnjjeqzfI+zPXJFoZQ1VQQuJS
         l3DQ==
X-Gm-Message-State: AOAM532Brd6kwL2X10WgfLp3u8S/yVD2sCeK8F3YXy4MjyMPwC8hW+Z0
        o81/IE3qhS9s3/FQPKEULFssmw==
X-Google-Smtp-Source: ABdhPJyOayWFoLYWFT+Owff0/VHBrm9ci9acPCP3tukyJz3F7vgvr3XujaCyYBh0KIO5KKe033tbBg==
X-Received: by 2002:a17:902:b117:b029:e6:81ed:8044 with SMTP id q23-20020a170902b117b02900e681ed8044mr4092540plr.13.1619108111612;
        Thu, 22 Apr 2021 09:15:11 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id h8sm2693759pjt.17.2021.04.22.09.15.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 09:15:11 -0700 (PDT)
Date:   Thu, 22 Apr 2021 16:15:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Wei Huang <wei.huang2@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v5 03/15] KVM: SVM: Disable SEV/SEV-ES if NPT is disabled
Message-ID: <YIGhC/1vlIAZfwzm@google.com>
References: <20210422021125.3417167-1-seanjc@google.com>
 <20210422021125.3417167-4-seanjc@google.com>
 <5e8a2d7d-67de-eef4-ab19-33294920f50c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e8a2d7d-67de-eef4-ab19-33294920f50c@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 22, 2021, Paolo Bonzini wrote:
> On 22/04/21 04:11, Sean Christopherson wrote:
> > Disable SEV and SEV-ES if NPT is disabled.  While the APM doesn't clearly
> > state that NPT is mandatory, it's alluded to by:
> > 
> >    The guest page tables, managed by the guest, may mark data memory pages
> >    as either private or shared, thus allowing selected pages to be shared
> >    outside the guest.
> > 
> > And practically speaking, shadow paging can't work since KVM can't read
> > the guest's page tables.
> > 
> > Fixes: e9df09428996 ("KVM: SVM: Add sev module_param")
> > Cc: Brijesh Singh <brijesh.singh@amd.com
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/svm/svm.c | 30 +++++++++++++++---------------
> >   1 file changed, 15 insertions(+), 15 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index fed153314aef..0e8489908216 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -970,7 +970,21 @@ static __init int svm_hardware_setup(void)
> >   		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
> >   	}
> > -	if (IS_ENABLED(CONFIG_KVM_AMD_SEV) && sev) {
> > +	/*
> > +	 * KVM's MMU doesn't support using 2-level paging for itself, and thus
> > +	 * NPT isn't supported if the host is using 2-level paging since host
> > +	 * CR4 is unchanged on VMRUN.
> > +	 */
> > +	if (!IS_ENABLED(CONFIG_X86_64) && !IS_ENABLED(CONFIG_X86_PAE))
> > +		npt_enabled = false;
> 
> Unrelated, but since you're moving this code: should we be pre-scient and
> tackle host 5-level paging as well?
> 
> Support for 5-level page tables on NPT is not hard to fix and could be
> tested by patching QEMU.  However, the !NPT case would also have to be fixed
> by extending the PDP and PML4 stacking trick to a PML5.

Isn't that backwards?  It's the nested NPT case that requires the stacking trick.
When !NPT is disabled in L0 KVM, 32-bit guests are run with PAE paging.  Maybe
I'm misunderstanding what you're suggesting.
 
> However, without real hardware to test on I'd be a bit wary to do it.
> Looking at 5-level EPT there might be other issues (e.g. what's the guest
> MAXPHYADDR) and I would prefer to see what AMD comes up with exactly in the
> APM.  So I would just block loading KVM on hypothetical AMD hosts with
> CR4.LA57=1.

Agreed, I think blocking KVM makes the most sense.
