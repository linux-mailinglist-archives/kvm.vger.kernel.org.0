Return-Path: <kvm+bounces-32576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 20F609DAC59
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 18:23:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5BD3CB2179C
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 17:22:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12C7C20102E;
	Wed, 27 Nov 2024 17:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CkC26/F+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8C21FF7BB
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732728171; cv=none; b=q4qd30MDeO1v8x6jUiKDsbc5K0DG7wPfwTy4tev+4mWigKb8enUjNpmqr5WxwYfpZCCIB/WMDygl9uvGKJ3JNumxnYbdTSpHsNhj0fWM2My7/Wx66GVPT1bbftf3Y+KMHJM0TP2SuWMfbwTfIvFr6rJ4VZZUA6z9NfttuxSU1II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732728171; c=relaxed/simple;
	bh=udRSauQ8v0m45QJa02tpuWABp6MhR6MgqKOiA1qUWyg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lX+hu8n8FQVA2pmK9X6KJEkaIUhg6bAN4hMvQamPp6OKFefa1OSzZ+3Y30H0TkxlRgqjjdgd0jeOn/jm1Dr/E0mXenjYjoEu1zDUGc6iMX7Bo3Fq4FORgmHq/Ir6wENLT8Y3bg/mxbe5AAuzj78dHPaJ3X1dkRebbEngPjlJ+ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CkC26/F+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732728168;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W9zax/CHaztlMaSgeA0GgU43P1mgjhVVVedx0D3zKOY=;
	b=CkC26/F+KE1Qm4TVnxGq1tRbGD66ty8IpqptluLtPT8kbMIDbnr8sphtugpAHmzk3nYZRu
	MgK5HlFvfyg9RUz2+a5YnOBoAQBozzNkRpq+ByX+SwB1Q1Di131Iuke5Qv0smHbdSnWKDd
	OYzXiqcTTiEu/snwQFI0NBnTYh88g8Y=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-17-3dxrvFq8N82rMNZ4GXUZRw-1; Wed, 27 Nov 2024 12:22:47 -0500
X-MC-Unique: 3dxrvFq8N82rMNZ4GXUZRw-1
X-Mimecast-MFC-AGG-ID: 3dxrvFq8N82rMNZ4GXUZRw
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a763b3bac5so9230545ab.1
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 09:22:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732728166; x=1733332966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W9zax/CHaztlMaSgeA0GgU43P1mgjhVVVedx0D3zKOY=;
        b=ed7NsfLvwHS5WtMcVMxItea/5v9gIF4sjCsgwyMOM9Xmo10F5fBT0ckpH6Miil+z6J
         nE9WA1u9feGK6VRXZheYMMomdEzrUbiqRyILIkvrzECIk6Uqi038tUlbRjok1CH/WKHe
         tvxyq+GhHqjuf0TKlnHMYSRbQKokPV3aPNLEcwTO6J3P9p1Pd5oC6m2C4dbWSqa/KbbM
         vSO1u6+SHvahEo54B9NgXSxALIIxn54GIaBNGZIGFFJJW4oinA4vLqgBtBbEvMFZx2Im
         oMnFdheZHIZsMwgyETiledraiwUVEWFMmxkw0/5T/N1UtESleK2zvp8u2t8hVL9KYKYf
         bEZA==
X-Forwarded-Encrypted: i=1; AJvYcCXr3WDSi2Qd5hwnYx2YObjd5GSh483OD8VsrPeb2k8+amZE7A/2raXIGTGhINfZ4K557uk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPGSpnUlVProq9Qf9y4WxyHDY5hi3LtVS+2o2BsKcF8KiFLbtr
	8x6NGQHudlO091yc4YVfJOpGNMlDlsRIBxumLDMVwJlOqjNY4jMv8FadH2l6hyuRu+z/HdtcJMJ
	KHXdX98zXPDmSIWhipPL1RPNat/s6zsZ9ixPPyXsPT/asLZ5sKA==
X-Gm-Gg: ASbGncs7woo+b8OBjTUhKLvfwBRDvTvIDbSqJAMs+tRLSoNyormBOziMe6YaB5w5Iig
	zA4m8qpV8lwnDommBPVY5DK4tcC0T6ypMWmfJUZzN2M4PmGSxRd11Fx4Olmu3TRJzxe61KHoWEO
	+Rt3jKr5qkCpztBMXCRZOntJnXv7XyJUbXi1WO+lI8cDhLctFIyEUg4HOMnUjA660H4FQ/pGZFB
	ISH2LqntqzvPIz2r4zncXdXly1PdrKtux9lO+WcZL5moVL4u18nZA==
X-Received: by 2002:a05:6e02:1785:b0:3a7:bd4c:b17e with SMTP id e9e14a558f8ab-3a7c544a689mr11641925ab.0.1732728166285;
        Wed, 27 Nov 2024 09:22:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFgahiLZdXLot24IB4E3W1bQXNAY3TqwQBGglHBYwgd/Sn9n6D44soFsrc5jyVRxyY14SiM6Q==
X-Received: by 2002:a05:6e02:1785:b0:3a7:bd4c:b17e with SMTP id e9e14a558f8ab-3a7c544a689mr11641795ab.0.1732728165925;
        Wed, 27 Nov 2024 09:22:45 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a79acbdf6asm27282405ab.77.2024.11.27.09.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2024 09:22:45 -0800 (PST)
Date: Wed, 27 Nov 2024 10:22:43 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Mitchell Augustin <mitchell.augustin@canonical.com>
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org, Bjorn Helgaas
 <bhelgaas@google.com>, linux-kernel@vger.kernel.org
Subject: Re: drivers/pci: (and/or KVM): Slow PCI initialization during VM
 boot with passthrough of large BAR Nvidia GPUs on DGX H100
Message-ID: <20241127102243.57cddb78.alex.williamson@redhat.com>
In-Reply-To: <CAHTA-uY3pyDLH9-hy1RjOqrRR+OU=Ko6hJ4xWmMTyoLwHhgTOQ@mail.gmail.com>
References: <CAHTA-uYp07FgM6T1OZQKqAdSA5JrZo0ReNEyZgQZub4mDRrV5w@mail.gmail.com>
	<20241126103427.42d21193.alex.williamson@redhat.com>
	<CAHTA-ubXiDePmfgTdPbg144tHmRZR8=2cNshcL5tMkoMXdyn_Q@mail.gmail.com>
	<20241126154145.638dba46.alex.williamson@redhat.com>
	<CAHTA-uZp-bk5HeE7uhsR1frtj9dU+HrXxFZTAVeAwFhPen87wA@mail.gmail.com>
	<20241126170214.5717003f.alex.williamson@redhat.com>
	<CAHTA-uY3pyDLH9-hy1RjOqrRR+OU=Ko6hJ4xWmMTyoLwHhgTOQ@mail.gmail.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 26 Nov 2024 19:12:35 -0600
Mitchell Augustin <mitchell.augustin@canonical.com> wrote:

> Thanks for the breakdown!
> 
> > That alone calls __pci_read_base() three separate times, each time
> > disabling and re-enabling decode on the bridge. [...] So we're
> > really being bitten that we toggle decode-enable/memory enable
> > around reading each BAR size  
> 
> That makes sense to me. Is this something that could theoretically be
> done in a less redundant way, or is there some functional limitation
> that would prevent that or make it inadvisable? (I'm still new to pci
> subsystem debugging, so apologies if that's a bit vague.)

The only requirement is that decode should be disabled while sizing
BARs, the fact that we repeat it around each BAR is, I think, just the
way the code is structured.  It doesn't take into account that toggling
the command register bit is not a trivial operation in a virtualized
environment.  IMO we should push the command register manipulation up a
layer so that we only toggle it once per device rather than once per
BAR.  Thanks,

Alex


