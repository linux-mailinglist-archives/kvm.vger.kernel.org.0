Return-Path: <kvm+bounces-19853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 52AFF90C9A9
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 13:35:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A5C91C223E0
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 11:35:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3551516DC1F;
	Tue, 18 Jun 2024 10:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T9RiuzsJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D2415278F
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 10:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718707172; cv=none; b=Ymwp1hsoBLNjh39P+qrbBSF/bI3hOoGu/Wbiex2FqywH5YLmvpDPPwgKioD7/eQjfW0iBMV1jn4AVJGUtG6HG9BYKvT8tALeKM3+VghyBIXDsfhWccy7XIeoD+B7x9F73+rim6xaH3QcRTVhNxxMWmcdLH0ZqYcUKjivf4HslJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718707172; c=relaxed/simple;
	bh=dFrRBkJl7R9hxvgTFXcfhz/5bf+uuLP1erp6wT8mbB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MaBiT3ZIcWY4EZgOUKNY5FWmz/KWU1NeDqr7+6dGX3MO+8OkwsVdrCu2hjWG9Fs/PpZVzpYWJxD3XaWhrLj9oHHd5MhLq7rszIjYzmvBMxYKJm3do5ppB+5BCZ0Bme2j4YXg0j7EZ8Xx8sSpNbIOHfIuVZ93Eg80F5IitiNBQRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T9RiuzsJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718707169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hUpnx4iA/H5rFTjd+Mex3wPRNbIj26vNn+VnYBxGz0o=;
	b=T9RiuzsJvbru3HMtYBNIqxK5tPq7An01B8nF0EWX0YJntRoYUNy/DT90zDxTe/Q5gmZSFS
	4t+MlVbAdEllh9/t6QSER5yW3X/r6xbym/v9aUiC6h+0wmPkcUW6b/IdF8bJrliWg17OKB
	0mJBwVO4LLtZpxqek9StKkFnOaxOD4c=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-ljqwV_kmP3OBcZwtx0i7lQ-1; Tue, 18 Jun 2024 06:39:28 -0400
X-MC-Unique: ljqwV_kmP3OBcZwtx0i7lQ-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-52c7cff3b89so1480962e87.0
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 03:39:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718707167; x=1719311967;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hUpnx4iA/H5rFTjd+Mex3wPRNbIj26vNn+VnYBxGz0o=;
        b=CmnUUhK+DBGLKf2+oXoqcudp+dih09wHQYH4bA1WcznpWHSHZsl3tSmu1ylx2sz+8t
         gao53I89G/+pDZYt41hf2DlF2EuTi1dtDve/XfXskLg26iBffi+mxLEWIw88FCKwKxfR
         KQk95II4opZBgVZMjGZ1+EK9jsrMyOw/4pgeGqwSifuHwLWPo+JDEPER/vNzMaaYNaFt
         gtga1oVb6u8gqcoFN0PoqW7kKEtwJO0k9BInnoR4Do3xhSE+LzsANztsYXo0wTt6SO3B
         Lejr4+UR3PnoPN4UGWTO4C1pqc2SfkxJeICMZQZ0mwJh3+iaes13uHnbk8gq3pAof6nl
         jICg==
X-Forwarded-Encrypted: i=1; AJvYcCVhIMhZ0eu6a8Chxz2LvLeYSQRCpaoh4UB109GyQoOcsC/us8OW4u+WoqhPrBzSlavLv322a5ljcG+TLj5Qd/EPGx1d
X-Gm-Message-State: AOJu0Yxn8ao1hkDExARmr8WzYph50Liu421JQKHeYJaGlhyryMraYw4I
	5HMHLuroFnWRtLY+SHwLZQLsD4XzcJRo6sSep4ZQaMgSHl6WANg/dKf7sFkGCa5PuVR1gqzGD65
	NoXd1Cs5d7EKVV8hjeTr/9pvkmHcwFz5wi5FWfXyoQ1e+t+NZ3g==
X-Received: by 2002:a05:6512:10c9:b0:52c:b5ab:b6cf with SMTP id 2adb3069b0e04-52cb5abb7e6mr5463292e87.45.1718707166754;
        Tue, 18 Jun 2024 03:39:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFze+XHONw1pKhSFRlONo3MnV+d+IuBKNx7zowmQrnW5HIibz+c67gR1XvzUPSIqN7ibLJNTw==
X-Received: by 2002:a05:6512:10c9:b0:52c:b5ab:b6cf with SMTP id 2adb3069b0e04-52cb5abb7e6mr5463273e87.45.1718707166240;
        Tue, 18 Jun 2024 03:39:26 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc7:441:67bf:ebbb:9f62:dc29:2bdc])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42286eef9c1sm222635295e9.7.2024.06.18.03.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 03:39:25 -0700 (PDT)
Date: Tue, 18 Jun 2024 06:39:21 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Jiri Pirko <jiri@resnulli.us>, Parav Pandit <parav@nvidia.com>,
	Jason Wang <jasowang@redhat.com>, Cindy Lu <lulu@redhat.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	"virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/2] vdpa: support set mac address from vdpa tool
Message-ID: <20240618063613-mutt-send-email-mst@kernel.org>
References: <PH0PR12MB5481BAABF5C43F9500D2852CDCCD2@PH0PR12MB5481.namprd12.prod.outlook.com>
 <ZnAETXPWG2BvyqSc@nanopsycho.orion>
 <PH0PR12MB5481F6F62D8E47FB6DFAD206DCCD2@PH0PR12MB5481.namprd12.prod.outlook.com>
 <ZnAgefA1ge11bbFp@nanopsycho.orion>
 <PH0PR12MB548116966222E720D831AA4CDCCD2@PH0PR12MB5481.namprd12.prod.outlook.com>
 <ZnAz8xchRroVOyCY@nanopsycho.orion>
 <20240617094314-mutt-send-email-mst@kernel.org>
 <20240617082002.3daaf9d4@kernel.org>
 <20240617121929-mutt-send-email-mst@kernel.org>
 <20240617094421.4ae387d7@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240617094421.4ae387d7@kernel.org>

On Mon, Jun 17, 2024 at 09:44:21AM -0700, Jakub Kicinski wrote:
> On Mon, 17 Jun 2024 12:20:19 -0400 Michael S. Tsirkin wrote:
> > > But the virtio spec doesn't allow setting the MAC...
> > > I'm probably just lost in the conversation but there's hypervisor side
> > > and there is user/VM side, each of them already has an interface to set
> > > the MAC. The MAC doesn't matter, but I want to make sure my mental model
> > > matches reality in case we start duplicating too much..  
> > 
> > An obvious part of provisioning is specifying the config space
> > of the device.
> 
> Agreed, that part is obvious.
> Please go ahead, I don't really care and you clearly don't have time
> to explain.

Thanks!
Just in case Cindy who is working on it is also confused,
here is what I meant:

- an interface to provision a device, including its config
  space, makes sense to me
- default mac address is part of config space, and would thus be covered
- note how this is different from ability to tweak the mac of an existing
  device


-- 
MST


