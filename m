Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80DF4A7D09
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 01:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240397AbiBCAzj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 19:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239475AbiBCAzh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 19:55:37 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50A6C061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 16:55:36 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 132so930815pga.5
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 16:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Cxi691D9vYBUyev7VlvAiD3Wf+tbocgQpf9urgiHdzc=;
        b=My+6moIq9Y1Kr6YKlQbnOQP8TEnsPlGuWfjCrGPjPTtCPYTj/K8fl7yLsHog0ebTPS
         w2dl3677O9vHXE/KLcXwoUpLQ76WM8Z8bJBFHU0RxXNnyjQG/pNzohFk1yAh7dbi8Lqd
         YWiLvxboYvrsQ3oNx6X5HivCp9spqNPr/u4w16m7ETSuN47VLMY+f0EaHgFe7RORT4h8
         r1D69SD1UWRtsiwxooNOM5N703wML6acvbXWqFwBsOnEvi7PRn6UsytSAqC66xPCjD7+
         5LR7tGOpqBxFb4X8gvwpRPoeUjiDBZ36Wh3Uz1zN+GW6QZzu2ND0poOc9ye3L2GZlrmO
         4Ajg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Cxi691D9vYBUyev7VlvAiD3Wf+tbocgQpf9urgiHdzc=;
        b=SOiELStZ0FJCpvD8xGZ3TFeGxbuo4H7NHOISBwL4syxFZG1UJBTvy9zG7ffj7xKHLD
         8XajsWOAVJ1pb0QVPz/SnR/sqGu6jsqJBQ/lCb25b4ycbbXMrj/Zbg5f85ZDTPV+l/0o
         7DB7s96hdAb0XSG/x64GpqTfZWsUkV6XPcm7wKqwcIPF/q7oGCwtwKNaB0lhTMezgWNG
         mxNdZRDY9bq7tjgcYe3gaB5W5YOwQUyKaur3QIT9L02L1BaEkxnOLY0wJi1B7BqR07J3
         cHO7LT55g+RSdRx7u4QCr/ToytE6nNJnEkEB4HFWH8A/rVP8R8Tf67jY3BlGMzWkWCs4
         ej9A==
X-Gm-Message-State: AOAM532bhTGMA0rigV+aKQOK9NW8+2B04Cf7YfX3XIqkOflE7ectQtuC
        e4KBZRaOFRFdx1TYHqDk4vUBcw==
X-Google-Smtp-Source: ABdhPJzkm7qzwWY9A39JE0Bl9tBvm8QokomUKHuQw7UIPS/1lgJaMb8Istnq6bBdz3M4nkkXR/u7xw==
X-Received: by 2002:a63:141f:: with SMTP id u31mr26792509pgl.614.1643849736140;
        Wed, 02 Feb 2022 16:55:36 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id nm14sm7573355pjb.32.2022.02.02.16.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 16:55:35 -0800 (PST)
Date:   Thu, 3 Feb 2022 00:55:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 0/4] KVM: nVMX: Fixes for VMX capability MSR invariance
Message-ID: <YfsoBECWPpP0BpOW@google.com>
References: <20220202230433.2468479-1-oupton@google.com>
 <CALMp9eRotJRKXwPp=kVdfDjGBkqMJ+6wM+N=-7WnN7yr-azvxQ@mail.gmail.com>
 <Yfsi2dSZ6Ga3SnIh@google.com>
 <CAOQ_Qsiv=QqKGr4H2dP30DEozzvmSpa1SLjX8T5vhSfv=gTy3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ_Qsiv=QqKGr4H2dP30DEozzvmSpa1SLjX8T5vhSfv=gTy3g@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 02, 2022, Oliver Upton wrote:
> On Wed, Feb 2, 2022 at 4:33 PM Sean Christopherson <seanjc@google.com> wrote:
> > MSR_IA32_FEAT_CTL has this same issue.  But that mess also highlights an issue
> > with this series: if userspace relies on KVM to do the updates, it will break the
> > existing ABI, e.g. I'm pretty sure older versions of QEMU rely on KVM to adjust
> > the MSRs.
> 
> I realize I failed to add a note about exactly this in the cover
> letter. It seems, based on the commit 5f76f6f5ff96 ("KVM: nVMX: Do not
> expose MPX VMX controls when guest MPX disabled") we opted to handle
> the VMX capability MSR in-kernel rather than expecting userspace to
> pick a sane value that matches the set CPUID. So what really has
> become ABI here? It seems as though one could broadly state that KVM
> owns VMX VM-{Entry,Exit} control MSRs without opt-in, or narrowly
> assert that only the bits in this series are in fact ABI.

I don't know Paolo's position, but personally I feel quite strongly that KVM should
not manipulate the guest vCPU model.  KVM should reject changes that put the kernel
at risk, but otherwise userspace should have full control.

> Regardless, since we must uphold this misbehavior as ABI, we have a
> regression since KVM doesn't override the MSR write if it comes after
> the CPUID write.
> 
> > I agree that KVM should keep its nose out of this stuff, especially since most
> > VMX controls are technically not architecturally tied to CPUID.  But we probably
> > need an opt-in from userspace to stop mucking with the MSRs.
> 
> Bleh, I wanted to avoid the age-old problem of naming, but alas...

I think a single quirk would suffice, e.g. KVM_X86_QUIRK_KVM_DOESNT_LIKE_TO_SHARE.
