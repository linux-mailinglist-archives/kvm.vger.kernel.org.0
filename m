Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904F048EEDE
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 18:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243631AbiANRAc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 12:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242588AbiANRAc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 12:00:32 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7876BC061574
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 09:00:31 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id h23so3225380pgk.11
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 09:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xjoS4K/y8gkwtFetlOk0sMfpyN0++LCc7AkNoF1EEeA=;
        b=IKLEf9fy+XV5ibto796ufUUVkuOXmiAe1Ec1lM7Z3daI4YOtmL6CWQG9prdrfb7oup
         I98bnXfMazE1cMqeBEAsn6oKT/rUhI80S2prPVp/AhX8ICntJmz5AJWQ/XRV2CCwXO3M
         TVYw4crJyR8WLi8lOK9POPQQ6JjM+g19AP1dddsS1z3Dq7g36cWQNpAdPIaHuC3/p4n6
         WzaubIq1mLt+jn9fLoMcSt6Ovf8zUad/zHf7O3mpUigEyTF3WmnRmYCyOQ51QP/ld1Sp
         qZa5acJbXlHJgNm9yxDginU0uGaj1DZXxV5NEd3qnX1n9t0K3lWv2OjUXnZ073W+WtPY
         LfhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xjoS4K/y8gkwtFetlOk0sMfpyN0++LCc7AkNoF1EEeA=;
        b=7qNQrEiPnWLtbU4gAX30ZmUiZfShRn7LM0W3Ma7LvW2QYk+3+/e2YDTut0p9k0LZGq
         kuhTt1fGTFQEheaDGbR+SSs1wtrVfKdCGb8WpYHLrXS+bBzh81trDmvVmhtzvG73TRSP
         8Uz9uufzfmfe3LoY0oMG9ab5S02IS13f64Mm4g8/rj8EtrLF6ymruw/ScKVPmA1NHIK3
         iMKGtVHt8Y48kxwZRmX2i97b1JvCeChcObS0n3y3ML/EZTtslq3Re7yCSMjBhWeEvhe7
         YYY+A3fHFO1zBiDzDQ8Q5+PLqEoPVgaOqxn9vf2FPQkAV8dWsmUqhvNQh3Gb8AO+aeBw
         8+GA==
X-Gm-Message-State: AOAM531fzxaFa57X4vHuP1YLcEDy1BoZI8Pp5+CaabIS303jXPr3jp/0
        sPbWH/Ikxw9umy23bv+r0rZnbw==
X-Google-Smtp-Source: ABdhPJyK4NO0IRQqUFtpgmMoDjmV9qYii4Ns5cvsdau/cVTvulWI3OU+4pc/o5/DiidW5EAys9uOLQ==
X-Received: by 2002:a63:6c01:: with SMTP id h1mr8913390pgc.233.1642179630783;
        Fri, 14 Jan 2022 09:00:30 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m13sm4985630pga.38.2022.01.14.09.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 09:00:29 -0800 (PST)
Date:   Fri, 14 Jan 2022 17:00:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Igor Mammedov <imammedo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
Message-ID: <YeGsKslt7hbhQZPk@google.com>
References: <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
 <20211227183253.45a03ca2@redhat.com>
 <61325b2b-dc93-5db2-2d0a-dd0900d947f2@redhat.com>
 <87mtkdqm7m.fsf@redhat.com>
 <20220103104057.4dcf7948@redhat.com>
 <YeCowpPBEHC6GJ59@google.com>
 <20220114095535.0f498707@redhat.com>
 <87ilummznd.fsf@redhat.com>
 <20220114122237.54fa8c91@redhat.com>
 <87ee5amrmh.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ee5amrmh.fsf@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 14, 2022, Vitaly Kuznetsov wrote:
> Igor Mammedov <imammedo@redhat.com> writes:
> 
> > On Fri, 14 Jan 2022 10:31:50 +0100
> > Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >
> >> Igor Mammedov <imammedo@redhat.com> writes:
> >> 
> >> 
> >> > However, a problem of failing KVM_SET_CPUID2 during VCPU re-plug
> >> > is still there and re-plug will fail if KVM rejects repeated KVM_SET_CPUID2
> >> > even if ioctl called with exactly the same CPUID leafs as the 1st call.
> >> >  
> >> 
> >> Assuming APIC id change doesn not need to be supported, I can send v2
> >> here with an empty allowlist.
> > As you mentioned in another thread black list would be better
> > to address Sean's concerns or just revert problematic commit.
> >
> 
> Personally, I'm leaning towards the blocklist approach even if just for
> 'documenting' the fact that KVM doesn't correctly handle the
> change. Compared to a comment in the code, such approach could help
> someone save tons of debugging time (if anyone ever decides do something
> weird, like changing MAXPHYADDR on the fly).

I assume the blocklist approach is let userspace opt into rejecting KVM_SET_CPUID{,2},
but allow all CPUID leafs and sub-leafs to be modified at will by default?  I don't
dislike the idea, but I wonder if it's unnecessarily fancy.

What if we instead provide an ioctl/capability to let userspace toggle disabling
of KVM_SET_CPUID{,2}, a la STAC/CLAC to override SMAP?  E.g. QEMU could enable
protections after initially creating the vCPU, then temporarily disable protections
only for the hotplug path?

That'd provide solid protections for minimal effort, and if userspace can restrict
the danger zone to one specific path, then userspace can easily do its own auditing
for that one path.
