Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECAAB53BB63
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 17:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236398AbiFBPJU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 11:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236405AbiFBPJS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 11:09:18 -0400
Received: from smarthost1.sentex.ca (smarthost1.sentex.ca [IPv6:2607:f3e0:0:1::12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 684CD201FC8
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 08:09:15 -0700 (PDT)
Received: from pyroxene2a.sentex.ca (pyroxene19.sentex.ca [199.212.134.19])
        by smarthost1.sentex.ca (8.16.1/8.16.1) with ESMTPS id 252F9B6R087959
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 2 Jun 2022 11:09:11 -0400 (EDT)
        (envelope-from mike@sentex.net)
Received: from [IPV6:2607:f3e0:0:4:5de0:5d15:a6e7:845e] ([IPv6:2607:f3e0:0:4:5de0:5d15:a6e7:845e])
        by pyroxene2a.sentex.ca (8.16.1/8.15.2) with ESMTPS id 252F9B2A011515
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Thu, 2 Jun 2022 11:09:11 -0400 (EDT)
        (envelope-from mike@sentex.net)
Message-ID: <489ddcdf-e38f-ea51-6f90-8c17358da61d@sentex.net>
Date:   Thu, 2 Jun 2022 11:09:11 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Guest migration between different Ryzen CPU generations
Content-Language: en-US
To:     Igor Mammedov <imammedo@redhat.com>
Cc:     kvm@vger.kernel.org, Leonardo Bras <leobras@redhat.com>
References: <48353e0d-e771-8a97-21d4-c65ff3bc4192@sentex.net>
 <20220602144200.1228b7bb@redhat.com>
From:   mike tancsa <mike@sentex.net>
In-Reply-To: <20220602144200.1228b7bb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 64.7.153.18
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/2/2022 8:42 AM, Igor Mammedov wrote:
> On Tue, 31 May 2022 13:00:07 -0400
> mike tancsa <mike@sentex.net> wrote:
>
>> Hello,
>>
>>       I have been using kvm since the Ubuntu 18 and 20.x LTS series of
>> kernels and distributions without any issues on a whole range of Guests
>> up until now. Recently, we spun up an Ubuntu LTS 22 hypervisor to add to
>> the mix and eventually upgrade to. Hardware is a series of Ryzen 7 CPUs
>> (3700x).  Migrations back and forth without issue for Ubuntu 20.x
>> kernels.  The first Ubuntu 22 machine was on identical hardware and all
>> was good with that too. The second Ubuntu 22 based machine was spun up
>> with a newer gen Ryzen, a 5800x.  On the initial kernel version that
>> came with that release back in April, migrations worked as expected
>> between hardware as well as different kernel versions and qemu / KVM
>> versions that come default with the distribution. Not sure if migrations
>> between kernel and KVM versions "accidentally" worked all these years,
>> but they did.  However, we ran into an issue with the kernel
>> 5.15.0-33-generic (possibly with 5.15.0-30 as well) thats part of
>> Ubuntu.  Migrations no longer worked to older generation CPUs.  I could
>> send a guest TO the box and all was fine, but upon sending the guest to
>> another hypervisor, the sender would see it as successfully migrated,
>> but the VM would typically just hang, with 100% CPU utilization, or
>> sometimes crash.  I tried a 5.18 kernel from May 22nd and again the
>> behavior is different. If I specify the CPU as EPYC or EPYC-IBPB, I can
>> migrate back and forth.
> perhaps you are hitting issue fixed by:
> https://lore.kernel.org/lkml/CAJ6HWG66HZ7raAa+YK0UOGLF+4O3JnzbZ+a-0j8GNixOhLk9dA@mail.gmail.com/T/
>
Thanks for the response. I am not sure. That patch is from Feb. Would 
the bug have been introduced sometime in May to the 5.15 kernel than 
Ubuntu 22 would have tracked ?

Looking at the CPU flags diff between the 5800 and the 3700,

diff -u 3700x 5800x
--- 3700x       2022-06-02 14:57:00.331309878 +0000
+++ 5800x       2022-06-02 14:56:52.403340136 +0000
@@ -77,6 +77,7 @@
  hw_pstate
  ssbd
  mba
+ibrs
  ibpb
  stibp
  vmmcall
@@ -85,6 +86,8 @@
  avx2
  smep
  bmi2
+erms
+invpcid
  cqm
  rdt_a
  rdseed
@@ -122,13 +125,15 @@
  vgif
  v_spec_ctrl
  umip
+pku
+ospke
+vaes
+vpclmulqdq
  rdpid
  overflow_recov
  succor
  smca
-sme
-sev
-sev_es
+fsrm
  bugs
  sysret_ss_attrs
  spectre_v1



>> Quick summary
>>
>> On Ubuntu 20.04 LTS with latest Ubuntu updates, I can migrate VMs back
>> and forth between a 3700x and a 5800x without issue. Guests are a mix of
>> Ubuntu, Fedora and FreeBSD
>> On Ubuntu 22 LTS, with the original kernel from release day, I can
>> migrate VMs back and forth between a 3700x and a 5800x without issue
>> On Ubuntu 22 LTS with everything up to date as of mid May 2022, I can
>> migrate from the 3700X to the 5800x without issue. But going from the
>> 5800x to the 3700x results in a migrated VM that either crashes inside
>> the VM or has the CPU pegged at 100% spinning its wheels with the guest
>> frozen and needing a hard reset. This is with --live or without and with
>> --unsafe or without. The crash / hang happens once the VM is fully
>> migrated with the sender thinking it was successfully sent and the
>> receiver thinking it successfully arrived in.
>> On stock Ubuntu 22 (5.15.0-33-generic) I can migrate back and forth to
>> Ubuntu 20 as long as the hardware / cpu is identical (in this case, 3700x)
>> On Ubuntu 22 LTS with everything up to date as of mid May 2022 with
>> 5.18.0-051800-generic #202205222030 SMP PREEMPT_DYNAMIC Sun May 22. I
>> can migrate VMs back and forth that have as its CPU def EPYC or
>> EPYC-IBPB. If the def (in my one test case anyways) is Nehalem then I
>> get a frozen VM on migration back to the 3700X.
>>
>> Some more details at
>>
>> https://ubuntuforums.org/showthread.php?t=2475399
>>
>> Is this a bug ? Expected behavior ?  Is there a better place to ask
>> these questions ?
>>
>> Thanks in advance!
>>
>>       ---Mike
>>
>
