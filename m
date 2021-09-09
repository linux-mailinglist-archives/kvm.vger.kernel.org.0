Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E89405958
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 16:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243678AbhIIOm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 10:42:57 -0400
Received: from foss.arm.com ([217.140.110.172]:36598 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350908AbhIIOml (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 10:42:41 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC8DF6D;
        Thu,  9 Sep 2021 07:41:31 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 78A7F3F59C;
        Thu,  9 Sep 2021 07:41:29 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC PATCH 4/5] scripts: Generate kvmtool
 standalone tests
To:     Andrew Jones <drjones@redhat.com>
Cc:     thuth@redhat.com, pbonzini@redhat.com, lvivier@redhat.com,
        kvm-ppc@vger.kernel.org, david@redhat.com, frankja@linux.ibm.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com,
        maz@kernel.org, vivek.gautam@arm.com
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-5-alexandru.elisei@arm.com>
 <20210907102135.i2w3r7j4zyj736b5@gator>
 <ee11a10a-c3e6-b9ce-81e1-147025a9b5bd@arm.com>
 <20210908160743.l4hrl4de7wkxwuda@gator>
 <9d5da497-7070-31ef-282a-a11a86e0102e@arm.com>
 <20210909130553.gnzce7cs7d5stvjd@gator>
 <7313396e-de46-8a3b-902d-5a59b2089c79@arm.com>
 <20210909135429.dqreodxr7elpvmfm@gator>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <e8560cdb-532c-0320-420d-c57d14cdae18@arm.com>
Date:   Thu, 9 Sep 2021 15:42:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210909135429.dqreodxr7elpvmfm@gator>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 9/9/21 2:54 PM, Andrew Jones wrote:
> On Thu, Sep 09, 2021 at 02:47:57PM +0100, Alexandru Elisei wrote:
>> Hi Drew,
>>
>> On 9/9/21 2:05 PM, Andrew Jones wrote:
>>> On Thu, Sep 09, 2021 at 12:11:52PM +0100, Alexandru Elisei wrote:
>>>> Hi Drew,
>>>>
>>>> On 9/8/21 5:07 PM, Andrew Jones wrote:
>>>>> On Wed, Sep 08, 2021 at 04:37:39PM +0100, Alexandru Elisei wrote:
>>>>>> Hi Drew,
>>>>>>
>>>>>> On 9/7/21 11:21 AM, Andrew Jones wrote:
>>>>>>> On Fri, Jul 02, 2021 at 05:31:21PM +0100, Alexandru Elisei wrote:
>>>>>>>> Add support for the standalone target when running kvm-unit-tests under
>>>>>>>> kvmtool.
>>>>>>>>
>>>>>>>> Example command line invocation:
>>>>>>>>
>>>>>>>> $ ./configure --target=kvmtool
>>>>>>>> $ make clean && make standalone
>>>>>>>>
>>>>>>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>>>>>>> ---
>>>>>>>>  scripts/mkstandalone.sh | 14 +++++++-------
>>>>>>>>  1 file changed, 7 insertions(+), 7 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
>>>>>>>> index 16f461c06842..d84bdb7e278c 100755
>>>>>>>> --- a/scripts/mkstandalone.sh
>>>>>>>> +++ b/scripts/mkstandalone.sh
>>>>>>>> @@ -44,6 +44,10 @@ generate_test ()
>>>>>>>>  	config_export ARCH_NAME
>>>>>>>>  	config_export PROCESSOR
>>>>>>>>  
>>>>>>>> +	if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "arm" ]; then
>>>>>>>> +		config_export TARGET
>>>>>>>> +	fi
>>>>>>> Should export unconditionally, since we'll want TARGET set
>>>>>>> unconditionally.
>>>>>> Yes, will do.
>>>>>>
>>>>>>>> +
>>>>>>>>  	echo "echo BUILD_HEAD=$(cat build-head)"
>>>>>>>>  
>>>>>>>>  	if [ ! -f $kernel ]; then
>>>>>>>> @@ -59,7 +63,7 @@ generate_test ()
>>>>>>>>  		echo 'export FIRMWARE'
>>>>>>>>  	fi
>>>>>>>>  
>>>>>>>> -	if [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ]; then
>>>>>>>> +	if [ "$TARGET" != "kvmtool" ] && [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ]; then
>>>>>>> I think it would be better to ensure that ENVIRON_DEFAULT is "no" for
>>>>>>> TARGET=kvmtool in configure.
>>>>>> From looking at the code, it is my understanding that with ENVIRON_DEFAULT=yes, an
>>>>>> initrd file is generated with the contents of erratatxt and other information, in
>>>>>> a key=value pair format. This initrd is then passed on to the test (please correct
>>>>>> me if I'm wrong). With ENVIRON_DEFAULT=no (set via ./configure
>>>>>> --disable-default-environ), this initrd is not generated.
>>>>>>
>>>>>> kvmtool doesn't have support for passing an initrd when loading firmware, so yes,
>>>>>> I believe the default should be no.
>>>>>>
>>>>>> However, I have two questions:
>>>>>>
>>>>>> 1. What happens when the user specifically enables the default environ via
>>>>>> ./configure --enable-default-environ --target=kvmtool? In my opinion, that should
>>>>>> be an error because the user wants something that is not possible with kvmtool
>>>>>> (loading an image with --firmware in kvmtool means that the initrd image it not
>>>>>> loaded into the guest memory and no node is generated for it in the dtb), but I
>>>>>> would like to hear your thoughts about it.
>>>>> As part of the forcing ENVIRON_DEFAULT to "no" for kvmtool in configure an
>>>>> error should be generated if a user tries to explicitly enable it.
>>>>>
>>>>>> 2. If the default environment is disabled, is it still possible for an user to
>>>>>> pass an initrd via other means? I couldn't find where that is implemented, so I'm
>>>>>> guessing it's not possible.
>>>>> Yes, a user could have a KVM_UNIT_TESTS_ENV environment variable set when
>>>>> they launch the tests. If that variable points to a file then it will get
>>>>> passed as an initrd. I guess you should also report a warning in arm/run
>>>>> if KVM_UNIT_TESTS_ENV is set which states that the environment file will
>>>>> be ignored when running with kvmtool.
>>>> Thank you for explaining it, I had looked at
>>>> scripts/arch-run.bash::initrd_create(), but it didn't click that setting the
>>>> KVM_UNIT_TESTS_ENV environment variable is enough to generate and use the initrd.
>>>>
>>>> After looking at the code some more, in the logs the -initrd argument is shown as
>>>> a comment, instead of an actual argument that is passed to qemu:
>>>>
>>>> timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64 -nodefaults -machine
>>>> virt,gic-version=host,accel=kvm -cpu host -device virtio-serial-device -device
>>>> virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none
>>>> -serial stdio -kernel arm/cache.flat -smp 1 # -initrd /tmp/tmp.rUIZ3h9KLJ
>>>> QEMU_ACCEL = kvm
>>>> INFO: IDC-DIC: dcache clean to PoU required
>>>> INFO: IDC-DIC: icache invalidation to PoU required
>>>> PASS: IDC-DIC: code generation
>>>> SUMMARY: 1 tests
>>>>
>>>> This is done intentionally in scripts/arch-run.bash::run_qemu(). I don't
>>>> understand the reason for that. When I first looked at the logs, I was sure that
>>>> no initrd is passed to the test. I had to go dig through the scripts to figure out
>>>> that the "#" sign (which marks the beginning of a comment) is not present in the
>>>> qemu invocation.
>>> It's commented out because if you want to copy+paste the command line to
>>> use it again it'll fail to run because the temp file will be gone. Of
>>> course somebody depending on the environment for their test run will have
>>> other problems when it's gone, but those people can use the
>>> KVM_UNIT_TESTS_ENV variable to specify a non-temp file which includes the
>>> default environment and then configure without the default environment.
>>> The command line won't get the # in that case.
>> Hmm... wouldn't it make more sense then to generate the initrd in the logs
>> directory, and keep it there? To ensure the test runs can be reproduced manually,
>> if needed?
> Well, there's no logs directory for standalone tests, but I do like the
> idea of capturing the environment when possible. Possibly the best thing
> to do is to provide an option that, when enabled, says to dump the
> environment into the log before executing the test. That would be similar
> to how BUILD_HEAD is output first when running the tests standalone.
> Anyway, this is a good idea, but probably outside the scope of your
> kvmtool work unless the initrd thing is blocking you and you need to
> rework it anyway.

I don't need to change anything about how initrd works in kvm-unit-tests for my
kvmtool series, I was just curious to understand more about it. Thank you for the
explanations!

Thanks,

Alex

>
> Thanks,
> drew
>
>> Thanks,
>>
>> Alex
>>
>>> Thanks,
>>> drew
>>>
>>>> Thanks,
>>>>
>>>> Alex
>>>>
>>>>> There aren't currently any other ways to invoke the addition of the
>>>>> -initrd command line option, because so far we only support passing a
>>>>> single file to test (the environment "file"). If we ever want to pass
>>>>> more files, then we'd need to create a simple file system on the initrd
>>>>> and make it possible to add -initrd even when no environment is desired.
>>>>> But, that may never happen.
>>>>>
>>>>> Thanks,
>>>>> drew
>>>>>
>>>>>> Thanks,
>>>>>>
>>>>>> Alex
>>>>>>
>>>>>>>>  		temp_file ERRATATXT "$ERRATATXT"
>>>>>>>>  		echo 'export ERRATATXT'
>>>>>>>>  	fi
>>>>>>>> @@ -95,12 +99,8 @@ function mkstandalone()
>>>>>>>>  	echo Written $standalone.
>>>>>>>>  }
>>>>>>>>  
>>>>>>>> -if [ "$TARGET" = "kvmtool" ]; then
>>>>>>>> -	echo "Standalone tests not supported with kvmtool"
>>>>>>>> -	exit 2
>>>>>>>> -fi
>>>>>>>> -
>>>>>>>> -if [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
>>>>>>>> +if [ "$TARGET" != "kvmtool" ] && [ "$ENVIRON_DEFAULT" = "yes" ] && \
>>>>>>>> +		[ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
>>>>>>>>  	echo "$ERRATATXT not found. (ERRATATXT=$ERRATATXT)" >&2
>>>>>>>>  	exit 2
>>>>>>>>  fi
>>>>>>>> -- 
>>>>>>>> 2.32.0
>>>>>>>>
>>>>>>> Thanks,
>>>>>>> drew 
>>>>>>>
