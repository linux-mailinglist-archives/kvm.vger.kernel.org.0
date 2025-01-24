Return-Path: <kvm+bounces-36554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EECDAA1BAC2
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 17:41:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D4E09188E085
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 16:41:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AD11199EA3;
	Fri, 24 Jan 2025 16:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RQzWU7s7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AF1155303
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 16:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737736900; cv=none; b=jxeBgqipVWyMffNM5Uf5Ru3qbrk1DcRLuH6RupjjmLkojdk4Uff1XszB6/ifX84ziv7AyJ9g+jTkIN25+r3yBYKZXNLr6YozGyVbEvsjPJ7bvjygTix4jvsPcCjqx0B7k2lEDB6OoXocve1G3iK9KPT5pS7+UkO3IrkHUTkFNgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737736900; c=relaxed/simple;
	bh=g++KJdhURYQ+tetTtPw95I2FB1HsITGwDAhs4EQfTbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aPYD3UjOoc1M9gjfj9H3AOhRzZnqU+sSpdBQXtHXkdHR8eq3Vb8p+nFLtrDhkvxSsAJ1aeZpDo1YrSIPktrbKy/Dp5/6WjddM92Z9t4FhPW7VaqSQTvmAElVLEbbcJoe+QzjvycZ/2UxG4iWOCsvUQbPsD8RAqzButaH8IA7Xzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RQzWU7s7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737736896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IDKUVYKOGSDfpP03QEl3KwwK9q8MuQxs4/UuoRKH5lI=;
	b=RQzWU7s7Clzdt7yjvwhZJSzwowje7B7QrNWodcf9mm6ddBAEFWZPV9IAPGCyx3IE9aZ09R
	q8UEjoj0G2tCDF8H5KHnyzEqfmR6NBmAYYfcJhzrzSeRwsqCQwZBTaY53jfZvVrAsMesfm
	XZ4XsqbNfuklv1l4gjRVaYJBk8Jqr+w=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-384-VA7z6oXSMUKD379P-1mGkw-1; Fri, 24 Jan 2025 11:41:34 -0500
X-MC-Unique: VA7z6oXSMUKD379P-1mGkw-1
X-Mimecast-MFC-AGG-ID: VA7z6oXSMUKD379P-1mGkw
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3cca581135dso31579035ab.3
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 08:41:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737736894; x=1738341694;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IDKUVYKOGSDfpP03QEl3KwwK9q8MuQxs4/UuoRKH5lI=;
        b=hfu008Zhw/Z9vLp1tjbESConr/GGiWeS3zPNZvI5uj4tNxnKGMLyeFRVzDaiE3OFs5
         ErFWidW1Pr8I8gNmezRQqC1x2I6m6ZnIrDO+oo6rpE3z5m7JXeYUg0TFhrOdUreHzUNy
         arwYmw8xxCOuHXYRezS7Gf4zDm5dW2jbOj6GrnRlnXk/FlwamsAxFvSQKlhFDvJaCzbr
         JaZkeXd0soR4NrdM/CM7OmHom246yzwYJreL/O/q8SLt7BrRxyH2oeq7+rGJ+8XYsCoD
         X/5q/Qda9XaL+8FS4uPl9CV6ek3/2hQFTU/M2wTuasx+W/ieW9IfCWe+1iSCaKkX5RFd
         SZ4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXgSEOf4GsjCQK5VqKd+jFrNAEHiT94Ol9/pwATuGqLGUzGIX5GjSa9ls52zqtt1S1x0H0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSONch0FfqcrpnkXfegBhvyyvujaQbX8PuJDIFHOrnopZUQRQa
	1Hl7/MqHrRoMMrA82fSd601huW+lVeVQY7raP73VkERdrciOtybXn76cGBjbemoGJAa0RFwRHcb
	TOMVeur1wnK5tPsVJsNXPr5i3vx9dutSAxNOfyDB4HavylPcr5Q==
X-Gm-Gg: ASbGncsSLOR7KMCiy27P8uRZ2RG36r4MztddH39K73q051AfAqI0N+oETqz7OR5p52H
	0Or9vsS64sYPeXZxLtGiLQ1Hb9Xl7+VmfSXiyDcnZnJxMdCAwg94HcEHfUCTp3wI5gnpgOji442
	YH1g8Ymx3WtZXxjr+Hj4BZPpqz7Y0YEO0HWIZ2FCta6zdFdep+bH/zsJzpeADirc5PcRvTbr38G
	WVUcIHqh0syeZiCsjncSx0UygdqDrUNiP/7GRrqfkd0eg51Irf1OacZ2rGum9O+zG8QbYw6xb+b
	vYg7HtQECqqF2h6fbDlN9nBS8dOXRcc=
X-Received: by 2002:a05:6214:d63:b0:6dd:be26:50ba with SMTP id 6a1803df08f44-6e1b21d4775mr472168176d6.21.1737735158706;
        Fri, 24 Jan 2025 08:12:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEkedu4M4bSFyiRgJDvmyb6kS6QCNU3PVd61/eGKd58HzLgZACf+QknYf4i4z86MzQZZnxlEg==
X-Received: by 2002:a05:6214:d63:b0:6dd:be26:50ba with SMTP id 6a1803df08f44-6e1b21d4775mr472167866d6.21.1737735158385;
        Fri, 24 Jan 2025 08:12:38 -0800 (PST)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e2058c236csm9808906d6.104.2025.01.24.08.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2025 08:12:37 -0800 (PST)
Date: Fri, 24 Jan 2025 11:12:35 -0500
From: Peter Xu <peterx@redhat.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Message-ID: <Z5O784_wnrBMrV6X@x1n>
References: <Z46GIsAcXJTPQ8yN@x1n>
 <7e60d2d8-9ee9-4e97-8a45-bd35a3b7b2a2@redhat.com>
 <Z46W7Ltk-CWjmCEj@x1n>
 <8e144c26-b1f4-4156-b959-93dc19ab2984@intel.com>
 <Z4_MvGSq2B4zptGB@x1n>
 <c5148428-9ebe-4659-953c-6c9d0eea1051@intel.com>
 <9d4df308-2dfd-4fa0-a19b-ccbbce13a2fc@intel.com>
 <b11f240d-ff8c-4c83-9b33-5e556cde0bce@amd.com>
 <d54f6f53-3d11-477e-8849-cc3d28a201db@intel.com>
 <2115c769-144c-4254-94b0-6b38b7afc6fc@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2115c769-144c-4254-94b0-6b38b7afc6fc@amd.com>

On Fri, Jan 24, 2025 at 04:56:50PM +1100, Alexey Kardashevskiy wrote:
> > Now, I assume Peter's real question is, if we can copy the vBIOS to a
> > private region and no need to create a specific guest_memfd-backed
> > memory region for it?

Yes.

> 
> I guess we can copy it but we have pc.bios and pc.rom in own memory regions
> for some reason even for legacy non-secure VMs, for ages, so it has little
> or nothing to do with whether vBIOS is in private or shared memory. Thanks,

My previous question is whether they are required to be converted to be
guest-memfd backed memory regions, irrelevant of whether they're separate
or not.

I think I found some answers in the commit logs here (it isn't hiding too
deep; I could have tried when asking):

===8<===
commit fc7a69e177e4ba26d11fcf47b853f85115b35a11
Author: Michael Roth <michael.roth@amd.com>
Date:   Thu May 30 06:16:40 2024 -0500

    hw/i386: Add support for loading BIOS using guest_memfd
    
    When guest_memfd is enabled, the BIOS is generally part of the initial
    encrypted guest image and will be accessed as private guest memory. Add
    the necessary changes to set up the associated RAM region with a
    guest_memfd backend to allow for this.
    
    Current support centers around using -bios to load the BIOS data.
    Support for loading the BIOS via pflash requires additional enablement
    since those interfaces rely on the use of ROM memory regions which make
    use of the KVM_MEM_READONLY memslot flag, which is not supported for
    guest_memfd-backed memslots.

commit 413a67450750e0459efeffc3db3ba9759c3e381c
Author: Michael Roth <michael.roth@amd.com>
Date:   Thu May 30 06:16:39 2024 -0500

    hw/i386/sev: Use guest_memfd for legacy ROMs
    
    Current SNP guest kernels will attempt to access these regions with
    with C-bit set, so guest_memfd is needed to handle that. Otherwise,
    kvm_convert_memory() will fail when the guest kernel tries to access it
    and QEMU attempts to call KVM_SET_MEMORY_ATTRIBUTES to set these ranges
    to private.
    
    Whether guests should actually try to access ROM regions in this way (or
    need to deal with legacy ROM regions at all), is a separate issue to be
    addressed on kernel side, but current SNP guest kernels will exhibit
    this behavior and so this handling is needed to allow QEMU to continue
    running existing SNP guest kernels.
===8<===

So IIUC the CoCo VMs will assume they're somehow convertable memories or
they'll stop working I assume, at least on some existing hardwares.

Thanks,

-- 
Peter Xu


