Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45E00D551C
	for <lists+kvm@lfdr.de>; Sun, 13 Oct 2019 10:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbfJMIH7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Oct 2019 04:07:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46522 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728073AbfJMIH7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Oct 2019 04:07:59 -0400
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1AB3E81F18
        for <kvm@vger.kernel.org>; Sun, 13 Oct 2019 08:07:59 +0000 (UTC)
Received: by mail-qt1-f197.google.com with SMTP id t25so14544255qtq.9
        for <kvm@vger.kernel.org>; Sun, 13 Oct 2019 01:07:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=yhYWl1Umy/1VTjIbbiNd2BN64NH6epCZE/mb8RSLaXM=;
        b=A3rAC975lbPOLzEhXGDqIVGPvxIbP28sgE7xBMU1GqmcIvgZiq/DeAXfpJ7MtJFVYl
         mwhIE85vtS142sPlR+EIYsSDvmlSpTWEORGojjJE7v+ZdlDzeudLr7e1jpvMb/pe5YnP
         wb1QbKs6Ei+LvhdEM3Iz+6SBlVD/6AvyHZfnw0bcDc61MeVWA8DoHCLaliohh/EjUx9i
         ddFC7yTNjeVfU9qToOnjCCt77KWEKJ2gYFuCA2B/kbELTcjVESh6Bw7rWPm03pxXAzQh
         RpccmG6hUESByvu3ZOU9cHpfKuLBtBvy8VtItJBTwRLx9ZJxFyxeZEwbQIOsPfuJ+dgP
         eI1A==
X-Gm-Message-State: APjAAAU3xbFGLqgBjv+sjIJvuKb4lWU7G95SJuWs5ut2x+QODe34SiHm
        ManVYwO0iA+OP8v7OdMt3m4AENP6Lm7dGYPbv94CoV3XXha3LSrFTBHRhhpuDiCrYTVRyruXlAU
        TgE2JT+4kXnx8
X-Received: by 2002:a37:9a05:: with SMTP id c5mr23746934qke.98.1570954078376;
        Sun, 13 Oct 2019 01:07:58 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxdHllinWFJ1shL2L0dscS9heDbinJBHlNcirUbgmYpZ/ksUyJvF3jXeQkMuv9YmookTDp0DQ==
X-Received: by 2002:a37:9a05:: with SMTP id c5mr23746919qke.98.1570954078076;
        Sun, 13 Oct 2019 01:07:58 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id q8sm7301621qtj.76.2019.10.13.01.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2019 01:07:57 -0700 (PDT)
Date:   Sun, 13 Oct 2019 04:07:52 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Subject: [PATCH RFC v3 0/4] vhost: ring format independence
Message-ID: <20191013080742.16211-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.22.0.678.g13338e74b8
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds infrastructure required for supporting
multiple ring formats.

The idea is as follows: we convert descriptors to an
independent format first, and process that converting to
iov later.

The point is that we have a tight loop that fetches
descriptors, which is good for cache utilization.
This will also allow all kind of batching tricks -
e.g. it seems possible to keep SMAP disabled while
we are fetching multiple descriptors.

This seems to perform exactly the same as the original
code already based on a microbenchmark.
Lightly tested.
More testing would be very much appreciated.

To use new code:
	echo 1 > /sys/module/vhost_test/parameters/newcode
or
	echo 1 > /sys/module/vhost_net/parameters/newcode

Changes from v2:
	- fixed indirect descriptor batching

Changes from v1:
	- typo fixes


Michael S. Tsirkin (4):
  vhost: option to fetch descriptors through an independent struct
  vhost/test: add an option to test new code
  vhost: batching fetches
  vhost/net: add an option to test new code

 drivers/vhost/net.c   |  32 +++-
 drivers/vhost/test.c  |  19 ++-
 drivers/vhost/vhost.c | 340 +++++++++++++++++++++++++++++++++++++++++-
 drivers/vhost/vhost.h |  20 ++-
 4 files changed, 397 insertions(+), 14 deletions(-)

-- 
MST

