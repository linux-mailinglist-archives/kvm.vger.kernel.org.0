Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40ED1667F7
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 09:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfGLHvL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 03:51:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42960 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfGLHvL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 03:51:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6C7nQXn084246;
        Fri, 12 Jul 2019 07:50:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=KWdd569p7H98s99VGkNt8W1kteSRKpwe7r4VXaES3dU=;
 b=pbWIwWl1aHu4f+DB6qI+IjeZS3EVzt/ZaLXRb3VkoTvcnyJiSPBjy53GBCqbYAQFWPrE
 ZFldPCuG6PvGbLCXMa7oii7YLCkchEd7W/WtM4uCDu/LDnBGo8SbyWaCaEv4bd+ixN28
 NoLoni2nztIJoXRUZjJlxHi9A3PE+t/uYnhj58XGG/pCqULq9IvI5fYO5axaS1TUaK3t
 /t7VN0yb/w54ud5iNtAVIxAct9/mQj9n3ls6BHu4ywz5o1PeXXtnT23PURm/RzK0pcRD
 yVU4QvmJFLW18ULNLf85ObPX8TtKJypDiK5sDVfaiQisxxxhvtz4uP1JZY/Fb1by7STf EQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2tjkkq424s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 07:50:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6C7lu8S028521;
        Fri, 12 Jul 2019 07:50:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2tmwgyms2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 07:50:08 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6C7o5XQ002589;
        Fri, 12 Jul 2019 07:50:05 GMT
Received: from [10.166.106.34] (/10.166.106.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Jul 2019 00:50:04 -0700
Subject: Re: [RFC v2 02/26] mm/asi: Abort isolation on interrupt, exception
 and context switch
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        jan.setjeeilers@oracle.com, liran.alon@oracle.com,
        jwadams@google.com, graf@amazon.de, rppt@linux.vnet.ibm.com
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
 <1562855138-19507-3-git-send-email-alexandre.chartre@oracle.com>
 <B8AF6DF6-8D39-40F6-8624-6F67EDA4E390@amacapital.net>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Organization: Oracle Corporation
Message-ID: <42a38126-8ae9-2f9e-6c9e-19998eedb85d@oracle.com>
Date:   Fri, 12 Jul 2019 09:50:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <B8AF6DF6-8D39-40F6-8624-6F67EDA4E390@amacapital.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9315 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907120081
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9315 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907120081
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/12/19 2:05 AM, Andy Lutomirski wrote:
> 
>> On Jul 11, 2019, at 8:25 AM, Alexandre Chartre <alexandre.chartre@oracle.com> wrote:
>>
>> Address space isolation should be aborted if there is an interrupt,
>> an exception or a context switch. Interrupt/exception handlers and
>> context switch code need to run with the full kernel address space.
>> Address space isolation is aborted by restoring the original CR3
>> value used before entering address space isolation.
>>
> 
> NAK to the entry changes. That code you’re changing is already known
> to be a bit buggy, and it’s spaghetti. PeterZ and I are gradually
> working on fixing some bugs and C-ifying it. ASI can go on top.
> 

Agree this is spaghetti and I will be happy to move ASI on top. I will keep
an eye for your changes, and I will change the ASI code accordingly.

Thanks,

alex.
