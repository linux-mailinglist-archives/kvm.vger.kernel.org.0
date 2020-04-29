Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1AF41BD760
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 10:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgD2IgZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 04:36:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23996 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726543AbgD2IgY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 04:36:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588149383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZRgQdTkn6qzRkQ8VVsW9dG8WYy4nYX+Jt55KEFeKtGA=;
        b=NDExp36RLF35uwfj3ZzwiMAwoMH/+qMTYSeB3Zp8I654+a+Ecuj/5lFWx/4ILb5AsQADX6
        FbyloKjMh6XlihJV1b9mNTAQKesXtVcrE28t6KMb2ZVBChrcCoSC1PPH8JTeDnrWB8otn0
        QlPnwIihC0CXnpqI0/B6hFEO42xFv68=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-Q6XBwiFROHmqALlBhrzmQQ-1; Wed, 29 Apr 2020 04:36:19 -0400
X-MC-Unique: Q6XBwiFROHmqALlBhrzmQQ-1
Received: by mail-wm1-f69.google.com with SMTP id 14so720420wmo.9
        for <kvm@vger.kernel.org>; Wed, 29 Apr 2020 01:36:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZRgQdTkn6qzRkQ8VVsW9dG8WYy4nYX+Jt55KEFeKtGA=;
        b=j+fulwyAHROvUbl1Zdkpf7tq+l0/R7/l5pr0pyDRVOdGttmqimp1s8vnQm/Ti/WgRz
         TmGED4THqRJa6nsr1lhnoOB5gCJ9dNVgNP522uVaGiBZDoNBW6xuEwXWniqRpWfZx3j4
         j3IfwiFwNo+zzGDl1DVlOrKfI0H39utzIVM1V5sdLT+tjTIbHON5QuxEzlUkisbzjNOS
         xNf5ZFYPFtv1B+Vkw+W3SFL9RUYURmduOkVh998L6FLXH1mYyN69fKQSs3uMcPmHyWjH
         EPf44OONdEn0alt3N9haws2H1U7QRavLh06FzATlPQtRqxaPHJYLz2mjxFU5xBQTz3h4
         TaXg==
X-Gm-Message-State: AGi0PuZ1y3/l4QzxTiSn0EpZU6PEXUcK/i+uYqx3LY0hsvn9Rpj8wbdr
        4cULVgdjLyiDDSlrev4dt7p1YEm6EACYHIr2gr3sfCoVkMeiKPPVMNc/k+0pfOa5fPoDCBZsCeP
        4c5JuDyRnmu+G
X-Received: by 2002:adf:9342:: with SMTP id 60mr36541877wro.129.1588149378460;
        Wed, 29 Apr 2020 01:36:18 -0700 (PDT)
X-Google-Smtp-Source: APiQypLSaWR1sAvWMX7AGwwO6UHEwfuQ24iWbemgcg/Uw0ef/sYvFheYyqtDLemSd+ABFL6cnQwmhw==
X-Received: by 2002:adf:9342:: with SMTP id 60mr36541854wro.129.1588149378247;
        Wed, 29 Apr 2020 01:36:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac19:d1fb:3f5f:d54f? ([2001:b07:6468:f312:ac19:d1fb:3f5f:d54f])
        by smtp.gmail.com with ESMTPSA id s6sm6686281wmh.17.2020.04.29.01.36.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 01:36:17 -0700 (PDT)
Subject: Re: [PATCH 12/13] KVM: x86: Replace late check_nested_events() hack
 with more precise fix
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
References: <20200423022550.15113-1-sean.j.christopherson@intel.com>
 <20200423022550.15113-13-sean.j.christopherson@intel.com>
 <CALMp9eTiGdYPpejAOLNz7zzqP1wPXb_zSL02F27VMHeHGzANJg@mail.gmail.com>
 <20200428222010.GN12735@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6b35ec9b-9565-ea6c-3de5-0957a9f76257@redhat.com>
Date:   Wed, 29 Apr 2020 10:36:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200428222010.GN12735@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/04/20 00:20, Sean Christopherson wrote:
>> So, that's what this mess was all about! Well, this certainly looks better.
> Right?  I can't count the number of times I've looked at this code and
> wondered what the hell it was doing.
> 
> Side topic, I just realized you're reviewing my original series.  Paolo
> commandeered it to extend it to SVM. https://patchwork.kernel.org/cover/11508679/

If you can just send a patch to squash into 9/13 I can take care of it.

Paolo

