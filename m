Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E0F35D99D
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 10:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240470AbhDMII0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 04:08:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14604 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238229AbhDMII0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 04:08:26 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13D834iN024563;
        Tue, 13 Apr 2021 04:07:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ql7r4twH3uyhCQI3WyBa/+Qd1zCPeMx1W+pnxHpMXU4=;
 b=pdLfpNvjq37NJ9D7fhlZy5Sj4vGHxYnqDGkxvRFHkj967UNeZg1U+2mSkrRMvR638S0G
 grkhTD+Zz1MWJ6JFp11j6ahLEtu5fb/TEzDT139pSrPDOGm3gi4E4SssqSv0/2IUcJnk
 +TICj7Ud4tIbCywrgm+FEkfYlABgzWTRj/Q1l/4CjuAlL2AjO9ZDh4gfrInSV61/qHN/
 LYGLVhmNRRZ14BU/XM3E2qPqIZJ9BE8L2WS9IRnvUuoba3CKj3nIbMBLIY/QEKhec3Fa
 m4UxQLvXMZSAkDr5HfzEi67tNpuIeQJn1ONrpRRFRj65iMuJpkZl038kdNMBNmDY9yDq Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37w6uvhbcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 04:07:20 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13D83HNG026422;
        Tue, 13 Apr 2021 04:07:19 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37w6uvhbbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 04:07:19 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13D7wmPb002367;
        Tue, 13 Apr 2021 08:07:17 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 37u3n8agce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 08:07:17 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13D87FjY41812328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 08:07:15 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8EDBC4C044;
        Tue, 13 Apr 2021 08:07:15 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00B2A4C052;
        Tue, 13 Apr 2021 08:07:15 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.28.118])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 13 Apr 2021 08:07:14 +0000 (GMT)
Subject: Re: [PATCH v2 1/3] context_tracking: Split guest_enter/exit_irqoff
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>
References: <1618298169-3831-1-git-send-email-wanpengli@tencent.com>
 <1618298169-3831-2-git-send-email-wanpengli@tencent.com>
 <81112cec-72fa-dd8c-21c8-b24f51021f43@de.ibm.com>
 <CANRm+CwNxcKPKdV4Bxr-5sWJtg_SKZEN5atGJKRyLcVnWVSKSg@mail.gmail.com>
 <4551632e-5584-29f6-68dd-d85fa968858b@de.ibm.com>
 <CANRm+Cw=7kKztPFHaXrK926ve7pY3NN4O22t_QaevHnCXqX5tg@mail.gmail.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <1d6a5fa9-3639-0908-206f-c9e941270f11@de.ibm.com>
Date:   Tue, 13 Apr 2021 10:07:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CANRm+Cw=7kKztPFHaXrK926ve7pY3NN4O22t_QaevHnCXqX5tg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sib58JeUfnxZZPGmfodP0ElEmi9mFVRE
X-Proofpoint-GUID: EQAoTGuOQtv-r8sP28ywUXslUTNSPbjo
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-13_03:2021-04-13,2021-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 spamscore=0 clxscore=1015 impostorscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130055
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13.04.21 09:52, Wanpeng Li wrote:
>> Or did I miss anything.
> 
> I mean the if (!context_tracking_enabled_this_cpu()) part in the
> function context_guest_enter_irqoff() ifdef
> CONFIG_VIRT_CPU_ACCOUNTING_GEN. :)

Ah I missed that. Thanks.
