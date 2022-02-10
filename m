Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1414B1947
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 00:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345561AbiBJXQX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 18:16:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345513AbiBJXQV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 18:16:21 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129305F58
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 15:16:22 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id 9so10123648pfx.12
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 15:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U8yAHUx3NK0rKUAij+DjnPG5NstC175VY6VEIELyATY=;
        b=IyNPNiJnwv1DiQnR0zrWU4/CK9fV7cBf452ASGkWgb0WoPhEAQ+RobfZ6ZBoeS7kja
         lL15Qg9fDdFjR30miKaiugM1/3hKUT+Nqs/ZjREWeE7CfnQ1MXR442ec+KrabD4uTH9P
         gkZEy8pwvzx5UzT4FTyvzVN9zZBItkdVsnDTmaxfayzSRLt0pmIzOVWwFm3325ucC95E
         Oup8RAanYZsMTuoUY55OFfPAzUT32OUjR/gRL2Kp7qapzuqrubiA4vtTLQtCOW7woJqD
         PIjJ5vXnMr3qs/FcaRAwf4Isib893ia9l+dBQXjc+GDDo3Yw9ywFTKRqnYHljz3yPmZP
         NEAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U8yAHUx3NK0rKUAij+DjnPG5NstC175VY6VEIELyATY=;
        b=jDSRsxCO6pMW/x5Q0Kwpc2NOLFIfRuPS+6lWIBZcpe5Y7rWCpXLJvWi0fjbwEUvaoD
         4wDaR6IDrk2ptefdfugE1jyXFJYPWHtQc7QNNc6mc7aDAkj1nGje4jKJkhfpV3sk2zll
         0w+mk0s6yA82mpRXC/kQxPHc+Dyw90+BSGZ3AEEMLNwZaMzQviO+debqrqv5U8pKLJGx
         uo+Ts0+3xHINTi1NTz/mPWleLpZtI9y516re8t6cPXZOkTPJ5DGIcyUeeHaHNwYdG0+J
         SntZQtmlb/UkGWw63vu1ApV+fHDnxfsgbRhfQYmN1OC6kGYscF+GfapNchD/G5IE3z6g
         8jKw==
X-Gm-Message-State: AOAM530fhaGpFe/zVi6/cSr8ovIFF+yqNLkwoyUkbAMoa07/oXXQQ9hl
        qoBQ5knUXCf7Vt9fY+PFilUfDw==
X-Google-Smtp-Source: ABdhPJz/wIQvMMphnAidsJDKGsOVONIwkZy/0fQZrAN9QPZRK+JABBUQLOF94nKpCjI4m6wDoCOikQ==
X-Received: by 2002:a05:6a00:2355:: with SMTP id j21mr9783791pfj.50.1644534981357;
        Thu, 10 Feb 2022 15:16:21 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 17sm25022106pfl.175.2022.02.10.15.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 15:16:20 -0800 (PST)
Date:   Thu, 10 Feb 2022 23:16:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
Subject: Re: [PATCH 03/12] KVM: x86: do not deliver asynchronous page faults
 if CR0.PG=0
Message-ID: <YgWcwQYHIFCb2pvH@google.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-4-pbonzini@redhat.com>
 <YgWbgfSrzAhd97LG@google.com>
 <YgWcS/0naKPdAn2E@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgWcS/0naKPdAn2E@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 10, 2022, Sean Christopherson wrote:
> On Thu, Feb 10, 2022, Sean Christopherson wrote:
> > On Wed, Feb 09, 2022, Paolo Bonzini wrote:
> > > Enabling async page faults is nonsensical if paging is disabled, but
> > > it is allowed because CR0.PG=0 does not clear the async page fault
> > > MSR.  Just ignore them and only use the artificial halt state,
> > > similar to what happens in guest mode if async #PF vmexits are disabled.
> > > 
> > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > ---
> > >  arch/x86/kvm/x86.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 5e1298aef9e2..98aca0f2af12 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -12272,7 +12272,9 @@ static inline bool apf_pageready_slot_free(struct kvm_vcpu *vcpu)
> > >  
> > >  static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
> > >  {
> > > -	if (!vcpu->arch.apf.delivery_as_pf_vmexit && is_guest_mode(vcpu))
> > > +	if (is_guest_mode(vcpu)
> > > +	    ? !vcpu->arch.apf.delivery_as_pf_vmexit
> > > +	    : !is_cr0_pg(vcpu->arch.mmu))
> > 
> > As suggested in the previous patch, is_paging(vcpu).
> > 
> > I find a more tradition if-elif marginally easier to understand the implication
> > that CR0.PG is L2's CR0 and thus irrelevant if is_guest_mode()==true.  Not a big
> > deal though.
> > 
> > 	if (is_guest_mode(vcpu)) {
> > 		if (!vcpu->arch.apf.delivery_as_pf_vmexit)
> > 			return false;
> > 	} else if (!is_paging(vcpu)) {
> > 		return false;
> > 	}
> 
> Alternatively, what about reordering and refactoring to yield:
> 
> 	if (kvm_pv_async_pf_enabled(vcpu))
> 		return false;
> 
> 	if (vcpu->arch.apf.send_user_only &&
> 	    static_call(kvm_x86_get_cpl)(vcpu) == 0)
> 		return false;
> 
> 	/* L1 CR0.PG=1 is guaranteed if the vCPU is in guest mode (L2). */
> 	if (is_guest_mode(vcpu)
> 		return !vcpu->arch.apf.delivery_as_pf_vmexit;
> 
> 	return is_cr0_pg(vcpu->arch.mmu);
> 
> There isn't any need to "batch" the if statements.

Third time's a charm...

	if (kvm_pv_async_pf_enabled(vcpu))
		return false;

	if (vcpu->arch.apf.send_user_only &&
	    static_call(kvm_x86_get_cpl)(vcpu) == 0)
		return false;

	/* L1 CR0.PG=1 is guaranteed if the vCPU is in guest mode (L2). */
	if (is_guest_mode(vcpu))
		return !vcpu->arch.apf.delivery_as_pf_vmexit;

	return is_paging(vcpu);


