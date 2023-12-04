Return-Path: <kvm+bounces-3340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2178680351A
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 14:38:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B5412B20A09
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 13:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7074425567;
	Mon,  4 Dec 2023 13:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VtE0DQW7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B20136
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 05:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701697101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=5akfcmS88aMdBOZU2tgTkzn2BZ024jWxw0fAikE98gA=;
	b=VtE0DQW7wlfLoFn+JC6Kj8+dEXzHuu85SpwTQcz7xkpG6nJ+84m8CsnSNbBQ/Gq1dWpkM3
	3arhhUq8avt2VijUGtNRD+kI/yl5eRsn/EWtbTAjOrf/Dp4gWUBBsV5OWvJwm7eaupvE6D
	jSmUxGqpjOSnHmTjFRL/wiOGMFFt6WY=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-C6b2bhUCP8a7rf8oe_Ii_A-1; Mon, 04 Dec 2023 08:38:15 -0500
X-MC-Unique: C6b2bhUCP8a7rf8oe_Ii_A-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-423d293392bso63029611cf.2
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 05:38:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701697094; x=1702301894;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5akfcmS88aMdBOZU2tgTkzn2BZ024jWxw0fAikE98gA=;
        b=C9l5Wlxcmsk51Zn72CV/hiwiRVieUah2JxoyokB8issf5iW+0akL3Vpyz08fETYfWm
         csA3Vt048eVr2b4BW+36j9Jciqjg+DPF2FNWFrzzwIy/gC04KthkTtayJGhXel4sTZ1V
         xcUaNcF2qJ8t1HRc6o+fWAMEIgmzqGQOU+gPE6WfInvA2bJ+J8YhY3yZpHSYgEqeL0JA
         9qQzzwoBtqiYNJdZnciZkTYK5bKeJAPEgB/uulkbk0XYgeFTzlIADku1WC5w0E8KkbES
         u/GU3WVwTONhUbYOrGOjmWQ6FuEK2qlgB4gnXF5vPPnDjFUA0sCcqFEora00wHBD1Tpg
         HKJQ==
X-Gm-Message-State: AOJu0YwFoDigOHoLZUvjLYr3IdbpqRvBoyOUJ3+RszRFwfdBcm+IwxEl
	3lxXYPcPrdeykPXSD9FtXq3wZY8VYiF6Sxl+bQKwIDZwPcAqggXuAUzqJmbWLrCuJ36D75AYPJL
	d2TniwPB1HgIG
X-Received: by 2002:a05:622a:282:b0:425:4043:18d0 with SMTP id z2-20020a05622a028200b00425404318d0mr5350678qtw.131.1701697094709;
        Mon, 04 Dec 2023 05:38:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH+uydVke1bj6K3+VpqcvkS7K82S/AfCUqWL9s3clAKf0dXgfm1gbib9FuloJn1VamCnIS2mQ==
X-Received: by 2002:a05:622a:282:b0:425:4043:18d0 with SMTP id z2-20020a05622a028200b00425404318d0mr5350660qtw.131.1701697094341;
        Mon, 04 Dec 2023 05:38:14 -0800 (PST)
Received: from redhat.com ([2.55.57.48])
        by smtp.gmail.com with ESMTPSA id i14-20020ac8488e000000b004199c98f87dsm4284873qtq.74.2023.12.04.05.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 05:38:13 -0800 (PST)
Date: Mon, 4 Dec 2023 08:38:08 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	eperezma@redhat.com, jasowang@redhat.com, lkp@intel.com,
	mst@redhat.com, shannon.nelson@amd.com, steven.sistare@oracle.com
Subject: [GIT PULL] vdpa: bugfixes
Message-ID: <20231204083808-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent

There's one other fix in my tree but it was only posted very
recently so I am giving it a week in linux next, just in case.

The following changes since commit 2cc14f52aeb78ce3f29677c2de1f06c0e91471ab:

  Linux 6.7-rc3 (2023-11-26 19:59:33 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to cefc9ba6aed48a3aa085888e3262ac2aa975714b:

  pds_vdpa: set features order (2023-12-01 09:55:01 -0500)

----------------------------------------------------------------
vdpa: bugfixes

fixes in mlx5 and pds drivers.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Shannon Nelson (3):
      pds_vdpa: fix up format-truncation complaint
      pds_vdpa: clear config callback when status goes to 0
      pds_vdpa: set features order

Steve Sistare (1):
      vdpa/mlx5: preserve CVQ vringh index

 drivers/vdpa/mlx5/net/mlx5_vnet.c | 7 ++++++-
 drivers/vdpa/pds/debugfs.c        | 2 +-
 drivers/vdpa/pds/vdpa_dev.c       | 7 ++++---
 3 files changed, 11 insertions(+), 5 deletions(-)


