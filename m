Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4B036B1BD
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 12:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbhDZKlP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 06:41:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34857 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233086AbhDZKlP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 06:41:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619433633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bZZsUMt0KMjKP40YJJFPdYzvGN9VTk6y13Ps6YXhbp8=;
        b=VwANrziXijNKq/3jslGg6lITcSbmyvOtWguwgAsq2J5p9y3SmcRAVO2UqOKYB29H8d09wV
        igf0795fexMx3W6Q/WAaeiPE70efyxyV51iB9d51UlWE8509UqUBiUxunecdk8X8KwLFMx
        X7YKSz1yktfpnKBHqcY+MBxIEbeg5iM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-22oSDgsFOluRlP3XHv8szQ-1; Mon, 26 Apr 2021 06:40:31 -0400
X-MC-Unique: 22oSDgsFOluRlP3XHv8szQ-1
Received: by mail-ej1-f72.google.com with SMTP id n10-20020a1709061d0ab029037caa96b8c5so10090881ejh.23
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 03:40:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bZZsUMt0KMjKP40YJJFPdYzvGN9VTk6y13Ps6YXhbp8=;
        b=ZCSalSL0qYjJdvVaQK9DbkvFdfAH+0mtQ1UroWNWPN4OmwTMsQkWPRSL179UBYUw/D
         PXdti52168ITNXcNebgnbimLAGCE8hwQArRsaNkI8Ch9sFKZf0e+B4GX9QYPEIJ8w1fH
         Uy4iIntzn3rDVgcq5kg1Bd6HZCUzyR1I5Q1/EWyR8hWbso85iL07nDBPrkbB2bhXt0Os
         qhw5R8tm+s/YLcF8EZkNXY9H9CKrAKszhHxRkdbtIk1I1Bo9V6lD3y1EP9/lDKKRlLWR
         HY36gQD9kowaYQ8zO49X3JbdK5pjiBHMQfEZT5M/NNJ4XPBYGEU7n59A+mr56t/FvI4X
         nE2A==
X-Gm-Message-State: AOAM531dJ54J9kmYqHYCxAeXzhkEh8WrUdxIeGGTnFi2jj/ACa8dqoCc
        xsD0JEajjFwt53OkgwjlwED5yEPUi4fbXBWyqjnaU+sF0mfO0D5g+jy9N+cYF+PDF+BQnMa7gmY
        srafWguNKccO+
X-Received: by 2002:a05:6402:3587:: with SMTP id y7mr20979868edc.54.1619433630745;
        Mon, 26 Apr 2021 03:40:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUlQIAYodwBzUUiJWgYEpzQujF933VDY95XxUTEaag8DV7wjbNaWtxum0gxZnhcW6tOwzmwg==
X-Received: by 2002:a05:6402:3587:: with SMTP id y7mr20979847edc.54.1619433630557;
        Mon, 26 Apr 2021 03:40:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id g11sm14002799edw.37.2021.04.26.03.40.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 03:40:29 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] KVM: VMX: Invoke NMI handler via indirect call
 instead of INTn
To:     Lai Jiangshan <jiangshanlai+lkml@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
References: <20200915191505.10355-1-sean.j.christopherson@intel.com>
 <20200915191505.10355-3-sean.j.christopherson@intel.com>
 <CAJhGHyBOLUeqnwx2X=WToE2oY8Zkqj_y4KZ0hoq-goe+UWcR9g@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bb2c2d93-8046-017a-5711-c61c8f1a4c09@redhat.com>
Date:   Mon, 26 Apr 2021 12:40:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CAJhGHyBOLUeqnwx2X=WToE2oY8Zkqj_y4KZ0hoq-goe+UWcR9g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/04/21 11:33, Lai Jiangshan wrote:
> When handle_interrupt_nmi_irqoff() is called, we may lose the
> CPU-hidden-NMI-masked state due to IRET of #DB, #BP or other traps
> between VMEXIT and handle_interrupt_nmi_irqoff().
> 
> But the NMI handler in the Linux kernel*expects*  the CPU-hidden-NMI-masked
> state is still set in the CPU for no nested NMI intruding into the beginning
> of the handler.
> 
> The original code "int $2" can provide the needed CPU-hidden-NMI-masked
> when entering #NMI, but I doubt it about this change.

How would "int $2" block NMIs?  The hidden effect of this change (and I 
should have reviewed better the effect on the NMI entry code) is that 
the call will not use the IST anymore.

However, I'm not sure which of the two situations is better: entering 
the NMI handler on the IST without setting the hidden NMI-blocked flag 
could be a recipe for bad things as well.

Paolo

