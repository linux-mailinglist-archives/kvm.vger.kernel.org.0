Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDA17C45FB
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 02:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344316AbjJKAU6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 20:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344298AbjJKAU5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 20:20:57 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A689E
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 17:20:54 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c9b3c3fb61so11307945ad.1
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 17:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696983653; x=1697588453; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NjUMjsAYLN4K0CcCNb5snEZI995WI0FNghN2u45/SBY=;
        b=dHZpnfKEYQzgGVnbawYcBTPx/g54aNef4o6kA+Fihhs51H6tAPqPzqDCR1YAdpmIUB
         WK1pq0dDdxNl0TUQPCSZlLHv5M6R/QYDahDrVLNfysrfIvYLYMBdpBC4bL/6zCBx6WIz
         K6NgO1gusVZLJ8G0EAuRSEAu31pLWDJOuN9ON4YviFHqKm5bbRQkiUkpcKkmN5l+iPd+
         FiwrkYeXmqyniGIYpJJXCoBLIz6dC8tzlI1sJo5/LkMnhk13m4+lL1fq8U0xPLsV3EXY
         vKeNSqXl7gcmt+OTe056FWWiIbQBDtIcWRxMapLhg3B9oFxG9iS+2T+7TOE/leGJILuN
         5y/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696983653; x=1697588453;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NjUMjsAYLN4K0CcCNb5snEZI995WI0FNghN2u45/SBY=;
        b=kVJTLmbxd/w64U/rKPDvvxbsn6HIWZD379dGgn4VA9IldtfsH2JlVwTLeZ20PsCS7f
         mUQ3JszZAD7ZzTOvYr2+1Z2ZVU5KkrHZ5zfzryH5Kj9XZJCW7jh+7ELp6q6dPa5citnK
         Id89lHqdIsWYzzdDZ4uUKcO58jvP37oIzxR4xETuVhVWgZPR5JCteMchJ0JntSBu7z2u
         Z/4rCv5vmUL99nAaxOZIQ8E/iIGcYttl3g+QzDGkcYGVzHyaTRcqSjF96NMB/P3KxFVc
         ojhfHONYGeJ/CvY8F4p39yrlyxcRUIylccpvfVEFtQScP/1OShqxP+FVMD2tEDSgb8Bo
         61kA==
X-Gm-Message-State: AOJu0Yy2AEjnNAxwXSAOWUugZ82gH61dKV0QSVOfBwpVv01O8sWZcUMw
        jAgoyzDLW/q9asJPWvsmdX0KcCB8660=
X-Google-Smtp-Source: AGHT+IGwLtnDmC28NCSg2AVFLpJ3UBf3B6IMr/OFOnVMHIFnCSzPjYdXJMKirrwFqBrbKyqAjmKEeIh8Ux0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4cd:b0:1c7:3462:ce8d with SMTP id
 o13-20020a170902d4cd00b001c73462ce8dmr351524plg.10.1696983653618; Tue, 10 Oct
 2023 17:20:53 -0700 (PDT)
Date:   Tue, 10 Oct 2023 17:20:52 -0700
In-Reply-To: <34057852-f6c0-d6d5-261f-bbb5fa056425@oracle.com>
Mime-Version: 1.0
References: <a461bf3f-c17e-9c3f-56aa-726225e8391d@oracle.com>
 <884aa233ef46d5209b2d1c92ce992f50a76bd656.camel@infradead.org>
 <ZRrxtagy7vJO5tgU@google.com> <52a3cea2084482fc67e35a0bf37453f84dcd6297.camel@infradead.org>
 <ZRtl94_rIif3GRpu@google.com> <9975969725a64c2ba2b398244dba3437bff5154e.camel@infradead.org>
 <ZRysGAgk6W1bpXdl@google.com> <d6dc1242ff731cf0f2826760816081674ade9ff9.camel@infradead.org>
 <ZR2pwdZtO3WLCwjj@google.com> <34057852-f6c0-d6d5-261f-bbb5fa056425@oracle.com>
Message-ID: <ZSXqZOgLYkwLRWLO@google.com>
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock periodically
From:   Sean Christopherson <seanjc@google.com>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Joe Jin <joe.jin@oracle.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 04, 2023, Dongli Zhang wrote:
> > And because that's not enough, on pCPU migration or if the TSC is unstable,
> > kvm_arch_vcpu_load() requests KVM_REQ_GLOBAL_CLOCK_UPDATE, which schedules
> > kvmclock_update_fn() with a delay of 100ms.  The large delay is to play nice with
> > unstable TSCs.  But if KVM is periodically doing clock updates on all vCPU,
> > scheduling another update with a *longer* delay is silly.
> 
> We may need to add above message to the places, where
> KVM_REQ_GLOBAL_CLOCK_UPDATE is replaced with KVM_REQ_CLOCK_UPDATE in the patch?

Yeah, comments are most definitely needed, this was just intended to be a quick
sketch to get the ball rolling.

> > -static void kvm_gen_kvmclock_update(struct kvm_vcpu *v)
> > -{
> > -	struct kvm *kvm = v->kvm;
> > -
> > -	kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
> > -	schedule_delayed_work(&kvm->arch.kvmclock_update_work,
> > -					KVMCLOCK_UPDATE_DELAY);
> > -}
> > -
> >  #define KVMCLOCK_SYNC_PERIOD (300 * HZ)
> 
> While David mentioned "maximum delta", how about to turn above into a module
> param with the default 300HZ.
> 
> BTW, 300HZ should be enough for vCPU hotplug case, unless people prefer 1-hour
> or 1-day.

Hmm, I think I agree with David that it would be better if KVM can take care of
the gory details and promise a certain level of accuracy.  I'm usually a fan of
punting complexity to userspace, but requiring every userspace to figure out the
ideal sync frequency on every platform is more than a bit unfriendly.  And it
might not even be realistic unless userspace makes assumptions about how the kernel
computes CLOCK_MONOTONIC_RAW from TSC cycles.

 : so rather than having a user-configured period for the update, KVM could
 : calculate the frequency for the updates based on the rate at which the clocks
 : would otherwise drift, and a maximum delta? Not my favourite option, but
 : perhaps better than nothing?
