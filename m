Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1362539544
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 19:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346430AbiEaRK7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 13:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236090AbiEaRK6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 13:10:58 -0400
X-Greylist: delayed 647 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 31 May 2022 10:10:57 PDT
Received: from smarthost1.sentex.ca (smarthost1.sentex.ca [IPv6:2607:f3e0:0:1::12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F56870369
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 10:10:56 -0700 (PDT)
Received: from pyroxene2a.sentex.ca (pyroxene19.sentex.ca [199.212.134.19])
        by smarthost1.sentex.ca (8.16.1/8.16.1) with ESMTPS id 24VH07bX083114
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 13:00:07 -0400 (EDT)
        (envelope-from mike@sentex.net)
Received: from [IPV6:2607:f3e0:0:4:918:9b70:12b0:284e] ([IPv6:2607:f3e0:0:4:918:9b70:12b0:284e])
        by pyroxene2a.sentex.ca (8.16.1/8.15.2) with ESMTPS id 24VH07U6040442
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO)
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 13:00:07 -0400 (EDT)
        (envelope-from mike@sentex.net)
Message-ID: <48353e0d-e771-8a97-21d4-c65ff3bc4192@sentex.net>
Date:   Tue, 31 May 2022 13:00:07 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     kvm@vger.kernel.org
From:   mike tancsa <mike@sentex.net>
Subject: Guest migration between different Ryzen CPU generations
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 64.7.153.18
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

     I have been using kvm since the Ubuntu 18 and 20.x LTS series of 
kernels and distributions without any issues on a whole range of Guests 
up until now. Recently, we spun up an Ubuntu LTS 22 hypervisor to add to 
the mix and eventually upgrade to. Hardware is a series of Ryzen 7 CPUs 
(3700x).  Migrations back and forth without issue for Ubuntu 20.x 
kernels.  The first Ubuntu 22 machine was on identical hardware and all 
was good with that too. The second Ubuntu 22 based machine was spun up 
with a newer gen Ryzen, a 5800x.  On the initial kernel version that 
came with that release back in April, migrations worked as expected 
between hardware as well as different kernel versions and qemu / KVM 
versions that come default with the distribution. Not sure if migrations 
between kernel and KVM versions "accidentally" worked all these years, 
but they did.  However, we ran into an issue with the kernel 
5.15.0-33-generic (possibly with 5.15.0-30 as well) thats part of 
Ubuntu.  Migrations no longer worked to older generation CPUs.  I could 
send a guest TO the box and all was fine, but upon sending the guest to 
another hypervisor, the sender would see it as successfully migrated, 
but the VM would typically just hang, with 100% CPU utilization, or 
sometimes crash.  I tried a 5.18 kernel from May 22nd and again the 
behavior is different. If I specify the CPU as EPYC or EPYC-IBPB, I can 
migrate back and forth.

Quick summary

On Ubuntu 20.04 LTS with latest Ubuntu updates, I can migrate VMs back 
and forth between a 3700x and a 5800x without issue. Guests are a mix of 
Ubuntu, Fedora and FreeBSD
On Ubuntu 22 LTS, with the original kernel from release day, I can 
migrate VMs back and forth between a 3700x and a 5800x without issue
On Ubuntu 22 LTS with everything up to date as of mid May 2022, I can 
migrate from the 3700X to the 5800x without issue. But going from the 
5800x to the 3700x results in a migrated VM that either crashes inside 
the VM or has the CPU pegged at 100% spinning its wheels with the guest 
frozen and needing a hard reset. This is with --live or without and with 
--unsafe or without. The crash / hang happens once the VM is fully 
migrated with the sender thinking it was successfully sent and the 
receiver thinking it successfully arrived in.
On stock Ubuntu 22 (5.15.0-33-generic) I can migrate back and forth to 
Ubuntu 20 as long as the hardware / cpu is identical (in this case, 3700x)
On Ubuntu 22 LTS with everything up to date as of mid May 2022 with 
5.18.0-051800-generic #202205222030 SMP PREEMPT_DYNAMIC Sun May 22. I 
can migrate VMs back and forth that have as its CPU def EPYC or 
EPYC-IBPB. If the def (in my one test case anyways) is Nehalem then I 
get a frozen VM on migration back to the 3700X.

Some more details at

https://ubuntuforums.org/showthread.php?t=2475399

Is this a bug ? Expected behavior ?  Is there a better place to ask 
these questions ?

Thanks in advance!

     ---Mike

