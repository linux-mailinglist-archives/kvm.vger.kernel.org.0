Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEF64019E0
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 12:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242027AbhIFKbs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 06:31:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48760 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231174AbhIFKbr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 06:31:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630924242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DsJzjdFaAaFnFOTOkzUAnviexzjsd3SYfhlH0e4oIgM=;
        b=JUZsZn7syv21MZdyhlWV7lj4kmgMQww44+DOTGoN8+nRHWNWoYaOPJdGYoEmU79Tqjas9z
        IzkBlK8WXfXYoqW+yca2szogeHXlZluCqZ4kjW46/pGS9KdTmWnkU2pkMI0hXDd+HHufHj
        2+mBoWjwK86R4ga0bAYjSOE7VE98rks=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-R0om8QEyPRCBPBSKzP4Vpw-1; Mon, 06 Sep 2021 06:30:39 -0400
X-MC-Unique: R0om8QEyPRCBPBSKzP4Vpw-1
Received: by mail-ed1-f71.google.com with SMTP id g4-20020a056402180400b003c2e8da869bso3490937edy.13
        for <kvm@vger.kernel.org>; Mon, 06 Sep 2021 03:30:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DsJzjdFaAaFnFOTOkzUAnviexzjsd3SYfhlH0e4oIgM=;
        b=UPHgeioexqF91ycc9rMf711nv4C0wwMYJdrUDJVVvZ4Vny+OXhFf9fAFlV+Sk9VQEH
         FcXQ7w//k4bPcgHaiS17Q5cDTR/TM8g1dkB7xUvErGKWTTifJrjMNwAGSJE3Ds61p5KH
         qwj+7XrUijiQxaqDXu07trv/iKOXzoA47+NTBK9XKUKWozxL7ldHOsfP/gAR2TIhVd22
         uEEwj5OHLV2SWmUdcxDFOW+wGWamPLu22uipXKdXSs+HnCeajmHejgg0Q3hWoDDLLawh
         xfA7qc3potvM3RA+IFpevhst2TWGV76QJMfIYR4kwYOZnQ/5HvTpYOYKirda7qy/NWSa
         MJIA==
X-Gm-Message-State: AOAM532YXm70JqkfdC7tNuyboKHl5w1IfmQ7jdfVoxeviJSOcVhWnEy9
        9tWa+IOgq5qR8vIneySSgTEj/m5PSsHF7oNcoUB9xk6xVQjsfrDAdTBnHOxt0RuNdgf9VUsPvQA
        GKafbGV2ZE0cL
X-Received: by 2002:a17:906:840f:: with SMTP id n15mr12968709ejx.460.1630924238784;
        Mon, 06 Sep 2021 03:30:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyMCUYgL2nI/1IEAUywDA6nmrVd/9sY5LrgsiYBRKNUDcBu6hkVNrMNtcvgdOVBU63XaIaC/A==
X-Received: by 2002:a17:906:840f:: with SMTP id n15mr12968698ejx.460.1630924238631;
        Mon, 06 Sep 2021 03:30:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id bt24sm3713982ejb.77.2021.09.06.03.30.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 03:30:38 -0700 (PDT)
Subject: Re: [PATCH] KVM: stats: Add VM stat for remote tlb flush requests
To:     Marc Zyngier <maz@kernel.org>, Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        David Matlack <dmatlack@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
References: <20210817002639.3856694-1-jingzhangos@google.com>
 <87v943rx32.wl-maz@kernel.org>
 <CAAdAUtjFdEX73fTDu-+gGfPR=KqvvSzVRZ=vVGJe=8=iAJOv1A@mail.gmail.com>
 <87eeaqsnk1.wl-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <05e2a8e3-c9ae-cd0d-7e72-d32e93c58ace@redhat.com>
Date:   Mon, 6 Sep 2021 12:30:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87eeaqsnk1.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/08/21 18:52, Marc Zyngier wrote:
> Yes, this is what I meant, as I only quoted the bit that was redundant.
> 
>> These two counters would have the same value for arm64, but not for
>> others (at least x86).
> Sure. It is just that this patch does two things at once, but doesn't
> advertise it.

All in all, Jing's new stat is more appropriate than the one I used. 
I'll fix the conflict when pulling from you.

Paolo

