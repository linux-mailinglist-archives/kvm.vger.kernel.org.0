Return-Path: <kvm+bounces-28067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2E4499306E
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 17:03:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0065F1C212F6
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 15:03:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 740BC1DA314;
	Mon,  7 Oct 2024 15:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="EsG8/Azs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B574D1D79AF
	for <kvm@vger.kernel.org>; Mon,  7 Oct 2024 15:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728313303; cv=none; b=CED0APxOfH0QAOMaSg8oRm9yksxknQhVDIn40sY/2ER8DTAzygdqGndNe0PdtjY7qt3E6L8RhZxIZgadG4O2rsE4zf00TGmsTtD+L1YMJ0cD8AaBpNsy6Dni601j/X2WvgTw81ToIbVIG0+2WftjiXIt1huiM2K3XijX1pmxE8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728313303; c=relaxed/simple;
	bh=rRVuIaOx8RNrteaDGFooPVCgbWZsVHEatmlbzj7fViY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aOQzGm90b4ETSBGpeJBTK25Uaj4U4N/QLahaJ0zJ7GT/fh9wpxOouRdER7XC4r0xdLv3IHXSKDDh/6R3vTG3cs9k5KLZBRvv3EPz+X3Ld9/ZDh4CF64Bn06VPKD0LccerW5s/dZCLDkp2Eds44H+BEiv0jdQ6fo8zNCWaNWGKmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=EsG8/Azs; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7acd7d9dbefso475262585a.3
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2024 08:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1728313300; x=1728918100; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4bInHqGw/7pXdDA3IXyTgOVdi79kStxfjp6yDL0daeE=;
        b=EsG8/Azs6QNi2ZnSa0so8tY9ftg0gKXL7pk4qP9hzK5qrt0wUFXXRvdMYKCbCcRS9p
         n49LNm/AILbZ/GDgD7o4iZrfiVTp10yzlTfOP1at0rgWo+Un3HbPw37hBXVX1npXym2E
         75TORHgNOBV7807m/bcEecsmrYSnyysT6xOMVmgja6O3AN3nWzREdUH+c3z1WX1aeiaV
         +TTkJPo6/GuAw6WGrxIcMID64yV8iz4PyH/ikIIDPUPoZyNs1ibCA2KoclqId9viUvGm
         Z8QVkWCS1B8n6P26wYl0PK8tvNxHwCGz5xblLTJZSpJHo2+lb6k13l3kA07ltMsfvxmD
         tJHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728313300; x=1728918100;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4bInHqGw/7pXdDA3IXyTgOVdi79kStxfjp6yDL0daeE=;
        b=PQqbsI7t1w62hXP1zrGzgYMOjUwcjZ/jYhxvQHIH+xvV05o1/MwLHlSt2Ul+eESTbG
         VaeCgqRTsfDbZXTumF+Mpb+JCr3FB6U3b0Q/e96kTFfvewPBzMS6p1lTKBvu504uOmvP
         3HhLW4AgVGflXP+BfNJqGozxFzO5bJ4CQnw4ml2b5DAbpqd9+d0eoxaT4dl0t65w+zSD
         nTKJ6l/VjXaXiuxn9pfQvT+mc6AarZafysCGk80+rSHhwo6D8ksFjb7971B0G+1fxtbl
         1g5ry8GhMbgzbWwnAecRpreDzDlXPesyzPtb2/JgohK30nPE++gPTqIf0KKTcSPqdDJg
         rvRg==
X-Forwarded-Encrypted: i=1; AJvYcCWnqw/yn17iEX+Rlb4jrNALwLCXK2/lEL9r7MtazrG9g5i53zzS4DwatMJxGIdqIevBzBY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKWg+D0BiHn0Ks7+EIAnQJizvOKdzrzg8JGUiMaRWDyV47nx0V
	dJdpNDLfu56k4G7FG+/FC6NIqWaSbUmX52KEny/bkyZfumnk6bl0fqBTo4UP6/0=
X-Google-Smtp-Source: AGHT+IEC12fI88Gp57MHDcshS4/IkrApM2kBYgZQIiBILAEfDwFMFN//oZi0JmEkR0VcJlcGa+25Vw==
X-Received: by 2002:a05:620a:40cd:b0:7a9:b914:279c with SMTP id af79cd13be357-7ae6f3aecbamr1931318585a.0.1728313300551;
        Mon, 07 Oct 2024 08:01:40 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ae7563619fsm264722085a.62.2024.10.07.08.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 08:01:39 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sxpEw-002Wvt-Te;
	Mon, 07 Oct 2024 12:01:38 -0300
Date: Mon, 7 Oct 2024 12:01:38 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Gowans, James" <jgowans@amazon.com>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "kw@linux.com" <kw@linux.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"madvenka@linux.microsoft.com" <madvenka@linux.microsoft.com>,
	"anthony.yznaga@oracle.com" <anthony.yznaga@oracle.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"nh-open-source@amazon.com" <nh-open-source@amazon.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"Saenz Julienne, Nicolas" <nsaenz@amazon.es>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"steven.sistare@oracle.com" <steven.sistare@oracle.com>,
	"Graf (AWS), Alexander" <graf@amazon.de>,
	"will@kernel.org" <will@kernel.org>,
	"joro@8bytes.org" <joro@8bytes.org>
Subject: Re: [RFC PATCH 05/13] iommufd: Serialise persisted iommufds and ioas
Message-ID: <20241007150138.GM2456194@ziepe.ca>
References: <20240916113102.710522-1-jgowans@amazon.com>
 <20240916113102.710522-6-jgowans@amazon.com>
 <20241002185520.GL1369530@ziepe.ca>
 <d6328467adc9b7512f6dd88a6f8f843b8efdc154.camel@amazon.com>
 <e458d48a797043b7efc853fc65b9c4d043b12ed4.camel@infradead.org>
 <1d331c55a299d414e49ba5eb6f46dccb525bf788.camel@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d331c55a299d414e49ba5eb6f46dccb525bf788.camel@amazon.com>

On Mon, Oct 07, 2024 at 08:57:07AM +0000, Gowans, James wrote:
> With the ARM SMMUv3 for example I think there are break-before-make
> requirement, so is it possible to do an atomic switch of the SMMUv3 page
> table PGD in a hitless way? 

The BBM rules are only about cached translations. If all your IOPTEs
result in the same translation *size* then you are safe. You can
change the radix memory storing the IOPTEs freely, AFAIK.

BBM level 2 capable HW doesn't have those limitations either and
everything is possible.

Jason

