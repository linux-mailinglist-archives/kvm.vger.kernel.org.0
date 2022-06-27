Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A7C55CE05
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240378AbiF0U6I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 16:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237599AbiF0U5z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 16:57:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FA65F46;
        Mon, 27 Jun 2022 13:57:52 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25RKgRJX009280;
        Mon, 27 Jun 2022 20:57:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Mg1mXq46lwWjOYPGFa6aZTnXVXBd+1ItFxTZzc2cyRA=;
 b=VG5rAMMiRSr/EsF10e4Qa/8F9B7kA4AEfaAMTzTtf6T3pHgL7MnNPazIF4IK0kSUm+/W
 OGROyJ9po3+NZPocu4hNuji0EVC/uh3psRtxIFLoweB+PRubMMhfwMsRaTjxDOJgGOAA
 LwQVac4zcKtVH/vtUljmr7Y7IdDroBzbElM7yGonMKZ+fGS0SMMlNpNaSWZzEXlBlBWt
 MFvG7389A79gZeWZAt25XaL+L29f3WFISfiMFwaix0Q6j29vDvDpDp/GZolOdVtoRtWM
 ow3kcF46Go3slJQ7fmCpuvrhp8kVm0xC/cBXio0gJTjILXmZdltU5vtuECHyR/zpYELp mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gyktjgcjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 20:57:50 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25RKsPBN025876;
        Mon, 27 Jun 2022 20:57:50 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gyktjgcj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 20:57:50 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25RKowbI011467;
        Mon, 27 Jun 2022 20:57:48 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01wdc.us.ibm.com with ESMTP id 3gwt090qff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 20:57:48 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25RKvmpR9371980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jun 2022 20:57:48 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20F2AB2065;
        Mon, 27 Jun 2022 20:57:48 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79BE0B2066;
        Mon, 27 Jun 2022 20:57:43 +0000 (GMT)
Received: from [9.163.8.193] (unknown [9.163.8.193])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jun 2022 20:57:43 +0000 (GMT)
Message-ID: <f86e2e05-114a-cc9e-8f3a-96b36889063d@linux.ibm.com>
Date:   Mon, 27 Jun 2022 16:57:42 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v9 00/21] KVM: s390: enable zPCI for interpretive
 execution
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        jgg@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220606203325.110625-1-mjrosato@linux.ibm.com>
In-Reply-To: <20220606203325.110625-1-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: R55Xn59uhCVJlVdv1QifeEKCKe5YqDcP
X-Proofpoint-ORIG-GUID: fUt8M3rRfiwx4w3h5tZbpHCdm7OMRxST
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-27_06,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1011
 suspectscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0 phishscore=0
 mlxlogscore=753 bulkscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206270084
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/6/22 4:33 PM, Matthew Rosato wrote:
> Enable interpretive execution of zPCI instructions + adapter interruption
> forwarding for s390x KVM vfio-pci.  This is done by triggering a routine
> when the VFIO group is associated with the KVM guest, transmitting to
> firmware a special token (GISA designation) to enable that specific guest
> for interpretive execution on that zPCI device.  Load/store interpreation
> enablement is then controlled by userspace (based upon whether or not a
> SHM bit is placed in the virtual function handle).  Adapter Event
> Notification interpretation is controlled from userspace via a new KVM
> ioctl.
> 
> By allowing intepretation of zPCI instructions and firmware delivery of
> interrupts to guests, we can reduce the frequency of guest SIE exits for
> zPCI.
> 
>  From the perspective of guest configuration, you passthrough zPCI devices
> in the same manner as before, with intepretation support being used by
> default if available in kernel+qemu.
> 
> Will follow up with a link the most recent QEMU series.
> 
> Changelog v8->v9:
> - Rebase on top of 5.19-rc1, adjust ioctl and capability defines
> - s/kzdev = 0/kzdev = NULL/ (Alex)
> - rename vfio_pci_zdev_open to vfio_pci_zdev_open_device (Jason)
> - rename vfio_pci_zdev_release to vfio_pci_zdev_close_device (Jason)
> - make vfio_pci_zdev_close_device return void, instead WARN_ON or ignore
>    errors in lower level function (kvm_s390_pci_unregister_kvm) (Jason)
> - remove notifier accidentally left in struct zpci_dev + associated
>    include statment (Jason)
> - Remove patch 'KVM: s390: introduce CPU feature for zPCI Interpretation'
>    based on discussion in QEMU thread.
> 

Ping -- I'm hoping this can make the next merge window, but there are 
still 2 patches left without any review tag (16 & 17).

