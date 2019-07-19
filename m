Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 148956E8E1
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 18:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbfGSQiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 12:38:23 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54298 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727577AbfGSQiX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 12:38:23 -0400
Received: by mail-wm1-f66.google.com with SMTP id p74so29377894wme.4
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2019 09:38:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sHsoR04A7qdshEHPxgnz08hA+eCZkBIwmivbqOSS+nA=;
        b=GkFjxg80C/fovs735CdhxNNQDY5VW0sp7WIL8IJ9eq/1i6vNBFilgCeDFNy+fMl1mB
         6Z6vwQdKxDGMyiuM0SIaeEOUGgLVBjQN2yaxVgwnetUOFhk2w1jZU8wRbIDAKXQs/VNG
         4lzQ3cT76b6AfOIDMm2zmUgXWJ3nSZp15x7rCJTQMlXc11lZE63/kAFYN/ht8Lkh6EZa
         /CcW+LnnguClFz/eNvgizMxXKZtASCVFq2IdCSUWA9OEMhMzNK4shwr9DiRHSDBMGGe4
         QgeJyZdFWEAlcdTeOxH3nrH9ePbMCtEBetsvq2I7c75uv+pdrS6DxMk9tpOMVg313J35
         uAqw==
X-Gm-Message-State: APjAAAWGrDplxnVnLqlgZgXhu5nfzAPQ5THBnRlHnpe4IR8cVqgKXB6K
        KfeOk/iyL3rhor2i9Z4xe63P82vNubk=
X-Google-Smtp-Source: APXvYqxzq6uSQtqohFSn+vBJZKmiHy6EamrRjqBNPwgLSukubRRWMLlGVIRbpBMV/VejWI459JLTag==
X-Received: by 2002:a05:600c:212:: with SMTP id 18mr63388wmi.88.1563554300580;
        Fri, 19 Jul 2019 09:38:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8501:6b03:f18c:74f8? ([2001:b07:6468:f312:8501:6b03:f18c:74f8])
        by smtp.gmail.com with ESMTPSA id y6sm36480298wmd.16.2019.07.19.09.38.19
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 09:38:19 -0700 (PDT)
Subject: Re: KVM_SET_NESTED_STATE not yet stable
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        "jmattson@google.com" <jmattson@google.com>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <9eb4dd9f-65e5-627d-b288-e5fe8ade0963@siemens.com>
 <1562772280.18613.25.camel@amazon.de>
 <f1936ed9-e41b-4d36-50bb-3956434d993c@siemens.com>
 <cfd86643-dbac-3a69-9faf-03eaa8aee6a1@siemens.com>
 <47e8c75d-f39a-89f8-940f-d05a9bc91899@oth-regensburg.de>
 <e81b5c46-1700-33d2-4db7-a887e339d4ac@redhat.com>
Message-ID: <68880241-ff91-1cb1-1bd5-ab5d2e307bec@redhat.com>
Date:   Fri, 19 Jul 2019 18:38:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <e81b5c46-1700-33d2-4db7-a887e339d4ac@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/07/19 19:30, Paolo Bonzini wrote:
> On 11/07/19 13:37, Ralf Ramsauer wrote:
>> I can reproduce and confirm this issue. A system_reset of qemu after
>> Jailhouse is enabled leads to the crash listed below, on all machines.
>>
>> On the Xeon Gold, e.g., Qemu reports:
>>
>> EAX=00000000 EBX=00000000 ECX=00000000 EDX=00000f61
>> ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
>> EIP=0000fff0 EFL=00000246 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
>> ES =0000 00000000 0000ffff 00009300
>> CS =f000 ffff0000 0000ffff 00a09b00
>> SS =0000 00000000 0000ffff 00c09300
>> DS =0000 00000000 0000ffff 00009300
>> FS =0000 00000000 0000ffff 00009300
>> GS =0000 00000000 0000ffff 00009300
>> LDT=0000 00000000 0000ffff 00008200
>> TR =0000 00000000 0000ffff 00008b00
>> GDT=     00000000 0000ffff
>> IDT=     00000000 0000ffff
>> CR0=60000010 CR2=00000000 CR3=00000000 CR4=00000680
>> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000
>> DR3=0000000000000000
>> DR6=00000000ffff0ff0 DR7=0000000000000400
>> EFER=0000000000000000
>> Code=00 66 89 d8 66 e8 af a1 ff ff 66 83 c4 0c 66 5b 66 5e 66 c3 <ea> 5b
>> e0 00 f0 30 36 2f 32 33 2f 39 39 00 fc 00 00 00 00 00 00 00 00 00 00 00
>> 00 00 00 00
>>
>> Kernel:
>> [ 1868.804515] kvm: vmptrld           (null)/6b8640000000 failed
>> [ 1868.804568] kvm: vmclear fail:           (null)/6b8640000000
>>
>> And the host freezes unrecoverably. Hosts use standard distro kernels
> 
> Thanks.  I'm going to look at it tomorrow.

Ok, it was only tomorrow modulo 7, but the first fix I got is trivial:

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6e88f459b323..6119b30347c6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -194,6 +194,7 @@ static void vmx_disable_shadow_vmcs(struct vcpu_vmx *vmx)
 {
 	secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_SHADOW_VMCS);
 	vmcs_write64(VMCS_LINK_POINTER, -1ull);
+	vmx->nested.need_vmcs12_to_shadow_sync = false;
 }
 
 static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)

Can you try it and see what you get?

Paolo

