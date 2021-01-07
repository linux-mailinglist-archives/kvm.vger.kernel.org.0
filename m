Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDC62ED39D
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 16:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbhAGPhW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 10:37:22 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58226 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727590AbhAGPhW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 10:37:22 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107FTDbj021361;
        Thu, 7 Jan 2021 15:36:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=l9RG+gvVGB2hCgh8oTBAUqTBGVrHNMBo5LYVurD8bJE=;
 b=s2/aEDvIQfj6xL7TSH0S3pk8/6MbFy55k/yODb/xvJwr6qPa1aq2iRzmgGxzETEUNiiI
 Mgv6PD1X9TrAFoZcNm9QKsTKVMtVsH+EJiDq9ABJETa392jkm5u5gHys0/VeA1ZCMKoj
 TLSl13CsSB38SuJvva6b5Y80+PT5cr2X5IuPYkkGeLPnkMaHS9Yo44ZJo3/37U7Lg9oB
 M6q5wZCJJAZB77YElsFOl2YGHS7eeLyHlFlHK+37lTQM8jhJ6yjNqGmv6SkN4D8RYybu
 X/ZkqzbpnJVa0El15ZwXX5C9biPBKjggh9r/g99E6sl6HmCy1J7H047ka6bTWdHSt0iZ 8w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35wepmcvt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 07 Jan 2021 15:36:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107FV8Ed045570;
        Thu, 7 Jan 2021 15:36:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 35v1fbd2pk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jan 2021 15:36:36 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 107FaZHL024209;
        Thu, 7 Jan 2021 15:36:35 GMT
Received: from [192.168.1.3] (/89.66.140.113)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Jan 2021 15:36:35 +0000
Subject: Re: [PATCH v3 1/2] KVM: x86/mmu: Ensure TDP MMU roots are freed after
 yield
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Leo Hou <leohou1402@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210107001935.3732070-1-bgardon@google.com>
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Message-ID: <2288be2a-b485-408d-b63c-85e00dbc5964@oracle.com>
Date:   Thu, 7 Jan 2021 16:36:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210107001935.3732070-1-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101070097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070097
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07.01.2021 01:19, Ben Gardon wrote:
> Many TDP MMU functions which need to perform some action on all TDP MMU
> roots hold a reference on that root so that they can safely drop the MMU
> lock in order to yield to other threads. However, when releasing the
> reference on the root, there is a bug: the root will not be freed even
> if its reference count (root_count) is reduced to 0.
> 
> To simplify acquiring and releasing references on TDP MMU root pages, and
> to ensure that these roots are properly freed, move the get/put operations
> into another TDP MMU root iterator macro.
> 
> Moving the get/put operations into an iterator macro also helps
> simplify control flow when a root does need to be freed. Note that using
> the list_for_each_entry_safe macro would not have been appropriate in
> this situation because it could keep a pointer to the next root across
> an MMU lock release + reacquire, during which time that root could be
> freed.
> 
> Reported-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Fixes: faaf05b00aec ("kvm: x86/mmu: Support zapping SPTEs in the TDP MMU")
> Fixes: 063afacd8730 ("kvm: x86/mmu: Support invalidate range MMU notifier for TDP MMU")
> Fixes: a6a0b05da9f3 ("kvm: x86/mmu: Support dirty logging for the TDP MMU")
> Fixes: 14881998566d ("kvm: x86/mmu: Support disabling dirty logging for the tdp MMU")
> Signed-off-by: Ben Gardon <bgardon@google.com>

Tested this version, too, and it works fine, so:
Tested-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Thanks,
Maciej
