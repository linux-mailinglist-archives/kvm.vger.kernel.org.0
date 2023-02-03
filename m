Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6689A68A432
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 22:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbjBCVGk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 16:06:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233010AbjBCVGY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 16:06:24 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065E1AF51B
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 13:03:45 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id v6-20020a17090ad58600b00229eec90a7fso8942257pju.0
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 13:03:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VP4/d3Y0Oqxsvz7Ftjj2BwTWqxgaXGOrnNFEq4FE3dU=;
        b=QO4R8KsHTxyL5z8Huk798ZeR6tHbP7t8MPYHoYmmjpIasgvTEKtbj4o8s1hb/77oVL
         GMgRrJLH+zRO1iickOIWDfT8oTgVv5+uQKQlw/Ck4Pm7rTGOEx2bIkD4Ebib7710No+a
         +o12MSKGByhdJX8HgZ77+zCGNZZgENejJG6sw8c+etR04Ngj0jLMD8i6dSwbcrY2J1v4
         zPgj48WxkJPHLqsHWq1jDtN0cgHzWcKV9Fs7YmeXu9loWbrddugVP8SNMwF7cMXRkQYY
         H+gDqAHy0P93Ut/u3ROlSTKbqaOnLl1y59sTKM9yrpuLwCjGfVsQahDGL+SKsw79Ud02
         ubOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VP4/d3Y0Oqxsvz7Ftjj2BwTWqxgaXGOrnNFEq4FE3dU=;
        b=HcaImJQL5ih1qNt0XL0M/7asaLfulAbq/ww28qanht0iSwcpzI9cjKRirOCu/dSTEm
         8FmXtp6vNMMBy6Vw1BpJ3dRWGlOgwzM6OKjMOvpNKCim39UwX1CiW5VESUBcxkczweGg
         NC4yAQ5IZylaD0mMG/Dfr/BCSIYpXMMTL48CixRM6MluqJOmfoZ0l1E/r7WKNCjCIvyd
         6trE9rCoE556valp4XpLr0tfIonJD0HmIQsDRH8oYtaiA8OFMTgQyd684lcRSHZefH0S
         XTSCqt0kAz7jXk5aHYx3zVicLZxZFRApJTLuKkcDYbaMObyRGATIsZ0um5grIe2v9O0I
         FTUg==
X-Gm-Message-State: AO0yUKVerZUWzPkixxZ1zvxqCuY87YCA6kQLLhdsBy1aXkhsaR++YzfZ
        pCqyLiUHOLgwLu/ulsz2S+Y6CHxuDOphsCw/f/U=
X-Google-Smtp-Source: AK7set9aTi4zteUq6Qmw6N81OlL7uUEGAJYUXTPDj/vmrkHjBpPjHLglXZeEUFHpscSIcH0tS0v85A==
X-Received: by 2002:a17:903:1c7:b0:198:af50:e4df with SMTP id e7-20020a17090301c700b00198af50e4dfmr26104plh.5.1675458216128;
        Fri, 03 Feb 2023 13:03:36 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n19-20020a170902969300b00198e03c3ad4sm1825758plp.278.2023.02.03.13.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 13:03:35 -0800 (PST)
Date:   Fri, 3 Feb 2023 21:03:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Weijiang <weijiang.yang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86/pmu: Disallow legacy LBRs if architectural LBRs
 are available
Message-ID: <Y912o2iB96G8K1PP@google.com>
References: <20230128001427.2548858-1-seanjc@google.com>
 <f106a06e-ae6f-2c79-df87-721817aacc02@gmail.com>
 <Y9wK/LkBYusOv1DO@google.com>
 <79bab707-6592-0c45-d21f-c3014362bb82@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79bab707-6592-0c45-d21f-c3014362bb82@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 03, 2023, Like Xu wrote:
> On 3/2/2023 3:11 am, Sean Christopherson wrote:
> > On Tue, Jan 31, 2023, Like Xu wrote:
> > > On 28/1/2023 8:14 am, Sean Christopherson wrote:
> > > > Disallow enabling LBR support if the CPU supports architectural LBRs.
> > > > Traditional LBR support is absent on CPU models that have architectural
> > > > LBRs, and KVM doesn't yet support arch LBRs, i.e. KVM will pass through
> > > > non-existent MSRs if userspace enables LBRs for the guest.
> > > 
> > > True, we have call_trace due to MSR_ARCH_LBR_FROM_0 (0x1500) for example.
> > > 
> > > > 
> > > > Cc: stable@vger.kernel.org
> > > > Cc: Yang Weijiang <weijiang.yang@intel.com>
> > > > Cc: Like Xu <like.xu.linux@gmail.com>
> > > 
> > > Tested-by: Like Xu <likexu@tencent.com>
> > > 
> > > > Reported-by: Paolo Bonzini <pbonzini@redhat.com>
> > > 
> > > Fixes: 145dfad998ea ("KVM: VMX: Advertise PMU LBRs if and only if perf
> > > supports LBRs")
> > 
> > If we want a fixes, I'd argue this is more appropriate:
> > 
> >    Fixes: be635e34c284 ("KVM: vmx/pmu: Expose LBR_FMT in the MSR_IA32_PERF_CAPABILITIES")
> > 
> > Though I'd prefer not to blame KVM, there's not much we could have done in KVM
> > to know that Intel would effectively break backwards compatibility.
> 
> Personally, I assume the bigger role of the Fix tag is to help the stable tree's
> bots make it easier to back port patches automatically, and there will be less
> sense of blame for the developers.

I don't mind adding a Fixes to aid stable, but then

  Fixes: be635e34c284 ("KVM: vmx/pmu: Expose LBR_FMT in the MSR_IA32_PERF_CAPABILITIES")

is still more correct, e.g. if there are kernel's that didn't get
145dfad998ea ("KVM: VMX: Advertise PMU LBRs if and only if perf supports LBRs")
for whatever reason.

> In pmu scope, if a feature is not "architecture", I'm not surprised that a
> new arrival will break compatibility, and sometimes kernel developers need to
> plan ahead.

Hrm, true, compatibility is usually a non-goal for uarch stuff.  I'll try to keep
that in mind for future vPMU code.

Thanks!
