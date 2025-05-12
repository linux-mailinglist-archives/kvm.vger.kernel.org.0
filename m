Return-Path: <kvm+bounces-46252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E06FAB4368
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:33:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E6163B8570
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:29:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF79A29B774;
	Mon, 12 May 2025 18:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jBiXfOEo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63488297A4A
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073662; cv=none; b=IYLeQVpMo3Icc0xcc+zVyHTXlj1W3DLlHzHjb0M9uJHwUFkz4MEf88nlygFFGoIbW1m1F96BChCWOwp2nY/7BrlNVNdOFpY5OcBCL0dE9ai58flop2JdG+Km+TRv3J/dE/91bU3pCAO0TVKyOoATaPM27VD2DNWrTL1zpv+LyB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073662; c=relaxed/simple;
	bh=ge8nSwHM2/L0C3/tgG66L21hTU30oQNN1Lla7jkdOAc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PWQBwUZnHvlZTbrXoF8N2g0q3cMXnsqzLlMawyu4hg4h0WGVoK8Q89HBdl9KdC84oTu28VeB4I7BNPwSxRMsrczPelfN+PN0pq3nLl5iBLI9uP0jLVh264c4SI1by5prXncVHgOPqwUaCKayiUOdvk1DHZrxGdkJoTcWfQ+VaMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jBiXfOEo; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30a80fe759bso6392493a91.1
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747073660; x=1747678460; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DppjzGuONHUmUt6xrl/Gh7jXlRXjo91ajvJ8cLSO9UA=;
        b=jBiXfOEomwUBjlJ9WAZ5r7XHHI7+2rnwX5D5JFGCpm96UBaGvvQ5jcUiQsRHj2dKot
         +Z8PCaVAGyw1qDLwsecrKWw1w2ZDJ6f7eq5TF6AtjyHMEEvDfbjjuECMWgby9wT/pXeX
         qDx+1CmpwiWD0uosMbiLBxAbTFziz4Bf/StmKyDKHSLD0I9etwYEXMLjyQlZ0R41tCYl
         2cFM4/Rh5MBrq9HB2AYPEaFeiREs/+nmvjUTI3wATJNNUeXLaxrofsePNFrjcfF3KuDg
         zdbmwpPfZSyHdxuVWg9OsKuLF3kvSa+8gisFzuyEYTFHGBXG//lzR7hdkn9HXocZsFsz
         P68Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073660; x=1747678460;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DppjzGuONHUmUt6xrl/Gh7jXlRXjo91ajvJ8cLSO9UA=;
        b=jYLKraQa8hcX3Bd5w3JYMyPOyKqC8BwVKYcmJ40Q7WKzmNBcjtx0N48jp8nVAJXMHm
         9eyOe3kEm4K5hTRltR9D2tNmrdDr1M9bfUx9c1XfiVd0T0N9az2smQrwYR5EPDy9ie4f
         4qb7xpENiRct8RYyiSvNkuK5GEDZyiy/ZQ748YoFAtH+gAI2wF6Ofs20QDjniDgVS31N
         Sip767CmBwN6rXNCWaHiYMC7Xc/Pek1FtbtmASxfszHYf6GsCC7Q3IQ0mgFb8iM9a5oq
         GVMPR/lIItxsLNSAiZxKbSqclaHxsMu4/SUpPW9iJDY5tX7RTLsmO/Lv0HRzLgehfaHL
         xTvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHQztA08KBLO+8Ou423XzH1adjpEufYk0v4CfZpxucA8IPJfJHKrDaFSlQzHD6+4bvKpc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjcvGIlqaoBLwtlCFdPFYXfUw35jNNtwKrTWpaiS9tDv2SHlTI
	uxgioDbbEkWSXsjMBDgar8mtRdWwlgiUsKMomnZG2m6q2n8RFrWHaXb06TJScMRRXcQri1BzZIE
	mXw==
X-Google-Smtp-Source: AGHT+IFVSP9g1YX6T9SSblQiikemd9gCjFwSJSmUr0xZ8O9g7WsE/PEszOVr+Pcq7V+3+YvAiBJ1tciAERI=
X-Received: from pjbli15.prod.google.com ([2002:a17:90b:48cf:b0:2ff:5516:6add])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d44e:b0:2f5:88bb:12f
 with SMTP id 98e67ed59e1d1-30c3d3eb7c2mr18454811a91.21.1747073660687; Mon, 12
 May 2025 11:14:20 -0700 (PDT)
Date: Mon, 12 May 2025 11:14:19 -0700
In-Reply-To: <20250313203702.575156-5-jon@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250313203702.575156-1-jon@nutanix.com> <20250313203702.575156-5-jon@nutanix.com>
Message-ID: <aCI6e6KYXmfi_Oqp@google.com>
Subject: Re: [RFC PATCH 04/18] KVM: VMX: add cpu_has_vmx_mbec helper
From: Sean Christopherson <seanjc@google.com>
To: Jon Kohler <jon@nutanix.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 13, 2025, Jon Kohler wrote:
> From: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
>=20
> Add 'cpu_has_vmx_mbec' helper to determine whether the cpu based VMCS
> from hardware has Intel Mode Based Execution Control exposed, which is
> secondary execution control bit 22.
>=20
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> Co-developed-by: Jon Kohler <jon@nutanix.com>
> Signed-off-by: Jon Kohler <jon@nutanix.com>

LOL, really?  There's a joke in here about how many SWEs it takes...

> ---
>  arch/x86/kvm/vmx/capabilities.h | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilit=
ies.h
> index cb6588238f46..f83592272920 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -253,6 +253,12 @@ static inline bool cpu_has_vmx_xsaves(void)
>  		SECONDARY_EXEC_ENABLE_XSAVES;
>  }
> =20
> +static inline bool cpu_has_vmx_mbec(void)
> +{
> +	return vmcs_config.cpu_based_2nd_exec_ctrl &
> +		SECONDARY_EXEC_MODE_BASED_EPT_EXEC;
> +}

This absolutely doesn't warrant its own patch.  Introduce it whenever its f=
irst
used/needed.

> +
>  static inline bool cpu_has_vmx_waitpkg(void)
>  {
>  	return vmcs_config.cpu_based_2nd_exec_ctrl &
> --=20
> 2.43.0
>=20

