Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97D016EBD3
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 23:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388365AbfGSVBz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 17:01:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60704 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728816AbfGSVBy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 17:01:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6JKx1Fh180966;
        Fri, 19 Jul 2019 21:01:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=w5M/y1YHYfWNHZpl6DNsS5mgG0YtlA+1vIp1/P0KTAY=;
 b=1/EZu5fQLtGDBMWMlXGjuuW6zjeN2V+ZPpqU63Y2B6EQmbrCS8Pkcq2unPYtX4Ejwsyv
 Uj/JpptsPFrgikqhb5wNS20aoHzy8TFAX0ktJDlGMg+erPYHQM8cxAQOX33h94OJY8Qr
 gu8DdQL1LXnzumYt5ieWMBTxGjgIKuifvKSNZHKGxJ80QYcqXH0ROhWaAbbEe8cQORko
 FGRgcumbZQSc1CDOHz9PM3d70KllUvCG7zAVb4i87uDyPSmBoWhQxgxtDMfdSbXROD4D
 w+yP5e/idNdIcVp74xPXYcglAfqTgX8p+7Jisw3hELAFHcwFYFu8seP4i4yR592QK1ca yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2tq78q8n5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jul 2019 21:01:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6JKwIE3095807;
        Fri, 19 Jul 2019 21:01:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2tt77jh316-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jul 2019 21:01:47 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6JL1kKd022709;
        Fri, 19 Jul 2019 21:01:46 GMT
Received: from [10.0.0.13] (/79.182.108.162)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 19 Jul 2019 21:01:46 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] KVM: nVMX: do not use dangling shadow VMCS after guest
 reset
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <1563554534-46556-3-git-send-email-pbonzini@redhat.com>
Date:   Sat, 20 Jul 2019 00:01:42 +0300
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6D1C57BE-1A1B-4714-B4E5-E0569A60FD1F@oracle.com>
References: <1563554534-46556-3-git-send-email-pbonzini@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9323 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907190221
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9323 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907190221
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 19 Jul 2019, at 19:42, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> If a KVM guest is reset while running a nested guest, free_nested will
> disable the shadow VMCS execution control in the vmcs01.  However,
> on the next KVM_RUN vmx_vcpu_run would nevertheless try to sync
> the VMCS12 to the shadow VMCS which has since been freed.
>=20
> This causes a vmptrld of a NULL pointer on my machime, but Jan reports
> the host to hang altogether.  Let's see how much this trivial patch =
fixes.
>=20
> Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

First, nested_release_vmcs12() also sets need_vmcs12_to_shadow_sync to =
false explicitly. This can now be removed.

Second, I suggest putting a WARN_ON_ONCE() on copy_vmcs12_to_shadow() in =
case shadow_vmcs=3D=3DNULL.
To assist catching these kind of errors more easily in the future.

Besides that, the fix seems correct to me.
Reviewed-by: Liran Alon <liran.alon@oracle.com>

-Liran

> ---
> arch/x86/kvm/vmx/nested.c | 1 +
> 1 file changed, 1 insertion(+)
>=20
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 6e88f459b323..6119b30347c6 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -194,6 +194,7 @@ static void vmx_disable_shadow_vmcs(struct =
vcpu_vmx *vmx)
> {
> 	secondary_exec_controls_clearbit(vmx, =
SECONDARY_EXEC_SHADOW_VMCS);
> 	vmcs_write64(VMCS_LINK_POINTER, -1ull);
> +	vmx->nested.need_vmcs12_to_shadow_sync =3D false;
> }
>=20
> static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
> --=20
> 1.8.3.1
>=20

