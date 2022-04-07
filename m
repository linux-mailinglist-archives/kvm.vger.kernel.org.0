Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7054F8047
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 15:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241201AbiDGNRG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 09:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbiDGNRF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 09:17:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E0CF817539B
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 06:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649337301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=udxygKvlwgxmrvFQRGMm3xyqxn601rj4KdSJI9OKca0=;
        b=V1XjBcRsiemY9Y0Ce1uLSF3j0uG/gCtlIlxvpdtJL91eIQB8Sxtj2qJaick8t+mFbHo402
        9KP/9IXqh+s3DZpAfnV6amu9xRa0dCzHV73GwYRaFiA9gVFHSAS3XqPpG/Y1p1JCf5eJdu
        dhUMsTPzDrbSx9jMbBs6a24sNmshoug=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-90-N-tjGXWXMbi9BevSbj7AyQ-1; Thu, 07 Apr 2022 09:15:00 -0400
X-MC-Unique: N-tjGXWXMbi9BevSbj7AyQ-1
Received: by mail-ed1-f69.google.com with SMTP id v5-20020aa7d645000000b0041ce08ab5afso2939237edr.6
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 06:15:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=udxygKvlwgxmrvFQRGMm3xyqxn601rj4KdSJI9OKca0=;
        b=rXCMbyfybsR+aAsC2ksXsFxWab26yRRx1v30QwwNWIsFSuwLq29g7YuaVVAiGD1Ewl
         bE1gp6P6O1Q4G7mVlBf7m0dk11JG0yMs3oXywmODDGcyGbgn8+AwgLkwFt14Sr1QdwG1
         Qd+/B8i4Sw1qVeA3toZahN4jX5G+I0o8WxsU7BuOnB60Y4WbxCo9LXYc86mC7bdcyiI6
         PAJtDkjl/zvsflU53Ozok/TtSeQ14cnqd/s2fXs+OAnTXea8Q9nlkbA2BXoI5+IyPeOc
         VdcBJL8BVv1dAICCBM2dqqGqOWJsFFG534qxD4CqVbRXLfMb36X8KF9KikK8sYdi3s3w
         1xGg==
X-Gm-Message-State: AOAM5338RVfAnhx4fY0sVlCThrx9H+Ck/jHVcua6uUTJME6pHe/xJfOF
        d/UayWsye4E0M4ob6Tr3feZTndcg7ulDP6rFAsbWkYckJmSGWVsM75YVX2V/B/VrfXgo0UJ5l/g
        2jRG6drShHewd
X-Received: by 2002:a17:907:1c20:b0:6e4:b753:93fc with SMTP id nc32-20020a1709071c2000b006e4b75393fcmr13277228ejc.363.1649337299497;
        Thu, 07 Apr 2022 06:14:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmZYQ3ay23HA1zsX8EaoXjDU6Mev9H0qIxUfrwm2VhF2YVOmFSt7Z/m1lFcvcz8wEQHikrsw==
X-Received: by 2002:a17:907:1c20:b0:6e4:b753:93fc with SMTP id nc32-20020a1709071c2000b006e4b75393fcmr13277200ejc.363.1649337299226;
        Thu, 07 Apr 2022 06:14:59 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id d12-20020a50cf4c000000b0041cc12dc1f3sm6542752edk.71.2022.04.07.06.14.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 06:14:58 -0700 (PDT)
Message-ID: <23189be4-4410-d47e-820c-a3645d5b9e6d@redhat.com>
Date:   Thu, 7 Apr 2022 15:14:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 089/104] KVM: TDX: Add a placeholder for handler of
 TDX hypercalls (TDG.VP.VMCALL)
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <b84fcd9927e49716de913b0fe910018788aaba46.1646422845.git.isaku.yamahata@intel.com>
 <3042130fce467c30f07e58581da966fc405a4c6c.camel@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <3042130fce467c30f07e58581da966fc405a4c6c.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/7/22 06:15, Kai Huang wrote:
>>   
>> +static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
>> +
>> +	if (unlikely(tdx->tdvmcall.xmm_mask))
>> +		goto unsupported;
> Put a comment explaining this logic?
> 

This only seems to be necessary for Hyper-V hypercalls, which however 
are not supported by this series in TDX guests (because the 
kvm_hv_hypercall still calls kvm_*_read, likewise for Xen).

So for now this conditional can be dropped.

Since

