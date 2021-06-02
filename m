Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D73398DF9
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 17:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbhFBPME (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 11:12:04 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:44628 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbhFBPMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 11:12:03 -0400
Received: by mail-pj1-f48.google.com with SMTP id h12-20020a17090aa88cb029016400fd8ad8so1961541pjq.3
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 08:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EMsAStqDMmlZbLPljNggWYrArAR/sB/EJfX3nXOrOco=;
        b=H+HhpoRrWY35FUyyvJ22tzsgwx9R7/BQsdEZbHfdAJJxfFBel8SdSHzwHQ4C1ISm5z
         KxcvuGlUqbRtPS+5NJJowh1VvrcDIL9JEABns/u4vhc8JR/ojV2usQVjrtV1TuZXF4GT
         +KyPTHXKJayNJ0nuOfXKukUTIjBHzfWJ5G3x28npkcYPz4knahTV4hHFX8BXAcTpAmDM
         XWx0+cjfStwo0kAwnrR8ILNsDA9TW2aLg3GMyvclIunTVmEefsHec9dH61GobEXkqnvK
         ZZaBoseRpuY2IfFaMZyxCE5R2IS9Zq3NSNzWFZ0OX5rh4h9uD/ituRwueuPhJ4kbGBFd
         67QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EMsAStqDMmlZbLPljNggWYrArAR/sB/EJfX3nXOrOco=;
        b=CxbrzG/8KsAieb4RIm0oGToGs8jaf7F9SVRjaHE9je6fd54tPn+430RKUYT3Qfrit/
         nkBjASytkK0F5zWoqxs9yVXqjoiz/B/YtMBNncpLwCGcsgPOjdKSKsG7LCKCB8aCARzA
         uiwBQ6Wnup6ukNRyqD0DCpuMIGVGIEtkpY+G/lLcHrIvNWk0SmvdjRYyQRmH/mL+bvo1
         lV2Kjdc16riKDUBZnx1CEMgU24WfkgK/navwf0+JxwnxU0/X+FiQmPEwVhEgt8MMweKl
         aN0o/VyJ1bC9Zb4d5Dt1DbkiEyNbvrrLWJtdQebuf0843usS4yeAsf06YbumSL+5nXfR
         xVtg==
X-Gm-Message-State: AOAM531vKhv35dHEU1iQNnoWhz0gUunyPHR3yPh0X0FVQKHQiZKbEWCd
        Saxkit39rLMykcyD1tb4g6zsgw==
X-Google-Smtp-Source: ABdhPJyE4u68q8FVt0eXI/DQE1UwCqmluzTkJAQnOfTMfeUcaCjkkTrKj/qaNpoSrIByDUGWJEIsXA==
X-Received: by 2002:a17:902:ee93:b029:10d:431e:21ee with SMTP id a19-20020a170902ee93b029010d431e21eemr329495pld.63.1622646560576;
        Wed, 02 Jun 2021 08:09:20 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id v12sm104304pgi.44.2021.06.02.08.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 08:09:20 -0700 (PDT)
Date:   Wed, 2 Jun 2021 15:09:16 +0000
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
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: fix tlb_flush_guest()
Message-ID: <YLefHNgePAs+lPQJ@google.com>
References: <20210527023922.2017-1-jiangshanlai@gmail.com>
 <78ad9dff-9a20-c17f-cd8f-931090834133@redhat.com>
 <YK/FGYejaIu6EzSn@google.com>
 <YK/FbFzKhZEmI40C@google.com>
 <YK/y3QgSg+aYk9Z+@google.com>
 <fc0f8b39-11a9-da21-dc5b-fc9695292556@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc0f8b39-11a9-da21-dc5b-fc9695292556@linux.alibaba.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 28, 2021, Lai Jiangshan wrote:
> 
> 
> On 2021/5/28 03:28, Sean Christopherson wrote:
> > On Thu, May 27, 2021, Sean Christopherson wrote:
> > > > KVM_REQ_MMU_RELOAD is overkill, nuking the shadow page tables will completely
> > > > offset the performance gains of the paravirtualized flush.
> > 
> > Argh, I take that back.  The PV KVM_VCPU_FLUSH_TLB flag doesn't distinguish
> > between flushing a specific mm and flushing the entire TLB.  The HyperV usage
> > (via KVM_REQ) also throws everything into a single bucket.  A full RELOAD still
> > isn't necessary as KVM just needs to sync all roots, not blast them away.  For
> > previous roots, KVM doesn't have a mechanism to defer the sync, so the immediate
> > fix will need to unload those roots.
> > 
> > And looking at KVM's other flows, __kvm_mmu_new_pgd() and kvm_set_cr3() are also
> > broken with respect to previous roots.  E.g. if the guest does a MOV CR3 that
> > flushes the entire TLB, followed by a MOV CR3 with PCID_NOFLUSH=1, KVM will fail
> > to sync the MMU on the second flush even though the guest can technically rely
> > on the first MOV CR3 to have synchronized any previous changes relative to the
> > fisrt MOV CR3.
> 
> Could you elaborate the problem please?
> When can a MOV CR3 that needs to flush the entire TLB if PCID is enabled?

Scratch that, I was wrong.  The SDM explicitly states that other PCIDs don't
need to be flushed if CR4.PCIDE=1.
