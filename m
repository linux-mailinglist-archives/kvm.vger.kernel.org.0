Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2709FBF796
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 19:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbfIZR3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 13:29:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40284 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727502AbfIZR3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 13:29:30 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0E9997FDFD;
        Thu, 26 Sep 2019 17:29:30 +0000 (UTC)
Received: from llong.remote.csb (dhcp-17-160.bos.redhat.com [10.18.17.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1765B60BE2;
        Thu, 26 Sep 2019 17:29:29 +0000 (UTC)
Subject: Re: [PATCH] KVM: VMX: Set VMENTER_L1D_FLUSH_NOT_REQUIRED if
 !X86_BUG_L1TF
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190826193023.23293-1-longman@redhat.com>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <6bc37d29-b691-28d6-d4dc-9402fa82093a@redhat.com>
Date:   Thu, 26 Sep 2019 13:29:28 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190826193023.23293-1-longman@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 26 Sep 2019 17:29:30 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/26/19 3:30 PM, Waiman Long wrote:
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
> ---
>  arch/x86/kvm/vmx/vmx.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 42ed3faa6af8..a00ce3d6bbfd 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7896,6 +7896,8 @@ static int __init vmx_init(void)
>  			vmx_exit();
>  			return r;
>  		}
> +	} else {
> +		l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_NOT_REQUIRED;
>  	}
>  
>  #ifdef CONFIG_KEXEC_CORE

Ping. Any comment on that one?

Cheers,
Longman

