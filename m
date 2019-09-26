Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35DC7BF1BA
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 13:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfIZLb2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 07:31:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38330 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbfIZLb1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 07:31:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8QBTNkQ110404;
        Thu, 26 Sep 2019 11:31:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=W65Qj1spfIW0T5TXpC/L2KW0atWcCOLy480ZPUWtihc=;
 b=ib2W1W9sZq8A+/3X5IVog69x/N+0IZaTe6/7kVLPhek2eY3dc43wjUJvlTYEYCk6taY1
 /slRc/8UUovk8L1yAveIRhcUY4zObH43ZLuqMWeLEElFYCqUV0wIAmnbDO9HRimKK+K6
 oox6Jofub77uyWP6zDnToY2nxd5F+5sPhBNd+fqOdVIDrz+1TRSHgnp87PK9SDCiUeRZ
 37nL9FVncyOA6BCkM/IuUYyPHlCtRYRYhcXAymhtHZA7eyzbS6Zu2uVzSif064FpCZoP
 7A5CbqTp12eYvte2HLBoEJrvDi6rqy78OmRY+IibuSOhY5i3VEYXQLLXgbNFTi60EvAs 4g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2v5cgraxv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Sep 2019 11:31:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8QBTGE0156616;
        Thu, 26 Sep 2019 11:31:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2v8tpjwtuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Sep 2019 11:31:08 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8QBV8Lc028193;
        Thu, 26 Sep 2019 11:31:08 GMT
Received: from [192.168.14.112] (/79.179.213.143)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Sep 2019 04:31:07 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] KVM: nVMX: cleanup and fix host 64-bit mode checks
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <1569429286-35157-1-git-send-email-pbonzini@redhat.com>
Date:   Thu, 26 Sep 2019 14:31:04 +0300
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <63797A78-1645-4A7E-970B-62C9A580B71B@oracle.com>
References: <1569429286-35157-1-git-send-email-pbonzini@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=837
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909260110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=919 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909260110
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 25 Sep 2019, at 19:34, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> KVM was incorrectly checking vmcs12->host_ia32_efer even if the "load
> IA32_EFER" exit control was reset.  Also, some checks were not using
> the new CC macro for tracing.
>=20
> Cleanup everything so that the vCPU's 64-bit mode is determined
> directly from EFER_LMA and the VMCS checks are based on that, which
> matches section 26.2.4 of the SDM.
>=20
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Fixes: 5845038c111db27902bc220a4f70070fe945871c
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> =E2=80=94

Reviewed-by: Liran Alon <liran.alon@oracle.com>


