Return-Path: <kvm+bounces-34419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AED969FEC22
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2024 02:27:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D2CA07A14E1
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2024 01:27:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F2AB16426;
	Tue, 31 Dec 2024 01:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hDlIN/K8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C9E524C
	for <kvm@vger.kernel.org>; Tue, 31 Dec 2024 01:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735608468; cv=none; b=AtYrAHsTcplUWHBh7fzGwdyxj7Kmzl9SI2djUdvN/tP7Fu12Mcy1nLgWTgOMfIZlUoQ+iKAs9qiYHc0Nr1++5hduF8S5eIUC4beEMBbC1DSZ2aYIH+/SVf/4y2QNio7sh4DP9Av68m22yT91WfZaNGX46Uf4gUvdoZtRHtNoVgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735608468; c=relaxed/simple;
	bh=cYwx81FiscoKPuQUcoEjGxNvsT4PQHMGFwYOIJGDDdY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m8l1aKaidCK8FZPMh77uA/Phjs5PlSgAJys3/nYaGYbyKTe+XTwEx0RXB4h+w9nwygHcjpRDuvdCq7kmLUwdXF4pH8a+46E6jnzBoAcDFsKcEY2lsLfd6tpo0gg1Dp+SEnRkfwC8ib4Fi9M3y0uzuMq0xkMpphoqSrsduldUpQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hDlIN/K8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735608464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PbSubt0jW6XprDSYA3GtrEByRivXdyFWNaGrTU8y1fc=;
	b=hDlIN/K8IYE9Kc/SYwM0k88YLOIZ99+1hAyf+rpis5jvULMyGnsltpBAr3PoJoAZ23Fu57
	aaC6kXkzNy/Ku4LNG4A5Fz78aqrGqlrH/lhaUmVw72HzaweGuQaCUj0Q2uLjGXly8+91mh
	wK7Gkk14kk45sCK0+WZpArIlvkUvlZU=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-364-smxkU2HZP9OxyuzAoZMG5g-1; Mon, 30 Dec 2024 20:27:40 -0500
X-MC-Unique: smxkU2HZP9OxyuzAoZMG5g-1
X-Mimecast-MFC-AGG-ID: smxkU2HZP9OxyuzAoZMG5g
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a81764054aso11354815ab.2
        for <kvm@vger.kernel.org>; Mon, 30 Dec 2024 17:27:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735608460; x=1736213260;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PbSubt0jW6XprDSYA3GtrEByRivXdyFWNaGrTU8y1fc=;
        b=b6ks2u4ff26w38+kUhEde+xBGOrvTfWxFqbewQrHEBh8iRgfjQhyCRJVcJjQ7wTQnL
         rnIeGF6BwIPPwfavUZ9w6HPbIi/+3pvQ5/VnhZM10vdwnmOfkK0BQ/f203RxiGC8SAwW
         ObleAtqnEw3EAmakjVGTsd8VtOfZGkQIQJpfJ/gx/DOpS/5lJmoVR0We2U7193kbpYwC
         3tu3RNCjcBVMpSh8AUT79Ze+Xge1nMYeDK2j9MvXEPkUIfWFz28Fa5VQ9lvOb28h2Fy8
         vN4fd9Ny5fZnzbRCfG40n/G+mfq1URIZ/CW0s6RsL5RctaVwzn13JdgysdUIkV4rNwm9
         QijQ==
X-Forwarded-Encrypted: i=1; AJvYcCV41FeG3C9v9TeyAk61fxIanPOGnLGq4VV2a+meGBu5BnVPNf6EK6bMCutPKLO3DhKdowg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxw4Y3LfM8VlS/NYMTYE5Bdlq61GfBO0IUnyfOPgjmvlLDDrtkV
	18ZM8QXjcyKUFhGl0TEUyMagSJIKkvbopw9EIkIgqeRn1uv2SqVQR2k441H6qm5HWUMvNkRV6iV
	JMdzFyhxcr8PpargQKmstfg+Z3T7FrML/CFrLXG5uae2k3oXNIw==
X-Gm-Gg: ASbGncvRuaVQaNBVK+U22ywgo7tSIiItEUUw5iOQmeUQBDgSwPYGQ0OxJXcTDY8SCbZ
	ghbuyqdrqGeeCouPbE+fLd4zcLiQw0nxzRTJaBWFYj5XZotgBKw6uHxKWpp5MzwTOqJ6RORTI9m
	6a82ZbZzpFU/LlEK1vB1yGk79oUqtFa8e4ibzGngn7pVcPnLZv1HljVGsx0XvLbeF43XxaqfU/G
	+G7CrxAJAzueBcBAvrKi/Tk9ltl9xpekYKDkz1cBWeZ2hchJSI8Q8W00yv3
X-Received: by 2002:a05:6e02:1c81:b0:3a7:bd4c:b17e with SMTP id e9e14a558f8ab-3c2cbd89eedmr90279625ab.0.1735608459894;
        Mon, 30 Dec 2024 17:27:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH7XZPI30EYeszFNZ0Jt4u4Phtf61lCBYw7J/duvSKrhB3IGnVslVa4n/XJNjdJsoxpLUzIVA==
X-Received: by 2002:a05:6e02:1c81:b0:3a7:bd4c:b17e with SMTP id e9e14a558f8ab-3c2cbd89eedmr90279545ab.0.1735608459520;
        Mon, 30 Dec 2024 17:27:39 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e68bf67e8fsm5815988173.58.2024.12.30.17.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Dec 2024 17:27:38 -0800 (PST)
Date: Mon, 30 Dec 2024 18:27:37 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Precific <precification@posteo.de>
Cc: Peter Xu <peterx@redhat.com>, Athul Krishna
 <athul.krishna.kr@protonmail.com>, Bjorn Helgaas <helgaas@kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Linux PCI
 <linux-pci@vger.kernel.org>, "regressions@lists.linux.dev"
 <regressions@lists.linux.dev>
Subject: Re: [bugzilla-daemon@kernel.org: [Bug 219619] New: vfio-pci: screen
 graphics artifacts after 6.12 kernel upgrade]
Message-ID: <20241230182737.154cd33a.alex.williamson@redhat.com>
In-Reply-To: <16ea1922-c9ce-4d73-b9b6-8365ca3fcf32@posteo.de>
References: <20241222223604.GA3735586@bhelgaas>
	<Hb6kvXlGizYbogNWGJcvhY3LsKeRwROtpRluHKsGqRcmZl68J35nP60YdzW1KSoPl5RO_dCxuL5x9mM13jPBbU414DEZE_0rUwDNvzuzyb8=@protonmail.com>
	<Z2mW2k8GfP7S0c5M@x1n>
	<16ea1922-c9ce-4d73-b9b6-8365ca3fcf32@posteo.de>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 30 Dec 2024 21:03:30 +0000
Precific <precification@posteo.de> wrote:

> On 23.12.24 17:59, Peter Xu wrote:
> > On Mon, Dec 23, 2024 at 07:37:46AM +0000, Athul Krishna wrote:  
> >> Can confirm. Reverting f9e54c3a2f5b from v6.13-rc1 fixed the problem.  
> >>>   
> >>>   Device: Asus Zephyrus GA402RJ
> >>>   CPU: Ryzen 7 6800HS
> >>>   GPU: RX 6700S
> >>>   Kernel: 6.13.0-rc3-g8faabc041a00
> >>>   
> >>>   Problem:
> >>>   Launching games or gpu bench-marking tools in qemu windows 11 vm will cause
> >>>   screen artifacts, ultimately qemu will pause with unrecoverable error.  
> > 
> > Is there more information on what setup can reproduce it?
> > 
> > For example, does it only happen with Windows guests?  Does the GPU
> > vendor/model matter?  
> 
> In my case, both Windows and Linux guests fail to initialize the GPU in 
> the first place since 6.12; QEMU does not crash. I also found commit 
> f9e54c3a2f5b79ecc57c7bc7d0d3521e461a2101 by bisection.
> 
> CPU: AMD 7950X3D
> GPU (guest): AMD RX 6700XT (12GB)
> Mainboard: ASRock X670E Steel Legend
> Kernel: 6.12.0-rc0 .. 6.13.0-rc2
> 
> Based on a handful of reports on the Arch forum and on r/vfio, my guess 
> is that affected users have Resizable BAR or similar settings enabled in 
> the firmware, which usually applies the maximum possible BAR size 
> advertised by the GPU on startup. Non-2^n-sized VRAM buffers may be 
> another commonality.
> 
> Some other reports I found that could fit to this regression:
> [1] https://bbs.archlinux.org/viewtopic.php?id=301352
>    - Several reports (besides mine), not clear which of those cases are 
> triggered by the vfio-pci commit. One case is clearly caused by a 
> different commit in KVM. Potential candidates for the vfio-pci commit 
> (speculation): (a) 6700XT GPU; (b) 5950X CPU, RTX 3090 GPU
> [2] https://old.reddit.com/r/VFIO/comments/1hkvedq/
>    - Two users, 7900XT and 7900XTX, reported that reverting 6.12 or 
> disabling ReBAR resolves Windows guest GPU initialization.
> 
> On my 6700XT (PCI address 03:00.0, 12GB of VRAM), I get the following 
> Resizable BAR default configuration with the host firmware/UEFI setting 
> enabled:
> 
> [root]# lspci -s 03:00.0 -vv
> ...
> Capabilities: [200 v1] Physical Resizable BAR
> 	BAR 0: current size: 16GB, supported: 256MB 512MB 1GB 2GB 4GB 8GB 16GB
> 	BAR 2: current size: 256MB, supported: 2MB 4MB 8MB 16MB 32MB 64MB 128MB 
> 256MB
> ...
> 
> The 16GB configuration above fails with 6.12 (unless I revert commit 
> f9e54c3a2f5b79ecc57c7bc7d0d3521e461a2101).
> Now, if I change BAR 0 to 8GB (as below), which is below the GPU's VRAM 
> size of 12GB, the Linux guest manages to initialize the GPU.

Interesting test.

> [root]# echo "0000:03:00.0" > /sys/bus/pci/drivers/vfio-pci/unbind
> [root]# #13: 8GB, 14: 16GB
> [root]# echo 13 > /sys/bus/pci/devices/0000:03:00.0/resource0_resize
> [root]# echo "0000:03:00.0" > /sys/bus/pci/drivers/vfio-pci/bind
> 
> On my mainboard, 'Resizable BAR off' sets BAR 0 to 256MB, which also 
> works with 6.12.
> 
> Only the size of BAR 0 (VRAM) appears to be relevant here. BAR 2 sizes 
> of 2MB vs. 256MB have no effect on the outcome.
> 
> >   
> >>>   
> >>>   Commit:
> >>>   f9e54c3a2f5b79ecc57c7bc7d0d3521e461a2101 is the first bad commit
> >>>   commit f9e54c3a2f5b79ecc57c7bc7d0d3521e461a2101
> >>>   Author: Alex Williamson <alex.williamson@redhat.com>
> >>>   Date:   Mon Aug 26 16:43:53 2024 -0400
> >>>   
> >>>       vfio/pci: implement huge_fault support  
> > 
> > Personally I have no clue yet on how this could affect it.  I was initially
> > worrying on any implicit cache mode changes on the mappings, but I don't
> > think any of such was involved in this specific change.
> > 
> > This commit majorly does two things: (1) allow 2M/1G mappings for BARs
> > instead of small 4Ks always, and (2) always lazy faults rather than
> > "install everything in the 1st fault".  Maybe one of the two could have
> > some impact in some way.  
> 
> In my case, commenting out (1) the huge_fault callback assignment from 
> f9e54c3a2f5b suffices for GPU initialization in the guest, even if (2) 
> the 'install everything' loop is still removed.
> 
> I have uploaded host kernel logs with vfio-pci-core debugging enabled 
> (one log with stock sources, one large log with vfio-pci-core's 
> huge_fault handler patched out):
> https://bugzilla.kernel.org/show_bug.cgi?id=219619#c1
> I'm not sure if the logs of handled faults say much about what 
> specifically goes wrong here, though.
> 
> The dmesg portion attached to my mail is of a Linux guest failing to 
> initialize the GPU (BAR 0 size 16GB with 12GB of VRAM).

Thanks for the logs with debugging enabled.  Would you be able to
repeat the test with QEMU 9.2?  There's a patch in there that aligns
the mmaps, which should avoid mixing 1G and 2MB pages for huge faults.
With this you should only see order 18 mappings for BAR0.

Also, in a different direction, it would be interesting to run tests
disabling 1G huge pages and 2MB huge pages independently.  The
following would disable 1G pages:

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 1ab58da9f38a..dd3b748f9d33 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1684,7 +1684,7 @@ static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
 							     PFN_DEV), false);
 		break;
 #endif
-#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
+#if 0
 	case PUD_ORDER:
 		ret = vmf_insert_pfn_pud(vmf, __pfn_to_pfn_t(pfn + pgoff,
 							     PFN_DEV), false);

This should disable 2M pages:

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 1ab58da9f38a..d7dd359e19bb 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1678,7 +1678,7 @@ static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
 	case 0:
 		ret = vmf_insert_pfn(vma, vmf->address, pfn + pgoff);
 		break;
-#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
+#if 0
 	case PMD_ORDER:
 		ret = vmf_insert_pfn_pmd(vmf, __pfn_to_pfn_t(pfn + pgoff,
 							     PFN_DEV), false);

And applying both together should be functionally equivalent to
pre-v6.12.  Thanks,

Alex


