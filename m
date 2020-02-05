Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 643EB15304B
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 13:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbgBEMCn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 07:02:43 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34895 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726277AbgBEMCm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 07:02:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580904161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=/spVCxI2tMMZk13TnZvHPVxSffYfYAEnO/6Yvm0/mVg=;
        b=I2hLgpVQQphbEBv8mQ6rdH6RIstQBWOhqEy7lqlUdnH+R28Z2dJOv6RhLbweB+t05sZ7Kk
        u+uB2OXqqKWog3paqhtmSqaW+q0bKwKAC/atUi5uGEIATEtPgObfnXUc16c4MYQatktnhE
        0o5OBU0qER2SgoW0m0pdhEwmBuV3LF0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-C2TaGf2BN4Kd93tM0mkmSg-1; Wed, 05 Feb 2020 07:02:40 -0500
X-MC-Unique: C2TaGf2BN4Kd93tM0mkmSg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9E751063BA0;
        Wed,  5 Feb 2020 12:02:38 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-132.ams2.redhat.com [10.36.116.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 81D5387B1B;
        Wed,  5 Feb 2020 12:02:34 +0000 (UTC)
Subject: Re: [RFCv2 21/37] KVM: S390: protvirt: Introduce instruction data
 area bounce buffer
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-22-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <55220810-3e2f-6312-4199-2afb583d9ff2@redhat.com>
Date:   Wed, 5 Feb 2020 13:02:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-22-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/2020 14.19, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
>=20
> Now that we can't access guest memory anymore, we have a dedicated
> sattelite block that's a bounce buffer for instruction data.
>=20
> We re-use the memop interface to copy the instruction data to / from
> userspace. This lets us re-use a lot of QEMU code which used that
> interface to make logical guest memory accesses which are not possible
> anymore in protected mode anyway.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
[...]
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index eab741bc12c3..20969ce12096 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -466,7 +466,7 @@ struct kvm_translation {
>  	__u8  pad[5];
>  };
> =20
> -/* for KVM_S390_MEM_OP */
> +/* for KVM_S390_MEM_OP and KVM_S390_SIDA_OP */
>  struct kvm_s390_mem_op {
>  	/* in */
>  	__u64 gaddr;		/* the guest address */
> @@ -475,11 +475,17 @@ struct kvm_s390_mem_op {
>  	__u32 op;		/* type of operation */
>  	__u64 buf;		/* buffer in userspace */
>  	__u8 ar;		/* the access register number */
> -	__u8 reserved[31];	/* should be set to 0 */
> +	__u8 reserved21[3];	/* should be set to 0 */
> +	__u32 offset;		/* offset into the sida */
> +	__u8 reserved28[24];	/* should be set to 0 */
>  };
> +
> +
>  /* types for kvm_s390_mem_op->op */
>  #define KVM_S390_MEMOP_LOGICAL_READ	0
>  #define KVM_S390_MEMOP_LOGICAL_WRITE	1
> +#define KVM_S390_MEMOP_SIDA_READ	2
> +#define KVM_S390_MEMOP_SIDA_WRITE	3
>  /* flags for kvm_s390_mem_op->flags */
>  #define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
>  #define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)
> @@ -1510,6 +1516,7 @@ struct kvm_pv_cmd {
>  /* Available with KVM_CAP_S390_PROTECTED */
>  #define KVM_S390_PV_COMMAND		_IOW(KVMIO, 0xc5, struct kvm_pv_cmd)
>  #define KVM_S390_PV_COMMAND_VCPU	_IOW(KVMIO, 0xc6, struct kvm_pv_cmd)
> +#define KVM_S390_SIDA_OP		_IOW(KVMIO, 0xc7, struct kvm_s390_mem_op)
> =20
>  /* Secure Encrypted Virtualization command */
>  enum sev_cmd_id {
>=20

Uh, why the mix of a new ioctl with the existing mem_op stuff? Could you
please either properly integrate this into the MEM_OP ioctl (and e.g.
use gaddr as offset for the new SIDA_READ and SIDA_WRITE subcodes), or
completely separate it for a new ioctl, i.e. introduce a new struct for
the new ioctl instead of recycling the struct kvm_s390_mem_op here?
(and in case you ask me, I'd slightly prefer to integrate everything
into MEM_OP instead of introducing a new ioctl here).

In any case, please also update Documentation/virt/kvm/api.txt with the
new SIDA functions.

 Thanks,
  Thomas

