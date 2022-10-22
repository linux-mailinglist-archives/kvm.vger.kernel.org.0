Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98188608B12
	for <lists+kvm@lfdr.de>; Sat, 22 Oct 2022 11:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbiJVJ1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Oct 2022 05:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbiJVJ1E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Oct 2022 05:27:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E983F314186
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 01:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666427804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jAgblVGXB5WEpCgDpaBdHs9YL/jEXwZ4f4yuamGfAjs=;
        b=CELQ6Pv/JX/vDV2UlYyY61/isfEODas+j1WcZnD77YjYbR06Kdc4WadD+Lo2jgDr7aDw8s
        8XGwFaDeptJ9GO3X4i4ktB641W08q8eG46jX3B1KovdV/EtSIzDM/WUi/34P6dX3xdaA40
        RomupQCBG6Z4YH8Ui0oB1Zmlw8KiT+k=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-640-64v6gWBLOKW6iKZRCYeF5Q-1; Sat, 22 Oct 2022 04:36:42 -0400
X-MC-Unique: 64v6gWBLOKW6iKZRCYeF5Q-1
Received: by mail-ed1-f69.google.com with SMTP id z11-20020a056402274b00b0045ca9510fc8so4903379edd.23
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 01:36:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jAgblVGXB5WEpCgDpaBdHs9YL/jEXwZ4f4yuamGfAjs=;
        b=ZmKpZloAlGWm1R71wl5kbJuN4wKBfwnL4mxdc6chF9YNEaTpjTFKxpUIKjAPlzyPz9
         dsvijN4oSkEc0zBLCMpIhBdjsd66CNQtcxNk1i4C4XAZ8cblwUN2pLE+TdnP7/3yOrQR
         ATrESYjO4mu2o8FLL0whSghek61bFfHnd2j90mg9/l/0e/VGAVg5mz//2dG8/1b8r9OC
         YiN9xVl25QEf3P6N2r6jtC25RbaFZhI5+/IW5EAycDqyqyXWDSyk6DLZxwuaOtnZZY9T
         RrScClfKHj1kk+uF84GMknw2loO9kg1tit/zhpu7RX1y4DJtJCPOfkJRobPC2klEaQEN
         lxag==
X-Gm-Message-State: ACrzQf32PYiqPrlUa4C9K6IYhP5rlDm4bSWcq0aiEuhhTxYLCskAIL8F
        jQKxLVMsC+QoXBvIjGozVo//2QynnMBX9gMPTe9FMfNrt9/sFPUW5j2pAPuAaxh6jcvEDOo9+wk
        0zb0DYI0RBdtN
X-Received: by 2002:a17:907:9493:b0:796:1166:70c4 with SMTP id dm19-20020a170907949300b00796116670c4mr12766544ejc.59.1666427800738;
        Sat, 22 Oct 2022 01:36:40 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5VPBT2q6zYsMvhqaw8L+a80eDrMu7V/+NPOaZGKJYudTbntG1SbMNldZkWPgsb8wvgNpB+KQ==
X-Received: by 2002:a17:907:9493:b0:796:1166:70c4 with SMTP id dm19-20020a170907949300b00796116670c4mr12766535ejc.59.1666427800487;
        Sat, 22 Oct 2022 01:36:40 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:2f4b:62da:3159:e077? ([2001:b07:6468:f312:2f4b:62da:3159:e077])
        by smtp.googlemail.com with ESMTPSA id jy17-20020a170907763100b00781d411a63csm12610779ejc.151.2022.10.22.01.36.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Oct 2022 01:36:39 -0700 (PDT)
Message-ID: <5064c01e-0d6d-c7da-8f4a-29dd70a3dde8@redhat.com>
Date:   Sat, 22 Oct 2022 10:36:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 1/6] KVM: x86: Mask off reserved bits in CPUID.80000001H
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org
References: <20220929225203.2234702-1-jmattson@google.com>
 <Y1CBJT9MhpYEB586@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y1CBJT9MhpYEB586@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/20/22 00:58, Sean Christopherson wrote:
> On Thu, Sep 29, 2022, Jim Mattson wrote:
>> KVM_GET_SUPPORTED_CPUID should only enumerate features that KVM
>> actually supports. CPUID.80000001:EBX[27:16] are reserved bits and
>> should be masked off.
>>
>> Fixes: 0771671749b5 ("KVM: Enhance guest cpuid management")
>> Signed-off-by: Jim Mattson <jmattson@google.com>
>> ---
> 
> Please provide cover letters for multi-patch series, at the very least it provides
> a convenient location to provide feedback to the series as a whole.
> 
> As for the patches, some nits, but nothing that can't be handled when applying,
> i.e. no need to send v2 at this time.

Indeed - queued all except patch 5, thanks.

Paolo

