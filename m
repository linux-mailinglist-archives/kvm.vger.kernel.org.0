Return-Path: <kvm+bounces-10234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AD5486AE5E
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 12:58:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B3741C2034D
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 11:58:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F03AB13DBA4;
	Wed, 28 Feb 2024 11:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="flAekDgF"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031E513A273;
	Wed, 28 Feb 2024 11:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709121075; cv=none; b=N6HQxcUbd8Ite6ClLRncwKXGBRUtkeTETpN8csT+p1FUcF0vrJZqesf/XKOsJO9XQxtOL3ZiR/X9QYKwAK50r9yjlKCE2JPKWLgIQjUUhunSv6ZecXNwwtmo9LqWojYZ0VZR/JhYAuNmbiybU//fven8aP/QVYjqxaquPgPoXTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709121075; c=relaxed/simple;
	bh=FMeKN9BDyggavJHuyRA8YHMcnKK4vNbzviOafAWXkW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oiwUs4hsPphO7HJ1bV3acycZBrr/JgSQL+VaTDIfwjLBcMeNqidukAqo24l4YETNQekDIdQDLw61Qy9D4cefuw/+wKdpo+QKcjWEF+7qdWxo0DgGj3dEdBIkPK6UUG76mTyOkxKjc7DEH9PO3FRseTZ4geItU0JJV5JG1E6WX3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=flAekDgF; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 63E5140E01A2;
	Wed, 28 Feb 2024 11:51:10 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id SlRXKPO_e66g; Wed, 28 Feb 2024 11:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1709121063; bh=2iV8Whwh6rSi//X/ZYELXyfO/45iEmq14sCFrQuQ02k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=flAekDgFJFq0DpW3zFw1DZUzrV6vfaj1R6EzmPiVi96JdG8FQcUUAqWWwo2B60Xld
	 Lebki7QKfxMnrUjUZOj6sTnTGYp79D062qqe91MJlfHsC2ptqvlhmBe2HOaMmiyOgj
	 8LxV/paft/eoeMb2RUyaS8F2IHJxoiXRAWaXBIRwz27avLgyVRQRpd2QXxfVlWii7X
	 L9MoEpBkl5uLa8bX94LL63FwA1RvpepV+i7vTFKyfA4d1onQDxrBwm1d0ZMgOFKnbf
	 XYqgLiXGf9M2B5BZEsTEA/EU0orNX+7/H0XTcNWFPjoMa8bunJz16DpxukkTvEW7WV
	 bcxc3Qs8W6CEzDqM4o8b2GOk+V0tNMryB76wHqoZeB508/lwNwLpyW+RByOMq0IDQU
	 3zVG1BUIdroHdcR7pTZcwXg9FFzaGS+K3g/pNuAHNeHmP3SoQR4WPJVSRl4X6kw6WP
	 JuAJEfWVuho4mpmpdBaq5UlN8KUmfF6E72loRskji1fS/0+/IbEq0Qoy1n/jZhScNN
	 afKTkLkE7dtbjiFzcJPuuKsTWXOEuSVCKRjnwqxIMQcZa/LRNKizMcIUGu+ZS9GUoP
	 ylj2HwBKeenm+h6V46FUxkp9QJ+WCF6hMius4VuEnxdpsWeWW3ALLpF6boL/aTEBTn
	 zLLNdn5yXm05VU7LD8QuJOLs=
Received: from zn.tnic (pd953021b.dip0.t-ipconnect.de [217.83.2.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4D0CF40E016C;
	Wed, 28 Feb 2024 11:50:52 +0000 (UTC)
Date: Wed, 28 Feb 2024 12:50:45 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v8 03/16] virt: sev-guest: Add SNP guest request structure
Message-ID: <20240228115045.GGZd8eFe9WZYmZmIeU@fat_crate.local>
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-4-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240215113128.275608-4-nikunj@amd.com>

On Thu, Feb 15, 2024 at 05:01:15PM +0530, Nikunj A Dadhania wrote:
> +enum aead_algo {

Looks unused.

Add new struct definitions, etc, together with their first user - not
preemptively.

Please audit all your patches.

> +	SNP_AEAD_INVALID,
> +	SNP_AEAD_AES_256_GCM,
> +};
> +
> +struct snp_guest_msg_hdr {
> +	u8 authtag[MAX_AUTHTAG_LEN];
> +	u64 msg_seqno;
> +	u8 rsvd1[8];
> +	u8 algo;
> +	u8 hdr_version;
> +	u16 hdr_sz;
> +	u8 msg_type;
> +	u8 msg_version;
> +	u16 msg_sz;
> +	u32 rsvd2;
> +	u8 msg_vmpck;
> +	u8 rsvd3[35];
> +} __packed;
> +
> +struct snp_guest_msg {
> +	struct snp_guest_msg_hdr hdr;
> +	u8 payload[4000];

What Tom said.

> +} __packed;
> +
> +struct snp_guest_req {
> +	void *req_buf;
> +	size_t req_sz;
> +
> +	void *resp_buf;
> +	size_t resp_sz;
> +
> +	void *data;
> +	size_t data_npages;
> +
> +	u64 exit_code;
> +	unsigned int vmpck_id;
> +	u8 msg_version;
> +	u8 msg_type;
> +};
> +
>  #ifdef CONFIG_AMD_MEM_ENCRYPT
>  extern void __sev_es_ist_enter(struct pt_regs *regs);
>  extern void __sev_es_ist_exit(void);
> @@ -223,7 +288,8 @@ void snp_set_memory_private(unsigned long vaddr, unsigned long npages);
>  void snp_set_wakeup_secondary_cpu(void);
>  bool snp_init(struct boot_params *bp);
>  void __init __noreturn snp_abort(void);
> -int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio);
> +int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
> +			    struct snp_guest_request_ioctl *rio);

Much nicer!

...

> @@ -868,7 +890,6 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>  	/* initial the input address for guest request */

That comment reads wrong - might fix it while here.

>  	snp_dev->input.req_gpa = __pa(snp_dev->request);
>  	snp_dev->input.resp_gpa = __pa(snp_dev->response);
> -	snp_dev->input.data_gpa = __pa(snp_dev->certs_data);

>  
>  	ret = tsm_register(&sev_tsm_ops, snp_dev, &tsm_report_extra_type);
>  	if (ret)

Rest looks ok. I'd chose shorter local vars if I were you but yours are
ok too.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

