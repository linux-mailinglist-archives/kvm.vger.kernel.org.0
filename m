Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6265359D202
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 09:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240936AbiHWH0M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 03:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbiHWH0I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 03:26:08 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DCA62A9D;
        Tue, 23 Aug 2022 00:26:05 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27N7I8mi019262;
        Tue, 23 Aug 2022 07:25:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SmOYCQlEi9xOYSyDiv1CZsdu0MNpYC68EjaM4akqad0=;
 b=Y9TlNJQL3bt2TjCZI+ODTGspLlnve8roixvsUwMPCPJBVWr1KZ2Oz0MJmgMqv/Oz2flu
 ZsGr7hStED3LA9vlQOD7TQYYLW7FvcrI8M1IH0cIw60+4oEsVrG/YEAdhHYJksDaA2pm
 9MORs9m1kXXeBu5sht2uc+nVhUXS3UHk4fK+AEAe6K0SzksB43CcMohkGOyzNi1XyKiU
 RtAn+4RVRcweY3piRBqk4VxyElSV1l47kQ/mMSjov64hTqA/tYF9KOv+fsD9brRlSjv4
 dr7fZtbmf+R3Lb0ElHOMpc/piR0Si7+PaDoVKsoqcjoslQSwvUKfsC8nL+yH1Y8xxaDp OA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4tct84q9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 07:25:33 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27N7IbrP020072;
        Tue, 23 Aug 2022 07:25:33 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4tct84pk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 07:25:33 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27N7LYrS017635;
        Tue, 23 Aug 2022 07:25:31 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3j2q88ucvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 07:25:31 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27N7PSEb28901874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 07:25:28 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 459094C04A;
        Tue, 23 Aug 2022 07:25:28 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3A084C040;
        Tue, 23 Aug 2022 07:25:27 +0000 (GMT)
Received: from [9.145.84.26] (unknown [9.145.84.26])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Aug 2022 07:25:27 +0000 (GMT)
Message-ID: <6d11d3b5-a313-8e2b-2f38-44c5a4a63a28@linux.ibm.com>
Date:   Tue, 23 Aug 2022 09:25:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, mjrosato@linux.ibm.com
Cc:     rdunlap@infradead.org, linux-kernel@vger.kernel.org, lkp@intel.com,
        borntraeger@linux.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org, gor@linux.ibm.com,
        hca@linux.ibm.com, schnelle@linux.ibm.com,
        alex.williamson@redhat.com, cohuck@redhat.com
References: <20220819122945.9309-1-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v2] KVM: s390: pci: Hook to access KVM lowlevel from VFIO
In-Reply-To: <20220819122945.9309-1-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WApmKQCF6vWAoWUcQpk8IJczJiuGuinz
X-Proofpoint-ORIG-GUID: VYjopGuI7cEjOcfPDg0iFkAn8lI1nGfm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_02,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 clxscore=1011 mlxscore=0 spamscore=0 mlxlogscore=803
 adultscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208230027
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/19/22 14:29, Pierre Morel wrote:
> We have a cross dependency between KVM and VFIO when using
> s390 vfio_pci_zdev extensions for PCI passthrough
> To be able to keep both subsystem modular we add a registering
> hook inside the S390 core code.
> 
> This fixes a build problem when VFIO is built-in and KVM is built
> as a module.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Fixes: 09340b2fca007 ("KVM: s390: pci: add routines to start/stop interpretive execution")
> Cc: <stable@vger.kernel.org>

Acked-by: Janosch Frank <frankja@linux.ibm.com>

@Niklas @Matt: Since the patches that introduced the PCI interpretation 
went via the KVM tree I'll also move this patch via the KVM tree.
