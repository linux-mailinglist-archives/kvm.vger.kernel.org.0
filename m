Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E785D4E2744
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 14:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347768AbiCUNMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 09:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239874AbiCUNMP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 09:12:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 431A32B187
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 06:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647868248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jW9u2SxGZ+/PXhfA4LWitkKJTkrl87CK1XIwrfuHmuI=;
        b=XLeZ7O0fIolXuBgHiXRoEyD8MOJHz5Yw43nIWcEkvCptDXCM4VdFgdwvE/sDE75sn89Frf
        /n5bZ29YD/zXeR4gI8gTxuRZBt1XEtt2U2hB462YKtwtyvUSDt6ac4n5xDWeyG3rOvfOr/
        RwB7ooSkTLHRa33Mf0UW5o1s0i2aFhA=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-98-WKcIopg_Px2RxiET6hlZVw-1; Mon, 21 Mar 2022 09:10:45 -0400
X-MC-Unique: WKcIopg_Px2RxiET6hlZVw-1
Received: by mail-ej1-f69.google.com with SMTP id hz15-20020a1709072cef00b006dfeceff2d1so1715229ejc.17
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 06:10:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jW9u2SxGZ+/PXhfA4LWitkKJTkrl87CK1XIwrfuHmuI=;
        b=QfNi8BJhoJBV5oBgcSzwfkhLS8iU+VhUGNx8WI+NLrdQjoTNMNF9WX2vxfhoBEC3i1
         XuHBmy57aJoST+XwtbkUQ923Bm1om9lPsSaNKAHpbPj+UJjQR0stCyMuBdGDwhlWhIdq
         gYN06bBBaGJ/SfYt3foQjgYHolv/PT3AUFHAEk5Edl7luY4aVxedei3+JszzK3nCJ9En
         z92gVMnZaaY+wOnBBuKK4XlbaWPESc51E6KN6nevAEfPi11vk/VrTg4Hph1GFVek6CKw
         3BOKkWmoqprRpAViNSM1UeL+MkjF/R37T7IZYmoySipqNZfSQaCDjz+3Rf4Sj/1kgnIZ
         yntw==
X-Gm-Message-State: AOAM533PpZcryKI5rO7dXrt/rhrTjL+ppTHBj2ySq4IvflwAJw8syWXS
        R7E5e50gN8VSQ9kJi3VjOzKnWtBWN8Ssphxo/dCnXPh+/UHOLelbAkuSldJh2gHKCgPjhfvGgdc
        MXpKG6FM9lZis
X-Received: by 2002:a17:906:c113:b0:6d7:7b53:9cb with SMTP id do19-20020a170906c11300b006d77b5309cbmr21539132ejc.197.1647868243786;
        Mon, 21 Mar 2022 06:10:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyBnzn2OkMRjoXpoDhzwRdBojajpt+8+9P+Hre6jbdWD80jQVzq7F3NPIks/W1UEiDL2fLCMA==
X-Received: by 2002:a17:906:c113:b0:6d7:7b53:9cb with SMTP id do19-20020a170906c11300b006d77b5309cbmr21539107ejc.197.1647868243502;
        Mon, 21 Mar 2022 06:10:43 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id qb24-20020a1709077e9800b006e029bd4c24sm570007ejc.193.2022.03.21.06.10.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 06:10:42 -0700 (PDT)
Message-ID: <47aee17c-cc65-02f0-4494-472ab6e80fad@redhat.com>
Date:   Mon, 21 Mar 2022 14:10:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] Documentation: KVM: Describe guest TSC scaling in
 migration algorithm
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20220316045308.2313184-1-oupton@google.com>
 <34ccef81-fe54-a3fc-0ba9-06189b2c1d33@redhat.com>
 <YjTRyssYQhbxeNHA@google.com>
 <0bff64ae-0420-2f69-10ba-78b9c5ac7b81@redhat.com>
 <YjWNfQThS4URRMZC@google.com>
 <e48bc11a5c4b0864616686cb1365dfb4c11b5b61.camel@infradead.org>
 <a6011bed-79b4-72ab-843c-315bf3fcf51e@redhat.com>
 <3548e754-28ae-f6c4-5d4c-c316ae6fbbb0@redhat.com>
 <100b54469a8d59976bbd96f50dd4cd33.squirrel@twosheds.infradead.org>
 <9ca10e3a-cd99-714a-76ad-6f1b83bb0abf@redhat.com>
 <YjbrOz+yT4R7FaX1@google.com>
 <9afd33cb-4052-fe15-d3ae-69a14ca252b0@redhat.com>
 <20f53c124a4a592f8dcf1fa6ae1d71fa1e2ec23b.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20f53c124a4a592f8dcf1fa6ae1d71fa1e2ec23b.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/21/22 13:16, David Woodhouse wrote:
> Hm, I still don't really understand why it's a 5-tuple and why we care
> about the *host* TSC at all.
> 
> Fundamentally, guest state is *guest* state. There is a 3-tuple of
>   { NTP-synchronized time of day, Guest KVM clock, Guest TSC value }
> 
> (plus a TSC offset from vCPU0, for each other vCPU perhaps.)
> 
> All else is redundant, and including host values is just wrong. [...]
> I don't understand why the actual *value* of the host TSC is something
> that userspace needs to see.

Ok, I understand now.

You're right, you don't need the value of the host TSC; you only need a 
{hostTOD, guestNS, guestTSC} tuple for every vCPU recorded on the source.

If all the frequencies are the same, that can be "packed" as {hostTOD, 
guestNS, anyTSC} plus N offsets.  The N offsets in turn can be 
KVM_VCPU_TSC_OFFSET if you use the hostTSC, or the offsets between vCPU0 
and the others if you use the vCPU0 guestTSC.

I think reasoning in terms of the host TSC is nicer in general, because 
it doesn't make vCPU0 special.  But apart from the aesthetics of having 
a "special" vCPU, making vCPU0 special is actually harder, because the 
TSC frequencies need not be the same for all vCPUs.  I think that is a 
mistake in the KVM API, but it was done long before I was involved (and 
long before I actually understood this stuff).

Paolo

