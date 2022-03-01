Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0ADE4C916B
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 18:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236282AbiCARYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 12:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbiCARYE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 12:24:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9C659340FF
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 09:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646155402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lFXunAdv5LdjJW8QDwspJT41+DJROvO8Ax1QEx6aw4A=;
        b=XxMTZWC2mYomoRb3SHerSgpEIWiv5HPUNIs7jCCBWr3JzheMbyySTVNZhr2tAbBVz6cTUZ
        yPXpiReIEpyS+AdRaYzNWm5dpKVwuNt2ci8DXptp4UGPcdOyHcKNHz+TBNSfisygK000Jn
        +FFsFc/xlbVvrXwXNK3Xd2/EJmzBrBA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498--V8tbuqTNbOanyJ6rx2bIA-1; Tue, 01 Mar 2022 12:23:21 -0500
X-MC-Unique: -V8tbuqTNbOanyJ6rx2bIA-1
Received: by mail-wr1-f72.google.com with SMTP id p18-20020adfba92000000b001e8f7697cc7so3555630wrg.20
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 09:23:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lFXunAdv5LdjJW8QDwspJT41+DJROvO8Ax1QEx6aw4A=;
        b=v9MWglQOi8BtQAlCiMDpPKQBplnK80XnKX2YgCfkd0LRcdEGfN6oLpNtq3IEua9BK6
         1uIXyYyviVeJMI580I25bIB5TFPcIRgExebltA8Rxgii5n3t0y3d0qtG7kAZja6x/sMB
         o0IrV4tZS/b0mB950D4pIXIFujKLinEIYUp+frUJr0ClXQHszapmjjRA1EBieGoV/sSG
         i+3cKdqm0qCoTU0spGh21iq+uyao6HCQArMmRBguqgXEFVtkKUVVTrO/cgt8FjCuk8/M
         arO11UXbVcCYRCMLq1c8rZWAB1KZKrIMp+Rq5oqsm0me7j0h1ule8wMXk/QKoEMA4Hq8
         1zMA==
X-Gm-Message-State: AOAM531viOgaQ997jzIMWLdo4wlc4QzKwnzqek4x/vnv0fEYG+vJcIeu
        lBtt/E4hMmarYLErKljef8BgBWqz9foLwMJ9Xbh+Px0UMGVf1GM3I6CQ9hciDcPn17I3Asw+W6x
        Ow/QLvX+o6ifa
X-Received: by 2002:a5d:6acb:0:b0:1ef:9e02:5214 with SMTP id u11-20020a5d6acb000000b001ef9e025214mr9605804wrw.151.1646155400159;
        Tue, 01 Mar 2022 09:23:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJybsHzJ1qP7vDADgXM1zyY8BnQaquWD5JrRb/ZZ0oV6+AsFWHNF9iahy81bgXX44HNLnhrUNA==
X-Received: by 2002:a5d:6acb:0:b0:1ef:9e02:5214 with SMTP id u11-20020a5d6acb000000b001ef9e025214mr9605788wrw.151.1646155399905;
        Tue, 01 Mar 2022 09:23:19 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id k25-20020a05600c1c9900b00381481059a3sm3382821wms.2.2022.03.01.09.23.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 09:23:19 -0800 (PST)
Message-ID: <c6f4d7e5-6138-084e-067f-6bb1ecda9e2c@redhat.com>
Date:   Tue, 1 Mar 2022 18:23:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 2/4] KVM: x86: SVM: disable preemption in
 avic_refresh_apicv_exec_ctrl
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org
References: <20220301135526.136554-1-mlevitsk@redhat.com>
 <20220301135526.136554-3-mlevitsk@redhat.com> <Yh5UqJ0De0dk6uxD@google.com>
 <c9e99c37e9d6c666ac790ee2166418eb9e54e3fd.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <c9e99c37e9d6c666ac790ee2166418eb9e54e3fd.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/22 18:20, Maxim Levitsky wrote:
> I don't see that this patch is much different that what I proposed,
> especially since disable of preemption can be nested.

The difference is that it's done in avic_vcpu_{load,put} instead of the 
caller.  I like that your patch is smaller, but I like that Sean's patch 
solves it for good.

I queued his, but maybe I could apply yours to 5.17 and his to 5.18.  I 
might do this if I have to send more stuff to Linus before the release.

Paolo

