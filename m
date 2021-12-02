Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845EF465BF1
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 03:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349523AbhLBCDf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 21:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349071AbhLBCDa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 21:03:30 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E91C06174A
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 18:00:08 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id n8so19127341plf.4
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 18:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ieez22Xn2l5HWg/32xD5LElmnAc6m+5OIzBSW88ykGA=;
        b=G0z4qsx02gTJpOX+id+WDt87iiCC68/pLc8/RHTHy93ZaRCC/cpz/VtsZ5QLq6NhsC
         pztYoE3cxmb1ab05i+mKIC8ML+IoYX2JvCedMYG/dA5g4rEg3w2gyuXKxfic5SWkfGb+
         LTzmn0ERm4vLCwinV2Q7f64T7CvStCYLOXGIoBC/JED1+H3JdUB9Rafl3aySZq2PFK+D
         j8FA4sR8WNSfp7GYg67MnxS2CunppQgmHJnEXulsOfQJjagvmDJOLOMmlhUfNCfaq2x+
         Msm/OAxbLxPfZ954U2c9p631E4TYd+VGgfnvhf+iALAZ45wlstnB6aDZPFFAYACiiRYn
         9c3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ieez22Xn2l5HWg/32xD5LElmnAc6m+5OIzBSW88ykGA=;
        b=ziwVoNUQgLBxRez+yb1NxYdRTD3YY1Nn/Yahp4/0TgNngkjCZLAwObFp6rdslKMg0r
         sCn4cMCwvdvAZXDgG9dkSKW0599s8UX95sJ7VXr1xr/I1ChZP27Kj1kNWrCg7dyPCAMx
         kmZM/diGdFLy+iG4Iuv3PLtM2FCgo4yzPiXdJLRwGJeVtbgnFIkx+rHQ1NIlpphBerik
         6BQT1bQfX+kwdfcI4auP4DGhZBQPhhYAo+Dqxjc3jehZRam3E+vAqN78nwr7tm7vQFco
         bIgdz4yafGFgfWGFRP5/rJhjamzBD5UAczh0GUNkTJGRgz7wsiptBPmVzwnKqKVFjh+I
         dClw==
X-Gm-Message-State: AOAM530nWFgSOsCz0M6w1S8jicR7pxyq18bYLMpbqhDjJevc03dhv/vu
        xdV8JaE6gZDb1CrFG7N1gO4s9Q==
X-Google-Smtp-Source: ABdhPJxNBM72YGsKSZuE+5oJQdw89IebyEem9LDSzk1Pcg1GjafGCYFG2d6Z2Cymjn7sJ6Jwu52nlQ==
X-Received: by 2002:a17:90b:3848:: with SMTP id nl8mr2408510pjb.221.1638410408016;
        Wed, 01 Dec 2021 18:00:08 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id lr6sm550689pjb.0.2021.12.01.18.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 18:00:07 -0800 (PST)
Date:   Thu, 2 Dec 2021 02:00:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Wei Huang <wei.huang2@amd.com>
Subject: Re: [PATCH v2 11/43] KVM: Don't block+unblock when halt-polling is
 successful
Message-ID: <Yagoo7R8P5xVilsj@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-12-seanjc@google.com>
 <cceb33be9e2a6ac504bb95a7b2b8cf5fe0b1ff26.camel@redhat.com>
 <4e883728e3e5201a94eb46b56315afca5e95ad9c.camel@redhat.com>
 <YaUNBfJh35WXMV0M@google.com>
 <496c2fc6-26b0-9b5d-32f4-2f9e9dd6a064@redhat.com>
 <YaUiEquKYi5eqWC0@google.com>
 <880a5727-69d1-72a1-b129-b053781625ad@redhat.com>
 <458c0819a578ba854f00089bc312c8faa177a81a.camel@redhat.com>
 <32eabe7d270e5a466ba2d9345b4270b8fe27700c.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <32eabe7d270e5a466ba2d9345b4270b8fe27700c.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 02, 2021, Maxim Levitsky wrote:
> On Tue, 2021-11-30 at 00:53 +0200, Maxim Levitsky wrote:
> > On Mon, 2021-11-29 at 20:18 +0100, Paolo Bonzini wrote:
> > Basically what I see that
> >  
> > 1. vCPU2 disables is_running in avic physical id cache
> > 2. vCPU2 checks that IRR is empty and it is
> > 3. vCPU2 does schedule();
> >  
> > and it keeps on sleeping forever. If I kick it via signal 
> > (like just doing 'info registers' qemu hmp command
> > or just stop/cont on the same hmp interface, the
> > vCPU wakes up and notices that IRR suddenly is not empty,
> > and the VM comes back to life (and then hangs after a while again
> > with the same problem....).
> >  
> > As far as I see in the traces, the bit in IRR came from
> > another VCPU who didn't respect the ir_running bit and didn't get 
> > AVIC_INCOMPLETE_IPI VMexit.
> > I can't 100% prove it yet, but everything in the trace shows this.

...

> I am now almost sure that this is errata #1235.
> 
> I had attached a kvm-unit-test I wrote (patch against master of
> https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git/) which is able to
> reproduce the issue on stock 5.15.0 kernel (*no patches applied at all*)
> after just few seconds.  If kvm is loaded without halt-polling (that is
> halt_poll_ns=0 is used).
> 
> Halt polling and/or Sean's patch are not to blame, it just changes timeing.
> With Sean's patch I don't need to disable half polling.

Hmm, that suggests the bug/erratum is due to the CPU consuming stale data from #4
for the IsRunning check in #5, or retiring uops for the IsRunning check before
retiring the vIRR update.  It would be helpful if the erratum actually provided
info on the "highly specific and detailed set of internal timing conditions". :-/

  4. Lookup the vAPIC backing page address in the Physical APIC table using the
     guest physical APIC ID as an index into the table.
  5. For every valid destination:
     - Atomically set the appropriate IRR bit in each of the destinations’ vAPIC
       backing page.
     - Check the IsRunning status of each destination.
