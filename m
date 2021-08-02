Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333E93DDD78
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 18:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhHBQUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 12:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbhHBQUi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 12:20:38 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2B9C061760
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 09:20:29 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id t3so18109775plg.9
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 09:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LKSDgoQrvGYLPlpAHnL1xCY18fI5StbO5wi+iDVl4jk=;
        b=vpvHeto3hln3guSCP5pAX4Ek1PDazugmwcY2YyzwDWs8Ifg3godsndxFaddLeJt3JJ
         sGbDjODTtZ39kFCAc++1K57NXsamMKXs0iyxzlPtVePMvpZLp4SWWYOeT6pckX/TSfoH
         0+zqLqBfP7DiMkJZPFUFqanc2fVMD8VPskHaqlPOnHPYIL9K2xnQ4AYehOvsicPB6EYY
         FwJPLNScSqzjPLOk1HNboRdXcgnua17PnHWPvEGQVp57LGmm0W0xqhd35lZG0aZd5TzI
         0AioNre27K5BSD1RvQNZHflszSUCO8ijNsz/wABMr79cL3ssGnKokCMjwxcCKiGP6yhc
         CSQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LKSDgoQrvGYLPlpAHnL1xCY18fI5StbO5wi+iDVl4jk=;
        b=pP+4yHQBLO7G7nBqFuH1lyz97OZf30quvDchHDy+UjkuCBSyLiWL6hm0unAu55eAS1
         egPWv47I8h+LTuGIJwsHB+TbTc/y7Tj49XoJJXl0P3a0rJ/FSGu41e27m/iK+a77x8k1
         DTj42TTSQY0TSMnli9QjC2Hpc5kSxIZQx9z9r7/T0KNm0YT/aEKnrDJ9uvuU3uu4wG/c
         LGZUXVRYfWYSe+DVmURrdhu9aSMe9WVJl0esx5vJBgoR181zsvOXPO4QN06+aaahIV07
         00klG4zi6xvneV9rEQtgwNDpozbpIIvTCYRJpHwI8UcD3PDTgv+dn6keGEcxU2N/1/dG
         Y6Gg==
X-Gm-Message-State: AOAM533tJ5/N/2fbbkOMUhBnKT4LOaMlFlFVsg9Xx5LclegkI76i4Tef
        HhsRDLVvDK3yrARRd4A+FL0S0w==
X-Google-Smtp-Source: ABdhPJwqBJ35AO52xu3hDxWSn2ir42jHB4/01j2TLEZ3gmIULEQlODgSzdOhe3FPjYkUE7WZCtw+Sg==
X-Received: by 2002:a05:6a00:b85:b029:332:1865:fea9 with SMTP id g5-20020a056a000b85b02903321865fea9mr17473384pfj.45.1627921228700;
        Mon, 02 Aug 2021 09:20:28 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k3sm12751155pfc.16.2021.08.02.09.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 09:20:28 -0700 (PDT)
Date:   Mon, 2 Aug 2021 16:20:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: Re: [PATCH 1/6] x86/feat_ctl: Add new VMX feature, Tertiary
 VM-Execution control
Message-ID: <YQgbSLYfNUL+WqPg@google.com>
References: <20210716064808.14757-1-guang.zeng@intel.com>
 <20210716064808.14757-2-guang.zeng@intel.com>
 <YQHr6VvNOQclolfc@google.com>
 <ad88a2ed-536e-deae-2428-278346a43d30@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad88a2ed-536e-deae-2428-278346a43d30@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 02, 2021, Zeng Guang wrote:
> On 7/29/2021 7:44 AM, Sean Christopherson wrote:
> > On Fri, Jul 16, 2021, Zeng Guang wrote:
> > > @@ -42,6 +44,13 @@ static void init_vmx_capabilities(struct cpuinfo_x86 *c)
> > >   	rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS2, &ign, &supported);
> > >   	c->vmx_capability[SECONDARY_CTLS] = supported;
> > > +	/*
> > > +	 * For tertiary execution controls MSR, it's actually a 64bit allowed-1.
> > > +	 */
> > > +	rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS3, &ign, &supported);
> > > +	c->vmx_capability[TERTIARY_CTLS_LOW] = ign;
> > > +	c->vmx_capability[TERTIARY_CTLS_HIGH] = supported;
> > Assuming only the lower 32 bits are going to be used for the near future (next
> > few years), what about defining just TERTIARY_CTLS_LOW and then doing:
> > 
> > 	/*
> > 	 * Tertiary controls are 64-bit allowed-1, so unlikely other MSRs, the
> > 	 * upper bits are ignored (because they're not used, yet...).
> > 	 */
> > 	rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS3, &supported, &ign);
> > 	c->vmx_capability[TERTIARY_CTLS_LOW] = supported;
> > 
> > I.e. punt the ugliness issue down the road a few years.
> Prefer to keep it complete, and use new variables like low/high consistent
> with its function meaning. Ok for that ?

Ya, either way works.
