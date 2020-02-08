Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5AE1564DD
	for <lists+kvm@lfdr.de>; Sat,  8 Feb 2020 15:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgBHOzF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 Feb 2020 09:55:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52713 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727303AbgBHOzF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Feb 2020 09:55:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581173703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=1a3yQdqw8IYuIFpzy/Qyf9eqTda8rOHfhh1VPD08Oww=;
        b=T+LYxfs2VzJ8R07aPIIYfHtcFkCkle0dEhpOBo18IYnVxiniK1VaHdQjYnnf1OLiq9otJR
        FzuN2o3nuQj11ac68umQnjhvTwT8WLcunfDxbFPJ9PD2hogHelx/W25emgWdrKksF+FvkP
        N+zDWdHNeadaqiGwME4j7xo3BUeNb3Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-KCVSfPdhP_ejkqhYhr8m6g-1; Sat, 08 Feb 2020 09:54:59 -0500
X-MC-Unique: KCVSfPdhP_ejkqhYhr8m6g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E05A18014C1;
        Sat,  8 Feb 2020 14:54:56 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-22.ams2.redhat.com [10.36.116.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BC3031001B34;
        Sat,  8 Feb 2020 14:54:51 +0000 (UTC)
Subject: Re: [PATCH 08/35] KVM: s390: protvirt: Add initial lifecycle handling
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
 <20200207113958.7320-9-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <2e5203d7-e162-ddd6-9281-44aa34fe32e7@redhat.com>
Date:   Sat, 8 Feb 2020 15:54:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200207113958.7320-9-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/2020 12.39, Christian Borntraeger wrote:
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
>  arch/s390/include/asm/uv.h       |  69 +++++++++
>  arch/s390/kvm/Makefile           |   2 +-
>  arch/s390/kvm/kvm-s390.c         | 191 +++++++++++++++++++++++-
>  arch/s390/kvm/kvm-s390.h         |  27 ++++
>  arch/s390/kvm/pv.c               | 244 +++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h         |  33 +++++
>  7 files changed, 586 insertions(+), 4 deletions(-)
>  create mode 100644 arch/s390/kvm/pv.c
[...]
> +struct kvm_pv_cmd {
> +	__u32	cmd;	/* Command to be executed */
> +	__u16	rc;	/* Ultravisor return code */
> +	__u16	rrc;	/* Ultravisor return reason code */

What are rc and rrc good for? I currently can't spot the code where they
are used...

> +	__u64	data;	/* Data or address */
> +};
> +
> +/* Available with KVM_CAP_S390_PROTECTED */
> +#define KVM_S390_PV_COMMAND		_IOW(KVMIO, 0xc5, struct kvm_pv_cmd)
> +#define KVM_S390_PV_COMMAND_VCPU	_IOW(KVMIO, 0xc6, struct kvm_pv_cmd)

If you intend to return values in rc and rrc, shouldn't this rather be
declared as _IOWR instead ?

 Thomas

