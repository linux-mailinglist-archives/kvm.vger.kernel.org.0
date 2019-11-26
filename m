Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 698F3109D9D
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 13:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbfKZMMq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 07:12:46 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39066 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727400AbfKZMMq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 07:12:46 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAQC9Ocd095900;
        Tue, 26 Nov 2019 12:12:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=ngSp5Vdb1l98tGPOSt6MgwEdgJ/FZ35OtKNEbBYZZyE=;
 b=fgqdVDWgT/z30tjYezBNTgcUNafQCnTZXrEAGEToS96Zn3PVhoBgoVqkMI/7AQjzkJfX
 xkFx2wkqOg7wLbYx95akBN9J1qoyMbb1CD2MrXlprSm0Z8Opa1C4c/nMcwC/EqSXCIaN
 xikmMtAJSSv7sFMvaZsPwV/OxyK0qx/NRdNaDkkY13wnwgHFTEOSTJm3B7yzBWtEqBJy
 iMhRkIWaBSDjsSQQ4nXeo2nY8Urav4XvQZULrV1lOvQHx573gJlwXqgTgRb9WsFonPXs
 HMnL86XeqLTPSjJlvOe/dXGA/RMa6SPB8STT4UOFGsPNQVo/+ls0JQpJovlTlxJuGuQo zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2wewdr6a24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Nov 2019 12:12:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAQC8X9r050177;
        Tue, 26 Nov 2019 12:12:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2wgwusgqm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Nov 2019 12:12:42 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAQCCgIF027814;
        Tue, 26 Nov 2019 12:12:42 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 Nov 2019 04:12:40 -0800
Date:   Tue, 26 Nov 2019 15:12:34 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     jmattson@google.com
Cc:     kvm@vger.kernel.org
Subject: [bug report] kvm: mmu: Don't expose private memslots to L2
Message-ID: <20191126072617.7kposz7ouo33lkgd@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9452 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=320
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911260110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9452 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=381 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911260110
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Jim Mattson,

The patch 3a2936dedd20: "kvm: mmu: Don't expose private memslots to
L2" from May 9, 2018, leads to the following static checker warning:

	arch/x86/kvm/mmu/mmu.c:3686 nonpaging_map()
	error: uninitialized symbol 'map_writable'.

arch/x86/kvm/mmu/mmu.c
  3665  
  3666          if (fast_page_fault(vcpu, v, level, error_code))
  3667                  return RET_PF_RETRY;
  3668  
  3669          mmu_seq = vcpu->kvm->mmu_notifier_seq;
  3670          smp_rmb();
  3671  
  3672          if (try_async_pf(vcpu, prefault, gfn, v, &pfn, write, &map_writable))
                                                                      ^^^^^^^^^^^^^
The patch introduces a new false return which doesn't initialize
map_writable.

  3673                  return RET_PF_RETRY;
  3674  
  3675          if (handle_abnormal_pfn(vcpu, v, gfn, pfn, ACC_ALL, &r))
  3676                  return r;
  3677  
  3678          r = RET_PF_RETRY;
  3679          spin_lock(&vcpu->kvm->mmu_lock);
  3680          if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
  3681                  goto out_unlock;
  3682          if (make_mmu_pages_available(vcpu) < 0)
  3683                  goto out_unlock;
  3684          if (likely(!force_pt_level))
  3685                  transparent_hugepage_adjust(vcpu, gfn, &pfn, &level);
  3686          r = __direct_map(vcpu, v, write, map_writable, level, pfn,
                                                 ^^^^^^^^^^^^

  3687                           prefault, false);
  3688  out_unlock:
  3689          spin_unlock(&vcpu->kvm->mmu_lock);
  3690          kvm_release_pfn_clean(pfn);
  3691          return r;

regards,
dan carpenter
