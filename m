Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C756D402DE5
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 19:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344732AbhIGRpe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 13:45:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58784 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345719AbhIGRpc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Sep 2021 13:45:32 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 187HXxBu142688;
        Tue, 7 Sep 2021 13:44:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=sFD+dQPTw69DjL1ZFGz49VYicjn5stdn6/UoTurDxH4=;
 b=IXAohVKGFccxtLO4fDoo/4rpwEUrJdcl08ymn1NfVYDUEYR8ldzpBlUolAxpbhvfCv3f
 a/vzubk1qPutr82IS0oeuviPWutSlqQgsIQnR5vKy/DV7OiTjBugXYsf29ZblyESIClo
 elO3DTndBjawEG0wJy2ZJ7KGAf+d/9iWL/cILr6YKf7uhZoyZ7H3s/cCX+yyo53Pb7Ir
 l+/Q0FMVYpNhvbh6ctcYHxmvvIcw5qdW45XCukE4Z27AVc9nBPFQbSpIUxOAorOpk5i/
 dSIyWcpKqljSllZEuyXJuJchhan0TmwzLkMBDFcXT1kU3OMMJ2UDFHuDR5xjORbJgKD2 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3axc4h1445-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Sep 2021 13:44:13 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 187Hav2s153372;
        Tue, 7 Sep 2021 13:44:13 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3axc4h143e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Sep 2021 13:44:13 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 187HcHXW023877;
        Tue, 7 Sep 2021 17:44:12 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 3axcnh87v3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Sep 2021 17:44:12 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 187HiAUQ29688154
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Sep 2021 17:44:10 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF73BC606C;
        Tue,  7 Sep 2021 17:44:10 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3157C605B;
        Tue,  7 Sep 2021 17:44:06 +0000 (GMT)
Received: from [9.65.84.185] (unknown [9.65.84.185])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  7 Sep 2021 17:44:06 +0000 (GMT)
Subject: Re: [RFC PATCH v2 11/12] i386/sev: sev-snp: add support for CPUID
 validation
To:     Michael Roth <michael.roth@amd.com>
Cc:     qemu-devel@nongnu.org, Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
 <20210826222627.3556-12-michael.roth@amd.com>
 <8c89a4e7-8d3e-645e-c2a8-16f3c146ef32@linux.ibm.com>
 <20210907165033.56bkajbopc3zchl4@amd.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
Message-ID: <fff74b1a-3a49-6279-1e76-62f42e9e3d1a@linux.ibm.com>
Date:   Tue, 7 Sep 2021 20:44:04 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210907165033.56bkajbopc3zchl4@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zf3fh7BIbZ7SXGXssrRrrtceMb53LQrl
X-Proofpoint-GUID: r01gM27ZnTbDyfw70h6ejq7xS3p2uoph
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-07_06:2021-09-07,2021-09-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1015 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109070114
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07/09/2021 19:50, Michael Roth wrote:
> On Sun, Sep 05, 2021 at 01:02:12PM +0300, Dov Murik wrote:
>> On 27/08/2021 1:26, Michael Roth wrote:

[...]

>>> +    for (i = 0; i < old->count; i++) {
>>> +        SnpCpuidFunc *old_func, *new_func;
>>> +
>>> +        old_func = &old->entries[i];
>>> +        new_func = &new->entries[i];
>>> +
>>> +        if (memcmp(old_func, new_func, sizeof(SnpCpuidFunc))) {
>>
>> Maybe clearer:
>>
>>     if (*old_func != *new_func) ...
> 
> Not 2 structs can be compared this way, maybe I'll just compare the
> individual members.
> 

Oops, my bad; I was confusing it with struct assignment.  I guess memcmp
is fine as-is in this case.


-Dov

