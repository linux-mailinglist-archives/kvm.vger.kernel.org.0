Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77A7AF7847
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 17:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfKKQCn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 11:02:43 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49216 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbfKKQCm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 11:02:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABFnXXt184815;
        Mon, 11 Nov 2019 16:02:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=TnU03Z6iukLVnVfZqn+P5GjXKVTrmco4z3NTz7H9cnE=;
 b=F4dCE1IV0BxxgFkO/sxufj+OhZTnc/bW9TtipF9exAdNHI2o5vLmw7Ps9rRR/7cMlqz0
 slEemC/Xe/SHGnYpzH7CRaJaEDDgzdIKP+1/DudvepWwySco87VcCv7jmf4IYVkMN4DN
 bgLnawNnapJu9gujVLWkMwAz5y6xbGGkuCKm1gMEMtaiqlgooGnhfNk28RCn7+BXVbi4
 7U9+Nr2O5EwfiYx1xbbgyomlNMlQGAxu5ZLbWhcnCb94tSYndyPc5ZdYY3KJ83wz1e3g
 c9XbLyJVmBZR3dco3WmEW7gXOunvFHBBWiG/OB41dtZkXH+KG1hQ7ilzALUwP9lrqn0j GA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w5ndpytax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 16:02:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABFrnad143800;
        Mon, 11 Nov 2019 16:02:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w67km95gf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 16:02:31 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xABG2UNL027238;
        Mon, 11 Nov 2019 16:02:30 GMT
Received: from [192.168.14.112] (/79.182.207.213)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 08:02:30 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 1/2] KVM: VMX: Refactor update_cr8_intercept()
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <0b04e879-f19c-da08-2feb-8dc17b08460c@redhat.com>
Date:   Mon, 11 Nov 2019 18:02:24 +0200
Cc:     rkrcmar@redhat.com, kvm@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Joao Martins <joao.m.martins@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <76336EBC-791A-456B-9E87-60BD4A95930C@oracle.com>
References: <20191111123055.93270-1-liran.alon@oracle.com>
 <20191111123055.93270-2-liran.alon@oracle.com>
 <de93a7b8-d0b6-33b2-2039-ad836fcfab1e@redhat.com>
 <30BFAF3B-EB5A-4121-B53D-9FD594CFF92E@oracle.com>
 <0b04e879-f19c-da08-2feb-8dc17b08460c@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110146
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 11 Nov 2019, at 18:01, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 11/11/19 16:00, Liran Alon wrote:
>>=20
>>=20
>>> On 11 Nov 2019, at 16:57, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>>=20
>>> On 11/11/19 13:30, Liran Alon wrote:
>>>> No functional changes.
>>>>=20
>>>> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
>>>> Signed-off-by: Liran Alon <liran.alon@oracle.com>
>>>> ---
>>>> arch/x86/kvm/vmx/vmx.c | 9 +++------
>>>> 1 file changed, 3 insertions(+), 6 deletions(-)
>>>>=20
>>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>>> index f53b0c74f7c8..d5742378d031 100644
>>>> --- a/arch/x86/kvm/vmx/vmx.c
>>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>>> @@ -6013,17 +6013,14 @@ static void vmx_l1d_flush(struct kvm_vcpu =
*vcpu)
>>>> static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, =
int irr)
>>>> {
>>>> 	struct vmcs12 *vmcs12 =3D get_vmcs12(vcpu);
>>>> +	int tpr_threshold;
>>>>=20
>>>> 	if (is_guest_mode(vcpu) &&
>>>> 		nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW))
>>>> 		return;
>>>>=20
>>>> -	if (irr =3D=3D -1 || tpr < irr) {
>>>> -		vmcs_write32(TPR_THRESHOLD, 0);
>>>> -		return;
>>>> -	}
>>>> -
>>>> -	vmcs_write32(TPR_THRESHOLD, irr);
>>>> +	tpr_threshold =3D ((irr =3D=3D -1) || (tpr < irr)) ? 0 : irr;
>>>=20
>>> Pascal parentheses? :)
>>=20
>> What do you mean?
>=20
> Redundant parentheses around && or || are usually avoided in the =
kernel,
> and they are typical of Pascal (which had weird operator precedence
> rules and thus required operands of AND/OR to be parenthesized).
>=20
> I can remove them when committing the series.
>=20
> Paolo

I see. Sure no problem you can remove them.

Thanks,
-Liran


