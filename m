Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC5C42E1C1
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 20:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbhJNS6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 14:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbhJNS6p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 14:58:45 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A960FC061753
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 11:56:40 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so5509641pjb.0
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 11:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3LreHgy6pHRdcseTPTu+FzR1hmJaWzkUvsg5FgfF3CA=;
        b=GFz74yUstAHcFh6DyYBis3Z+O3ExBYfbqiA8cVzf4trKTw/XAD6WldBEmIQtcXgJ8q
         JWbd/8AaVIeRFfX0xTH5WdB2TRI4Fg29XVuHnCDvS7Nut+QJftZFi5x/o2/+S6iBGz7m
         TyDNJ1vtFqhVeXjeOBCLtKI4NTzA+XyraoFVDxELUvFV9BHgawN6vrj7y5aa4oSwBsq7
         BO5OaE2H2LtCbupNdTa7HNpF5N8PjvzJQtSF7V+MThKXCpzDEve66bvs/Lt0FwLAUQLw
         6WHUEx7fHCC1rD/QVVdqffAJ+aOhtWF5IsNkZYmLgZiAlsh44KQgW+8nt12huSOGzqHd
         kWEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3LreHgy6pHRdcseTPTu+FzR1hmJaWzkUvsg5FgfF3CA=;
        b=3ecxdvwpMc5hrnsCKgcLYqDp8O3fO5eVShIBxok6od8iqtXmLCxrnW0CtKIYzC6kYY
         PG1T6hRY0wIvhfBw8G/NM0pelba6OQDM9WUJkgg2LGHQvovTom1W1HpY1Hl3aaq4AX+U
         PJQY9W+nGAeQA35KGKrPK5DXTdAWiQWc0wryjvWxNgnU0agoiFI/4oS9eCzb5PAeHF+Q
         4OR+WZJcKQ5wB5ZHBpMKMyrZqVLu7816FGcmD6o85UnRLv5WBbQpkWr0jav+TEBkZJex
         YeTPme+uK+wCU5w8JxFKI+s2KclPauKG0rUmFiPch4WXm5KUq9QsMso2XFj9PpMMLFKa
         fWNw==
X-Gm-Message-State: AOAM532nb2CQB6dl3PblAhmVZKQekGIFvA6v80o98J67TBEYX3NmDmrO
        aVE5U7ckB9il5vbrvvhUoAamBA==
X-Google-Smtp-Source: ABdhPJzeAQ/2Mrw2TGDuVSQmY9NJA0/3+eQo4AiWUEZC8v/D+wo6TAzYPNfP4E50NiwEXknO48MFNg==
X-Received: by 2002:a17:90a:a581:: with SMTP id b1mr21972732pjq.21.1634237799882;
        Thu, 14 Oct 2021 11:56:39 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u1sm2938419pje.47.2021.10.14.11.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 11:56:39 -0700 (PDT)
Date:   Thu, 14 Oct 2021 18:56:35 +0000
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
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v4 6/6] KVM: VMX: enable IPI virtualization
Message-ID: <YWh9YyulGLBHBvEt@google.com>
References: <20210809032925.3548-1-guang.zeng@intel.com>
 <20210809032925.3548-7-guang.zeng@intel.com>
 <YTvttCcfqF7D/CXt@google.com>
 <YTvwbUhofR3Fv7bV@google.com>
 <c13b1ad7-f250-1f7f-4f6c-886b81b06517@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c13b1ad7-f250-1f7f-4f6c-886b81b06517@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 18, 2021, Zeng Guang wrote:
> On 9/11/2021 7:55 AM, Sean Christopherson wrote:
> > On Fri, Sep 10, 2021, Sean Christopherson wrote:
> > > On Mon, Aug 09, 2021, Zeng Guang wrote:
> > > > +		if (!pages)
> > > > +			return -ENOMEM;
> > > > +
> > > > +		to_kvm_vmx(kvm)->pid_table = (void *)page_address(pages);
> > > > +		to_kvm_vmx(kvm)->pid_last_index = KVM_MAX_VCPU_ID;
> > > I don't see the point of pid_last_index if we're hardcoding it to KVM_MAX_VCPU_ID.
> > > If I understand the ucode pseudocode, there's no performance hit in the happy
> > > case, i.e. it only guards against out-of-bounds accesses.
> > > 
> > > And I wonder if we want to fail the build if this grows beyond an order-1
> > > allocation, e.g.
> > > 
> > > 		BUILD_BUG_ON(PID_TABLE_ORDER > 1);
> > > 
> > > Allocating two pages per VM isn't terrible, but 4+ starts to get painful when
> > > considering the fact that most VMs aren't going to need more than one page.  For
> > > now I agree the simplicity of not dynamically growing the table is worth burning
> > > a page.
> > Ugh, Paolo has queued a series which bumps KVM_MAX_VCPU_ID to 4096[*].  That makes
> > this an order-3 allocation, which is quite painful.  One thought would be to let
> > userspace declare the max vCPU it wants to create, not sure if that would work for
> > xAPIC though.
> > 
> > [*] https://lkml.kernel.org/r/1111efc8-b32f-bd50-2c0f-4c6f506b544b@redhat.com
> Thus we keep current design as no change.

Not necessarily.  I was pointing out that the current design is already problematic
from a memory allocation perspective.  Burning a few pages per vCPU isn't the end
of the world, but 32kb of _contiguous_ memory is rough, especially when 28kb is
unlikely to be used in many cases.
