Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E82E4D4D27
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 16:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343593AbiCJPHY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 10:07:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344060AbiCJPGy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 10:06:54 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F37DB19D741
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 06:56:30 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3CD611692;
        Thu, 10 Mar 2022 06:56:05 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 42DB83F7B4;
        Thu, 10 Mar 2022 06:56:04 -0800 (PST)
Date:   Thu, 10 Mar 2022 14:56:30 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Martin Radev <martin.b.radev@gmail.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, andre.przywara@arm.com
Subject: Re: [PATCH v2 kvmtool 0/5] Fix few small issues in virtio code
Message-ID: <YioRnsym4HmOSgjl@monolith.localdoman>
References: <20220303231050.2146621-1-martin.b.radev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303231050.2146621-1-martin.b.radev@gmail.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Martin,

On Fri, Mar 04, 2022 at 01:10:45AM +0200, Martin Radev wrote:
> Hello everyone,
> 
[..]
> The Makefile change is kept in its original form because I didn't understand
> if there is an issue with it on aarch64.

I'll try to explain it better. According to this blogpost about executable
stacks [1], gcc marks the stack as executable automatically for assembly
(.S) files. C files have their stack mark as non-executable by default. If
any of the object files have the stack executable, then the resulting
binary also has the stack marked as executable (obviously).

To mark the stack as non-executable in assembly files, the empty section
.note.GNU-stack must be present in the file. This is a marking to tell
the linker that the final executable does not require an executable stack.
When the linker finds this section, it will create a PT_GNU_STACK empty
segment in the final executable. This segment tells Linux to mark the stack
as non-executable when it loads the binary.

The only assembly files that kvmtool compiles into objects are the x86
files x86/bios/entry.S and x86/bios/bios-rom.S; the other architectures are
not affected by this. I haven't found any instances where these files (and
the other files they are including) do a call/jmp to something on the
stack, so I've added the .note.GNU-Stack section to the files:

diff --git a/x86/bios/bios-rom.S b/x86/bios/bios-rom.S
index 3269ce9793ae..571029fc157e 100644
--- a/x86/bios/bios-rom.S
+++ b/x86/bios/bios-rom.S
@@ -10,3 +10,6 @@
 GLOBAL(bios_rom)
        .incbin "x86/bios/bios.bin"
 END(bios_rom)
+
+# Mark the stack as non-executable.
+.section .note.GNU-stack,"",@progbits
diff --git a/x86/bios/entry.S b/x86/bios/entry.S
index 85056e9816c4..4d5bb663a25d 100644
--- a/x86/bios/entry.S
+++ b/x86/bios/entry.S
@@ -90,3 +90,6 @@ GLOBAL(__locals)
 #include "local.S"

 END(__locals)
+
+# Mark the stack as non-executable.
+.section .note.GNU-stack,"",@progbits

which makes the final executable have a non-executable stack. Did some very
*light* testing by booting a guest, and everything looked right to me.

[1] https://www.airs.com/blog/archives/518

Thanks,
Alex

> 
> Martin Radev (5):
>   kvmtool: Add WARN_ONCE macro
>   virtio: Sanitize config accesses
>   virtio: Check for overflows in QUEUE_NOTIFY and QUEUE_SEL
>   Makefile: Mark stack as not executable
>   mmio: Sanitize addr and len
> 
>  Makefile                |  7 +++--
>  include/kvm/util.h      | 10 +++++++
>  include/kvm/virtio-9p.h |  1 +
>  include/kvm/virtio.h    |  3 ++-
>  mmio.c                  |  4 +++
>  virtio/9p.c             | 27 ++++++++++++++-----
>  virtio/balloon.c        | 10 ++++++-
>  virtio/blk.c            | 10 ++++++-
>  virtio/console.c        | 10 ++++++-
>  virtio/mmio.c           | 44 +++++++++++++++++++++++++-----
>  virtio/net.c            | 12 +++++++--
>  virtio/pci.c            | 59 ++++++++++++++++++++++++++++++++++++++---
>  virtio/rng.c            |  8 +++++-
>  virtio/scsi.c           | 10 ++++++-
>  virtio/vsock.c          | 10 ++++++-
>  15 files changed, 199 insertions(+), 26 deletions(-)
> 
> -- 
> 2.25.1
> 
