Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A8C4ADC36
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 16:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351433AbiBHPPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 10:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379487AbiBHPPn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 10:15:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7073DC061576
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 07:15:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644333341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EnNBR8BMLKn7/pCF7bmdB8nFhlPOJjdiOJRmbi77wXQ=;
        b=I38T+2gOpUKI97YfqgXn5bIwNs0oxpX71kJ/jJnZ/stIsMt56e7KWhOtbly0+mxMW1jOFr
        DZWZDP0gil3LVm3AEl9SPSL3Ht/hEZBrZ2hWr3ybFc9M40VYk2STNcRdxRhWWGmcnctTiT
        yKkNfN16di9LM6xunM7JQLbJr59yCIw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-i4w3sSQsOre6lDHiX3WAkg-1; Tue, 08 Feb 2022 10:15:39 -0500
X-MC-Unique: i4w3sSQsOre6lDHiX3WAkg-1
Received: by mail-ed1-f71.google.com with SMTP id u24-20020a50d518000000b0040f8cef2463so2380864edi.21
        for <kvm@vger.kernel.org>; Tue, 08 Feb 2022 07:15:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=EnNBR8BMLKn7/pCF7bmdB8nFhlPOJjdiOJRmbi77wXQ=;
        b=1luEHMge5LsMt27bkpNmZcknGc+Qe/u0M+4eM8JszBVWrQ4HyTkdEriZnvBHf5UflT
         e4B4n/Qmue0N+yLeO5rk0i7I5Bo+F8Zd9+lU/8FBEwtyqYKIXxtjOsU1gGy25f7CX3fx
         ickZHTC1uBCQ6tCMr7iV5vAPAZ6NMJE8mQ+8x+joAQa75GBkWgfyFlcu4XiuZaNYYnJy
         RzzsikO6d/Qai/enGpHYcSE1dUd30EcSKyWuzx5oBZCUb153aqo7aA2tPktVuta1Pl5L
         menjxeE9J1lJD6dZsFFJXJpK6OV6gyD8zr9BEKTAzdU9VaIiMMw5pYZS8OEXgmPjprrk
         We4w==
X-Gm-Message-State: AOAM530yAH6xYSsCaboUCJj7uZ+V/McEqOyI1giWqmdljLD8EvpybBOb
        S9R3+L9vimg9gijbT2VHGgPGH2GE8Ud2mxjF5N4/W7UKzInRV/7pqstNx8tEERiDR9p/YASmjiT
        oNIQKT03bi/sgwjboAllXaaRGQE5ho9IN9YX5wvKDMsrX39wueKwqF1oXPqSl5o7e
X-Received: by 2002:a17:906:7482:: with SMTP id e2mr1863237ejl.84.1644333338111;
        Tue, 08 Feb 2022 07:15:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxuO64214EwvHgCRCpssUCam8m0SS81q8no7W7C0nXqnuVSPRkEF0Cswyi7ShWJJie+ELL3ig==
X-Received: by 2002:a17:906:7482:: with SMTP id e2mr1863214ejl.84.1644333337789;
        Tue, 08 Feb 2022 07:15:37 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p6sm976312ejf.11.2022.02.08.07.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 07:15:37 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: warning in kvm_hv_invalidate_tsc_page due to writes to guest
 memory from VM ioctl context
In-Reply-To: <190b5932de7c61905d11c92780095a2caaefec1c.camel@redhat.com>
References: <190b5932de7c61905d11c92780095a2caaefec1c.camel@redhat.com>
Date:   Tue, 08 Feb 2022 16:15:36 +0100
Message-ID: <87ee4d9yp3.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> [102140.117649] WARNING: CPU: 10 PID: 579353 at arch/x86/kvm/../../../virt/kvm/kvm_main.c:3161 mark_page_dirty_in_slot+0x6c/0x80 [kvm]
...
> [102140.123834] Call Trace:
> [102140.123910]  <TASK>
> [102140.123976]  ? kvm_write_guest+0x114/0x120 [kvm]
> [102140.124183]  kvm_hv_invalidate_tsc_page+0x9e/0xf0 [kvm]
> [102140.124396]  kvm_arch_vm_ioctl+0xa26/0xc50 [kvm]

...

>
> This happens because kvm_hv_invalidate_tsc_page is called from kvm_vm_ioctl_set_clock
> which is a VM wide ioctl and thus doesn't have to be called with an active vCPU.
>  
> But as I see the warring states that guest memory writes must alway be done
> while a vCPU is active to allow the write to be recorded in its dirty track ring.
>  
> I _think_ it might be OK to drop this invalidation,
> and rely on the fact that kvm_hv_setup_tsc_page will update it,
> and it is called when vCPU0 processes KVM_REQ_CLOCK_UPDATE which is raised in the
> kvm_vm_ioctl_set_clock eventually.
>  
> Vitaly, any thoughts on this?
>  


TSC page (as well as SynIC pages) are supposed to be "overlay" pages
which are mapped over guest's memory but KVM doesn't do that and just
writes to guest's memory. This kind of works as Windows/Hyper-V guests
never disable these features and expecting the memory behind them to
stay intact.

Dirty tracking for active TSC page can be omited, I belive. Let me take
a look at this.

> For reference those are my HV flags:
>  
>     $cpu_flags: |
>         $cpu_flags,
>         hv_relaxed,hv_spinlocks=0x1fff,hv_vpindex,     # General HV features
>         hv_runtime,hv_time,hv-frequencies,             # Clock stuff        
>         hv_synic,hv_stimer,hv-stimer-direct,#hv-vapic, # APIC extensions
>         #hv-tlbflush,hv-ipi,                           # IPI extensions
>         hv-reenlightenment,                            # nested stuff
>  
>  
>  
> PS: unrelated question:
>  
> Vitaly, do you know why hv-evmcs needs hv-vapic?
>  
>  
> I know that they stuffed the eVMCS pointer to HV_X64_MSR_VP_ASSIST_PAGE,
>  
> But can't we set HV_APIC_ACCESS_AVAILABLE but not HV_APIC_ACCESS_RECOMMENDED
> so that guest would hopefully still know that HV assist page is available,
> but should not use it for APIC acceleration?

Yes,

"hv-vapic" enables so-called "VP Assist" page and Enlightened VMCS GPA
sits there, it is used instead of VMPTRLD (which becomes unsupported)

Take a look at the newly introduced "hv-apicv"/"hv-avic" (the same
thing) in QEMU: 

commit e1f9a8e8c90ae54387922e33e5ac4fd759747d01
Author: Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Thu Sep 2 11:35:28 2021 +0200

    i386: Implement pseudo 'hv-avic' ('hv-apicv') enlightenment

when enabled, HV_APIC_ACCESS_RECOMMENDED is not set even with "hv-vapic"
(but HV_APIC_ACCESS_AVAILABLE remains). 

-- 
Vitaly

