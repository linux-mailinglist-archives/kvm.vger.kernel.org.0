Return-Path: <kvm+bounces-62138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 405E7C38726
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 01:14:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 098914E5CB7
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 00:14:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF44222339;
	Thu,  6 Nov 2025 00:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A2yuCWaL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FDFCA52
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 00:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762388072; cv=none; b=emWYP4XG5813T+OZoJsVnUen1zV/8pN0LN5hJP/1tkatm0MkSQPTQhnZSrLsKbkfrayK8q91Xa4Vmcs3Hagj9RywzYjzhC2EicsqqJlsDmjr6fiP1sElkn29mM6+CWTF4JNJAHFNyoBivSGdpxE+lSyAW6kRi5sl1uZ9La97wg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762388072; c=relaxed/simple;
	bh=DRK2N3r5v5psexKnqVX1ubSmtmNxRf2HQUDtM5cF6rU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jkpuHma5BW32ru0bWMaOm/0BodnKypRtO981V2Ko+DGeswo73wW/eFwgvBDJfD+YfNaxOtWjUzDUy5TaIpuFIw59DIogZCNkK2pXkG4iL//Kw2VQZhXnhMMEg+h+PaiZ/sDFqeXphucfqM42/FacLu0cFkNrr3EHcMln9Bn12Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A2yuCWaL; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-294fc62d7f4so3858945ad.2
        for <kvm@vger.kernel.org>; Wed, 05 Nov 2025 16:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762388070; x=1762992870; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o1lmaO09oZEmTOr5ZOwlTY8KRXuoWLlblnQmg9l/mdo=;
        b=A2yuCWaLGT+mJ11SPGs1Eg7aR2TUxELwwt2PvnUSKbRIe3U37FE4dEwnEIc0cHWcVx
         z2u3CptmGHKW/gmAnYzEREBnEeVZd+twSu54I24KbV7+HndlTxOl3bOmLJOBIFdR4OBQ
         FkXr0w9svIdd/E6xp3phAx5PaUchLilYyp4Iez2mLs9LUdIG7op8UWprEdwDCWfG92a2
         J1TDlmPII/BDdvzVYtNW7c8VwkCB6/Ft0vWwo4PMeFiZSVr9yHQh+Plzk8oab3a7J5xt
         N275LHhC9S7jlVhsXbHCb8A32rLxb1Sa479hjMwVkBiBkVrK9JwgB30/rMppjAz3daue
         skCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762388070; x=1762992870;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o1lmaO09oZEmTOr5ZOwlTY8KRXuoWLlblnQmg9l/mdo=;
        b=P4ZVfQYUz3/PLzGVZxEop21TcmwYvImD3gI10bB8u11QyjeshReukeRq4JafQwJfJO
         fzOCEPXLI5rggsiTyPniwOs101Gpg+MLRZdhvahCTw9+I6PqxIdtLQdmjn5AbQDUTC+j
         iDCfcpYLXOoNRyGyExMwz4uhDKML8WMJB1etb3OcgqRTADfyJCpNti3FSfJsdS7PQix5
         SuwmcTF2VDwDMKvDHCkm6V5v2/hR42AkeltOltcp17xfYDqARzmjysYYIMcfmBLeRXve
         Ll1rzVomS/V0CJcBZA0ICqhlITye1FAzY4igBkEQuk7zFtE2hxbUAyJySUbAHQK8Asfa
         o9tQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMurUNJqF11m27gpAZ2sjm4/ZdU5/P+aAANhzqRZyGVhF8rjZYBsowmMjsZBR0oTK8Oqk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKCZXt041gFmgeDcjaUrLEcklbdlVDdzeiZhuBf1XhJ1Plb+Og
	kT40LaWycnSJW8uaacSC9ypJ58qo8n4h9bJG6FGPPStYNV/ZT02vRK2RuAjW7uarOw==
X-Gm-Gg: ASbGncvLj53DecT9NoRvgaVSNZRBKoEUVMd0NmfFogX6wsBCuR6/rRa0zZV0BPzfB8D
	gytT8lvzYI4H8ZxkKNewT+YePv8+bATIZ6jAGXToqaUfJljJaXxD0mfoUJjqcl9Sy00nlEEeDEC
	CpsLruGhncXSry7S6eNn9SaHQwsuqvCPKkUsSCYQt6QC5Z6PwdCUfQIXmDgzD41tPq7fZRx35o3
	5ICjZeJexuf68HXqusA7Hnwy+sr4RC/Fsr6oBV5RFcfxUbJu2W5A/oT63mTcDXeuobhgdyfVsp8
	aXuvHAgloM0SO7/jrOQpNWWO4Rs7IbL2YN9YVZLEimfu3gjzpFBeSioBLf4aT4rrVG9bXMBC6bv
	D0Doccj39qCPKznur3VnZsP251Iu8nyJi44xyjlfq99yFwpwbSZAOggOPPXb2e36TVHJdglvCZq
	HjMEwEmktrs3R78c2c+kTMa6GixavJu7KDnj+4E1SFimzvDrZ1OskQ
X-Google-Smtp-Source: AGHT+IEMBf1dyDG7MeT/9tZx6yKxyh7B8WhX3lv3XCw4idBVSajUZtQi9QVePs38w4HQOSSQTKRJsA==
X-Received: by 2002:a17:902:e84e:b0:295:e9af:8e4f with SMTP id d9443c01a7336-2962ae97813mr77569345ad.52.1762388069620;
        Wed, 05 Nov 2025 16:14:29 -0800 (PST)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29651cce763sm7101515ad.103.2025.11.05.16.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 16:14:28 -0800 (PST)
Date: Thu, 6 Nov 2025 00:14:24 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] vfio: selftests: Add support for passing vf_token in
 device init
Message-ID: <aQvoYE7LPQp1uNEA@google.com>
References: <20251104003536.3601931-1-rananta@google.com>
 <20251104003536.3601931-2-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104003536.3601931-2-rananta@google.com>

On 2025-11-04 12:35 AM, Raghavendra Rao Ananta wrote:

> diff --git a/tools/testing/selftests/vfio/lib/libvfio.mk b/tools/testing/selftests/vfio/lib/libvfio.mk
> index 5d11c3a89a28e..2dc85c41ffb4b 100644
> --- a/tools/testing/selftests/vfio/lib/libvfio.mk
> +++ b/tools/testing/selftests/vfio/lib/libvfio.mk
> @@ -18,7 +18,9 @@ $(shell mkdir -p $(LIBVFIO_O_DIRS))
>  
>  CFLAGS += -I$(VFIO_DIR)/lib/include
>  
> +LDLIBS += -luuid

I wonder if we really need this dependency. VFIO and IOMMUFD just expect
a 16 byte character array. That is easy enough to represent. The other
part we use is uuid_parse(), but I don't know if selftests need to do
that validation. We can let VFIO and IOMMUFD validate the UUID as they
see fit and return an error if they aren't happy with it. i.e. We do not
need to duplicate validation in the test.

