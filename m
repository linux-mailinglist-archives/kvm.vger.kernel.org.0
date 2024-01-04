Return-Path: <kvm+bounces-5633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 07971823FFF
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 11:58:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8C106B2389D
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 10:58:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A250C210E8;
	Thu,  4 Jan 2024 10:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nx4cPqwW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qJfs4+dt";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nx4cPqwW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qJfs4+dt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745A320DDD;
	Thu,  4 Jan 2024 10:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 538B81F801;
	Thu,  4 Jan 2024 10:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1704365911; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6FWhN0ERbLuq8LWOeEYEp5w2T8EZulnYOzaESG0ouas=;
	b=nx4cPqwWT06+c71Bp/tUfL1DFD8Wk6I4/6fpmoH4DBiyiep8bQJGW6hBB4I/4jW9A9o7Ib
	59Lb8BOdJEEvkK4V95KL9K9/DJ9aEZQXaEskNLpPLFmodzCIyLKtHbiwwygkCNqzTd6PTt
	b+DSumKZ54Ov8JK5BwiwP+iAQbHuptE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1704365911;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6FWhN0ERbLuq8LWOeEYEp5w2T8EZulnYOzaESG0ouas=;
	b=qJfs4+dtTrWOHQYruY68fbWEBOy6QjIbgBt7eWJbCC4ghP4mAVTyV6hmwusl3PEdNRfDIC
	GH5GDXnN/9zhwsDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1704365911; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6FWhN0ERbLuq8LWOeEYEp5w2T8EZulnYOzaESG0ouas=;
	b=nx4cPqwWT06+c71Bp/tUfL1DFD8Wk6I4/6fpmoH4DBiyiep8bQJGW6hBB4I/4jW9A9o7Ib
	59Lb8BOdJEEvkK4V95KL9K9/DJ9aEZQXaEskNLpPLFmodzCIyLKtHbiwwygkCNqzTd6PTt
	b+DSumKZ54Ov8JK5BwiwP+iAQbHuptE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1704365911;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6FWhN0ERbLuq8LWOeEYEp5w2T8EZulnYOzaESG0ouas=;
	b=qJfs4+dtTrWOHQYruY68fbWEBOy6QjIbgBt7eWJbCC4ghP4mAVTyV6hmwusl3PEdNRfDIC
	GH5GDXnN/9zhwsDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 76DC213722;
	Thu,  4 Jan 2024 10:58:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Uy/HG1aPlmVJewAAD6G6ig
	(envelope-from <jroedel@suse.de>); Thu, 04 Jan 2024 10:58:30 +0000
Date: Thu, 4 Jan 2024 11:58:29 +0100
From: Joerg Roedel <jroedel@suse.de>
To: Michael Roth <michael.roth@amd.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
	linux-mm@kvack.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
	pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
	jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
	slp@redhat.com, pgonda@google.com, peterz@infradead.org,
	srinivas.pandruvada@linux.intel.com, rientjes@google.com,
	tobin@ibm.com, bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
	ak@linux.intel.com, tony.luck@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com
Subject: Re: [PATCH v1 03/26] iommu/amd: Don't rely on external callers to
 enable IOMMU SNP support
Message-ID: <ZZaPVW1RX6n2imok@suse.de>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-4-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231230161954.569267-4-michael.roth@amd.com>
X-Spam-Level: 
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -1.43
X-Spamd-Result: default: False [-1.43 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 BAYES_HAM(-0.13)[67.42%];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 R_RATELIMIT(0.00)[to_ip_from(RLx9ywf34oiqgwhbk19yaj1om5)];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCPT_COUNT_TWELVE(0.00)[37];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Flag: NO

On Sat, Dec 30, 2023 at 10:19:31AM -0600, Michael Roth wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Currently the expectation is that the kernel will call
> amd_iommu_snp_enable() to perform various checks and set the
> amd_iommu_snp_en flag that the IOMMU uses to adjust its setup routines
> to account for additional requirements on hosts where SNP is enabled.
> 
> This is somewhat fragile as it relies on this call being done prior to
> IOMMU setup. It is more robust to just do this automatically as part of
> IOMMU initialization, so rework the code accordingly.
> 
> There is still a need to export information about whether or not the
> IOMMU is configured in a manner compatible with SNP, so relocate the
> existing amd_iommu_snp_en flag so it can be used to convey that
> information in place of the return code that was previously provided by
> calls to amd_iommu_snp_enable().
> 
> While here, also adjust the kernel messages related to IOMMU SNP
> enablement for consistency/grammar/clarity.
> 
> Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Co-developed-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Acked-by: Joerg Roedel <jroedel@suse.de>

-- 
Jörg Rödel
jroedel@suse.de

SUSE Software Solutions Germany GmbH
Frankenstraße 146
90461 Nürnberg
Germany

(HRB 36809, AG Nürnberg)
Geschäftsführer: Ivo Totev, Andrew Myers, Andrew McDonald, Boudien Moerman


