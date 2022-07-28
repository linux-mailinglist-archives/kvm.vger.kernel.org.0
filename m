Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B99584810
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 00:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiG1WP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 18:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiG1WP5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 18:15:57 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0E471BE9
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 15:15:55 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id t2so2987763ply.2
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 15:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=laf7q6oYf9Z/b7tIx3bAIteJTyiMhy6ysUSu6EBmMNA=;
        b=QsQ3KOE3m4TyTQM9LsLSBtiJete862hT/8UaEei6hLSwJKu4h3rNuFCUwCAWIlc0SC
         cEAVZxb+jZu/1fmYw8X+W8v2J03cYYEExzIdBU2h54bnDKvcJa9Pq/ah32XkpVJFv4iK
         +XR9jyfqM4Z/gd0tzKDjIXygZLdYSIlQltOTxD353HAnFsEJc2Igz36tsacf/WTmknaI
         yOIV3qjfBE3h5GYBWut4osLaTLDQKH5qHfTF+BLO0NgpryS5GNwhn+zRmX8OzxBcsmCi
         CQRNjguPjuq0luMYZE/l8T9MmqsSk9Qi6tHUOBD3r5qYO+unzv1xOgKJVkMfUYeeFvk9
         vOBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=laf7q6oYf9Z/b7tIx3bAIteJTyiMhy6ysUSu6EBmMNA=;
        b=W1Y/4+2FK1BpK76MAufMo+RWiyHO77DiAkyxi756+SE2eSm9Byr0Vp+5Dv3oKByni3
         mzpZgkP7zN4DsEDabcWu53tPXOcuFfEfFOw1+zHVcTfw2a9nzTWLx+WT1JY14S6Vk+oN
         DN0NrR53QFzSXkxrnOmtyBRGNt7OgLjjVwB55Kf5UAYPa7uy/xtOPppe0NJNt07JvExK
         Nv3oRIqazfThXepBbI0sIcR6u26UhtmrMOU7Q6cSR8KEVMLpU1YKd95gT3KtcNMelUjk
         HpPa+d42kdvn60sV6T6k9mzJzjP6GTCuX/lGBc5jdpYSlc8riAYCnf/o2i9+CSgSDHZD
         gyvQ==
X-Gm-Message-State: ACgBeo2Dz4awzJRrbR55r2cmoXrtfU07dO5cQLTaEwLaeiHkVRifP2fg
        V/x9A/+2A2acp6y1APKVKIOW/w==
X-Google-Smtp-Source: AA6agR6FfSskFiyfO/E1DIFwz7UVDF7Dn+XrWExgacvqoWghopf6dEHUlkvMi1u/gzsTY71gyEb1LQ==
X-Received: by 2002:a17:902:ecc7:b0:16d:66eb:bb88 with SMTP id a7-20020a170902ecc700b0016d66ebbb88mr936716plh.170.1659046554544;
        Thu, 28 Jul 2022 15:15:54 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ft18-20020a17090b0f9200b001f2f64eada6sm1492299pjb.51.2022.07.28.15.15.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 15:15:54 -0700 (PDT)
Date:   Thu, 28 Jul 2022 22:15:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yosry Ahmed <yosryahmed@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 0/6] KVM: x86: Apply NX mitigation more precisely
Message-ID: <YuMKllD5KXM7A4YU@google.com>
References: <20220723012325.1715714-1-seanjc@google.com>
 <08c9e2ed-29a2-14ea-c872-1a353a70d3e5@redhat.com>
 <YuL9sB8ux88TJ9o0@google.com>
 <f8ccb892-cf79-62df-2752-2333467245cd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8ccb892-cf79-62df-2752-2333467245cd@redhat.com>
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

On Fri, Jul 29, 2022, Paolo Bonzini wrote:
> On 7/28/22 23:20, Sean Christopherson wrote:
> > 
> > Anyways, the bug we really care about is that by not precisely checking if a
> > huge page is disallowed, KVM would refuse to create huge page after disabling
> > dirty logging, which is a very noticeable performance issue for large VMs if
> > a migration is canceled.  That particular bug has since been unintentionally
> > fixed in the TDP MMU by zapping the non-leaf SPTE, but there are other paths
> > that could similarly be affected, e.g. I believe zapping leaf SPTEs in response
> > to a host page migration (mmu_notifier invalidation) to create a huge page would
> > yield a similar result; KVM would see the shadow-present non-leaf SPTE and assume
> > a huge page is disallowed.
> 
> Ok, thanks.  So this will be 5.21 material even during the -rc phase

Yes, this definitely needs more time in the queue before being sent to Linus.
