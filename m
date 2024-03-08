Return-Path: <kvm+bounces-11378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F1DA87694E
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 18:06:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9190A1C226FC
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 17:06:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D722A219E4;
	Fri,  8 Mar 2024 17:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="DDurbmA3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C5F20320
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 17:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709917552; cv=none; b=OxWqIYCzVkSGfLPeCOgclYYpZ8GQ3OYdhT/gctewubURik1WyUP4FfxtQFktit0YIeTvkomUx3VMghm5eC8tXLKzAEhpXKD985hhxDOsKgVMH7Qn0X/UZoFt0KcTzRKxDsumyeVZxaGuVlFn8mQrh6OV+YnJOc4fPtSJHley/PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709917552; c=relaxed/simple;
	bh=V6KJTShdwT+mkrh0tNjho/v1spFJQp+mhN1u9pDoGUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Daya/D/c5pa/riqJReLdgD7XVBuWMrvm43lz6CRDAMj1YakjEw1+z8J5BpKiclU6lYaZYTFCbHsy/LSgj3WOj4lEx8N6rl8XGgxDGTrQjK2FpeiXREJrv05WB3kC+UUaVtEFvn/JAScjLaNu55MAy3Wkl1DL6s2D9BhcrM1JI8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=DDurbmA3; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3c1a2f7e302so569880b6e.0
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 09:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1709917548; x=1710522348; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M1AjcWBSkItGUiNsU5CP48uMxnVb158nfN7iDwmiCRM=;
        b=DDurbmA3S6btZn2V8KtaQVOAeU8XJtj2r2bxnzLWx/bXgBtqnKFzitf+UKd3O+C8Sf
         GzSEE5xJX6ZJwq+cgIT9I+GoVPReBCKzUqa3diO4WI2esw9hE4l4Ybc+d1u+FQmA+2ru
         /t6/zSUaORfxu+qRugu+U6q6pVMItxiwHgC6N5VdfO8aP01mvm0otMqzG0VW9GPaKvym
         w9RnhV2zf+ykqTh/UWxYdF4koZZy375vi2K90ej2Dpn9zybrsvP6NTGj3BBH2Ougo0Yh
         YrKZkb53J0xmtuSnehL9IeWufuOOeF20AX4aowrlITKI1CoGUICBc2F16BYKP+z5pCAV
         gfKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709917548; x=1710522348;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M1AjcWBSkItGUiNsU5CP48uMxnVb158nfN7iDwmiCRM=;
        b=H0dNgJi7yHfyvtKja4dRnJEKpPsl85Y9kCHN67M46XHGJYcpU45hyaQOg8ezHrzDmp
         5O87QpgBhQwe6ITR1/e7ohpqzeLGWndoH3IN8VW1yg63V/K0fd8LJ1gCte6bw6OwVNWT
         iV7ktME0dUkDR6qOzcVFqGdzkb9vBoBjHLCsHiQ91csWYYkfbsaUcBbBaH6Cg4DrZUGX
         /hlLnfD/oa8poEnA6Qh+4BkXS6A/dqzL2UfSuoBPkmZuYX5neUbH81sfyO2WSLp8aly+
         J1dEJccyN82VAh9kFN9yn96Jo3X/r/GNUDjpYNSD6mWuskNrVtD2OFu7hZ42Lw/hQ9Kv
         u8nA==
X-Forwarded-Encrypted: i=1; AJvYcCWsilBuV7Xq+3FT5cfXOU5wVRgEYOwOhO4k+4jvi/+srNLK7WThNj+FTqMJiirqhmEKmmF4/kkmRJDwHzjcVpZh1nGy
X-Gm-Message-State: AOJu0YwuXRhABl660DlclYvYs/yC9YKjhlvQ4XPIAhtWbt5+CBYKTrBs
	+CMpP5DhWw46LptsqTk+tJX1jU0aTo0aQB30oBqXd0hAs2ly6Are56IuRMFImKI=
X-Google-Smtp-Source: AGHT+IFmpdDM8Yw9rLFEeWGGVYCMO+qikKXQROcwg2THfy528Bht9EXOGogx2z63mdDKX9uCapRecg==
X-Received: by 2002:a05:6808:1393:b0:3c2:3a02:2731 with SMTP id c19-20020a056808139300b003c23a022731mr106904oiw.5.1709917548441;
        Fri, 08 Mar 2024 09:05:48 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id v2-20020a544482000000b003c1ec2c3fa5sm1655913oiv.42.2024.03.08.09.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Mar 2024 09:05:47 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1ridfG-007SKN-Rm;
	Fri, 08 Mar 2024 13:05:46 -0400
Date: Fri, 8 Mar 2024 13:05:46 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"clg@redhat.com" <clg@redhat.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] vfio/pci: Disable auto-enable of exclusive INTx IRQ
Message-ID: <20240308170546.GS9225@ziepe.ca>
References: <20240306211445.1856768-1-alex.williamson@redhat.com>
 <20240306211445.1856768-2-alex.williamson@redhat.com>
 <BL1PR11MB527189373E8756AA8697E8D78C202@BL1PR11MB5271.namprd11.prod.outlook.com>
 <20240307132348.5dbc57dc.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240307132348.5dbc57dc.alex.williamson@redhat.com>

On Thu, Mar 07, 2024 at 01:23:48PM -0700, Alex Williamson wrote:
> On Thu, 7 Mar 2024 08:39:16 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
> 
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Thursday, March 7, 2024 5:15 AM
> > > 
> > > Currently for devices requiring masking at the irqchip for INTx, ie.
> > > devices without DisINTx support, the IRQ is enabled in request_irq()
> > > and subsequently disabled as necessary to align with the masked status
> > > flag.  This presents a window where the interrupt could fire between
> > > these events, resulting in the IRQ incrementing the disable depth twice.
> > > This would be unrecoverable for a user since the masked flag prevents
> > > nested enables through vfio.
> > > 
> > > Instead, invert the logic using IRQF_NO_AUTOEN such that exclusive INTx
> > > is never auto-enabled, then unmask as required.
> > > 
> > > Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
> > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>  
> > 
> > CC stable?
> 
> I've always found that having a Fixes: tag is sufficient to get picked
> up for stable, so I typically don't do both.  If it helps out someone's
> process I'd be happy to though.  Thanks,

It helps other distros in the ecosystem to flag patches that really
should be backported. Not everyone runs their backport trees as
agressively as a stable does.

Jason

