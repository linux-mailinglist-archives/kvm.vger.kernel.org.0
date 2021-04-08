Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C421357ADA
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 05:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhDHDoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 23:44:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9444 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229469AbhDHDoT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 23:44:19 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1383hNgj189190;
        Wed, 7 Apr 2021 23:43:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=M5YyGyvWrfpM6mouCFBNWvwNAPp/hMMkIWHkaOPIBZM=;
 b=OHGOMvidOBD78rppWGzRX61MvNg2/bKJFjp6p/Usav5hpF2YrdlguHzk9J5l/5WQ4eLT
 hHugqSEAe9O/F1T2vEjLrNgMxx3i/IIfDVo9+W6OGPHlNlmB5ZEgEzkZcdhSDMHIFaaz
 WlXBH0mqZ7LQ/jY74oKBRfpUy1cUdsQgjyNH0gGADJJCDueRqSEhgz0xthi2LdE50qpz
 Mhlf3WbhLYiOgFxSJsiGVIHCHwYjFUtowbL58JeY2iSzc0xR/Mfk0I322v5VuqgvOYfX
 h6fMwK09i0XQTINDbYl/OhY9I3MpvKk6El1fhQO5CdzOIqYUdgb79NB7kfz7Q4SZ336t fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37rw6kw116-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 23:43:47 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1383hlpA189687;
        Wed, 7 Apr 2021 23:43:47 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37rw6kw10r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 23:43:47 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1383RcG4020886;
        Thu, 8 Apr 2021 03:43:44 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 37rvbu97aw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Apr 2021 03:43:44 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1383hg791245746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Apr 2021 03:43:42 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F75AA405C;
        Thu,  8 Apr 2021 03:43:42 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56F14A405B;
        Thu,  8 Apr 2021 03:43:39 +0000 (GMT)
Received: from [9.199.37.175] (unknown [9.199.37.175])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  8 Apr 2021 03:43:39 +0000 (GMT)
Subject: Re: [PATCH v4 3/3] ppc: Enable 2nd DAWR support on p10
To:     David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>
Cc:     paulus@samba.org, mpe@ellerman.id.au, mikey@neuling.org,
        pbonzini@redhat.com, mst@redhat.com, clg@kaod.org,
        qemu-ppc@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        cohuck@redhat.com, Ravi Bangoria <ravi.bangoria@linux.ibm.com>
References: <20210406053833.282907-1-ravi.bangoria@linux.ibm.com>
 <20210406053833.282907-4-ravi.bangoria@linux.ibm.com>
 <20210407101041.1a884af7@bahia.lan> <YG5tg2aHNR1/5A6H@yekko.fritz.box>
From:   Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Message-ID: <298d37fc-49b9-5297-b196-14b35b1ec4de@linux.ibm.com>
Date:   Thu, 8 Apr 2021 09:13:38 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <YG5tg2aHNR1/5A6H@yekko.fritz.box>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: S57IxgAYrtKqsXWg_grbhiPy5PCZ7aYp
X-Proofpoint-ORIG-GUID: _7YxHdCh5qPIfVKoLFWzbULqTV8eAZN_
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-08_01:2021-04-07,2021-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 mlxlogscore=966
 clxscore=1015 phishscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104080021
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


>>> +static void cap_dawr1_apply(SpaprMachineState *spapr, uint8_t val,
>>> +                               Error **errp)
>>> +{
>>> +    ERRP_GUARD();
>>> +    if (!val) {
>>> +        return; /* Disable by default */
>>> +    }
>>> +
>>> +    if (tcg_enabled()) {
>>> +        error_setg(errp, "DAWR1 not supported in TCG.");
>>> +        error_append_hint(errp, "Try appending -machine cap-dawr1=off\n");
>>> +    } else if (kvm_enabled()) {
>>> +        if (!kvmppc_has_cap_dawr1()) {
>>> +            error_setg(errp, "DAWR1 not supported by KVM.");
>>> +            error_append_hint(errp, "Try appending -machine cap-dawr1=off\n");
>>> +        } else if (kvmppc_set_cap_dawr1(val) < 0) {
>>> +            error_setg(errp, "DAWR1 not supported by KVM.");
>>
>> Well... technically KVM does support DAWR1 but something went wrong when
>> trying to enable it. In case you need to repost, maybe change the error
>> message in this path, e.g. like in cap_nested_kvm_hv_apply().
> 
> This won't be going in until 6.1 anyway, so please to update the
> message.

Sure. Will post v5 with updated message.

> 
> I'd probably prefer to actually wait until the 6.1 tree opens to apply
> this, rather than pre-queueing it in ppc-for-6.1, because there's a
> fairly good chance the header update patch will conflict with someone
> else's during the 6.1 merge flurry.

No worries.

Thanks Greg, David for the review.
Ravi
