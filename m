Return-Path: <kvm+bounces-34348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 260999FB3E5
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 19:15:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9322D16667C
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 18:15:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD6DB1BBBFD;
	Mon, 23 Dec 2024 18:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QfNHQPaO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F60A1AF0AF
	for <kvm@vger.kernel.org>; Mon, 23 Dec 2024 18:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734977735; cv=none; b=rNdM/S8dP+OPTLlLsAwn7y/qBc/1a0FYBrYkne6Rve93E/qRPZWNTEGDTbA7efGyjlfyae1D7GRbo7tMmTSDbRJfd0MgrZOXST6b4ziMQlZ6xJj53sPYwZ5NL/CFMp0y2/H8Ul26Lh4JPY1oUb9L/H+EpUwODtEad6iiPvxzVTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734977735; c=relaxed/simple;
	bh=8pDFmu8/1sF75hrfCbh9g3oxXjJ5jWjyvYPRTNtqsUg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y+XT0JEMI8bvyg34mQI5GBIxA/9BGmDVdoHW4W//rIW1TERuwiHch8aRA+b4TBCIGSUtuVdiqbrOa53MiZn3JOjT082wkYJ7mYfjMQ8EBEhHh/ET4FeaG3+OfVj5xy9J8aTvT/AevEU08HjVIDnMUIo1SdHqzPe1VFs+rSlLXEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QfNHQPaO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734977731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i779kwZKwslACzFfkM+4lV0vJyXdo9Mbz+mQvKzFbgg=;
	b=QfNHQPaO71IQxC+QAE2DCoX7Dle1tS/1dXDpUOjYJ2T/dBo/3pfbY59sGak3hH/PRM4gbU
	YJsX+lsB0boHMMGHyH8hpaITjbgUyMLU91QubJYwhF03WvdwstPyOX9j+CFFZ6geS/jqez
	bElFkADmzMHsJUt/h0LK3D6d0Gii7pU=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-05cVCoy0MlaeMMD4QSZ1Ug-1; Mon, 23 Dec 2024 13:15:29 -0500
X-MC-Unique: 05cVCoy0MlaeMMD4QSZ1Ug-1
X-Mimecast-MFC-AGG-ID: 05cVCoy0MlaeMMD4QSZ1Ug
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-71fbb6e5b38so25826a34.1
        for <kvm@vger.kernel.org>; Mon, 23 Dec 2024 10:15:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734977728; x=1735582528;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i779kwZKwslACzFfkM+4lV0vJyXdo9Mbz+mQvKzFbgg=;
        b=AnPppPxfgMNZ3NKzY/dbywkGtVCMHPoVrNoQHK8phju+DXM6dg7ekfVVmHUz8IJYJj
         ndssKkFREMCLtNz2tKzKF97k1FjWQ6qgnPoJ0B4GQzGxJxhUEmYH/zzpsihLApe9RZw3
         OK18d4I8H1jBHYA4n5fO20bu6dgt6pDQtvIN06+YyTPr73ve8KSSUW3n1YJtoVbEdHwO
         lGayMgGb5ibzy3lrj9yMNPCfWcSC+tpEww2AjvmqUVVOl4nY8pfK4NAw8RkcUcAp40xK
         WANhENXncyQUONgCQxuKpnPkGlXlJiPXHI42YxtTEqskWiGj4Anhijt5JKJJaiUEc/w5
         9K4w==
X-Forwarded-Encrypted: i=1; AJvYcCVOpiuBmJsVGUUao/HReWGwj/pinvGP8Z7VqOmyqnbGHb3Mjx416293fviXbFjVXDMZUCo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlOHiFehOQVHrkyt0w1aaK3vg8dKVBW6plxOtXhkhTlk0LFv4r
	WKG0b2fUJCkRncbRNttiuan0Xnq/y0nwn8CW2cyaGaDX+1nkFFaTwIPNtS+h4+yWpYo3kT14dx1
	xzTuVySDBGReYUqPzsTso57Yfpe1/gLNNsCf0ojjoCId29CVlAA==
X-Gm-Gg: ASbGnctE8yHCi0XtgRKcUNp8Q1EB+zgoRTAS+ukk++GmFaaDo5J52AzFqfbdnyqMThf
	Gjs+LqNRUmoG/woF5XwLytXtqLAPyiHaQ81XpBopoaHmsJQqwYH0p5LZ/y3HEK+7GQn+K91budJ
	kzRwggc+a8g8UHXwpSzJWKEgApVg2F16g+7xRnqzeDdnC9oFT8BY0weY6R6DAr27XKQL3anR8w9
	fBUBKmD8BlnS19/msVrOLy1G7m+qMsHDMWRp0qt3Ilz1N4ad+E4LxsqE71a
X-Received: by 2002:a05:6830:34a9:b0:71e:48b1:ad29 with SMTP id 46e09a7af769-720ff691e28mr2341871a34.2.1734977728568;
        Mon, 23 Dec 2024 10:15:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHL84ulGDZQJL2507Y3H15s+slqjLTXHJpf42Oh15OEYbs2ukq1so9LGjZjnTqyXM9iw8VcMg==
X-Received: by 2002:a05:6830:34a9:b0:71e:48b1:ad29 with SMTP id 46e09a7af769-720ff691e28mr2341863a34.2.1734977728249;
        Mon, 23 Dec 2024 10:15:28 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-71fc97642e8sm2400002a34.5.2024.12.23.10.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Dec 2024 10:15:27 -0800 (PST)
Date: Mon, 23 Dec 2024 11:15:25 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Peter Xu <peterx@redhat.com>, Athul Krishna
 <athul.krishna.kr@protonmail.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
 "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: Re: [bugzilla-daemon@kernel.org: [Bug 219619] New: vfio-pci: screen
 graphics artifacts after 6.12 kernel upgrade]
Message-ID: <20241223111525.0249057e.alex.williamson@redhat.com>
In-Reply-To: <Z2mW2k8GfP7S0c5M@x1n>
References: <20241222223604.GA3735586@bhelgaas>
	<Hb6kvXlGizYbogNWGJcvhY3LsKeRwROtpRluHKsGqRcmZl68J35nP60YdzW1KSoPl5RO_dCxuL5x9mM13jPBbU414DEZE_0rUwDNvzuzyb8=@protonmail.com>
	<Z2mW2k8GfP7S0c5M@x1n>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 23 Dec 2024 11:59:06 -0500
Peter Xu <peterx@redhat.com> wrote:

> On Mon, Dec 23, 2024 at 07:37:46AM +0000, Athul Krishna wrote:
> > Can confirm. Reverting f9e54c3a2f5b from v6.13-rc1 fixed the problem.  
> 
> I suppose Alex should have some more thoughts, probably after the holidays.
> Before that, one quick question to ask..

Yeah, apologies in advance for latency over the next couple weeks.

> > -------- Original Message --------
> > On 23/12/24 04:06, Bjorn Helgaas <helgaas@kernel.org> wrote:
> >   
> > >  Forwarding since not everybody follows bugzilla.  Apparently bisected
> > >  to f9e54c3a2f5b ("vfio/pci: implement huge_fault support").
> > >  
> > >  Athul, f9e54c3a2f5b appears to revert cleanly from v6.13-rc1.  Can you
> > >  verify that reverting it is enough to avoid these artifacts?
> > >  
> > >  #regzbot introduced: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> > >  
> > >  ----- Forwarded message from bugzilla-daemon@kernel.org -----
> > >  
> > >  Date: Sat, 21 Dec 2024 10:10:02 +0000
> > >  From: bugzilla-daemon@kernel.org
> > >  To: bjorn@helgaf9e54c3a2f5bas.com
> > >  Subject: [Bug 219619] New: vfio-pci: screen graphics artifacts after 6.12 kernel upgrade
> > >  Message-ID: <bug-219619-41252@https.bugzilla.kernel.org/>
> > >  
> > >  https://bugzilla.kernel.org/show_bug.cgi?id=219619
> > >  
> > >              Bug ID: 219619
> > >             Summary: vfio-pci: screen graphics artifacts after 6.12 kernel
> > >                      upgrade
> > >             Product: Drivers
> > >             Version: 2.5
> > >            Hardware: AMD
> > >                  OS: Linux
> > >              Status: NEW
> > >            Severity: normal
> > >            Priority: P3
> > >           Component: PCI
> > >            Assignee: drivers_pci@kernel-bugs.osdl.org
> > >            Reporter: athul.krishna.kr@protonmail.com
> > >          Regression: No
> > >  
> > >  Created attachment 307382  
> > >    --> https://bugzilla.kernel.org/attachment.cgi?id=307382&action=edit  
> > >  dmesg  
> 
> vfio-pci 0000:03:00.0: vfio_bar_restore: reset recovery - restoring BARs

Is the reset recovery message seen even with the suspect commit
reverted?  Timestamps here would be useful for correlation.

> pcieport 0000:00:01.1: AER: Multiple Uncorrectable (Non-Fatal) error message received from 0000:03:00.1
> vfio-pci 0000:03:00.0: PCIe Bus Error: severity=Uncorrectable (Non-Fatal), type=Transaction Layer, (Requester ID)
> vfio-pci 0000:03:00.0:   device [1002:73ef] error status/mask=00100000/00000000
> vfio-pci 0000:03:00.0:    [20] UnsupReq               (First)
> vfio-pci 0000:03:00.0: AER:   TLP Header: 60001004 000000ff 0000007d fe7eb000
> vfio-pci 0000:03:00.1: PCIe Bus Error: severity=Uncorrectable (Non-Fatal), type=Transaction Layer, (Requester ID)
> vfio-pci 0000:03:00.1:   device [1002:ab28] error status/mask=00100000/00000000
> vfio-pci 0000:03:00.1:    [20] UnsupReq               (First)
> vfio-pci 0000:03:00.1: AER:   TLP Header: 60001004 000000ff 0000007d fe7eb000
> vfio-pci 0000:03:00.1: AER:   Error of this Agent is reported first
> pcieport 0000:02:00.0: AER: broadcast error_detected message
> pcieport 0000:02:00.0: AER: broadcast mmio_enabled message
> pcieport 0000:02:00.0: AER: broadcast resume message
> pcieport 0000:02:00.0: AER: device recovery successful
> pcieport 0000:02:00.0: AER: broadcast error_detected message
> pcieport 0000:02:00.0: AER: broadcast mmio_enabled message
> pcieport 0000:02:00.0: AER: broadcast resume message
> pcieport 0000:02:00.0: AER: device recovery successful
> 
> > >  
> > >  Device: Asus Zephyrus GA402RJ
> > >  CPU: Ryzen 7 6800HS
> > >  GPU: RX 6700S
> > >  Kernel: 6.13.0-rc3-g8faabc041a00
> > >  
> > >  Problem:
> > >  Launching games or gpu bench-marking tools in qemu windows 11 vm will cause
> > >  screen artifacts, ultimately qemu will pause with unrecoverable error.  
> 
> Is there more information on what setup can reproduce it?
> 
> For example, does it only happen with Windows guests?  Does the GPU
> vendor/model matter?

And the CPU vendor, this was predominately tested by me on Intel +
NVIDIA.  I'm also not seeing any similar reports on r/VFIO, which is a
bit strange as there are a lot of bleeding edge users there.  The bz is
reported against 6.13.0-rc3-g8faabc041a00 and a revert against
v6.13-rc1 was reported as stable.  Has this actually been confirmed on
v6.12, or might something in v6.13-rc have introduced a new issue?

> > >  Commit:
> > >  f9e54c3a2f5b79ecc57c7bc7d0d3521e461a2101 is the first bad commit
> > >  commit f9e54c3a2f5b79ecc57c7bc7d0d3521e461a2101
> > >  Author: Alex Williamson <alex.williamson@redhat.com>
> > >  Date:   Mon Aug 26 16:43:53 2024 -0400
> > >  
> > >      vfio/pci: implement huge_fault support  
> 
> Personally I have no clue yet on how this could affect it.  I was initially
> worrying on any implicit cache mode changes on the mappings, but I don't
> think any of such was involved in this specific change.
> 
> This commit majorly does two things: (1) allow 2M/1G mappings for BARs
> instead of small 4Ks always, and (2) always lazy faults rather than
> "install everything in the 1st fault".  Maybe one of the two could have
> some impact in some way.

Athul, can you test reverting both f9e54c3a2f5b and d71a989cf5d9?  That
would provide the faulting behavior without yet making use of huge
pfnmaps.  Thanks,

Alex


