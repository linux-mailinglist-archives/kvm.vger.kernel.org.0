Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9C138E8D9
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 16:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbhEXOjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 10:39:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26042 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233009AbhEXOjg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 10:39:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621867088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MwTVkYpE+xLZ+L9XkvcMXjd+Zl3U7ycgPiVSmNWbDF4=;
        b=hSoedQmacms0F6toOrtj5/gaKjnLu/ZbCVOlkkcSjGlGf/LiQuumiS/HDaeKADJ98Kn65P
        CrMJmS0BeXeg1Fc/EJgf+DdOdKvSmObPTXSZJq6Y6wzxxFQebzf4UBc1SvB+lH6z7Kwrbg
        cIzVepfWhdt41D4cdERvykV0TvH/pRg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-aZqL7ITKOdyu1BFjd2suBw-1; Mon, 24 May 2021 10:38:02 -0400
X-MC-Unique: aZqL7ITKOdyu1BFjd2suBw-1
Received: by mail-wr1-f71.google.com with SMTP id 7-20020adf95070000b02901104ad3ef04so13198878wrs.16
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 07:38:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=MwTVkYpE+xLZ+L9XkvcMXjd+Zl3U7ycgPiVSmNWbDF4=;
        b=tgAzsgrwY0yTCKOjPFOdMuByq/hLE7eP6KUVwy3iZsxWNloqx1i4SuHMb8cK5Tpy2S
         99Ft6iHgiejZA31eWZJg9qr1m8GZr+gpYgTuNyKZE0YnVG87zYPErLTsTzhkg0pA04vk
         1hCa/LSiplNvLvBZ8egzmxi+dLzmoTcirL3xOXeIvILbJ6k76LxaKD8L0PBMUcmiMNLB
         rCt+i882kbYsaQt+bG5vmfVXx1vgr5vukz1Nz1qjNsyZoh0yNt1FOiPzZPsQcluD3tyA
         tHauY7vVdzJZpPAMxu2/QHePYByRf227EgAx64FFQWYqZlcoRctTmq03+dqmUxapke5N
         RhgQ==
X-Gm-Message-State: AOAM530kTRzc2oj4HlMeWEt1iK26suiX0FrSyVC73DCxuG0Kb0rBMpZ8
        nAzBXt7ZIbseMpiB5yozPFsgtlDJqW6VMPKrj6hjXTQ5CsnaUAxGenc4dj65Slz7i+5IxKElU9c
        /KDDm196f64YU
X-Received: by 2002:adf:f54b:: with SMTP id j11mr21122605wrp.376.1621867081143;
        Mon, 24 May 2021 07:38:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzbJEoi9TrHxGwxpZRByUMSDNTVDSgWJX9G30qYssPN8Bc323jcyH+1k1mhtks4tAA7Fm1b9A==
X-Received: by 2002:adf:f54b:: with SMTP id j11mr21122594wrp.376.1621867080971;
        Mon, 24 May 2021 07:38:00 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id y137sm8143918wmc.11.2021.05.24.07.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 07:38:00 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/7] KVM: nVMX: Introduce nested_evmcs_is_used()
In-Reply-To: <37a6d13d-58ae-65e1-75f9-681a40d819a1@redhat.com>
References: <20210517135054.1914802-1-vkuznets@redhat.com>
 <20210517135054.1914802-2-vkuznets@redhat.com>
 <115fcae7-0c88-4865-6494-bdf6fb672382@redhat.com>
 <87r1hw8br1.fsf@vitty.brq.redhat.com>
 <37a6d13d-58ae-65e1-75f9-681a40d819a1@redhat.com>
Date:   Mon, 24 May 2021 16:37:59 +0200
Message-ID: <87lf848aew.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 24/05/21 16:09, Vitaly Kuznetsov wrote:
>> You mean we'll be using:
>> 
>> "hv_evmcs_ptr == 0" meaning "no evmcs" (like now)
>> "hv_evmcs_ptr == -1" meaing "evmcs not yet mapped" (and
>> nested_evmcs_is_used() will check for both '0' and '-1')
>> "hv_evmcs_ptr == anything else" - eVMCS mapped.
>
> I was thinking of:
>
> hv_evmcs_ptr == -1 meaning no evmcs
>
> hv_evmcs == NULL meaning "evmcs not yet mapped" (I think)
>
> hv_evmcs != NULL meaning "evmcs mapped".
>
> As usual with my suggestions, I'm not sure if this makes sense :) but if 
> it does, the code should be nicer.

Ok, let me try this!

-- 
Vitaly

