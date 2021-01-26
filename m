Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6805C303C31
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 12:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392211AbhAZLyl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 06:54:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58340 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405510AbhAZLy3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 06:54:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611661983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jlQQQ6L+FtcMn7LVj7kDbGnrW45WOTGTVH3PvdiMo28=;
        b=Lo+coYbxiX0DOppxHx5XliuWVE/eL0dfwf7mrxTkFsLMiUh5zQFW3PqLaPhPjbHv432zML
        GZubCKbyY4ir2quBvq7QbY6croMIldp9paBGEor0sGHFWbM3m5vCZfTdg/jeXCVVrsYFV4
        Tr03zXR3wZWwkr1dOUV2q16lxLx+gaY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-Xv8bPRWoNpeVt9ncVFrPTg-1; Tue, 26 Jan 2021 06:53:01 -0500
X-MC-Unique: Xv8bPRWoNpeVt9ncVFrPTg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9B2510054FF;
        Tue, 26 Jan 2021 11:52:59 +0000 (UTC)
Received: from starship (unknown [10.35.206.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E17010023AE;
        Tue, 26 Jan 2021 11:52:51 +0000 (UTC)
Message-ID: <f8a2fbc829a553b936b8babc5c1df2b1e88f51d7.camel@redhat.com>
Subject: Re: [PATCH v3 3/4] KVM: SVM: Add support for SVM instruction
 address check change
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, seanjc@google.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, luto@amacapital.net
Date:   Tue, 26 Jan 2021 13:52:50 +0200
In-Reply-To: <20210126081831.570253-4-wei.huang2@amd.com>
References: <20210126081831.570253-1-wei.huang2@amd.com>
         <20210126081831.570253-4-wei.huang2@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-01-26 at 03:18 -0500, Wei Huang wrote:
> New AMD CPUs have a change that checks #VMEXIT intercept on special SVM
> instructions before checking their EAX against reserved memory region.
> This change is indicated by CPUID_0x8000000A_EDX[28]. If it is 1, #VMEXIT
> is triggered before #GP. KVM doesn't need to intercept and emulate #GP
> faults as #GP is supposed to be triggered.
> 
> Co-developed-by: Bandan Das <bsd@redhat.com>
> Signed-off-by: Bandan Das <bsd@redhat.com>
> Signed-off-by: Wei Huang <wei.huang2@amd.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  arch/x86/kvm/svm/svm.c             | 3 +++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 84b887825f12..ea89d6fdd79a 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -337,6 +337,7 @@
>  #define X86_FEATURE_AVIC		(15*32+13) /* Virtual Interrupt Controller */
>  #define X86_FEATURE_V_VMSAVE_VMLOAD	(15*32+15) /* Virtual VMSAVE VMLOAD */
>  #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
> +#define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* "" SVME addr check */
>  
>  /* Intel-defined CPU features, CPUID level 0x00000007:0 (ECX), word 16 */
>  #define X86_FEATURE_AVX512VBMI		(16*32+ 1) /* AVX512 Vector Bit Manipulation instructions*/
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e5ca01e25e89..f9233c79265b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1036,6 +1036,9 @@ static __init int svm_hardware_setup(void)
>  		}
>  	}
>  
> +	if (boot_cpu_has(X86_FEATURE_SVME_ADDR_CHK))
> +		svm_gp_erratum_intercept = false;
> +
Again, I would make svm_gp_erratum_intercept a tri-state module param,
and here if it is in 'auto' state do this.

Also I might as well made this code fail if X86_FEATURE_SVME_ADDR_CHK is set but
user insists on svm_gp_erratum_intercept = true.

>  	if (vgif) {
>  		if (!boot_cpu_has(X86_FEATURE_VGIF))
>  			vgif = false;


Best regards,
	Maxim Levitsky

