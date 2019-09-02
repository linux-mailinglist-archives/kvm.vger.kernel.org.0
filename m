Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 231C0A545D
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2019 12:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731168AbfIBKtu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Sep 2019 06:49:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58524 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730785AbfIBKtt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Sep 2019 06:49:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x82AhO5Q179751;
        Mon, 2 Sep 2019 10:48:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=09Q4/fYIG9MJvMP7nWj77FfKeGU7L5Yn85N83DxgLrw=;
 b=WhFDP2/IAFKDzmMK9FZuHXS9XTbT4hEwmQUa11WiaO3/aF1lXTAz2fg60WkvRhW9xu61
 NbVJutLwz31Bsu26lfKGgBIpmuZ42eYeBy4GGqKylL5CGB2VGsh1OYy9jTVEtEOm8nCC
 vSC0m6W/cTepEIcAS4EU4zn82WmiA4t+18S9hgtWJfkd4Kjilj7TfLJ6c/Co9RpjV51i
 9kf7AQOXcKFOr9U2juvglD7sXzrWHYaR88Tbg6U2aIwzuG1RTLe+55BjMoA/P6G/EDez
 G4z6lfHa7BMgFMDi7i34PZ3Ajd1d2gcK8WW9qX4tlmnOUrhRZp8H/acP+ZevWCPFriOu ig== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2us1cbg2j3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Sep 2019 10:48:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x82Am2Y7174602;
        Mon, 2 Sep 2019 10:48:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2uryv530x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Sep 2019 10:48:18 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x82AmGK4023171;
        Mon, 2 Sep 2019 10:48:17 GMT
Received: from [10.175.163.45] (/10.175.163.45)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Sep 2019 03:48:16 -0700
Subject: Re: [PATCH v2] cpuidle-haltpoll: vcpu hotplug support
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
References: <20190829151027.9930-1-joao.m.martins@oracle.com>
 <20190829152714.GA15616@amt.cnet>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <5df5b2b1-11ce-9b1a-dd4a-8fe32e491543@oracle.com>
Date:   Mon, 2 Sep 2019 11:48:06 +0100
MIME-Version: 1.0
In-Reply-To: <20190829152714.GA15616@amt.cnet>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9367 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909020124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9367 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909020123
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/29/19 4:27 PM, Marcelo Tosatti wrote:
> On Thu, Aug 29, 2019 at 04:10:27PM +0100, Joao Martins wrote:
>> When cpus != maxcpus cpuidle-haltpoll will fail to register all vcpus
>> past the online ones and thus fail to register the idle driver.
>> This is because cpuidle_add_sysfs() will return with -ENODEV as a
>> consequence from get_cpu_device() return no device for a non-existing
>> CPU.
>>
>> Instead switch to cpuidle_register_driver() and manually register each
>> of the present cpus through cpuhp_setup_state() callback and future
>> ones that get onlined. This mimmics similar logic that intel_idle does.
>>
>> Fixes: fa86ee90eb11 ("add cpuidle-haltpoll driver")
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>> ---
>> v2:
>> * move cpus_read_unlock() right after unregistering all cpuidle_devices;
>> (Marcello Tosatti)
>> * redundant usage of cpuidle_unregister() when only
>> cpuidle_unregister_driver() suffices; (Marcelo Tosatti)
>> * cpuhp_setup_state() returns a state (> 0) on success with CPUHP_AP_ONLINE_DYN
>> thus we set @ret to 0

[ ... ]

> 
> Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
Thanks!

Meanwhile upon re-reading cpuhp_setup_state() I found out the teardown/offlining
and haltpoll_uninit() could be a bit simplified. So I sent out a new version[0],
but didn't add your Rb because there's was some very slight functional changes.

[0] https://lore.kernel.org/kvm/20190902104031.9296-1-joao.m.martins@oracle.com/

	Joao
