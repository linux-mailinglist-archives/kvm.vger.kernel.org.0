Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2AE38D32C
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 14:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfHNMdU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 08:33:20 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37616 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfHNMdU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 08:33:20 -0400
Received: by mail-wr1-f65.google.com with SMTP id z11so8994277wrt.4
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2019 05:33:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=upTbxgSaXX7vP3fRyuPdfadpq9YVtUPTVjwym3KEr4Y=;
        b=itlOS9X6cBkV061KBg3TGMJK+bOPCGnEdpnrKmCshhHbbXjHSHcA68U7g8u04qLaKU
         o0HaGDlesIOO8b23SEsrvwmDTe+APjB9s40FEtj3bRkfCpLsK80ofKo2GC3zpuXhE7Q2
         6+kfS6Jrga2JJxKfOs1pt5t3kIUOuNFjtbfldKEhfZZNYLx6bjTGfEkqeApUTAf3dXD9
         CjpTj+uCKVi7obw6vISuflwCKBUs1o7PHXjJgfFF8LkVHhMLsny6trAQntoNVaHQQl0x
         EzvivP60hcPSZwtU4+8WI9mCkEiZDGuVPzHm0rxkBwdv8ysYvtJDI83wLBUe4kuiWhj3
         DLTg==
X-Gm-Message-State: APjAAAUPYrBbdYDfzjkcY/DopUI6dPJHLQrXdXAG3+ELCel7rWYeM0Th
        m++Wr7ESpNZ6Jd5vFyd8xV91Rw==
X-Google-Smtp-Source: APXvYqz1e95Qa1i40o6nza1DKDGFvEdbi2CRAHDnxQjpMJXDtInVEHY/zM9v7riSirWigzFbE4Rhgg==
X-Received: by 2002:adf:db49:: with SMTP id f9mr5035161wrj.112.1565785997898;
        Wed, 14 Aug 2019 05:33:17 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id j10sm191268142wrd.26.2019.08.14.05.33.16
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 05:33:17 -0700 (PDT)
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
 <1362cc5c-d0cd-6b7c-1151-9df3996fefa9@redhat.com>
 <5d53f965.1c69fb81.cd952.035bSMTPIN_ADDED_BROKEN@mx.google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <50bade53-c584-504d-7c02-1238af731666@redhat.com>
Date:   Wed, 14 Aug 2019 14:33:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5d53f965.1c69fb81.cd952.035bSMTPIN_ADDED_BROKEN@mx.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/08/19 14:07, Adalbert Lazăr wrote:
> On Tue, 13 Aug 2019 11:20:45 +0200, Paolo Bonzini <pbonzini@redhat.com> wrote:
>> On 09/08/19 18:00, Adalbert Lazăr wrote:
>>> From: Mihai Donțu <mdontu@bitdefender.com>
>>>
>>> It can happened for us to end up emulating the VMCALL instruction as a
>>> result of the handling of an EPT write fault. In this situation, the
>>> emulator will try to unconditionally patch the correct hypercall opcode
>>> bytes using emulator_write_emulated(). However, this last call uses the
>>> fault GPA (if available) or walks the guest page tables at RIP,
>>> otherwise. The trouble begins when using KVMI, when we forbid the use of
>>> the fault GPA and fallback to the guest pt walk: in Windows (8.1 and
>>> newer) the page that we try to write into is marked read-execute and as
>>> such emulator_write_emulated() fails and we inject a write #PF, leading
>>> to a guest crash.
>>>
>>> The fix is rather simple: check the existing instruction bytes before
>>> doing the patching. This does not change the normal KVM behaviour, but
>>> does help when using KVMI as we no longer inject a write #PF.
>>
>> Fixing the hypercall is just an optimization.  Can we just hush and
>> return to the guest if emulator_write_emulated returns
>> X86EMUL_PROPAGATE_FAULT?
>>
>> Paolo
> 
> Something like this?
> 
> 	err = emulator_write_emulated(...);
> 	if (err == X86EMUL_PROPAGATE_FAULT)
> 		err = X86EMUL_CONTINUE;
> 	return err;

Yes.  The only difference will be that you'll keep getting #UD vmexits
instead of hypercall vmexits.  It's also safer, we want to obey those
r-x permissions because PatchGuard would crash the system if it noticed
the rewriting for whatever reason.

Paolo

>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 04b1d2916a0a..965c4f0108eb 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -7363,16 +7363,33 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>>>  }
>>>  EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
>>>  
>>> +#define KVM_HYPERCALL_INSN_LEN 3
>>> +
>>>  static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
>>>  {
>>> +	int err;
>>>  	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
>>> -	char instruction[3];
>>> +	char buf[KVM_HYPERCALL_INSN_LEN];
>>> +	char instruction[KVM_HYPERCALL_INSN_LEN];
>>>  	unsigned long rip = kvm_rip_read(vcpu);
>>>  
>>> +	err = emulator_read_emulated(ctxt, rip, buf, sizeof(buf),
>>> +				     &ctxt->exception);
>>> +	if (err != X86EMUL_CONTINUE)
>>> +		return err;
>>> +
>>>  	kvm_x86_ops->patch_hypercall(vcpu, instruction);
>>> +	if (!memcmp(instruction, buf, sizeof(instruction)))
>>> +		/*
>>> +		 * The hypercall instruction is the correct one. Retry
>>> +		 * its execution maybe we got here as a result of an
>>> +		 * event other than #UD which has been resolved in the
>>> +		 * mean time.
>>> +		 */
>>> +		return X86EMUL_CONTINUE;
>>>  
>>> -	return emulator_write_emulated(ctxt, rip, instruction, 3,
>>> -		&ctxt->exception);
>>> +	return emulator_write_emulated(ctxt, rip, instruction,
>>> +				       sizeof(instruction), &ctxt->exception);
>>>  }

