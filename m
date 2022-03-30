Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8EA84EC403
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 14:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242263AbiC3MUD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 08:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347089AbiC3MS4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 08:18:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 425A865D2C
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 05:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648642143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uweqLFGJbLof9q3XnJpMcN0HzPoip10nBUyG1VZQn3I=;
        b=EVQEiSrZUXS3lZGHN3ffwjgTznZkUs1vD8rKDZxcDxf4DEMuyPZFjK2Mbsd+2fvBcubWWn
        BnsZu8mTMZHNMJgmijL6o65F6koB9rJe1Y4oDrk8XHZzi5KXcFHRtw5AlEZJ21xFaLhvAD
        Pdk7Kqg1gFFsBYpNiVDJTY9ec41ch8I=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-r9dOhPlpP-i5lV_fJswMoA-1; Wed, 30 Mar 2022 08:09:01 -0400
X-MC-Unique: r9dOhPlpP-i5lV_fJswMoA-1
Received: by mail-ed1-f72.google.com with SMTP id j39-20020a05640223a700b0041992453601so10564048eda.1
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 05:09:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uweqLFGJbLof9q3XnJpMcN0HzPoip10nBUyG1VZQn3I=;
        b=HzGzqml/17m3QSOkalQW6+2VOTVc+Kl1uYTmETx9WtZaWlwPYM9hEhecKg/94Eq/0F
         6+aLY5clXwgtBIs8s76hY0WFKCucDIba9pwacuZLdr84Y7Y2oxGE/T4GzOJrwTzew5Ez
         QTVCqBv5D9kG/Nsl+z7bKrbEBOBVDLmAqpvDdH9WPpChB2cOPO++HINe3LG0A0lVfwAf
         wpDo0SuIjhvCvOBdV/rFuRIgQ6Y4gBnCQ63txB7aMMHpUMhhwoMnkVz+3/606g3MJF8P
         1rrgVeVENFubt/8Q3FyAD3dON5E9rzWg83PPzz2DGI0hETJlc86yMhW2F54TCNYV79VK
         kKUg==
X-Gm-Message-State: AOAM531ED3fSJzoTuOslddhFfnfyGLmHC3II9i+SE+1x+1Ko6/kpI9/C
        wFu6D9ILrRBR8NzIWLyKnciIiJ0u5Ab7ncdzHR1etfxfFdgr0O7L+h8r6kgWCL4+FDfINRIh8ar
        FoDGWYVYkJneE
X-Received: by 2002:a17:907:6092:b0:6db:ab31:96a2 with SMTP id ht18-20020a170907609200b006dbab3196a2mr38331792ejc.361.1648642140639;
        Wed, 30 Mar 2022 05:09:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqK0o157pvMUi7ZACRVTs9KL0PWXwSz46MMFdHFHdke+qjmFhJwWcKrvBjDHTt/zB/odl55A==
X-Received: by 2002:a17:907:6092:b0:6db:ab31:96a2 with SMTP id ht18-20020a170907609200b006dbab3196a2mr38331771ejc.361.1648642140392;
        Wed, 30 Mar 2022 05:09:00 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:8ca6:a836:a237:fed1? ([2001:b07:6468:f312:8ca6:a836:a237:fed1])
        by smtp.googlemail.com with ESMTPSA id l12-20020a056402028c00b00418f7fc4bd8sm9747115edv.91.2022.03.30.05.08.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 05:08:59 -0700 (PDT)
Message-ID: <00fbd38e-2a9c-fda2-2565-6a53940b43e6@redhat.com>
Date:   Wed, 30 Mar 2022 14:08:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 8/8] KVM: x86: SVM: remove vgif_enabled()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20220322172449.235575-1-mlevitsk@redhat.com>
 <20220322172449.235575-9-mlevitsk@redhat.com> <YkOiU2TtxE32xhCu@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YkOiU2TtxE32xhCu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/30/22 02:20, Sean Christopherson wrote:
> It'd be helpful to explicitly call out that KVM always takes V_GIF_ENABLE_MASK
> from vmcs01, otherwise this looks like it does unintentend things when KVM is
> runing vmcb02.

I will add a note to the commit message.

More precisely, because KVM does not (as of this patch) support vGIF 
when L1 runs L2, the vmcb02's V_GIF_MASK and V_GIF_ENABLE_MASK also 
control L1's GIF and are the same as vmcs01's.

Paolo

