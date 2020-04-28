Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7DC1BCFFF
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 00:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgD1Wak (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 18:30:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5266 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725934AbgD1Wak (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 18:30:40 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03SM2oeZ060650;
        Tue, 28 Apr 2020 18:30:36 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mh6ux3p1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 18:30:35 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03SMRrGi122875;
        Tue, 28 Apr 2020 18:30:35 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mh6ux3np-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 18:30:35 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03SMPPIj013332;
        Tue, 28 Apr 2020 22:30:34 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02wdc.us.ibm.com with ESMTP id 30mcu6fqc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 22:30:34 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03SMUX4714418608
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 22:30:33 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51BB5AE063;
        Tue, 28 Apr 2020 22:30:33 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2E9DAE068;
        Tue, 28 Apr 2020 22:30:32 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com (unknown [9.85.144.216])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 28 Apr 2020 22:30:32 +0000 (GMT)
Subject: Re: [PATCH v7 01/15] s390/vfio-ap: store queue struct in hash table
 for quick access
To:     Harald Freudenberger <freude@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
 <20200407192015.19887-2-akrowiak@linux.ibm.com>
 <20200424055732.7663896d.pasic@linux.ibm.com>
 <d15b4a8e-66eb-e4ce-c8ac-6885519940aa@linux.ibm.com>
 <20200427171739.76291a74.pasic@linux.ibm.com>
 <6ea12752-d23f-abe4-8d5f-3e7738984576@linux.ibm.com>
 <20200428120726.3f769ce3.pasic@linux.ibm.com>
 <bc6ac9ef-f9ad-f41a-024d-db3d5c2ddd10@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <e3777193-2b9c-e04b-2d2e-c4337d706d93@linux.ibm.com>
Date:   Tue, 28 Apr 2020 18:30:32 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <bc6ac9ef-f9ad-f41a-024d-db3d5c2ddd10@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_14:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 suspectscore=3 bulkscore=0 spamscore=0 mlxscore=0 impostorscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280166
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/28/20 6:57 AM, Harald Freudenberger wrote:
> On 28.04.20 12:07, Halil Pasic wrote:
>> On Mon, 27 Apr 2020 17:48:58 -0400
>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>
>>> On 4/27/20 11:17 AM, Halil Pasic wrote:
>>>> On Mon, 27 Apr 2020 15:05:23 +0200
>>>> Harald Freudenberger <freude@linux.ibm.com> wrote:
>>>>
>>>>> On 24.04.20 05:57, Halil Pasic wrote:
>>>>>> On Tue,  7 Apr 2020 15:20:01 -0400
>>>>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>>>>    
>>>>>>> Rather than looping over potentially 65535 objects, let's store the
>>>>>>> structures for caching information about queue devices bound to the
>>>>>>> vfio_ap device driver in a hash table keyed by APQN.
>>>>>> @Harald:
>>>>>> Would it make sense to make the efficient lookup of an apqueue base
>>>>>> on its APQN core AP functionality instead of each driver figuring it out
>>>>>> on it's own?
>>>>>>
>>>>>> If I'm not wrong the zcrypt device/driver(s) must the problem of
>>>>>> looking up a queue based on its APQN as well.
>>>>>>
>>>>>> For instance struct ep11_cprb has a target_id filed
>>>>>> (arch/s390/include/uapi/asm/zcrypt.h).
>>>>>>
>>>>>> Regards,
>>>>>> Halil
>>>>> Hi Halil
>>>>>
>>>>> no, the zcrypt drivers don't have this problem. They build up their own device object which
>>>>> includes a pointer to the base ap device.
>>>> I'm a bit confused. Doesn't your code loop first trough the ap_card
>>>> objects to find the APID portion of the APQN, and then loop the queue
>>>> list of the matching card to find the right ap_queue object? Or did I
>>>> miss something? Isn't that what _zcrypt_send_ep11_cprb() does? Can you
>>>> point me to the code that avoids the lookup (by apqn) for zcrypt?
>>> The code you reference, _zcrypt_send_ep11_cprb(), does loop through
>>> each queue associated with each card, but it doesn't appear to be
>>> looking for
>>> a queue with a particular APQN. It appears to be looking for a queue
>>> meeting a specific set of conditions. At least that's my take after
>>> taking a very
>>> brief look at the code, so I'm not sure that applies here.
>>>
>> One of the possible conditions is that the APQN is in the targets array.
>> Please have another look at the code below, is_desired_ep11_queue()
>> and is_desired_ep11_card() do APQI and APID part of the check
>> respectively:
>>
>>          for_each_zcrypt_card(zc) {
>>                  /* Check for online EP11 cards */
>>                  if (!zc->online || !(zc->card->functions & 0x04000000))
>>                          continue;
>>                  /* Check for user selected EP11 card */
>>                  if (targets &&
>>                      !is_desired_ep11_card(zc->card->id, target_num, targets))
>>                          continue;
>>                  /* check if device node has admission for this card */
>>                  if (!zcrypt_check_card(perms, zc->card->id))
>>                          continue;
>>                  /* get weight index of the card device  */
>>                  weight = speed_idx_ep11(func_code) * zc->speed_rating[SECKEY];
>>                  if (zcrypt_card_compare(zc, pref_zc, weight, pref_weight))
>>                          continue;
>>                  for_each_zcrypt_queue(zq, zc) {
>>                          /* check if device is online and eligible */
>>                          if (!zq->online ||
>>                              !zq->ops->send_ep11_cprb ||
>>                              (targets &&
>>                               !is_desired_ep11_queue(zq->queue->qid,
>>                                                      target_num, targets)))
>>
>>
>> Yes the size of targets may or may not be 1 (example for size == 1 is
>> the invocation form ep11_cryptsingle()) and the respective costs
>> depend on the usual size of the array. Since the goal of the whole
>> exercise seems to be to pick a single queue, and we settle with the first
>> suitable (first not in the input array, but in our lists) that is
>> suitable, I assumed we wouldn't need many hashtable lookups.
>>
>> Regards,
>> Halil
> again, this is all code related to zcrypt card and queues and has nothing directly to do with ap queue and ap cards.
> If you want to have a look how this works for ap devices, have a look into the scan routines for the ap bus in ap_bus.c
> There you can find a bus_for_each_device() which would fit together with the right matching function for your needs.
> And this is exactly what Tony implemented in the first shot. However, as written I can provide something like that
> for you.
> One note for the improvement via hash list with the argument about the max 65535 objects.
> Think about a real big machine which has currently up to 30 crypto cards (z15 GA1.5) which when CEX7S are
> plugged appear as 60 crypto adapters and have up to 85 domains each. When all these crypto resources
> are assigned to one LPAR we end up in 60x85 = 5100 APQNs. Well, of course with a hash you can improve
> the linear search through an array or list but can you measure the performance gain and then compare this
> to the complexity.  ... just some thoughts about beautifying code ...

I set up a test case to compare searching using a hashtable verses using 
a list.
I created both a hashtable and a list of 5100 objects. Each structure 
had a single
APQN field. I then randomly searched both the hashtable and the list for
each APQN. The following table contains the result of 5 test runs. The 
elapsed
times are in nanoseconds.

Test:                              List Search    Hashtable Search
------                              ----------- ----------------
Avg. Per APQN:             11651           81
Total per 5500 APQNs:  60164268     1085368

Avg. Per APQN:              10925           78
Total per 5500 APQNs:   56482780    1084590

Avg. Per APQN:              10190           80
Total per 5500 APQNs:   52714920    1123205

Avg. Per APQN:              8431             76
Total per 5500 APQNs:   43748838    1061414

Avg. Per APQN:              9678             75
Total per 5500 APQNs:   50103437    1044427
-----------------------------------------------
Per APQN Search Avg:   10175          78            Hashtable is 130 
times faster
Total Search 5500 Avg:  52642848    1079800  Hashtable is 49 times faster

Note that the list search was just a straight search of an object in a 
list, not
a device attached to a bus. I don't know if that would add time, but it 
seems
that the savings using a hashtable are significant.

So I have two questions:

1. Would it make more sense to provide AP bus interfaces to search for
     queue devices by APQN?

2. If so, shall we store the queue devices in a hashtable to make the
     searches more efficient?

>>>> If you look at the new function of vfio_ap_get_queue(unsigned long apqn)
>>>> it basically about finding the queue based on the apqn, with the
>>>> difference that it is vfio specific.
>>>>
>>>> Regards,
>>>> Halil
>>>>
>>>>> However, this is not a big issue, as the ap_bus holds a list of ap_card objects and within each
>>>>> ap_card object there exists a list of ap_queues.
>>>>

