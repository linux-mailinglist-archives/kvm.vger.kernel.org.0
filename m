Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0BA46E0AA3
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 11:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjDMJxa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 05:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDMJx2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 05:53:28 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D91111F;
        Thu, 13 Apr 2023 02:53:27 -0700 (PDT)
Received: from [192.168.2.41] (77-166-152-30.fixed.kpn.net [77.166.152.30])
        by linux.microsoft.com (Postfix) with ESMTPSA id 29502217924E;
        Thu, 13 Apr 2023 02:53:25 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 29502217924E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1681379606;
        bh=l047P5D4NQLb72VAy60GQ95n1JUmURyslRckcLLAEe8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=T0TKxjqFbqmR49LfsEP32JsVA9ZzvVMZykfdEH7vpeZBphPen2Iq0nQYbOlaPRTnv
         Oi32ymNqobnxZRyWHMWtP6e8FtTTcRdg4F9HQyf2OjF5jRffHaNqxAF/Q2eRxHWDxc
         /N3VBZzZXuyfGbvAgHym3qZH7LloulW89lurAfXg=
Message-ID: <61d131da-7239-6aae-753f-2eb4f1b84c24@linux.microsoft.com>
Date:   Thu, 13 Apr 2023 11:53:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] KVM: SVM: Disable TDP MMU when running on Hyper-V
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>
References: <20230227171751.1211786-1-jpiotrowski@linux.microsoft.com>
 <ZAd2MRNLw1JAXmOf@google.com>
 <959c5bce-beb5-b463-7158-33fc4a4f910c@linux.microsoft.com>
 <ZDSa9Bbqvh0btgQo@google.com>
 <ecd3d8de-859b-e5dd-c3bf-ea9c3c0aac60@linux.microsoft.com>
 <ZDWEgXM/UILjPGiG@google.com>
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <ZDWEgXM/UILjPGiG@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-20.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/11/2023 6:02 PM, Sean Christopherson wrote:
> On Tue, Apr 11, 2023, Jeremi Piotrowski wrote:
>> On 4/11/2023 1:25 AM, Sean Christopherson wrote:
>>> On Wed, Apr 05, 2023, Jeremi Piotrowski wrote:
>>>> On 3/7/2023 6:36 PM, Sean Christopherson wrote:
>>>>> Thinking about this more, I would rather revert commit 1e0c7d40758b ("KVM: SVM:
>>>>> hyper-v: Remote TLB flush for SVM") or fix the thing properly straitaway.  KVM
>>>>> doesn't magically handle the flushes correctly for the shadow/legacy MMU, KVM just
>>>>> happens to get lucky and not run afoul of the underlying bugs.  The revert appears
>>>>> to be reasonably straightforward (see bottom).
>>>>
>>>> Hi Sean,
>>>>
>>>> I'm back, and I don't have good news. The fix for the missing hyperv TLB flushes has
>>>> landed in Linus' tree and I now had the chance to test things outside Azure, in WSL on my
>>>> AMD laptop.
>>>>
>>>> There is some seriously weird interaction going on between TDP MMU and Hyper-V, with
>>>> or without enlightened TLB. My laptop has 16 vCPUs, so the WSL VM also has 16 vCPUs.
>>>> I have hardcoded the kernel to disable enlightened TLB (so we know that is not interfering).
>>>> I'm running a Flatcar Linux VM inside the WSL VM using legacy BIOS, a single CPU
>>>> and 4GB of RAM.
>>>>
>>>> If I run with `kvm.tdp_mmu=0`, I can boot and shutdown my VM consistently in 20 seconds.
>>>>
>>>> If I run with TDP MMU, the VM boot stalls for seconds at a time in various spots
>>>> (loading grub, decompressing kernel, during kernel boot), the boot output feels like
>>>> it's happening in slow motion. The fastest I see it finish the same cycle is 2 minutes,
>>>> I have also seen it take 4 minutes, sometimes even not finish at all. Same everything,
>>>> the only difference is the value of `kvm.tdp_mmu`.
>>>
>>> When a stall occurs, can you tell where the time is lost?  E.g. is the CPU stuck
>>> in L0, L1, or L2?  L2 being a single vCPU rules out quite a few scenarios, e.g.
>>> lock contention and whatnot.
>>
>> It shows up as around 90% L2 time, 10% L1 time.
> 
> Are those numbers coming from /proc/<pid>/stat?  Something else?

Yes, /proc/<pid>/stat shows that kind of ratio for the qemu process.

> 
>> I don't have great visibility into L0 time right now, I'm trying to find
>> someone who might be able to help with that.
>>
>>>
>>> If you can run perf in WSL, that might be the easiest way to suss out what's going
>>> on.
>>
>> I can run perf, what trace would help?
> 
> Good question.  I'm not exactly a perf expert and almost never do anything beyond
> `perf top`.  That's probably sufficient for now, I really just want to confirm that
> L1 doesn't appear to be stuck, e.g. in KVM's page fault handler.

Perf does not really show much anything in the L1, the 10% looks like it's vmx_flush_tlb_current.

> 
>> The results are the same for both branches, and it does look like this affects AMD and
>> Intel equally.
> 
> Nice.  I have Intel hardware at home that I'll try to repro on, though it will
> be several weeks until I can dive into this.

Same here.

> 
>> So seeing as this will likely take a while to figure out (and I know I won't be able to
>> spend too many cycles on this in the next few weeks), what do you think of a patch to
>> disable tdp_mmu in this configuration (for the time being?).
> 
> I don't particularly love the idea of disabling the TDP MMU without having the
> slightest clue what's going wrong, but I'm not totally opposed to it.
> 
> Paolo, any thoughts?  You have far more experience with supporting downstream
> consumers of KVM.
> 
>> Something else I've been wondering: in a KVM-on-KVM setup, is tdp_mmu used in both L0
>> and L1 hypervisors right now?
> 
> By default, yes.  I double checked that L2 has similar boot times for KVM-on-KVM
> with and without the TDP MMU.  Certainly nothing remotely close to 2 minutes.

Something I just noticed by tracing hv_track_root_tdp is that the VM appears to go through
some ~10000 unique roots in the period before kernel init starts (so grub + kernel decompression).
That part seems to take a long time. Is this kind of churn of roots by design?

The ftrace output for when the root changes looks something like this, kvm goes through smm emulation
during the exit.

 qemu-system-x86-18971   [015] d.... 95922.997039: kvm_exit: vcpu 0 reason EXCEPTION_NMI rip 0xfd0bd info1 0x0000000000000000 info2 0x0000000000000413 intr_info 0x80000306 error_code 0x00000000
 qemu-system-x86-18971   [015] ..... 95922.997052: p_hv_track_root_tdp_0: (hv_track_root_tdp+0x0/0x70 [kvm]) si=0x18b082000
 qemu-system-x86-18971   [015] d.... 95922.997133: kvm_entry: vcpu 0, rip 0xf7d6b

There are also root changes after IO_INSTRUCTION exits. When I look at non-tdp-mmu it seems to cycle between two
roots in that phase time, and tdp-mmu allocates new ones instead.

You can see this for yourself with this script, my test machine is Ubuntu 22.10, QEMU 7.0.0, and the
a kernel from the kvm-x86/next branch.

#!/bin/bash

set -xe

fetch_flatcar () 
{ 
    sudo apt-get install -y qemu-system-x86 lbzip2
    local channel=$1;
    local version=${2:-current};
    local machine=$(uname -m);
    local arch=;
    if [[ ${machine} = "aarch64" ]]; then
        arch=arm64-usr;
    else
        if [[ ${machine} = "x86_64" ]]; then
            arch=amd64-usr;
        fi;
    fi;
    local base=https://$channel.release.flatcar-linux.net/${arch}/${version};
    wget $base/flatcar_production_qemu.sh;
    wget $base/flatcar_production_qemu_image.img.bz2;
    lbunzip2 -kvf flatcar_production_qemu_image.img.bz2
    chmod +x flatcar_production_qemu.sh
    sed -i -e 's/VM_NCPUS=.*/VM_NCPUS="1"/' flatcar_production_qemu.sh
}

[ -f flatcar_production_qemu_image.img ] || fetch_flatcar stable

cat <<EOF >config.json
{
  "ignition": {
    "version": "3.3.0"
  },
  "storage": {
    "files": [
      {
        "group": {
          "id": 500
        },
        "overwrite": true,
        "path": "/home/core/.bashrc",
        "user": {
          "id": 500
        },
        "contents": {
          "compression": "",
          "source": "data:,sudo%20shutdown%20-h%20now%0A"
        },
        "mode": 420
      }
    ]
  }
}
EOF

# first run is meant to take a bit longer due to processing provisioning
# data, subsequent runs should be stable.
time sudo ./flatcar_production_qemu.sh -i config.json -nographic -m 4096

