Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1937E56A31D
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 15:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235409AbiGGNEl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 09:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235235AbiGGNEj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 09:04:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25C52B242;
        Thu,  7 Jul 2022 06:04:38 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267Cknlb032592;
        Thu, 7 Jul 2022 13:04:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=B0fxewBnJ4otqPSYN/xPY49Z/iG80ZN98QWcZT5x/tU=;
 b=UZ+8bAQI50VGitlgApHDZORSQX2LzK82FZtxT6sP1XhEVRS0NPGjKVLJaTUBrZKDWDo+
 5TDivii/cfqQKQtwqpbdNtR+RIhj6yZNuZpXoQFZvLdSlt0EJyVUrVKFA/ju702UhzBw
 oRvZXDlklvGIuWkZud0P8Nn61blrg0NZHKSfjiyIARsQ6/VXH6F1d8Xm8duIXkYwrrtf
 /Sx5ALZo3Gewe0eI1HNtTbQ4SbOEHbHFsg3X8MaAoLj4GpnM4xmv6CqsHu5pYxXtBKlW
 fO3oxLgcPM0bLFZh/GgtsPn9BFh+Mx5AN/FLe23GuOK0sKbzdMg/varJAXDUVR33Chuj Sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5ysw8ht3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 13:04:37 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 267CnSBp017489;
        Thu, 7 Jul 2022 13:04:36 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5ysw8hr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 13:04:36 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 267CphJQ022496;
        Thu, 7 Jul 2022 13:04:33 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3h4ujsjkyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 13:04:33 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 267D4Ul018219414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Jul 2022 13:04:30 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAD1211C052;
        Thu,  7 Jul 2022 13:04:30 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4074B11C04A;
        Thu,  7 Jul 2022 13:04:30 +0000 (GMT)
Received: from [9.171.47.29] (unknown [9.171.47.29])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Jul 2022 13:04:30 +0000 (GMT)
Message-ID: <0b2501e7-0e5c-9bf6-3317-611b96f44c58@linux.ibm.com>
Date:   Thu, 7 Jul 2022 15:04:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 00/11] s390/vfio-ccw rework
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <20220630203647.2529815-1-farman@linux.ibm.com>
 <20220630234411.GM693670@nvidia.com>
 <e8f1748eb1bae3e90521b0d5d4471266f4ea7c98.camel@linux.ibm.com>
 <f21307d9-6490-c39d-cff0-2a50c5f1cb35@linux.ibm.com>
 <20220704112511.GO693670@nvidia.com>
 <e1ead3e4-9e7d-f026-485b-157d7dc004d3@linux.ibm.com>
 <145a84e4-e228-0f18-eebe-7488f8b07d67@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <145a84e4-e228-0f18-eebe-7488f8b07d67@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0uJF8kD6E-7Dn74ovVXuqKKyDmAoK30l
X-Proofpoint-ORIG-GUID: JturGly2mjOZ-oMaTJTBKXKSSrDiB6Kg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-07_09,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxscore=0 phishscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207070052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 07.07.22 um 14:34 schrieb Matthew Rosato:
> On 7/7/22 5:06 AM, Christian Borntraeger wrote:
>>
>>
>> Am 04.07.22 um 13:25 schrieb Jason Gunthorpe:
>>> On Fri, Jul 01, 2022 at 02:48:25PM +0200, Christian Borntraeger wrote:
>>>
>>>> Am 01.07.22 um 14:40 schrieb Eric Farman:
>>>>> On Thu, 2022-06-30 at 20:44 -0300, Jason Gunthorpe wrote:
>>>>>> On Thu, Jun 30, 2022 at 10:36:36PM +0200, Eric Farman wrote:
>>>>>>> Here's an updated pass through the first chunk of vfio-ccw rework.
>>>>>>>
>>>>>>> As with v2, this is all internal to vfio-ccw, with the exception of
>>>>>>> the removal of mdev_uuid from include/linux/mdev.h in patch 1.
>>>>>>>
>>>>>>> There is one conflict with the vfio-next branch [2], on patch 6.
>>>>>>
>>>>>> What tree do you plan to take it through?
>>>>>
>>>>> Don't know. I know Matt's PCI series has a conflict with this same
>>>>> patch also, but I haven't seen resolution to that. @Christian,
>>>>> thoughts?
>>>>
>>>>
>>>> What about me making a topic branch that it being merged by Alex AND the KVM tree
>>>> so that each of the conflicts can be solved in that way?
>>>
>>> It make sense, I would base it on Alex's VFIO tree just to avoid
>>> some conflicts in the first place. Matt can rebase on this, so lets
>>> get things going?
>>
>> So yes. Lets rebase on VFIO-next. Ideally Alex would then directly pick Eric
>> patches.
> 
> @Christian to be clear, do you want me to also rebase the zPCI series on vfio-next then?

For that we are probably better of me having a topic branch that is then merged by Alex
and Paolo. Alex, Paolo, would be make sense?

As an alternative: will the vfio patches build without the KVM patches and vice versa,
I assume not?
