Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5814492577
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 13:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241390AbiARMKT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 07:10:19 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38720 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231645AbiARMKP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 07:10:15 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IARS21014091;
        Tue, 18 Jan 2022 12:08:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=oumTtlxfq16bMp5kvjq8AIKc/uxiC8YtpOq7Zm+f1U4=;
 b=jyXPuHRQVrn6Stow3Tsp/Oi4fsRkywBvqDiSHthQ6hOX2RdqaEAi+Lnhp/ToMcWcaHiq
 ty1vT5d92LDYH9ZDzbqpAjiGrh9xYwyaMRxG6504gYtbp3pCDmMRI13flQ63MMSzs7EI
 gQIcl/2mUhS4uHHq/h4tgcGtsyIz9IBRRGslww/uYedx9vefuWg/z7LKlVVHWGO4FoLK
 QLRW7AyQdvs5uHDENDb1myVo9ZAekpwURyaecVaXoBs5E/it20yBOFuwm1mhlCqI25iL
 ewD1hi5MoGAlR37peOG+gP+0LFEkAQW7E1qEGHkceIxtKVItSpWOIqyFvFkJUwkhgxle cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnutjt8mm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 12:08:46 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20IBubvL011004;
        Tue, 18 Jan 2022 12:08:45 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnutjt8k5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 12:08:45 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20IC3eev021718;
        Tue, 18 Jan 2022 12:08:42 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3dknhjbtsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 12:08:42 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20IC8d5W31326612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 12:08:39 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE87EAE04D;
        Tue, 18 Jan 2022 12:08:38 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89378AE045;
        Tue, 18 Jan 2022 12:08:33 +0000 (GMT)
Received: from [9.171.19.84] (unknown [9.171.19.84])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 12:08:33 +0000 (GMT)
Message-ID: <345ed0e0-d33a-3969-3f07-6e4fd3c20775@linux.ibm.com>
Date:   Tue, 18 Jan 2022 13:08:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 0/5] kvm: fix latent guest entry/exit bugs
Content-Language: en-US
To:     Mark Rutland <mark.rutland@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, aleksandar.qemu.devel@gmail.com,
        alexandru.elisei@arm.com, anup.patel@wdc.com,
        aou@eecs.berkeley.edu, atish.patra@wdc.com,
        benh@kernel.crashing.org, bp@alien8.de, catalin.marinas@arm.com,
        chenhuacai@kernel.org, dave.hansen@linux.intel.com,
        david@redhat.com, frankja@linux.ibm.com, frederic@kernel.org,
        gor@linux.ibm.com, hca@linux.ibm.com, imbrenda@linux.ibm.com,
        james.morse@arm.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, maz@kernel.org, mingo@redhat.com,
        mpe@ellerman.id.au, nsaenzju@redhat.com, palmer@dabbelt.com,
        paulmck@kernel.org, paulus@samba.org, paul.walmsley@sifive.com,
        seanjc@google.com, suzuki.poulose@arm.com, tglx@linutronix.de,
        tsbogend@alpha.franken.de, vkuznets@redhat.com,
        wanpengli@tencent.com, will@kernel.org
References: <20220111153539.2532246-1-mark.rutland@arm.com>
 <127a6117-85fb-7477-983c-daf09e91349d@linux.ibm.com>
 <YeFqUlhqY+7uzUT1@FVFF77S0Q05N>
 <ae1a42ab-f719-4a4e-8d2a-e2b4fa6e9580@linux.ibm.com>
 <YeF7Wvz05JhyCx0l@FVFF77S0Q05N>
 <b66c4856-7826-9cff-83f3-007d7ed5635c@linux.ibm.com>
 <YeGUnwhbSvwJz5pD@FVFF77S0Q05N>
 <8aa0cada-7f00-47b3-41e4-8a9e7beaae47@redhat.com>
 <20220118120154.GA17938@C02TD0UTHF1T.local>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220118120154.GA17938@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rIjzolKUCnjTFSyInxWYQVlFrYiJcev_
X-Proofpoint-ORIG-GUID: 9YTZW9Rrm2_i8H2h1CuE4iOxW_hFopZW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_03,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 phishscore=0 adultscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180074
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 18.01.22 um 13:02 schrieb Mark Rutland:
> On Mon, Jan 17, 2022 at 06:45:36PM +0100, Paolo Bonzini wrote:
>> On 1/14/22 16:19, Mark Rutland wrote:
>>> I also think there is another issue here. When an IRQ is taken from SIE, will
>>> user_mode(regs) always be false, or could it be true if the guest userspace is
>>> running? If it can be true I think tha context tracking checks can complain,
>>> and it*might*  be possible to trigger a panic().
>>
>> I think that it would be false, because the guest PSW is in the SIE block
>> and switched on SIE entry and exit, but I might be incorrect.
> 
> Ah; that's the crux of my confusion: I had thought the guest PSW would
> be placed in the regular lowcore *_old_psw slots. From looking at the
> entry asm it looks like the host PSW (around the invocation of SIE) is
> stored there, since that's what the OUTSIDE + SIEEXIT handling is
> checking for.

Yes, Paolos observation is correct.
> 
> Assuming that's correct, I agree this problem doesn't exist, and there's
> only the common RCU/tracing/lockdep management to fix.
> 
> Sorry for the noise, and thanks for the pointer!
> 
> Thanks,
> Mark.
