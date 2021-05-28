Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554F8394620
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 18:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236068AbhE1Q7Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 May 2021 12:59:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33626 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230337AbhE1Q7W (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 May 2021 12:59:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622221067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nsUDfVx6kw1QKKH4CSV+8SNh91THtBJmewd0AtxZsM0=;
        b=WcwqrGMXKSFcWxhaeVWMCFRDrxtR44lbjLMX1IJ/pwZbFX8HGsEPca563kDOL2GqKTu+zh
        lD1CbFchB4dqwVfpqgOuJQhdZH0bmJtiJAdx+kEs9J5GC0+0lCrdQSX1vpas+fAqztnGkN
        j8dUiwXPcZVFRsTr3FnnFkRFEVkqx0s=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-diGgjC2jOvmgWArvhjYHJw-1; Fri, 28 May 2021 12:57:46 -0400
X-MC-Unique: diGgjC2jOvmgWArvhjYHJw-1
Received: by mail-ed1-f70.google.com with SMTP id q18-20020a0564025192b02903888712212fso2410179edd.19
        for <kvm@vger.kernel.org>; Fri, 28 May 2021 09:57:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nsUDfVx6kw1QKKH4CSV+8SNh91THtBJmewd0AtxZsM0=;
        b=NFos6V2S4iUauicklZHKX/vXSK5eE3SthzlS/Glul/2Mb7nZaEXy5HZfWFF4D30wR1
         HzuIb75cBXhYyyJy7PuOi+RfyVpbZ9dVvaZoOAhsn7ruyqsjdyZb1VRH0WYtELKloK/0
         GeTq6yVR22piHIEqyfpLBcEhCl+ZDIOIoAi067Cvd+xaCPwz0eR+Q7ZDCh4V+mK5LSHN
         unXfaIVK7ZcMMp6L103TmzDjOS3nDIWzvFMpLPCh/iJUGlUoT1s+QambCFs/cMI/Utq8
         XduCgtzFgozQQ7APamOO0TRvx+L/pUBfW1hAt8cxjh5K2PXAmydH5Gsp7zQTsiegn4UU
         aJEQ==
X-Gm-Message-State: AOAM533WP6DdfiZqypXjq27lLCCz8KUO4C9BxhAkwbXCmElRuDNgDzrN
        wt5DLhJN/dWHBLLJJXu750FI5ZXYr17/IoDIHTCAXIp5L1LcT/NjP3ldkJoIeVk1wu+Os7ToYvx
        Wo2upfzlLbOkp
X-Received: by 2002:a17:906:a88c:: with SMTP id ha12mr10040287ejb.129.1622221064240;
        Fri, 28 May 2021 09:57:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7sI8kp8yuGAgJ1e35LlzT33u7gefY6svEG8stz3Z+BamOigP5rdwUT8mplASzQlfiImy/Jw==
X-Received: by 2002:a17:906:a88c:: with SMTP id ha12mr10040273ejb.129.1622221064030;
        Fri, 28 May 2021 09:57:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l19sm2197864edw.58.2021.05.28.09.57.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 May 2021 09:57:43 -0700 (PDT)
Subject: Re: [PATCH] Move VMEnter and VMExit tracepoints closer to the actual
 event
To:     Dario Faggioli <dfaggioli@suse.com>,
        Sean Christopherson <seanjc@google.com>,
        Stefano De Venuto <stefano.devenuto99@gmail.com>
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, rostedt@goodmis.org,
        y.karadz@gmail.com
References: <20210519182303.2790-1-stefano.devenuto99@gmail.com>
 <YKaBEn6oUXaVAb0K@google.com>
 <ab44e5b1-4448-d6c8-6cda-5e41866f69f1@redhat.com>
 <d7dc2464a8aa3caf64f955fe6c9df0cb8fe3b746.camel@suse.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c30bfb44-2dc7-cb9c-c038-5ab08f611586@redhat.com>
Date:   Fri, 28 May 2021 18:57:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <d7dc2464a8aa3caf64f955fe6c9df0cb8fe3b746.camel@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/05/21 18:55, Dario Faggioli wrote:
> So, Paolo, just to be sure, when you said "the tracepoint on SVM could
> match the clgi/stgi region", did you mean they should be outside of
> this region (i.e., trace_kvm_enter() just before clgi() and
> trace_kvm_exit() after stgi())? Or vice versa?:-)

Just outside, yes.

Paolo

