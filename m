Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC173BE922
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 15:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbhGGOB2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 10:01:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30381 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231720AbhGGOB1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 10:01:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625666326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z7dzRxBxm91wjIPJ9WL8p7wOAJtFPjrAp62go4fmxBM=;
        b=Oab+mbvA78Hvsi7kR2Tw3n1LvenRG+Q+HtuN6b0jc4GspghbELXF6zVieIpxhg2Jr75rBw
        2773RIiqvWJRw0ythgjjq9mSwWc+Vs1zTGQ9eGBtNd1YysOhD+kvlI6P8VgLa0uIg5i6NT
        1B80mJzuH0PY2QTdAtCssNpylLTL4ow=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-IH93AFPWPxihp6Oolpr9TQ-1; Wed, 07 Jul 2021 09:58:44 -0400
X-MC-Unique: IH93AFPWPxihp6Oolpr9TQ-1
Received: by mail-ej1-f70.google.com with SMTP id u4-20020a1709061244b02904648b302151so584534eja.17
        for <kvm@vger.kernel.org>; Wed, 07 Jul 2021 06:58:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z7dzRxBxm91wjIPJ9WL8p7wOAJtFPjrAp62go4fmxBM=;
        b=qjutsDH2OFlIAiEa1E0wDluZtW+8wIZZ8o/owVNW+c4RYuSC4nWAfn9vMA01+uniRf
         RYjO9RXjhxJNjvPrZohPNhEtTifHJ1jC2LKs61gPkVRq7sbvg/XoVjD3AaLqNB9UCRfw
         VjTUgF8XxAJTvi7QgQ1J8Ek8xzGazWdMTGHOVeNK42I9eLiQpr5Zkd+8kVViMC2VPuOW
         vKgClDg4HnvLN/IlayRfH/LsvXCtXKvr3gaiSp3VegNv+jiV+uMrBpSIpo7cPsqGAlKF
         jo6Xo1fzUx3iiFHLi8PPuvJL+RXG3RZErYUeZmf13Cx9hsUaLp8QxoIfhYSysZwOVP7v
         NsxQ==
X-Gm-Message-State: AOAM5333hXzgQEPuIaj+qMX4t+wbK3B9leyqTgxQOBsqozlwUInz105R
        dUCWaVAw2XxiCy+IGfhFDlYBDN886Br8ZK9X3+yKQEqeLt9jV+TE+Sd7i2gAWin5MOOQhZVYnpK
        8akXdfhB+MOVq
X-Received: by 2002:a17:907:778a:: with SMTP id ky10mr24219095ejc.32.1625666323678;
        Wed, 07 Jul 2021 06:58:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyv4/GKMuuk/PByT1b/oedsUb6euFSbdyt/iajMDhfbbJx/hDlbvK2r52qKQEnfJptk9m8CAg==
X-Received: by 2002:a17:907:778a:: with SMTP id ky10mr24219079ejc.32.1625666323534;
        Wed, 07 Jul 2021 06:58:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z10sm8700548edd.11.2021.07.07.06.58.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 06:58:42 -0700 (PDT)
Subject: Re: [PATCH 02/10] KVM: x86: APICv: fix race in
 kvm_request_apicv_update on SVM
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>
References: <20210623113002.111448-1-mlevitsk@redhat.com>
 <20210623113002.111448-3-mlevitsk@redhat.com>
 <6c4a69ce-595e-d5a1-7b4e-e6ce1afe1252@redhat.com>
 <43ef1a1ea488977db11d40ec9672b524ec816112.camel@redhat.com>
 <9413056ebbd5997a35b446f2841589973484ba02.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <502391b4-5a5f-6f37-dab6-06ae276a205f@redhat.com>
Date:   Wed, 7 Jul 2021 15:58:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <9413056ebbd5997a35b446f2841589973484ba02.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/07/21 14:57, Maxim Levitsky wrote:
> 
> Hi!
> Any update? should I use a lock for this?

Yes please, even irq_lock can do.

Paolo

