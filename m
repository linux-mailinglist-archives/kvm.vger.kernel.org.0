Return-Path: <kvm+bounces-71178-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YE+CAKG/lGkBHgIAu9opvQ
	(envelope-from <kvm+bounces-71178-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 20:21:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 913E914F963
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 20:21:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 147A8305040A
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 19:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40A1F2D29B7;
	Tue, 17 Feb 2026 19:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Agsp8DWo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A50B264A97
	for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 19:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771356027; cv=none; b=fO0XItRdtt3ByV5RmnvbjdKlGPEkFolKOssTOaJnhKciaePDJKKj+JdDis19493OKwzn/nsL9fW6deM3XQD6laVeziapBdKQd1BHJHL1GQcadFciHd2KErW5gK4o9gETI4r+yFypnoJsZ3x1MoeZLFlBWKHFaqxUbOWcZY1en+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771356027; c=relaxed/simple;
	bh=Vv3QMpSIcWnjWa0xaJUaOqm9MHPLlXF/eFco6dBpQTQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nEzVIvTf+Lw2RVL1Ml5UvQKyDl27ygEG+hLNS5fAKGryzrQ+MNAt+p7YphmjGR2UIp5UklXghsDz6urynDCBZwTzN8wniB0A0PU9G4O47obUS1YzeyEI/EdWE0dxN0RfBgotrmf0vusNQmUbtbdFtkpSwH65leObVzgyduOK6zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Agsp8DWo; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35641c14663so5294270a91.2
        for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 11:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771356026; x=1771960826; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1eH/mwAkqLmfyEh1EvqsNY2VkqyRMUhzopmOJ1U3e7Q=;
        b=Agsp8DWoYDyAr+ruQM2isfkX6IjXJwrQd9z+vquO5xYRioNzxAX7LdDqXfjYQ9vvN3
         S3QZ6x9P9FiEsT0cGDoWjqAKARb9SN7D4OolZfEJTDKTcjl2ZFw1gvG3hknrAcKMKUlN
         1Vf5XrhFZn4UyhNuqyNjxqE+KNIxYrJoEsbjTFENtSRs3/nxcZpGhLzjg8xXSh06zsgG
         bHIyG8xFxP3GkfzOFnnP+mEwPVWP34FcQsQboBdLec4d2fGaVpgW8D7JMqIm1Y5clPHy
         vPX3ubZBBxOm3OXxaQfFCWMxIwoVgJyLyfet5pQGod3BPHOMFvs3DiRkXH+3BQbzYTCv
         PySA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771356026; x=1771960826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1eH/mwAkqLmfyEh1EvqsNY2VkqyRMUhzopmOJ1U3e7Q=;
        b=gTrED94dN2RrJRsXq9mv5EwVbkjmsROIn1uMPfg7vhLmgv3SCKDkaItgLHLF6190ls
         4TFxnYgq1ZVMoA7gPpk3j0zTiIxmuQBSgBNleMkt/xA0rRmNPbooFiyYrO48NaQasleL
         F6Tk7ekexXdCuYOxgFkAPRIBv8taDLeMMIynHSBHwTck++IawXSmxLe1YKPNoAF0SXw1
         xWaEhkIRAyKNWaOq8Ag37TRdyzk5htLpj1sfUbpRIxgzDWu1vrLVna4Hg/sMbOieCeFw
         5ehiqg2a+nXyuLeOSPZD4uFE6ni2VpcSfXeZDehOMcZVbHNfFFK4vDvVKzgH7i9EdhSd
         cdkw==
X-Forwarded-Encrypted: i=1; AJvYcCUlnK7Q6/XHYmFt/TNRA/HZE//ONzjMiioJEy7Fb/M/oeRLg+sboAAXcnu+u7hnZQoJlGI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyxbq57W4hquRLupxdENwXytkA85RK1yoGORw7tZfN1fsuPxXj0
	1EqIkGaLC4uzUICM5BLd6zn1ekdGoQqy6mAbT4ZkkTV/1g290Xgb+lF09wfLIpAEgsselOay2YP
	IFtSEMg==
X-Received: from pjbmd6.prod.google.com ([2002:a17:90b:23c6:b0:352:f162:7d9f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c8a:b0:34a:9d9a:3f67
 with SMTP id 98e67ed59e1d1-356aad7eacemr12756476a91.33.1771356025579; Tue, 17
 Feb 2026 11:20:25 -0800 (PST)
Date: Tue, 17 Feb 2026 19:20:24 +0000
In-Reply-To: <20260217191635.swit2awsmwrj57th@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260206222829.3758171-1-sagis@google.com> <20260206222829.3758171-2-sagis@google.com>
 <20260217180511.rvgsx7y45xfmrxvz@amd.com> <037084a1-2019-4bd2-b1ed-7f34f9128e37@amd.com>
 <20260217191635.swit2awsmwrj57th@amd.com>
Message-ID: <aZS_ePUyLcTyZ4Am@google.com>
Subject: Re: [PATCH v3 1/2] KVM: TDX: Allow userspace to return errors to
 guest for MAPGPA
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, Sagi Shahar <sagis@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	Vishal Annapurve <vannapurve@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71178-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 913E914F963
X-Rspamd-Action: no action

On Tue, Feb 17, 2026, Michael Roth wrote:
> On Tue, Feb 17, 2026 at 12:45:52PM -0600, Tom Lendacky wrote:
> > On 2/17/26 12:05, Michael Roth wrote:
> > >> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > >> index 2d7a4d52ccfb..056a44b9d78b 100644
> > >> --- a/arch/x86/kvm/vmx/tdx.c
> > >> +++ b/arch/x86/kvm/vmx/tdx.c
> > >> @@ -1186,10 +1186,21 @@ static void __tdx_map_gpa(struct vcpu_tdx *tdx);
> > >>  
> > >>  static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
> > >>  {
> > >> +	u64 hypercall_ret = READ_ONCE(vcpu->run->hypercall.ret);
> > >>  	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > >>  
> > >> -	if (vcpu->run->hypercall.ret) {
> > >> -		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
> > >> +	if (hypercall_ret) {
> > >> +		if (hypercall_ret == EAGAIN) {
> > >> +			tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
> > >> +		} else if (vcpu->run->hypercall.ret == EINVAL) {
> > >> +			tdvmcall_set_return_code(
> > >> +				vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
> > >> +		} else {
> > >> +			WARN_ON_ONCE(
> > >> +				kvm_is_valid_map_gpa_range_ret(hypercall_ret));
> > >> +			return -EINVAL;
> > >> +		}
> > >> +
> > >>  		tdx->vp_enter_args.r11 = tdx->map_gpa_next;
> > >>  		return 1;
> > >>  	}
> > > 
> > > Maybe slightly more readable?
> > > 
> > >     switch (hypercall_ret) {
> > >     case EAGAIN:
> > >         tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
> > >         /* fallthrough */
> > 
> > I think you want a break here, not a fallthrough, so that you don't set
> > the return code twice with the last one not being correct for EAGAIN.
> 
> Doh, thanks for the catch. I guess a break for the EINVAL case as well would
> be more consistent then.
> 
>     switch (hypercall_ret) {
>     case EAGAIN:
>         tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
>         break;
>     case EINVAL:
>         tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
>         break;
>     case 0:
>         break;
>     case default:
>         WARN_ON_ONCE(kvm_is_valid_map_gpa_range_ret(hypercall_ret));
>         return -EINVAL;
>     }
>   
>     tdx->vp_enter_args.r11 = tdx->map_gpa_next;
>     return 1;

Heh, except then KVM will fail to handle the next chunk on success.  I like the
idea of a switch statement, so what if we add that and dedup the error handling?

static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
{
	u64 hypercall_ret = READ_ONCE(vcpu->run->hypercall.ret);
	struct vcpu_tdx *tdx = to_tdx(vcpu);
	long rc;

	switch (hypercall_ret) {
	case 0:
		break;
	case EAGAIN:
		rc = TDVMCALL_STATUS_RETRY;
		goto propagate_error;
	case EINVAL:
		rc = TDVMCALL_STATUS_INVALID_OPERAND;
		goto propagate_error;
	default:
		WARN_ON_ONCE(kvm_is_valid_map_gpa_range_ret(hypercall_ret));
		return -EINVAL;
	}

	tdx->map_gpa_next += TDX_MAP_GPA_MAX_LEN;
	if (tdx->map_gpa_next >= tdx->map_gpa_end)
		return 1;

	/*
	 * Stop processing the remaining part if there is a pending interrupt,
	 * which could be qualified to deliver.  Skip checking pending RVI for
	 * TDVMCALL_MAP_GPA, see comments in tdx_protected_apic_has_interrupt().
	 */
	if (kvm_vcpu_has_events(vcpu)) {
		rc = TDVMCALL_STATUS_RETRY;
		goto propagate_error;
	}

	__tdx_map_gpa(tdx);
	return 0;

propagate_error:
	tdvmcall_set_return_code(vcpu, rc);
	tdx->vp_enter_args.r11 = tdx->map_gpa_next;
	return 1;
}

