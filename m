Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8171F68EC
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2019 13:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbfKJMXc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Nov 2019 07:23:32 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:43240 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbfKJMXc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Nov 2019 07:23:32 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAACG6G9024960;
        Sun, 10 Nov 2019 12:23:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=xfGHYhQGPZcQSLT5vio2mDM8lYi4JVvBs2OEBmJ4CoM=;
 b=GOJUfKhrJjnU7itXIEcOU58AHNv1pss/nek6yOmVpbCkkt5XmvYE+cfk2d01pFWNHLYt
 PejLiD+JYyNsNmXUdqt1EbPC7ZMAbhUrQfMXeJqXoGjoqiYIzbSyhPuMtMliJEayh1GZ
 NSjMylQo7RyoxymwnXZT6uYk9HxQbeA0quS9XtMdItG0CrV9/P2nykeqoP0IwbifXhlM
 ogDl66VwLZBLZOUwMoiv0c0751cotT8Wa/ITYae/jA07z0WantDzUmlnKAKfeqZMY+bn
 gXPNGh/NrqkAWPU1CMXvDO9qsSsgLrtiVjVMsn8tda667HDU0oYRYNrpcikjmbSLLK1o fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2w5p3qb341-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 10 Nov 2019 12:23:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAACNMpc162810;
        Sun, 10 Nov 2019 12:23:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2w66ypwk9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 10 Nov 2019 12:23:23 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAACNMsv014829;
        Sun, 10 Nov 2019 12:23:22 GMT
Received: from [192.168.14.112] (/79.182.207.213)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 10 Nov 2019 04:23:22 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 2/2] KVM: x86: Fix INIT signal handling in various CPU
 states
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <199dac11-d79b-356f-ae52-91653087cc49@redhat.com>
Date:   Sun, 10 Nov 2019 14:23:17 +0200
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1ACF3DBE-DD34-4BE9-B25E-10805EB8C720@oracle.com>
References: <20190826102449.142687-1-liran.alon@oracle.com>
 <20190826102449.142687-3-liran.alon@oracle.com>
 <20190826160301.GC19381@linux.intel.com>
 <221B019B-D38D-401E-9C6B-17D512B61345@oracle.com>
 <199dac11-d79b-356f-ae52-91653087cc49@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9436 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911100128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9436 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911100127
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry in the delay of handling this.
Now preparing a bunch of KVM commits to submit. :)

> On 11 Sep 2019, at 19:21, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 26/08/19 20:26, Liran Alon wrote:
>> An alternative could be to just add a flag to events->flags that =
modifies
>> behaviour to treat events->smi.latched_init as just =
events->latched_init.
>> But I prefer the previous option.
>=20
> Why would you even need the flag?  I think you only need to move the =
"if
> (lapic_in_kernel(vcpu)) outside, under "if (events->flags &
> KVM_VCPUEVENT_VALID_SMM)=E2=80=9D.

Without an additional flag, the events->smi.latched_init field will be =
evaluated
by kvm_vcpu_ioctl_x86_set_vcpu_events() even when userspace haven=E2=80=99=
t
specified KVM_VCPUEVENT_VALID_SMM. Which in theory should break
compatibility to userspace that don=E2=80=99t specify this flag.

If you are ok with breaking this compatibility, I will avoid adding an =
opt-in flag
that specifies this field should be evaluated even when =
KVM_VCPUEVENT_VALID_SMM
is not specified.

Because we are lucky and =E2=80=9Clatched_init" was last field in =
=E2=80=9Cstruct smi=E2=80=9D inside =E2=80=9Cstruct kvm_vcpu_events=E2=80=9D=
,
I will just move =E2=80=9Clatched_init=E2=80=9D field outside of =
=E2=80=9Cstruct smi=E2=80=9D just before the =E2=80=9Creserved=E2=80=9D =
field.
Which would keep binary format compatibility while allowing making KVM =
code more clear.

>=20
> In fact, I think it would make sense anyway to clear KVM_APIC_SIPI in
> kvm_vcpu_ioctl_x86_set_vcpu_events (i.e. clear apic->pending_events =
and
> then possibly set KVM_APIC_INIT if events->smi.latched_init is true).

Agree. Will do this as-well.

-Liran

>=20
> Paolo

