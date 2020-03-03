Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E62817741E
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 11:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbgCCK0Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 05:26:25 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27681 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728473AbgCCK0Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Mar 2020 05:26:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583231184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qg05cq73WzBGGAry/Xv5FvYaaU5AB/YsxHlJBvC5Ieo=;
        b=Qlg/eSps7fUFoTEHVhZGR/IhvsJSzTtbz01lGbe88F/+NXpWmzaRO4teN24Flzpd9TbTZ3
        y8rTZBGe11i0dKRJT3TYuhgmXf/TAkvUqB3PulndXy1R7eXVFghkz8Pw6Kl6TdmIaE2YUA
        i+V+JfaPrCsedrfKi25/V3WymmyA/7E=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-7X8uXYjoPpaPPguvDf4b9w-1; Tue, 03 Mar 2020 05:26:23 -0500
X-MC-Unique: 7X8uXYjoPpaPPguvDf4b9w-1
Received: by mail-wm1-f71.google.com with SMTP id y7so888752wmd.4
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 02:26:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qg05cq73WzBGGAry/Xv5FvYaaU5AB/YsxHlJBvC5Ieo=;
        b=IZq+5wvH1ineVEUsPhz9PYwseoEmqx0kUlcoDfV9ci+PCxqvzVg1UXBMtTGKtTnpuP
         lxHzJySA4AchYn0lkAH7Z5JyQZJ+8sGx9qNw2/IhKo78P3fwqe8irdqGnENRv2xyso8y
         apT3WVnzn1gCRo4Mn+bB+7n85qYBNe54bQAMY4MyXdPvclDeoSWrW/CJCyHwUfnMNtHj
         GQrCt8MmRhxsZ6M/6ucI2RaJh5Z4TGAMN8fS6tbusLr8m1w5rDe9yQog51ICfyR7z+KL
         tfZvy4ZkXG1+XCBHo6gnVwcm4KfjbGiCM5SBVGsZf7xOPiXzhtAURGroh9G6Qii/uJXN
         rwPw==
X-Gm-Message-State: ANhLgQ1RjFLxDKXU4e52mUlsAmi3i+GKUBMCYTKSzLgUTGHBZ+BG69wp
        YIOD8uNNn7GThBaJ2jyA0qN/rB6QsXmrS7jKCHgoqRXaywkCVjdOkvN+LySqkI+DKEOqvzjTv+j
        igBW5dc/RaefU
X-Received: by 2002:a7b:c010:: with SMTP id c16mr3653509wmb.148.1583231182069;
        Tue, 03 Mar 2020 02:26:22 -0800 (PST)
X-Google-Smtp-Source: ADFU+vttGcMcE2BIxjss8IG6DykhJvTycSZ+bjh9Lev0XveVbRwLE+LNmMMY2pIjdVyXsWaMa0kqxA==
X-Received: by 2002:a7b:c010:: with SMTP id c16mr3653482wmb.148.1583231181802;
        Tue, 03 Mar 2020 02:26:21 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:9def:34a0:b68d:9993? ([2001:b07:6468:f312:9def:34a0:b68d:9993])
        by smtp.gmail.com with ESMTPSA id l17sm32608641wro.77.2020.03.03.02.26.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 02:26:21 -0800 (PST)
Subject: Re: [PATCH v2 08/13] KVM: x86: Dynamically allocate per-vCPU
 emulation context
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200218232953.5724-1-sean.j.christopherson@intel.com>
 <20200218232953.5724-9-sean.j.christopherson@intel.com>
 <87wo89i7e3.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <83bd7c0c-ac3c-8ab5-091f-598324156d27@redhat.com>
Date:   Tue, 3 Mar 2020 11:26:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <87wo89i7e3.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/02/20 18:29, Vitaly Kuznetsov wrote:
>>  struct x86_emulate_ctxt {
>> +	void *vcpu;
> Why 'void *'? I changed this to 'struct kvm_vcpu *' and it seems to
> compile just fine...
> 

I guess because it's really just an opaque pointer; using void* ensures
that the emulator doesn't break the emulator ops abstraction.

Paolo

