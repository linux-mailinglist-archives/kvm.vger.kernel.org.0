Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C959697D26
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 14:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234171AbjBONZp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 08:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234195AbjBONZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 08:25:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF79C55B9
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 05:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676467471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MFN0moGTp+tt6wcptvdN7tt2OUfIY3OXjIMRvK/wyF8=;
        b=M57le8IWBp/B0z8fC6bz0CVm/OfI3cu8I7/np1DVzeIh5VR7w5KXP+pZciI2zvKYmraYwf
        KglOYmd4uM9WR6cuYdTeTFaQsbmuqVEClTH4OimlMkDTqzeeDNawrG88uNBU+x05sWL1rE
        o5kCxSvcJu5g/yEORApPidI8a1AkoF4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-26--oHjfvRDMjOJ4TiiBV3vag-1; Wed, 15 Feb 2023 08:24:30 -0500
X-MC-Unique: -oHjfvRDMjOJ4TiiBV3vag-1
Received: by mail-ej1-f71.google.com with SMTP id gb21-20020a170907961500b008b107fa657cso6753399ejc.23
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 05:24:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MFN0moGTp+tt6wcptvdN7tt2OUfIY3OXjIMRvK/wyF8=;
        b=pU6YtMoNhArHtvKbQtzAvJRUO+sLJi28D32KD+19wxXxFppVzjmmfTv05uT3rW74/E
         J9vF/i4AmOMGCw4Y6QaBz0UIfSgZfenFHwJH18vXBm4xhcsDP/unWIChHISW/y92qxSB
         F6ZAvA03kihvfCs0bYZ1V3UYXvNjVCMsXJnTfUJnKEKZzVRunAJEtfqytITrDyGCCAEy
         tNj7i6vaF8hsQ+3QP+yO6NX8a3nvi/DfbS9vKQYrVtAq7Aqd95gww4L1wnUJ4ipd8rup
         7eiVSU5fkSjosXvu8+mZdwk25RB+ZiOzDDzTZykCXcAV7VbGpUfXlXwHS5+oNN1lJm30
         CDng==
X-Gm-Message-State: AO0yUKWvsnZbXoLuMnu73J+5DpWNDDhURQKIXfhXMQoA+iNuTKS7RLdl
        b2NnFaHDncc87iu+4cnNMtE1Rft/GGmL6a+I6tZgIwtZBvwP1t4RE0ULuijlVbkCweu47deMiwW
        Rq/LGLFwg0ziY
X-Received: by 2002:a17:906:c2d3:b0:8b1:3d83:6497 with SMTP id ch19-20020a170906c2d300b008b13d836497mr2374124ejb.36.1676467468663;
        Wed, 15 Feb 2023 05:24:28 -0800 (PST)
X-Google-Smtp-Source: AK7set+Yt5FA2AG8INjswbnJpknoPsDnyh0LdLacB7borWcASEi9cZjB5n1DVTV1FJi2hIj477VZWQ==
X-Received: by 2002:a17:906:c2d3:b0:8b1:3d83:6497 with SMTP id ch19-20020a170906c2d300b008b13d836497mr2374109ejb.36.1676467468383;
        Wed, 15 Feb 2023 05:24:28 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id b12-20020a170906150c00b00888d593ce76sm9603684ejd.72.2023.02.15.05.24.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 05:24:27 -0800 (PST)
Message-ID: <e37b595d-6a8a-ca9f-3a1a-f1205587918a@redhat.com>
Date:   Wed, 15 Feb 2023 14:24:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [GIT PULL] KVM: x86: PMU changes for 6.3
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <20230215010718.415413-1-seanjc@google.com>
 <20230215010718.415413-5-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230215010718.415413-5-seanjc@google.com>
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

On 2/15/23 02:07, Sean Christopherson wrote:
> KVM x86/pmu changes for 6.3.  The most noteworthy patches are two fixes that
> _aren't_  in this pull request.  The arch LBRs fix came late in the cycle and
> doesn't seem super urgent, not sure if it needs to go into 6.3.  Disabling vPMU
> support on hybrid CPUs is much more urgent, but I want your input before
> proceeding.
> 
>    https://lore.kernel.org/all/20230128001427.2548858-1-seanjc@google.com
>    https://lore.kernel.org/all/20230208204230.1360502-1-seanjc@google.com

I agree, I will pick this one for 6.2 as well.

Paolo

