Return-Path: <kvm+bounces-2655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 91CEE7FC016
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 18:15:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 24B23B214C2
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 17:15:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A114C5B5C7;
	Tue, 28 Nov 2023 17:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ma7mg49E"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC921702
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 09:14:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701191694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gtaSo1ub4uORnqknoH16PJEFq9uekg4hoFlfPiGwcdU=;
	b=Ma7mg49ErWhdVjlHdOXOlxB4Q5jXhxSulnDtSWrFV0vbZehZgNsxL4E9joVgYbduP4qqIo
	wLQDbW2eA8Mu/Ih8vA8CCUhiI977LqnztmgnUkgasHRnLxWIsY1G8BnfkBRhc77thGpNKE
	L3vQlzRAOoFQ3JsqoswxiAwYKCQ+NVQ=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-HjeS7eQCMF6ohk-gsU0h7w-1; Tue, 28 Nov 2023 12:14:50 -0500
X-MC-Unique: HjeS7eQCMF6ohk-gsU0h7w-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7b34d71f269so542733339f.2
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 09:14:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701191690; x=1701796490;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gtaSo1ub4uORnqknoH16PJEFq9uekg4hoFlfPiGwcdU=;
        b=LYEtE+fgeZ5rhDsy/qRsAFcec/R698nRqAydGC5ipi/Z2YojMM9WS6MRNhqtzMMQud
         s8FKJtWCdtz0YCJua4dp/TEvhqqkhpm4jPnWX9a2JLTWSiIoNuEaBHHPKGqP+FqV9Yyg
         tDeIV/KG5GMBkL2NdpfsPRWzo2rZ8GvcR4B/LLCdHk863thNf3OIi1p7se7AemkZmTzQ
         fGOv4IOL/9rXIDa9+k0L1gJgzrCTPUtD1IyJM0FAKwIZLZRPd66gepSz1IUgF8uRScTz
         06o/BNOb4Bmjn0IWPtPgj7dHQkLowwLwUBVfM+aUMmZs28Ek48HpGJrioN3Cf0wif8Z/
         QZvg==
X-Gm-Message-State: AOJu0YzFBv5Ls9jayo7wnfvRkMWOyg9DaIqp7vSxv/CTiH+OUfFBUVKU
	ciIMYU5kjqKFYMECN8nB9WFh0hv2ODpaNMFc3MKzkWs4I5wo7sBfoyRqxBTv1IPGGDMSj4A7SwK
	JvS9Vt8f/gyvB
X-Received: by 2002:a05:6602:131e:b0:7b0:2037:68f3 with SMTP id h30-20020a056602131e00b007b0203768f3mr15000358iov.13.1701191689959;
        Tue, 28 Nov 2023 09:14:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFD6oEwpFjpUyHT/D0OGCBMhCVi5mSaIjGthKIjs5b6xAvuny8q9LhuouQv4++AjP9LEwy0Kw==
X-Received: by 2002:a05:6602:131e:b0:7b0:2037:68f3 with SMTP id h30-20020a056602131e00b007b0203768f3mr15000328iov.13.1701191689657;
        Tue, 28 Nov 2023 09:14:49 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id ep10-20020a0566384e0a00b00459949acd10sm2956452jab.39.2023.11.28.09.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 09:14:49 -0800 (PST)
Date: Tue, 28 Nov 2023 10:14:47 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kernel test robot <lkp@intel.com>, Yi Liu <yi.l.liu@intel.com>,
 llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: arch/powerpc/kvm/../../../virt/kvm/vfio.c:89:7: warning:
 attribute declaration must precede definition
Message-ID: <20231128101447.2739afa9.alex.williamson@redhat.com>
In-Reply-To: <20231128124538.GO436702@nvidia.com>
References: <202311280814.KwQVhwqI-lkp@intel.com>
	<20231128124538.GO436702@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 28 Nov 2023 08:45:38 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Nov 28, 2023 at 11:01:45AM +0800, kernel test robot wrote:
> > Hi Yi,
> > 
> > FYI, the error/warning still remains.  
> 
> The patch is still here:
> 
> https://lore.kernel.org/r/0-v1-08396538817d+13c5-vfio_kvm_kconfig_jgg@nvidia.com
> 
> Alex? Maybe you should send it to -rc now?

Looks like this was originally targeted going through KVM.  I'm
intending to do a v6.7-rc pull anyway and it's relevant to vfio, so I
don't mind including it, but I think we need an ack from Paolo.

Paolo?

Thanks,
Alex


