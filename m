Return-Path: <kvm+bounces-70615-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6P3CMw8PimlrGAAAu9opvQ
	(envelope-from <kvm+bounces-70615-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 17:45:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 76565112A14
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 17:45:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 68958305C495
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 16:41:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72DEB38551F;
	Mon,  9 Feb 2026 16:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2p3l6JnD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F2E38170F
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 16:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770655265; cv=none; b=lba3AA7HCPrPqEK4PD8uRK/bfzxcxXDNBc3CN/b+zkSzAju8uiWbFFJm098/KHOsoJGA8s7PCnIbI3uZFXrsV28HtdL+Oo/bAtunoiQhWjDEB5+YbUypo93mNY5Oa2F4nisA9VNgV2X64IWys/xfo5DKQT0qo4ythO3WyGnbQA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770655265; c=relaxed/simple;
	bh=yorrzb7NRKtIXt5G2GDhvZgIgQxURMT3QqjSzo+rUa8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N0JcIJtaxTB82fwtidzyqV/SYvs5yGPB7khZU0snUGlW4e1GQR6L4woZWHfE8qcDKufaW751IG83P7BPRHObz0nU4fKa7UyI/9A+C4zgihZAETtgQkpTUNtdQOtL64F5FI0nacEnux/4udryvTGE8q7GUmc23XRx1eiBngzLkoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2p3l6JnD; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2aad5fec175so37597335ad.2
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 08:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770655265; x=1771260065; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EKHOCX1WV2Qxb28cI5D8Ij6jh1+CDP36MN7+6L6pt98=;
        b=2p3l6JnDt56LkZGCfUzhncyRD67KNPvH8+2+z5hOTHYhlL7DGG8u8AII5DSDSZe+XO
         +u99eQb5srdKaNMEA+zcUBrsnz7ZqsrNVr5xnrBVEo4hsoAYQB3zPDqYvJ0cS8Hejhxb
         h9mGBih0cUN1/q76orbH8zMTUzzOb5grFppo3PABnSae5Kj/UHacO1fguUmdERo9GU4f
         oojaaFfOWRlbXToCvXFcshzNtnKvuIu6vUzyRf71intI/dYWLhhioJrUUxzYE2M/6tIc
         9aDTwiw/VFGyg3z205bUkQZX7Ooo9kHr0qQnqWUNeBaIhWqFSdSw0R4twqfuOnnq0Z9Z
         +iwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770655265; x=1771260065;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EKHOCX1WV2Qxb28cI5D8Ij6jh1+CDP36MN7+6L6pt98=;
        b=rEsi27B7tqnyH/VzWOyct49GLUvBCun/WKaygcSXdAVpFf17eUOCH54Mhtbni0bTYa
         PSac1YVIIVHChYFBEEWd/5p7wyWgBPgHVwIh3OMNha1QA/3w44Kmm69iwBX/w9MuGNQH
         zD1KQl7Vmnsc/w5DlHePL/gV5yPbf17lEp9DsKw1bpxoe7imBn7zBNOZ6nZOThdpsFiV
         vRsgzr4lUCejrWoiMG4s1p3sPgIfsdzWi3KChLJ4v6adZnlpR/oWyfmloW0QZAUu5JV+
         NdgywH/PyJewUoNz0K09RZ0i4piGGIar0sHazcqots1/8mEEsfM3t8yB47QU1IvLtu8A
         PtTg==
X-Forwarded-Encrypted: i=1; AJvYcCXaiMfwfzahhE/qff4zufIvAxMhnlcGV6DjSepeLhdkR22lhcYlhDezXgDpJlCuuL+mT18=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaKJrjWFH6mEFxgMTeQ9gzgg70+rZiz8QTCHHlBFowwwOM10LW
	fMwY/s+bz/cWb/NqJSoh/mPhsrG/oxQLDmbtdgJ6NGfZMeJ6IvsJZDvt6Ba9kDajiH4xnB2V7cb
	6G1384A==
X-Received: from plas9.prod.google.com ([2002:a17:903:2009:b0:2aa:d604:fb13])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1a24:b0:2a9:6281:6a48
 with SMTP id d9443c01a7336-2a962816e6dmr93478985ad.44.1770655264923; Mon, 09
 Feb 2026 08:41:04 -0800 (PST)
Date: Mon, 9 Feb 2026 08:41:03 -0800
In-Reply-To: <20260209041305.64906-6-zhiquan_li@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260209041305.64906-1-zhiquan_li@163.com> <20260209041305.64906-6-zhiquan_li@163.com>
Message-ID: <aYoOHzwgxvpZ5Iso@google.com>
Subject: Re: [PATCH RESEND 5/5] KVM: x86: selftests: Fix write MSR_TSC_AUX
 reserved bits test failure on Hygon
From: Sean Christopherson <seanjc@google.com>
To: Zhiquan Li <zhiquan_li@163.com>
Cc: pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70615-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[163.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 76565112A14
X-Rspamd-Action: no action

On Mon, Feb 09, 2026, Zhiquan Li wrote:
> Therefore, the expectation of writing MSR_TSC_AUX reserved bits on Hygon
> CPUs should be:
> 1) either RDTSCP or RDPID is supported case, and both are supported
>    case, expect success and a truncated value, not #GP.
> 2) neither RDTSCP nor RDPID is supported, expect #GP.

That's how Intel and AMD behave as well.  I don't understand why there needs to
be a big pile of special case code for Hygon.  Presumably just fixup_rdmsr_val()
needs to be changed?

> Signed-off-by: Zhiquan Li <zhiquan_li@163.com>
> ---
>  tools/testing/selftests/kvm/x86/msrs_test.c | 26 +++++++++++++++++----
>  1 file changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86/msrs_test.c b/tools/testing/selftests/kvm/x86/msrs_test.c
> index 40d918aedce6..2f1e800fe691 100644
> --- a/tools/testing/selftests/kvm/x86/msrs_test.c
> +++ b/tools/testing/selftests/kvm/x86/msrs_test.c
> @@ -77,11 +77,11 @@ static bool ignore_unsupported_msrs;
>  static u64 fixup_rdmsr_val(u32 msr, u64 want)
>  {
>  	/*
> -	 * AMD CPUs drop bits 63:32 on some MSRs that Intel CPUs support.  KVM
> -	 * is supposed to emulate that behavior based on guest vendor model
> +	 * AMD and Hygon CPUs drop bits 63:32 on some MSRs that Intel CPUs support.
> +	 * KVM is supposed to emulate that behavior based on guest vendor model
>  	 * (which is the same as the host vendor model for this test).
>  	 */
> -	if (!host_cpu_is_amd)
> +	if (!host_cpu_is_amd && !host_cpu_is_hygon)
>  		return want;
>  
>  	switch (msr) {
> @@ -94,6 +94,17 @@ static u64 fixup_rdmsr_val(u32 msr, u64 want)
>  	}
>  }
>  
> +/*
> + * On Hygon processors either RDTSCP or RDPID is supported in the host,
> + * MSR_TSC_AUX is able to be accessed.
> + */
> +static bool is_hygon_msr_tsc_aux_supported(const struct kvm_msr *msr)
> +{
> +	return host_cpu_is_hygon &&
> +			msr->index == MSR_TSC_AUX &&
> +			(this_cpu_has(msr->feature) || this_cpu_has(msr->feature2));

Align indentation, but as above, this shouldn't be necessary.

> +}
> +
>  static void __rdmsr(u32 msr, u64 want)
>  {
>  	u64 val;
> @@ -174,9 +185,14 @@ void guest_test_reserved_val(const struct kvm_msr *msr)
>  	/*
>  	 * If the CPU will truncate the written value (e.g. SYSENTER on AMD),
>  	 * expect success and a truncated value, not #GP.
> +	 *
> +	 * On Hygon CPUs whether or not RDPID is supported in the host, once RDTSCP
> +	 * is supported, MSR_TSC_AUX is able to be accessed.  So, for either RDTSCP
> +	 * or RDPID is supported case and both are supported case, expect
> +	 * success and a truncated value, not #GP.
>  	 */
> -	if (!this_cpu_has(msr->feature) ||
> -	    msr->rsvd_val == fixup_rdmsr_val(msr->index, msr->rsvd_val)) {
> +	if (!is_hygon_msr_tsc_aux_supported(msr) && (!this_cpu_has(msr->feature) ||
> +	    msr->rsvd_val == fixup_rdmsr_val(msr->index, msr->rsvd_val))) {
>  		u8 vec = wrmsr_safe(msr->index, msr->rsvd_val);
>  
>  		__GUEST_ASSERT(vec == GP_VECTOR,
> -- 
> 2.43.0
> 

