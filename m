Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E299175D3
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 12:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbfEHKSE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 06:18:04 -0400
Received: from 7.mo2.mail-out.ovh.net ([188.165.48.182]:50151 "EHLO
        7.mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbfEHKSE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 06:18:04 -0400
X-Greylist: delayed 151951 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 May 2019 06:18:02 EDT
Received: from player734.ha.ovh.net (unknown [10.109.160.230])
        by mo2.mail-out.ovh.net (Postfix) with ESMTP id A7445191317
        for <kvm@vger.kernel.org>; Wed,  8 May 2019 12:18:01 +0200 (CEST)
Received: from kaod.org (lfbn-1-10649-41.w90-89.abo.wanadoo.fr [90.89.235.41])
        (Authenticated sender: clg@kaod.org)
        by player734.ha.ovh.net (Postfix) with ESMTPSA id F204157A1D76;
        Wed,  8 May 2019 10:17:54 +0000 (UTC)
Subject: Re: [PATCH] KVM: fix 'release' method of KVM device
To:     David Hildenbrand <david@redhat.com>, kvm-ppc@vger.kernel.org
Cc:     Paul Mackerras <paulus@samba.org>,
        David Gibson <david@gibson.dropbear.id.au>, kvm@vger.kernel.org
References: <20190507162047.17152-1-clg@kaod.org>
 <2d3bb5ca-65fe-96ff-5a4e-2ba050c41713@redhat.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <79107e6e-8562-0b39-9dec-d163ab158a47@kaod.org>
Date:   Wed, 8 May 2019 12:17:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <2d3bb5ca-65fe-96ff-5a4e-2ba050c41713@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 12454986248125516679
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrkeefgddvhecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/7/19 9:32 PM, David Hildenbrand wrote:
> On 07.05.19 18:20, Cédric Le Goater wrote:
>> There is no need to test for the device pointer validity when releasing
>> a KVM device. The file descriptor should identify it safely.
> 
> "Fix" implies it is broken. Is it broken?

no, it's not broken indeed. The changes are removing useless 
checks leftover from a previous patch. A title such as : 

   remove useless checks in 'release' method of KVM device

would be more appropriate. I can send a v2 with Alexey's rb.

Thanks,

C.

>>
>> Signed-off-by: Cédric Le Goater <clg@kaod.org>
>> ---
>>
>>  Fixes http://patchwork.ozlabs.org/patch/1087506/
>>  https://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git/commit/?h=kvm-ppc-next&id=2bde9b3ec8bdf60788e9e2ce8c07a2f8d6003dbd
>>
>>  virt/kvm/kvm_main.c | 6 ------
>>  1 file changed, 6 deletions(-)
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 161830ec0aa5..ac15b8fd8399 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -2939,12 +2939,6 @@ static int kvm_device_release(struct inode *inode, struct file *filp)
>>  	struct kvm_device *dev = filp->private_data;
>>  	struct kvm *kvm = dev->kvm;
>>  
>> -	if (!dev)
>> -		return -ENODEV;
>> -
>> -	if (dev->kvm != kvm)
>> -		return -EPERM;
>> -
>>  	if (dev->ops->release) {
>>  		mutex_lock(&kvm->lock);
>>  		list_del(&dev->vm_node);
>>
> 
> 

