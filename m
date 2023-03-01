Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 785C16A6AE0
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 11:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjCAKfN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 05:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjCAKfK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 05:35:10 -0500
Received: from devnull.tasossah.com (devnull.tasossah.com [IPv6:2001:41d0:1:e60e::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99000305ED
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 02:35:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=devnull.tasossah.com; s=vps; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:Subject:References:Cc:To:From:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OBuPW6i4X5Ys8HJh2D9EDrbkm76m4Z2GvX39JdOYUM8=; b=BgGj34JNIaqdOvslukhZ6Sg8dA
        njbzLG8MemdZR6wXP8/1RRQubJQYrpzVwpFAUkiufggT8GHNQhxNuC0mRzu+h6JUsYdkx+fh09KBK
        vXZwrodP2Lu6WEkMUwj/pKzT7AsduYmREP4dxqDQoH7K3Pvz+bpkN5f0z93rQkAK731s=;
Received: from [2a02:587:6a08:c500::298]
        by devnull.tasossah.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <tasos@tasossah.com>)
        id 1pXJnH-00CCR6-8Q; Wed, 01 Mar 2023 12:34:43 +0200
Message-ID: <7c1980ec-d032-11c1-b09d-4db40611f268@tasossah.com>
Date:   Wed, 1 Mar 2023 12:34:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   Tasos Sahanidis <tasos@tasossah.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Abhishek Sahu <abhsahu@nvidia.com>, kvm@vger.kernel.org
References: <a01fa87d-bd42-e108-606b-78759edcecf8@tasossah.com>
 <bcc9d355-b464-7eaf-238c-e95d2f65c93d@nvidia.com>
 <31c2caf4-57b2-be1a-cf15-146903f7b2a1@tasossah.com>
 <20230228114606.446e8db2.alex.williamson@redhat.com>
Content-Language: en-US
Subject: Re: Bug: Completion-Wait loop timed out with vfio
In-Reply-To: <20230228114606.446e8db2.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-02-28 20:46, Alex Williamson wrote:
> Can you do the same for the root port to the GPU, ex. use lspci -t to
> find the parent root port.  Since the device doesn't seem to be
> achieving D3cold (expected on a desktop system), the other significant
> change of the identified commit is that the root port will also enter a
> low power state.  Prior to that commit the device would enter D3hot, but
> we never touched the root port.  Perhaps confirm the root port now
> enters D3hot and compare lspci for the root port when using
> disable_idle_d3 to that found when trying to use the device without
> disable_idle_d3. Thanks,
> 
> Alex
> 

I seem to have trouble understanding the lspci tree.

The tree is as follows:

-[0000:00]-+-00.0  Advanced Micro Devices, Inc. [AMD] Starship/Matisse Root Complex
[...]      |
           +-01.2-[02-0d]----00.0-[03-0d]--+-01.0-[04-05]----00.0-[05]--+-00.0  Creative Labs EMU10k2/CA0100/CA0102/CA10200 [Sound Blaster Audigy Series]
           |                               |                            +-00.1  Creative Labs SB Audigy Game Port
           |                               |                            +-01.0  Brooktree Corporation Bt878 Video Capture
           |                               |                            \-01.1  Brooktree Corporation Bt878 Audio Capture
           |                               +-02.0-[06]--+-00.0  Advanced Micro Devices, Inc. [AMD/ATI] Bonaire XT [Radeon HD 7790/8770 / R7 360 / R9 260/360 OEM]
           |                               |            \-00.1  Advanced Micro Devices, Inc. [AMD/ATI] Tobago HDMI Audio [Radeon R7 360 / R9 360 OEM]
           |                               +-03.0-[07-08]----00.0-[08]--+-00.0  Philips Semiconductors SAA7131/SAA7133/SAA7135 Video Broadcast Decoder
           |                               |                            \-01.0  Yamaha Corporation YMF-744B [DS-1S Audio Controller]
           |                               +-05.0-[09]----00.0  Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller
           |                               +-06.0-[0a]--+-00.0  MosChip Semiconductor Technology Ltd. PCIe 9912 Multi-I/O Controller
           |                               |            +-00.1  MosChip Semiconductor Technology Ltd. PCIe 9912 Multi-I/O Controller
           |                               |            \-00.2  MosChip Semiconductor Technology Ltd. PCIe 9912 Multi-I/O Controller
           |                               +-08.0-[0b]--+-00.0  Advanced Micro Devices, Inc. [AMD] Starship/Matisse Reserved SPP
           |                               |            +-00.1  Advanced Micro Devices, Inc. [AMD] Matisse USB 3.0 Host Controller
           |                               |            \-00.3  Advanced Micro Devices, Inc. [AMD] Matisse USB 3.0 Host Controller
           |                               +-09.0-[0c]----00.0  Advanced Micro Devices, Inc. [AMD] FCH SATA Controller [AHCI mode]
           |                               \-0a.0-[0d]----00.0  Advanced Micro Devices, Inc. [AMD] FCH SATA Controller [AHCI mode]
[...]      |

The parent root port is either 0000:00:01.2 or 0000:00:02.0, correct?
00:01.2 PCI bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse GPP Bridge
02:00.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Matisse Switch Upstream

If so, I tested in 5.18, both before and while running the VM, with 6.2
both with and without disable_idle_d3, and in all cases they stayed at D0.

Only difference was the card itself would be at D0 instead of D3hot with
disable_idle_d3. In the working 5.18, without disable_idle_d3, it would
still enter D3hot.

==> 5_18_before_vm <==
# cat /sys/bus/pci/devices/0000:02:00.0/power_state
D0
# cat /sys/bus/pci/devices/0000:02:00.0/power/runtime_status
active
# cat /sys/bus/pci/devices/0000:00:01.2/power_state
D0
# cat /sys/bus/pci/devices/0000:00:01.2/power/runtime_status
active
# cat /sys/bus/pci/devices/0000:00:02.0/power_state
unknown
# cat /sys/bus/pci/devices/0000:00:02.0/power/runtime_status
active
# cat /sys/bus/pci/devices/0000:06:00.0/power_state
D3hot
# cat /sys/bus/pci/devices/0000:06:00.0/power/runtime_status
active

==> 5_18_running_vm <==
# cat /sys/bus/pci/devices/0000:02:00.0/power_state
D0
# cat /sys/bus/pci/devices/0000:02:00.0/power/runtime_status
active
# cat /sys/bus/pci/devices/0000:00:01.2/power_state
D0
# cat /sys/bus/pci/devices/0000:00:01.2/power/runtime_status
active
# cat /sys/bus/pci/devices/0000:00:02.0/power_state
unknown
# cat /sys/bus/pci/devices/0000:00:02.0/power/runtime_status
active
# cat /sys/bus/pci/devices/0000:06:00.0/power_state
D0
# cat /sys/bus/pci/devices/0000:06:00.0/power/runtime_status
active

==> 6_2_before_vm <==
# cat /sys/bus/pci/devices/0000:02:00.0/power_state
D0
# cat /sys/bus/pci/devices/0000:02:00.0/power/runtime_status
active
# cat /sys/bus/pci/devices/0000:00:01.2/power_state
D0
# cat /sys/bus/pci/devices/0000:00:01.2/power/runtime_status
active
# cat /sys/bus/pci/devices/0000:00:02.0/power_state
unknown
# cat /sys/bus/pci/devices/0000:00:02.0/power/runtime_status
active
# cat /sys/bus/pci/devices/0000:06:00.0/power_state
D3hot
# cat /sys/bus/pci/devices/0000:06:00.0/power/runtime_status
suspended

==> 6_2_running_vm <==
# cat /sys/bus/pci/devices/0000:02:00.0/power_state
D0
# cat /sys/bus/pci/devices/0000:02:00.0/power/runtime_status
active
# cat /sys/bus/pci/devices/0000:00:01.2/power_state
D0
# cat /sys/bus/pci/devices/0000:00:01.2/power/runtime_status
active
# cat /sys/bus/pci/devices/0000:00:02.0/power_state
unknown
# cat /sys/bus/pci/devices/0000:00:02.0/power/runtime_status
active
# cat /sys/bus/pci/devices/0000:06:00.0/power_state
D0
# cat /sys/bus/pci/devices/0000:06:00.0/power/runtime_status
active

==> 6_2_before_vm_disable_idle_d3 <==
# cat /sys/bus/pci/devices/0000:02:00.0/power_state
D0
# cat /sys/bus/pci/devices/0000:02:00.0/power/runtime_status
active
# cat /sys/bus/pci/devices/0000:00:01.2/power_state
D0
# cat /sys/bus/pci/devices/0000:00:01.2/power/runtime_status
active
# cat /sys/bus/pci/devices/0000:00:02.0/power_state
unknown
# cat /sys/bus/pci/devices/0000:00:02.0/power/runtime_status
active
# cat /sys/bus/pci/devices/0000:06:00.0/power_state
D0
# cat /sys/bus/pci/devices/0000:06:00.0/power/runtime_status
active

==> 6_2_running_vm_disable_idle_d3 <==
# cat /sys/bus/pci/devices/0000:02:00.0/power_state
D0
# cat /sys/bus/pci/devices/0000:02:00.0/power/runtime_status
active
# cat /sys/bus/pci/devices/0000:00:01.2/power_state
D0
# cat /sys/bus/pci/devices/0000:00:01.2/power/runtime_status
active
# cat /sys/bus/pci/devices/0000:00:02.0/power_state
unknown
# cat /sys/bus/pci/devices/0000:00:02.0/power/runtime_status
active
# cat /sys/bus/pci/devices/0000:06:00.0/power_state
D0
# cat /sys/bus/pci/devices/0000:06:00.0/power/runtime_status
active

0000:00:02.0 is Host bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PCIe Dummy Host Bridge
and can presumably be ignored.

--
Tasos
