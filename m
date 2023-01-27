Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E1267DFB3
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 10:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbjA0JJX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 04:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjA0JJW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 04:09:22 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0AF4C10;
        Fri, 27 Jan 2023 01:09:21 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30R8kucJ018948;
        Fri, 27 Jan 2023 09:09:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=4SZ7Es78iT9Bl1L8QXSmRpFohHTfZAPVu/ApukTo7Z0=;
 b=YYkwhCm6UX5DAfcGZbpf9cxes+8jobXlLBqG4S1Ag4hSDqQV5cwI10mkqQmddgVH1Zam
 Qm0EbqO7MVO0LvTOKnvd47FrvAMFqKUwnE4iuU5FbjtTQ2GnWWEWglhKb+RP+0Q5iwSj
 1z+k3DCi+PCzyTaGgQr8EY35f3SP3HJW7J/dSEyX5SGT6IiNiQydad1xFYkaxyxuE8w7
 Y8L1IosVUIQVVYS1QFr78DNjBPzAeVR7lX2LJI9pDb8lX3eGVXCl5tcC6+hTFuhn6jxX
 o+rebkduEU7ZnshKtPzCOyqURz5iRo+jhWpidaMpaoeBZlB2AWmJZHshIBc10FlZKtdp 4Q== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nc8gxm80g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Jan 2023 09:09:20 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30R54RpW014840;
        Fri, 27 Jan 2023 09:09:18 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3n87affb05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Jan 2023 09:09:18 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30R99ENW39715088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 09:09:15 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D55302004B;
        Fri, 27 Jan 2023 09:09:14 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BD452004D;
        Fri, 27 Jan 2023 09:09:14 +0000 (GMT)
Received: from [9.171.2.114] (unknown [9.171.2.114])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 27 Jan 2023 09:09:14 +0000 (GMT)
Message-ID: <c883a240-b5ad-9b21-006d-1074fc122f7b@linux.ibm.com>
Date:   Fri, 27 Jan 2023 10:09:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 1/1] KVM: s390: disable migration mode when dirty
 tracking is disabled
To:     Nico Boehr <nrb@linux.ibm.com>, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230126174027.133667-1-nrb@linux.ibm.com>
 <20230126174027.133667-2-nrb@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230126174027.133667-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: knMs9129_GZc04o7tlRVGvXn9NaAGZrf
X-Proofpoint-GUID: knMs9129_GZc04o7tlRVGvXn9NaAGZrf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_04,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 mlxlogscore=791 spamscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301270084
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/26/23 18:40, Nico Boehr wrote:
> Migration mode is a VM attribute which enables tracking of changes in
> storage attributes (PGSTE). It assumes dirty tracking is enabled on all
> memslots to keep a dirty bitmap of pages with changed storage attributes.
> 
> When enabling migration mode, we currently check that dirty tracking is
> enabled for all memslots. However, userspace can disable dirty tracking
> without disabling migration mode.
> 
> Since migration mode is pointless with dirty tracking disabled, disable
> migration mode whenever userspace disables dirty tracking on any slot.
> 
> Also update the documentation to clarify that dirty tracking must be
> enabled when enabling migration mode, which is already enforced by the
> code in kvm_s390_vm_start_migration().
> 
> Also highlight in the documentation for KVM_S390_GET_CMMA_BITS that it
> can now fail with -EINVAL when dirty tracking is disabled while
> migration mode is on. Move all the error codes to a table to this stays
> readable.
> 
> To disable migration mode, slots_lock should be held, which is taken
> in kvm_set_memory_region() and thus held in
> kvm_arch_prepare_memory_region().
> 
> Restructure the prepare code a bit so all the sanity checking is done
> before disabling migration mode. This ensures migration mode isn't
> disabled when some sanity check fails.
> 
> Cc: stable@vger.kernel.org
> Fixes: 190df4a212a7 ("KVM: s390: CMMA tracking, ESSA emulation, migration mode")
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

