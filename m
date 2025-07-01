Return-Path: <kvm+bounces-51191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A9B67AEF9BD
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 15:07:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B7161895CC9
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 13:05:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFAB82749E7;
	Tue,  1 Jul 2025 13:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iT9JUHQz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C7872605
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 13:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751375110; cv=none; b=hXntET3ilgLfMnSNcACRBAvH1OqbKwJajz5kpeJZZ03+lm/5R+BQBBjh9jX5lYWz3HbRWWEN86uvDZ/UKRfgAzeHWc46C8pHLoTjZtqKMFp8e9FX8f87cdUuy/UmpB1B0SCOMOCFVYlWkXJonwkPa288YyldEox7ZirCgm4kWT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751375110; c=relaxed/simple;
	bh=FHwbmGHV6FOrnxIkxMOgu3/Pm1yc+6nTHKLnKEvURnc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eQDiZtb8R7ZiXLKxmTkbfbU/8rocSvFKv6uKyf0bYG4Tcw4+ZHH3PiVRTHGjae0Fvkl61zwiiqc7HmPCGCJyTCMH8qyjSh38kPdhVj5uOYSQQst2WQsQceu2BCDcfXMb3tv3Ddjy2twNZJ89VzbB1XJ48y2D+cQ6L6UpORb8pUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iT9JUHQz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751375107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=41EXXjsLW0bLv6oTUIdi6IkrVBQSOASHsVY5f4FWQCM=;
	b=iT9JUHQzOKdiKL9afejylF1LUVq8IVws6sv/iQrHvgs3CTcu62K/4ZrkbtXrHgvXlw8vSt
	4biDfu6yGeQp9kCQ5EcfGMg1CZy+S+1Q5fjnoFCzb/fdNpHj8tQBAG7V3WUonyxMxdWSDu
	jXbBVvDRH8D6tquOsSfJBwR+DmAAzP0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-450-Ks0m65GTMGidRhmiWEx_-w-1; Tue, 01 Jul 2025 09:05:06 -0400
X-MC-Unique: Ks0m65GTMGidRhmiWEx_-w-1
X-Mimecast-MFC-AGG-ID: Ks0m65GTMGidRhmiWEx_-w_1751375105
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-450eaae2934so23614735e9.2
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 06:05:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751375105; x=1751979905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=41EXXjsLW0bLv6oTUIdi6IkrVBQSOASHsVY5f4FWQCM=;
        b=Xti6UW9cb0Q9hjSSYwmmr/empOYUrbIzEA3cWXqgZbnxjISb9ol2OwfolAfUa5uRst
         8JHGVH7GIeXMSRU+mqO3rVPgfc6hriDaOEune70TBL+OWwtnkTfKXP0ItggtGWLw+VBR
         wEOABa7qn6G+CDyfgDAy2siyHdThQT9r60Krq2fU6MSbul68N7jNd61kD30hbAAwf/OG
         oAKWqaGZAHTJAOFarV9Dtm9TqjakHjNMnHdWELWKtfsubzU6KZWuMV8R1VhO6zln/1Da
         wBs8VUz78XLpLsX8MzQq13f8xPqWbxQZ49AP66WuryvCXGBsSrfnpPyOkX/VczaSE5iL
         7Tcg==
X-Forwarded-Encrypted: i=1; AJvYcCUffzYmHVMPLUjhneDlQIOByzoaIi536OoxpCcB1GbgJKgOPrW6vxmsb4e2sonTzvKjmxo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjmP6x77XpPMEM4nqGdQZzoI26F8e9wN6dyZGxm4O7oZa84+kL
	aTLI4sZWlha30T/n7IIXAGXKV7udYhNVy+q/EcAQh/jEafAf3aHBZquX1P6/NFxLc7atr6y/y7o
	qv/hB3rfYPCr3F2klAFd8v8NMeayTUKre9sXyLRpPFumw5lubKQemRA==
X-Gm-Gg: ASbGncv13jhZrk/nDIzETKpDhLBj8pYLYkO50vkq6iVBaY4hqWuLcnk7nmwGqNEH5BP
	PaWmgFAoxTgjydKZpCvklj4Jr6z1CZb32WxFxwrUUWaFoJZvqkpMoB1tDY/TPaTGzuYGqEfsAp0
	akWmeRS2vPHYTgvRt5ef/c9Gd+bs+b2mfvJV6KWV3xx224y8Y0r1Yd9iSQNyr8/gd9tWbsd9b7Q
	rWoQlDcJoAHO++dYCLc7R5504oVkV9hNrpHRgXpxiEwDz2TintglEjb0WbhS8OzrUlik+NUVQgB
	HSWXzAxOtH5V
X-Received: by 2002:a05:600c:3f14:b0:453:b44:eb69 with SMTP id 5b1f17b1804b1-4539d797842mr103011335e9.13.1751375104377;
        Tue, 01 Jul 2025 06:05:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHZrAeqRbvPFsp3eqfgd8dac460wn5yOs+TSAJzTayg7uOwbIpnr2TYBNQv2q2RQVYQFGT/eg==
X-Received: by 2002:a05:600c:3f14:b0:453:b44:eb69 with SMTP id 5b1f17b1804b1-4539d797842mr103010415e9.13.1751375103421;
        Tue, 01 Jul 2025 06:05:03 -0700 (PDT)
Received: from fedora ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4538a390bf8sm168812485e9.4.2025.07.01.06.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jul 2025 06:05:02 -0700 (PDT)
Date: Tue, 1 Jul 2025 15:05:00 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Alexandre Chartre
 <alexandre.chartre@oracle.com>, qemu-devel@nongnu.org, pbonzini@redhat.com,
 qemu-stable@nongnu.org, konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
 maciej.szmigiero@oracle.com, Sean Christopherson <seanjc@google.com>,
 kvm@vger.kernel.org
Subject: Re: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be advertised on
 AMD
Message-ID: <20250701150500.3a4001e9@fedora>
In-Reply-To: <aGPWW/joFfohy05y@intel.com>
References: <20250630133025.4189544-1-alexandre.chartre@oracle.com>
	<aGO3vOfHUfjgvBQ9@intel.com>
	<c6a79077-024f-4d2f-897c-118ac8bb9b58@intel.com>
	<aGPWW/joFfohy05y@intel.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 1 Jul 2025 20:36:43 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> On Tue, Jul 01, 2025 at 07:12:44PM +0800, Xiaoyao Li wrote:
> > Date: Tue, 1 Jul 2025 19:12:44 +0800
> > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > Subject: Re: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be advertised
> >  on AMD
> > 
> > On 7/1/2025 6:26 PM, Zhao Liu wrote:  
> > > > unless it was explicitly requested by the user.  
> > > But this could still break Windows, just like issue #3001, which enables
> > > arch-capabilities for EPYC-Genoa. This fact shows that even explicitly
> > > turning on arch-capabilities in AMD Guest and utilizing KVM's emulated
> > > value would even break something.
> > > 
> > > So even for named CPUs, arch-capabilities=on doesn't reflect the fact
> > > that it is purely emulated, and is (maybe?) harmful.  
> > 
> > It is because Windows adds wrong code. So it breaks itself and it's just the
> > regression of Windows.  
> 
> Could you please tell me what the Windows's wrong code is? And what's
> wrong when someone is following the hardware spec?

the reason is that it's reserved on AMD hence software shouldn't even try
to use it or make any decisions based on that.


PS:
on contrary, doing such ad-hoc 'cleanups' for the sake of misbehaving
guest would actually complicate QEMU for no big reason.

Also
KVM does do have plenty of such code, and it's not actively preventing guests from using it.
Given that KVM is not welcoming such change, I think QEMU shouldn't do that either.


> Do you expect software developers to make special modifications for QEMU
> after following the hardware spec? Or do you categorize this behavior as
> paravirtualization?
> 
> Resolving this issue within QEMU is already a win-win approach. I don't
> understand why you're shifting the blame onto Windows.
> 
> > KVM and QEMU are not supposed to be blamed.  
> 
> I do not think I'm blaming anything. So many people report
> this bug issue in QEMU community, and maintainer suggested a solution.
> 
> I totally agree on this way, and provide feedback to help thoroughly
> resolve the issue and prevent similar situations from happening again.
> 
> That's all.
> 
> Thanks,
> Zhao
> 
> 
> 


