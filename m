Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F06493525
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 07:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351202AbiASGnq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 01:43:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10324 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236370AbiASGnq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 01:43:46 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20J3vEOn011739;
        Wed, 19 Jan 2022 06:42:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : references : date : in-reply-to : message-id : mime-version :
 content-type; s=pp1; bh=ixb4I1knaCEMpC8Scm2nge8wNvM+tkC2ipXzX72G1l4=;
 b=LIX0Fcb/UPpGY+ek848KZbR+LCQ6blLh6teGCO2jw9i/9yBA9QQti8s7ZBWnjiWhgwo6
 4pQ3G/uQs3qN+P4K2qEtmx+pP6p3eFjKlRULeHsa2zwUN4qnLpxU55FdPIx3IHZ3XU5e
 kN0likDNljVgCW+F0D69eSwvCHma49VbehnUBU3pLodS/L3+mAgqkzrppR3lIFhdV7zL
 rzYIiA8J1Nc0oxdRdzHcEexJvGZJB+o7nxZYlLCPGp3ejaBUtzRnJGNVTkutONQyQBfT
 OXZI+Jhh+SQagwd7BxDRmb7d8Etk0IPBntogEJBwQcghnT/NyNGObtV26zRBHxMoL5R/ nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dpb6njeux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 06:42:07 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20J6HrQl022445;
        Wed, 19 Jan 2022 06:42:06 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dpb6njeu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 06:42:06 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20J6bfqY018574;
        Wed, 19 Jan 2022 06:42:03 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3dknw9h104-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 06:42:03 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20J6fwSk48497092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 06:41:58 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3AD8D42041;
        Wed, 19 Jan 2022 06:41:58 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2501D4204D;
        Wed, 19 Jan 2022 06:41:57 +0000 (GMT)
Received: from tuxmaker.linux.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 19 Jan 2022 06:41:57 +0000 (GMT)
From:   Sven Schnelle <svens@linux.ibm.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, aleksandar.qemu.devel@gmail.com,
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
Subject: Re: [PATCH 0/5] kvm: fix latent guest entry/exit bugs
References: <YeFqUlhqY+7uzUT1@FVFF77S0Q05N>
        <ae1a42ab-f719-4a4e-8d2a-e2b4fa6e9580@linux.ibm.com>
        <YeF7Wvz05JhyCx0l@FVFF77S0Q05N>
        <b66c4856-7826-9cff-83f3-007d7ed5635c@linux.ibm.com>
        <YeGUnwhbSvwJz5pD@FVFF77S0Q05N>
        <8aa0cada-7f00-47b3-41e4-8a9e7beaae47@redhat.com>
        <20220118120154.GA17938@C02TD0UTHF1T.local>
        <6b6b8a2b-202c-8966-b3f7-5ce35cf40a7e@linux.ibm.com>
        <20220118131223.GC17938@C02TD0UTHF1T.local>
        <yt9dfsplc9fu.fsf@linux.ibm.com>
        <20220118175051.GE17938@C02TD0UTHF1T.local>
Date:   Wed, 19 Jan 2022 07:41:56 +0100
In-Reply-To: <20220118175051.GE17938@C02TD0UTHF1T.local> (Mark Rutland's
        message of "Tue, 18 Jan 2022 17:50:51 +0000")
Message-ID: <yt9dbl08uszv.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eoEuZVGXtQpAvFi0xFDcaZjGnFAjf1FH
X-Proofpoint-ORIG-GUID: 2TEPILiq-QMkd9Fdqdqp7R7yk3Di7xtI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-19_05,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 phishscore=0 mlxlogscore=471 clxscore=1015 suspectscore=0
 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201190034
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mark,

Mark Rutland <mark.rutland@arm.com> writes:

> On Tue, Jan 18, 2022 at 05:09:25PM +0100, Sven Schnelle wrote:
>> Mark Rutland <mark.rutland@arm.com> writes:
>> > On Tue, Jan 18, 2022 at 01:42:26PM +0100, Christian Borntraeger wrote:
>> >> Will you provide an s390 patch in your next iteration or shall we then do
>> >> one as soon as there is a v2? We also need to look into vsie.c where we
>> >> also call sie64a
>> >
>> > I'm having a go at that now; my plan is to try to have an s390 patch as
>> > part of v2 in the next day or so.
>> >
>> > Now that I have a rough idea of how SIE and exception handling works on
>> > s390, I think the structural changes to kvm-s390.c:__vcpu_run() and
>> > vsie.c:do_vsie_run() are fairly simple.
>> >
>> > The only open bit is exactly how/where to identify when the interrupt
>> > entry code needs to wake RCU. I can add a per-cpu variable or thread
>> > flag to indicate that we're inside that EQS, or or I could move the irq
>> > enable/disable into the sie64a asm and identify that as with the OUTSIDE
>> > macro in the entry asm.
>> 
>> I wonder whether the code in irqentry_enter() should call a function
>> is_eqs() instead of is_idle_task(). The default implementation would
>> be just a
>> 
>> #ifndef is_eqs
>> #define is_eqs is_idle_task
>> #endif
>> 
>> and if an architecture has special requirements, it could just define
>> is_eqs() and do the required checks there. This way the architecture
>> could define whether it's a percpu bit, a cpu flag or something else.
>
> I had come to almost the same approach: I've added an arch_in_rcu_eqs()
> which is checked in addition to the existing is_idle_thread() check.
>

Sounds good, thanks!

/Sven
