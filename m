Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDCE4F6F3F
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 02:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbiDGAgD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 20:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiDGAgC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 20:36:02 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027F4BD8B1
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 17:34:05 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id y6so3471052plg.2
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 17:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sL3wuBTw/dwoQlL6RSLgjqdwXx1E82jMdIVhieH2eYI=;
        b=Uaw2NUiOZa5REByzIVSYeRJPspQ+8GqREi63CaSoCY1lP+4l8zlLUEmN7oz8vTYAer
         GIwsrOTXQC5IpHvOPqNNmSNfq/Z1BkStZoTeYWHnKmwKWRepSEeci1OhJujgJB8RWFZk
         p8ofJ8lMklDjKFHc3U3HToj+9/a8W8kCM43bnLGIW36ygLLg8p+aoewV7E3nPsFeUjjA
         T0OFGQ6/DVT/lAK6a5013sgMfxijFkzbfMOSYkRaLzI+sDqOUaEkXcVdCa9Uru7kUueE
         uHA7kubLG9uGAivCtfBCl5KHyv6/AFTxRMgklmm6nsJN6SG+foAFFEwYCQ/bYI25oeQg
         94dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sL3wuBTw/dwoQlL6RSLgjqdwXx1E82jMdIVhieH2eYI=;
        b=sW04pmpeUjEsdC8FVUhr82COqHDNNqg3b2qhkgw/+L+slQrPxxHlPnId0lNsSB4a1Y
         TZWG6yVyR3OH8uNYGsUkR/Fp2s/B2s6GnLMjUdT9qx25ftOqC3TLHi/sMuFbSSU8fr79
         fXQ4NsY8SVdLyS9Ipzo75qOFwK/akdR9eEchlefdkWNy4XY1yH2j/dr91Lqlt0uvNB2e
         YsqKTOnwwUb49wZK9KamaHxikDapMNDsnIbG7xaBeWF8TXyFpOLQJOeT0GaWk9gduchs
         IRDy8tmQ/lVxEow80sik3NdTR5pwrxmXmlTgkbwdn1FVnmPgqmcDNwSg+5PE1zMH7G25
         uExw==
X-Gm-Message-State: AOAM533r8ojUsppA7DgPI6AeS0hLvFbNjiD615rTDkUI4R65URhHepiz
        L4Hm/O9SjBLiM1tB03nUvIfoAg==
X-Google-Smtp-Source: ABdhPJxFXWG7PxM3SLwqVBVn9J1klEiW5E+6e/XZHrIn9c659Ri+YP3gQ3RV9jUdp9tTyP1y4h6tWw==
X-Received: by 2002:a17:90b:1c03:b0:1c7:5523:6a27 with SMTP id oc3-20020a17090b1c0300b001c755236a27mr12950777pjb.29.1649291644367;
        Wed, 06 Apr 2022 17:34:04 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mu1-20020a17090b388100b001c77e79531bsm6912619pjb.50.2022.04.06.17.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 17:34:03 -0700 (PDT)
Date:   Thu, 7 Apr 2022 00:34:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>
Subject: Re: [PATCH v4 1/8] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
Message-ID: <Yk4xd4hAij3ZQame@google.com>
References: <4d4606f4-dbc9-d3a4-929e-0ea07182054c@redhat.com>
 <Yh/nlOXzIhaMLzdk@google.com>
 <YiAdU+pA/RNeyjRi@google.com>
 <78abcc19-0a79-4f8b-2eaf-c99b96efea42@redhat.com>
 <YiDps0lOKITPn4gv@google.com>
 <CALMp9eRGNfF0Sb6MTt2ueSmxMmHoF2EgT-0XR=ovteBMy6B2+Q@mail.gmail.com>
 <YiFS241NF6oXaHjf@google.com>
 <764d42ec-4658-f483-b6cb-03596fa6c819@redhat.com>
 <Yk4vqJ1nT+JxEpKo@google.com>
 <CAOQ_Qsj6KwV_OjDS-JwOkPs76Z9FiCBVBTGgp-_hZHQ6BAeExg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ_Qsj6KwV_OjDS-JwOkPs76Z9FiCBVBTGgp-_hZHQ6BAeExg@mail.gmail.com>
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

On Wed, Apr 06, 2022, Oliver Upton wrote:
> Hey Sean,
> 
> On Wed, Apr 6, 2022 at 5:26 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, Mar 04, 2022, Paolo Bonzini wrote:
> > > On 3/4/22 00:44, Sean Christopherson wrote:
> > > >
> > > > diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> > > > index c92cea0b8ccc..46dd1967ec08 100644
> > > > --- a/arch/x86/kvm/vmx/nested.h
> > > > +++ b/arch/x86/kvm/vmx/nested.h
> > > > @@ -285,8 +285,8 @@ static inline bool nested_cr4_valid(struct kvm_vcpu *vcpu, unsigned long val)
> > > >  }
> > > >
> > > >  /* No difference in the restrictions on guest and host CR4 in VMX operation. */
> > > > -#define nested_guest_cr4_valid nested_cr4_valid
> > > > -#define nested_host_cr4_valid  nested_cr4_valid
> > > > +#define nested_guest_cr4_valid kvm_is_valid_cr4
> > > > +#define nested_host_cr4_valid  kvm_is_valid_cr4
> > >
> > > This doesn't allow the theoretically possible case of L0 setting some
> > > CR4-fixed-0 bits for L1.  I'll send another one.
> >
> > Are you still planning on sending a proper patch for this?
> >
> > And more importantly, have we shifted your view on this patch/series?
> 
> Sorry, I should've followed up. If nobody else complains, let's just
> leave everything as-is and avoid repeating the mistakes of the patches
> to blame (hey, I authored one of those!)

The problem is that if we leave things as is, someone will inevitably think it's
the right thing to do and will repeat those mistakes.  I don't see why we wouldn't
add the quirk, broken userspace gets to keep its broken behavior unless it opts
into to disabling the quirk.
