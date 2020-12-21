Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF40B2DFFA6
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 19:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725898AbgLUSZv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Dec 2020 13:25:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31459 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726057AbgLUSZu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Dec 2020 13:25:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608575064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yIHhDp6JjovqIb+IiGQWcQSFYCxr+8xx7FZ95bj2vtE=;
        b=HITKSzaHDrV9M9NYaQomg4P13mq6vGOVjupIVP1l2SWrdXS+LnOGqqxot3SpHzA6sYw1KD
        RnnmBPETGz4mJw3lbk4QWgcMPI/vkLOlj/awTYSLb0fdDGCbPBFy+EUA1H5L34YWZgcpoI
        Ls3R3HsO3tWms7XPW6/az9vaTGRz4pk=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-rA7j1X1YNT-w3bHjQv6yOA-1; Mon, 21 Dec 2020 13:24:20 -0500
X-MC-Unique: rA7j1X1YNT-w3bHjQv6yOA-1
Received: by mail-ej1-f70.google.com with SMTP id n17so4345219eja.23
        for <kvm@vger.kernel.org>; Mon, 21 Dec 2020 10:24:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yIHhDp6JjovqIb+IiGQWcQSFYCxr+8xx7FZ95bj2vtE=;
        b=G13wNwRnhjkjrWNgzdyMx2tnMAULrNn+Qo1sSutNdmW6rgkL0UouLadXewvSgoGiCH
         1l+HLyTngjw/a6ln/PNwzZVFi8RNM6YxEoaQ2H6ZIk451CYI8OzKm+F0Gi7DE1BrZ6vG
         RZ1v8/yDGHzqnLif30zRDcjmGqZT9vFKMeKplX3boR2e7jeTD4tHeHjMYpTcw4qWrbok
         poLm6viaZ1pW+pT1EVET3wS4HVLoJ6S7qebIoTH+U5nnm1VTgFIbXJGJcyAz4NDiL8qH
         PqkmQ9eITkrlVH1BgrG7AM/gkDMonQ9oL2hCPapap4Q3UnRj8SqrPWDcV/bdUXlUM5IV
         Z0rg==
X-Gm-Message-State: AOAM530PPwlQNjPSg2JMUof6DvE2A9j3+J8BHsFwjXdXQdDoVY1/Op4v
        IlGt0AUROhWWiAoMJPGE8Lm/7mpus7clRCKnlTYhQB65Yf5m2wJnE8HGfwwpByARnCVZW81QpFP
        yOxJscR0ZOPTz
X-Received: by 2002:a17:907:2061:: with SMTP id qp1mr16109760ejb.222.1608575058887;
        Mon, 21 Dec 2020 10:24:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx5tpvy1N5ZQZV/nQ+r7ruRnK//awichKa9+ePVpHGO6xb4OUGHuiMWNdLcjY208ZHmqJtZdw==
X-Received: by 2002:a17:907:2061:: with SMTP id qp1mr16109751ejb.222.1608575058755;
        Mon, 21 Dec 2020 10:24:18 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id pv24sm9186118ejb.101.2020.12.21.10.24.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 10:24:17 -0800 (PST)
Subject: Re: [PATCH 2/4] KVM: x86/mmu: Get root level from walkers when
 retrieving MMIO SPTE
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Richard Herbert <rherbert@sympatico.ca>
References: <20201218003139.2167891-1-seanjc@google.com>
 <20201218003139.2167891-3-seanjc@google.com>
 <87r1nntr7s.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <493c0252-7aa1-b14d-0172-91bf75cf7553@redhat.com>
Date:   Mon, 21 Dec 2020 19:24:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <87r1nntr7s.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/12/20 10:10, Vitaly Kuznetsov wrote:
>> -	int root = vcpu->arch.mmu->shadow_root_level;
>> -	int leaf;
>> -	int level;
>> +	int root, leaf, level;
>>   	bool reserved = false;
> Personal taste: I would've renamed 'root' to 'root_level' (to be
> consistent with get_walk()/kvm_tdp_mmu_get_walk()) and 'level' to
> e.g. 'l' as it's only being used as an interator ('i' would also do).

Maybe agree on the former, not really on the latter. :)

Paolo

