Return-Path: <kvm+bounces-32548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C94D9D9F4B
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 23:42:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F14F1B25D79
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 22:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D8961DFE23;
	Tue, 26 Nov 2024 22:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tl7s4hcK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A930A1DA632
	for <kvm@vger.kernel.org>; Tue, 26 Nov 2024 22:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732660912; cv=none; b=punwoRmoYGnuHo57f8dVCR1wEQabXMzgqUTtN002tqFOid5Sd4n9dtSEO8ypWEg+2fbWTHscH8iCmlfHnZNYr9OYs3p7DHeieZTocI5I3hlYx8DyyM5jBCYtStXWwTmPwhGEq5+cFyPIYES9dGwA/itlU04UC2bGkHR8BENGP08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732660912; c=relaxed/simple;
	bh=b7lCrDz13ILNM08LfCgzVYD9C9TH4sUkUGJSvBRHy9I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RihdHG12ljPelB/ayVE8p4tL6LBEELzrd5As2DbIQW05scnr7NbIC3xdBjSRpzncZF8rhGDCuLO+YLj5BjWLFGgTAasefs4uGlLddTesfxjK6z7SRrd6djz8KtZ4aAczcWLit9LxHWcRp05PGNFZ13E9x072nrR5M5spqPa2IO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tl7s4hcK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732660909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AjzLuFCAYERs3f8o3lK5yADWmxgixrnHXJ2IfNHbUqo=;
	b=Tl7s4hcKTCscNVwswKqdsKukeJ09sxMa6PI/mrj64TUVqlkeHz673QgAnREtcBoQITYvn+
	NgYMGtIfAu/iK3N9a+mbzC2YcqYr8IAeNxLAdHMQwuixuLvT3LGR+6I2tj3I29VievNg/C
	P2flu0V7iZxcgX3Fqr3K/286TxlFA3g=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-306-s1ifjZWsPkSImcQ5DHFTZw-1; Tue, 26 Nov 2024 17:41:47 -0500
X-MC-Unique: s1ifjZWsPkSImcQ5DHFTZw-1
X-Mimecast-MFC-AGG-ID: s1ifjZWsPkSImcQ5DHFTZw
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-8419d05aa7cso33184139f.0
        for <kvm@vger.kernel.org>; Tue, 26 Nov 2024 14:41:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732660907; x=1733265707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AjzLuFCAYERs3f8o3lK5yADWmxgixrnHXJ2IfNHbUqo=;
        b=p7LKyTngi+itsf61sOP6YAAt45qw0JEbZtPh+LlFTZItiDbcLNr05jDHG1gf/5LmJn
         7dDPdpCYhTotkqdprjfqK5bCFEQVHe7KCzoUcW+xAMvVNt+PwLfnhQgwugD/ZNVEsrSY
         DqIEfVTxiMY9cxsYGtLxMWrzEqYUMfvvdXz6YeTjBqxr+h9loP/Lp5i46GJ5LybIhSjt
         1qbxWGzIc/UgBpBDF2YIdxVYWA4AApo9fXfsBa6er6HrgwvFBXqlGcTgt0LeODFYfmMo
         gXLW3xAkOpbohWGGQ5+DWFSFl8Y4VSesuVlwIsHsOsHpcSV91l0iAdTo0IEWe8fdw43c
         +jjw==
X-Forwarded-Encrypted: i=1; AJvYcCV6SHYMYx5RchRk6T3HEVpUmawiI3AjWEAXAQlLzYQYCLoIRwyT9WXEF1zCq3EJ3h5CKjY=@vger.kernel.org
X-Gm-Message-State: AOJu0YztdFDQ+kep0I8EDHIe4HielTIOMp8ja69XgaevXdtr+vlygS5+
	1VxRbrHpl6aohTNGeoTwtIxU3YrfGbMVTqZhURbjOytezR/SkOCsI8UqjLKatxz7bs/6rhQtbyw
	bsV3hrrhDUTGiY7yQw0ikhcWFimFbn9ilLQGi+4UrLTNZxxyCtg==
X-Gm-Gg: ASbGncuo5x5Hap669AXShCndOokMumLGN5p7l1iCA0mt2Ak5Ndj2Uy/CPQMFf/jydL/
	wF9Xh6mdPKZfgneDm1uypO29bgY/vPxqJwu87S0Y9uwo4irtnjY/zfEOcCcqOdz4Y7qHA2dgrE7
	AH8noUn6Nz1VLg1VrDyR1MseoZ6H+BACjhKkDu2EZNU59vQSM8H8pv/nBtcnJtWex8sQ/b3Y1H4
	KUTjVGhJlGiUC/x6KD1dGbVzr8vAZmKIF/pfUDmazsZuby4LN+/Vg==
X-Received: by 2002:a05:6602:150b:b0:82a:a4f0:5084 with SMTP id ca18e2360f4ac-843ed0d8d35mr38815939f.4.1732660907268;
        Tue, 26 Nov 2024 14:41:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHQ7nxJJRG17OVR38I1h6QIFaT5CqYN0QEozIVMyIIuB4frEnlsLeSFJmypcdPsDIcw6V5jhg==
X-Received: by 2002:a05:6602:150b:b0:82a:a4f0:5084 with SMTP id ca18e2360f4ac-843ed0d8d35mr38815139f.4.1732660906981;
        Tue, 26 Nov 2024 14:41:46 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e1fcb97e1fsm1518271173.102.2024.11.26.14.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2024 14:41:46 -0800 (PST)
Date: Tue, 26 Nov 2024 15:41:45 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Mitchell Augustin <mitchell.augustin@canonical.com>
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org, Bjorn Helgaas
 <bhelgaas@google.com>, linux-kernel@vger.kernel.org
Subject: Re: drivers/pci: (and/or KVM): Slow PCI initialization during VM
 boot with passthrough of large BAR Nvidia GPUs on DGX H100
Message-ID: <20241126154145.638dba46.alex.williamson@redhat.com>
In-Reply-To: <CAHTA-ubXiDePmfgTdPbg144tHmRZR8=2cNshcL5tMkoMXdyn_Q@mail.gmail.com>
References: <CAHTA-uYp07FgM6T1OZQKqAdSA5JrZo0ReNEyZgQZub4mDRrV5w@mail.gmail.com>
	<20241126103427.42d21193.alex.williamson@redhat.com>
	<CAHTA-ubXiDePmfgTdPbg144tHmRZR8=2cNshcL5tMkoMXdyn_Q@mail.gmail.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 26 Nov 2024 16:18:26 -0600
Mitchell Augustin <mitchell.augustin@canonical.com> wrote:
> > The BAR space is walked, faulted, and mapped.  I'm sure you're at
> > least experiencing scaling issues of that with 128GB BARs.  
> 
> The part that is strange to me is that I don't see the initialization
> slowdown at all when the GPUs are hotplugged after boot completes.
> Isn't what you describe here also happening during the hotplugging
> process, or is it different in some way?

The only thing that comes to mind would be if you're using a vIOMMU and
it's configured in non-passthrough mode so the BARs aren't added to the
DMA address space after the vIOMMU is enabled during boot.  But your
virt-install command doesn't show a vIOMMU configuration for the VM.

If the slowness is confined to the guest kernel boot, can you share the
log of that boot with timestamps?  Thanks,

Alex


