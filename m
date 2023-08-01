Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6EF76B99F
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 18:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjHAQ2Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 12:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjHAQ2O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 12:28:14 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB6B172B
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 09:28:13 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5844e92ee6bso53350847b3.3
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 09:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690907292; x=1691512092;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HAYQ6CPqypbZAwagm0gpBh07TfshjwyxE/XrQBRRO+4=;
        b=Ghw4slRYaevnRH/HJyXNl4f59qF3vPbdk3TYFCObrlljF5993niW4hwAEnqrbZzYiS
         wg/Tc+dWHki6iAJGQ/3LXTRZ68aARNbWexYt05F4hb42kPadN+xmIo8Jp8gQw6lmjHVU
         tWBbTnFHXBc7DeoyMH+W+ZqSeqIefF8xedXubf3pZy4E+U60fp+kr6irmlu+O4vBOBeE
         JArjoY/Kuujxr3VwRtrc2RLUS88nVenlnUnHCYVOa69ZN/Lcf02n8zAzQb26Eau2/ciw
         +il/pq4vIighY8LQ9udaBahOZDqg1/Ivw/cb5k/GD0nH2PIVh11oPRi9RnL+pgLcQmHs
         0dzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690907292; x=1691512092;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HAYQ6CPqypbZAwagm0gpBh07TfshjwyxE/XrQBRRO+4=;
        b=WAU6vLvat1kmR93J2FadK6I5N+V5EHL3Kdus3iv+9m3Vi58gOS1oPKNOQa4MV74sGI
         w5XAbcXa+aTu0So62Bf2ZYVm44gvWXJoZXXtgkC+4ZL2sBGcme1pFezJd2+DPGVjIhkb
         5sZpOyWuhYntABI7+eq5SI80L/Yw+5hRWFJ3brW83awSzzae3XZZmXktLOpzUgv8ZLMv
         4ySCAKeifKWAr7zjIMvOm+r2INk7P0PT/ycies+YHMDQq2aM/jD5s1p/sEIeFZUx79MV
         9ovbLUB6NRr2gzCyLeBLanSrjG3VY1UiUMJWDVUxQXhUSJ9JRQCu0p8Sdu/OJtcWVKtu
         O8Mw==
X-Gm-Message-State: ABy/qLakJYEKf1f/unk4hC0ADzt76BBhExsonYzQFppMhXji0AOqEJ6r
        FiltwtKoWZGAn1vWaCgEV9biWMiNBwE=
X-Google-Smtp-Source: APBJJlEKj/3LC1KAcHxbD6ewH2mXHk7DozG6uhQ3WYWVvGRV9U6VMD8nuO7XFZHKw6emGK9qgUdYbNLSBrU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:c509:0:b0:573:87b9:7ee9 with SMTP id
 k9-20020a81c509000000b0057387b97ee9mr118443ywi.4.1690907292608; Tue, 01 Aug
 2023 09:28:12 -0700 (PDT)
Date:   Tue, 1 Aug 2023 09:28:11 -0700
In-Reply-To: <ZMkie3B7obtTTpLu@johallen-workstation>
Mime-Version: 1.0
References: <20230524155339.415820-1-john.allen@amd.com> <20230524155339.415820-5-john.allen@amd.com>
 <ZJYKksVIORhPtD6T@google.com> <ZMkie3B7obtTTpLu@johallen-workstation>
Message-ID: <ZMkymz22bHTsFCTD@google.com>
Subject: Re: [RFC PATCH v2 4/6] KVM: SVM: Save shadow stack host state on VMRUN
From:   Sean Christopherson <seanjc@google.com>
To:     John Allen <john.allen@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, weijiang.yang@intel.com,
        rick.p.edgecombe@intel.com, x86@kernel.org,
        thomas.lendacky@amd.com, bp@alien8.de
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 01, 2023, John Allen wrote:
> On Fri, Jun 23, 2023 at 02:11:46PM -0700, Sean Christopherson wrote:
> > On Wed, May 24, 2023, John Allen wrote:
> > As for the values themselves, the kernel doesn't support Supervisor Shadow Stacks
> > (SSS), so PL0-2_SSP are guaranteed to be zero.  And if/when SSS support is added,
> > I doubt the kernel will ever use PL1_SSP or PL2_SSP, so those can probably be
> > ignored entirely, and PL0_SSP might be constant per task?  In other words, I don't
> > see any reason to try and track the host values for support that doesn't exist,
> > just do what VMX does for BNDCFGS and yell if the MSRs are non-zero.  Though for
> > SSS it probably makes sense for KVM to refuse to load (KVM continues on for BNDCFGS
> > because it's a pretty safe assumption that the kernel won't regain MPX supported).
> > 
> > E.g. in rough pseudocode
> > 
> > 	if (boot_cpu_has(X86_FEATURE_SHSTK)) {
> > 		rdmsrl(MSR_IA32_PLx_SSP, host_plx_ssp);
> > 
> > 		if (WARN_ON_ONCE(host_pl0_ssp || host_pl1_ssp || host_pl2_ssp))
> > 			return -EIO;
> > 	}
> 
> The function in question returns void and wouldn't be able to return a
> failure code to callers. We would have to rework this path in order to
> fail in this way. Is it sufficient to just WARN_ON_ONCE here or is there
> some other way we can cause KVM to fail to load here?

Sorry, I should have been more explicit than "it probably make sense for KVM to
refuse to load".  The above would go somewhere in __kvm_x86_vendor_init().
