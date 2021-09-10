Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B27B407414
	for <lists+kvm@lfdr.de>; Sat, 11 Sep 2021 01:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234883AbhIJX4m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 19:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232897AbhIJX4l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 19:56:41 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5F8C061574
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 16:55:30 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id m21-20020a17090a859500b00197688449c4so2553229pjn.0
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 16:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Lj4EQSAtjojNeOo+5AIxnfhqBrNwaP0Usia46GVY1oQ=;
        b=P2Y9yL/ptNBIkgV2RV1ndLR/eMSVc/fsViMjX3kFRfgr6q4MrkOMcgd2f5ArvU/vQD
         xal7x4pdT+BNm7K7oodlNFs5rfif4USN/CVluAoxvUAYVAqL5BWnqFH8V1m9ZotHj/FV
         WEH5ZklYjE90+sxvPNoKKhV8iXPvLrqWIxSqzDfOW1nHFyDF9s3WUCMrTXud7dOLxE74
         gNBGBcSpa/95/ClNgU+Xd8QaN+ReSUJFdryu/CBrGHmAOlu0KevlhgjtxB76wKHhQLZJ
         PqoTZp9ltAYrzoPT/fX7pxFveU3Bvd9WSOGjEymXtMONBS44d4uOK7Y+JKt/VUprf0DJ
         G2YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Lj4EQSAtjojNeOo+5AIxnfhqBrNwaP0Usia46GVY1oQ=;
        b=JWfdHJd7ts7jyiRtztxTe9mvlIcUC1I3aLditMqQ0wIrwT1o4Tm7qY56ENTroCbBcX
         UsOhsL++Ds1KWOiGs3QiGdkR1A7knLP1nper4x0vYShCuaI1Wp7zamiP4DmHLMoV1llC
         G4bVskyZQdmURqU/echOy9RGuHkYEUuQwEliJT9aZlyHSg1BCwTyvcKb7JybrzcwAYpx
         ViY5sgPw2SIgTXKqgRdC6C1UaJvRskQ3VL9Y5EaR5ofVfd8EIaPj/GzfR79IQRnuf1M8
         DaQqs2bhgnG9gTaWxxNQLANf8mwr4d3QfYMMKBCuQ008gu+3HXNYhPRztMSFNDdFiWqn
         t1sQ==
X-Gm-Message-State: AOAM530xC/JJbuZ/2axxyVJvi1pl8BhoYEY8elLBzh96MtM8ePpcqoZE
        zgx8hKeZXnV0RDvjMK+WAmK1lQ==
X-Google-Smtp-Source: ABdhPJwR9DZl1UautfziIWEvTjfS+Ek/Jql8tysBLQBAE49gKvvzNab7WfTaGvKbi8veNTD7znt/4g==
X-Received: by 2002:a17:90b:198c:: with SMTP id mv12mr125644pjb.223.1631318129721;
        Fri, 10 Sep 2021 16:55:29 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n14sm60042pgd.48.2021.09.10.16.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 16:55:29 -0700 (PDT)
Date:   Fri, 10 Sep 2021 23:55:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Gao Chao <chao.gao@intel.com>
Subject: Re: [PATCH v4 6/6] KVM: VMX: enable IPI virtualization
Message-ID: <YTvwbUhofR3Fv7bV@google.com>
References: <20210809032925.3548-1-guang.zeng@intel.com>
 <20210809032925.3548-7-guang.zeng@intel.com>
 <YTvttCcfqF7D/CXt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTvttCcfqF7D/CXt@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 10, 2021, Sean Christopherson wrote:
> On Mon, Aug 09, 2021, Zeng Guang wrote:
> > +		if (!pages)
> > +			return -ENOMEM;
> > +
> > +		to_kvm_vmx(kvm)->pid_table = (void *)page_address(pages);
> > +		to_kvm_vmx(kvm)->pid_last_index = KVM_MAX_VCPU_ID;
> 
> I don't see the point of pid_last_index if we're hardcoding it to KVM_MAX_VCPU_ID.
> If I understand the ucode pseudocode, there's no performance hit in the happy
> case, i.e. it only guards against out-of-bounds accesses.
> 
> And I wonder if we want to fail the build if this grows beyond an order-1
> allocation, e.g.
> 
> 		BUILD_BUG_ON(PID_TABLE_ORDER > 1);
> 
> Allocating two pages per VM isn't terrible, but 4+ starts to get painful when
> considering the fact that most VMs aren't going to need more than one page.  For
> now I agree the simplicity of not dynamically growing the table is worth burning
> a page.

Ugh, Paolo has queued a series which bumps KVM_MAX_VCPU_ID to 4096[*].  That makes
this an order-3 allocation, which is quite painful.  One thought would be to let
userspace declare the max vCPU it wants to create, not sure if that would work for
xAPIC though.

[*] https://lkml.kernel.org/r/1111efc8-b32f-bd50-2c0f-4c6f506b544b@redhat.com
