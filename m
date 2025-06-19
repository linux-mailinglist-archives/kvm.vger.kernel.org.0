Return-Path: <kvm+bounces-49982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF8CFAE08C4
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 16:29:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46A9A178A69
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 14:29:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CB4E220F24;
	Thu, 19 Jun 2025 14:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UTFMOwgV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507F121A437
	for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 14:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750343389; cv=none; b=G8XcveMMGMi7Rf+bM3udoAt1eAxKC9PB1IeqmCiu6THL/nTqNXzzBAyQkMnfVbD39W9e/0o46ENWDm+9d6apkvq/QLKkJQ85Rz1odMipCiDSH+riW56rJpC0g2VFBiJfzlusVhsr5YHelJ04C+mXKXNF13jDnTVOKaz5J+uKV9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750343389; c=relaxed/simple;
	bh=JSkUUtxu4awPtGQwUQ31Xy0Jw7VvKvOEfSy1FzmDztk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b28r4rHbkCOtsm3KtphmXHNx7Q6i47tExEfOye7lMtYEGv6F9dpvOaGHG5RFgf4xQDfTvBvaGYYmBh9c6uSXEKMk0+0KXQLIGMBuqHsbuT7dVKSPK3DXrxLaWoan0u4pgDAmItxdBbQC/EieRbi0mtR2XXVirqa3agnb/Dhulgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UTFMOwgV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750343386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jw4+AfBdpsqpQGJ0mcxwqiIcpsICB6zMjxgca9zqplM=;
	b=UTFMOwgVlc4vchNRUYwlLD4cQluVSoA+PEPTjPmJPI1gIi0KKYN4jcItRSQb20256Ga9Ol
	mIjkKmcEGnSfRqspLXO4ZmbNP0CLbk8GTLYv/kVK80znIJYkQMeDrL2JFfeuZM47xASsKZ
	JdZAFiecavnkcn09blJV7U4eRp2vVj0=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-104-2fnoIt8mOvWa3V37z5HcGA-1; Thu, 19 Jun 2025 10:29:44 -0400
X-MC-Unique: 2fnoIt8mOvWa3V37z5HcGA-1
X-Mimecast-MFC-AGG-ID: 2fnoIt8mOvWa3V37z5HcGA_1750343384
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4a442d07c5fso18028371cf.3
        for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 07:29:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750343384; x=1750948184;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jw4+AfBdpsqpQGJ0mcxwqiIcpsICB6zMjxgca9zqplM=;
        b=qGcLiqcz2icl+JBk8ovLD2ejCSUb3hi8aTnI2AsIYe+Iw3S6KYc3hXLr2KeOFBZW7D
         qE8BvEsbT5bphXSRL6ub2fQRWiuNmAJQOh905WgkC7iEcc94+Z1RsSorim26q+1jssQU
         xJ3FYTLh9Qj4hyGTP7/PGJppnjbFkwQK96/BwNHtpVPt41wSy3H5+L4khUrRO0kZoLS3
         eUs3A3MUG+N7uP2cARuuWeOct9NWCEQeJz0EeSsqoHE6xNfBVEMY6mKVI12tERO+EHex
         Bh1tZwosAiOGwZdYl4fp36W3NnotAKlIUZNeeZu1P7a+diJn3gE8eKdQjp44TvYu2Id8
         Ar4w==
X-Forwarded-Encrypted: i=1; AJvYcCWCJOKI2k3dG8pA3LlFbxtP6T5uKxBDsW+DcEVNxRjovu+mKTux6hszmJPublfP+fqmILY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzMFAHaWGjcOHN03+nEh2fwteain/pqcT03k1mAwXhHLwjn+2M
	m4J65MnLTxqjLOqsUWJJhV3UGq4r8KC0Jz3ZNVghUlgvOgRtUTxV4Zm3X/OJA+MZ4gbM8DdI4wc
	WHx2Gy9k5qeKrAjyfTX2g4TOankN6ZtybNGuUz/J6nPL5kVw9qt0SCQ==
X-Gm-Gg: ASbGncuubOT+UIreE8OjA17wSzMYjZQopux3aeI0VEF0/n+kxZAP8cc0KUfm2CezQBz
	Com+MBhgwvHPRwGF1vuT71i8BXBn/wgjVFIVX/OdYZhJTc015uL1ODurq4zsps9LEBwOIUOXcPl
	0mXDT2uoOTAeGQBY1L6Pg//WDOsPV6aU33lo0/Y8qCVOTVPK8Qlkd0hOUPsns0T5KJd2d4peS82
	+6k1RkvJyjjoWccvNy7EdLGgytsGKGv+8FkBaxNjAb/qgCsJaCdSWV2oevwSXBMMkmAlctSzZ2g
	7eBo1BDH3TIoeg==
X-Received: by 2002:ac8:7548:0:b0:4a6:f774:dec5 with SMTP id d75a77b69052e-4a744b38ecdmr257416611cf.31.1750343384386;
        Thu, 19 Jun 2025 07:29:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCo4NFNd2eVXjNyKWheRktH1dIovpHIBm3XaBDiAXDGMbj37MfoGzfHeFmCUjPQXbgIGALvw==
X-Received: by 2002:ac8:7548:0:b0:4a6:f774:dec5 with SMTP id d75a77b69052e-4a744b38ecdmr257416181cf.31.1750343383959;
        Thu, 19 Jun 2025 07:29:43 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a72a3112b8sm82903861cf.31.2025.06.19.07.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 07:29:43 -0700 (PDT)
Date: Thu, 19 Jun 2025 10:29:40 -0400
From: Peter Xu <peterx@redhat.com>
To: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Gupta Pankaj <pankaj.gupta@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>, Baolu Lu <baolu.lu@linux.intel.com>,
	Gao Chao <chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>,
	Li Xiaoyao <xiaoyao.li@intel.com>,
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v7 3/5] memory: Unify the definiton of
 ReplayRamPopulate() and ReplayRamDiscard()
Message-ID: <aFQe1NcMSyCTiDoF@x1.local>
References: <20250612082747.51539-1-chenyi.qiang@intel.com>
 <20250612082747.51539-4-chenyi.qiang@intel.com>
 <0de41d54-31da-466c-a6bb-f45ff919ced5@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0de41d54-31da-466c-a6bb-f45ff919ced5@intel.com>

On Thu, Jun 19, 2025 at 11:06:46AM +0800, Chenyi Qiang wrote:
> To fix the build error with --enable-docs configuration, Add the below fixup

Thanks, this works for me.

Though I just noticed it has more than the doc issue.. please see:

https://gitlab.com/peterx/qemu/-/jobs/10403528070

So 6 failures (and you can ignore the rust warnings):

https://gitlab.com/peterx/qemu/-/pipelines/1878653850

WASM complains a bit more than others, but worth double check from your
side too.

Thanks,

-- 
Peter Xu


