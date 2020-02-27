Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 695851713A4
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 10:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbgB0JFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 04:05:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35031 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728554AbgB0JFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 04:05:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582794303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e/JnuGwt/RIzUAmg6DM6H46ShUb0PP4MBCjOmt5H8X8=;
        b=NOIy2bd4CBmDdGYdYeQS2AQd7tXkbPUgr13LFNOFq8TbCY9Z9qJ3S+35BDWLNAmvURfq9p
        JSbqaIn7bh/vYJF+8ZrPlnQ2jtskFmd/Zbv2j+RmEAXVoG2LhaIf/Kv6PYtsrnfeHKSCFd
        yaMBhJ471mNw4PkI+VdQxfA/DWLZWsA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-6oipT42LOvuu82pf8m6K9A-1; Thu, 27 Feb 2020 04:04:59 -0500
X-MC-Unique: 6oipT42LOvuu82pf8m6K9A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C511D1005512;
        Thu, 27 Feb 2020 09:04:57 +0000 (UTC)
Received: from gondolin (ovpn-117-2.ams2.redhat.com [10.36.117.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD7538C08C;
        Thu, 27 Feb 2020 09:04:51 +0000 (UTC)
Date:   Thu, 27 Feb 2020 10:04:48 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Ulrich.Weigand@de.ibm.com, david@redhat.com, frankja@linux.ibm.com,
        frankja@linux.vnet.ibm.com, gor@linux.ibm.com,
        imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, mimu@linux.ibm.com, thuth@redhat.com
Subject: Re: [PATCH v4.1 36/36] KVM: s390: protvirt: Add KVM api
 documentation
Message-ID: <20200227100448.4b795562.cohuck@redhat.com>
In-Reply-To: <20200227084717.13449-1-borntraeger@de.ibm.com>
References: <a392d135-c0aa-3513-b633-70aa6c7e88bd@de.ibm.com>
        <20200227084717.13449-1-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 27 Feb 2020 03:47:17 -0500
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
>  Documentation/virt/kvm/api.rst | 59 ++++++++++++++++++++++++++++++++++
>  1 file changed, 59 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 7505d7a6c0d8..bae90f3cd11d 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4648,6 +4648,54 @@ the clear cpu reset definition in the POP. However, the cpu is not put
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
> +  donating memory to the Ultravisor that will become inaccessible to
> +  KVM. All existing CPUs are converted to protected ones. After this
> +  command has succeeded, any CPU added via hotplug will become
> +  protected during its creation as well.
> +
> +KVM_PV_DISABLE
> +
> +  Deregister the VM from the Ultravisor and reclaim the memory that
> +  had been donated to the Ultravisor, making it usable by the kernel
> +  again.  All registered VCPUs are converted back to non-protected
> +  ones.

Do you want to mention that memory might be lost on error? Or is that
too far in should-not-happen-land for callers to care about?

Anyway,
Reviewed-by: Cornelia Huck <cohuck@redhat.com>

