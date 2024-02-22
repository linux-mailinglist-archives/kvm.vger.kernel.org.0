Return-Path: <kvm+bounces-9437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 208C986035D
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 20:57:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6DF80B33717
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 19:24:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62ECB6AF8C;
	Thu, 22 Feb 2024 19:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ax2O9Gv8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080E614B822
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 19:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708629829; cv=none; b=S6PuZFd9xB4wHWzxIore89L1INkzbUX8pDGSJUXxO/Gv8LlZ/TiSwnpxYjJFnln6XVYHlVp71oIjD1CXt6qvjLwMfaF8tHhoJ/xyKJm5bPKLPkMGMT3WQWKa6sCb9JCOOAmnJUVQKV4iKxL+9kxbkp5LQoRaZrPwrZ8IS+9ifhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708629829; c=relaxed/simple;
	bh=cq3Cnk+GZrsQGPtsY4OcFojjqqyL9ctq/cxxaE9pID4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WmjDWp1PI8/L6++hgVlZ/t7a7jlJXoi8UhuvIp9oYhvg3qm7qC3YUQqHFocdCfeceWYaSqWcPQ85UFjv3vdltZ0vulp1sAnzb4ASAs0Dh2Upml0wyxGoIlSj4osXs0CBJi280/pX2vpG/g25mrUDQQiO7ytr+e9W+NIpuQKTiL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ax2O9Gv8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708629826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nZ+RDIdGnhU5lg6jFGeCqCjJlhqa8k7CnALV244t9Yw=;
	b=ax2O9Gv8ewMecneBzmkgEiLxhHpTlB1RKlkQ0fyhJ0NWCgHSMGO7PvYACFeqhHseMxsqqD
	nyshrknh6I7RdYLs4GvwZxiY8wLwIicqVrToSUKO/C6LhdNNZbYmS1TVC2tsTRiUcG8ZmE
	bS0wlxgWrcOcn8xbbq0C5NxdvXEZ9tE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-OzWB9fF1NZSgWoi2gYzMmQ-1; Thu, 22 Feb 2024 14:23:45 -0500
X-MC-Unique: OzWB9fF1NZSgWoi2gYzMmQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-411ac839dc5so317225e9.2
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 11:23:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708629824; x=1709234624;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nZ+RDIdGnhU5lg6jFGeCqCjJlhqa8k7CnALV244t9Yw=;
        b=KHvJlAotH7zLZnKA9B/wM2kWYz6GyDKrW85k//cMD01P8T4BGqJgHmdWXATa8H/zCI
         XUVLaWIbSP+Ef2TrlDk6e5gOibWQzBxOTxc5GQkedPxEkoMzSzN06i1XfKJXY0F6gkM7
         8KesvxevWr4ngnKTHKzTI2AEzNAyPDP4sPN7ANftpch+IaYLSSH4x5Rw2XeC2r46kELN
         j3BYOWSiLXHFSs+sA423GdsT0Ga6uYSUlRtQDRIJdJAL+Ag1hoCTbsTQ9F7dM9yfeTKd
         hYC5eUFk9yXAwUPCMlrul4XmgQDH5AImz5kcZ86OJjvfi4aOr19FKJTWjrYt0VaTkvTX
         bVNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbTbt7UAsG32EyWZ8sEbcfYqErG3prOWfX4K51Cx0JcSeBWUaeyLF3O2dlNrtbsUtgbHaxNTTggK7jZc+8r1MSJKd+
X-Gm-Message-State: AOJu0Yz1NtMObNyv2YExyKgP+H/993EOjFCmB+fe+p4b458qwdt9c8Cc
	l3gUzbRp+53Kc1f5iYob3Jw++KbJ091nctYTyNrtn2+tX02tRr2CjSW+LD+2Jnjf9VFeyanKxMN
	+qZJu2+PoI1hwp+Gc7nft4s8Qio5auBP56r5CHj+A9JKb07J3sg==
X-Received: by 2002:a05:600c:4c99:b0:40e:a569:3555 with SMTP id g25-20020a05600c4c9900b0040ea5693555mr18945737wmp.35.1708629824330;
        Thu, 22 Feb 2024 11:23:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHRkfAP3Yd4xKF6bdlzBebTP+hY1tBDnghJRdAmvC+uFZRuB+6mlbezFnXDMpRlAhkJUEHJUQ==
X-Received: by 2002:a05:600c:4c99:b0:40e:a569:3555 with SMTP id g25-20020a05600c4c9900b0040ea5693555mr18945722wmp.35.1708629824024;
        Thu, 22 Feb 2024 11:23:44 -0800 (PST)
Received: from redhat.com ([172.93.237.99])
        by smtp.gmail.com with ESMTPSA id g16-20020a05600c311000b004127942bcd6sm5410408wmo.7.2024.02.22.11.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Feb 2024 11:23:43 -0800 (PST)
Date: Thu, 22 Feb 2024 14:23:36 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tobias Huschle <huschle@linux.ibm.com>
Cc: Jason Wang <jasowang@redhat.com>, Abel Wu <wuyun.abel@bytedance.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: Re: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6
 sched/fair: Add lag based placement)
Message-ID: <20240222142254-mutt-send-email-mst@kernel.org>
References: <42870.123121305373200110@us-mta-641.us.mimecast.lan>
 <20231213061719-mutt-send-email-mst@kernel.org>
 <25485.123121307454100283@us-mta-18.us.mimecast.lan>
 <20231213094854-mutt-send-email-mst@kernel.org>
 <20231214021328-mutt-send-email-mst@kernel.org>
 <92916.124010808133201076@us-mta-622.us.mimecast.lan>
 <20240121134311-mutt-send-email-mst@kernel.org>
 <07974.124020102385100135@us-mta-501.us.mimecast.lan>
 <20240201030341-mutt-send-email-mst@kernel.org>
 <89460.124020106474400877@us-mta-475.us.mimecast.lan>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89460.124020106474400877@us-mta-475.us.mimecast.lan>

On Thu, Feb 01, 2024 at 12:47:39PM +0100, Tobias Huschle wrote:
> I'll do some more testing with the cond_resched->schedule fix, check the
> cgroup thing and wait for Peter then.
> Will get back if any of the above yields some results.

As I predicted, if you want attention from sched guys you need to
send a patch in their area.

-- 
MST


