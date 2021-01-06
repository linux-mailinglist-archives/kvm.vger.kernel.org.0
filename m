Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB832EC2E7
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 19:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbhAFSC4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 13:02:56 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60642 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbhAFSC4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 13:02:56 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106Hn0Wr066124;
        Wed, 6 Jan 2021 18:02:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=2lt3ykkXLU7Z05NRvknGfNq8ZldSt2677ItCZlpH1Cw=;
 b=ziGf732eXm4y4bArZ7Ykz4J8coQGXeg0yZ6trcTx3QbeqiwsPwzxu1ZryO5F9l9MO3Fk
 XWRToc5p7g3mWQHHOhs+2CPxh2YgHgYwxFST6b20QQ2bTbLaCRBwCykP9b7YEnTE8shn
 heADdXVW0RF9Wv3e1vusvI+SzSpXxg2y229SngcnoI66rdahmNxQQgMycliXEw4w5C8h
 ugX7GYnYXluTiCochiFDV6UGL2OQBur2h1k429rfFyW3XKnLlipdPwgM4iQ0fgvpZEDC
 CwWvROWkqT9fvyALWHwEae5U9TCUFa1jTnS8dS0vYeM8woX7M0UtqsAe7ShpIVfSVa23 cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35wcuxsj2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 18:02:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106Hpdr9105870;
        Wed, 6 Jan 2021 18:02:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 35w3g1e147-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 18:02:10 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 106I28jq006145;
        Wed, 6 Jan 2021 18:02:09 GMT
Received: from [192.168.1.3] (/89.66.140.113)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 10:02:08 -0800
Subject: Re: [PATCH 2/3] kvm: x86/mmu: Ensure TDP MMU roots are freed after
 yield
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Leo Hou <leohou1402@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>
References: <20210105233136.2140335-1-bgardon@google.com>
 <20210105233136.2140335-2-bgardon@google.com>
 <CANgfPd8TXa3GG4mQ7MD0wBrUOTdRDeR0z50uDmbcR88rQMn5FQ@mail.gmail.com>
 <e94e674e-1775-3c67-97f0-8c61e1add554@oracle.com>
 <CANgfPd-QPUwigK5um8DWQ5Y_M+JGRie_N_vkYtZdNE1WQbn3mA@mail.gmail.com>
 <4471c5e6-16a1-65c4-aa59-185091a2ebbc@oracle.com>
 <CANgfPd_jJmFT_ZLW9M0=AMP8fH9JnA2Jm1aymOwPBfnbL6odSw@mail.gmail.com>
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Message-ID: <7e1e20f7-4630-3329-41c9-ddd6597d2486@oracle.com>
Date:   Wed, 6 Jan 2021 19:02:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd_jJmFT_ZLW9M0=AMP8fH9JnA2Jm1aymOwPBfnbL6odSw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060103
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06.01.2021 18:56, Ben Gardon wrote:
> On Wed, Jan 6, 2021 at 9:37 AM Maciej S. Szmigiero
> <maciej.szmigiero@oracle.com> wrote:
>>
>> On 06.01.2021 18:28, Ben Gardon wrote:
>>> On Wed, Jan 6, 2021 at 1:26 AM Maciej S. Szmigiero
>>> <maciej.szmigiero@oracle.com> wrote:
>>>>
>>>> Thanks for looking at it Ben.
>>>>
>>>> On 06.01.2021 00:38, Ben Gardon wrote:
>>>> (..)
>>>>>
>>>>> +Sean Christopherson, for whom I used a stale email address.
>>>>> .
>>>>> I tested this series by running kvm-unit-tests on an Intel Skylake
>>>>> machine. It did not introduce any new failures. I also ran the
>>>>> set_memory_region_test
>>>>
>>>> It's "memslot_move_test" that is crashing the kernel - a memslot
>>>> move test based on "set_memory_region_test".
>>>
>>> I apologize if I'm being very dense, but I can't find this test
>>> anywhere.
>>
>> No problem, the reproducer is available here:
>> https://urldefense.com/v3/__https://gist.github.com/maciejsszmigiero/890218151c242d99f63ea0825334c6c0__;!!GqivPVa7Brio!N4KXBbUfHtzFMD33RIWVJQmeTtSrFm4n-Ve84kFEkuewBJNuaOpsdmdoqTGnw8DT_EktHA$
>> as I stated in my original report.
> 
> Ah, that makes sense now. I didn't realize there were more files below
> the .config. I added your test and can now reproduce the issue!

That's great!
Thanks for looking at it once again.

Maciej
