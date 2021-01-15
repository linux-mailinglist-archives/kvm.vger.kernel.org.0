Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF892F832A
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 18:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbhAOR6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 12:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbhAOR63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 12:58:29 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797C7C0613D3
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 09:57:49 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id w1so6542040pjc.0
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 09:57:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uEflp91SYEJEoNcnlfy5sa1fP5kmkuZCXVCSskOFlC0=;
        b=ef0SziCCt1lkNSKK0R2jZx4Sw8hjm9L2wzdjpzq4IQaPH36hpLM5s0vnieW9z5ZpB9
         da9hsXQ/zJ0+Fp/SUDT4O+0P2hwa5WfyUJz95cvFRn0X7CNpS0ru+U1zbSTNFaCyKYw+
         98AxW3+SW3nz/e9ES33250BC6DW22qwOxZ2ou8zEPkuMTH3hPysZT+q0vrsdysHw9nG0
         4Sn/BUxxHz1siIU8eDu3mPCJ7/RQ+wzC0kcr9xUnrbMwHg/HcmacvZ324eV9+u1s3ctN
         mzYH9d56EYPctpqCa2ZmNJe7KimcbBfmKMrQ9rtT6WFM6U+rKMCXHJHgfzIbdu7IaFFh
         VlGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uEflp91SYEJEoNcnlfy5sa1fP5kmkuZCXVCSskOFlC0=;
        b=NwY/HRoR6pNkcKDRTgweoUqr2/Bxu6N+PoWN9weQQUMf+eYqEwgktnVZ3T86/WU5aZ
         0ATZm9Tp92B/gLnRlrkug9NyjPMBTWF9McXnzBUBD3fccW+T1bDV0hFUU4C+Zkyi7SVF
         0Ze7bVh/NopBXQpIQK/23bvZU2qnVkPwttxhsmD4UCggeM75plvRszzfAgzQhDM87MTy
         EwcVxmqhX8X9bizjdyhtNmxKz9ZasYmpb2+KFsTFlZETTLt0iJVtEAL4eQlcFLaKVwYX
         oAohhkWE5dGvHdtiiYL+/sW3pthv/QY40bH5rPbPfrN+XJMyhjghx3tbT9UXYooN2JCU
         iLnw==
X-Gm-Message-State: AOAM530GloF3o3DJOX0J5X2bVSR1aWg1wABKwT7ElCQxY10z2Ps75hy9
        1h8tqNOdJuOJCsciQSuUJDv7fQ==
X-Google-Smtp-Source: ABdhPJx5AHJi8xLqblPt4mK/T3MI+zTtlRSpgv7rxkVTIYJlnurw/CfsDVR0EzhgrGajzNlyYO8ZBg==
X-Received: by 2002:a17:90a:9918:: with SMTP id b24mr11761239pjp.108.1610733468909;
        Fri, 15 Jan 2021 09:57:48 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id f67sm8773844pfg.159.2021.01.15.09.57.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 09:57:48 -0800 (PST)
Date:   Fri, 15 Jan 2021 09:57:41 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Andi Kleen <andi@firstfloor.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/17] KVM: x86/pmu: Add support to enable Guest PEBS
 via DS
Message-ID: <YAHXlWmeR9p6JZm2@google.com>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <YACXQwBPI8OFV1T+@google.com>
 <f8a8e4e2-e0b1-8e68-81d4-044fb62045d5@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8a8e4e2-e0b1-8e68-81d4-044fb62045d5@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 15, 2021, Xu, Like wrote:
> Hi Sean,
> 
> Thanks for your comments !
> 
> On 2021/1/15 3:10, Sean Christopherson wrote:
> > On Mon, Jan 04, 2021, Like Xu wrote:
> > > 2) Slow path (part 3, patch 0012-0017)
> > > 
> > > This is when the host assigned physical PMC has a different index
> > > from the virtual PMC (e.g. using physical PMC1 to emulate virtual PMC0)
> > > In this case, KVM needs to rewrite the PEBS records to change the
> > > applicable counter indexes to the virtual PMC indexes, which would
> > > otherwise contain the physical counter index written by PEBS facility,
> > > and switch the counter reset values to the offset corresponding to
> > > the physical counter indexes in the DS data structure.
> > > 
> > > Large PEBS needs to be disabled by KVM rewriting the
> > > pebs_interrupt_threshold filed in DS to only one record in
> > > the slow path.  This is because a guest may implicitly drain PEBS buffer,
> > > e.g., context switch. KVM doesn't get a chance to update the PEBS buffer.
> > Are the PEBS record write, PEBS index update, and subsequent PMI atomic with
> > respect to instruction execution?  If not, doesn't this approach still leave a
> > window where the guest could see the wrong counter?
> 
> First, KVM would limit/rewrite guest DS pebs_interrupt_threshold to one
> record before vm-entry,
> (see patch [PATCH v3 14/17] KVM: vmx/pmu: Limit pebs_interrupt_threshold in
> the guest DS area)
> which means once a PEBS record is written into the guest pebs buffer,
> a PEBS PMI will be generated immediately and thus vm-exit.

I'm asking about ucode/hardare.  Is the "guest pebs buffer write -> PEBS PMI"
guaranteed to be atomic?

In practice, under what scenarios will guest counters get cross-mapped?  And,
how does this support affect guest accuracy?  I.e. how bad do things get for the
guest if we simply disable guest counters if they can't have a 1:1 association
with their physical counter?
