Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43A591BA9B
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 18:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731221AbfEMQGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 12:06:45 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60992 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730669AbfEMQGp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 12:06:45 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DFs3dw072771;
        Mon, 13 May 2019 16:04:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=iQOB5KRWAw5aCrq5NScPGP6m3rv8ZkXQhJVOUTIv/ts=;
 b=WTdZ/AERAY8uumxJJXYsPTnreT70nlTdVm2Uk+gpoBLOvefKgPXnZt9lMTEMJFC7AElo
 brnBgKufzGI6G7SdHRYtY9DNe1fPL/lr6yYBtqTq1NwJweBx96/lEPw0gXQDChYYuGac
 U23W2zUNgmJsl+a+kAph+SzIcbarXxPaSKnGTuApMEm9SALHEWk4vYdLv6/q4htUkhgF
 WE7JQ9OasaE8W8U4eHRDazsIYBZLsFHVvieWyLy4O0VCbRsaFoOYmSRDO8ige/yanJ96
 5o2bnR09qlNx9ZES5yobQvJ9oT4iiJzAV2mUdyrP8YoQNhZQX7fc7kZ/sA0B/Dpf0nCT +g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2sdkwdg9ek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 16:04:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DG4975087318;
        Mon, 13 May 2019 16:04:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2sf3cmrhbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 16:04:51 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4DG4mrx011596;
        Mon, 13 May 2019 16:04:48 GMT
Received: from [10.166.106.34] (/10.166.106.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 May 2019 09:04:48 -0700
Subject: Re: [RFC KVM 03/27] KVM: x86: Introduce KVM separate virtual address
 space
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, Liran Alon <liran.alon@oracle.com>,
        Jonathan Adams <jwadams@google.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <1557758315-12667-4-git-send-email-alexandre.chartre@oracle.com>
 <CALCETrV9-VAMS2K3pmkqM--pr0AYcb38ASETvwsZ5YhLtLq-9w@mail.gmail.com>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Organization: Oracle Corporation
Message-ID: <8dba7da4-8087-1d80-5b60-fe651a930bb8@oracle.com>
Date:   Mon, 13 May 2019 18:04:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <CALCETrV9-VAMS2K3pmkqM--pr0AYcb38ASETvwsZ5YhLtLq-9w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905130109
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130109
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/13/19 5:45 PM, Andy Lutomirski wrote:
> On Mon, May 13, 2019 at 7:39 AM Alexandre Chartre
> <alexandre.chartre@oracle.com> wrote:
>>
>> From: Liran Alon <liran.alon@oracle.com>
>>
>> Create a separate mm for KVM that will be active when KVM #VMExit
>> handlers run. Up until the point which we architectully need to
>> access host (or other VM) sensitive data.
>>
>> This patch just create kvm_mm but never makes it active yet.
>> This will be done by next commits.
> 
> NAK to this whole pile of code.  KVM is not so special that it can
> duplicate core infrastructure like this.  Use copy_init_mm() or
> improve it as needed.
> 
> --Andy
> 

This was originally inspired from how efi_mm is built. If I remember
correctly copy_init_mm() or other mm init functions do initialization
we don't need in this case; we basically want a blank mm. I will have
another look at copy_init_mm().

In any case, if we really need a mm create/init function I agree it
doesn't below to kvm. For now, this part of shortcuts used for the POC.

alex.
