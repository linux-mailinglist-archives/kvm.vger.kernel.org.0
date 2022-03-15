Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69EB64D9DD9
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 15:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349328AbiCOOk5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 10:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349261AbiCOOk4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 10:40:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEB5554B5;
        Tue, 15 Mar 2022 07:39:44 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22FETpll009276;
        Tue, 15 Mar 2022 14:39:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=HdrkUfe0/D5SVxX5k6mR556dpi7SYCIMHcWQB9GIKlo=;
 b=LbVoALjtgafgTI2BCQh6qHaf5siFetQrAIcatQeEdVxURph/o4sVEXrKHMx2c/8k3wrN
 EcbkMI6LjsH0SDP0gXkZb8Eizem2c5wugXoQjFuXP9dXKrDoHfIvmFk6m8eBtY7oUqPH
 1BfcQX9SS3i+K4bq6BCrde3+gtVMlZzGJLgdRV3sP8OP27KnHTsO84CpDigcQ827TfnE
 oqNRYDUI1VoOkj49rwl0X5g7BugVszAZ5jnEdDJh0q/MmOssk/bZUEOjWJbhXLmDAOET
 odCf/R2LpJprCYcxnXbe4rTc5xAFgB9qkKY7mbu0yBAhuwxVqw7GIB9i3Pda/Tu8lPh+ wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etujssxng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:39:38 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22FEU8u7011563;
        Tue, 15 Mar 2022 14:39:37 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etujssxn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:39:37 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22FEdD3G010354;
        Tue, 15 Mar 2022 14:39:36 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04dal.us.ibm.com with ESMTP id 3erk59kb6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:39:36 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22FEdYfe12386602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 14:39:34 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3486EAC062;
        Tue, 15 Mar 2022 14:39:34 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2C1BAC060;
        Tue, 15 Mar 2022 14:39:19 +0000 (GMT)
Received: from [9.211.32.184] (unknown [9.211.32.184])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 15 Mar 2022 14:39:19 +0000 (GMT)
Message-ID: <35ccdbb0-eb21-0c25-638e-4d46fb12e7a9@linux.ibm.com>
Date:   Tue, 15 Mar 2022 10:39:18 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v4 29/32] vfio-pci/zdev: add DTSM to clp group capability
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, joro@8bytes.org, will@kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-doc@vger.kernel.org
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
 <20220314194451.58266-30-mjrosato@linux.ibm.com>
 <20220314214928.GK11336@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220314214928.GK11336@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MRRtZXdh7x6rRNvT7Mp08XCMaAMnd3Gt
X-Proofpoint-ORIG-GUID: 5j6xI5tjpbzLXiLdvUu1mhlI6rdOOOoP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_03,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 mlxlogscore=966 adultscore=0 phishscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/14/22 5:49 PM, Jason Gunthorpe wrote:
> On Mon, Mar 14, 2022 at 03:44:48PM -0400, Matthew Rosato wrote:
>> The DTSM, or designation type supported mask, indicates what IOAT formats
>> are available to the guest.  For an interpreted device, userspace will not
>> know what format(s) the IOAT assist supports, so pass it via the
>> capability chain.  Since the value belongs to the Query PCI Function Group
>> clp, let's extend the existing capability with a new version.
> 
> Why is this on the VFIO device?

Current vfio_pci_zdev support adds a series of capability chains to the 
VFIO_DEVICE_GET_INFO ioctl.  These capability chains are all related to 
output values associated with what are basically s390x query instructions.

The capability chain being modified by this patch is used to populate a 
response to the 'query this zPCI group' instruction.

> 
> Maybe I don't quite understand it right, but the IOAT is the
> 'userspace page table'?

IOAT = I/O Address Translation tables;  the head of which is called the 
IOTA (translation anchor).  But yes, this would generally refer to the 
guest DMA tables.

Specifically here we are only talking about the DTSM which is the 
formats that the guest is allowed to use for their address translation 
tables, because the hardware (or in our case the intermediary kvm iommu) 
can only operate on certain formats.

> 
> That is something that should be modeled as a nested iommu domain.
> 
> Querying the formats and any control logic for this should be on the
> iommu side not built into VFIO.

I agree that the DTSM is really controlled by what the IOMMU domain can 
support (e.g. what guest table formats it can actually operate on) and 
so the DTSM value should come from there vs out of KVM; but is there 
harm in including the query response data here along with the rest of 
the response information for 'query this zPCI group'?
