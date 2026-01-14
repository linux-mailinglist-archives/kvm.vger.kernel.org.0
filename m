Return-Path: <kvm+bounces-68092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F2546D21769
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 22:54:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 469CC3087923
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 21:49:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 266F23A63F7;
	Wed, 14 Jan 2026 21:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L+8GBCpl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714E238E5CC
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 21:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768427362; cv=none; b=qj1k4Z76Xd4J/vtrYrvA4ay/y0CvEjs7a1s5zAWMuzbSaNABnZNOEW6T/7GwUUw0IQ74jmR8O4upR3VhJNpngOmXK8sIq14X/mGmDYy1c+c9cSKTrF6wHAAcldFlr6ADkR14auhiXzgaDcapJRdwNYyawOuQG0CRpcb3yRRzecs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768427362; c=relaxed/simple;
	bh=sYapoanqDNVjmowm3U98DjxSpn0xFT5o0faGgzukwF4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iH3yudjxAJVV1jUs5Nlrf4m2OhIheZA40YVNexyVxGCHFfvlOFl1x9E7hpcfcTT7S2pMYm30ZlGNrwUbJxrMfaGIFMool2eWgg/7dRSjzYPNUclv3z8Bx7KEFp/2Zy51K8KHacaClKimP5/W81ZQFIXqlSUxBQ4kQOn3Pf6/1w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L+8GBCpl; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c66cb671fso158294a91.3
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 13:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768427287; x=1769032087; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Folo1QSQIeNygTDacssAH4wR+caKLjy6AQ6SgfkeFFU=;
        b=L+8GBCpl7G2vn5PBjhhzMcx565hxRrte5GPW1pAkaZ6hbKDTr7sTqxDncMwRxXQdgn
         mHRYxcoIKD7K5NR7VTwI+pVd7rn/eFPSBlwo2eAXr+/CQTYJlbI+QmdyyoysIC1LikTZ
         RxIP86AZqx83lRGc+iSKz6emnB9hqdBVXdDNzySyWG+c9CN8T85G1xAvtr8FP04l8wis
         kQEuSQVAvW4HuaRQmx4t0Jh8DwL4DUbKVse+83CUEwNLeDh9QUmgFwrkhYWGsICK7KE9
         mR4FXP9ZeIYrcHPeC3OGiDRffijr3WUNJ2Nt62+IEfOv0bDD4ynnuXh2GGz7FOh7kWxX
         FtjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768427287; x=1769032087;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Folo1QSQIeNygTDacssAH4wR+caKLjy6AQ6SgfkeFFU=;
        b=P9/qWDtQ7oqgGOgNWuctlGWOB4zRecYkzFOb7IXNhDLpWYwMSfOgYHxfwaB8+9iipj
         kDUEune//8FN9ma09Vq1dZZFDEC4etyLhRtILbgAm/w3NXXgso+Bph5sPhk73SNHQ6hq
         RcYWdgnVQUlmY/UhmLNrSR0hnd9d5w3G9vYwli/dQbUq4ZEUvBUwaYN68TMsCAOrwwv0
         nhdH3Ry3+JoZ/+X6B+AFk/doRb88zuwUTUuIf4YmUsn4e4HxXrOaniy/KxrBPOxE83cw
         aAH5n3IrHjBBSx+bBq36h7xSSkpwDdSQSJSSr3OfKicOAUf/DQcvAPS+jSdC/tHP3xHU
         aY3A==
X-Forwarded-Encrypted: i=1; AJvYcCW+iVqq7/BbbiibuKFsRh4rK/v6F1B26bsT2+sfhMsCLcDH6WKpJ9a8Zb2dnPnEoEL/Iw0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYEKdbP2ZeOilNp6n/hRGpJPl7cqwsvkOmpuSDH7HpkpvVIRwk
	fvAG8kOGQq+TB+VNzeMxS0xz9gapAAO4X+kNG3l160E2T3244ftOmyGJEpgGC7MdBS8Q8jRkAKE
	uJdMMxg==
X-Received: from pjso10.prod.google.com ([2002:a17:90a:c08a:b0:349:3867:ccc1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:57ed:b0:340:c060:4d44
 with SMTP id 98e67ed59e1d1-351090b100fmr3848862a91.14.1768427286993; Wed, 14
 Jan 2026 13:48:06 -0800 (PST)
Date: Wed, 14 Jan 2026 13:48:05 -0800
In-Reply-To: <aWe8zESCJ0ZeAOT3@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260114003015.1386066-1-sagis@google.com> <43a0558a-4cca-4d9c-97dc-ffd085186fd9@intel.com>
 <aWe8zESCJ0ZeAOT3@google.com>
Message-ID: <aWgPFQOQRr3xcMjh@google.com>
Subject: Re: [PATCH] KVM: TDX: Allow userspace to return errors to guest for MAPGPA
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Sagi Shahar <sagis@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Thomas Gleixner <tglx@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	Vishal Annapurve <vannapurve@google.com>, Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"

+Mike

On Wed, Jan 14, 2026, Sean Christopherson wrote:
> On Wed, Jan 14, 2026, Xiaoyao Li wrote:
> > On 1/14/2026 8:30 AM, Sagi Shahar wrote:
> > So it needs to be
> > 
> > 	if (vcpu->run->hypercall.ret == -EBUSY)
> > 		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
> > 	else
> > 		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
> 
> No, because assuming everything except -EBUSY translates to
> TDVMCALL_STATUS_INVALID_OPERAND paints KVM back into the same corner its already
> in.  What I care most about is eliminating KVM's assumption that a non-zero
> hypercall.ret means TDVMCALL_STATUS_INVALID_OPERAND.
> 
> For the new ABI, I see two options:
> 
>  1. Translate -errno as done in this patch.
>  2. Propagate hypercall.ret directly to the TDVMCALL return code, i.e. let
>     userspace set any return code it wants.
> 
> #1 has the downside of needing KVM changes and new uAPI every time a new return
> code is supported.
> 
> #2 has the downside of preventing KVM from establishing its own ABI around the
> return code, and making the return code vendor specific.  E.g. if KVM ever wanted
> to do something in response to -EBUSY beyond propagating the error to the guest,
> then we can't reasonably do that with #2.
> 
> Whatever we do, I want to change snp_complete_psc_msr() and snp_complete_one_psc()
> in the same patch, so that whatever ABI we establish is common to TDX and SNP.
> 
> See also https://lore.kernel.org/all/Zn8YM-s0TRUk-6T-@google.com.

Aha!  Finally.  I *knew* we had discussed this more recently.  The SNP series to
add KVM_EXIT_SNP_REQ_CERTS uses a similar pattern.  Note its intentional use of
positive values, because that's what userspace sees in errno.  This code should
do the same.  Oh, and we need to choose between EAGAIN and EBUSY...

	switch (READ_ONCE(vcpu->run->snp_req_certs.ret)) {
	case 0:
		return snp_handle_guest_req(svm, control->exit_info_1,
					    control->exit_info_2);
	case ENOSPC:
		vcpu->arch.regs[VCPU_REGS_RBX] = vcpu->run->snp_req_certs.npages;
		return snp_req_certs_err(svm, SNP_GUEST_VMM_ERR_INVALID_LEN);
	case EAGAIN:
		return snp_req_certs_err(svm, SNP_GUEST_VMM_ERR_BUSY);
	case EIO:
		return snp_req_certs_err(svm, SNP_GUEST_VMM_ERR_GENERIC);
	default:
		break;
	}


https://lore.kernel.org/all/20260109231732.1160759-2-michael.roth@amd.com

