Return-Path: <kvm+bounces-55760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 388ACB36F09
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 17:57:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB7FB981A5D
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 15:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AC2536CC6C;
	Tue, 26 Aug 2025 15:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FoTyejyk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E514D34F464
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 15:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756223334; cv=none; b=Mqejw7ymJz5TKbV1DLnVZQyGUKu7EemqqX5WV/+crcvaY+A1KHAnOAVQQiPwG13IpCQuf54keMPFqFuTSh8oQtBpJmBSen/m0a8yu/vAek2pLJ4WSQIeVFWUxCNA/C41m0V5KgH46PuBBgjlHs1hlJppOhUc5pc8Ovhe18g1CgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756223334; c=relaxed/simple;
	bh=Y0eks1YaOqbzuug07KZLAOR4Y6H+hh0TiHWBe8OcU2k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AHw/+u5/WfiJN18KlyWi7BErOlxO9k6ytrK+mpMFy3lL9Y/5b80iE+QwQJS8n5CDWTjvfhjTil5MlsVCyrE8Lqhctkf77PHICJl8jKIrgg7B1GqOdaGHIIk42MGGhDqd5Hqeza9/rFtQD9vr7tJWG+zjetKX0lMjTbKBnlHgddU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FoTyejyk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756223331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BHNXd9VyNqrFX2UZhtEPC0je8otxXnW6I6u8evl0zzQ=;
	b=FoTyejykliqyIqZIaV0XHfj+Ua60Iq6SBKYCJOkQIvnlpC3NX6xIgbx4WHnpDq/nCGyWjI
	DbfiST88pOQMuk9MVdV95HzwF2qGbxl63pnm2+QIYidIOna63PeaoPxggvtHymQvGXV9VD
	+3NJUr26qf9mTodnjvqOI0Ahx3airXA=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-xqr5HkU_NoGmKfxbF4iVWw-1; Tue, 26 Aug 2025 11:48:50 -0400
X-MC-Unique: xqr5HkU_NoGmKfxbF4iVWw-1
X-Mimecast-MFC-AGG-ID: xqr5HkU_NoGmKfxbF4iVWw_1756223329
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3ec9adc1255so5866295ab.3
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 08:48:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756223329; x=1756828129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BHNXd9VyNqrFX2UZhtEPC0je8otxXnW6I6u8evl0zzQ=;
        b=SMxSyoyAUv38EbLk2DmV5ty4p+RNONfBSwTYHtPX/HwDuzyVeM+zwUSTZ4MDorAoPG
         n9pzkLWWCSrM0riWoJRe8Axl54/oQb10KFDY9YUlYCX/GFvQnP6WWTBYlKax/J30lrOk
         vmanu3ameudra/zF5CmXYynUFW9XK+N7v9VeYadHnkUe8p2b+jFObQyO7kgNlEoUMvwg
         Y74vNuJ+IH5CecYVMMsXUvreIVN3Cgc9OVlUAPpi/10LnL9f95EdM0vuauqasrhtOfGG
         1p9rcrNIDVevk5oLDf/xWZeT3s/Is4nRERzDhduGCHG5PM6TTIdZKRh0grlxklFk/oZ2
         kopg==
X-Forwarded-Encrypted: i=1; AJvYcCXSYajNZKRQaRsPb7qokLxpbWbpqNORMaI/KKKOX9yGnr6R/gZlxNw+oOuJ+oPE2Y69vyI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxK+N/8E7napKm2Ew2ECUaHp+7JF4L0aFjY+4rO4tXTQ9vs+3KY
	Ch0OBt4t2f6JuuXmXIF/e10jpspFI7T5x1QyP1oHy/ChxiG/gobIhNeCo/NRuQqT7upTaeXsI+T
	zD+UE/UXuKyrtwOHDSKrl9lNsJCnonH0odp+yyLqGOQsRTavvr+V3SQ==
X-Gm-Gg: ASbGncvbAU19B1xflNwY6Mf9wv6Rp7AV6AaqdDCg6DUfK7dQ54leCngMoy6jlJ96jaH
	Poc1xj6fr3Mdae8HkLLYMaMOaastXRawnNzymawJ0c7ciArq81lnvkTactUt5SGHKgUA9mMP8OE
	58r6DkxEX/X4u+ff5W6L3amYtsfznxgagOaOGCeAySzfc+A7nyZmXm0hHCGVL8509dA4dmzp1A/
	cbBhVvjwQRHZyeCW0qAGAtZf1BRJaDZlgjfvckTJx7hQjWy664eiV9d7i++sdBFij8UVUvAWZT+
	IFsqmTjtD7kE5JuMtiVwq5SOPlHux2VUNcWBXrDfz9U=
X-Received: by 2002:a05:6e02:1a48:b0:3e6:67f9:2061 with SMTP id e9e14a558f8ab-3e91cfae117mr88824255ab.0.1756223329385;
        Tue, 26 Aug 2025 08:48:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE41ooOBFFuOfcZRxU06TfSGWwzTnjM8fsjevvJOvWhDhebSC+xJEVzKrEMkNTbsTkk0XUw5w==
X-Received: by 2002:a05:6e02:1a48:b0:3e6:67f9:2061 with SMTP id e9e14a558f8ab-3e91cfae117mr88824085ab.0.1756223328938;
        Tue, 26 Aug 2025 08:48:48 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ea4ec1f6d0sm68656065ab.40.2025.08.26.08.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:48:47 -0700 (PDT)
Date: Tue, 26 Aug 2025 09:48:45 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Farhan Ali <alifm@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, helgaas@kernel.org, schnelle@linux.ibm.com,
 mjrosato@linux.ibm.com
Subject: Re: [PATCH v2 1/9] PCI: Avoid restoring error values in config
 space
Message-ID: <20250826094845.517e0fa7.alex.williamson@redhat.com>
In-Reply-To: <eb6d05d0-b448-4f4e-a734-50c56078dd9b@linux.ibm.com>
References: <20250825171226.1602-1-alifm@linux.ibm.com>
	<20250825171226.1602-2-alifm@linux.ibm.com>
	<20250825153501.3a1d0f0c.alex.williamson@redhat.com>
	<eb6d05d0-b448-4f4e-a734-50c56078dd9b@linux.ibm.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 25 Aug 2025 15:13:00 -0700
Farhan Ali <alifm@linux.ibm.com> wrote:

> On 8/25/2025 2:35 PM, Alex Williamson wrote:
> > On Mon, 25 Aug 2025 10:12:18 -0700
> > Farhan Ali <alifm@linux.ibm.com> wrote:
> >  
> >> The current reset process saves the device's config space state before
> >> reset and restores it afterward. However, when a device is in an error
> >> state before reset, config space reads may return error values instead of
> >> valid data. This results in saving corrupted values that get written back
> >> to the device during state restoration. Add validation to prevent writing
> >> error values to the device when restoring the config space state after
> >> reset.
> >>
> >> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> >> ---
> >>   drivers/pci/pci.c | 3 +++
> >>   1 file changed, 3 insertions(+)
> >>
> >> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> >> index b0f4d98036cd..0dd95d782022 100644
> >> --- a/drivers/pci/pci.c
> >> +++ b/drivers/pci/pci.c
> >> @@ -1825,6 +1825,9 @@ static void pci_restore_config_dword(struct pci_dev *pdev, int offset,
> >>   	if (!force && val == saved_val)
> >>   		return;
> >>   
> >> +	if (PCI_POSSIBLE_ERROR(saved_val))
> >> +		return;
> >> +
> >>   	for (;;) {
> >>   		pci_dbg(pdev, "restore config %#04x: %#010x -> %#010x\n",
> >>   			offset, val, saved_val);  
> >
> > The commit log makes this sound like more than it is.  We're really
> > only error checking the first 64 bytes of config space before restore,
> > the capabilities are not checked.  I suppose skipping the BARs and
> > whatnot is no worse than writing -1 to them, but this is only a
> > complete solution in the narrow case where we're relying on vfio-pci to
> > come in and restore the pre-open device state.
> >
> > I had imagined that pci_save_state() might detect the error state of
> > the device, avoid setting state_saved, but we'd still perform the
> > restore callouts that only rely on internal kernel state, maybe adding a
> > fallback to restore the BARs from resource information.  
> 
> I initially started with pci_save_state(), and avoid saving the state 
> altogether. But that would mean we don't go restore the msix state and 
> for s390 don't call arch_restore_msi_irqs(). Do you prefer to avoid 
> saving the state at all? This change was small and sufficient enough to 
> avoid breaking the device in my testing.

If we're only reading -1 from the device anyway, I'm not sure what
value we're adding to continue to save bogus data from the device.
There are also various restore sub-functions that don't need that saved
state, ex. PASID, PRI, ATS, REBAR, AER, MSI, MSIX, ACS, VF REBAR,
SRIOV.  We could push the state_saved check down into the functions
that do need the prior device state, add warnings and let the remaining
function proceed.  We really need to at least pull BAR values from
resources information for there to be a chance of a functional device
without relying on vfio-pci to restore that though.  Thanks,

Alex


