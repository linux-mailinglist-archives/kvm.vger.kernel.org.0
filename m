Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB413511F7D
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 20:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239871AbiD0PaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 11:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239846AbiD0PaC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 11:30:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCDA36AF07;
        Wed, 27 Apr 2022 08:26:50 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23RFDTwk029543;
        Wed, 27 Apr 2022 15:26:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=r/3UuYYj8lO8LNwPx+iO0uhHHmy7sV/1IWHWhgrIb+g=;
 b=j1eISLJej7TVVPvyYib7O3eAR5TKVrNTi/l8XEUJkP+atwGe5nJAxphBf+tpZ6BLUDRb
 zo04XNDMX1ShJyMD4g1iELqmPFI/feKGau7JH1N06jiVz6pPAvo0k0PQBilEUDzTGWlu
 kBaTQK9wAqvhUPwpV2gQUgA88gkyKKR4igJU8mevFXBrZ1UAnl8jhWffeEJpmvnoBW+O
 gAOyrBScdI0f8ya4VYxMzR90iQaKYbdvKWZXkXg5a2hUQHnhhw47XkNnirGBmxId4szG
 /LLaAZWfU2+M5cj5xtEJIB9TSdoez93S1UcxDGL0PWSHlIXAd4xTgA7oa1s329rXBuRA cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fq7w5gx31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 15:26:48 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23RFDaU8030514;
        Wed, 27 Apr 2022 15:26:47 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fq7w5gx2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 15:26:47 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23RF8buU029492;
        Wed, 27 Apr 2022 15:26:47 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03dal.us.ibm.com with ESMTP id 3fm93a43ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 15:26:46 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23RFQjMj7013312
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 15:26:45 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE390AC05F;
        Wed, 27 Apr 2022 15:26:45 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 430B2AC059;
        Wed, 27 Apr 2022 15:26:41 +0000 (GMT)
Received: from [9.211.73.42] (unknown [9.211.73.42])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 27 Apr 2022 15:26:41 +0000 (GMT)
Message-ID: <1bca5de9-88aa-6abc-88b7-cbd2a11e5c85@linux.ibm.com>
Date:   Wed, 27 Apr 2022 11:26:40 -0400
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
 <f6c78792-9cf7-0cde-f760-76166f9b7eb7@linux.ibm.com>
 <20220427150138.GA2512703@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220427150138.GA2512703@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1a0tWSpKHa4Hxx9OL5kRQS7-X1kND_AI
X-Proofpoint-GUID: e_IrcGUWVhlThRpDryPgxUwfKy6CAsgR
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-27_04,2022-04-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 clxscore=1015 lowpriorityscore=0
 malwarescore=0 phishscore=0 suspectscore=0 mlxscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204270096
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/27/22 11:01 AM, Jason Gunthorpe wrote:
> On Wed, Apr 27, 2022 at 10:42:07AM -0400, Matthew Rosato wrote:
>> On 4/27/22 10:04 AM, Jason Gunthorpe wrote:
>>> On Tue, Apr 26, 2022 at 04:08:37PM -0400, Matthew Rosato wrote:
>>>
>>>> +static int vfio_pci_zdev_group_notifier(struct notifier_block *nb,
>>>> +					unsigned long action, void *data)
>>>> +{
>>>> +	struct zpci_dev *zdev = container_of(nb, struct zpci_dev, nb);
>>>> +	int (*fn)(struct zpci_dev *zdev, struct kvm *kvm);
>>>> +	int rc = NOTIFY_OK;
>>>> +
>>>> +	if (action == VFIO_GROUP_NOTIFY_SET_KVM) {
>>>> +		if (!zdev)
>>>> +			return NOTIFY_DONE;
>>>> +
>>>> +		fn = symbol_get(kvm_s390_pci_register_kvm);
>>>> +		if (!fn)
>>>> +			return NOTIFY_DONE;
>>>> +
>>>> +		if (fn(zdev, (struct kvm *)data))
>>>> +			rc = NOTIFY_BAD;
>>>> +
>>>> +		symbol_put(kvm_s390_pci_register_kvm);
>>>
>>> Is it possible this function can be in statically linked arch code?
>>>
>>> Or, actually, is zPCI useful anyhow without kvm ie can you just have a
>>> direct dependency here?
>>>
>>
>> zPCI devices (zpci_dev) exist regardless of whether kvm is configured or
>> not, and you can e.g. bind the associated PCI device to vfio-pci when KVM is
>> not configured (or module not loaded) and get the existing vfio-pci-zdev
>> extensions for that device (extra VFIO_DEVICE_INFO response data).  Making a
>> direct dependency on KVM would remove that; this was discussed in a prior
>> version because this extra info is not used today outside of a KVM usecase
>> are not specific to kvm that need vfio-pci-zdev).
> 
> I'm a bit confused, what is the drawback of just having a direct
> symbol dependency here? It means vfio loads a little extra kernel
> module code, but is that really a big worry given almost all vfio
> users on s390 will be using it with kvm?

It's about trying to avoid loading unnecessary code (or at least giving 
a way to turn it off).

Previously I did something like....

https://lore.kernel.org/kvm/20220204211536.321475-15-mjrosato@linux.ibm.com/

And could do so again; as discussed in the thread there, I can use e.g. 
CONFIG_VFIO_PCI_ZDEV_KVM and make vfio-pci-zdev depend on KVM in this 
series.  You only get the vfio-pci-zdev extensions when you configure KVM.

Then if we find a usecase for a vfio-pci-zdev extension without KVM 
later, we can further split vfio-pci-zdev and go back to building 
vfio-pci-zdev when CONFIG_S390 but only build the kvm pieces (like the 
code above) when you specify CONFIG_VFIO_PCI_ZDEV_KVM.  This would 
eliminate this symbol_get.  Sound OK?

> 
> Or is there some technical blocker? (circular dep or something?)
> 
> Jason

