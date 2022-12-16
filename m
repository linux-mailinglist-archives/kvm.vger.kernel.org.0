Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1138C64F0FB
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 19:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbiLPScF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 13:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiLPScD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 13:32:03 -0500
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B534A07B
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 10:32:02 -0800 (PST)
Received: by mail-vs1-xe30.google.com with SMTP id c184so3126801vsc.3
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 10:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7ILck7vL09T6k+S+HSUOg40zD4ka6Kk7RyTZ0hGkIdg=;
        b=LGFQI37+QHPxTRnEo1a4ViYYuJQ0q+XsyxnR98X0MBVEOBBgkWydwd+kATJ7VbT/iQ
         SRE1G1YTKpb5E650TpHCiMkfxyf66KYTjiLiBQiaTLuFd+2HQhsO7f6cMPyB8qkCY4YJ
         u1oJvA/COu1hga2wcpb0bh4y76n+mjhuxZ10TVlFRlMxjZ2Syx/HfwALzkroEV0NldRN
         9RAXIF179zu7O5P3b/BdzjWt/QiuSDqfUYKLVVS3e+QMbpu7yX/ak4MjKZjw7nvTil/P
         pwFj8VDh5Pan+EQHTzKGaYacdGFKb8AVs7Oq22stdyH4FfK/NiidW3GBtFprUNfJNmNz
         z43Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7ILck7vL09T6k+S+HSUOg40zD4ka6Kk7RyTZ0hGkIdg=;
        b=M8X13cJ4IOiK9fF/RrMzF6bHw+TEDX5A/o/jei4Y0RNcz4hfWI2W4cQAtuWH6D7nXl
         U7utU4uz2AQzwEWAoARGTZaJ2fTWvbc/necQ4+dOfaBKu7AMJetHUHapxRT5GUvELJu3
         yx9BWv30qR8VXhOrAxHL6uUmm7vnN5C7rzExPlKA5kKNji5MBHAJ+5GAnP0kbdpeycXq
         3KSXbVVKAQPjUGwwolEenM4rSm/KBUkeS0NIKHk1LfRMibZTacIDZbMUhvUVdrCvKnuj
         GBR5arQXQu+ptiGYrP6A1443V0IOuvir04upXOYyQeiCDOERmgkqGGEyWSuWOy3Sk2Gb
         30Xw==
X-Gm-Message-State: AFqh2krEEHwUy0EzyllcZFvHRvlxZ/tWUtPPR/I/FJ/sq17E/aeGRxqM
        xpYlnb6jjKW6EccMZohdPwi8/Ky1s8GrH4p4OdY67A==
X-Google-Smtp-Source: AMrXdXs/n8Rcl/teLsBX4II8kt1NpOqxSu7gE7NBZ7jYPpw6mCGts6NteXLx7SJq+w2KCBFjRIAsNqcqCp8Pxc+PDLE=
X-Received: by 2002:a05:6102:3e17:b0:3b5:3716:e14e with SMTP id
 j23-20020a0561023e1700b003b53716e14emr1151463vsv.18.1671215521660; Fri, 16
 Dec 2022 10:32:01 -0800 (PST)
MIME-Version: 1.0
References: <20221021205105.1621014-1-aaronlewis@google.com>
 <20221021205105.1621014-5-aaronlewis@google.com> <3f0a7487-476c-071c-ece9-49a401982e40@gmail.com>
 <Y5yxIcc4g8EuhtZE@google.com>
In-Reply-To: <Y5yxIcc4g8EuhtZE@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Fri, 16 Dec 2022 10:31:50 -0800
Message-ID: <CAAAPnDHvvCXo8qYpPFK=a7Ghtdf-Z-7sX5RmsgbRCjf_QmoYgA@mail.gmail.com>
Subject: Re: [PATCH v6 4/7] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
To:     Sean Christopherson <seanjc@google.com>
Cc:     Like Xu <like.xu.linux@gmail.com>, pbonzini@redhat.com,
        jmattson@google.com, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

On Fri, Dec 16, 2022 at 9:55 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Dec 15, 2022, Like Xu wrote:
> > On 22/10/2022 4:51 am, Aaron Lewis wrote:
> > > --- a/include/uapi/linux/kvm.h
> > > +++ b/include/uapi/linux/kvm.h
> > > @@ -1178,6 +1178,7 @@ struct kvm_ppc_resize_hpt {
> > >   #define KVM_CAP_S390_ZPCI_OP 221
> > >   #define KVM_CAP_S390_CPU_TOPOLOGY 222
> > >   #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
> > > +#define KVM_CAP_PMU_EVENT_MASKED_EVENTS 224
> >
> > I presume that the linux/tools code in google's internal tree
> > can directly refer to the various definitions in the kernel headers.
> >
> > Otherwise, how did the newly added selftest get even compiled ?
>
> Magic fairy dust, a.k.a. `make headers_install`.  KVM selftests don't actually
> get anything from tools/include/uapi/ or tools/arch/<arch>/include/uapi/, the
> only reason the KVM headers are copied there are for perf usage.  And if it weren't
> for perf, I'd delete them from tools/, because keeping them in sync is a pain.
>
> To get tools' uapi copies, KVM selftests would need to change its include paths
> or change a bunch of #includes to do <uapi/...>.
>
> > Similar errors include "union cpuid10_eax" from perf_event.h
>
> I don't follow this one.  Commit bef9a701f3eb ("selftests: kvm/x86: Add test for
> KVM_SET_PMU_EVENT_FILTER") added the union definition in pmu_event_filter_test.c

That's been replaced since posting.  The function num_gp_counters()
needs to be placed with
kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS).  I can update and
repost.
