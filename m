Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE5070D6BA
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 10:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235551AbjEWIIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 04:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235577AbjEWIIA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 04:08:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDDDE42
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 01:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684829092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+spMR7GWVCywyQ8Vss3L/nhZ/nrGXvNU+qf7VC841P0=;
        b=iKNLadwQuLvoG3ZGJzn1kjQnZdYcCuPx7DkXzUTNQPaCjKIBKMuV1jpekw9L1Xymt8OzMo
        8U6Vi4aKraZhS0mNPeynJLGyN7njTa8fBGZMCLdjMvXMkvotHxkxu32TPeSayYt4K+8We1
        VFqrlGqkkrZ+1xxYwP7UySLB/mauWe4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-423-lA9ZIT-kOXK7rtqagJ5BBQ-1; Tue, 23 May 2023 04:04:51 -0400
X-MC-Unique: lA9ZIT-kOXK7rtqagJ5BBQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f608ea691fso5695045e9.3
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 01:04:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684829090; x=1687421090;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+spMR7GWVCywyQ8Vss3L/nhZ/nrGXvNU+qf7VC841P0=;
        b=d1RWjtrubLNN5H5IcmtEkv6aa+C20qLyGjI/u7c1UW7JSFdDY4J5RLUhBUlc6ZuEmO
         FLVcyIJMrl9HKGEQIXkNoVJci8lTI7V6gzq37CpME0v/S7NcNvYnBhyqpFBYYER6g6lp
         6wOGGNBg/JEFP9l097imvuIlr61FdzyyKOGL+kEgwk6aKlomuD91Rmbpi92X/RjZuL+Z
         AlNHKHisDyT8AbNDoxhESsxno9YvxbcHNszyYPRy2fLc2l+VZX0TN2bXQcPV2jlwV+8k
         dFH6pOlFcSD53aOfSvrCJY58Bif69L7yv1/cnnq1mCBeQ0DEE7PdTiDPsmcddKYWcha5
         EIeQ==
X-Gm-Message-State: AC+VfDzpB0Qjrpx68376lgpGkbqxwUdahlerY2hAJbmldycwWeVmTw1z
        La8f5wt8QG/wRuAKswPX5E/UlmcUHeXD0rV4Kg1nt9JCNcR1FUvZFFB0daQrkSyhiOl6Px0TZFA
        4QrzGtMhTd4bC8cVlUtApNIusZWr/5XCQ0pQURtnLIuYFkR1BzXsx9QkBzPV2zSzv33+1V0Fe
X-Received: by 2002:a1c:f611:0:b0:3f4:2e13:ccdc with SMTP id w17-20020a1cf611000000b003f42e13ccdcmr9214201wmc.0.1684829089973;
        Tue, 23 May 2023 01:04:49 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7dZ+uqenjEqCbZmwJMUh612CQFPX8E4+NvP9d6E10gJlbOWWzX9LXpbLljFvjphuDg6sVdlQ==
X-Received: by 2002:a1c:f611:0:b0:3f4:2e13:ccdc with SMTP id w17-20020a1cf611000000b003f42e13ccdcmr9214164wmc.0.1684829089591;
        Tue, 23 May 2023 01:04:49 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id v7-20020a7bcb47000000b003f080b2f9f4sm14233350wmj.27.2023.05.23.01.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 01:04:49 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 1/2] x86/hyperv: Fix hyperv_pcpu_input_arg handling when
 CPUs go online/offline
In-Reply-To: <BYAPR21MB16889F38274F6F7691DB85F8D743A@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1684506832-41392-1-git-send-email-mikelley@microsoft.com>
 <87o7mczqvu.fsf@redhat.com>
 <BYAPR21MB16889F38274F6F7691DB85F8D743A@BYAPR21MB1688.namprd21.prod.outlook.com>
Date:   Tue, 23 May 2023 10:04:47 +0200
Message-ID: <87wn0zxylc.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Michael Kelley (LINUX)" <mikelley@microsoft.com> writes:

> From: Vitaly Kuznetsov <vkuznets@redhat.com> Sent: Monday, May 22, 2023 1:56 AM
>> 
>> Michael Kelley <mikelley@microsoft.com> writes:
>> 
>
> [snip]
>
>> > diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
>> > index 0f1001d..696004a 100644
>> > --- a/include/linux/cpuhotplug.h
>> > +++ b/include/linux/cpuhotplug.h
>> > @@ -201,6 +201,7 @@ enum cpuhp_state {
>> >  	/* Online section invoked on the hotplugged CPU from the hotplug thread */
>> >  	CPUHP_AP_ONLINE_IDLE,
>> >  	CPUHP_AP_KVM_ONLINE,
>> > +	CPUHP_AP_HYPERV_ONLINE,
>> 
>> (Cc: KVM)
>> 
>> I would very much prefer we swap the order with KVM here: hv_cpu_init()
>> allocates and sets vCPU's VP assist page which is used by KVM on
>> CPUHP_AP_KVM_ONLINE:
>> 
>> kvm_online_cpu() -> __hardware_enable_nolock() ->
>> kvm_arch_hardware_enable() -> vmx_hardware_enable():
>> 
>>         /*
>>          * This can happen if we hot-added a CPU but failed to allocate
>>          * VP assist page for it.
>>          */
>> 	if (kvm_is_using_evmcs() && !hv_get_vp_assist_page(cpu))
>> 		return -EFAULT;
>> 
>> With the change, this is likely broken.
>> 
>> FWIF, KVM also needs current vCPU's VP index (also set by hv_cpu_init())
>> through __kvm_x86_vendor_init() -> set_hv_tscchange_cb() call chain but
>> this happens upon KVM module load so CPU hotplug ordering should not
>> matter as this always happens on a CPU which is already online.
>> 
>> Generally, as 'KVM on Hyper-V' is a supported scenario, doing Hyper-V
>> init before KVM's (and vice versa on teardown) makes sense.
>> 
>> >  	CPUHP_AP_SCHED_WAIT_EMPTY,
>> >  	CPUHP_AP_SMPBOOT_THREADS,
>> >  	CPUHP_AP_X86_VDSO_VMA_ONLINE,
>
> I have no objection to putting CPUHP_AP_HYPERV_ONLINE first.  I did
> not give any consideration to a possible dependency between the two. :-(
> But note that in current code, hv_cpu_init() is running on the
> CPUHP_AP_ONLINE_DYN state, which is also after KVM.  So this patch
> doesn't change the order w.r.t. KVM and the VP assist page.   Are things
> already broken for KVM, or is something else happening that makes it
> work anyway?

This looks like a currently present bug indeed so I had to refresh my
memory. 

KVM's CPUHP_AP_KVM_STARTIN is registered with
cpuhp_setup_state_nocalls() which means that kvm_starting_cpu() is not
called for all currently present CPUs. Moreover, kvm_init() is called
when KVM vendor module (e.g. kvm_intel) is loaded and as KVM is normally
built as module, this happens much later than Hyper-V's
hyperv_init(). vmx_hardware_enable() is actually called from
hardware_enable_all() which happens when the first KVM VM is created.

This all changes when a CPU is hotplugged. The order CPUHP_AP_* from
cpuhp_state is respected and KVM's kvm_starting_cpu() is called _before_
Hyper-V's hv_cpu_init() even before your patch. We don't see the bug
just because Hyper-V doesn't(?) support CPU hotplug. Just sending a CPU
offline with e.g. "echo 0 > /sys/devices/system/cpu/cpuX/online" is not
the same as once allocated, VP assist page persists for all non-root
Hyper-V partitions. I don't know if KVM is supported for Hyper-V root
partitions but in case it is, we may have a problem.

Let's put CPUHP_AP_HYPERV_ONLINE before KVM's CPUHP_AP_KVM_ONLINE
explicitly so CPU hotplug scenario is handled correctly, even if current
Hyper-V versions don't support it.

-- 
Vitaly

