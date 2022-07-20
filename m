Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF83457BC79
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 19:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbiGTRS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 13:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbiGTRSZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 13:18:25 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8AE43307
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 10:18:24 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id q43-20020a17090a17ae00b001f1f67e053cso2896126pja.4
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 10:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0A7Vop3JLb1LjbZM57vszyAHhwMfMivUkOyzRnB3v4k=;
        b=OMPem98GHTwpACFqIppAYiEcB9A98T6HaqNgfFg6loCE9C2If5iTTOylYF/LdCO3j7
         wWRWVsrG1G9zL67r49dHTzEKiDpOBggC4Vq8U6GsaMa3hTOMEhXKfPUWNt9lDzmzq3dX
         se2X1rKBZXrPcAaIRqNAdVGJS/1HEeYwDpKF0DVY7JfZHQSbNoTBy8oKCNXslNZjfFaQ
         r7fsrHGZWmkTKOzZh1i6CSgPkrRfd1uGss9EYUoGOwndxI3YdGWbHocM3ZUNgPrraVCK
         hT2hHCcpX7iD91UczKNWjeIirCaWA8nw0HPpkuy2fm0xJ4K00zGe/VnRSgoWzaRJDYa3
         eKpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0A7Vop3JLb1LjbZM57vszyAHhwMfMivUkOyzRnB3v4k=;
        b=MYCrpJlEONbQ64JRGj9aiooibrNsivpmCnCcweVbKVGrQOO7usaRoZJLKYi7nqx3cf
         jnXs2O/Ck+E9QHDXiIogYBIgefEb+/mM7UnrEjA5mvKWx+Ol5LtU/2g/mk+DYwBT0EBX
         g/dTyVtJbYMvkR0IG3cM2CegK2BnLKjjPjsjc84+TyVukkKR6IVwgXx6sr0jOqf72kdI
         oQ5ZnIW+EpfSDecgMm/me9uAFzFTXlVHdGa2qvT165p0xhCHzmIplkC9vm4DEFcZMVTZ
         CsG6Gn9F++8qdcHbHATyNHRNT9ShxVm6XjFeEI4Nf7erAkY2R2tCBs4wJ7t2PW+ljhRJ
         CcMQ==
X-Gm-Message-State: AJIora954BgBbXxd+O+b9jQLHBUeKF5XQVnsdjnwggC7acq6b6rieDTn
        Bb0PvfK46JRPbV+d4+gVCV/6Xw==
X-Google-Smtp-Source: AGRyM1u1q5jWE+4EwAQPjgXW1AyAFcCYEgcXf7FKYYKoaVc96AaLu+frjyDkY4pgRjfZJtH4E03J1g==
X-Received: by 2002:a17:902:e945:b0:16a:1c41:f66 with SMTP id b5-20020a170902e94500b0016a1c410f66mr39507484pll.129.1658337503742;
        Wed, 20 Jul 2022 10:18:23 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id f15-20020aa7968f000000b00528c22fbb45sm14095091pfk.141.2022.07.20.10.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 10:18:23 -0700 (PDT)
Date:   Wed, 20 Jul 2022 17:18:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Kechen Lu <kechenl@nvidia.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, somduttar@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 4/7] KVM: x86: Let userspace re-enable previously
 disabled exits
Message-ID: <Ytg428sleo7uMRQt@google.com>
References: <20220615011622.136646-1-kechenl@nvidia.com>
 <20220615011622.136646-5-kechenl@nvidia.com>
 <20220615025114.GB7808@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615025114.GB7808@gao-cwp>
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

On Wed, Jun 15, 2022, Chao Gao wrote:
> On Tue, Jun 14, 2022 at 06:16:19PM -0700, Kechen Lu wrote:
> > 7.14 KVM_CAP_S390_HPAGE_1M
> >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >index f31ebbb1b94f..7cc8ac550bc7 100644
> >--- a/arch/x86/kvm/x86.c
> >+++ b/arch/x86/kvm/x86.c
> >@@ -4201,11 +4201,10 @@ static inline bool kvm_can_mwait_in_guest(void)
> > 
> > static u64 kvm_get_allowed_disable_exits(void)
> > {
> >-	u64 r = KVM_X86_DISABLE_EXITS_HLT | KVM_X86_DISABLE_EXITS_PAUSE |
> >-		KVM_X86_DISABLE_EXITS_CSTATE;
> >+	u64 r = KVM_X86_DISABLE_VALID_EXITS;
> > 
> >-	if(kvm_can_mwait_in_guest())
> >-		r |= KVM_X86_DISABLE_EXITS_MWAIT;
> >+	if (!kvm_can_mwait_in_guest())
> >+		r &= ~KVM_X86_DISABLE_EXITS_MWAIT;
> 
> This hunk looks like a fix to patch 3; it can be squashed into that patch.

It's not a fix, just an inversion of the logic to make it easier to maintain
going forward.  I intentionally made the change in patch 4 so that adding the
kvm_get_allowed_disable_exits() is a more "pure" movement of code from the "check"
path to a common helper.

I agree it's kinda odd, but I still think splitting the changes is desirable.
