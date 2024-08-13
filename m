Return-Path: <kvm+bounces-24046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42B4C950AAB
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 18:46:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73E311C20E6E
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 16:46:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2B831A2C14;
	Tue, 13 Aug 2024 16:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ccRme6QQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9BA1A257C
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 16:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723567425; cv=none; b=BICrutcPJOJj96BRTRvuU8DRO35qzaBDXweQOumsM/+wMt7oyTxaGCeUIOwyoL4ub/gYSq70Gh9A5l3lG3HL+3Sbf0dubKH6yu+O3Ab3VcBpo23/qPU+NbdIyIIVDSmBl3p5/1+70JN+GCwEozzsMDrsYlNxYtBt/S8SLD6WoJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723567425; c=relaxed/simple;
	bh=clgAIbvfrJrk1IcVma008X2y2mp12ev0nTOUNJlQorM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PccXbd8inxyt/QQuYcyquso0MzhX3bcTvaYjluZUxXPQSBA6M/iorUc+URwwqGtpyJGlqXIg55F7/gODr3oNJh25A2hMM9HprwIbfXItyVAIwNA18m9s0T/tPayp/BfLojWLFNayrNe3FHMeG+zc10Sjhbo3/1jDABc4pUDxp5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=ccRme6QQ; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-5c6661bca43so3430645eaf.0
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 09:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1723567423; x=1724172223; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ROqRYY1dqCAC6kog/NOEL1zLkAqrmdMPMSau7oyZjtU=;
        b=ccRme6QQmmLmQbTDKjVCxdzd0SYMQEEqLz9z+DcY2XXzjcTZ2Lc2hM1B4rk9dVpkcg
         WLjt1uAw7zXi5bOAC7OhLIMeie6S29GSgu1LYJg4BuRgpD+wh86kLCBbn25Sxtwpzmj2
         c0g2Oy1qjeJtORNJ7YLxQp2vEW9AxG+42M8SXb+S9euTZMPBVudyxusnYI4n5mgFV9ty
         /7JZxW089iONiddU37w3INpPV8tdMKkjjw8ru0V+1HqHZqJNFktkmg9m17mjYrxQcLPH
         0cJeJGn+J97jt7B1T4qzyzzHIRUdu57VGESwbdaMJSREA4nzH69kwP1af30zhKgKMYZ1
         +lFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723567423; x=1724172223;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ROqRYY1dqCAC6kog/NOEL1zLkAqrmdMPMSau7oyZjtU=;
        b=U5mz//QPN1ib4jkIzrjkja5oEFZmJwbANQIoZImPqj3DalMQvKjbQM0+dUwL5Wr/2u
         XLobKKw+yO6VKsY7DUpUDrln8IuhBGi3caKElWFmILFY/zxi/3sMlyvtTBbaTKusuXUw
         mq7B9gDG3Nl6FWluiYSZgV8ZMKAPr0zNyqZQxgHEHMbOVAzpqVIrAiWIE+OeVo6pSEzg
         kUo5C/a6YKWYdsVJqtKy6IhpZXyxWnO5mPKBcvGbHOsyzuoih0QRUTnCFKg0HQVOnH8r
         xunvdeGLit8hr6EBYILBZNAE0BdlMASM38g5kWQwj09OjfSHjfugTPpyJT643dufKRka
         GoaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVt9ymP7vCJtdxDC7I9aIS9/jf3gq75Lwy7u8mfwwbXnT9268odmBHqV6pxyKIgVUwbfmO6DfOHsvDNmco86fJqshKB
X-Gm-Message-State: AOJu0YzIKKZJud+dB60Ypeuwqycmgr2q6FU266CwIsbzzVQiYXPJX30M
	IH6GtK0+GDsLGUdXvL5DW+jf6Q5ivv+EQkO7+smeQnbo3RI4cFsRfaKSSB4V2Yw=
X-Google-Smtp-Source: AGHT+IEvmSCVnjpjqrFJiGnBKOZvxrmuCp6UnsBlqoXz0YHrq61kKl9NZyVY0sS6gN/GBZB3kKmjIg==
X-Received: by 2002:a05:6359:410d:b0:19e:fa9c:5ec9 with SMTP id e5c5f4694b2df-1b1aab4ccf6mr3925955d.9.1723567423216;
        Tue, 13 Aug 2024 09:43:43 -0700 (PDT)
Received: from ziepe.ca ([128.77.69.90])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bd82e2f405sm35400856d6.79.2024.08.13.09.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2024 09:43:42 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sducX-008U9H-Jt;
	Tue, 13 Aug 2024 13:43:41 -0300
Date: Tue, 13 Aug 2024 13:43:41 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, quic_bqiang@quicinc.com,
	kvalo@kernel.org, prestwoj@gmail.com,
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
	dwmw2@infradead.org, iommu@lists.linux.dev, kernel@quicinc.com,
	johannes@sipsolutions.net, jtornosm@redhat.com
Subject: Re: [PATCH RFC/RFT] vfio/pci-quirks: Quirk for ath wireless
Message-ID: <20240813164341.GL1985367@ziepe.ca>
References: <adcb785e-4dc7-4c4a-b341-d53b72e13467@gmail.com>
 <20240812170045.1584000-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812170045.1584000-1-alex.williamson@redhat.com>

On Mon, Aug 12, 2024 at 11:00:40AM -0600, Alex Williamson wrote:
> These devices have an embedded interrupt controller which is programmed
> with guest physical MSI address/data, which doesn't work.  We need
> vfio-pci kernel support to provide a device feature which disables
> virtualization of the MSI capability registers.  Then we can do brute
> force testing for writes matching the MSI address, from which we can
> infer writes of the MSI data, replacing each with host physical values.
> 
> This has only been tested on ath11k (0x1103), ath12k support is
> speculative and requires testing.  Note that Windows guest drivers make
> use of multi-vector MSI which requires interrupt remapping support in
> the host.

The way it is really supposed to work, is that the guest itself
controls/knows the MSI addr/data pairs and the interrupt remapping HW
makes that delegation safe since all the interrupt processing will be
qualified by the RID.

Then the guest can make up the unique interrupts for MSI and any
internal "IMS" sources and we just let the guest directly write the
MSI/MSI-X and any IMS values however it wants.

This hackery to capture and substitute the IMS programming is neat and
will solve this one device, but there are more IMS style devices in
the pipeline than will really need a full solution.

> + * The Windows driver makes use of multi-vector MSI, where our sanity test
> + * of the MSI data value must then mask off the vector offset for comparison
> + * and add it back to the host base data value on write.

But is that really enough? If the vector offset is newly created then
that means the VM built a new interrupt that needs setup to be routed
into the VM?? Is that why you say it "requires interrupt remapping
support" because that setup is happening implicitly on x86?

It looks like Windows is acting as I said Linux should, with a
"irq_chip" and so on to get the unique interrupt source a proper
unique addr/data pair...

Jason

