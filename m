Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFB7511A57
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 16:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238426AbiD0Opa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 10:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238319AbiD0Op3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 10:45:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5534B35878;
        Wed, 27 Apr 2022 07:42:18 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23RCh5FA014600;
        Wed, 27 Apr 2022 14:42:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=k+GrStm0Ysu+JMQMOJRXy4Xc+c0DmeROAWKzUIFx2OI=;
 b=guAshWAXrH1xD/9nK/Ha65c1rzDE4LFaM1shEsCAK4SzKn/Ve97tA7VSHhHZa+T/A3Jo
 QBgK80SF5Y5hRXjdRucfF3ZMEsl71fqgHZiuv+wg9mVomSCIl2ac/IBJNp59NJbnEOeV
 A0XwHUJ5inHR+ho7f75YxA/QjL7H/4/iXMQ+1Uxvp3l0Q9YPHB8TN0mwISkKg8E5uerD
 4QlEw8F9Q/aqnSi7QSL0xDXqas1Llz0Q6sJGXsUIiK4q/jBI4hpsPeoRxNcspNBBjABc
 gFLWqP1+IG6Zg4ou1s561CwiWspyt09sdJ/afRzPmrzwyW7p898XWGqf9Z5a44EDGMAy GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpvf2n5vp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 14:42:16 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23REXrLx026641;
        Wed, 27 Apr 2022 14:42:15 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpvf2n5vc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 14:42:15 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23REcSWQ028307;
        Wed, 27 Apr 2022 14:42:14 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04dal.us.ibm.com with ESMTP id 3fm93abs84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 14:42:14 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23REgDwm55902600
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 14:42:13 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E693AC065;
        Wed, 27 Apr 2022 14:42:13 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C838CAC05E;
        Wed, 27 Apr 2022 14:42:08 +0000 (GMT)
Received: from [9.211.73.42] (unknown [9.211.73.42])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 27 Apr 2022 14:42:08 +0000 (GMT)
Message-ID: <f6c78792-9cf7-0cde-f760-76166f9b7eb7@linux.ibm.com>
Date:   Wed, 27 Apr 2022 10:42:07 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v6 16/21] vfio-pci/zdev: add open/close device hooks
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220426200842.98655-1-mjrosato@linux.ibm.com>
 <20220426200842.98655-17-mjrosato@linux.ibm.com>
 <20220427140410.GX2125828@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220427140410.GX2125828@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GxVsMEQcXGhlmQ992YWp9KhgwHCvcuKx
X-Proofpoint-ORIG-GUID: R49eDuTDRAQg8XPIhpr4WkOX4mWpEJrd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-27_04,2022-04-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=749
 lowpriorityscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxscore=0 priorityscore=1501 adultscore=0 impostorscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204270092
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/27/22 10:04 AM, Jason Gunthorpe wrote:
> On Tue, Apr 26, 2022 at 04:08:37PM -0400, Matthew Rosato wrote:
> 
>> +static int vfio_pci_zdev_group_notifier(struct notifier_block *nb,
>> +					unsigned long action, void *data)
>> +{
>> +	struct zpci_dev *zdev = container_of(nb, struct zpci_dev, nb);
>> +	int (*fn)(struct zpci_dev *zdev, struct kvm *kvm);
>> +	int rc = NOTIFY_OK;
>> +
>> +	if (action == VFIO_GROUP_NOTIFY_SET_KVM) {
>> +		if (!zdev)
>> +			return NOTIFY_DONE;
>> +
>> +		fn = symbol_get(kvm_s390_pci_register_kvm);
>> +		if (!fn)
>> +			return NOTIFY_DONE;
>> +
>> +		if (fn(zdev, (struct kvm *)data))
>> +			rc = NOTIFY_BAD;
>> +
>> +		symbol_put(kvm_s390_pci_register_kvm);
> 
> Is it possible this function can be in statically linked arch code?
> 
> Or, actually, is zPCI useful anyhow without kvm ie can you just have a
> direct dependency here?
> 

zPCI devices (zpci_dev) exist regardless of whether kvm is configured or 
not, and you can e.g. bind the associated PCI device to vfio-pci when 
KVM is not configured (or module not loaded) and get the existing 
vfio-pci-zdev extensions for that device (extra VFIO_DEVICE_INFO 
response data).  Making a direct dependency on KVM would remove that; 
this was discussed in a prior version because this extra info is not 
used today outside of a KVM usecase -- but it could be useful in the 
future (or we may have other s390-isms that are not specific to kvm that 
need vfio-pci-zdev).

As far as statically linking in arch...  The fundamental 
(un)registration task being done here -- (dis)associating the guest GISA 
with the firmware and thus allowing this particular guest to use 
firmware assists (or turning it off when kvm == 0) -- is only relevant 
to guest passthrough with kvm and calls a number of different routines 
that reside in the kvm module during the (un)registration process. 
Without a direct dependency I think a symbol lookup still has to 
inevitably happen at some point in the call chain.
