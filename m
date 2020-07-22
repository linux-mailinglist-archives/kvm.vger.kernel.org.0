Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C580C229AFF
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 17:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbgGVPJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 11:09:34 -0400
Received: from mga14.intel.com ([192.55.52.115]:33983 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726717AbgGVPJd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 11:09:33 -0400
IronPort-SDR: Ml1NjBay97GwnoP1wIeApPISk1NtazU+TINFB0U91IwPseki9ytL2LH4A0Kc3EuRJrVmlbXrPt
 yjrUXZIgYniw==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="149513597"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="149513597"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 08:09:31 -0700
IronPort-SDR: RlU5InFR7sDN5rcYvVgCLEpYmQ+Gd8aXOFnMbhPL0hxvuYvKnv3StrJqA1UIpEvc5pg372xPXs
 tzqQod9sFYFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="432407239"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu.ger.corp.intel.com) ([10.252.58.190])
  by orsmga004.jf.intel.com with ESMTP; 22 Jul 2020 08:09:28 -0700
From:   Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: [PATCH v4 0/4] Add a vhost RPMsg API
Date:   Wed, 22 Jul 2020 17:09:23 +0200
Message-Id: <20200722150927.15587-1-guennadi.liakhovetski@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Now that virtio-rpmsg endianness fixes have been merged we can 
proceed with the next step.

v4:
- add endianness conversions to comply with the VirtIO standard

v3:
- address several checkpatch warnings
- address comments from Mathieu Poirier

v2:
- update patch #5 with a correct vhost_dev_init() prototype
- drop patch #6 - it depends on a different patch, that is currently
  an RFC
- address comments from Pierre-Louis Bossart:
  * remove "default n" from Kconfig

Linux supports RPMsg over VirtIO for "remote processor" / AMP use
cases. It can however also be used for virtualisation scenarios,
e.g. when using KVM to run Linux on both the host and the guests.
This patch set adds a wrapper API to facilitate writing vhost
drivers for such RPMsg-based solutions. The first use case is an
audio DSP virtualisation project, currently under development, ready
for review and submission, available at
https://github.com/thesofproject/linux/pull/1501/commits

Thanks
Guennadi

Guennadi Liakhovetski (4):
  vhost: convert VHOST_VSOCK_SET_RUNNING to a generic ioctl
  rpmsg: move common structures and defines to headers
  rpmsg: update documentation
  vhost: add an RPMsg API

 Documentation/rpmsg.txt          |   6 +-
 drivers/rpmsg/virtio_rpmsg_bus.c |  78 +------
 drivers/vhost/Kconfig            |   7 +
 drivers/vhost/Makefile           |   3 +
 drivers/vhost/rpmsg.c            | 375 +++++++++++++++++++++++++++++++
 drivers/vhost/vhost_rpmsg.h      |  74 ++++++
 include/linux/virtio_rpmsg.h     |  83 +++++++
 include/uapi/linux/rpmsg.h       |   3 +
 include/uapi/linux/vhost.h       |   4 +-
 9 files changed, 553 insertions(+), 80 deletions(-)
 create mode 100644 drivers/vhost/rpmsg.c
 create mode 100644 drivers/vhost/vhost_rpmsg.h
 create mode 100644 include/linux/virtio_rpmsg.h

-- 
2.27.0

