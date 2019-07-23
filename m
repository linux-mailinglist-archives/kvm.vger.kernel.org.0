Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D651B713AB
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2019 10:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733039AbfGWIPL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jul 2019 04:15:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35564 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbfGWIPL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jul 2019 04:15:11 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4C086308C216;
        Tue, 23 Jul 2019 08:15:11 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 64FB760BEC;
        Tue, 23 Jul 2019 08:15:10 +0000 (UTC)
Date:   Tue, 23 Jul 2019 10:15:07 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3] x86: Support environments without
 test-devices
Message-ID: <20190723081507.vkostd7cjzxcomes@kamzik.brq.redhat.com>
References: <20190722225540.43572-1-nadav.amit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722225540.43572-1-nadav.amit@gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 23 Jul 2019 08:15:11 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 22, 2019 at 03:55:40PM -0700, Nadav Amit wrote:
> Enable to run the tests when test-device is not present (e.g.,
> bare-metal). Users can provide the number of CPUs and ram size through
> kernel parameters.
> 
> On Ubuntu that uses grub, for example, the tests can be run by copying a
> test to the boot directory (/boot) and adding a menu-entry to grub
> (e.g., by editing /etc/grub.d/40_custom):
> 
>   menuentry 'idt_test' {
> 	set root='[ROOT]'
> 	multiboot [BOOT_RELATIVE]/[TEST].flat [PARAMETERS]
> 	module params.initrd
>   }
> 
> Replace:
>   * [ROOT] with `grub-probe --target=bios_hints /boot`
>   * [BOOT_RELATIVE] with `grub-mkrelpath /boot`
>   * [TEST] with the test executed
>   * [PARAMETERS] with the test parameters
> 
> params.initrd, which would be located on the boot directory should
> describe the machine and tell the test infrastructure that a test
> device is not present and boot-loader was used (the bootloader and qemu
> deliver test . For example for a 4 core machines with 4GB of
> memory:
> 
>   NR_CPUS=4
>   MEMSIZE=4096
>   TEST_DEVICE=0
>   BOOTLOADER=1
> 
> Since we do not really use E820, using more than 4GB is likely to fail
> due to holes.
> 
> Finally, do not forget to run update-grub. Remember that the output goes
> to the serial port.
> 
> Cc: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> 
> ---
> 
> v2->v3:
>  * Adding argument to argv when bootloader is used [Andrew]
>  * Avoid unnecessary check of test-device availability [Andrew]
> 
> v1->v2:
>  * Using initrd to hold configuration override [Andrew]
>  * Adapting vmx, tscdeadline_latency not to ignore the first argument
>    on native
> ---
>  lib/argv.c      | 13 +++++++++----
>  lib/argv.h      |  1 +
>  lib/x86/fwcfg.c | 28 ++++++++++++++++++++++++++++
>  lib/x86/fwcfg.h | 10 ++++++++++
>  lib/x86/setup.c |  5 +++++
>  x86/apic.c      |  4 +++-
>  x86/cstart64.S  |  8 ++++++--
>  x86/eventinj.c  | 17 ++++++++++++++---
>  x86/vmx_tests.c |  5 +++++
>  9 files changed, 81 insertions(+), 10 deletions(-)
> 

Reviewed-by: Andrew Jones <drjones@redhat.com>
