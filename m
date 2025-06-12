Return-Path: <kvm+bounces-49229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CEA0AD6838
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 08:50:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9D583AE44A
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 06:50:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEEDC202F9A;
	Thu, 12 Jun 2025 06:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P3Ckdrps"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AD779E1;
	Thu, 12 Jun 2025 06:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749711010; cv=none; b=cWUF+Wedw8R4yzPzyq36dbAqLrN+LNdKxl2t8fNMAP5KTZ6g46HB9rUwKk+9HiCzgyAi6K8j0mBIxv87ym64ki89rXn6n1G7M47sLPjvSnNNHAv7PVJjoaLcMh3F++W0vrbvy91EkvsCNoD7aWX9/xI2qL7KECamPjNotkDtunY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749711010; c=relaxed/simple;
	bh=08PF/lUsOyzjSZ16g6xMGKxp92gOt1shxG7B2bPWqkw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P7XHD0Ll42vWNqdlGZgpyJi+AKhz0s2ldaIzlQbjSKS5e6uFvUUNb69gRO+5sJ46wquVLyNcpwq8J2EYVcVz3KD+4rc5ni5ukaXL2FfhUMHaL6eg2ixazdWaWt8UiEhphe+I/kINSOFkpF2+X4atMQyo0yfUDJghIY4kos/CcIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P3Ckdrps; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7399a2dc13fso875210b3a.2;
        Wed, 11 Jun 2025 23:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749711008; x=1750315808; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GAhUfbavJ/U3RSjlWfBGk3Y1ELwSnt4DpMvXPbLBnqQ=;
        b=P3CkdrpsfgCihO/vBITaRTJtyJNOl1T99tJbby4B2QSwrwEJX2LFOBDqjvy4iYg/Pt
         jPyXj8uvzHKz7u5FR7LRcxQooLoJ8BWcfLQx6XEdvmx4GFjlxP+dWFTWDLnaoJWjXSgP
         jGj6B6f2UfwUP7LYKNVlM8nBJ5qbhf3h8SIp0G2oVdRzd22OLfnhafYQ5bGMYv2bE3jZ
         RuAvgr0q4gE+OIOJ+szLcXUCC1ZNZLj16juBXmctszbyvIQQwa/UDpABI38YF6nSUdes
         cY7GKe/C8YHKbmBrYjTt7p4GuRz9QxaofKwau9ZXxAgi5+QnO8XjEWwtOh+AJmjzgmzE
         9gyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749711008; x=1750315808;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GAhUfbavJ/U3RSjlWfBGk3Y1ELwSnt4DpMvXPbLBnqQ=;
        b=kd784Or1eaWpXOn/lp4rR+Aeu7p0GOCCkWDZFnfQL2DLG2c2nPeW9HSl8o+W0kQKvE
         hUJZSf63xsA68lBj13DdMp8vFUcflkrnpcyh9d7g/c6K6WOHBKUzyyXxq7j9Qvh3xjdq
         0esh+9oM1S9GolEzhBUqlrOsx9ic2+nSSr+6kVGOZFzpzLvf4hstOoGrWIUGgiJsPxKY
         bgprK2dEsnUkCYiP6jWAxDkQTMt6NkKGXRD833v9G3w9IKtE8IOs5a1nAtOXCkYrNM2E
         tQxrJJN9UzPzn39wAOEerEeKruM+Wz/gCuTX1ZuWVoLTvAAzWe++NN3eOteaIl4jNMKU
         SoAA==
X-Forwarded-Encrypted: i=1; AJvYcCV+qeSbTAYARx6jTSAxKvq4ldYuo9CEQdMIyd6lkJBxEpA93vupfQiyx8Z36onY9ANbwE6SCHcB@vger.kernel.org, AJvYcCV543iciRlo/OjECkgnYDuXeorq2LLRaigN3IeHbKuJbmKHm1s/Ax4mUlkLPCKQNCRtDzc=@vger.kernel.org, AJvYcCVMYh7uSyosH68VWxIJXm1Dh1k6R/7hPxRQwO1cTSRoeXY5/CwhYSiybg4lPqtispCemz7QJPEM35TPJhtr@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4tMYJROAEn8/gfsT1jO9/ojYYV7pChTy9BFKufDaZLRhGW14e
	dfrYYpUUPTkBrt8ew9XzLNws25DB1r/EQmqJdiYP4O9sFpjQ9BapuN4f
X-Gm-Gg: ASbGncv2FkrhDIORAwxovjzjG/PhZ25VNOd1SwUmWp4UkiX5Kxskigel+6mIiTPjzLT
	OVGBKYqFzK50BVpjInzZ94wFaCdkv0FluSGXhL7GVmaKWzjz9xqn9kfMBOK1lbslusoQn06qjVx
	sdAto+rAoOY/uw28S10YPz+jC++Kdo0Kg3644PAuFApFFi0V/sd2H7m2ht/+XYS5wvQ9no6D5Bv
	sW+xM9C1PTl8pT73rrfF7Tl0h3vuFnUZ9uy2exqaPY4oejfNgywNmY14ZSJK2J48dXniAU4A4oT
	5lrG0K1AANUP47GYjaKoC0EvUVmhPkVErHxs7tfg5Bj39Ky9Y4nteu68Eq0R25FjxqG68BV6ehW
	O1ukQRbh8
X-Google-Smtp-Source: AGHT+IGZ04n2ntr6M6gKmnZGuVgjfZIdYUzO7jRwZ6WSZQWmXFnMB4eiJ3OYjNtknt2vP06p1Txifg==
X-Received: by 2002:a05:6a21:3994:b0:215:e60b:3bc7 with SMTP id adf61e73a8af0-21f9786f9damr4116995637.26.1749711007658;
        Wed, 11 Jun 2025 23:50:07 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2fd613fee4sm675601a12.26.2025.06.11.23.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jun 2025 23:50:07 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: mst@redhat.com
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
	netdev@vger.kernel.org,
	niuxuewei.nxw@antgroup.com,
	niuxuewei97@gmail.com,
	pabeni@redhat.com,
	sgarzare@redhat.com,
	stefanha@redhat.com,
	virtualization@lists.linux.dev,
	xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH net] vsock/virtio: fix `rx_bytes` accounting for stream sockets
Date: Thu, 12 Jun 2025 14:49:57 +0800
Message-Id: <20250612064957.978503-1-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250612023334-mutt-send-email-mst@kernel.org>
References: <20250612023334-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> On Thu, Jun 12, 2025 at 01:32:01PM +0800, Xuewei Niu wrote:
> > No comments since last month.
> > 
> > The patch [1], which adds SIOCINQ ioctl support for vsock, depends on this
> > patch. Could I get more eyes on this one?
> > 
> > [1]: https://lore.kernel.org/lkml/bbn4lvdwh42m2zvi3rdyws66y5ulew32rchtz3kxirqlllkr63@7toa4tcepax3/#t
> > 
> > Thanks,
> > Xuewei
> 
> it's been in net for two weeks now, no?

Umm sorry, I didn't check the date carefully, because there are several
ongoing patches. Next time I'll check it carefully. Sorry again.

It looks like no one is paying attention to this patch. I am requesting
someone interested in vsock to review this. I'd appreciate that!

Thanks,
Xuewei

