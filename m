Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD2B110FF14
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 14:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbfLCNsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 08:48:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29510 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726024AbfLCNsP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 08:48:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575380894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P5EBEqGJPiXNRYZecHBTQ2o/Z3ABHvD6lVKEN+XEBDY=;
        b=dk9boR/8D4mmRpsW3dySsJYZlVoMzweSufw4JfIWugJYHYvraJMlbHK//FNpMO9x5EN7dc
        bGoyEd1DElPMynZLXQIempHJmGLEHP9sEuIuVxwSS+kXlgJWElMVjsP8PIRIsc9pXMN7Ep
        fGgPV1IT4bOWCmok5WFidUEIr+Ir/6Q=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-fVCBiIsZNF-656OwG2nYfA-1; Tue, 03 Dec 2019 08:48:13 -0500
Received: by mail-wr1-f72.google.com with SMTP id l20so1799131wrc.13
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2019 05:48:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P5EBEqGJPiXNRYZecHBTQ2o/Z3ABHvD6lVKEN+XEBDY=;
        b=lBGLT74xKRhx0PCrNqc4yV7yTH0zpam4TES4ud6RAZRdDM9KJ+vbC/zAN6cY7vS6pu
         GhAUKPnK/yQC6TkoNjsMOjRqY1XwAKPeD6sykTTn0EYLDA0SRlIaapgehPf9EVPZ5SCk
         c8I/zi2tRA7oqkOYO57IQV4DejVVHAZNGKEES3s/Zor5uC4udIt0N513AeGI4aCWa59r
         uA7oNd0F8G2yoAVqUdHXPx9mWQwHxHIzdAiChM5TMdj4Uk+fr35/AGy6+7HAqI9+U9VK
         kIPlL3JUztbfEX4ofLPexgyNfQ+KdZAWGpO+3N6kgFmfSMr2SJEy2QmPAPldq9qDQghf
         Os0A==
X-Gm-Message-State: APjAAAXWzl4UkPqsUJ4dOHybmCwhm2Gw7dU4NNA7uxo+aM2kJaVANYE9
        89S1C2IINqa3h9rVuw1lIaXl6+HzjfXAdElXW9mjjeUBllYoLIHkof4wtUDDTyHXjQh4GEp/Hng
        cEg8OdnNw5tEU
X-Received: by 2002:a05:600c:230d:: with SMTP id 13mr29075743wmo.12.1575380891891;
        Tue, 03 Dec 2019 05:48:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqy1BjGoe1DzkR4woD0VDV01r9r26SUZiRfcr2ar76yyw43E2q/uHXedhVEWM4sCNcuphONk7Q==
X-Received: by 2002:a05:600c:230d:: with SMTP id 13mr29075727wmo.12.1575380891617;
        Tue, 03 Dec 2019 05:48:11 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a? ([2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a])
        by smtp.gmail.com with ESMTPSA id u26sm3075492wmj.9.2019.12.03.05.48.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2019 05:48:11 -0800 (PST)
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <20191202201036.GJ4063@linux.intel.com> <20191202211640.GF31681@xz-x1>
 <20191202215049.GB8120@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fd882b9f-e510-ff0d-db43-eced75427fc6@redhat.com>
Date:   Tue, 3 Dec 2019 14:48:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191202215049.GB8120@linux.intel.com>
Content-Language: en-US
X-MC-Unique: fVCBiIsZNF-656OwG2nYfA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/12/19 22:50, Sean Christopherson wrote:
>>
>> I discussed this with Paolo, but I think Paolo preferred the per-vm
>> ring because there's no good reason to choose vcpu0 as what (1)
>> suggested.  While if to choose (2) we probably need to lock even for
>> per-cpu ring, so could be a bit slower.
> Ya, per-vm is definitely better than dumping on vcpu0.  I'm hoping we can
> find a third option that provides comparable performance without using any
> per-vcpu rings.
> 

The advantage of per-vCPU rings is that it naturally: 1) parallelizes
the processing of dirty pages; 2) makes userspace vCPU thread do more
work on vCPUs that dirty more pages.

I agree that on the producer side we could reserve multiple entries in
the case of PML (and without PML only one entry should be added at a
time).  But I'm afraid that things get ugly when the ring is full,
because you'd have to wait for all vCPUs to finish publishing the
entries they have reserved.

It's ugly that we _also_ need a per-VM ring, but unfortunately some
operations do not really have a vCPU that they can refer to.

Paolo

