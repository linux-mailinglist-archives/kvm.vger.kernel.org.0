Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20AC16644F1
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 16:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238789AbjAJPdy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 10:33:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239115AbjAJPdK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 10:33:10 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C913186;
        Tue, 10 Jan 2023 07:33:08 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30AFPrDw021470;
        Tue, 10 Jan 2023 15:33:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=4denREQZKmsoUZHgTVtUIfzFE1J9K1MAH3zJdHfo8CE=;
 b=Y4gn2dyas/FTlgKUihjMgveWOv3oRo/2i5++R7TXN9F++o+LBj9h76tfNIZhzyi2K/yC
 DzVTZRroQxyaSDxlTQ2IrO6RDKMAHRAYxA/xcEQ0dxJf2N+jxFp4k6yXk6kKuK5tzjkG
 rVC1MWMPuzWnQwIPt6O/I4aGP+IYa8z+mZ++Fl+XHR4B2vdA6Jd8vFIydOXpWxJw+96v
 lK7OFe+M3kl1f7F5UCNVvuYS9ITc1IYImreJVNiDu4nQEqdqw1fpYw1cbxTy5a5kxGhe
 riQu4wCenHAxRUexl8inny+CDfnprC1a+c/GpMmwdfyYPROg0joMBHmH3pKUZ+wlf96t 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n1ane05kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 15:32:59 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30AFQQ73022580;
        Tue, 10 Jan 2023 15:32:59 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n1ane05jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 15:32:59 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30AFD5Ld009734;
        Tue, 10 Jan 2023 15:32:58 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([9.208.129.120])
        by ppma03wdc.us.ibm.com (PPS) with ESMTPS id 3my0c7afyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 15:32:58 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
        by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30AFWvOj62652750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 15:32:57 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06E2B58058;
        Tue, 10 Jan 2023 15:32:57 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E088958052;
        Tue, 10 Jan 2023 15:32:55 +0000 (GMT)
Received: from [9.160.171.221] (unknown [9.160.171.221])
        by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Jan 2023 15:32:55 +0000 (GMT)
Message-ID: <a24f261b-6a02-5988-47b3-1cfc57fa6da8@linux.ibm.com>
Date:   Tue, 10 Jan 2023 10:32:55 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 1/4] vfio-mdev: allow building the samples into the kernel
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gfx@lists.freedesktop.org
References: <20230110091009.474427-1-hch@lst.de>
 <20230110091009.474427-2-hch@lst.de>
 <b317380e-26bf-b478-4aea-0355e0de4017@linux.ibm.com>
 <20230110152722.GB9485@lst.de>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20230110152722.GB9485@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9RaJsYmBh65_a6LbtTbqBdT8Ncd5KuzB
X-Proofpoint-GUID: w8k4qKyGVXxjLKu6IswKeoqvMKz_nNGV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-10_06,2023-01-10_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 mlxlogscore=919 spamscore=0 priorityscore=1501 adultscore=0 clxscore=1011
 bulkscore=0 suspectscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301100094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/10/23 10:27 AM, Christoph Hellwig wrote:
> On Tue, Jan 10, 2023 at 09:54:51AM -0500, Anthony Krowiak wrote:
>>> +	tristate "Build VFIO mtty example mediated device sample code"
>>> +	depends on VFIO_MDEV
>>
>> Admittedly, I'm not very fluent with Kconfig, but in patch 2 you stated,
>> "VFIO_MDEV is just a library with helpers for the drivers. Stop making it a
>> user choice and just select it by the drivers that use the helpers". Why
>> are you not selecting it here?
> Because this changes one thing at a time.  Patch 2 then switches this
> depends to a select.


My bad, I missed it.

Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>


