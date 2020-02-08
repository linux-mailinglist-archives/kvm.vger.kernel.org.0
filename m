Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 280341564EA
	for <lists+kvm@lfdr.de>; Sat,  8 Feb 2020 15:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbgBHO6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 Feb 2020 09:58:10 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22493 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727383AbgBHO6J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 8 Feb 2020 09:58:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581173888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=SQgmkBN5tyuRu18Ue8Pwfopbm2TgdzznY4WbLOZMLIo=;
        b=ix4tWTTe26WvQoX/AxY2hOjyipE/6nR8Xz9UNEywWwdKXPfBoBFOSkh/bS4GQBAx8MD+iI
        YzbyvIHYqDN147pcucY3F4/eGHkBCkn9Vu2hps0TwM2pGGcKgYpj01cV9cSAmQRAbgpht/
        cM2ii3YY0kmWrEu+pVSyVbJ4N7x6vUw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-Oa5wX6i8NqWBgIr8LoAUeQ-1; Sat, 08 Feb 2020 09:58:06 -0500
X-MC-Unique: Oa5wX6i8NqWBgIr8LoAUeQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB4CF106BBDC;
        Sat,  8 Feb 2020 14:58:04 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-22.ams2.redhat.com [10.36.116.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 922545D9C9;
        Sat,  8 Feb 2020 14:57:59 +0000 (UTC)
Subject: Re: [PATCH 09/35] KVM: s390: protvirt: Add KVM api documentation
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
 <20200207113958.7320-10-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f7089ad6-65d2-35fc-16fb-b94e968fd4e8@redhat.com>
Date:   Sat, 8 Feb 2020 15:57:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200207113958.7320-10-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/2020 12.39, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
> 
> Add documentation for KVM_CAP_S390_PROTECTED capability and the
> KVM_S390_PV_COMMAND and KVM_S390_PV_COMMAND_VCPU ioctls.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  Documentation/virt/kvm/api.txt | 61 ++++++++++++++++++++++++++++++++++
>  1 file changed, 61 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> index 73448764f544..4874d42286ca 100644
> --- a/Documentation/virt/kvm/api.txt
> +++ b/Documentation/virt/kvm/api.txt
> @@ -4204,6 +4204,60 @@ the clear cpu reset definition in the POP. However, the cpu is not put
>  into ESA mode. This reset is a superset of the initial reset.
>  
>  
> +4.125 KVM_S390_PV_COMMAND
> +
> +Capability: KVM_CAP_S390_PROTECTED
> +Architectures: s390
> +Type: vm ioctl
> +Parameters: struct kvm_pv_cmd
> +Returns: 0 on success, < 0 on error
> +
> +struct kvm_pv_cmd {
> +	__u32	cmd;	/* Command to be executed */
> +	__u16	rc;	/* Ultravisor return code */
> +	__u16	rrc;	/* Ultravisor return reason code */
> +	__u64	data;	/* Data or address */

That remindes me ... do we maybe want a "reserved" field in here for
future extensions? Or is the "data" pointer enough?

> +};
> +
> +cmd values:
> +KVM_PV_VM_CREATE
> +Allocate memory and register the VM with the Ultravisor, thereby
> +donating memory to the Ultravisor making it inaccessible to KVM.
> +
> +KVM_PV_VM_DESTROY
> +Deregisters the VM from the Ultravisor and frees memory that was
> +donated, so the kernel can use it again. All registered VCPUs have to
> +be unregistered beforehand and all memory has to be exported or
> +shared.
> +
> +KVM_PV_VM_SET_SEC_PARMS
> +Pass the image header from VM memory to the Ultravisor in preparation
> +of image unpacking and verification.
> +
> +KVM_PV_VM_UNPACK
> +Unpack (protect and decrypt) a page of the encrypted boot image.
> +
> +KVM_PV_VM_VERIFY
> +Verify the integrity of the unpacked image. Only if this succeeds, KVM
> +is allowed to start protected VCPUs.

You also don't mention rc and rrc here ... yet another indication that
it is unused?

 Thomas

