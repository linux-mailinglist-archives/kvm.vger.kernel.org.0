Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46C6F16FC65
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 11:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgBZKiz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 05:38:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36141 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726936AbgBZKiy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 05:38:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582713534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t1E99b1AW1suQBpruFYpKzqDLzcD5+Ck8romT3uCJAQ=;
        b=YcqlW53/F89weL0ybdYwJOT8KBDrsN3UhUjjFOsIpy2Bc3A2GCP1Nc87CfEoQzcrWovSau
        FzPdf591RTsHAAnN0vCM71uco7zvbJPZF042+dcvLBYr4CoiCGPm+niKMGRtmaH2sEaWmF
        Bovb4mkSsCJhzz4ziTY3TEAUPXOTB/Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-CEnIhTNZMYOTFLxJyDReAw-1; Wed, 26 Feb 2020 05:38:49 -0500
X-MC-Unique: CEnIhTNZMYOTFLxJyDReAw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB80A800EBB;
        Wed, 26 Feb 2020 10:38:47 +0000 (UTC)
Received: from gondolin (ovpn-117-69.ams2.redhat.com [10.36.117.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 179EC2718F;
        Wed, 26 Feb 2020 10:38:42 +0000 (UTC)
Date:   Wed, 26 Feb 2020 11:38:40 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     david@redhat.com, Ulrich.Weigand@de.ibm.com, frankja@linux.ibm.com,
        frankja@linux.vnet.ibm.com, gor@linux.ibm.com,
        imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, mimu@linux.ibm.com, thuth@redhat.com
Subject: Re: [PATCH v4.5 09/36] KVM: s390: protvirt: Add initial vm and cpu
 lifecycle handling
Message-ID: <20200226113840.46880055.cohuck@redhat.com>
In-Reply-To: <20200225214822.3611-1-borntraeger@de.ibm.com>
References: <f80a0b58-5ed2-33b7-5292-2c4899d765b7@redhat.com>
        <20200225214822.3611-1-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Feb 2020 16:48:22 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> This contains 3 main changes:
> 1. changes in SIE control block handling for secure guests
> 2. helper functions for create/destroy/unpack secure guests
> 3. KVM_S390_PV_COMMAND ioctl to allow userspace dealing with secure
> machines
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  24 ++-
>  arch/s390/include/asm/uv.h       |  69 ++++++++
>  arch/s390/kvm/Makefile           |   2 +-
>  arch/s390/kvm/kvm-s390.c         | 209 +++++++++++++++++++++++-
>  arch/s390/kvm/kvm-s390.h         |  33 ++++
>  arch/s390/kvm/pv.c               | 269 +++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h         |  31 ++++
>  7 files changed, 633 insertions(+), 4 deletions(-)
>  create mode 100644 arch/s390/kvm/pv.c

> +int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
> +{
> +		struct uv_cb_cgc uvcb = {

Broken indentation.

> +		.header.cmd = UVC_CMD_CREATE_SEC_CONF,
> +		.header.len = sizeof(uvcb)
> +	};
> +	int cc, ret;
> +	u16 dummy;
> +
> +	ret = kvm_s390_pv_alloc_vm(kvm);
> +	if (ret)
> +		return ret;
> +
> +	/* Inputs */
> +	uvcb.guest_stor_origin = 0; /* MSO is 0 for KVM */

What is 'MSO'? (i.e., where is that 'M' coming from?)

> +	uvcb.guest_stor_len = kvm->arch.pv.guest_len;
> +	uvcb.guest_asce = kvm->arch.gmap->asce;
> +	uvcb.guest_sca = (unsigned long)kvm->arch.sca;
> +	uvcb.conf_base_stor_origin = (u64)kvm->arch.pv.stor_base;
> +	uvcb.conf_virt_stor_origin = (u64)kvm->arch.pv.stor_var;
> +
> +	cc = uv_call(0, (u64)&uvcb);
> +	*rc = uvcb.header.rc;
> +	*rrc = uvcb.header.rrc;
> +	KVM_UV_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc %x",
> +		     uvcb.guest_handle, uvcb.guest_stor_len, *rc, *rrc);
> +
> +	/* Outputs */
> +	kvm->arch.pv.handle = uvcb.guest_handle;

Is this valid if the call failed?

> +
> +	if (cc) {
> +		if (uvcb.header.rc & UVC_RC_NEED_DESTROY)
> +			kvm_s390_pv_deinit_vm(kvm, &dummy, &dummy);
> +		else
> +			kvm_s390_pv_dealloc_vm(kvm);
> +		return -EIO;
> +	}
> +	kvm->arch.gmap->guest_handle = uvcb.guest_handle;

...especially as you assign that handle only down here.

> +	atomic_set(&kvm->mm->context.is_protected, 1);
> +	return 0;
> +}
> +
> +int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
> +			      u16 *rrc)
> +{
> +	struct uv_cb_ssc uvcb = {
> +		.header.cmd = UVC_CMD_SET_SEC_CONF_PARAMS,
> +		.header.len = sizeof(uvcb),
> +		.sec_header_origin = (u64)hdr,
> +		.sec_header_len = length,
> +		.guest_handle = kvm_s390_pv_get_handle(kvm),
> +	};
> +	int cc = uv_call(0, (u64)&uvcb);
> +
> +	*rc = uvcb.header.rc;
> +	*rrc = uvcb.header.rrc;
> +	KVM_UV_EVENT(kvm, 3, "PROTVIRT VM SET PARMS: rc %x rrc %x",
> +		     *rc, *rrc);
> +	if (cc)
> +		return -EINVAL;
> +	return 0;

Maybe
	return cc ? -EINVAL : 0;

(I assume none of the possible rcs in this case could indicate
something that does not map to -EINVAL?)

> +}

