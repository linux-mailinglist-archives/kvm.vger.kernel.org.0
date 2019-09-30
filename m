Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9703C33BC
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 14:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732862AbfJAMET (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 08:04:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36838 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfJAMES (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 08:04:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91C43p9171527;
        Tue, 1 Oct 2019 12:04:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2019-08-05;
 bh=tgOBFZObT23SyNVVIgjHtEVR3Av80X15fH43kUobLu8=;
 b=ro25Eb2C5gb4RNQdAjQkaP92uhpi+c7yOPLkyY4qWDW6FlcnFWTiQSzJiQsyeUewKT7T
 xv/FU7CliTpaPNK/aaqEyJjDXQ5VPb+yaviO2qsCzvVEJe+iok31aMR2VoxDLHZ03Pa/
 9i7aB5SFJAW+DE/CVYcMnYulFm5tgXq3CnYalVS7hyMpJ/bOPDFlJd4ec2yO45XOD+7/
 8jC4ISozo4Y/V3VOmwjOU/Jqr7dCH1VJVGpjMbsvRecCX8+MjM4Q3ICCtybLWlpposT3
 wniKDbf7kI5d2oNL2JyX+I8y9g14cNqoaL31/gITFk24WDDKNSCNXehekdRFv36MRvfU qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2va05rn82s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 12:04:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91C3NUm157467;
        Tue, 1 Oct 2019 12:04:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2vbnqcs96x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 12:04:12 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x91C4B9G017612;
        Tue, 1 Oct 2019 12:04:11 GMT
Received: from z2.cn.oracle.com (/10.182.71.205)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Oct 2019 05:04:11 -0700
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     vkuznets@redhat.com, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, Zhenzhong Duan <zhenzhong.duan@oracle.com>
Subject: [PATCH v2 0/3] Add a unified parameter "nopvspin"
Date:   Mon, 30 Sep 2019 20:08:56 +0800
Message-Id: <1569845340-11884-1-git-send-email-zhenzhong.duan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010112
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are cases folks want to disable spinlock optimization for
debug/test purpose. Xen and hyperv already have parameters "xen_nopvspin"
and "hv_nopvspin" to support that, but kvm doesn't.

The first patch adds that feature to KVM guest with "nopvspin".

For compatibility reason original parameters "xen_nopvspin" and
"hv_nopvspin" are retained and marked obsolete.

v2:
PATCH1: pick the print code change into seperate PATCH2,
        updated patch description             [Vitaly Kuznetsov]
PATCH2: new patch with print code change      [Vitaly Kuznetsov]
PATCH3: add Reviewed-by                       [Juergen Gross]

Thanks
Zhenzhong
