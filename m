Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1D199500F
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 23:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbfHSVrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 17:47:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54460 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728014AbfHSVrI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 17:47:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7JLd19S133381
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 21:47:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=q4B+iWSavjgpiwONyp3kxrqTfAG8hJoijgqc3JeKPBo=;
 b=lr9Rc/lj/Aaj7O6AYjv7X0yp6T1YiBF6gT4a+a/CHGMJYzPHorKEtaDQ5TN//p42ZZLZ
 MWncPxedc/WTXGo3vqJkb2kgta0SgOPZCXtBGLZ47+k0iPfNU3IF7emilDLaw6bgkn2g
 i1NZUYsZb7eZ7l5azM3GfsvuvdM0MiBW6t5sv6xx6gzMfJLO0jDojc+RhUzwcvsX5L8D
 TCH6vjV1JaZfpFa0oT4Ow4ogepddfQEilBYSATpBmo+chxtctxSFdDwbeHEqKkNfgt5S
 IDD9cAJUkeo07/ORTRto62rEhC2xcLjzX2PXX6BlWCZGM8zRZEBkwQDiNukwT/rxGFgi wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ue90ta9j5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 21:47:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7JLcOUM086288
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 21:47:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2uejxemsd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 21:47:06 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7JLl5ep009997
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 21:47:05 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 19 Aug 2019 14:47:05 -0700
From:   Nikita Leshenko <nikita.leshchenko@oracle.com>
To:     kvm@vger.kernel.org
Subject: [PATCH 0/2] KVM: nVMX: Improve HLT activity support
Date:   Tue, 20 Aug 2019 00:46:48 +0300
Message-Id: <20190819214650.41991-1-nikita.leshchenko@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=516
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908190217
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=587 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908190217
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These patches improve various aspects of nested HLT activity state support. The
first patch prevents usermode from turning off the feature bit in VMX_MISC MSR
and the second patch adds additional activity state related checks on VMCS12 as
required by SDM.

These patches were tested to not cause regressions in kvm-unit-tests.

Nikita


