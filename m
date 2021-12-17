Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22FEC478639
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 09:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbhLQIcG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 03:32:06 -0500
Received: from 6.mo552.mail-out.ovh.net ([188.165.49.222]:55225 "EHLO
        6.mo552.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbhLQIcF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 03:32:05 -0500
X-Greylist: delayed 137679 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Dec 2021 03:32:04 EST
Received: from mxplan5.mail.ovh.net (unknown [10.109.156.3])
        by mo552.mail-out.ovh.net (Postfix) with ESMTPS id E655F21A9B;
        Fri, 17 Dec 2021 07:14:43 +0000 (UTC)
Received: from kaod.org (37.59.142.102) by DAG4EX1.mxp5.local (172.16.2.31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 17 Dec
 2021 08:14:43 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-102R004079ff3d4-5572-457f-8f52-68a8f117d6f3,
                    277755725B32849AD4052F723BD6C67625B53A02) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <24a21799-89a3-4b38-2673-1e768e506044@kaod.org>
Date:   Fri, 17 Dec 2021 08:14:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH kernel v3] KVM: PPC: Merge powerpc's debugfs entry content
 into generic entry
Content-Language: en-US
To:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        <linuxppc-dev@lists.ozlabs.org>
CC:     <kvm-ppc@vger.kernel.org>, <kvm@vger.kernel.org>,
        Fabiano Rosas <farosas@linux.ibm.com>
References: <20211215013309.217102-1-aik@ozlabs.ru>
 <d980eeb7-1f32-dbd3-f60d-ea6ef24dbaaa@kaod.org>
 <e59eaa8c-6c60-521f-dc5d-d7c549a7c80f@ozlabs.ru>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <e59eaa8c-6c60-521f-dc5d-d7c549a7c80f@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.102]
X-ClientProxiedBy: DAG4EX1.mxp5.local (172.16.2.31) To DAG4EX1.mxp5.local
 (172.16.2.31)
X-Ovh-Tracer-GUID: 7837b1a5-7453-4b75-b801-3f49b2e9bf99
X-Ovh-Tracer-Id: 4099120086048934819
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvuddrleehgddutdehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvfhfhjggtgfhisehtkeertddtfeejnecuhfhrohhmpeevrogurhhitggpnfgvpgfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepieegvdffkeegfeetuddttddtveduiefhgeduffekiedtkeekteekhfffleevleelnecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrddutddvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpohhuthdphhgvlhhopehmgihplhgrnhehrdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhrtghpthhtohepfhgrrhhoshgrsheslhhinhhugidrihgsmhdrtghomh
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/21 04:07, Alexey Kardashevskiy wrote:
> 
> 
> On 12/16/21 05:11, Cédric Le Goater wrote:
>> On 12/15/21 02:33, Alexey Kardashevskiy wrote:
>>> At the moment KVM on PPC creates 3 types of entries under the kvm debugfs:
>>> 1) "%pid-%fd" per a KVM instance (for all platforms);
>>> 2) "vm%pid" (for PPC Book3s HV KVM);
>>> 3) "vm%u_vcpu%u_timing" (for PPC Book3e KVM).
>>>
>>> The problem with this is that multiple VMs per process is not allowed for
>>> 2) and 3) which makes it possible for userspace to trigger errors when
>>> creating duplicated debugfs entries.
>>>
>>> This merges all these into 1).
>>>
>>> This defines kvm_arch_create_kvm_debugfs() similar to
>>> kvm_arch_create_vcpu_debugfs().
>>>
>>> This defines 2 hooks in kvmppc_ops that allow specific KVM implementations
>>> add necessary entries, this adds the _e500 suffix to
>>> kvmppc_create_vcpu_debugfs_e500() to make it clear what platform it is for.
>>>
>>> This makes use of already existing kvm_arch_create_vcpu_debugfs() on PPC.
>>>
>>> This removes no more used debugfs_dir pointers from PPC kvm_arch structs.
>>>
>>> This stops removing vcpu entries as once created vcpus stay around
>>> for the entire life of a VM and removed when the KVM instance is closed,
>>> see commit d56f5136b010 ("KVM: let kvm_destroy_vm_debugfs clean up vCPU
>>> debugfs directories").
>>
>> It would nice to also move the KVM device debugfs files :
>>
>>     /sys/kernel/debug/powerpc/kvm-xive-%p
>>
>> These are dynamically created and destroyed at run time depending
>> on the interrupt mode negociated by CAS. It might be more complex ?
> 
> With this addition:
> 
> diff --git a/arch/powerpc/kvm/book3s_xive_native.c
> b/arch/powerpc/kvm/book3s_xive_native.c
> index 99db9ac49901..511f643e2875 100644
> --- a/arch/powerpc/kvm/book3s_xive_native.c
> +++ b/arch/powerpc/kvm/book3s_xive_native.c
> @@ -1267,10 +1267,10 @@ static void xive_native_debugfs_init(struct
> kvmppc_xive *xive)
>                  return;
>          }
> 
> -       xive->dentry = debugfs_create_file(name, 0444, arch_debugfs_dir,
> +       xive->dentry = debugfs_create_file(name, 0444,
> xive->kvm->debugfs_dentry,
>                                             xive, &xive_native_debug_fops);
> 
> 
> it looks fine, this is "before":
> 
> root@zz1:/sys/kernel/debug# find -iname "*xive*"
> ./slab/xive-provision
> ./powerpc/kvm-xive-c0000000208c0000
> ./powerpc/xive
> 
> 
> and this is "after" the patch applied.
> 
> root@zz1:/sys/kernel/debug# find -iname "*xive*"
> ./kvm/29058-11/kvm-xive-c0000000208c0000
> ./slab/xive-provision
> ./powerpc/xive
> 

I think "./kvm/29058-11/xive" should be enough now. The KVM prefix is
redundant and so is the %p which was used to distinguish VMs.

The same change could be done for the KVM XICS device.

Thanks,

C.

