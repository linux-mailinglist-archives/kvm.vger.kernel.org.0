Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593A3242365
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 02:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgHLA3q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 20:29:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42210 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbgHLA3q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 20:29:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07C0Ixch003755;
        Wed, 12 Aug 2020 00:29:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=zmJQ/PYh+h0LN7urVgZLOZACxmEOo3wOo/ZIQoexe08=;
 b=fJZahmLWCnNUbs2DvYzMg6ftYXa/CM2TyKgMpJzu8OUbL1wvNcFK2YlcmpGyexmySJKR
 RKWipZcnZ7qjd4skpCVTbPmz0C2KQmdI0KMXP2TK9US7pbcsDwtj6ZT7mctpf95g1EqF
 5UbMdR3MkWuZUIlD9KD2a+yIpotDClGHSF8fnqv/S/wGEoY0hVOMmX4j+bQ00aRlbnhz
 n909PC7p8CmTeqhw2Ny8+wmZjHEGNjQm0XjxexfzT6iWelKOOH+Sc4YoxCe3AK+jh2FP
 yXvxrCsp+HjLAt6mmmGjmEQ23O8n8Tf+uVGfm5egBima1XDjWNLvaXqVIFmPh46kTNUI wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32t2ydp66d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 12 Aug 2020 00:29:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07C0DIva131140;
        Wed, 12 Aug 2020 00:29:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 32t5y5cnbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Aug 2020 00:29:43 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07C0Tgag001131;
        Wed, 12 Aug 2020 00:29:42 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Aug 2020 00:29:42 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH v3] nSVM: Test illegal combinations of EFER.LME, CR0.PG, CR0.PE and CR4.PAE in VMCB
Date:   Wed, 12 Aug 2020 00:29:34 +0000
Message-Id: <20200812002935.48365-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9710 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=1 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=632 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008120000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9710 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=624 priorityscore=1501
 malwarescore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 suspectscore=1 phishscore=0 adultscore=0 spamscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008120000
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2 -> v3:
	Changed the patch title.

[PATCH v3] nSVM: Test illegal combinations of EFER.LME, CR0.PG, CR0.PE

 x86/svm_tests.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

Krish Sadhukhan (1):
      nSVM: Test illegal combinations of EFER.LME, CR0.PG and CR4.PAE in VMCB

