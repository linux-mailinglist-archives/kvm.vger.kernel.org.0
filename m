Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7705715DF
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 11:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbiGLJjB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 05:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbiGLJiz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 05:38:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9928963A2;
        Tue, 12 Jul 2022 02:38:54 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26C9MfNH006467;
        Tue, 12 Jul 2022 09:38:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=6aeJAg1iZI9nzEd1LHJNgoB2C234O5R69qc1Bx6wE1Y=;
 b=PhC1rTpoe9U5/0THQi9EnqRNaQUGHuj4BN8zMZkxa5/MFLci5QLrBzJ/SpYZLXXI3zWN
 ItoiLq4cK172Go+oKadZuYRiuqklnBKxTR0gKwPv4F0p5bfycyr3MoLUOM9yOOnJ59qO
 yp23lsWr1pnq/MHRoSFHKUahhwNoq/18TXyENStj9x1gwRqMPqbVw44z93ESji3/rccK
 ukSf1mEzCXhyZZt4vMw1ksK577ec/AMFiDsZr9ofCvCFjRuahN6zUGGYAl3BBmOw1KDr
 BVWj59SFK1JHDarEV3ERA6N4NyEiu8UL09hE6ocSyExVkMnze8R2WcdI4e0kTi+XtcEr zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9697rfkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 09:38:42 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26C9NjiT017050;
        Tue, 12 Jul 2022 09:38:42 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9697rfjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 09:38:42 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26C9MCbC029154;
        Tue, 12 Jul 2022 09:38:39 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3h8rrn0vsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 09:38:39 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26C9ca0J21627138
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 09:38:36 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 860904C046;
        Tue, 12 Jul 2022 09:38:36 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B9044C040;
        Tue, 12 Jul 2022 09:38:36 +0000 (GMT)
Received: from [9.152.224.114] (unknown [9.152.224.114])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jul 2022 09:38:36 +0000 (GMT)
Message-ID: <8c7993c0-7c53-d609-c731-1c7c25e50a65@de.ibm.com>
Date:   Tue, 12 Jul 2022 11:38:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH next 3/3] Documentation: kvm: extend KVM_S390_ZPCI_OP
 subheading underline
Content-Language: en-US
To:     Bagas Sanjaya <bagasdotme@gmail.com>, linux-doc@vger.kernel.org
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220712092954.142027-1-bagasdotme@gmail.com>
 <20220712092954.142027-4-bagasdotme@gmail.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20220712092954.142027-4-bagasdotme@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5UhaZwNSk_6ShaMlXXSp1yVnwRUghYm8
X-Proofpoint-GUID: gzyBMWnMDx0EZfPxClnq1iG1st3N77hq
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_05,2022-07-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 impostorscore=0 clxscore=1011 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207120035
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Am 12.07.22 um 11:29 schrieb Bagas Sanjaya:
> Stephen Rothwell reported the htmldocs warning:
> 
> Documentation/virt/kvm/api.rst:5959: WARNING: Title underline too short.
> 
> 4.137 KVM_S390_ZPCI_OP
> --------------------
> 
> The warning is due to subheading underline on KVM_S390_ZPCI_OP section is
> short of 2 dashes.
> 
> Extend the underline to fix the warning.
> 
> Link: https://lore.kernel.org/linux-next/20220711205557.183c3b14@canb.auug.org.au/
> Fixes: a0c4d1109d6cc5 ("KVM: s390: add KVM_S390_ZPCI_OP to manage guest zPCI devices")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Pierre Morel <pmorel@linux.ibm.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: Matthew Rosato <mjrosato@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-s390@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

will queue this on top of the kvms390 tree.

> ---
>   Documentation/virt/kvm/api.rst | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 1ae3508d51c537..e6bd6c6dbd13ec 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5956,7 +5956,7 @@ KVM_PV_DUMP_CPU
>     The length of the returned data is provided by uv_info.guest_cpu_stor_len.
>   
>   4.137 KVM_S390_ZPCI_OP
> ---------------------
> +----------------------
>   
>   :Capability: KVM_CAP_S390_ZPCI_OP
>   :Architectures: s390
