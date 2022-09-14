Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD645B8223
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 09:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiINHmn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 03:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiINHmj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 03:42:39 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E468472B40
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 00:42:37 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso18106626pjk.0
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 00:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=c5ZYpTByncp5HN1cWQAD3FaVVr7mGXVV2XjTzUESKj0=;
        b=BxaLnc1MXY1pE93RhGGQ/rxkxCg6rVjgniDvBvWlyWMsWQ/WkY0SZn2Dcd4Z8O9fQx
         6WmxkwHh9sTJhHUuIXfiAqjBRVo8WAH+p1Ebmmewwt43D2CB+WjtwYDMgc7UBFUANuG7
         IcoXy4jVuT9Xctl0icw8j9nU3ZaRKasYOKTIobMTWuws1M4lLhPquYty+k3tbkAER6C0
         nAEdV24vO3920A4s8cQa19MoTnddBoWWP8ZQwqnwlgTuYxa1cUj8GnSYh1dawQSp7/4e
         6EkjwQaJuRbLqQPN/TxkrVwhaOn3xnIGI5M2FSF1oKD1mLpgFPNjFTWR1XI08g9tVUa2
         c1NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=c5ZYpTByncp5HN1cWQAD3FaVVr7mGXVV2XjTzUESKj0=;
        b=WBk4m97j4ynag2bp+nuIVgkWqylcFUzr4D0vTlgST/p03+lmHVL62SI3sgb3AmD42D
         lgYloL28V6E3Z0+3RghHqtxbcpW0GG/kj639YwtP1mTccIRlHsrTZsUtS9mjaBBYuDnt
         h3/YZdP70ACdVJp1WyvyhFscbOCjsv8AeVm2o6qmRMsxx7Rnv6RnA6vMnAXF36t+CSjx
         QUq3+tN2NL1UDLv0YLg01oqHA7ilv+EwY2VuzHpdTIrgT6w/N5U4E/rBH5ezbHsw49hB
         J/hIPf+s/u6vrQMVR0nx4sGzZBslVLiGUGBIUfbUXqhGtJTpjskmE/jNRZCtyOzYKF6g
         23tg==
X-Gm-Message-State: ACgBeo3ORRNuKrPsoou4EP6m1FjvH+SI5tusZxphO6wy3B2rwmdOFQFx
        0IjQVZEWTGEdtqvYT9Z03vIfog==
X-Google-Smtp-Source: AA6agR4Bt9Eijo0k77CkX0XflkxEon8bq4pHXN/QXruP0B6PdzCMzu/U2fIL81611fkeu8WWH4k1nw==
X-Received: by 2002:a17:902:ccc7:b0:16c:484f:4c69 with SMTP id z7-20020a170902ccc700b0016c484f4c69mr36564183ple.118.1663141356949;
        Wed, 14 Sep 2022 00:42:36 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m6-20020a17090a2c0600b001faf7a88138sm8368043pjd.42.2022.09.14.00.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 00:42:36 -0700 (PDT)
Date:   Wed, 14 Sep 2022 07:42:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH v2 13/23] KVM: x86: Disable APIC logical map if vCPUs are
 aliased in logical mode
Message-ID: <YyGF6T/N1l3i7Ded@google.com>
References: <20220903002254.2411750-1-seanjc@google.com>
 <20220903002254.2411750-14-seanjc@google.com>
 <aedb7677-528a-75b7-6517-ab1865515ad4@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aedb7677-528a-75b7-6517-ab1865515ad4@amd.com>
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

On Tue, Sep 13, 2022, Suthikulpanit, Suravee wrote:
> Hi Sean
> 
> On 9/2/2022 7:22 PM, Sean Christopherson wrote:
> > Disable the optimized APIC logical map if multiple vCPUs are aliased to
> > the same logical ID.  Architecturally, all CPUs whose logical ID matches
> > the MDA are supposed to receive the interrupt; overwriting existing map
> > entries can result in missed IPIs.
> > 
> > Fixes: 1e08ec4a130e ("KVM: optimize apic interrupt delivery")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >   arch/x86/kvm/lapic.c | 5 +++--
> >   1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 6b2f538b8fd0..75748c380ceb 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -303,12 +303,13 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
> >   		if (!mask)
> >   			continue;
> > -		if (!is_power_of_2(mask)) {
> > +		ldr = ffs(mask) - 1;
> > +		if (!is_power_of_2(mask) || cluster[ldr]) {
> 
> Should this be checking if the cluster[ldr] is pointing to the same struct
> apic instead? For example:
> 
> 		if (!is_power_of_2(mask) || cluster[ldr] != apic)
> 
> From my observation, the kvm_recalculate_apic_map() can be called many
> times, and the cluster[ldr] could have already been assigned from the
> previous invocation. So, as long as it is the same, it should be okay.

No, because cluster[ldr] can never match "apic".  kvm_recalculate_apic_map()
creates and populates a _new_ kvm_apic_map every time, it doesn't do an in-place
update of the current map.

The loop containing this code is:

	kvm_for_each_vcpu(i, vcpu, kvm) {
		struct kvm_lapic *apic = vcpu->arch.apic;

		...
	}

so it's impossible for cluster[ldr] to hold the current "apic", because this is
the first and only iteration that processes the current "apic".
