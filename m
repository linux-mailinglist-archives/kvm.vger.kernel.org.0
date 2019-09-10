Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 713C2AEDAD
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 16:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392988AbfIJOtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 10:49:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48450 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732434AbfIJOtB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 10:49:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8AENkGG131485;
        Tue, 10 Sep 2019 14:25:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to : content-transfer-encoding; s=corp-2019-08-05;
 bh=NHdeAPKmmXhs2gh53Ao/iY+rl0IHNTcE9ceoYzmW3PA=;
 b=eTl3Ht16X9k57STX22Nfse1q1i+nAE2TOCTXC5ruD8NFqq1ebwh84ldhbSzISgmnssuF
 bZIfi3jJldDUhk95HDI8Qd7vioZqIgsTPuYAJmJmPMMhEmrPrpnfOh22bWYYwfdvPQ0W
 5AsHTQqRr9rI0b5wOBdrcZw9xuTuRG07TVcmSqgR2hpE7BFSph8b9enoTeIcAerW5cCB
 MUJWN4L+0WArFfdjI4p38FksHxgCerqViUcWoGVEtdoSJk+8+JEyW4ldrL6DbwPH/ZHW
 sBwq1gi3p5aaqVp2L//aIpV1VGxmbF2cRKlZoK8+zPUvKfHfPO9l4u4RIOqNoXrolw3h Jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2uw1jy3swg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Sep 2019 14:25:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8AENt39128686;
        Tue, 10 Sep 2019 14:25:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2uxd6ch563-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Sep 2019 14:25:02 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8AEOwoJ025439;
        Tue, 10 Sep 2019 14:24:58 GMT
Received: from char.us.oracle.com (/10.152.32.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Sep 2019 07:24:58 -0700
Received: by char.us.oracle.com (Postfix, from userid 1000)
        id D9F686A010E; Tue, 10 Sep 2019 10:26:42 -0400 (EDT)
Date:   Tue, 10 Sep 2019 10:26:42 -0400
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     Adalbert =?utf-8?B?TGF6xINy?= <alazar@bitdefender.com>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Samuel =?iso-8859-1?Q?Laur=E9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@pps.reinject,
        Yu C <yu.c.zhang@intel.com>,
        Mihai =?utf-8?B?RG9uyJt1?= <mdontu@bitdefender.com>
Subject: Re: [RFC PATCH v6 69/92] kvm: x86: keep the page protected if
 tracked by the introspection tool
Message-ID: <20190910142642.GC5879@char.us.oracle.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-70-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190809160047.8319-70-alazar@bitdefender.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9376 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909100140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9376 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909100140
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 09, 2019 at 07:00:24PM +0300, Adalbert Laz=C4=83r wrote:
> This patch might be obsolete thanks to single-stepping.

sooo should it be skipped from this large patchset to easy
review?

>=20
> Signed-off-by: Adalbert Laz=C4=83r <alazar@bitdefender.com>
> ---
>  arch/x86/kvm/x86.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2c06de73a784..06f44ce8ed07 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6311,7 +6311,8 @@ static bool reexecute_instruction(struct kvm_vcpu=
 *vcpu, gva_t cr2,
>  		indirect_shadow_pages =3D vcpu->kvm->arch.indirect_shadow_pages;
>  		spin_unlock(&vcpu->kvm->mmu_lock);
> =20
> -		if (indirect_shadow_pages)
> +		if (indirect_shadow_pages
> +		    && !kvmi_tracked_gfn(vcpu, gpa_to_gfn(gpa)))
>  			kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
> =20
>  		return true;
> @@ -6322,7 +6323,8 @@ static bool reexecute_instruction(struct kvm_vcpu=
 *vcpu, gva_t cr2,
>  	 * and it failed try to unshadow page and re-enter the
>  	 * guest to let CPU execute the instruction.
>  	 */
> -	kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
> +	if (!kvmi_tracked_gfn(vcpu, gpa_to_gfn(gpa)))
> +		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
> =20
>  	/*
>  	 * If the access faults on its page table, it can not
> @@ -6374,6 +6376,9 @@ static bool retry_instruction(struct x86_emulate_=
ctxt *ctxt,
>  	if (!vcpu->arch.mmu->direct_map)
>  		gpa =3D kvm_mmu_gva_to_gpa_write(vcpu, cr2, NULL);
> =20
> +	if (kvmi_tracked_gfn(vcpu, gpa_to_gfn(gpa)))
> +		return false;
> +
>  	kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
> =20
>  	return true;
