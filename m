Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5513638E821
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 15:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbhEXN6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 09:58:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29509 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232409AbhEXN6J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 09:58:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621864600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rJGWlb0mzdcs5C9EH1U6m2Va0MhvnRjaEHGGSG6l/jM=;
        b=DYv4d6FR+Tn1BBBxIbvFbSr9Ixmmf8U1Oc2e4sgvncmbQIQJ2TK9Cz7XHIcWPdsPABpUf5
        wvRCBjl0FZbUkr8ZHTv5JjT1vWoDinv/TucYb++BTXKEiuSGe6SUSitFUO49rlejNG+MmA
        il/o48Nj1zXw5RwfqGb3ZhmVacA2yNU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-lNtbZdPZOmeK2Niz9XJz9A-1; Mon, 24 May 2021 09:56:39 -0400
X-MC-Unique: lNtbZdPZOmeK2Niz9XJz9A-1
Received: by mail-ej1-f71.google.com with SMTP id z1-20020a1709068141b02903cd421d7803so7595022ejw.22
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 06:56:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rJGWlb0mzdcs5C9EH1U6m2Va0MhvnRjaEHGGSG6l/jM=;
        b=KmqHizgCi4wRC6NjfE+vaVGmLa9SAzZhg2B71V3QUPChbZcvNOv8sS6ZshKTBWT4WW
         yOBhMw/59BYca23Xb5zSr1fB6dE8Hzr3PtEDmaBJsZgLxYUS7PgneJBHxiQv7CowQGAo
         U7wFC9cWt6WOfwUBKDv0699QSbQcvxupyVm1SE/tF4Vour0pbKDsdY1jEYBrb/Xn2VyG
         IH5FXwsFC4v0SZ82L10KoOpEFQW/iLesAJxEumHq9DV1+elZQ+qayj3FB62MjJaqZxHN
         Ve+/FrpbEX37gp7OXOS4qNU8mouDp0P5BKEwoNOhq2CkMIJnbMQfKtQ0aj7R/7B9JiVq
         q06w==
X-Gm-Message-State: AOAM533+NQcvLQQLb2VRw0gyr0FySicrSmdBuFEtrQOC21NMhjjDuhQS
        VMCopxSSV9DqG7YOIDrzAyiIGlyTyaCnCn8F9SWqL0+6ehpB4AbtjrvQCPELmW/dnJHtm7EESaZ
        DM6JZpbns8nuL
X-Received: by 2002:a17:906:710a:: with SMTP id x10mr23830931ejj.516.1621864597630;
        Mon, 24 May 2021 06:56:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxq0mpI+41JnPNU1+jhy8PAqOk7Rr0AjJRODt2B+GDUy9HDBcyVZhW7k15yjOkD1FtlXjLt9w==
X-Received: by 2002:a17:906:710a:: with SMTP id x10mr23830920ejj.516.1621864597507;
        Mon, 24 May 2021 06:56:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i2sm9176706edc.96.2021.05.24.06.56.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 06:56:36 -0700 (PDT)
Subject: Re: [PATCH v2 3/7] KVM: nVMX: Ignore 'hv_clean_fields' data when
 eVMCS data is copied in vmx_get_nested_state()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20210517135054.1914802-1-vkuznets@redhat.com>
 <20210517135054.1914802-4-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b79562d2-c517-b86c-8871-e8f81537f247@redhat.com>
Date:   Mon, 24 May 2021 15:56:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210517135054.1914802-4-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/05/21 15:50, Vitaly Kuznetsov wrote:
> 'Clean fields' data from enlightened VMCS is only valid upon vmentry: L1
> hypervisor is not obliged to keep it up-to-date while it is mangling L2's
> state, KVM_GET_NESTED_STATE request may come at a wrong moment when actual
> eVMCS changes are unsynchronized with 'hv_clean_fields'. As upon migration
> VMCS12 is used as a source of ultimate truth, we must make sure we pick all
> the changes to eVMCS and thus 'clean fields' data must be ignored.

While you're at it, would you mind making copy_vmcs12_to_enlightened and 
copy_enlightened_to_vmcs12 void?

Paolo

