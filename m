Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9346414D38
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 17:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236463AbhIVPjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 11:39:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53470 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236477AbhIVPjK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 11:39:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632325060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yPMfBTlyhQaNIBRsQlgsKkEXI7vjlBDH2c8APmBdvAw=;
        b=dT1p/WT4wrWIQ6UyqHMatzrNPTJ5pIImQ+JDI4c5yLOSIvBC2XMynthPikwplSvtWwqsa3
        o3I9zxBuYAhBLXFX7Ebkfcmr0JBjO46D8w5O9Z0fxQ4n8E98hQCGSYky82x+IfsYOLCfO6
        0z9LPeYti4xV4YAWxm1WBA0L+SA1rnQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-ExqxGsXkPkKjqJ8Qo4N0pA-1; Wed, 22 Sep 2021 11:37:39 -0400
X-MC-Unique: ExqxGsXkPkKjqJ8Qo4N0pA-1
Received: by mail-ed1-f72.google.com with SMTP id m20-20020aa7c2d4000000b003d1add00b8aso3593092edp.0
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 08:37:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yPMfBTlyhQaNIBRsQlgsKkEXI7vjlBDH2c8APmBdvAw=;
        b=0cbpFE3Eks3BCo4EDLAqRT10/5NUuAUtroxp+VKJ0B241lfiqldlsDgu9j1mz1KVnN
         rATfcdhjWtgAWxYOrXb4n5rdUsA2zXKNHg3stS0NB+/jHLRFVnxSwXnIwNLosoYJlRhO
         5+HsEKFXv70mwcidMHTuymf5Pw35sysvzGG5N3bKHaQZm3ro+o5g04E1hZChDj0ClGHz
         VNAf219Je7VlT4CFgZLVSokxFU9cyjjP9Q+Oaunq+ZHnpQIgX02C25RS/fQsC457n62x
         qB1R+ghhN24/1sSxwNcpWhdS+nu854J/MqARW3Mp5U+Xy4uNITZCF9je8gyXK6/M6k0M
         tnMA==
X-Gm-Message-State: AOAM533HA/O5bjGFd9y9M/oWU7QNZwQ8a28L9CaQYXwreUIsqgflfo3n
        MXVvn7rA7m73Bt8eiaN6bgPEB2Z6TYvyXazP8ygPBMV+9C4C5Hx5ak/XjTCJhpn7V6fC9KAMDE6
        OUpnYfo80HxoT
X-Received: by 2002:a17:907:1df1:: with SMTP id og49mr176118ejc.35.1632325057663;
        Wed, 22 Sep 2021 08:37:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqc1iXc2OLrx6isUvPIHnN9Gan4Ne4+V8C0dmc4M3Gy8q4yKHumt8T875e2Dt+Me/ihh1nbg==
X-Received: by 2002:a17:907:1df1:: with SMTP id og49mr176096ejc.35.1632325057433;
        Wed, 22 Sep 2021 08:37:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z20sm1398413edl.61.2021.09.22.08.37.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 08:37:36 -0700 (PDT)
Subject: Re: [PATCH v1 3/3] KVM: arm64: Add histogram stats for handling time
 of arch specific exit reasons
To:     Marc Zyngier <maz@kernel.org>, Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Will Deacon <will@kernel.org>,
        David Matlack <dmatlack@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210922010851.2312845-1-jingzhangos@google.com>
 <20210922010851.2312845-3-jingzhangos@google.com>
 <87czp0voqg.wl-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d16ecbd2-2bc9-2691-a21d-aef4e6f007b9@redhat.com>
Date:   Wed, 22 Sep 2021 17:37:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87czp0voqg.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/21 13:22, Marc Zyngier wrote:
> Frankly, this is a job for BPF and the tracing subsystem, not for some
> hardcoded syndrome accounting. It would allow to extract meaningful
> information, prevent bloat, and crucially make it optional. Even empty
> trace points like the ones used in the scheduler would be infinitely
> better than this (load your own module that hooks into these trace
> points, expose the data you want, any way you want).

I agree.  I had left out for later the similar series you had for x86, 
but I felt the same as Marc; even just counting the number of 
occurrences of each exit reason is a nontrivial amount of memory to 
spend on each vCPU.

Paolo

