Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C23AF539FEF
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 10:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243255AbiFAI53 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 04:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348187AbiFAI52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 04:57:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F03E50004
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 01:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654073846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oTXq3UeABBYSaGV3RAS/AH+/JRNDT9mOMSr/5zH7Hs0=;
        b=h8eMeN6QzDHKazOBDXu8HsSB/dseUh4ETKI5f9K9tPsig5mebMzAW367RoDLP4cN/Z4M5l
        YHFlhRb8VTBXcw7YuNitlE4bFibEQQSabWt7QWCb4vEjUItyRegP/85J0jgv42+yjjMjEH
        N5wVGD/kRsJTiibGgi7C5oA5G+rnn/c=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-JjZcR8VNPGGdIkhEJiyfVQ-1; Wed, 01 Jun 2022 04:57:25 -0400
X-MC-Unique: JjZcR8VNPGGdIkhEJiyfVQ-1
Received: by mail-ej1-f69.google.com with SMTP id gf24-20020a170906e21800b006fe8e7f8783so611694ejb.2
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 01:57:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oTXq3UeABBYSaGV3RAS/AH+/JRNDT9mOMSr/5zH7Hs0=;
        b=MADQnnAPtY+nCMuddyGGwdRu2ZQAFEr9Y/5X7hDIQtNBfHTjtrel12cN5/1+O2t6gI
         A3ZsDGDvGaUzCM+Oz0dNQPZ3dEkENBzvgV/rAkTdwAii0A7n7fWgra/XI/JwX8HFGBZB
         w4g4HvPwVpyZie4qagv2EJuNYJzqI6og5jIsmR/qT0JdOOx1QDuWTHEngmRTyFhBPUor
         GGzhwsHcEBmd2MItUp7DPEVxRSJDxzR+j2rVxt+xLmH6G4hgxEek0voiTRdHaVPz/FxX
         JkC2i4DT6uJNgsBE/XA+fugNAot19d5Gg2rstfzzc9el18iKTUFrC2B2oj5+8A5S49YY
         /moQ==
X-Gm-Message-State: AOAM531KEVMVQ/r98lxOSoVI8u+pX8tdsNZhx3GORLAbfZwUTWdL7m+J
        z7gpp/gZjct1vNmhKIT/KTT5eSCtWnnAXA9mgxoqO5AyeqE66NCq/IGHnZT2sihhxifpX17IDYe
        NeRsQMmEqead2
X-Received: by 2002:a17:907:7f88:b0:6fe:c708:198f with SMTP id qk8-20020a1709077f8800b006fec708198fmr43587487ejc.342.1654073843807;
        Wed, 01 Jun 2022 01:57:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzspdGAJ1tvlmp1pj2tAMQKYUyYFKr+aKmQzllLi1ycv3BYCEiI5u5Vw68OUVvqmMxRgWCtNA==
X-Received: by 2002:a17:907:7f88:b0:6fe:c708:198f with SMTP id qk8-20020a1709077f8800b006fec708198fmr43587459ejc.342.1654073843578;
        Wed, 01 Jun 2022 01:57:23 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id t6-20020a170906948600b006fed062c68esm448279ejx.182.2022.06.01.01.57.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 01:57:22 -0700 (PDT)
Message-ID: <2bdfde74-da27-667d-d1c4-3b17147cecce@redhat.com>
Date:   Wed, 1 Jun 2022 10:57:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: ...\n
Content-Language: en-US
To:     "Durrant, Paul" <pdurrant@amazon.co.uk>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     "Allister, Jack" <jalliste@amazon.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "diapop@amazon.co.uk" <diapop@amazon.co.uk>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "metikaya@amazon.co.uk" <metikaya@amazon.co.uk>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "x86@kernel.org" <x86@kernel.org>
References: <YpYaYK7a28DFT5Ne@hirez.programming.kicks-ass.net>
 <20220531140236.1435-1-jalliste@amazon.com>
 <YpYpxzt4rmG+LFy9@hirez.programming.kicks-ass.net>
 <059ab3327ac440479ecfdf49fa054347@EX13D32EUC003.ant.amazon.com>
 <YpcMw2TgNWzrcoRm@worktop.programming.kicks-ass.net>
 <87r148olol.fsf@redhat.com>
 <48edf12807254a2b86e339b26873bf00@EX13D32EUC003.ant.amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <48edf12807254a2b86e339b26873bf00@EX13D32EUC003.ant.amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/1/22 10:54, Durrant, Paul wrote:
> That is exactly the case. This is not 'some hare-brained money
> scheme'; there is genuine concern that moving a VM from old h/w to
> new h/w may cause it to run 'too fast', breaking any such calibration
> done by the guest OS/application. I also don't have any real-world
> examples, but bugs may well be reported and having a lever to address
> them is IMO a good idea. However, I also agree with Paolo that KVM
> doesn't really need to be doing this when the VMM could do the job
> using cpufreq, so we'll pursue that option instead. (FWIW the reason
> for involving KVM was to do the freq adjustment right before entering
> the guest and then remove the cap right after VMEXIT).

But if so, you still would submit the full feature, wouldn't you?

Paul, thanks for chiming in, and sorry for leaving you out of the list 
of people that can help Jack with his upstreaming efforts.  :)

Paolo

