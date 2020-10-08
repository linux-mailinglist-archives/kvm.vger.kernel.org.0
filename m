Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A7D286E55
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 07:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbgJHFwy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 01:52:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42394 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727857AbgJHFwy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Oct 2020 01:52:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602136372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ltGs068siZf3xtEoiji16jcQ5M11pmWZuXAiz0lIBWM=;
        b=ItGSaHmJzviPqcbNayROSH4TPiRIPOv8dL0uZUjomWemYU3YoA1EEXHhG0qN0eF63lsxMY
        bRYBLSuDOupaCVNaRTdsB3VS3vCHWthQJmdxwzgwkWpa5v1w/awp+rkHUvdzV2lUf9oV3q
        xUYhZr5Ib0yIGw56TH3Jaj66wu3+Efs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-37R2NHLFPjm0SOkatj-9uw-1; Thu, 08 Oct 2020 01:52:51 -0400
X-MC-Unique: 37R2NHLFPjm0SOkatj-9uw-1
Received: by mail-wr1-f72.google.com with SMTP id 33so3445652wrk.12
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 22:52:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ltGs068siZf3xtEoiji16jcQ5M11pmWZuXAiz0lIBWM=;
        b=Q8ZgHgUpwh5mB38UTB0vXJc4RPZo3orjjBr1WqQUe3AGNaoszyukMH0L3egVxq0+m5
         vPuJJCjsXDQDhkGgiNta/YT6JfchFNf4WQFMmHSzg6oHWQ4Np/Udl52Y0fb5ctcSEY8I
         pdM/PF/eoy7VZJSc9FZ7IYj8zEw87vLk5bSdJ+121twgGj29wy7GNw8LOTIIMgaPoeXe
         L2jxfcF8StJle4+InCzFtaL6YhTjJWHNzrhqJIbIS/ULoXin+feF/jGRko1Ti7wliJPS
         P3Omn9OZfQMT3WHP5oMcCLg9RXYZFf076ZRR6xZhZfrFOVgsuY1mdkOao2aNh+RlFStD
         lWDw==
X-Gm-Message-State: AOAM533c5zxgB2MVaKX4Eb617nUxFMJejac1g8YlyObCVH6DFQ1DJEXQ
        p/XrbGsOFqTMgQJrLAnQiLK7aalZcx1K7cYQCfWp4wFsgeuYamwlhKe1yC/cwedcVHrcar1SYTV
        5g8QWWc8OYL5m
X-Received: by 2002:adf:fc8d:: with SMTP id g13mr7171576wrr.248.1602136370097;
        Wed, 07 Oct 2020 22:52:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy5Bm/ZD8U7+p2VglQe5fK4bJTyhYCj95+XyM/xiKcrn7gpj+d3p19Xy0SSDHPLrmm2ZEDASw==
X-Received: by 2002:adf:fc8d:: with SMTP id g13mr7171562wrr.248.1602136369782;
        Wed, 07 Oct 2020 22:52:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d2f4:5943:190c:39ff? ([2001:b07:6468:f312:d2f4:5943:190c:39ff])
        by smtp.gmail.com with ESMTPSA id j14sm5759851wrr.66.2020.10.07.22.52.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 22:52:49 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: Use a separate vmcb for the nested L2 guest
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, wei.huang2@amd.com
References: <20200917192306.2080-1-cavery@redhat.com>
 <587d1da1a037dd3ab7844c5cacc50bfda5ce6021.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <aaaadb29-6299-5537-47a9-072ca34ba512@redhat.com>
Date:   Thu, 8 Oct 2020 07:52:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <587d1da1a037dd3ab7844c5cacc50bfda5ce6021.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/10/20 00:14, Maxim Levitsky wrote:
>>
>> +	if (svm->vmcb01->control.asid == 0)
>> +		svm->vmcb01->control.asid = svm->nested.vmcb02->control.asid;
> 
> I think that the above should be done always. The asid field is currently host
> controlled only (that is L2 value is ignored, selective ASID tlb flush is not
> advertized to the guest and lnvlpga is emulated as invlpg). 

Yes, in fact I suggested that ASID should be in svm->asid and moved to
svm->vmcb->asid in svm_vcpu_run.  Then there's no need to special case
it in nested code.

This should be a patch coming before this one.

> 
> 1. Something wrong with memory types - like guest is using UC memory for everything.
>     I can't completely rule that out yet

You can print g_pat and see if it is all zeroes.

In general I think it's better to be explicit with vmcb01 vs. vmcb02,
like Cathy did, but I can see it's a matter of personal preference to
some extent.

Paolo

