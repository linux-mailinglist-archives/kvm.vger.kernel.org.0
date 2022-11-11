Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B0C625AB3
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 13:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbiKKMtz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 07:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233734AbiKKMt3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 07:49:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053179FE4
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 04:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668170910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l68F1qZMVvbDKVgrBPDD9FNz5sFjCB0hE8JMkh0Y524=;
        b=I/ZrKtBbaJe2TnyQ33OFzvCHu0qduJQcHnB7k1bOf6+07G5plMPP+SfkCY/7sfGzLc4vj6
        PNqgv9LCwJ0lDCkDe4L3uiBKzAp6jnZMwyLkl/WccSwDvuK90xkwbfu0Uqi8sp6l72V+2z
        FxfwMuw0dy+InpIJmdgx7JMxllYbeIw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-104-_bp96qFeNpm1PSFxQJY_SQ-1; Fri, 11 Nov 2022 07:48:29 -0500
X-MC-Unique: _bp96qFeNpm1PSFxQJY_SQ-1
Received: by mail-wr1-f71.google.com with SMTP id i12-20020adfaacc000000b0023cd08e3b56so993787wrc.12
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 04:48:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l68F1qZMVvbDKVgrBPDD9FNz5sFjCB0hE8JMkh0Y524=;
        b=LxzncQKBX/WfjFd8FhKLpY9mjYo402aQYjUPsN2+f4+mCjU247kGyLyHbuZmKDcz1u
         JXcRN8V9JOR25HeJ4YNjMu0cnHYoA0WDPdCRi65v1eKvbIjKEZV+SA7mtn0RuPmWB2Ld
         jDRTkJfVDHHiMGQXo1Vcwso61rXToVJqb+pvTUPnnPl+ZAyayTpVX0s3qiGuNbYMqft/
         4DDJlY71PgMUiVfVPo0MQgr0VdmN3w1PA4ySiiB4n7jagSZ4SErewonj9/XiUDbnJAVd
         BYGAlDDGqFFUVynsB6An/cDhJvVTyEc/P0vMTgO4RucOrgkNBj3SDfKn85no4sHICMB2
         +jyg==
X-Gm-Message-State: ANoB5pnWIY+UflUypI7yo5G0MFUJ6LgwoMjf8jcskky+J9vUF0afQu31
        +nWi0vo743WpMRSlPDldIKWjF1vL3iDg7VN+Sg6Lbg+fRh+U/SoAJHKaE4NDhZ4N+0BE175iRb7
        lmdMu1pbF8LSQ
X-Received: by 2002:adf:ce88:0:b0:23a:ce24:1bf0 with SMTP id r8-20020adfce88000000b0023ace241bf0mr1131540wrn.383.1668170908260;
        Fri, 11 Nov 2022 04:48:28 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4Y976AWKnKuAOShS8jdPcXzx2Ubo9o7t+QtwJANzTT3yqsZSmwSyfrOWWbv2hMw4+jn89rQg==
X-Received: by 2002:adf:ce88:0:b0:23a:ce24:1bf0 with SMTP id r8-20020adfce88000000b0023ace241bf0mr1131524wrn.383.1668170907991;
        Fri, 11 Nov 2022 04:48:27 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id c5-20020adffb45000000b002366d1cc198sm1774062wrs.41.2022.11.11.04.48.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Nov 2022 04:48:27 -0800 (PST)
Message-ID: <6fd26a70-3774-6ae7-73ea-4653aee106f0@redhat.com>
Date:   Fri, 11 Nov 2022 13:48:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     "Li, Xin3" <xin3.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-6-xin3.li@intel.com>
 <Y2y+YgBUYuUHbPtd@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161976800EB14B74A24D9F3A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y24SoNKZtj/NPSGy@hirez.programming.kicks-ass.net>
 <6097036e-063f-5175-72b2-8935b12af853@redhat.com>
 <Y24908NWCdzUNqI0@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y24908NWCdzUNqI0@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/22 13:19, Peter Zijlstra wrote:
> On Fri, Nov 11, 2022 at 01:04:27PM +0100, Paolo Bonzini wrote:
>> On Intel you can optionally make it hold onto IRQs, but NMIs are always
>> eaten by the VMEXIT and have to be reinjected manually.
> 
> That 'optionally' thing worries me -- as in, KVM is currently
> opting-out?

Yes, because "If the “process posted interrupts” VM-execution control is 
1, the “acknowledge interrupt on exit” VM-exit control is 1" (SDM 
26.2.1.1, checks on VM-Execution Control Fields).  Ipse dixit.  Posted 
interrupts are available and used on all processors since I think Ivy 
Bridge.

(sorry about splitting the replies across two threads)

Paolo

