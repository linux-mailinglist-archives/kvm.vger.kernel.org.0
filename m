Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC9C3689E
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 02:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfFFAKk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jun 2019 20:10:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45862 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbfFFAKk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jun 2019 20:10:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5604kQB041670;
        Thu, 6 Jun 2019 00:10:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : content-type :
 content-transfer-encoding : mime-version : subject : message-id : date :
 cc : to; s=corp-2018-07-02;
 bh=UpMf1r5JAs33vcx0hs1njyIPgbbilFrxn0QNcI3l0c0=;
 b=R7JUl6T2mXLmDs/zbN6QkYl+1LwgJRxFYihjCM8IfL7yo/OdNMby+sngGvY0yWbWo+q9
 Kwrky+fQxYDejSuo65s4QSNy6x5NU3mBwPkRQOAzV6VZhZHj/QMyv8qQrX9APlW4gQjS
 9wvSH3YkxLIUGaWwta1D9s68ztIJcqKz89GmL1kf4lBUp0oEBt9MhGEYIkoGp5Xh368n
 Ns6seVdLBUNXsEMPRpOyuQ9ORQhYh4k1NjLsI6hAxzb5gaPbNRsutm/Sg5y0ySgNF5tg
 b4Hmf7+/PRlSmyXDeFbD1s+bB/6EbV1A92Ypi6X5Pvmesjx6nbny/51PZu1O48sk8RXI zw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2sugstnhkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jun 2019 00:10:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5609v1M116261;
        Thu, 6 Jun 2019 00:10:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2swngj5bdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jun 2019 00:10:02 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x560A0N5017359;
        Thu, 6 Jun 2019 00:10:00 GMT
Received: from [192.168.14.112] (/109.66.241.232)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 05 Jun 2019 17:10:00 -0700
From:   Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: QEMU/KVM migration backwards compatibility broken?
Message-Id: <38B8F53B-F993-45C3-9A82-796A0D4A55EC@oracle.com>
Date:   Thu, 6 Jun 2019 03:09:57 +0300
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     kvm list <kvm@vger.kernel.org>, qemu-devel@nongnu.org
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9279 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906050153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9279 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906050153
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Looking at QEMU source code, I am puzzled regarding how migration =
backwards compatibility is preserved regarding X86CPU.

As I understand it, fields that are based on KVM capabilities and guest =
runtime usage are defined in VMState subsections in order to not send =
them if not necessary.
This is done such that in case they are not needed and we migrate to an =
old QEMU which don=E2=80=99t support loading this state, migration will =
still succeed
(As .needed() method will return false and therefore this state won=E2=80=99=
t be sent as part of migration stream).
Furthermore, in case .needed() returns true and old QEMU don=E2=80=99t =
support loading this state, migration fails. As it should because we are =
aware that guest state
is not going to be restored properly on destination.

I=E2=80=99m puzzled about what will happen in the following scenario:
1) Source is running new QEMU with new KVM that supports save of some =
VMState subsection.
2) Destination is running new QEMU that supports load this state but =
with old kernel that doesn=E2=80=99t know how to load this state.

I would have expected in this case that if source .needed() returns =
true, then migration will fail because of lack of support in destination =
kernel.
However, it seems from current QEMU code that this will actually succeed =
in many cases.

For example, if msr_smi_count is sent as part of migration stream (See =
vmstate_msr_smi_count) and destination have has_msr_smi_count=3D=3Dfalse,
then destination will succeed loading migration stream but =
kvm_put_msrs() will actually ignore env->msr_smi_count and will =
successfully load guest state.
Therefore, migration will succeed even though it should have failed=E2=80=A6=


It seems to me that QEMU should have for every such VMState subsection, =
a .post_load() method that verifies that relevant capability is =
supported by kernel
and otherwise fail migration.

What do you think? Should I really create a patch to modify all these =
CPUX86 VMState subsections to behave like this?

Thanks,
-Liran=
