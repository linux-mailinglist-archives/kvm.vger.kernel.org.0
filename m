Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1301539449
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 17:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345902AbiEaPv5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 11:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345897AbiEaPv4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 11:51:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 823CF255BD
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 08:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654012313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gKY7+1hI0OcF1VmOLMsPVp2gaCidZW28lrPz7Mrrnkc=;
        b=gWS0HqboZ/Gt670lEfXv0UifOGOkbVQruWxTYw1W+FzXkert9DePhg6fhQgUT2QFGIPatC
        wcqZDsfL2/eI4Zk5Ubp8iSFJyeLRMXZH4KUpsIQr9hmfVYkz6JtNtD4IOtg4OzP/CkfoEy
        LgzGPwpmIxi64K6m1VJk+umN4wA5+g8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-N4onK49VPgmTFshwCR-LdA-1; Tue, 31 May 2022 11:51:52 -0400
X-MC-Unique: N4onK49VPgmTFshwCR-LdA-1
Received: by mail-ed1-f72.google.com with SMTP id t14-20020a056402020e00b0042bd6f4467cso10467252edv.9
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 08:51:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gKY7+1hI0OcF1VmOLMsPVp2gaCidZW28lrPz7Mrrnkc=;
        b=q7WyGmmxcWYFkhmq2483+0QqCabYcFsYOvHzsyGUlQbS7WXd/jfRrB0kDajgZdb3yS
         CkCcOYGrgvHovrgRSFhSLdWXYWD/ts2udNn4VsK0IqMMd2oO3Fkwh60YWwHTlKXK7lSf
         kxAnRVeOzED7YkO+Syuxi6GY9ja42bkMXg38avMlNF5JCQbgkxzgLyoj2dzPthvj/6OP
         Sl9H0g+ooxotER3/8Cx36A9EdJ7jEY+aRYIJn/LT6xZ5YR/cVnxqsq5DnQ+DIWsXPgmi
         Ayh2q2cIHeKyp3Zv1VpW4X6Tv8/iJDwPM7V04ijLpnjvZHLc3MZUawlArApDcxEiwnDW
         M/lg==
X-Gm-Message-State: AOAM531WKmEAxfw8dRW1F9FaYTdplF/UCMXYpIoWu6Qb5Rz8dCxFsgDs
        USVc34CiXQHBh5onGBYU1UvqDA3QlH0Q/8tSigsWylgrxb84IOSBU1VR1+XkBMWywnpM3lZliyK
        u/gwlIEp0KrQ3
X-Received: by 2002:a05:6402:42c8:b0:42d:f0b0:c004 with SMTP id i8-20020a05640242c800b0042df0b0c004mr661142edc.356.1654012311082;
        Tue, 31 May 2022 08:51:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy5SLFg9S7qn51mqnz1euHAeg2XjFbbts8AKfsa6YVE0htxYYVfG/wmrItiD64Z/o0wh4KlPw==
X-Received: by 2002:a05:6402:42c8:b0:42d:f0b0:c004 with SMTP id i8-20020a05640242c800b0042df0b0c004mr661115edc.356.1654012310897;
        Tue, 31 May 2022 08:51:50 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id j4-20020a508a84000000b0042aa153e73esm8802086edj.12.2022.05.31.08.51.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 08:51:50 -0700 (PDT)
Message-ID: <307f19cc-322e-c900-2894-22bdee1e248a@redhat.com>
Date:   Tue, 31 May 2022 17:51:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: ...\n
Content-Language: en-US
To:     "Durrant, Paul" <pdurrant@amazon.co.uk>,
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
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "x86@kernel.org" <x86@kernel.org>
References: <YpYaYK7a28DFT5Ne@hirez.programming.kicks-ass.net>
 <20220531140236.1435-1-jalliste@amazon.com>
 <YpYpxzt4rmG+LFy9@hirez.programming.kicks-ass.net>
 <059ab3327ac440479ecfdf49fa054347@EX13D32EUC003.ant.amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <059ab3327ac440479ecfdf49fa054347@EX13D32EUC003.ant.amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/31/22 16:52, Durrant, Paul wrote:
>> -----Original Message-----
>> From: Peter Zijlstra <peterz@infradead.org>
>> Sent: 31 May 2022 15:44
>> To: Allister, Jack <jalliste@amazon.com>
>> Cc: bp@alien8.de; diapop@amazon.co.uk; hpa@zytor.com; jmattson@google.com; joro@8bytes.org;
>> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; metikaya@amazon.co.uk; mingo@redhat.com;
>> pbonzini@redhat.com; rkrcmar@redhat.com; sean.j.christopherson@intel.com; tglx@linutronix.de;
>> vkuznets@redhat.com; wanpengli@tencent.com; x86@kernel.org
>> Subject: RE: [EXTERNAL]...\n
>>
>>
>> On Tue, May 31, 2022 at 02:02:36PM +0000, Jack Allister wrote:
>>> The reasoning behind this is that you may want to run a guest at a
>>> lower CPU frequency for the purposes of trying to match performance
>>> parity between a host of an older CPU type to a newer faster one.
>>
>> That's quite ludicrus. Also, then it should be the host enforcing the
>> cpufreq, not the guest.
> 
> I'll bite... What's ludicrous about wanting to run a guest at a lower CPU freq to minimize observable change in whatever workload it is running?

Well, the right API is cpufreq, there's no need to make it a KVM 
functionality.

Paolo

