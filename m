Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E8A70DE62
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 16:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236763AbjEWOCm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 10:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236701AbjEWOCl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 10:02:41 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D10C4
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 07:02:39 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id af79cd13be357-757942bd912so368851785a.2
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 07:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vultr.com; s=google; t=1684850558; x=1687442558;
        h=content-transfer-encoding:to:reply-to:subject:content-language
         :user-agent:mime-version:date:message-id:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JeT4kp6dLaRnk+SSa+RRbM2NVbMl8fUDRB2Q4p9z0/U=;
        b=hOzQPY1A9rRFtNDSlWXqUw0z0Lu90oFhR+BlqfS8Zs3EH+ISkVLwAt67Zt5lwD6rlV
         5dWg/Bh6pWKHGEhY3GeP0JqyCh1tgUWrthUSS/JPJ5iXNRIoYqKHfhMXL6pdSUH3EWbp
         su2v3hg63+sDnCwdQhNBJplKrIY0i6RnQ9MBBOMR917tK6xSrwEWCgq2ZP3lUqY+TEEj
         wUPJcp/nAnKVxBIZXRBM3tEkwM2O/GJ5JpIXDx6NtgAt8tK5dBB818JppI3a4q/PbXTE
         /i8eh1ABNZ0glnPYRWEPJc4J6HEXY+gxZEjCS+q/kmZkQnKPBqYYOq85Lce0N88NRelB
         qx0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684850558; x=1687442558;
        h=content-transfer-encoding:to:reply-to:subject:content-language
         :user-agent:mime-version:date:message-id:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JeT4kp6dLaRnk+SSa+RRbM2NVbMl8fUDRB2Q4p9z0/U=;
        b=Hyuw+XX5rUu6HFBVSyaLUfnld6dRJZIDQsXWu8R55pvIDEY76MTTayEOfSC7wtwL0M
         OYYKy8MvZ8nHqCu7kYhVdyX52NS+aLUaVZb0mpzSeng35ukP+mWJIaYU4c2kj5RHQgEb
         MZGpkRjBOvs5unqWWurOBD/vph4RYrqsOoPSK3YDbqktOp012JE3gluEujNacIJWJyhl
         NQiXWhnGllzxZCplWYMmgrukNA1ASFot3fFlE4Sy8zrC1w3/GMB2UrVviEus7YS2dosf
         pRuyGEdJ4+WCa/iCrqYf6sdZLkop2+/3cRActYQ+fyx51VygvwVyBIZtFvnSvit+icP9
         a/NQ==
X-Gm-Message-State: AC+VfDx3sArPVt4NVQNbXW0XA4/XM4DHINPq1LKcrAmrVhWOKwIYR6H0
        t+sVVBrmKe7eDeqLVMzpdFPdx7v/DHcrfHIVrNXOZdKOIgdnFz1KrWK9gviEbFF0U5xFaCUdq9y
        YejgNoExwqLwTQODEEOrrBabJkPN4ROcHdHXnosvGaEISP/eNRfXmgeGdLOZCPC1lFw==
X-Google-Smtp-Source: ACHHUZ5Bj1xaSK9pOjm/nRSILJBqCWcAR8qCVv1lB24oX0V5rVjs48fIV5rX7RtZNDHcyKQHS00wiQ==
X-Received: by 2002:a05:622a:195:b0:3f4:f516:62e7 with SMTP id s21-20020a05622a019500b003f4f51662e7mr23577642qtw.9.1684850558408;
        Tue, 23 May 2023 07:02:38 -0700 (PDT)
Received: from [10.7.101.16] ([208.167.225.210])
        by smtp.gmail.com with ESMTPSA id t8-20020ac865c8000000b003f018e18c35sm2892881qto.27.2023.05.23.07.02.37
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 May 2023 07:02:38 -0700 (PDT)
From:   Brian Rak <brak@vultr.com>
X-Google-Original-From: Brian Rak <brak@gameservers.com>
Message-ID: <f023d927-52aa-7e08-2ee5-59a2fbc65953@gameservers.com>
Date:   Tue, 23 May 2023 10:02:36 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.0
Content-Language: en-US
Subject: Deadlock due to EPT_VIOLATION
Reply-To: brak@gameservers.com
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We've been hitting an issue lately where KVM guests (w/ qemu) have been 
getting stuck in a loop of EPT_VIOLATIONs, and end up requiring a guest 
reboot to fix.

On Intel machines the trace ends up looking like:

     CPU-2386625 [094] 6598425.465404: kvm_entry:            vcpu 1, rip 
0xffffffffc0771aa2
     CPU-2386625 [094] 6598425.465405: kvm_exit:             reason 
EPT_VIOLATION rip 0xffffffffc0771aa2 info 683 800000ec
     CPU-2386625 [094] 6598425.465405: kvm_page_fault:       vcpu 1 rip 
0xffffffffc0771aa2 address 0x0000000002594fe0 error_code 0x683
     CPU-2386625 [094] 6598425.465406: kvm_inj_virq:         IRQ 0xec 
[reinjected]
     CPU-2386625 [094] 6598425.465406: kvm_entry:            vcpu 1, rip 
0xffffffffc0771aa2
     CPU-2386625 [094] 6598425.465407: kvm_exit:             reason 
EPT_VIOLATION rip 0xffffffffc0771aa2 info 683 800000ec
     CPU-2386625 [094] 6598425.465407: kvm_page_fault:       vcpu 1 rip 
0xffffffffc0771aa2 address 0x0000000002594fe0 error_code 0x683
     CPU-2386625 [094] 6598425.465408: kvm_inj_virq:         IRQ 0xec 
[reinjected]
     CPU-2386625 [094] 6598425.465408: kvm_entry:            vcpu 1, rip 
0xffffffffc0771aa2
     CPU-2386625 [094] 6598425.465409: kvm_exit:             reason 
EPT_VIOLATION rip 0xffffffffc0771aa2 info 683 800000ec
     CPU-2386625 [094] 6598425.465410: kvm_page_fault:       vcpu 1 rip 
0xffffffffc0771aa2 address 0x0000000002594fe0 error_code 0x683
     CPU-2386625 [094] 6598425.465410: kvm_inj_virq:         IRQ 0xec 
[reinjected]
     CPU-2386625 [094] 6598425.465410: kvm_entry:            vcpu 1, rip 
0xffffffffc0771aa2
     CPU-2386625 [094] 6598425.465411: kvm_exit:             reason 
EPT_VIOLATION rip 0xffffffffc0771aa2 info 683 800000ec
     CPU-2386625 [094] 6598425.465412: kvm_page_fault:       vcpu 1 rip 
0xffffffffc0771aa2 address 0x0000000002594fe0 error_code 0x683
     CPU-2386625 [094] 6598425.465413: kvm_inj_virq:         IRQ 0xec 
[reinjected]
     CPU-2386625 [094] 6598425.465413: kvm_entry:            vcpu 1, rip 
0xffffffffc0771aa2
     CPU-2386625 [094] 6598425.465414: kvm_exit:             reason 
EPT_VIOLATION rip 0xffffffffc0771aa2 info 683 800000ec
     CPU-2386625 [094] 6598425.465414: kvm_page_fault:       vcpu 1 rip 
0xffffffffc0771aa2 address 0x0000000002594fe0 error_code 0x683
     CPU-2386625 [094] 6598425.465415: kvm_inj_virq:         IRQ 0xec 
[reinjected]
     CPU-2386625 [094] 6598425.465415: kvm_entry:            vcpu 1, rip 
0xffffffffc0771aa2
     CPU-2386625 [094] 6598425.465417: kvm_exit:             reason 
EPT_VIOLATION rip 0xffffffffc0771aa2 info 683 800000ec
     CPU-2386625 [094] 6598425.465417: kvm_page_fault:       vcpu 1 rip 
0xffffffffc0771aa2 address 0x0000000002594fe0 error_code 0x683

on AMD machines, we end up with:

     CPU-14414 [063] 3039492.055571: kvm_page_fault:       vcpu 0 rip 
0xffffffffb172ab2b address 0x0000000f88eb2ff8 error_code 0x200000006
     CPU-14414 [063] 3039492.055571: kvm_entry:            vcpu 0, rip 
0xffffffffb172ab2b
     CPU-14414 [063] 3039492.055572: kvm_exit:             reason 
EXIT_NPF rip 0xffffffffb172ab2b info 200000006 f88eb2ff8
     CPU-14414 [063] 3039492.055572: kvm_page_fault:       vcpu 0 rip 
0xffffffffb172ab2b address 0x0000000f88eb2ff8 error_code 0x200000006
     CPU-14414 [063] 3039492.055573: kvm_entry:            vcpu 0, rip 
0xffffffffb172ab2b
     CPU-14414 [063] 3039492.055574: kvm_exit:             reason 
EXIT_NPF rip 0xffffffffb172ab2b info 200000006 f88eb2ff8
     CPU-14414 [063] 3039492.055574: kvm_page_fault:       vcpu 0 rip 
0xffffffffb172ab2b address 0x0000000f88eb2ff8 error_code 0x200000006
     CPU-14414 [063] 3039492.055575: kvm_entry:            vcpu 0, rip 
0xffffffffb172ab2b
     CPU-14414 [063] 3039492.055575: kvm_exit:             reason 
EXIT_NPF rip 0xffffffffb172ab2b info 200000006 f88eb2ff8
     CPU-14414 [063] 3039492.055576: kvm_page_fault:       vcpu 0 rip 
0xffffffffb172ab2b address 0x0000000f88eb2ff8 error_code 0x200000006
     CPU-14414 [063] 3039492.055576: kvm_entry:            vcpu 0, rip 
0xffffffffb172ab2b
     CPU-14414 [063] 3039492.055577: kvm_exit:             reason 
EXIT_NPF rip 0xffffffffb172ab2b info 200000006 f88eb2ff8
     CPU-14414 [063] 3039492.055577: kvm_page_fault:       vcpu 0 rip 
0xffffffffb172ab2b address 0x0000000f88eb2ff8 error_code 0x200000006
     CPU-14414 [063] 3039492.055578: kvm_entry:            vcpu 0, rip 
0xffffffffb172ab2b
     CPU-14414 [063] 3039492.055579: kvm_exit:             reason 
EXIT_NPF rip 0xffffffffb172ab2b info 200000006 f88eb2ff8
     CPU-14414 [063] 3039492.055579: kvm_page_fault:       vcpu 0 rip 
0xffffffffb172ab2b address 0x0000000f88eb2ff8 error_code 0x200000006
     CPU-14414 [063] 3039492.055580: kvm_entry:            vcpu 0, rip 
0xffffffffb172ab2b


The qemu process ends up looking like this once it happens:

     0x00007fdc6a51be26 in internal_fallocate64 (fd=-514841856, 
offset=16, len=140729021657088) at ../sysdeps/posix/posix_fallocate64.c:36
     36     return EINVAL;
     (gdb) thread apply all bt

     Thread 6 (Thread 0x7fdbdefff700 (LWP 879746) "vnc_worker"):
     #0  futex_wait_cancelable (private=0, expected=0, 
futex_word=0x7fdc688f66cc) at ../sysdeps/nptl/futex-internal.h:186
     #1  __pthread_cond_wait_common (abstime=0x0, clockid=0, 
mutex=0x7fdc688f66d8, cond=0x7fdc688f66a0) at pthread_cond_wait.c:508
     #2  __pthread_cond_wait (cond=cond@entry=0x7fdc688f66a0, 
mutex=mutex@entry=0x7fdc688f66d8) at pthread_cond_wait.c:638
     #3  0x0000563424cbd32b in qemu_cond_wait_impl (cond=0x7fdc688f66a0, 
mutex=0x7fdc688f66d8, file=0x563424d302b4 "../../ui/vnc-jobs.c", 
line=248) at ../../util/qemu-thread-posix.c:220
     #4  0x00005634247dac33 in vnc_worker_thread_loop 
(queue=0x7fdc688f66a0) at ../../ui/vnc-jobs.c:248
     #5  0x00005634247db8f8 in vnc_worker_thread 
(arg=arg@entry=0x7fdc688f66a0) at ../../ui/vnc-jobs.c:361
     #6  0x0000563424cbc7e9 in qemu_thread_start (args=0x7fdbdeffcf30) 
at ../../util/qemu-thread-posix.c:505
     #7  0x00007fdc6a8e1ea7 in start_thread (arg=<optimized out>) at 
pthread_create.c:477
     #8  0x00007fdc6a527a2f in clone () at 
../sysdeps/unix/sysv/linux/x86_64/clone.S:95

     Thread 5 (Thread 0x7fdbe5dff700 (LWP 879738) "CPU 1/KVM"):
     #0  0x00007fdc6a51d5f7 in preadv64v2 (fd=1756258112, 
vector=0x563424b5f007 <kvm_vcpu_ioctl+103>, count=0, offset=0, 
flags=44672) at ../sysdeps/unix/sysv/linux/preadv64v2.c:31
     #1  0x0000000000000000 in ?? ()

     Thread 4 (Thread 0x7fdbe6fff700 (LWP 879737) "CPU 0/KVM"):
     #0  0x00007fdc6a51d5f7 in preadv64v2 (fd=1755834304, 
vector=0x563424b5f007 <kvm_vcpu_ioctl+103>, count=0, offset=0, 
flags=44672) at ../sysdeps/unix/sysv/linux/preadv64v2.c:31
     #1  0x0000000000000000 in ?? ()

     Thread 3 (Thread 0x7fdbe83ff700 (LWP 879735) "IO mon_iothread"):
     #0  0x00007fdc6a51bd2f in internal_fallocate64 (fd=-413102080, 
offset=3, len=4294967295) at ../sysdeps/posix/posix_fallocate64.c:32
     #1  0x000d5572b9bb0764 in ?? ()
     #2  0x000000016891db00 in ?? ()
     #3  0xffffffff7fffffff in ?? ()
     #4  0xf6b8254512850600 in ?? ()
     #5  0x0000000000000000 in ?? ()

     Thread 2 (Thread 0x7fdc693ff700 (LWP 879730) "qemu-kvm"):
     #0  0x00007fdc6a5212e9 in ?? () from 
target:/lib/x86_64-linux-gnu/libc.so.6
     #1  0x0000563424cbd9aa in qemu_futex_wait (val=<optimized out>, 
f=<optimized out>) at ./include/qemu/futex.h:29
     #2  qemu_event_wait (ev=ev@entry=0x5634254bd1a8 
<rcu_call_ready_event>) at ../../util/qemu-thread-posix.c:430
     #3  0x0000563424cc6d80 in call_rcu_thread (opaque=opaque@entry=0x0) 
at ../../util/rcu.c:261
     #4  0x0000563424cbc7e9 in qemu_thread_start (args=0x7fdc693fcf30) 
at ../../util/qemu-thread-posix.c:505
     #5  0x00007fdc6a8e1ea7 in start_thread (arg=<optimized out>) at 
pthread_create.c:477
     #6  0x00007fdc6a527a2f in clone () at 
../sysdeps/unix/sysv/linux/x86_64/clone.S:95

     Thread 1 (Thread 0x7fdc69c3a680 (LWP 879712) "qemu-kvm"):
     #0  0x00007fdc6a51be26 in internal_fallocate64 (fd=-514841856, 
offset=16, len=140729021657088) at ../sysdeps/posix/posix_fallocate64.c:36
     #1  0x0000000000000000 in ?? ()

We first started seeing this back in 5.19, and we're still seeing it as 
of 6.1.24 (likely later too, we don't have a ton of data for newer 
versions).  We haven't been able to link this to any specific hardware.  
It appears to happen more often on Intel, but our sample size is much 
larger there.  Guest operating system type/version doesn't appear to 
matter.  This usually happens to guests with a heavy network/disk 
workload, but it can happen to even idle guests. This has happened on 
qemu 7.0 and 7.2 (upgrading to 7.2.2 is on our list to do).

Where do we go from here?  We haven't really made a lot of progress in 
figuring out why this keeps happening, nor have we been able to come up 
with a reliable way to reproduce it.
