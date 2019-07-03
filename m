Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B203B5E8A4
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 18:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfGCQUZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 12:20:25 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40676 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbfGCQUZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 12:20:25 -0400
Received: by mail-wr1-f68.google.com with SMTP id p11so3491836wre.7
        for <kvm@vger.kernel.org>; Wed, 03 Jul 2019 09:20:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nQQIzDBT5ulmvCv1mGA/eYyAvfwknQmSWGz/saY1kAc=;
        b=UW1OKI89lOWxIqO9ohUp/Wuzeo/7NjZp9uhfgGWJ/w1G3bM88vKKXSHrGZwCD6LaI5
         BXycW/fPUPMu4b1tLVUcGc53vB/+6LZRY5+exepR81VXXxvSRYx95Zv9y1RvGTbDPJCR
         yQJgQiFCaF3yiSpJykEBcPSLkdk2CnMIXmCwRru+bf0Jmkg+eUxqCP3DxqalaGeBdVKc
         6SUtn9fUuO0L8jVmlHrjg/c8gOFfy35Je1mo8c/tAoWA78m4hm83rh/Qh6llZqZNu8kl
         H4W3qxUHwo7dbXkMY/TEivaAhPVCIzKMrXzRHtuTwhTXhzNASsldo5rPW3Eh56FaKcQ+
         BUyQ==
X-Gm-Message-State: APjAAAUcdeYZ3td4I/78yJB0N5J+5IS2iBk0kdoUJOTiTxCNlt36g3Fg
        5gKygxWGfeUjZQ5VmRMu2dZm2Q==
X-Google-Smtp-Source: APXvYqyqSE6CiCMaA3tE51IMPrW8jI0NMG5fLN7BNkcYFfVOQTNzchZ43TBtON7ulLvYVDu5oG/5iA==
X-Received: by 2002:a5d:4681:: with SMTP id u1mr29031344wrq.102.1562170822816;
        Wed, 03 Jul 2019 09:20:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:6c1d:63cc:b81d:e1a9? ([2001:b07:6468:f312:6c1d:63cc:b81d:e1a9])
        by smtp.gmail.com with ESMTPSA id y24sm2136601wmi.10.2019.07.03.09.20.21
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 09:20:22 -0700 (PDT)
Subject: Re: [PATCH v4 0/5] x86 instruction emulator fuzzing
To:     Alexander Graf <graf@amazon.com>, Sam Caccavale <samcacc@amazon.de>
Cc:     samcaccavale@gmail.com, nmanthey@amazon.de, wipawel@amazon.de,
        dwmw@amazon.co.uk, mpohlack@amazon.de, karahmed@amazon.de,
        andrew.cooper3@citrix.com, JBeulich@suse.com, rkrcmar@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        paullangton4@gmail.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190628092621.17823-1-samcacc@amazon.de>
 <caaeb546-9aa1-7fd5-496d-a0ec1f759d10@amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <537c4950-8b22-c28f-c248-504f8396dd5a@redhat.com>
Date:   Wed, 3 Jul 2019 18:20:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <caaeb546-9aa1-7fd5-496d-a0ec1f759d10@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/06/19 11:33, Alexander Graf wrote:
> 
> 
> On 28.06.19 11:26, Sam Caccavale wrote:
>> Dear all,
>>
>> This series aims to provide an entrypoint for, and fuzz KVM's x86
>> instruction
>> emulator from userspace.  It mirrors Xen's application of the AFL
>> fuzzer to
>> it's instruction emulator in the hopes of discovering vulnerabilities.
>> Since this entrypoint also allows arbitrary execution of the emulators
>> code
>> from userspace, it may also be useful for testing.
>>
>> The current 4 patches build the emulator and 2 harnesses:
>> simple-harness is
>> an example of unit testing; afl-harness is a frontend for the AFL fuzzer.
>> The fifth patch contains useful scripts for development but is not
>> intended
>> for usptream consumption.
>>
>> Patches
>> =======
>>
>> - 01: Builds and links afl-harness with the required kernel objects.
>> - 02: Introduces the minimal set of emulator operations and supporting
>> code
>> to emulate simple instructions.
>> - 03: Demonstrates simple-harness as a unit test.
>> - 04: Adds scripts for install and building.
>> - 05: Useful scripts for development
>>
>>
>> Issues
>> =======
>>
>> Currently, fuzzing results in a large amount of FPU related crashes. 
>> Xen's
>> fuzzing efforts had this issue too.  Their (temporary?) solution was to
>> disable FPU exceptions after every instruction iteration?  Some solution
>> is desired for this project.
>>
>>
>> Changelog
>> =======
>>
>> v1 -> v2:
>>   - Moved -O0 to ifdef DEBUG
>>   - Building with ASAN by default
>>   - Removed a number of macros from emulator_ops.c and moved them as
>>     static inline functions in emulator_ops.h
>>   - Accidentally changed the example in simple-harness (reverted in v3)
>>   - Introduced patch 4 for scripts
>>
>> v2 -> v3:
>>   - Removed a workaround for printf smashing the stack when compiled
>>     with -mcmodel=kernel, and stopped compiling with -mcmodel=kernel
>>   - Added a null check for malloc's return value
>>   - Moved more macros from emulator_ops.c into emulator_ops.h as
>>     static inline functions
>>   - Removed commented out code
>>   - Moved changes to emulator_ops.h into the first patch
>>   - Moved addition of afl-many script to the script patch
>>   - Fixed spelling mistakes in documentation
>>   - Reverted the simple-harness example back to the more useful
>> original one
>>   - Moved non-essential development scripts from patch 4 to new patch 5
>>
>> v3 -> v4:
>>   - Stubbed out all unimplemented emulator_ops with a unimplemented_op
>> macro
>>   - Setting FAIL_ON_UNIMPLEMENTED_OP on compile decides whether
>> calling these
>>     is treated as a crash or ignored
>>   - Moved setting up core dumps out of the default build/install path and
>>     detailed this change in the README
>>   - Added a .sh extention to afl-many
>>   - Added an optional timeout to afl-many.sh and made deploy_remote.sh
>> use it
>>   - Building no longer creates a new .config each time and does not
>> force any
>>     config options
>>   - Fixed a path bug in afl-many.sh
>>
>> Any comments/suggestions are greatly appreciated.
>>
>> Best,
>> Sam Caccavale
>>
>> Sam Caccavale (5):
>>    Build target for emulate.o as a userspace binary
>>    Emulate simple x86 instructions in userspace
>>    Demonstrating unit testing via simple-harness
>>    Added build and install scripts
>>    Development scripts for crash triage and deploy
>>
>>   tools/Makefile                                |   9 +
>>   tools/fuzz/x86ie/.gitignore                   |   2 +
>>   tools/fuzz/x86ie/Makefile                     |  54 ++
>>   tools/fuzz/x86ie/README.md                    |  21 +
>>   tools/fuzz/x86ie/afl-harness.c                | 151 +++++
>>   tools/fuzz/x86ie/common.h                     |  87 +++
>>   tools/fuzz/x86ie/emulator_ops.c               | 590 ++++++++++++++++++
>>   tools/fuzz/x86ie/emulator_ops.h               | 134 ++++
>>   tools/fuzz/x86ie/scripts/afl-many.sh          |  31 +
>>   tools/fuzz/x86ie/scripts/bin.sh               |  49 ++
>>   tools/fuzz/x86ie/scripts/build.sh             |  34 +
>>   tools/fuzz/x86ie/scripts/coalesce.sh          |   5 +
>>   tools/fuzz/x86ie/scripts/deploy.sh            |   9 +
>>   tools/fuzz/x86ie/scripts/deploy_remote.sh     |  10 +
>>   tools/fuzz/x86ie/scripts/gen_output.sh        |  11 +
>>   tools/fuzz/x86ie/scripts/install_afl.sh       |  15 +
>>   .../fuzz/x86ie/scripts/install_deps_ubuntu.sh |   5 +
>>   tools/fuzz/x86ie/scripts/rebuild.sh           |   6 +
>>   tools/fuzz/x86ie/scripts/run.sh               |  10 +
>>   tools/fuzz/x86ie/scripts/summarize.sh         |   9 +
>>   tools/fuzz/x86ie/simple-harness.c             |  49 ++
>>   tools/fuzz/x86ie/stubs.c                      |  59 ++
>>   tools/fuzz/x86ie/stubs.h                      |  52 ++
> 
> Sorry I didn't realize it before. Isn't that missing a patch to the
> MAINTAINERS file?

Yeah, and the directory should probably be tools/fuzz/kvm_emulate so as
not to puzzle people.  Also:

- let's limit the scripts to the minimum, i.e. only the run script which
should be something like

#!/bin/bash
# SPDX-License-Identifier: GPL-2.0+

FUZZDIR="${FUZZDIR:-$(pwd)/fuzz}"

mkdir -p $FUZZDIR/in
cp tools/fuzz/kvm_emulate/rand_sample.bin $FUZZDIR/in
mkdir -p $FUZZDIR/out

${TIMEOUT:+TIMEOUT=$TIMEOUT} ${AFL_FUZZ-afl-fuzz} "$@" \
  -i $FUZZDIR/in -o $FUZZDIR/out tools/fuzz/kvm_emulate/afl-harness @@

where people can substitute afl-many.sh or add their own options using
the AFL_FUZZ variable or the command line.  Likewise for screen.

- the build should be just "make -C tools/fuzz/kvm_emulate" and it
should just work.  Feel free to steal the Makefile magic from other
tools/ directories.

- finally, rand_sample.bin is missing.

Otherwise, it looks very nice.

Paolo
