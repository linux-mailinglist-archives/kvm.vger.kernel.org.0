Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F3C34F949
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 08:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbhCaGxP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 02:53:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21211 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233788AbhCaGwr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Mar 2021 02:52:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617173566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q/u2zDOZR2fJn1skX9F+p4SZWZio1ROklQRvgUa+VK0=;
        b=Yw9iKddDTbegL39R/yay6pOQDGRP2hTGWPQGnhin/o7rVFuz0NJhygGUBRiVBthrgb4rPU
        UkostWaajFNh30XvveeZ8N51Am5pWcQMFJaTTa0nRbrdOILPBkKTSEzsgcw5sy7tIWkuKc
        mtrvMJgw6VehRSlG7M57yRH7Azgpj2M=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-LoeJmH-FOLekxLNdhLnIyA-1; Wed, 31 Mar 2021 02:52:44 -0400
X-MC-Unique: LoeJmH-FOLekxLNdhLnIyA-1
Received: by mail-wr1-f72.google.com with SMTP id z6so487258wrh.11
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 23:52:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q/u2zDOZR2fJn1skX9F+p4SZWZio1ROklQRvgUa+VK0=;
        b=dTuiQl//XYFpT4nY8jZWiou3x9x/Q+tr5GKKeTz5+y+kA50AQ2Lw9PdEDjfMCOOsah
         ArMPtHDN8K9I9G5Cs9BeC/ZcLfKA+UUAeKuUoXqQvhzDEWLmxmUdB5LahFSpGEDWQdlR
         OYtoO/vO9JbplEjxuOjiipNB1W5ejaaflUAfXCB5z2tqLVCMB/GJzHDWf2bUHA4tkZLc
         7ayhRP5cST2MEZAvs+vQqciz6xirxsIrM7UYh5N4ucQP1xDGLc/IdViVswUJOy8jI8oh
         bUR6wTFJkNYAVAPnK35cPG1V0WlKJr1DGxEmOz/WL8+iMRM8Jx238umHuzn/39AUNA4Q
         QKyg==
X-Gm-Message-State: AOAM533pitWqIpvLrdNI0I4TU/7ee335tNxFjYTwVJeiL0RPw7bIvsOF
        i33WJ+SeP9cqRwh3lrsm8VPJq+M3MQhfnK6TTjuKVJFrjrd7oslGo6s4F/A1skw0mneFmou0IOF
        f9Wr4z91m4qBI
X-Received: by 2002:adf:82aa:: with SMTP id 39mr1870785wrc.114.1617173563543;
        Tue, 30 Mar 2021 23:52:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzA7hdY5OqUkh+/XOcmk1PNgls1Np2mDSAD7Q9PuhlUOiq5ZSTKixzJKpUROGn55Tvj6z9XBw==
X-Received: by 2002:adf:82aa:: with SMTP id 39mr1870770wrc.114.1617173563412;
        Tue, 30 Mar 2021 23:52:43 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.169.140])
        by smtp.gmail.com with ESMTPSA id x25sm3279080wmj.14.2021.03.30.23.52.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Mar 2021 23:52:42 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] KVM: x86: hyper-v: Properly divide maybe-negative
 'hv_clock->system_time' in compute_tsc_page_parameters()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
References: <20210329114800.164066-1-vkuznets@redhat.com>
 <20210329114800.164066-2-vkuznets@redhat.com>
 <20210330131236.GA5932@fuller.cnet> <87ft0cu2eq.fsf@vitty.brq.redhat.com>
 <4d7f375c-c912-fbeb-edd1-03d742d49dcb@redhat.com>
 <87a6qju97s.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7c6f61e9-f2a6-46dc-7ab6-dc6ae86c7b60@redhat.com>
Date:   Wed, 31 Mar 2021 08:52:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <87a6qju97s.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/03/21 08:29, Vitaly Kuznetsov wrote:
> I'm leaning towards making a v3 and depending on how complex it's going
> to look like we can decide which way to go.

As you prefer, but I would have no problem with committing v2 for now. 
 From the point of view of system_time being a signed delta your v2 is 
not a regression.

Paolo

