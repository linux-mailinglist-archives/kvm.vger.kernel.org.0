Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8324B143B
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 18:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239851AbiBJRae (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 12:30:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238085AbiBJRad (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 12:30:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7B0692611
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 09:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644514232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ipC35w792dvxJk0OyBY7gcESXN0lGemMDfsvs+ruGts=;
        b=PgZS2bo76IOXJ8difk7giJt3uSk9LdmCy/+A1RhRkA0wsWyfdEFOSsQELauOYjNIkLQw21
        0YJSzDEukXbzrNYb08R1z/GVH/lODYZtfyN32ZV5fx6aAAkLOG50rSqQ1+WThqWKJdnJvr
        su56TS3SvDetOAMbKPTCyKbLQU5b8VQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-6NlaV0OiME6iZUrxvyypOw-1; Thu, 10 Feb 2022 12:30:31 -0500
X-MC-Unique: 6NlaV0OiME6iZUrxvyypOw-1
Received: by mail-ed1-f72.google.com with SMTP id dn20-20020a05640222f400b0040f8cdfb542so3736542edb.3
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 09:30:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ipC35w792dvxJk0OyBY7gcESXN0lGemMDfsvs+ruGts=;
        b=DvY5m5mOA52tLmLanSG8tta2sihKV7U4jIkaBtc6+UgIibuconOWILGDepLPoJs8TE
         9e5sThZkSPnJfBgQfPunQwQquWihYD1BcRiOSYFDwcGvDwK8K7jb0LJtu3CproqayP4Z
         ChxwN16QouFHKqUKAI3yzId3T2DwFjFGRRjgOSENAO+bRUUg06RsqJYjz5qzrY/GdIvd
         Cu1TgdTYxZsSxwpWErpqyDfZtYX5W+ZAvu29F3s9LsmfUHWu5Uk82EqBQo3kmuhEa/hL
         AHiYdS/yQwrxn9oiDL1juYY9RqTNbTaO0Kp4iE5b0ZGxoRLbByt8vgXWp/HjbnucJSVC
         7X6A==
X-Gm-Message-State: AOAM533/1cyZZDZPIEDF/8isC8Ji9XSsm9EQ1kL1ya+olpPJMlGqQNWU
        qjpAXm4O0Yt24iW52RPSYirAr1d5eDsom12m/lLz3xUHFil+W87JWBcsibl20qeX+UiAIOvgpaP
        KBT9nPFdjtdp4
X-Received: by 2002:a05:6402:2708:: with SMTP id y8mr9445642edd.409.1644514229895;
        Thu, 10 Feb 2022 09:30:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw+5gAesk8y5CJUhwsjQvRSPjVku04l37Bvzlnqcvt9dX9PJwsr+KeQ7sLPZ30dz1n51krz+w==
X-Received: by 2002:a05:6402:2708:: with SMTP id y8mr9445622edd.409.1644514229627;
        Thu, 10 Feb 2022 09:30:29 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id yz13sm5164078ejb.209.2022.02.10.09.30.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 09:30:28 -0800 (PST)
Message-ID: <344042cf-099e-5e26-026a-c42d0825488e@redhat.com>
Date:   Thu, 10 Feb 2022 18:30:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 00/23] KVM: MMU: MMU role refactoring
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Matlack <dmatlack@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <YgGmgMMR0dBmjW86@google.com> <YgGq31edopd6RMts@google.com>
 <CALzav=d05sMd=ARkV+GMf9SkxKcg9c9n5ttb274M2fZrP27PDA@mail.gmail.com>
 <YgRmXDn7b8GQ+VzX@google.com>
 <40930834-8f54-4701-d3ec-f8287bc1333f@redhat.com>
 <YgVDfG1DvUdXnd2n@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YgVDfG1DvUdXnd2n@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/10/22 17:55, Sean Christopherson wrote:
>> 	union kvm_mmu_page_role root_role;
>> 	union kvm_mmu_paging_mode cpu_mode;
>
> I'd prefer to not use "paging mode", the SDM uses that terminology to refer to
> the four paging modes.  My expectation given the name is that the union would
> track only CR0.PG, EFER.LME, CR4.PAE, and CR4.PSE[*].

Yeah, I had started with kvm_mmu_paging_flags, but cpu_flags was an even 
worse method than kvm_mmu_paging_mode.

Anyway, now that I have done _some_ replacement, it's a matter of sed -i 
on the patch files once you or someone else come up with a good moniker.

I take it that "root_role" passed your filter successfully.

Paolo

> I'm out of ideas at the moment, I'll keep chewing on this while reviewing...
> 
> [*] Someone at Intel rewrote the SDM and eliminated Mode B, a.k.a. PSE 36-bit
> physical paging, it's now just part of "32-bit paging".  But 5-level paging is
> considered it's own paging mode?!?!  Lame.  I guess they really want to have
> exactly four paging modes...

