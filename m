Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8531452E9E5
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 12:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346494AbiETKbE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 06:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233724AbiETKa4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 06:30:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C1D140BC;
        Fri, 20 May 2022 03:30:54 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24K7nGjP022845;
        Fri, 20 May 2022 10:30:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=SAwEXgmn+ug7Ywtt15h7zATBYWFQXhVY/ziQbb8IdbE=;
 b=aWFvuz5UYZbLHdI1qm3nNpf2gi025MZH+E5FQFSiseGJMXeKsQX4CLWdafs7ppXNpCeT
 7bWRbQOK3BalA0fidpGCl+Bi5Y5vW88B8+PH3ZjgEU+Ivwfi3skAijjZAjQJrellzhSZ
 +y02UW2VF7VaSj4sM7gQHRDmIEa4cCRKAjx7cTsFV4lMoG9VuvvL4wv278c/7wSOXYc2
 ot9JUs19fFgaJik3Aop8hXyCUbBNFmWeRFdrmN0r/kDYqXBypZLx04GoxEHL+dmRo+oX
 W9GG3mfvv15FJal6P7KL+PPL1cQ/DU5wmuIYmLDQRXmvXXAsfbshxGUAlmMUu/Cmel22 Qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g63a96wyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 10:30:41 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24KAQHKP010615;
        Fri, 20 May 2022 10:30:40 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g63a96wy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 10:30:40 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24KASk1w031045;
        Fri, 20 May 2022 10:30:38 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3g2429gmh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 10:30:38 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24KAGcts50201020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 10:16:38 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A497A405F;
        Fri, 20 May 2022 10:30:35 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52DDAA4054;
        Fri, 20 May 2022 10:30:34 +0000 (GMT)
Received: from sig-9-145-82-10.uk.ibm.com (unknown [9.145.82.10])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 May 2022 10:30:34 +0000 (GMT)
Message-ID: <41dd3f695c57a12fc5e68a3ed818940252cdb69f.camel@linux.ibm.com>
Subject: Re: [PATCH] iommu/s390: tolerate repeat attach_dev calls
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>, jgg@nvidia.com,
        joro@8bytes.org
Cc:     will@kernel.org, alex.williamson@redhat.com, cohuck@redhat.com,
        borntraeger@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        farman@linux.ibm.com, iommu@lists.linux-foundation.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 20 May 2022 12:30:33 +0200
In-Reply-To: <20220519182929.581898-1-mjrosato@linux.ibm.com>
References: <20220519182929.581898-1-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UPQNWYGYN2jfEEnpr0kh6tsiw-ImLUir
X-Proofpoint-ORIG-GUID: lZwqxU0pyHDPdiisXyarqcrrM_OytcKb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_03,2022-05-20_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=768 priorityscore=1501 malwarescore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205200073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-05-19 at 14:29 -0400, Matthew Rosato wrote:
> Since commit 0286300e6045 ("iommu: iommu_group_claim_dma_owner() must
> always assign a domain") s390-iommu will get called to allocate multiple
> unmanaged iommu domains for a vfio-pci device -- however the current
> s390-iommu logic tolerates only one.  Recognize that multiple domains can
> be allocated and handle switching between DMA or different iommu domain
> tables during attach_dev.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---

I know it's applied already and no need to add my R-b but:

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>

