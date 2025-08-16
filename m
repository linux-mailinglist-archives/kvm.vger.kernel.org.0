Return-Path: <kvm+bounces-54828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8315B28C60
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 11:30:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C93A3B56CB
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 09:30:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 947A0634;
	Sat, 16 Aug 2025 09:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="OTg6XfFH"
X-Original-To: kvm@vger.kernel.org
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CFA2288D5;
	Sat, 16 Aug 2025 09:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755336627; cv=none; b=D0MnIXJ31cu1U8xyl7yVsgh/58gDR6GCMwxhU+PNoKxB8PrQBzqX15fMrVWDYzAbDQEliLagXBmmkvcq7S2WSUE53mLg4xlPyiKQxai9tdODuvIMMZJ7rxaxk5UkQIHILSR/7pLlQmyUO0dte8rs6JDCOrJzPjG0l7UTOMOabEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755336627; c=relaxed/simple;
	bh=ZMB0T7WyZDc/KYFhxhYAA5BbOcLSc9wwrxrSkbS/0Do=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nUbQuqfOaCyyzICyqn/HZsBbvLQHE+QfaoG/gRB9TqHtM4csGJ3xsXhjmNVeG/j5T6Br329H0i0r7EGXkI7uHnmhTvBJjYvZ1D2xMnlQ/tA1vguIP2Va6WXJACDEpKOadUf5c4ZEGiQvzA1Em8JLtDF0JDLi+4x7DCuOdhYRXBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=OTg6XfFH; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=d9UixZd+ywiMt91Do8+cl23FuTfwWnP+omo1gMjpILA=; b=OTg6XfFHsfjrOZ3hD6wVssqj7J
	qtHjXlVWv7mLQHNATuNhigGzBgckLqiJdQuL6VLbE0GDh7nM/HeMsVP+F3NC8c2HoIwb+E52yIesU
	SxFQNjMe6VXPPRs8nLgowDNq/t6h9dGR372SSbaCX23Gik1N1S7lP8q57jgZsy3VUEls347mmpmPr
	lHdHTN4rpMxkTpDh8Iw4ySU5ZD+TvyCucEaTE3us9yzeCF3w9kYMK1T8spF132iDtfKIX5rdvX48D
	E4Cjj0/Dy5g7OLg10UGz3TXTUOojkmNDePIkwaMcCGuetn4dA4zm7Y5SpH+Hor3dociAiRQLCfTH5
	Bsh0V33A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1unCz2-00EmIs-25;
	Sat, 16 Aug 2025 17:29:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 16 Aug 2025 17:29:49 +0800
Date: Sat, 16 Aug 2025 17:29:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: corbet@lwn.net, seanjc@google.com, pbonzini@redhat.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	thomas.lendacky@amd.com, john.allen@amd.com, davem@davemloft.net,
	akpm@linux-foundation.org, rostedt@goodmis.org, paulmck@kernel.org,
	nikunj@amd.com, Neeraj.Upadhyay@amd.com, aik@amd.com,
	ardb@kernel.org, michael.roth@amd.com, arnd@arndb.de,
	linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 0/7] Add SEV-SNP CipherTextHiding feature support
Message-ID: <aKBPjfyIHMc2X_ZL@gondor.apana.org.au>
References: <cover.1752869333.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1752869333.git.ashish.kalra@amd.com>

On Mon, Jul 21, 2025 at 02:12:15PM +0000, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Ciphertext hiding prevents host accesses from reading the ciphertext
> of SNP guest private memory. Instead of reading ciphertext, the host
> will see constant default values (0xff).
> 
> The SEV ASID space is split into SEV and SEV-ES/SNP ASID ranges.
> Enabling ciphertext hiding further splits the SEV-ES/SEV-SNP ASID space
> into separate ASID ranges for SEV-ES and SEV-SNP guests.
> 
> Add new module parameter to the KVM module to enable ciphertext hiding
> support and a user configurable system-wide maximum SNP ASID value. If
> the module parameter value is "max" then the complete SEV-ES/SEV-SNP
> space is allocated to SEV-SNP guests.
> 
> v7:
> - Fix comments.
> - Move the check for module parameter ciphertext_hiding_asids inside
> check_and_enable_sev_snp_ciphertext_hiding(), this keeps all the logic
> related to the parameter in a single function.
> 
> v6:
> - Fix module parameter ciphertext_hiding_asids=0 case.
> - Coalesce multiple cases of handling invalid module parameter
> ciphertext_hiding_asids into a single branch/label.
> - Fix commit logs.
> - Fix Documentation.
> 
> v5:
> - Add pre-patch to cache SEV platform status and use this cached
> information to set api_major/api_minor/build.
> - Since the SEV platform status and SNP platform status differ, 
> remove the state field from sev_device structure and instead track
> SEV platform state from cached SEV platform status.
> - If SNP is enabled then cached SNP platform status is used for 
> api_major/api_minor/build.
> - Fix using sev_do_cmd() instead of __sev_do_cmd_locked().
> - Fix commit logs.
> - Fix kernel-parameters documentation. 
> - Modify KVM module parameter to enable CipherTextHiding to support
> "max" option to allow complete SEV-ES+ ASID space to be allocated
> to SEV-SNP guests.
> - Do not enable ciphertext hiding if module parameter to specify
> maximum SNP ASID is invalid.
> 
> v4:
> - Fix buffer allocation for SNP_FEATURE_INFO command to correctly
> handle page boundary check requirements.
> - Return correct length for SNP_FEATURE_INFO command from
> sev_cmd_buffer_len().
> - Switch to using SNP platform status instead of SEV platform status if
> SNP is enabled and cache SNP platform status and feature information.
> Modify sev_get_api_version() accordingly.
> - Fix commit logs.
> - Expand the comments on why both the feature info and the platform
> status fields have to be checked for CipherTextHiding feature 
> detection and enablement.
> - Add new preperation patch for CipherTextHiding feature which
> introduces new {min,max}_{sev_es,snp}_asid variables along with
> existing {min,max}_sev_asid variable to simplify partitioning of the
> SEV and SEV-ES+ ASID space.
> - Switch to single KVM module parameter to enable CipherTextHiding
> feature and the maximum SNP ASID usable for SNP guests when 
> CipherTextHiding feature is enabled.
> 
> v3:
> - rebase to linux-next.
> - rebase on top of support to move SEV-SNP initialization to
> KVM module from CCP driver.
> - Split CipherTextHiding support between CCP driver and KVM module
> with KVM module calling into CCP driver to initialize SNP with
> CipherTextHiding enabled and MAX ASID usable for SNP guest if
> KVM is enabling CipherTextHiding feature.
> - Move module parameters to enable CipherTextHiding feature and
> MAX ASID usable for SNP guests from CCP driver to KVM module
> which allows KVM to be responsible for enabling CipherTextHiding
> feature if end-user requests it.
> 
> v2:
> - Fix and add more description to commit logs.
> - Rename sev_cache_snp_platform_status_and_discover_features() to 
> snp_get_platform_data().
> - Add check in snp_get_platform_data to guard against being called
> after SNP_INIT_EX.
> - Fix comments for new structure field definitions being added.
> - Fix naming for new structure being added.
> - Add new vm-type parameter to sev_asid_new().
> - Fix identation.
> - Rename CCP module parameters psp_cth_enabled to cipher_text_hiding and 
> psp_max_snp_asid to max_snp_asid.
> - Rename max_snp_asid to snp_max_snp_asid. 
> 
> Ashish Kalra (7):
>   crypto: ccp - New bit-field definitions for SNP_PLATFORM_STATUS
>     command
>   crypto: ccp - Cache SEV platform status and platform state
>   crypto: ccp - Add support for SNP_FEATURE_INFO command
>   crypto: ccp - Introduce new API interface to indicate SEV-SNP
>     Ciphertext hiding feature
>   crypto: ccp - Add support to enable CipherTextHiding on SNP_INIT_EX
>   KVM: SEV: Introduce new min,max sev_es and sev_snp asid variables
>   KVM: SEV: Add SEV-SNP CipherTextHiding support
> 
>  .../admin-guide/kernel-parameters.txt         |  18 +++
>  arch/x86/kvm/svm/sev.c                        |  96 +++++++++++--
>  drivers/crypto/ccp/sev-dev.c                  | 127 ++++++++++++++++--
>  drivers/crypto/ccp/sev-dev.h                  |   6 +-
>  include/linux/psp-sev.h                       |  44 +++++-
>  include/uapi/linux/psp-sev.h                  |  10 +-
>  6 files changed, 274 insertions(+), 27 deletions(-)
> 
> -- 
> 2.34.1

Patches 1-5 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

