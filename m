Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09E9F52D419
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238345AbiESNb4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235342AbiESNbx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:31:53 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114512CE23;
        Thu, 19 May 2022 06:31:52 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d22so4792139plr.9;
        Thu, 19 May 2022 06:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=NeBhBDbLvND8TXeCRztU3OoO0UgF77pFRvz7RKCrOXE=;
        b=qCihqc2ueuq0ep5U2t2Yk+coPUZ5bLTTvg6iGnfg6JSitGwLYLNHBRe+A9ojsKO4Xw
         lQx8l7egXFo3SitSVionCf7skJKIPE7y2IE86dJn9O9MRlzLUGo/R+UhVkOmNtCRFbp/
         6kg3Jti6oExWDjraoUteTqSLNbKvFlvPSW9JbxpJmpv4E8uITu+JBjPNcN7MWnCj9IcS
         B3f/k88LJ/PJBfIxSSVJ2HVN14Iwz/8QGZT8+y0gDE8WDiGSdVOmTUnrcf0C1+o2piXx
         GrrpcN8+5tX4rDQlDP0cRjja7Ga3oib9FFc8BOQAlcQ9fymyStq5qS/qt4X5+IKgRveO
         20fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NeBhBDbLvND8TXeCRztU3OoO0UgF77pFRvz7RKCrOXE=;
        b=5G1QvuE9JJb/MBogdvvnkK5P60fH+aawh5iCyui9oR145t17cPEyd7CUt8dHgjVL0k
         oCzBcipnYxUqboJwtDiaRKu+SVwNA8Cz7RLjfpc60y350aEVIfW5NNPYurNf2eO9puS2
         G/JX0HHpcB1lyh/a2DnvZhNy8MwNjFTJW7zvrnfSlllr4cQE1xMJnZxuEWA71g3t/cTW
         8eHfnQEpcoabVK3PT5OX8mOVEC50VXDWvSUPeBp1tNZAtJqRughiGG4hyW/nwrN6xQwd
         8R67/zeY6OB+aiUGOSl0cOSjCPCkAfIVp9QYKohXb29g2Jj35HWlYfj3PwF4a+tSDMYA
         BM+g==
X-Gm-Message-State: AOAM5313DUJhEWSxvYBuwB1cMIWH35hpSebDaUaCCeOICWSnQ7EBSAXF
        6Mevol7hRb7TDemJmz7Ivgc=
X-Google-Smtp-Source: ABdhPJzje9/9enhIU8B7DPtTNIzLDHv31g/rhqCVLWPzu3d35117+jsw135QPxrsPBI2grjOaMvP6w==
X-Received: by 2002:a17:90b:4d8c:b0:1df:8f22:b699 with SMTP id oj12-20020a17090b4d8c00b001df8f22b699mr5337535pjb.152.1652967111496;
        Thu, 19 May 2022 06:31:51 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.80])
        by smtp.gmail.com with ESMTPSA id o6-20020a62f906000000b0050dc76281fcsm4170777pfh.214.2022.05.19.06.31.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 May 2022 06:31:50 -0700 (PDT)
Message-ID: <e0b96ebd-00ee-ead4-cf35-af910e847ada@gmail.com>
Date:   Thu, 19 May 2022 21:31:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH RESEND v12 00/17] KVM: x86/pmu: Add basic support to
 enable guest PEBS via DS
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
References: <20220411101946.20262-1-likexu@tencent.com>
 <87fsl5u3bg.fsf@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <87fsl5u3bg.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/5/2022 8:14 pm, Vitaly Kuznetsov wrote:
> Like Xu <like.xu.linux@gmail.com> writes:
> 
> ...
> 
> Hi, the following commit
> 
>>    KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS
> 
> (currently in kvm/queue) breaks a number of selftests, e.g.:

Indeed, e.g.:

x86_64/hyperv_clock
x86_64/max_vcpuid_cap_test
x86_64/mmu_role_test

> 
> # ./tools/testing/selftests/kvm/x86_64/state_test

This test continues to be silent after the top commit a3808d884612 ("KVM: x86/pmu:
Expose CPUIDs feature bits PDCM, DS, DTES64"), which implies a root cause.

Anyway, thanks for this git-bisect report.

> ==== Test Assertion Failure ====
>    lib/x86_64/processor.c:1207: r == nmsrs
>    pid=6702 tid=6702 errno=7 - Argument list too long
>       1	0x000000000040da11: vcpu_save_state at processor.c:1207 (discriminator 4)
>       2	0x00000000004024e5: main at state_test.c:209 (discriminator 6)
>       3	0x00007f9f48c2d55f: ?? ??:0
>       4	0x00007f9f48c2d60b: ?? ??:0
>       5	0x00000000004026d4: _start at ??:?
>    Unexpected result from KVM_GET_MSRS, r: 29 (failed MSR was 0x3f1)
> 
> I don't think any of these failing tests care about MSR_IA32_PEBS_ENABLE
> in particular, they're just trying to do KVM_GET_MSRS/KVM_SET_MSRS.
> 
