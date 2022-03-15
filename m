Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBF44DA013
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 17:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350081AbiCOQa5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 12:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350067AbiCOQat (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 12:30:49 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAF657142;
        Tue, 15 Mar 2022 09:29:36 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22FGEM4Y029688;
        Tue, 15 Mar 2022 16:29:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cbkYVQbQRRtLfFZ4wdGkiRutFnpOquBvZJYoshzzZi4=;
 b=caTfq98QMeGQf248z9VAEzG1kRAcOYKzm+X1QOZ5FmuJtUaEx+k71YYYAk1Wz/FgIs4+
 YRKcQSi26TjPnDq5zu+/6QTTt0FrN8brPa1+p/5DGaP575dA+oaBTKybXXhm8Mibft+F
 qYqrSQ2o2k1UKco4FK8nJA9lkEiMG4mM8gcCHm6LAOV4z1CRBfQlrHXtefLglzKEdzHx
 btiTfqQucAH9RE/q8SKADdWYcfLVJELHfwGlPZgQKAEn41AJqzjW0W3y1dzSLD3D9RGI
 pcGyDmwAPx135bzu91zAVrKoK1VyNue49E3vA8BHroMDjsy63McaODciBVrDNuyMlGD4 +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etw7p24wv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 16:29:18 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22FGEw13007435;
        Tue, 15 Mar 2022 16:29:18 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etw7p24wm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 16:29:18 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22FGRDhn009206;
        Tue, 15 Mar 2022 16:29:17 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04wdc.us.ibm.com with ESMTP id 3erk59pkqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 16:29:17 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22FGTFtc25297208
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 16:29:15 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2482AC06D;
        Tue, 15 Mar 2022 16:29:15 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8898FAC05E;
        Tue, 15 Mar 2022 16:29:04 +0000 (GMT)
Received: from [9.211.32.184] (unknown [9.211.32.184])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 15 Mar 2022 16:29:04 +0000 (GMT)
Message-ID: <5a1c64ac-df10-fb66-ad6d-39adf786f32b@linux.ibm.com>
Date:   Tue, 15 Mar 2022 12:29:02 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v4 15/32] vfio: introduce KVM-owned IOMMU type
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>, borntraeger@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, joro@8bytes.org, will@kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-doc@vger.kernel.org
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
 <20220314194451.58266-16-mjrosato@linux.ibm.com>
 <20220314213808.GI11336@nvidia.com>
 <decc5320-eb3e-af25-fd2b-77fabe56a897@linux.ibm.com>
 <20220315143858.GY11336@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220315143858.GY11336@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XovYpnHnN8X7XvZsXcj1wbC8jRUcunWF
X-Proofpoint-GUID: VyCBJft7M62L1ZwToTemOEV0VPlk6L0Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_03,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0 clxscore=1015
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150102
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/15/22 10:38 AM, Jason Gunthorpe wrote:
> On Tue, Mar 15, 2022 at 09:49:01AM -0400, Matthew Rosato wrote:
> 
>> The rationale for splitting steps 1 and 2 are that VFIO_SET_IOMMU doesn't
>> have a mechanism for specifying more than the type as an arg, no?  Otherwise
>> yes, you could specify a kvm fd at this point and it would have some other
>> advantages (e.g. skip notifier).  But we still can't use the IOMMU for
>> mapping until step 3.
> 
> Stuff like this is why I'd be much happier if this could join our
> iommfd project so we can have clean modeling of the multiple iommu_domains.
> 

I'd certainly be willing to collaborate so feel free to loop me in on 
the discussions; but I got the impression that iommufd is not close to 
ready (maybe I'm wrong?) -- if so I really don't want to completely 
delay this zPCI support behind it as it has a significant benefit for 
kvm guests on s390x :(

