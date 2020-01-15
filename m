Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF7FD13D052
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 23:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730902AbgAOWtb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 17:49:31 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47760 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728899AbgAOWtb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 17:49:31 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FMhPsS093616;
        Wed, 15 Jan 2020 22:49:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=0eMvgfzTenYltLWrsdGjsDcA2l+gtvwq3pl5JlibP3U=;
 b=ltgtpWxD55EDSjXpgkI7SARZi1LXAkKdzJ4f7XqA8hT3jI+7CrjkpNCV5go2fX963j5J
 ToXXZ6n4BYbVofmw8W5a9Nux91yNrDn8Az7XXdUMQRsZOEocx49GFwKXhNQnTdygnKPg
 idQbWBkx+EYeFEaRG13l1sIZQYGZ4vfjdZbOGBV2tslcGCgsur+VXnkQdrulxoJc51Sg
 8l+vQ5xEJ1o2n9MAKAwqq+ieVRos3aWPBDR96dzzN7pNhr1aGIWAei92Y4EPkvgMjCF5
 RF3a4MSXr1BBflhjZnXR2scn+LweK3cDzs2LmlTXz4iUawYHHbyEIkyXrWHA5fWL5AhL qw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xf73ty4u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 22:49:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FMi19i020190;
        Wed, 15 Jan 2020 22:49:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xj61khn2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 22:49:25 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00FMnNde016067;
        Wed, 15 Jan 2020 22:49:23 GMT
Received: from [192.168.14.112] (/109.66.225.253)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 14:49:23 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH RFC 2/3] x86/kvm/hyper-v: move VMX controls sanitization
 out of nested_enable_evmcs()
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20200115171014.56405-3-vkuznets@redhat.com>
Date:   Thu, 16 Jan 2020 00:49:19 +0200
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Roman Kagan <rkagan@virtuozzo.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A93CDB6E-0E46-4AA8-9B45-8F2EE3C723F5@oracle.com>
References: <20200115171014.56405-1-vkuznets@redhat.com>
 <20200115171014.56405-3-vkuznets@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150171
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 15 Jan 2020, at 19:10, Vitaly Kuznetsov <vkuznets@redhat.com> =
wrote:
>=20
> With fine grained VMX feature enablement QEMU>=3D4.2 tries to do =
KVM_SET_MSRS
> with default (matching CPU model) values and in case eVMCS is also =
enabled,
> fails.
>=20
> It would be possible to drop VMX feature filtering completely and make
> this a guest's responsibility: if it decides to use eVMCS it should =
know
> which fields are available and which are not. Hyper-V mostly complies =
to
> this, however, there is at least one problematic control:
> SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES
> which Hyper-V enables. As there is no 'apic_addr_field' in eVMCS, we
> fail to handle this properly in KVM. It is unclear how this is =
supposed
> to work, genuine Hyper-V doesn't expose the control so it is possible =
that
> this is just a bug (in Hyper-V).

Have you tried contacted someone at Hyper-V team about this?

>=20
> Move VMX controls sanitization from nested_enable_evmcs() to =
vmx_get_msr(),
> this allows userspace to keep setting controls it wants and at the =
same
> time hides them from the guest.
>=20
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
> arch/x86/kvm/vmx/evmcs.c | 38 ++++++++++++++++++++++++++++++++------
> arch/x86/kvm/vmx/evmcs.h |  1 +
> arch/x86/kvm/vmx/vmx.c   | 10 ++++++++--
> 3 files changed, 41 insertions(+), 8 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> index 89c3e0caf39f..b5d6582ba589 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -346,6 +346,38 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu =
*vcpu)
>        return 0;
> }
>=20
> +void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
> +{
> +	u32 ctl_low =3D (u32)*pdata, ctl_high =3D (u32)(*pdata >> 32);

Nit: I dislike defining & initialising multiple local vars on same line.

> +	/*
> +	 * Enlightened VMCS doesn't have certain fields, make sure we =
don't
> +	 * expose unsupported controls to L1.
> +	 */
> +
> +	switch (msr_index) {
> +	case MSR_IA32_VMX_PINBASED_CTLS:
> +	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
> +		ctl_high &=3D ~EVMCS1_UNSUPPORTED_PINCTRL;
> +		break;
> +	case MSR_IA32_VMX_EXIT_CTLS:
> +	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
> +		ctl_high &=3D ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
> +		break;
> +	case MSR_IA32_VMX_ENTRY_CTLS:
> +	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
> +		ctl_high &=3D ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
> +		break;
> +	case MSR_IA32_VMX_PROCBASED_CTLS2:
> +		ctl_high &=3D ~EVMCS1_UNSUPPORTED_2NDEXEC;
> +		break;
> +	case MSR_IA32_VMX_VMFUNC:
> +		ctl_low &=3D ~EVMCS1_UNSUPPORTED_VMFUNC;
> +		break;
> +	}
> +
> +	*pdata =3D ctl_low | ((u64)ctl_high << 32);
> +}
> +
> int nested_enable_evmcs(struct kvm_vcpu *vcpu,
> 			uint16_t *vmcs_version)
> {
> @@ -356,11 +388,5 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
> 	if (vmcs_version)
> 		*vmcs_version =3D nested_get_evmcs_version(vcpu);
>=20
> -	vmx->nested.msrs.pinbased_ctls_high &=3D =
~EVMCS1_UNSUPPORTED_PINCTRL;
> -	vmx->nested.msrs.entry_ctls_high &=3D =
~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
> -	vmx->nested.msrs.exit_ctls_high &=3D =
~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
> -	vmx->nested.msrs.secondary_ctls_high &=3D =
~EVMCS1_UNSUPPORTED_2NDEXEC;
> -	vmx->nested.msrs.vmfunc_controls &=3D =
~EVMCS1_UNSUPPORTED_VMFUNC;
> -
> 	return 0;
> }
> diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
> index 07ebf6882a45..b88d9807a796 100644
> --- a/arch/x86/kvm/vmx/evmcs.h
> +++ b/arch/x86/kvm/vmx/evmcs.h
> @@ -201,5 +201,6 @@ bool nested_enlightened_vmentry(struct kvm_vcpu =
*vcpu, u64 *evmcs_gpa);
> uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
> int nested_enable_evmcs(struct kvm_vcpu *vcpu,
> 			uint16_t *vmcs_version);
> +void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata);
>=20
> #endif /* __KVM_X86_VMX_EVMCS_H */
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e3394c839dea..8eb74618b8d8 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1849,8 +1849,14 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, =
struct msr_data *msr_info)
> 	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
> 		if (!nested_vmx_allowed(vcpu))
> 			return 1;
> -		return vmx_get_vmx_msr(&vmx->nested.msrs, =
msr_info->index,
> -				       &msr_info->data);
> +		if (vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
> +				    &msr_info->data))
> +			return 1;
> +		if (!msr_info->host_initiated &&
> +		    vmx->nested.enlightened_vmcs_enabled)
> +			nested_evmcs_filter_control_msr(msr_info->index,
> +							=
&msr_info->data);
> +		break;

Nit: It seems more elegant to me to put the call to =
nested_evmcs_filter_control_msr() inside vmx_get_vmx_msr().

The patch itself makes sense to me and looks correct.
Reviewed-by: Liran Alon <liran.alon@oracle.com>

-Liran

