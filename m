Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44172151E47
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 17:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbgBDQ13 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 11:27:29 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23657 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727331AbgBDQ13 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 11:27:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580833648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3SLppk//ApQMwF/rvA3NGuu9lEaUBa2+psuDrmQo5OU=;
        b=GcVSGf3nB+wAhrqS5+5VDN6nXVvOnM0XE6pSKEFnolGOCVnv0bSyeguBF72gNPpU5Hhpbs
        MSrbzVXUUaLsARN06wOrZY6IAGqxcc22xEej3iCaRAemgDH6ZUNbYIXeH55XEo3NE6Y2AD
        Dlg8qpxhuyqFIEbb929CpioHJTN2+uo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-1a5VJADFOxKoEdo9lZ6E6A-1; Tue, 04 Feb 2020 11:27:24 -0500
X-MC-Unique: 1a5VJADFOxKoEdo9lZ6E6A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A7051857374;
        Tue,  4 Feb 2020 16:27:23 +0000 (UTC)
Received: from gondolin (ovpn-117-199.ams2.redhat.com [10.36.117.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 948E05D9E2;
        Tue,  4 Feb 2020 16:27:21 +0000 (UTC)
Date:   Tue, 4 Feb 2020 17:27:18 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 08/37] KVM: s390: protvirt: Add initial lifecycle
 handling
Message-ID: <20200204172718.4780f011.cohuck@redhat.com>
In-Reply-To: <20200203131957.383915-9-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-9-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Feb 2020 08:19:28 -0500
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
> ---
>  arch/s390/include/asm/kvm_host.h |  24 ++-
>  arch/s390/include/asm/uv.h       |  60 ++++++++
>  arch/s390/kvm/Makefile           |   2 +-
>  arch/s390/kvm/kvm-s390.c         | 198 ++++++++++++++++++++++++-
>  arch/s390/kvm/kvm-s390.h         |  45 ++++++
>  arch/s390/kvm/pv.c               | 246 +++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h         |  33 +++++
>  7 files changed, 604 insertions(+), 4 deletions(-)
>  create mode 100644 arch/s390/kvm/pv.c
> 
(...)
> @@ -80,6 +95,32 @@ struct uv_cb_init {
>  
>  } __packed __aligned(8);
>  
> +struct uv_cb_cgc {

Given that we now have a bunch of structs of the form uv_cb_TLA, can we
add a comment to each for what uv call they are?

> +	struct uv_cb_header header;
> +	u64 reserved08[2];
> +	u64 guest_handle;
> +	u64 conf_base_stor_origin;
> +	u64 conf_var_stor_origin;
> +	u64 reserved30;
> +	u64 guest_stor_origin;
> +	u64 guest_stor_len;
> +	u64 guest_sca;
> +	u64 guest_asce;
> +	u64 reserved60[5];
> +} __packed __aligned(8);

(...)

> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> +static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
> +{
> +	int r = 0;
> +	void __user *argp = (void __user *)cmd->data;
> +
> +	switch (cmd->cmd) {
> +	case KVM_PV_VM_CREATE: {
> +		r = -EINVAL;
> +		if (kvm_s390_pv_is_protected(kvm))
> +			break;
> +
> +		r = kvm_s390_pv_alloc_vm(kvm);
> +		if (r)
> +			break;
> +
> +		mutex_lock(&kvm->lock);
> +		kvm_s390_vcpu_block_all(kvm);
> +		/* FMT 4 SIE needs esca */
> +		r = sca_switch_to_extended(kvm);
> +		if (!r)
> +			r = kvm_s390_pv_create_vm(kvm);

If sca_switch_to_extended() fails, you don't call
kvm_s390_pv_dealloc_vm(). Also, kvm_s390_pv_create_vm() _does_ call
_dealloc_vm() on failure, which seems a bit surprising. I'd probably
move the _dealloc_vm() out of the error path of _create_vm() and call
it here for r != 0.

> +		kvm_s390_vcpu_unblock_all(kvm);
> +		mutex_unlock(&kvm->lock);
> +		break;
> +	}

(...)

