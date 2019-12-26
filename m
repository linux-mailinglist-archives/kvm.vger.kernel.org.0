Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A481112A965
	for <lists+kvm@lfdr.de>; Thu, 26 Dec 2019 01:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfLZAWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Dec 2019 19:22:45 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56782 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfLZAWp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Dec 2019 19:22:45 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBQ0El2c096450;
        Thu, 26 Dec 2019 00:21:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=FidDFb56tOGvXdSrIBlld65Mx8wH8w5gd9U+5ufUXEs=;
 b=bCOd9wrkNlLbvtJbWl81N4/26kvABHMljeGR6i6+ASZKfrjzx75+DfhkkCy7hEucYA9X
 80I+nu40C5gXCBfTk/12jzU24hxU5i4etkph1RPwY4Zga/QrhsfSZu+2/lP+lzVWoCnv
 blKgnXBFY9X4kTAegWFTaPr6opmLcShBD/MNaxSNq0wpgbkiTg271D9OByPaIYL1TGSu
 +T1mI4POxThNOrxhLYultZKyfcX1dHo28l2HFlI+gmrK6fFTzyQ4LRoahGPpYINhf46k
 QcA6kOEMGqah8MJjnEoq/WkDylLk1hIvtxHwWcXtUt1LM1rHNYZA2jtcv2s9qN6iGqSz Gg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2x1bbq06eg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Dec 2019 00:21:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBQ0JwUC052358;
        Thu, 26 Dec 2019 00:21:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2x3nn6vb7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Dec 2019 00:21:11 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBQ0L4Tl013321;
        Thu, 26 Dec 2019 00:21:04 GMT
Received: from [192.168.14.112] (/79.180.210.71)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Dec 2019 16:21:04 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] KVM: nvmx: retry writing guest memory after page fault
 injected
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <1577240501-763-1-git-send-email-linmiaohe@huawei.com>
Date:   Thu, 26 Dec 2019 02:20:59 +0200
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <CE1E9880-3812-473F-A38B-2FAC45A95839@oracle.com>
References: <1577240501-763-1-git-send-email-linmiaohe@huawei.com>
To:     linmiaohe <linmiaohe@huawei.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9481 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912260001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9481 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912260001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 25 Dec 2019, at 4:21, linmiaohe <linmiaohe@huawei.com> wrote:
>=20
> From: Miaohe Lin <linmiaohe@huawei.com>
>=20
> We should retry writing guest memory when =
kvm_write_guest_virt_system()
> failed and page fault is injected in handle_vmread().
>=20
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Patch fix seems correct to me:
Reviewed-by: Liran Alon <liran.alon@oracle.com>

However, I suggest to rephrase commit title & message as follows:

"""
KVM: nVMX: vmread should not set rflags to specify success in case of =
#PF

In case writing to vmread destination operand result in a #PF, vmread =
should
not call nested_vmx_succeed() to set rflags to specify success. Similar =
to as
done in for VMPTRST (See handle_vmptrst()).
"""

In addition, it will be appreciated if you would also submit =
kvm-unit-test that verifies this condition.

-Liran

> ---
> arch/x86/kvm/vmx/nested.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 8edefdc9c0cb..c1ec9f25a417 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4799,8 +4799,10 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
> 					instr_info, true, len, &gva))
> 			return 1;
> 		/* _system ok, nested_vmx_check_permission has verified =
cpl=3D0 */
> -		if (kvm_write_guest_virt_system(vcpu, gva, &value, len, =
&e))
> +		if (kvm_write_guest_virt_system(vcpu, gva, &value, len, =
&e)) {
> 			kvm_inject_page_fault(vcpu, &e);
> +			return 1;
> +		}
> 	}
>=20
> 	return nested_vmx_succeed(vcpu);
> --=20
> 2.19.1
>=20

