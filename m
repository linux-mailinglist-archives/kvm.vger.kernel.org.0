Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9A35114101
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 13:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729327AbfLEMuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 07:50:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50086 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729236AbfLEMuV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 07:50:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575550220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=Hyb3ibAkZAYbAECyFhbWYbuR4iitZbKy1OZQ/jhZU9E=;
        b=Ls+umEusCq1YTRmx57goWvT1xzqQvRa2hy1A6XsSFHep/dYDQHO83eoSMUzqmpDnBhMrXv
        tLmkZMgidr2PlAKj/At1YR2nVuEIHPBXjf2jSovZPbid6SKhHdxhsvDvmgou257Wj+DIxy
        zNJy17AKed8Y8IiT2m7DQMOHyyBFCkA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-wu3KczLdMO2YjAEPyeCztg-1; Thu, 05 Dec 2019 07:50:17 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8F40911E8;
        Thu,  5 Dec 2019 12:50:15 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-87.ams2.redhat.com [10.36.116.87])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 969806106B;
        Thu,  5 Dec 2019 12:50:14 +0000 (UTC)
Subject: Re: [PATCH v4] KVM: s390: Add new reset vcpu API
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
References: <20191205131930.1b78f78b.cohuck@redhat.com>
 <20191205122810.10672-1-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <081eebc2-fbe4-d928-ad54-7e90fa06e0b2@redhat.com>
Date:   Thu, 5 Dec 2019 13:50:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191205122810.10672-1-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: wu3KczLdMO2YjAEPyeCztg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/12/2019 13.28, Janosch Frank wrote:
> The architecture states that we need to reset local IRQs for all CPU
> resets. Because the old reset interface did not support the normal CPU
> reset we never did that. Now that we have a new interface, let's
> properly clear out local IRQs.
>=20
> Also we add a ioctl for the clear reset to have all resets exposed to
> userspace. Currently the clear reset falls back to the initial reset,
> but we plan to have clear reset specific code in the future.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> ---
>  Documentation/virt/kvm/api.txt | 48 ++++++++++++++++++++++++++++++++++
>  arch/s390/kvm/kvm-s390.c       | 14 ++++++++++
>  include/uapi/linux/kvm.h       |  5 ++++
>  3 files changed, 67 insertions(+)
[...]
> +4.123 KVM_S390_CLEAR_RESET
> +
> +Capability: KVM_CAP_S390_VCPU_RESETS
> +Architectures: s390
> +Type: vcpu ioctl
> +Parameters: none
> +Returns: 0
> +
> +This ioctl resets VCPU registers and control structures that userspace
> +can't access via the kvm_run structure. It is intended to be called
> +when an initial reset (which is a superset of the normal reset) is
> +performed on the vcpu and additionally clears general, access,
> +floating and vector registers.

So now you've documented that this ioctl clears the GPRs, ARs and
FRs/VRs ... but the implementation does not! That's quite ugly.
Can you please state clearly that it is the job of userspace to clear
these registers (in the default, non-protected case) and that this ioctl
should be called on top?

Same problem with the PSW bit 24 and riccb during normal reset.

Or should the kernel code maybe also clear these in addition to
userspace, just to be in line with the initial reset?

 Thomas

