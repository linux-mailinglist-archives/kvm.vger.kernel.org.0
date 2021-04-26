Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C774536B59D
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 17:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbhDZPWg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 26 Apr 2021 11:22:36 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:39725 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233573AbhDZPWf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 11:22:35 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-L4NhDlQ8OHCOCv_9G1-kuA-1; Mon, 26 Apr 2021 11:21:49 -0400
X-MC-Unique: L4NhDlQ8OHCOCv_9G1-kuA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49A9B85EE8B;
        Mon, 26 Apr 2021 15:21:48 +0000 (UTC)
Received: from bahia.redhat.com (ovpn-113-148.ams2.redhat.com [10.36.113.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40ACB60C5F;
        Mon, 26 Apr 2021 15:21:36 +0000 (UTC)
From:   Greg Kurz <groug@kaod.org>
To:     qemu-devel@nongnu.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        virtio-fs@redhat.com, Miklos Szeredi <miklos@szeredi.hu>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Greg Kurz <groug@kaod.org>
Subject: [for-6.1 v2 0/2] virtiofsd: Add support for FUSE_SYNCFS request
Date:   Mon, 26 Apr 2021 17:21:33 +0200
Message-Id: <20210426152135.842037-1-groug@kaod.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

v2: - based on new version of FUSE_SYNCFS
      https://listman.redhat.com/archives/virtio-fs/2021-April/msg00166.html
    - propagate syncfs() errors to client (Vivek)

Greg Kurz (2):
  Update linux headers to 5.12-rc8 + FUSE_SYNCFS
  virtiofsd: Add support for FUSE_SYNCFS request

 include/standard-headers/drm/drm_fourcc.h     | 23 ++++-
 include/standard-headers/linux/ethtool.h      | 54 ++++++-----
 include/standard-headers/linux/fuse.h         | 13 ++-
 include/standard-headers/linux/input.h        |  2 +-
 .../standard-headers/rdma/vmw_pvrdma-abi.h    |  7 ++
 linux-headers/asm-generic/unistd.h            |  4 +-
 linux-headers/asm-mips/unistd_n32.h           |  1 +
 linux-headers/asm-mips/unistd_n64.h           |  1 +
 linux-headers/asm-mips/unistd_o32.h           |  1 +
 linux-headers/asm-powerpc/kvm.h               |  2 +
 linux-headers/asm-powerpc/unistd_32.h         |  1 +
 linux-headers/asm-powerpc/unistd_64.h         |  1 +
 linux-headers/asm-s390/unistd_32.h            |  1 +
 linux-headers/asm-s390/unistd_64.h            |  1 +
 linux-headers/asm-x86/kvm.h                   |  1 +
 linux-headers/asm-x86/unistd_32.h             |  1 +
 linux-headers/asm-x86/unistd_64.h             |  1 +
 linux-headers/asm-x86/unistd_x32.h            |  1 +
 linux-headers/linux/kvm.h                     | 89 +++++++++++++++++++
 linux-headers/linux/vfio.h                    | 27 ++++++
 tools/virtiofsd/fuse_lowlevel.c               | 19 ++++
 tools/virtiofsd/fuse_lowlevel.h               | 13 +++
 tools/virtiofsd/passthrough_ll.c              | 29 ++++++
 tools/virtiofsd/passthrough_seccomp.c         |  1 +
 24 files changed, 267 insertions(+), 27 deletions(-)

-- 
2.26.3


