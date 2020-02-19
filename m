Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46A631638BC
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 01:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgBSAwL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 19:52:11 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44836 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbgBSAwL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 19:52:11 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01J0V4ib124250;
        Wed, 19 Feb 2020 00:51:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=EXfdJroLahj1fjenAt1LakeRFv7fBrTRyPPo6hNVXtA=;
 b=l1rqbLWHXkvzyQ7OXy4NjC3oFBHcH1c/+oeuX2WmwgluBVfnrsPTsIivJKsielRg8IZW
 Tcav/eymscmzuXsYpC5UkbyzXSs5yThkarrxTv9AIwfCFdRUoBsbT4ASIC9PUA2sBDGk
 5kFPn1OyARyybizr4SzdZpPnJDT9w8/KQZ1ScIXj1l2wTsnDWRaRRpUzigOlh2D4Zoty
 bzucOq9PxxdqY1wLyMdegu3bm6lvo6QuKbuNbtJX/qU/eYM2wols0ICx5oMlYEQoyrog
 lSap7myPnsLOldM5AAEm8Dm8CLJjP23u7Lglp73mKJp6k8E0MviSAXCXeBN4gBotC0We ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2y7aq5w0ru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 00:51:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01J0Sx8w152757;
        Wed, 19 Feb 2020 00:51:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2y82c2ds8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 00:51:58 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01J0psvl010065;
        Wed, 19 Feb 2020 00:51:55 GMT
Received: from [192.168.1.206] (/71.63.128.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Feb 2020 16:51:54 -0800
Subject: Re: [PATCH] mm/hugetlb: avoid get wrong ptep caused by race
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "Longpeng (Mike)" <longpeng2@huawei.com>
Cc:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, arei.gonglei@huawei.com,
        weidong.huang@huawei.com, weifuqiang@huawei.com,
        kvm@vger.kernel.org
References: <1582027825-112728-1-git-send-email-longpeng2@huawei.com>
 <20200218203717.GE28156@linux.intel.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <455abe66-d801-89c4-3e3c-503842fe403a@oracle.com>
Date:   Tue, 18 Feb 2020 16:51:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200218203717.GE28156@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002190000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 adultscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 clxscore=1011 bulkscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002190000
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/18/20 12:37 PM, Sean Christopherson wrote:
> On Tue, Feb 18, 2020 at 08:10:25PM +0800, Longpeng(Mike) wrote:
>> Our machine encountered a panic after run for a long time and
>> the calltrace is:
> 
> What's the actual panic?  Is it a BUG() in hugetlb_fault(), a bad pointer
> dereference, etc...?

I too would like some more information on the panic.
If your analysis is correct, then I would expect the 'ptep' returned by
huge_pte_offset() to not point to a pte but rather some random address.
This is because the 'pmd' calculated by pmd_offset(pud, addr) is not
really the address of a pmd.  So, perhaps there is an addressing exception
at huge_ptep_get() near the beginning of hugetlb_fault()?

	ptep = huge_pte_offset(mm, haddr, huge_page_size(h));
	if (ptep) {
		entry = huge_ptep_get(ptep);
		...

-- 
Mike Kravetz
