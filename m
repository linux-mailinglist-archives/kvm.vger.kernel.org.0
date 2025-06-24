Return-Path: <kvm+bounces-50530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 87A52AE6E79
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 20:17:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 326A518882AA
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 18:16:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FE5E2E762C;
	Tue, 24 Jun 2025 18:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Hob0j6YN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54980233145
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 18:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750788982; cv=none; b=cv6ykRULOlF+BzYNDa52uH8c4qamLfgZF5ukKQ0ICThAIBWMDhoHPvwkc8l1RcsKITszCSopOkJ6Hhf8YMlrWIZGN+973orViopPBLu9aJfhIrRj+KXLK4xPJovSGxsRezEAm3/1Fa3XetWYsgGrhmdQwAlT9zHGAeb2126ZytM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750788982; c=relaxed/simple;
	bh=DA/D38PB76BVpZicl9d8McqLird9x5AUMZVDHvIa5Z4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iylQw/oZn/g/EgoXRdYcPYsVb//BKBNmlTYnDt4XBBKtbpbNZM49QhbKdV0IOmNsZO2EXZI27KvB2zZ3JXEa5Oj4M1eCmsaOfzUQFQxZB81MF8z1wzfNrU2SXMZADG659PCjLpn35SDVbTQH2X9nJDNUjvMRsAVHx1xVuJjXTbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Hob0j6YN; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4a752944794so8055401cf.3
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 11:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1750788977; x=1751393777; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RUtJ9tEA29eCjDyOeDq5s8JDWFGttISewMfomLtSMxY=;
        b=Hob0j6YN0h3KLU+6VmkZ6QuH8xtxGbZHNOWQaJa3pCHZdbZM21YX27pnysdRMpNOpb
         UzMHboljgSpQXKNI4Tg7NfqQTfiluCQzro4N/OVMRYzHWKPXCT20EjfBCws68pjDB7FL
         OC/xAiIoN3sEpbxczwx6FugEYJ9eAdcL9e1SUjQHW8P55NlkZ5PrFZKt8vmyRtPsMquh
         cW7L6EbnWkPS4KgC0E8HMZL3s9mWjQ59iUANMR8zMzUjdLplnsEMxca1400FfA4sj51p
         jWgOlSz9ThUQbZsMdhESayRiq3RFbc101exJ98nAzAzkYQvkp49AJtgAQYcZyrvy63jQ
         RZeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750788977; x=1751393777;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RUtJ9tEA29eCjDyOeDq5s8JDWFGttISewMfomLtSMxY=;
        b=sECYBNpO9nAv26K4HVNM9oy9JUYl86m2vHsumaaoBFvqcvB6lWLt4C6sWFD3/6xWm0
         vPqAP35LUVgeho0IziDEkmQoHSfMpkJRmzG7+ViV4S5J4FXZPb1jsBuZxmGLTxd/ee3X
         aSQPCRnBLokhdjqPY74nFWKT62ZWAgh0gy41UMVZhchiSsNMUsYy9rDLnGO9eoUtUlhy
         LNKB9aNlt+5KshHr3U8ijxIaeAHowI1vl7+T8cQa2/9q59j3iw4e9lPPuxAAmaTKZE8Q
         6iuA+s+zM80d98re7KEne0MkT9Goolh4NrSwvnGPrnHxMkSa2zY4OmErAaY+P2AruoFo
         i6ZA==
X-Forwarded-Encrypted: i=1; AJvYcCUtxcSyU1luhZOU7JcDfksMvLAqsgyuDkBYFdORB+DiLO8rEBIG6Cg0Bz37L0oqyAsXmUI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyE6yNXaANf0Em8aiYgjHkE3ZMKUVoJWpDYH76FGF9zVinUcoLB
	ZHwzPym37M0kV5Yzv80nON0kR53LnS8gKtZueVRUXcZpESALIloKtclI0nQ5XKaBjh0=
X-Gm-Gg: ASbGnctJ8pTwyYQoymN8sdFe9+9vpEaKW48pZgOa5j/v5Jl1SBzdp73rmgOU1hsS35U
	nAnSGJLhB2VBDSw+kbYhNyLN3v7nn8jUZGla4kbSF/kY5IwBhjfoy6KXS1mR/GbALpFjpzf/Bz8
	1bwePZ42/QgAlMkWDAauyGujFG91vNIYhD3EDQl0iV6goXrOFzb3yA3ntYG+7GdRd3BFh6ngnva
	MmsnTii+AwQhb281wvP0pEEooe9Ma9ej1E6fXz/Bpf57KWshMjSJNoEg9BTZHhHwDnN2+N4H9VX
	V9FV19icwZ6EOXd0l+M5E2SEiBfNf0ATsG5strMmc42GwLU320G06kqQn/K3mk+oqMaqMxIyChK
	H+fshgQbJmj1oPG9ydBJAcV/gcxvH1XbCKd8Wfg==
X-Google-Smtp-Source: AGHT+IF6I3w46MYeQWneTxqWC3YDA/b4GfvnKogo4xGCeiX5WBI7oCdnuJ/jwqVwtuKe0ddn/P8YxQ==
X-Received: by 2002:ac8:57c1:0:b0:494:a30b:e27c with SMTP id d75a77b69052e-4a7c080060amr5144121cf.39.1750788977151;
        Tue, 24 Jun 2025 11:16:17 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a779e5d2b3sm53372151cf.43.2025.06.24.11.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 11:16:16 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uU8Bs-00000000hCY-0nqw;
	Tue, 24 Jun 2025 15:16:16 -0300
Date: Tue, 24 Jun 2025 15:16:16 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, peterx@redhat.com,
	kbusch@kernel.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: print vfio-device name to fdinfo
Message-ID: <20250624181616.GE72557@ziepe.ca>
References: <20250624005605.GA72557@ziepe.ca>
 <20250624163559.2984626-1-amastro@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250624163559.2984626-1-amastro@fb.com>

On Tue, Jun 24, 2025 at 09:35:58AM -0700, Alex Mastro wrote:

> > The userspace can deduce more information, like the actual PCI BDF, by
> > mapping the name through sysfs.
> 
> In the vfio cdev case, <pci sysfs path>/vfio-dev/X tells you the
> /dev/vfio/devices/X mapping, but is there a straightforward way to map in the
> opposite direction?

There will be a symlink under /sys/class/vfio-xx/XX pointing to the
<pci sysfs path>/vfio-dev/X directory

And another symlink under /sys/dev/char/XX:XX doing the same.

Jason

