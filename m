Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19D7EC0939
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 18:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfI0QLS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 12:11:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45378 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727273AbfI0QLS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 12:11:18 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0A349369D3;
        Fri, 27 Sep 2019 16:11:18 +0000 (UTC)
Received: from llong.remote.csb (dhcp-17-160.bos.redhat.com [10.18.17.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8742A5C224;
        Fri, 27 Sep 2019 16:11:17 +0000 (UTC)
Subject: Re: [PATCH v2] KVM: VMX: Set VMENTER_L1D_FLUSH_NOT_REQUIRED if
 !X86_BUG_L1TF
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     bp@alien8.de
References: <1569600316-35966-1-git-send-email-pbonzini@redhat.com>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <d8dc9ae5-7a97-1aed-4c22-051587795789@redhat.com>
Date:   Fri, 27 Sep 2019 12:11:17 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1569600316-35966-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 27 Sep 2019 16:11:18 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/27/19 12:05 PM, Paolo Bonzini wrote:
> From: Waiman Long <longman@redhat.com>
>
> The l1tf_vmx_mitigation is only set to VMENTER_L1D_FLUSH_NOT_REQUIRED
> when the ARCH_CAPABILITIES MSR indicates that L1D flush is not required.
> However, if the CPU is not affected by L1TF, l1tf_vmx_mitigation will
> still be set to VMENTER_L1D_FLUSH_AUTO. This is certainly not the best
> option for a !X86_BUG_L1TF CPU.
>
> So force l1tf_vmx_mitigation to VMENTER_L1D_FLUSH_NOT_REQUIRED to make it
> more explicit in case users are checking the vmentry_l1d_flush parameter.
>
> Signed-off-by: Waiman Long <longman@redhat.com>
> [Patch rewritten accoring to Borislav Petkov's suggestion. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d4575ffb3cec..e7970a2e8eae 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -209,6 +209,11 @@ static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
>  	struct page *page;
>  	unsigned int i;
>  
> +	if (!boot_cpu_has_bug(X86_BUG_L1TF)) {
> +		l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_NOT_REQUIRED;
> +		return 0;
> +	}
> +
>  	if (!enable_ept) {
>  		l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_EPT_DISABLED;
>  		return 0;
> @@ -7995,12 +8000,10 @@ static int __init vmx_init(void)
>  	 * contain 'auto' which will be turned into the default 'cond'
>  	 * mitigation mode.
>  	 */
> -	if (boot_cpu_has(X86_BUG_L1TF)) {
> -		r = vmx_setup_l1d_flush(vmentry_l1d_flush_param);
> -		if (r) {
> -			vmx_exit();
> -			return r;
> -		}
> +	r = vmx_setup_l1d_flush(vmentry_l1d_flush_param);
> +	if (r) {
> +		vmx_exit();
> +		return r;
>  	}
>  
>  #ifdef CONFIG_KEXEC_CORE

That looks cleaner. Thanks for the suggestion and rewrite.

Cheers,
Longman

