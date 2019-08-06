Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE686833C8
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 16:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732981AbfHFOSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 10:18:41 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:46724 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728756AbfHFOSl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 10:18:41 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 6 Aug 2019 17:18:38 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x76EIa7h019368;
        Tue, 6 Aug 2019 17:18:36 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     kvm@vger.kernel.org, wankhede@nvidia.com,
        linux-kernel@vger.kernel.org
Cc:     parav@mellanox.com, alex.williamson@redhat.com, cohuck@redhat.com,
        cjia@nvidia.com
Subject: [PATCH v1 0/2] Simplify mtty driver and mdev core
Date:   Tue,  6 Aug 2019 09:18:24 -0500
Message-Id: <20190806141826.52712-1-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190802065905.45239-1-parav@mellanox.com>
References: <20190802065905.45239-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently mtty sample driver uses mdev state and UUID in convoluated way to
generate an interrupt.
It uses several translations from mdev_state to mdev_device to mdev uuid.
After which it does linear search of long uuid comparision to
find out mdev_state in mtty_trigger_interrupt().
mdev_state is already available while generating interrupt from which all
such translations are done to reach back to mdev_state.

This translations are done during interrupt generation path.
This is unnecessary and reduandant.

Hence,
Patch-1 simplifies mtty sample driver to directly use mdev_state.

Patch-2, Since no production driver uses mdev_uuid() and mdev's name
(derived from UUID) is already available using core kernel dev_name(),
this patch simplifies and removes redandant mdev_uuid() exported symbol.

Parav Pandit (2):
  vfio-mdev/mtty: Simplify interrupt generation
  vfio/mdev: Removed unused and redundant API for mdev UUID

 drivers/vfio/mdev/mdev_core.c |  6 ------
 include/linux/mdev.h          |  1 -
 samples/vfio-mdev/mtty.c      | 39 +++++++----------------------------
 3 files changed, 8 insertions(+), 38 deletions(-)

-- 
2.21.0.777.g83232e3864

