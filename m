Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 683199B365
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 17:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404025AbfHWPei (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 11:34:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37720 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388022AbfHWPeh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 11:34:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NFTKV5176321;
        Fri, 23 Aug 2019 15:31:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=ljXkikTKvcTUSpDKbQATasB9hPlgF773nyUv/9uVgks=;
 b=Q3yFW4jrfc1ZC1UFbS+fW14Zd/LnpE5bWxAAsq+JroKmfKe9sYg6hWM6GXQQofsanX2/
 VP/JRpMRmPsi+ZK9Mt1Xv1oADtAtBt1OB2vI3UvVRSjYLcKatGtZH3NldbqopL+gTkCL
 /s8qRPfoUci82Q7lQMDFmYmjvv64ChYJhKMFpX0z1GVkUB2fFU8hF9I7AZuAY7lQxD4H
 PuuAUEaDALHsJIuB43ns6RqJkd6TpohWExnTdmykpzL2xScsUsOCGLUAnqlK94A3+BSj
 nhiSq1d8Bzx5pGHv3kXH9Mo581/xtJHxFy7D1N0tm4IU0wqXGMjreXlcTLUIsmsOZ3sT Iw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ue9hq5d2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 15:31:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NFS7fY036669;
        Fri, 23 Aug 2019 15:31:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2uj1y0mg0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 15:31:38 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7NFVaBE011951;
        Fri, 23 Aug 2019 15:31:36 GMT
Received: from [192.168.14.112] (/109.64.228.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 23 Aug 2019 08:31:36 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [RESEND PATCH 07/13] KVM: x86: Add explicit flag for forced
 emulation on #UD
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190823144423.GB6713@linux.intel.com>
Date:   Fri, 23 Aug 2019 18:31:32 +0300
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B03AFFBB-3E33-4D04-8B5D-4FA3C7F385CB@oracle.com>
References: <20190823010709.24879-1-sean.j.christopherson@intel.com>
 <20190823010709.24879-8-sean.j.christopherson@intel.com>
 <9E01A06E-FD3E-4D43-9FFE-6FFE3BAC269A@oracle.com>
 <20190823144423.GB6713@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9358 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908230158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9358 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908230158
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 23 Aug 2019, at 17:44, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Fri, Aug 23, 2019 at 04:47:14PM +0300, Liran Alon wrote:
>>=20
>>=20
>>> On 23 Aug 2019, at 4:07, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>>>=20
>>> Add an explicit emulation type for forced #UD emulation and use it =
to
>>> detect that KVM should unconditionally inject a #UD instead of =
falling
>>> into its standard emulation failure handling.
>>>=20
>>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>=20
>> The name "forced emulation on #UD" is not clear to me.
>>=20
>> If I understand correctly, EMULTYPE_TRAP_UD is currently used to =
indicate
>> that in case the x86 emulator fails to decode instruction, the caller =
would
>> like the x86 emulator to fail early such that it can handle this =
condition
>> properly.  Thus, I would rename it EMULTYPE_TRAP_DECODE_FAILURE.
>=20
> EMULTYPE_TRAP_UD is used when KVM intercepts a #UD from hardware.  KVM
> only emulates select instructions in this case in order to minmize the
> emulator attack surface, e.g.:
>=20
> 	if (unlikely(ctxt->ud) && likely(!(ctxt->d & EmulateOnUD)))
> 		return EMULATION_FAILED;
>=20
> To enable testing of the emulator, KVM recognizes a special "opcode" =
that
> triggers full emulation on #UD, e.g. ctxt->ud is false when the #UD =
was
> triggered with the magic prefix.  The prefix is only recognized when =
the
> module param force_emulation_prefix is toggled on, hence the name
> EMULTYPE_TRAP_UD_FORCED.

Ah-ha. This makes sense. Thanks for the explanation.
I would say it=E2=80=99s worth putting a comment in it in code=E2=80=A6

>=20
>> But this new flag seems to do the same. So I=E2=80=99m left confused. =
 I=E2=80=99m probably
>> missing something trivial here.

