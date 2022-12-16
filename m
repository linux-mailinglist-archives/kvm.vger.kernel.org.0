Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92CE064F0AD
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 18:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbiLPRzy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 12:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiLPRzw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 12:55:52 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADEF963C2
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 09:55:50 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d3so3020246plr.10
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 09:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KCwZeS2Ti8e0H7ZxmG6ZCIxtk35Odnz6OouMXcX+6Uk=;
        b=KKKeQoFz95yZ+BobakrMfXyAq6zwgHv9202BNKknERnA/qEZTS+kAMU9x5By0FDvIq
         HsjW+OfMy/cpSxORON7OJwRQP3GEdz2ErVpiOFeGaosV9XLaGi6mAO1ahc20xL/BnuVR
         fL8MZJrzH5UenIWvjzKtsrBuHY7GbrrUADCux53T+MIiA7X57zXIJ1ZglvcOc134xIEj
         nuQYERcXwQCawOb9O5OH1v+Z0dTD2gnBUE+pNitzoMjSuv2m4Dzu5TY5cbYsoRJmhAIb
         vr2lYoJQ2hHqxYZyYU/hCBY35TBHxbFPZf7nI5QhovDxUNLNHpjImb8j5BP/OEQM0zjn
         buQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KCwZeS2Ti8e0H7ZxmG6ZCIxtk35Odnz6OouMXcX+6Uk=;
        b=OWTCqaHYbYucDYnbJJs9l/UN4ENS8CsCrVNi8GjURiW5aPkQIIFMs7CIv6NHra0431
         Btc8/liRZBrJBYQ6ZK3j4i1U9Q8NW/CN9MMWgCbE67vspYww69rBVT21ONgx4sxVw7TQ
         hW5UCfHCWtj0i4aTUz00dZeqQNE3BdnvXRzHuGkm25JhwYCM4HXn6avNL7oQkQDKF9sm
         sYWtSv8a9+o3zO46jvqKRvyzMjiSTQI06apiGjv2Ita6s0RB9M5hssroFVyvTaSa9YIT
         iS/M6yOtT/r9nX/3xWXActmfa1n8csfz796QdlmsNygWPUKLBs/+VLoImS1X8ioriOH/
         s/pQ==
X-Gm-Message-State: AFqh2kpTSVUp0xrzgUzWtU0KNehnPAssLuBqmVQKb6uUNXpSfEGyRNTx
        eM0V7tPHt0lB0F6MHmn6Bgzquw==
X-Google-Smtp-Source: AMrXdXsZtYRRam2KEPSmBpM24X4qT1yoxC9A9h1b5c0HU7PQHqHRKTQW9wVHRj/Jttg1gkpN4WwZag==
X-Received: by 2002:a17:902:b493:b0:189:58a8:282 with SMTP id y19-20020a170902b49300b0018958a80282mr550577plr.3.1671213350070;
        Fri, 16 Dec 2022 09:55:50 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t7-20020a1709027fc700b00189f69c1aa0sm1893125plb.270.2022.12.16.09.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 09:55:49 -0800 (PST)
Date:   Fri, 16 Dec 2022 17:55:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Aaron Lewis <aaronlewis@google.com>, pbonzini@redhat.com,
        jmattson@google.com, kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 4/7] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
Message-ID: <Y5yxIcc4g8EuhtZE@google.com>
References: <20221021205105.1621014-1-aaronlewis@google.com>
 <20221021205105.1621014-5-aaronlewis@google.com>
 <3f0a7487-476c-071c-ece9-49a401982e40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f0a7487-476c-071c-ece9-49a401982e40@gmail.com>
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

On Thu, Dec 15, 2022, Like Xu wrote:
> On 22/10/2022 4:51 am, Aaron Lewis wrote:
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1178,6 +1178,7 @@ struct kvm_ppc_resize_hpt {
> >   #define KVM_CAP_S390_ZPCI_OP 221
> >   #define KVM_CAP_S390_CPU_TOPOLOGY 222
> >   #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
> > +#define KVM_CAP_PMU_EVENT_MASKED_EVENTS 224
> 
> I presume that the linux/tools code in google's internal tree
> can directly refer to the various definitions in the kernel headers.
>
> Otherwise, how did the newly added selftest get even compiled ?

Magic fairy dust, a.k.a. `make headers_install`.  KVM selftests don't actually
get anything from tools/include/uapi/ or tools/arch/<arch>/include/uapi/, the
only reason the KVM headers are copied there are for perf usage.  And if it weren't
for perf, I'd delete them from tools/, because keeping them in sync is a pain.

To get tools' uapi copies, KVM selftests would need to change its include paths
or change a bunch of #includes to do <uapi/...>.

> Similar errors include "union cpuid10_eax" from perf_event.h

I don't follow this one.  Commit bef9a701f3eb ("selftests: kvm/x86: Add test for
KVM_SET_PMU_EVENT_FILTER") added the union definition in pmu_event_filter_test.c/
