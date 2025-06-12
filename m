Return-Path: <kvm+bounces-49238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 058A4AD6A6F
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 10:22:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E4C41700E5
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 08:22:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25A40221FA4;
	Thu, 12 Jun 2025 08:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NE5UStuq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922591B0F0A;
	Thu, 12 Jun 2025 08:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749716487; cv=none; b=TDYdCWl9xBwb2UAV/FjkWqiU57LCko3hjYVAm5EtpK3C8O3vMTeh0tOWZwFqMejAPTFjw+9ykN+M739jFoLPyA0i2vemKIc4Z+tFRnMxk7iDaiYSEVJLmQOX+mb2KTwuuRvn1Fp+WKLZsHdCDkBcgCLpxIWnUMBcRnqoqcOMOqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749716487; c=relaxed/simple;
	bh=cA1qk3yB6bh3HRDOAFOZEbWTkiE34cfwmnNRWGtfb2E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O8agmeS7n6QuvduhTugMHhoiqtrCxXWLtl0giLTselNIbSqU8P4JfvMgXx0S1u7Koj83xw4Bo8BJm3onQ5SBM/4Unf1aSEqUdsJrkk986sShvl/Z6tffp1Fk0BIRvdJEKmaf/TMccKYoHkk0u96Iqb6i/gDm6R5vtomDkWRse+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NE5UStuq; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-747fba9f962so601955b3a.0;
        Thu, 12 Jun 2025 01:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749716485; x=1750321285; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AGY5/ZppoucW3cdRAPG2Yq6T7pXeZ7SlaGjUvy+OgTk=;
        b=NE5UStuqMQFzN4O1JR2+Lh/1vWkuDiFNCPmY1UudhEpx7ElDGCCxNOiEiVM7srEH5h
         of9W8bckPd6ruNZlBMbIAx5EahRUwuDVYTFte0fyOKvV6II1qbeTjjNWZ3S8nzV8YO5o
         P9rigoNx5uWG+DZLesnN5RUE6GN4gXtdDqY5vQxyHiAKQ3G/Z7G0na1VnPHNXA3TEVKx
         zjazkfU9/NUaE1x7hG2fJyztk+ZCpq7MvxRKdjlmED32pCZ0Lc2C5N716y1ZSo1X0L3e
         2EVNDZW/r+z8rutRk/oYsGK9UCM9mP+FEdbppa9zKEZeTU9cxpXigO3u7Rbs0GUQ3/RR
         HzJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749716485; x=1750321285;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AGY5/ZppoucW3cdRAPG2Yq6T7pXeZ7SlaGjUvy+OgTk=;
        b=IPR2WJ9h4TBSsIn5/QgmeqORZBoygc0ReN8jcV2aoz2jbjWmH4hhObdQHXoRnCvNi0
         ngUGAvhnNRosrj3iSBDValWneeXCrDsmUrjO26YwmbxLqAri3CKeNcPtWd+NVTEGOWi3
         oeLRG4BeP3PXyf74UcrAiYRRbEsNGNj9WC6ANcSo6z0SSTMWw/b7jXwRSPWwZUH5ljtf
         HKF/mtmgigR9Jdnicwf0trc6HClVY+qIMYpEzZ/rm0QAK1TN7O0/V7Fy/lYu8ISTA+Vs
         2jAmLiQ3EB76R5vKUDpd1LRPQjnUKMB+p3KHe2MLuOdi1wSB92Q/hzXlV6ibQo+qYVqH
         bW3A==
X-Forwarded-Encrypted: i=1; AJvYcCUEeOu0t6MYjEHmOiEwMqLcTHwEe/FKG22PBPosD9R5lwKtWWu7FkrNHazviaQBtTYTv3o=@vger.kernel.org, AJvYcCXWLPWnZUry82M8HltcnZMuVaQVqC1S6c9XYuL3NuZ6HCwZcFShTlYlEMlSu/IpFIn5sduaesQFarNhkObj@vger.kernel.org, AJvYcCXWWANMZrMPfNm4k5z5XN2oTz3ysNcQhKf+2XbU9DYCW7HKAOIdzc/qZRlk7cMR1PTJu7SmRArW@vger.kernel.org
X-Gm-Message-State: AOJu0YxMf8MtyHaRAGxKC6h1HmOym0o6A71+5Abfmgz/GV17sG2zXTCm
	LXMS50opsZEQrrGNvFq1ARrmqEjZmmyEdbxWeC14RM6Kjv6OcnLtaTLm
X-Gm-Gg: ASbGncvSIEVMaiCcxcM97NfkiBfSWO4vOnAc9nywRD5RTLZITxZCWbVAjWk5G4LYCtq
	jr4TKza3ArPpfzZEQvbbfCYBG734gblupl0BlYchHApXSiVLczaESC4dRHSkcb4R5K86wPVCUhx
	LXgOFFx7vNin6c1BHA6vDV5vXiYy/E+2vpQoRmUtaZIZBSP03SuaiL7gnhJ+n4vzSgjNJlWWnKu
	HjuJ6+yZfoRinB3sST8pQYALOyT3+54nxlKH7niwH0+SENToG9oV/t5URejv+6fPpmuxitOw88H
	5io9oU2vaaywYT4rhJE2Uz3VABkmhybIfupqPsCc0soGf1kqljVY6xQ0eycobXoP2l7f/BPM918
	LOLqP1MtdvqEk8jBy30Y=
X-Google-Smtp-Source: AGHT+IE+LDi/Ab84IBFtCqrYc1tpyvpJ4aUiVqEazD1/iV2mWYI0UZMCjrUiYLHgOoy0bCfPKn/26A==
X-Received: by 2002:a05:6a00:6086:b0:746:2217:5863 with SMTP id d2e1a72fcca58-7487ce58871mr2355872b3a.6.1749716484623;
        Thu, 12 Jun 2025 01:21:24 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748808962d5sm885967b3a.54.2025.06.12.01.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 01:21:24 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: sgarzare@redhat.com
Cc: Oxffffaa@gmail.com,
	avkrasnov@salutedevices.com,
	davem@davemloft.net,
	edumazet@google.com,
	eperezma@redhat.com,
	horms@kernel.org,
	jasowang@redhat.com,
	kuba@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	netdev@vger.kernel.org,
	niuxuewei.nxw@antgroup.com,
	niuxuewei97@gmail.com,
	pabeni@redhat.com,
	stefanha@redhat.com,
	virtualization@lists.linux.dev,
	xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH net] vsock/virtio: fix `rx_bytes` accounting for stream sockets
Date: Thu, 12 Jun 2025 16:21:02 +0800
Message-Id: <20250612082102.995225-1-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAGxU2F6c7=M-jbBRXkU-iUfzNbUYAr9QApDvRVOAU6Q0zDsFGQ@mail.gmail.com>
References: <CAGxU2F6c7=M-jbBRXkU-iUfzNbUYAr9QApDvRVOAU6Q0zDsFGQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> On Thu, 12 Jun 2025 at 08:50, Xuewei Niu <niuxuewei97@gmail.com> wrote:
> >
> > > On Thu, Jun 12, 2025 at 01:32:01PM +0800, Xuewei Niu wrote:
> > > > No comments since last month.
> > > >
> > > > The patch [1], which adds SIOCINQ ioctl support for vsock, depends on this
> > > > patch. Could I get more eyes on this one?
> > > >
> > > > [1]: https://lore.kernel.org/lkml/bbn4lvdwh42m2zvi3rdyws66y5ulew32rchtz3kxirqlllkr63@7toa4tcepax3/#t
> > > >
> > > > Thanks,
> > > > Xuewei
> > >
> > > it's been in net for two weeks now, no?
> >
> > Umm sorry, I didn't check the date carefully, because there are several
> > ongoing patches. Next time I'll check it carefully. Sorry again.
> >
> > It looks like no one is paying attention to this patch. I am requesting
> > someone interested in vsock to review this. I'd appreciate that!
> 
> Which patch do you mean?
> 
> Thanks,
> Stefano

I am saying your patch, "vsock/virtio: fix `rx_bytes` accounting for stream
sockets".

Once this gets merged, I will send a new version of my patch to support
SIOCINQ ioctl. Thus, I can reuse `rx_bytes` to count unread bytes, as we
discussed.

Thanks,
Xuewei

