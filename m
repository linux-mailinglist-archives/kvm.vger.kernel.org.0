Return-Path: <kvm+bounces-25784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C577096A7D6
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 21:53:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA8E71C23B76
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 19:53:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E08718DF6F;
	Tue,  3 Sep 2024 19:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="koDdkCMs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECED1DC721
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 19:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725393171; cv=none; b=T9oG+4KXFQQoVAkUbJa4poo74DBZdn4Wvsb5eCMa9nLqnta/iGU3vPfExar6vGkeFzqx4WTWO8b+fDHGwIhcQjh1em0BG5FMp49xmkY3CvYj6TPV1NauOEBNOXjvh9Hsq4Fujp8jtmgjAtqwPNutO1Fe5m9AHGD1+FRcXfOeITU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725393171; c=relaxed/simple;
	bh=8xKZgw8HBtI3RFkDbmWK5wOroviUu7mWZf/ycI38VGQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hlor0IWo1gKtKd8MtXbjkNs7/AfHttjV7FwxeLEeJhHu/xR9T0G2T0kOi6HdIYGk2PSULDld6kp1WGpx0O+B7VHSaX2ORnka2kDHfiBWKA3WGaVXR4XoEw/IBlH+mAkpZYagGojZekxk0jmPMQUcEztEUMD0fbz0kqu0H3owZCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=koDdkCMs; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6d4629210f2so74819887b3.1
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 12:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725393169; x=1725997969; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fI+madg2F5jxzMgESVkIyHR0MmAEDyO6S+oxlQFxTfw=;
        b=koDdkCMs9iVA+7uGqhCchh8C2CQL+DiVbjU2CnpAbyQJeiwo0UR0zPqn0AXuw3/NUI
         MXVopW0GPrqDFCFhNDDx3z6gqXtZ7LhtTZ9YGnSrXj55A/T8f6bIxirep9O/8dQ+dzOt
         +T6vQMtgX4U1ooeNJDbkqny1SwXEfqvIIAzO1vrxtZsDMbarbIcYQkvjuRBd+OXpgc+J
         bbpZ8BTbBPThtNjhvhqxyVID+ptFd+opU7Yg1FAexDNfy4CTSwL0M086H2lGr0b1X4cM
         e5jZOmY24x53TCpbE9nv+rbMnSy5MkWjKIXsjoX/Bpn0jIEyho9si96Oaacbmvk7Xgul
         jo5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725393169; x=1725997969;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fI+madg2F5jxzMgESVkIyHR0MmAEDyO6S+oxlQFxTfw=;
        b=C6+kl8GH1RyjDyTYBkBcX6YxuREMg94Mbnm9d951iKGw7GP1bgGipgOTHNUfSIVRn6
         1tIzKiSLTJAIND2X7YdGlyec2LEx2m5jLJVYHnfu0wW+t/LEcZiuXDNrJSlKYUyIhLGg
         E6d/Mou0cZQKGAOdrfythtGTfWQzNN+1uCShrXouJJJwT5KvnQm/GgOq6JYpVBMi/hLZ
         GU+5Kux3qEe+34GOPFnsZjX28Bg96DrWwc+tQGmpUkvflR/JrddTlTi4n4VYbxMqyvye
         qwcciSSv7IK+njFVMGlyEk/tIwroAXWMCPltMndkFHJfPiwGFvgdcuZAROZBPhGQDITg
         YA8g==
X-Forwarded-Encrypted: i=1; AJvYcCVzCXj/FDK9iM/J8zxwZkVVfKN57DY/BLa4LLjAw1gkL1uouMA2AJBQADy6uI/S7Yd5XvQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLkmRvwW3CSaWok9hjcGGdw1Q2pWilaJFB9FiLxE64O4ExBRnQ
	XoU9h8F6JCC+ZEZCUtNWgzS9bQCZqOd+3E5dtXba/PAvUxc7JKtMf6TJRE897whbgRARjYwoQS5
	twQ==
X-Google-Smtp-Source: AGHT+IGznZGpOHs537cn7xrwAtS55FBRH/lk1IunDfes8pLlRqXE4lN176lmA/xwEcC4P3q0jU1X7lR2lZU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:281:b0:69a:536:afd3 with SMTP id
 00721157ae682-6d4108c6606mr11831257b3.5.1725393168864; Tue, 03 Sep 2024
 12:52:48 -0700 (PDT)
Date: Tue, 3 Sep 2024 12:52:47 -0700
In-Reply-To: <20240903191033.28365-1-Ashish.Kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240903191033.28365-1-Ashish.Kalra@amd.com>
Message-ID: <ZtdpDwT8S_llR9Zn@google.com>
Subject: Re: [PATCH v2] x86/sev: Fix host kdump support for SNP
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: pbonzini@redhat.com, dave.hansen@linux.intel.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com, 
	peterz@infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	thomas.lendacky@amd.com, michael.roth@amd.com, kexec@lists.infradead.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 03, 2024, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> [    1.671804] AMD-Vi: Using global IVHD EFR:0x841f77e022094ace, EFR2:0x0
> [    1.679835] AMD-Vi: Translation is already enabled - trying to copy translation structures
> [    1.689363] AMD-Vi: Copied DEV table from previous kernel.
> [    1.864369] AMD-Vi: Completion-Wait loop timed out
> [    2.038289] AMD-Vi: Completion-Wait loop timed out
> [    2.212215] AMD-Vi: Completion-Wait loop timed out
> [    2.386141] AMD-Vi: Completion-Wait loop timed out
> [    2.560068] AMD-Vi: Completion-Wait loop timed out
> [    2.733997] AMD-Vi: Completion-Wait loop timed out
> [    2.907927] AMD-Vi: Completion-Wait loop timed out
> [    3.081855] AMD-Vi: Completion-Wait loop timed out
> [    3.225500] AMD-Vi: Completion-Wait loop timed out
> [    3.231083] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> d out
> [    3.579592] AMD-Vi: Completion-Wait loop timed out
> [    3.753164] AMD-Vi: Completion-Wait loop timed out
> [    3.815762] Kernel panic - not syncing: timer doesn't work through Interrupt-remapped IO-APIC
> [    3.825347] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.11.0-rc3-next-20240813-snp-host-f2a41ff576cc-dirty #61
> [    3.837188] Hardware name: AMD Corporation ETHANOL_X/ETHANOL_X, BIOS RXM100AB 10/17/2022
> [    3.846215] Call Trace:
> [    3.848939]  <TASK>
> [    3.851277]  dump_stack_lvl+0x2b/0x90
> [    3.855354]  dump_stack+0x14/0x20
> [    3.859050]  panic+0x3b9/0x400
> [    3.862454]  panic_if_irq_remap+0x21/0x30
> [    3.866925]  setup_IO_APIC+0x8aa/0xa50
> [    3.871106]  ? __pfx_amd_iommu_enable_faulting+0x10/0x10
> [    3.877032]  ? __cpuhp_setup_state+0x5e/0xd0
> [    3.881793]  apic_intr_mode_init+0x6a/0xf0
> [    3.886360]  x86_late_time_init+0x28/0x40
> [    3.890832]  start_kernel+0x6a8/0xb50
> [    3.894914]  x86_64_start_reservations+0x1c/0x30
> [    3.900064]  x86_64_start_kernel+0xbf/0x110
> [    3.904729]  ? setup_ghcb+0x12/0x130
> [    3.908716]  common_startup_64+0x13e/0x141
> [    3.913283]  </TASK>
> [    3.915715] in panic
> [    3.918149] in panic_other_cpus_shutdown
> [    3.922523] ---[ end Kernel panic - not syncing: timer doesn't work through Interrupt-remapped IO-APIC ]---
> 
> This happens as SNP_SHUTDOWN_EX fails

Exactly what happens?  I.e. why does the PSP (sorry, ASP) need to be full shutdown
in order to get a kdump?  The changelogs for the original SNP panic/kdump support
are frustratingly unhelpful.  They all describe what the patch does, but say
nothing about _why_.

> when SNP VMs are active as the firmware checks every encryption-capable ASID
> to verify that it is not in use by a guest and a DF_FLUSH is not required. If
> a DF_FLUSH is required, the firmware returns DFFLUSH_REQUIRED.
> 
> To fix this, added support to do SNP_DECOMMISSION of all active SNP VMs
> in the panic notifier before doing SNP_SHUTDOWN_EX, but then
> SNP_DECOMMISSION tags all CPUs on which guest has been activated to do
> a WBINVD. This causes SNP_DF_FLUSH command failure with the following
> flow: SNP_DECOMMISSION -> SNP_SHUTDOWN_EX -> SNP_DF_FLUSH ->
> failure with WBINVD_REQUIRED.
> 
> When panic notifier is invoked all other CPUs have already been
> shutdown, so it is not possible to do a wbinvd_on_all_cpus() after
> SNP_DECOMMISSION has been executed. This eventually causes SNP_SHUTDOWN_EX
> to fail after SNP_DECOMMISSION.
> 
> Adding fix to do SNP_DECOMMISSION and subsequent WBINVD on all CPUs
> during NMI shutdown of CPUs as part of disabling virtualization on
> all CPUs via cpu_emergency_disable_virtualization ->
> svm_emergency_disable().
> 
> SNP_DECOMMISSION unbinds the ASID from SNP context and marks the ASID
> as unusable and then transitions the SNP guest context page to a
> firmware page and SNP_SHUTDOWN_EX transitions all pages associated
> with the IOMMU to reclaim state which the hypervisor then transitions
> to hypervisor state, all these page state changes are in the RMP
> table, so there is no loss of guest data as such and the complete
> host memory is captured with the crashkernel boot. There are no
> processes which are being killed and host/guest memory is not
> being altered or modified in any way.
> 
> This fixes and enables crashkernel/kdump on SNP host.

...

> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 714c517dd4b7..30f286a3afb0 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -16,6 +16,7 @@
>  #include <linux/psp-sev.h>
>  #include <linux/pagemap.h>
>  #include <linux/swap.h>
> +#include <linux/delay.h>
>  #include <linux/misc_cgroup.h>
>  #include <linux/processor.h>
>  #include <linux/trace_events.h>
> @@ -89,6 +90,8 @@ static unsigned int nr_asids;
>  static unsigned long *sev_asid_bitmap;
>  static unsigned long *sev_reclaim_asid_bitmap;
>  
> +static DEFINE_SPINLOCK(snp_decommission_lock);
> +static void **snp_asid_to_gctx_pages_map;
>  static int snp_decommission_context(struct kvm *kvm);
>  
>  struct enc_region {
> @@ -2248,6 +2251,9 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  		goto e_free_context;
>  	}
>  
> +	if (snp_asid_to_gctx_pages_map)
> +		snp_asid_to_gctx_pages_map[sev_get_asid(kvm)] = sev->snp_context;
> +
>  	return 0;
>  
>  e_free_context:
> @@ -2884,9 +2890,126 @@ static int snp_decommission_context(struct kvm *kvm)
>  	snp_free_firmware_page(sev->snp_context);
>  	sev->snp_context = NULL;
>  
> +	if (snp_asid_to_gctx_pages_map)
> +		snp_asid_to_gctx_pages_map[sev_get_asid(kvm)] = NULL;
> +
>  	return 0;
>  }
>  
> +static void __snp_decommission_all(void)
> +{
> +	struct sev_data_snp_addr data = {};
> +	int ret, asid;
> +
> +	if (!snp_asid_to_gctx_pages_map)
> +		return;
> +
> +	for (asid = 1; asid < min_sev_asid; asid++) {
> +		if (snp_asid_to_gctx_pages_map[asid]) {
> +			data.address = __sme_pa(snp_asid_to_gctx_pages_map[asid]);

NULL pointer deref if this races with snp_decommission_context() from task
context.

> +			ret = sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, &data, NULL);
> +			if (!ret) {

And what happens if SEV_CMD_SNP_DECOMMISSION fails?

> +				snp_free_firmware_page(snp_asid_to_gctx_pages_map[asid]);
> +				snp_asid_to_gctx_pages_map[asid] = NULL;
> +			}
> +		}
> +	}
> +}
> +
> +/*
> + * NOTE: called in NMI context from svm_emergency_disable().
> + */
> +void sev_emergency_disable(void)
> +{
> +	static atomic_t waiting_for_cpus_synchronized;
> +	static bool synchronize_cpus_initiated;
> +	static bool snp_decommission_handled;
> +	static atomic_t cpus_synchronized;
> +
> +	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> +		return;
> +
> +	/*
> +	 * SNP_SHUTDOWN_EX fails when SNP VMs are active as the firmware checks

Define "active".

> +	 * every encryption-capable ASID to verify that it is not in use by a
> +	 * guest and a DF_FLUSH is not required. If a DF_FLUSH is required,
> +	 * the firmware returns DFFLUSH_REQUIRED. To address this, SNP_DECOMMISSION
> +	 * is required to shutdown all active SNP VMs, but SNP_DECOMMISSION tags all
> +	 * CPUs that guest was activated on to do a WBINVD. When panic notifier
> +	 * is invoked all other CPUs have already been shutdown, so it is not
> +	 * possible to do a wbinvd_on_all_cpus() after SNP_DECOMMISSION has been
> +	 * executed. This eventually causes SNP_SHUTDOWN_EX to fail after
> +	 * SNP_DECOMMISSION. To fix this, do SNP_DECOMMISSION and subsequent WBINVD
> +	 * on all CPUs during NMI shutdown of CPUs as part of disabling
> +	 * virtualization on all CPUs via cpu_emergency_disable_virtualization().
> +	 */
> +
> +	spin_lock(&snp_decommission_lock);
> +
> +	/*
> +	 * exit early for call from native_machine_crash_shutdown()
> +	 * as SNP_DECOMMISSION has already been done as part of
> +	 * NMI shutdown of the CPUs.
> +	 */
> +	if (snp_decommission_handled) {
> +		spin_unlock(&snp_decommission_lock);
> +		return;
> +	}
> +
> +	/*
> +	 * Synchronize all CPUs handling NMI before issuing
> +	 * SNP_DECOMMISSION.
> +	 */
> +	if (!synchronize_cpus_initiated) {
> +		/*
> +		 * one CPU handling panic, the other CPU is initiator for
> +		 * CPU synchronization.
> +		 */
> +		atomic_set(&waiting_for_cpus_synchronized, num_online_cpus() - 2);

And what happens when num_online_cpus() == 1?

> +		synchronize_cpus_initiated = true;
> +		/*
> +		 * Ensure CPU synchronization parameters are setup before dropping
> +		 * the lock to let other CPUs continue to reach synchronization.
> +		 */
> +		wmb();
> +
> +		spin_unlock(&snp_decommission_lock);
> +
> +		/*
> +		 * This will not cause system to hang forever as the CPU
> +		 * handling panic waits for maximum one second for
> +		 * other CPUs to stop in nmi_shootdown_cpus().
> +		 */
> +		while (atomic_read(&waiting_for_cpus_synchronized) > 0)
> +		       mdelay(1);
> +
> +		/* Reacquire the lock once CPUs are synchronized */
> +		spin_lock(&snp_decommission_lock);
> +
> +		atomic_set(&cpus_synchronized, 1);
> +	} else {
> +		atomic_dec(&waiting_for_cpus_synchronized);
> +		/*
> +		 * drop the lock to let other CPUs contiune to reach
> +		 * synchronization.
> +		 */
> +		spin_unlock(&snp_decommission_lock);
> +
> +		while (atomic_read(&cpus_synchronized) == 0)
> +		       mdelay(1);
> +
> +		/* Try to re-acquire lock after CPUs are synchronized */
> +		spin_lock(&snp_decommission_lock);
> +	}

Yeah, no.  This is horrific.  If the panic path doesn't provide the necessary
infrastructure to ensure the necessary ordering between the initiating CPU and
responding CPUs, then rework the panic path.

