Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4710A422AB1
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 16:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235897AbhJEORd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 10:17:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27146 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236433AbhJEORU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 10:17:20 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 195D2WpO022810;
        Tue, 5 Oct 2021 10:15:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2WILOUitcrndYCn8gziycm16SrxxQDqEUbiXZpkLSBc=;
 b=KYqiANCZaR2SwkqjfRGwgtTLBU8NVJTg1X5cDvcAn6f0B3ZlbxHu14SwY3zSm3/eFqgt
 AKdieYwKzYzRDi0XNhCvH9q20ffDBe80KUa+06DAKUh5RVg5gp8PqeFRWy5ZA41+dPVx
 JL8wjMa/h/AX6HYEPlmGbvoPXmhJdlowXKBNW7ZDZP6lwv9SF1gjQuq/1QbSxwZ/nf1y
 zzrxWNj9d8HgZ9BcPqfzllXb/U1FtjrB7wHmZjKo440/2My6t5SFpn4fA6tb8WXaFkiL
 9O/ErvnemFBjTymLAGFHtkgxcQaaftDw7USzgjLQQJ/wIxPJsIy4NPp/yqeCuxqVmszk QA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bgq7u28hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 10:15:30 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 195DrY80005687;
        Tue, 5 Oct 2021 10:15:29 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bgq7u28gd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 10:15:29 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 195EDGkM017382;
        Tue, 5 Oct 2021 14:15:27 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3bef29s4cb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 14:15:27 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 195EA4Rh49611256
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Oct 2021 14:10:04 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A2FFA406D;
        Tue,  5 Oct 2021 14:15:21 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91D27A4062;
        Tue,  5 Oct 2021 14:15:20 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.76.223])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Oct 2021 14:15:20 +0000 (GMT)
Subject: Re: [PATCH v5 00/14] KVM: s390: pv: implement lazy destroy for reboot
To:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulrich.Weigand@de.ibm.com
References: <20210920132502.36111-1-imbrenda@linux.ibm.com>
 <fcfd5d04-1a08-f91e-7bc2-8878c6dcd1eb@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <566654e2-92fd-4e91-325e-ced6a89b7a0e@de.ibm.com>
Date:   Tue, 5 Oct 2021 16:15:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <fcfd5d04-1a08-f91e-7bc2-8878c6dcd1eb@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eVrRzcQILvBPOgMZwrE0DEstCjF0LlWz
X-Proofpoint-ORIG-GUID: _7xoNjSY8p5ENEbm2NnULYhM2UUi-ajy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-05_02,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110050084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 05.10.21 um 15:26 schrieb Janosch Frank:
> On 9/20/21 15:24, Claudio Imbrenda wrote:
>> Previously, when a protected VM was rebooted or when it was shut down,
>> its memory was made unprotected, and then the protected VM itself was
>> destroyed. Looping over the whole address space can take some time,
>> considering the overhead of the various Ultravisor Calls (UVCs). This
>> means that a reboot or a shutdown would take a potentially long amount
>> of time, depending on the amount of used memory.
>>
>> This patchseries implements a deferred destroy mechanism for protected
>> guests. When a protected guest is destroyed, its memory is cleared in
>> background, allowing the guest to restart or terminate significantly
>> faster than before.
>>
>> There are 2 possibilities when a protected VM is torn down:
>> * it still has an address space associated (reboot case)
>> * it does not have an address space anymore (shutdown case)
>>
>> For the reboot case, the reference count of the mm is increased, and
>> then a background thread is started to clean up. Once the thread went
>> through the whole address space, the protected VM is actually
>> destroyed.
>>
>> This means that the same address space can have memory belonging to
>> more than one protected guest, although only one will be running, the
>> others will in fact not even have any CPUs.
>>
>> The shutdown case is more controversial, and it will be dealt with in a
>> future patchseries.
>>
>> When a guest is destroyed, its memory still counts towards its memory
>> control group until it's actually freed (I tested this experimentally)
> 
> 
> @Christian: I'd like to have #1-3 in early so we can focus on the more complicated stuff.

Yes, makes perfect sense.
