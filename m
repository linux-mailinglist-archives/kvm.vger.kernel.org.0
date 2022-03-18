Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD3914DD889
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 11:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbiCRK4M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 06:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235468AbiCRK4J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 06:56:09 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A8FEB1A48B4
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 03:54:50 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2684016F2;
        Fri, 18 Mar 2022 03:54:50 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1D1713F7F5;
        Fri, 18 Mar 2022 03:54:49 -0700 (PDT)
Date:   Fri, 18 Mar 2022 10:54:38 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Dongli Si <sidongli1997@gmail.com>
Subject: Re: [RESEND PATCH kvmtool] x86/cpuid: Stop masking the CPU vendor
Message-ID: <20220318105438.0614cfda@donnerap.cambridge.arm.com>
In-Reply-To: <20220317192853.60205-1-oupton@google.com>
References: <20220317192853.60205-1-oupton@google.com>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 17 Mar 2022 19:28:53 +0000
Oliver Upton <oupton@google.com> wrote:

Hi Oliver,

thanks for the patch, this overlaps with our recent discussion here:
https://lore.kernel.org/kvm/20220226060048.3-1-sidongli1997@gmail.com/

> commit bc0b99a ("kvm tools: Filter out CPU vendor string") replaced the
> processor's native vendor string with a synthetic one to hack around
> some interesting guest MSR accesses that were not handled in KVM. In
> particular, the MC4_CTL_MASK MSR was accessed for AMD VMs, which isn't
> supported by KVM. This MSR relates to masking MCEs originating from the
> northbridge on real hardware, but is of zero use in virtualization.

Yes, in general this applies to all kind of errata workarounds tied to
certain F/M/S values, something totally expected. We have the same
situation on Arm, actually, although the kernel tries to avoid IMPDEF
system register accesses.

> Speaking more broadly, KVM does in fact do the right thing for such an
> MSR (#GP), and it is annoying but benign that KVM does a printk for the
> MSR.

Yes, but the printk is the lesser of our problems, the #GP is typically
more of an issue. Fortunately other VMMs have this problem as well, so the
kernel itself learned to ignore certain MSR #GPs (rdmsrl_safe()), so we
are good now. Back then this #GP lead to a kernel crash, IIRC.

> Masking the CPU vendor string is far from ideal, and gets in the
> way of testing vendor-specific CPU features.

Not only that, it's mostly wrong and now unsustainable, see the early
kernel messages when running on an unknown vendor. Also glibc compiled for
a higher ISA level is now a showstopper.
At least the AMD CPUID spec clearly says that its CPUID register mapping
are only valid for the AMD vendor string, and I believe Intel relies on
that as well. I wouldn't know of conflicting assignments between the two,
though, but we now miss many features by exposing an unknown vendor.

> Stop the shenanigans and
> expose the vendor ID as returned by KVM_GET_SUPPORTED_CPUID.

Yes, that's the right thing to do.

So can you please:
1) make this a revert of the original kvmtool patch
2) Mention the glibc error in the commit message, so that search engines
turn this up?
3) Copy in some part of my explanation (either from this message or the
reply to the thread mentioned above).

If you don't feel like it or don't have time, let me know. I originally
wanted to send the revert myself, but got distracted.

Cheers,
Andre

> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  x86/cpuid.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/x86/cpuid.c b/x86/cpuid.c
> index aa213d5..f4347a8 100644
> --- a/x86/cpuid.c
> +++ b/x86/cpuid.c
> @@ -10,7 +10,6 @@
>  
>  static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid, int cpu_id)
>  {
> -	unsigned int signature[3];
>  	unsigned int i;
>  
>  	/*
> @@ -20,13 +19,6 @@ static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid, int cpu_id)
>  		struct kvm_cpuid_entry2 *entry = &kvm_cpuid->entries[i];
>  
>  		switch (entry->function) {
> -		case 0:
> -			/* Vendor name */
> -			memcpy(signature, "LKVMLKVMLKVM", 12);
> -			entry->ebx = signature[0];
> -			entry->ecx = signature[1];
> -			entry->edx = signature[2];
> -			break;
>  		case 1:
>  			entry->ebx &= ~(0xff << 24);
>  			entry->ebx |= cpu_id << 24;

