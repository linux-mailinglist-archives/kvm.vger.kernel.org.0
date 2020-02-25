Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A20616EA8D
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 16:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730275AbgBYPvQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 10:51:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32866 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728515AbgBYPvQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 10:51:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582645874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z0DlAdI9/sKGf97eqVEbAeNHhd5i8GxwMNlFZqYH+6A=;
        b=HJqcXfaTr/nB9eaa68eIDFTD1WwvUYpgEDNIJhtdSI4ijVVkHCF1WiMFTD3okbyIBmGVvd
        xcLKFjrj3M3CJBznVV2N9hGTSi1CGNg7mo5FK7aR7U9N6VA0RgnWSEyyb/IbZ+kcHSqBZr
        kVe5MoNjJ8Md3HFfqS6lmrIJ+Svd4Eg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-0xYdur1VPuedMPipNBG-IA-1; Tue, 25 Feb 2020 10:51:10 -0500
X-MC-Unique: 0xYdur1VPuedMPipNBG-IA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 115DC1902EA8;
        Tue, 25 Feb 2020 15:51:09 +0000 (UTC)
Received: from gondolin (dhcp-192-175.str.redhat.com [10.33.192.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B18065D9CD;
        Tue, 25 Feb 2020 15:51:01 +0000 (UTC)
Date:   Tue, 25 Feb 2020 16:50:59 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v4 36/36] KVM: s390: protvirt: Add KVM api documentation
Message-ID: <20200225165059.5a2f48a5.cohuck@redhat.com>
In-Reply-To: <20200224114107.4646-37-borntraeger@de.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
        <20200224114107.4646-37-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Feb 2020 06:41:07 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> Add documentation for KVM_CAP_S390_PROTECTED capability and the
> KVM_S390_PV_COMMAND ioctl.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  Documentation/virt/kvm/api.rst | 55 ++++++++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 7505d7a6c0d8..20abb8b2594e 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4648,6 +4648,51 @@ the clear cpu reset definition in the POP. However, the cpu is not put
>  into ESA mode. This reset is a superset of the initial reset.
>  
>  
> +4.125 KVM_S390_PV_COMMAND
> +-------------------------
> +
> +:Capability: KVM_CAP_S390_PROTECTED
> +:Architectures: s390
> +:Type: vm ioctl
> +:Parameters: struct kvm_pv_cmd
> +:Returns: 0 on success, < 0 on error
> +
> +::
> +
> +  struct kvm_pv_cmd {
> +	__u32 cmd;	/* Command to be executed */
> +	__u16 rc;	/* Ultravisor return code */
> +	__u16 rrc;	/* Ultravisor return reason code */
> +	__u64 data;	/* Data or address */
> +	__u32 flags;    /* flags for future extensions. Must be 0 for now */
> +	__u32 reserved[3];
> +  };
> +
> +cmd values:
> +
> +KVM_PV_ENABLE
> +  Allocate memory and register the VM with the Ultravisor, thereby
> +  donating memory to the Ultravisor making it inaccessible to KVM.
> +  Also converts all existing CPUs to protected ones. Future hotplug
> +  CPUs will become protected during creation.

"Allocate memory and register the VM with the Ultravisor, thereby
donating memory to the Ultravisor that will become inaccsessible to
KVM. All existing CPUs are converted to protected ones. After this
command has succeeded, any CPU added via hotplug will become protected
during its creation as well."

> +
> +KVM_PV_DISABLE
> +  Deregisters the VM from the Ultravisor and frees memory that was
> +  donated, so the kernel can use it again. All registered VCPUs are
> +  converted back to non-protected ones.

"Deregister the VM from the Ultravisor and reclaim the memory that had
been donated to the Ultravisor, making it usable by the kernel again.
..."

> +
> +KVM_PV_VM_SET_SEC_PARMS
> +  Pass the image header from VM memory to the Ultravisor in
> +  preparation of image unpacking and verification.
> +
> +KVM_PV_VM_UNPACK
> +  Unpack (protect and decrypt) a page of the encrypted boot image.
> +
> +KVM_PV_VM_VERIFY
> +  Verify the integrity of the unpacked image. Only if this succeeds,
> +  KVM is allowed to start protected VCPUs.
> +
> +
>  5. The kvm_run structure
>  ========================
>  
> @@ -6026,3 +6071,13 @@ Architectures: s390
>  
>  This capability indicates that the KVM_S390_NORMAL_RESET and
>  KVM_S390_CLEAR_RESET ioctls are available.
> +
> +8.23 KVM_CAP_S390_PROTECTED
> +
> +Architecture: s390
> +
> +This capability indicates that KVM can start protected VMs and the
> +Ultravisor has therefore been initialized.

"This capability indicates that the Ultravisor has been initialized and
KVM can therefore start protected VMs."

> +This will provide the new KVM_S390_PV_COMMAND ioctl and it will allow
> +KVM_MP_STATE_LOAD as new MP_STATE. KVM_SET_MP_STATE can now fail for
> +protected guests when the state change is invalid.

"This capability governs the KVM_S390_PV_COMMAND ioctl and the
KVM_MP_STATE_LOAD MP_STATE. KVM_SET_MP_STATE can fail for protected
guests when the state change is invalid."

