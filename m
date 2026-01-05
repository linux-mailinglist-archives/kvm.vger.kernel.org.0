Return-Path: <kvm+bounces-67065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FF17CF5085
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 18:42:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 567B4301F002
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 17:42:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 785DC331233;
	Mon,  5 Jan 2026 17:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FkZ2XIFL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF7D2FC00C
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 17:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767634941; cv=none; b=rtXg3qXgNomIDd+wsHWkLH0sX9vKGzrUUH0qg+j4411g+r58f7iYLrVM1ouo6ks2Yksm/wY2vEOCEImL7nTR1XoYeUaSTVqVOfU5fpca5isYsqxNF3e+mhI8GND2oCxZR4CPPfv4xvWYS4I1DfUw4XC68ZxXG10DJuNqW5sc8qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767634941; c=relaxed/simple;
	bh=4b6ti+RmgfZJNtUxvbEGFQg50xjmQpryddCzAS0dEKg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oAtdlq1kkTNbsVnmsStrr48TWgnBGpNHZV+spgjTb16zJRtZDz/TdDImi/RXuVgSAXlUAIOA2P/xq5Jv+xe31fZFKkCIuKmo/Zt8uGbcZIwWmvrXRRG7C06Hf9aTVdzFA/uZj2ndBB4KMpC96LpXaDvRsi1MTxjj5DXbo4cSHjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FkZ2XIFL; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7f66686710fso430095b3a.3
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 09:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767634939; x=1768239739; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rhaaoIrpwKmi1popYwImOlBJQVWglr2lIzlwBR1M0gE=;
        b=FkZ2XIFLuD8R5qsX3JCJ3TkHBSO/HYVktpzLkIiNK5smNzfrSgMXrQsq1kqCJWktf4
         EldMlUksSGJRqkTMpxGehoghkukF5BePehnNoJN2jdyc9TnVsUMt9momIPQ2ukGCUBKk
         8QJBwo+cnr4JIZwlEeQlWOJAlIj3vW0vjNf0LWP4xvqGzDjhhfBN/XJ/kNSsZKu9Oo0T
         19Bi3H+w7JBVh8MUWJRZlg83SGWeSh3UOlABZC+wjh3H0h7CNa8uV9AvB4EEdvPlv+zC
         6coj5cfyl2Dp0f353AMzQS3AzVGM3CEPN+3ttGHFoSVsQUpApq1LdItIv1oVy8GJurFv
         IBcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767634939; x=1768239739;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rhaaoIrpwKmi1popYwImOlBJQVWglr2lIzlwBR1M0gE=;
        b=VR2YJ3ovGj/sU3OGNx94IEdJ7q4Rj+AwLANERQi1pq0cVwzI9w0Nm/uUB9WO/Wuagj
         g7R/h6bA7XTo9PJP7Lb7IW0DgwsvdLO36B9JgckVHf8wS181hXVhbKCrNXMV0CDP3LgK
         K55jCuE8VuFPMCkJ378x404HbGANNNx+dNCCrjaPQgE8OYS4ZWg7ThewxCoKhGxEKIPb
         1l+Gmk+Po8BLbkDTuNJ9dtJT6ALkRHSwccmMQVGamoElIaYgB3ZpGT4hlynAMyrZrhGq
         jgk/pMIkWXEaNtmo1yv2K+4iYVNkcFiJMbk/+EwaoWjEh7V98404ROV6YyWQLEBEYax/
         wL3g==
X-Forwarded-Encrypted: i=1; AJvYcCW/LKa4R7a6NIETgZ1e36Zur2g5kYCmkvCMbB2fiB0o3sr6iNjSMBeg5P1jxTPiRWaP5CQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8epEJLh/IWhMThpbGxRP1B1C4s3Rj/y9iAuTOlqZyxES3hQs1
	WrWQp3qNKCZUXWVZM6kpNd0ozxveyTxPfmNHBHDI1G7ICTg1szFzyNifPl5ZZH3ox4GMXWLjdPZ
	VSfbw5w==
X-Google-Smtp-Source: AGHT+IHVQhNdzqxSBDWtZhkY1cbUxdZB6/e/xfSz8pxhB4np55/4r3z1TMMdoc4zF4qbMHXb5rrPeUwWoP0=
X-Received: from pffn21.prod.google.com ([2002:a62:e515:0:b0:7ee:f5f6:a02f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3387:b0:35d:53dc:cb56
 with SMTP id adf61e73a8af0-389822d69d9mr122558637.36.1767634939225; Mon, 05
 Jan 2026 09:42:19 -0800 (PST)
Date: Mon, 5 Jan 2026 09:42:17 -0800
In-Reply-To: <aVSZGRpvMIrmUku1@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230220220.4122282-1-seanjc@google.com> <20251230220220.4122282-3-seanjc@google.com>
 <aVSZGRpvMIrmUku1@intel.com>
Message-ID: <aVv3-V1mXohnyeFK@google.com>
Subject: Re: [PATCH v2 2/2] KVM: nVMX: Remove explicit filtering of
 GUEST_INTR_STATUS from shadow VMCS fields
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xin Li <xin@zytor.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="us-ascii"

On Wed, Dec 31, 2025, Chao Gao wrote:
> On Tue, Dec 30, 2025 at 02:02:20PM -0800, Sean Christopherson wrote:
> >Drop KVM's filtering of GUEST_INTR_STATUS when generating the shadow VMCS
> >bitmap now that KVM drops GUEST_INTR_STATUS from the set of supported
> >vmcs12 fields if the field isn't supported by hardware.
> 
> IIUC, the construction of the shadow VMCS bitmap and fields doesn't reference
> "the set of supported vmcs12 fields".

Argh, right you are.  I assumed init_vmcs_shadow_fields() would already verify
the field is a valid vmcs12 field, at least as a sanity check, but it doesn't.

> So, with the filtering dropped, copy_shadow_to_vmcs12() and
> copy_vmcs12_to_shadow() may access GUEST_INTR_STATUS on unsupported hardware.
> 
> Do we need something like this (i.e., don't shadow unsupported vmcs12 fields)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index f50d21a6a2d7..08433b3713d2 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -127,6 +127,8 @@ static void init_vmcs_shadow_fields(void)
> 				continue;
> 			break;
> 		default:
> +			if (!cpu_has_vmcs12_field(field))

This can be

			if (get_vmcs12_field_offset(field) < 0)

And I think I'll put it outside the switch statement, because the requirement
applies to all fields, even those that have additional restrictions.

I also think it makes sense to have patch 1 call nested_vmx_setup_vmcs12_fields()
from nested_vmx_hardware_setup(), so that the ordering and dependency between
configuring vmcs12 fields and shadow VMCS fields can be explicitly documented.

