Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59546651126
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 18:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbiLSRTs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 12:19:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbiLSRT2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 12:19:28 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB4EAE7B
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 09:19:27 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id 67-20020a621946000000b00575f8210320so5329316pfz.10
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 09:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u1OxrZzOIajVGZwkXAPogH/ue04ueQgByOpRB200gSU=;
        b=RrzqGferbVNclkVYmMFvgCACtExupzd+zXKlb6mqsno4S/mJv3bQ7LCh29DMgCaVEu
         2CVeVtbR98sVzCFZ2PrSeFfDjxBsanG7unC6LTZ7Pvf17Vx8sM/YNe1dVT1DS32UDOfh
         hteFFn+helbDlE1Cubk5wDLAOGDZTao2EiDVP5kj+BdQOCHaKmFNXcNu8HKZCtnL9iyX
         UvcOAjulhbrTLhfQXqDGVd6ILFbWZpvYCOcYGraPxPkQ5N8U1+IGg20DKKAkhwCg15pi
         vN8zy17Y1pJ978V2ET2wigwRRg4poqTNOFZW76ogCRe/tD9RrpOZq/XyQhTz3HV37t5n
         N0tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=u1OxrZzOIajVGZwkXAPogH/ue04ueQgByOpRB200gSU=;
        b=3Xhmi0OEkA0OvTAn2u80ZW1/pxyN/VSspMZ8iFUqRXdM2W9lHpJniwv55f3ZRxPTyj
         HudM/780+XMNgE5VyO6wDE+3qM6cVTwHJnimnfdO9HKwg0eOrGy6GnOe8mxYEVQuhYFy
         lLY5j4AmQPdOfHK0xDVFduIgK9RZvE7vurt0fN9n2AkvN5ZN9u431wiR8ZI+sVgGLP/j
         9hIHMEaRYTowhgz/cjSL8UP2k4bFLZlCfiryrVX6AEcQRcVvbldpCv30ciepQljOyH1K
         k2cNOZwObSLHanK62/BAXo+FnaeBYNQE/wEyTaNgqqgZkvf50de0nJxj1Gr1cMDmBiGe
         +86w==
X-Gm-Message-State: ANoB5pmhvZf146L+Tg2h6Xow/Wzg79SNc/M7QGcytGMH1ACihxNR8yc3
        wIuqXtaAiJHUNLzyuzzPjWrv+chjcnA=
X-Google-Smtp-Source: AA0mqf47iFBIWrLHBVtRlKfWtlwfs4338UwzR9+snJh/ddN8hNpdi0zwWP4rl94BM9iTNW8RowDHx1ocEik=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:cf02:b0:189:d193:95e7 with SMTP id
 i2-20020a170902cf0200b00189d19395e7mr21663279plg.1.1671470367133; Mon, 19 Dec
 2022 09:19:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 19 Dec 2022 17:19:24 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221219171924.67989-1-seanjc@google.com>
Subject: [PATCH] KVM: Destroy target device if coalesced MMIO unregistration fails
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "=?UTF-8?q?=E6=9F=B3=E8=8F=81=E5=B3=B0?=" <liujingfeng@qianxin.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Destroy and free the target coalesced MMIO device if unregistering said
device fails.  As clearly noted in the code, kvm_io_bus_unregister_dev()
does not destroy the target device.

  BUG: memory leak
  unreferenced object 0xffff888112a54880 (size 64):
    comm "syz-executor.2", pid 5258, jiffies 4297861402 (age 14.129s)
    hex dump (first 32 bytes):
      38 c7 67 15 00 c9 ff ff 38 c7 67 15 00 c9 ff ff  8.g.....8.g.....
      e0 c7 e1 83 ff ff ff ff 00 30 67 15 00 c9 ff ff  .........0g.....
    backtrace:
      [<0000000006995a8a>] kmalloc include/linux/slab.h:556 [inline]
      [<0000000006995a8a>] kzalloc include/linux/slab.h:690 [inline]
      [<0000000006995a8a>] kvm_vm_ioctl_register_coalesced_mmio+0x8e/0x3d0 =
arch/x86/kvm/../../../virt/kvm/coalesced_mmio.c:150
      [<00000000022550c2>] kvm_vm_ioctl+0x47d/0x1600 arch/x86/kvm/../../../=
virt/kvm/kvm_main.c:3323
      [<000000008a75102f>] vfs_ioctl fs/ioctl.c:46 [inline]
      [<000000008a75102f>] file_ioctl fs/ioctl.c:509 [inline]
      [<000000008a75102f>] do_vfs_ioctl+0xbab/0x1160 fs/ioctl.c:696
      [<0000000080e3f669>] ksys_ioctl+0x76/0xa0 fs/ioctl.c:713
      [<0000000059ef4888>] __do_sys_ioctl fs/ioctl.c:720 [inline]
      [<0000000059ef4888>] __se_sys_ioctl fs/ioctl.c:718 [inline]
      [<0000000059ef4888>] __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:718
      [<000000006444fa05>] do_syscall_64+0x9f/0x4e0 arch/x86/entry/common.c=
:290
      [<000000009a4ed50b>] entry_SYSCALL_64_after_hwframe+0x49/0xbe

  BUG: leak checking failed

Fixes: 5d3c4c79384a ("KVM: Stop looking for coalesced MMIO zones if the bus=
 is destroyed")
Cc: stable@vger.kernel.org
Reported-by: =E6=9F=B3=E8=8F=81=E5=B3=B0 <liujingfeng@qianxin.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/coalesced_mmio.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 0be80c213f7f..5ef88f5a0864 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -187,15 +187,17 @@ int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm=
 *kvm,
 			r =3D kvm_io_bus_unregister_dev(kvm,
 				zone->pio ? KVM_PIO_BUS : KVM_MMIO_BUS, &dev->dev);
=20
+			kvm_iodevice_destructor(&dev->dev);
+
 			/*
 			 * On failure, unregister destroys all devices on the
 			 * bus _except_ the target device, i.e. coalesced_zones
-			 * has been modified.  No need to restart the walk as
-			 * there aren't any zones left.
+			 * has been modified.  Bail after destroying the target
+			 * device, there's no need to restart the walk as there
+			 * aren't any zones left.
 			 */
 			if (r)
 				break;
-			kvm_iodevice_destructor(&dev->dev);
 		}
 	}
=20

base-commit: 9d75a3251adfbcf444681474511b58042a364863
--=20
2.39.0.314.g84b9a713c41-goog

