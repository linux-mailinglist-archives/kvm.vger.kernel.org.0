Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28FBD24904
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 09:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbfEUHdV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 May 2019 03:33:21 -0400
Received: from smtp.lucina.net ([62.176.169.44]:59506 "EHLO smtp.lucina.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbfEUHdU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 May 2019 03:33:20 -0400
X-Greylist: delayed 525 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 May 2019 03:33:20 EDT
Received: from nodbug.lucina.net (188-167-250-119.dynamic.chello.sk [188.167.250.119])
        by smtp.lucina.net (Postfix) with ESMTPSA id 739D2122804
        for <kvm@vger.kernel.org>; Tue, 21 May 2019 09:24:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lucina.net;
        s=dkim-201811; t=1558423474;
        bh=lHVulHQV4hVDwBbMHDiDM+CX7vfJtx9zPkWnutH4c8E=;
        h=Date:From:To:Subject:From;
        b=F0J4iT8FWvpi7Bm+FNdZZbeUlTt7YC6nldhbIaLU6+EZ4mFrYrG57gaPR6bDOT+pn
         e2xrivmYguP2fy0//Kfpd2yDPDeA8u5Vp+mSGn8jbkdQyqXxgBj/pGWVRzPrZ3e8xE
         qxiydPDMZ40/O71OBWMLh50cFODxgLTh0NZF/VtoD1fokgdCuZK488FAD6qTXs2ZPb
         UWyaKw5QR5Le4OVgWJpRfdu+CcYjCiOrxIm0cWiX+JnEajrT8liNhDtNi8ORVnSuUy
         THD9mtu3iWwF7aXk7MDIF1dlP/8f+6GZg6p4KqDIAlsg6eNlh8KkSTeuNwn/8rgCwI
         U2KjFNrdWsshg==
Received: by nodbug.lucina.net (Postfix, from userid 1000)
        id 2F565268437A; Tue, 21 May 2019 09:24:34 +0200 (CEST)
Date:   Tue, 21 May 2019 09:24:34 +0200
From:   Martin Lucina <martin@lucina.net>
To:     kvm@vger.kernel.org
Subject: Interaction between host-side mprotect() and KVM MMU
Message-ID: <20190521072434.p4rtnbkerk5jqwh4@nodbug.lucina.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

as part of an effort to enforce W^X for the KVM backend of Solo5 [1], I'm
trying to understand how host-side mprotect() interacts with the KVM MMU.

Take a KVM guest on x86_64, where the guest runs exclusively in long mode,
in virtual ring 0, using 1:1 2MB pages in the guest, and all guest page
tables are RWX, i.e. no memory protection is enforced inside the guest
itself. EPT is enabled on the host.

Instead, our ELF loader applies a host-side mprotect(PROT_...) based on the
protection bits in the guest application (unikernel) ELF PHDRs.

The observed behaviour I see, from tests run inside the guest:

1. Attempting to WRITE to .text which has had mprotect(PROT_READ |
PROT_EXEC) applied on the host side results in a EFAULT from KVM_RUN in the
userspace tender (our equivalent of a VMM).

2. Attempting to EXECUTE code in .data which has had mprotect(PROT_READ |
PROT_WRITE) applied on the host side succeeds.

Questions:

a. Is this the intended behaviour, and can it be relied on? Note that
KVM/aarch64 behaves the same for me.

b. Why does case (1) fail but case (2) succeed? I spent a day reading
through the KVM MMU code, but failed to understand how this is implemented.

c. In order to enforce W^X both ways I'd like to have case (2) also fail
with EFAULT, is this possible?

Martin

[1] https://github.com/Solo5/solo5
