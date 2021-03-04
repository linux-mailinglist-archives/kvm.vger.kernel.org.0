Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF1832D77B
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 17:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236119AbhCDQNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 11:13:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236120AbhCDQNI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 11:13:08 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C443DC06175F
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 08:12:27 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id a24so16379708plm.11
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 08:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=M0XnnEAqraXAeF4+i+vItLFGXDvAf3tEfz7DahoxJJw=;
        b=cwCs3pDntYOkJYJ9dj1954BTJbulh/SVFYFy867rYU2YXd3cbO27mWW0JntnQI23Nq
         YxGLio8waz9UwbuYZfqARkQlev3EDeY7a5Xt6rk3Bb8EXFEMI0vsr6q3ZdM1aHouf5Y5
         PAAJNi/AZUCMFq0EqWP3LFgS4pxUkkzgic1yK3lRvtFC5bXEUmJmQiyhn/rE5LwrxUm8
         F2XZEdoREg7bx149EnmQxJuoJJlKwzC5pGLDMFEwHvEj+X+RO2xkat3RK3xjHwFw1j8Z
         m2cs4uJ4BW9nepnnJB1/6ukkvu4aXNYMCA5aGfFtAnhEBUzlrVAHlygllfp2HhKGDrfT
         rAnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=M0XnnEAqraXAeF4+i+vItLFGXDvAf3tEfz7DahoxJJw=;
        b=MEYYzgteaZJ4Vhx7W9zR/j0fXz4Xt9gd+yxAgvDyNoSfTIWYG5ihvJNYhwKcIiRc2j
         TlBjsz41KG381lz0bLyTfM1zDLxSrlm2+Y+NV92nrl7kx0oOvwaO9LVZ+be+SdWWyzNP
         CXg+tEo9vb1YxjbMfwLQA0Iz7H1/BrN/kFscCzKus+3vZgh0x2fE3Rj5s0JZV6hSB+pS
         3lk5bHEG02+W7KVG05cSWZPKHOClrAyJXzQGZyWkpZUnWb9CQzZ6peSx9yno876rerD6
         zF0HG3UNjNFJ1VLlxNECCdXIb+rTOYZr7yl0e8Q+gejbNDF+TIOXiLuYTdwLAwmRK6Ry
         yURA==
X-Gm-Message-State: AOAM533QO9VIN9hQm5oCnr5AQYwGoF/6hvxbRncFn11AMK/hVWZN5XBb
        Yz0R5bveUX0DjPhmwuNUFotOBw==
X-Google-Smtp-Source: ABdhPJypswSWeuvacVV01KINr3t+qwNBGGLALIuoahZrYHJqqwob1SAVeOpezDBWZ9EvmFmAKsHv7w==
X-Received: by 2002:a17:902:b18c:b029:da:fc41:baf8 with SMTP id s12-20020a170902b18cb02900dafc41baf8mr4653715plr.58.1614874347083;
        Thu, 04 Mar 2021 08:12:27 -0800 (PST)
Received: from google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
        by smtp.gmail.com with ESMTPSA id r15sm28694616pfh.97.2021.03.04.08.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 08:12:26 -0800 (PST)
Date:   Thu, 4 Mar 2021 08:12:19 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>, wei.w.wang@intel.com,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: Re: [PATCH v3 5/9] KVM: vmx/pmu: Add MSR_ARCH_LBR_DEPTH emulation
 for Arch LBR
Message-ID: <YEEG48erESM0+3CB@google.com>
References: <20210303135756.1546253-1-like.xu@linux.intel.com>
 <20210303135756.1546253-6-like.xu@linux.intel.com>
 <YD/APUcINwvP53VZ@google.com>
 <890a6f34-812a-5937-8761-d448a04f67d7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <890a6f34-812a-5937-8761-d448a04f67d7@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 04, 2021, Xu, Like wrote:
> Hi Sean,
> 
> Thanks for your detailed review on the patch set.
> 
> On 2021/3/4 0:58, Sean Christopherson wrote:
> > On Wed, Mar 03, 2021, Like Xu wrote:
> > > @@ -348,10 +352,26 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
> > >   	return true;
> > >   }
> > > +/*
> > > + * Check if the requested depth values is supported
> > > + * based on the bits [0:7] of the guest cpuid.1c.eax.
> > > + */
> > > +static bool arch_lbr_depth_is_valid(struct kvm_vcpu *vcpu, u64 depth)
> > > +{
> > > +	struct kvm_cpuid_entry2 *best;
> > > +
> > > +	best = kvm_find_cpuid_entry(vcpu, 0x1c, 0);
> > > +	if (best && depth && !(depth % 8))
> > This is still wrong, it fails to weed out depth > 64.
> 
> How come ? The testcases depth = {65, 127, 128} get #GP as expected.

@depth is a u64, throw in a number that is a multiple of 8 and >= 520, and the
"(1ULL << (depth / 8 - 1))" will trigger undefined behavior due to shifting
beyond the capacity of a ULL / u64.

Adding the "< 64" check would also allow dropping the " & 0xff" since the check
would ensure the shift doesn't go beyond bit 7.  I'm not sure the cleverness is
worth shaving a cycle, though.

> > Not that this is a hot path, but it's probably worth double checking that the
> > compiler generates simple code for "depth % 8", e.g. it can be "depth & 7)".
> 
> Emm, the "%" operation is quite normal over kernel code.

So is "&" :-)  I was just pointing out that the compiler should optimize this,
and it did.

> if (best && depth && !(depth % 8))
>    10659:       48 85 c0                test   rax,rax
>    1065c:       74 c7                   je     10625 <intel_pmu_set_msr+0x65>
>    1065e:       4d 85 e4                test   r12,r12
>    10661:       74 c2                   je     10625 <intel_pmu_set_msr+0x65>
>    10663:       41 f6 c4 07             test   r12b,0x7
>    10667:       75 bc                   jne    10625 <intel_pmu_set_msr+0x65>
> 
> It looks like the compiler does the right thing.
> Do you see the room for optimization ？
> 
> > 
> > > +		return (best->eax & 0xff) & (1ULL << (depth / 8 - 1));

Actually, looking at this again, I would explicitly use BIT() instead of 1ULL
(or BIT_ULL), since the shift must be 7 or less.

> > > +
> > > +	return false;
> > > +}
> > > +
> 
