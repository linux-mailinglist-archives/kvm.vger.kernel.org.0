Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D599F7798
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 16:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfKKPYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 10:24:52 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57430 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbfKKPYw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 10:24:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABFO9Te162231;
        Mon, 11 Nov 2019 15:24:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=4UNzLwOnEqJcRGz0ghDq+P2TdYkxizAVlL6hYF77Ums=;
 b=HtbPAq4V9R55oMOcF6GeA691lUtwWZMkhCkcYlp5dSO5IJKu8Y2VnIns78JtKic3yyuh
 gwI6H2X0GXOR9/Wd7JJBASVcjlpKm2fxVQIIoNgKfbEPpMYpfbJhGBU6b/G6TA1MxePm
 O3N36tcTAFKzmYaad36K3N2YztuFYohOQNPKQRzYZ28N0DBv2T5R8bQLQ9R170h1ZcXS
 j9rrZXp3hrLwVRnrJ1MJ8p/HXueGn6ll90JFG0kj4TGX28ZOSmolSWSZOtLO93v/ueis
 HQdygZ2DmtIlPlkJw/f4tRKe3E4TxZ+SxKTuD5hv1T8QP86HMSQoRQYxmMp35eKAJDeC cg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w5ndpykc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 15:24:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABFNNOx012077;
        Mon, 11 Nov 2019 15:24:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2w66yy1ugy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 15:24:44 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xABFOh9v022192;
        Mon, 11 Nov 2019 15:24:43 GMT
Received: from [192.168.14.112] (/79.182.207.213)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 07:24:43 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 2/2] KVM: nVMX: Update vmcs01 TPR_THRESHOLD if L2 changed
 L1 TPR
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <a26a9a8c-df8d-c49a-3943-35424897b6b3@redhat.com>
Date:   Mon, 11 Nov 2019 17:24:39 +0200
Cc:     rkrcmar@redhat.com, kvm@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Joao Martins <joao.m.martins@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6CAEE592-02B0-4E25-B2D2-20E5B55A5D19@oracle.com>
References: <20191111123055.93270-1-liran.alon@oracle.com>
 <20191111123055.93270-3-liran.alon@oracle.com>
 <a26a9a8c-df8d-c49a-3943-35424897b6b3@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=802
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=874 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110141
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 11 Nov 2019, at 17:02, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 11/11/19 13:30, Liran Alon wrote:
>> When L1 don't use TPR-Shadow to run L2, L0 configures vmcs02 without
>> TPR-Shadow and install intercepts on CR8 access (load and store).
>>=20
>> If L1 do not intercept L2 CR8 access, L0 intercepts on those accesses
>> will emulate load/store on L1's LAPIC TPR. If in this case L2 lowers
>> TPR such that there is now an injectable interrupt to L1,
>> apic_update_ppr() will request a KVM_REQ_EVENT which will trigger a =
call
>> to update_cr8_intercept() to update TPR-Threshold to highest pending =
IRR
>> priority.
>>=20
>> However, this update to TPR-Threshold is done while active vmcs is
>> vmcs02 instead of vmcs01. Thus, when later at some point L0 will
>> emulate an exit from L2 to L1, L1 will still run with high
>> TPR-Threshold. This will result in every VMEntry to L1 to immediately
>> exit on TPR_BELOW_THRESHOLD and continue to do so infinitely until
>> some condition will cause KVM_REQ_EVENT to be set.
>> (Note that TPR_BELOW_THRESHOLD exit handler do not set KVM_REQ_EVENT
>> until apic_update_ppr() will notice a new injectable interrupt for =
PPR)
>>=20
>> To fix this issue, change update_cr8_intercept() such that if L2 =
lowers
>> L1's TPR in a way that requires to lower L1's TPR-Threshold, save =
update
>> to TPR-Threshold and apply it to vmcs01 when L0 emulates an exit from
>> L2 to L1.
>=20
> Can you explain why the write shouldn't be done to vmcs02 as well?
>=20
> Paolo

Because when L1 don=E2=80=99t use TPR-Shadow, L0 configures vmcs02 =
without TPR-Shadow.
Thus, writing to vmcs02->tpr_threshold doesn=E2=80=99t have any effect.

If l1 do use TPR-Shadow, then VMX=E2=80=99s update_cr8_intercept() =
doesn=E2=80=99t write to vmcs at all,
because it means L1 defines a vTPR for L2 and thus doesn=E2=80=99t =
provide it direct access to L1 TPR.

-Liran

>=20
>> -	vmcs_write32(TPR_THRESHOLD, tpr_threshold);
>> +
>> +	if (is_guest_mode(vcpu))
>> +		to_vmx(vcpu)->nested.l1_tpr_threshold =3D tpr_threshold;
>> +	else
>> +		vmcs_write32(TPR_THRESHOLD, tpr_threshold);
>> }
>>=20
>> void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>> index bee16687dc0b..43331dfafffe 100644
>> --- a/arch/x86/kvm/vmx/vmx.h
>> +++ b/arch/x86/kvm/vmx/vmx.h
>> @@ -167,6 +167,9 @@ struct nested_vmx {
>> 	u64 vmcs01_debugctl;
>> 	u64 vmcs01_guest_bndcfgs;
>>=20
>> +	/* to migrate it to L1 if L2 writes to L1's CR8 directly */
>> +	int l1_tpr_threshold;
>> +
>> 	u16 vpid02;
>> 	u16 last_vpid;
>>=20
>>=20
>=20

