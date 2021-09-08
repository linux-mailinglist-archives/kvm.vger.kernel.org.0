Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E945E403C96
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 17:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349682AbhIHPh0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 11:37:26 -0400
Received: from foss.arm.com ([217.140.110.172]:48026 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235441AbhIHPh0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 11:37:26 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D5C6D1FB;
        Wed,  8 Sep 2021 08:36:17 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7A40E3F766;
        Wed,  8 Sep 2021 08:36:15 -0700 (PDT)
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
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <ee11a10a-c3e6-b9ce-81e1-147025a9b5bd@arm.com>
Date:   Wed, 8 Sep 2021 16:37:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210907102135.i2w3r7j4zyj736b5@gator>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 9/7/21 11:21 AM, Andrew Jones wrote:
> On Fri, Jul 02, 2021 at 05:31:21PM +0100, Alexandru Elisei wrote:
>> Add support for the standalone target when running kvm-unit-tests under
>> kvmtool.
>>
>> Example command line invocation:
>>
>> $ ./configure --target=kvmtool
>> $ make clean && make standalone
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  scripts/mkstandalone.sh | 14 +++++++-------
>>  1 file changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
>> index 16f461c06842..d84bdb7e278c 100755
>> --- a/scripts/mkstandalone.sh
>> +++ b/scripts/mkstandalone.sh
>> @@ -44,6 +44,10 @@ generate_test ()
>>  	config_export ARCH_NAME
>>  	config_export PROCESSOR
>>  
>> +	if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "arm" ]; then
>> +		config_export TARGET
>> +	fi
> Should export unconditionally, since we'll want TARGET set
> unconditionally.

Yes, will do.

>
>> +
>>  	echo "echo BUILD_HEAD=$(cat build-head)"
>>  
>>  	if [ ! -f $kernel ]; then
>> @@ -59,7 +63,7 @@ generate_test ()
>>  		echo 'export FIRMWARE'
>>  	fi
>>  
>> -	if [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ]; then
>> +	if [ "$TARGET" != "kvmtool" ] && [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ]; then
> I think it would be better to ensure that ENVIRON_DEFAULT is "no" for
> TARGET=kvmtool in configure.

From looking at the code, it is my understanding that with ENVIRON_DEFAULT=yes, an
initrd file is generated with the contents of erratatxt and other information, in
a key=value pair format. This initrd is then passed on to the test (please correct
me if I'm wrong). With ENVIRON_DEFAULT=no (set via ./configure
--disable-default-environ), this initrd is not generated.

kvmtool doesn't have support for passing an initrd when loading firmware, so yes,
I believe the default should be no.

However, I have two questions:

1. What happens when the user specifically enables the default environ via
./configure --enable-default-environ --target=kvmtool? In my opinion, that should
be an error because the user wants something that is not possible with kvmtool
(loading an image with --firmware in kvmtool means that the initrd image it not
loaded into the guest memory and no node is generated for it in the dtb), but I
would like to hear your thoughts about it.

2. If the default environment is disabled, is it still possible for an user to
pass an initrd via other means? I couldn't find where that is implemented, so I'm
guessing it's not possible.

Thanks,

Alex

>
>
>>  		temp_file ERRATATXT "$ERRATATXT"
>>  		echo 'export ERRATATXT'
>>  	fi
>> @@ -95,12 +99,8 @@ function mkstandalone()
>>  	echo Written $standalone.
>>  }
>>  
>> -if [ "$TARGET" = "kvmtool" ]; then
>> -	echo "Standalone tests not supported with kvmtool"
>> -	exit 2
>> -fi
>> -
>> -if [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
>> +if [ "$TARGET" != "kvmtool" ] && [ "$ENVIRON_DEFAULT" = "yes" ] && \
>> +		[ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
>>  	echo "$ERRATATXT not found. (ERRATATXT=$ERRATATXT)" >&2
>>  	exit 2
>>  fi
>> -- 
>> 2.32.0
>>
> Thanks,
> drew 
>
