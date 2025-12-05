Return-Path: <kvm+bounces-65341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 76237CA7249
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 11:26:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7E10B301B481
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 10:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A986320CAD;
	Fri,  5 Dec 2025 10:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f8y1kPFY";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BB46jHb4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB59622FDFF
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 10:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764930226; cv=none; b=Lh2OVBtUXyoJ4IOfk6rhTplkQyQKluW1u4+wjmy/VokpGA2KuJJT66yIAoD6Jd5t20AixfUREa/phV9a41qCZlTSUvU1ZK2r3sQ+UOWaNIr4IFBPbBZq79qGoZ3egBKhBRIjCMt7mpecNxZVbCOzDHEYyNtvOibWBjQhdolQMnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764930226; c=relaxed/simple;
	bh=pwhFHjvbxOJ6MCXdhz6if7uY6B/UT86ioPoRTaBLukY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ObYEFqvKDoefCtyFLtIOHeQqbfL9PnxqKmusYJvJKLrvi1ZjoyeLsicIYHusJ5bAC25+EUqrENLhnzla1HQls/yBvp1vweFXGPj9othKxkXn0XV21EO5cragTSQsvCVE2Y4Sa9HkuyTddlCD1IpRNC98HNADaI3gSj9eK/OlOLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f8y1kPFY; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BB46jHb4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764930216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6xW6jefNHPNF0bpweUbMnSI3U9B7pAKO05hs1H2bEbQ=;
	b=f8y1kPFYqIognz7P+Q5tKGf+bRrJG5FsPdDPLgrJv4p+0mrngRl4HFba0J/CLbVSwm240K
	sNggmoaJbMni6CY50tuu2oZQzwWrsTR7zyeY7X/uF2SrqcO2cx17P82KkNNjNFd5ARQkSf
	rGQ0f42xuZYCxiyKNlqpvGURyHxbqy8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-vFTdPiGXNlyWO9D_j_EKXg-1; Fri, 05 Dec 2025 05:23:33 -0500
X-MC-Unique: vFTdPiGXNlyWO9D_j_EKXg-1
X-Mimecast-MFC-AGG-ID: vFTdPiGXNlyWO9D_j_EKXg_1764930212
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-42b5556d80bso1890977f8f.2
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 02:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764930212; x=1765535012; darn=vger.kernel.org;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=6xW6jefNHPNF0bpweUbMnSI3U9B7pAKO05hs1H2bEbQ=;
        b=BB46jHb4HogsoGqVSNkfbXIa3P6Iwuu36gdj8zUv2XgilSMQMOo5FaC2h+hPk8TqZH
         xsCIECk5Mv3tVQcrbSM4MlcoxTLPkpKzaPTdoUp5NeY2j9jNyFOKUrVF2wOUL646KLrT
         nCnbek5zQMiTdvi4duhYSoNt9v8LUeTr8MQ32T4BT7ZxvUhZT5s4D1YEhk6LeZZ09h1b
         aP02HETqUTfNIACscIyrxUNXFu6tpHpHursZXq/2lFjpGD1Caaz1nGWStw5EaBPOGQKP
         mSBJ3G0UxCzk5Qb5/46WfqowX8UM3vkyVMEn7ofunuOEYB7aeF0qeEof9HPUg3SMa+kh
         nRTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764930212; x=1765535012;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6xW6jefNHPNF0bpweUbMnSI3U9B7pAKO05hs1H2bEbQ=;
        b=d+7UluqEbIWqzMLp0lnGiilozWol+4t7BNqr4X4fBFGRzTOtfIAtPRVnNMgWashr21
         GmKAKrS0LI76wEPMrouM1yXfzpXD/J/BoVcpr0P/0KaU8Z6fkMhbBpZqmgmqtRrgYOJ4
         1hWF2uvdblxlwms6OquJg/gKW2YvxRSQmPTJ2g1E0sXZL2nmvsxFK9J5WtSg2H12UewZ
         Binf5EYH4xREgBb/I4PfMiI0ImSGgPYo1wOorS1MuzVmcndXPjNQZSqPVLY79o/NOtDU
         VbKGdjSOlZigbF91mkp2sVr+YXeVB+soNEsL9UqPymRwNKNAFSpFBr4y4/k2lFDnBhEb
         WCIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUturGlyOetzuIJajds1gCOry6jfYrxCzEdmtjFPjh+bfW4IfVtEl9c4+KFQxIkJ35yMAI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyN5c0eWRUQ41kTTex+No52v/dlFJGDTFoeKAC7FzBiX9ld4mVL
	eFDZ8rvdxoEUvWhzvnNQRSNRWSGCBPs2+p6nmNzVfMT2SW5jFCGeLs7kCFmJBvJQeeychQALkK0
	WG2F0Bsoks/nOiCLFxGlOSWTEKPtXYN6rqxMOM1yOXLFs3LQVe2uQrw==
X-Gm-Gg: ASbGncu43vyXk4aAgCfmTODNLVASf0+vFNMqa/EsXinPAk4Nk9d3SH1OlAqvpP2xlLE
	ZaA1D3DOvji1opPwUmvQyR0QRtCgZap4FmRWKvTjPmY+WMsezPBn/363h9eIOkNo8lDP2p1bE+e
	3a14oOw2qT8czlp7umAfLV7v1WdBTP1OFkjaDU+FHlyFVBaTxmCKM1iBCt7FsOzMwIyeTvlf+fb
	W+CDBQfroC4nVegCc0typuOp1sHtdo9nQw0LVfX2l6HfCMJtER4XR/zT31en07yiHNdnjixwFv1
	KwZPMb+lf6ziZW1Vmjym6ykcczpaKpYWV0Ns8khNm1A2YuKsa4dwZlWJrRnchHgom0sv72vqwMw
	5ksLeCw==
X-Received: by 2002:a05:6000:40c7:b0:428:4354:aa26 with SMTP id ffacd0b85a97d-42f79851e8amr6654637f8f.47.1764930211967;
        Fri, 05 Dec 2025 02:23:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHrdOemlWNGUF6CbfSfufhv59m+zQeQwV6PzBv0W7dgch4smDWMT4zUpBoGQijXrByxYlVabg==
X-Received: by 2002:a05:6000:40c7:b0:428:4354:aa26 with SMTP id ffacd0b85a97d-42f79851e8amr6654598f8f.47.1764930211455;
        Fri, 05 Dec 2025 02:23:31 -0800 (PST)
Received: from fedora (g3.ign.cz. [91.219.240.17])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d331e29sm8310163f8f.32.2025.12.05.02.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 02:23:30 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter
 Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 05/10] KVM/x86: Add KVM_MSR_RET_* defines for values 0
 and 1
In-Reply-To: <20251205074537.17072-6-jgross@suse.com>
References: <20251205074537.17072-1-jgross@suse.com>
 <20251205074537.17072-6-jgross@suse.com>
Date: Fri, 05 Dec 2025 11:23:29 +0100
Message-ID: <877bv1kz1a.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Juergen Gross <jgross@suse.com> writes:

> For MSR emulation return values only 2 special cases have defines,
> while the most used values 0 and 1 don't.
>
> Reason seems to be the maze of function calls of MSR emulation
> intertwined with the KVM guest exit handlers, which are using the
> values 0 and 1 for other purposes. This even led to the comment above
> the already existing defines, warning to use the values 0 and 1 (and
> negative errno values) in the MSR emulation at all.
>
> Fact is that MSR emulation and exit handlers are in fact rather well
> distinct, with only very few exceptions which are handled in a sane
> way.
>
> So add defines for 0 and 1 values of MSR emulation and at the same
> time comments where exit handlers are calling into MSR emulation.
>
> The new defines will be used later.
>
> No change of functionality intended.
>
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>  arch/x86/kvm/x86.c |  2 ++
>  arch/x86/kvm/x86.h | 10 ++++++++--
>  2 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e733cb923312..e87963a47aa5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2130,6 +2130,7 @@ static int __kvm_emulate_rdmsr(struct kvm_vcpu *vcpu, u32 msr, int reg,
>  	u64 data;
>  	int r;
>  
> +	/* Call MSR emulation. */
>  	r = kvm_emulate_msr_read(vcpu, msr, &data);
>  
>  	if (!r) {
> @@ -2171,6 +2172,7 @@ static int __kvm_emulate_wrmsr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>  {
>  	int r;
>  
> +	/* Call MSR emulation. */
>  	r = kvm_emulate_msr_write(vcpu, msr, data);
>  	if (!r) {
>  		trace_kvm_msr_write(msr, data);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index f3dc77f006f9..e44b6373b106 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -639,15 +639,21 @@ enum kvm_msr_access {
>  /*
>   * Internal error codes that are used to indicate that MSR emulation encountered
>   * an error that should result in #GP in the guest, unless userspace handles it.
> - * Note, '1', '0', and negative numbers are off limits, as they are used by KVM
> - * as part of KVM's lightly documented internal KVM_RUN return codes.
> + * Note, negative errno values are possible for return values, too.
> + * In case MSR emulation is called from an exit handler, any return value other
> + * than KVM_MSR_RET_OK will normally result in a GP in the guest.
>   *
> + * OK		- Emulation succeeded. Must be 0, as in some cases return values
> + *		  of functions returning 0 or -errno will just be passed on.
> + * ERR		- Some error occurred.
>   * UNSUPPORTED	- The MSR isn't supported, either because it is completely
>   *		  unknown to KVM, or because the MSR should not exist according
>   *		  to the vCPU model.
>   *
>   * FILTERED	- Access to the MSR is denied by a userspace MSR filter.
>   */
> +#define  KVM_MSR_RET_OK			0
> +#define  KVM_MSR_RET_ERR		1
>  #define  KVM_MSR_RET_UNSUPPORTED	2
>  #define  KVM_MSR_RET_FILTERED		3

I like the general idea of the series as 1/0 can indeed be
confusing. What I'm wondering is if we can do better by changing 'int'
return type to something else. I.e. if the result of the function can be
'passed on' and KVM_MSR_RET_OK/KVM_MSR_RET_ERR have one meaning while
KVM_MSR_RET_UNSUPPORTED/KVM_MSR_RET_FILTERED have another, maybe we can
do better by changing the return type to something and then, when the
value needs to be passed on, do proper explicit vetting of the result
(e.g. to make sure only 1/0 pass through)? Just a thought, I think the
series as-is makes things better and we can go with it for now.

-- 
Vitaly


