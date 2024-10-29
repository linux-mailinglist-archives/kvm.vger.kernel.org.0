Return-Path: <kvm+bounces-29970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 72A429B5141
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 18:44:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3341C282C34
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 17:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2B461D7985;
	Tue, 29 Oct 2024 17:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="FZwPXa1a"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FCA19258A;
	Tue, 29 Oct 2024 17:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730223865; cv=none; b=LPiS2vhro7Ma6CSl80vPYjkkD2puyY9wXO/a+NasGgdRpsfOQszp5zrKOXf0XHEqBq+3z3hbUWeRdRV03LybdcFaYa7LBt3hlZAe8fOwa3zeGy2kSG3RiL5eF+G8ZVva/L8xEjKTRT2sIa0NN2rFdopXU5Y5v78uRkCt95YTicM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730223865; c=relaxed/simple;
	bh=J365I8voCVVs7+QqfpUdraeQTQar+BYCR5lc+7HjVw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i5P8Qo0kCl9nld4jdm4l5NiNev/79IIo4FJ+PSQYX7Vlaz8QWPqd+YRMwsclNh906NETRxXzLtH/FG8w4lPCNnzZuI6oIVsqd+kJpF4Pm6qm5EnlEoWRYaa80HETBuYS/h5pcMi5sKFCNXcWxV121RKQlz8uXZNGYa75vtzVgwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=FZwPXa1a; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8AF5240E01A5;
	Tue, 29 Oct 2024 17:44:19 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id T6BQsndEFnLR; Tue, 29 Oct 2024 17:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1730223854; bh=HR0f1lTZwMqBrosIlrc89Nf1wvTIZfC3xRSgXCnUop4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FZwPXa1a39vgGs2cA6eGp6LoC3ion5mxCurIvBCkGss97+yjpzZR2mmOvywkCjyhD
	 n21aXL3PcQeThpY7js900k8P951/xRbPaUsmyS2ep3F1S/ZYyZg4FkCfccK1ASdJua
	 95hT13X6sS8zQsrJ52nFexi8gIwtqjepehTC2UhbIcQECphoqDKJIyefkX6p57gGTQ
	 ccmyyMmT9pgNgn0PlL5WyMPe6mIBMeNY/HmM28LmDEoeFUlWf5oymX7yXa9tnOm/dh
	 RCpUQq5AtoRSZqTWxPF6e4MJX3PDHr1H7esnLAtzhGSC3bJM90hhBsjL8IwsWLVWXl
	 5C8IRhDAD4Epf76OwMHlSaGtqkd3HxFFwBdlUkaSs0kewkx1IO2EkgjxUKE5W+EkJI
	 vEd5FREV2al0J/kXgiLUO85Tnsa9Ap1rUai7VUnXiNdH3bYacE3Fi1zo7cumz5wiah
	 CQL9rZblE6EbnskJGZjmhWTyxnNqEfESZd23bSs59sYL1+iV+0fQBnWq+2dFMAeh88
	 H4yz6DrrSS0UYsjc0BaGM2SvsExat9A71lMRubN+7EsNfhIEQfNgyM9EFJcRcpUCMz
	 vwIg5WwMOVBTrSoWbG1XDylcBKHZhmH8WeMhUnJMZszj9Uo39vnrbtBQndyTJJboAe
	 sUCMhl28PfbzJbHXrzvas5l4=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id AA2F240E0198;
	Tue, 29 Oct 2024 17:44:03 +0000 (UTC)
Date: Tue, 29 Oct 2024 18:43:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v14 01/13] x86/sev: Carve out and export SNP guest
 messaging init routines
Message-ID: <20241029174357.GWZyEe3VwJr3xYHXoT@fat_crate.local>
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-2-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241028053431.3439593-2-nikunj@amd.com>

On Mon, Oct 28, 2024 at 11:04:19AM +0530, Nikunj A Dadhania wrote:
> Currently, the SEV guest driver is the only user of SNP guest messaging.
> All routines for initializing SNP guest messaging are implemented within
> the SEV guest driver. To add Secure TSC guest support, these initialization
> routines need to be available during early boot.
> 
> Carve out common SNP guest messaging buffer allocations and message
> initialization routines to core/sev.c and export them. These newly added
> APIs set up the SNP message context (snp_msg_desc), which contains all the
> necessary details for sending SNP guest messages.
> 
> At present, the SEV guest platform data structure is used to pass the
> secrets page physical address to SEV guest driver. Since the secrets page
> address is locally available to the initialization routine, use the cached
> address. Remove the unused SEV guest platform data structure.

Do not talk about *what* the patch is doing in the commit message - that
should be obvious from the diff itself. Rather, concentrate on the *why*
it needs to be done.

Imagine one fine day you're doing git archeology, you find the place in
the code about which you want to find out why it was changed the way it 
is now.

You do git annotate <filename> ... find the line, see the commit id and
you do:

git show <commit id>

You read the commit message and there's just gibberish and nothing's
explaining *why* that change was done. And you start scratching your
head, trying to figure out why.

See what I mean?

> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/include/asm/sev.h              |  71 ++++++++-
>  arch/x86/coco/sev/core.c                | 133 +++++++++++++++-
>  drivers/virt/coco/sev-guest/sev-guest.c | 195 +++---------------------
>  3 files changed, 215 insertions(+), 184 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 2e49c4a9e7fe..63c30f4d44d7 100644
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
> @@ -438,6 +436,63 @@ u64 sev_get_status(void);
>  void sev_show_status(void);
>  void snp_update_svsm_ca(void);
>  
> +static inline void free_shared_pages(void *buf, size_t sz)

A function with a generic name exported in a header?!

First of all, why is it in a header?

Then, why isn't it called something "sev_" or so...?

Same holds true for all the below.

> +	unsigned int npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
> +	int ret;
> +
> +	if (!buf)
> +		return;
> +
> +	ret = set_memory_encrypted((unsigned long)buf, npages);
> +	if (ret) {
> +		WARN_ONCE(ret, "failed to restore encryption mask (leak it)\n");
> +		return;
> +	}
> +
> +	__free_pages(virt_to_page(buf), get_order(sz));
> +}

...

> +static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
> +{
> +	struct aesgcm_ctx *ctx;
> +
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
> +	if (!ctx)
> +		return NULL;
> +
> +	if (aesgcm_expandkey(ctx, key, keylen, AUTHTAG_LEN)) {

ld: vmlinux.o: in function `snp_init_crypto':
/home/boris/kernel/2nd/linux/arch/x86/coco/sev/core.c:2700:(.text+0x1fa3): undefined reference to `aesgcm_expandkey'
make[2]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
make[1]: *** [/mnt/kernel/kernel/2nd/linux/Makefile:1166: vmlinux] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:224: __sub-make] Error 2

I'll stop here until you fix those.

Btw, tip patches are done against tip/master - not against the branch they get
queued in.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

