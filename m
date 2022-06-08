Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616DD54313A
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 15:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240040AbiFHNVx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 09:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239983AbiFHNVw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 09:21:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 46DEE44761
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 06:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654694509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SkCtRFwTpix6cqqR0vaJf3gcR2UPvZl1kedDkrrQHQk=;
        b=OgtL/Ljqiolk0q8qO208H90TlbLU29C79a/uFYjFgXXJ853Pa2xq77M96L1gVpvUZ07ne7
        s1kj6bbrCAYLHTpai88euN6nf2WyLfzmWyTsZqEFYmH/SD++MwX7o9kjht/pb9yzyTvJnK
        Zj9X8sb/wCp6cjOnZsTa5nVs/B7topE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-mjis4WYhOUi6_N9GaO6CjQ-1; Wed, 08 Jun 2022 09:21:47 -0400
X-MC-Unique: mjis4WYhOUi6_N9GaO6CjQ-1
Received: by mail-wm1-f71.google.com with SMTP id ay28-20020a05600c1e1c00b0039c5cbe76c1so2007639wmb.1
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 06:21:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SkCtRFwTpix6cqqR0vaJf3gcR2UPvZl1kedDkrrQHQk=;
        b=xOMzzB5NigJXeMlu0lcnguNm4N2nvHIWSsySQR4cg5ritfjtg92R8whAOmO8siU2dv
         ghrihAiyBkxt5HEVXPyKrFqPhZ6ACqndXs5VM5vhNNtwO89JtdwzDLquL8IJn1xdvJ/O
         ESgSSANfC/7W80ta4R5rhEBZ0GZ9n7oPLomQ4petTG3MFu6jjOM4/GpIZpyHUHiKT41S
         EYnY+7cO80aQ2o8PK/8FamLl80CDfWnxSeMpPs0oeh8CvkeYnqYQJlBVVF/TSpwWzAuK
         6fM/pXy/7KDTsogRo53izbWUNxtTikSVbkBiXOChpi5Aytk38ONHG1D7vJz7z69VkqRt
         6eBQ==
X-Gm-Message-State: AOAM533MAaHsI9yjcOA3pQoB4n9+kowDfKiUoK+ZrcQOmqgTuHqu+Q6R
        aVwIoblrXxpdbIGf8H3FdFxhzgDG9vfSXOMjWDNC31xMTQJ5WLYAs3kRJ1p55Xttvntd3VdVlMO
        7Ve/gXl9bbBs5
X-Received: by 2002:adf:f20d:0:b0:214:c726:ce76 with SMTP id p13-20020adff20d000000b00214c726ce76mr26699127wro.649.1654694506287;
        Wed, 08 Jun 2022 06:21:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyaA7jNNnJGWGxSZi3mS5Ma8c5boc4zfZ2u1LoRf9h9fTXyTDTHq18tyu2dPMjTs6YP00xiHA==
X-Received: by 2002:adf:f20d:0:b0:214:c726:ce76 with SMTP id p13-20020adff20d000000b00214c726ce76mr26699096wro.649.1654694506013;
        Wed, 08 Jun 2022 06:21:46 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id c14-20020adffb0e000000b00213465d202esm18742388wrr.46.2022.06.08.06.21.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jun 2022 06:21:45 -0700 (PDT)
Message-ID: <c7fb78e2-2650-f9a2-3062-5d5ecc34332b@redhat.com>
Date:   Wed, 8 Jun 2022 15:21:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 4/7] KVM: x86: SVM: fix avic_kick_target_vcpus_fast
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        stable@vger.kernel.org
References: <20220606180829.102503-1-mlevitsk@redhat.com>
 <20220606180829.102503-5-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220606180829.102503-5-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/6/22 20:08, Maxim Levitsky wrote:
> There are two issues in avic_kick_target_vcpus_fast
> 
> 1. It is legal to issue an IPI request with APIC_DEST_NOSHORT
>     and a physical destination of 0xFF (or 0xFFFFFFFF in case of x2apic),
>     which must be treated as a broadcast destination.
> 
>     Fix this by explicitly checking for it.
>     Also don’t use ‘index’ in this case as it gives no new information.
> 
> 2. It is legal to issue a logical IPI request to more than one target.
>     Index field only provides index in physical id table of first
>     such target and therefore can't be used before we are sure
>     that only a single target was addressed.
> 
>     Instead, parse the ICRL/ICRH, double check that a unicast interrupt
>     was requested, and use that info to figure out the physical id
>     of the target vCPU.
>     At that point there is no need to use the index field as well.
> 
> 
> In addition to fixing the above	issues,	also skip the call to
> kvm_apic_match_dest.
> 
> It is possible to do this now, because now as long as AVIC is not
> inhibited, it is guaranteed that none of the vCPUs changed their
> apic id from its default value.
> 
> 
> This fixes boot of windows guest with AVIC enabled because it uses
> IPI with 0xFF destination and no destination shorthand.
> 
> Fixes: 7223fd2d5338 ("KVM: SVM: Use target APIC ID to complete AVIC IRQs when possible")
> Cc: stable@vger.kernel.org
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

Is it possible to use kvm_intr_is_single_vcpu_fast, or am I missing 
something?

Series queued, thanks.

Paolo

