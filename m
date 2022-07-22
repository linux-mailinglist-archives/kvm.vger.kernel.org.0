Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A208257E048
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 12:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234803AbiGVKwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 06:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiGVKwi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 06:52:38 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00575B5560;
        Fri, 22 Jul 2022 03:52:37 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26MASomZ031721;
        Fri, 22 Jul 2022 10:52:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TXJr5gvkSfjpaKJwS52BBldx007V8s6/EU9SFaaScXU=;
 b=icV5oCywvyWyPDcyK4r4XmNx42nX3IvTO+g2E8y7+rfZbwI9+8b0i+uFLWoqXuQLxvqp
 YnT3QB1Mj91AmUaZqpk/UA8yUwSc9KxWYWLy8/x5q+rGTVyxjxJhNa/20yr72gHFdYcV
 TARDP3tQrVmfVw0lJgpyK/EDJVx8gKliHKeBSbXYuPBNIy20sqYBc/5Q9+Q4XVwwvv13
 HFYa6Q7ZGRVeV9LYMNvz7keVn5wpzIf4ZYxoJGJjNt5VJr5xuKZOiEepGBu8/+n+eL7P
 agxsM1rj6SN95dW0KOnFJEUj9SJFiPyp7+W8TU6B85hxJoyOXse7mn4u0F5Uc9R587Qj 7A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hft66rpq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 10:52:37 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26MATRdu032510;
        Fri, 22 Jul 2022 10:52:36 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hft66rppn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 10:52:36 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26MApbIP032056;
        Fri, 22 Jul 2022 10:52:34 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3hbmy8p6m0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 10:52:34 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26MAofN317236350
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jul 2022 10:50:41 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82A4711C04C;
        Fri, 22 Jul 2022 10:52:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D55811C04A;
        Fri, 22 Jul 2022 10:52:31 +0000 (GMT)
Received: from [9.171.5.186] (unknown [9.171.5.186])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Jul 2022 10:52:30 +0000 (GMT)
Message-ID: <4ace6d5f-e536-4a50-8451-8da84ece5847@linux.ibm.com>
Date:   Fri, 22 Jul 2022 12:52:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL 00/42] KVM: s390: PCI, CPU topology, PV features
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        Alex Williamson <alex.williamson@redhat.com>
References: <20220721161302.156182-1-imbrenda@linux.ibm.com>
 <4caa1fb2-febd-22e5-54b7-dababe63ae15@redhat.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <4caa1fb2-febd-22e5-54b7-dababe63ae15@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mpxJIhA6FQZP6HCn-SljuOKWYoGaSx_I
X-Proofpoint-ORIG-GUID: KyPvK9EstWFKgJsq50SDy-5MnHQCvYs4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-22_02,2022-07-21_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 mlxlogscore=999
 mlxscore=0 clxscore=1015 spamscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207220044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 22.07.22 um 09:17 schrieb Paolo Bonzini:
> On 7/21/22 18:12, Claudio Imbrenda wrote:
>> Hi Paolo,
>>
>> today you are getting the pull request from me :)
> 
> I'll trust you. :)
> 
>> this request has:
>>
>> * First part of deferred teardown (Claudio)
>> * CPU Topology (Pierre)
>> * interpretive execution for PCI instructions (Matthew)
>> * PV attestation (Steffen)
>> * Minor fixes

As a reminder. There is a (trivial) conflict with vfio-next.
Might be worth mentioning when sending to Linus.

