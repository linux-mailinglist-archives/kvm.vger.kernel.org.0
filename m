Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 729765978F
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 11:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfF1JeF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 05:34:05 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:17969 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfF1JeF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 05:34:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1561714444; x=1593250444;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=sSKEUVaTdyL6t5ZO2NW3uKuh1AeVNjk+FHaRRO4KGtI=;
  b=NijCFQlkyyK7FfvWXmgNHYE0bJIap9oSNNMq9l6hELAx5Xct/iEnSozP
   WkQW7lzlLaMbI/nG3tC97HAqXxEjfLXGLsM77tWoMtnkewrXJexAWsAzG
   mBrZeFi0Ti4udYx8FrRDm79mYVNZv1ChSOsk+lbJq2gBn/pUAQ2dcWifl
   M=;
X-IronPort-AV: E=Sophos;i="5.62,427,1554768000"; 
   d="scan'208";a="408520324"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 28 Jun 2019 09:33:56 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com (Postfix) with ESMTPS id EB7E1A1DFF;
        Fri, 28 Jun 2019 09:33:52 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 28 Jun 2019 09:33:51 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.16) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 28 Jun 2019 09:33:47 +0000
Subject: Re: [PATCH v4 0/5] x86 instruction emulator fuzzing
To:     Sam Caccavale <samcacc@amazon.de>
CC:     <samcaccavale@gmail.com>, <nmanthey@amazon.de>,
        <wipawel@amazon.de>, <dwmw@amazon.co.uk>, <mpohlack@amazon.de>,
        <karahmed@amazon.de>, <andrew.cooper3@citrix.com>,
        <JBeulich@suse.com>, <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <paullangton4@gmail.com>, <x86@kernel.org>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20190628092621.17823-1-samcacc@amazon.de>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <caaeb546-9aa1-7fd5-496d-a0ec1f759d10@amazon.com>
Date:   Fri, 28 Jun 2019 11:33:45 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190628092621.17823-1-samcacc@amazon.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.16]
X-ClientProxiedBy: EX13D18UWC004.ant.amazon.com (10.43.162.77) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 28.06.19 11:26, Sam Caccavale wrote:
> Dear all,
> 
> This series aims to provide an entrypoint for, and fuzz KVM's x86 instruction
> emulator from userspace.  It mirrors Xen's application of the AFL fuzzer to
> it's instruction emulator in the hopes of discovering vulnerabilities.
> Since this entrypoint also allows arbitrary execution of the emulators code
> from userspace, it may also be useful for testing.
> 
> The current 4 patches build the emulator and 2 harnesses: simple-harness is
> an example of unit testing; afl-harness is a frontend for the AFL fuzzer.
> The fifth patch contains useful scripts for development but is not intended
> for usptream consumption.
> 
> Patches
> =======
> 
> - 01: Builds and links afl-harness with the required kernel objects.
> - 02: Introduces the minimal set of emulator operations and supporting code
> to emulate simple instructions.
> - 03: Demonstrates simple-harness as a unit test.
> - 04: Adds scripts for install and building.
> - 05: Useful scripts for development
> 
> 
> Issues
> =======
> 
> Currently, fuzzing results in a large amount of FPU related crashes.  Xen's
> fuzzing efforts had this issue too.  Their (temporary?) solution was to
> disable FPU exceptions after every instruction iteration?  Some solution
> is desired for this project.
> 
> 
> Changelog
> =======
> 
> v1 -> v2:
>   - Moved -O0 to ifdef DEBUG
>   - Building with ASAN by default
>   - Removed a number of macros from emulator_ops.c and moved them as
>     static inline functions in emulator_ops.h
>   - Accidentally changed the example in simple-harness (reverted in v3)
>   - Introduced patch 4 for scripts
> 
> v2 -> v3:
>   - Removed a workaround for printf smashing the stack when compiled
>     with -mcmodel=kernel, and stopped compiling with -mcmodel=kernel
>   - Added a null check for malloc's return value
>   - Moved more macros from emulator_ops.c into emulator_ops.h as
>     static inline functions
>   - Removed commented out code
>   - Moved changes to emulator_ops.h into the first patch
>   - Moved addition of afl-many script to the script patch
>   - Fixed spelling mistakes in documentation
>   - Reverted the simple-harness example back to the more useful original one
>   - Moved non-essential development scripts from patch 4 to new patch 5
> 
> v3 -> v4:
>   - Stubbed out all unimplemented emulator_ops with a unimplemented_op macro
>   - Setting FAIL_ON_UNIMPLEMENTED_OP on compile decides whether calling these
>     is treated as a crash or ignored
>   - Moved setting up core dumps out of the default build/install path and
>     detailed this change in the README
>   - Added a .sh extention to afl-many
>   - Added an optional timeout to afl-many.sh and made deploy_remote.sh use it
>   - Building no longer creates a new .config each time and does not force any
>     config options
>   - Fixed a path bug in afl-many.sh
> 
> Any comments/suggestions are greatly appreciated.
> 
> Best,
> Sam Caccavale
> 
> Sam Caccavale (5):
>    Build target for emulate.o as a userspace binary
>    Emulate simple x86 instructions in userspace
>    Demonstrating unit testing via simple-harness
>    Added build and install scripts
>    Development scripts for crash triage and deploy
> 
>   tools/Makefile                                |   9 +
>   tools/fuzz/x86ie/.gitignore                   |   2 +
>   tools/fuzz/x86ie/Makefile                     |  54 ++
>   tools/fuzz/x86ie/README.md                    |  21 +
>   tools/fuzz/x86ie/afl-harness.c                | 151 +++++
>   tools/fuzz/x86ie/common.h                     |  87 +++
>   tools/fuzz/x86ie/emulator_ops.c               | 590 ++++++++++++++++++
>   tools/fuzz/x86ie/emulator_ops.h               | 134 ++++
>   tools/fuzz/x86ie/scripts/afl-many.sh          |  31 +
>   tools/fuzz/x86ie/scripts/bin.sh               |  49 ++
>   tools/fuzz/x86ie/scripts/build.sh             |  34 +
>   tools/fuzz/x86ie/scripts/coalesce.sh          |   5 +
>   tools/fuzz/x86ie/scripts/deploy.sh            |   9 +
>   tools/fuzz/x86ie/scripts/deploy_remote.sh     |  10 +
>   tools/fuzz/x86ie/scripts/gen_output.sh        |  11 +
>   tools/fuzz/x86ie/scripts/install_afl.sh       |  15 +
>   .../fuzz/x86ie/scripts/install_deps_ubuntu.sh |   5 +
>   tools/fuzz/x86ie/scripts/rebuild.sh           |   6 +
>   tools/fuzz/x86ie/scripts/run.sh               |  10 +
>   tools/fuzz/x86ie/scripts/summarize.sh         |   9 +
>   tools/fuzz/x86ie/simple-harness.c             |  49 ++
>   tools/fuzz/x86ie/stubs.c                      |  59 ++
>   tools/fuzz/x86ie/stubs.h                      |  52 ++

Sorry I didn't realize it before. Isn't that missing a patch to the 
MAINTAINERS file?


Alex
