Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA29353710
	for <lists+kvm@lfdr.de>; Sun,  4 Apr 2021 08:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbhDDGcB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Apr 2021 02:32:01 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:30496 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229557AbhDDGcA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Apr 2021 02:32:00 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4FCkTg6gdbz9v3gc;
        Sun,  4 Apr 2021 08:31:51 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id Wu3DjiSg0knV; Sun,  4 Apr 2021 08:31:51 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4FCkTg5Rd4z9v3gb;
        Sun,  4 Apr 2021 08:31:51 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 435258B76F;
        Sun,  4 Apr 2021 08:31:54 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id b4wLpnXD92A7; Sun,  4 Apr 2021 08:31:54 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 92D088B76A;
        Sun,  4 Apr 2021 08:31:53 +0200 (CEST)
Subject: Re: [PATCH 1/5] crypto: ccp: Detect and reject vmalloc addresses
 destined for PSP
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
References: <20210402233702.3291792-1-seanjc@google.com>
 <20210402233702.3291792-2-seanjc@google.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <f731c2f3-7a51-47d6-bdb2-cfefd07b6abd@csgroup.eu>
Date:   Sun, 4 Apr 2021 08:31:46 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210402233702.3291792-2-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Le 03/04/2021 à 01:36, Sean Christopherson a écrit :
> Explicitly reject vmalloc'd data as the source for SEV commands that are
> sent to the PSP.  The PSP works with physical addresses, and __pa() will
> not return the correct address for a vmalloc'd pionter, which at best
> will cause the command to fail, and at worst lead to system instability.
> 
> While it's unlikely that callers will deliberately use vmalloc() for SEV
> buffers, a caller can easily use a vmalloc'd pointer unknowingly when
> running with CONFIG_VMAP_STACK=y as it's not obvious that putting the
> command buffers on the stack would be bad.  The command buffers are
> relative small and easily fit on the stack, and the APIs to do not
> document that the incoming pointer must be a physically contiguous,
> __pa() friendly pointer.
> 
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Fixes: 200664d5237f ("crypto: ccp: Add Secure Encrypted Virtualization (SEV) command support")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   drivers/crypto/ccp/sev-dev.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index cb9b4c4e371e..6556d220713b 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -150,6 +150,9 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>   
>   	sev = psp->sev_data;
>   
> +	if (data && WARN_ON_ONCE(is_vmalloc_addr(data)))
> +		return -EINVAL;
> +

I hadn't seen this patch when I commented the 2 other ones, I received it only this night.

As commented in the other patches, is_vmalloc_addr() is not the best way to test that __pa() can be 
safely used.

For that, you have virt_addr_valid()

>   	/* Get the physical address of the command buffer */
>   	phys_lsb = data ? lower_32_bits(__psp_pa(data)) : 0;
>   	phys_msb = data ? upper_32_bits(__psp_pa(data)) : 0;
> 
