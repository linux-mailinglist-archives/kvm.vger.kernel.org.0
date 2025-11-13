Return-Path: <kvm+bounces-63037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D441C5991E
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 19:52:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 510903A8259
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 18:52:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1E09314D05;
	Thu, 13 Nov 2025 18:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rGYOArWL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609A33112BC
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 18:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763059926; cv=none; b=ppffdnmkiZUF5ZUhLS2xzBOkgoK9R9ugsOCn6D12wJIm4LIrANNPdWC0sxBFPo6gQ4xzPXSXhceOH88emBk2cKZEGq1vTrGAuW6PF04ye705lhDUutRWChFfLbP+KJm/cjRzjl9zsirqzoF/xD7xJUpjideDBg5H+havemHJY4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763059926; c=relaxed/simple;
	bh=1I81ZMh2flMGmGHT9awFaIU8CTiz5EtPfzZ60BaJIQg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eU7GvzYZtW6r68GIMzfTJ3eg7dmtBjQCtVU5QAgi5xccobSx3BoWL+Bqn1jMGW7IR99NgqKm4Fv8gsmhQ7aUSH0ICw1TfzwchLJ1SH02P1rO1r37PdpOH/LXMCwE8nGikbRJi0E2nF6svrC6NgkFsD3G5i6AUXjtXatbRdeHLG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rGYOArWL; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2956cdcdc17so12829365ad.3
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 10:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763059925; x=1763664725; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cIVgrZy+vZcCrxI7QYJ8hXcnFmjFjPoiu79u6DzwfMA=;
        b=rGYOArWLBoU/z7s2/0AFUplNEZJlfgGZoFD0CPngpcrsVtURCpOHU5T8W1uWSDnD72
         i3QCs2ESzUzudtmienyD0J/nc2O1Hr2cBHB8R/hFhTOKyDmFrcJz4uT5vPE0DXjGAXSB
         wREraRFWzCZDCHB+BPFQ4rFo/+DXMm8tsocoX0sGhLP417QhH+NWf2oY46zCW2m7HX5C
         tLqjkfLLECu3yBngKAbDa5img1EVRvDarrs64s5HBy+qaqWDDv7hNdTDBAzmDOwJ8c4z
         zWp3HwaXx0wecl8fQRwf8zp0yjLf3nRFP4hOjSCUfXD+C5wvSD+gx6itbQTBKAnirHdH
         kcGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763059925; x=1763664725;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cIVgrZy+vZcCrxI7QYJ8hXcnFmjFjPoiu79u6DzwfMA=;
        b=D5mZsQIS0/6H1db37uWAZdtqUMC1erBDugrWgFue9WjfDUmEbRn1jsOVRZrVJW7uPl
         0FGBGx/buzLL/DoRJTyniTmuxI64PEmdUjU6CdU0JBLQ/jMBfjNwqwRyIgAzsSJkVfZP
         JxDZV6Pm0whVdfbC3GacWgaVJBaZLOFbtkX4yy+m3NcmKPEVom0yKKj07v29s/6PrgQG
         7VsuoIhv3DOHuU/SyWwCyq6oJRxv70xPJLCk8RmMkxvg6X2i3Kz9yWPKJqJfyM1cfEkK
         CzcPGGuE7dprKDkWyjjGQ8B6jWZVQ0Sozj/FTxY2BOJ4Ku9wnuZXMub05fboZwqplyne
         8kFQ==
X-Gm-Message-State: AOJu0Yx+3uf/R3xCMZ4+bvl7jFQr/RD3kc4Q6AzTltfBTmZf9JmeGyhP
	PyCniMs36ixJNtc6ijWDO5OLOqxZdiX6oNoXWY6nn5yCT18KA2dJTQIeQN3alSvRQ25ud+z+hNz
	4ZTagRA==
X-Google-Smtp-Source: AGHT+IELLdvnYt/gi3DBJs5U+itYxHk4SoCPsQR2iLQbi7s7Ha6OS3ZSPCJ4OFt28AA30gan8pj0zZ6ieKk=
X-Received: from plbkp5.prod.google.com ([2002:a17:903:2805:b0:297:fd8b:fe1e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ecc7:b0:297:db6a:a82f
 with SMTP id d9443c01a7336-2986a6d27fcmr422445ad.24.1763059924664; Thu, 13
 Nov 2025 10:52:04 -0800 (PST)
Date: Thu, 13 Nov 2025 10:52:03 -0800
In-Reply-To: <e3f711366ddc22e3dd215c987fd2e28dc1c07f54.1761593632.git.thomas.lendacky@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1761593631.git.thomas.lendacky@amd.com> <e3f711366ddc22e3dd215c987fd2e28dc1c07f54.1761593632.git.thomas.lendacky@amd.com>
Message-ID: <aRYo05KMsaNdj59U@google.com>
Subject: Re: [PATCH v4 2/4] crypto: ccp - Add an API to return the supported
 SEV-SNP policy bits
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	linux-crypto@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Michael Roth <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 27, 2025, Tom Lendacky wrote:
> Supported policy bits are dependent on the level of SEV firmware that is
> currently running. Create an API to return the supported policy bits for
> the current level of firmware.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---

...

> @@ -1014,6 +1031,7 @@ void *snp_alloc_firmware_page(gfp_t mask);
>  void snp_free_firmware_page(void *addr);
>  void sev_platform_shutdown(void);
>  bool sev_is_snp_ciphertext_hiding_supported(void);
> +u64 sev_get_snp_policy_bits(void);
>  
>  #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
>  
> @@ -1052,6 +1070,8 @@ static inline void sev_platform_shutdown(void) { }
>  
>  static inline bool sev_is_snp_ciphertext_hiding_supported(void) { return false; }
>  
> +static inline u64 sev_get_snp_policy_bits(void) { return 0; }

As called out in the RFC[*], this stub is unnecesary.

[*] https://lore.kernel.org/all/aMHP5EO-ucJGdHXz@google.com

