Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73CA5F68FE
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2019 13:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfKJM5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Nov 2019 07:57:39 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58836 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbfKJM5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Nov 2019 07:57:38 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAACs4ld078305;
        Sun, 10 Nov 2019 12:57:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=GKXYSKESsGXB2bWTcM2afIUZn5WqaAkeyjLOfZIbLCo=;
 b=K4Rk+zPMvzqw1lgaNQ/FXoJtDX9zJpugjMvMynqcD3Z0RxZhCx3QcY0w9Mfmea1KkMwL
 grWPAioGbBQM+l9ZexiFHRwa5hELS4NB9+LsBNbl+SiHXQ0em/nWE1JzFR4ZvDqP7YLq
 REdrMtZE/kNXg4IttC80vijf4Jw5iEwI70M5FM5fb3qvUvJyXJswIfOthTtLtGgu+YtB
 Z2eUs23LQ3JKp43OdI9dpK6G6cj8IhuEbjfDsAIiQTOzI2sSj9VNCaN0TaUG+BFzZ/sZ
 Z3WsOJAKFvTJH08+lp2C4SBkoxSf0juFwEbst+BceV9elGjBAQaLFjbuDGpVsjom3uEF Iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w5mvtb8ks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 10 Nov 2019 12:57:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAACs5wm011702;
        Sun, 10 Nov 2019 12:57:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2w67kgweb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 10 Nov 2019 12:57:27 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAACvQNs026659;
        Sun, 10 Nov 2019 12:57:26 GMT
Received: from [192.168.14.112] (/79.182.207.213)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 10 Nov 2019 04:57:25 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 2/2] KVM: x86: Fix INIT signal handling in various CPU
 states
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <1ACF3DBE-DD34-4BE9-B25E-10805EB8C720@oracle.com>
Date:   Sun, 10 Nov 2019 14:57:20 +0200
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F28AA61F-4BA9-42F2-AA00-E75797BBA8CE@oracle.com>
References: <20190826102449.142687-1-liran.alon@oracle.com>
 <20190826102449.142687-3-liran.alon@oracle.com>
 <20190826160301.GC19381@linux.intel.com>
 <221B019B-D38D-401E-9C6B-17D512B61345@oracle.com>
 <199dac11-d79b-356f-ae52-91653087cc49@redhat.com>
 <1ACF3DBE-DD34-4BE9-B25E-10805EB8C720@oracle.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9436 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911100130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9436 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911100130
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 10 Nov 2019, at 14:23, Liran Alon <liran.alon@oracle.com> wrote:
>=20
> Because we are lucky and =E2=80=9Clatched_init" was last field in =
=E2=80=9Cstruct smi=E2=80=9D inside =E2=80=9Cstruct kvm_vcpu_events=E2=80=9D=
,
> I will just move =E2=80=9Clatched_init=E2=80=9D field outside of =
=E2=80=9Cstruct smi=E2=80=9D just before the =E2=80=9Creserved=E2=80=9D =
field.
> Which would keep binary format compatibility while allowing making KVM =
code more clear.

Forget about this. Because of padding this will cause to issues.
And besides, it will break with any additional field added to =E2=80=9Cstr=
uct smi=E2=80=9D.
So I will keep field in =E2=80=9Cstruct smi=E2=80=9D even though it =
isn=E2=80=99t related specifically to SMM anymore=E2=80=A6

-Liran

