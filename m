Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE6451DC3E
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 17:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442930AbiEFPi5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 11:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbiEFPiz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 11:38:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F397F66;
        Fri,  6 May 2022 08:35:12 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 246Dmvbl019354;
        Fri, 6 May 2022 15:35:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=blLD599xWM8TsoqnVdATsyQkk63uresPs9SegCqqIJ8=;
 b=L/flva3qm311tXx/sh/kPxNxZSVMAyo8Shoq8uE+GtfAaIg2PRK2yTDmGRyIO+IygEa6
 +Ds2Z1c8Zh5Ocrh+lFb0+t1hs3rymY/O8xlwEXmdnR1JMJBZhOj/S347NL1BE82hXzvz
 70md7lrOiuqjx/YsqzIOW/4mp2wcHTHW09uZkc7Sd1mITrw9M8RvB34kRVVOzlCwQnHG
 OzeWAOO0hHyeCaEb8TrgyUKaftfO65wre7A3xUDUkkWXbjpNS+dr/Dh/HTeJ5x659jrf
 tiJJurRAAMi8fykICZzoI7C6oFvs/BE0QMiWSY1c73xlhrJ6yZwy+A6CDKOCmNWVetCr hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fw4w1jfm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 15:35:09 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 246FKSM1025004;
        Fri, 6 May 2022 15:35:09 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fw4w1jfk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 15:35:09 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 246FHbY9032762;
        Fri, 6 May 2022 15:35:06 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ftp7fwpaj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 15:35:06 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 246FYtpC32702734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 May 2022 15:34:55 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67D87A405B;
        Fri,  6 May 2022 15:35:03 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 588FFA4060;
        Fri,  6 May 2022 15:35:02 +0000 (GMT)
Received: from [9.171.60.83] (unknown [9.171.60.83])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 May 2022 15:35:02 +0000 (GMT)
Message-ID: <28395b98-3489-342a-970a-5358e4405f22@linux.ibm.com>
Date:   Fri, 6 May 2022 17:35:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v6 14/21] KVM: s390: pci: provide routines for
 enabling/disabling interrupt forwarding
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
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
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220426200842.98655-15-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NrU3OZfGBe5iOJbw7gkh1V-3ysVy0Ku8
X-Proofpoint-GUID: SQ06wbn3n7KXqve90ckpJdnRS_Tu02T4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_04,2022-05-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 priorityscore=1501 adultscore=0 phishscore=0 malwarescore=0
 mlxlogscore=950 lowpriorityscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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



Am 26.04.22 um 22:08 schrieb Matthew Rosato:
[...]
> +static inline void unaccount_mem(unsigned long nr_pages)
> +{
> +	struct user_struct *user = get_uid(current_user());
> +
> +	if (user)
> +		atomic_long_sub(nr_pages, &user->locked_vm);
> +	if (current->mm)
> +		atomic64_sub(nr_pages, &current->mm->pinned_vm);
> +}
> +
> +static inline int account_mem(unsigned long nr_pages)
> +{
> +	struct user_struct *user = get_uid(current_user());
> +	unsigned long page_limit, cur_pages, new_pages;
> +
> +	page_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> +
> +	do {
> +		cur_pages = atomic_long_read(&user->locked_vm);
> +		new_pages = cur_pages + nr_pages;
> +		if (new_pages > page_limit)
> +			return -ENOMEM;
> +	} while (atomic_long_cmpxchg(&user->locked_vm, cur_pages,
> +					new_pages) != cur_pages);
> +
> +	atomic64_add(nr_pages, &current->mm->pinned_vm);
> +
> +	return 0;

user->locked_vm is not available unconditionally. Shall we add

CONFIG_S390 && CONFIG_KVM here?

include/linux/sched/user.h
#if defined(CONFIG_PERF_EVENTS) || defined(CONFIG_BPF_SYSCALL) || \
     defined(CONFIG_NET) || defined(CONFIG_IO_URING)
         atomic_long_t locked_vm;
#endif
Or we could get rid of the user memlock checking for now until this is more ubiquitous.


Otherwise this looks sane

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
