Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD95353718
	for <lists+kvm@lfdr.de>; Sun,  4 Apr 2021 08:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhDDGs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Apr 2021 02:48:27 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:49592 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhDDGs0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Apr 2021 02:48:26 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4FCkrf2bWgz9v3gt;
        Sun,  4 Apr 2021 08:48:18 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id 6FrJODn1fU2E; Sun,  4 Apr 2021 08:48:18 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4FCkrf0XZjz9v3gs;
        Sun,  4 Apr 2021 08:48:18 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id B91588B76F;
        Sun,  4 Apr 2021 08:48:20 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id JzUiL4yZzzBC; Sun,  4 Apr 2021 08:48:20 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id D675D8B76A;
        Sun,  4 Apr 2021 08:48:19 +0200 (CEST)
Subject: Re: [PATCH 3/5] crypto: ccp: Play nice with vmalloc'd memory for SEV
 command structs
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
 <20210402233702.3291792-4-seanjc@google.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <8ea3744f-fdf7-1704-2860-40c2b8fb47e1@csgroup.eu>
Date:   Sun, 4 Apr 2021 08:48:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210402233702.3291792-4-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Le 03/04/2021 à 01:37, Sean Christopherson a écrit :
> Copy vmalloc'd data to an internal buffer instead of rejecting outright
> so that callers can put SEV command buffers on the stack without running
> afoul of CONFIG_VMAP_STACK=y.  Currently, the largest supported command
> takes a 68 byte buffer, i.e. pretty much every command can be put on the
> stack.  Because sev_cmd_mutex is held for the entirety of a transaction,
> only a single bounce buffer is required.
> 
> Use a flexible array for the buffer, sized to hold the largest known
> command.   Alternatively, the buffer could be a union of all known
> command structs, but that would incur a higher maintenance cost due to
> the need to update the union for every command in addition to updating
> the existing sev_cmd_buffer_len().
> 
> Align the buffer to an 8-byte boundary, mimicking the alignment that
> would be provided by the compiler if any of the structs were embedded
> directly.  Note, sizeof() correctly incorporates this alignment.
> 
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   drivers/crypto/ccp/sev-dev.c | 33 +++++++++++++++++++++++++++------
>   drivers/crypto/ccp/sev-dev.h |  7 +++++++
>   2 files changed, 34 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 4c513318f16a..6d5882290cfc 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -135,13 +135,14 @@ static int sev_cmd_buffer_len(int cmd)
>   	return 0;
>   }
>   
> -static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
> +static int __sev_do_cmd_locked(int cmd, void *__data, int *psp_ret)
>   {
>   	struct psp_device *psp = psp_master;
>   	struct sev_device *sev;
>   	unsigned int phys_lsb, phys_msb;
>   	unsigned int reg, ret = 0;
>   	int buf_len;
> +	void *data;
>   
>   	if (!psp || !psp->sev_data)
>   		return -ENODEV;
> @@ -152,11 +153,21 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>   	sev = psp->sev_data;
>   
>   	buf_len = sev_cmd_buffer_len(cmd);
> -	if (WARN_ON_ONCE(!!data != !!buf_len))
> +	if (WARN_ON_ONCE(!!__data != !!buf_len))
>   		return -EINVAL;
>   
> -	if (WARN_ON_ONCE(data && is_vmalloc_addr(data)))
> -		return -EINVAL;
> +	if (__data && is_vmalloc_addr(__data)) {
> +		/*
> +		 * If the incoming buffer is virtually allocated, copy it to
> +		 * the driver's scratch buffer as __pa() will not work for such
> +		 * addresses, vmalloc_to_page() is not guaranteed to succeed,
> +		 * and vmalloc'd data may not be physically contiguous.
> +		 */
> +		data = sev->cmd_buf;
> +		memcpy(data, __data, buf_len);
> +	} else {
> +		data = __data;
> +	}

I don't know how big commands are, but if they are small, it would probably be more efficient to 
inconditionnally copy them to the buffer rather then doing the test.

>   
>   	/* Get the physical address of the command buffer */
>   	phys_lsb = data ? lower_32_bits(__psp_pa(data)) : 0;
> @@ -204,6 +215,13 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>   	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
>   			     buf_len, false);
>   
> +	/*
> +	 * Copy potential output from the PSP back to __data.  Do this even on
> +	 * failure in case the caller wants to glean something from the error.
> +	 */
> +	if (__data && data != __data)
> +		memcpy(__data, data, buf_len);
> +
>   	return ret;
>   }
>   
> @@ -978,9 +996,12 @@ int sev_dev_init(struct psp_device *psp)
>   {
>   	struct device *dev = psp->dev;
>   	struct sev_device *sev;
> -	int ret = -ENOMEM;
> +	int ret = -ENOMEM, cmd_buf_size = 0, i;
>   
> -	sev = devm_kzalloc(dev, sizeof(*sev), GFP_KERNEL);
> +	for (i = 0; i < SEV_CMD_MAX; i++)
> +		cmd_buf_size = max(cmd_buf_size, sev_cmd_buffer_len(i));
> +
> +	sev = devm_kzalloc(dev, sizeof(*sev) + cmd_buf_size, GFP_KERNEL);
>   	if (!sev)
>   		goto e_err;
>   
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index dd5c4fe82914..b43283ce2d73 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -52,6 +52,13 @@ struct sev_device {
>   	u8 api_major;
>   	u8 api_minor;
>   	u8 build;
> +
> +	/*
> +	 * Buffer used for incoming commands whose physical address cannot be
> +	 * resolved via __pa(), e.g. stack pointers when CONFIG_VMAP_STACK=y.
> +	 * Note, alignment isn't strictly required.
> +	 */
> +	u8 cmd_buf[] __aligned(8);
>   };
>   
>   int sev_dev_init(struct psp_device *psp);
> 
