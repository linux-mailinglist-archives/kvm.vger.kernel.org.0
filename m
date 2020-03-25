Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAE5E192D87
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 16:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbgCYPzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 11:55:48 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:28070 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727592AbgCYPzs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Mar 2020 11:55:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585151746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uyp5KQDbaTuA45q/Xax3q7Sq5x15XAtmyACKrevDWP4=;
        b=AuKPokZljxUH28lSzuymVHwICEJ/MmjauPsiRDZQY4S+CHugABfleArJQ6tvSfPNV8FYIb
        zpOsYRRxY8wW/mDZyXo2Oev6SPoapPreVELa8xaGA/8szej8trEzldpKUNtY5OhbKfie+e
        wFummDeLCsQBFQH2Xgc0Rn/eKbvaanM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-Yp9ch34mMBqeO03QSYzRHA-1; Wed, 25 Mar 2020 11:55:44 -0400
X-MC-Unique: Yp9ch34mMBqeO03QSYzRHA-1
Received: by mail-wr1-f69.google.com with SMTP id e10so1358505wrm.2
        for <kvm@vger.kernel.org>; Wed, 25 Mar 2020 08:55:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Uyp5KQDbaTuA45q/Xax3q7Sq5x15XAtmyACKrevDWP4=;
        b=PCYA6fuiiOSAuaV+hQkGDjDdwSd/tmvsxTJ6KTtzCFP7gmMWoyEzefl0hcKbFHKN3a
         SG0DdN+pwbPtnqqPZdClboqDdQDBy1jUqXNNDnZNS1X3MBpsOGBQMTY5rB5vD9yGIw9M
         IMMhYxdN2PK1+S8jW/Ljrpknx6icuC8nYb3HzJCdwgBMZcW0S1QQlJS54x80m/bvnx/X
         39lcNcoTa3ARoc0ElG92vypB1A0WVNXO6Xxb2swrMiLbvMaVX1afFfMKEcvZgO6IJ9OX
         ASZuer6dIcDQOrxdKH6QM3yxrG5HFo9Gb8KZWLCr2EwtEWj3+v0cuqyf+Ls/t1s3DuPs
         XOQw==
X-Gm-Message-State: ANhLgQ1OyVKNzt8UOjzL8yCHEgpTKIINktbZ7djztmfzeQZsUbvPKIWN
        +4K5KLMVvtXQDNAXJDy0QulaFQ+0+WoPqKVFrIU+gBOZHH+0ocQJOA1BOZqkSZWjdIXfQORFJdU
        nr8Mrmz9ozexG
X-Received: by 2002:a5d:510d:: with SMTP id s13mr4108644wrt.110.1585151742842;
        Wed, 25 Mar 2020 08:55:42 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtr84A74132XneFu/qdjCKJKKAo6gtWQw73ZQv5xSzVApoFiDmSQRc9YzMzr0NqEKEw83Qidw==
X-Received: by 2002:a5d:510d:: with SMTP id s13mr4108625wrt.110.1585151742652;
        Wed, 25 Mar 2020 08:55:42 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id y200sm9674775wmc.20.2020.03.25.08.55.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 08:55:41 -0700 (PDT)
Subject: Re: [PATCH] KVM: LAPIC: Also cancel preemption timer when disarm
 LAPIC timer
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1585031530-19823-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <708f1914-be5e-91a0-2fdf-8d34b78ca7da@redhat.com>
Date:   Wed, 25 Mar 2020 16:55:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1585031530-19823-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/03/20 07:32, Wanpeng Li wrote:
>  			hrtimer_cancel(&apic->lapic_timer.timer);
> +			preempt_disable();
> +			if (apic->lapic_timer.hv_timer_in_use)
> +				cancel_hv_timer(apic);
> +			preempt_enable();
>  			kvm_lapic_set_reg(apic, APIC_TMICT, 0);
>  			apic->lapic_timer.period = 0;
>  			apic->lapic_timer.tscdeadline = 0;

There are a few other occurrences of hrtimer_cancel, and all of them
probably have a similar issue.  What about adding a cancel_apic_timer
function that contains the combination of
hrtimer_cancel/preempt_disable/cancel_hv_timer/preempt_enable?

Thanks,

Paolo

