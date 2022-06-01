Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F23539ECF
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 09:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350438AbiFAH5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 03:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347965AbiFAH5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 03:57:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7A2F8393D6
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 00:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654070238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O5QXms97mzjNRo1BpIafcf4zkMkOZgs+Ex4M5DhumCM=;
        b=Y5NoP5rQU6pZYuBMqOvcWNDtISpifR4Zzp6XzpXW3Dc5sKwZ1kXcTeRSs5RpCOzKl9mbD+
        V0yfHPoYoYSXWgPHgbUJLB+6oHIHXaUOTERZjDQmZ6PBcnnxDEB84k4hsjo5NO/RlSDcIq
        s2Iy0PdF7+HqRguhCWY6cNbDn5ilFuA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-70-vpyzcDAXOSWbwz-Q6IbgdA-1; Wed, 01 Jun 2022 03:57:17 -0400
X-MC-Unique: vpyzcDAXOSWbwz-Q6IbgdA-1
Received: by mail-ed1-f70.google.com with SMTP id f9-20020a056402354900b0042ded146259so669343edd.20
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 00:57:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=O5QXms97mzjNRo1BpIafcf4zkMkOZgs+Ex4M5DhumCM=;
        b=j4VVkm0D1bisi70sEbE5HOaAIblnZOfR8obyC6OpAM2aIiXY7nxvy0+jUKqY8qpBCZ
         0HHQopQ5Azws36SzhVtQFO+5lN1dl2cCsohp7GG7jYDroe8RdlImE0PzcTTtHQWFHYCW
         JYtXf3BhWMHoenb8FZN9JtLxRs+87RvBAKc6ySYkuhxSKjF+88K6NJADUhfSSJoN9iIb
         vxucjN8tCDGNhis9XN/DVGOsk2yDVfpL1M0S1Llwh5MIDFYyl2ZJkyebPOhDh+p3rrvP
         WX1WeO47MGeGxcwn/yEiFCOH1j31I6NujuodG8EuXWuzGRbz9dOALKLb6y3mANqfVQdB
         Ip8A==
X-Gm-Message-State: AOAM530VJ9AE/i42KVfTLXXasopgq3DjJwn1qh8rTlP6pZYjdfuNNkIW
        9L159qZF4C1oZO/RbbfXkXHFR4Pv3yJvGL+qADdZq0s96IPdg+IwY34Ef1nHUahvr2SV/bx02cT
        7Lq305pbhRhKk
X-Received: by 2002:a05:6402:51d3:b0:428:ce4a:69b with SMTP id r19-20020a05640251d300b00428ce4a069bmr69400356edd.72.1654070236293;
        Wed, 01 Jun 2022 00:57:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwi5I+nLMMpy7cXuMnhScbVTRxlJpybCoi3ZedzCKGjhqJcCbMbACRapQopdVWvDwrN5NGYnw==
X-Received: by 2002:a05:6402:51d3:b0:428:ce4a:69b with SMTP id r19-20020a05640251d300b00428ce4a069bmr69400329edd.72.1654070236103;
        Wed, 01 Jun 2022 00:57:16 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id a4-20020a1709065f8400b006f3ef214dfesm390234eju.100.2022.06.01.00.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 00:57:15 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Durrant, Paul" <pdurrant@amazon.co.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        "Allister, Jack" <jalliste@amazon.com>
Cc:     "bp@alien8.de" <bp@alien8.de>,
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
Subject: Re: ...\n
In-Reply-To: <307f19cc-322e-c900-2894-22bdee1e248a@redhat.com>
References: <YpYaYK7a28DFT5Ne@hirez.programming.kicks-ass.net>
 <20220531140236.1435-1-jalliste@amazon.com>
 <YpYpxzt4rmG+LFy9@hirez.programming.kicks-ass.net>
 <059ab3327ac440479ecfdf49fa054347@EX13D32EUC003.ant.amazon.com>
 <307f19cc-322e-c900-2894-22bdee1e248a@redhat.com>
Date:   Wed, 01 Jun 2022 09:57:14 +0200
Message-ID: <87tu94olyd.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 5/31/22 16:52, Durrant, Paul wrote:
>>> -----Original Message-----
>>> From: Peter Zijlstra <peterz@infradead.org>
>>> Sent: 31 May 2022 15:44
>>> To: Allister, Jack <jalliste@amazon.com>
>>> Cc: bp@alien8.de; diapop@amazon.co.uk; hpa@zytor.com; jmattson@google.com; joro@8bytes.org;
>>> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; metikaya@amazon.co.uk; mingo@redhat.com;
>>> pbonzini@redhat.com; rkrcmar@redhat.com; sean.j.christopherson@intel.com; tglx@linutronix.de;
>>> vkuznets@redhat.com; wanpengli@tencent.com; x86@kernel.org
>>> Subject: RE: [EXTERNAL]...\n
>>>
>>>
>>> On Tue, May 31, 2022 at 02:02:36PM +0000, Jack Allister wrote:
>>>> The reasoning behind this is that you may want to run a guest at a
>>>> lower CPU frequency for the purposes of trying to match performance
>>>> parity between a host of an older CPU type to a newer faster one.
>>>
>>> That's quite ludicrus. Also, then it should be the host enforcing the
>>> cpufreq, not the guest.
>> 
>> I'll bite... What's ludicrous about wanting to run a guest at a lower CPU freq to minimize observable change in whatever workload it is running?
>
> Well, the right API is cpufreq, there's no need to make it a KVM 
> functionality.

KVM may probably use the cpufreq API to run each vCPU at the desired
frequency: I don't quite see how this can be done with a VMM today when
it's not a 1-vCPU-per-1-pCPU setup.

-- 
Vitaly

