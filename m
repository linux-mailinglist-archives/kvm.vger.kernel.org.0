Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C808F084C
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 22:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729953AbfKEV1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 16:27:35 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43976 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729698AbfKEV1e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 16:27:34 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA5LPSp1165977;
        Tue, 5 Nov 2019 21:27:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=ox0okjtqCwlJuQYS/BmX4FR8EVDcIqmTwAPCFhMTbqM=;
 b=i8zZbTZwQjWEaHbvSx2QpfIWj4hTp0C/T0Z9UA+StsQUVT9ux47H1A3Ue6Dqihbqjj3a
 iheppZIOsUj8ORMdi+X9MPs2rNhIJtX9nyf6towx8xef9IeD/uBfM1FH/HM2UeiWzO84
 LNFdi0U0ZIDlBLnta+hBvT6wB/gSDqxYQrBwLYJjG99XWNbi9tnG01EMMLnxoZ5pYNmE
 fj/5HjMj0tGSRmEO7FWzSpeHKFPL9+vnPgnkcJ7+1GPuBkRcV0BR+tXVi7q+ckKGtmk8
 G+dI0nwnpe+uumWbbU5O7bKInH0yVQUh7oCeBiRYgh0A3eOqtwJeKUbbUZPxCHIB5EN6 RA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w11rq1j8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 21:27:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA5L8to4164650;
        Tue, 5 Nov 2019 21:27:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w316238yu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 21:27:19 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA5LRIoT013292;
        Tue, 5 Nov 2019 21:27:19 GMT
Received: from [192.168.14.112] (/79.180.234.250)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Nov 2019 13:27:18 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v2 1/4] kvm: nested: Introduce read_and_check_msr_entry()
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20191105191910.56505-2-aaronlewis@google.com>
Date:   Tue, 5 Nov 2019 23:27:15 +0200
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <2BB6A84F-5D87-45D3-A30A-26B5A0BE776F@oracle.com>
References: <20191105191910.56505-1-aaronlewis@google.com>
 <20191105191910.56505-2-aaronlewis@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911050173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911050174
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 5 Nov 2019, at 21:19, Aaron Lewis <aaronlewis@google.com> wrote:
>=20
> Add the function read_and_check_msr_entry() which just pulls some code
> out of nested_vmx_store_msr() for now, however, this is in preparation
> for a change later in this series were we reuse the code in
> read_and_check_msr_entry().

Please don=E2=80=99t refer to =E2=80=9Cthis series=E2=80=9D in commit =
message.
As once this patch series will be merged, =E2=80=9Cthis series=E2=80=9D =
will be meaning-less.

Prefer to just explain what is the change that will be introduced in =
future commits that requires this change.
E.g. =E2=80=9CThis new utility function will be used by upcoming patches =
that will introduce code which search vmcs12->vm_exit_msr_store for =
specific entry."

>=20
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>

Reviewed-by: Liran Alon <liran.alon@oracle.com>

> ---
> arch/x86/kvm/vmx/nested.c | 35 ++++++++++++++++++++++-------------
> 1 file changed, 22 insertions(+), 13 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index e76eb4f07f6c..7b058d7b9fcc 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -929,6 +929,26 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu =
*vcpu, u64 gpa, u32 count)
> 	return i + 1;
> }
>=20
> +static bool read_and_check_msr_entry(struct kvm_vcpu *vcpu, u64 gpa, =
int i,
> +				     struct vmx_msr_entry *e)
> +{
> +	if (kvm_vcpu_read_guest(vcpu,
> +				gpa + i * sizeof(*e),
> +				e, 2 * sizeof(u32))) {
> +		pr_debug_ratelimited(
> +			"%s cannot read MSR entry (%u, 0x%08llx)\n",
> +			__func__, i, gpa + i * sizeof(*e));
> +		return false;
> +	}
> +	if (nested_vmx_store_msr_check(vcpu, e)) {
> +		pr_debug_ratelimited(
> +			"%s check failed (%u, 0x%x, 0x%x)\n",
> +			__func__, i, e->index, e->reserved);
> +		return false;
> +	}
> +	return true;
> +}
> +
> static int nested_vmx_store_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 =
count)
> {
> 	u64 data;
> @@ -940,20 +960,9 @@ static int nested_vmx_store_msr(struct kvm_vcpu =
*vcpu, u64 gpa, u32 count)
> 		if (unlikely(i >=3D max_msr_list_size))
> 			return -EINVAL;
>=20
> -		if (kvm_vcpu_read_guest(vcpu,
> -					gpa + i * sizeof(e),
> -					&e, 2 * sizeof(u32))) {
> -			pr_debug_ratelimited(
> -				"%s cannot read MSR entry (%u, =
0x%08llx)\n",
> -				__func__, i, gpa + i * sizeof(e));
> +		if (!read_and_check_msr_entry(vcpu, gpa, i, &e))
> 			return -EINVAL;
> -		}
> -		if (nested_vmx_store_msr_check(vcpu, &e)) {
> -			pr_debug_ratelimited(
> -				"%s check failed (%u, 0x%x, 0x%x)\n",
> -				__func__, i, e.index, e.reserved);
> -			return -EINVAL;
> -		}
> +
> 		if (kvm_get_msr(vcpu, e.index, &data)) {
> 			pr_debug_ratelimited(
> 				"%s cannot read MSR (%u, 0x%x)\n",
> --
> 2.24.0.rc1.363.gb1bccd3e3d-goog
>=20

