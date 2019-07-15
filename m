Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 547F269AE7
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 20:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbfGOSbY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 14:31:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34972 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729277AbfGOSbY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 14:31:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6FIT6fA062087;
        Mon, 15 Jul 2019 18:30:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=hopLuf5BdO4Hp4VyyoYHpaylCZN2F3fSGEY9jDvuJts=;
 b=JVdI472Z/iRpilgLDIk8Pc4VQhFU0unpgTbJMwZiCHxL6OaeVI/tcAgkemsQvBOhThJi
 B78JN/BQtKsreFgn/eKR9TalT2oVK4hTGgajWPPWFYS29NPjDlnlJh9icMCe1liGgOBV
 QO1nkHYvgcVZ731PX6Kr/NAOQ2MnafEGDT4Qr0iaIWviPdhR3wT2e1nck4k3V6WbyWfZ
 dbdCFwpbPdK9r9pRWjw0z03C/NLwLTBxZbGonDtY0FmamNP4WWvXJg5ZCACmBI/0fdI8
 1J/qerjwXv9g0I6iQCUGdKGYIVMmyK1xR+YD2+lTvgqGsSnzfL1pHxg6OWxDm7UoL8G3 Eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2tq78pg6g9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jul 2019 18:30:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6FIS1jk056761;
        Mon, 15 Jul 2019 18:30:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2tq4dtff8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jul 2019 18:30:52 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6FIUpgh004797;
        Mon, 15 Jul 2019 18:30:51 GMT
Received: from [10.30.3.6] (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jul 2019 11:30:51 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] KVM: nVMX: Ignore segment base for VMX memory operand
 when segment not FS or GS
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <801988b0-b5c0-011e-5775-cb9e22f5d5c2@redhat.com>
Date:   Mon, 15 Jul 2019 21:30:48 +0300
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, max@m00nbsd.net,
        Joao Martins <joao.m.martins@oracle.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C000BFA0-5FE2-4AD4-B3F5-079AFE3005A2@oracle.com>
References: <20190715154744.36134-1-liran.alon@oracle.com>
 <87r26rw9lv.fsf@vitty.brq.redhat.com> <20190715172139.GB789@linux.intel.com>
 <801988b0-b5c0-011e-5775-cb9e22f5d5c2@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9319 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907150212
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9319 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907150212
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 15 Jul 2019, at 21:28, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 15/07/19 19:21, Sean Christopherson wrote:
>>>> +		if ((seg_reg !=3D VCPU_SREG_FS) && (seg_reg !=3D =
VCPU_SREG_GS))
>> I'm pretty sure the internal parantheses are unnecessary.
>>=20
>=20
> Indeed, that's so Pascal! :)  I'll apply Vitaly's suggestion and queue =
it.
>=20
> Paolo

I like parentheses as it makes ordering of expression a no-brainer. But =
that=E2=80=99s just a matter of taste I guess.
I don=E2=80=99t mind you will change it according to given suggestions. =
:)

-Liran=
