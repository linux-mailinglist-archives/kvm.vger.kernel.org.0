Return-Path: <kvm+bounces-55921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 50CC7B389E0
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 20:55:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DC801B6533B
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 18:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 309632E7BCC;
	Wed, 27 Aug 2025 18:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P/4dfx8C"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC672E22BC
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 18:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756320908; cv=none; b=UiLGmjVgfrDLG/8EaJE8dIRghpdAfzrNc3Ef93c8QXRu1j9YsnQrKjTzSZXJ24mspY6wfaX5pS0tHKILWjSP7EH0fGMgAcWK6RD7tC0uoyxaPLsvzkMKfYXDVCP7FQVt70hHclA91i2Wq9pNwqXjlbJfbwrzvWJWLGJyBJIWT4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756320908; c=relaxed/simple;
	bh=ne728g33Ic89OdMPAENBxFjSizIUR3CqOaqTHDpBguk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qSYVpbznCe/Whn5Iiw0f25gzhp/ZytNrxprWL3p3L6Z5FJqherfuVjrTrwpHuirK4Ocl3kPadNAcghCPQgBoNanZ8v+d6Fdxu2p5KfV8NNfOHgP4IsxUhooo9b/zmW1Nu+8TArjM9I3gaBsRB9iY/UOra0uJzoKSRCxiy5EHYEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P/4dfx8C; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756320905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eF3DTjEsZLVirufoG8QRMws1dk+QuLId/jBJE6DkJbg=;
	b=P/4dfx8Cdput8KK4vRLgPJySjAdLQD4ud8TNyIj3yAw+ESOukCJbFBsy0kl/3bZA/Xh8SB
	e9zRCkBIJVt9FMw9+IPkSEGrH+fg44uo39lFJL1ZezEMt68irjLEVWJXwTr8qyKT49Flh4
	YijwJsdRWZk8QK5i8x+/Bsh4VIU6l8M=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-576-SCFsOwo2MA2NJvPhN7gSnQ-1; Wed, 27 Aug 2025 14:55:03 -0400
X-MC-Unique: SCFsOwo2MA2NJvPhN7gSnQ-1
X-Mimecast-MFC-AGG-ID: SCFsOwo2MA2NJvPhN7gSnQ_1756320903
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3ebd3ca6902so315165ab.3
        for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 11:55:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756320902; x=1756925702;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eF3DTjEsZLVirufoG8QRMws1dk+QuLId/jBJE6DkJbg=;
        b=LdGYwHnqselVrgtsuzcdaUvE8ySgCDfDQCnqK9xnUBW1M88rTT9ht2ObW/PighbPGc
         3DW7MgNaN/BGB7xPBptCx7r5d770U0DaDE9FmVgPQ+AQ1ePvBQZqAT9Aiz7pA2JpTkNW
         PElcFAx5354JaOlLG6G3upbjGdAMXy5s01w6K0tY1CbBNEP75FraPIrAMpglyJw4p8Ck
         0rrM+8sSsNRGH6mu+wJDIQyJjOiixHbSPqt9nf6XiynDdkpgKfR7yybO67He2Yrgc79K
         UgSR24/0l/diQB/1gR94Td5VzDYKCRVc/KTION2Qn7KTX+zC0lSvH3A7xgJ7mIRzuW3Y
         c2PA==
X-Forwarded-Encrypted: i=1; AJvYcCWyvgrANt7veRqUAfjsMW624xgioBm0OHcWQHnafughWfxAywFo8LYJwKXkcHIwQfVXSaI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmcdX4/F4thLdVvSjDcjCUSXfU450A1ymiwAPDBclgENtqONM/
	8ZG17u9KIWkLKt6GxNnhMq1R7a+DEIjsWyUU7bv353zpj/piE3RVjoYMHrwz4WjeB20CQNTZo5a
	5FfhRE8xKEejL6YgmjsG4Cks3LywmH6bSMyv35ncdV7hSCylY5WlV2f5saXFjkg==
X-Gm-Gg: ASbGnctVzkY4o96Co6pDne1nhnUOOCUuS5ekg+SGRgw7kpWIKcMQ84Y5Rug+U/wHk/H
	DbggQ1L1gjx/mTFM5TWagi8alMxWlp26ZAaGCOzYCJ4GRv3UpMimvIrnyyEoUxqEHDo5xrKiHk8
	/p0z+dUrjNR9KgOb4ZC0N+pmDuhNdLm61TI5x28jc3cJs/yqvnKUDUdP+ssJinRMzRgq8J0xmkB
	XWsknra/C8iCByuleCFFRI7qW0Qfj8XCjoiP/Bno/ifEhwSskaWPrvLl2LNVerBoP/yFSb/IYnV
	dPzvrCH9BumeiVGZHmPpuGQEn97re0+jDeg1H20uNgI=
X-Received: by 2002:a05:6602:140f:b0:87c:469c:bcdf with SMTP id ca18e2360f4ac-886bd26223amr1074675839f.5.1756320902464;
        Wed, 27 Aug 2025 11:55:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGcn4XXONhUn8JvBftE3ZsZrBNhr3WQ7ZVNO9SR8mW/jmt3C0qMFBX2Cm9qP6Uy+O7yYpbTWA==
X-Received: by 2002:a05:6602:140f:b0:87c:469c:bcdf with SMTP id ca18e2360f4ac-886bd26223amr1074674039f.5.1756320902025;
        Wed, 27 Aug 2025 11:55:02 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-886cf7a8c45sm722969439f.15.2025.08.27.11.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 11:55:00 -0700 (PDT)
Date: Wed, 27 Aug 2025 12:54:58 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Alex Mastro <amastro@fb.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Jason Gunthorpe <jgg@ziepe.ca>, Keith
 Busch <kbusch@kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
 <kvm@vger.kernel.org>
Subject: Re: [PATCH v4] vfio/pci: print vfio-device syspath to fdinfo
Message-ID: <20250827125458.6bc70a1d.alex.williamson@redhat.com>
In-Reply-To: <20250804-show-fdinfo-v4-1-96b14c5691b3@fb.com>
References: <20250804-show-fdinfo-v4-1-96b14c5691b3@fb.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 4 Aug 2025 12:44:31 -0700
Alex Mastro <amastro@fb.com> wrote:

> Print the PCI device syspath to a vfio device's fdinfo. This enables tools
> to query which device is associated with a given vfio device fd.
> 
> This results in output like below:
> 
> $ cat /proc/"$SOME_PID"/fdinfo/"$VFIO_FD" | grep vfio
> vfio-device-syspath: /sys/devices/pci0000:e0/0000:e0:01.1/0000:e1:00.0/0000:e2:05.0/0000:e8:00.0
> 
> Signed-off-by: Alex Mastro <amastro@fb.com>
> ---
> Changes in v4:
> - Remove changes to vfio.h
> - Link to v3: https://lore.kernel.org/r/20250801-show-fdinfo-v3-1-165dfcab89b9@fb.com

Applied to vfio next branch for v6.18.  Thanks,

Alex


