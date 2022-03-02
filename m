Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96B24CAC6E
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 18:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244245AbiCBRtU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 12:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbiCBRtR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 12:49:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E3938237E7
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 09:48:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646243313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ish057kHJjR2Es3o2X8vkZcDc0WMwyYLfwxQbeB+OyA=;
        b=AkWQ+rhN8SVDcMReGqGggeXXOS3Ze2cQTcrX4qGoYZfK4z94y8wWSdavSa1UbcbTKYM4H+
        sisUmQGV32Fj/wg6vLrjuslqo+L+r7ACGap2w8LSyP4N53t9W5jbMqDNlUemUzE0M12OgL
        UVsqE6H8BT8Yd1fiCdwCN8XYdJlHASg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-HBYSd7LiMhWktnlcSnUafw-1; Wed, 02 Mar 2022 12:48:31 -0500
X-MC-Unique: HBYSd7LiMhWktnlcSnUafw-1
Received: by mail-wm1-f72.google.com with SMTP id 7-20020a1c1907000000b003471d9bbe8dso1098392wmz.0
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 09:48:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ish057kHJjR2Es3o2X8vkZcDc0WMwyYLfwxQbeB+OyA=;
        b=na2X2L0pvce3a+MMAedidD+euGWP9yBvp/xB30apwArIwclu3FH1FecOYwB9B4si+C
         lPh8JSTtPuPW9eLNDBIAp52qgfV1QTalOos08LYgqwjNQ8TKIW0iP8p2szwc7Jx0xv1O
         4Xu7BM/0LoA7kAl4fX4OS9Ka1Lc8ouySJNLCaRkh0V8FxMsIwxIdvWup3zkKEIskhU6g
         irIhhSrtnRJk9PRpMYLVZHf/c1u9i6PsxPT26ELjvU0wmuSQ3UARkL0qqe11POhcR9qz
         iJHODUuqqjqO+UPAaQCfkJElLR3lappHb5A96jnyc4sAswkY//j7Z9FnaFMYPpCz+wEZ
         eZHw==
X-Gm-Message-State: AOAM5322ZdeztslcRkSVmqi6Q7FuUBCl4lwzdwUteO5doUQZAlno9+J7
        M89hDkdjK+RkhoZoosJ+YeA8dzERryta+CrPlX1SW2k2G2+9mFmkUXiZAiiYSwdg5k1w/VAEs33
        1S6hMeLXPnwm6
X-Received: by 2002:a5d:4a8f:0:b0:1f0:4af2:4e29 with SMTP id o15-20020a5d4a8f000000b001f04af24e29mr292228wrq.519.1646243310195;
        Wed, 02 Mar 2022 09:48:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJykaH1cjF8Bel4wvi23J3mDvwOhoDqUEVzkDqVEnsn90rg5c2+5PKw3CzHay2FDBT8xLhmG5g==
X-Received: by 2002:a5d:4a8f:0:b0:1f0:4af2:4e29 with SMTP id o15-20020a5d4a8f000000b001f04af24e29mr292213wrq.519.1646243309890;
        Wed, 02 Mar 2022 09:48:29 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id r20-20020adfa154000000b001f0326a23e1sm2583118wrr.88.2022.03.02.09.48.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 09:48:29 -0800 (PST)
Message-ID: <a0eee64e-763a-0db3-29d1-e19ee80ba1ee@redhat.com>
Date:   Wed, 2 Mar 2022 18:48:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] KVM: allow struct kvm to outlive the file descriptors
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
References: <20220302174321.326189-1-pbonzini@redhat.com>
 <Yh+trXegvWs+e5l3@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yh+trXegvWs+e5l3@google.com>
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

On 3/2/22 18:47, Sean Christopherson wrote:
>> +	/* This is safe, since we have a reference from open(). */
>> +	__module_get(THIS_MODULE);
> This isn't sufficient.  For x86, it only grabs a reference to kvm.ko, not the
> vendor module.  Instead, we can do:
> 
> 	if (!try_module_get(kvm_chardev_ops.owner))
> 		return ERR_PTR(-EINVAL);
> 
> And then on top, revert commit revert ("KVM: set owner of cpu and vm file operations").
> vCPUs file descriptors hold reference to the VM, which means they indirectly hold a
> reference to the module. So once the "real" bug of struct kvm not holding a reference
> to the module is fixed, grabbing a reference when a VM/vCPU inode is opened becomes
> unnecessary.
> 

Got it, I'll wait for David to post the right thing. :)

Paolo

