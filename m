Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2693762B2
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 11:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235855AbhEGJRD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 05:17:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49896 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232642AbhEGJOG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 05:14:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620378711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=suhB8sy5uEkF9nO1YWXgUHKyAFe8zwWsrNN0GHW2SIg=;
        b=gJd6SznCu9C1lfJw9/KGmqLBDlvzJJ0+KqHwrovzvezpxoedvyr4hegcve4EQ/hE9v4fAa
        LX3m/rbw89O4LACNXkw5UBZfVeHKrDvTwhaZzuPQ3ECwzOQaJmSFqGy/ggqCryLLQ9ldxz
        bhm5MIBTDqTrrc8wOQ4AMO99gFetxxg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-Isf-IsA_MV-zk9A-MhdPag-1; Fri, 07 May 2021 05:11:48 -0400
X-MC-Unique: Isf-IsA_MV-zk9A-MhdPag-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 496E01800D50;
        Fri,  7 May 2021 09:11:46 +0000 (UTC)
Received: from [10.36.110.22] (unknown [10.36.110.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C0A9D687D2;
        Fri,  7 May 2021 09:11:37 +0000 (UTC)
Subject: Re: [PATCH] vfio: Lock down no-IOMMU mode when kernel is locked down
To:     Ondrej Mosnacek <omosnace@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     James Morris <jmorris@namei.org>,
        David Howells <dhowells@redhat.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>, kvm@vger.kernel.org,
        mjg59@srcf.ucam.org, Kees Cook <keescook@chromium.org>,
        Cornelia Huck <cohuck@redhat.com>
References: <20210506091859.6961-1-maxime.coquelin@redhat.com>
 <20210506155004.7e214d8f@redhat.com>
 <CAFqZXNswPM4nEoRwKjLY=zpnqXLF8SRAWWkhj1EL3CoODYB-=w@mail.gmail.com>
From:   Maxime Coquelin <maxime.coquelin@redhat.com>
Message-ID: <ee4b4bdb-79c1-b91c-2181-2e849cc77ef3@redhat.com>
Date:   Fri, 7 May 2021 11:11:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAFqZXNswPM4nEoRwKjLY=zpnqXLF8SRAWWkhj1EL3CoODYB-=w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/7/21 10:37 AM, Ondrej Mosnacek wrote:
> On Thu, May 6, 2021 at 11:50 PM Alex Williamson
> <alex.williamson@redhat.com> wrote:
>> On Thu,  6 May 2021 11:18:59 +0200
>> Maxime Coquelin <maxime.coquelin@redhat.com> wrote:
>>
>>> When no-IOMMU mode is enabled, VFIO is as unsafe as accessing
>>> the PCI BARs via the device's sysfs, which is locked down when
>>> the kernel is locked down.
>>>
>>> Indeed, it is possible for an attacker to craft DMA requests
>>> to modify kernel's code or leak secrets stored in the kernel,
>>> since the device is not isolated by an IOMMU.
>>>
>>> This patch introduces a new integrity lockdown reason for the
>>> unsafe VFIO no-iommu mode.
>>
>> I'm hoping security folks will chime in here as I'm not familiar with
>> the standard practices for new lockdown reasons.  The vfio no-iommu
>> backend is clearly an integrity risk, which is why it's already hidden
>> behind a separate Kconfig option, requires RAWIO capabilities, and
>> taints the kernel if it's used, but I agree that preventing it during
>> lockdown seems like a good additional step.
>>
>> Is it generally advised to create specific reasons, like done here, or
>> should we aim to create a more generic reason related to unrestricted
>> userspace DMA?

I am fine with a more generic reason. I'm also not sure what is the best
thing to do in term of granularity.

>> I understand we don't want to re-use PCI_ACCESS because the vfio
>> no-iommu backend is device agnostic, it can be used for both PCI and
>> non-PCI devices.

Right, that's why I created a new reason.

>>> Signed-off-by: Maxime Coquelin <maxime.coquelin@redhat.com>
>>> ---
>>>  drivers/vfio/vfio.c      | 13 +++++++++----
>>>  include/linux/security.h |  1 +
>>>  security/security.c      |  1 +
>>>  3 files changed, 11 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
>>> index 5e631c359ef2..fe466d6ea5d8 100644
>>> --- a/drivers/vfio/vfio.c
>>> +++ b/drivers/vfio/vfio.c
>>> @@ -25,6 +25,7 @@
>>>  #include <linux/pci.h>
>>>  #include <linux/rwsem.h>
>>>  #include <linux/sched.h>
>>> +#include <linux/security.h>
>>>  #include <linux/slab.h>
>>>  #include <linux/stat.h>
>>>  #include <linux/string.h>
>>> @@ -165,7 +166,8 @@ static void *vfio_noiommu_open(unsigned long arg)
>>>  {
>>>       if (arg != VFIO_NOIOMMU_IOMMU)
>>>               return ERR_PTR(-EINVAL);
>>> -     if (!capable(CAP_SYS_RAWIO))
>>> +     if (!capable(CAP_SYS_RAWIO) ||
>>> +                     security_locked_down(LOCKDOWN_VFIO_NOIOMMU))
>>>               return ERR_PTR(-EPERM);
>>>
>>>       return NULL;
>>> @@ -1280,7 +1282,8 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
>>>       if (atomic_read(&group->container_users))
>>>               return -EINVAL;
>>>
>>> -     if (group->noiommu && !capable(CAP_SYS_RAWIO))
>>> +     if (group->noiommu && (!capable(CAP_SYS_RAWIO) ||
>>> +                     security_locked_down(LOCKDOWN_VFIO_NOIOMMU)))
>>>               return -EPERM;
>>>
>>>       f = fdget(container_fd);
>>> @@ -1362,7 +1365,8 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
>>>           !group->container->iommu_driver || !vfio_group_viable(group))
>>>               return -EINVAL;
>>>
>>> -     if (group->noiommu && !capable(CAP_SYS_RAWIO))
>>> +     if (group->noiommu && (!capable(CAP_SYS_RAWIO) ||
>>> +                     security_locked_down(LOCKDOWN_VFIO_NOIOMMU)))
>>>               return -EPERM;
>>>
>>>       device = vfio_device_get_from_name(group, buf);
>>> @@ -1490,7 +1494,8 @@ static int vfio_group_fops_open(struct inode *inode, struct file *filep)
>>>       if (!group)
>>>               return -ENODEV;
>>>
>>> -     if (group->noiommu && !capable(CAP_SYS_RAWIO)) {
>>> +     if (group->noiommu && (!capable(CAP_SYS_RAWIO) ||
>>> +                     security_locked_down(LOCKDOWN_VFIO_NOIOMMU))) {
>>>               vfio_group_put(group);
>>>               return -EPERM;
>>>       }
>>
>> In these cases where we're testing RAWIO, the idea is to raise the
>> barrier of passing file descriptors to unprivileged users.  Is lockdown
>> sufficiently static that we might really only need the test on open?
>> The latter three cases here only make sense if the user were able to
>> open a no-iommu context when lockdown is not enabled, then lockdown is
>> later enabled preventing them from doing anything with that context...
>> but not preventing ongoing unsafe usage that might already exist.  I
>> suspect for that reason that lockdown is static and we really only need
>> the test on open.  Thanks,
> 
> Note that SELinux now also implements the locked_down hook and that
> implementation is not static like the Lockdown LSM's. It checks
> whether the current task's SELinux domain has either integrity or
> confidentiality permission granted by the policy, so for SELinux it
> makes sense to have the lockdown hook called in these other places as
> well.
> 

Thanks Ondrej for the insights, is there any plan for selinux to support
finer granularity than integrity and confidentiality? I'm not sure it
makes sense, but it might help to understand if we should choose between
a "VFIO no-iommu mode" reason and a more generic userspace DMA one.

Maxime

