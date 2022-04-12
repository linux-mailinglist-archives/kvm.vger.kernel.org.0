Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C2F4FE2A4
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 15:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355965AbiDLNYu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 09:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356574AbiDLNXS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 09:23:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485C913EBF;
        Tue, 12 Apr 2022 06:14:47 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23CBgE2v008904;
        Tue, 12 Apr 2022 13:14:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=pLTJILFWv8SMp1Gxs+TBC09oDeHM+2WiTPbdP91mfHs=;
 b=MOMKJ7kd488Bg/i2/BspB/Ri5+YzqBJNMRxZGtSAE1JoB1yl/6TIymGG4XbAvUpnqs6A
 MF8AkwVGxaXWHC8k0wL11OQKRoEx/MwUQqA0geQ+wxjD6i8xtk+P7eoVqN9XFAZq31/v
 rJcsl4ly9PK65yNmZ0kH0B5eBZ5bmrThP5o7u615hh//jkNznoIGC8MyFJwvMKrEkgmu
 6yEf7nnkqSD3dJMOCUYLSXzdcoxHV+qjXcu9K4DzhGl7MKay8J85KjzNrz7Ho2ZCM2Pm
 J5taZCAM7Qb8feem6XuktQOGsKn+9Dwn4W3DDJUHWFxD8JN2pTptDvrZGfZJ02W49lvK ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fd8sbj2qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 13:14:44 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23CD0i2I019215;
        Tue, 12 Apr 2022 13:14:43 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fd8sbj2qm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 13:14:43 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23CD7teF006999;
        Tue, 12 Apr 2022 13:14:43 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02wdc.us.ibm.com with ESMTP id 3fb1s9r4ra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 13:14:43 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23CDEgj226542584
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 13:14:42 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 505E9B2066;
        Tue, 12 Apr 2022 13:14:42 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C563B2064;
        Tue, 12 Apr 2022 13:14:38 +0000 (GMT)
Received: from [9.211.106.50] (unknown [9.211.106.50])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 12 Apr 2022 13:14:38 +0000 (GMT)
Message-ID: <b143e333-0add-8042-12de-7e9e8b275ec0@linux.ibm.com>
Date:   Tue, 12 Apr 2022 09:14:36 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v5 15/21] KVM: s390: pci: add routines to start/stop
 interpretive execution
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>
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
References: <20220404174349.58530-1-mjrosato@linux.ibm.com>
 <20220404174349.58530-16-mjrosato@linux.ibm.com>
 <20220408124707.GY64706@ziepe.ca>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220408124707.GY64706@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ug2cA0NUQiUtzyMfzAv0jirnerPyC71J
X-Proofpoint-ORIG-GUID: FbaeDxowGGk6k4drG8ggKIZDsBOdLcFr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_04,2022-04-12_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 clxscore=1011 bulkscore=0 mlxlogscore=713 lowpriorityscore=0
 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204120062
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/8/22 8:47 AM, Jason Gunthorpe wrote:
> On Mon, Apr 04, 2022 at 01:43:43PM -0400, Matthew Rosato wrote:
>> +int kvm_s390_pci_register_kvm(struct device *dev, void *data)
>> +{
>> +	struct zpci_dev *zdev = NULL;
>> +	struct kvm *kvm = data;
>> +
>> +	/* Only proceed for zPCI devices, quietly ignore others */
>> +	if (dev_is_pci(dev))
>> +		zdev = to_zpci_dev(dev);
>> +	if (!zdev)
>> +		return 0;
> 
> Especially since this only works if we have zpci device
> 
> So having the zpci code hook the kvm notifier and then call the arch
> code from the zpci area seems pretty OK
> 
> Also why is a struct kvm * being passed as a void *?

Only because the function is intended to be called via 
iommu_group_for_each_dev (next patch) which requires int (*fn)(struct 
device *, void *)



