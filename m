Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4792734D134
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 15:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbhC2NfX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 09:35:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49810 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231185AbhC2NfF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 09:35:05 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12TDWkEo026024;
        Mon, 29 Mar 2021 09:34:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : subject : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SEPyldpy16GplLMLA0GEH2oUhFtKE05FUdp7w85/PvQ=;
 b=gvFuy1n1MRQRDsluP5QUDASUdDYbV7Gm0+m4FaWCUpRJv4mxTvCYqjEoaWPr0NZcWsVH
 0+qFm97MlMM2MtMTH8o+NfTXEqt2VgKaM2Mugw3TfmisZBrCZkacWJa7KMw4LTNvk14g
 /HrRhNmec9ebCFO3Vlsw9/0Mn6UqVmMWaKbzkjdtM2wI5GsdLJWEaOEvQ2zbHZqrYL8h
 YSnolCKQqRpp1/ZE9+iQxc1PA5ng1DrnPzzs85H2x6A9WOfyeARBHNje4y9FLQ1QOVxB
 I2u9XEc9p2Wg8tmnWVUeddp7+sBQD4Lb/QmpyzJOobbDakgQtPO4D+/43x4c1x9US3G4 pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jhru86k9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 09:34:33 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12TDWlrL026193;
        Mon, 29 Mar 2021 09:34:33 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jhru86j6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 09:34:33 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12TDWJ6M004528;
        Mon, 29 Mar 2021 13:34:30 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 37hvb8htxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 13:34:30 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12TDYSVh21299502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Mar 2021 13:34:28 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B6FB4C040;
        Mon, 29 Mar 2021 13:34:28 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9818C4C046;
        Mon, 29 Mar 2021 13:34:25 +0000 (GMT)
Received: from [9.199.34.103] (unknown [9.199.34.103])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 29 Mar 2021 13:34:25 +0000 (GMT)
From:   Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Subject: Re: [PATCH v2 3/3] ppc: Enable 2nd DAWR support on p10
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     paulus@samba.org, mpe@ellerman.id.au, mikey@neuling.org,
        pbonzini@redhat.com, mst@redhat.com, clg@kaod.org,
        qemu-ppc@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        cohuck@redhat.com, Ravi Bangoria <ravi.bangoria@linux.ibm.com>
References: <20210329041906.213991-1-ravi.bangoria@linux.ibm.com>
 <20210329041906.213991-4-ravi.bangoria@linux.ibm.com>
 <YGFf0WxO+LRU1ysI@yekko.fritz.box>
Message-ID: <9abc9f1a-f855-e7bd-4b83-2884f6595172@linux.ibm.com>
Date:   Mon, 29 Mar 2021 19:04:24 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <YGFf0WxO+LRU1ysI@yekko.fritz.box>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: t-Ib75zXb4jT1xXkPD-nxPczoUEFHf1q
X-Proofpoint-ORIG-GUID: s-7GpMknevRtYPP9hVtAZwOTk5eOK7dc
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_09:2021-03-26,2021-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 adultscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0 spamscore=0
 suspectscore=0 malwarescore=0 clxscore=1015 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103290103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

>> @@ -241,6 +241,31 @@ static void spapr_dt_pa_features(SpaprMachineState *spapr,
>>           /* 60: NM atomic, 62: RNG */
>>           0x80, 0x00, 0x80, 0x00, 0x00, 0x00, /* 60 - 65 */
>>       };
>> +    uint8_t pa_features_310[] = { 66, 0,
>> +        /* 0: MMU|FPU|SLB|RUN|DABR|NX, 1: fri[nzpm]|DABRX|SPRG3|SLB0|PP110 */
>> +        /* 2: VPM|DS205|PPR|DS202|DS206, 3: LSD|URG, SSO, 5: LE|CFAR|EB|LSQ */
>> +        0xf6, 0x1f, 0xc7, 0xc0, 0x80, 0xf0, /* 0 - 5 */
>> +        /* 6: DS207 */
>> +        0x80, 0x00, 0x00, 0x00, 0x00, 0x00, /* 6 - 11 */
>> +        /* 16: Vector */
>> +        0x00, 0x00, 0x00, 0x00, 0x80, 0x00, /* 12 - 17 */
>> +        /* 18: Vec. Scalar, 20: Vec. XOR, 22: HTM */
>> +        0x80, 0x00, 0x80, 0x00, 0x00, 0x00, /* 18 - 23 */
>> +        /* 24: Ext. Dec, 26: 64 bit ftrs, 28: PM ftrs */
>> +        0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 24 - 29 */
>> +        /* 30: MMR, 32: LE atomic, 34: EBB + ext EBB */
>> +        0x80, 0x00, 0x80, 0x00, 0xC0, 0x00, /* 30 - 35 */
>> +        /* 36: SPR SO, 38: Copy/Paste, 40: Radix MMU */
>> +        0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 36 - 41 */
>> +        /* 42: PM, 44: PC RA, 46: SC vec'd */
>> +        0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 42 - 47 */
>> +        /* 48: SIMD, 50: QP BFP, 52: String */
>> +        0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 48 - 53 */
>> +        /* 54: DecFP, 56: DecI, 58: SHA */
>> +        0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 54 - 59 */
>> +        /* 60: NM atomic, 62: RNG, 64: DAWR1 */
>> +        0x80, 0x00, 0x80, 0x00, 0x00, 0x00, /* 60 - 65 */
>> +    };
> 
> I don't see any point adding pa_features_310: it's identical to
> pa_features_300, AFAICT.

Sure. The only difference is in the comment part: /* ... 64: DAWR1  */
I'll update pa_features_300 with something like:

         /* ... 64: DAWR1 (ISA 3.1) */

and reuse pa_features_300.

[...]

>> +static void cap_dawr1_apply(SpaprMachineState *spapr, uint8_t val,
>> +                               Error **errp)
>> +{
>> +    if (!val) {
>> +        return; /* Disable by default */
>> +    }
>> +
>> +    if (tcg_enabled()) {
>> +        error_setg(errp,
>> +                "DAWR1 not supported in TCG. Try appending -machine cap-dawr1=off");
> 
> I don't love this.  Is anyone working on DAWR1 emulation for POWER10?

No. Infact DAWR0 is also not enabled in TCG mode.

[...]

>>   static void gen_spr_970_dbg(CPUPPCState *env)
>>   {
>>       /* Breakpoints */
>> @@ -8727,7 +8742,7 @@ static void init_proc_POWER8(CPUPPCState *env)
>>       /* Common Registers */
>>       init_proc_book3s_common(env);
>>       gen_spr_sdr1(env);
>> -    gen_spr_book3s_207_dbg(env);
>> +    gen_spr_book3s_310_dbg(env);
> 
> This should surely be in init_proc_POWER10, not init_proc_POWER8.

Sure.

Thanks for the review,
Ravi
