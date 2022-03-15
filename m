Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEB04DA040
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 17:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350104AbiCOQkv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 12:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236164AbiCOQkt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 12:40:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF6257155;
        Tue, 15 Mar 2022 09:39:37 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22FGPEvF029511;
        Tue, 15 Mar 2022 16:39:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=86aL+xbwdE1jgnOidVY4JgtAIE9bJ2Wd34ptqVKlogo=;
 b=BCG0f1Q12c1R85DRkjPGeZ+FTiyyDAir1dVi/qiNF20mpbbwYXkPm+FoE9bq3aRUaMUf
 X2wuJzcvd8sLNKIQipm6kCwdndDWV4LzAXEuCqU67xkSAVa5oIBsUHQezvuY+zBd9nmh
 eRGvbjq3uKQgVdz/8J768mZCyWGH3fNr0CJwoLFBiU5yi3BdkWzZ5xN+GnzI4+xOf5vB
 I25fZlFE+04vYoec8Q3Sg7LohQTgUp8RcTE5i+4IshU5oDe5ukmHVevOpbA9IVuGxvtX
 stYv2pGXXB3lA9N5TtCBZCYK+VgEHr+klT4UkoSpngstJNyqPEcPTPj5yO3AYV14KOrk SQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etxa28dbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 16:39:30 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22FGPjNs012271;
        Tue, 15 Mar 2022 16:39:29 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etxa28dax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 16:39:28 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22FGR9Mo019322;
        Tue, 15 Mar 2022 16:39:27 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02wdc.us.ibm.com with ESMTP id 3erk59ps5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 16:39:27 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22FGdP3Q27853244
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 16:39:25 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5F6DAC06A;
        Tue, 15 Mar 2022 16:39:25 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E478AAC066;
        Tue, 15 Mar 2022 16:39:14 +0000 (GMT)
Received: from [9.211.32.184] (unknown [9.211.32.184])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 15 Mar 2022 16:39:14 +0000 (GMT)
Message-ID: <3cc6dff9-0346-c449-249f-5812b3df379c@linux.ibm.com>
Date:   Tue, 15 Mar 2022 12:39:13 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v4 22/32] KVM: s390: pci: routines for (dis)associating
 zPCI devices with a KVM
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
 <20220314194451.58266-23-mjrosato@linux.ibm.com>
 <20220314214633.GJ11336@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220314214633.GJ11336@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iSDqed2p1r28JmWsOMYySAiM5fB1UvOT
X-Proofpoint-ORIG-GUID: xNu_0DWt1lKw2zQUPUBiiledYjR3anGK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_07,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/14/22 5:46 PM, Jason Gunthorpe wrote:
> On Mon, Mar 14, 2022 at 03:44:41PM -0400, Matthew Rosato wrote:
>> +int kvm_s390_pci_zpci_start(struct kvm *kvm, struct zpci_dev *zdev)
>> +{
>> +	struct vfio_device *vdev;
>> +	struct pci_dev *pdev;
>> +	int rc;
>> +
>> +	rc = kvm_s390_pci_dev_open(zdev);
>> +	if (rc)
>> +		return rc;
>> +
>> +	pdev = pci_get_slot(zdev->zbus->bus, zdev->devfn);
>> +	if (!pdev) {
>> +		rc = -ENODEV;
>> +		goto exit_err;
>> +	}
>> +
>> +	vdev = get_vdev(&pdev->dev);
>> +	if (!vdev) {
>> +		pci_dev_put(pdev);
>> +		rc = -ENODEV;
>> +		goto exit_err;
>> +	}
>> +
>> +	zdev->kzdev->nb.notifier_call = kvm_s390_pci_group_notifier;
>> +
>> +	/*
>> +	 * At this point, a KVM should already be associated with this device,
>> +	 * so registering the notifier now should immediately trigger the
>> +	 * event.  We also want to know if the KVM association is later removed
>> +	 * to ensure proper cleanup happens.
>> +	 */
>> +	rc = register_notifier(vdev->dev, &zdev->kzdev->nb);
>> +
>> +	put_vdev(vdev);
>> +	pci_dev_put(pdev);
>> +
>> +	/* Make sure the registered KVM matches the KVM issuing the ioctl */
>> +	if (rc || zdev->kzdev->kvm != kvm) {
>> +		rc = -ENODEV;
>> +		goto exit_err;
>> +	}
>> +
>> +	/* Must support KVM-managed IOMMU to proceed */
>> +	if (IS_ENABLED(CONFIG_S390_KVM_IOMMU))
>> +		rc = zpci_iommu_attach_kvm(zdev, kvm);
>> +	else
>> +		rc = -EINVAL;
> 
> This seems like kind of a strange API, shouldn't kvm be getting a
> reference on the underlying iommu_domain and then calling into it to
> get the mapping table instead of pushing KVM specific logic into the
> iommu driver?
> 
> I would be nice if all the special kvm stuff could more isolated in
> kvm code.
> 
> I'm still a little unclear about why this is so complicated - can't
> you get the iommu_domain from the group FD directly in KVM code as
> power does?

Yeah, I think I could do something like that using the vfio group fd 
like power does.

Providing a reference to the kvm itself inside iommu was being used for 
the pin/unpin operations, which would not be necessary if we switched to 
the 1st layer iommu pinning all of guest memory.



