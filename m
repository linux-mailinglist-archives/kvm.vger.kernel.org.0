Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F513398DC5
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 17:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbhFBPEU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 11:04:20 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:37416 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbhFBPEN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 11:04:13 -0400
Received: by mail-pl1-f176.google.com with SMTP id u7so1246245plq.4
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 08:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P21AYfjvRn1BPnlQ+AuEW3lVoQo2ATf7BrIzySahaEs=;
        b=R5gg7DhQN4H+wZF5g/WQAoR96Vr5pqvoqeMCaKveARCoeDJ1T6+yAtasV7zgdrFYoe
         ZH+1FFPbwdW0E5tpPz5SLkZJPQ9lV+3w9OVAYmro7b3Lvwh3gNdrNo85HXGjfqHXKcg0
         8AAY9zxYHN4BQOZhKJHn5qadv+Fl6sj4GLSSBS3YsKGSgbQi3Yl/vHxdiP3unlVD0hIQ
         X3yTO96Pv1Lz0/klcPi8k57bWiP5YKZoQyQjuTlebQh5U8PSMBP/K9UNsYTYySdzbNmL
         hWj/EMLazVIuu6yTrsMNp6hnGfswhrXmdfheUY44qdcLOAXNOEAGuCGEl7IsOFcYTsLA
         KDDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P21AYfjvRn1BPnlQ+AuEW3lVoQo2ATf7BrIzySahaEs=;
        b=kXC0li5oszZSLNW3bb0zts7uXR1UdEW3TBbGvTi8xH336imk4xR9BaDAk+hWAfqPyP
         wHFMvsD1bCRRe1UpylFmBbgO/uILpHwEXZlqg44X4qvzbwHhWeKY6fbCCXtfrIEadJh3
         ge0sTR4j0CDym/4YPxaG9Nhkpv0J2HVuD7M7j9YhDYktCtU3Q2/v/bHoU6bssqdsnpNj
         Xqox7QbqKQgcqeUu+fSowBfBqSZXI8jEMvzmpfvmWf1gJma/gCOCeRFYRDV2Hoq4YeSd
         wr991vzR9EuUctsq3a2fv/N9vbCAWDv4pjcoO5SgfRcegQVmnLql/OyIWsbXr70Aamkj
         tiSw==
X-Gm-Message-State: AOAM531caOWEDmredBoa9jPfTlMpa8IYCNgfvgq+APseadlBpibXtboH
        +howTHN+Iz3YEu1vbRLhbY0gLg==
X-Google-Smtp-Source: ABdhPJzijG29Y5EMgZHAl3/fJi5+zpU6KE+aKWI43cl8NwduoI35nqmdoMXkgKl3k9TWDp6kaKvQkA==
X-Received: by 2002:a17:90b:38ca:: with SMTP id nn10mr18826901pjb.127.1622646081188;
        Wed, 02 Jun 2021 08:01:21 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id e17sm3513pfi.131.2021.06.02.08.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 08:01:20 -0700 (PDT)
Date:   Wed, 2 Jun 2021 15:01:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <laijs@linux.alibaba.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH] KVM: X86: fix tlb_flush_guest()
Message-ID: <YLedPIkBvPrjguCC@google.com>
References: <20210527023922.2017-1-jiangshanlai@gmail.com>
 <78ad9dff-9a20-c17f-cd8f-931090834133@redhat.com>
 <YK/FGYejaIu6EzSn@google.com>
 <d96f8c11-19e6-2c2d-91ff-6a7a51fa1b9c@linux.alibaba.com>
 <YLA4peMjgeVvKlEn@google.com>
 <332beac2-5a0b-2e5c-f22a-7609ed98acb9@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <332beac2-5a0b-2e5c-f22a-7609ed98acb9@linux.alibaba.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 28, 2021, Lai Jiangshan wrote:
> 
> On 2021/5/28 08:26, Sean Christopherson wrote:
> > On Fri, May 28, 2021, Lai Jiangshan wrote:
> > > 
> > > On 2021/5/28 00:13, Sean Christopherson wrote:
> > > > And making a request won't work without revamping the order of request handling
> > > > in vcpu_enter_guest(), e.g. KVM_REQ_MMU_RELOAD and KVM_REQ_MMU_SYNC are both
> > > > serviced before KVM_REQ_STEAL_UPDATE.
> > > 
> > > Yes, it just fixes the said problem in the simplest way.
> > > I copied KVM_REQ_MMU_RELOAD from kvm_handle_invpcid(INVPCID_TYPE_ALL_INCL_GLOBAL).
> > > (If the guest is not preempted, it will call invpcid_flush_all() and will be handled
> > > by this way)
> > 
> > The problem is that record_steal_time() is called after KVM_REQ_MMU_RELOAD
> > in vcpu_enter_guest() and so the reload request won't be recognized until the
> > next VM-Exit.  It works for kvm_handle_invpcid() because vcpu_enter_guest() is
> > guaranteed to run between the invcpid code and VM-Enter.
> 
> Kvm will recheck the request before VM-enter.
> See kvm_vcpu_exit_request().

Ah, right, forgot requests are rechecked.  Thanks!
