Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0EE3534D0
	for <lists+kvm@lfdr.de>; Sat,  3 Apr 2021 19:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236910AbhDCRDQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Apr 2021 13:03:16 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:3735 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236364AbhDCRDP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Apr 2021 13:03:15 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4FCNXX3hw0z9v2CJ;
        Sat,  3 Apr 2021 19:03:08 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id rvaiHbBvDo5U; Sat,  3 Apr 2021 19:03:08 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4FCNXX2S8Wz9v2CG;
        Sat,  3 Apr 2021 19:03:08 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 06A1B8B76D;
        Sat,  3 Apr 2021 19:03:10 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id mMLZlhwDpRCm; Sat,  3 Apr 2021 19:03:09 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 316988B76A;
        Sat,  3 Apr 2021 19:03:09 +0200 (CEST)
Subject: Re: [PATCH 2/5] crypto: ccp: Reject SEV commands with mismatching
 command buffer
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
 <20210402233702.3291792-3-seanjc@google.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <686e74ca-63b7-e52f-a22d-9eb6577c4937@csgroup.eu>
Date:   Sat, 3 Apr 2021 19:02:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210402233702.3291792-3-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Le 03/04/2021 à 01:36, Sean Christopherson a écrit :
> WARN on and reject SEV commands that provide a valid data pointer, but do
> not have a known, non-zero length.  And conversely, reject commands that
> take a command buffer but none is provided.
> 
> Aside from sanity checking intput, disallowing a non-null pointer without
> a non-zero size will allow a future patch to cleanly handle vmalloc'd
> data by copying the data to an internal __pa() friendly buffer.
> 
> Note, this also effectively prevents callers from using commands that
> have a non-zero length and are not known to the kernel.  This is not an
> explicit goal, but arguably the side effect is a good thing from the
> kernel's perspective.
> 
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   drivers/crypto/ccp/sev-dev.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 6556d220713b..4c513318f16a 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -141,6 +141,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>   	struct sev_device *sev;
>   	unsigned int phys_lsb, phys_msb;
>   	unsigned int reg, ret = 0;
> +	int buf_len;
>   
>   	if (!psp || !psp->sev_data)
>   		return -ENODEV;
> @@ -150,7 +151,11 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>   
>   	sev = psp->sev_data;
>   
> -	if (data && WARN_ON_ONCE(is_vmalloc_addr(data)))
> +	buf_len = sev_cmd_buffer_len(cmd);
> +	if (WARN_ON_ONCE(!!data != !!buf_len))
> +		return -EINVAL;
> +
> +	if (WARN_ON_ONCE(data && is_vmalloc_addr(data)))

Shouldn't it be !virt_addr_valid() instead of is_vmalloc_addr() ?


>   		return -EINVAL;
>   
>   	/* Get the physical address of the command buffer */
> @@ -161,7 +166,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>   		cmd, phys_msb, phys_lsb, psp_timeout);
>   
>   	print_hex_dump_debug("(in):  ", DUMP_PREFIX_OFFSET, 16, 2, data,
> -			     sev_cmd_buffer_len(cmd), false);
> +			     buf_len, false);
>   
>   	iowrite32(phys_lsb, sev->io_regs + sev->vdata->cmdbuff_addr_lo_reg);
>   	iowrite32(phys_msb, sev->io_regs + sev->vdata->cmdbuff_addr_hi_reg);
> @@ -197,7 +202,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>   	}
>   
>   	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
> -			     sev_cmd_buffer_len(cmd), false);
> +			     buf_len, false);
>   
>   	return ret;
>   }
> 
