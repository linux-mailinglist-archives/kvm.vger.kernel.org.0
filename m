Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EECA69892A
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 01:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjBPAWV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 19:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBPAWT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 19:22:19 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AD4298DF
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 16:22:17 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-53317a0238dso2126107b3.17
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 16:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OO/XTincpCiOXImHy7SwOjlBWMW8XPG1CnOI7CA/ZcY=;
        b=LnBstyJy4LT3mEIvdskbIgeDS+rclo6poLMV+Nv5ZzkibiXvVIGYgkx+eOYc5BJHvL
         0zETyvNfNI/evJrwJjztLvCpN2ptg7Fb4ErZw3wTbRnLzZmYj7aGlhQrL7iJI0yGogOP
         rfyh44a+Gh2NWZVrepHI5BJIpv/+R24uMLgypUhJXK8IzqTxcYLcadWw38FdHhM2ZR8t
         O4QkPfZroFOoYjKZqdQ7aQQHblRW81SOmO6DpONJjDgKmi+9IrJrKWbRF7I6XkGDYUmo
         2gyVpBEA5dHppBpAM2NvB3AMfRXKL0UlijifmMlLRS7DVO4EL6O+XkniDfrgCR2HNKPO
         2Vwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OO/XTincpCiOXImHy7SwOjlBWMW8XPG1CnOI7CA/ZcY=;
        b=hwc4tdwSVgKCrDKpjHBa36APoJVUdP/uWKQSU8ptVz7M1QtnNU7WxV12/QF626i/3k
         VgLdCgdY7OEZ/GM2VQqU9OQsvVQiLifMUQLI8ITHW/j2xIC0NRhSInH/kuOB2uR9hbFJ
         Ks51vuGPkD6j/FOlEnSvTGYnVthpcZD6q0a/xGgFY20aZlYg1ZNDR28UyjNbmDvWqFyI
         DA4LwtC8j8DrCqUNLNu509x5rjRqzZQIep66lU1iNPXqsydzzfYNEPp48OGs6WnT6Few
         QKs0CWg54qJYDP2cdTzz5iwRje0BF8c3rV0Ms8hyOvZVtb8XLHznox4XAxfyzy6M5WSV
         k4+w==
X-Gm-Message-State: AO0yUKXyCDIr0lp4wMbK0ghO022hP1LGdqz1MF6IWfidq6wkYhUuHLPj
        DdfJ390jo/bESWLfBm8rO8AaABeGIgI=
X-Google-Smtp-Source: AK7set8TtgAp+JveubF1EyRpmR0tyRaCPAWGn+TbxCeFDcJCSfFyMY0Gdzt5kzn4yrgBcM4KmuI5pUnnlgk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:bcd:0:b0:8ac:a1b7:6fa3 with SMTP id
 c13-20020a5b0bcd000000b008aca1b76fa3mr458932ybr.278.1676506937147; Wed, 15
 Feb 2023 16:22:17 -0800 (PST)
Date:   Wed, 15 Feb 2023 16:22:15 -0800
In-Reply-To: <Y+1f/En6rvqoe6st@google.com>
Mime-Version: 1.0
References: <20221129193717.513824-1-mlevitsk@redhat.com> <20221129193717.513824-8-mlevitsk@redhat.com>
 <Y9mWFlGdzoa8ZDW7@google.com> <a59505b3-5405-0409-bbf1-34466932c2c1@amd.com>
 <Y+PIdJZtCsGH2Sw3@google.com> <2b5994e2-15ba-dd57-285c-fb33827a5275@amd.com> <Y+1f/En6rvqoe6st@google.com>
Message-ID: <Y+13N/Ky19VK0rzq@google.com>
Subject: Re: [PATCH v2 07/11] KVM: x86: add a delayed hardware NMI injection interface
From:   Sean Christopherson <seanjc@google.com>
To:     Santosh Shukla <santosh.shukla@amd.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 15, 2023, Sean Christopherson wrote:
> On Tue, Feb 14, 2023, Santosh Shukla wrote:
> > "
> > V_NMI_MASK: Indicates whether virtual NMIs are masked. The processor will set V_NMI_MASK
> > once it takes the virtual NMI. V_NMI_MASK is cleared when the guest successfully completes an
> > IRET instruction or #VMEXIT occurs while delivering the virtual NMI
> > "
> >
> > In my initial implementation I had changed V_NMI_MASK for the SMM scenario [1],
> > This is also not required as HW will save the V_NMI/V_NMI_MASK on 
> > SMM entry and restore them on RSM.
> > 
> > That said the svm_{get,set}_nmi_mask will look something like:

...

> >  static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
> >  {
> >         struct vcpu_svm *svm = to_svm(vcpu);
> > 
> > +       if (is_vnmi_enabled(svm))
> > +               return;
> > +
> >         if (masked) {
> >                 svm->nmi_masked = true;
> >                 svm_set_iret_intercept(svm);
> > 
> > is there any inputs on above approach?
> 
> What happens if software clears the "NMIs are blocked" flag?  If KVM can't clear
> the flag, then we've got problems.  E.g. if KVM emulates IRET or SMI+RSM.  And I
> I believe there are use cases that use KVM to snapshot and reload vCPU state,
> e.g. record+replay?, in which case KVM_SET_VCPU_EVENTS needs to be able to adjust
> NMI blocking too.

Actually, what am I thinking.  Any type of state save/restore will need to stuff
NMI blocking.  E.g. live migration of a VM that is handling an NMI (V_NMI_MASK=1)
_and_ has a pending NMI (V_NMI=1) absolutely needs to set V_NMI_MASK=1 on the dest,
otherwise the pending NMI will get serviced when the guest expects NMIs to be blocked.
