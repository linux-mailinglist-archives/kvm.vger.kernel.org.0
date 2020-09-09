Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF52262CE3
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 12:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgIIKMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 06:12:17 -0400
Received: from forward104p.mail.yandex.net ([77.88.28.107]:48917 "EHLO
        forward104p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725917AbgIIKMR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Sep 2020 06:12:17 -0400
X-Greylist: delayed 437 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Sep 2020 06:12:16 EDT
Received: from mxback28o.mail.yandex.net (mxback28o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::79])
        by forward104p.mail.yandex.net (Yandex) with ESMTP id D811D4B01330;
        Wed,  9 Sep 2020 13:04:47 +0300 (MSK)
Received: from iva1-bc1861525829.qloud-c.yandex.net (iva1-bc1861525829.qloud-c.yandex.net [2a02:6b8:c0c:a0e:0:640:bc18:6152])
        by mxback28o.mail.yandex.net (mxback/Yandex) with ESMTP id BKj4cjSxDD-4lhqBAfQ;
        Wed, 09 Sep 2020 13:04:47 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1599645887;
        bh=/mSNeznE4L7L7lRZHTXFGApgkNhi/uDA8BA12Xr9AHU=;
        h=Cc:Subject:From:To:Date:Message-ID;
        b=vxq1iwbYpo0ji0alA4i5xgT9FqEkOYZKD3zsBQJwqotDYN2j9Xyc6UXG9pRjacRgd
         mBivQPUJ0liClxxl7IAlnY8xhaBwiPvtpaURagQMdxYvcgxq0ybI2uH85Uox9eQHb6
         tSfkd+SqQWd2OR9H6u5zC4rDlKtqm0VX7vYCI1rQ=
Authentication-Results: mxback28o.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by iva1-bc1861525829.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id Vdl32a8ppf-4lHS46qW;
        Wed, 09 Sep 2020 13:04:47 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
To:     kvm@vger.kernel.org
From:   stsp <stsp2@yandex.ru>
Subject: KVM_SET_SREGS & cr4.VMXE problems
Cc:     Andy Lutomirski <luto@amacapital.net>
Message-ID: <8f0d9048-c935-bccf-f7bd-58ba61759a54@yandex.ru>
Date:   Wed, 9 Sep 2020 13:04:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Guys!

I have a kvm-based hypervisor, and
also I have problems with how KVM
handles cr4.VMXE flag.

Problem 1 can be shown as follows.

The below snippet WORKS as expected:
---
     sregs.cr4 |= X86_CR4_VMXE;
     ret = ioctl(vcpufd, KVM_SET_SREGS, &sregs);
     if (ret == -1) {
       perror("KVM: KVM_SET_SREGS");
       leavedos(99);
     }
---

The below one doesn't:
---
     ret = ioctl(vcpufd, KVM_SET_SREGS, &sregs);
     if (ret == -1) {
       perror("KVM: KVM_SET_SREGS");
       leavedos(99);
     }
     sregs.cr4 |= X86_CR4_VMXE;
     ret = ioctl(vcpufd, KVM_SET_SREGS, &sregs);
     if (ret == -1) {
       perror("KVM: KVM_SET_SREGS");
       leavedos(99);
     }
---


Basically that example demonstrates that
I can set VMXE flag only by the very first
call to KVM_SET_SREGS. Any subsequent
calls do not allow me to modify VMXE flag,
even though no error is returned, and
other flags are modified, if needed, as
expected, but not this one.
Is there any reason why VMXE flag is
"locked" to its very first setting?


Problem 2:
If I set both VME and VMXE flags
(by the very first invocation of KVM_SET_SREGS,
yes), then VME flag does not actually
work. My hypervisor then runs in non-VME
mode.
Is it KVM that clears the VME flag when
VMXE is set, or is it really not a workable
combination of flags?

Problem 3.
Some older Intel CPUs appear to require
the VMXE flag even in non-root VMX.
This is vaguely documented in an Intel
specs:
---
The first processors to support VMX operation require that the
following bits be 1 in VMX operation: CR0.PE, CR0.NE, CR0.PG, and CR4.VMXE.
---

They are not explicit about a non-root
mode, but my experiments show they
meant exactly that. On such CPUs, KVM
otherwise returns KVM_EXIT_FAIL_ENTRY,
"invalid guest state".
Question: did they really mean non-root,
and if so - shouldn't KVM itself work around
such quirks? I wouldn't mind enabling
VMXE myself, if not for the Problem 2 above,
that just disables VME then.
Can KVM be somehow "fixed" to not require
all these dancing, or is there a better ways
of fixing that problem?



Thanks!

