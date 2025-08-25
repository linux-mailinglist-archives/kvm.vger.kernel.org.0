Return-Path: <kvm+bounces-55691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 57CEAB34E78
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 23:54:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6AF4A1B2630D
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 21:54:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B4AD2BD01A;
	Mon, 25 Aug 2025 21:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bxSI5vp1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0289929D26A
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 21:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756158868; cv=none; b=Fe4d7lB2vv1uOeUKajhOy6mY9AmhoKVjBcCkLROIxtcGRkKL+SA2XKy4YfLmxONU4hG5ZG8c9XJzfEF59pgrBVRQ1dxmPiakPZlioQwYPrYj80CF2RBxLMWHR2DFwme+2is6XZIHd61Kkle+gPx1v2U0Md796LxTFP9qcrPjQ74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756158868; c=relaxed/simple;
	bh=PUrALNKcazTqj1JOi1kUX/7GRlWlbsgpoo8wt8AGzQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IVOlDZSWDNjyaBB3TFz3knB+ff/LM66LltCV73npKlRkfPSWKujS5QjmC2eBztVU+L9TWf+XJjzzgz/IEFIhkDaG/O1ty74okeOsiW2if2pti8xgvkXL1xfrqzEXIYd+czmud01DxHs3I7X6EFlxkmhUGjqd6O6zn2VXvuuKhSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bxSI5vp1; arc=none smtp.client-ip=170.10.133.124
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756158865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ktdRGsOdUoyTte4ICKWTNwEDxAMcLJUcCCRuCPiDxEI=;
	b=bxSI5vp17Kttun/uupcHs86jhJFTizzaPNpJKfIc9JDrlgxnB3vCMoNyrm2VJy1opCpQ+D
	8AqOGpnyAEZ0iYOMGI/5gxVL4dkLkC/DbBqER2ykqM6crnyQEfSuwfyGNcO7GY+JIYFJem
	Fg38QuI/QXBaPUzb9LCA6AbnVtuwjtU=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-7ttzbPmnNjmisooH3BW4ww-1; Mon, 25 Aug 2025 17:54:24 -0400
X-MC-Unique: 7ttzbPmnNjmisooH3BW4ww-1
X-Mimecast-MFC-AGG-ID: 7ttzbPmnNjmisooH3BW4ww_1756158864
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-886e8134e87so5821339f.3
        for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 14:54:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756158863; x=1756763663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ktdRGsOdUoyTte4ICKWTNwEDxAMcLJUcCCRuCPiDxEI=;
        b=KW8CRBKA1XsPKgPXOg6wOI1Wstlc/5Kvi/YbeCC1u9TuFdq7Sc+FQdght6+9hnp0Df
         QBdO3H+fW/zj7KP6dKvxk8cxjE6dcBtTzdEBBDT3Y2JWIigqul0HttBAckWJi9CEK34F
         HqHqCLPTrVkIystNy/eenIrc/jd/qhqPtzayOVsopRXiXsv671Ikgt4/XZGxGmK2QE6G
         iMZzP3qgkJhBP5Ane6jJy1ULZOIL6JEnVnDYgjetgKjsyGELZnEPOV8VKgbimqeuF+/m
         ZlsPkXq8775Ic/gOzqI0JoQwbuGXwUxPqWtLdt8lIOO1E/XGJYMTwyxZh0UrKVoIXWgu
         tg6w==
X-Forwarded-Encrypted: i=1; AJvYcCVV0QPcGo6mUCMtD8qnJaiAgwVk/SZc91T55jUDfdzOTsa3SbG1OVpIYX7YShwpLItCh2g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/fn99LvjzXtg5bcOJW1D555tgV51FnKHvCxzje1YHI96vsPXW
	FCcTxCOGqEdKPnc6AM2Nr0R22s4qpP3OW9Tg4SJQnPy2jIypDYSP1DJi5mWIZk8W7DHhOSguEp/
	piP3RwQnsYI71l3+9ln72J0X4s52ck5YRaVdpgrNdQSSPyiXvt/5VZ/g/IUEEvw==
X-Gm-Gg: ASbGncvIJgglfFU0SaxC65IGvMfrkhexIJANpkAv6pO+l7KZ2k0sE+3LyJg4laTpPrH
	i1w+ys+nkgXPfcvjd+ViKs3AXvimfywqsIiRdMPuYgGhwJM1tjIMpDOgxYv3LrBTU+UlGRG2RBA
	NLLohd+s8HmMoRrIuK5UikfmcKoACJx+PrG3/tcJaYmQ1Tt+yV268sEUePNSOgiZvF6MUQrIuz9
	4H4EHAJ93j9d+OlOpNkaV0X/P940afp6mLGxknaX87R3656Tj4MypWhVln9d3vmahJMDIrVHqY5
	C4ttSb3aDNSAV55l2ehayZHD+CYDG2zINJrTOxI75ks=
X-Received: by 2002:a05:6602:2c10:b0:87c:32d1:3b84 with SMTP id ca18e2360f4ac-886bd202301mr688403439f.3.1756158863113;
        Mon, 25 Aug 2025 14:54:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQEDzQ15G4rYzJDAIr+leDsCSs9V6r+VT1nFdg7y+XkefGZ8cay0aY5yb38za5ejvfkweA7g==
X-Received: by 2002:a05:6602:2c10:b0:87c:32d1:3b84 with SMTP id ca18e2360f4ac-886bd202301mr688402539f.3.1756158862694;
        Mon, 25 Aug 2025 14:54:22 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-886c8fc6b0dsm540240839f.20.2025.08.25.14.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 14:54:21 -0700 (PDT)
Date: Mon, 25 Aug 2025 15:54:20 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Farhan Ali <alifm@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, helgaas@kernel.org, schnelle@linux.ibm.com,
 mjrosato@linux.ibm.com
Subject: Re: [PATCH v2 2/9] PCI: Add additional checks for flr and pm reset
Message-ID: <20250825155420.2ace4847.alex.williamson@redhat.com>
In-Reply-To: <20250825171226.1602-3-alifm@linux.ibm.com>
References: <20250825171226.1602-1-alifm@linux.ibm.com>
	<20250825171226.1602-3-alifm@linux.ibm.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 25 Aug 2025 10:12:19 -0700
Farhan Ali <alifm@linux.ibm.com> wrote:

> If a device is in an error state, then any reads of device registers can
> return error value. Add addtional checks to validate if a device is in an
> error state before doing an flr or pm reset.

I think the thing we see in practice for a device that's wedged and
returning -1 from config space is that the FLR will timeout waiting for
a pending transaction.  So this should fix that, but should we log
something?

I'm assuming AF FLR is not needed here because we don't cache the
offset and therefore won't find the capability when we search the chain
for it.

> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
>  drivers/pci/pci.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 0dd95d782022..a07bdb287cf3 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -4560,12 +4560,17 @@ EXPORT_SYMBOL_GPL(pcie_flr);
>   */
>  int pcie_reset_flr(struct pci_dev *dev, bool probe)
>  {
> +	u32 reg;
> +
>  	if (dev->dev_flags & PCI_DEV_FLAGS_NO_FLR_RESET)
>  		return -ENOTTY;
>  
>  	if (!(dev->devcap & PCI_EXP_DEVCAP_FLR))
>  		return -ENOTTY;
>  
> +	if (pcie_capability_read_dword(dev, PCI_EXP_DEVCAP, &reg))
> +		return -ENOTTY;
> +
>  	if (probe)
>  		return 0;
>  
> @@ -4640,6 +4645,8 @@ static int pci_pm_reset(struct pci_dev *dev, bool probe)
>  		return -ENOTTY;
>  
>  	pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &csr);
> +	if (PCI_POSSIBLE_ERROR(csr))
> +		return -ENOTTY;

Doesn't this turn out to be redundant to the test below?

>  	if (csr & PCI_PM_CTRL_NO_SOFT_RESET)
>  		return -ENOTTY;
>  

Thanks,
Alex


