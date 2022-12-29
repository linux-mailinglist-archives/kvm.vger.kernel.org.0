Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2B3E6591F1
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 22:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbiL2VEU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 16:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiL2VES (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 16:04:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE1638A2
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 13:03:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672347819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lo9jTUCpeOz7gOnHi1O8cWhVViGe+xtdWqoEDHttnaA=;
        b=jNuQrlDZNOa/QIk4PltL74Kkwp3yD3q6wv5DvZBU9rs931MnIHVuJtTmmvqWZhgdrGVfcQ
        42BsB3wlpDwCPLaPaOCmJ9i+5u2APMffvwgbvA4RxfsFPAYKSYFXW1t2IG6FyX4/X8/vMi
        s2oucEvpC+tuJBUhZSPA4lm78nLdtag=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-121-or4q6OKDPYiyy04c4V_1bA-1; Thu, 29 Dec 2022 16:03:37 -0500
X-MC-Unique: or4q6OKDPYiyy04c4V_1bA-1
Received: by mail-ej1-f69.google.com with SMTP id xh12-20020a170906da8c00b007413144e87fso13060654ejb.14
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 13:03:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lo9jTUCpeOz7gOnHi1O8cWhVViGe+xtdWqoEDHttnaA=;
        b=M4Iy/xusbYOG8wjVL7oFKk2An916nX8QQY+XEM4Z1/YXgGaemC515rRLvHmDP+2kIY
         ETUJMXGxMnhIRFnevyD62x1eE7LkvcbG9WPNpgwo87LPEOThAESSWyVwSLX2G5NVmz4Y
         VgJ8pFIUVUKLQhvWBMWHw7CX7T98moSRLoWBt9s5U1ijLIZLLsmckcGFGfyIvosD4ID/
         5VMqD5GAIH0r3iriq+QBXXMVJE1JjIz5zVOqv5WyFbp0TZg3wWsUottofP/Oae8A4akT
         aBY2ZZOM1/mzhqgwSaVvBwOYiRXRDmrm3LiMkp3MaM5wTilYOzmWRIf8fke2bgzOoujF
         LExw==
X-Gm-Message-State: AFqh2kpzwJxFa/FOQiQPSMpLXE8F+VtZmTLlQPfRhAXna0heCvYmUa5y
        Qa4yvhWqcC0zrlVUMpW4r5BGD+yDozc1zXsZ0O68YJY391fML/Cjl8R3PZnoORb5IZxCZGTYpzT
        IJgnHyGajSaWB
X-Received: by 2002:a17:906:aed6:b0:7af:170f:512 with SMTP id me22-20020a170906aed600b007af170f0512mr25558609ejb.38.1672347816481;
        Thu, 29 Dec 2022 13:03:36 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsSoT6wR4FWMpyJ/uY8ZWT39t7im2HPHYutYgdfKoiG7UkuXRi+X/UjOMzo3+kzPOHwAzSPpA==
X-Received: by 2002:a17:906:aed6:b0:7af:170f:512 with SMTP id me22-20020a170906aed600b007af170f0512mr25558601ejb.38.1672347816291;
        Thu, 29 Dec 2022 13:03:36 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312::529? ([2001:b07:6468:f312::529])
        by smtp.googlemail.com with ESMTPSA id u17-20020a170906409100b00779cde476e4sm8874485ejj.62.2022.12.29.13.03.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Dec 2022 13:03:35 -0800 (PST)
Message-ID: <a03a298d-dfd0-b1ed-2375-311044054f1a@redhat.com>
Date:   Thu, 29 Dec 2022 22:03:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC PATCH 1/2] KVM: x86/xen: Fix use-after-free in
 kvm_xen_eventfd_update()
Content-Language: en-US
To:     Michal Luczaj <mhal@rbox.co>,
        David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     paul@xen.org, seanjc@google.com
References: <20221222203021.1944101-1-mhal@rbox.co>
 <20221222203021.1944101-2-mhal@rbox.co>
 <42483e26-10bd-88d2-308a-3407a0c54d55@redhat.com>
 <ea97ca88-b354-e96b-1a16-0a1be29af50c@rbox.co>
 <af3846d2-19b2-543d-8f5f-d818dbdffc75@redhat.com>
 <532cef98-1f0f-7011-7793-cef5b37397fc@rbox.co>
 <4ed92082-ef81-3126-7f55-b0aae6e4a215@redhat.com>
 <9b09359f88e4da1037139eb30ff4ae404beee866.camel@infradead.org>
 <6d2e2043-dc44-e0c0-b357-c5480d7c4e7c@redhat.com>
 <2ac40491-7efc-64bf-d7b8-b10dc4346094@rbox.co>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <2ac40491-7efc-64bf-d7b8-b10dc4346094@rbox.co>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/29/22 03:12, Michal Luczaj wrote:
> It looks like there are more places with such bad ordering:
> kvm_vm_ioctl_set_msr_filter(), kvm_vm_ioctl_set_pmu_event_filter().

These are easy to fix because the unlock can just be moved before 
synchronize_srcu() or synchronize_srcu_expedited().  Would you like to 
send a patch?

Paolo

