Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E09D103E44
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 16:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbfKTPZ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 10:25:57 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42532 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbfKTPZ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 10:25:57 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKFNZE5031481;
        Wed, 20 Nov 2019 15:25:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=67PKDs+GYPSm513wCO3qMf6C3JDDK7O6a+efBPIjKeY=;
 b=qcWzhV47hfbv1RUrXurKpBT6rWG8Mj8aaRH5PAbg4YW0r0PKR9DhQil6l3LX6sSEOygt
 ns8s0cf6LGNffjtt3lObho2kKUwyRS2y0m2PwdrUZCdXW7p6nKnap5VAysNLOj+kg3i7
 yht8XBzAcx+/HTGbCCKhfGoeLY8pYTZwGX9lJ/ZEwMCXTZgEX818da+IaTcrti4bJEg3
 H4KPEy2rbikNYufiS6piyeQ4bhhvOGLydfSH5M6Tf6YBun2oyhjE39+YGItFf4C1bFIY
 ZwNWffITuh8D5N6y/uM7aBXpCIHHMumez9mEErFgmby/gjPkMxjIVrvkS8tza+nZtmO7 OQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wa8htx8w6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 15:25:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKFO0jn094795;
        Wed, 20 Nov 2019 15:25:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2wcemgb6md-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 15:25:51 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAKFPo90019305;
        Wed, 20 Nov 2019 15:25:50 GMT
Received: from [192.168.14.112] (/79.176.218.68)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 07:25:50 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] KVM: nVMX: Remove unnecessary TLB flushes on L1<->L2
 switches when L1 use apic-access-page
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <d7d4629a-c605-72bc-9d71-dd97cb6c0ab4@redhat.com>
Date:   Wed, 20 Nov 2019 17:25:46 +0200
Cc:     rkrcmar@redhat.com, kvm@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Joao Martins <joao.m.martins@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4D796E12-758F-44D6-93B9-0BEFE0E7F712@oracle.com>
References: <20191120143307.59906-1-liran.alon@oracle.com>
 <d7d4629a-c605-72bc-9d71-dd97cb6c0ab4@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911200136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911200136
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 20 Nov 2019, at 17:05, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 20/11/19 15:33, Liran Alon wrote:
>> "Virtualize APIC accesses" VM-execution control was changed
>> from 0 to 1, OR the value of apic_access_page was changed.
>>=20
>> Examining prepare_vmcs02(), one could note that L0 won't flush
>> physical TLB only in case: L0 use VPID, L1 use VPID and L0
>> can guarantee TLB entries populated while running L1 are tagged
>> differently than TLB entries populated while running L2.
>> The last condition can only occur if either L0 use EPT or
>> L0 use different VPID for L1 and L2
>> (i.e. vmx->vpid !=3D vmx->nested.vpid02).
>>=20
>> If L0 use EPT, L0 use different EPTP when running L2 than L1
>> (Because guest_mode is part of mmu-role) and therefore SDM section
>> 28.3.3.4 doesn't apply. Otherwise, L0 use different VPID when
>> running L2 than L1 and therefore SDM section 28.3.3.3 doesn't
>> apply.
>=20
> I don't understand this.  You could still have a stale EPTP entry from =
a
> previous L2 vmenter.   If L1 uses neither EPT nor VPID, it expects a =
TLB
> flush to occur on every vmentry, but this won't happen if L0 uses EPT.

I don=E2=80=99t seem to get your concern.
In case L1 don=E2=80=99t use VPID, prepare_vmcs02() will request =
KVM_REQ_TLB_FLUSH.
(As it needs to emulate to L1 that on every L1<->L2 switch, the entire =
physical TLB is flushed)
As explained in commit message.

>=20
> Paolo




