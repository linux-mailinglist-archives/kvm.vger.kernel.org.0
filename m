Return-Path: <kvm+bounces-58158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 89171B8A740
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 17:58:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A755C7A90E4
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 15:56:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 186DF31E0FB;
	Fri, 19 Sep 2025 15:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bgYk9M9j"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C492F31A55C
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758297473; cv=none; b=XebjEu5dGCTwTzBqce7xlTT35DI4QISi7xegUNsKZKOyLhcuyPvQbTLg/tvatMJ68CmPJyA5K2satYai+s0+0AlEricWOv2r/dvsLi3bsILXrnVwjJmFxO6Kll2ce4wsMw4DOAhF1vYt/7d5ifmBGrdm6kif9rt4Fh/Tx11oGUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758297473; c=relaxed/simple;
	bh=jcgRaanW9qH9mr+Sv4w77DNE6nNUSLNEVq5bL0EhAq0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tc939oeEYYJ+cESUU+HUGfYtqbJqMYglm1Lo/ypPcVPHsz9Ps0AHMG8LKnbZw3xZ+HkRjQAQRIk6YDQoujaA+epPFaYxjalmLabgEMcen+oAtvWQ01ToXlHpV2J6htNQYnopVXFedIMj8BRZguy1CJAqNzRh06rtadymoLgIJt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bgYk9M9j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758297470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aM1my6NJjtlki0BZEqbhHHnBmfD25BQlwJZ8Tn+vp3c=;
	b=bgYk9M9jCwH1OYireHeYOLy07C7Y624+Gdw9bETendXzEEwzQ4ScTb0eW43lFx7IOJ/KLV
	wgtP2nmyD7x5R7tC8bRLPTMl423PZsou+9J9MpNmZACBuDgEwISwEtCVZCPHziT5lOpSSs
	kJJvYqVW1WnNVkOr/Y/rSizYcGSGL2E=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-5-vyGk4XS2OSStYqcsIQKh1w-1; Fri, 19 Sep 2025 11:57:49 -0400
X-MC-Unique: vyGk4XS2OSStYqcsIQKh1w-1
X-Mimecast-MFC-AGG-ID: vyGk4XS2OSStYqcsIQKh1w_1758297469
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-4247de28df5so4323505ab.2
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 08:57:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758297469; x=1758902269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aM1my6NJjtlki0BZEqbhHHnBmfD25BQlwJZ8Tn+vp3c=;
        b=QagJakvscYnw30dSy40a1c11sX+ohb8KMJ9p1BuLeN9qwKcqhrRkUahEb81qfyvVxy
         RQ5pybEshmtZ51Ivg5fPxPKPL4zafFPioVByRPzKlrHiR7+orM8Atqbjx+RqqfhcAnJu
         x70tYeZAQntsGwvrcaRiWTVG0pfnB2r1EeschexRlGjFa947A9QjHpHoKRbUDQo4ni7o
         JUdgT4NH/VZPaHk5ybXomnYRo6Rlfy0kpLNACQld6Y2d/hXNDy0koTWbqu+iSR+0BoBZ
         dIqv0V+1oAz2zL74+ExsYqe4k3EZdOSgl9IPUlGGC2h+Wn6+rHZW/5mFLUVHR8YuDxlq
         NkXA==
X-Forwarded-Encrypted: i=1; AJvYcCVQG4Jv/4F0J71fskRRESa2hkcOgueMuaMrGUUHKU9NKQkt8mMv7H+OQARss8vWm6gOIXA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKOfUN3L5SD+bP1mjd4/4GbhayyFZpncv1+6VhBhQK62pIbgtb
	djacWlHfk+K7TmwYrWX8AZGIBvprqCt9DGZ+YK+xTOWOkLiem7AH8VaKPJ8HiMDBS5VJD0qAVtP
	5U25RcE5kFuG8fnjEZveTTnRWQrK920eQ8RmJtK4gfyeaJ1jRjJJIgA==
X-Gm-Gg: ASbGncuBULvYJ0nH+xMkiCg2kDD81nGArm9BBBwYL59tqq3M6MnCtkDpJ80mzGy0OZq
	/y7G2cNb8+iSz8mFHm40HGDAdYF+xpiDus+xLR2nFijhsZdH+0ia+7+BvweygfFUcWtORRsqiqB
	DAaVwWxj9kFmoOPx/qls3xxn0H3G3cv7QkrYjIL+l7DaSNiIhs4yqyHQRgxoQQDTvha33GiG5hI
	SvXR5jNQiuThoNeB333R4Bn1mR02NUv5ujEDh86G+XywX4PRbyfr9hObCDB1WXtdn83tx6vMx3d
	6FHe3kYN1mrHNEDjn4GXkWpd8BQM2MXRkAff7GxA9Sw=
X-Received: by 2002:a05:6e02:1845:b0:423:fea2:584a with SMTP id e9e14a558f8ab-42481979b04mr21894815ab.3.1758297467360;
        Fri, 19 Sep 2025 08:57:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG3kKvBSX9JHZGnWAdCW/3QH1TzYJQzZYSAISEqZ847cNL+IsLLiA4SVKmwkv0UjgNX2yNcRA==
X-Received: by 2002:a05:6e02:1845:b0:423:fea2:584a with SMTP id e9e14a558f8ab-42481979b04mr21894495ab.3.1758297466785;
        Fri, 19 Sep 2025 08:57:46 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-4244a36b076sm23232495ab.1.2025.09.19.08.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 08:57:45 -0700 (PDT)
Date: Fri, 19 Sep 2025 09:57:43 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Alex Mastro <amastro@fb.com>, Kevin Tian <kevin.tian@intel.com>, Bjorn
 Helgaas <bhelgaas@google.com>, David Reiss <dreiss@meta.com>, Joerg Roedel
 <joro@8bytes.org>, Keith Busch <kbusch@kernel.org>, Leon Romanovsky
 <leon@kernel.org>, Li Zhe <lizhe.67@bytedance.com>, Mahmoud Adam
 <mngyadam@amazon.de>, Philipp Stanner <pstanner@redhat.com>, Robin Murphy
 <robin.murphy@arm.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, Will
 Deacon <will@kernel.org>, Yunxiang Li <Yunxiang.Li@amd.com>,
 linux-kernel@vger.kernel.org, iommu@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [TECH TOPIC] vfio, iommufd: Enabling user space drivers to vend
 more granular access to client processes
Message-ID: <20250919095743.482a00cd.alex.williamson@redhat.com>
In-Reply-To: <20250918225739.GS1326709@ziepe.ca>
References: <20250918214425.2677057-1-amastro@fb.com>
	<20250918225739.GS1326709@ziepe.ca>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 Sep 2025 19:57:39 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:
> 
> What I've been thinking is if the vending process could "dup" the FD
> and permanently attach a BPF program to the new FD that sits right
> after ioctl. The BPF program would inspect each ioctl when it is
> issued and enforce whatever policy the vending process wants.

Promising idea.

> What would give me alot of pause is your proposal where we effectively
> have the kernel enforce some arbitary policy, and I know from
> experience there will be endless asks for more and more policy
> options.

Definitely.  Also, is this at all considering the work that's gone into
vfio-user?  The long running USD sounds a lot like a vfio-user server,
where if we're using vfio-user's socket interface we'd have a lot of
opportunity to implement policy there and dma-bufs might be a means to
expose direct, restricted access.  Thanks,

Alex


