Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B421F535B
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 13:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbgFJLfw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 07:35:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41238 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728471AbgFJLfw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 07:35:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591788950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=K8pYKea34n4xAOJeaGLf5FVVIvqFNqD4hPeT2vvgXYw=;
        b=QF2OTnz9kxuNasah4u4+KL7oDpaLE1I/forXxt8yF2+vBNNpKWBHG80j0tpIXY1sZpqptQ
        S5i5fLcweNfEER4kl5D0DL8ts+UN+0HWJLc+zsR5TfFnLo33R9HIQdyZ4PMsoaomRfIyTP
        Z640UA6RqpCOJbBxRhC8R3RpymGfVmo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-tW4BO7umNFa-hHurk8rvWQ-1; Wed, 10 Jun 2020 07:35:49 -0400
X-MC-Unique: tW4BO7umNFa-hHurk8rvWQ-1
Received: by mail-wm1-f69.google.com with SMTP id g84so400295wmf.4
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 04:35:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=K8pYKea34n4xAOJeaGLf5FVVIvqFNqD4hPeT2vvgXYw=;
        b=MiyK6LNjARTlLIVYy4PmWAEVPCIEJsDRTxRCE/YI9fKwLhOB1x4LJ69a13BhMwNEqN
         kp2EGmv9aW9fP8dnSYg7SwXZMHkuvkU/XHwwj1X8eA6eq56zshJ3gk+ghWT2XCFnG8qW
         97j08IXSK8PyUpARVGCdaEV+2KuIRt4ikwv0iEg/Ce1OMi4hnH7DjY/+VUcNcdk4zsoV
         yrAYNupfZc2Pu4ZZggVrCRgZS/l5cFSeUwSSQ/gj4rHaj5MXGmfePVNApUa2j0Nv9z1F
         0vpN8yOauvf10iGtmFcCyzwvO26UWyWKYrMWXuQKAMUH0aojtur5T4JtqZgBaMLQM6Tx
         FlPg==
X-Gm-Message-State: AOAM532zxWco2hRfo4odhgG3NJyvMcHn2fc+no25Yx0isGUSOG4ckVdr
        q7YO+8OT7KwNvt/VtNfoEZBXKcEvZSbcy1K+mnusvnsyDmZoVa+MHICJ9hjHyyk2pr5BSptUMKG
        9Ji488XTrgeIm
X-Received: by 2002:adf:f251:: with SMTP id b17mr3051843wrp.289.1591788947565;
        Wed, 10 Jun 2020 04:35:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyWnKuMQXjtn3IeBKm108U4YQm44aJFvUiXB9xS8f3b+y8TTFsSksejlRPFLR+mhd/ngiqchQ==
X-Received: by 2002:adf:f251:: with SMTP id b17mr3051819wrp.289.1591788947339;
        Wed, 10 Jun 2020 04:35:47 -0700 (PDT)
Received: from redhat.com ([212.92.121.57])
        by smtp.gmail.com with ESMTPSA id e15sm6864302wme.9.2020.06.10.04.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 04:35:46 -0700 (PDT)
Date:   Wed, 10 Jun 2020 07:35:44 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v7 00/14] vhost: ring format independence
Message-ID: <20200610113515.1497099-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This intentionally leaves "fixup" changes separate - hopefully
that is enough to fix vhost-net crashes reported here,
but it helps me keep track of what changed.
I will naturally squash them later when we are done.


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
  vhost: use batched get_vq_desc version
  vhost/net: pass net specific struct pointer
  vhost: reorder functions
  vhost: format-independent API for used buffers
  fixup! vhost: format-independent API for used buffers
  fixup! vhost: use batched get_vq_desc version
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

