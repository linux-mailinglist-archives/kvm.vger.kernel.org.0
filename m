Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D997F92832
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 17:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfHSPSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 11:18:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52770 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726343AbfHSPSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 11:18:32 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ADFA283F45
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 15:18:31 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id k8so4286460wrx.19
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 08:18:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0/2t4hS8FqXThVER+v2A5JOFUnGhu/vf2ajPY5A6Uf4=;
        b=Wb2d8GWdgWBN4UGaPSMItR/D3h3k2YMHJXzxycLB47ZyAzCyx8ZdjNe0JphAXznhb7
         LlqVOWFOOwnT/FHCI/khigZcK+QIDfMJq90/pFzPI4w4aXQfdab5JVL80bvBf+kd7sjM
         9ScTAa5JFvGxs7OxacYP9I6XBbOWclesNxThjfons+5nVsQQqjv5vMi22JOoT3Cm25aa
         FjWkP6zsrBwTGjYpB4vdFl/xzHi4z4gFEn9slywENhIZ5dUdKrb+1eEr0N2HTxziwPNS
         uVZG9LuL1VBQn0b46gL5cUJhOfA9jFBCiP6CleaLuoKNr0d3V2zl5Qj2qPpeG87We9St
         IUcg==
X-Gm-Message-State: APjAAAUkgvDHVSOrfDF0IY62d5H8BqBo9Uv+j7NJuITqBx+Z84xC9EsK
        345YRKAJZ417F3wcL4qaOx1RadJmauMwPuhm5jRMVstxYFo2w2Yx9wRDOdsZSDwuOGRjqY33Sis
        EXXQuIsOIaIRr
X-Received: by 2002:a5d:65ca:: with SMTP id e10mr10917604wrw.267.1566227910391;
        Mon, 19 Aug 2019 08:18:30 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy2TMYfv7mIazOQe72riCVUkHV+60Qy7yTDJQyIB9kc6T5c0Kk0L1QXICVeLMbYFZlY9buLJA==
X-Received: by 2002:a5d:65ca:: with SMTP id e10mr10917573wrw.267.1566227910127;
        Mon, 19 Aug 2019 08:18:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8033:56b6:f047:ba4f? ([2001:b07:6468:f312:8033:56b6:f047:ba4f])
        by smtp.gmail.com with ESMTPSA id f197sm27675081wme.22.2019.08.19.08.18.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2019 08:18:29 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Fix x86_decode_insn() return when fetching insn
 bytes fails
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190815162032.6679-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9bf79098-703c-e82b-7e7d-1c0a6a1023c2@redhat.com>
Date:   Mon, 19 Aug 2019 17:18:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190815162032.6679-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/08/19 18:20, Sean Christopherson wrote:
> Jump to the common error handling in x86_decode_insn() if
> __do_insn_fetch_bytes() fails so that its error code is converted to the
> appropriate return type.  Although the various helpers used by
> x86_decode_insn() return X86EMUL_* values, x86_decode_insn() itself
> returns EMULATION_FAILED or EMULATION_OK.
> 
> This doesn't cause a functional issue as the sole caller,
> x86_emulate_instruction(), currently only cares about success vs.
> failure, and success is indicated by '0' for both types
> (X86EMUL_CONTINUE and EMULATION_OK).
> 
> Fixes: 285ca9e948fa ("KVM: emulate: speed up do_insn_fetch")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/emulate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 8e409ad448f9..6d2273e71020 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -5126,7 +5126,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
>  	else {
>  		rc = __do_insn_fetch_bytes(ctxt, 1);
>  		if (rc != X86EMUL_CONTINUE)
> -			return rc;
> +			goto done;
>  	}
>  
>  	switch (mode) {
> 

Queued, thanks.

Paolo
