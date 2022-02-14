Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBD84B4EA3
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 12:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351445AbiBNLcN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 06:32:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352606AbiBNLbf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 06:31:35 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B6F5F69498
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 03:16:38 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 85C0F1042;
        Mon, 14 Feb 2022 03:16:38 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7BC283F718;
        Mon, 14 Feb 2022 03:16:37 -0800 (PST)
Date:   Mon, 14 Feb 2022 11:16:55 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, drjones@redhat.com,
        kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests BUG] x86: debug.c compilation error with
 --target-efi
Message-ID: <Ygo6DA+938qQp6Hw@monolith.localdoman>
References: <YgT9ZIEkSSWJ+YTX@monolith.localdoman>
 <YgVHx2GV/MbKu57I@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgVHx2GV/MbKu57I@google.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Thu, Feb 10, 2022 at 05:13:43PM +0000, Sean Christopherson wrote:
> On Thu, Feb 10, 2022, Alexandru Elisei wrote:
> > When compiling kvm-unit-tests configured with --target-efi I get the following
> > error:
> > 
> > [..]
> > gcc -mno-red-zone -mno-sse -mno-sse2  -fcf-protection=full -m64 -O1 -g -MMD -MF x86/.debug.d -fno-strict-aliasing -fno-common -Wall -Wwrite-strings -Wempty-body -Wuninitialized -Wignored-qualifiers -Werror -Wno-missing-braces  -fno-omit-frame-pointer  -fno-stack-protector    -Wno-frame-address  -DTARGET_EFI -maccumulate-outgoing-args -fshort-wchar -fPIC  -Wclobbered  -Wunused-but-set-parameter  -Wmissing-parameter-type  -Wold-style-declaration -Woverride-init -Wmissing-prototypes -Wstrict-prototypes -std=gnu99 -ffreestanding -I /path/to/kvm-unit-tests/lib -I /path/to/kvm-unit-tests/lib/x86 -I lib   -c -o x86/debug.o x86/debug.c
> > ld -T /path/to/kvm-unit-tests/x86/efi/elf_x86_64_efi.lds -Bsymbolic -shared -nostdlib -o x86/debug.so \
> > 	x86/debug.o x86/efi/efistart64.o lib/libcflat.a
> > ld: x86/debug.o: relocation R_X86_64_32S against `.text' can not be used when making a shared object; recompile with -fPIC
> > make: *** [/path/to/kvm-unit-tests/x86/Makefile.common:51: x86/debug.so] Error 1
> > rm x86/emulator.o x86/tsc.o x86/msr.o x86/tsc_adjust.o x86/idt_test.o x86/sieve.o x86/s3.o x86/asyncpf.o x86/rmap_chain.o x86/init.o x86/xsave.o x86/debug.o x86/pmu.o x86/kvmclock_test.o x86/pcid.o x86/umip.o x86/setjmp.o x86/eventinj.o x86/hyperv_connections.o x86/apic.o x86/dummy.o x86/hypercall.o x86/vmexit.o x86/tsx-ctrl.o x86/hyperv_synic.o x86/smap.o x86/hyperv_stimer.o x86/efi/efistart64.o x86/smptest.o
> > 
> > The error does not happen if the test is not configured with --target-efi.
> > 
> > I bisected the error to commit 9734b4236294 ("x86/debug: Add framework for
> > single-step #DB tests"). Changing the Makefile to build x86/debug.o when
> > !TARGET_EFI has fixed the issue for me (it might be that the inline assembly
> > added by the commit contains absolute addresses, but my knowledge of x86
> > assembly is sketchy at best):
> 
> Fix posted: https://lore.kernel.org/all/20220210092044.18808-1-zhenzhong.duan@intel.com

Thanks for the heads-up, I missed it because it didn't have kvm-unit-tests
in the subject line.

Thanks,
Alex
