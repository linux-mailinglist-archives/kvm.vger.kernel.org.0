Return-Path: <kvm+bounces-57494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B956FB55F7C
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 10:27:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BCB0AA4875
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 08:27:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD9DA2EA172;
	Sat, 13 Sep 2025 08:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IRe11eRu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4537B2836A6
	for <kvm@vger.kernel.org>; Sat, 13 Sep 2025 08:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757752044; cv=none; b=rzat/oMaZ7E6Azp1NWduNMze4zvsMds9LfTs0kwjnZoMDe5D7xgVDf0WbMXkaGXnRdJyXVslMe+MnItzklzJmMAF230izrgjslmi3OW0mnPuTLwNjZuZGLzy/Yhvz1vcvuOyQ7jYbJ0yG+pc+S0tUIuIHDYrllje1KSCFLAklKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757752044; c=relaxed/simple;
	bh=KBdb34yjuqC8JNMb7MU0xophtAjSJbuqI+5/g2ts2wc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ejPcWwliVNQ1Mbe+kP2FTqJPiVXa0N0xf2IFv/dCNUOZKtBQZKlmTa/41D0NL1svlz2e2Va7yrOXwryWV4zlDq8wY5LcJoHsRARA4QZgYJYHgB+KHkFXtA87W4IV+bJA6ePsniUMrBpub31X+JP1FBN7Pn5KDV9S00w+FScc/+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IRe11eRu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757752041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jHz5EoPd+ylCkG4BgrRtBzTwz79VaTitLewrCZQ2PXY=;
	b=IRe11eRu4nLwyrUUcEmiuDKwaOWORP7jmRmMEKhvaH8uCvAPDgRCn3RXGykHkpKmzFHpnQ
	jcB8iqR0Gjlh5xIBcEq0WHotrJX2efTbW8yhT0jmzFqJMOhwFH/xruzoM+tV+HDnnNVHKB
	Sj6DzJZgnKxQa9aUVmHo4jA5PKHAAzw=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-moAJtNkbOF-kxmEeXf1rjw-1; Sat, 13 Sep 2025 04:27:20 -0400
X-MC-Unique: moAJtNkbOF-kxmEeXf1rjw-1
X-Mimecast-MFC-AGG-ID: moAJtNkbOF-kxmEeXf1rjw_1757752039
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-41a6fb8b09dso3725985ab.3
        for <kvm@vger.kernel.org>; Sat, 13 Sep 2025 01:27:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757752039; x=1758356839;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jHz5EoPd+ylCkG4BgrRtBzTwz79VaTitLewrCZQ2PXY=;
        b=KkzAKdFll6gZYT7sAagaP3vvTSx7L9EaBopE+yoFxSUZTAYYGEgo76ceSacitCkTxC
         dRwHoJ6uveTkJCI4bqDH3iMdpLTUV4gvHulyJX6f/qxRUpEqCFivjwOiC62flLFzF7eC
         qQS+51xa4mLVlrRrOAYbEft/W6A6ziqZSddYw3qAKiVnTkVLz0uY2sBfVFI77gGpF3cJ
         1oCfoAClA5fX4LyvXrmtlVRJOR0LtlEC55LVs59dziHWdcforbt5X5LVbo3dYnxOGgvc
         we3BwZIr7oQKoAwaI6BzpwfehHpd7Ay4qcqRYg3wmsH2iPRP0Ufp9IcRJd3PF1xot+O1
         AhEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTvEJtSRlTFHg/U0Yb9bZUA2An4l3O/MZyTTRjt3coLfI8iEaOyDAlMEdGpR74BRp1Kek=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZvgkuBkAsPydn69frZjsBt+KaB7UHp76VUtvVUIbShaENgMHH
	f8YBAvf/iF6yKkuvHMKqBrsPqnmpRJXZ5PrdhaJHFV+V7M9T6a6hL5XxCQI1P4xX87TzdNPLEUh
	dTxppY3/0waDTJU7iJ+Vd+XbZqezRfPfiXED6cqevfaLWpSjNGnb59w==
X-Gm-Gg: ASbGncun/6K3AULZs6EtYpvPUQqsy1tl4f+CAjXordG7o3ZJUJ6aap9sz8bWb/swn7m
	1aBczU/IwMmMpnWtK/cbwLnfLMCyiBNdagZ6PCGL+EWRJt4s5+ndTmbBTwUJNDhLWhdM7ZQuj+5
	BLfEA81dFEzaYI3cxtZY2+vlLpLKVhEjs9pFEgyxKLJM2J/luNLanZTE2vTIWCn2PDQiFE8q60t
	TL34YcNQbAtKwF15RPIZ4J7Hvmb0K/WqxYJdqP+wrIHzTIK2gaSb06KAmkam6+PkPG3NKagYTX/
	lZlpVkbYrxTGo/J6fhhaqhOftPfNnAc8MYCKNJoxXIU=
X-Received: by 2002:a05:6e02:1489:b0:412:5782:c7c1 with SMTP id e9e14a558f8ab-4209fc549bamr26611055ab.5.1757752039133;
        Sat, 13 Sep 2025 01:27:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGIW4jBz+RhyO9sjz/kQQ01borjLc8HZiyi2LaANGIQ/TGf19Rkd/3OlbjO/Xq+R2DLvjT7/A==
X-Received: by 2002:a05:6e02:1489:b0:412:5782:c7c1 with SMTP id e9e14a558f8ab-4209fc549bamr26610945ab.5.1757752038702;
        Sat, 13 Sep 2025 01:27:18 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-41deede6de7sm30080015ab.10.2025.09.13.01.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Sep 2025 01:27:18 -0700 (PDT)
Date: Sat, 13 Sep 2025 09:27:09 +0100
From: Alex Williamson <alex.williamson@redhat.com>
To: Farhan Ali <alifm@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
 helgaas@kernel.org, schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: Re: [PATCH v3 01/10] PCI: Avoid saving error values for config
 space
Message-ID: <20250913092709.2e58782d.alex.williamson@redhat.com>
In-Reply-To: <20250911183307.1910-2-alifm@linux.ibm.com>
References: <20250911183307.1910-1-alifm@linux.ibm.com>
	<20250911183307.1910-2-alifm@linux.ibm.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 Sep 2025 11:32:58 -0700
Farhan Ali <alifm@linux.ibm.com> wrote:

> The current reset process saves the device's config space state before
> reset and restores it afterward. However, when a device is in an error
> state before reset, config space reads may return error values instead of
> valid data. This results in saving corrupted values that get written back
> to the device during state restoration.
> 
> Avoid saving the state of the config space when the device is in error.
> While restoring we only restorei the state that can be restored through

s/restorei/restore/

> kernel data such as BARs or doesn't depend on the saved state.
> 
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
>  drivers/pci/pci.c      | 29 ++++++++++++++++++++++++++---
>  drivers/pci/pcie/aer.c |  5 +++++
>  drivers/pci/pcie/dpc.c |  5 +++++
>  drivers/pci/pcie/ptm.c |  5 +++++
>  drivers/pci/tph.c      |  5 +++++
>  drivers/pci/vc.c       |  5 +++++
>  6 files changed, 51 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index b0f4d98036cd..4b67d22faf0a 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1720,6 +1720,11 @@ static void pci_restore_pcie_state(struct pci_dev *dev)
>  	struct pci_cap_saved_state *save_state;
>  	u16 *cap;
>  
> +	if (!dev->state_saved) {
> +		pci_warn(dev, "Not restoring pcie state, no saved state");
> +		return;
> +	}
> +
>  	/*
>  	 * Restore max latencies (in the LTR capability) before enabling
>  	 * LTR itself in PCI_EXP_DEVCTL2.
> @@ -1775,6 +1780,11 @@ static void pci_restore_pcix_state(struct pci_dev *dev)
>  	struct pci_cap_saved_state *save_state;
>  	u16 *cap;
>  
> +	if (!dev->state_saved) {
> +		pci_warn(dev, "Not restoring pcix state, no saved state");
> +		return;
> +	}
> +
>  	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_PCIX);
>  	pos = pci_find_capability(dev, PCI_CAP_ID_PCIX);
>  	if (!save_state || !pos)
> @@ -1792,6 +1802,14 @@ static void pci_restore_pcix_state(struct pci_dev *dev)
>  int pci_save_state(struct pci_dev *dev)
>  {
>  	int i;
> +	u16 val;
> +
> +	pci_read_config_word(dev, PCI_DEVICE_ID, &val);
> +	if (PCI_POSSIBLE_ERROR(val)) {
> +		pci_warn(dev, "Device in error, not saving config space state\n");
> +		return -EIO;
> +	}
> +

I don't think this works with standard VFs, per the spec the device ID
register returns 0xFFFF.  Likely need to look for a CRS or error status
across both vendor and device ID registers.

We could be a little more formal and specific describing the skipped
states too, ex. "PCIe capability", "PCI-X capability", "PCI AER
capability", etc.  Thanks,

Alex

>  	/* XXX: 100% dword access ok here? */
>  	for (i = 0; i < 16; i++) {
>  		pci_read_config_dword(dev, i * 4, &dev->saved_config_space[i]);
> @@ -1854,6 +1872,14 @@ static void pci_restore_config_space_range(struct pci_dev *pdev,
>  
>  static void pci_restore_config_space(struct pci_dev *pdev)
>  {
> +	if (!pdev->state_saved) {
> +		pci_warn(pdev, "No saved config space, restoring BARs\n");
> +		pci_restore_bars(pdev);
> +		pci_write_config_word(pdev, PCI_COMMAND,
> +				PCI_COMMAND_MEMORY | PCI_COMMAND_IO);
> +		return;
> +	}
> +
>  	if (pdev->hdr_type == PCI_HEADER_TYPE_NORMAL) {
>  		pci_restore_config_space_range(pdev, 10, 15, 0, false);
>  		/* Restore BARs before the command register. */
> @@ -1906,9 +1932,6 @@ static void pci_restore_rebar_state(struct pci_dev *pdev)
>   */
>  void pci_restore_state(struct pci_dev *dev)
>  {
> -	if (!dev->state_saved)
> -		return;
> -
>  	pci_restore_pcie_state(dev);
>  	pci_restore_pasid_state(dev);
>  	pci_restore_pri_state(dev);
> diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
> index e286c197d716..dca3502ef669 100644
> --- a/drivers/pci/pcie/aer.c
> +++ b/drivers/pci/pcie/aer.c
> @@ -361,6 +361,11 @@ void pci_restore_aer_state(struct pci_dev *dev)
>  	if (!aer)
>  		return;
>  
> +	if (!dev->state_saved) {
> +		pci_warn(dev, "Not restoring aer state, no saved state");
> +		return;
> +	}
> +
>  	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ERR);
>  	if (!save_state)
>  		return;
> diff --git a/drivers/pci/pcie/dpc.c b/drivers/pci/pcie/dpc.c
> index fc18349614d7..62c520af71a7 100644
> --- a/drivers/pci/pcie/dpc.c
> +++ b/drivers/pci/pcie/dpc.c
> @@ -67,6 +67,11 @@ void pci_restore_dpc_state(struct pci_dev *dev)
>  	if (!pci_is_pcie(dev))
>  		return;
>  
> +	if (!dev->state_saved) {
> +		pci_warn(dev, "Not restoring dpc state, no saved state");
> +		return;
> +	}
> +
>  	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_DPC);
>  	if (!save_state)
>  		return;
> diff --git a/drivers/pci/pcie/ptm.c b/drivers/pci/pcie/ptm.c
> index 65e4b008be00..7b5bcc23000d 100644
> --- a/drivers/pci/pcie/ptm.c
> +++ b/drivers/pci/pcie/ptm.c
> @@ -112,6 +112,11 @@ void pci_restore_ptm_state(struct pci_dev *dev)
>  	if (!ptm)
>  		return;
>  
> +	if (!dev->state_saved) {
> +		pci_warn(dev, "Not restoring ptm state, no saved state");
> +		return;
> +	}
> +
>  	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_PTM);
>  	if (!save_state)
>  		return;
> diff --git a/drivers/pci/tph.c b/drivers/pci/tph.c
> index cc64f93709a4..f0f1bae46736 100644
> --- a/drivers/pci/tph.c
> +++ b/drivers/pci/tph.c
> @@ -435,6 +435,11 @@ void pci_restore_tph_state(struct pci_dev *pdev)
>  	if (!pdev->tph_enabled)
>  		return;
>  
> +	if (!pdev->state_saved) {
> +		pci_warn(pdev, "Not restoring tph state, no saved state");
> +		return;
> +	}
> +
>  	save_state = pci_find_saved_ext_cap(pdev, PCI_EXT_CAP_ID_TPH);
>  	if (!save_state)
>  		return;
> diff --git a/drivers/pci/vc.c b/drivers/pci/vc.c
> index a4ff7f5f66dd..fda435cd49c1 100644
> --- a/drivers/pci/vc.c
> +++ b/drivers/pci/vc.c
> @@ -391,6 +391,11 @@ void pci_restore_vc_state(struct pci_dev *dev)
>  {
>  	int i;
>  
> +	if (!dev->state_saved) {
> +		pci_warn(dev, "Not restoring vc state, no saved state");
> +		return;
> +	}
> +
>  	for (i = 0; i < ARRAY_SIZE(vc_caps); i++) {
>  		int pos;
>  		struct pci_cap_saved_state *save_state;


