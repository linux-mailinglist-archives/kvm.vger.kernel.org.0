Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9ED1521C5
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 22:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbgBDVQh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 16:16:37 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57857 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727490AbgBDVQg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 16:16:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580850995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=wjVsRZ3KKIum0YIMt2pbkVgShJKZ6Rj4bXu464tRROA=;
        b=BAgL2EwTQkIluZzpYdUN4qRosiAtku+DFHFGbTODn/0dVRL3VflOaEw27KofUcW9EuobHX
        lP7iUh7G3aiTa+EzMfTkZV+fYyaC04IJWHDAlvW56NX/JOhWGbeVwLLn5WTHMJiZzUuT4T
        3vv1+uw7C/RtSBj6eog1vkZiEffPlac=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-ip7Q0K4_MHS1pE3BRLO_uw-1; Tue, 04 Feb 2020 16:16:31 -0500
X-MC-Unique: ip7Q0K4_MHS1pE3BRLO_uw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0EC685EE6C;
        Tue,  4 Feb 2020 21:16:29 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-98.ams2.redhat.com [10.36.116.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A929889E76;
        Tue,  4 Feb 2020 21:16:25 +0000 (UTC)
Subject: Re: [RFCv2 12/37] KVM: s390: protvirt: Handle SE notification
 interceptions
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-13-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f3d5a14b-2770-7c7a-3bd0-72b623b72c1a@redhat.com>
Date:   Tue, 4 Feb 2020 22:16:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-13-borntraeger@de.ibm.com>
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
> Since KVM doesn't emulate any form of load control and load psw
> instructions anymore, we wouldn't get an interception if PSWs or CRs
> are changed in the guest. That means we can't inject IRQs right after
> the guest is enabled for them.

I had to read that twice to understand it. I'd suggest maybe rather
something like:

Since there is no interception for load control and load psw instruction
in the protected mode, we need a new way to get notified whether we have
to inject an IRQ right after the guest has just enabled the possibility
for receiving them.

> The new interception codes solve that problem by being a notification

maybe s/being/providing/

> for changes to IRQ enablement relevant bits in CRs 0, 6 and 14, as
> well a the machine check mask bit in the PSW.
>=20
> No special handling is needed for these interception codes, the KVM
> pre-run code will consult all necessary CRs and PSW bits and inject
> IRQs the guest is enabled for.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  2 ++
>  arch/s390/kvm/intercept.c        | 10 ++++++++++
>  2 files changed, 12 insertions(+)
>=20
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/k=
vm_host.h
> index 841690d05080..d63ed05272ec 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -215,6 +215,8 @@ struct kvm_s390_sie_block {
>  #define ICPT_PARTEXEC	0x38
>  #define ICPT_IOINST	0x40
>  #define ICPT_KSS	0x5c
> +#define ICPT_PV_MCHKR	0x60
> +#define ICPT_PV_INT_EN	0x64
>  	__u8	icptcode;		/* 0x0050 */
>  	__u8	icptstatus;		/* 0x0051 */
>  	__u16	ihcpu;			/* 0x0052 */
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index a389fa85cca2..eaa2a21c3170 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -480,6 +480,16 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu=
)
>  	case ICPT_KSS:
>  		rc =3D kvm_s390_skey_check_enable(vcpu);
>  		break;
> +	case ICPT_PV_MCHKR:
> +		/* fallthrough */
> +	case ICPT_PV_INT_EN:
> +		/*
> +		 * PSW bit 13 or a CR (0, 6, 14) changed and we might
> +		 * now be able to deliver interrupts. The pre-run code
> +		 * will take care of this.
> +		 */
> +		rc =3D 0;
> +		break;
>  	default:
>  		return -EOPNOTSUPP;
>  	}

With "fallthrough" removed and the commit message improved:

Reviewed-by: Thomas Huth <thuth@redhat.com>

