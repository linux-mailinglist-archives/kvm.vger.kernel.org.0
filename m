Return-Path: <kvm+bounces-40173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 56B82A50A92
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 20:00:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED120188C32D
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 19:00:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0FA625485C;
	Wed,  5 Mar 2025 18:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="XA5liIjq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600F4253F21
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 18:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741201091; cv=none; b=fhsfiRUimPAfRvPjwTA2Mi5I+yYarzT7ubyG4/HtskGQbG7tBfcgXTZEvU4sWgMoT3zYk50aHOokYBXcDTrDSrYXMQzogQv+syEljQlrVbPW9Bt4npGP9RvOTE0AV20l+xxf87/Ep5jz0aySEQ1HMLzuoSvCznOUdF8HjK2K+WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741201091; c=relaxed/simple;
	bh=So3QeqGxndvQG0zfhtyNsbAPVpnfS2FVAH11SlRwDzk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k7Zb/t/92aLGYrS+jGCrn4OAyGgD5nCi6O+m1ISHprDhOwsY26aZAS+515dfJX1jVSWaaAvlO9UZQcc/Dk87nMzUlPv7xyjm9vv7ymC1Dsi2hawDQJLKNjv9uwq9VV9GJOrKs5+40Bdu4RSy+0CEoHKJCZCgioSjB889m08B2iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=XA5liIjq; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-474f8d2f21aso12217741cf.1
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 10:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1741201088; x=1741805888; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=h6oq+7wXRTmTKWjwxNLkl5GA1SEXaRAgRnC6RqlkiHs=;
        b=XA5liIjqVK7VMaWbQbtp+5I7jrwdgusfKipGePp80LfRjDJOqwq95t9pYxKN7Uc3XM
         GQC3+u4wLlZduV+VXfdtTF4s7AOh87Ed9QZiixpVUlEaxq2pAheSCAgEDOLMgKCnSbqT
         QHOeZkn3p72LDlreAXX+pNcdxOz6NpW+iCO0PWNYRCZqpiWHvOsaY8bwQRBB3Xj/HY1w
         +EV46LJt1PBQoxC8Pyzqv8cheYE88i9c6lY3gLSxYe+lejh4foRdZttcA6bylvwdATk+
         uX49KuiYuGPfYLUgh2f+RTALdSLX9dXoe6bbjHqrFuZYezGw67kruiwuPzvwl75w0fWt
         V85g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741201088; x=1741805888;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h6oq+7wXRTmTKWjwxNLkl5GA1SEXaRAgRnC6RqlkiHs=;
        b=dFIY4G15ycZxyRE8dagS5PvtM6d3948fwzD96jcuAzZJ7jc04c852EgA5xFTjmnegY
         Pq9fCXq+a1dRMdmmhgJUxAwotukOE2ThgQMw+GaT1DrL0MKVykMVUP5nN9x+PAqb2Ak2
         I+/GC4rFGnSJVLiLLHN2MgAwPf6ecf5NhYznF3ZKffgiJQ7LXgZfpnJrHm1ovaC6OWqy
         cVEBbgQ2JEXgudc9YatC804cftG6XP3YlB9cNKYxaAKwnsc1hnebJKYg8XTZiK6Acunp
         S26r4v2fOqkibsD4rXO5k8p8Jy0aN3GyNeqHEFKMrAJlHMQNsREa0BNU45BX+YtSdZiT
         tRng==
X-Forwarded-Encrypted: i=1; AJvYcCXndw/fRRvm6Nj0EpQTFIPbC6foPVCrKYEmR7KY4Qi7dNWkythpwT6ViXiF+JTeSgMfZEQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxeZVHQG8MOsUYdx5vD7egd7V+E4i1Mhp2RjLJih6F7SuXfBoM
	6rpi1Zxbf3/6g/BBh0MnGWZrIvrupU1HTPBtd+Ly0FufqUbBaHeTqM3fYbupQEg=
X-Gm-Gg: ASbGncvmRHTPW9t8ryr+/WHO2D3uiYbx7X0mSEDOzNdKa4ELzI39xaNjgTLxNCdZJZ2
	4Ukoaj10JsH0/m5myWT14l5qoYKO/LvPOR8PrCEexPXYHC6NavbR4BasjKu99G0XK2zy7J0hfdl
	IBOIzyyATJn3dkbDZE391jV9URT3DnWNfUdCEl3KGIaCcFfl356WFAAGiidfksKsFMfL3+n8PZH
	zf2O3Zn368aMVO+/RLY29s+ElwX0dqgK2D3NttDIq6GvgOuicayfEmdPWw+GZXu4mcFQkYMEpxB
	DB6Cig3lJbZf4BfH0ByJ+Xwh8U3silIiqkqUiK9GrmtapaQ0d9rzYB7Q8TQh/oASzK7ALmLo2Jp
	5kOgraO3/ja+QjFKmYg==
X-Google-Smtp-Source: AGHT+IGy6bVapx3hHutl1yrtO1anKKN2oBzh7Lijv3kvf5Uua6D73JGcBfxwLh93LspMyz2xcniwzw==
X-Received: by 2002:a05:622a:14d:b0:472:2d4:5036 with SMTP id d75a77b69052e-4751a4d8ca8mr6196181cf.2.1741201088197;
        Wed, 05 Mar 2025 10:58:08 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-474fe45ab8dsm26497961cf.71.2025.03.05.10.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 10:58:07 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tptwU-00000001UXo-0rac;
	Wed, 05 Mar 2025 14:58:06 -0400
Date: Wed, 5 Mar 2025 14:58:06 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	nd <nd@arm.com>, Kevin Tian <kevin.tian@intel.com>,
	Philipp Stanner <pstanner@redhat.com>,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	"open list:VFIO DRIVER" <kvm@vger.kernel.org>,
	Dhruv Tripathi <Dhruv.Tripathi@arm.com>,
	Honnappa Nagarahalli <Honnappa.Nagarahalli@arm.com>,
	Jeremy Linton <Jeremy.Linton@arm.com>
Subject: Re: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Message-ID: <20250305185806.GB354403@ziepe.ca>
References: <20250221224638.1836909-1-wathsala.vithanage@arm.com>
 <20250304141447.GY5011@ziepe.ca>
 <PAWPR08MB89093BBC1C7F725873921FB79FC82@PAWPR08MB8909.eurprd08.prod.outlook.com>
 <20250304182421.05b6a12f.alex.williamson@redhat.com>
 <PAWPR08MB89095339DEAC58C405A0CF8F9FCB2@PAWPR08MB8909.eurprd08.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PAWPR08MB89095339DEAC58C405A0CF8F9FCB2@PAWPR08MB8909.eurprd08.prod.outlook.com>

On Wed, Mar 05, 2025 at 06:11:22AM +0000, Wathsala Wathawana Vithanage wrote:

> By not enabling TPH in device-specific mode, hypervisors can ensure that
> setting an ST in a device-specific location (like queue contexts) will have no
> effect. VMs should also not be allowed to enable TPH. 

So many workloads run inside VMs now for security reasons that is not
a reasonable approach.

> I believe this could
> be enforced by trapping (causing VM exits) on MSI-X/ST table writes. 

Yes, I think this was always part of the plan for virtualization when
using a MSI-X table.

> Having said that, regardless of this proposal or the availability of kernel
> TPH support, a VFIO driver could enable TPH and set an arbitrary ST on the
> MSI-X/ST table or a device-specific location on supported platforms. If the
> driver doesn't have a list of valid STs, it can enumerate 8- or 16-bit STs and
> measure access latencies to determine valid ones.

And you think it is absolutely true that no TPH value can cause a
platform malfunction or security failure?

Jason

