Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCFC2D468D
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 17:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731702AbgLIQQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 11:16:13 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:47040 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728404AbgLIQQF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Dec 2020 11:16:05 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9G9MnR083781;
        Wed, 9 Dec 2020 16:15:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=86yS5ZSEM4uLoGDP4K4dfalOsPgydZF3kRohkHa788k=;
 b=OEWxn/8v3C0lRN470tEn+9GKAsOfbGeBngvE0EwG4JpCfeyL+cqztxrxumCrtv2F51zs
 j6sC19bk2GQns84sKXvvRw0YuyR9a4sqDpndz2EZj/jDM6WdbRaT1vcfFLeMhgxn+L/E
 pL1NjR61rmKp2TRc+b5A80VNzYMoqb6F6vhot65LI+jRsRN1P7he1heQ/0l7kgZUMw2k
 PrYGuhboP9FkE4K3nlV9I1WtziuzjbrTSzgYyPD7214iHw8zQeWtdbBMfiN6HrLQIntx
 f0OBKIUALFsoSsGvl+wtFesu/WjUbMbYUtq3GmwE0B8rDFzcDZgGD4iyu1NA1aN4K16/ oQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 357yqc13jt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 16:15:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9GAil4111778;
        Wed, 9 Dec 2020 16:13:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 358kyuwg06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 16:13:07 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B9GD3f3012679;
        Wed, 9 Dec 2020 16:13:03 GMT
Received: from [10.175.160.66] (/10.175.160.66)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Dec 2020 08:13:02 -0800
Subject: Re: [PATCH RFC 10/39] KVM: x86/xen: support upcall vector
To:     David Woodhouse <dwmw2@infradead.org>,
        Ankur Arora <ankur.a.arora@oracle.com>, karahmed@amazon.de
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190220201609.28290-1-joao.m.martins@oracle.com>
 <20190220201609.28290-11-joao.m.martins@oracle.com>
 <71753a370cd6f9dd147427634284073b78679fa6.camel@infradead.org>
 <53baeaa7-0fed-d22c-7767-09ae885d13a0@oracle.com>
 <4ad0d157c5c7317a660cd8d65b535d3232f9249d.camel@infradead.org>
 <c43024b3-6508-3b77-870c-da81e74284a4@oracle.com>
 <052867ae1c997487d85c21e995feb5647ac6c458.camel@infradead.org>
 <6a6b5806be1fe4c0fe96c0b664710d1ce614f29d.camel@infradead.org>
 <1af00fa4-03b8-a059-d859-5cfd71ef10f4@oracle.com>
 <0eb8c2ef01b77af0d288888f200e812d374beada.camel@infradead.org>
 <f7dec3f1-aadc-bda5-f4dc-7185ffd9c1a6@oracle.com>
 <db4ea3bd6ebec53c40526d67273ccfba38982811.camel@infradead.org>
 <35165dbc-73d0-21cd-0baf-db4ffb55fc47@oracle.com>
 <2E57982D-6508-4850-ABA5-67592381379D@infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <f92d0cfa-f1fe-9339-e319-946f6475131d@oracle.com>
Date:   Wed, 9 Dec 2020 16:12:58 +0000
MIME-Version: 1.0
In-Reply-To: <2E57982D-6508-4850-ABA5-67592381379D@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=1 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090113
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/20 3:41 PM, David Woodhouse wrote:
> On 9 December 2020 13:26:55 GMT, Joao Martins <joao.m.martins@oracle.com> wrote:
>> On 12/9/20 11:39 AM, David Woodhouse wrote:
>>> As far as I can tell, Xen's hvm_vcpu_has_pending_irq() will still
>>> return the domain-wide vector in preference to the one in the LAPIC,
>> if
>>> it actually gets invoked. 
>>
>> Only if the callback installed is HVMIRQ_callback_vector IIUC.
>>
>> Otherwise the vector would be pending like any other LAPIC vector.
> 
> Ah, right.
> 
> For some reason I had it in my head that you could only set the per-vCPU lapic vector if the domain was set to HVMIRQ_callback_vector. If the domain is set to HVMIRQ_callback_none, that clearly makes more sense.
> 
> Still, my patch should do the same as Xen does in the case where a guest does set both, I think.
> 
> Faithful compatibility with odd Xen behaviour FTW :)
> 
Ah, yes. In that case, HVMIRQ_callback_vector does take precedence.

But it would be very weird for a guest to setup two callback vectors :)
