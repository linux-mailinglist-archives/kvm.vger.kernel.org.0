Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE4689B0C9
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 15:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392760AbfHWNY5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 09:24:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45596 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392194AbfHWNY5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 09:24:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NDNlFj051828;
        Fri, 23 Aug 2019 13:23:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=p0RQDgsmP5itMie9wmmg6pNVdSasWpi8POdZFHN0hhQ=;
 b=Vlayb+W8aI4dB2lk56qdPkGxUESvCY4ymrzNW4pai7a+89Ka5YQw/Kk0E5+AM7vkZ70s
 RVQe0Y8rVNwaCW3e3v/HDXX+fjP6E48jMxgnSlSWh8muKWkRcVX2GEQpZYn0wWIgS0Av
 U1+o55AP0hXZq8JULmqHGZyvJIuaNztbqL165VibrrKhPpWmnU3SyUKVFPHyvf8Q+N3W
 JQPaGWtK0L5o8vk24AIJ9Y4uw5b/2dqhgBeKOjeB7fhnWKEyjQR44L0fPigtqTSiYyZz
 wois3cP+sgIVu2PR8hZDZN3N/mk6VxXJ/CYXuT6Wq3k/OtOl02AEGQK/4z3o52SqPi0a GA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uea7rcrpg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 13:23:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NDNRWO138212;
        Fri, 23 Aug 2019 13:23:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ujca83pee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 13:23:45 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7NDNhlr023979;
        Fri, 23 Aug 2019 13:23:43 GMT
Received: from [192.168.14.112] (/109.64.228.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 23 Aug 2019 06:23:43 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [RESEND PATCH 05/13] KVM: x86: Don't attempt VMWare emulation on
 #GP with non-zero error code
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190823010709.24879-6-sean.j.christopherson@intel.com>
Date:   Fri, 23 Aug 2019 16:23:38 +0300
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <5D23F679-9E64-4BFA-8041-C18952EF0F56@oracle.com>
References: <20190823010709.24879-1-sean.j.christopherson@intel.com>
 <20190823010709.24879-6-sean.j.christopherson@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=769
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908230138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=817 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908230138
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 23 Aug 2019, at 4:07, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> The VMware backdoor hooks #GP faults on IN{S}, OUT{S}, and RDPMC, none
> of which generate a non-zero error code for their #GP.  Re-injecting =
#GP
> instead of attempting emulation on a non-zero error code will allow a
> future patch to move #GP injection (for emulation failure) into
> kvm_emulate_instruction() without having to plumb in the error code.
>=20
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Liran Alon <liran.alon@oracle.com>

-Liran

> ---
> arch/x86/kvm/svm.c     | 6 +++++-
> arch/x86/kvm/vmx/vmx.c | 7 ++++++-
> 2 files changed, 11 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 5a42f9c70014..b96a119690f4 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -2772,11 +2772,15 @@ static int gp_interception(struct vcpu_svm =
*svm)
>=20
> 	WARN_ON_ONCE(!enable_vmware_backdoor);
>=20
> +	if (error_code) {
> +		kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
> +		return 1;
> +	}
> 	er =3D kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE);
> 	if (er =3D=3D EMULATE_USER_EXIT)
> 		return 0;
> 	else if (er !=3D EMULATE_DONE)
> -		kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
> +		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
> 	return 1;
> }
>=20
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6ecf773825e2..3ee0dd304bc7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4509,11 +4509,16 @@ static int handle_exception_nmi(struct =
kvm_vcpu *vcpu)
>=20
> 	if (!vmx->rmode.vm86_active && is_gp_fault(intr_info)) {
> 		WARN_ON_ONCE(!enable_vmware_backdoor);
> +
> +		if (error_code) {
> +			kvm_queue_exception_e(vcpu, GP_VECTOR, =
error_code);
> +			return 1;
> +		}
> 		er =3D kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE);
> 		if (er =3D=3D EMULATE_USER_EXIT)
> 			return 0;
> 		else if (er !=3D EMULATE_DONE)
> -			kvm_queue_exception_e(vcpu, GP_VECTOR, =
error_code);
> +			kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
> 		return 1;
> 	}
>=20
> --=20
> 2.22.0
>=20

