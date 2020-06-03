Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 536921ECDA9
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 12:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgFCKgZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 06:36:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53306 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgFCKgY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 06:36:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 053AWuSj184485;
        Wed, 3 Jun 2020 10:36:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=82u63JacQ047l8DYs93FI4u9B2eDvAWbxc7OeJ2RYgk=;
 b=GDSlU/j9oaCG+Iso3O0iFDW6t6sz2lGLF9jCy0uHfDBn/K1cOrzILOtW3a0jyFEnALF0
 71lWUugENnfVKXONGHu3lr/0TY2x+9AP7e4u0Xo04GsxNN0TnJ+T2iJMSN+RtCx5gmIB
 4MFcvhre/0ZHv8h3+jyTc09on9TUR9pOULhHgeGfHiX0qMH8fH1Bxqtq1Z1rat/t8Ymq
 nb4wReywCwIWTE3kCMlJmxhuD/V1ixi7WHuOczvyyyR7FmvtB663Zqtf6KOuLYfYwZnI
 4XebdBii3AZMrfa4MIuiSYizKOnFtyRVyaE9+RUUYyncBux26WfIpQDSSzOHCENws9DN sw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31bewr0mc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 03 Jun 2020 10:36:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 053AS2uL126793;
        Wed, 3 Jun 2020 10:34:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31c25rqy3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jun 2020 10:34:21 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 053AYKBu018206;
        Wed, 3 Jun 2020 10:34:20 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Jun 2020 03:34:20 -0700
Date:   Wed, 3 Jun 2020 13:34:15 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org
Subject: [bug report] KVM: x86: enable event window in inject_pending_event
Message-ID: <20200603103415.GC1845750@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=3 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=806
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006030082
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 suspectscore=3 impostorscore=0 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=840
 malwarescore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006030082
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Paolo Bonzini,

The patch c9d40913ac5a: "KVM: x86: enable event window in
inject_pending_event" from May 22, 2020, leads to the following
static checker warning:

	arch/x86/kvm/x86.c:10530 kvm_can_do_async_pf()
	warn: signedness bug returning '(-16)'

arch/x86/kvm/x86.c
 10516  bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
 10517  {
 10518          if (unlikely(!lapic_in_kernel(vcpu) ||
 10519                       kvm_event_needs_reinjection(vcpu) ||
 10520                       vcpu->arch.exception.pending))
 10521                  return false;
 10522  
 10523          if (kvm_hlt_in_guest(vcpu->kvm) && !kvm_can_deliver_async_pf(vcpu))
 10524                  return false;
 10525  
 10526          /*
 10527           * If interrupts are off we cannot even use an artificial
 10528           * halt state.
 10529           */
 10530          return kvm_arch_interrupt_allowed(vcpu);
 10531  }

The svm_nmi_allowed() used to return false because interrupts aren't
allowed but now it returns -EBUSY so it returns true/allowed.

regards,
dan carpenter
