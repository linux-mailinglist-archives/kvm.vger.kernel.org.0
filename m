Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCA3348078
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 19:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237491AbhCXS11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 14:27:27 -0400
Received: from foss.arm.com ([217.140.110.172]:37742 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237629AbhCXS1Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 14:27:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3CF631FB;
        Wed, 24 Mar 2021 11:27:22 -0700 (PDT)
Received: from C02W217MHV2R.local (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AA4473F718;
        Wed, 24 Mar 2021 11:27:20 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 3/3] README: Add a guide of how to run
 tests with litmus7
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, alexandru.elisei@arm.com,
        Jade Alglave <Jade.Alglave@arm.com>,
        maranget <luc.maranget@inria.fr>
References: <20210324171402.371744-1-nikos.nikoleris@arm.com>
 <20210324171402.371744-4-nikos.nikoleris@arm.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Message-ID: <ce7228c2-0c07-833c-4bbe-d7b70d82ac94@arm.com>
Date:   Wed, 24 Mar 2021 18:27:17 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210324171402.371744-4-nikos.nikoleris@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/03/2021 17:14, Nikos Nikoleris wrote:
> litmus7 (http://diy.inria.fr/doc/litmus.html) is a tool that takes as
> an input a litmus test specification and generates a program that can
> execute on hardware. Using kvm-unit-tests, litmus7 can generate tests
> that run on KVM. This change adds some documentation to introduce this
> functionality along with a basic example of how to build and run such
> tests.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

+cc: Jade and Luc

Apologies for the spam, I should have done that in my first email.

Thanks,

Nikos

> ---
>   README.litmus7.md | 125 ++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 125 insertions(+)
>   create mode 100644 README.litmus7.md
> 
> diff --git a/README.litmus7.md b/README.litmus7.md
> new file mode 100644
> index 0000000..4653488
> --- /dev/null
> +++ b/README.litmus7.md
> @@ -0,0 +1,125 @@
> +# Memory model litmus tests as kvm-unit-tests
> +
> +In this guide, we explain how to use kvm-unit-tests in combination
> +with litmus7 to generate and run litmus tests as tiny operating
> +systems.
> +
> +## Background
> +
> +### Memory model litmus tests
> +
> +A litmus test is a small program designed to exercise a certain
> +behavior. Traditionally, litmus tests have been used to demonstrate
> +and exercise the memory model of parallel computing systems. Litmus
> +tests are often described in assembly or pseudo-assembly code and
> +require tools like [litmus7](http://diy.inria.fr/doc/litmus.html) to
> +genererate executable programs that we can then run on real hardware.
> +
> +### Why kvm-unit-tests
> +
> +litmus7 uses kvm-unit-tests to encapsulate a litmus tests and generate
> +executables in the form of tiny operating systems. Inside these tiny
> +operating systems, the litmus tests can control parameters of the
> +execution that a user space application cannot. For example, control
> +virtual address translation and handle exceptions.
> +
> +## Building and running litmus kvm-unit-tests
> +
> +litmus7 is a tool that given a litmus test will generate C source
> +code. The generated C source code is compiled and linked with
> +kvm-unit-tests to generate the binary.
> +
> +## Prerequisites
> +
> +litmus7 is part of the herdtools7 toolsuite. See
> +https://github.com/herd/herdtools7/blob/master/INSTALL.md for
> +instructions of how to build and install herdtools7 from source.
> +
> +In addition to herdtools7, this guide assumes that you have a copy of
> +kvm-unit-tests and you have already configured and built the included
> +tests.
> +
> +## Building and running a litmus test
> +
> +In this guide, we use `MP` (Message Passing), a popular litmus test
> +which demonstrates the communication pattern between a sender (P0) and
> +a receiver (P1_ process of a message `x`. There is also variable `y`
> +which is a flag, the sender sets it after setting the message `x` and
> +the receiver reads it before reading the message `x`. The test also
> +specifies a condition after the execution of the test which is
> +validated when P1 reads the initial value of message `x` (0) and the
> +new value of flag `y` (1).
> +
> +```
> +AArch64 MP
> +"PodWW Rfe PodRR Fre"
> +Generator=diyone7 (version 7.56)
> +Prefetch=0:x=F,0:y=W,1:y=F,1:x=T
> +Com=Rf Fr
> +Orig=PodWW Rfe PodRR Fre
> +{
> +0:X1=x; 0:X3=y;
> +1:X1=y; 1:X3=x;
> +}
> + P0          | P1          ;
> + MOV W0,#1   | LDR W0,[X1] ;
> + STR W0,[X1] | LDR W2,[X3] ;
> + MOV W2,#1   |             ;
> + STR W2,[X3] |             ;
> +exists (1:X0=1 /\ 1:X2=0)
> +```
> +
> +Note: [diy7](http://diy.inria.fr/doc/gen.html) and
> +[diyone7]](http://diy.inria.fr/doc/gen.html) from the herdtools7
> +toolsuite can systematically generate litmus tests. For example to
> +generate the MP litmus test:
> +
> +    diyone7 -arch AArch64 PodWW Rfe PodRR Fre -name MP
> +
> +Assuming the file `MP.litmus` contains the test and KUT_DIR is the top
> +directory of kvm-unit-tests, we can use litmus7 to generate
> +the C sources:
> +
> +    litmus7 -mach kvm-armv8.1 -variant precise -a 4 -o ${KUT_DIR}/litmus_tests MP.litmus
> +
> +To build the test:
> +
> +    cd litmus-tests && make && cd -
> +
> +This will build the test in the file `litmus-tests/MP.flat` which you
> +can run like any other test:
> +
> +     ./arm/run litmus-tests/MP.flat -smp 4
> +
> +The test will print whether the condition of the test was observed
> +(`Allowed`), stats about the observed outcomes and metadata (e.g.,
> +hash).
> +
> +```
> +Test MP Allowed
> +Histogram (4 states)
> +19865 :>1:X0=0; 1:X2=1;
> +20885 *>1:X0=1; 1:X2=0;
> +975348:>1:X0=0; 1:X2=0;
> +983902:>1:X0=1; 1:X2=1;
> +Ok
> +
> +Witnesses
> +Positive: 20885, Negative: 1979115
> +Condition exists (1:X0=1 /\ 1:X2=0) is validated
> +Hash=211d5b298572012a0869d4ded6a40b7f
> +Cycle=Rfe PodRR Fre PodWW
> +Generator=diycross7 (version 7.54+01(dev))
> +Com=Rf Fr
> +Orig=PodWW Rfe PodRR Fre
> +Observation MP Sometimes 20885 1979115
> +Time MP 3.19
> +```
> +
> +## References
> +
> +https://community.arm.com/developer/ip-products/processors/b/processors-ip-blog/posts/expanding-memory-model-tools-system-level-architecture
> +https://community.arm.com/developer/ip-products/processors/b/processors-ip-blog/posts/running-litmus-tests-on-hardware-litmus7
> +http://diy.inria.fr/doc/litmus.html
> +https://community.arm.com/developer/ip-products/processors/b/processors-ip-blog/posts/generate-litmus-tests-automatically-diy7-tool
> +http://diy.inria.fr/doc/gen.html
> 
