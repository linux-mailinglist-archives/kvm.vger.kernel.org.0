Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3E31F04C0
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 19:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390602AbfKESL2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 13:11:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34476 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390569AbfKESL1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 13:11:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572977486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UuJPrBqREAFk5jrpYh3lWuOtvA9khByTJsyWvjlERO0=;
        b=VQh4x0XwN/4od+pJNQSqeyBWgYJjo+1gqAXOQTQqnuVX9nAP/ypKcldBVL1iP+ENtLSe5R
        C1xQiCbPe4HSx7P+LrM0GLbMiYDaMCNcWFsZvopUZVFO5KgXi2awENYBLSdlUukODABelE
        7vqCE/atsAFGi/er3KOs+FYRJnLIOIY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-8kwLu3MYPqq6Ymc7xlIi9Q-1; Tue, 05 Nov 2019 13:11:23 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E37C28017E0;
        Tue,  5 Nov 2019 18:11:21 +0000 (UTC)
Received: from gondolin (unknown [10.36.118.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF84F608BB;
        Tue,  5 Nov 2019 18:11:16 +0000 (UTC)
Date:   Tue, 5 Nov 2019 19:11:13 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [RFC 16/37] KVM: s390: protvirt: Implement machine-check
 interruption injection
Message-ID: <20191105191113.655337e0.cohuck@redhat.com>
In-Reply-To: <20191024114059.102802-17-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-17-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 8kwLu3MYPqq6Ymc7xlIi9Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Oct 2019 07:40:38 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> From: Michael Mueller <mimu@linux.ibm.com>
>=20
> Similar to external interrupts, the hypervisor can inject machine
> checks by providing the right data in the interrupt injection controls.
>=20
> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
> ---
>  arch/s390/kvm/interrupt.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index c919dfe4dfd3..1f87c7d3fa3e 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -568,6 +568,14 @@ static int __write_machine_check(struct kvm_vcpu *vc=
pu,
>  =09union mci mci;
>  =09int rc;
> =20
> +=09if (kvm_s390_pv_is_protected(vcpu->kvm)) {
> +=09=09vcpu->arch.sie_block->iictl =3D IICTL_CODE_MCHK;
> +=09=09vcpu->arch.sie_block->mcic =3D mchk->mcic;
> +=09=09vcpu->arch.sie_block->faddr =3D mchk->failing_storage_address;
> +=09=09vcpu->arch.sie_block->edc =3D mchk->ext_damage_code;
> +=09=09return 0;
> +=09}
> +

The other stuff this function injects in the !pv case is inaccessible
to the hypervisor in the pv case, right? (Registers, extended save
area, ...) Maybe add a comment?

>  =09mci.val =3D mchk->mcic;
>  =09/* take care of lazy register loading */
>  =09save_fpu_regs();

