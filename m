Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2F0B4A46A
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 16:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729702AbfFROtP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 10:49:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53224 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729050AbfFROtO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 10:49:14 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1CB33308338E;
        Tue, 18 Jun 2019 14:49:14 +0000 (UTC)
Received: from redhat.com (ovpn-116-120.ams2.redhat.com [10.36.116.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C0B81001DF3;
        Tue, 18 Jun 2019 14:49:12 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: KVM call minutes for 2019-06-18
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Tue, 18 Jun 2019 16:49:10 +0200
Message-ID: <87d0jb9cex.fsf@trasno.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Tue, 18 Jun 2019 14:49:14 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi

This are the random notes that I took about today community call.
Please review and add anything that you consider relevant.



Multiprocess qemu

Overview
- qemu (basically) runs as a single process
- emulates several devices
- the idea is to run the device emulations in a different process
- QMP/HMP/... still on main process
- rest of devices are going to be in external process
- idea is to reduce priviledge for each process
- questions?
  * how much work is going to be to integrate changes after this
  * most of the changes are new code with proxy objects
  * will not be changes to existing models
  * don't require all emulation run in remote process
  * device backends are run fully on the emulation process
  * leveraging virtio user model
  * expect DMA and IRQ like virtio user
* QEMU assumes that several things have global state
* migration/notifiers/...
* QEMU is able to DMA from one device to other device directly, with multiprocess is difficult
* How to get that global assumptions
* patches already quite big and only do one device so far
* Kevin is experimenthing with an external qemu-storage daemon
* qemu-storage daemon vs process for each image
  * compromise: less isolation but easier to do
* i.e. just doing the full subsystem instead of each device
* multiprocess:
  * devices shouldn't have to be changed, it is the same code that inside qemu
* TCG never claim any security
* qemu: command line and device interface and QMP
  good solotion for QMP, but for the rest
* libvirt/management app will launch the remote devices and just handle fd's to qemu
* When we launch qemu
  qemu needs to know the "proxied" devices through the command line
  move everything to QMP and don't even pass the command line
  spcially don't pass the commandline from qemu to processes
* Any quesntion about how the bus/device are presented?
* why don't use only nemu + virtio?
  nemu and virtio don't handle legacy devices
* cpu usage from multiprocess?
  how much cpu fro the same amount of IOPs:  current implementation use around 9-10% more cpu cycles
  but there are optimizations that could reduce it further
* multiprocess mmio
  create a kernel fd for each multiprocess and decide at device creation time if that range is
  going to be handled by the main qemu or another process.  Something like vhost-user.
  This is an optimizaton, not implemented yet.
* Why do they need legacy?
  Because they are not anly bringing new VM's, also legacy VM's (specially windows).
* Is worth this for legacy?
  Or just enable it for new/modern guests.
* How invasive is this?
  it is important to decide how much security/isolation it brings vs the amount of invasive things
  How much do we gain from using seccomp + unpriviledged qemu + ....
* Discussion about if it makes sense the change
  Does it bring enough new isolation to qemu

Thanks, Juan.
