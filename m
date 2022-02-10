Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF074B1939
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 00:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345525AbiBJXOZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 18:14:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240813AbiBJXOY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 18:14:24 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3516B55A4
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 15:14:24 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id t14-20020a17090a3e4e00b001b8f6032d96so7107274pjm.2
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 15:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zVPS2ok9/nx7180z6dx4Z4VBr5ge+N4XNxLNYfv1b4E=;
        b=VyyafF8z0UHAylczbPUn4iflRukwWBbb+WUXy47xyXqkhIbDPqr8QWGmQRK08hrtkt
         IUUtWOTxMrtxTQUmV5kZYgN3t5yJfO7EHgX1B94/+OGtyIuYZf67FGfL78/A1VRN1qcR
         yZHUxbG//rJmxAlIy7hmpGz03vxelXwsVQjC0dYELgXlme1cj3t4zxZ+Lt5i3/buYshI
         +C49g6w39oWHqkT88ERKBpyaHXMiJ7pIKTD7TDNl2iFt4ZRdymGwPi8c3Vn1JgLkNuU9
         663OJuen9xmZPOyn+rAyIydumJ/0FtLmSD9sd9DH8klMuOW6aTJEkunzim8z31w/hhgh
         5aBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zVPS2ok9/nx7180z6dx4Z4VBr5ge+N4XNxLNYfv1b4E=;
        b=Lgbl89Fak06s4wy0mNf/o04sxqX8AqeUmWjSGukQhDD4bGZRqd0mIIIV6BGZQn7JAG
         BTfHRpM3xaQSGES0ajnm/PiVOMmYFASZk7M2YuL4Ws2Vu7XihEIT7nWoUBHii714edB/
         Z8KsoBLy4TOgbyYKDu8zvWdWR3zZGBrTekZYM5AoNcdYeUotjZfhriMsu7LLa5CdRZ8g
         sn6MnAhAeGyKU/hVwp/25YOU/rFey+VOsh/28cFiN22tcxcQYmDBqKEL8OjiWOpZ8uQK
         1vKmnMwHjzl4ykt7PU1htzaRbZG77erMHRbsb2PGitpUIYC7aXtDzhzOG1M5vnUyVbXD
         bWWA==
X-Gm-Message-State: AOAM531RsU2LERv+RjydG1DI7b9oguFN0gZGK8sK7pN3B6ahbe6/4ZTM
        HvKXq6xv0lhK8mKllZpJQXJFvg==
X-Google-Smtp-Source: ABdhPJw188UyNNoqFlMqDgKpm7hdg8bXICpgwoP46Vv6pmyTqCweCur2W7sJkfRIks5cXCOoPrUP5Q==
X-Received: by 2002:a17:902:f789:: with SMTP id q9mr9618229pln.135.1644534863552;
        Thu, 10 Feb 2022 15:14:23 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k16sm24789705pfu.140.2022.02.10.15.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 15:14:22 -0800 (PST)
Date:   Thu, 10 Feb 2022 23:14:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
Subject: Re: [PATCH 03/12] KVM: x86: do not deliver asynchronous page faults
 if CR0.PG=0
Message-ID: <YgWcS/0naKPdAn2E@google.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-4-pbonzini@redhat.com>
 <YgWbgfSrzAhd97LG@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgWbgfSrzAhd97LG@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 10, 2022, Sean Christopherson wrote:
> On Wed, Feb 09, 2022, Paolo Bonzini wrote:
> > Enabling async page faults is nonsensical if paging is disabled, but
> > it is allowed because CR0.PG=0 does not clear the async page fault
> > MSR.  Just ignore them and only use the artificial halt state,
> > similar to what happens in guest mode if async #PF vmexits are disabled.
> > 
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/kvm/x86.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 5e1298aef9e2..98aca0f2af12 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -12272,7 +12272,9 @@ static inline bool apf_pageready_slot_free(struct kvm_vcpu *vcpu)
> >  
> >  static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
> >  {
> > -	if (!vcpu->arch.apf.delivery_as_pf_vmexit && is_guest_mode(vcpu))
> > +	if (is_guest_mode(vcpu)
> > +	    ? !vcpu->arch.apf.delivery_as_pf_vmexit
> > +	    : !is_cr0_pg(vcpu->arch.mmu))
> 
> As suggested in the previous patch, is_paging(vcpu).
> 
> I find a more tradition if-elif marginally easier to understand the implication
> that CR0.PG is L2's CR0 and thus irrelevant if is_guest_mode()==true.  Not a big
> deal though.
> 
> 	if (is_guest_mode(vcpu)) {
> 		if (!vcpu->arch.apf.delivery_as_pf_vmexit)
> 			return false;
> 	} else if (!is_paging(vcpu)) {
> 		return false;
> 	}

Alternatively, what about reordering and refactoring to yield:

	if (kvm_pv_async_pf_enabled(vcpu))
		return false;

	if (vcpu->arch.apf.send_user_only &&
	    static_call(kvm_x86_get_cpl)(vcpu) == 0)
		return false;

	/* L1 CR0.PG=1 is guaranteed if the vCPU is in guest mode (L2). */
	if (is_guest_mode(vcpu)
		return !vcpu->arch.apf.delivery_as_pf_vmexit;

	return is_cr0_pg(vcpu->arch.mmu);

There isn't any need to "batch" the if statements.
