Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E1351DC9F
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 17:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443219AbiEFQAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 12:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242211AbiEFQAT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 12:00:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B990F6A41C;
        Fri,  6 May 2022 08:56:35 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 246FNOwM009394;
        Fri, 6 May 2022 15:56:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=KhmnJeFSyRF4LtoXVy47PTVBdagm8XSy/kBl/ANo8hU=;
 b=ZOA7jZzjf7S57v+PLpk2JcawivlF+GwJoCz7MK6MrqWEGpXjK+/stS37+cLp/1RnGcR5
 sOOk7T75hA6KoB9knJCKGzOmOzeA/Zmw6yftAyNQX+D1k4wgnyQt8S3sczpzM7TkXMLq
 0MeHFR2MGBzpJ3tSJI+LPtUtvlh1xixH9dP5VNBrVHhEqcg5MlzfHEoeyDFrp3bSCo2b
 NsO1Wgwp4y48iVeu8VyBlqVs3dN4Nj8uSYHBySilRJvJi2+QCjMdvG438lPkRCBOev+A
 gWY//fxDNvnrEoVD9CNfxrb9wT/IKQBi6/R58WOuD2g0S4uskHYYu0r1xBqQL5/HFQiu VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fw699rk1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 15:56:32 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 246FqR8d015392;
        Fri, 6 May 2022 15:56:32 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fw699rk15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 15:56:32 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 246FdPBd021558;
        Fri, 6 May 2022 15:56:30 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3ftp7fwpys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 15:56:30 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 246FuRiB59113872
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 May 2022 15:56:27 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19527A4054;
        Fri,  6 May 2022 15:56:27 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14B6EA405C;
        Fri,  6 May 2022 15:56:26 +0000 (GMT)
Received: from [9.171.60.83] (unknown [9.171.60.83])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 May 2022 15:56:26 +0000 (GMT)
Message-ID: <8c48614a-4e93-a575-1a08-ead955ad2a91@linux.ibm.com>
Date:   Fri, 6 May 2022 17:56:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v6 16/21] vfio-pci/zdev: add open/close device hooks
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220426200842.98655-1-mjrosato@linux.ibm.com>
 <20220426200842.98655-17-mjrosato@linux.ibm.com>
 <20220427140410.GX2125828@nvidia.com>
 <f6c78792-9cf7-0cde-f760-76166f9b7eb7@linux.ibm.com>
 <20220427150138.GA2512703@nvidia.com>
 <1bca5de9-88aa-6abc-88b7-cbd2a11e5c85@linux.ibm.com>
 <20220427153924.GZ2125828@nvidia.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220427153924.GZ2125828@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: U5wlWa-tosuxYXfAN6YtnIWo1GItx_tq
X-Proofpoint-ORIG-GUID: zBZHDZW7t4jg2L8cmt_0T_sg0WGos1B8
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_04,2022-05-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=971 malwarescore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205060082
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 27.04.22 um 17:39 schrieb Jason Gunthorpe:
> On Wed, Apr 27, 2022 at 11:26:40AM -0400, Matthew Rosato wrote:
>>>> zPCI devices (zpci_dev) exist regardless of whether kvm is configured or
>>>> not, and you can e.g. bind the associated PCI device to vfio-pci when KVM is
>>>> not configured (or module not loaded) and get the existing vfio-pci-zdev
>>>> extensions for that device (extra VFIO_DEVICE_INFO response data).  Making a
>>>> direct dependency on KVM would remove that; this was discussed in a prior
>>>> version because this extra info is not used today outside of a KVM usecase
>>>> are not specific to kvm that need vfio-pci-zdev).
>>>
>>> I'm a bit confused, what is the drawback of just having a direct
>>> symbol dependency here? It means vfio loads a little extra kernel
>>> module code, but is that really a big worry given almost all vfio
>>> users on s390 will be using it with kvm?
>>
>> It's about trying to avoid loading unnecessary code (or at least giving a
>> way to turn it off).
>>
>> Previously I did something like....
>>
>> https://lore.kernel.org/kvm/20220204211536.321475-15-mjrosato@linux.ibm.com/
>>
>> And could do so again; as discussed in the thread there, I can use e.g.
>> CONFIG_VFIO_PCI_ZDEV_KVM and make vfio-pci-zdev depend on KVM in this
>> series.  You only get the vfio-pci-zdev extensions when you configure KVM.
> 
> That make sense to me, I'd rather see that then the symbol_get/put here

I agree with Jason here.
