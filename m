Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87085152175
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 21:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbgBDUTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 15:19:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52652 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727314AbgBDUTu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 15:19:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580847589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=oMgQhXVlqlsLKfJJTDk6i/8N890uL/YsZGkjCf4t5g4=;
        b=gAxUzPuEgILKy7fUVtw1SRuqttBZzVKTrZ68TS9V2vg0g/oklE+IdQi2qfGLDu2vTTSs+P
        4KJk80WU0ZOFqxABu8NUCXehcwkRjJUanXdW5sglAmw+awW19F+caxqfx6gWvsOxs+4IBf
        hI4izH6j9Ik24X7tLIhGb6A15t1oUYs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-6f59lXCyOJSJYacEmJ4acQ-1; Tue, 04 Feb 2020 15:19:47 -0500
X-MC-Unique: 6f59lXCyOJSJYacEmJ4acQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 067491137843;
        Tue,  4 Feb 2020 20:19:46 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-98.ams2.redhat.com [10.36.116.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A8E4D10018FF;
        Tue,  4 Feb 2020 20:19:41 +0000 (UTC)
Subject: Re: [RFCv2 09/37] KVM: s390: protvirt: Add KVM api documentation
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-10-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <4ec2f1f0-cfdd-3592-c2bf-5153fc2f6005@redhat.com>
Date:   Tue, 4 Feb 2020 21:19:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-10-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/2020 14.19, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
> 
> Add documentation for KVM_CAP_S390_PROTECTED capability and the
> KVM_S390_PV_COMMAND and KVM_S390_PV_COMMAND_VCPU ioctls.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  Documentation/virt/kvm/api.txt | 62 ++++++++++++++++++++++++++++++++++
>  1 file changed, 62 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> index 73448764f544..a73fdae40e26 100644
> --- a/Documentation/virt/kvm/api.txt
> +++ b/Documentation/virt/kvm/api.txt
> @@ -4204,6 +4204,61 @@ the clear cpu reset definition in the POP. However, the cpu is not put
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
> +};
> +
> +cmd values:
> +KVM_PV_VM_CREATE
> +Allocate memory and register the VM with the Ultravisor, thereby
> +donating memory to the Ultravisor making it inaccessible to KVM.
> +
> +KVM_PV_VM_DESTROY
> +Unregisters the VM from the Ultravisor and frees memory that was

s/Unregisters/Deregisters/ ?

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
> +
> +is allowed to start protected VCPUs.

Please remove the empty line between "KVM" and "is allowed".

Apart from the two nits, the patch looks fine to me.

 Thomas

