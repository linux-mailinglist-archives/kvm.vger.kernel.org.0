Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5B98151E16
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 17:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbgBDQSk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 11:18:40 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59154 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727290AbgBDQSk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 11:18:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014GFpm9099115;
        Tue, 4 Feb 2020 16:18:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=rKE6BXas3LZe481kZHsQO9RrFsrswJ8xXmcNA5ia/sc=;
 b=B83REeVYK/qA/uk+oNSDRp+5EZio8ECEraJSWV7MzTlwxzLxjK0dCBX7/3cBu4IuEntU
 Q1Y8pi4wWrh1em0ZC4e7lGaKm6i/0RRM/QnIwHH1gDJLvate0O6i76HWnDscTBFE03jp
 m0vYMX+CR8CzHfsUkd0oSvHE3E4LMihs90G5z8RF7RlKSMXGVYHAiLAbIu9zS8fO5cqp
 BmX2YTRDlSo03ouhjqzQh0eaz+YLA705/vTz5f67vJro2hoMppguLlZtpfjRoh/Ajtlw
 q5v78rojwBeLB9TacrjrNMjrioqHLiAuhvXudutZGto/SNje390kzS8o5T8HTQ+QrK+h FQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xw0ru7rry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Feb 2020 16:18:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014GGNC4155573;
        Tue, 4 Feb 2020 16:18:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xxw0xb6a8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Feb 2020 16:18:08 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 014GI6qi018533;
        Tue, 4 Feb 2020 16:18:06 GMT
Received: from [10.175.207.61] (/10.175.207.61)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 08:18:05 -0800
Subject: Re: [PATCH RFC 02/10] mm: Handle pmd entries in follow_pfn()
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Barret Rhoden <brho@google.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
References: <20200110190313.17144-1-joao.m.martins@oracle.com>
 <20200110190313.17144-3-joao.m.martins@oracle.com>
 <20200203213718.GL8731@bombadil.infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <94c35449-16ac-235b-fa2e-a5aea85dc568@oracle.com>
Date:   Tue, 4 Feb 2020 16:17:59 +0000
MIME-Version: 1.0
In-Reply-To: <20200203213718.GL8731@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=767
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002040108
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=830 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002040108
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/3/20 9:37 PM, Matthew Wilcox wrote:
> On Fri, Jan 10, 2020 at 07:03:05PM +0000, Joao Martins wrote:
>> @@ -4366,6 +4366,7 @@ EXPORT_SYMBOL(follow_pte_pmd);
>>  int follow_pfn(struct vm_area_struct *vma, unsigned long address,
>>  	unsigned long *pfn)
>>  {
>> +	pmd_t *pmdpp = NULL;
> 
> Please rename to 'pmdp'.
> 
Will do.

Alongside patch 4 usage of pmdpp and renaming 'pudpp' to 'pudp'.
