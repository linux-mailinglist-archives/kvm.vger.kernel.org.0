Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1048F4BBDFE
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 18:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238153AbiBRRGt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 12:06:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238148AbiBRRGr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 12:06:47 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9544F54;
        Fri, 18 Feb 2022 09:06:25 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21IGcTtv036408;
        Fri, 18 Feb 2022 17:06:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=uyireqeUxx+W1eVB2rdg/kA4tqDlfRnSBxG00YgQGz8=;
 b=XcxmcJStXwjoyTg5Hnr4tfbppqolTmzKLrOXo8MSW748JGsX6xQV7dRjAY2zdZ7xcnqg
 aw0tScSJfhsmcp1jYfiw11qCQGEGgSGFQ+4zm504V79aVEK2aPmdmkC/yADTr6GFUHw8
 +nxACHWwZW94VbMkNeprZjgaxGKx4dU+Icr1i/VFPC6wh/SyNAbannCX2XMEIDB30eC/
 BqbCbtLT5TbRQHf/UKuZqgPIZm+VxH4bKPWFkO9KhpUvWYPxvl1qzjkH3LtiO5HzvCnw
 dLH/fdQTgfI39aAWzchVIfHIrOopBfegx/ofreMxCyEiC+3lMvjiTtdraoEqvHECD+uz aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eaexx8thh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Feb 2022 17:06:25 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21IGdKri038207;
        Fri, 18 Feb 2022 17:06:25 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eaexx8tgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Feb 2022 17:06:24 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21IH3uqO013656;
        Fri, 18 Feb 2022 17:06:22 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3e645kkkb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Feb 2022 17:06:22 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21IH6JG740894916
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Feb 2022 17:06:19 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11DD0A404D;
        Fri, 18 Feb 2022 17:06:19 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59F6FA4051;
        Fri, 18 Feb 2022 17:06:18 +0000 (GMT)
Received: from [9.171.47.189] (unknown [9.171.47.189])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 18 Feb 2022 17:06:18 +0000 (GMT)
Message-ID: <96fe20ac-bea0-7eee-cfb5-198a906e5399@linux.ibm.com>
Date:   Fri, 18 Feb 2022 18:08:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v7 1/1] s390x: KVM: guest support for topology function
Content-Language: en-US
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        gor@linux.ibm.com, wintera@linux.ibm.com, seiden@linux.ibm.com
References: <20220217095923.114489-1-pmorel@linux.ibm.com>
 <20220217095923.114489-2-pmorel@linux.ibm.com>
 <f0bf737abf480d6d16af6e5335bb195061f3d076.camel@linux.ibm.com>
 <97af6268-ff7a-cfb6-5ea4-217b5162cfe7@linux.ibm.com>
 <Yg+23xh7DDSRHFxK@osiris>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <Yg+23xh7DDSRHFxK@osiris>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IfpfTVUfv_1JqyrBaifEhsDRus0ke-EX
X-Proofpoint-ORIG-GUID: CE2b7bsqyAYz6ALk1vfk_x_DvWs5WNqZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-18_07,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 mlxlogscore=993 spamscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202180109
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/18/22 16:10, Heiko Carstens wrote:
>>>> +       /* The real CPU backing up the vCPU moved to another socket
>>>> */
>>>> +       if (topology_physical_package_id(vcpu->cpu) !=
>>>> +           topology_physical_package_id(vcpu->arch.prev_cpu))
>>>> +               return true;
>>>
>>> Why is it OK to look just at the physical package ID here? What if the
>>> vcpu for example moves to a different book, which has a core with the
>>> same physical package ID?
>>>
>>
>> You are right, we should look at the drawer and book id too.
>> Something like that I think:
>>
>>          if ((topology_physical_package_id(vcpu->cpu) !=
>>               topology_physical_package_id(vcpu->arch.prev_cpu)) ||
>>              (topology_book_id(vcpu->cpu) !=
>>               topology_book_id(vcpu->arch.prev_cpu)) ||
>>              (topology_drawer_id(vcpu->cpu) !=
>>               topology_drawer_id(vcpu->arch.prev_cpu)))
>>                  return true;
> 
> You only need to check if prev_cpu is present in topology_core_cpumask(cpu).
> 

Yes, thanks.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
