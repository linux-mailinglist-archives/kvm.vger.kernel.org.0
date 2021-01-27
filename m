Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E7D30575E
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 10:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233985AbhA0JvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 04:51:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29224 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235181AbhA0JsY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 04:48:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611740818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p2ZgdeE8emMvrTo+qZdhtSbV4TLt//BKUXr6Nkuxz8M=;
        b=PmdguyM2/pMShwqQkKUzs1pNeKizei7kZNKfVl9g2uszD/WFIN8r8Sb6d2ykBWm38oei88
        8U++DqIrJkcp2d52Uvr0RaV2P9cKXjY6UEYxHlXO/1TB2VpAQAF/uvWKwyMNsyKpgSymiv
        PU7bxGAIHu9j9MJ7q2hK++35BLWLf7M=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-RM1SRHECOwSKcFs8S2-YAQ-1; Wed, 27 Jan 2021 04:46:57 -0500
X-MC-Unique: RM1SRHECOwSKcFs8S2-YAQ-1
Received: by mail-ed1-f72.google.com with SMTP id dg17so1048497edb.11
        for <kvm@vger.kernel.org>; Wed, 27 Jan 2021 01:46:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p2ZgdeE8emMvrTo+qZdhtSbV4TLt//BKUXr6Nkuxz8M=;
        b=bA0ArT/wdXy4kYzttzoizqINRDnQNToSDFp22yGl/oqyD4Z3hOQ5IBs2W73kWdUb54
         vVB55I2aJzRfd8MdTqmIdWY6XfMFXlhLl0ElQfiG7TwxTpSUoWpJB6vlM/h1MdnYVfL+
         Vv8mRZUeDhw5Y5gzZy9YOzlrqvaY/uE2yDWLCk+D5ne4qGc8TMgXlx7UrpWdW3wgvQJ7
         zzw2Ko5bfAPHVc066WG1aBBwdJRN71RdwWHUdfYVxHV9/dLywQCuNMbjL6koJG8inWyM
         WrLAQ0Bpq8tT7tYyG0mfm7XFwfmxOg01MIPHBYIP6bnxwlUtZNYlrnQrNqGqUng6P7Mq
         1Iww==
X-Gm-Message-State: AOAM532xMNlfIgF0ryKulVu1aF8cWB1BerIWZ1kKwHN3slLDrxRpoWXn
        E5URJmWFqn1QbNtUwnVbmBTT69hhLGqQWWYx1HbvB4qyauFGsZH8Uz4WwVMPrag1dbrzMW1JPCl
        t+KNYrzXwrNsd
X-Received: by 2002:a17:906:9342:: with SMTP id p2mr6328413ejw.300.1611740815580;
        Wed, 27 Jan 2021 01:46:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzqxTjCXlGq65ZXJizGzN/1wJ3EKGImAEp1e+xOhoLzSLVqiLN4lEgiB1lVZKT0JTaXxWmqzw==
X-Received: by 2002:a17:906:9342:: with SMTP id p2mr6328403ejw.300.1611740815349;
        Wed, 27 Jan 2021 01:46:55 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id lh26sm554051ejb.119.2021.01.27.01.46.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 01:46:54 -0800 (PST)
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Thomas Huth <thuth@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201105081805.5674-1-chenyi.qiang@intel.com>
 <20201105081805.5674-9-chenyi.qiang@intel.com>
 <6174185b-25e0-f2a2-3f71-d8bbe6ca889d@redhat.com>
 <7aa67008-a72f-f6e3-2de4-4b9b9e62cd86@redhat.com>
 <e1ba2803-877c-e7d5-0a16-f356d5c2b571@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Add tests for PKS
Message-ID: <ce0fad10-ddca-2102-0331-86ddcba9e808@redhat.com>
Date:   Wed, 27 Jan 2021 10:46:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <e1ba2803-877c-e7d5-0a16-f356d5c2b571@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/01/21 08:41, Chenyi Qiang wrote:
>>
> 
> Hi Paolo,
> 
> Thank you for your time. I was just thinking about resending this patch 
> series to ping you although no changes will be added. I really hope to 
> get the comments from you.
> 
> Do you want me to resend a new non-RFC version as well as the QEMU 
> implementation? or you review this RFC series first?
> 
> Thanks
> Chenyi

Hi,

I have reviewed the KVM implementation and actually I have also 
implemented PKRS in QEMU's binary translation.  I'll send a patch and 
commit this one too, since it can be tested.

For QEMU you'll still have to post the KVM parts (getting/setting the 
PKRS MSR) since I don't have a way to test those.

Paolo

