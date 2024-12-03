Return-Path: <kvm+bounces-32926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3AA69E2269
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 16:24:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5980FB2C896
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 14:20:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDDCD1F4717;
	Tue,  3 Dec 2024 14:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="bz//0v3y"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1D217BB16;
	Tue,  3 Dec 2024 14:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733235617; cv=none; b=Wvvxw6YpdOp3eX2rBqUdqqBXTEHB0m2M3x+A470D3/nDFZpiSAL2CpfMjSfclYeZ/E8Mci+lwGnu3nZE5ZtMuK0/o1ECw3YS9364E82u8pyCYWeTmixbL5Z7mcfTduw58M0zLDWHkKZeyd819KBzqm2KxFLmReLKHAUPzZ3QQy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733235617; c=relaxed/simple;
	bh=s2SqqMNG8bkReQAgImrfGF1AvrnPnThhdA7ZNCRj1jE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=em8QtPNrk8sV0z+NIOE7t2J+uW2oBjkES5dY/AOq8WJGqYn58u0tuAq6tYeXLJ5h7yPlzdsrR/p7IzKGLABr+DjrTs7Mm36m36y2FRYq29IIbOYwtfsy34PzTvPtIRjJy+GX2D7SISqToUuGVAGT9oEKczeq2v4yy1QuCmnzKP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=bz//0v3y; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id BDF8040E021C;
	Tue,  3 Dec 2024 14:20:11 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id TdUGDkFbDPTk; Tue,  3 Dec 2024 14:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733235607; bh=BZeJ1b95eAqJbQxIv6AsrDch7h30Uxh79jYaoVPQxk8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bz//0v3y5+ecRmZTqMCe+UzAJ8Zql5zCw6Kk6qGF7LoqEDos18vkLiP6WTiot6EoZ
	 0DUOJ7qyGXWr9ILsKJnUAauACWOWxQV/6QHN5zjN/txF8ejD+mBdsznJ6y2wksYWrg
	 oD7A9c7RCb2diE3DxLq7Z/EftTx+9WwWi3O6bpS1I1NGGDrDMAlkrw/NFNTcCYc5RX
	 GNAudwMxdMCSKwPSV0ZDZHlTbbWzbqwef5B4j9v4tPebcEdhUA1mdnB7DNgX8j/ptF
	 sZvzZuSOOvPazqux+lYKu8g+vRh8fGLmQ0WmclorpVJLIFiY5Y8UdA2/BrdbxFvOJk
	 SY4WRSBiF8OJGgRmC+t2UYw8xN8qYz1yrwFGJwn3xCHyd7dp1q8JHiPnTWOcx5vZsP
	 MivRQC3lbutkSg/PphVUFyy2tYN2J03ph2/XW16YaJCZWpHi9wzCd/qr74oPsm+lxq
	 m+MrXo2YWeWE/5qrLN5arXcj/2B083EgLERhniYxYnYQ6Jf48euTTN4dnuZAVsJt0b
	 krROaXWAdf7MA3t7taUYZ7h5tEPpexveQtAJzMcXWaoh6LgzXcjE11f2RDd4axFhFq
	 scgT/GPQ4n5PUiYJtWWVmv1Xx/GFBcF9xB8N0Uc7bGCw2zA2RYi5d9zhvdtQVoiKmo
	 YGDVwXZy0IDU20Ds3UZRGLfU=
Received: from zn.tnic (pd9530b86.dip0.t-ipconnect.de [217.83.11.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 73C3B40E0163;
	Tue,  3 Dec 2024 14:19:56 +0000 (UTC)
Date: Tue, 3 Dec 2024 15:19:50 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 01/13] x86/sev: Carve out and export SNP guest
 messaging init routines
Message-ID: <20241203141950.GCZ08ThrMOHmDFeaa2@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-2-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241203090045.942078-2-nikunj@amd.com>

On Tue, Dec 03, 2024 at 02:30:33PM +0530, Nikunj A Dadhania wrote:
> Currently, the sev-guest driver is the only user of SNP guest messaging.
> All routines for initializing SNP guest messaging are implemented within
> the sev-guest driver and are not available during early boot. In
> prepratation for adding Secure TSC guest support, carve out APIs to

Unknown word [prepratation] in commit message.
Suggestions: ['preparation', 'preparations', 'reparation', 'perpetration', 'reputation', 'perpetuation', 'peroration', 'presentation', 'repatriation', 'propagation', "preparation's"]

Please introduce a spellchecker into your patch creation workflow.

> allocate and initialize guest messaging descriptor context and make it part
> of coco/sev/core.c. As there is no user of sev_guest_platform_data anymore,
> remove the structure.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/include/asm/sev.h              |  24 ++-
>  arch/x86/coco/sev/core.c                | 183 +++++++++++++++++++++-
>  drivers/virt/coco/sev-guest/sev-guest.c | 197 +++---------------------
>  arch/x86/Kconfig                        |   1 +
>  drivers/virt/coco/sev-guest/Kconfig     |   1 -
>  5 files changed, 220 insertions(+), 186 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 91f08af31078..f78c94e29c74 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -14,6 +14,7 @@
>  #include <asm/insn.h>
>  #include <asm/sev-common.h>
>  #include <asm/coco.h>
> +#include <asm/set_memory.h>
>  
>  #define GHCB_PROTOCOL_MIN	1ULL
>  #define GHCB_PROTOCOL_MAX	2ULL
> @@ -170,10 +171,6 @@ struct snp_guest_msg {
>  	u8 payload[PAGE_SIZE - sizeof(struct snp_guest_msg_hdr)];
>  } __packed;
>  
> -struct sev_guest_platform_data {
> -	u64 secrets_gpa;
> -};
> -
>  struct snp_guest_req {
>  	void *req_buf;
>  	size_t req_sz;
> @@ -253,6 +250,7 @@ struct snp_msg_desc {
>  
>  	u32 *os_area_msg_seqno;
>  	u8 *vmpck;
> +	int vmpck_id;
>  };
>  
>  /*
> @@ -458,6 +456,20 @@ void set_pte_enc_mask(pte_t *kpte, unsigned long pfn, pgprot_t new_prot);
>  void snp_kexec_finish(void);
>  void snp_kexec_begin(void);
>  
> +static inline bool snp_is_vmpck_empty(struct snp_msg_desc *mdesc)
> +{
> +	static const char zero_key[VMPCK_KEY_LEN] = {0};
> +
> +	if (mdesc->vmpck)
> +		return !memcmp(mdesc->vmpck, zero_key, VMPCK_KEY_LEN);
> +
> +	return true;
> +}

This function looks silly in a header with that array allocation.

I think you should simply do:

	if (memchr_inv(mdesc->vmpck, 0, VMPCK_KEY_LEN))

at the call sites and not have this helper at all.

But please do verify whether what I'm saying actually makes sense and if it
does, this can be a cleanup pre-patch.


> +
> +int snp_msg_init(struct snp_msg_desc *mdesc, int vmpck_id);
> +struct snp_msg_desc *snp_msg_alloc(void);
> +void snp_msg_free(struct snp_msg_desc *mdesc);
> +
>  #else	/* !CONFIG_AMD_MEM_ENCRYPT */
>  
>  #define snp_vmpl 0
> @@ -498,6 +510,10 @@ static inline int prepare_pte_enc(struct pte_enc_desc *d) { return 0; }
>  static inline void set_pte_enc_mask(pte_t *kpte, unsigned long pfn, pgprot_t new_prot) { }
>  static inline void snp_kexec_finish(void) { }
>  static inline void snp_kexec_begin(void) { }
> +static inline bool snp_is_vmpck_empty(struct snp_msg_desc *mdesc) { return false; }
> +static inline int snp_msg_init(struct snp_msg_desc *mdesc, int vmpck_id) { return -1; }
> +static inline struct snp_msg_desc *snp_msg_alloc(void) { return NULL; }
> +static inline void snp_msg_free(struct snp_msg_desc *mdesc) { }
>  
>  #endif	/* CONFIG_AMD_MEM_ENCRYPT */
>  
> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index c5b0148b8c0a..3cc741eefd06 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -25,6 +25,7 @@
>  #include <linux/psp-sev.h>
>  #include <linux/dmi.h>
>  #include <uapi/linux/sev-guest.h>
> +#include <crypto/gcm.h>
>  
>  #include <asm/init.h>
>  #include <asm/cpu_entry_area.h>
> @@ -2580,15 +2581,9 @@ static struct platform_device sev_guest_device = {
>  
>  static int __init snp_init_platform_device(void)
>  {
> -	struct sev_guest_platform_data data;
> -
>  	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
>  		return -ENODEV;
>  
> -	data.secrets_gpa = secrets_pa;
> -	if (platform_device_add_data(&sev_guest_device, &data, sizeof(data)))
> -		return -ENODEV;
> -
>  	if (platform_device_register(&sev_guest_device))
>  		return -ENODEV;
>  
> @@ -2667,3 +2662,179 @@ static int __init sev_sysfs_init(void)
>  }
>  arch_initcall(sev_sysfs_init);
>  #endif // CONFIG_SYSFS
> +
> +static void free_shared_pages(void *buf, size_t sz)
> +{
> +	unsigned int npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
> +	int ret;
> +
> +	if (!buf)
> +		return;
> +
> +	ret = set_memory_encrypted((unsigned long)buf, npages);
> +	if (ret) {
> +		WARN_ONCE(ret, "failed to restore encryption mask (leak it)\n");

Looking at where this lands:

set_memory_encrypted
|-> __set_memory_enc_dec

and that doing now:

        if (cc_platform_has(CC_ATTR_MEM_ENCRYPT)) {
                if (!down_read_trylock(&mem_enc_lock))
                        return -EBUSY;


after

859e63b789d6 ("x86/tdx: Convert shared memory back to private on kexec")

we probably should pay attention to this here firing and maybe turning that
_trylock() into a normal down_read*

Anyway, just something to pay attention to in the future.

> +		return;
> +	}
> +
> +	__free_pages(virt_to_page(buf), get_order(sz));
> +}

...

> +struct snp_msg_desc *snp_msg_alloc(void)
> +{
> +	struct snp_msg_desc *mdesc;
> +	void __iomem *mem;
> +
> +	BUILD_BUG_ON(sizeof(struct snp_guest_msg) > PAGE_SIZE);
> +
> +	mdesc = kzalloc(sizeof(struct snp_msg_desc), GFP_KERNEL);

The above ones use GFP_KERNEL_ACCOUNT. What's the difference?

> +	if (!mdesc)
> +		return ERR_PTR(-ENOMEM);
> +
> +	mem = ioremap_encrypted(secrets_pa, PAGE_SIZE);
> +	if (!mem)
> +		goto e_free_mdesc;
> +
> +	mdesc->secrets = (__force struct snp_secrets_page *)mem;
> +
> +	/* Allocate the shared page used for the request and response message. */
> +	mdesc->request = alloc_shared_pages(sizeof(struct snp_guest_msg));
> +	if (!mdesc->request)
> +		goto e_unmap;
> +
> +	mdesc->response = alloc_shared_pages(sizeof(struct snp_guest_msg));
> +	if (!mdesc->response)
> +		goto e_free_request;
> +
> +	mdesc->certs_data = alloc_shared_pages(SEV_FW_BLOB_MAX_SIZE);
> +	if (!mdesc->certs_data)
> +		goto e_free_response;
> +
> +	/* initial the input address for guest request */
> +	mdesc->input.req_gpa = __pa(mdesc->request);
> +	mdesc->input.resp_gpa = __pa(mdesc->response);
> +	mdesc->input.data_gpa = __pa(mdesc->certs_data);
> +
> +	return mdesc;
> +
> +e_free_response:
> +	free_shared_pages(mdesc->response, sizeof(struct snp_guest_msg));
> +e_free_request:
> +	free_shared_pages(mdesc->request, sizeof(struct snp_guest_msg));
> +e_unmap:
> +	iounmap(mem);
> +e_free_mdesc:
> +	kfree(mdesc);
> +
> +	return ERR_PTR(-ENOMEM);
> +}
> +EXPORT_SYMBOL_GPL(snp_msg_alloc);
> +
> +void snp_msg_free(struct snp_msg_desc *mdesc)
> +{
> +	if (!mdesc)
> +		return;
> +
> +	mdesc->vmpck = NULL;
> +	mdesc->os_area_msg_seqno = NULL;

	memset(mdesc, ...);

at the end instead of those assignments.

> +	kfree(mdesc->ctx);
> +
> +	free_shared_pages(mdesc->response, sizeof(struct snp_guest_msg));
> +	free_shared_pages(mdesc->request, sizeof(struct snp_guest_msg));
> +	iounmap((__force void __iomem *)mdesc->secrets);


> +	kfree(mdesc);
> +}
> +EXPORT_SYMBOL_GPL(snp_msg_free);
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
> index b699771be029..5268511bc9b8 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.c
> +++ b/drivers/virt/coco/sev-guest/sev-guest.c

...

> @@ -993,115 +898,57 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>  	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
>  		return -ENODEV;
>  
> -	if (!dev->platform_data)
> -		return -ENODEV;
> -
> -	data = (struct sev_guest_platform_data *)dev->platform_data;
> -	mapping = ioremap_encrypted(data->secrets_gpa, PAGE_SIZE);
> -	if (!mapping)
> -		return -ENODEV;
> -
> -	secrets = (__force void *)mapping;
> -
> -	ret = -ENOMEM;
>  	snp_dev = devm_kzalloc(&pdev->dev, sizeof(struct snp_guest_dev), GFP_KERNEL);
>  	if (!snp_dev)
> -		goto e_unmap;
> -
> -	mdesc = devm_kzalloc(&pdev->dev, sizeof(struct snp_msg_desc), GFP_KERNEL);
> -	if (!mdesc)
> -		goto e_unmap;
> -
> -	/* Adjust the default VMPCK key based on the executing VMPL level */
> -	if (vmpck_id == -1)
> -		vmpck_id = snp_vmpl;
> +		return -ENOMEM;
>  
> -	ret = -EINVAL;
> -	mdesc->vmpck = get_vmpck(vmpck_id, secrets, &mdesc->os_area_msg_seqno);
> -	if (!mdesc->vmpck) {
> -		dev_err(dev, "Invalid VMPCK%d communication key\n", vmpck_id);
> -		goto e_unmap;
> -	}
> +	mdesc = snp_msg_alloc();
> +	if (IS_ERR_OR_NULL(mdesc))
> +		return -ENOMEM;
>  
> -	/* Verify that VMPCK is not zero. */
> -	if (is_vmpck_empty(mdesc)) {
> -		dev_err(dev, "Empty VMPCK%d communication key\n", vmpck_id);
> -		goto e_unmap;
> -	}
> +	ret = snp_msg_init(mdesc, vmpck_id);
> +	if (ret)
> +		return -EIO;

You just leaked mdesc here.

Audit all your error paths.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

