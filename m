Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D28B163BA4
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 04:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgBSDtS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 22:49:18 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59640 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbgBSDtS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 22:49:18 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01J3mvlY170771;
        Wed, 19 Feb 2020 03:49:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=gHlccQ6ZZAYSbCQvUXMqxP/tdLBTjkConysTLhwg+LU=;
 b=mrPteIz90peuC/Duu4pivDaPAwnRfz3K39l4PuvHw0BdY/cSP9JmJf/d35otq0LcMyZE
 33MVlSDUYXpjIzWjfjpNCfmKXg1hvVgee0/HrbWBuVhQAikeSu/eoMjYLlLWB9PfYlHD
 tPvlwGx4mQR3mW923jfRk38WVPWEjlBd94/A/yxakZnYz2167woPBfXBr4wwFDIaCd4X
 xyyYHFUKnym6k5rYcPhs9RH8QN5d+TuH3BW8jn7kA53u97zZgsOUDdmcYIVOJhrrsF5O
 o+hnAAC77o/IMqSK39hQBbR6xzYSwv96U9t5Nv516gEyfcOBb4tT2YohP4yQf6fjYDk8 6g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2y8ud10c72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 03:49:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01J3lvE8149521;
        Wed, 19 Feb 2020 03:49:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2y8ud25fr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 03:49:04 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01J3n2cC005269;
        Wed, 19 Feb 2020 03:49:02 GMT
Received: from [192.168.1.206] (/71.63.128.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Feb 2020 19:49:02 -0800
Subject: Re: [PATCH] mm/hugetlb: avoid get wrong ptep caused by race
To:     "Longpeng (Mike)" <longpeng2@huawei.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, arei.gonglei@huawei.com,
        weidong.huang@huawei.com, weifuqiang@huawei.com,
        kvm@vger.kernel.org
References: <1582027825-112728-1-git-send-email-longpeng2@huawei.com>
 <20200218205239.GE24185@bombadil.infradead.org>
 <593d82a3-1d1e-d8f2-6b90-137f10441522@huawei.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <8292299c-4c5a-a8cb-22e2-d5c9051f122a@oracle.com>
Date:   Tue, 18 Feb 2020 19:49:01 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <593d82a3-1d1e-d8f2-6b90-137f10441522@huawei.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002190026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002190026
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/18/20 6:09 PM, Longpeng (Mike) wrote:
> ÔÚ 2020/2/19 4:52, Matthew Wilcox Ð´µÀ:
>> On Tue, Feb 18, 2020 at 08:10:25PM +0800, Longpeng(Mike) wrote:
>>>  {
>>> -	pgd_t *pgd;
>>> -	p4d_t *p4d;
>>> -	pud_t *pud;
>>> -	pmd_t *pmd;
>>> +	pgd_t *pgdp;
>>> +	p4d_t *p4dp;
>>> +	pud_t *pudp, pud;
>>> +	pmd_t *pmdp, pmd;
>>
>> Renaming the variables as part of a fix is a really bad idea.  It obscures
>> the actual fix and makes everybody's life harder.  Plus, it's not even
>> renaming to follow the normal convention -- there are only two places
>> (migrate.c and gup.c) which follow this pattern in mm/ while there are
>> 33 that do not.
>>
> Good suggestion, I've never noticed this, thanks.
> By the way, could you give an example if we use this way to fix the bug?

Matthew and others may have better suggestions for naming.  However, I would
keep the existing names and add:

pud_t pud_entry;
pmd_t pmd_entry;

Then the *_entry variables are the target of the READ_ONCE()

pud_entry = READ_ONCE(*pud);
if (sz != PUD_SIZE && pud_none(pud_entry))
...
...
pmd_entry = READ_ONCE(*pmd);
if (sz != PMD_SIZE && pmd_none(pmd_entry))
...
...

BTW, thank you for finding this issue!
-- 
Mike Kravetz
