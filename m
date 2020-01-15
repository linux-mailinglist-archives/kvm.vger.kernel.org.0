Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51A2413D0AC
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 00:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbgAOXa4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 18:30:56 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:58846 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgAOXa4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 18:30:56 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FNSxPR142024;
        Wed, 15 Jan 2020 23:30:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=PYwgNWG/JVTv6hmJUC/N6gPnI4GX4CRWHrwsun68Q2I=;
 b=mTG9KaL0kOJazjC9C5x4jHEmktdtn7fF2C9GEKP4Z719NTVtDTvzgK7Mp+Gk0KC5z34D
 tgsZxVi4rocGQ8bldDh8jF+OCC0O41Cnnnmw9p7aAsSzJUg/hVEw8j9B1LYmYt/gEIXW
 0EsoRtM+opRbbH82KhD1Aex8xSjdR18l+wjFTMJ2IIF9l5OcrEg7ieCIqMrSUwCRSoN+
 +Juv4NJ23zw4vafkAAEQGM7B2ntWzsqRTU+X0oq6C++Cw4IUQZocUszOIAiZ9NT/KUZS
 3P+jiVhZvceyKX8oOLxrYttDT89Pzg2u9MvMXB5oy6IhwqCa2jvA5MVSDTkgBOmAPi9e bQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xf73yqbct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 23:30:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FNSqIW183544;
        Wed, 15 Jan 2020 23:30:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xj1arpua3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 23:30:49 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00FNUlF9011630;
        Wed, 15 Jan 2020 23:30:48 GMT
Received: from [192.168.14.112] (/109.66.225.253)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 15:30:47 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH RFC 2/3] x86/kvm/hyper-v: move VMX controls sanitization
 out of nested_enable_evmcs()
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20200115232738.GB18268@linux.intel.com>
Date:   Thu, 16 Jan 2020 01:30:43 +0200
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Roman Kagan <rkagan@virtuozzo.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C6C4003E-0ADD-42A5-A580-09E06806E160@oracle.com>
References: <20200115171014.56405-1-vkuznets@redhat.com>
 <20200115171014.56405-3-vkuznets@redhat.com>
 <20200115232738.GB18268@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=823
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=875 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150177
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 16 Jan 2020, at 1:27, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Wed, Jan 15, 2020 at 06:10:13PM +0100, Vitaly Kuznetsov wrote:
>> With fine grained VMX feature enablement QEMU>=3D4.2 tries to do =
KVM_SET_MSRS
>> with default (matching CPU model) values and in case eVMCS is also =
enabled,
>> fails.
>=20
> As in, Qemu is blindly throwing values at KVM and complains on =
failure?
> That seems like a Qemu bug, especially since Qemu needs to explicitly =
do
> KVM_CAP_HYPERV_ENLIGHTENED_VMCS to enable eVMCS.

See: https://patchwork.kernel.org/patch/11316021/
For more context.

-Liran=
