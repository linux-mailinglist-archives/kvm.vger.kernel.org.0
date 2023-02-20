Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 178D569C90A
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 11:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbjBTKwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 05:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbjBTKwA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 05:52:00 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 395E6125A7;
        Mon, 20 Feb 2023 02:51:58 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C879915BF;
        Mon, 20 Feb 2023 02:52:40 -0800 (PST)
Received: from [10.57.75.211] (unknown [10.57.75.211])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4EDEA3F703;
        Mon, 20 Feb 2023 02:51:53 -0800 (PST)
Message-ID: <09cc1a81-d4a2-7db2-2add-d56121bbd7d7@arm.com>
Date:   Mon, 20 Feb 2023 10:51:51 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [RFC] Support for Arm CCA VMs on Linux
Content-Language: en-US
To:     Itaru Kitayama <itaru.kitayama@gmail.com>
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>,
        James Morse <james.morse@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Price <steven.price@arm.com>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <cfb0292c-e84d-0a7c-be74-ae5508779502@arm.com>
 <CANW9uyvXofhGGuhGzk_0Et-w8CHT2y35WSu5+hno6Qm8K4R4ug@mail.gmail.com>
 <CANW9uyuY2Ca9dxYQTtFLFupd-A088NTtmhdE=ST6o6Qn1_XM_A@mail.gmail.com>
From:   Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <CANW9uyuY2Ca9dxYQTtFLFupd-A088NTtmhdE=ST6o6Qn1_XM_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/02/2023 08:02, Itaru Kitayama wrote:
> On Sat, Feb 11, 2023 at 7:53 AM Itaru Kitayama <itaru.kitayama@gmail.com> wrote:
>>
>> On Sat, Feb 11, 2023 at 1:56 AM Ryan Roberts <ryan.roberts@arm.com> wrote:
>>>
>>> On 27/01/2023 11:22, Suzuki K Poulose wrote:
>>>> [...]
>>>
>>>> Running the stack
>>>> ====================
>>>>
>>>> To run/test the stack, you would need the following components :
>>>>
>>>> 1) FVP Base AEM RevC model with FEAT_RME support [4]
>>>> 2) TF-A firmware for EL3 [5]
>>>> 3) TF-A RMM for R-EL2 [3]
>>>> 4) Linux Kernel [6]
>>>> 5) kvmtool [7]
>>>> 6) kvm-unit-tests [8]
>>>>
>>>> Instructions for building the firmware components and running the model are
>>>> available here [9]. Once, the host kernel is booted, a Realm can be launched by
>>>> invoking the `lkvm` commad as follows:
>>>>
>>>>  $ lkvm run --realm                            \
>>>>        --measurement-algo=["sha256", "sha512"] \
>>>>        --disable-sve                           \
>>>>        <normal-vm-options>
>>>>
>>>> Where:
>>>>  * --measurement-algo (Optional) specifies the algorithm selected for creating the
>>>>    initial measurements by the RMM for this Realm (defaults to sha256).
>>>>  * GICv3 is mandatory for the Realms.
>>>>  * SVE is not yet supported in the TF-RMM, and thus must be disabled using
>>>>    --disable-sve
>>>>
>>>> You may also run the kvm-unit-tests inside the Realm world, using the similar
>>>> options as above.
>>>
>>> Building all of these components and configuring the FVP correctly can be quite
>>> tricky, so I thought I would plug a tool we have called Shrinkwrap, which can
>>> simplify all of this.
>>>
>>> The tool accepts a yaml input configuration that describes how a set of
>>> components should be built and packaged, and how the FVP should be configured
>>> and booted. And by default, it uses a Docker container on its backend, which
>>> contains all the required tools, including the FVP. You can optionally use
>>> Podman or have it run on your native system if you prefer. It supports both
>>> x86_64 and aarch64. And you can even run it in --dry-run mode to see the set of
>>> shell commands that would have been executed.
>>>
>>> It comes with two CCA configs out-of-the-box; cca-3world.yaml builds TF-A, RMM,
>>> Linux (for both host and guest), kvmtool and kvm-unit-tests. cca-4world.yaml
>>> adds Hafnium and some demo SPs for the secure world (although since Hafnium
>>> requires x86_64 to build, cca-4world.yaml doesn't currently work on an aarch64
>>> build host).
>>>
>>> See the documentation [1] and repository [2] for more info.
>>>
>>> Brief instructions to get you up and running:
>>>
>>>   # Install shrinkwrap. (I assume you have Docker installed):
>>>   sudo pip3 install pyyaml termcolor tuxmake
>>>   git clone https://git.gitlab.arm.com/tooling/shrinkwrap.git
>>>   export PATH=$PWD/shrinkwrap/shrinkwrap:$PATH
>>>
>>>   # If running Python < 3.9:
>>>   sudo pip3 install graphlib-backport
>>>
>>>   # Build all the CCA components:
>>>   shrinkwrap build cca-3world.yaml [--dry-run]
>>
>> This has been working on my Multipass instance on M1, thanks for the tool.
>>
>> Thanks,
>> Itaru.
> 
> It took a while though I've just booted an Ubuntu 22.10 disk image
> with the cca-3world.yaml config on M1.

That's good to hear - If you have any feedback (or patches ;-)) for Shrinkwrap
that would improve the experience, do let me know!

> 
> Thanks,
> Itaru.
> 
>>
>>>
>>>   # Run the stack in the FVP:
>>>   shrinkwrap run cca-3world.yaml -r ROOTFS=<my_rootfs.ext4> [--dry-run]
>>>
>>> By default, building is done at ~/.shrinkwrap/build/cca-3world and the package
>>> is created at ~/.shrinkwrap/package/cca-3world (this can be changed with
>>> envvars).
>>>
>>> The 'run' command will boot TF-A, RMM and host Linux kernel in the FVP, and
>>> mount the provided rootfs. You will likely want to have copied the userspace
>>> pieces into the rootfs before running, so you can create realms:
>>>
>>> - ~/.shrinkwrap/package/cca-3world/Image (kernel with RMI and RSI support)
>>> - ~/.shrinkwrap/package/cca-3world/lkvm (kvmtool able to launch realms)
>>> - ~/.shrinkwrap/package/cca-3world/kvm-unit-tests.tgz (built kvm-unit-tests)
>>>
>>> Once the FVP is booted to a shell, you can do something like this to launch a
>>> Linux guest in a realm:
>>>
>>>   lkvm run --realm --disable-sve -c 1 -m 256 -k Image
>>>
>>> [1] https://shrinkwrap.docs.arm.com
>>> [2] https://gitlab.arm.com/tooling/shrinkwrap
>>>
>>>
>>> _______________________________________________
>>> linux-arm-kernel mailing list
>>> linux-arm-kernel@lists.infradead.org
>>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

