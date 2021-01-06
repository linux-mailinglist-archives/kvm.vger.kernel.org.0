Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFFC2EC618
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 23:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbhAFWQl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 17:16:41 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53542 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbhAFWQk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 17:16:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106M90fE051181;
        Wed, 6 Jan 2021 22:15:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=23sjDthx40QVcHElY5oXK1UXKDa+NL2H45rfUiSZpaI=;
 b=PgpveU9VVS/Ovnf7l7X+jc59NUFzL+HsBZAUfIklaNEmZ1gg7xe2R0OpVSGHi0tIMEQu
 3KACJZ1DY1YAo4NonE+xyoKECN6NSh8B72uk2bqNW7E1qeq+MTbcGjgKN20tK9Xw1ImR
 XzsJjSqEZOESg32/klteMDlhI2qbf+fSv/TGMykEUqh1LrwKLxSpEseinSswDm130+NU
 ID/9WWF3DKYzVp0tqXIhIKzwKVg8eJxloL6W1UA/dZjpRKoq4mp2crvSyFNPAFdhnz7H
 gH92i6t81GotIhWKTImjvswE7Ca82Qb2sZsvpKyxo1C8mXlIQtEIlwTLEhpAjgRQraCi eg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35wepma3uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 22:15:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106MARbu064412;
        Wed, 6 Jan 2021 22:13:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 35w3qsmv43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 22:13:55 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 106MDsLp030490;
        Wed, 6 Jan 2021 22:13:54 GMT
Received: from [192.168.1.3] (/89.66.140.113)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 22:13:54 +0000
Subject: Re: [PATCH v2 1/2] KVM: x86/mmu: Ensure TDP MMU roots are freed after
 yield
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Leo Hou <leohou1402@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
References: <20210106185951.2966575-1-bgardon@google.com>
 <CANgfPd9g3R7Am=EVf+5o0_WFabqQKjmW0t3mtEHe1rOccLFpTg@mail.gmail.com>
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Message-ID: <386f6b9e-2590-71b2-196e-1f692460ef80@oracle.com>
Date:   Wed, 6 Jan 2021 23:13:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd9g3R7Am=EVf+5o0_WFabqQKjmW0t3mtEHe1rOccLFpTg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060124
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06.01.2021 20:03, Ben Gardon wrote:
> On Wed, Jan 6, 2021 at 10:59 AM Ben Gardon <bgardon@google.com> wrote:
>>
>> Many TDP MMU functions which need to perform some action on all TDP MMU
>> roots hold a reference on that root so that they can safely drop the MMU
>> lock in order to yield to other threads. However, when releasing the
>> reference on the root, there is a bug: the root will not be freed even
>> if its reference count (root_count) is reduced to 0.
>>
>> To simplify acquiring and releasing references on TDP MMU root pages, and
>> to ensure that these roots are properly freed, move the get/put operations
>> into the TDP MMU root iterator macro. Not all functions which use the macro
>> currently get and put a reference to the root, but adding this behavior is
>> harmless.
>>
>> Moving the get/put operations into the iterator macro also helps
>> simplify control flow when a root does need to be freed. Note that using
>> the list_for_each_entry_unsafe macro would not have been appropriate in
>> this situation because it could keep a reference to the next root across
>> an MMU lock release + reacquire.
>>
>> Reported-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
>> Fixes: faaf05b00aec ("kvm: x86/mmu: Support zapping SPTEs in the TDP MMU")
>> Fixes: 063afacd8730 ("kvm: x86/mmu: Support invalidate range MMU notifier for TDP MMU")
>> Fixes: a6a0b05da9f3 ("kvm: x86/mmu: Support dirty logging for the TDP MMU")
>> Fixes: 14881998566d ("kvm: x86/mmu: Support disabling dirty logging for the tdp MMU")
>> Signed-off-by: Ben Gardon <bgardon@google.com>
>> ---
(..)
> I tested v2 with Maciej's test
> (https://urldefense.com/v3/__https://gist.github.com/maciejsszmigiero/890218151c242d99f63ea0825334c6c0__;!!GqivPVa7Brio!NUh8Xbu1YkhSf49HvbyhI-svvPmJXWj9KECqaEd7ZJMKPdz-HdND1sKduH2VpwasEN8Gpg$ ,
> near the bottom of the page) on an Intel Skylake Machine and can
> confirm that v1 failed the test but v2 passes. The problem with v1 was
> that roots were being removed from the list before list_next_entry was
> called, resulting in a bad value.
> 

I've tested the fix now and can confirm, too, that I can no longer
observe any crash.

Thanks,
Maciej
