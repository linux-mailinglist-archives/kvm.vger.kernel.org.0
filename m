Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F92D54D16
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 13:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729587AbfFYLCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 07:02:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55968 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbfFYLCY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 07:02:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5PAxxMr177500;
        Tue, 25 Jun 2019 11:01:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=B2zsKIoRAShW+y2NyCEXOSxGQYTAtwaazZmMjEodyZ8=;
 b=OCpLaY2IF7JosIlxBkL5z+C6J6pDZgAGpE5VAHMrOK0QoZyfAVntL3gJ0wbBqeALTtrV
 liu8QqcPTFm+zofwM6Km6G9TeVdiU4xkFKiGZfMwMqDracIOztM3/iN5Az6gDzv2Cd0N
 0FwzYq4B/mKONmqBkrJf700Qx8OpQOQ/7jNy+L9SM2UX5dHjejKczUKTe1lTOncA84Em
 VZUab5EIESL2HXo2WHneToCz2fPIIcG2BLjsBxDGC/7azL1AcNRlajwo0U2t5ukBEX0E
 7EMg729E4UuLtnWmfSamjWb4/tFLjrF8F5po4yea+VFPO2oj6/SbzlYjRrVXEpDgU7MV Fg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2t9brt3pd1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 11:01:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5PB030j010029;
        Tue, 25 Jun 2019 11:01:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2t99f3tbn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 11:01:40 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5PB1drN020837;
        Tue, 25 Jun 2019 11:01:39 GMT
Received: from [192.168.14.112] (/109.64.216.174)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Jun 2019 04:01:39 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] x86/kvm/nVMCS: fix VMCLEAR when Enlightened VMCS is in
 use
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <87lfxqdp3n.fsf@vitty.brq.redhat.com>
Date:   Tue, 25 Jun 2019 14:01:36 +0300
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E7C72E0C-B44F-4CE6-8325-EA32521D75B7@oracle.com>
References: <20190624133028.3710-1-vkuznets@redhat.com>
 <CEFF2A14-611A-417C-BC0A-8814862F26C6@oracle.com>
 <87lfxqdp3n.fsf@vitty.brq.redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906250089
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906250089
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 25 Jun 2019, at 11:51, Vitaly Kuznetsov <vkuznets@redhat.com> =
wrote:
>=20
> Liran Alon <liran.alon@oracle.com> writes:
>=20
>>> On 24 Jun 2019, at 16:30, Vitaly Kuznetsov <vkuznets@redhat.com> =
wrote:
>>>=20
>>>=20
>>> +bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmptr)
>>=20
>> I prefer to rename evmptr to evmcs_ptr. I think it=E2=80=99s more =
readable and sufficiently short.
>> In addition, I think you should return either -1ull or =
assist_page.current_nested_vmcs.
>> i.e. Don=E2=80=99t return evmcs_ptr by pointer but instead as a =
return-value
>> and get rid of the bool.
>=20
> Actually no, sorry, I'm having second thoughts here: in =
handle_vmclear()
> we don't care about the value of evmcs_ptr, we only want to check that
> enlightened vmentry bit is enabled in assist page. If we switch to
> checking evmcs_ptr against '-1', for example, we will make '-1' a =
magic
> value which is not in the TLFS. Windows may decide to use it for
> something else - and we will get a hard-to-debug bug again.

I=E2=80=99m not sure I understand.
You are worried that when guest have setup a valid assist-page and set =
enlighten_vmentry to true,
that assist_page.current_nested_vmcs can be -1ull and still be =
considered a valid eVMCS?
I don't think that's reasonable.

i.e. I thought about having this version of the method:

+u64 nested_enlightened_vmentry(struct kvm_vcpu *vcpu)
+{
+	struct hv_vp_assist_page assist_page;
+
+	if (unlikely(!kvm_hv_get_assist_page(vcpu, &assist_page)))
+		return -1ull;
+
+	if (unlikely(!assist_page.enlighten_vmentry))
+		return -1ull;
+
+	return assist_page.current_nested_vmcs;
+}
+

-Liran

>=20
> If you still dislike nested_enlightened_vmentry() having the side =
effect
> of fetching evmcs_ptr I can get rid of it by splitting the function =
into
> two, however, it will be less efficient for
> nested_vmx_handle_enlightened_vmptrld(). Or we can just leave things =
as
> they are there and use the newly introduced function in =
handle_vmclear()
> only.
>=20
> --=20
> Vitaly

