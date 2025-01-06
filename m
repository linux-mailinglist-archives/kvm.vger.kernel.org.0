Return-Path: <kvm+bounces-34585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AB62A024C6
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 13:05:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D6CA165008
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 12:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01C911D935E;
	Mon,  6 Jan 2025 12:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="ZKMdps5r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D871D517B
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 12:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736165114; cv=none; b=jKb4k9CGC48HIBypIaoq3TkFJ8nRiurm93H7bQg9JfBW+Jipjobn7EVqw3xaC1eoyT/3j3fBnrdOgeqtn+ZDReEn7md9/1kWnswGz6VE3E0UsWp0LObsYhM/F2O8G7vITycFm29LRxFJzJy6qBXDZPBIoEX9xZn3Q7AUZQvxmto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736165114; c=relaxed/simple;
	bh=0iRa6EEImH6dlHzlicrBzOn2LQ3TjBMLZL0GCnr0KlY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iG69Nk6aRN1VzNQNhr0Dq5y3dKol/pzWS4UTJWpDlY5A9RyNizMmXGDu8eBBVgqi+UNpIPrYIYH03JkLrc7YZwifb6LzQgUm95rzAw+UwaMLyquCuN9OHlCF7as4v1WV9SR62EILGpsOJ7pvu8cJ1vjqag+aLMDba3hPAOhZtL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch; spf=none smtp.mailfrom=ffwll.ch; dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b=ZKMdps5r; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ffwll.ch
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43635796b48so86102675e9.0
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 04:05:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1736165111; x=1736769911; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mR8gi6U4cwYS0aW4/hxecZgCrBHXc4kljGv3GyLWPoI=;
        b=ZKMdps5rr8hxY8OWxiAsjbBp0PhFEyWwquLG9eS1/W0PCDYq7tbmJNhXvUWwmn5Eaw
         yQBPJOkNBYQfd8BZCztnn2iVgO8gIJp+KWuwCk8Tn0swnz3kP5REstSZcTOUfQJbV9oJ
         GAkiSkEzwPxb8hvnR+tvx6o9jHsMN/nGilpOU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736165111; x=1736769911;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mR8gi6U4cwYS0aW4/hxecZgCrBHXc4kljGv3GyLWPoI=;
        b=WZBwSO2wowRQ9qB7UWfsQZcfd4/QGDNTgI9/Dwn/AB140QxE9uLhqg4BYR83llVASP
         WT61odd7pjmwh169LKHRSHTSgwF92ZwMOMVAVLlMH8UdJJDDlFb8RdhNg7X/ECsd57X2
         hji0C1n07DaQer+9jMGzOdcN0CBVOj9ebZZKhoVEG3Ju3if4R9VQqbQO0yMh+yl1IZr0
         A6v/dfAfHSGbcQyb4Rb7qlH/gsQuTPpRjghSoJLGkWU+kSlldD45gTtFcmnxqn5NVbek
         QItRTyQCCi/FwxM1fR/UVlj5IvRWdnJLvOdVB2bmutTM5e6mRIYbVDAbHvyKJ8gOA744
         QUww==
X-Forwarded-Encrypted: i=1; AJvYcCUbfEWBJXLVSBb5Xm14pfZqhpxyaZgNx0MJxiFX6o+BskrSmzVSklCV2W5NtfSvSudxjm8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQ0d7sYH3PD6Zu5L8XH3eU+o2ca6GfBBkUAhy3uN4m3Xhrmrz8
	bD7iQVg0SSSLNdrc/xepU4sqUVbGwFqaegCURPsNjbYTciZ9EXrTgEw6FNUvYPU=
X-Gm-Gg: ASbGncsBg87UV2uM1xuCcG2ywNFNC1aFe8iRWyg3e/a87jK2t9RCWQyJ8jdMO9ondK7
	7TYLWiOBN+zzrjkz+8pKwRT6MuiW0s2aSoe9VN8RarD+NNZZCMUmZYMrAFVsXb3fry/TjNFIBSR
	Dq1mr5vqn0IfugfraiURdtmdrXTB4Mlqe8lrj20tC7ISrd9nbvom80zzxkzJMKvupJKVSnR3ivs
	hpwMk5aSqsgMuZdnan4D/28aFgizYECHVFCc6mcJd1PcfxpInUhAoDd/xP742waqVHt
X-Google-Smtp-Source: AGHT+IGqrYDLO8WuLsURv5mBKdZnSYgPAQgK5+8FmFCtidEbzqmhldfGSWYEyPKtEVnMyQ4Knh1myQ==
X-Received: by 2002:a7b:c3d9:0:b0:434:ea1a:e30c with SMTP id 5b1f17b1804b1-4365c79aa7dmr532914215e9.13.1736165110894;
        Mon, 06 Jan 2025 04:05:10 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:5485:d4b2:c087:b497])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43665cd9c29sm548387705e9.14.2025.01.06.04.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 04:05:10 -0800 (PST)
Date: Mon, 6 Jan 2025 13:05:08 +0100
From: Simona Vetter <simona.vetter@ffwll.ch>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	"Kasireddy, Vivek" <vivek.kasireddy@intel.com>,
	Wei Lin Guay <wguay@meta.com>, Keith Busch <kbusch@kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	Dag Moxnes <dagmoxnes@meta.com>,
	Nicolaas Viljoen <nviljoen@meta.com>,
	Oded Gabbay <ogabbay@kernel.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Leon Romanovsky <leon@kernel.org>, Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH 0/4] cover-letter: Allow MMIO regions to be exported
 through dmabuf
Message-ID: <Z3vG9JNOaQMfDZAY@phenom.ffwll.local>
References: <89d9071b-0d3e-4fcd-963b-7aa234031a38@amd.com>
 <Z2BbPKvbxm7jvJL9@kbusch-mbp.dhcp.thefacebook.com>
 <0f207bf8-572a-4d32-bd24-602a0bf02d90@amd.com>
 <C369F330-5BAD-4AC6-A13C-EEABD29F2F08@meta.com>
 <e8759159-b141-410b-be08-aad54eaed41f@amd.com>
 <IA0PR11MB7185D0E4EE2DA36A87AE6EACF8052@IA0PR11MB7185.namprd11.prod.outlook.com>
 <0c7ab6c9-9523-41de-91e9-602cbcaa1c68@amd.com>
 <IA0PR11MB71855CFE176047053A4E6D07F8062@IA0PR11MB7185.namprd11.prod.outlook.com>
 <0843cda7-6f33-4484-a38a-1f77cbc9d250@amd.com>
 <20250102133951.GB5556@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250102133951.GB5556@nvidia.com>
X-Operating-System: Linux phenom 6.12.3-amd64 

On Thu, Jan 02, 2025 at 09:39:51AM -0400, Jason Gunthorpe wrote:
> On Thu, Dec 19, 2024 at 11:04:54AM +0100, Christian König wrote:
> 
> > > Based on all the above, I think we can conclude that since dma_buf_put()
> > > does not directly (or synchronously) call the f_op->release() handler, a
> > > deadlock is unlikely to occur in the scenario you described.
> 
> Right, there is no deadlock here, and there is nothing inhernetly
> wrong with using try_get like this. The locking here is ugly ugly
> ugly, I forget why, but this was the best I came up with to untangle
> it without deadlocks or races.

Yeah, imo try_get is perfectly fine pattern. With that sorted my only
request is to make the try_get specific to the dma_ops, because it only
works if both ->release and the calling context of try_get follow the same
rules, which by necessity are exporter specific.

In full generality as a dma_buf.c interface it's just busted and there's
no way to make it work, unless we inflict that locking ugliness on
absolutely every exporter.

> > Yeah, I agree.
> > 
> > Interesting to know, I wasn't aware that the task_work functionality exists
> > for that use case.
> 
> IIRC it was changed a while back because call chains were getting kind of
> crazy long with the file release functions and stack overflow was a
> problem in some cases.

Hm I thought it was also a "oh fuck deadlocks" moment, because usually
most of the very deep fput calls are for temporary reference and not the
final one. Unless userspace is sneaky and drops its own fd reference in a
separate thread with close(), then everything goes boom. And untangling
all these was impossible.
-Sima
-- 
Simona Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

