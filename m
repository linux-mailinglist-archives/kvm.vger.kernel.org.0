Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F082960BB93
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 23:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234301AbiJXVDm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 17:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiJXVDX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 17:03:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64292260
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 12:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666638489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0LL0WdRv7w02bBht6OkCZWHjAU7QYuBFD9z0q0qxows=;
        b=V9m3LElLJ7YojDw0L8w6PjSHWNU31NLvqPqaQo94SsIvx5S8DcbwuZT3/g9QzG5vC0slRA
        7dgqsMKUB1RQIJ2cjTA48WuMZCuKuWZhNTwg4bg3H01Obc9qMX+56WcSlG50GxHUlylK4P
        dymRNHviPr5Z85RRhpNfCaoarN6eDLo=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-10-C0DehRyTOpaH1pUKyHysdA-1; Mon, 24 Oct 2022 08:38:55 -0400
X-MC-Unique: C0DehRyTOpaH1pUKyHysdA-1
Received: by mail-qt1-f198.google.com with SMTP id k9-20020ac85fc9000000b00399e6517f9fso6922787qta.18
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 05:38:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0LL0WdRv7w02bBht6OkCZWHjAU7QYuBFD9z0q0qxows=;
        b=X6D0T06aD7VgCmeV+m3HFrg4MIWZv0otlYCnMUJ1G1onfsgQge1AK2HRr0qT45GkJm
         uvEll21O2LcnCiU39C/84en5H8uSS5ZcuxUVGO9J6BtmHbUQOLwSQ9frWYt6Je3fvkD+
         b2cHI+PfYBEeWMUB5tTjeWjxH3JnfqZes5nc57qrZzXYQVT8WbDoi6f2LgFlzwJOnnv5
         EarounsbV6dB9pq8oUnSWthBWTT6wiLXq/yUPKT1GmjQvto9hON3IdVkTUuNt/KARQVL
         vRMEP8TFNBrXTtcfn9vLYU3KhRRjPAEowDPJT10j8NmsBWDj5d3daTLdHXc00wqwQUU2
         XqQg==
X-Gm-Message-State: ACrzQf12PFFEf90RhZBYZtP95kMi+HxPDu12vzdHlKi5s6acNm6Veuxd
        ATDFgl+PJp/BWLnYRjv3J6DzuTraQcEJ0gGAjfxLjl5dGyKoUJqJW8phCDiYOrpgJfELqN+4hMe
        2whJHTsWQu7uW
X-Received: by 2002:ac8:5f12:0:b0:39c:d2ff:13aa with SMTP id x18-20020ac85f12000000b0039cd2ff13aamr25807831qta.193.1666615134931;
        Mon, 24 Oct 2022 05:38:54 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7iwNUnLlbBSllF0KpmW+dkxosALK+9wOGvjEBYbgGxRSLqc8bqDzJkDwQuwExM3M5cVXPCsA==
X-Received: by 2002:a05:622a:1312:b0:39c:fbd3:6dbf with SMTP id v18-20020a05622a131200b0039cfbd36dbfmr23911482qtk.335.1666615123640;
        Mon, 24 Oct 2022 05:38:43 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id u10-20020a05620a0c4a00b006bb2cd2f6d1sm14738103qki.127.2022.10.24.05.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 05:38:43 -0700 (PDT)
Message-ID: <18e82f0a4064fd8dce1eb3da0fd38d640d503760.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 07/16] x86: Add a simple test for
 SYSENTER instruction.
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Mon, 24 Oct 2022 15:38:40 +0300
In-Reply-To: <Y1GgwQDrfg9wd4ej@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
         <20221020152404.283980-8-mlevitsk@redhat.com> <Y1GgwQDrfg9wd4ej@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-10-20 at 19:25 +0000, Sean Christopherson wrote:
> On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> > Run the test with Intel's vendor ID and in the long mode,
> > to test the emulation of this instruction on AMD.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  x86/Makefile.x86_64 |   2 +
> >  x86/sysenter.c      | 127 ++++++++++++++++++++++++++++++++++++++++++++
> >  x86/unittests.cfg   |   5 ++
> >  3 files changed, 134 insertions(+)
> >  create mode 100644 x86/sysenter.c
> > 
> > diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
> > index 865da07d..8ce53650 100644
> > --- a/x86/Makefile.x86_64
> > +++ b/x86/Makefile.x86_64
> > @@ -33,6 +33,7 @@ tests += $(TEST_DIR)/vmware_backdoors.$(exe)
> >  tests += $(TEST_DIR)/rdpru.$(exe)
> >  tests += $(TEST_DIR)/pks.$(exe)
> >  tests += $(TEST_DIR)/pmu_lbr.$(exe)
> > +tests += $(TEST_DIR)/sysenter.$(exe)
> >  
> >  
> >  ifeq ($(CONFIG_EFI),y)
> > @@ -60,3 +61,4 @@ $(TEST_DIR)/hyperv_clock.$(bin): $(TEST_DIR)/hyperv_clock.o
> >  $(TEST_DIR)/vmx.$(bin): $(TEST_DIR)/vmx_tests.o
> >  $(TEST_DIR)/svm.$(bin): $(TEST_DIR)/svm_tests.o
> >  $(TEST_DIR)/svm_npt.$(bin): $(TEST_DIR)/svm_npt.o
> > +$(TEST_DIR)/sysenter.o: CFLAGS += -Wa,-mintel64
> > diff --git a/x86/sysenter.c b/x86/sysenter.c
> > new file mode 100644
> > index 00000000..6c32fea4
> > --- /dev/null
> > +++ b/x86/sysenter.c
> > @@ -0,0 +1,127 @@
> > +#include "alloc.h"
> > +#include "libcflat.h"
> > +#include "processor.h"
> > +#include "msr.h"
> > +#include "desc.h"
> > +
> > +
> > +// undefine this to run the syscall instruction in 64 bit mode.
> > +// this won't work on AMD due to disabled code in the emulator.
> > +#define COMP32
> 
> Why not run the test in both 32-bit and 64-bit mode, and skip the 64-bit mode
> version if the vCPU model is AMD?

True, but on Intel the test won't test much since the instruction is not
emulated there.

It is also possible to enable the emulation on x86 on AMD as well,
there doesn't seem anything special and/or dangerous in the KVM emulator.

> 
> > +
> > +int main(int ac, char **av)
> > +{
> > +    extern void sysenter_target(void);
> > +    extern void test_done(void);
> 
> Tabs instead of spaces.
OK, I'll take a note.

> 
> > +
> > +    setup_vm();
> > +
> > +    int gdt_index = 0x50 >> 3;
> > +    ulong rax = 0xDEAD;
> > +
> > +    /* init the sysenter GDT block */
> > +    /*gdt64[gdt_index+0] = gdt64[KERNEL_CS >> 3];
> > +    gdt64[gdt_index+1] = gdt64[KERNEL_DS >> 3];
> > +    gdt64[gdt_index+2] = gdt64[USER_CS >> 3];
> > +    gdt64[gdt_index+3] = gdt64[USER_DS >> 3];*/
> > +
> > +    /* init the sysenter msrs*/
> > +    wrmsr(MSR_IA32_SYSENTER_CS, gdt_index << 3);
> > +    wrmsr(MSR_IA32_SYSENTER_ESP, 0xAAFFFFFFFF);
> > +    wrmsr(MSR_IA32_SYSENTER_EIP, (uint64_t)sysenter_target);
> > +
> > +    u8 *thunk = (u8*)malloc(50);
> > +    u8 *tmp = thunk;
> > +
> > +    printf("Thunk at 0x%lx\n", (u64)thunk);
> > +
> > +    /* movabs test_done, %rdx*/
> > +    *tmp++ = 0x48; *tmp++ = 0xBA;
> > +    *(u64 *)tmp = (uint64_t)test_done; tmp += 8;
> > +    /* jmp %%rdx*/
> > +    *tmp++ = 0xFF; *tmp++ = 0xe2;
> > +
> > +    asm volatile (
> 
> Can we add a helper sysenter_asm.S or whatever instead of making this a gigantic
> inline asm blob?  And then have separate routines for 32-bit vs. 64-bit?  That'd
> require a bit of code duplication, but macros could be used to dedup the common
> parts if necessary.
> 
> And with a .S file, I believe there's no need to dynamically generate the thunk,
> e.g. pass the jump target through a GPR that's not modified/used by SYSENTER.

I'll take a look, however since I wrote this test long ago and I am kind of short on time,
I prefer to merge it as is and then improve it as you suggested.

Best regards,
	Maxim Levitsky

> 
> > +#ifdef COMP32
> > +        "# switch to comp32, mode prior to running the test\n"
> > +        "ljmpl *1f\n"
> > +        "1:\n"
> > +        ".long 1f\n"
> > +        ".long " xstr(KERNEL_CS32) "\n"
> > +        "1:\n"
> > +        ".code32\n"
> > +#else
> > +               "# store the 64 bit thunk address to rdx\n"
> > +               "mov %[thunk], %%rdx\n"
> > +#endif
> 


