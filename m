Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4733557CB00
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 14:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbiGUM6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 08:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiGUM6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 08:58:47 -0400
X-Greylist: delayed 567 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 21 Jul 2022 05:58:46 PDT
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5360B459BE
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 05:58:46 -0700 (PDT)
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
        by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 45A2040569;
        Thu, 21 Jul 2022 14:49:15 +0200 (CEST)
Message-ID: <eb0e0c7e-5b6f-a573-43f6-bd58be243d6b@proxmox.com>
Date:   Thu, 21 Jul 2022 14:49:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
From:   Fabian Ebner <f.ebner@proxmox.com>
To:     kvm@vger.kernel.org, qemu-devel@nongnu.org
Cc:     Thomas Lamprecht <t.lamprecht@proxmox.com>,
        Mira Limbeck <m.limbeck@proxmox.com>
Subject: Guest reboot issues since QEMU 6.0 and Linux 5.11
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,
since about half a year ago, we're getting user reports about guest
reboot issues with KVM/QEMU[0].

The most common scenario is a Windows Server VM (2012R2/2016/2019,
UEFI/OVMF and SeaBIOS) getting stuck during the screen with the Windows
logo and the spinning circles after a reboot was triggered from within
the guest. Quitting the kvm process and booting with a fresh instance
works. The issue seems to become more likely, the longer the kvm
instance runs.

We did not get such reports while we were providing Linux 5.4 and QEMU
5.2.0, but we do with Linux 5.11/5.13/5.15 and QEMU 6.x.

I'm just wondering if anybody has seen this issue before or might have a
hunch what it's about? Any tips on what to look out for when debugging
are also greatly appreciated!

We do have debug access to a user's test VM and the VM state was saved
before a problematic reboot, but I can't modify the host system there.
AFAICT QEMU just executes guest code as usual, but I'm really not sure
what to look out for.

That VM has CPU type host, and a colleague did have a similar enough CPU
to load the VM state, but for him, the reboot went through normally. On
the user's system, it triggers consistently after loading the VM state
and rebooting.

So unfortunately, we didn't manage to reproduce the issue locally yet.
With two other images provided by users, we ran into a boot loop, where
QEMU resets the CPUs and does a few KVM_RUNs before the exit reason is
KVM_EXIT_SHUTDOWN (which to my understanding indicates a triple fault)
and then it repeats. It's not clear if the issues are related.

There are also a few reports about non-Windows VMs, mostly Ubuntu 20.04
with UEFI/OVMF, but again, it's not clear if the issues are related.

[0]: https://forum.proxmox.com/threads/100744/
(the forum thread is a bit chaotic unfortunately).

Best Regards,
Fabi

