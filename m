Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7286C48DBDE
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 17:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236726AbiAMQe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 11:34:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbiAMQe1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 11:34:27 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31994C061574
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 08:34:27 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id j27so324750pgj.3
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 08:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mkqNPwNyWzH/IWi5x/274HOlT+CfBnkf/fh5Mx48N7U=;
        b=ZJIJPSDPPwbxebtfbczZRnKKBZAYzlymkaeATSEkqwn8Asb2zWUlNIb2LwZBPeWcIf
         PLcDlMQGxAfViHTSvk8aSY4g+c47rtyup7vPVAJKNoquUC61XSiK1bH+VlQLn5VzdkWU
         dWAvcNWVwfF/H03VzX1AlgnSh9DcStzd50+LEXeK5lktV6S1uIun9rmkzX4muhlVdpuv
         0zZURfvq2jYk6VoYeaNXrt8eid1hXNn7AayALghAlTYRNFdBr1/8vlanbL/1xTLHU1+b
         ZB3AOot6jaC/QFzmcmWMhFmJn/98a8isZRmNvFI68QONGfnYjcCxiPTL+SbqUG3PMvQ+
         3mNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mkqNPwNyWzH/IWi5x/274HOlT+CfBnkf/fh5Mx48N7U=;
        b=0sk1Z1+pehnSeVJ90jkDq4soD0A7GHm6W+VtgLzsR4oJp80IpGmlokJQF5YBq/2G/6
         NoCue2EWqWMQummxazczATlZqwn9yrdUJRISuGFgYX/HlCH5h7C58ThfkBet3OkTpXR9
         znvtMVkCMz6weCSoquL5c7CIDIfNYuxEMpLu7Gd0j2pbuout9fSGxEFPxjdreu6DbWTv
         0I16BvcBwRLv9DHiYyX3MAW/LFb+mymHxBWO8gv/nwR6XZqz04Sl5OJvYCHTclaTFCuE
         naBOj+kjJaunSpB3iHmT8WDTg5EOPqyHEVR/zerwJlLd9fH+cWzFmJqIMwJ4jgM4/xbZ
         8pfA==
X-Gm-Message-State: AOAM531VjipQx5vBw/cVQP3gvkLiCC3OWsYAI/FhYrfwiOF4qsLTu9AI
        NdD0LtA7GakRyEI0DUG5dkKPrA==
X-Google-Smtp-Source: ABdhPJy16fWqMfRtddgMqmja4pygVtnjB2tUDY2FPN15TAZ6Mbc2iMRfm3/LmhDWGOARWvgUghdVIg==
X-Received: by 2002:a05:6a00:1783:b0:4c0:775b:e1c1 with SMTP id s3-20020a056a00178300b004c0775be1c1mr4931904pfg.36.1642091666534;
        Thu, 13 Jan 2022 08:34:26 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x23sm2945205pjd.40.2022.01.13.08.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 08:34:25 -0800 (PST)
Date:   Thu, 13 Jan 2022 16:34:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Li RongQing <lirongqing@baidu.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        tglx@linutronix.de, bp@alien8.de, x86@kernel.org,
        kvm@vger.kernel.org, joro@8bytes.org
Subject: Re: [PATCH] KVM: X86: set vcpu preempted only if it is preempted
Message-ID: <YeBUjibZ1/nZ1p0X@google.com>
References: <1641988921-3507-1-git-send-email-lirongqing@baidu.com>
 <Yd7S5rEYZg8v93NX@hirez.programming.kicks-ass.net>
 <Yd8QR2KHDfsekvNg@google.com>
 <20220112213129.GO16608@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220112213129.GO16608@worktop.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022, Peter Zijlstra wrote:
> On Wed, Jan 12, 2022 at 05:30:47PM +0000, Sean Christopherson wrote:
> > On Wed, Jan 12, 2022, Peter Zijlstra wrote:
> > > On Wed, Jan 12, 2022 at 08:02:01PM +0800, Li RongQing wrote:
> > > > vcpu can schedule out when run halt instruction, and set itself
> > > > to INTERRUPTIBLE and switch to idle thread, vcpu should not be
> > > > set preempted for this condition
> > > 
> > > Uhhmm, why not? Who says the vcpu will run the moment it becomes
> > > runnable again? Another task could be woken up meanwhile occupying the
> > > real cpu.
> > 
> > Hrm, but when emulating HLT, e.g. for an idling vCPU, KVM will voluntarily schedule
> > out the vCPU and mark it as preempted from the guest's perspective.  The vast majority,
> > probably all, usage of steal_time.preempted expects it to truly mean "preempted" as
> > opposed to "not running".
> 
> No, the original use-case was locking and that really cares about
> running.
> 
> If the vCPU isn't running, we must not busy-wait for it etc..
> 
> Similar to the scheduler use of it, if the vCPU isn't running, we should
> not consider it so. Getting the vCPU task scheduled back on the CPU can
> take a 'long' time.

Ah, thanks.  Should have blamed more, commit 247f2f6f3c70 ("sched/core: Don't
schedule threads on pre-empted vCPUs") is quite clear on this front.
