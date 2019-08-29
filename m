Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C75DA1BD7
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 15:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfH2Nvz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 09:51:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38072 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbfH2Nvz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 09:51:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TDnNxP095592;
        Thu, 29 Aug 2019 13:50:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Fd9hv6LyJBtuu9ZkSbuId7vkAVpMFdpT9DAMePfpKUs=;
 b=LlGZy+/DG+OXEKjb+xgSZmFbX6eKUKcb8gVa0bmQ4CG/Nft6uZ7A55vWkTZ8J8gf0Jqv
 bkwlXEK43cZ2rRynMhqsvtgTcWlgbG0SnaCO9mEcW679IAmJ2y5yRRe9nv/5zXCrtYC5
 dLPADKS7e9opjOwx3OC2auQu9H58xe6zqbkGOziog91lNWaYK+/jv4vGXxfKcuc0JAdW
 a443/QnB0NWV0yYwTQYGeO9hHwIP/ZQSp7KLoXxg/y898dqdKsyvKlgKksvfhXGc7uAc
 KTezwu6PkHpNnf1VTzILbXK/dJWSaNpbKPgsS2B4mGv0ZOn6xo0+pzpaCNPiljXiJR4y wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2upfwx808j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 13:50:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TDm7t2074044;
        Thu, 29 Aug 2019 13:50:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2untev2f8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 13:50:30 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7TDoRYU028608;
        Thu, 29 Aug 2019 13:50:27 GMT
Received: from [10.175.160.184] (/10.175.160.184)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 13:50:27 +0000
Subject: Re: [PATCH v1] cpuidle-haltpoll: vcpu hotplug support
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-pm@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20190828185650.16923-1-joao.m.martins@oracle.com>
 <20190829115634.GA4949@amt.cnet>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <8c459d91-bc47-2ff4-7d3b-243ed4e466cb@oracle.com>
Date:   Thu, 29 Aug 2019 14:50:21 +0100
MIME-Version: 1.0
In-Reply-To: <20190829115634.GA4949@amt.cnet>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=978
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=5 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290152
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/29/19 12:56 PM, Marcelo Tosatti wrote:
> Hi Joao,
> 
> On Wed, Aug 28, 2019 at 07:56:50PM +0100, Joao Martins wrote:
>> +static void haltpoll_uninit(void)
>> +{
>> +	unsigned int cpu;
>> +
>> +	cpus_read_lock();
>> +
>> +	for_each_online_cpu(cpu) {
>> +		struct cpuidle_device *dev =
>> +			per_cpu_ptr(haltpoll_cpuidle_devices, cpu);
>> +
>> +		if (!dev->registered)
>> +			continue;
>> +
>> +		arch_haltpoll_disable(cpu);
>> +		cpuidle_unregister_device(dev);
>> +	}
> 
> 1)
> 
>> +
>> +	cpuidle_unregister(&haltpoll_driver);
> 
> cpuidle_unregister_driver.

Will fix -- this was an oversight.

> 
>> +	free_percpu(haltpoll_cpuidle_devices);
>> +	haltpoll_cpuidle_devices = NULL;
>> +
>> +	cpus_read_unlock();
> 
> Any reason you can't cpus_read_unlock() at 1) ?
> 
No, let me adjust that too.

> Looks good otherwise.
> 
> Thanks!
> 
Thanks for the review!

	Joao
