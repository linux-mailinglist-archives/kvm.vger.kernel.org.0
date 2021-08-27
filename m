Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482C83F95B4
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 10:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244469AbhH0IEs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 04:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244533AbhH0IET (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 04:04:19 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44BFC061757;
        Fri, 27 Aug 2021 01:02:02 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id r13so4629961pff.7;
        Fri, 27 Aug 2021 01:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cswhnu+o8kyBBIxzcLABF5rjUJeD7g9ZDLkYCWGDY3Y=;
        b=OqohcBTPo1bx+g+Uhy5kq56l7yUOxLEugEOLnrrHFGOE9q6fl4GSY8Z1g4cy28v8/H
         /L1w4p4Sg8b+ljDLiH9Gb1+GZJmzWV6ysvxelEZyI9D8Ew3G/bqelIPClmFt9as7aEEu
         nk0NoXFPWc3E70qTNobmYIJyHjN8UsaDJ8PQd9G9IThDwB0Rbm6047rMIfrYiIaoPol8
         83YdQMipI9Ef5oiCjCXNrqRhdPiM1lKbwLomBu4t1pdAiwluLh1kv3kaFwWDZpIPSD+6
         7uC9Sledzc7uwLe6e/cdddOBkwHJ7y8MIBF8ETXjcZo+yjuo33qz1BEAi+Qpk6kRxoes
         Y0ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Cswhnu+o8kyBBIxzcLABF5rjUJeD7g9ZDLkYCWGDY3Y=;
        b=moiGwqnn0GEHcCX2sLxD47WqkWkrxuVzsSMXNFs8Vq7KdfoM9oxkBt3mGySjG+N05X
         +QJa/Eq0CFhQX5WGIwby2r9ls7hTVLO0Any3bbPkJY1c5/2tUd7ZEN+39qHWUb9Om81q
         5wCD6hX1o+/N5gJgaCCxSzz+w6Vu+oH5nHA5St7o80bqdDwFQ8WTuDLNVGAnAAsti1Cq
         gMBS97M/oBUg4Ehn/22+4OdnRIenK/WPeK11A9aOxaAmfDtamy4s8C+zSPDvbBtNXfuQ
         Zf1iOuqA4RfRsUGYJBVMqWdcV7ACeIK/QEsBXji1o28xAVm8o/31XO9cDfVrjpXVrjOF
         symw==
X-Gm-Message-State: AOAM531OeIYGv7rfe7pUmaSQuRgy+HP5io4ZddCF0cZGHWdPatDwtHRP
        ImcJsTmwmDN2ah/zw2bt2XrHbQwuopp16Mzb+Pw=
X-Google-Smtp-Source: ABdhPJz93kkIvT1VtOeM07aufGlsPC5VcsFoOF9FFZYwZ3Du0G+C1ytyrpDJPIrEyio9g37sV046Cg==
X-Received: by 2002:a05:6a00:1748:b0:3e2:ace4:82b7 with SMTP id j8-20020a056a00174800b003e2ace482b7mr7814214pfc.56.1630051322226;
        Fri, 27 Aug 2021 01:02:02 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d15sm5390883pfd.115.2021.08.27.01.01.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 01:02:01 -0700 (PDT)
Subject: Re: [PATCH 00/15] perf: KVM: Fix, optimize, and clean up callbacks
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jason Baron <jbaron@akamai.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ard Biesheuvel <ardb@kernel.org>
References: <20210827005718.585190-1-seanjc@google.com>
 <fd3dcd6c-b3d5-4453-93fb-b46d0595534e@gmail.com>
 <YSiX9OPcrDsr3P4C@hirez.programming.kicks-ass.net>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Message-ID: <3bd4955a-1219-20b0-058b-d23f1e30aa77@gmail.com>
Date:   Fri, 27 Aug 2021 16:01:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YSiX9OPcrDsr3P4C@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/8/2021 3:44 pm, Peter Zijlstra wrote:
> On Fri, Aug 27, 2021 at 02:52:25PM +0800, Like Xu wrote:
>> + STATIC BRANCH/CALL friends.
>>
>> On 27/8/2021 8:57 am, Sean Christopherson wrote:
>>> This started out as a small series[1] to fix a KVM bug related to Intel PT
>>> interrupt handling and snowballed horribly.
>>>
>>> The main problem being addressed is that the perf_guest_cbs are shared by
>>> all CPUs, can be nullified by KVM during module unload, and are not
>>> protected against concurrent access from NMI context.
>>
>> Shouldn't this be a generic issue of the static_call() usage ?
>>
>> At the beginning, we set up the static entry assuming perf_guest_cbs != NULL:
>>
>> 	if (perf_guest_cbs && perf_guest_cbs->handle_intel_pt_intr) {
>> 		static_call_update(x86_guest_handle_intel_pt_intr,
>> 				   perf_guest_cbs->handle_intel_pt_intr);
>> 	}
>>
>> and then we unset the perf_guest_cbs and do the static function call like this:
>>
>> DECLARE_STATIC_CALL(x86_guest_handle_intel_pt_intr,
>> *(perf_guest_cbs->handle_intel_pt_intr));
>> static int handle_pmi_common(struct pt_regs *regs, u64 status)
>> {
>> 		...
>> 		if (!static_call(x86_guest_handle_intel_pt_intr)())
>> 			intel_pt_interrupt();
>> 		...
>> }
> 
> You just have to make sure all static_call() invocations that started
> before unreg are finished before continuing with the unload.
> synchronize_rcu() can help with that.

Do you mean something like that:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 64e310ff4f3a..e7d310af7509 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8465,6 +8465,7 @@ void kvm_arch_exit(void)
  #endif
  	kvm_lapic_exit();
  	perf_unregister_guest_info_callbacks(&kvm_guest_cbs);
+	synchronize_rcu();

  	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
  		cpufreq_unregister_notifier(&kvmclock_cpufreq_notifier_block,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index e466fc8176e1..63ae56c5d133 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6508,6 +6508,7 @@ EXPORT_SYMBOL_GPL(perf_register_guest_info_callbacks);
  int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
  {
  	perf_guest_cbs = NULL;
+	arch_perf_update_guest_cbs();
  	return 0;
  }
  EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);

> 
> This is module unload 101. Nothing specific to static_call().
> 
