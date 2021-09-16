Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F1C40D0D5
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 02:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbhIPAar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 20:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbhIPAar (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 20:30:47 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D64AC061574
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 17:29:27 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id m3so9561468lfu.2
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 17:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=NOfNAXzWn2iNMFgc8Qpag7WikiQmaWSgLADwLsaraKM=;
        b=RqJG0j4GgjA7iI5CRivFjxgbuCf+nP9u6xFAid3MlHdwlJfMudK0KpCKrxLZ46SBF7
         rR5Vv3JvutAmBd6dJV4KYYjyILZf1+cNUzjIJX9XLzWwru9Y7HMr9B5A6MaW/DVheSPq
         wOUccdkk1ReUK5OuUxblX6p/WONbNKE3Bwmohaap8nkKokoiMDW3tJbA/hzOLc/KLKmk
         MBMQxdhe6TMSweVLXHoPiZEjz3irSeD5CruoOLqnu9htDp8hYnQYwRJI+/xonst3P9hV
         ZbmvXOL0Ti/meQZXHNE8K+6vZ27OUQsMLhpSabGxzYo+bQ5ofNUd1iPHt526ThdPhxeg
         iUgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=NOfNAXzWn2iNMFgc8Qpag7WikiQmaWSgLADwLsaraKM=;
        b=km3eXgxGcKTvTqLecO7Xzu8lkq8yZ9LkuZb3ufoy4fw56oDD6hh6i7Qwl+KL89JykY
         wLAXqb5iIjvpTeAEY6E7YPlYwUaO8uYmdJyAI+FtDF3jR0PVY+o3z8XKbQzVKHMh/DWZ
         UCCG8YdVFSY6gbUrj4/ZprJSHATrJejfsNJqdUIVvOJnyL9gNd1kkpUZJdCE7FHRlW+U
         Lqn6kf0VCdLATx9lW2SPab/qk7Qb+YznNiUWxzHIcHTbDBFjfGJvx4y/jQ1EksZ2IzUP
         PdNFE7PdVoQzr31NNrx6BGqaReIyt95qaCkY7vcqvOr1yhw+thuD55ssso03hiVvbn0p
         KvsQ==
X-Gm-Message-State: AOAM531IilPXs2dEmXKQwYOyKOi9mXCR5HclJ4fuCfhVG3B+7k1Y5L6w
        TA1ZHhf/7bGOugO8foUdpZO1qATb8+S/9zuNnA4mcUbqU08=
X-Google-Smtp-Source: ABdhPJyrwCXvXHPsKxmnmZxnhio6nxknVnpzxlDURWvBK+RSSf7n9cThp6ilakysgV6ZySlBFsadYLOS0t0RO1aBjDI=
X-Received: by 2002:a2e:a4ca:: with SMTP id p10mr2394120ljm.415.1631752165357;
 Wed, 15 Sep 2021 17:29:25 -0700 (PDT)
MIME-Version: 1.0
From:   Bill Sherwood <bsherwood218@gmail.com>
Date:   Wed, 15 Sep 2021 20:29:12 -0400
Message-ID: <CA+Pe=gchWL+f1xuVCDgJADoTn6gtG58UUKyyRrjc+JrpgjovgQ@mail.gmail.com>
Subject: Windows guests become unresponsive and display black screen in VNC
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Host is Ubuntu 20.04 - 5.4.0-26-generic

KVM is 1:4.2-3ubuntu6.17

Guest OS -- various flavors of Windows 2012 server or greater

Symptom:   Guests will appear to be running fine for some time (hours
or days), occasionally a perfectly running guest will "lock up" and
become unresponsive to network, VNC, etc..   We are unable to access
the VM and the only resort is to destroy the VM - shutdown will not
tear down the VM.

Looking at a number of things, we can see the following via trace_pipe
-- nothing else is emitted while in the hung state.

 cat /sys/kernel/debug/tracing/trace_pipe | grep -i <pid>

.....

 <...>-3441924 [004] .... 1907374.582975: kvm_set_irq: gsi 0 level 1 source 0
           <...>-3441924 [004] .... 1907374.582977: kvm_pic_set_irq:
chip 0 pin 0 (edge|masked)
           <...>-3441924 [004] .... 1907374.582979:
kvm_apic_accept_irq: apicid 0 vec 209 (Fixed|edge)
           <...>-3441924 [004] .... 1907374.582981:
kvm_ioapic_set_irq: pin 2 dst 1 vec 209 (Fixed|logical|edge)
           <...>-3441924 [004] .... 1907374.582983: kvm_set_irq: gsi 0
level 0 source 0
           <...>-3441924 [004] .... 1907374.582984: kvm_pic_set_irq:
chip 0 pin 0 (edge|masked)
           <...>-3441924 [004] .... 1907374.582984:
kvm_ioapic_set_irq: pin 2 dst 1 vec 209 (Fixed|logical|edge)
           <...>-3441924 [004] .... 1907374.583457: kvm_set_irq: gsi 0
level 1 source 0
           <...>-3441924 [004] .... 1907374.583459: kvm_pic_set_irq:
chip 0 pin 0 (edge|masked)
           <...>-3441924 [004] .... 1907374.583461:
kvm_apic_accept_irq: apicid 0 vec 209 (Fixed|edge)
           <...>-3441924 [004] .... 1907374.583462:
kvm_ioapic_set_irq: pin 2 dst 1 vec 209 (Fixed|logical|edge)
           <...>-3441924 [004] .... 1907374.583464: kvm_set_irq: gsi 0
level 0 source 0
.....


----------------------


Strace (15 second) output:

 55.39    0.082181          16      4937           ioctl
 23.05    0.034208          14      2390           ppoll
 21.56    0.031990          13      2379           futex
  0.00    0.000001           0        30           read
------ ----------- ----------- --------- --------- ----------------
100.00    0.148380                  9736           total


-----------------------

KVM stat live output:

        APIC_ACCESS      11491    44.50%     5.12%      1.82us
5021.41us      9.41us ( +-   9.87% )
       EPT_MISCONFIG       8007    31.01%    17.51%     11.25us
11003.56us     46.18us ( +-   8.59% )
                 HLT       3804    14.73%    76.26%      2.19us
3962.04us    423.30us ( +-   0.44% )
  EXTERNAL_INTERRUPT       2492     9.65%     0.46%      0.96us
163.72us      3.91us ( +-   4.36% )
   PAUSE_INSTRUCTION         14     0.05%     0.00%      1.24us
6.59us      3.40us ( +-  14.61% )
      IO_INSTRUCTION          8     0.03%     0.64%      8.34us
13470.05us   1693.58us ( +-  99.34% )
   PENDING_INTERRUPT          3     0.01%     0.00%      2.31us
3.69us      2.99us ( +-  13.36% )
       EPT_VIOLATION          2     0.01%     0.00%      7.74us
9.37us      8.56us ( +-   9.51% )
       EXCEPTION_NMI          1     0.00%     0.00%      3.09us
3.09us      3.09us ( +-   0.00% )
 TPR_BELOW_THRESHOLD          1     0.00%     0.00%      2.39us
2.39us      2.39us ( +-   0.00% )


We have tried quite a few of the HyperV enlightenments and clock
settings and those do not resolve the issue

We can reproduce the issue by stopping all guests(7) on the host and
starting them up at the same time - this may take a couple of
cycles(2-3) en-masse restarts and 1 or 2 out of the 7 will exhibit
this behavior


CPU is host-passthrough
Server has 24 cores with 256G of ram


Looking to see if anyone in the community has encountered this problem.

Thanks
Bill
