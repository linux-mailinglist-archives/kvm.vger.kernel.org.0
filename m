Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2B3608B85
	for <lists+kvm@lfdr.de>; Sat, 22 Oct 2022 12:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbiJVKXb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Oct 2022 06:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiJVKXA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Oct 2022 06:23:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D692BB36
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 02:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666431495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=898hlQcdo2bCygpu9c6/dwSi1/CzDsQfOH2C2fIFX+M=;
        b=gQJ2Jx1mK7RKlw7dw2p5PXQoAVsXML0UPIHyWXCSY/Qtc+X1ZtKiNvweVXjSffqDCVRbsk
        X0dabRgJGpalC58pMrvme+KEAZu1HcqW40glsxFkpLNEcVHsVACJJeo9iAJXxlDHtoMkUt
        SaNyV3x3umVg26mCSy2+jej78SlBHxw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-441-2y0H9BySN9S-Nz1SF5z4lg-1; Sat, 22 Oct 2022 05:12:44 -0400
X-MC-Unique: 2y0H9BySN9S-Nz1SF5z4lg-1
Received: by mail-ed1-f71.google.com with SMTP id y10-20020a056402358a00b0045d5cf18d4cso4942867edc.17
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 02:12:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=898hlQcdo2bCygpu9c6/dwSi1/CzDsQfOH2C2fIFX+M=;
        b=OLXNPYeoPG6SKDiY63q/FULrD4vkw1+0Pq0zR6jm2Zy0Lb3H7yQ7EC86l5RmBh4BCP
         aItI5BUccxBm7/tX8UoA8PWpZ3//RBLW72sCQ1QqVPf5HzfIhYkwHZDHUISuoryw4DyU
         bIT7H1JBLdvU7PeV+JJXE+/3nBFDF7dA4nNgmlktSzZ9GH1iDHF9DJo8YtSqumyyjv6F
         9quV/Iow09Kr8v7UCEuVCkalDfJRG6VCxVFgHh52k0K4HI4PgrRR8qmvywGcnhNt0kq3
         nAUG6Pt6Xfz2AquijdLPe2gIXaTvFKpincixuLUVQIXNEIHGIcBQ/yOuP/jqdB7bvpEz
         7hhQ==
X-Gm-Message-State: ACrzQf2pPzX+v9jRsFa8hJO5LTmgKnQuFUbcMewXtPIT0gW06XXNqays
        +4DSnflzFJ30Z5cEtkjjno/oIhSQ1gBk8hnCGw6FBALmySwGfmHDzJSHAMMV1KGw9bl5LgJCPTh
        Y3jcNmCubZhqO
X-Received: by 2002:a17:906:c152:b0:78d:9dbb:150b with SMTP id dp18-20020a170906c15200b0078d9dbb150bmr18397342ejc.542.1666429962997;
        Sat, 22 Oct 2022 02:12:42 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4FD0SisvQtCxqZgIl2JdfF1BAFwR+/pQ/hCzUOkZl1Fjt1w84ckWZRx/6qCKU/m7aCE+Rp0Q==
X-Received: by 2002:a17:906:c152:b0:78d:9dbb:150b with SMTP id dp18-20020a170906c15200b0078d9dbb150bmr18397334ejc.542.1666429962815;
        Sat, 22 Oct 2022 02:12:42 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:2f4b:62da:3159:e077? ([2001:b07:6468:f312:2f4b:62da:3159:e077])
        by smtp.googlemail.com with ESMTPSA id 9-20020a170906308900b0073c8d4c9f38sm12905127ejv.177.2022.10.22.02.12.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Oct 2022 02:12:42 -0700 (PDT)
Message-ID: <11d4bc25-3128-d50c-a8b4-736504ec70eb@redhat.com>
Date:   Sat, 22 Oct 2022 11:12:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2 1/2] KVM: x86: Insert "AMD" in KVM_X86_FEATURE_PSFD
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Babu Moger <Babu.Moger@amd.com>
References: <20220830225210.2381310-1-jmattson@google.com>
 <Yw6c7X1ymnrAEIVu@google.com>
 <CALMp9eQA-D+=1Os=WaHh29_z=kz8_7uuR+D584_Mc1OS9fN4gw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALMp9eQA-D+=1Os=WaHh29_z=kz8_7uuR+D584_Mc1OS9fN4gw@mail.gmail.com>
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

On 8/31/22 01:32, Jim Mattson wrote:
>> This is asinine.  If KVM is forced to carry the feature bit then IMO we have every
>> right to the "real" name.  If we can't convince others that this belongs in
>> cpufeatures.h, then I vote to rename this to X86_FEATURE_AMD_PSFD so that we don't
>> have to special case this thing.
> You won't get any argument from me!
> 
> If Borislav objects to seeing the feature in /proc/cpuinfo, can't we
> just begin the cpufeatures.h descriptive comment with ""?

Yes, since this is just part of word 13 it should just use "".

It won't help for the Intel one which uses CPUID[EAX=7,ECX=2] though.

Paolo

