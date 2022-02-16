Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 881384B8621
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 11:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiBPKs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 05:48:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiBPKs0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 05:48:26 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 49C30C51
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 02:48:14 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0B1ECD6E;
        Wed, 16 Feb 2022 02:48:14 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 951D93F66F;
        Wed, 16 Feb 2022 02:48:12 -0800 (PST)
Date:   Wed, 16 Feb 2022 10:48:35 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Subject: Re: [PATCH kvmtool 2/2] kvm tools: avoid printing [Firmware Bug]:
 CPUx: APIC id mismatch. Firmware: x APIC: x
Message-ID: <YgzWg2rY859qq4wh@monolith.localdoman>
References: <20220216043834.39938-1-songmuchun@bytedance.com>
 <20220216043834.39938-2-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216043834.39938-2-songmuchun@bytedance.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Would you mind rewording the commit subject to:

x86: Set the correct APIC ID

On Wed, Feb 16, 2022 at 12:38:34PM +0800, Muchun Song wrote:
> When I boot kernel, the dmesg will print the following message:
  ^^^^^^^^^^^^^^^^^^

Would you mind replacing that with "When kvmtool boots a kernel, [..]"?

> 
>   [Firmware Bug]: CPU1: APIC id mismatch. Firmware: 1 APIC: 30
> 
> Fix this by setting up correct initial_apicid to cpu_id.

Thank you for fixing this. I've always wanted to fix that error, but I didn't
know enough about the x86 architecture.

> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  x86/cpuid.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/x86/cpuid.c b/x86/cpuid.c
> index c3b67d9..aa213d5 100644
> --- a/x86/cpuid.c
> +++ b/x86/cpuid.c
> @@ -8,7 +8,7 @@
>  
>  #define	MAX_KVM_CPUID_ENTRIES		100
>  
> -static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid)
> +static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid, int cpu_id)
>  {
>  	unsigned int signature[3];
>  	unsigned int i;
> @@ -28,6 +28,8 @@ static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid)
>  			entry->edx = signature[2];
>  			break;
>  		case 1:
> +			entry->ebx &= ~(0xff << 24);
> +			entry->ebx |= cpu_id << 24;
>  			/* Set X86_FEATURE_HYPERVISOR */
>  			if (entry->index == 0)
>  				entry->ecx |= (1 << 31);
> @@ -80,7 +82,7 @@ void kvm_cpu__setup_cpuid(struct kvm_cpu *vcpu)
>  	if (ioctl(vcpu->kvm->sys_fd, KVM_GET_SUPPORTED_CPUID, kvm_cpuid) < 0)
>  		die_perror("KVM_GET_SUPPORTED_CPUID failed");
>  
> -	filter_cpuid(kvm_cpuid);
> +	filter_cpuid(kvm_cpuid, vcpu->cpu_id);

Tested it and it works:

Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

>  
>  	if (ioctl(vcpu->vcpu_fd, KVM_SET_CPUID2, kvm_cpuid) < 0)
>  		die_perror("KVM_SET_CPUID2 failed");
> -- 
> 2.11.0
> 
