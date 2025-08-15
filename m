Return-Path: <kvm+bounces-54809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EB0D6B2875C
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 22:49:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 37FB9189DAE6
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 20:49:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9154F242D6C;
	Fri, 15 Aug 2025 20:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ciqq6XpX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DDA26AF3
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 20:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755290944; cv=none; b=nH60eBdsNqwGVqv68wMdGcKX+DvCfNYQdgjdixkg7uBO4KJnw1dFgsz3GCNAXEP2MCRQS2OXQACl4IGDV0FWAv4dXZtYbtv2vgbJuFkXDbRO/euu0wJ9rVrs9tce7tD+dT8KpZH6U4gXtW7nsUGKZNcUwOOaEufbBtABkbYVW0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755290944; c=relaxed/simple;
	bh=coJD5zt20O9N4j84lqFB3HeMlhyWbtnt7oF12zKdrf8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ge0JbkXguSJzr+c1KspuBySx6lDoiqI/LEpiZQ5Mha/WXV3AjFiXF6NLkfZUd5MpOBH5rk7Qd76fFRfWqY9wjbYkftsKQCTXyf6MweNJEpx41p3iNQ9uw1uO6RjC29JwnRlsPOCYV/ssCip/VKBWRdBv6odBBxAgGyAKwIi+Yqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ciqq6XpX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755290941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RxQQKjb9DfbHLiLKKFOLHod9vjKmsoO2pBfbkqGt7+A=;
	b=Ciqq6XpXcsY4MqQ6ebjfR8K3lbEO0rY5rjQRtt8gVoOW1DU/GOUnOPczMOz/8XrZZEAdJe
	x+XsG6LlJnreWYpIXWPPeboASLcmRtbtV2TnnHV7m9fBo1C1RI+Hs/JgG/mXW/dmBH1M4P
	M7+55//c2uusz17VwngZZr7Mcd+6Q8I=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-PIJ9F1cyP4KmvSLxXIBqYg-1; Fri, 15 Aug 2025 16:49:00 -0400
X-MC-Unique: PIJ9F1cyP4KmvSLxXIBqYg-1
X-Mimecast-MFC-AGG-ID: PIJ9F1cyP4KmvSLxXIBqYg_1755290939
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3e57000f282so6458265ab.2
        for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 13:49:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755290939; x=1755895739;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RxQQKjb9DfbHLiLKKFOLHod9vjKmsoO2pBfbkqGt7+A=;
        b=sxtPT3UgmuwZF8voWC6jQk+bYdATA99H4Yh3PReh7Z8QP7ZTAqMxIlCrGe18ybP4ke
         tvOM8951IWEvYUxAJ80TFy2KloCBmHHyYtZajDh5z9wTmRrHzAiGTzdgfBReOmt2IkwD
         Ysp9wRPAWMVc7s2cKOYTnDwv66D8B7dTTyGgUd1lcT9lBGXdBge7CJneBlnuAY5Z0a2V
         GawqtkToWoyio2uNHGSveNAi0o8oSDHQeyT/M0oqnXftfjxr3KGR0FCt0R9S650seaaW
         A/buftTVNZX6FnClgWVPdeY41gZ1BUVV4A+XrUA3TI20Q5pZlL8EOBT46o6IZbGNUBwV
         vcyA==
X-Forwarded-Encrypted: i=1; AJvYcCWGq4Ql0+3xJhXD1p8OfeDIwfr1jez8z49mj3CHT3K41t6XWr0CA0iG3dFVt+slXt/zx0Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1dUVsvehNphjTXiuN9Q4LSlNKEvEQBv+Sh4EAt3qBoxpvN7uD
	FyicmJDlUCf+GowMLf88aHiYJDk+Qd//UO4E1HhtnLNPw3PHBtsMfqV8yEYYP2EATyJl/YfZGFg
	e8Frg2RPqPt1D7gRw+n9+58pcnkj6x8Eywz0+ET1MRA40WP9LpRO0jg==
X-Gm-Gg: ASbGncstrfxdFHFRyuks8kqSiQgd9MpYFqzvzVG19gE0vBnbQqEdXt0a0gCkCBxB0IG
	Gd5eYcQsleLa2dzJ02Yz7L2fM+0c/p3Kyh/wRC22h27FTrq/e5+7T7ifG3YVuiLN+GeWco2WUo6
	nr7WUB7ZfK0DgPhQplaz7mAyvGonhigxRsHWaDco2YqVWrzINnvVM+6TKWbha5WHySefNOBwdTP
	L3Q+gji4UD1CAMVFJetV6eDSEPbfFWrX7Kt52iVnxqVlaguYPbxDxdJ2UD9J8F8VyK7VpiHIpJo
	b2MTrpMybQgOrr7TrWqF9A6g2E98F4wU7vnW3dXbwdI=
X-Received: by 2002:a05:6e02:1889:b0:3dd:c947:b3a7 with SMTP id e9e14a558f8ab-3e57e9aa92cmr17440415ab.5.1755290939244;
        Fri, 15 Aug 2025 13:48:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEBEqL66ko0fvzn8eomIswOaFBFnW1Yg/xfXCXQYEyBW1J3DP6PPCIr+IIvwunh1IfBSp5G0A==
X-Received: by 2002:a05:6e02:1889:b0:3dd:c947:b3a7 with SMTP id e9e14a558f8ab-3e57e9aa92cmr17440355ab.5.1755290938868;
        Fri, 15 Aug 2025 13:48:58 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e57e67ab0csm8796525ab.26.2025.08.15.13.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 13:48:58 -0700 (PDT)
Date: Fri, 15 Aug 2025 14:48:55 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Farhan Ali <alifm@linux.ibm.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, schnelle@linux.ibm.com,
 mjrosato@linux.ibm.com
Subject: Re: [PATCH v1 6/6] vfio: Allow error notification and recovery for
 ISM device
Message-ID: <20250815144855.51f2ac24.alex.williamson@redhat.com>
In-Reply-To: <60855b41-a1ad-4966-aa5e-325256692279@linux.ibm.com>
References: <20250814204850.GA346571@bhelgaas>
	<60855b41-a1ad-4966-aa5e-325256692279@linux.ibm.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Aug 2025 14:02:05 -0700
Farhan Ali <alifm@linux.ibm.com> wrote:

> On 8/14/2025 1:48 PM, Bjorn Helgaas wrote:
> > On Wed, Aug 13, 2025 at 10:08:20AM -0700, Farhan Ali wrote: =20
> >> VFIO allows error recovery and notification for devices that
> >> are PCIe (and thus AER) capable. But for PCI devices on IBM
> >> s390 error recovery involves platform firmware and
> >> notification to operating system is done by architecture
> >> specific way. The Internal Shared Memory(ISM) device is a legacy
> >> PCI device (so not PCIe capable), but can still be recovered
> >> when notified of an error. =20
> > "PCIe (and thus AER) capable" reads as though AER is required for all
> > PCIe devices, but AER is optional.
> >
> > I don't know the details of VFIO and why it tests for PCIe instead of
> > AER.  Maybe AER is not relevant here and you don't need to mention
> > AER above at all? =20
>=20
> The original change that introduced this commit=C2=A0dad9f89 "VFIO-AER:=20
> Vfio-pci driver changes for supporting AER" was adding the support for=20
> AER for vfio. My assumption is the author thought if the device is AER=20
> capable the pcie check should be sufficient? I can remove the AER=20
> references in commit message. Thanks Farhan

I've looked back through discussions when this went in and can't find
any specific reasoning about why we chose pci_is_pcie() here.  Maybe
we were trying to avoid setting up an error signal on devices that
cannot have AER, but then why didn't we check specifically for AER.
Maybe some version used PCIe specific calls in the handler that we
didn't want to check runtime, but I don't spot such a dependency now.

Possibly we should just remove the check.  We're configuring the error
signaling on the vast majority of devices, it's extremely rare that it
fires anyway, reporting it on a device where it cannot trigger seems
relatively negligible and avoids extra ugly code.  Thanks,

Alex


