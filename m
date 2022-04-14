Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0A9500D34
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 14:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243189AbiDNM1Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 08:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243172AbiDNM1O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 08:27:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D9342CE32
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 05:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649939083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w3YBdRKJUuRVoqjsuVYs7FMkqCpz3SW587vkpc0Rrvg=;
        b=iUnN5q0ZbfakU7j4xFu2WGxledK1F5TrxOwEkwu7yKVTwIUcljoXDjRw3tfN400vzoUVqT
        EY2jcWeDv4fy/ZxdgAcskxaFOGRIISW7WGhlv1AaBnaNUxvL08CD82tXJriYafZAkutKwd
        mQ6i49pxNNSVi20ilznqkBlL6vImKtk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-17-7x5eswDMPHagf2GtxZQzrg-1; Thu, 14 Apr 2022 08:24:42 -0400
X-MC-Unique: 7x5eswDMPHagf2GtxZQzrg-1
Received: by mail-wm1-f72.google.com with SMTP id 6-20020a1c0206000000b0038ff4f1014fso1013994wmc.7
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 05:24:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=w3YBdRKJUuRVoqjsuVYs7FMkqCpz3SW587vkpc0Rrvg=;
        b=7kDSgVCKgaWKqvj8LjKRfWCQ5ZIQ1lRTu7TXT67/giMSP15HSnrStMaCLWBfKgVJCr
         duEhjs7ha4zAya75lHR0WocaDeqfEc/bXrIFSSm7pKrdJTF4HVbyr+gLxQNIV+DQ1MRh
         lyL2sy3NRB9LXwHvK8qAk2n7c2VOnrTI4aJRy/5W04CM95tQPsGOTX6RjNIAS8v/5ZNt
         yKeZPTQHB/IEV0ygR1Oj8erjEI206b6gwcCEvphWMjgd9mxn0Y84JC7tDG9wEkKu04Fp
         BpMIHWpCP3UeRnapzqTlphB6Z/mMFeBi6XViheE776kHlI06chzG9cH+wAxPf4DHGCIm
         f2jQ==
X-Gm-Message-State: AOAM531c4U1kYJczLxhKfz2FXuFi4c061zZgHSihJJPyr2S5bBMdtN3U
        NoukfRnas6tXUXIq3N4aVLfy7jcbMRSieYrRhB9r5pFD05o2UVOJsu8xHPWeFDt30tcwXVTyJr+
        7JQYfmY+UFCr9
X-Received: by 2002:a05:6000:1acf:b0:203:fe67:a8dc with SMTP id i15-20020a0560001acf00b00203fe67a8dcmr1939003wry.212.1649939080841;
        Thu, 14 Apr 2022 05:24:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzzXxuDleRxU9n7P7jE2XBRIfRSmIzpph4ijPoFszyxobCWls/GbBpEwYTZXs/vLQg4+4xeFg==
X-Received: by 2002:a05:6000:1acf:b0:203:fe67:a8dc with SMTP id i15-20020a0560001acf00b00203fe67a8dcmr1938985wry.212.1649939080646;
        Thu, 14 Apr 2022 05:24:40 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id r14-20020a0560001b8e00b00205918bd86esm1671555wru.78.2022.04.14.05.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 05:24:39 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 13/31] KVM: x86: hyper-v: Direct TLB flush
In-Reply-To: <Yk8tDHc5E8SkOVqB@google.com>
References: <20220407155645.940890-1-vkuznets@redhat.com>
 <20220407155645.940890-14-vkuznets@redhat.com>
 <Yk8tDHc5E8SkOVqB@google.com>
Date:   Thu, 14 Apr 2022 14:24:38 +0200
Message-ID: <87lew76eex.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Apr 07, 2022, Vitaly Kuznetsov wrote:
>> Handle Direct TLB flush requests from L2 by going through all vCPUs
>
> What is a "Direct TLB flush request" in this context?  I can't tell if "direct"
> refers to the MMU being direct, or if it has some other Hyper-V specific meaning.
>
> Ewww, it looks to be Hyper-V terminology.  Now I see that @direct=true is getting
> L2's ring, not L1's ring.  That's all kinds of evil.  That confusion goes away with
> my suggestion below, but this shortlog and changelog (and the ones for nVMX and
> nSVM enabling) absolutely need to clarify "direct" since it conflicts mightily
> with KVM's "direct" terminology.
>
> In fact, unless I'm missing a patch where "Direct" doesn't mean "From L2", I vote
> to not use the "Direct TLB flush" terminology in any of the shortlogs or changelogs
> and only add a footnote to this first changelog to call out that the TLFS (or
> wherever this terminology came from) calls these types of flushes
> "Direct".

In soon-to-be-sent-out v3 I got rid of 'Direct TLB flush' completely.
Note, in addition to what gets introduced in this series, there are
two other Hyper-V specific places which overload 'direct' already:

- Direct TLB flush for KVM-on-Hyper-V (enable_direct_tlbflush()). I'm
getting rid of it too.

- Direct synthetic timers. 'Direct' in this case means that the timer
signal is delivered via dedicated IRQ 'directly' and not through Vmbus
message. This stays as I can't think of how we can rename it (and if we
should, in the first place).

-- 
Vitaly

