Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C550C4AD67B
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 12:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350156AbiBHL0K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 06:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356116AbiBHKKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 05:10:33 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13065C03FEC0;
        Tue,  8 Feb 2022 02:10:33 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id on2so7366260pjb.4;
        Tue, 08 Feb 2022 02:10:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=9N9L4dN/+O42RdNqPa0c7EN++tLooOLaX6Ua4iCm1C4=;
        b=VJGmLXkLYWP/fkapKbAywvMBkmheSaOK6tSVXry4w3Yr1EhLO4aqKXvm8NEpUQonnn
         MEYvTU1xSm5rEiqe1j3eoY7RKPZgqquIk104XEbE6h9v3+Hqhfj5xzn41B61JmbqLQQP
         f0nFsENmOURm0q0Q/NP07syHvUoR/fYLL8tU7cochCk1AhVERMAh6Un/EXTnj+KzCGRT
         +h15JezsAX81cnEGRKL0BQAlXTBEYJ4cZ3BK5eSzfKB7vJW3BHsVZHmj+1d1xkLBCdjP
         yQ/0mxpuHpOSeQAg+atISm7ALk1kL2ikUfkPpSo18aqdw3Y33xUxaj4jcBj4UM9bS4pP
         Ge7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=9N9L4dN/+O42RdNqPa0c7EN++tLooOLaX6Ua4iCm1C4=;
        b=kZQDbZGoSfr1Kv/BsRydtZPHDnCNTz8K22UmQwE3jwfSzilqLEzOOjJrPPiVCPqExy
         guJhK0V2DpLa/1MRNyz6CyURvCWR36QlUbugD9YbTARgt7uPRsT9F+h/ady4aUU5iYse
         8Q+XhxKGhzalko0dJ05WzsW8pAHhKngs948+WPYQcVDnK6J3XJiv0CWgHfSA9IR2iasb
         VnbE+h5nNUZ55ffRiBVkgxGr8hw7q9T3o2ojmxcdaox+huW+XJsDqiBqnkkglkokvwSG
         D91iRM1I0riSeW/9jnIVitqgEoHCoRWDUS5uVMLtQT5baOmRuLzUFA0XzjFpZT8EK8gW
         3z2A==
X-Gm-Message-State: AOAM531JtDZVsvgqreJ5hrHlQhuRlIcg2vdYAGbLc8+ly+KSZs5Aq8UM
        iq4z85JVsY3zoy+//1hoK+M=
X-Google-Smtp-Source: ABdhPJzFsXTVieyXIcOacrZ2FFwAwXtK3QcXv+aWceASGOqhsu1d11Fvko4jLFVl4j9NpK+hQ/n/ng==
X-Received: by 2002:a17:902:6b06:: with SMTP id o6mr3631677plk.162.1644315032532;
        Tue, 08 Feb 2022 02:10:32 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id il18sm2337123pjb.27.2022.02.08.02.10.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 02:10:31 -0800 (PST)
Message-ID: <4a8beb6d-1589-7f53-881f-8faaeb52f7ba@gmail.com>
Date:   Tue, 8 Feb 2022 18:10:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH kvm/queue v2 3/3] KVM: x86/pmu: Setup the
 {inte|amd}_event_mapping[] when hardware_setup
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>
References: <20220117085307.93030-1-likexu@tencent.com>
 <20220117085307.93030-4-likexu@tencent.com>
 <13de6271-61bc-7138-15b3-9241508d94fa@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <13de6271-61bc-7138-15b3-9241508d94fa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/2/2022 8:28 pm, Paolo Bonzini wrote:
> On 1/17/22 09:53, Like Xu wrote:
>> +
>> +    for (i = 0; i < PERF_COUNT_HW_MAX; i++) {
>> +        config = perf_get_hw_event_config(i) & 0xFFFFULL;
>> +
>> +        kernel_hw_events[i] = (struct kvm_event_hw_type_mapping){
>> +            .eventsel = config & ARCH_PERFMON_EVENTSEL_EVENT,
>> +            .unit_mask = (config & ARCH_PERFMON_EVENTSEL_UMASK) >> 8,
>> +            .event_type = i,
>> +        };
> 
> Should event_type be PERF_COUNT_HW_MAX if config is zero?

Emm, we do not assume that the hardware event encoded with "eventsel=0 && 
unit_mask=0"
(in this case, config is zero) are illegal.

If perf core puts this encoded event into "enum perf_hw_id" table as this part 
is out of the scope of
KVM, we have to setup with a valid event_type value instead of PERF_COUNT_HW_MAX.

In this proposal, the returned perf_hw_id from kvm_x86_ops.pmu_ops->pmc_perf_hw_id()
is only valid and used if "pmc->eventsel & 0xFFFFULL" is non-zero, otherwise the
reprogram_gp_counter() will fall back to use PERF_TYPE_RAW type.

Please let me know if you need more clarification on this change.

> 
> Thanks,
> 
> Paolo
> 
