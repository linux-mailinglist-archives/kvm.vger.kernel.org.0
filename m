Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E4D3B1BDF
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 16:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbhFWODw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 10:03:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30062 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230430AbhFWODv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 10:03:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624456893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GI7BUvQGaSJTYs1XHkSa35D9gwv1cTj0EBhXSBIFL1M=;
        b=S1o6A23ECx4vq9DQGGQIOlNVBm08Y2mS+YNEnnH6LeJfkiyRmGqO0ZPtrAYuXOc840GDYd
        DklbtNMjI/+AR+s8tFAVspMAFUx6x6hcEVanSxTTenvxYDjLcCXmkg+sVfhXepsQ8+uBA8
        cJ6etpy6WYVJNpLiC5JW4tpDiTKfrOc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-VpYiGRfpMhqFGGftp5t28Q-1; Wed, 23 Jun 2021 10:01:31 -0400
X-MC-Unique: VpYiGRfpMhqFGGftp5t28Q-1
Received: by mail-ed1-f69.google.com with SMTP id dy23-20020a05640231f7b0290394996f1452so1357622edb.18
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 07:01:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GI7BUvQGaSJTYs1XHkSa35D9gwv1cTj0EBhXSBIFL1M=;
        b=tjkOT6ZGHSjIp3sJ5Tk2AdwnXEIAmR6GQonsMPuE8ptLl7dOod0HZk2YjI9qHZHv6c
         AzQEGgrWrwwxwvXegPZHPbjHudJqJzBmetf0RzuoCRsZ6hd3ieb6itGueWQkir1xCDX6
         BgLo51ASHeeMCD0MyYrFH/8mRczCGC5iZxfQrg6FeSG/JOqJyJTGoX+ax9VwIRAtJ1pP
         N/aM+fNfVpNfCLApnrXbg757QpBbc2FcvnRR2VQhDUjB/z3VU1Tcip9n5IuQuCWqZLpC
         qBLBQEVhN0pgLq+RptRbOZnmS2crIaR9KdQmTtRfLqtywnHsVDKXo1uk8dpNkLR38HHt
         F9AQ==
X-Gm-Message-State: AOAM531PZjFYoccWd2LemZC97k7sMNEBiR3Gt51YeDpv7LzDAB5CtCJx
        Jc8+7fZnfxuh5QLKL6BKpj3m8RcYbIdYZBh49ADltYhCdZtLNU3Qo6DzObWAz6hOWXOo+YB0wU/
        LPhmmwP89KOqG
X-Received: by 2002:a17:906:36d5:: with SMTP id b21mr181084ejc.258.1624456890773;
        Wed, 23 Jun 2021 07:01:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxVVzhqdfVDJJTFG6BriT0PEnR8sAnb90HHFIoMhWugO9e/5JQG8bPfqCAHNolqC3qdIS/oPg==
X-Received: by 2002:a17:906:36d5:: with SMTP id b21mr181048ejc.258.1624456890517;
        Wed, 23 Jun 2021 07:01:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u12sm7382464eje.40.2021.06.23.07.01.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 07:01:29 -0700 (PDT)
Subject: Re: [PATCH 03/54] KVM: x86: Properly reset MMU context at vCPU
 RESET/INIT
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-4-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3c3f9251-cab4-70ee-6e38-85fe8e6579f7@redhat.com>
Date:   Wed, 23 Jun 2021 16:01:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210622175739.3610207-4-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/21 19:56, Sean Christopherson wrote:
> +	/*
> +	 * Reset the MMU context if paging was enabled prior to INIT (which is
> +	 * implied if CR0.PG=1 as CR0 will be '0' prior to RESET).  Unlike the
> +	 * standard CR0/CR4/EFER modification paths, only CR0.PG needs to be
> +	 * checked because it is unconditionally cleared on INIT and all other
> +	 * paging related bits are ignored if paging is disabled, i.e. CR0.WP,
> +	 * CR4, and EFER changes are all irrelevant if CR0.PG was '0'.
> +	 */
> +	if (old_cr0 & X86_CR0_PG)
> +		kvm_mmu_reset_context(vcpu);

Hmm, I'll answer myself, is it because of the plan to add a vCPU reset 
ioctl?

Paolo

