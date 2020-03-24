Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 708B4191957
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 19:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbgCXSmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 14:42:36 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40815 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727318AbgCXSmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 14:42:36 -0400
Received: by mail-wm1-f67.google.com with SMTP id a81so4662558wmf.5
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 11:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pPtwMbJxrA1Es8ak0yumoRvEWX0T2QU5/hT413522OM=;
        b=NI5YdHzmFt8MJznP4pojeq6KTnqd6bmIu2KrxmmLL1Xe2tr97ui/97+nEp55ClKB3A
         873nWHtQXnaK/FX5EzwDrasARNrqwER0pd3f7CRkAouFGcpVFQkMlYif+tTNPzSaz3us
         uS3/+WbLU5Q3bdhR8HkD65f/pkj8xXKg8MaFF5hnUjVgH7VH/j/XV2iBinR/ummxg4sZ
         dtIGVSnPgJCL0JvVKo3PD1Fh1+wrNDfPW00mF9RjB3twX9vbQd3Dhhoxn0NbtIJN1Yr3
         lPpOrd4Nskw3MoXDsIS+nUC8rfZQv2RFfR3ajZ46SDPVl/aJNryZLDoSrG6xfQZKJk18
         Ss4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pPtwMbJxrA1Es8ak0yumoRvEWX0T2QU5/hT413522OM=;
        b=sdn52jZ1xMHMXDjVXtVvKLY22zVZ0lM86tND4YYHxZHVUeztph94UvcMwjolNKt3Hn
         s2HbE9QVz1hW48SK23V6FUkyi/QuzffB8udxKUf9o5MEwtaAl9FGkwAD0neWTwhoM0V/
         wFM387Inyz821vZj23HNdBLcEghdtxzMxxL9BuCO8V+tB8zKdJZMM15d9ez/VH9dyaP7
         QT+8CMu1pEz3KtFF9RMSwFJOzqsKsjPhlSNd12vwxV3SWI3GjleB97NZn0OQ/7PHYsN0
         KZa4jK77nen/R/SDHyH3DOmIoeS9M9k0YAoIJeHc4DjPCK7x6Sz5G5+7dbhF7YrPSMvc
         l7oQ==
X-Gm-Message-State: ANhLgQ3yvrlX7ElWWsKXKsASLWqg31PmfPyWGREbYGUzyRMz8P5dvwhc
        rm9Ye6YKagwntIQT9mLPOyGJkL4FP3Auvri8WDWOBw==
X-Google-Smtp-Source: ADFU+vs4sQRYA41bjiNHunaQN2sONVEfP7brWVrPfFBwzK5q8MTUlZRXbUkGnnDCfaae5S4dUZwF76luoNfQxU9kSTE=
X-Received: by 2002:a1c:bcd4:: with SMTP id m203mr7106648wmf.35.1585075353851;
 Tue, 24 Mar 2020 11:42:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200324094154.32352-1-joro@8bytes.org> <20200324183007.GA7798@linux.intel.com>
In-Reply-To: <20200324183007.GA7798@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 24 Mar 2020 11:42:21 -0700
Message-ID: <CALMp9eRYNH+=Ra=1KSJdT5Ej5kTfdV8J7Rf6JcS9NGbPOYPj8A@mail.gmail.com>
Subject: Re: [PATCH 0/4] KVM: SVM: Move and split up svm.c
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 24, 2020 at 11:30 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Mar 24, 2020 at 10:41:50AM +0100, Joerg Roedel wrote:
> > Hi,
> >
> > here is a patch-set agains kvm/queue which moves svm.c into its own
> > subdirectory arch/x86/kvm/svm/ and splits moves parts of it into
> > separate source files:
>
> What are people's thoughts on using "arch/x86/kvm/{amd,intel}" instead of
> "arch/x86/kvm/{svm,vmx}"?  Maybe this won't be an issue for AMD/SVM, but on
> the Intel/VMX side, there is stuff in the pipeline that makes using "vmx"
> for the sub-directory quite awkward.  I wasn't planning on proposing the
> rename (from vmx->intel) until I could justify _why_, but perhaps it makes
> sense to bundle all the pain of a reorganizing code into a single kernel
> version?

Doesn't VIA have some CPUs that implement VMX?
