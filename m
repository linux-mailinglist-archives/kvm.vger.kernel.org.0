Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D4B30F836
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 17:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237527AbhBDQlD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 11:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237761AbhBDQ3k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 11:29:40 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B18C06178B
        for <kvm@vger.kernel.org>; Thu,  4 Feb 2021 08:29:00 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id a16so2027764plh.8
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 08:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=plRvYvTXbrJav06tLJcFv3awfKApAI3ZId7jgrPzdbM=;
        b=kryIB9hE370OkjDIE2fdWPkaaE+yd4yzATdvBphWBUa2sY6T7T2ftsnWhr67dIlvu3
         yN942vKj/N0O6PdYxtTH8Cb2mmSqtB0gmW2uX50PCE6ATci6V5Mgs0hrH35aAkQ454GU
         098ktIx8sIZW5yaMYnwnUZTTmNf2cUXE3Rk+UAEfRn2+rMR2K7s0ntIIdNmyNhs+ZJGk
         7h5aRNEbHmm96AfTnfmBethDROpZb3PIl3rwKh680ZGxTakOq/6T5tUetRjNtYBbh+Uc
         EfIcGuTKiO0CUo5r67r7v79hFcykGCE9TLeJKeVJo9uv23FT/f+xiprOjK6UQkQs2WD/
         ZXkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=plRvYvTXbrJav06tLJcFv3awfKApAI3ZId7jgrPzdbM=;
        b=FZU7MZfwkimrO+g0ostEI5kUqv+ugO+NZwWOi1j3be66m/OJMm/EZNwt1Gp0SuUZb2
         WNTJXB5k4Tz4EsXy5wL5qrjPOWgYkrupyA9dyrxyzIY2Ug1hy5hFAiZ4ZAbUJIfrul/y
         mnlY+UV7BPBhr4UkZ7rmYkLVLfAEHPSlQGoxo6IRobPlyFZhENJt22z6HF03m7oJmpFk
         EsY4tlrARjxXoFTLPbecoFgxSNtHiL3Kub5MT/1okunDHXC2m7TOOl8kOtlfPuhdB9t0
         tpwqzBvlqSKZ1to3UUNPRUiBHdK4gaKchtuFRYBwoHEzJNYFcATD4aDsgqwkFhuNNDsn
         mcpA==
X-Gm-Message-State: AOAM531sHfL8lXlwhucqhqLDKPigHHLLKQPYr78untMcRCAvvq75+5f8
        R3sK//ImYKKtnlQsKuORyiO+TA==
X-Google-Smtp-Source: ABdhPJzkuuhIByakzk2yIT7Y0I4Zxy7ssendU8ehBBB6nWHqPTI48vn719SYkbINdCHb0DzKiWZvUQ==
X-Received: by 2002:a17:902:d304:b029:e1:7503:4dce with SMTP id b4-20020a170902d304b02900e175034dcemr8821912plc.23.1612456139205;
        Thu, 04 Feb 2021 08:28:59 -0800 (PST)
Received: from google.com ([2620:15c:f:10:f16f:a28e:552e:abea])
        by smtp.gmail.com with ESMTPSA id mw12sm706013pjb.38.2021.02.04.08.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 08:28:58 -0800 (PST)
Date:   Thu, 4 Feb 2021 08:28:51 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "luto@kernel.org" <luto@kernel.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "b.thiel@posteo.de" <b.thiel@posteo.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "Huang, Haitao" <haitao.huang@intel.com>
Subject: Re: [RFC PATCH v3 00/27] KVM SGX virtualization support
Message-ID: <YBwgw0vVCjlhFvqP@google.com>
References: <f50ac476-71f2-60d4-5008-672365f4d554@intel.com>
 <YBrfF0XQvzQf9PhR@google.com>
 <475c5f8b-efb7-629d-b8d2-2916ee150e4f@redhat.com>
 <c827fed1-d7af-a94a-b69e-114d4a2ec988@intel.com>
 <d044ccde68171dc319d77917c8ab9f83e9a98645.camel@intel.com>
 <YBsyqLHPtYOpqeW4@google.com>
 <b6e0a32f-0070-f97e-5d94-d12f7972d474@intel.com>
 <44b5a747aaf1d42fb8ef388bd28f49614d42cd50.camel@intel.com>
 <YBs/vveIBg00Im0U@google.com>
 <5bd3231e05911bc64f5c51e1eddc3ed1f6bfe6c4.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bd3231e05911bc64f5c51e1eddc3ed1f6bfe6c4.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 04, 2021, Kai Huang wrote:
> On Wed, 2021-02-03 at 16:28 -0800, Sean Christopherson wrote:
> > On Thu, Feb 04, 2021, Kai Huang wrote:
> > > On Wed, 2021-02-03 at 15:37 -0800, Dave Hansen wrote:
> > > > On 2/3/21 3:32 PM, Sean Christopherson wrote:
> > > > > > > > Yeah, special casing KVM is almost always the wrong thing to do.
> > > > > > > > Anything that KVM can do, other subsystems will do as well.
> > > > > > > Agreed.  Thwarting ioremap itself seems like the right way to go.
> > > > > > This sounds irrelevant to KVM SGX, thus I won't include it to KVM SGX series.
> > > > > I would say it's relevant, but a pre-existing bug.  Same net effect on what's
> > > > > needed for this series..
> > > > > 
> > > > > I say it's a pre-existing bug, because I'm pretty sure KVM can be coerced into
> > > > > accessing the EPC by handing KVM a memslot that's backed by an enclave that was
> > > > > created by host userspace (via /dev/sgx_enclave).
> > > > 
> > > > Dang, you beat me to it.  I was composing another email that said the
> > > > exact same thing.
> > > > 
> > > > I guess we need to take a closer look at the KVM fallout from this.
> > > > It's a few spots where it KVM knew it might be consuming garbage.  It
> > > > just get extra weird stinky garbage now.
> > > 
> > > I don't quite understand how KVM will need to access EPC memslot. It is *guest*, but
> > > not KVM, who can read EPC from non-enclave. And if I understand correctly, there will
> > > be no place for KVM to use kernel address of EPC to access it. To KVM, there's no
> > > difference, whether EPC backend is from /dev/sgx_enclave, or /dev/sgx_vepc. And we
> > > really cannot prevent guest from doing anything.
> > > 
> > > So how memremap() of EPC section is related to KVM SGX? For instance, the
> > > implementation of this series needs to be modified due to this?
> > 
> > See kvm_vcpu_map() -> __kvm_map_gfn(), which blindly uses memremap() when the
> > resulting pfn isn't a "valid" pfn.  KVM doesn't need access to an EPC memslot,
> > we're talking the case where a malicious userspace/guest hands KVM a GPA that
> > resolves to the EPC.  E.g. nested VM-Enter with the L1->L2 MSR bitmap pointing
> > at EPC.  L0 KVM will intercept VM-Enter and then read L1's bitmap to merge it's
> > desires with L0 KVM's requirements.  That read will hit the EPC, and thankfully
> > for KVM, return garbage.
> 
> Right. I missed __kvm_map_gfn(). 
> 
> I am not quite sure returning all ones can be treated as garbage, since one can means
> true for a boolean, or one bit in bitmap as you said. But since this only happens
> when guest/userspace is malicious, so causing misbehavior to the guest is fine?

Yes, it's fine.  It's really the guest causing misbehavior for itself.

> Do we see any security risk here?

Not with current CPUs, which drop writes and read all ones.  If future CPUs take
creatives liberties with the SDM, then we could have a problem, but that's why
Dave is trying to get stronger guarantees into the SDM.
