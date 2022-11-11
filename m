Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719FD625A5D
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 13:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbiKKMSE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 07:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbiKKMSB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 07:18:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395145B5A9
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 04:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668169027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5nR0UrKAt+mKIXqkj2J1zkaKe6Y1J5StNAPq9jHfPSo=;
        b=VRT/K3DVZzZ3Y5bDgsT+xICudAgBByW4xLWT2V2IozOn43obC4fII+Jp4ymo+1csftqglH
        LJfPBXfzyZUiyJeyvNo1eRlnP9tkEtJOMsjZPMaMbDlNvBKSEfMX/1Nl8g9GjpP+z2g4UE
        zXkQHVo35u2jCa9Xh8l70woPkhnf5Hk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-221-Md2N3wtCORqsMiCd2eZ8mQ-1; Fri, 11 Nov 2022 07:17:05 -0500
X-MC-Unique: Md2N3wtCORqsMiCd2eZ8mQ-1
Received: by mail-wm1-f72.google.com with SMTP id 1-20020a05600c028100b003cf7833293cso4336773wmk.3
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 04:17:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5nR0UrKAt+mKIXqkj2J1zkaKe6Y1J5StNAPq9jHfPSo=;
        b=ivmyc2nH4IdYvUfhyMZX4EwnPU3ChMCBuNfZMOfh+JH/SDBaI4We7qCxoW+Hy0ojl1
         P2UMx6Zc+nHaCIy1fbU4xRGa49HXVzIRFq/bECMqImjw+gjTAuBfenb0nabrGN7t2dfp
         FJFZoO+AU91PPCkY3J2l9Sv3NAZIAIfuxliycx7/huDQNtJgLTrZS3DAps4baeGjXeSX
         7VHLkdEI3M0bVfiuaz6rNAA40GZ4qgFLD/q7P7t/TAf/rAZnuENkvGVko4SOwzwvNjsw
         wijgrAcnO3LMLjxQSGEKmbLxx/o5nyQbmro75HsgJ9q2lwO6ZL23mfF7ObVDbFiT9Gfs
         C8FQ==
X-Gm-Message-State: ANoB5pmw/cFSkiCrzkSqenrpVYU/KcXKg/t+T2KjU8G2u17LKeTOfb+i
        ffXLt0IXP2OOBzTc9WJOJ71lQjIijvrUNpK9ipRsGuTUalyTdSi80/mHxJ0qc/MRvNn3JUxxuxM
        mvWNb39Cl74iK
X-Received: by 2002:a5d:58ee:0:b0:236:73ff:9cd0 with SMTP id f14-20020a5d58ee000000b0023673ff9cd0mr1043203wrd.628.1668169024294;
        Fri, 11 Nov 2022 04:17:04 -0800 (PST)
X-Google-Smtp-Source: AA0mqf64bTQQlUx/DdIG+J7TAAntiqmQ7ZLzr4eQbufvDdIir527pQnOWN78jF1jOgNuvRzweuvI8g==
X-Received: by 2002:a5d:58ee:0:b0:236:73ff:9cd0 with SMTP id f14-20020a5d58ee000000b0023673ff9cd0mr1043178wrd.628.1668169024010;
        Fri, 11 Nov 2022 04:17:04 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id k33-20020a05600c1ca100b003cf6c2f9513sm3222716wms.2.2022.11.11.04.17.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Nov 2022 04:17:03 -0800 (PST)
Message-ID: <e9ed7f8e-7236-c951-7a3d-c8128726c7d7@redhat.com>
Date:   Fri, 11 Nov 2022 13:17:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq() for
 NMI/IRQ reinjection
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        "Li, Xin3" <xin3.li@intel.com>,
        "linux-kernel@vger.kernnel.org" <linux-kernel@vger.kernnel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
References: <20221110055347.7463-1-xin3.li@intel.com>
 <20221110055347.7463-6-xin3.li@intel.com> <Y20f8v9ObO+IPwU+@google.com>
 <BN6PR1101MB2161C2C3910C2912079122D2A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y21ktSq1QlWZxs6n@google.com>
 <Y24Tm2P34jI3+E1R@hirez.programming.kicks-ass.net>
 <3A1B7743-9448-405A-8BE4-E1BDAB4D62F8@zytor.com>
 <Y24n4bHoFBuHVid5@hirez.programming.kicks-ass.net>
 <ef2c54f7-14b9-dcbb-c3c4-1533455e7a18@redhat.com>
 <Y247mQq0uAtFqCFQ@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y247mQq0uAtFqCFQ@hirez.programming.kicks-ass.net>
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


On 11/11/22 13:10, Peter Zijlstra wrote:
> *phew*, that sounds a*lot*  better than 'random'. And yes, that should
> do.
> 
> Another thing; these patches appear to be about system vectors and
> everything, but what I understand from Andrew is that VMX is only screwy
> vs NMI, not regular interrupts/exceptions, so where does that come from?

Exceptions are fine, for interrupts it's optional in theory but in 
practice you have to invoke them manually just like NMIs (I had replied 
on this in the other thread).

Paolo

> SVM specifically fixed the NMI wonkyness with their Global Interrupt
> flag thingy.
> 

