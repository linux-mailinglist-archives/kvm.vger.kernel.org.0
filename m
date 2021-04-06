Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F74355CD3
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 22:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbhDFU0w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 16:26:52 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:35871 "EHLO isrv.corpit.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231339AbhDFU0v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 16:26:51 -0400
X-Greylist: delayed 539 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Apr 2021 16:26:51 EDT
Received: from tsrv.corpit.ru (tsrv.tls.msk.ru [192.168.177.2])
        by isrv.corpit.ru (Postfix) with ESMTP id 24487402A3;
        Tue,  6 Apr 2021 23:17:42 +0300 (MSK)
Received: from [192.168.177.130] (mjt.wg.tls.msk.ru [192.168.177.130])
        by tsrv.corpit.ru (Postfix) with ESMTP id 0529521E;
        Tue,  6 Apr 2021 23:17:41 +0300 (MSK)
To:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>
From:   Michael Tokarev <mjt@tls.msk.ru>
Subject: Commit "x86/kvm: Move context tracking where it belongs" broke guest
 time accounting
Message-ID: <36088364-0b3d-d492-0aa4-59ea8f1d1632@msgid.tls.msk.ru>
Date:   Tue, 6 Apr 2021 23:17:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!

It looks like this commit:

commit 87fa7f3e98a1310ef1ac1900e7ee7f9610a038bc
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Wed Jul 8 21:51:54 2020 +0200

     x86/kvm: Move context tracking where it belongs

     Context tracking for KVM happens way too early in the vcpu_run()
     code. Anything after guest_enter_irqoff() and before guest_exit_irqoff()
     cannot use RCU and should also be not instrumented.

     The current way of doing this covers way too much code. Move it closer to
     the actual vmenter/exit code.

broke kvm guest cpu time accounting - after this commit, when running
qemu-system-x86_64 -enable-kvm, the guest time (in /proc/stat and
elsewhere) is always 0.

I dunno why it happened, but it happened, and all kernels after 5.9
are affected by this.

This commit is found in a (painful) git bisect between kernel 5.8 and 5.10.

Thanks,

/mjt
