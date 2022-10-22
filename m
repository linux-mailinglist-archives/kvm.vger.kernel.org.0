Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5217608B9D
	for <lists+kvm@lfdr.de>; Sat, 22 Oct 2022 12:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiJVK1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Oct 2022 06:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbiJVK11 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Oct 2022 06:27:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EF6DDA15
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 02:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666431720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5mn5pq8Up0gygiPBh9fjfcwf0+pjffwonXvxd2n++Pw=;
        b=YSyWRAjJVfc090A7SWEa54T0jSWtt5/+LaAXt8npYIJBs0do1lAZsqrih4Z/tS5zFn4b2H
        7jCwD2p8rEzQWHrtq7vcL2pE96ZJ8B6PCTupKTy2AYT6mwVjpLyvTHz2hUtRmwaEMWnQR5
        4cW99MrDzbvgtbXmFot1vfK7Gp48S3g=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-168-0iVFUAO9MWGxSn5ZYHnZQw-1; Sat, 22 Oct 2022 04:26:46 -0400
X-MC-Unique: 0iVFUAO9MWGxSn5ZYHnZQw-1
Received: by mail-ed1-f71.google.com with SMTP id dz9-20020a0564021d4900b0045d9a3aded4so4893712edb.22
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 01:26:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5mn5pq8Up0gygiPBh9fjfcwf0+pjffwonXvxd2n++Pw=;
        b=PxpuXTD2pS3SHgbgSPPNYAzCcIafRpB4AThoRhVlRrGgBL3IzZKpI5DMwQ90HLputm
         Db4WczDDPyFlUAjwcPpQaX4Fb7tPVxhLYi76TtFz2s8xPkBCatsZgYYxhFK9686D/hZf
         qcA3Ao2dDpzYVZqlFa7is2n0ULdTXXLMjczc3UW1Bhjud2E3mOnVeO4S33+UzoH112Fp
         zD8JFziAePL15AmRR6h3qQ6U2uFxCeMErkcrHH0y6xQh58Sq5v60QKF1Paa1FpY2gfWp
         EEV2nAcapP8Rs30LL/Dqw8Fuu/FVFlCs8s9sSekHn8gmMtjr9vFWjtERlUQ04FtP73aG
         2PXA==
X-Gm-Message-State: ACrzQf08Its7BkLd18PBmX6zvNqeTEbauCmiLsJ7V6+iIwg0TFxKcTrA
        UltXYuqfN8tM6mykglpPmyUl7OmIGNRwbXrWSAdW8YqBgH6kVA5OSn5BjGsfDXZE4Keq/Km5vA/
        qq43z5hGfHBvd
X-Received: by 2002:a17:907:2cd9:b0:78d:9e76:be26 with SMTP id hg25-20020a1709072cd900b0078d9e76be26mr18717800ejc.315.1666427205292;
        Sat, 22 Oct 2022 01:26:45 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4AQduEAQCM/lUm3wNoFrfF41UXN6ebs9jSdqSTmCWzJ9+GX+YEguC054Oyeg4d9bDhBCxqbw==
X-Received: by 2002:a17:907:2cd9:b0:78d:9e76:be26 with SMTP id hg25-20020a1709072cd900b0078d9e76be26mr18717791ejc.315.1666427205092;
        Sat, 22 Oct 2022 01:26:45 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:2f4b:62da:3159:e077? ([2001:b07:6468:f312:2f4b:62da:3159:e077])
        by smtp.googlemail.com with ESMTPSA id ky23-20020a170907779700b0078a86e013c4sm12720514ejc.61.2022.10.22.01.26.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Oct 2022 01:26:44 -0700 (PDT)
Message-ID: <64a940a7-cbc8-774d-9565-1f9c1bacbaa4@redhat.com>
Date:   Sat, 22 Oct 2022 10:26:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 5/6] KVM: x86: Mask off reserved bits in CPUID.8000001EH
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org
References: <20220929225203.2234702-1-jmattson@google.com>
 <20220929225203.2234702-5-jmattson@google.com> <Y1B/7r4rBd0xHCvu@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y1B/7r4rBd0xHCvu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/20/22 00:53, Sean Christopherson wrote:
> On Thu, Sep 29, 2022, Jim Mattson wrote:
>> KVM_GET_SUPPORTED_CPUID should only enumerate features that KVM
>> actually supports. The following ranges of CPUID.8000001EH are reserved
>> and should be masked off:
>>      EBX[31:16]
>>      ECX[31:11]
> LOL, APM is buggy, it says all bits in ECX are reserved.
> 
>    31:0  -                Reserved.
>    10:8 NodesPerProcessor
>    7:0  NodeId
> 
> Advertising NodeId seems all kinds of wrong 🙁

Yeah I don't think there is any sensible way to pass this down via 
KVM_GET_SUPPORTED_CPUID.  Making it all zeros is the only way, userspace 
can always compute it on its own based on the topology that it wants the 
guest to see.  I'll send a separate patch.

Paolo

