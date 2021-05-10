Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5077C37932E
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 17:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbhEJP44 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 10 May 2021 11:56:56 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:25060 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230492AbhEJP4y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 11:56:54 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-Dv24lgUpNayROI3ptof5aQ-1; Mon, 10 May 2021 11:55:44 -0400
X-MC-Unique: Dv24lgUpNayROI3ptof5aQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 537B3100A61E;
        Mon, 10 May 2021 15:55:43 +0000 (UTC)
Received: from bahia.redhat.com (ovpn-112-152.ams2.redhat.com [10.36.112.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D638819C44;
        Mon, 10 May 2021 15:55:40 +0000 (UTC)
From:   Greg Kurz <groug@kaod.org>
To:     qemu-devel@nongnu.org
Cc:     Vivek Goyal <vgoyal@redhat.com>, virtio-fs@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>, Greg Kurz <groug@kaod.org>
Subject: [for-6.1 v3 0/3] virtiofsd: Add support for FUSE_SYNCFS request
Date:   Mon, 10 May 2021 17:55:36 +0200
Message-Id: <20210510155539.998747-1-groug@kaod.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=groug@kaod.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kaod.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

FUSE_SYNCFS allows the client to flush the host page cache.
This isn't available in upstream linux yet, but the following
tree can be used to test:

https://gitlab.com/gkurz/linux/-/tree/virtio-fs-sync

v3: - track submounts and do per-submount syncfs() (Vivek)
    - based on new version of FUSE_SYNCFS (still not upstream)
      https://listman.redhat.com/archives/virtio-fs/2021-May/msg00025.html

v2: - based on new version of FUSE_SYNCFS
      https://listman.redhat.com/archives/virtio-fs/2021-April/msg00166.html
    - propagate syncfs() errors to client (Vivek)

Greg Kurz (3):
  Update linux headers to 5.13-rc1 + FUSE_SYNCFS
  virtiofsd: Track mounts
  virtiofsd: Add support for FUSE_SYNCFS request

 .../infiniband/hw/vmw_pvrdma/pvrdma_verbs.h   |  35 -
 include/standard-headers/drm/drm_fourcc.h     |  23 +-
 include/standard-headers/linux/ethtool.h      | 109 ++-
 include/standard-headers/linux/fuse.h         |  27 +-
 include/standard-headers/linux/input.h        |   2 +-
 include/standard-headers/linux/virtio_ids.h   |   2 +
 .../standard-headers/rdma/vmw_pvrdma-abi.h    |   7 +
 linux-headers/asm-generic/unistd.h            |  13 +-
 linux-headers/asm-mips/unistd_n32.h           | 752 +++++++--------
 linux-headers/asm-mips/unistd_n64.h           | 704 +++++++-------
 linux-headers/asm-mips/unistd_o32.h           | 844 ++++++++---------
 linux-headers/asm-powerpc/kvm.h               |   2 +
 linux-headers/asm-powerpc/unistd_32.h         | 857 +++++++++---------
 linux-headers/asm-powerpc/unistd_64.h         | 801 ++++++++--------
 linux-headers/asm-s390/unistd_32.h            |   5 +
 linux-headers/asm-s390/unistd_64.h            |   5 +
 linux-headers/asm-x86/kvm.h                   |   1 +
 linux-headers/asm-x86/unistd_32.h             |   5 +
 linux-headers/asm-x86/unistd_64.h             |   5 +
 linux-headers/asm-x86/unistd_x32.h            |   5 +
 linux-headers/linux/kvm.h                     | 134 +++
 linux-headers/linux/userfaultfd.h             |  36 +-
 linux-headers/linux/vfio.h                    |  35 +
 tools/virtiofsd/fuse_lowlevel.c               |  11 +
 tools/virtiofsd/fuse_lowlevel.h               |  12 +
 tools/virtiofsd/passthrough_ll.c              |  80 +-
 tools/virtiofsd/passthrough_seccomp.c         |   1 +
 27 files changed, 2465 insertions(+), 2048 deletions(-)

-- 
2.26.3


