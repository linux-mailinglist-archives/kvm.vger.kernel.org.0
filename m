Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA65C5A82D9
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 18:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbiHaQQo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 12:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbiHaQQm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 12:16:42 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A39A9E11F
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:16:41 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id n8-20020a17090a73c800b001fd832b54f6so12829599pjk.0
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=9x8sUvoC7rgFMkOsw/aKrTFYXEgLneL8O2ulM5YnfRs=;
        b=pVTPFQthVCkpKdrWdf2BHvHfVDobb5p6ZHdt086Mwnd1Pt66NIeQ1FvHlx2k9KaJAH
         o2OUtSpV28iMKPJedHCPlrPNPzOCdUrUAw6l/UqdD5ewYUpdZkXKOVcDT2s4XH1UGACE
         M7s8WjgHgM210iBd38/VUvxgs/gQhRGSWrZE0p3u8kWsJpDfFKjYV56ebcx4kdaWc0yb
         47pp+lPEv5LJ66veJ4RdbBrblkqjjHGn53ySK2XBYpNQmH4/+TwQOmyYhgRlwnawwPzY
         aHRJRnAaENPamR01waUfrUprBRYlbKEaNzZaSrtti8beexy3GWKQ6zhaBbCvbfUNJ02u
         UPbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=9x8sUvoC7rgFMkOsw/aKrTFYXEgLneL8O2ulM5YnfRs=;
        b=L7hLXe9pf2ZFbOwoQ1FfjTdiMcIWIgDCoPjmMz2T1BeA7c8v9KIp3NGL5HyLoze8bt
         vYeY+BQCAUoHg1TyLEN2NKUf2U6H6LcZMVqrqjfG/X0PHRSAXVTJ+mgtVeOFktlvwOA2
         o4pGA5NMhLP3z+W0jaBTuvMrplCaOkvA5JcyyI1lsY9QzGf9YadnYJAT0BOJQpMDu+Qq
         eF0F0tlAsC87M2UW+YQwRMF4HvSlDW8NuU/5TdgFE23RXH4bAm6y1CtMgDIL/kn+vOdk
         ud2aYlS1EKPjjwwAoJCMQB+hpbZoy43MtlPUrz3emqQhGYis9MYADlD0s5oYUuN/Zor2
         lt8Q==
X-Gm-Message-State: ACgBeo2w7WZV7IsIt1mcuyhX642SbAqUO80q2copxLk65het4+GcMktl
        EbSfy5v+VHgGb0oygfa07lp4JQ==
X-Google-Smtp-Source: AA6agR5vuXY2Jbi5jyvWALwt+NdNbZX7/tR6VfIwABxkmPLHGYw9Xm0lW+y5nYDcIw+L3bFwUmBtvw==
X-Received: by 2002:a17:902:f711:b0:170:9e3c:1540 with SMTP id h17-20020a170902f71100b001709e3c1540mr25966679plo.22.1661962600665;
        Wed, 31 Aug 2022 09:16:40 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s6-20020a170902a50600b0016dbe37cebdsm11841514plq.246.2022.08.31.09.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 09:16:40 -0700 (PDT)
Date:   Wed, 31 Aug 2022 16:16:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH 10/19] KVM: SVM: Document that vCPU ID == APIC ID in AVIC
 kick fastpatch
Message-ID: <Yw+JZODiHgvZVsAN@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
 <20220831003506.4117148-11-seanjc@google.com>
 <29542724f23fd15745bd137b99153bf8629907f0.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29542724f23fd15745bd137b99153bf8629907f0.camel@redhat.com>
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

On Wed, Aug 31, 2022, Maxim Levitsky wrote:
> On Wed, 2022-08-31 at 00:34 +0000, Sean Christopherson wrote:
> > Document that AVIC is inhibited if any vCPU's APIC ID diverges from its
> > vCPU ID, i.e. that there's no need to check for a destination match in
> > the AVIC kick fast path.
> > 
> > Opportunistically tweak comments to remove "guest bug", as that suggests
> > KVM is punting on error handling, which is not the case.  Targeting a
> > non-existent vCPU or no vCPUs _may_ be a guest software bug, but whether
> > or not it's a guest bug is irrelevant.  Such behavior is architecturally
> > legal and thus needs to faithfully emulated by KVM (and it is).
> 
> I don't want to pick a fight,

Please don't hesitate to push back, I would much rather discuss points of contention
than have an ongoing, silent battle through patches.

> but personally these things *are* guest bugs / improper usage of APIC, and I
> don't think it is wrong to document them as such.

If the guest is intentionally exercising an edge case, e.g. KUT or selftests, then
from the guest's perspective its code/behavior isn't buggy.

I completely agree that abusing/aliasing logical IDs is improper usage and arguably
out of spec, but the scenarios here are very much in spec, e.g. a bitmap of '0'
isn't expressly forbidden and both Intel and AMD specs very clearly state that
APICs discard interrupt messages if they are not the destination.

But that's somewhat beside the point, as I have no objection to documenting scenarios
that are out-of-spec or undefined.  What I object to is documenting such scenarios as
"guest bugs".  If the CPU/APIC/whatever behavior is undefined, then document it
as undefined.  Saying "guest bug" doesn't help future readers understand what is
architecturally supposed to happen, whereas a comment like

	/*
	 * Logical IDs are architecturally "required" to be unique, i.e. this is
	 * technically undefined behavior.  Disable the optimized logical map so
	 * that KVM is consistent with itself, as the non-optimized matching
	 * logic with accept interrupts on all CPUs with the logical ID.
	 */

anchors KVM's behavior to the specs and explains why KVM does XYZ in response to
undefined behavior.

I feel very strongly about "guest bug" because KVM has a history of disregarding
architectural correctness and using a "good enough" approach.  Simply stating
"guest bug" makes it all the more difficult to differentiate between KVM handling
architecturally undefined behavior, versus KVM deviating from the spec because
someone decided that KVM's partial emulation/virtualziation was "good enough".
