Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B62F555E74C
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 18:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345308AbiF1Ole (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 10:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235217AbiF1Old (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 10:41:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 829202A268
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 07:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656427291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=48PU0cYYAauvmPMjEHk3daV8QUhCzNTdWpVHcu7cu+c=;
        b=Qi7ip8PQw3v9Q/Z4bp6Ool89coQoQ16JkHQA29SrD7m2jEXCsVwUEBodyFWNfVQhGnUS42
        oo8d9Popwz+W3DBAes/DzjAbAxdU0W45AxukJSHsWju5Z15kKAZTIiqq/30l3eoxIX8DEu
        6xoEeyIqJA3GzI4YpDxcblo9y3UC5dE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-464-y19ERSOqOQKF1avHceko7A-1; Tue, 28 Jun 2022 10:41:27 -0400
X-MC-Unique: y19ERSOqOQKF1avHceko7A-1
Received: by mail-wm1-f70.google.com with SMTP id z11-20020a05600c0a0b00b003a043991610so4844997wmp.8
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 07:41:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=48PU0cYYAauvmPMjEHk3daV8QUhCzNTdWpVHcu7cu+c=;
        b=B73k8l/5vFhGXTlXGu4qcJRJ4Hay7YLOmDVs7UODh9N6rCrbbPZGlJ0U0OHcae1Ju8
         clZVOJLnksJHXod5W57eRLF9xOjiU3/CrJLRCDl27cW3td/2pyvHQIGSR0zg9Ld+YMWl
         CxAFrOq0XwbRuiuv69BXsIsIHhoydGlOrcb1YpbNe8qT3xT13mrWbK6imK1kATCCIniN
         X96C1d+7tDZlngCVKWYIqAvAmLV8NG5aXhMCeBDdornXeHPtrHTNcoE8rqsexS8VxNJB
         /LEDYRT+A26Bie668/Bl1RKQnVlKjPv8I/uDo2jgOBXzkysVRIhqGjKIjlSVuV3FHL9I
         JT4g==
X-Gm-Message-State: AJIora/tOnGFrWqd5/ehCXWKztTBP4Y4VIl0MV0iE6Y15jC3Oiehx6c9
        7AtB8HBzsrmFXVVaiakJ27A46Zf5kSY0RWnHW6YfuhJVH/n6ozLap+V91sr2l27Dj3Ai8REaKuu
        ehFyyzq/I3KFh
X-Received: by 2002:a7b:c196:0:b0:3a0:3d46:4620 with SMTP id y22-20020a7bc196000000b003a03d464620mr24935513wmi.26.1656427285899;
        Tue, 28 Jun 2022 07:41:25 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u6jxItwk84c1RRYlUduqIBWNfAYYgWtgW4dA6EO+OmDjkEApm15lVFsnccLCGmyL7yp+p2yQ==
X-Received: by 2002:a7b:c196:0:b0:3a0:3d46:4620 with SMTP id y22-20020a7bc196000000b003a03d464620mr24935491wmi.26.1656427285627;
        Tue, 28 Jun 2022 07:41:25 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id h13-20020adff4cd000000b002103aebe8absm13797860wrp.93.2022.06.28.07.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 07:41:25 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <joro@8bytes.org>, babu.moger@amd.com,
        den@virtuozzo.com, ptikhomirov@virtuozzo.com,
        alexander@mihalicyn.com, Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [RFC] SVM: L2 hang with fresh L1 and old L0
In-Reply-To: <20220628172342.ffbb5b087260ef3046797492@virtuozzo.com>
References: <20220628172342.ffbb5b087260ef3046797492@virtuozzo.com>
Date:   Tue, 28 Jun 2022 16:41:24 +0200
Message-ID: <87r138u9yj.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> writes:

> Dear friends,
>
> Recently, we (in OpenVZ) noticed an interesting issue with
> L2 VM hang on RHEL 7 based hosts with SVM (AMD).
>
> Let me describe our test configuration:
> - AMD EPYC 7443P (Milan) or AMD EPYC 7261 (Rome)
> - RHEL 7 based kernel on the Host Node.
> ... and most important:
>
> L0 -----------> L1 --------> L2
> RHEL 7       -> RHEL 7 --------> RHEL 7        *works*
> RHEL 7       -> RHEL 7 --------> RHEL 8        *works*
> RHEL 7       -> RHEL 7 --------> recent Fedora *works*
> RHEL 7       -> RHEL 8 --------> RHEL 7        *L2 hang*
> RHEL 7       -> fresh Fedora --> RHEL 7        *L2 hang*
>
> or even more:
> RHEL 7       -> RHEL 7 --------> *any tested Linux guest*  *works*
> RHEL 7       -> RHEL 8 --------> *any tested Linux guest*  *L2 hang*
>
> but at the same time:
> RHEL 8       -> RHEL 8 --------> *any tested Linux guest*  *works*
>
> It was the key observation and I've started bisecting L1 kernel to find
> some hint. It was commit:
> c9d40913 ("KVM: x86: enable event window in inject_pending_event")
>
> At the same minute I've tried to revert it for CentOS 8 kernel and retry test,
> and it... works! To conclude, if we have an *old* kernel on host and *sufficiently new* kernel
> in L1 then L2 totaly broken (only for SVM).
>
> I've tried to port this patch for L0 kernel and check if it will fix the issue. And yes,
> it works. I wonder if it will be useful information for KVM developers and users.
>
> My attempt to port it for RHEL 7 kernel:
> https://lists.openvz.org/pipermail/devel/2022-June/079776.html

Thanks for the investigation!

FWIW, nesting was never supported in RHEL7. It was disabled by default
and only worked to certain extent on Intel. By the time we stopped
rebasing KVM in RHEL7, nested SVM was still a trainwreck, even upstream.

>
> Possibly I need to port this patches for stable kernels too and send it?
>
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=v4.9.320&qt=grep&q=enable+event+window+in+inject_pending_event
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=v4.14.285&qt=grep&q=enable+event+window+in+inject_pending_event
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=v4.19.249&qt=grep&q=enable+event+window+in+inject_pending_event
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=v5.4.201&qt=grep&q=enable+event+window+in+inject_pending_event
>
> So, 4.9, 4.14, 4.19 and 5.4 kernels lacks this patch.

Personally, I wouldn't bother with anything below 5.4, nSVM is in very
poor shape there, fixing one problem will just create an illusion that
it is 'supported'. 

>
> I've not checked that yet but it looks like, for instance,
>
> L0  -> L1   -> L2
> 5.4 -> 5.10 -> *any kernel version*
>
> setup will hang for SVM.

Cc: Max who fixed a long list of issues on nSVM.

-- 
Vitaly

