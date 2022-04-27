Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0A25123D6
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 22:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236168AbiD0U0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 16:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235227AbiD0U0r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 16:26:47 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38B8AD10E
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 13:23:32 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id h12so2529651plf.12
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 13:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Lf9in1R/IyB6rX6jUJyTZ+zPOwsufKTBlApv7ttWWfI=;
        b=mkxmR1CbEjd7T2oSqQlrgTQGHLlxZ+wMChlXJfbXaJrep9GBLX60uCfKBbyXYGwQyY
         KDeQaI/saGyf/LQwrsxRc4jpYpOJDNAOWSHS6RjaaHaFYnWhyYzY0WUVLU0fnQ65rQ1L
         +IFWWit2h/ta/ZKMcHoXuZFGd2pAt9kJ0eIVPm2WL/+Y2ya5kO2EVd89BcXV+C2iWt2k
         8j9H7dPQ2goG7B4GUDT7ajgoo8khiZPhogewkTSA26dLrc9B4lyzV5SLazc217D393SB
         UOkHV1x8I5ReHmCKZvlenNboSq2xb/YT0q/ccK4jrEv5Sn8UVrX+fSmKgtGjVNIe16lI
         URhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Lf9in1R/IyB6rX6jUJyTZ+zPOwsufKTBlApv7ttWWfI=;
        b=go8JjYjp6RxXVquG5iEB1U7OWZehAZjGVSt9yKywKIvqXVlktERzJpv7kmAtp98tct
         dXI8oBBTEETgueqVNOGQzjQ23oZg2uLslh7DUwmJBPEOWpusCNX81BXevVbiPZycfCSA
         GBWE7/sIj9S9mxSM0pJkI7dlALIZzQ0YUUWfb+MgKRixvVo8ERtaIw7z19hRUyF+2CHT
         xs8TlxfVWz6Var2PcShwq0Kzm0idMFEvZ74Sl/h9gKnhLuO5Lo0TuF7gxSDG7S5Koup+
         sBjOa+BqFBs2y3MYoIWr6susNLwkgvlRoef9VzZGiqBdY7HpFt+aIZ1lroKvuQcpR074
         fyCg==
X-Gm-Message-State: AOAM532ZO5yJ0tqobuS/6/IcfDSw0GFnkMRA7vQw4Q32KM7m10a0iLJp
        y9eDozachm+XnKFAQcJEtfkduw==
X-Google-Smtp-Source: ABdhPJw3HiHU2l0Zxdnl8FI3SE8UUCEm63BOmZlO5wTWpPxNDy3Afc0ad7VVfEKZ63cdvh+uY/IWNA==
X-Received: by 2002:a17:902:e8cf:b0:156:36e0:6bcb with SMTP id v15-20020a170902e8cf00b0015636e06bcbmr29286930plg.105.1651091012280;
        Wed, 27 Apr 2022 13:23:32 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i23-20020a056a00225700b0050d38d0f58dsm12888790pfu.213.2022.04.27.13.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 13:23:31 -0700 (PDT)
Date:   Wed, 27 Apr 2022 20:23:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH v2 8/8] DO NOT MERGE: Hack-a-test to verify gpc
 invalidation+refresh
Message-ID: <YmmmP0TSmj5CxV06@google.com>
References: <20220427014004.1992589-1-seanjc@google.com>
 <20220427014004.1992589-9-seanjc@google.com>
 <68b3f18e156391e20aed8e10e974fdf8052b7f47.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68b3f18e156391e20aed8e10e974fdf8052b7f47.camel@infradead.org>
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

On Wed, Apr 27, 2022, David Woodhouse wrote:
> On Wed, 2022-04-27 at 01:40 +0000, Sean Christopherson wrote:
> > Add a VM-wide gfn=>pfn cache and a fake MSR to let userspace control the
> > cache.  On writes, reflect the value of the MSR into the backing page of
> > a gfn=>pfn cache so that userspace can detect if a value was written to
> > the wrong page, i.e. to a stale mapping.
> > 
> > Spin up 16 vCPUs (arbitrary) to use/refresh the cache, and another thread
> > to trigger mmu_notifier events and memslot updates.
> 
> Do you need the MSR hack? Can't you exercise this using Xen interrupt
> delivery or runstate information and the same kind of thread setup?

Yeah, I asumme it's possible, and medium/long term I definitely want to have a
proper test.  I went the hack route to get something that could hammer a cache
with minimal chance of a test bug.  I only have a rough idea of what the Xen stuff
does.
