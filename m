Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9445EBB5C
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 01:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbfKAAJz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Oct 2019 20:09:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45766 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728259AbfKAAJz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Oct 2019 20:09:55 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6C36883F3B
        for <kvm@vger.kernel.org>; Fri,  1 Nov 2019 00:09:54 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id 7so4562590wrl.2
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2019 17:09:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=njCRr17XQP3xqLSejqA7yoAHrQexEV3Lj6Vhe33PwmQ=;
        b=P+w6FG+U2JEtfhpyCRjAyR/lCf+zazi48dQW2+eZDIoGLv+jIhFvnkWFsq872l7jyA
         nR3zh6IYiPYvDyGhHP4Y4INAcLkb1Q5pbCYQwaZg/gB/U2gTb1RyCgFLAnyzbdPehUCC
         u4+FTsLAH7O22SEbeeH3r8ZS6J0jfwHa2ypPbfQEL6xRnRRrvRl5GG3SPe8Y/bJ6KNPM
         DzafwK+6QK5kKV9hWqw5zb8Jaoib/f8Lm6i3PinPNc2/eZTxb6cXsvPQAVwbC6L3rok3
         3fwAzii/iV/lwQBMDtgCT87Hlkd2adySHkDyQ+LZYglHCOxLIvwwomtE44L6gZBgwLI/
         1wtA==
X-Gm-Message-State: APjAAAWt73kwp9+/ZGvVjbdMa1BuYg7s6hMIRV7Rh2FXtrIFub3D/dDM
        LrARkwi2wVtFoVrjKvT1LhtLqkUVDwZQvZP341UdZGd0Df9w4HWuRHpaX6AvdOtflq0cheUO08A
        GWA4T3+vlh8nS
X-Received: by 2002:adf:fec7:: with SMTP id q7mr8347119wrs.267.1572566992945;
        Thu, 31 Oct 2019 17:09:52 -0700 (PDT)
X-Google-Smtp-Source: APXvYqydWPKAHOa99miFE6BdKNJLqX9iX2d0pWZ7e+qTZEdSgkjQr0mJXQy2Ekqis9UNykM6HWv4bQ==
X-Received: by 2002:adf:fec7:: with SMTP id q7mr8347105wrs.267.1572566992636;
        Thu, 31 Oct 2019 17:09:52 -0700 (PDT)
Received: from [192.168.20.72] (94.222.26.109.rev.sfr.net. [109.26.222.94])
        by smtp.gmail.com with ESMTPSA id i3sm5893330wrw.69.2019.10.31.17.09.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2019 17:09:51 -0700 (PDT)
Subject: Re: KVM: x86: switch KVMCLOCK base to monotonic raw clock
To:     Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
References: <20191028143619.GA14370@amt.cnet>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <08c9fce5-90ef-222d-ed86-e337f912b4a8@redhat.com>
Date:   Fri, 1 Nov 2019 01:09:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191028143619.GA14370@amt.cnet>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/10/19 15:36, Marcelo Tosatti wrote:
> 
> Commit 0bc48bea36d1 ("KVM: x86: update master clock before computing
> kvmclock_offset")
> switches the order of operations to avoid the conversion 
> 
> TSC (without frequency correction) ->
> system_timestamp (with frequency correction), 
> 
> which might cause a time jump.
> 
> However, it leaves any other masterclock update unsafe, which includes, 
> at the moment:
> 
>         * HV_X64_MSR_REFERENCE_TSC MSR write.
>         * TSC writes.
>         * Host suspend/resume.
> 
> Avoid the time jump issue by using frequency uncorrected
> CLOCK_MONOTONIC_RAW clock. 
> 
> Its the guests time keeping software responsability
> to track and correct a reference clock such as UTC.
> 
> This fixes forward time jump (which can result in 
> failure to bring up a vCPU) during vCPU hotplug:
> 
> Oct 11 14:48:33 storage kernel: CPU2 has been hot-added
> Oct 11 14:48:34 storage kernel: CPU3 has been hot-added
> Oct 11 14:49:22 storage kernel: smpboot: Booting Node 0 Processor 2 APIC 0x2          <-- time jump of almost 1 minute
> Oct 11 14:49:22 storage kernel: smpboot: do_boot_cpu failed(-1) to wakeup CPU#2
> Oct 11 14:49:23 storage kernel: smpboot: Booting Node 0 Processor 3 APIC 0x3
> Oct 11 14:49:23 storage kernel: kvm-clock: cpu 3, msr 0:7ff640c1, secondary cpu clock
> 
> Which happens because:
> 
>                 /*                                                               
>                  * Wait 10s total for a response from AP                         
>                  */                                                              
>                 boot_error = -1;                                                 
>                 timeout = jiffies + 10*HZ;                                       
>                 while (time_before(jiffies, timeout)) { 
>                          ...
>                 }
> 
> Analyzed-by: Igor Mammedov <imammedo@redhat.com>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 661e2bf..ff713a1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1521,20 +1521,25 @@ static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
>  }
>  
>  #ifdef CONFIG_X86_64
> +struct pvclock_clock {
> +	int vclock_mode;
> +	u64 cycle_last;
> +	u64 mask;
> +	u32 mult;
> +	u32 shift;
> +};
> +
>  struct pvclock_gtod_data {
>  	seqcount_t	seq;
>  
> -	struct { /* extract of a clocksource struct */
> -		int vclock_mode;
> -		u64	cycle_last;
> -		u64	mask;
> -		u32	mult;
> -		u32	shift;
> -	} clock;
> +	struct pvclock_clock clock; /* extract of a clocksource struct */
> +	struct pvclock_clock raw_clock; /* extract of a clocksource struct */
>  
> +	u64		boot_ns_raw;
>  	u64		boot_ns;
>  	u64		nsec_base;
>  	u64		wall_time_sec;
> +	u64		monotonic_raw_nsec;
>  };
>  
>  static struct pvclock_gtod_data pvclock_gtod_data;
> @@ -1542,10 +1547,20 @@ struct pvclock_gtod_data {
>  static void update_pvclock_gtod(struct timekeeper *tk)
>  {
>  	struct pvclock_gtod_data *vdata = &pvclock_gtod_data;
> -	u64 boot_ns;
> +	u64 boot_ns, boot_ns_raw;
>  
>  	boot_ns = ktime_to_ns(ktime_add(tk->tkr_mono.base, tk->offs_boot));
>  
> +	/*
> +	 * FIXME: tk->offs_boot should be converted to CLOCK_MONOTONIC_RAW
> +	 * interval (that is, without frequency adjustment for that interval).
> +	 *
> +	 * Lack of this fix can cause system_timestamp to not be equal to
> +	 * CLOCK_MONOTONIC_RAW (which happen if the host uses
> +	 * suspend/resume).
> +	 */

This is scary.  Essentially you're saying that you'd want a
CLOCK_BOOTTIME_RAW.  But is this true?  CLOCK_BOOTTIME only differs by
the suspend time, and that is computed directly in nanoseconds so the
different frequency of CLOCK_MONOTONIC and CLOCK_MONOTONIC_RAW does not
affect it.

Thanks,

Paolo

Paolo
