Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB31456A673
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 16:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236389AbiGGO7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 10:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236150AbiGGO6V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 10:58:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3820BBB2
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 07:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657205874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BPPyfbm7cP61/jDVpNfbjlUmaFCLU4YcNzeyYG8WmXc=;
        b=J1YdaH4BQGgdbOk23gvC5K1dn49jUtRTRAOZV+pa6zzQKSujjckpU2sJFBkAkXHrRkHp18
        l3QEdj4d2xZe5p1u3bj0ynfOtjRrGrrIcF/Q79Ij9eHLFNOkz7G4fR9LfuUw3PODOz5grh
        Sk9rset/5KibKgSSR5P4M6qD1v5o4Wo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-388-MnUhY5mkPXaw9ZCHdxHl0A-1; Thu, 07 Jul 2022 10:57:47 -0400
X-MC-Unique: MnUhY5mkPXaw9ZCHdxHl0A-1
Received: by mail-wm1-f72.google.com with SMTP id bg6-20020a05600c3c8600b003a03d5d19e4so9678475wmb.1
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 07:57:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=BPPyfbm7cP61/jDVpNfbjlUmaFCLU4YcNzeyYG8WmXc=;
        b=x4RxIdsHjjTfcD0zgVes6rwjGxCkPxB8WhoGc2DbDe86cmuklGCoWUiMzxFONE6WNR
         7njWt7/mPtIhysEWEx4oTbuZWCQDK3HfdWFGdHM2GV9sNg+66EjUYBcqi7OgK2yhTd7m
         vu8UrVcwTDLc7hLTdk/j3jxhX7iuNGRDdgpJ4wsL69Tz4N8wRlNlrcHErwWVWZSLF8fn
         QAxLIX6YKr1WskvdUe1AtwRecmF6Q5zIfx3Lv5r+Cf8y+3U+42msTFgn30V5VU8yjwuH
         qVjcl/FfFTZeU8YQ8nPea1Ti0jfqpo0waTgd1v93koTeQD9kYg4e/WUcAITNGMQh8Jgv
         Ab/g==
X-Gm-Message-State: AJIora9dEBdwcZ1QXjSwhwX4guSb4WeIlrgEp2s2W4Ti1TsuN5tpQN+K
        lTcZ8C4HDcuPLv7Lnqlrqq8hcys8pfwmllDsf2pzqWXOPndz8sNR9oiGKLfK5OVfn2HeByDbcUS
        Jy1W07bWGVdGv
X-Received: by 2002:a05:600c:3511:b0:3a1:9992:f72f with SMTP id h17-20020a05600c351100b003a19992f72fmr5166858wmq.164.1657205866240;
        Thu, 07 Jul 2022 07:57:46 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u0/E4oQnfuVVwr2Quhckj80YkdpdC1DUvgHP9mLEG3FQiLuZoO9arVkl3lDbI9tW7XUnCGwg==
X-Received: by 2002:a05:600c:3511:b0:3a1:9992:f72f with SMTP id h17-20020a05600c351100b003a19992f72fmr5166839wmq.164.1657205866008;
        Thu, 07 Jul 2022 07:57:46 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id y8-20020adfee08000000b0021d6e49e4ebsm9673078wrn.10.2022.07.07.07.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 07:57:45 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 22/28] KVM: VMX: Clear controls obsoleted by EPT at
 runtime, not setup
In-Reply-To: <CALMp9eRA0v6BK6KG81ZE_iLKF6VNXxemN=E4gAE4AM-V4gkdHQ@mail.gmail.com>
References: <20220629150625.238286-1-vkuznets@redhat.com>
 <20220629150625.238286-23-vkuznets@redhat.com>
 <CALMp9eRA0v6BK6KG81ZE_iLKF6VNXxemN=E4gAE4AM-V4gkdHQ@mail.gmail.com>
Date:   Thu, 07 Jul 2022 16:57:44 +0200
Message-ID: <87wncpotqv.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> writes:

> On Wed, Jun 29, 2022 at 8:07 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>
>> From: Sean Christopherson <seanjc@google.com>
>>
>> Clear the CR3 and INVLPG interception controls at runtime based on
>> whether or not EPT is being _used_, as opposed to clearing the bits at
>> setup if EPT is _supported_ in hardware, and then restoring them when EPT
>> is not used.  Not mucking with the base config will allow using the base
>> config as the starting point for emulating the VMX capability MSRs.
>>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Nit: These controls aren't "obsoleted" by EPT; they're just no longer
> required.

Sean,

I'm going to update the subject line to "KVM: VMX: Clear controls
unneded with EPT at runtime, not setup" retaining your authorship in v3
(if there are no objections, of course).

>
> Reviewed-by: Jim Mattson <jmattson@google.com>
>

Thanks!

-- 
Vitaly

