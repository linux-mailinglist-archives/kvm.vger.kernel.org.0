Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3AD8599670
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 09:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347236AbiHSHsz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 03:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347248AbiHSHso (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 03:48:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A596B2DAC
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 00:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660895320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=09vMTP9vJHiw/P02q27iNIqPqja/VvpetizcVgPzsMo=;
        b=Iyt2hBsDXCKhLVCZo56SEumIzucA5s74DvIR8pznr8aNuzuztxNi4eaZ3gkpsl6CyM5h0D
        o8hWS7AJjT+NW59h9kINYxCvF1aK7VuhnWBLUzRJbWpz349escmppoQY+iDSm26DUvf80u
        SFWXO1Pnj4xN68Jb7aQKYrUI8zEx6aQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-178-PEzCSqPfNIGqM59XFo7M-g-1; Fri, 19 Aug 2022 03:48:39 -0400
X-MC-Unique: PEzCSqPfNIGqM59XFo7M-g-1
Received: by mail-ed1-f72.google.com with SMTP id q32-20020a05640224a000b004462f105fa9so1290664eda.4
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 00:48:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=09vMTP9vJHiw/P02q27iNIqPqja/VvpetizcVgPzsMo=;
        b=kPHL9VrKoUpIbTF1oNhLghr3H48mw/tLQb/1Gv0t5kAGNqUVK7p/ahdrLXZ+89U/xT
         g5ZylaQdNrXEMlyqTdEkEVe1hc7KidRrzNq8wSv5yhGwWVt+ZvyPrbpDB48fo3iUEtAE
         VGysbraHBVu5bc8aCLXow7LSjhIhQokofCjON9O/DbS8Shy/ieNHLMy2AQpLL/ZdGblW
         nu4BOKk7FRzEMIX0CRE8vMoRrJGUYUSga6FHowMJ3jE5PI/H1yMV7riI29CYgN3y0KQW
         GDy32Wot/LYXYapOH8UgfKIFMZOKTxU7hvSWMvo7O6sORa/y50WZEmw8ndtqPxbElW+9
         IKUQ==
X-Gm-Message-State: ACgBeo2E+bucSHtwdTmvIyJeQepQ7ERsJtb7+5njxZ77mDH4Y4fD5msp
        Ks16RUfcORprIiNkMRXQ0e5b+u/jURkInRNdIPUULDrgdyjZT6lgoi+uoqQ/kBs6RSXy+vU3sTM
        TP4Od6F1oCP8g
X-Received: by 2002:a17:907:2e0b:b0:730:8aee:d674 with SMTP id ig11-20020a1709072e0b00b007308aeed674mr4197336ejc.104.1660895318300;
        Fri, 19 Aug 2022 00:48:38 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6AiRRPeV4IlrR5u7EYBCj7ZdHNSnHfKfXiJC2KfWg2Lb5NypwN0HfG80UyVo8Ikdgj70Ah8Q==
X-Received: by 2002:a17:907:2e0b:b0:730:8aee:d674 with SMTP id ig11-20020a1709072e0b00b007308aeed674mr4197316ejc.104.1660895318122;
        Fri, 19 Aug 2022 00:48:38 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id ss28-20020a170907c01c00b00730a18a8b68sm1929373ejc.130.2022.08.19.00.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 00:48:37 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 22/26] KVM: VMX: Move LOAD_IA32_PERF_GLOBAL_CTRL
 errata handling out of setup_vmcs_config()
In-Reply-To: <Yv57tmu09nOQcFrf@google.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
 <20220802160756.339464-23-vkuznets@redhat.com>
 <Yv57tmu09nOQcFrf@google.com>
Date:   Fri, 19 Aug 2022 09:48:36 +0200
Message-ID: <87wnb4smgb.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Aug 02, 2022, Vitaly Kuznetsov wrote:
>> While it seems reasonable to not expose LOAD_IA32_PERF_GLOBAL_CTRL controls
>> to L1 hypervisor on buggy CPUs, such change would inevitably break live
>> migration from older KVMs where the controls are exposed. Keep the status quo
>> for now, L1 hypervisor itself is supposed to take care of the errata.
>
> As noted before, this statement is wrong as it requires guest FMS == host FMS,
> but it's irrelevant because KVM can emulate the control unconditionally.  I'll
> test and fold in my suggested patch[*] (assuming it works) and reword this part
> of the changelog.  Ah, and I'll also need to fold in a patch to actually emulate
> the controls without hardware support.
>
> [*] https://lore.kernel.org/all/YtnZmCutdd5tpUmz@google.com

Oh, I missed the part that my changelog is actually wrong when Paolo
said "Can you send this as a separate patch", no objections to re-wording!

>
>> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/vmx/vmx.c | 59 +++++++++++++++++++++++++-----------------
>>  1 file changed, 35 insertions(+), 24 deletions(-)
>> 
>
> ...
>
>> @@ -8192,6 +8199,10 @@ static __init int hardware_setup(void)
>>  	if (setup_vmcs_config(&vmcs_config, &vmx_capability) < 0)
>>  		return -EIO;
>>  
>> +	if (cpu_has_perf_global_ctrl_bug())
>> +		pr_warn_once("kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL "
>> +			     "does not work properly. Using workaround\n");
>
> Any objections to opportunistically tweaking this?
>
> 		pr_warn_once("kvm: CPU has VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL erratum,"
> 			     "using MSR load/store lists for PERF_GLOBAL_CTRL\n");
>

Personally I'd say just 

 		pr_warn_once("kvm: CPU has VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL erratum\n");

leaving aside the workaround KVM uses. This is merely an implementation
detail which KVM users most likely don't really need. I have no strong
opinion though, feel free to adjust.

>> +
>>  	if (boot_cpu_has(X86_FEATURE_NX))
>>  		kvm_enable_efer_bits(EFER_NX);
>>  
>> -- 
>> 2.35.3
>> 
>

-- 
Vitaly

