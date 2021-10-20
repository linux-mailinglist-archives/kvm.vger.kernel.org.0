Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2E8434A31
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 13:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhJTLkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 07:40:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20409 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230077AbhJTLkN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 07:40:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634729878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WMFMpI2ywfhiF/WZQ2cVNkUkb9LeUHwe6nPMf/N51Uk=;
        b=V50BNvCI7deabMuKT/F1J8cD7ckpQgcyFAzuAZtyFlH/1gHLvcZZwZPeJkOKPjFAYmWcRC
        UNKLBvwhOpIoMQrtIoFkRH5ahOoerAMLomuiimZbULGtH/wlzYrbsZWWS1LX9uSQLR5tCP
        qWvkPoidha6qSjZLPL85QhqMWtZm4YQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-tUByUijgOgq1MG-4bHCfsg-1; Wed, 20 Oct 2021 07:37:57 -0400
X-MC-Unique: tUByUijgOgq1MG-4bHCfsg-1
Received: by mail-ed1-f71.google.com with SMTP id u10-20020a50d94a000000b003dc51565894so14024035edj.21
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 04:37:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WMFMpI2ywfhiF/WZQ2cVNkUkb9LeUHwe6nPMf/N51Uk=;
        b=5hC0VJ0r+HMc6+62+sSXFzSypk7fDhpI/oKklABIOjMfSm5KFpiSfI8H8NnGXgZZL+
         YWhp4yAEefIfy/2FdbzK6uHBi+aV5uRKuaNGXLrrxl0wHf/KXLxp72ebPowYvBgU4Cqc
         jmwXO+r9s21jJr78FABRel6T1vAtquLwl2MNilOE5V0uFG1Yt/v9XmMdMkT3cICN3fKn
         OzFUgG54Tn/z4nDSSzIO84IqyNnpAUBxLcP6e5k1PRF0o18CXMGsnlTjJ02UR82QMx+V
         XJhtGO1nuHwXnm6CzSWmPkj+zC1rk60VdLpluIGYy+9BgSj6kuR7ZZsKjNW2B56+lNUH
         Jt5A==
X-Gm-Message-State: AOAM533xXdZMKpBpvo8si2Jevgefarpz7KmHn0q6cPotQVN6QTnH/8CN
        3mbt8qncOOZZmI1IobfbIfJV6Li4nwvIrAHT+ulXapZBq0Jeyp8dnAMILtAPaelxn4zjARhHTWv
        zCa+GbgA6/hhn
X-Received: by 2002:a05:6402:90b:: with SMTP id g11mr62795972edz.32.1634729876487;
        Wed, 20 Oct 2021 04:37:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/Kwn3SPasef1rECuTy0s1D3BJoVygPew/lcZ8vA2zu273zdL7RPPGrnK4RDV3fBbQVimbrg==
X-Received: by 2002:a05:6402:90b:: with SMTP id g11mr62795932edz.32.1634729876202;
        Wed, 20 Oct 2021 04:37:56 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id nb29sm1084687ejc.54.2021.10.20.04.37.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 04:37:55 -0700 (PDT)
Message-ID: <659fbd82-7d18-0e76-6fe4-b311897b4ae0@redhat.com>
Date:   Wed, 20 Oct 2021 13:37:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] rcuwait: do not enter RCU protection unless a wakeup is
 needed
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Davidlohr Bueso <dave@stgolabs.net>,
        Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Wanpeng Li <wanpengli@tencent.com>
References: <20211020110638.797389-1-pbonzini@redhat.com>
 <YW/61zpycsD8/z4g@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YW/61zpycsD8/z4g@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/10/21 13:17, Peter Zijlstra wrote:
> AFAICT, rcu_read_lock() for PREEMPT_RCU is:
> 
>    WRITE_ONCE(current->rcu_read_lock_nesting, READ_ONCE(current->rcu_read_lock_nesting) + 1);
>    barrier();

rcu_read_unlock() is the expensive one if you need to go down 
rcu_read_unlock_special().

Paolo

> Paul?

