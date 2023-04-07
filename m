Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9DD86DA698
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 02:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237455AbjDGAXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 20:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjDGAXp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 20:23:45 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EC859D5
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 17:23:44 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-2448b247ef8so41921a91.2
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 17:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680827024;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9BL6xGXohD1mMjzQzL9jL23akOWofJeCBhg5NZPFl9s=;
        b=e2YAugEvgT5tAXo7eVUS5zgBbfWIlCwI6gAkSy3eKfW/JPoowsZZe7fSYDgebDGW5g
         w7qPjIQl5uNGRCeAmO9aPTn2ss01Mz8Jumtn3zcirquknCrjD2/iozRJN5kCWCNtaIOZ
         d77le/+gF3tCjH5BB0YAu9UMLmpk7zL3HtcOFy+rn1c+rkcE549YeuajAx9WbxEq+YT9
         GnMTR4IRHjrLsMB1dTLEzDfyO+wySRZMbPZjiGAQ6StHnYeq+th6CJIpeOUdMPMIBNiE
         9CMPRy3oRtHpYWdtd6xVDUj+iqa45l3fe8R5OLeXoUncLF9LFsEDPxye6c67JUvjiNYR
         o5sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680827024;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9BL6xGXohD1mMjzQzL9jL23akOWofJeCBhg5NZPFl9s=;
        b=WkRnUEBGy8nai7bu1F0ByC5xzJ+MsDLEo3K0/B423JPExXxm8IGcN+abnANlo4YmYV
         Hs9MCMX/HpuAnCOiJ5ZaJwWtnZugtz5+zjTLzdx0ZBECcIR61qrGBDzhn8jl1xRSLJfs
         uRHxuxfWq2HGWSz7EW8br6u0O/avEni/u/h7lkjJzaQX8Gr1KYnVcYn4XdgfJKVPaXay
         wJ7aH6SPlCcYceOpBpW2EN7VMYie/ateApD40y+Wn2z7HYG/o//g8vc2AyLSZrez6QmF
         1vHQx/vpDwYS02AG8lyZk5mN8D4KOKkzfGqdtxYiBMXVCBEOA40yNWxKi6K8PTI0wtLT
         3pSQ==
X-Gm-Message-State: AAQBX9dVF8VYjEeAfNNLHwF2iL9WWcVv2bYVZ8zCnajqqKHkg+QdVvWk
        SNllgrZ2XLMfGzafpK2JodcaisSo6lE=
X-Google-Smtp-Source: AKy350ZDcF01M0B0CctJ34aWlQdDkU/U4sdYBnEP029Qs93P/VbJsAL7otUHHaLd74TLG5g4YXpKhu1Uqds=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2182:b0:625:73a7:326f with SMTP id
 h2-20020a056a00218200b0062573a7326fmr383929pfi.3.1680827024058; Thu, 06 Apr
 2023 17:23:44 -0700 (PDT)
Date:   Thu, 6 Apr 2023 17:23:42 -0700
In-Reply-To: <ZC9enygbWzJ59Ssb@google.com>
Mime-Version: 1.0
References: <20230214050757.9623-1-likexu@tencent.com> <20230214050757.9623-9-likexu@tencent.com>
 <ZC9enygbWzJ59Ssb@google.com>
Message-ID: <ZC9ijgZBaz6p1ecw@google.com>
Subject: Re: [PATCH v4 08/12] KVM: x86/pmu: Disable vPMU if the minimum num of
 counters isn't met
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 06, 2023, Sean Christopherson wrote:
> On Tue, Feb 14, 2023, Like Xu wrote:
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Like Xu <likexu@tencent.com>
> > ---
> >  arch/x86/kvm/pmu.h | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> > index d1cc02c8da88..46db5404894e 100644
> > --- a/arch/x86/kvm/pmu.h
> > +++ b/arch/x86/kvm/pmu.h
> > @@ -170,6 +170,12 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
> >  	if ((is_intel && !kvm_pmu_cap.version) || !kvm_pmu_cap.num_counters_gp)
> >  		enable_pmu = false;
> >  
> > +	/*
> > +	 * For AMD, disable vPMU if the minimum number of counters isn't met.
> > +	 */
> 
> Doesn't need to be a multiple line comment.  This comment is also useless.  It's
> quite clear from the code that PMU support is being disabled when there aren't
> enough counters, what's missing is _why_.
> 
> > +	if (!is_intel && kvm_pmu_cap.num_counters_gp < AMD64_NUM_COUNTERS)

Actually, rather than bleed AMD details into common code, define a const int
kvm_pmu_ops, e.g.

	const int MIN_NR_GP_COUNTERS

and then the above !kvm_pmu_cap.num_counters_gp can get replaced with a more generic
check.   That will also give us a convenient location to document _why_ Intel
and AMD have different mins (in particular, AMD's lack of any way to enumerate
less than four counters to the guest).

E.g. end up with

	if (enable_pmu) {
		perf_get_x86_pmu_capability(&kvm_pmu_cap);

		/*
		 * For Intel, only support guest architectural pmu
		 * on a host with architectural pmu.
		 */
		if ((is_intel && !kvm_pmu_cap.version) ||
		    (kvm_pmu_cap.num_counters_gp < pmu_ops->MIN_NR_GP_COUNTERS))
			enable_pmu = false;
	}

Hmm, and doesn't have to be done in this series, but we could do the same for the
min/max PMU versions.

> > +		enable_pmu = false;
> > +
> >  	if (!enable_pmu) {
> >  		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
> >  		return;
> > -- 
> > 2.39.1
> > 
