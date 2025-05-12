Return-Path: <kvm+bounces-46256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 680A8AB43E4
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:43:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A1C68C1B63
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83488297A55;
	Mon, 12 May 2025 18:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jT+mfza2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4980F2550C0
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747075029; cv=none; b=AgfcdTj+zzoIJyaepsA0DRdMgxANEBK1R1UQPpQt+tGM83MlXJD7s9meDEUzuUeI39nUpfIfO/7gjZuY1et+WybA3irMNFmeWtKd2FsXPT1Ulnz8fVHGTKI6sd3VkcbIw+JaRVcnvp6qBUjh9YdX03M+3/YRNzOLgu1b+hM+5ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747075029; c=relaxed/simple;
	bh=kE7kBOc2VwbS3HYOTOs9ZLPbh2trI0AIR0/lLIkOWp0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DLD2QI4hWFsE0fZ21rOnM7GbMFmIt7SGe+TUZdPyuQRkvpuY56FH3LzUqKWhKDLNerxM3jHiHitF2kJUXC9xPZF8xzQstpSaoW31FHeY6f862uF1+hl7CWuV4wcP+E8DVbXAbR6Rl2EtgAKme8Uy8KRWUQMmBiu/rRNLJ5KX7mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jT+mfza2; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30aab0f21a3so4356175a91.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747075027; x=1747679827; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3tz2zLJJWQej2+gxGEF1Co5g2xWs8cmlAGRtB66I/EI=;
        b=jT+mfza21teJOj86whgukYZBe7zZe7Xm4zL7LFAlaQUem7+tUAh2f/nwOm36hQJlb7
         HAdSDCUOLZm0mrXryxPbfGn2oRAi0fu0bcIkiXFqGTMI52+Qtjyg1VpIqYAMzExqRCVQ
         G5AQc6z//tkzdwwIMQLzY/UNah61T6aMMGxgoC2uscOoikcYxoK54ZITH9yMHLp6hUIz
         uvFOk7JN4fUQ14y8dC6HrvVeyCypxI0+yY5WWr9D9bbuUSyCImlaC3AavAUMpTNrQ+QI
         NrJPo1Ua60duvA232vlq3KyHb3vmUS5ZnIz1+GNvJkbD73gGyVK+xZBfMs4VFbGoMkzQ
         WnJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747075027; x=1747679827;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3tz2zLJJWQej2+gxGEF1Co5g2xWs8cmlAGRtB66I/EI=;
        b=SJFY3augQgbYnxdCZ5EeGcb+UcKdWBXkURrBGFMeMllveCFenwVbCBGyLGGCOmHoEl
         mJrSKri2iMBf9MVj43ynwMdDnle2XTnsDOaDWd0RrlJQXZCXxHnbnid1OjyRrf96oYV8
         ga+fiz2OlwbC3/bD9PLleTo2s2xVt3SQ6GBippDvUkhddMXUMNg/BjBaA2P05YUQtHRe
         jLrxRg1BIqFNIqrbWgbAtVGl3GP1qxDoJ9CSleasNsyPDZaPbbctUTSBbnRlVjg7FrRK
         3ABFsW7kH14ls0mqmVWXHrW0yVp/0L1C/yxVFt8J7JrCo/3vzF2Wr23FCnaIf4g17huk
         b7+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXsf660UkTQD5UqtzRzbpgLwbmt1GOw6E6wL/Lpv1UdVl8Tfzeq0TWcmcdaws0ckK7bKt0=@vger.kernel.org
X-Gm-Message-State: AOJu0YylcmfI3BRifTyM3iMAck9HKsE9N5p633mFghOQJZaqqPP0u/QI
	gXdCTmmPzwHAUvYtw64TLSqOMpuyMutZJjeDFitYCQz6fsVaNmu8/lazkePwGQTQY93CEdj/VDH
	Lqg==
X-Google-Smtp-Source: AGHT+IHSd2hqQr7pKt9juYC9h4oiydDWEMcqSz2v3GX4aA5gpFhyO7yz8YZW31gtEXaX7DtFOH7e4Lv67Zk=
X-Received: from pjbsj5.prod.google.com ([2002:a17:90b:2d85:b0:2f4:465d:5c61])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f0f:b0:2ee:f076:20fb
 with SMTP id 98e67ed59e1d1-30c3d2e3610mr27112396a91.17.1747075027561; Mon, 12
 May 2025 11:37:07 -0700 (PDT)
Date: Mon, 12 May 2025 11:37:05 -0700
In-Reply-To: <20250313203702.575156-11-jon@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250313203702.575156-1-jon@nutanix.com> <20250313203702.575156-11-jon@nutanix.com>
Message-ID: <aCI_0WqSzrgtz6IW@google.com>
Subject: Re: [RFC PATCH 10/18] KVM: VMX: Extend EPT Violation protection bits
From: Sean Christopherson <seanjc@google.com>
To: Jon Kohler <jon@nutanix.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 13, 2025, Jon Kohler wrote:
> Define macros for READ, WRITE, EXEC protection bits, to be used by
> MBEC-enabled systems.
> 
> No functional change intended.
> 
> Signed-off-by: Jon Kohler <jon@nutanix.com>
> 
> ---
>  arch/x86/include/asm/vmx.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index d7ab0ad63be6..ffc90d672b5d 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -593,8 +593,17 @@ enum vm_entry_failure_code {
>  #define EPT_VIOLATION_GVA_IS_VALID	BIT(7)
>  #define EPT_VIOLATION_GVA_TRANSLATED	BIT(8)
>  
> +#define EPT_VIOLATION_READ_TO_PROT(__epte) (((__epte) & VMX_EPT_READABLE_MASK) << 3)
> +#define EPT_VIOLATION_WRITE_TO_PROT(__epte) (((__epte) & VMX_EPT_WRITABLE_MASK) << 3)
> +#define EPT_VIOLATION_EXEC_TO_PROT(__epte) (((__epte) & VMX_EPT_EXECUTABLE_MASK) << 3)
>  #define EPT_VIOLATION_RWX_TO_PROT(__epte) (((__epte) & VMX_EPT_RWX_MASK) << 3)
>  
> +static_assert(EPT_VIOLATION_READ_TO_PROT(VMX_EPT_READABLE_MASK) ==
> +	      (EPT_VIOLATION_PROT_READ));
> +static_assert(EPT_VIOLATION_WRITE_TO_PROT(VMX_EPT_WRITABLE_MASK) ==
> +	      (EPT_VIOLATION_PROT_WRITE));
> +static_assert(EPT_VIOLATION_EXEC_TO_PROT(VMX_EPT_EXECUTABLE_MASK) ==
> +	      (EPT_VIOLATION_PROT_EXEC));

Again, as a general rule, introduce macros and helpers functions when they are
first used, not as tiny prep patches.  There are exceptions to that rule, e.g. to
avoid cyclical dependencies or to isolate arch/vendor changes, but know of those
exceptions apply in this series.

Patches like this are effectively impossible to review from a design/intent
perspective, because without peeking at the usage that comes along later, there's
no way to determine whether or not it makes sense to add these macros.

And looking ahead, I don't see any reason to slice n' dice the RWX=>prot macro.

TL;DR: drop this patch.

