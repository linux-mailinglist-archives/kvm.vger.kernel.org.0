Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA3B388079
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 21:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351842AbhERTZr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 15:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346055AbhERTZo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 15:25:44 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F9FC061573
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 12:24:25 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso2227239pjx.1
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 12:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r5Jk+9Ja+kn0VHFuLnbq34Qrw9ShVEHa6rhQvetZyQY=;
        b=W2or1ahYnIFqgo0AiCmxrnFPCtu43CiGXJ6jy7l9dWtdlzjQ1+AxotfO+umlsoOdWW
         2vse/gU6FAjBWawxyMBSuI+wZ93MVdfknmitBW1A1XIoqE6iQ9/FjqgvN5m15EOWvW59
         PnX9x/0BI+A/1LZ0HyApBzpjfhStcel35joRAOJ642HSOwPe48wHvuIfdcV1NDaNUDbG
         5h1N36k4zHIV+DYydxjsAFlEhkgdGuhvK40NJliLNyvT3CLN/qNRoJs5i8KOb2F7wH06
         8E1IUoED+G5IWd5XdtGhQ0wq9YBMacdQW+5qpEAkGdhrNr6GTucqTQjFQCFENdoyg77p
         nUTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r5Jk+9Ja+kn0VHFuLnbq34Qrw9ShVEHa6rhQvetZyQY=;
        b=Cnt1V07I3+2hlpfbY2yKL3THn4/f4L9udd2lAMyWJ6S6gphYHJd9RHIYZaP7VExBWO
         qEYRIQJMr9B7Bp/vemNNpigrnWt6ZgCUKS4QVR58JJHNrYD91XU1Uod/FLvzvRZf7FW1
         67hOv/hrWsDMFLI56euzu5dO2ZbvtzpI8Hm8BkDbynX4dhpk5uLJxPTPgVNmOslMj0gx
         lQCMTK+ecSC3U+hiydCXaIHzUi6xeGFp3vNZFFj/rP1XJ4PfZIVFGO9+VejPRtJJAUS3
         KhcsjmZFjz48RIogyTw9ETk0NaltU8snuQIVGIJ2CNKegel0zJEagOQE57mpUocBNb9F
         3FfQ==
X-Gm-Message-State: AOAM533B6txjIsfhZ5n41Ou9OpFqAy21UuBz2xPchw7ocZNJa1HlwFnQ
        bHJVKAyVLodOLoZ9qqfnhEz4HQ==
X-Google-Smtp-Source: ABdhPJxc3ZNUABU74g4MkROq1xAEn6f0RnT3SGzwbKXOjV5nZA5lW+lo8QCbwlhpEDeLu0oG/tWc7A==
X-Received: by 2002:a17:902:dac9:b029:f2:bda7:a4b8 with SMTP id q9-20020a170902dac9b02900f2bda7a4b8mr6229831plx.15.1621365864386;
        Tue, 18 May 2021 12:24:24 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id o9sm13652828pfh.217.2021.05.18.12.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 12:24:23 -0700 (PDT)
Date:   Tue, 18 May 2021 19:24:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 03/15] KVM: SVM: Inject #UD on RDTSCP when it should be
 disabled in the guest
Message-ID: <YKQUZF8Ejxh7Eytg@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
 <20210504171734.1434054-4-seanjc@google.com>
 <CALMp9eSvXRJm-KxCGKOkgPO=4wJPBi5wDFLbCCX91UtvGJ1qBg@mail.gmail.com>
 <YJHCadSIQ/cK/RAw@google.com>
 <1b50b090-2d6d-e13d-9532-e7195ebffe14@redhat.com>
 <CALMp9eSSiPVWDf43Zed3+ukUc+NwMP8z7feoxX0eMmimvrznzA@mail.gmail.com>
 <4a4b9fea4937da7b0b42e6f3179566d73bf022e2.camel@redhat.com>
 <YJlluzMze2IfUM6S@google.com>
 <1245ad2f-78b2-a334-e36a-524579274183@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245ad2f-78b2-a334-e36a-524579274183@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 18, 2021, Paolo Bonzini wrote:
> On 10/05/21 18:56, Sean Christopherson wrote:
> > On Mon, May 10, 2021, Maxim Levitsky wrote:
> > > On Tue, 2021-05-04 at 14:58 -0700, Jim Mattson wrote:
> > > > On Tue, May 4, 2021 at 2:57 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > > > > On 04/05/21 23:53, Sean Christopherson wrote:
> > > > > > > Does the right thing happen here if the vCPU is in guest mode when
> > > > > > > userspace decides to toggle the CPUID.80000001H:EDX.RDTSCP bit on or
> > > > > > > off?
> > > > > > I hate our terminology.  By "guest mode", do you mean running the vCPU, or do
> > > > > > you specifically mean running in L2?
> > > > > > 
> > > > > 
> > > > > Guest mode should mean L2.
> > > > > 
> > > > > (I wonder if we should have a capability that says "KVM_SET_CPUID2 can
> > > > > only be called prior to KVM_RUN").
> > > > 
> > > > It would certainly make it easier to reason about potential security issues.
> > > > 
> > > I vote too for this.
> > 
> > Alternatively, what about adding KVM_VCPU_RESET to let userspace explicitly
> > pull RESET#, and defining that ioctl() to freeze the vCPU model?  I.e. after
> > userspace resets the vCPU, KVM_SET_CPUID (and any other relevant ioctls() is
> > disallowed.
> > 
> > Lack of proper RESET emulation is annoying, e.g. userspace has to manually stuff
> > EDX after vCPU creation to get the right value at RESET.  A dedicated ioctl()
> > would kill two birds with one stone, without having to add yet another "2"
> > ioctl().
> 
> That has a disadvantage of opting into the more secure behavior, but we can
> do both (forbidding KVM_SET_CPUID2 after both KVM_RUN and KVM_RESET).

Doesn't changing KVM_SET_CPUID2 need to be opt-in as well, e.g. if the strict
behavior is activated via a capability?
