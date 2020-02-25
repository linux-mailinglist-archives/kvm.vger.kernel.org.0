Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D463216EDFF
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 19:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731545AbgBYS3f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 13:29:35 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52924 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbgBYS3f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 13:29:35 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PINhOG135617;
        Tue, 25 Feb 2020 18:28:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=s65FAwe6rKkFUzFN7JM3BEeK126LVw7a/JcTrGwEU+8=;
 b=zFak7vW096Kbg9nvSPPrC1FraCgE/MxLkheu8lIBmf0UYkGbiKB8N2l6n4GQnzLgVW8q
 YmdnWesUf2zt+cM/iJT0KQCIOTg7omXMu6bxoT78WJkgYc2TircwN3CCo3JHh7SGNDcG
 tXvO8h22KtDA5fxtudbWzwdGr39Hwc3nTV0ZFwgz17GGVTtv6cA1jwJErSSghUd5197/
 OZ+JqpkqH7zw7ezWPQoNQLa45oVfyczkpOU4zUL273O8WLupqda6XXAf6wbrUXKloN1O
 dzQNgXoG1AXm37KzgcjVsxYYinzW0ekdLzQagRJTBGyXyHfGoVOXegRZ9E1DGUQ2az7J fQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yd093keew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 18:28:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PIEJk7187859;
        Tue, 25 Feb 2020 18:28:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2yd0vv53r2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 18:28:27 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01PISQu6015812;
        Tue, 25 Feb 2020 18:28:26 GMT
Received: from localhost.localdomain (/10.159.148.245)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 10:28:26 -0800
Subject: Re: [PATCH 1/2] kvm: vmx: Use basic exit reason to check if it's the
 specific VM EXIT
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200224020751.1469-1-xiaoyao.li@intel.com>
 <20200224020751.1469-2-xiaoyao.li@intel.com>
 <87lfosp9xs.fsf@vitty.brq.redhat.com>
 <d9744594-4a66-d867-f785-64ce4d42b848@intel.com>
 <716806df-c0e4-43d5-b082-627d2c312f53@oracle.com>
 <877e0an763.fsf@vitty.brq.redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <f109f89d-ec69-4651-140b-24cc0be233d2@oracle.com>
Date:   Tue, 25 Feb 2020 10:28:25 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <877e0an763.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0 mlxlogscore=990
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 priorityscore=1501
 phishscore=0 clxscore=1015 mlxlogscore=999 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250130
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/25/20 5:11 AM, Vitaly Kuznetsov wrote:
> Krish Sadhukhan <krish.sadhukhan@oracle.com> writes:
>
>> We have a macro for bit 31,
>>
>>       VMX_EXIT_REASONS_FAILED_VMENTRY                0x80000000
>>
>>
>> Does it make sense to define a macro like that instead ? Say,
>>
>>       VMX_BASIC_EXIT_REASON        0x0000ffff
>>
> 0xffffU ?
>
>> and then we do,
>>
>>       u32 exit_reason = vmx->exit_reason;
>>       u16 basic_exit_reason = exit_reason & VMX_BASIC_EXIT_REASON;
>>
> Just a naming suggestion: if we decide to go down this road, let's name
> it e.g. VMX_BASIC_EXIT_REASON_MASK to make it clear this is *not* an
> exit reason.
>

VMX_BASIC_EXIT_REASON_MASK  works.

