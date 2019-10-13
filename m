Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20579D55ED
	for <lists+kvm@lfdr.de>; Sun, 13 Oct 2019 13:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729141AbfJMLmE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Oct 2019 07:42:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60700 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728997AbfJMLmE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Oct 2019 07:42:04 -0400
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EC41A83F3E
        for <kvm@vger.kernel.org>; Sun, 13 Oct 2019 11:42:03 +0000 (UTC)
Received: by mail-qk1-f198.google.com with SMTP id s28so14077100qkm.5
        for <kvm@vger.kernel.org>; Sun, 13 Oct 2019 04:42:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=WhM42HnkXorw8ZktlIqV/yS0IRHKb5HISbW//fiFIIA=;
        b=Xjk2l5DfNnEPpgnM0bsdK8kfEkJCH8adjOMU+0Jye07xyfaFZyRA6ADwS4PqwzdPiR
         X2TldZCKsdw6ZXfQIXDu8F3QsUwHi6z7b/ILa23dyfM1kk7CRlE7NPMcxORL/rGA0+T5
         J4IfitsuYj3jAh3VW3i+gUoloM5VHaooVEH58JnfauV0HDzODEV5/MQgAC0mDiLshYsx
         rZfDS8nZEk5kWuVb0D6boGXcs+DO5/2CWy4jcv6Zq6lpHeQ1MBB/COOTXzuPzh2IQ4gN
         c7CYJX63B1SsUIyJBguX4rhBS6FGirL3ykmd7ePLhB6/P9gJlQve9c9VvWuflJPOEhhn
         /PUg==
X-Gm-Message-State: APjAAAU60Hg15tayfiIHcM6p/ni5aAOD5+WBeWAvPrM1DGlHFAtRPhOP
        7uBOoW4rvS1jEeDMmFy3tN6J6SpuWzPA937e8Kf0MvmA/YDyjUjo8iIJRFRQ0RkHQGjm4vWst0z
        qPIaDNKe7FXaH
X-Received: by 2002:a37:a14d:: with SMTP id k74mr25294018qke.308.1570966922926;
        Sun, 13 Oct 2019 04:42:02 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxJbPZHmjjRtZPdn0OIP4+7Md8xReA9OfG4qhSoToCuN8Mn6p7CW5fNAnas5HTHE7lcLL2Caw==
X-Received: by 2002:a37:a14d:: with SMTP id k74mr25293998qke.308.1570966922588;
        Sun, 13 Oct 2019 04:42:02 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id d25sm1763837qtj.84.2019.10.13.04.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2019 04:42:01 -0700 (PDT)
Date:   Sun, 13 Oct 2019 07:41:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Subject: [PATCH RFC v4 0/5] vhost: ring format independence
Message-ID: <20191013113940.2863-1-mst@redhat.com>
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

changes from v3:
        - fixed error handling in case of indirect descriptors
        - add BUG_ON to detect buffer overflow in case of bugs
                in response to comment by Jason Wang
        - minor code tweaks

Changes from v2:
	- fixed indirect descriptor batching
                reported by Jason Wang

Changes from v1:
	- typo fixes


Michael S. Tsirkin (5):
  vhost: option to fetch descriptors through an independent struct
  vhost/test: add an option to test new code
  vhost: batching fetches
  vhost/net: add an option to test new code
  vhost: last descriptor must have NEXT clear

 drivers/vhost/net.c   |  32 ++++-
 drivers/vhost/test.c  |  19 ++-
 drivers/vhost/vhost.c | 328 +++++++++++++++++++++++++++++++++++++++++-
 drivers/vhost/vhost.h |  20 ++-
 4 files changed, 385 insertions(+), 14 deletions(-)

-- 
MST

