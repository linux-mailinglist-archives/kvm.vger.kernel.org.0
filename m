Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88421A40C8
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2019 01:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbfH3XHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Aug 2019 19:07:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39828 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728194AbfH3XHg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Aug 2019 19:07:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UN7HqQ124031;
        Fri, 30 Aug 2019 23:07:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=RLrzfO3AeeFVrDRvAQYR86GjFtqvZ+FTDjFoH7g8g9Y=;
 b=EpplMmRzya7B0vOiqNw99CVc9z8nqxIspiYKto4bICJJ19RphAsUDvViMsMGd5VCLhUE
 db3mXoEhLMmllKU02Hp4i/HexcWrXSu3/ZPltczl24RYzVWGTlHHdTPdRIldxTnLCX+E
 keFx0282N4yQAHPmh8sZxAnBk49KMsWvhqYCPtgVR19vqmgTYyHTmssslRIKVRajWzkM
 vM1+iSQyzT4y/LEIKAL9o62XzaGwT8vwt+IlqQbRmrjsFl/A4QiZulckUq7P+2YZDuS+
 ZUPjBc5zdrAFKu1IWwmrOfL41FNVzeHob6UmTZk7OMrIhInqXiKrvqoYEEUMye4CiXvM rA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2uqd6ng003-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 23:07:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UN31TK134616;
        Fri, 30 Aug 2019 23:07:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2uphavtpsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 23:07:16 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7UN7FE0001296;
        Fri, 30 Aug 2019 23:07:15 GMT
Received: from dhcp-10-132-91-76.usdhcp.oraclecorp.com (/10.132.91.76)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Aug 2019 16:07:15 -0700
Subject: Re: [PATCH 2/4] KVM: nVMX: Check GUEST_DR7 on vmentry of nested
 guests
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20190829205635.20189-1-krish.sadhukhan@oracle.com>
 <20190829205635.20189-3-krish.sadhukhan@oracle.com>
 <CALMp9eSekWEvvgwhMXWOtRZG1saQDOaKr+_4AacuM9JtH5guww@mail.gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <a4882749-a5cc-f8cd-4641-dd61314e6312@oracle.com>
Date:   Fri, 30 Aug 2019 16:07:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eSekWEvvgwhMXWOtRZG1saQDOaKr+_4AacuM9JtH5guww@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=883
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300225
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=945 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300225
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 08/29/2019 03:26 PM, Jim Mattson wrote:
> On Thu, Aug 29, 2019 at 2:25 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
>> According to section "Checks on Guest Control Registers, Debug Registers, and
>> and MSRs" in Intel SDM vol 3C, the following checks are performed on vmentry
>> of nested guests:
>>
>>      If the "load debug controls" VM-entry control is 1, bits 63:32 in the DR7
>>      field must be 0.
> Can't we just let the hardware check guest DR7? This results in
> "VM-entry failure due to invalid guest state," right? And we just
> reflect that to L1?

Just trying to understand the reason why this particular check can be 
deferred to the hardware.
