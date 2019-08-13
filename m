Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D63648B3FD
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 11:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfHMJUv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 05:20:51 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54553 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfHMJUv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 05:20:51 -0400
Received: by mail-wm1-f65.google.com with SMTP id p74so809424wme.4
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 02:20:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5WhOyVWdh6QSPNAVErcAEqsYGeEW+/y9GXLU12kMFrw=;
        b=RBk3RV4XvsHLps3zDO4kQ/8C0nzsQ1aEMp+IntAgUripbOqjj2gPpYU9gQ+SwhMbUw
         DVF1S12ts4kXLJPiSxHFXceCki+LV+KmZFhJXS7CQYz5imHjODLRNCiRSoE6LsNRWUnR
         +UaDxfcs/tYsYZsTfh/FCQcCprkGnN/FLPwxj16bgYAJ/Zkwag/htjzeZwdg/btsqHKY
         zfB6KdpWIJ0UDDlbPhTX8gDp0kWjzhHkd0pXRmlEXjdmH4GzzQsbWmPTFP1pO6pJ/b5L
         OPere4D8opefAsFUgDn6voao1pMSTM5DTWACUEedKtolWzl/jjNjnrbVOYOkfARIgSEZ
         ciDQ==
X-Gm-Message-State: APjAAAUSrSSN/1UTiFhAVcYDqfQPvLVP/BNbUn3UmaUU3gfmGna3IXGU
        kKyT6r5S0u9xPDXdKMyjzJTHGg==
X-Google-Smtp-Source: APXvYqy7ZmTsVWHpsqOXwbw3dSaP1W5TTiLRwJljDd+oxKVerUOBaX1bmIlseQ1dv51/PnYJUN17Cw==
X-Received: by 2002:a7b:c7c4:: with SMTP id z4mr1999804wmk.13.1565688048937;
        Tue, 13 Aug 2019 02:20:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5d12:7fa9:fb2d:7edb? ([2001:b07:6468:f312:5d12:7fa9:fb2d:7edb])
        by smtp.gmail.com with ESMTPSA id z6sm18721496wre.76.2019.08.13.02.20.46
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 02:20:48 -0700 (PDT)
Subject: Re: [RFC PATCH v6 74/92] kvm: x86: do not unconditionally patch the
 hypercall instruction during emulation
To:     =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?Q?Samuel_Laur=c3=a9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Yu C Zhang <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-75-alazar@bitdefender.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <1362cc5c-d0cd-6b7c-1151-9df3996fefa9@redhat.com>
Date:   Tue, 13 Aug 2019 11:20:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809160047.8319-75-alazar@bitdefender.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/19 18:00, Adalbert Lazăr wrote:
> From: Mihai Donțu <mdontu@bitdefender.com>
> 
> It can happened for us to end up emulating the VMCALL instruction as a
> result of the handling of an EPT write fault. In this situation, the
> emulator will try to unconditionally patch the correct hypercall opcode
> bytes using emulator_write_emulated(). However, this last call uses the
> fault GPA (if available) or walks the guest page tables at RIP,
> otherwise. The trouble begins when using KVMI, when we forbid the use of
> the fault GPA and fallback to the guest pt walk: in Windows (8.1 and
> newer) the page that we try to write into is marked read-execute and as
> such emulator_write_emulated() fails and we inject a write #PF, leading
> to a guest crash.
> 
> The fix is rather simple: check the existing instruction bytes before
> doing the patching. This does not change the normal KVM behaviour, but
> does help when using KVMI as we no longer inject a write #PF.

Fixing the hypercall is just an optimization.  Can we just hush and
return to the guest if emulator_write_emulated returns
X86EMUL_PROPAGATE_FAULT?

Paolo

> CC: Joerg Roedel <joro@8bytes.org>
> Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
> Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
> ---
>  arch/x86/kvm/x86.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 04b1d2916a0a..965c4f0108eb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7363,16 +7363,33 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
>  
> +#define KVM_HYPERCALL_INSN_LEN 3
> +
>  static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
>  {
> +	int err;
>  	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
> -	char instruction[3];
> +	char buf[KVM_HYPERCALL_INSN_LEN];
> +	char instruction[KVM_HYPERCALL_INSN_LEN];
>  	unsigned long rip = kvm_rip_read(vcpu);
>  
> +	err = emulator_read_emulated(ctxt, rip, buf, sizeof(buf),
> +				     &ctxt->exception);
> +	if (err != X86EMUL_CONTINUE)
> +		return err;
> +
>  	kvm_x86_ops->patch_hypercall(vcpu, instruction);
> +	if (!memcmp(instruction, buf, sizeof(instruction)))
> +		/*
> +		 * The hypercall instruction is the correct one. Retry
> +		 * its execution maybe we got here as a result of an
> +		 * event other than #UD which has been resolved in the
> +		 * mean time.
> +		 */
> +		return X86EMUL_CONTINUE;
>  
> -	return emulator_write_emulated(ctxt, rip, instruction, 3,
> -		&ctxt->exception);
> +	return emulator_write_emulated(ctxt, rip, instruction,
> +				       sizeof(instruction), &ctxt->exception);
>  }
>  
>  static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu)
> 

