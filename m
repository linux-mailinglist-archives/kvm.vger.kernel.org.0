Return-Path: <kvm+bounces-17467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FF508C6E5E
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 00:02:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B8F51F242B2
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 22:02:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E2215B576;
	Wed, 15 May 2024 22:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fn3ZfncV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5838A3BBEA;
	Wed, 15 May 2024 22:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715810548; cv=none; b=esXow1DpnC5/w7v+Nsm76csOThpG4eiIsEOfhQuYTGvDwq/FWPIfFYNxsxLvNM6SXO+PcE5IIqLG05Bf6PTvwuqjUBSmmFNCeT7Bt0JfcdxrKJeYjS/2y+3+iNPuniHA6mUl64xl9b66hdcr8QNTvjrs/In0OTbWGU3YEjO+mqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715810548; c=relaxed/simple;
	bh=1W2MEncHHKIIZw/gUV3VjWj7F2dfJC8lq475qeKDkvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qxn5zIGjWOVoxAkLzwgJXE6hgI4u7jhvqx6Agbhd1tGLMGj0CNhZZn12ME89NJRKxXSgMmhktiCLSbLL5zL0YYZRj/lJKY3HPY72RIKN7gsvTBECIdRJGSyCK9R7UIWLChcev/1WLjGkWV2jjXBB2k7qzU9azSg7J/0gp3ysX88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fn3ZfncV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83150C116B1;
	Wed, 15 May 2024 22:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715810547;
	bh=1W2MEncHHKIIZw/gUV3VjWj7F2dfJC8lq475qeKDkvA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fn3ZfncVloDqgYu0adTKnRT6ewnofVsEG2vT0WPV5da4/tR46PXWnYOIIKRHZiKDw
	 3OUeYRyG9OP28ObCy5xnIZp6SfmZkErHXvBmt5z4cTskN50V+smTnJiK2dNgt155Qa
	 rXvNlQgcEGnP3q6b2Ud6c8bMRSW8T8Yq/OeVxmGWeMN3TIOjjxch0AaJt5+VzOY51u
	 d9/VHpHCl3nSxecmI5UgL5KJmlKgzAvRdJMmDlszQNla3zcHVcEue5baH/RFB1iHvm
	 cEu+vJ9n7T9vM2O3V5Rf67Hkgp97kxXqLu2+OrFTTgItTNPe4bDGS2/qhZXx7jvbp2
	 Op0gf//ebdfcA==
Date: Wed, 15 May 2024 15:02:25 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>, linux-coco@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] KVM: SEV: Fix uninitialized firmware error code
Message-ID: <20240515220225.GA2014948@thelio-3990X>
References: <20240513172704.718533-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240513172704.718533-1-michael.roth@amd.com>

On Mon, May 13, 2024 at 12:27:04PM -0500, Michael Roth wrote:
> The current code triggers a clang warning due to passing back an
> uninitialized firmware return code in cases where an attestation request
> is aborted before getting sent to userspace. Since firmware has not been
> involved at this point the appropriate value is 0.
> 
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Closes: https://lore.kernel.org/kvm/20240513151920.GA3061950@thelio-3990X/
> Fixes: 32fde9e18b3f ("KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event")
> Signed-off-by: Michael Roth <michael.roth@amd.com>

This obviously resolves the warning:

Tested-by: Nathan Chancellor <nathan@kernel.org> # build

> ---
>  arch/x86/kvm/svm/sev.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 57c2c8025547..59c0d89a4d52 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4048,7 +4048,6 @@ static int snp_begin_ext_guest_req(struct kvm_vcpu *vcpu)
>  	int vmm_ret = SNP_GUEST_VMM_ERR_GENERIC;
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	unsigned long data_npages;
> -	sev_ret_code fw_err;
>  	gpa_t data_gpa;
>  
>  	if (!sev_snp_guest(vcpu->kvm))
> @@ -4075,7 +4074,7 @@ static int snp_begin_ext_guest_req(struct kvm_vcpu *vcpu)
>  	return 0; /* forward request to userspace */
>  
>  abort_request:
> -	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
> +	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, 0));
>  	return 1; /* resume guest */
>  }
>  
> -- 
> 2.25.1
> 

