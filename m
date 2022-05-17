Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 211BE52A4B0
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 16:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348835AbiEQOWP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 10:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348833AbiEQOWJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 10:22:09 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A7F43EDF
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 07:22:08 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id t25so31620990lfg.7
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 07:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=T2Ql4EilVhMbhFlF9rltYRS/JSSzR/pII+0Y623bIJQ=;
        b=Gk7YNidWLYatOf/aKLBaHhTec33dNpoEgdTOL+ILdTijNAA/GmJXqS5ytyb2YAxiIa
         hfgnMSB0rDR4qjdAxJnKRsCQ674xfm1WRgqBIXiIpQ7HtDIE9+9R3RZjqJIraOm4UdxI
         XQL7jNju9ScDasP1z69lUrQ18ZLPPKVNsyqKZ7fYExj+WHBawJINoI+9uR0VF0SNScj4
         dlPrKzU9s+b8Edo50PvS3RYDBoMZIl+5FX+am1mg7V9FcUiICtgnooAIj2I+o2tPXve+
         SSbQSATukFRZtBFM2aeI36o+M4SQHp0p7l8eF1hmotZrvOWBDoCAf1k/3UUQ6cnggpm2
         kpTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=T2Ql4EilVhMbhFlF9rltYRS/JSSzR/pII+0Y623bIJQ=;
        b=m1m4obgr+3bD9GbfNIvLEHgTk9YFko4yFUmUS/X5bDZAO5AczOixBWJWUQNjqoe5SY
         36RacoiiRcXsh+6jjZcwwNTivBACZZ5f/tADyQVE4DxQmjj/MeXXFuz8YzOt8mpDBgLA
         kmRxhUngfAJAMyLCuJElQd0GYkP8jJM/RXonFPKppSYwqimszju9Tmx4dGKRwpNVk1kd
         8KfdXA/F7nsTpqRzE3BQfKSanUDMdeIl1IiNCe0hziNa0bJGZ4MK5TKju72rd5Ug9pZn
         3Q94PtYPg5j+rghNDKFN2YAD3XqHCX/pK/uf71O+FgSS8C4H1rv8iev4omrFlx6sPsD8
         yCKw==
X-Gm-Message-State: AOAM5335VwD3DrfsuxrkM1aGucBgSg64NnJd93KKb4CJD3k9WbbLCZVn
        TvUryC0HOIKPMIgwCInTLnLErFiTM1uAmsEhFsn0lABRIb1lLQ==
X-Google-Smtp-Source: ABdhPJxU70twrYvV99BRKE7BN7aWUXU/yX8gl5Q+SHWUUrCOyVCx1gwVZN4u/j/zYTKMl192esKzFhVbCtswbHnaW9M=
X-Received: by 2002:ac2:4c54:0:b0:473:a414:1768 with SMTP id
 o20-20020ac24c54000000b00473a4141768mr16880377lfk.537.1652797326336; Tue, 17
 May 2022 07:22:06 -0700 (PDT)
MIME-Version: 1.0
From:   Gernot Poerner <gernot.poerner@gmail.com>
Date:   Tue, 17 May 2022 16:21:55 +0200
Message-ID: <CAKkmiEn2kWRWHcJv2j0Vh_VCugdKvGkApXWF3_mfBe9R++7YNg@mail.gmail.com>
Subject: Possible virtio bug, ideas needed
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi list,

I hope this is the right place to ask - if not please show me a better
place to submit this.

I am facing a problem with the virtio network driver which we were not
able to resolve yet
so I'm now pretty convinced now that this is really a bug.

Thing is - I cannot "make it fail" in a reproducable way in our
environment but it happens pretty
regularly, always with the same effect. Also, since it happens on
production Vms the need to
get them working again is pretty high.
I have set up a new cluster lately where it happens more often then in
the "standard"
environment so I was at least able to dig a bit deeper into it and do
some more tests.

The environment is a ganeti cluster running qemu-kvm as the
hypervisor. The underlying
Hardware is 64Bit X86 Intel with Mellanox network adapters (Connect-X
4 & 5). The vms are
connected via tap interfaces to a linux brige on the host nodes. I am
using both regular vlans
and vxlan (happens in both environments.)
The host and guest OS is Debian 10 Buster, running the same kernel
from backports (currently 5.10.0-0.bpo.12-amd64)

After a seemingly random time, Vms suddenly get inaccessible over the
network. A reboot
fixes it (soft or hard, doesn't matter), also a Vm migration fixes it.

When looking at the traffic with tcpdump, the problem seems to be the incoming
queue of the eth0 adapter inside the VM doesn't recieve any packets anymore.

All other hops see all the packets, including request (arp) of the
broken VM. The answers
reach the tap interface but get dropped on their way to eth0.
Since even arp doesn't work anymore, the VM is then dead in the water.
The interface
still has a link, there are no log entires or anything useful in dmesg.

Things I already veriefied and tried:

- made sure it's not any kind of mac address conflict
- there are no iptables/ebtables involved anywhere
- ifdown/ifup eth0 inside the VM has no effect
- there is no qos/traffic control involved on the host node
- we upgraded the kernel on the host nodes and vms (from Debian 10s
4.19 standard to the current 5.10) - no change
- we upgraded qemu-kvm from 5.4 to 7.0 - no change
- we tested self compiled kernel 5.15 and even 5.18 rc 7 on the VMs - no change
- we upgraded the firmware on the Mellanox adapters - no change
- we disabled any offloads on the virtual interface - no change
- I even thought about a very far fetched idea regarding pause frames
but am pretty sure that is not the case here
- in addition to a reboot or migration, what fixes it is to do ifdown
eth0, rmmod virtio_net, modprobe virtio_net, ifup eth0
- this finally convinced me that it probably is something with the virtio driver
- it seems to happen only on high traffic Vms, although it's possible
it would happen on others too if they reached some kind of
uptime/amount of network traffic
- the amount of traffic passed on the eth interface seems pretty
different between similar vms which got hit

I am now at some kind of dead end and have no real idea what I could
further do, besides asking and maybe
creating a bug report.
I would be especially interested in any kind of idea or tip on which
counters or proc entries I could watch
or what could be done to do even deeper debugging when the issue
occurs. I can give many more details if needed
too.

Any hints or help would be greatly appreciated.

G
