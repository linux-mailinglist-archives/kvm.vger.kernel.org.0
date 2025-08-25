Return-Path: <kvm+bounces-55681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E3A82B34E1C
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 23:35:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC3D62433B0
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 21:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AF3F29A310;
	Mon, 25 Aug 2025 21:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AVBij65p"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F6F13C695
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 21:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756157713; cv=none; b=dlCfsVor3J7ZHC5h2/MyR4E22TjLqg2IxtARk1wb5GHJWptOMqSZ4weMCrJUt6eaKqyAe3y+bhT/AScRpzwKHSW2UvZkVMRteg7E0nOYjtYWDUstyNd/6UeNKmeU+7sZkm99TP4Qnll4I0+cch9DrnH1dz6ro7/jSqjnrm+4dFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756157713; c=relaxed/simple;
	bh=Q9CPbQpH2d/T5EyyLjYG2kTFNAop20As96U/hmdEPUY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A0n6CVi7Vi6hUU5CZAR7BQTY9/+TH5W+J8Xja6tAWzWpkJN+cKNCy7a6VCihm/Xme7KSpUPhgf7zC4pjYaFAv3rUkNmmYRkKzBkbGiZxxZ1QxsUunfnpx3S7zaH5lfvsrEsJkB6CdKHqi8EVCSyeZQNsTUZ3RADwaWQExav5K7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AVBij65p; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756157709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TuacPQu0sUaEe98IXzV5lAzTlLH7oY2OXfsQpZup1+Q=;
	b=AVBij65pmNfwJOXWbJPtok+69RkZPzIoKvWYOZAb0DfGsr70fG4c4gIuJIgFt3Ppnc/Vn7
	8ucfpZWlMWxnGqSxPeeRfHlpMCpZljGWGTAd4R1L20fjJ+UGa23XfjGcYzvTh0OKHO6uGh
	SPiZCkVGhtNFVtsId74ZjaO5CG1dLAg=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-354-7zNGVF68NBOqfx6SdKcWKg-1; Mon, 25 Aug 2025 17:35:08 -0400
X-MC-Unique: 7zNGVF68NBOqfx6SdKcWKg-1
X-Mimecast-MFC-AGG-ID: 7zNGVF68NBOqfx6SdKcWKg_1756157707
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3eb35f7f147so5771925ab.2
        for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 14:35:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756157707; x=1756762507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TuacPQu0sUaEe98IXzV5lAzTlLH7oY2OXfsQpZup1+Q=;
        b=kYVrFKuQ23/UTYkqau5jVd+VvYgW2SHqLzUWcZZo6kEpxSyh0vqx9/mmCi0L1iH1eb
         wGfhy70X7owDxEUwtD2XayEXMURr0m2VRA3E+ZVw8+vYJTO7cM+LjchaX6efv0eHu5it
         14do+sgu/yHi/RF881oWMt4hE2Xi2SJ7OxutRYAwSWo85T/mCzTCDO99jHjeVCndKPLl
         evn3od9yq17LycFfXHy2+IEWhptbo7Clva1j36i9m4Y/g7gdjroItEQchw9PshKW3qWI
         9P3SP3gqQhvSz9170updAmmJlCyo+ld5OVmcp7k4bBkQ3OOvqyol5l72KhN7mhIExd0/
         QVtA==
X-Forwarded-Encrypted: i=1; AJvYcCXOCxxUNxK4BUug5tjc6tWeYJAxCNWNJZ2gzwhRIPNtnOmlpRAVfrXPgphSsaR51jD4j4A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJsHXOQfE0CHi0JVIJtkceiyVheGJ+U9PTKFDJJaxKPAHqhLKS
	C6UKEMLkZfartrFw0s5qyCVBOy+wxJ36JGKeEypBjGyUrAlne1TaV2key/8sVELYTN6BXmRYae2
	oOfAb8Rdkwp43/2kMrfgLyH9nH0mZTVW9RKOTl9Y6CGmE4KgSHJRodQ==
X-Gm-Gg: ASbGncvcKFw3JPXMG11pcEu95AAilz9aWQYbBm7TBJ27+J0Da7uhW+vO2ZqwQ3x7qxJ
	P66GxcYVxDR5myqflyDFlrEu68nhTqYraqmyGLstNiI4i7e65ftQD7AkYycf/9+gAZmVF3rPeTQ
	rKHbbuuItuGjHUTREhBZa1O/Kzn+3sw0oCiW7UskgASx8CH7JIowpfpGvSxjHk/VIDYZSisoaiJ
	f8ZH0nuk3RoYVgv3XXQugQVVc+WLYgKnIX+FrLW4PllkWidqusOdTAH0mC9u3T7H0iM8UVkCp5A
	PIw1uPAGs7jA2u5QesGLE8IF5Py8Ky72p9Ynv4q0bFk=
X-Received: by 2002:a05:6e02:4414:10b0:3e9:9070:b0bd with SMTP id e9e14a558f8ab-3e99070b2a6mr42182205ab.2.1756157707166;
        Mon, 25 Aug 2025 14:35:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFjadVuAgSDvfABUcZMm01Kysw1HDncV59yUGSUyp2hVa5KPH4rom30lUjRmGeYrcRiA010pQ==
X-Received: by 2002:a05:6e02:4414:10b0:3e9:9070:b0bd with SMTP id e9e14a558f8ab-3e99070b2a6mr42182075ab.2.1756157706803;
        Mon, 25 Aug 2025 14:35:06 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ea4c761718sm56163575ab.23.2025.08.25.14.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 14:35:05 -0700 (PDT)
Date: Mon, 25 Aug 2025 15:35:01 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Farhan Ali <alifm@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, helgaas@kernel.org, schnelle@linux.ibm.com,
 mjrosato@linux.ibm.com
Subject: Re: [PATCH v2 1/9] PCI: Avoid restoring error values in config
 space
Message-ID: <20250825153501.3a1d0f0c.alex.williamson@redhat.com>
In-Reply-To: <20250825171226.1602-2-alifm@linux.ibm.com>
References: <20250825171226.1602-1-alifm@linux.ibm.com>
	<20250825171226.1602-2-alifm@linux.ibm.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 25 Aug 2025 10:12:18 -0700
Farhan Ali <alifm@linux.ibm.com> wrote:

> The current reset process saves the device's config space state before
> reset and restores it afterward. However, when a device is in an error
> state before reset, config space reads may return error values instead of
> valid data. This results in saving corrupted values that get written back
> to the device during state restoration. Add validation to prevent writing
> error values to the device when restoring the config space state after
> reset.
> 
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
>  drivers/pci/pci.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index b0f4d98036cd..0dd95d782022 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1825,6 +1825,9 @@ static void pci_restore_config_dword(struct pci_dev *pdev, int offset,
>  	if (!force && val == saved_val)
>  		return;
>  
> +	if (PCI_POSSIBLE_ERROR(saved_val))
> +		return;
> +
>  	for (;;) {
>  		pci_dbg(pdev, "restore config %#04x: %#010x -> %#010x\n",
>  			offset, val, saved_val);


The commit log makes this sound like more than it is.  We're really
only error checking the first 64 bytes of config space before restore,
the capabilities are not checked.  I suppose skipping the BARs and
whatnot is no worse than writing -1 to them, but this is only a
complete solution in the narrow case where we're relying on vfio-pci to
come in and restore the pre-open device state.

I had imagined that pci_save_state() might detect the error state of
the device, avoid setting state_saved, but we'd still perform the
restore callouts that only rely on internal kernel state, maybe adding a
fallback to restore the BARs from resource information.

This implementation serves a purpose, but the commit log should
describe the specific, narrow scenario this solves, and probably also
add a comment in the code about why we're not consistently checking the
saved state for errors.  Thanks,

Alex


