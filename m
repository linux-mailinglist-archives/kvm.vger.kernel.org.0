Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16926676BD2
	for <lists+kvm@lfdr.de>; Sun, 22 Jan 2023 10:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjAVJQP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Jan 2023 04:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjAVJQO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Jan 2023 04:16:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124F21F4A7
        for <kvm@vger.kernel.org>; Sun, 22 Jan 2023 01:15:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674378927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I15dmARdRmpeQGi3/82UdAPUya8gTAjhHxikBkjzHaA=;
        b=PpuUZxt31BirbDq/smCYRFmgQX/qIS+UEG4cQ2oRt0EJ/eY7iEQ5TZKPquQn6ziXOMQAk6
        DHsLgWXaPkU08JfuEgxeM/RWKqt8ku8O2hM2fJxd+Zdp5e1gE0aZ/8L870cWH/zbP1wKI4
        m9GxFJbOjDCss7y7AwUfGEiGWzsngFs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-15-pdJyDowIP4KRfceJ_Im2xQ-1; Sun, 22 Jan 2023 04:15:23 -0500
X-MC-Unique: pdJyDowIP4KRfceJ_Im2xQ-1
Received: by mail-ed1-f71.google.com with SMTP id c12-20020a05640227cc00b0049e2c079aabso6488052ede.1
        for <kvm@vger.kernel.org>; Sun, 22 Jan 2023 01:15:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I15dmARdRmpeQGi3/82UdAPUya8gTAjhHxikBkjzHaA=;
        b=uwk6br618s88toZ0egvcx/5A+piLUWkbExUKNzLIjm3XX3jELoQd7FK11IQ1nT0yjs
         JVEx1VStulyABvlv27ZWOsRskYjqq/TPvGimHrJWbFkye5m89qbmjXDv0kOitMkXBm2w
         LNEcqwr5O8yDSNisRCCH7D+jaMz0/GJ08EHVFyAyUlMaF9mKF77KGTT2CHwdyNKWOHkt
         YRjo5eyc15jSO0nZC/8fbw/I2BEdg0icld7BLdD9gE34jXUMKqbweo4xN1klLzA2tWpb
         YHRNx4csfH0QGh7Aoq2rRUzULEYkMp/WGfQT919Jz519C6WC2pVuAMSyJ/af+MRJhaB8
         cMwA==
X-Gm-Message-State: AFqh2kpWMSK62Frv0XRDRLExsZhDm7GZ8q/DzU9WL/qzhTDi6iMkyJzU
        aQiq96G6zOfaL0EDIEiZfD/QDoW/Ni/D3j8OGuk+8C7TSgwAz06lLKTpWZhi+1bsBGNzkxRh1wf
        1q7Iuy8/7rOIS
X-Received: by 2002:a05:6402:5407:b0:483:21d8:87af with SMTP id ev7-20020a056402540700b0048321d887afmr23356966edb.24.1674378922042;
        Sun, 22 Jan 2023 01:15:22 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsnTrZ/FwrZ+t+XlqY1mrT1w5+N7DwUwhFEyg/7GOjoqz26wIe/86Sk1t8o3XODScxJZjc9qg==
X-Received: by 2002:a05:6402:5407:b0:483:21d8:87af with SMTP id ev7-20020a056402540700b0048321d887afmr23356950edb.24.1674378921792;
        Sun, 22 Jan 2023 01:15:21 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id p3-20020a056402500300b00488abbbadb3sm19885047eda.63.2023.01.22.01.15.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Jan 2023 01:15:20 -0800 (PST)
Message-ID: <9235d535-aea3-841f-72f0-477db606c09d@redhat.com>
Date:   Sun, 22 Jan 2023 10:15:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] KVM: x86/vmx: Do not skip segment attributes if unusable
 bit is set
Content-Language: en-US
To:     Hendrik Borghorst <hborghor@amazon.de>
Cc:     graf@amazon.de, Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221114164823.69555-1-hborghor@amazon.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221114164823.69555-1-hborghor@amazon.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/14/22 17:48, Hendrik Borghorst wrote:
> When serializing and deserializing kvm_sregs, attributes of the segment
> descriptors are stored by user space. For unusable segments,
> vmx_segment_access_rights skips all attributes and sets them to 0.
> 
> This means we zero out the DPL (Descriptor Privilege Level) for unusable
> entries.
> 
> Unusable segments are - contrary to their name - usable in 64bit mode and
> are used by guests to for example create a linear map through the
> NULL selector.
> 
> VMENTER checks if SS.DPL is correct depending on the CS segment type.
> For types 9 (Execute Only) and 11 (Execute Read), CS.DPL must be equal to
> SS.DPL [1].
> 
> We have seen real world guests setting CS to a usable segment with DPL=3
> and SS to an unusable segment with DPL=3. Once we go through an sregs
> get/set cycle, SS.DPL turns to 0. This causes the virtual machine to crash
> reproducibly.
> 
> This commit changes the attribute logic to always preserve attributes for
> unusable segments. According to [2] SS.DPL is always saved on VM exits,
> regardless of the unusable bit so user space applications should have saved
> the information on serialization correctly.
> 
> [3] specifies that besides SS.DPL the rest of the attributes of the
> descriptors are undefined after VM entry if unusable bit is set. So, there
> should be no harm in setting them all to the previous state.
> 
> [1] Intel SDM Vol 3C 26.3.1.2 Checks on Guest Segment Registers
> [2] Intel SDM Vol 3C 27.3.2 Saving Segment Registers and Descriptor-Table
> Registers
> [3] Intel SDM Vol 3C 26.3.2.2 Loading Guest Segment Registers and
> Descriptor-Table Registers
> 
> Cc: Alexander Graf <graf@amazon.de>
> Signed-off-by: Hendrik Borghorst <hborghor@amazon.de>
> ---
>   arch/x86/kvm/vmx/vmx.c | 21 +++++++++------------
>   1 file changed, 9 insertions(+), 12 deletions(-)

Hi Hendrik,

thanks for the patch!  I have queued it now for 6.2-rc6, and added Cc: 
stable.

Would you mind providing a test in the form of a patch for 
tools/testing/selftests/kvm?  I think a kvm-unit-tests testcase would be 
harder to do because there's no easy way to force 
KVM_GET_SREGS/KVM_SET_SREGS.

Thanks,

Paolo

