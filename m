Return-Path: <kvm+bounces-15719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AB6D8AF7F5
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 22:25:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C4ED3B26916
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 20:25:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66B001428EA;
	Tue, 23 Apr 2024 20:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eBGYeOTY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A36142654
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 20:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713903909; cv=none; b=IWKyC66cBj/fU3SjN1fl1x5TdPhvsTLZ/U7A5gBHdk2hZCxJHHb/svTNBLlXutomwKSacnuolf0gcy3mHsCLoxMN36QEe1UCIbpVht/77vlAZvdnzLLQpH4FofolTOBPZD+5kVJlsPO1ed4bevg4wALfeFzAA5pJ+zgX7A3Pswc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713903909; c=relaxed/simple;
	bh=IiKD5SyliMCZS6uycnE4FDV8Y10UkP2LI2qZh1H+yng=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FhhCBGSYAyD5oJCVaQIYwKHgCRA5nK8rVmiEP5ZwYOGcRbXntcxYqDzVDctjUEJYDIhlg4xZTxv3lR4QbG+Sz0C9nUwy844dCtAZJpcGZ2Jit8WfsMIpEiOrGts82W0D8Si3f9b4j9TwlD3OUO86rV4HkXxvhGyiUlbUv2HFXHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eBGYeOTY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713903906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s2YosHNze/KnevH6aeloLEYctU29JplkQLtgxuJbONU=;
	b=eBGYeOTYKBYj7mC79yYW174XR386HEwPIw17qdf2kUGfeFsVVxUuVsAFl+YzqnENcezKvP
	5zqhnJsSOQmrOgrmraAFF5RYRXW7TneSZEg2/FzN9z+yvQVBHhITnklRruRxjkFLZVSGRf
	p9etYPHS0sOjIrCCLSa8N7bt+0yUnwE=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-bbzmOSKEOT6kpSsVpM8L4A-1; Tue, 23 Apr 2024 16:25:05 -0400
X-MC-Unique: bbzmOSKEOT6kpSsVpM8L4A-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7dd8cd201aaso204192839f.0
        for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 13:25:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713903904; x=1714508704;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s2YosHNze/KnevH6aeloLEYctU29JplkQLtgxuJbONU=;
        b=mhTyOw5dltNHcFF8gMorvlTdYR0kW4/jRhcp30qrmScez9i2qmFZoxMDLT1l5cTenI
         g7+y8W3ojwTGasohEALr5nOFFNDXUebP1avH1kjSWrVV7P+QgCaMBbdt3EwpxUIn7sgB
         RtYf5F7ilyZXfSi6N6JRGU7hko07j0Jii5FSKKr7S5Hc8m8bzTUxTy6zPVHjQDVWN3zb
         VSp/TVo0d82BICl7ZAAyZ5At6yfwrgr8rWfqTMx3rki2hQFkSTlAKKFqc7Kw5iUDswFc
         nFdEu7ig5AMCwBeRdlfv/DNL77RFz4SCCYYBDk3ZwKvjQaOlmtLbZ0tb/x2338OUREDE
         Z9Rw==
X-Forwarded-Encrypted: i=1; AJvYcCWCbrpDC+3V0OHHc/4pcD50UwcmKKkxdmaLNTbrLpGX4wmeYERMSE0S60WuZn1K+WGAnr4pa1+4vTX6DzVYX2iC2/7h
X-Gm-Message-State: AOJu0YzM9lXjQran2PNHzsT6kJEhzZIXg1BbwNmJUIhMYaQlzrUywwxp
	n1OE5PoyngZ6BfLc4yIKzueqllhPEZx9oMf3ciSMIEcp7b4aTQQzaNDc8NvYurRKr3zr1G68QKc
	rJK7x1dn6recwH3IzcP0RVioxHrR6700cZS1zq3RRdEGATxZD9g==
X-Received: by 2002:a6b:fc19:0:b0:7d6:bf30:a39 with SMTP id r25-20020a6bfc19000000b007d6bf300a39mr634223ioh.9.1713903904655;
        Tue, 23 Apr 2024 13:25:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IERbsuOghp6nNjyihZkysSp2DlUBwqMP/IoKpPnCpTuyK0FOD4xZogtqfEBcmtUW2M41qudAQ==
X-Received: by 2002:a6b:fc19:0:b0:7d6:bf30:a39 with SMTP id r25-20020a6bfc19000000b007d6bf300a39mr634209ioh.9.1713903904304;
        Tue, 23 Apr 2024 13:25:04 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id x5-20020a056638160500b00484f72550ccsm2540519jas.174.2024.04.23.13.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Apr 2024 13:25:03 -0700 (PDT)
Date: Tue, 23 Apr 2024 14:25:02 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Ye Bin <yebin10@huawei.com>
Cc: <kevin.tian@intel.com>, <reinette.chatre@intel.com>,
 <tglx@linutronix.de>, <brauner@kernel.org>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio/pci: fix potential memory leak in
 vfio_intx_enable()
Message-ID: <20240423142502.3f10bc92.alex.williamson@redhat.com>
In-Reply-To: <20240415015029.3699844-1-yebin10@huawei.com>
References: <20240415015029.3699844-1-yebin10@huawei.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 Apr 2024 09:50:29 +0800
Ye Bin <yebin10@huawei.com> wrote:

> If vfio_irq_ctx_alloc() failed will lead to 'name' memory leak.
> 
> Fixes: 18c198c96a81 ("vfio/pci: Create persistent INTx handler")
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  drivers/vfio/pci/vfio_pci_intrs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Applied to vfio next branch for v6.10.  Thanks!

Alex


