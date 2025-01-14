Return-Path: <kvm+bounces-35367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD183A1054E
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 12:26:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0128162378
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 11:26:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDB35284A72;
	Tue, 14 Jan 2025 11:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cxWKJ36C"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990CD240229
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 11:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736853975; cv=none; b=JQH0PZJgBnmiB1b4bzhPikqsVEsqCJB5y9upZU9ac6eKFvDIyYIaqgFig+MjgqUbc8WRcUcOAuvhVqzAwx0sbVbQyxIrhrP7zARe3bRO6z/V8SsmzLpExaZwudjoM8dVevYt2Bf3onn7DzELrN8/DFV8PWDZLMZ8rB+0XGzjRIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736853975; c=relaxed/simple;
	bh=P5WOc1gqUz8scmwf5xVMe2cVdYOYl+zpgG91/lMjQ8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Es/KWAP5wBtnq9ZF02ph4sOxm6mzzrUAftqAYS4evoTqvl4mAODAPuSiLgPS0H1H+0DtPL4Ccn07vBmQoVKIFczo6VH2IijkDvDkPtKk+eRZYgL19USUBKG1YE3qcTfZq2Es0HPjzSTD0JD453JirMB9J9fy6fVsA6xL8VV/ErE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cxWKJ36C; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736853972;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MsY6pEzLRQ774Ovx8M1YoG6AKNuIHynFJ8DXSapB998=;
	b=cxWKJ36C2xicuoB0Fo4zeOdovQsNbbeM845YaG4djHem/yNtQhyO2n3FRL3BL3jOD4x/do
	a9od8XLYWrAbN4eOlcVp18CzBoxJ8nmH8cQg3E7OmLREci5A8IFhiCu1yH3ShcAMcUgBNa
	L9oSBqnObdeWRXuo8SULx/RdHlYJPQQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-60-vPm6n8G2OlipHgRKiMx_jQ-1; Tue, 14 Jan 2025 06:26:11 -0500
X-MC-Unique: vPm6n8G2OlipHgRKiMx_jQ-1
X-Mimecast-MFC-AGG-ID: vPm6n8G2OlipHgRKiMx_jQ
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-436328fcfeeso42936585e9.1
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 03:26:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736853970; x=1737458770;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MsY6pEzLRQ774Ovx8M1YoG6AKNuIHynFJ8DXSapB998=;
        b=NpP4/oDMSguvGKbQtTOB37Z1Nq/u9UDTwtd5qOSRjNqu4DMGpy/+mlCPqRXJpqgZ61
         WlK6Kt738u16okywNS4hLDMzasgd+xAUUopIq5fInCItXkkKfhttPG0KGpmq7Eaaq6wR
         Hc9oZhiApjrGvu9564bFS9G8JNVwp+aDuxwjT3BgJ/nCwLB58EalVmXOXHn7WBQ5tTHU
         v7T3dvzGDWMIFCWMc2sKdqDFotRmvnvuoKResi6Bvj1JiK2OqOdnBuWuZcAfKcvCsovh
         l3WbTlFqk3N1gzDYHIJb/pakYAgboDJyfp+P6plFqDteBm/rrjYRwxtGwc5Snyem5Pto
         GrRg==
X-Forwarded-Encrypted: i=1; AJvYcCWptauemmLgHQfh2maJvtZUT/8cPS375W3NpTGKf76jhi/9ULJPx1219t3+OSo1Th+1wfI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5OZZi6D1ez6jth7xfn7OHQQmEFr04OpE8xA0C2HVfzv0tuemX
	qZ7cq2+cYZ33JRo/zcjln0Vmc9ePFY2fO4nzZjbXwogbEykTg/sIZAFqsUvDok2Rcot6yPnWPYM
	X6V+KGGTkmH23px8n6HJGDyR+grwRRAeArwcpxfihce2wooT8jQ==
X-Gm-Gg: ASbGncvsCM49E5Wedsm+cFXn5bzNLQfzbYMy2qDpBMU+wczjBA0/uBj3YxXCNnlsob1
	pXLiJZacNGgsREdng/00ab1BVB/HpRadvKJo9wnR8lUjf93QVZx2OtjLhQA9/81p+n6Bw5z0poX
	YKGoBTZ4sn3tYmbyyyPCb+EJQfaDWk7/HQZ+7RMCJq268awYXnaCMfzrOyEeHDJQ67IFPux9dMk
	/Nyki7YnFLf0huHzvAMx1f/jblqxxVW8QidQIpH5dxdw5Ci1A==
X-Received: by 2002:a7b:c4c9:0:b0:436:f960:3428 with SMTP id 5b1f17b1804b1-436f96034b3mr87034355e9.29.1736853970033;
        Tue, 14 Jan 2025 03:26:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGArTmmJVNPIIZQEpvn3/I+W40gy72w27dB0r1QO7CEIvxpSiVE4IdF93HeHvTkZVp04ua2Ng==
X-Received: by 2002:a7b:c4c9:0:b0:436:f960:3428 with SMTP id 5b1f17b1804b1-436f96034b3mr87034075e9.29.1736853969706;
        Tue, 14 Jan 2025 03:26:09 -0800 (PST)
Received: from redhat.com ([2a02:14f:175:f243:3731:6014:d7c:f11f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e383882sm14683861f8f.34.2025.01.14.03.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 03:26:08 -0800 (PST)
Date: Tue, 14 Jan 2025 06:26:04 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Mike Christie <michael.christie@oracle.com>
Cc: Haoran Zhang <wh1sper@zju.edu.cn>, jasowang@redhat.com,
	pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost/scsi: Fix improper cleanup in
 vhost_scsi_set_endpoint()
Message-ID: <20250114062550-mutt-send-email-mst@kernel.org>
References: <20250111033454.26596-1-wh1sper@zju.edu.cn>
 <bae5ca72-c6ff-4412-a317-4649f2d09cdf@oracle.com>
 <481cd60a-d633-4251-bb53-d3026e005930@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481cd60a-d633-4251-bb53-d3026e005930@oracle.com>

On Sun, Jan 12, 2025 at 03:19:44PM -0600, Mike Christie wrote:
> On 1/12/25 11:35 AM, michael.christie@oracle.com wrote:
> > So I think to fix the issue, we would want to:
> > 
> > 1. move the
> > 
> > memcpy(vs_tpg, vs->vs_tpg, len);
> > 
> > to the end of the function after we do the vhost_scsi_flush. This will
> > be more complicated than the current memcpy though. We will want to
> > merge the local vs_tpg and the vs->vs_tpg like:
> > 
> > for (i = 0; i < VHOST_SCSI_MAX_TARGET; i++) {
> > 	if (vs_tpg[i])
> > 		vs->vs_tpg[i] = vs_tpg[i])
> > }
> 
> I think I wrote that in reverse. We would want:
> 
> vhost_scsi_flush(vs);
> 
> if (vs->vs_tpg) {
> 	for (i = 0; i < VHOST_SCSI_MAX_TARGET; i++) {
> 		if (vs->vs_tpg[i])
> 			vs_tpg[i] = vs->vs_tpg[i])
> 	}
> }
> 
> kfree(vs->vs_tpg);
> vs->vs_tpg = vs_tpg;
> 
> or we could just allocate the vs_tpg with the vhost_scsi like:
> 
> struct vhost_scsi {
> 	....
> 
> 	struct vhost_scsi_tpg *vs_tpg[VHOST_SCSI_MAX_TARGET];
> 
> then when we loop in vhost_scsi_set/clear_endpoint set/clear the
> every vs_tpg entry.

Wanna post the patch, Mike?

-- 
MST


