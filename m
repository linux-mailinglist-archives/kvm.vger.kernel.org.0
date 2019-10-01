Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC6BC35A6
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 15:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfJAN2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 09:28:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36286 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726829AbfJAN2y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 09:28:54 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F3F4FC049D7C
        for <kvm@vger.kernel.org>; Tue,  1 Oct 2019 13:28:53 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id b6so956173wrw.2
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2019 06:28:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fgEpXZCxadIaSlGyam7Y94cKgN0MEHx1nsTGGiTCw4M=;
        b=RNMak/rmZm/M7uS9/CQ/hl9c/AED6h13bxy/xp/F1QHGYAsEuqp88hWceIga8WkAdP
         wzXRvqp+k8xJyWiRlF4i+DVNbMwNk+pbebvXY7uQGDdgnrHjGpn92ZvHRGHeNKZFiZbn
         8DWArnukRUyvhIVHLNVNS20pftfb7t4aMUAtqwDUKmCvsRqqr5tEFwqzPshWt8B3Y8lA
         5VIjRNCLa4WmrgYv1SKclWYIoGyMWivKYK0CwFiIqOC9JUoR+2uvoFiFlkVQPaiLaQ7T
         ogo6QcQRSJBuuHmY/J/Z+EfYqi/6HH3nU6NyLEUnSUNWNVHcmp6VcNTqVv/WkuYWP9hs
         uKWA==
X-Gm-Message-State: APjAAAW6boeZgkqj6j8v5KpR19ZYw9AnxnIIIOZr8+DSoWY1wDZz4LLs
        mBL7q17UZwGXMLUSPbnCW+3xnZPpCe/fiAu2myYJcnzi2mjsXhXKfaL4gL+rLoCq2jB6bzVx8jt
        G5prvhzuJHSB8
X-Received: by 2002:a05:600c:d4:: with SMTP id u20mr3990646wmm.66.1569936532343;
        Tue, 01 Oct 2019 06:28:52 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw/i8kbK3b/qONuZ8hXJrG8l0X9syAoWOYufms4Y9u3XQgQPUBprQ476ixAo7Std1v6UDO2jA==
X-Received: by 2002:a05:600c:d4:: with SMTP id u20mr3990618wmm.66.1569936532047;
        Tue, 01 Oct 2019 06:28:52 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:dd94:29a5:6c08:c3b5? ([2001:b07:6468:f312:dd94:29a5:6c08:c3b5])
        by smtp.gmail.com with ESMTPSA id r7sm16709411wrx.87.2019.10.01.06.28.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Oct 2019 06:28:51 -0700 (PDT)
Subject: Re: [PATCH] kvm: vmx: Limit guest PMCs to those supported on the host
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Marc Orr <marcorr@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20190930233854.158117-1-jmattson@google.com>
 <87blv03dm7.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <08e172b2-eb75-04af-0b63-b0516c8455e1@redhat.com>
Date:   Tue, 1 Oct 2019 15:28:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87blv03dm7.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/10/19 13:32, Vitaly Kuznetsov wrote:
> Jim Mattson <jmattson@google.com> writes:
> 
>> KVM can only virtualize as many PMCs as the host supports.
>>
>> Limit the number of generic counters and fixed counters to the number
>> of corresponding counters supported on the host, rather than to
>> INTEL_PMC_MAX_GENERIC and INTEL_PMC_MAX_FIXED, respectively.
>>
>> Note that INTEL_PMC_MAX_GENERIC is currently 32, which exceeds the 18
>> contiguous MSR indices reserved by Intel for event selectors. Since
>> the existing code relies on a contiguous range of MSR indices for
>> event selectors, it can't possibly work for more than 18 general
>> purpose counters.
> 
> Should we also trim msrs_to_save[] by removing impossible entries
> (18-31) then?

Yes, I'll send a patch in a second.

Paolo
