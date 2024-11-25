Return-Path: <kvm+bounces-32456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 89F779D8A4F
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 17:29:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B4B10B63DF3
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 15:08:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 787901B6CE8;
	Mon, 25 Nov 2024 15:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="TAQJ2x1b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32C31B4F29
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 15:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732547252; cv=none; b=pgzqnyASRLjWten3O4dHYH0xxjY+Guoz5Dlj/J2xg0R5Ka1N/Zpws+aqGWbQvxDF9h98xMV1LnixlDXNUAZV44UuLrQfP5eaJvK4YI01cjL9pAEnvjXqHMoJLksX/nerSsrH5DEMfidzj1uNaCLS8X2ef+N8MuRA4jL9eMBoRaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732547252; c=relaxed/simple;
	bh=Q4aBnJqFOt15Ux30my9yAGcWPJu0Cl3Tq+l8YJKlqtc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s6GsE/ze8/RwX1t19cvQtmtbIiNMMfGsQ6JGYpwS6cAwVPFQcW3kVYC8Zyb6K25boi6KGzdGJqpgUFEZIcP5gGnEbySRIpDImeHr/BVml2Rw98xiR7DQweTULWyX2H+x5hYrlgam5Rdtj/uhqf9JqFFTZGPErU5FSgknUnG3sdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=TAQJ2x1b; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7b6600c9338so126441285a.0
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 07:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1732547249; x=1733152049; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=twGWU6mtjTufZth/+pvf0jPNX0dQZ+T26QxysrcZJis=;
        b=TAQJ2x1bUDlNyQvWYOltLsFkP4fKwVwL8WlR7J2U5zO+OXmQ5iD2iPT0IH6OByMedq
         qZZPodjgIlOJS5Znuk+EhW5EdowLyB3xXrEquFcDXQKxA47azLookg2/8pmYLLzMMIWg
         +jzCbi1ZX2Mb+LOgRvckvNsZi3R0G5S5qiw+ozAP5NHe4jT+VN+3e7TsRux3BhnzV5CW
         XcLhl9bAks3A5y1VUMncKSE6+++9dYtbJ+OiA38ZkKao+9TVFNuXn5WM9IfiqrWHnlAt
         A4rUk4nULrgjeu7/vDM+nP1e1vBG/LdS4DMynOFVZAkn3YciatYMroz5fK490g4YlaX+
         15sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732547249; x=1733152049;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=twGWU6mtjTufZth/+pvf0jPNX0dQZ+T26QxysrcZJis=;
        b=BOg4Zr7kOYYZTEMSYyeC2SJWLxJoCH4GoNjjv3wq90HicaOO3y9g6ywXMFrV8VAY+w
         phKtyGFd83U/NO04Nz3pgrTKloG5WLUb+0/eZ0lEV7fDoRgkJPBKTwOLjZz1gqDavcRh
         Uo7VEHBKcKQ90dYdXgLpRIqxf0VpGWP1lNowuMVl5eFtSC78gqfuK/jkWFJfe8dnxAcj
         tAR9ez7Zmkedxa7tE2UnsQuSlxbz8jNESdqagYovoEIA/SwaQY7Kb77VMG14K8tJYXN8
         jAdJH6QbP5Roz/b4SpsmUEQ/aGX7calLdFwTzQI1UunvTaqprd6UeRBZR4CRwXohwEJ1
         Rm7A==
X-Forwarded-Encrypted: i=1; AJvYcCWs4FjIRCOnGKGXWQ1fZCL9d0eoIKCvshfF+ajZR+pAgc7NCsJ9N9cUROY+wEr9L9W6GOo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRE5oSPMCuQBGESvQbu/xZu+q/A8G8Uu24qep2M/4OFJ5s0lzi
	xXRlQ8wvPLkMJz0Kgp4xwBrn7OaTKZVKRLCDT1PaE/db/7phRmm1fl063nCaLtk=
X-Gm-Gg: ASbGnctfHAhBRzir8QbAcbw1Dq01ZBwPG41O/jwMppZUCU9iEJkzkAnidJg6i/mOT5T
	Sxtt++1cATN3N5a7vF/s1R6h/Qe7aaONmXQZj1zlB+buv+9cZqchEJ9YQ2pNYfglQqvjdeCwMD9
	Bz70cyZNDnW3tXxkxRU2ZxVdmEFhQK+mhRJ7VYAHBQfCGUE80BAmMS/U/08I5Y9a7UR1iLthJ0N
	+G6e6IZJ5NTGo01CTjtkuaLe+5i1tixbTMGnBmualozUozebyRoUUkeaJHko8j70/P0LyzDm9zI
	gVURiraLi207X3Z87Zi1LDg=
X-Google-Smtp-Source: AGHT+IFwf0rZmHcROgKHTVBJNGS81A60fdkLkHL/TjOd3GPuY+6MrtSu7XfH3JVuUswHCoYHME7qRA==
X-Received: by 2002:a05:620a:29c9:b0:7b6:6bd7:7adb with SMTP id af79cd13be357-7b66bd77cd2mr503418185a.23.1732547249439;
        Mon, 25 Nov 2024 07:07:29 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b66c8d41d8sm99837985a.95.2024.11.25.07.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2024 07:07:28 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tFagR-00000004zCr-3o1V;
	Mon, 25 Nov 2024 11:07:27 -0400
Date: Mon, 25 Nov 2024 11:07:27 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: iommu@lists.linux.dev, kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, tjeznach@rivosinc.com,
	zong.li@sifive.com, joro@8bytes.org, will@kernel.org,
	robin.murphy@arm.com, anup@brainfault.org, atishp@atishpatra.org,
	tglx@linutronix.de, alex.williamson@redhat.com,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu
Subject: Re: [RFC PATCH 08/15] iommu/riscv: Add IRQ domain for interrupt
 remapping
Message-ID: <20241125150727.GD773835@ziepe.ca>
References: <20241114161845.502027-17-ajones@ventanamicro.com>
 <20241114161845.502027-25-ajones@ventanamicro.com>
 <20241118184336.GB559636@ziepe.ca>
 <20241119-62ff49fc1eedba051838dba2@orel>
 <20241119140047.GC559636@ziepe.ca>
 <DE13E1DF-7C68-461D-ADCD-8141B1ACEA5E@ventanamicro.com>
 <20241119153622.GD559636@ziepe.ca>
 <20241121-4e637c492d554280dec3b077@orel>
 <20241122153340.GC773835@ziepe.ca>
 <20241122-8c00551e2383787346c5249f@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241122-8c00551e2383787346c5249f@orel>

On Fri, Nov 22, 2024 at 06:07:59PM +0100, Andrew Jones wrote:

> > What you are trying to do is not supported by the software stack right
> > now. You need to make much bigger, more intrusive changes, if you
> > really want to make interrupt remapping dynamic.
> >
> 
> Let the fun begin. I'll look into this more. It also looks like I need to
> collect some test cases to ensure I can support all use cases with
> whatever I propose next. Pointers for those would be welcome.

Sorry, I don't really have anything.. But iommufd allows changing the
translation at will and we expect this to happen in normal VMM
scenarios. So blocking, paging, nesting are all expected to be
dynamically selectable and non-disruptive to interrupts.

So, you can't decide if remapping is enabled or not for a device based
only on the domain attachment.

I think you'd need to create a way for VFIO to request dynamic
interrupt remapping be enabled for the device very, very early in it's
process and that would remain fixed while VFIO is using the device.

The dynamic state of interrupt remapping would constrain what iommu
attachment configurations are permitted.

Jason

