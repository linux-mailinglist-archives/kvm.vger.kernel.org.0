Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEED3403CBD
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 17:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352142AbhIHPqD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 11:46:03 -0400
Received: from foss.arm.com ([217.140.110.172]:48100 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239842AbhIHPqD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 11:46:03 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D785E1FB;
        Wed,  8 Sep 2021 08:44:54 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7946C3F766;
        Wed,  8 Sep 2021 08:44:52 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC PATCH 3/5] run_tests.sh: Add kvmtool support
To:     Andrew Jones <drjones@redhat.com>
Cc:     thuth@redhat.com, pbonzini@redhat.com, lvivier@redhat.com,
        kvm-ppc@vger.kernel.org, david@redhat.com, frankja@linux.ibm.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com,
        maz@kernel.org, vivek.gautam@arm.com
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-4-alexandru.elisei@arm.com>
 <20210907101730.trnsig2j4jmhinyu@gator>
 <587a5f8c-cf04-59ec-7e35-4ca6adf87862@arm.com>
 <20210908150912.3d57akqkfux4fahj@gator>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <56289c06-04ec-1772-6e15-98d02780876d@arm.com>
Date:   Wed, 8 Sep 2021 16:46:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210908150912.3d57akqkfux4fahj@gator>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 9/8/21 4:09 PM, Andrew Jones wrote:
> On Wed, Sep 08, 2021 at 03:33:19PM +0100, Alexandru Elisei wrote:
> ...
>>>> +fixup_kvmtool_opts()
>>>> +{
>>>> +    local opts=$1
>>>> +    local groups=$2
>>>> +    local gic
>>>> +    local gic_version
>>>> +
>>>> +    if find_word "pmu" $groups; then
>>>> +        opts+=" --pmu"
>>>> +    fi
>>>> +
>>>> +    if find_word "its" $groups; then
>>>> +        gic_version=3
>>>> +        gic="gicv3-its"
>>>> +    elif [[ "$opts" =~ -machine\ *gic-version=(2|3) ]]; then
>>>> +        gic_version="${BASH_REMATCH[1]}"
>>>> +        gic="gicv$gic_version"
>>>> +    fi
>>>> +
>>>> +    if [ -n "$gic" ]; then
>>>> +        opts=${opts/-machine gic-version=$gic_version/}
>>>> +        opts+=" --irqchip=$gic"
>>>> +    fi
>>>> +
>>>> +    opts=${opts/-append/--params}
>>>> +
>>>> +    echo "$opts"
>>>> +}
>>> Hmm, I don't think we want to write a QEMU parameter translator for
>>> all other VMMs, and all other VMM architectures, that we want to
>>> support. I think we should add new "extra_params" variables to the
>>> unittest configuration instead, e.g. "kvmtool_params", where the
>>> extra parameters can be listed correctly and explicitly. While at
>>> it, I would create an alias for "extra_params", which would be
>>> "qemu_params" allowing unittests that support more than one VMM
>>> to clearly show what's what.
>> I agree, this is a much better idea than a parameter translator. Using a dedicated
>> variable in unittests.cfg will make it easier for new tests to get support for all
>> VMMs (for example, writing a list of parameters in unittests.cfg should be easier
>> than digging through the scripts to figure exactly how and where to add a
>> translation for a new parameter), and it allow us to express parameters for other
>> VMMs which don't have a direct correspondent in qemu.
>>
>> By creating an alias, do you mean replacing extra_params with qemu_params in
>> arm/unittests.cfg? Or something else?
> Probably something like this
>
> diff --git a/scripts/common.bash b/scripts/common.bash
> index 7b983f7d6dd6..e5119ff216e5 100644
> --- a/scripts/common.bash
> +++ b/scripts/common.bash
> @@ -37,7 +37,12 @@ function for_each_unittest()
>                 elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
>                         smp=${BASH_REMATCH[1]}
>                 elif [[ $line =~ ^extra_params\ *=\ *(.*)$ ]]; then
> -                       opts=${BASH_REMATCH[1]}
> +               elif [[ $line =~ ^extra_params\ *=\ *(.*)$ ]]; then
> +                       qemu_opts=${BASH_REMATCH[1]}
> +               elif [[ $line =~ ^qemu_params\ *=\ *(.*)$ ]]; then
> +                       qemu_opts=${BASH_REMATCH[1]}
> +               elif [[ $line =~ ^kvmtool_params\ *=\ *(.*)$ ]]; then
> +                       kvmtool_opts=${BASH_REMATCH[1]}
>                 elif [[ $line =~ ^groups\ *=\ *(.*)$ ]]; then
>                         groups=${BASH_REMATCH[1]}
>                 elif [[ $line =~ ^arch\ *=\ *(.*)$ ]]; then
>
> and all other changes needed to support the s/opts/qemu_opts/ change
> should work. Also, an addition to the unittests.cfg documentation.

Got it, replace extra_opts with qemu_opts in the scripts.

Yes, the documentation for unittests.cfg (at the top of the file) should
definitely be updated to document the new configuration option, kvmtool_params.

>
> The above diff doesn't consider that a unittests.cfg file could have
> both an 'extra_params' and a 'qemu_params' field, but I'm not sure
> we care about that. Users should read the documentation and we
> should review changes to the committed unittests.cfg files to avoid
> that.

What do you feel about renaming extra_params -> qemu_params in unittests.cfg? I'm
thinking it would make the usage clearer, improve consistency (we would have
qemu_params and kvmtool_params, instead of extra_params and kvmtool_params), and
remove any confusions regarding when they are used (I can see someone thinking
that extra_params are used all the time, and are appended to kvmtool_params when
--target=kvmtool). On the other hand, this could be problematic for people using
out-of-tree scripts that parse the unittest.cfg file for whatever reason (are
there people that do that?).

Thanks,

Alex

>
> Thanks,
> drew
>
