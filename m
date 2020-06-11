Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F7D1F66E7
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 13:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgFKLe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 07:34:28 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36513 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727109AbgFKLeY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Jun 2020 07:34:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591875262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=kvOkZNSYFeD+43Sy08lFqOoYp/OFi1aiv2h8v9KKAP4=;
        b=etcfzlhYUXUr2JMq/IBg38soc5HuV1HAeiqo2x94a/Tg0ypUhREMWcJZdIx5hJc3yK4ttw
        zf4GYyEsVma63FwKNYE00D9YpK3ZcKAY2kuRC5ZkyiMi5geamOQ1IuxBdO1Pao0qcFnEe1
        JwR+D0hQQCF8P67Mkjkq4oM+QNp4p/s=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-vAAHg8CLPie5P1gv1FhvHg-1; Thu, 11 Jun 2020 07:34:17 -0400
X-MC-Unique: vAAHg8CLPie5P1gv1FhvHg-1
Received: by mail-wm1-f70.google.com with SMTP id g84so1234584wmf.4
        for <kvm@vger.kernel.org>; Thu, 11 Jun 2020 04:34:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=kvOkZNSYFeD+43Sy08lFqOoYp/OFi1aiv2h8v9KKAP4=;
        b=bq6wfh3NBm7ZG55okWKCTjarWXEHWM0Qk3AaeVa5N2mzq1g8BU/uVpuHgKBkU6H+mu
         wFxyjlGZ5f2QUd0y1wDaKbx+XTuJRLrxLnS2pDN7lFNlDC6DidvSKOGOwWFjUUo4CeK7
         KFHPXYplLsBz8dUXoSGnMEQbBEhGZznr4V7GKzWXBhbqz7bckA3OVrfdHrlXdS7OjtcT
         WhHJ1LufZLMtKSbDTN8bnegtGvYTs9FTMMaSUVm+nWwO1thKbXD2eKNO4P3JXttWyBWV
         gBs/AaCNJDF+cpR+Jmfcg/1NdMijUzqUKJhFy66G/3wAt9vkecugkI10FjyrjHuJkITK
         lQUQ==
X-Gm-Message-State: AOAM533Q3TqQ1/KzKM7xm7UhCO21ab0Z/FubOBCwpH//8WUSQfvuMxtN
        euCm7lsP9GYk9ZiZN3UN0PJuRupxaCXp28EgVBQnFhjAZ9yLT08A4jnZ0oQ7FQSpY2/lFSXHnQJ
        xGzzUUNlxaLZI
X-Received: by 2002:adf:afc7:: with SMTP id y7mr9022430wrd.173.1591875256651;
        Thu, 11 Jun 2020 04:34:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzMVwGtIAyLyKuJe/rvxpW01IwwfuztK2wzsTcAeYYTwafjhy8A/SBGUsb9zgk1wtRdA+tFzQ==
X-Received: by 2002:adf:afc7:: with SMTP id y7mr9022405wrd.173.1591875256447;
        Thu, 11 Jun 2020 04:34:16 -0700 (PDT)
Received: from redhat.com (bzq-79-181-55-232.red.bezeqint.net. [79.181.55.232])
        by smtp.gmail.com with ESMTPSA id k12sm4673844wrn.42.2020.06.11.04.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 04:34:15 -0700 (PDT)
Date:   Thu, 11 Jun 2020 07:34:14 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v8 00/11] vhost: ring format independence
Message-ID: <20200611113404.17810-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


This still causes corruption issues for people so don't try
to use in production please. Posting to expedite debugging.

This adds infrastructure required for supporting
multiple ring formats.

The idea is as follows: we convert descriptors to an
independent format first, and process that converting to
iov later.

Used ring is similar: we fetch into an independent struct first,
convert that to IOV later.

The point is that we have a tight loop that fetches
descriptors, which is good for cache utilization.
This will also allow all kind of batching tricks -
e.g. it seems possible to keep SMAP disabled while
we are fetching multiple descriptors.

For used descriptors, this allows keeping track of the buffer length
without need to rescan IOV.

This seems to perform exactly the same as the original
code based on a microbenchmark.
Lightly tested.
More testing would be very much appreciated.

changes from v8:
	- squashed in fixes. no longer hangs but still known
	  to cause data corruption for some people. under debug.

changes from v6:
	- fixes some bugs introduced in v6 and v5

changes from v5:
	- addressed comments by Jason: squashed API changes, fixed up discard

changes from v4:
	- added used descriptor format independence
	- addressed comments by jason
	- fixed a crash detected by the lkp robot.

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


Michael S. Tsirkin (14):
  vhost: option to fetch descriptors through an independent struct
  fixup! vhost: option to fetch descriptors through an independent
    struct


Michael S. Tsirkin (11):
  vhost: option to fetch descriptors through an independent struct
  vhost: use batched get_vq_desc version
  vhost/net: pass net specific struct pointer
  vhost: reorder functions
  vhost: format-independent API for used buffers
  vhost/net: convert to new API: heads->bufs
  vhost/net: avoid iov length math
  vhost/test: convert to the buf API
  vhost/scsi: switch to buf APIs
  vhost/vsock: switch to the buf API
  vhost: drop head based APIs

 drivers/vhost/net.c   | 174 +++++++++----------
 drivers/vhost/scsi.c  |  73 ++++----
 drivers/vhost/test.c  |  22 +--
 drivers/vhost/vhost.c | 378 +++++++++++++++++++++++++++---------------
 drivers/vhost/vhost.h |  44 +++--
 drivers/vhost/vsock.c |  30 ++--
 6 files changed, 439 insertions(+), 282 deletions(-)

-- 
MST

