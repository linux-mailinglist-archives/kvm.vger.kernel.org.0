Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316924F86DC
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 20:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346748AbiDGSFq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 14:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbiDGSFo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 14:05:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 406FC89CDB
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 11:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649354622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qblZlwLVOW0eR3D4SlQZSCRb0yYaR0BlU1bRFwj122U=;
        b=EnAKPQjc1g5Gc5REjLqyXCyhTwzD0oeI45KlJifzVApeivgTROiYxAdrrGLlqKSgFzCe4n
        RW9Zhzw2w4yON5ehUyzkEzmNdrdDyvok/JZFOG2Q4ITVek0pHYggcxHXFEeUd/bl613Oxy
        2QlKVgqzdxpZF8PJlietEivL7TVytd4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-npvbBw6sNuqvRG4ofFhM5Q-1; Thu, 07 Apr 2022 14:03:41 -0400
X-MC-Unique: npvbBw6sNuqvRG4ofFhM5Q-1
Received: by mail-ed1-f71.google.com with SMTP id l2-20020a056402028200b0041cd2975b87so3332230edv.22
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 11:03:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qblZlwLVOW0eR3D4SlQZSCRb0yYaR0BlU1bRFwj122U=;
        b=1v6gQYlzWR8MWANFRyInoUY0WMg36uN+6I32elGS2ISNrLN5kro9JrpCm9RkDaFnjl
         73aJHrhgfVWLdLz0+dDCvihURzYMw75p/dmR3q6cHsTLTMWy36V4OG/6KwyDRLgJNx8W
         IT0i8XZzj8KLQig31TfWFo7U+zUZbyRnpMOADPCMXOVk7ziwByYPAmxvtPEyhqpoYmVK
         XS1pXo5byHw+81r7WXtsDyxCr1/1+8IdmFrujC5CLD17894ownXV+hlWa74QPMN1tyJk
         8tbwwTfTV1ob0POGtlekmROOrKZzdBoEK+v73h1SYzgyk26bkHSmv1E6kMokm5QLkYdh
         b9tA==
X-Gm-Message-State: AOAM531JpkL7BH/We1m0dBD0dE8VKtZnt5bUgSJDolTGZMPBu6Egez1p
        tL4SPiG7FC+9pBh+B9EpOPGGooYi4kuknuChfTL2IlCNjXXGjDeOEARrCDgnmYSlPblmiE9VmEv
        HzES3rnOXaNpK
X-Received: by 2002:a17:906:9b8f:b0:6db:ab62:4713 with SMTP id dd15-20020a1709069b8f00b006dbab624713mr14730996ejc.738.1649354619851;
        Thu, 07 Apr 2022 11:03:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPxFQXOcLc+wg9Chj6cjk13RLg3UF6jdjTnzG19giIe0d5Y51YOzJ8wIhpn6LkthjVJFINQw==
X-Received: by 2002:a17:906:9b8f:b0:6db:ab62:4713 with SMTP id dd15-20020a1709069b8f00b006dbab624713mr14730971ejc.738.1649354619597;
        Thu, 07 Apr 2022 11:03:39 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id f5-20020a17090624c500b006cee6661b6esm7892592ejb.10.2022.04.07.11.03.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 11:03:38 -0700 (PDT)
Message-ID: <6558fe13-6406-7536-7557-e89a8b10d102@redhat.com>
Date:   Thu, 7 Apr 2022 20:03:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 091/104] KVM: TDX: Handle TDX PV CPUID hypercall
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <e3621e9893796d2bd8ea8b1f16c1616ae9df3f37.1646422845.git.isaku.yamahata@intel.com>
 <adea5393-cbe9-3344-0ef5-461a72321f72@redhat.com>
 <Yk75xJjUghPTjTjT@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yk75xJjUghPTjTjT@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/7/22 16:48, Sean Christopherson wrote:
>> Reviewed-by: Paolo Bonzini<pbonzini@redhat.com>
>>
>> but I don't think tdvmcall_*_{read,write} add much.
> They provided a lot more value when the ABI was still in flux, but I still like
> having them.  That said, either the comments about R12..R15 need to go, or the
> wrappers need to go.  Having both is confusing.
> 

Fair enough, let's keep them but rename them a0..a3 for consistency with 
kvm_emulate_hypercall.

Paolo

