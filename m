Return-Path: <kvm+bounces-29470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BAF079AC164
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 10:19:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 666541F2510A
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 08:19:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD921158A09;
	Wed, 23 Oct 2024 08:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fxllouxZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C1015852E
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 08:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729671555; cv=none; b=BpZky5TUREGBXLrcBdcAOZg3RFt0D26nP1m25ZN6oOQYgCgQNa2jjMsAQ+6D7cjMu+24NY2vraGfw19PQsWK6g+nmUFOIkgx6ELiq4+n+lYWbcbpXyMtSuODmZKdPrnTIJ7modYGPP+KI40dEJbE48kUJkQkOdARxW/+BW3Ire0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729671555; c=relaxed/simple;
	bh=YTmqyiXUVuGr+Gh619vU8cd1U4QuivNESwr11uwnKMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lI3NSMAKo2+qdPa9bd5vgK+/Ww/1NXp+oiIPTfCRCtPYREIA78S8WqXyFnxo0dwAwboNgAxUdEQPv6zh7RWd9p9AUUihz+bfJzXOYypYL01XyOUJGFpDbIr4Zav0tWI2BDaeMbH8DlJDbvOoXf4o/4QvCKfQmIeyNIaTlr/iqYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fxllouxZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729671552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lj3kTDQyz2Ila1/KyVdWNvT3mRytQreFHg0SSqDc3rk=;
	b=fxllouxZ3d6TY5bed3ryAsMSvhU11deYxlYlvNkH1o2ONCnOBY9wDcuoB2OWJMWrzvlAzg
	9bz0Ig6wx6E9sOVaby0FVWwmZyXM2olWpxtuQjs7h59EBQ7E/wxjlEAX2LATfy66h7R6vM
	2DHHVEZxVp1WQstA1dEXi0ZTe1g+7rA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-2h5J7y54NXeTBvSDYH8WbQ-1; Wed, 23 Oct 2024 04:19:10 -0400
X-MC-Unique: 2h5J7y54NXeTBvSDYH8WbQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43154a0886bso47206815e9.0
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 01:19:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729671549; x=1730276349;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lj3kTDQyz2Ila1/KyVdWNvT3mRytQreFHg0SSqDc3rk=;
        b=X/voIt+OdTkVzSbFq5TDSJTR3jDaYUEimJgaQtjE9T98npH6awUtVJfmLXUcgT41fv
         DicOlrQvolTUGdjAvG6IOfRt67KVb0BP+bk0K5u1CIt/vZisaSXHkt8xTmnryfObC/Qa
         IQC09DC4Y8cAE15tgHH9GeJnUS5NfRCE0MBC6FMMzVvN8jBVhCRkS3IEoz5K+nIovm2w
         cW9HGFUbvcrGSKCHwyxI+tGWo4/OcCSundbh83Bo2IL2xdKZbpRmLH4RmPFSHyCGZOTo
         beyrZGZ97knCctpt/y+gAAiRGeZwFbqsdPYrJMsAdxaMaaaR/9Yc0ydkUnh77VbQhdrm
         NQSw==
X-Forwarded-Encrypted: i=1; AJvYcCWAEd8guv88m5vh8+Jt03Pk+EkJZ1i1LBFmplsI33mHgugGr+xBOQqsv6O6hAp3An8cpi0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCZHGo1twQrDrrMZ109JOieT7A+Yb5K++EYW9o1F2SBRZKOsW+
	8BKEjXIdgGOXaYS92cpkhFdB/PTcZq9QD5+yChu5qwt8hKIANUKmigRiSxg8rexLpemDY32T6HB
	fHyFQWiF3ZyklS4Vn+/oMdmjCmwCXa+SLEsl0w5S///AXZqPiyeO0xHMKww==
X-Received: by 2002:a05:600c:1e22:b0:430:5846:7582 with SMTP id 5b1f17b1804b1-431841ee1b9mr13708785e9.7.1729671549261;
        Wed, 23 Oct 2024 01:19:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFusMJgqND3nBXD0ggRCRYPJkNUCP74BP/zihbIdNOtOBhuotxICVzslO5BzRnF0Gmb6GzOdg==
X-Received: by 2002:a05:600c:1e22:b0:430:5846:7582 with SMTP id 5b1f17b1804b1-431841ee1b9mr13708575e9.7.1729671548910;
        Wed, 23 Oct 2024 01:19:08 -0700 (PDT)
Received: from redhat.com ([2.52.26.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43186be531esm9272865e9.18.2024.10.23.01.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 01:19:07 -0700 (PDT)
Date: Wed, 23 Oct 2024 04:19:02 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Srujana Challa <schalla@marvell.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"jasowang@redhat.com" <jasowang@redhat.com>,
	"eperezma@redhat.com" <eperezma@redhat.com>,
	Nithin Kumar Dabilpuram <ndabilpuram@marvell.com>,
	Jerin Jacob <jerinj@marvell.com>
Subject: Re: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for
 NO-IOMMU mode
Message-ID: <20241023041739-mutt-send-email-mst@kernel.org>
References: <20240920140530.775307-1-schalla@marvell.com>
 <Zvu3HktM4imgHpUw@infradead.org>
 <DS0PR18MB5368BC2C0778D769C4CAC835A0442@DS0PR18MB5368.namprd18.prod.outlook.com>
 <Zw3mC3Ej7m0KyZVv@infradead.org>
 <20241016134127-mutt-send-email-mst@kernel.org>
 <ZxCrqPPbidzZb6w1@infradead.org>
 <20241019201059-mutt-send-email-mst@kernel.org>
 <ZxieizC7zeS7zyrd@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxieizC7zeS7zyrd@infradead.org>

On Tue, Oct 22, 2024 at 11:58:19PM -0700, Christoph Hellwig wrote:
> On Sat, Oct 19, 2024 at 08:16:44PM -0400, Michael S. Tsirkin wrote:
> > Because people want to move from some vendor specific solution with vfio
> > to a standard vdpa compatible one with vdpa.
> 
> So now you have a want for new use cases and you turn that into a must
> for supporting completely insecure and dangerous crap.

Nope.

kernel is tainted -> unsupported

whoever supports tainted kernels is already in dangerous waters.

-- 
MST


