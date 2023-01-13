Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6614E66A1C9
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 19:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbjAMSRJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 13:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjAMSQG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 13:16:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2BF12ACC
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 10:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673633165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hQvFnya6NFdzrd0uXGd+lLCU8K6l8CjIC+mc6Joc75c=;
        b=btyPJbHf5HYYSwQNWBzWX9GMpe4BOOvMAldffV2WlXYEsDH8TYGa7JjPxayecU2t+RLP6V
        Y9k1LPgn6Dcm4VoJGVI7PzCksf2rs+FPC/RYanZ5PV3HZZHYqtxTBJN8NZ5OZ5Nuffwmjy
        CiSM68eVDbIRn48YN3t4I2MrwkUkSd4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-43-AV_anbmXOq60lu0JpcEU1Q-1; Fri, 13 Jan 2023 13:06:04 -0500
X-MC-Unique: AV_anbmXOq60lu0JpcEU1Q-1
Received: by mail-ed1-f71.google.com with SMTP id q10-20020a056402518a00b0048e5bc8cb74so15088201edd.5
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 10:06:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hQvFnya6NFdzrd0uXGd+lLCU8K6l8CjIC+mc6Joc75c=;
        b=nRSz9YgdMcrT/DO4v82L0pMItd7fh+9/8KPnPQo7olgHzEHs+LH1UTAVNPsn4+oqm0
         FTC/dpZYUmzi3u6AgW+FQAbI5OlyAZcCKapqq+yshVF+lRQAekDBmpAGN0LimZYW/rQR
         omMyq/RUUO0grG5ng6A29/qJcIJp2Cp8VuZWpE3hjKuz21eloBBZwx/E3Dj05ZDr9nGU
         MQ+9v6/Rm9/CTbb/kPY0qjs2qse58q3NDSCJBuQTz8o5QLIPgKEAIi9GdQlZfL8XgdIm
         GYV/EBV0RUlGiFZ9InYHApP5CjeBlWWhGNilzrfhISVly8uZLRDoWQ6GCD9KKKt5XwiW
         QP/w==
X-Gm-Message-State: AFqh2kpVeaX/UESOkqdGcK5EHTHY/TCKhLnUXLQXjauTkJUdRbtiNHW6
        xNA7NgT7Ofv1aXbseGymp0jwFpsBc4/Chrok+u4NcpHFHGOkBlQ0pX6truhRjun6vsayqo0PlYd
        D5geEHTYPyGk/
X-Received: by 2002:a17:906:7c58:b0:84d:4e9d:864a with SMTP id g24-20020a1709067c5800b0084d4e9d864amr15761302ejp.74.1673633163193;
        Fri, 13 Jan 2023 10:06:03 -0800 (PST)
X-Google-Smtp-Source: AMrXdXt4OmwyB6O2jyNzsN9OMjhhAn2F5iRTGB3A9G+/HJ+y66pFH9MGlJvZurdSDSOqdub4DT7B+Q==
X-Received: by 2002:a17:906:7c58:b0:84d:4e9d:864a with SMTP id g24-20020a1709067c5800b0084d4e9d864amr15761291ejp.74.1673633163017;
        Fri, 13 Jan 2023 10:06:03 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id la19-20020a170907781300b007aee7ca1199sm8819421ejc.10.2023.01.13.10.06.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 10:06:02 -0800 (PST)
Message-ID: <674ac894-12a2-c15f-72c5-878558a8005d@redhat.com>
Date:   Fri, 13 Jan 2023 19:06:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 0/6] KVM: x86: x2APIC reserved bits/regs fixes
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Orr <marcorr@google.com>, Ben Gardon <bgardon@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>
References: <20230107011025.565472-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230107011025.565472-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/7/23 02:10, Sean Christopherson wrote:
> Fixes for edge cases where KVM mishandles reserved bits/regs checks when
> the vCPU is in x2APIC mode.
> 
> The first two patches were previously posted[*], but both patches were
> broken (as posted against upstream), hence I took full credit for doing
> the work and changed Marc to a reporter.
> 
> The VMX APICv fixes are for bugs found when writing tests.  *sigh*
> I didn't Cc those to stable as the odds of breaking something when touching
> the MSR bitmaps seemed higher than someone caring about a 10 year old bug.
> 
> AMD x2AVIC support may or may not suffer similar interception bugs, but I
> don't have hardware to test and this already snowballed further than
> expected...
> 
> [*] https://lore.kernel.org/kvm/20220525173933.1611076-1-venkateshs@chromium.org

Looks good; please feel free to start gathering this in your tree for 6.3.

Next week I'll go through Ben's series as well as Aaron's "Clean up the 
supported xfeatures" and others.

Let me know if you would like me to queue anything of these instead, and 
please remember to set up the tree in linux-next. :)

Thanks,

Paolo

> Sean Christopherson (6):
>    KVM: x86: Inject #GP if WRMSR sets reserved bits in APIC Self-IPI
>    KVM: x86: Inject #GP on x2APIC WRMSR that sets reserved bits 63:32
>    KVM: x86: Mark x2APIC DFR reg as non-existent for x2APIC
>    KVM: x86: Split out logic to generate "readable" APIC regs mask to
>      helper
>    KVM: VMX: Always intercept accesses to unsupported "extended" x2APIC
>      regs
>    KVM: VMX: Intercept reads to invalid and write-only x2APIC registers
> 
>   arch/x86/kvm/lapic.c   | 55 ++++++++++++++++++++++++++----------------
>   arch/x86/kvm/lapic.h   |  2 ++
>   arch/x86/kvm/vmx/vmx.c | 40 +++++++++++++++---------------
>   3 files changed, 57 insertions(+), 40 deletions(-)
> 
> 
> base-commit: 91dc252b0dbb6879e4067f614df1e397fec532a1

