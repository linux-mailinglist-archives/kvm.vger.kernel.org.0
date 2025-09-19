Return-Path: <kvm+bounces-58175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94056B8AE32
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 20:18:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 995243A9A3C
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 18:17:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ED8E25CC64;
	Fri, 19 Sep 2025 18:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZFDgsxG8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B36A227BA4
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 18:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758305869; cv=none; b=Sl6hpNZ80YUCcN/C98F609oBSTOYRRmnryQ3PqxU+WSwS2MARUuv7YhpI/LM53vqb6i02uHRKnnEg9B9wInS+5zjNXLZxdBmCrgDLXZagy9ZKslfk3j0Rt/aPtiRT/1gaP9C3t7tJAoWdEvyWLkSRdF8GOPV64i3AybVds+S85k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758305869; c=relaxed/simple;
	bh=UYQ/heBMSwesBf4ndeJdw8Tnd7iUiwyxPBtUng/3UNg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bKszSdUft7Zf9zQUHWx4WSzaX5tbBJs4MVtgvZxHmpw1IGjEtYfX77/OhKt6iUVlymAas4qU8Co3UKTjemuGDeHQbaUHFDvUFjIdq3CXysNsA6LrTipiuQvLSiVbn9xbAIaWEWSNySOSQPsAPXN/TjrUjrSATbPx7RJyhAz6DkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZFDgsxG8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758305866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2tP8qgX24boDvqrfxOc41UrXAFnZAOnA7a7ICmrly80=;
	b=ZFDgsxG8nPh/yYgJcznsBtfXi8gX+MzsKd5dGcZr2WnfJvNpMtrTVJuq6IWJKEVO++SIYj
	2wqG+ZIF4oyAkUQyUMywf3MzOldNeuSZowc2M2PvvCN5S8+DMLHit9gh6VAUbhG+Ku/wZv
	Mx+abhkQcER3kTphMXb6mku3tg+GBl8=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-0ArZ836_NBih3OSRcLxLMw-1; Fri, 19 Sep 2025 14:17:44 -0400
X-MC-Unique: 0ArZ836_NBih3OSRcLxLMw-1
X-Mimecast-MFC-AGG-ID: 0ArZ836_NBih3OSRcLxLMw_1758305864
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-4248b4d6609so476215ab.3
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 11:17:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758305863; x=1758910663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2tP8qgX24boDvqrfxOc41UrXAFnZAOnA7a7ICmrly80=;
        b=FJq4ygWlOYaqdNA627I5g/msMjnaxMSbhCimKthIAFrUBkxtuLCoHLhZsI69XuZf07
         wbIAQJt53ng8XY9q9qd5pRuWrH8mAmaIxxNhBlcgFYuK+PQpIbvn0fBDfEAlRKe+dzyi
         N/BPSs2dkkn4AhXUtiUtqtpGPVjafrTzFLBHKWL3pwzBoW75xXkRadkz7tl/zhDRwb4o
         IzpXWTbh5ntp0CMXWAVJH1nw8gbj8Dr+b/QuKoP/c7PEa7jhIao1RXVSrf7QkLt7ZuII
         YnRTxiYG9gQxHtobbFtE58zGBxbW5gnP+/t/2ivO/6ZoIhuU75XdioPFwK9a8L5UIKCf
         CbLw==
X-Forwarded-Encrypted: i=1; AJvYcCVpNJfLOoIERi1+6gYWnAyQfxvg4Yak+mnydLGbyHYCpGYMN4xkQHdwtxgXKaQ5u+ZSCR0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5DtqNBGi+UVGsHEywEaaYnDcDpFxeaPausI2AIL99TJ/QCy8c
	KQ6DE7Dq5082X2tA2kZsPe4FfI4J2z9qg55zhQKs3ETU+1+94RIJ7Ycg9w/BNg9UIW1uSCoVgU2
	Oh8Dnp95/2xeuxLsRKBm2ieYUKDN/R0dTj/YR2uDc+mggkEqPu8jLUnIfEsmdOg==
X-Gm-Gg: ASbGnctkHsDx9GyX6pjInlr0VCT3wuRh4tGkc8Li3UFtiqWxE9OpkeGBcNhxLwyzDIz
	iCjBVjNaxagbZewvYXUkBvB80hiPuPD/uQ66fxvRlW2IeUIRsK/TgAdS5ag9c3R8joswQIwnpsF
	7YdtbgPxDtO6+g1iw8XjXVIpKYbSLZdlbwKe4QcYI+s3Nj0lfOzRLMHq0IWz4HzrlAXgfwvFPYq
	ndu87YznkNChLV1Iawa3Jj0tTi34moHK2/cW5NucicL1f7WX8/29ngwmr62YGupzeadubv+hFxo
	4oEhADu2g7M1WUKF3rcfHVRzTr1jssOo2DZMMr5QcQE=
X-Received: by 2002:a05:6e02:1d9d:b0:424:69b:e8d0 with SMTP id e9e14a558f8ab-4248190395emr19310685ab.1.1758305863189;
        Fri, 19 Sep 2025 11:17:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGb10MnB7zhkH1dVW9AEzJVk+z8ybEB8AlSck6uXI8Tp5xc6aeeZCL649awhtncJC1hXa8bVg==
X-Received: by 2002:a05:6e02:1d9d:b0:424:69b:e8d0 with SMTP id e9e14a558f8ab-4248190395emr19310505ab.1.1758305862772;
        Fri, 19 Sep 2025 11:17:42 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-4244afa9f6fsm24280945ab.22.2025.09.19.11.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 11:17:42 -0700 (PDT)
Date: Fri, 19 Sep 2025 12:17:39 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Farhan Ali <alifm@linux.ibm.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-pci@vger.kernel.org, schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: Re: [PATCH v3 01/10] PCI: Avoid saving error values for config
 space
Message-ID: <20250919121739.53f79518.alex.williamson@redhat.com>
In-Reply-To: <d6655c44-ca97-4527-8788-94be2644c049@linux.ibm.com>
References: <20250916180958.GA1797871@bhelgaas>
	<d6655c44-ca97-4527-8788-94be2644c049@linux.ibm.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 16 Sep 2025 13:00:30 -0700
Farhan Ali <alifm@linux.ibm.com> wrote:

> On 9/16/2025 11:09 AM, Bjorn Helgaas wrote:
> > On Thu, Sep 11, 2025 at 11:32:58AM -0700, Farhan Ali wrote:  
> >> The current reset process saves the device's config space state before
> >> reset and restores it afterward. However, when a device is in an error
> >> state before reset, config space reads may return error values instead of
> >> valid data. This results in saving corrupted values that get written back
> >> to the device during state restoration.
> >>
> >> Avoid saving the state of the config space when the device is in error.
> >> While restoring we only restorei the state that can be restored through
> >> kernel data such as BARs or doesn't depend on the saved state.
> >>
> >> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> >> ---
> >>   drivers/pci/pci.c      | 29 ++++++++++++++++++++++++++---
> >>   drivers/pci/pcie/aer.c |  5 +++++
> >>   drivers/pci/pcie/dpc.c |  5 +++++
> >>   drivers/pci/pcie/ptm.c |  5 +++++
> >>   drivers/pci/tph.c      |  5 +++++
> >>   drivers/pci/vc.c       |  5 +++++
> >>   6 files changed, 51 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> >> index b0f4d98036cd..4b67d22faf0a 100644
> >> --- a/drivers/pci/pci.c
> >> +++ b/drivers/pci/pci.c
> >> @@ -1720,6 +1720,11 @@ static void pci_restore_pcie_state(struct pci_dev *dev)
> >>   	struct pci_cap_saved_state *save_state;
> >>   	u16 *cap;
> >>   
> >> +	if (!dev->state_saved) {
> >> +		pci_warn(dev, "Not restoring pcie state, no saved state");
> >> +		return;  
> Hi Bjorn
> 
> Thanks for taking a look.
> 
> > Seems like a lot of messages.  If we want to warn about this, why
> > don't we do it once in pci_restore_state()?  
> 
> I thought providing messages about which state is not restored would be 
> better and meaningful as we try to restore some of the state. But if the 
> preference is to just have a single warn message in pci_restore_state 
> then I can update it. (would also like to hear if Alex has any 
> objections to that)

I thought it got a bit verbose as well.

> > I guess you're making some judgment about what things can be restored
> > even when !dev->state_saved.  That seems kind of hard to maintain in
> > the future as other capabilities are added.
> >
> > Also seems sort of questionable if we restore partial state and keep
> > using the device as if all is well.  Won't the device be in some kind
> > of inconsistent, unpredictable state then?

To an extent that's always true.  Reset is a lossy process, we're
intentionally throwing away the internal state of the device and
attempting to restore the architected config space as best as we can.
It's hard to guarantee it's complete though.

In this case we're largely just trying to determine whether the
pre-reset config space is already broken, which would mean that some
forms of reset are unavailable and our restore data is bogus.  In
addition to the s390x specific scenario resolved here, I hope this
might eliminate some of the "device stuck in D3" or "device stuck with
pending transaction" errors we currently see trying to do PM or FLR
resets on broken devices.  Failing to actually reset the device in any
way, then trying to write back -1 for restore data is what we'd see
today, which also isn't what we intend.

It probably doesn't make sense to note the specific capabilities that
aren't being restored.  Probably a single pci_warn indicating the
device config space is inaccessible prior to reset and will only be
partially restored is probably sufficient.  Thanks,

Alex


