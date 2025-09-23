Return-Path: <kvm+bounces-58582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 09611B96E5E
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 19:02:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B300A3ABB07
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 17:02:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38D1E2512DE;
	Tue, 23 Sep 2025 17:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eMfoSAm5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704151D5CEA
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 17:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758646940; cv=none; b=bOSD/yn69GZwkeZm1SfY8zIK2PaE7sXqEVLtOf/SLlF0Hnm3A4Y1VkhEZiL5HHNtUlbN/53YbwdAtTQI7Htqn8y9jhPQ5Y0tRlDTnszKHtu1B8nf/7nnENM3lVKVWpt7nQ/dmnpA2npNNHSk/WyayeOa1EpVCw3rDwogbKHJzWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758646940; c=relaxed/simple;
	bh=zPyve496OIR6DHrhycPdyFEAG18J/s9aaIMEttgoXw0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f6Xu905Oer4UDP9n6ybnPB/qpidbIVDGbgQg7UJEh6GtAzwYp8tp/43tJpFy/s6cHZoYHwkJ0VDiicNrqcRVaYWQLKGrxMJX8C7zICCIAekZfOP7ztaen/jjvX/q9jrsyAZpECHW9cvkiSxrwrfHmCvTboO3spjRd63svqrxMyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eMfoSAm5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758646937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+yVsTQAlBVDvjynp3S3KHSHcOn+gzz2S8kJWQRrsb8k=;
	b=eMfoSAm5iCp64B7cBDh0AO/057Y8KYw7c1F/3XQwhA4rxUP58S+6AVp3S16a3mdOywMo92
	mSYsUsc4pM0+u2hA+La01jSuk9GEVJ4AMI3R63jgdb2Cojw1pMwNhDx69EKI7rjTiJOVE5
	4HO+zYPO8kjSkdAm4ZaS3DmMg8Ohfgs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-153-FE3azLYkML6bfwHni412Wg-1; Tue, 23 Sep 2025 13:02:15 -0400
X-MC-Unique: FE3azLYkML6bfwHni412Wg-1
X-Mimecast-MFC-AGG-ID: FE3azLYkML6bfwHni412Wg_1758646934
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ee10a24246so3989008f8f.3
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 10:02:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758646934; x=1759251734;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+yVsTQAlBVDvjynp3S3KHSHcOn+gzz2S8kJWQRrsb8k=;
        b=Rt+ncQBj1pv57WC/Pw1eHC2iMDXxv+I/kna3bai6I6WSGARSDhLSP7fa80bLIJ3ro3
         h0IJpSOl/9tIcoMxbH0E3JUCG+7F/FYkyTPjwcU4qNNVDZOVUV+PyScSVimnLha2UCDV
         MWD7iHJbUZviam9t9ZxAtOm0IESt8fWd8PYPbi+Wd3ule7k/Oz4oXnxN1qaUzwy/+Nww
         4eVC5NSacvdsvttb30kmPRTlMDXk34qL4LjX4SUarcSAkoANKIbiS9zz0J+X9xmBcfnD
         vHVytePjYtfE6xMWfssWjphkYWQowurhlvPQ3aRMkBYiJ/7g4KdoWESlV6tX0+E6sGGB
         Pb9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUl2UJoGymWqCl16FcHxPi/DOBWY1syHAYVuohSBTshRbC7hDG+heMHAnGuMsXMJbusObE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEaubFnTAzjIfY/ANMOxh99qLD0BiXYdOgOm35rxTfeEPM00U4
	jV2kqD5TAXnHqIyodF94pBcPs32k17nu0itcdQd0G6TgfEnw9y4wMSWVYGbtHxEyb9uWBVa5TRs
	MkYmHKJQuaySEGXam1HVksyuGqSmKP7S31VBYMfiRsZ3w70ARuHnTZQ==
X-Gm-Gg: ASbGncs5JRr23dk81FYs2w3PCSA3CDZKwClAuj0pacdmFa9BvddRKIEXeK3n9NZr9k8
	H+9X303ZnpFIVnAnUAwdNFZpVWMle+u4rUkBXcMjk58VcpCLtdV3R8GSIbpwYLWLgiTTs9XNtmp
	N6TXCD2Vc0JQ06P+vGkDJhYPegdEPJY0eISFzZ/j/WPWDK/vs/hVPxFDB2mkighpFSdYppt2Okh
	YD+ZbeZ7/oBnU7iVy49pMLJ575ZzMYjYjoNP8OFBJuBw8Oz8Mxb70YXBgFsBgJsc1L46l+xJJ6c
	BajA861fpPlyB760x7Hg5RKcU79fmbsCQkTLQ46tk0DeC8tPhKWuTGdGZUljdVuh/30xPQuiyWZ
	g4G4=
X-Received: by 2002:a05:6000:184f:b0:3ee:1492:aeac with SMTP id ffacd0b85a97d-405ca95972dmr3593627f8f.38.1758646934227;
        Tue, 23 Sep 2025 10:02:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGk1FKJIA+oRLLUZLl85pUi0Wj5cslafO5JrAxW6RScXu4bROYWAr/9CVSMPLqkzQDlLQNw7g==
X-Received: by 2002:a05:6000:184f:b0:3ee:1492:aeac with SMTP id ffacd0b85a97d-405ca95972dmr3593596f8f.38.1758646933712;
        Tue, 23 Sep 2025 10:02:13 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:576b:abc6:6396:ed4a? ([2a01:e0a:280:24f0:576b:abc6:6396:ed4a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3f70b47ca57sm14207316f8f.0.2025.09.23.10.02.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 10:02:13 -0700 (PDT)
Message-ID: <b1813fed-1dbe-40ad-a6e9-a5c86aea996c@redhat.com>
Date: Tue, 23 Sep 2025 19:02:12 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] vfio/pci: Fix INTx handling on legacy non-PCI 2.3
 devices
To: Timothy Pearson <tpearson@raptorengineering.com>,
 kvm <kvm@vger.kernel.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
 Alex Williamson <alex.williamson@redhat.com>
References: <1293210747.1743219.1758565305521.JavaMail.zimbra@raptorengineeringinc.com>
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Content-Language: en-US, fr
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <1293210747.1743219.1758565305521.JavaMail.zimbra@raptorengineeringinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/22/25 20:21, Timothy Pearson wrote:
> PCI devices prior to PCI 2.3 both use level interrupts and do not support
> interrupt masking, leading to a failure when passed through to a KVM guest on
> at least the ppc64 platform. This failure manifests as receiving and
> acknowledging a single interrupt in the guest, while the device continues to
> assert the level interrupt indicating a need for further servicing.
> 
> When lazy IRQ masking is used on DisINTx- (non-PCI 2.3) hardware, the following
> sequence occurs:
> 
>   * Level IRQ assertion on device
>   * IRQ marked disabled in kernel
>   * Host interrupt handler exits without clearing the interrupt on the device
>   * Eventfd is delivered to userspace
>   * Guest processes IRQ and clears device interrupt
>   * Device de-asserts INTx, then re-asserts INTx while the interrupt is masked
>   * Newly asserted interrupt acknowledged by kernel VMM without being handled
>   * Software mask removed by VFIO driver
>   * Device INTx still asserted, host controller does not see new edge after EOI
> 
> The behavior is now platform-dependent.  Some platforms (amd64) will continue
> to spew IRQs for as long as the INTX line remains asserted, therefore the IRQ
> will be handled by the host as soon as the mask is dropped.  Others (ppc64) will
> only send the one request, and if it is not handled no further interrupts will
> be sent.  The former behavior theoretically leaves the system vulnerable to
> interrupt storm, and the latter will result in the device stalling after
> receiving exactly one interrupt in the guest.
> 
> Work around this by disabling lazy IRQ masking for DisINTx- INTx devices.

Timothy,

This changes lacks your SoB.

Thanks,

C.




> ---
>   drivers/vfio/pci/vfio_pci_intrs.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 123298a4dc8f..61d29f6b3730 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -304,9 +304,14 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev,
>   
>   	vdev->irq_type = VFIO_PCI_INTX_IRQ_INDEX;
>   
> +	if (!vdev->pci_2_3)
> +		irq_set_status_flags(pdev->irq, IRQ_DISABLE_UNLAZY);
> +
>   	ret = request_irq(pdev->irq, vfio_intx_handler,
>   			  irqflags, ctx->name, ctx);
>   	if (ret) {
> +		if (!vdev->pci_2_3)
> +			irq_clear_status_flags(pdev->irq, IRQ_DISABLE_UNLAZY);
>   		vdev->irq_type = VFIO_PCI_NUM_IRQS;
>   		kfree(name);
>   		vfio_irq_ctx_free(vdev, ctx, 0);
> @@ -352,6 +357,8 @@ static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
>   		vfio_virqfd_disable(&ctx->unmask);
>   		vfio_virqfd_disable(&ctx->mask);
>   		free_irq(pdev->irq, ctx);
> +		if (!vdev->pci_2_3)
> +			irq_clear_status_flags(pdev->irq, IRQ_DISABLE_UNLAZY);
>   		if (ctx->trigger)
>   			eventfd_ctx_put(ctx->trigger);
>   		kfree(ctx->name);


