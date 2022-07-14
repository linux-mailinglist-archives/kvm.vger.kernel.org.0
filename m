Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52164574563
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 08:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234312AbiGNG7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 02:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbiGNG7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 02:59:10 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD242B190;
        Wed, 13 Jul 2022 23:59:07 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26E6hmqE029727;
        Thu, 14 Jul 2022 06:59:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GeT64NfS5k2tAgpLSlglGCY4PhITfWskpQ5HmZ6QoX0=;
 b=llRSFn46x1quPK2wDOzYtg4bRovel3Od3mm+NjR7etSyuLFCYTZdEjKlxMzmj5X686DE
 aJEDEQJ5ptUSKLJe4ccGIHUMLjsbgv4CiScPQmTIyFW+9noxNc5/aSAxUopTqJPqtddj
 IjVoNK+rh/3c9qer5S9Vm7InluTtCikAO+Az49Vos6fJhysoHA7KfaLOX+hM7A1PZoiK
 G+yo49sM6DMJSYeL59zHRR4d7yTfYEHCdSRGeTCuIfMNhPi/HsVwiWJ5K1dEjuwIkLFv
 V8t9WjXx8DIthy3b4F5Y6u9XIUO9NUxPqggDb3CnO0X4dPJmyYoPGb/NUD19Orww3RIc nA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hae4frak9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 06:59:06 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26E6nwxg023864;
        Thu, 14 Jul 2022 06:59:06 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hae4frajq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 06:59:06 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26E6rSpI004319;
        Thu, 14 Jul 2022 06:59:04 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3h8ncnh5vr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 06:59:04 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26E6vS6b22020368
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 06:57:28 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18C19A4054;
        Thu, 14 Jul 2022 06:59:01 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9FA22A405C;
        Thu, 14 Jul 2022 06:59:00 +0000 (GMT)
Received: from [9.145.62.186] (unknown [9.145.62.186])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jul 2022 06:59:00 +0000 (GMT)
Message-ID: <abed8069-220a-ee32-b4fa-3cff935b539c@linux.ibm.com>
Date:   Thu, 14 Jul 2022 08:59:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
References: <20220628135619.32410-1-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v12 00/18] KVM: s390: pv: implement lazy destroy for
 reboot
In-Reply-To: <20220628135619.32410-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XNyKNM8aZ2gI7zY6NPWPZb6wPeL7o6gm
X-Proofpoint-ORIG-GUID: eCzD25cLDywZLHhs-OJ0w9_idvUGfNkH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-14_04,2022-07-13_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 malwarescore=0 clxscore=1015 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 mlxscore=0 mlxlogscore=972 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207140025
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/28/22 15:56, Claudio Imbrenda wrote:
> Previously, when a protected VM was rebooted or when it was shut down,
> its memory was made unprotected, and then the protected VM itself was
> destroyed. Looping over the whole address space can take some time,
> considering the overhead of the various Ultravisor Calls (UVCs). This
> means that a reboot or a shutdown would take a potentially long amount
> of time, depending on the amount of used memory.
> 
> This patchseries implements a deferred destroy mechanism for protected
> guests. When a protected guest is destroyed, its memory can be cleared
> in background, allowing the guest to restart or terminate significantly
> faster than before.
> 

Patches 1-12 have spent a considerable amount of time in the CI and I'd 
like to queue them to be able to focus on the rest of the series.

Patch 9 will need two small fixups since there are two conflicts where a 
line was introduced before your addition of the include and the struct 
kvm_s390_pv mmu_notifier member. I.e. it's more of a patch history 
problem than a real conflict.

I'd fix that up when queuing if you're ok with it?
