Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B903E492AC4
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 17:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346751AbiARQNB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 11:13:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9040 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241957AbiARQLV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 11:11:21 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IF5oFj023401;
        Tue, 18 Jan 2022 16:09:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : references : date : in-reply-to : message-id : mime-version :
 content-type; s=pp1; bh=1o6hTST4A3SUGBmaAxu8ieEaB6ozOWFLtPDxrNatUGA=;
 b=DzNMcImxANxYolnLHBlr+vFqZ5fZdEnH7yQ6rvoPXMq93VzwSqY1EkNyQorEeRwT8COw
 Q5cppXkRob5+ZZkxuWmPST9YU0fKy0cZXQU1DxLFo+bnD4Dxk6wjlVmO87ERi5CZEO/H
 lIHQSDeTSNJtTFrNqGKDUESRYDFb13yPYqp8k98o94PywPKZvj9uiaT1uQL5iCQRrANy
 pJX/9wTh1OvfGFgXkozN+7RQvrEkViRxlcU5AOws18ZyAo6X9mDr+BBSX4vfJcJP5Idp
 o0iAkwIcOTMTOiy5zZV/Nkgp8gcv/FqBOha6f+bjWIr64qDG+f6p86oRh8lMIwVqzbjI IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dnyvv1emg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 16:09:33 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20IFbLSU024274;
        Tue, 18 Jan 2022 16:09:32 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dnyvv1ekt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 16:09:32 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20IG88Ip027792;
        Tue, 18 Jan 2022 16:09:30 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3dknw9cuua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 16:09:30 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20IG9Qu737945614
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 16:09:26 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B41F54C046;
        Tue, 18 Jan 2022 16:09:26 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1A714C044;
        Tue, 18 Jan 2022 16:09:25 +0000 (GMT)
Received: from tuxmaker.linux.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 18 Jan 2022 16:09:25 +0000 (GMT)
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
References: <20220111153539.2532246-1-mark.rutland@arm.com>
        <127a6117-85fb-7477-983c-daf09e91349d@linux.ibm.com>
        <YeFqUlhqY+7uzUT1@FVFF77S0Q05N>
        <ae1a42ab-f719-4a4e-8d2a-e2b4fa6e9580@linux.ibm.com>
        <YeF7Wvz05JhyCx0l@FVFF77S0Q05N>
        <b66c4856-7826-9cff-83f3-007d7ed5635c@linux.ibm.com>
        <YeGUnwhbSvwJz5pD@FVFF77S0Q05N>
        <8aa0cada-7f00-47b3-41e4-8a9e7beaae47@redhat.com>
        <20220118120154.GA17938@C02TD0UTHF1T.local>
        <6b6b8a2b-202c-8966-b3f7-5ce35cf40a7e@linux.ibm.com>
        <20220118131223.GC17938@C02TD0UTHF1T.local>
Date:   Tue, 18 Jan 2022 17:09:25 +0100
In-Reply-To: <20220118131223.GC17938@C02TD0UTHF1T.local> (Mark Rutland's
        message of "Tue, 18 Jan 2022 13:12:23 +0000")
Message-ID: <yt9dfsplc9fu.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hidflXyfSxGUg2IONdWdehVdnkIymNiH
X-Proofpoint-ORIG-GUID: dZDmymDNcmhBaN1x10GnjBJvOBJgLfZK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_04,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 phishscore=0 impostorscore=0 spamscore=0 mlxscore=0
 malwarescore=0 lowpriorityscore=0 clxscore=1011 adultscore=0
 suspectscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201180099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mark,

Mark Rutland <mark.rutland@arm.com> writes:

> On Tue, Jan 18, 2022 at 01:42:26PM +0100, Christian Borntraeger wrote:
>> 
>> 
>> Am 18.01.22 um 13:02 schrieb Mark Rutland:
>> > On Mon, Jan 17, 2022 at 06:45:36PM +0100, Paolo Bonzini wrote:
>> > > On 1/14/22 16:19, Mark Rutland wrote:
>> > > > I also think there is another issue here. When an IRQ is taken from SIE, will
>> > > > user_mode(regs) always be false, or could it be true if the guest userspace is
>> > > > running? If it can be true I think tha context tracking checks can complain,
>> > > > and it*might*  be possible to trigger a panic().
>> > > 
>> > > I think that it would be false, because the guest PSW is in the SIE block
>> > > and switched on SIE entry and exit, but I might be incorrect.
>> > 
>> > Ah; that's the crux of my confusion: I had thought the guest PSW would
>> > be placed in the regular lowcore *_old_psw slots. From looking at the
>> > entry asm it looks like the host PSW (around the invocation of SIE) is
>> > stored there, since that's what the OUTSIDE + SIEEXIT handling is
>> > checking for.
>> > 
>> > Assuming that's correct, I agree this problem doesn't exist, and there's
>> > only the common RCU/tracing/lockdep management to fix.
>> 
>> Will you provide an s390 patch in your next iteration or shall we then do
>> one as soon as there is a v2? We also need to look into vsie.c where we
>> also call sie64a
>
> I'm having a go at that now; my plan is to try to have an s390 patch as
> part of v2 in the next day or so.
>
> Now that I have a rough idea of how SIE and exception handling works on
> s390, I think the structural changes to kvm-s390.c:__vcpu_run() and
> vsie.c:do_vsie_run() are fairly simple.
>
> The only open bit is exactly how/where to identify when the interrupt
> entry code needs to wake RCU. I can add a per-cpu variable or thread
> flag to indicate that we're inside that EQS, or or I could move the irq
> enable/disable into the sie64a asm and identify that as with the OUTSIDE
> macro in the entry asm.

I wonder whether the code in irqentry_enter() should call a function
is_eqs() instead of is_idle_task(). The default implementation would
be just a

#ifndef is_eqs
#define is_eqs is_idle_task
#endif

and if an architecture has special requirements, it could just define
is_eqs() and do the required checks there. This way the architecture
could define whether it's a percpu bit, a cpu flag or something else.

/Sven
