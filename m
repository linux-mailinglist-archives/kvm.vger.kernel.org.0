Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E89205F5607
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 16:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiJEOA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 10:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiJEOAz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 10:00:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F2E6E889;
        Wed,  5 Oct 2022 07:00:54 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 295DQpFH018763;
        Wed, 5 Oct 2022 14:00:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Id5lsR+X1siSa3ifaM4+hqNR4jc4s2N1uw4ZhTMSshw=;
 b=YyEGP+OIGX8qdgwUDJ103/8k/CUrIjGHwq1/l2aEn/m4BmIPn8T9BT91ECoE2gFoxuax
 OJ2GpiAp61b/AAalrhsrEvdN2EWMPv1d2OL8GlBkgWcKf7faeYom7HWv2pBprqRIu0tq
 teBOAXWbkRpr6/IjlX5EL/uYwotqyHKELiiUfap207vBe7RSx+rNNPh3XSBMCxCyfudL
 NpaddO4MhZKPQAdN56+z54YIwuFGT+soKG4cDD+ZqoyOhxSPTIhfKbPYZvG3tV37+Qac
 NwvgTum+JtmlELGDtKU0ZzYZj3MkOqvbpvPCJcajhbReN/QVu8z+j9oJ5TBLgwPZcvwe 4w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k1atnh7w0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Oct 2022 14:00:48 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 295DSs14031638;
        Wed, 5 Oct 2022 14:00:47 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k1atnh7u2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Oct 2022 14:00:47 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 295DoXBW018152;
        Wed, 5 Oct 2022 14:00:45 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3jxd68v4xh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Oct 2022 14:00:45 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 295E0gdg57737582
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Oct 2022 14:00:42 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A18911C052;
        Wed,  5 Oct 2022 14:00:42 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9338711C05B;
        Wed,  5 Oct 2022 14:00:41 +0000 (GMT)
Received: from [9.171.26.202] (unknown [9.171.26.202])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 Oct 2022 14:00:41 +0000 (GMT)
Message-ID: <bca44128-e550-e8e5-5d89-cd69307284f6@linux.ibm.com>
Date:   Wed, 5 Oct 2022 16:00:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2] vfio: Follow a strict lifetime for struct iommu_group
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        "Jason J . Herne" <jjherne@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <0-v2-a3c5f4429e2a+55-iommu_group_lifetime_jgg@nvidia.com>
 <4cb6e49e-554e-57b3-e2d3-bc911d99083f@linux.ibm.com>
 <20220927140541.6f727b01.alex.williamson@redhat.com>
 <52545d8b-956b-8934-8a7e-212729ea2855@linux.ibm.com>
 <YzxT6Suu+272gDvP@nvidia.com>
 <1aebfa84-8310-5dff-1862-3d143878d9dd@linux.ibm.com>
 <YzxfK/e14Bx9yNyo@nvidia.com>
 <0a0d7937-316a-a0e2-9d7d-df8f3f8a38e3@linux.ibm.com>
 <33bc5258-5c95-99ee-a952-5b0b2826da3a@linux.ibm.com>
 <8982bc22-9afa-dde4-9f4e-38948db58789@linux.ibm.com>
 <Yz2NSDa3E6LpW1c5@nvidia.com>
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <Yz2NSDa3E6LpW1c5@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GKMi5hiBflybN_G3pyJ1AX-2rzMoOY2m
X-Proofpoint-GUID: TYme39URQfJq-KeqF6-ZI_ifnhMcBYTz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-05_03,2022-10-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 bulkscore=0 clxscore=1015 mlxlogscore=848 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210050085
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 05.10.22 um 15:57 schrieb Jason Gunthorpe:
> On Wed, Oct 05, 2022 at 09:46:45AM -0400, Matthew Rosato wrote:
> 
>   
>> (again, with the follow-up applied) Besides the panic above I just
>> noticed there is also this warning that immediately precedes and is
>> perhaps more useful.  Re: what triggers the WARN, both group->owner
>> and group->owner_cnt are already 0
> 
> And this is after the 2nd try that fixes the locking?
> 
> This shows that vfio_group_detach_container() is called twice (which
> was my guess), hoever this looks to be impossible as both calls are
> protected by 'if (group->container)' and the function NULL's
> group->container and it is all under the proper lock.
> 
> My guess was that missing locking caused the two cases to race and
> trigger WARN, but the locking should fix that.
> 
> So I'm at a loss, can you investigate a bit?

So where is your 2nd version (and what was the first). I only saw one fix.
