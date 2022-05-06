Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D20F51DCB6
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 18:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381301AbiEFQEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 12:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392246AbiEFQEf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 12:04:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB624D636;
        Fri,  6 May 2022 09:00:49 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 246FeEnw028532;
        Fri, 6 May 2022 16:00:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bRmWHothJ44idqRxRc2b4VvG+NnDl/cNT8TjtLNF0oA=;
 b=qj1uWR9hKfdHIXUpYuovn0sRaVNrm0WqBoQwyDIBr9xYlP46hgM9ZrPKbjxUysPrV2p0
 NZ9z5uQ0KdeTKyvr5SduHtYvEJx0DodtNVtjtkkQdA0wUAR4uwq2FjkllkX14b01EyiF
 T+sP4EAKOwo9XMebeVwbQ6Xz6jrSiYhmWsOPRUVbVeOUW27erfz+NPs3JYWU6m4Cf+DQ
 Fns15BFUbiWlvFi4T4zjU4rJgxmJh410mde+wLJbZl9/niOjaQyJmrTsSD8/cfI8CWVA
 TPzkvaYqChyU7HrN1oOy+Srj36LNDs/lKTb0Lwq5ppsnHOA+edwOyuwzpraMyw0WP+21 Sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fw5b4a1kh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 16:00:44 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 246FxA5I007140;
        Fri, 6 May 2022 16:00:43 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fw5b4a1k8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 16:00:43 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 246FeR5F018164;
        Fri, 6 May 2022 15:55:39 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04dal.us.ibm.com with ESMTP id 3frvrabh39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 15:55:39 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 246FtcBB34800094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 May 2022 15:55:38 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A5AB78060;
        Fri,  6 May 2022 15:55:38 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 080DA7805F;
        Fri,  6 May 2022 15:55:36 +0000 (GMT)
Received: from [9.211.41.182] (unknown [9.211.41.182])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  6 May 2022 15:55:35 +0000 (GMT)
Message-ID: <6e3f4d81-dcb5-9a64-a9f8-2c9b319574ef@linux.ibm.com>
Date:   Fri, 6 May 2022 11:55:35 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v6 14/21] KVM: s390: pci: provide routines for
 enabling/disabling interrupt forwarding
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        jgg@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220426200842.98655-1-mjrosato@linux.ibm.com>
 <20220426200842.98655-15-mjrosato@linux.ibm.com>
 <28395b98-3489-342a-970a-5358e4405f22@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <28395b98-3489-342a-970a-5358e4405f22@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZYJdC1IPRRb3XJnAspOlOwIp7kSxSB3-
X-Proofpoint-ORIG-GUID: 1Tvfo-boab2yO5F4ca5zEB0e4uWca6Lx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_04,2022-05-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 adultscore=0 phishscore=0 priorityscore=1501 impostorscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205060082
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/22 11:35 AM, Christian Borntraeger wrote:
> 
> 
> Am 26.04.22 um 22:08 schrieb Matthew Rosato:
> [...]
>> +static inline void unaccount_mem(unsigned long nr_pages)
>> +{
>> +    struct user_struct *user = get_uid(current_user());
>> +
>> +    if (user)
>> +        atomic_long_sub(nr_pages, &user->locked_vm);
>> +    if (current->mm)
>> +        atomic64_sub(nr_pages, &current->mm->pinned_vm);
>> +}
>> +
>> +static inline int account_mem(unsigned long nr_pages)
>> +{
>> +    struct user_struct *user = get_uid(current_user());
>> +    unsigned long page_limit, cur_pages, new_pages;
>> +
>> +    page_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
>> +
>> +    do {
>> +        cur_pages = atomic_long_read(&user->locked_vm);
>> +        new_pages = cur_pages + nr_pages;
>> +        if (new_pages > page_limit)
>> +            return -ENOMEM;
>> +    } while (atomic_long_cmpxchg(&user->locked_vm, cur_pages,
>> +                    new_pages) != cur_pages);
>> +
>> +    atomic64_add(nr_pages, &current->mm->pinned_vm);
>> +
>> +    return 0;
> 
> user->locked_vm is not available unconditionally. Shall we add
> 
> CONFIG_S390 && CONFIG_KVM here?
> 
> include/linux/sched/user.h
> #if defined(CONFIG_PERF_EVENTS) || defined(CONFIG_BPF_SYSCALL) || \
>      defined(CONFIG_NET) || defined(CONFIG_IO_URING)
>          atomic_long_t locked_vm;
> #endif
> Or we could get rid of the user memlock checking for now until this is 
> more ubiquitous.

Oh, good catch.  Per my conversation with Jason in a thread on patch 16, 
we will end up with a CONFIG_VFIO_PCI_ZDEV_KVM (or something like that) 
-- this could be used instead of CONFIG_S390 && CONFIG_KVM and would 
imply both of those anyway

> 
> 
> Otherwise this looks sane
> 
> Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>

