Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61F3816A72F
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 14:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbgBXNVc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 08:21:32 -0500
Received: from foss.arm.com ([217.140.110.172]:37010 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727329AbgBXNVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 08:21:31 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B08A30E;
        Mon, 24 Feb 2020 05:21:31 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F2E153F534;
        Mon, 24 Feb 2020 05:21:29 -0800 (PST)
Subject: Re: kvm-unit-tests : Kconfigs and extra kernel args for full coverage
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        kvm list <kvm@vger.kernel.org>, lkft-triage@lists.linaro.org
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, yzt356@gmail.com,
        jmattson@google.com, Paolo Bonzini <pbonzini@redhat.com>,
        namit@vmware.com, sean.j.christopherson@intel.com,
        Basil Eljuse <Basil.Eljuse@arm.com>,
        Andrew Jones <drjones@redhat.com>
References: <CA+G9fYvx=WzyJqS4fUFLq8qXT8nbFQoFfXZoeL9kP-hvv549EA@mail.gmail.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <c82f4386-702f-a2e9-a4d7-d5ebb1f335d1@arm.com>
Date:   Mon, 24 Feb 2020 13:21:23 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CA+G9fYvx=WzyJqS4fUFLq8qXT8nbFQoFfXZoeL9kP-hvv549EA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Naresh,

On 2/24/20 12:53 PM, Naresh Kamboju wrote:
> [Sorry for the spam]
>
> Greeting from Linaro !
> We are running kvm-unit-tests on our CI Continuous Integration and
> testing on x86_64 and arm64 Juno-r2.
> Linux stable branches and Linux mainline and Linux next.
>
> Few tests getting fail and skipped, we are interested in increasing the
> test coverage by adding required kernel config fragments,
> kernel command line arguments and user space tools.
>
> Your help is much appreciated.
>
> Here is the details of the LKFT kvm unit test logs,
>
> [..]

I am going to comment on the arm64 tests. As far as I am aware, you don't need any
kernel configs to run the tests.

From looking at the java log [1], I can point out a few things:

- The gicv3 tests are failing because Juno has a gicv2 and the kernel refuses to
create a virtual gicv3. It's normal.

- I am not familiar with the PMU test, so I cannot help you with that.

- Without the logs, it's hard for me to say why the micro-bench test is failing.
Can you post the logs for that particular run? They are located in
/path/to/kvm-unit-tests/logs/micro-bench.log. My guess is that it has to do with
the fact that you are using taskset to keep the tests on one CPU. Micro-bench will
use 2 VCPUs to send 2^28 IPIs which will run on the same physical CPU, and sending
and receiving them will be serialized which will incur a *lot* of overhead. I
tried the same test without taskset, and it worked. With taskset -c 0, it timed
out like in your log.

- there are also other tests that spawn multiple VCPUs, using taskset will
serialize the VCPUs and will probably hide any potential locking issues.

[1]|https://lkft.validation.linaro.org/scheduler/job/1242488|

|Thanks,|
|Alex|
||||
