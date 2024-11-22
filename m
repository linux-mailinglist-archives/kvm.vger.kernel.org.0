Return-Path: <kvm+bounces-32386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A22D59D6584
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 23:02:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EEF30B229C8
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 22:02:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1490618BC0D;
	Fri, 22 Nov 2024 22:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aCfDTT7b"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7595B187344
	for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 22:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732312952; cv=none; b=QuwMOX/M8w3nq2W3EMYqaswCZ3pbC1JEJlDeKS/J9/IvEh32/rRjOCrJCdK1DlIjSZl4Vsu2ZyPhlCubwDrtzr+FncTo7ItCoKyX7HJlJ8c2f7gSb/dt4kbFlyek2ejFfw1/8+NeDDmbQAAYrFtNj5hoxPv5GuoS7MmWli7G+hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732312952; c=relaxed/simple;
	bh=ykKAo7sEnG6ogfqSoVM5ICIKtWGlLhAzzJdQhZ59ppk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EvaceAaO6R+ogST3BXbapRQaJ699s8xIeZRvEeT4Ywi1RnEkR2whfSP23lJdta5lAdJobm33/qIxJPVaiPmNR6WD9pqXW0e/NVymtyR2h6+E4Fi6JXOdgZNs3kFdAve/ExQQs18wm289dUR+WwsYOnlsBOiWEWpKW6mrSeDofOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aCfDTT7b; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732312949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D2rLE49z94TB7gVF24gYVB/BYnqK4CzBdI3lSpjsVG8=;
	b=aCfDTT7bEfUdncfx9QSZwlLejxsWhFyCehE+d8Rodze1xu2VwAuukEil+/a9/zNoKwxGAW
	sQcRmfwuPUhgIe0o86anAlaugbXYXxtQXnf2M9u+kjNJax19ngjLqKD6c94KCr8gzeoGJh
	/NRd0CUjRyMTJApRnc7/TRWjVR1ntgg=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-o_Q2umBJOSiR4eeRzLj1rw-1; Fri, 22 Nov 2024 17:02:28 -0500
X-MC-Unique: o_Q2umBJOSiR4eeRzLj1rw-1
X-Mimecast-MFC-AGG-ID: o_Q2umBJOSiR4eeRzLj1rw
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-83aa8c7edb7so42444339f.3
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 14:02:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732312947; x=1732917747;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D2rLE49z94TB7gVF24gYVB/BYnqK4CzBdI3lSpjsVG8=;
        b=RdVddsj7AzoyJrxxfxlEMe5VaW6YHKiKPyPv0qPmzPjanow7VJ9IM9EKXJB9eygurK
         R12QuDue9I8oq/6B0SHjuoX4rO/PpCInDUykbdRqA8+7g60nBskp0bEnOcsndCPVma7I
         tw5xsRQdFffW8CGEn+P0d9i7Tq+fnT57/kY7f3iZIOWfRq4K2suH0RsCjZN9SNCmEkY1
         4QXvjJ33EwyC1jd9I0xbek7jCX/wPiYJAI907zoZyEQm6Mcrwo7BclpWtsTNxfDmDyqC
         xufhZ9WUaXQn8tgFRMi/FK9fxI6hFKjQ3M1w0eIfxSldKw3y6qHSFlKN425NcjMB2hdM
         Ccog==
X-Forwarded-Encrypted: i=1; AJvYcCV3SoTl/X2NDWsLRWwZv6j5sAIXjZ4Bjye74aKPbKbVJd2mQzZdV0Wi5wwzvsYPEBJUa3I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTlRF+WT+3Gj24/XHBdYLboBZ1HSQBoGf9/aVdedDUKSCiNsvg
	g84KdTOVUqZasT9pGsZUAcuQdJ6whI8qdIpJ/XeO3jxNPLa6f9/ZYe4RddZNWcim7eNru1N1sIK
	N+sOu7viO7Z5bhS5/vW+Hunf5y1UhTbPYBcZPo6zRFVVJfp8Cow==
X-Gm-Gg: ASbGnctN7BgSjID1Gmr1t6jIoDiCWFIhBtfqNcgdOrEDFcZ01IMHZu0R/uPLjuCktJh
	TI+LhjEP8xehCDepxHoBIek2WcmwOZUFF16v/lIiacjS8mSNb8Kntqm2na6abW1tn63qazfE7v5
	LDXPStnatNY9Bqhh/GPnKGXhjbygOg5Gper1pnpx+xYMkcOMqtz655pt4Ozp4JSq67g+yZbK3YT
	1MuPv+glBql60HwK9L+/6afSMlPFjaVYDBAlF7U1B7L6XDsKbJEiw==
X-Received: by 2002:a05:6e02:1a08:b0:3a6:c8cf:9d5e with SMTP id e9e14a558f8ab-3a79b02befamr12879095ab.6.1732312947527;
        Fri, 22 Nov 2024 14:02:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGN9GQ8p7p1EhkinN390sEetXzPMQLlVGkf1ufMAmQ34s/L5hM95PseqaFylZwSu7zEjU2HsQ==
X-Received: by 2002:a05:6e02:1a08:b0:3a6:c8cf:9d5e with SMTP id e9e14a558f8ab-3a79b02befamr12878975ab.6.1732312947196;
        Fri, 22 Nov 2024 14:02:27 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e1cff116ddsm829785173.112.2024.11.22.14.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 14:02:26 -0800 (PST)
Date: Fri, 22 Nov 2024 15:02:25 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Avihai Horon <avihaih@nvidia.com>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
 kvm@vger.kernel.org, Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe
 <jgg@nvidia.com>, Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH v2] vfio/pci: Properly hide first-in-list PCIe extended
 capability
Message-ID: <20241122150225.40029654.alex.williamson@redhat.com>
In-Reply-To: <202411230727.abAsDI8W-lkp@intel.com>
References: <20241121140057.25157-1-avihaih@nvidia.com>
	<202411230727.abAsDI8W-lkp@intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 23 Nov 2024 05:33:10 +0800
kernel test robot <lkp@intel.com> wrote:

> Hi Avihai,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on awilliam-vfio/next]
> [also build test ERROR on linus/master awilliam-vfio/for-linus v6.12 next-20241122]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Avihai-Horon/vfio-pci-Properly-hide-first-in-list-PCIe-extended-capability/20241121-220249
> base:   https://github.com/awilliam/linux-vfio.git next
> patch link:    https://lore.kernel.org/r/20241121140057.25157-1-avihaih%40nvidia.com
> patch subject: [PATCH v2] vfio/pci: Properly hide first-in-list PCIe extended capability
> config: s390-randconfig-r053-20241122 (https://download.01.org/0day-ci/archive/20241123/202411230727.abAsDI8W-lkp@intel.com/config)
> compiler: clang version 16.0.6 (https://github.com/llvm/llvm-project 7cbf1a2591520c2491aa35339f227775f4d3adf6)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241123/202411230727.abAsDI8W-lkp@intel.com/reproduce)

...
> >> drivers/vfio/pci/vfio_pci_config.c:322:27: error: initializer element is not a compile-time constant  
>            [0 ... PCI_CAP_ID_MAX] = direct_ro_perms
>                                     ^~~~~~~~~~~~~~~
>    drivers/vfio/pci/vfio_pci_config.c:325:31: error: initializer element is not a compile-time constant
>            [0 ... PCI_EXT_CAP_ID_MAX] = direct_ro_perms
>                                         ^~~~~~~~~~~~~~~
>    12 warnings and 2 errors generated.
> 
> 
> vim +322 drivers/vfio/pci/vfio_pci_config.c
> 
>    319	
>    320	/* Default capability regions to read-only, no-virtualization */
>    321	static struct perm_bits cap_perms[PCI_CAP_ID_MAX + 1] = {
>  > 322		[0 ... PCI_CAP_ID_MAX] = direct_ro_perms  
>    323	};

I thought declaring direct_ro_perms as const was enough to resolve
this, it is with gcc but I didn't test clang.  Feel free to leave the
existing declarations alone if there's not an obvious fix.  Thanks,

Alex


