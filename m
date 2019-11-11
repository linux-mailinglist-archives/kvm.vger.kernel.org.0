Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5357EF755A
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 14:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfKKNst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 08:48:49 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44812 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbfKKNss (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 08:48:48 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABDiO3f060026;
        Mon, 11 Nov 2019 13:48:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=EpFABDWBhO8fvvUmXkAs/bCMitZ52ZZK+AWvMZhikN0=;
 b=V9EFCMqGoPrZZwTVYZjerRnqHSIiLLisgiPjMbE4MQadc5uALrBBKO820tfr0v61W7Qp
 5kckp7qDeVHk/iaf6Rk5CbEzSYSnTNpQXMjDfofcms9jf7ko2MZ0M/Yg/FjeJe98QUpw
 Bapy3P26NnA5OCWRQVdJtses3hSG16c1D03kyXV4PeI+MO9qTdmGvZz2kEVehhQ94Gos
 4DD/hjgPlY9XlWkbda9cQXjoUyiPz13Te1zQcNfCMWF1lQyWplDP1EXpq1mHmAEGtbpD
 JigD3CtMrMuwh9VkSyrUjPSfGZdtbHRstbMNiDjcTXDViHBCWK8agIi2qcWNYEBymr8B Kw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2w5p3qf0fa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 13:48:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABDcfuS166514;
        Mon, 11 Nov 2019 13:46:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2w66yxkya5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 13:46:40 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xABDkdqH002780;
        Mon, 11 Nov 2019 13:46:39 GMT
Received: from [10.74.126.113] (/10.74.126.113)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 05:46:38 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 2/2] KVM: x86: Prevent set vCPU into INIT/SIPI_RECEIVED
 state when INIT are latched
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <cff559e6-7cc4-64f3-bebf-e72dd2a5a3ea@redhat.com>
Date:   Mon, 11 Nov 2019 15:46:34 +0200
Cc:     rkrcmar@redhat.com, kvm@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Mihai Carabas <mihai.carabas@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <BB5CCF97-38DE-4037-83E3-22E921D25651@oracle.com>
References: <20191111091640.92660-1-liran.alon@oracle.com>
 <20191111091640.92660-3-liran.alon@oracle.com>
 <cff559e6-7cc4-64f3-bebf-e72dd2a5a3ea@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110130
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 11 Nov 2019, at 15:40, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 11/11/19 10:16, Liran Alon wrote:
>> -	/* INITs are latched while in SMM */
>> -	if ((is_smm(vcpu) || vcpu->arch.smi_pending) &&
>> +	/* INITs are latched while CPU is in specific states */
>> +	if ((kvm_vcpu_latch_init(vcpu) || vcpu->arch.smi_pending) &&
>> 	    (mp_state->mp_state =3D=3D KVM_MP_STATE_SIPI_RECEIVED ||
>> 	     mp_state->mp_state =3D=3D KVM_MP_STATE_INIT_RECEIVED))
>> 		goto out;
>=20
> Just a small doc clarification:
>=20
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 318046647fda..cacfe14717d6 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2707,7 +2707,8 @@ void kvm_apic_accept_events(struct kvm_vcpu =
*vcpu)
> 		return;
>=20
> 	/*
> -	 * INITs are latched while CPU is in specific states.
> +	 * INITs are latched while CPU is in specific states
> +	 * (SMM, VMX non-root mode, SVM with GIF=3D0).

I didn=E2=80=99t want this line of comment as it may diverge from the =
implementation of kvm_vcpu_latch_init().
That=E2=80=99s why I removed it.

> 	 * Because a CPU cannot be in these states immediately
> 	 * after it has processed an INIT signal (and thus in
> 	 * KVM_MP_STATE_INIT_RECEIVED state), just eat SIPIs
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 681544f8db31..11746534e209 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8706,7 +8706,11 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct =
kvm_vcpu *vcpu,
> 	    mp_state->mp_state !=3D KVM_MP_STATE_RUNNABLE)
> 		goto out;
>=20
> -	/* INITs are latched while CPU is in specific states */
> +	/*
> +	 * KVM_MP_STATE_INIT_RECEIVED means the processor is in
> +	 * INIT state; latched init should be reported using
> +	 * KVM_SET_VCPU_EVENTS, so reject it here.
> +	 */

Yes this is a good comment. Thanks for adding it.

> 	if ((kvm_vcpu_latch_init(vcpu) || vcpu->arch.smi_pending) &&
> 	    (mp_state->mp_state =3D=3D KVM_MP_STATE_SIPI_RECEIVED ||
> 	     mp_state->mp_state =3D=3D KVM_MP_STATE_INIT_RECEIVED))
>=20
>=20
> I'm not sure why you're removing the first hunk, it's just meant to
> explain why it needs to be a kvm_x86_ops in case the reader is not
> thinking about nested virtualization.
>=20
> Paolo
>=20

