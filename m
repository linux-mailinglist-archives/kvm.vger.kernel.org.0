Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCA9669DBA4
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 09:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbjBUIFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 03:05:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbjBUIFb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 03:05:31 -0500
Received: from vulcan.natalenko.name (vulcan.natalenko.name [104.207.131.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2D1199EC;
        Tue, 21 Feb 2023 00:05:29 -0800 (PST)
Received: from mail.natalenko.name (vulcan.natalenko.name [IPv6:2001:19f0:6c00:8846:5400:ff:fe0c:dfa0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 47208123ABF8;
        Tue, 21 Feb 2023 09:05:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1676966723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G+5CEPB2tMcnsVBj0PLLoAVpUfmTuiWou62HWd5w4z8=;
        b=eE8yJQgjbslRe1LpCaNL2hyLkXWstxQMXoo8tqtXzus8oTdaeQAKq7UNFPhwHtw0VtlZvy
        QAwt7uU598RJ+/W9z5Ylsa4qaUN+68m+IEdxjqE+ZiA1dLpIY8SClIwc19kvJHs30dIpYL
        WGzGWB8bgU6WTqpI2XAIkTe1XMKy1DY=
MIME-Version: 1.0
Date:   Tue, 21 Feb 2023 09:05:22 +0100
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Kim Phillips <kim.phillips@amd.com>, tglx@linutronix.de,
        Usama Arif <usama.arif@bytedance.com>, arjan@linux.intel.com,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        Piotr Gorski <piotrgorski@cachyos.org>
Subject: Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
In-Reply-To: <5A3B7074-0C6D-472B-803B-D76541828C1F@infradead.org>
References: <20230215145425.420125-1-usama.arif@bytedance.com>
 <2668799.mvXUDI8C0e@natalenko.name>
 <ed8d662351cfe5793f8cc7e7e8c514d05d16c501.camel@infradead.org>
 <2668869.mvXUDI8C0e@natalenko.name>
 <2a67f6cf18dd2c1879fad9fd8a28242918d3e5d2.camel@infradead.org>
 <982e1d6140705414e8fd60b990bd259a@natalenko.name>
 <715CBABF-4017-4784-8F30-5386F1524830@infradead.org>
 <67dbc69f-b712-8971-f1c9-5d07f506a19c@amd.com>
 <42dc683e2846ae8fc1e09715aaf7884660e1a386.camel@infradead.org>
 <37c18c3aeea2e558633b6da6886111d0@natalenko.name>
 <5A3B7074-0C6D-472B-803B-D76541828C1F@infradead.org>
Message-ID: <3d8ed6e157df10c5175c636de0e21849@natalenko.name>
X-Sender: oleksandr@natalenko.name
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21.02.2023 08:53, David Woodhouse wrote:
> On 21 February 2023 07:27:13 GMT, Oleksandr Natalenko 
> <oleksandr@natalenko.name> wrote:
>> On 21.02.2023 00:30, David Woodhouse wrote:
>>> Oleksandr, please could you show the output of 'cpuid' after a
>>> successful resume?  I'm particularly looking for this part...
>>> 
>>> 
>>> $ sudo cpuid | grep -A1 1/ebx
>>>    miscellaneous (1/ebx):
>>>       process local APIC physical ID = 0x0 (0)
>>> --
>>>    miscellaneous (1/ebx):
>>>       process local APIC physical ID = 0x2 (2)
>>> ...
>> 
>> For me this command doesn't produce any output. Also, no output from 
>> the command Kim used in response to you. With no `grep` it just dumps 
>> a table of raw hex data.
> 
> I'll take the hex please.

Please see here: http://ix.io/4oLm

>> It's `msr-tools` 1.3-4 from Arch. Should I run this command on a 
>> patched kernel booted with `no_parallel_bringup`, or on unpatched 
>> kernel (if that makes any difference)?
> 
> Either works as long as it's after a resume that wouldn't have worked. 
> Thanks.

OK, I'm on an unpatched kernel now.

-- 
   Oleksandr Natalenko (post-factum)
