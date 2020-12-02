Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6932CBB79
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 12:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbgLBLUx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 06:20:53 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59674 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725918AbgLBLUw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 06:20:52 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2BFxTk185672;
        Wed, 2 Dec 2020 11:20:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=CtW4DT/Jt2AI/ejN0dO+qJAtFhgduCuaF1CNDqI5k5k=;
 b=tIN8NZrx0TWrOTINmk0ba/LZJ+dXam/PBGzZHOgcRWikaECpSOLRtNrO/KdGSDmJGlYh
 va4YUM84kRLP5xnZkk41mPqGJTozKgRtObH66CvR3FQp3K2WKibd2nbbKXWWGr23EvMt
 crWrX5zIxXT01ODyTNLtdyfZuc84RY86fxrQy38ULJpYecfiQzp6ehWA/CqaVASJxr9c
 CGxLM6nuyTmi67owUMfdkfcIUBcFSzNjKLqthvVfGkqCcmtY8HYYFfBzn1gall0eb/QI
 iKG7ysJaCPHPsLcSk6pk3uWqVAj9zLkr3P/9e1dmhF5HfZQRHIf+xPmCigQHIHXJ+ENU Gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 353dyqqpc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Dec 2020 11:20:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2BGKuq059235;
        Wed, 2 Dec 2020 11:18:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3540au36x4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Dec 2020 11:18:01 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B2BI0HG019988;
        Wed, 2 Dec 2020 11:18:00 GMT
Received: from [10.175.181.158] (/10.175.181.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Dec 2020 03:17:59 -0800
Subject: Re: [PATCH RFC 02/39] KVM: x86/xen: intercept xen hypercalls if
 enabled
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Ankur Arora <ankur.a.arora@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190220201609.28290-1-joao.m.martins@oracle.com>
 <20190220201609.28290-3-joao.m.martins@oracle.com>
 <b56f763e6bf29a65a11b7a36c4d7bfa79b2ec1b2.camel@infradead.org>
 <85c49b9c31f6b74f23ad58f93ec73786b7d48391.camel@infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <f30f1f50-9533-1416-e0ef-79f9fbd8d0e5@oracle.com>
Date:   Wed, 2 Dec 2020 11:17:54 +0000
MIME-Version: 1.0
In-Reply-To: <85c49b9c31f6b74f23ad58f93ec73786b7d48391.camel@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=888 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=1
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020067
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=907
 suspectscore=1 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/1/20 11:19 AM, David Woodhouse wrote:
> On Tue, 2020-12-01 at 09:48 +0000, David Woodhouse wrote:
>> So I switched it to generate the hypercall page directly from the
>> kernel, just like we do for the Hyper-V hypercall page.
> 
> Speaking of Hyper-V... I'll post this one now so you can start heckling
> it.
> 
Xen viridian mode is indeed one thing that needed fixing. And definitely a
separate patch as you do here. Both this one and the previous is looking good.

I suppose that because you switch to kvm_vcpu_write_guest() you no longer need
to validate that the hypercall page is correct neither marking as dirty. Probably
worth making that explicit in the commit message.

> I won't post the rest as I go; not much of the rest of the series when
> I eventually post it will be very new and exciting. It'll just be
> rebasing and tweaking your originals and perhaps adding some tests.
> 

Awesome!!
