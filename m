Return-Path: <kvm+bounces-21965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87E57937CE9
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 21:20:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3EE7B2825DE
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 19:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1C61148317;
	Fri, 19 Jul 2024 19:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FzLnnHVv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BE3146D6E;
	Fri, 19 Jul 2024 19:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721416842; cv=none; b=rhf3RLNIg/siJpx2GMdteaGoymJ5fTJQuKeahQVYtjbB4MRFqNCX3rrN/X/q74yff2GLxEUlMCHkiBPVkxFXG7qjhD9w7g1siCXxeVdSTXZwIzmch4NxXWYGh/qzkxL44Y+38F+Xrt/4g/tNPU1wXOX7DzpJAV1F12msBbvfGoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721416842; c=relaxed/simple;
	bh=GnosC41aFEorTpqIQg1lkOrmngssg4UGvmMGZ/2iHCg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KgjCnXnd+gdxbC/m6/ZSCEp/5ygR1yHyMfnnGVubsU30tNT9G3nz3hdRRoaDmX7yZRKPugIk6TebsJasV0nKG66FTsPGHrVeWrC1ntp61ybEjaZoKe8FnKLrxg3PK6iHooLNBXTqqO1/HugRQAul9snfuWU3Ac89CcGPMwu7htc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FzLnnHVv; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3685a564bafso811595f8f.3;
        Fri, 19 Jul 2024 12:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721416839; x=1722021639; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kgxIwzDdawq/mE5RHsJXRJiJ+Rr6LD4njCkuzhh9Id0=;
        b=FzLnnHVvrQy39PjxFTdovoZuyedP3gCy8oqnjw4oflO9tOhLpQ7E2eS026bAHQWiJE
         EI0TqLwHIzsKIuj7oPcD1RP7T6J5PJdadX0kysb5jAygDU00JMKK1Nk4KKaxP3PkZrn9
         2K6jbUP1KijcC6jvFB0+IMvdeLo8TFF03uoY7ckaB19RK1JkKP1Jf6W8XoRw8Qe4KKCs
         NubRQemo5YYZmP8iUc2FdZkcwcoe9eUcYSG+t5qeOGODTuy0CLHtZIQX6OQLhAGghr7v
         Jui+8Q6LIOq7wl4Wqid9rx6TVo861bJtgcLhcx9LdrPF4rE0JxS2wu6ZUhfhTN+jmopP
         5Upg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721416839; x=1722021639;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kgxIwzDdawq/mE5RHsJXRJiJ+Rr6LD4njCkuzhh9Id0=;
        b=IMDdECz/kuPkLx3diI7yhTsOJkbjlf4ssdJ7gFNz+/+Pt7kT6kwH7sjD+Jkn2z6lqC
         xWz3CMI0XaQkaQqfd4FBhs+7TcpvByy4yB+vt7TdcBPQ0IY1vWqnOiranmtBo8SNeb/2
         a3btm+oYW4SRPKIv6olMuA5yb2aE93u8ewD7TC+fec4xcvezIfkcjiHZYnAf4PjEDf7A
         i9PZY/XwZ2K/7XAPrFxC2hi+ZrTBdPfnKWlAKxLcjygv7SUiOFzS3D2Mq7PQPAkpywwM
         lLIoGELns2IE/O4VNKGDc+bWCn3vPEaNZ+/t/OMKnQEi6l/iw+rnt+ou/j4ol6cBjvkM
         qfAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVb27Cg8SntGJaDFJmG/XuIakQwW30EcAdvSriMjCoNjYRCMEymXqPoDiVxjww/tICykxqmuUuxpUL+ZysJji5PS4zYomUjGK41HHNi
X-Gm-Message-State: AOJu0YzSUm2QUMv/GuxVTCb/E3Rpmh9fB+TehRfAb0Fp3kdovJ8W0aDK
	sUr3JerzZOJUB4ulS9nFtx9H8+2WfZdp+cssNPpdGvjQRiRTvxzy
X-Google-Smtp-Source: AGHT+IGXSwARzch356MOV1fjUs4D/MMW5BCKmOMFA79g+xuc19LEPF3fkMAVwBiropkV4Kq5bzzpZQ==
X-Received: by 2002:a5d:6488:0:b0:368:2f3d:ae6c with SMTP id ffacd0b85a97d-368315f2b8cmr6659082f8f.1.1721416839230;
        Fri, 19 Jul 2024 12:20:39 -0700 (PDT)
Received: from [192.168.178.20] (dh207-42-168.xnet.hr. [88.207.42.168])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-368787eced0sm2320537f8f.98.2024.07.19.12.20.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jul 2024 12:20:38 -0700 (PDT)
Message-ID: <207a5c75-b6ad-4bfb-b436-07d4a3353003@gmail.com>
Date: Fri, 19 Jul 2024 21:20:34 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?Q?Re=3A_=5BBUG=5D_arch/x86/kvm/vmx/vmx=5Fonhyperv=2Eh=3A109?=
 =?UTF-8?B?OjM2OiBlcnJvcjogZGVyZWZlcmVuY2Ugb2YgTlVMTCDigJgw4oCZ?=
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 linux-kernel@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
References: <b44227c5-5af6-4243-8ed9-2b8cdc0e5325@gmail.com>
 <Zpq2Lqd5nFnA0VO-@google.com>
Content-Language: en-US
From: Mirsad Todorovac <mtodorovac69@gmail.com>
In-Reply-To: <Zpq2Lqd5nFnA0VO-@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 7/19/24 20:53, Sean Christopherson wrote:
> On Fri, Jul 19, 2024, Mirsad Todorovac wrote:
>> Hi, all!
>>
>> Here is another potential NULL pointer dereference in kvm subsystem of linux
>> stable vanilla 6.10, as GCC 12.3.0 complains.
>>
>> (Please don't throw stuff at me, I think this is the last one for today :-)
>>
>> arch/x86/include/asm/mshyperv.h
>> -------------------------------
>>   242 static inline struct hv_vp_assist_page *hv_get_vp_assist_page(unsigned int cpu)
>>   243 {
>>   244         if (!hv_vp_assist_page)
>>   245                 return NULL;
>>   246 
>>   247         return hv_vp_assist_page[cpu];
>>   248 }
>>
>> arch/x86/kvm/vmx/vmx_onhyperv.h
>> -------------------------------
>>   102 static inline void evmcs_load(u64 phys_addr)
>>   103 {
>>   104         struct hv_vp_assist_page *vp_ap =
>>   105                 hv_get_vp_assist_page(smp_processor_id());
>>   106 
>>   107         if (current_evmcs->hv_enlightenments_control.nested_flush_hypercall)
>>   108                 vp_ap->nested_control.features.directhypercall = 1;
>>   109         vp_ap->current_nested_vmcs = phys_addr;
>>   110         vp_ap->enlighten_vmentry = 1;
>>   111 }
>>
>> Now, this one is simple:
> 
> Nope :-)
> 
>> hv_vp_assist_page(cpu) can return NULL, and in line 104 it is assigned to
>> wp_ap, which is dereferenced in lines 108, 109, and 110, which is not checked
>> against returning NULL by hv_vp_assist_page().
> 
> When enabling eVMCS, and when onlining a CPU with eVMCS enabled, KVM verifies
> that every CPU has a valid hv_vp_assist_page() and either aborts enabling eVMCS
> or rejects CPU onlining.  So very subtly, it's impossible for hv_vp_assist_page()
> to be NULL at evmcs_load().

I see, however I did not invent it, it broke my build with CONFIG_FORTIFY_SOURCE=y.

I think I warned that I have little knowledge about the KVM code.

Here is the full GCC 12.3.0 report:

------------------------------------------------------------------------------------------------------------------
In file included from arch/x86/kvm/vmx/vmx_ops.h:9,
                 from arch/x86/kvm/vmx/vmx.h:15,
                 from arch/x86/kvm/vmx/hyperv.h:7,
                 from arch/x86/kvm/vmx/nested.c:11:
arch/x86/kvm/vmx/vmx_onhyperv.h: In function ‘evmcs_load’:
arch/x86/kvm/vmx/vmx_onhyperv.h:109:36: error: dereference of NULL ‘0’ [CWE-476] [-Werror=analyzer-null-dereference]
  109 |         vp_ap->current_nested_vmcs = phys_addr;
      |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~
  ‘nested_release_vmcs12.part.0’: events 1-4
    |
    |arch/x86/kvm/vmx/nested.c:5306:20:
    | 5306 | static inline void nested_release_vmcs12(struct kvm_vcpu *vcpu)
    |      |                    ^~~~~~~~~~~~~~~~~~~~~
    |      |                    |
    |      |                    (1) entry to ‘nested_release_vmcs12.part.0’
    |......
    | 5315 |         if (enable_shadow_vmcs) {
    |      |            ~        
    |      |            |
    |      |            (2) following ‘true’ branch...
    |......
    | 5318 |                 copy_shadow_to_vmcs12(vmx);
    |      |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |                 |
    |      |                 (3) ...to here
    |      |                 (4) calling ‘copy_shadow_to_vmcs12’ from ‘nested_release_vmcs12.part.0’
    |
    +--> ‘copy_shadow_to_vmcs12’: events 5-6
           |
           | 1565 | static void copy_shadow_to_vmcs12(struct vcpu_vmx *vmx)
           |      |             ^~~~~~~~~~~~~~~~~~~~~
           |      |             |
           |      |             (5) entry to ‘copy_shadow_to_vmcs12’
           |......
           | 1573 |         if (WARN_ON(!shadow_vmcs))
           |      |            ~ 
           |      |            |
           |      |            (6) following ‘false’ branch...
           |
         ‘copy_shadow_to_vmcs12’: event 7
           |
           |./include/linux/preempt.h:214:1:
           |  214 | do { \
           |      | ^~
           |      | |
           |      | (7) ...to here
arch/x86/kvm/vmx/nested.c:1576:9: note: in expansion of macro ‘preempt_disable’
           | 1576 |         preempt_disable();
           |      |         ^~~~~~~~~~~~~~~
           |
         ‘copy_shadow_to_vmcs12’: event 8
           |
           | 1578 |         vmcs_load(shadow_vmcs);
           |      |         ^~~~~~~~~~~~~~~~~~~~~~
           |      |         |
           |      |         (8) calling ‘vmcs_load’ from ‘copy_shadow_to_vmcs12’
           |
           +--> ‘vmcs_load’: events 9-12
                  |
                  |arch/x86/kvm/vmx/vmx_ops.h:294:20:
                  |  294 | static inline void vmcs_load(struct vmcs *vmcs)
                  |      |                    ^~~~~~~~~
                  |      |                    |
                  |      |                    (9) entry to ‘vmcs_load’
                  |......
                  |  298 |         if (kvm_is_using_evmcs())
                  |      |            ~        
                  |      |            |
                  |      |            (10) following ‘true’ branch...
                  |  299 |                 return evmcs_load(phys_addr);
                  |      |                 ~~~~~~ ~~~~~~~~~~~~~~~~~~~~~
                  |      |                 |      |
                  |      |                 |      (12) calling ‘evmcs_load’ from ‘vmcs_load’
                  |      |                 (11) ...to here
                  |
                  +--> ‘evmcs_load’: event 13
                         |
                         |arch/x86/kvm/vmx/vmx_onhyperv.h:102:20:
                         |  102 | static inline void evmcs_load(u64 phys_addr)
                         |      |                    ^~~~~~~~~~
                         |      |                    |
                         |      |                    (13) entry to ‘evmcs_load’
                         |
                       ‘evmcs_load’: event 14
                         |
                         |./arch/x86/include/asm/mshyperv.h:244:12:
                         |  244 |         if (!hv_vp_assist_page)
                         |      |            ^
                         |      |            |
                         |      |            (14) following ‘true’ branch...
                         |
                       ‘evmcs_load’: events 15-18
                         |
                         |arch/x86/kvm/vmx/vmx_onhyperv.h:105:17:
                         |  105 |                 hv_get_vp_assist_page(smp_processor_id());
                         |      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                         |      |                 |
                         |      |                 (15) ...to here
                         |  106 | 
                         |  107 |         if (current_evmcs->hv_enlightenments_control.nested_flush_hypercall)
                         |      |            ~     
                         |      |            |
                         |      |            (16) following ‘false’ branch...
                         |  108 |                 vp_ap->nested_control.features.directhypercall = 1;
                         |  109 |         vp_ap->current_nested_vmcs = phys_addr;
                         |      |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                         |      |         |                          |
                         |      |         (17) ...to here            (18) dereference of NULL ‘<unknown>’
                         |
cc1: all warnings being treated as errors
-----------------------------------------------------------------------------------

GCC 12.3.0 appears unaware of this fact that evmcs_load() cannot be called with hv_vp_assist_page() == NULL.

This, for example, silences the warning and also hardens the code against the "impossible" situations:

-------------------><------------------------------------------------------------------
diff --git a/arch/x86/kvm/vmx/vmx_onhyperv.h b/arch/x86/kvm/vmx/vmx_onhyperv.h
index eb48153bfd73..8b0e3ffa7fc1 100644
--- a/arch/x86/kvm/vmx/vmx_onhyperv.h
+++ b/arch/x86/kvm/vmx/vmx_onhyperv.h
@@ -104,6 +104,11 @@ static inline void evmcs_load(u64 phys_addr)
        struct hv_vp_assist_page *vp_ap =
                hv_get_vp_assist_page(smp_processor_id());
 
+       if (!vp_ap) {
+               pr_warn("BUG: hy_get_vp_assist_page(%d) returned NULL.\n", smp_processor_id());
+               return;
+       }
+
        if (current_evmcs->hv_enlightenments_control.nested_flush_hypercall)
                vp_ap->nested_control.features.directhypercall = 1;
        vp_ap->current_nested_vmcs = phys_addr;
--

Best regards,
Mirsad Todorovac

