Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91E94F1F1E
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 00:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240705AbiDDWax (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 18:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245161AbiDDW3S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 18:29:18 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D0A522EF
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 14:51:40 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id h7so19843927lfl.2
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 14:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NUAR6ohw0c+cB2iG3OTNJ9/QNM3sctZv6ga716kg9Qs=;
        b=CiI/2hwLVlzRwZmZQ24QW/virYnoTO28HHhkZCPbk0q70mPEbPm5thEzkvoCzzbBdR
         sh5buC1GVITJxV/Ll7JbCxKFfrqRSPZWO8H5mSof7BuhT19cEgNIyM5O+NTgxRLmy6lg
         a8Xm7KzIvEwFLoiJFB5BYunyw1eSAekwAsH+Cmc7LauP9ou8IXcbTK44QQwoAIN7WBA0
         5QscXUIFiiY6/fI5iznyG2p/G6tKvqdU51KHD4ajgv1PquooV3tl5pV0TQhVe25MkFWR
         rQnuoZAHO7EPnGmTwyjy14SNV1861P0Wvx+e879uSCS5VPOTH2xjN14mcZpJUHwQqUJO
         Svhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NUAR6ohw0c+cB2iG3OTNJ9/QNM3sctZv6ga716kg9Qs=;
        b=GVdhX4V5kaxFNna1/3FCAqcjvpooKxo5V6rvPUcSdBV9lkiRisiP8UsYgDNUN5MeWj
         xQw1v+9gOOAGVS27qN4qtGk1+kSiMFb2aTQUumb4LYCv2xxbEyh43tT9UJBC+Q/E/OI8
         ZWPfr38iq+iB+Ey+PN05CqVViSZx/659DGfd3MoazXCM9HOZSy0L0m1gnb3s2wAHWawX
         dIWWgVqg5OeqCCIBmAViSbLXvFpcaK8OC54SNYpmHTWo+W+NxaZ9B/q50lxvnGovaWiu
         6InUWo1bTGYd9kPyDEXKfClRIKUoBR0Lkx7nXJGadEzBeanBFad/8F749CQITrmIsHlD
         UPAQ==
X-Gm-Message-State: AOAM533uFRfQXh3DESrodpNnLhHsv1IwNOS/+anEmKvdEiacA0qn/MTM
        5p90yABEZxKF0iRH9t9SssuvRHVj8gIr9bpdO6ELKw==
X-Google-Smtp-Source: ABdhPJwbPMtpyxeBt2rGXgRp6yuj6edZw7T/hRyccDnC+nwnfDBpO6n5uB/Pj7tLsTFmCvrkHLz6DrRcnfHf/95aYoc=
X-Received: by 2002:a05:6512:131b:b0:44b:75d:e3d0 with SMTP id
 x27-20020a056512131b00b0044b075de3d0mr252146lfu.685.1649109098578; Mon, 04
 Apr 2022 14:51:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220404194605.1569855-1-pgonda@google.com> <YktWfUbjz27OdbUA@google.com>
In-Reply-To: <YktWfUbjz27OdbUA@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 4 Apr 2022 15:51:27 -0600
Message-ID: <CAMkAt6r+DpuFcnhVMcLnj2tEDmefdCnwUP7axdLiRomCVmdjXg@mail.gmail.com>
Subject: Re: [PATCH] KVM: SEV: Mark nested locking of vcpu->lock
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        John Sperbeck <jsperbeck@google.com>,
        David Rientjes <rientjes@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

>
> This is rather gross, and I'm guessing it adds extra work for the non-lockdep
> case, assuming the compiler isn't so clever that it can figure out that the result
> is never used.  Not that this is a hot path...
>
> Does each lock actually need a separate subclass?  If so, why don't the other
> paths that lock all vCPUs complain?
>
> If differentiating the two VMs is sufficient, then we can pass in SINGLE_DEPTH_NESTING
> for the second round of locks.  If a per-vCPU subclass is required, we can use the
> vCPU index and assign evens to one and odds to the other, e.g. this should work and
> compiles to a nop when LOCKDEP is disabled (compile tested only).  It's still gross,
> but we could pretty it up, e.g. add defines for the 0/1 param.

I checked and the perf vCPU subclassing is required. If I just only
use a SINGLE_DEPTH_NESTING on the second VM's vCPUs I still see the
warning.

This odds and evens approach seems much better. I'll update to use
that in the V2 unless there is a better idea.
