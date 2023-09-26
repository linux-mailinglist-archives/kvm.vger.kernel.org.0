Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 285917AF0DA
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 18:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbjIZQhf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 12:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233879AbjIZQhe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 12:37:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1A2124
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 09:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695746214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kwn+Y2/3Lb7G0UxCRBVpYop5K/bVWNWfnHKf0b40Tss=;
        b=E4WVV0fLI3XnBwUT1+XsPwFCdN2bq0rB/ZsWDTjxSK0Z21IOqiLwLodRTdlAjSKydMG4FN
        zbUQkz61RI/hcw9Z4MorxJIbHOJKW38KSao0XQj015/EiFxnvW+/ptf/SULu5yJlVXGtvq
        ohUPzdEX95v5i/wl+wxll0L2PExWQ/M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-tBbNnWOXPhGpihjVFX4HCw-1; Tue, 26 Sep 2023 12:36:53 -0400
X-MC-Unique: tBbNnWOXPhGpihjVFX4HCw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f42bcef2acso78550275e9.2
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 09:36:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695746212; x=1696351012;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kwn+Y2/3Lb7G0UxCRBVpYop5K/bVWNWfnHKf0b40Tss=;
        b=afADEmAF+9RESNm+95dG/Z8A4/Hq+km5MR+1B1lidB1hv2UmscjBJX4oa0Q2HQV0/Q
         KVODSyiS8gRpbznUhJpLzYnn/KE3JbEPWgr4C/PUhRaKNzPsCsonwCQQbcNkx7UDHS7T
         a0TIWhVGOakyidouBCCqldEGmxKs67VXfmJ8JNpBum3jV+Mi/mSiR8WU72T4yayMTrxV
         RTAqapj5gk2+Yd/+w024V3LJ3QDmnTp0LEpt3SeZHtS2Jp751wA5DL+zNg/wcKMWlI6a
         AXXe6+hBuITKel5ec1dAU5ncuxN8S9uiAQ3wCGawO/YhsHsTvBemvr0XSfDdKbA2C85J
         zawQ==
X-Gm-Message-State: AOJu0YyDaLvw1K+fFjmZVbIxgpW/8/7k33zcXYcSmLHVCqN/+cdHhi47
        nA8RgMnif8p418k6sIAitwaDclqc9oyC2KAd7lsqtIlfOW9jotWPl6fI+MGw+KhkGbVcApliFdf
        v21LmGjGvf3x1
X-Received: by 2002:a05:600c:310d:b0:405:959e:dc79 with SMTP id g13-20020a05600c310d00b00405959edc79mr4523732wmo.37.1695746211870;
        Tue, 26 Sep 2023 09:36:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPe3hnMTPEM/AxRFgRHfDLU7UP3Ocp6QTz9J/GjLvhtxRI/bAlHI/7d0inLqttqPjjFRHJew==
X-Received: by 2002:a05:600c:310d:b0:405:959e:dc79 with SMTP id g13-20020a05600c310d00b00405959edc79mr4523711wmo.37.1695746211487;
        Tue, 26 Sep 2023 09:36:51 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id v19-20020a05600c429300b004047ac770d1sm13421784wmc.8.2023.09.26.09.36.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Sep 2023 09:36:50 -0700 (PDT)
Message-ID: <ef6a0ebf-cb5f-0bb0-f453-0e9e0fdc87d5@redhat.com>
Date:   Tue, 26 Sep 2023 18:36:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 0/4] KVM: x86: tracepoint updates
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>
References: <20230924124410.897646-1-mlevitsk@redhat.com>
 <ZRIf1OPjKV66Y17/@google.com>
 <abd13162f106c5ce86c211fc9d32d901ab34500b.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <abd13162f106c5ce86c211fc9d32d901ab34500b.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/26/23 10:28, Maxim Levitsky wrote:
>> trace_kvm_exit is good example, where despite all of the information that is captured
>> by KVM, it's borderline worthless for CPUID and MSR exits because their interesting
>> information is held in registers and not captured in the VMCS or VMCB.
>>
>> There are some on BTF type info issues that I've encountered, but I suspect that's
>> as much a PEBKAC problem as anything.
>>
> While eBPF has its use cases, none of the extra tracepoints were added solely because of
> the monitoring tool and I do understand that tracepoints are a limited resource.
> 
> Each added tracepoint/info was added only when it was also found to be useful for regular
> kvm tracing.

I am not sure about _all_ of them, but I agree with both of you.

On one hand, it would be pretty cool to have eBPF access to registers. 
On the other hand, the specific info you're adding is generic and I 
think there are only a couple exceptions where I am not sure it belongs 
in the generic KVM tracepoints.

Paolo

