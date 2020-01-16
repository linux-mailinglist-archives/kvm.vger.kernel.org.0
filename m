Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26C1C13D12A
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 01:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbgAPAcM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 19:32:12 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47430 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729110AbgAPAcM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 19:32:12 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G0DCSG195884;
        Thu, 16 Jan 2020 00:32:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=fZoA3Mkurgsgn5osZjIdYEva/h4cuaGBHzs43O+G62c=;
 b=jKAoGBCl2/rJWCFOHinuxG3gGo2+EWH+bkhMpf4XbrYA+s0pqtOXgqbcJ2MNosY9qIla
 09X/HOptUUcGklN3avfcq8KHbdrQvssdfnPmELCrNpRiPYNzoJ9P24Qtn695rT05Fhlz
 BdqQwkvUtaJae8tNyRF3IxFBzh4IYHk0i6RmpI1SeKxxuODaKnRdHBNOnVKEBlyOsU57
 QmW/41nRAXgciuYQA/m/nwhbK4+ZEtKGNmx8NlP575+NRjYlfhYEEtqh2ShVkpYNd0YY
 +Vpvz/V5N8221IDnQkdsn/T8fWCrCW2zFFoTJKnCmUNAv6ol1Rzsr2KeQbdSnFLOzvLb Uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xf74sfgcy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 00:32:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G0TVSt177405;
        Thu, 16 Jan 2020 00:32:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2xj1ps3nas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 00:32:07 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00G0W6SY000756;
        Thu, 16 Jan 2020 00:32:06 GMT
Received: from [192.168.14.112] (/109.66.225.253)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 16:32:06 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] kvm: x86: Don't dirty guest memory on every vcpu_put()
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20200116001635.174948-1-jmattson@google.com>
Date:   Thu, 16 Jan 2020 02:32:02 +0200
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Kevin Mcgaire <kevinmcgaire@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FE5AE42B-107F-4D7E-B728-E33780743434@oracle.com>
References: <20200116001635.174948-1-jmattson@google.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160000
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 16 Jan 2020, at 2:16, Jim Mattson <jmattson@google.com> wrote:
>=20
> Beginning with commit 0b9f6c4615c99 ("x86/kvm: Support the vCPU
> preemption check"), the KVM_VCPU_PREEMPTED flag is set in the guest
> copy of the kvm_steal_time struct on every call to vcpu_put(). As a
> result, guest memory is dirtied on every call to vcpu_put(), even when
> the VM is quiescent.
>=20
> To avoid dirtying guest memory unnecessarily, don't bother setting the
> flag in the guest copy of the struct if it is already set in the
> kernel copy of the struct.

I suggest adding this comment to code as-well.

>=20
> If a different vCPU thread clears the guest copy of the flag, it will
> no longer get reset on the next call to vcpu_put, but it's not clear
> that resetting the flag in this case was intentional to begin with.

I agree=E2=80=A6 I find it hard to believe that guest vCPU is allowed to =
clear the flag
and expect host to set it again on the next vcpu_put() call. Doesn=E2=80=99=
t really make sense.

>=20
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Tested-by: Kevin Mcgaire <kevinmcgaire@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Reviewed-by: Oliver Upton <oupton@google.com>

Good catch.
Reviewed-by: Liran Alon <liran.alon@oracle.com>

-Liran

>=20
> ---
> arch/x86/kvm/x86.c | 3 +++
> 1 file changed, 3 insertions(+)
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cf917139de6b..3dc17b173f88 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3504,6 +3504,9 @@ static void kvm_steal_time_set_preempted(struct =
kvm_vcpu *vcpu)
> 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
> 		return;
>=20
> +	if (vcpu->arch.st.steal.preempted & KVM_VCPU_PREEMPTED)
> +		return;
> +
> 	vcpu->arch.st.steal.preempted =3D KVM_VCPU_PREEMPTED;
>=20
> 	kvm_write_guest_offset_cached(vcpu->kvm, &vcpu->arch.st.stime,
> --=20
> 2.25.0.rc1.283.g88dfdc4193-goog
>=20

