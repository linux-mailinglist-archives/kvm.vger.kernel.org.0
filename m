Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB7A508B64
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 17:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379922AbiDTPDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 11:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379875AbiDTPCz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 11:02:55 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1428110FC6;
        Wed, 20 Apr 2022 08:00:07 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id x3so1382967wmj.5;
        Wed, 20 Apr 2022 08:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:content-language:to
         :cc:references:from:subject:in-reply-to:content-transfer-encoding;
        bh=OxqISZ3PhyCe5pZOlEZIasOqnMsXsO76KKiBjnHunxA=;
        b=lFQcgrWobsgpW7viU3ZTb9wdOFGUZDGqwSyg0cV7Kli9Azkgk7Cpjo1qsoJzvkwAoI
         OAde/6iSG5xnggIrmJRXGXr0qAG2EDMbUPGxEvXLJz4KJu9jqH4WBYDbpyquK/JZ64bF
         r5+Z532/g0SeC8v+uvJj230tK5OegzCd0pag9kU3Q0QRLnskAnksihWeFsAQjmFSTFb5
         BZ6NV7HCgHb7Bw2OFCQ5YE/xXkXAE9rn9w4hRkfvalPy40nF12xAO2g5Za09Z91PdStH
         krV6lG9NUkAZFHhP/Q4fqvrVvilDEq3uHlsRU4AJvMYQcXzO6S+V4iRuATH4jzffpgCz
         R76g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=OxqISZ3PhyCe5pZOlEZIasOqnMsXsO76KKiBjnHunxA=;
        b=ovBAlsWWWX2AFGYLe/8wRMG3qkYVl2tLRduEzVU/bQppeeK8F/aa95rwH258DUVUd4
         fau081hE68l17XdbGjj+PdAz7I3qFIjkNvpQcppMbR9m4wIcypcVsqqRT/+c/ftPcC7g
         kU6XY4tyzWGgDqx5hodJOkbTGcqQ/W7k3eKUN07PIZXA415TdYCaR6ciorojEbmBugNW
         M3WY55KwaEAEJW+gWtg+i85IVQmOU/amxBtDYygWapYkpdyl7QzW1pwVOiRLNRwKLq7/
         p40Rtz67DW7rVD2fJnc592To5y6zq5iBx2zY43QbObQ9iLvy2mKpXW05aaAyHqlJ/LGP
         zscw==
X-Gm-Message-State: AOAM532wZqo5n0/c4qOlHdayDW8YsnW4OclbaIa1FKrrCmlY5oizkpQP
        7ujud1+77Mp8UPAVNmZGeCI=
X-Google-Smtp-Source: ABdhPJwnr4sQBBSJEglycv2Tu5vNhaI8eNnAP0123HsG2diJW30WuE7yrKnypB1R6AEhTkpqKqV15g==
X-Received: by 2002:a05:600c:4ed4:b0:392:90a5:b7e6 with SMTP id g20-20020a05600c4ed400b0039290a5b7e6mr4255941wmq.33.1650466805548;
        Wed, 20 Apr 2022 08:00:05 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id e16-20020a05600c2dd000b0038ed449cbdbsm114678wmh.3.2022.04.20.08.00.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Apr 2022 08:00:04 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <4505b43d-5c33-4199-1259-6d4e8ebac1ec@redhat.com>
Date:   Wed, 20 Apr 2022 17:00:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220402010903.727604-1-seanjc@google.com>
 <20220402010903.727604-2-seanjc@google.com>
 <112c2108-7548-f5bd-493d-19b944701f1b@maciej.szmigiero.name>
 <YkspIjFMwpMYWV05@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/8] KVM: nSVM: Sync next_rip field from vmcb12 to vmcb02
In-Reply-To: <YkspIjFMwpMYWV05@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/4/22 19:21, Sean Christopherson wrote:
> On Mon, Apr 04, 2022, Maciej S. Szmigiero wrote:
>>> @@ -1606,7 +1622,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>>>    	nested_copy_vmcb_control_to_cache(svm, ctl);
>>>    	svm_switch_vmcb(svm, &svm->nested.vmcb02);
>>> -	nested_vmcb02_prepare_control(svm);
>>> +	nested_vmcb02_prepare_control(svm, save->rip);
>>
>> 					   ^
>> I guess this should be "svm->vmcb->save.rip", since
>> KVM_{GET,SET}_NESTED_STATE "save" field contains vmcb01 data,
>> not vmcb{0,1}2 (in contrast to the "control" field).
> 
> Argh, yes.  Is userspace required to set L2 guest state prior to KVM_SET_NESTED_STATE?
> If not, this will result in garbage being loaded into vmcb02.
> 

Let's just require X86_FEATURE_NRIPS, either in general or just to
enable nested virtualiazation, i.e.:

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fc1725b7d05f..f8fc8a1b09f1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4904,10 +4904,12 @@ static __init int svm_hardware_setup(void)
  			goto err;
  	}
  
-	if (nrips) {
-		if (!boot_cpu_has(X86_FEATURE_NRIPS))
-			nrips = false;
-	}
+	if (!boot_cpu_has(X86_FEATURE_NRIPS))
+		nrips = false;
+	if (nested & !nrips) {
+		pr_warn("Next RIP Save not available, disabling nested virtualization\n");
+		nested = false;
+	}
  
  	enable_apicv = avic = avic && npt_enabled && (boot_cpu_has(X86_FEATURE_AVIC) || force_avic);
  

If I looked it up correctly it was introduced around 2010-2011.

Paolo
