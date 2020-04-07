Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 440D21A093E
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 10:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgDGIVx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 04:21:53 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48750 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727800AbgDGIVw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Apr 2020 04:21:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586247711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K15spboYUeYf/bjn+WnbKry7UBlqA+ppBvnlRgm50mY=;
        b=Eb5QURn7lRqvmMfp/i6nR69AJbyJtGeq1QnyYFQTxSCRg4VzQZm9l+qw2066Zi+0o/I9lH
        /RC6gI7R5/Szaiq1OucsxuqE3syfRpZSYji7ud7NLQYYct9lZMAch3fNvgLshRtXTvynq+
        /fmfic00E3/sYtP0nSFiPI4oYz+s3oQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-ymXkWuKVO-2gkd7DWcWzKQ-1; Tue, 07 Apr 2020 04:21:49 -0400
X-MC-Unique: ymXkWuKVO-2gkd7DWcWzKQ-1
Received: by mail-wm1-f69.google.com with SMTP id z24so388766wml.9
        for <kvm@vger.kernel.org>; Tue, 07 Apr 2020 01:21:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K15spboYUeYf/bjn+WnbKry7UBlqA+ppBvnlRgm50mY=;
        b=A6Fauuf9p/rS+m5TDs1JprnemiFa/30QUVEYZpAoArOzbFIl/mu9Je8CMTSvm7UfXC
         77N4Q2gRz7GxYVIvLQWytPtlviOOeXPuKz3ps7LhE+FcBh80MrVqOVSCPvZ69sOVP0U0
         UdXv9eJSzPWf0465ngcsmg++ptxiNMYIJUMIz36k1LZFQsDn29qR6jO3ygOjxVYJ7XuS
         ZRty+HE4mi2So/1vxsOySBjcT2cjISz1aC1bh/hGADRnboEhA46k2v7lS8KQrzO74zna
         4LAcsSGA+L1Mgi1ov+iTl5yBljHtkk75z/AWAYCIyFjltsb78DcAXS0pj7namQyLPESG
         MPhw==
X-Gm-Message-State: AGi0PubJHuX0F5SBL/aynGA1pbb/f24h5rKrZZ65ZvlYoUYV3Sv8b9Ah
        RBJGsAtjGT5GT85zxld/n8JyhcBVIiXoe4s5l+FHReg0xsh7uGbTBnCBJazF+MOQVmFr1Dp2f5R
        D+NeZo1AISCnS
X-Received: by 2002:adf:a448:: with SMTP id e8mr1362981wra.238.1586247708021;
        Tue, 07 Apr 2020 01:21:48 -0700 (PDT)
X-Google-Smtp-Source: APiQypL7oxoG+5qTFvSOQ7tJJy8npe9AKnp7V/bjHcxO1D8kR5OQp0szKSt9DFNY2rRfqhTgy8iD9g==
X-Received: by 2002:adf:a448:: with SMTP id e8mr1362951wra.238.1586247707721;
        Tue, 07 Apr 2020 01:21:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:98c9:e86f:5fe7:54a5? ([2001:b07:6468:f312:98c9:e86f:5fe7:54a5])
        by smtp.gmail.com with ESMTPSA id a15sm1335558wme.17.2020.04.07.01.21.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 01:21:47 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: don't clear mtf_pending when nested events are
 blocked
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
References: <20200406201237.178725-1-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f7688790-02bc-e634-eff6-e58d25da31a4@redhat.com>
Date:   Tue, 7 Apr 2020 10:21:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200406201237.178725-1-oupton@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/04/20 22:12, Oliver Upton wrote:
> If nested events are blocked, don't clear the mtf_pending flag to avoid
> missing later delivery of the MTF VM-exit.
> 
> Fixes: 5ef8acbdd687c ("KVM: nVMX: Emulate MTF when performing instruction emulation")
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index de232306561a0..cbc9ea2de28f9 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3645,7 +3645,8 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>  	 * Clear the MTF state. If a higher priority VM-exit is delivered first,
>  	 * this state is discarded.
>  	 */
> -	vmx->nested.mtf_pending = false;
> +	if (!block_nested_events)
> +		vmx->nested.mtf_pending = false;
>  
>  	if (lapic_in_kernel(vcpu) &&
>  		test_bit(KVM_APIC_INIT, &apic->pending_events)) {
> 

Queued, thanks.

Paolo

