Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1A51C6DED
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 12:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbgEFKDy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 06:03:54 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21003 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728306AbgEFKDy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 06:03:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588759433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QiIEZVwe7SG+6Nxq2tgonbDJOE30ulty5p7C5cusMJU=;
        b=bj+jX9ddjfDsCzMV9KcJHaTHvrXeJkeUyCHwl5M8M3kKX4jQ19LFW4SLgyGiSGfgwZJ6yU
        qlM/dv2TULepNz1u1oMktlfnx7OtI96OoR3NweK++WsZceU6U2+SQ6OCs09cJEbM+9C4gM
        zvk/JVn2MgGRq2o+WxqHrdk3jl6ijL4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-IB6WSJg2NMGTREWgFHRhiw-1; Wed, 06 May 2020 06:03:49 -0400
X-MC-Unique: IB6WSJg2NMGTREWgFHRhiw-1
Received: by mail-wm1-f71.google.com with SMTP id f81so531333wmf.2
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 03:03:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QiIEZVwe7SG+6Nxq2tgonbDJOE30ulty5p7C5cusMJU=;
        b=InrpBWDXpJ2BhaGmb3lfqtIPaUOOcWuR4l3lx3Ha3vy+l1dDhrpcaknq8u0coqk5UM
         hh324quVC45aud3kIcXmWlbK+5jqV4FLXsEgWDd3Cwj/Ku4rRbIblaHE5DPuiXoTeD8Y
         XMbcg74lUXpmDfgx8w5H3klFI0+YfxDmxsWGKD3B4CY0zfA7KTYImFp28G/A2es1qrwV
         s4A2SjWd2OUMEHXWPhtJTEYnuwTKErzwk3hjhwpR3PIO2qe58Oi3D6XwJEXh3EzKVuk+
         c6YTkuaUXy1nU1VimSaRdDUKff/wzdHGUaSnryRDIIwCuWn9fN5hSsIOxuY35gcNiBmd
         Rr2A==
X-Gm-Message-State: AGi0PuZh6jqZFvDMPU8uT2CYN3u91gCRSNtng91fQQCkRjyRYXC8bK6n
        u9jCndh7t9efNw3GI89sB7UbI9vPAI5ctZYzrsEx9XCQ5Zhv3Zkmt/MTC45dKKP/fB32hkxw1Dr
        v9L9bTFS7u9LC
X-Received: by 2002:a1c:e284:: with SMTP id z126mr3721715wmg.32.1588759427845;
        Wed, 06 May 2020 03:03:47 -0700 (PDT)
X-Google-Smtp-Source: APiQypKA2Cf0okwuIaFAnbBfYxArho8JGedgvkjxALaNhmtcMcYyVgk5oUJVs5LcIZ75gvpZF67HhA==
X-Received: by 2002:a1c:e284:: with SMTP id z126mr3721677wmg.32.1588759427527;
        Wed, 06 May 2020 03:03:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:11d7:2f21:f38b:17e? ([2001:b07:6468:f312:11d7:2f21:f38b:17e])
        by smtp.gmail.com with ESMTPSA id d27sm2027867wra.30.2020.05.06.03.03.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 03:03:46 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: Explicitly clear RFLAGS.CF and RFLAGS.ZF in
 VM-Exit RSB path
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
References: <20200506035355.2242-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1f906b20-4806-4de0-fa99-9e7607464eb0@redhat.com>
Date:   Wed, 6 May 2020 12:03:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200506035355.2242-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/05/20 05:53, Sean Christopherson wrote:
> Clear CF and ZF in the VM-Exit path after doing __FILL_RETURN_BUFFER so
> that KVM doesn't interpret clobbered RFLAGS as a VM-Fail.  Filling the
> RSB has always clobbered RFLAGS, its current incarnation just happens
> clear CF and ZF in the processs.  Relying on the macro to clear CF and
> ZF is extremely fragile, e.g. commit 089dd8e53126e ("x86/speculation:
> Change FILL_RETURN_BUFFER to work with objtool") tweaks the loop such
> that the ZF flag is always set.
> 
> Reported-by: Qian Cai <cai@lca.pw>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: stable@vger.kernel.org
> Fixes: f2fde6a5bcfcf ("KVM: VMX: Move RSB stuffing to before the first RET after VM-Exit")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmenter.S | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index 87f3f24fef37b..51d1a82742fd5 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -82,6 +82,9 @@ SYM_FUNC_START(vmx_vmexit)
>  	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
>  	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
>  
> +	/* Clear RFLAGS.CF and RFLAGS.ZF to preserve VM-Exit, i.e. !VM-Fail. */
> +	or $1, %_ASM_AX
> +
>  	pop %_ASM_AX
>  .Lvmexit_skip_rsb:
>  #endif
> 

Queued, thanks (for 5.7 so that it will never be broken in Linus's tree).

Paolo

