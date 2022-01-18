Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E7A492F01
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 21:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348756AbiARUK3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 15:10:29 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:17860 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343775AbiARUK1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 15:10:27 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IK8Dt0002872;
        Tue, 18 Jan 2022 20:10:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ClgT80fqh5Danohnghv3DuP1WBvcTEp34OwN93zlkyc=;
 b=hvPOX+M21fPHl8StPkBNtuFDSvHvxU7EZ6rI8obuaJHelD2S7B9of7YCfEhJ+G5vBzSh
 SU833YoepSAP1GKKcIIodGLF+sXj7g2kVKMT8DKFsSFM0tZPVz0Md7S5/YZbkBhKaRy1
 bBhD/u0wgxfaR8PsrtVTJAAzLirIKquN3pGfnnvz94PKTwMou9ClMTcbEL6nND/o2CLt
 /TDMjeUkKAWxr2gsItWzs4lOxOvY/m152Dw2h8UDqTTCNZiucFaRc5o61fWEQlHB5KDD
 1X46fofQfVd1CemkGrGHvolBAFOly1/Qz0vqhEnidh8xeb1IkWM43uU6GodncElqdsh3 gA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnbrnu1wh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 20:10:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20IK0PbU180361;
        Tue, 18 Jan 2022 20:10:24 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by aserp3020.oracle.com with ESMTP id 3dkp34rapw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 20:10:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SjP7Kdz0YInd5WGz0Fwtf5lymVTFR4iXoZpm/k1I0m+UdM1PfI46WSqpRd8YKjQkJOkxk7f3wOwIntW18GCn70M0LKpGGOsHzjvV/0Rr4j7HRvdmyYUUR77Acq6MPjaO0yW1AL4sif74cTX8Ais1Kq5lwhflH1LX88PA8atihGlr+Rr8YZx3jEaLhR3JDeZpJsVSPAkz2KjIa9M+9e0hEFgBXsGlP2ket1kC6zENk1W4j6cFc+1qfg6S/9PJQhLbSQw8FBfwNIiAic6VY+64w0ceo6JtP524JphCahfellAyX2ABh2tUejVcAm7g0a6Oo5MhDaPerHSDn5Ws+6jb6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ClgT80fqh5Danohnghv3DuP1WBvcTEp34OwN93zlkyc=;
 b=BEPxmduep3ioe/eWU4j6gpFNczBUWNBQbCuvBYwdnZNrsw7qItOHVS7kcXghfXGljiyWq2kMnTerAIHPvxBsErMsOrhpbucTvabnWu33sAKadz1CaA1DTKuxSRlL/o2no2PjGtG68dLzAp7VZbzZEZulIFRQ5lo0rhxnhZV7e0RR4zywhPjd9sYLazC0vg+nHqt0tFzDNZoMBf5vZCcYYinMC6mzE0yZwzzTHxU9Pwbo8ZpDUgLKKwAnVcAxFvZ0XvbKwRGhF1JVDwCug34a0u+IluHonMGx9s7OkNEUJCS0tLLiS/7l9SThAz+GLM3jq1Iqm9CwZGZKdGip1oV/5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ClgT80fqh5Danohnghv3DuP1WBvcTEp34OwN93zlkyc=;
 b=dGwQKgMPu/cFvVPNOvwBVRKe0PwiMank9sqiGHnoe4JOWKSeiQdL9dhHNlprThXUB6XVH6K7Ih313TezaN2PE3ueJ5Yy4+FXLrkWFQtBouFW2KxYeG0bsJl4WLvaLOQ3H4biIL4kbN+y7VfrxP77Vz+zG/LrwauQ8RJEriegVZ4=
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by DM5PR1001MB2154.namprd10.prod.outlook.com (2603:10b6:4:2e::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Tue, 18 Jan
 2022 20:10:21 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::c83b:812a:f9d6:b70e]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::c83b:812a:f9d6:b70e%5]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 20:10:21 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, mlevitsk@redhat.com
Subject: [PATCH KVM 1/3] nSVM: Fix PAT in VMCB02 and check PAT in VMCB12
Date:   Tue, 18 Jan 2022 14:14:47 -0500
Message-Id: <20220118191449.38852-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20220118191449.38852-1-krish.sadhukhan@oracle.com>
References: <20220118191449.38852-1-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::12) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68bbb1b2-d60b-4bdf-e313-08d9dabe8e48
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2154:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2154DFB0598BF81D244B317981589@DM5PR1001MB2154.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C69lVsUXileP5B3MKYQz/j+SZ4wYBuhlKEYRZwrHkq2co7AO+S4HxVvnwNK2rsl4XDvmxBiHN94FDkN5HQH255TMzHWlUg6/30jBM3jCZxzmc/pdUmJROC9NKbUoZGEUe5OEULFNmF5vdQD/+f/oV402JKMJ+Stye3zhGUq+x0uR0zKdBo9MrGHIuoV1bRDxpkJYQo/s3BTfi1zM6xjbm1Y24rHLrb1Vk41aokqoPp4lrxW305o8lA0ezL6L/l9YGxoTbhkiu0w1T/d0BJOO3JqHPi6WRaB8WIyzO/YfH8e9VA82dCeA/xS5So+LQtXV9tqJR+PADk+cpgqPvh7h0XmW8/Lr5wVk1QsN7ZRYy+gKW99dxVcMSEOYw++YVjYNrSzxxjcHYryVq25N6LzSANUEe1IpmSCfZw1GkaAzL9b7lxXc5HgDrs8Nn32n1EhQiSKDfBF3g9XpB4V6NFy5Ok7E7kCNv4lPCqhZQzVORR44GXNSDmd9b27Hnrv92QuDHinp8QR8haeHWJNCO7EXGHQwWjG1eO3DldpI/1kSGU0kdNKSCp+p/lm0sTcYPL6az3xAUo4oJrqH5VENNwFY2iZad4wJgONug248kE5L5JQTjyWfscGMfKIlCidKAEBh6E60eEHDyoP99PJ07C4CggAtP8KTJTDRxrkeBUslELjgpW2Rt5QHcxlmJMY2DPP4JNAN+lAJfCt/goNpTS8v3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(83380400001)(38100700002)(38350700002)(4326008)(5660300002)(66556008)(8936002)(8676002)(6512007)(86362001)(66476007)(66946007)(6486002)(316002)(2906002)(186003)(26005)(6666004)(44832011)(36756003)(508600001)(2616005)(1076003)(6916009)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bmlWSWUvQ1o0SjhtMHFVWEVhcXhrZXQvd0YvZlhpbW9uRFRua0F6TE5JcW1t?=
 =?utf-8?B?a2hNcjBLWCt4eTVVQ0N4YmVVSVp1dDBvVWM4eUc1Zmdmall5cWdJMXorYXJy?=
 =?utf-8?B?dHFOZDcxaE9CZUpNbk11Mmh1dlBHR3VUeW80YUxPUENHN2YyalI4Uzc3Q0tU?=
 =?utf-8?B?NlMxMHJWcnR3UldvR2NRWHVzdEV3OStzUXhmTUd3NXV2OGs5aWxaNTIzUXM2?=
 =?utf-8?B?NjRqd2VXUWd1eithWGxpSS9jVmtBc3Q2enNtajlYZkE4S3hxYkVHVVdEcDVW?=
 =?utf-8?B?UDhqQkxIZmRCRkREQ0R4aHlpTzZJa1ZaOXNqQlR5V2VNbVBtbi9OcGJZY2E1?=
 =?utf-8?B?ZW0zaVFQdjRhcWprUkIrRTBZUjk1Qi9pQ3ZJcFQ1S3pFeno1ZWgySUJmbHN3?=
 =?utf-8?B?NTdDZnZhYWRXQ0Jwa3lXT3kvOGlYcTg2TjhNN0tPVk8wUkEzSjJjdnZOZSsr?=
 =?utf-8?B?WXZoMHNTai9JWCs5MXB2ZXpSQUV5NDl1cHdZUFVIRVVuR2NHOTR0K2NFQXRE?=
 =?utf-8?B?Zy9GbFRxWDBlQ1FySzRNVjZ6bTBrWWgzNWpJZzRzSFFLTGtvU2F3M2VuL3Nz?=
 =?utf-8?B?aC9STytCVkoyeWRpMDZ2ODFYc0c5UlB1RHVyT3F1aDZlYjdyeEIvTWJqb0pt?=
 =?utf-8?B?SWhFRks2a0VMYU95b1dGUDZBY0p6SXJPWWF1cW83UG1oQ21BdDNzV2ZDLys4?=
 =?utf-8?B?T0M2NWNaSXo4WVp1RXJJSEc2ZGxEMUlBbW0yTmJFQ0FIYlJxQXpMNThZdDJT?=
 =?utf-8?B?RlFHL3BXYVN0RGdNSTM5TlVYMlJjVFAwRnRsWVo1WFpBUkRva0dtY1p6amdM?=
 =?utf-8?B?d1BhdXBoZnUrV2w4dy9rOEZFTlV5Q1RIYzE0VGxCUFJYSHZUNTMxdG1ERXFj?=
 =?utf-8?B?RnJzS09OVm43enEyUUJCZCtBbElVanl0YVdsVDBWWEhhRENaV0twb2w3T0NO?=
 =?utf-8?B?SERTRHdMREdpSjIyeEdUSVk3WmxiN0xlNUplbGpld0ppZGZobVV2OXBJcXlx?=
 =?utf-8?B?WTJ3OHY0MXNGVUI2RnJYcHVMV1d0bW1YbDNaaFFzK0UzeUR0QkNDZ1NRSHVJ?=
 =?utf-8?B?K0dMRnFBeEs0V3ZTakZTZTVISW9SM0x4eE1VRnpnYkJDMDV0blFFY1JESXlJ?=
 =?utf-8?B?VXhBdytNS0kyNjhmYjhqSmFzSlJHRjk3ZCs1eFZSWEVxTmpBdG1mK3R3M0Fa?=
 =?utf-8?B?b2I2MHJ6QTJDUUZTMVdMSVZqQVF3bDVwMndTTjUwelI5QnFIeHhLT1RZUTlt?=
 =?utf-8?B?U3g3VFlJLzRWdjRtVnFiM0xLYjA3bFQ1VUozSWhtQlFMWm0vY0UzaFNBV1Jn?=
 =?utf-8?B?a2NlTmVhNFl4RUN4UHphR20xV05oN3hjR2c4Q24rZXFIMncvQkc3VmRleXZs?=
 =?utf-8?B?bmZUYjVEVFVoaFJCMk9EMVhKRnBiWFlybWJGV085L2d4Q09VSFJBTC9QQnBx?=
 =?utf-8?B?Z2xLTHRUL1Fqakd3cklidGd5cEp5bkRlTEhuL1hhYU5SN21NZncrWk1tYWFz?=
 =?utf-8?B?RDVKSlFjY2o1WkZHRW04Qnd2cHZvSmhwVXh6STUrRHlWdHd0K3VQNzJySGJK?=
 =?utf-8?B?M1YwYXJQRFJuSkxiMlhUcmU4TmRPQTlhWlpMOXhwQUJKeUxYTXNOL2dKMWpY?=
 =?utf-8?B?MmZRVTJ5ZExZM1ZmVFNoeWt3Z25uS1JjSjQ2S0xCdzBWcGg2R01sblVZdG1G?=
 =?utf-8?B?aXR0d3IrbWl2ME85R3dWcmhtTURMQmtZSUdZUzVBMWVLdjVrbEtzOVgwWTQ0?=
 =?utf-8?B?a2wrT1ZpMFNaMzZwOUxMN1prUGRGcE1jN1N5Tnphb2kybTQvMWJmTjk3UVhY?=
 =?utf-8?B?Uk1uR0NueDhxYzFrYXVYbjRlSCtsWnczOXRwdm90RkF4NkZBR0dhL01wUTk1?=
 =?utf-8?B?VkV1czlEd0tBNEpNdkNrSXZoTlc2a2o3enZLMzV2NFBLcms4aTNHMmE2YUFp?=
 =?utf-8?B?ZU52Sm1IRUlMeGFXRWRXbll1RjM2Wm1UbmhIMXhLWGR1blVReC9sV2J3Nzc1?=
 =?utf-8?B?dkZwRVBhZWdSeHBLSFZMT2xKWnFXZXYzb3IzdGtJdVF1VzFrbjZkZk9YZlhu?=
 =?utf-8?B?S0wzVFRrODFmeXVQSENJSFk2SU5jMEJ4RFNCelV1cWYrUGE1bVhIb0U0WHlx?=
 =?utf-8?B?QWlYNjl4NjFHRDYrT2w4dCtQdktrSkcwWGdUbStKelIvN3pWeW5XcVRodW52?=
 =?utf-8?B?a280V1JBWE9yejJpeVBvL2dhM0krOFM1YVU0R1prOTBhbURDenNEdG9DT1Q4?=
 =?utf-8?B?MW8wNFRvY0ozU0VFU2twSzNnM1pBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68bbb1b2-d60b-4bdf-e313-08d9dabe8e48
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 20:10:21.7449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dgzMpRTTZraTrDPzAv8u1o+o4Uy3FzbwCJIV7oADKsmqqLuJurOAoEQ/+hD5e9KE59wpJNsylsM1Ww3u1x0Dzg6Q3HEXfx8Ibt/ZW4O1kD4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2154
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10231 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=921 adultscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180119
X-Proofpoint-GUID: sJ7zDFXetK5yLLcppFUMElebsinBFO8J
X-Proofpoint-ORIG-GUID: sJ7zDFXetK5yLLcppFUMElebsinBFO8J
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, KVM uses PAT from VMCB01 when launching nested guests, as well
as, when nested guests write MSR_IA32_CR_PAT. But section "Nested Paging
and VMRUN/#VMEXIT" in APM vol 2 states the following:

    "When VMRUN is executed with nested paging enabled (NP_ENABLE = 1),
     the paging registers are affected as follows:
	• VMRUN loads the guest paging state from the guest VMCB into the
	  guest registers (i.e., VMRUN loads CR3 with the VMCB CR3 field,
	  etc.). The guest PAT register is loaded from G_PAT field in the
	  VMCB."

Therefore, if we are launching nested guests, the PAT value from VMCB12
needs to be use in VMCB02 if nested paging is enabled in VMCB12 whereas the
PAT value from VMCB01 needs to used in VMCB02 if nested paging is disabled
in VMCB12.

However, when nested guets write MSR_IA32_CR_PAT, that register needs to
be updated only if nested paging is disabled in nested guests and the PAT
to be used is the one from VMCB12.

According to the same section in APM vol 2, the following guest state is
illegal:

	• Any G_PAT.PA field has an unsupported type encoding or any
	  reserved field in G_PAT has a nonzero value.

So, add checks for the PAT fields in VMCB12.


Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Suggested-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c | 34 +++++++++++++++++++++++++++-------
 arch/x86/kvm/svm/svm.c    |  3 ++-
 arch/x86/kvm/svm/svm.h    |  3 ++-
 3 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f8b7bc04b3e7..3283a58d5b0f 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -326,6 +326,17 @@ static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+noinline bool nested_vmcb_check_save_area(struct kvm_vcpu *vcpu,
+                                       struct vmcb_control_area *control,
+                                       struct vmcb_save_area *save)
+{
+	if (CC((control->nested_ctl  & SVM_NESTED_CTL_NP_ENABLE) &&
+	    !kvm_pat_valid(save->g_pat)))
+		return false;
+
+	return nested_vmcb_valid_sregs(vcpu, save);
+}
+
 void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
 				     struct vmcb_control_area *control)
 {
@@ -452,21 +463,28 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 	return 0;
 }
 
-void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm)
+void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm, u64 g_pat,
+				 u64 nested_ctl, bool from_vmrun)
 {
 	if (!svm->nested.vmcb02.ptr)
 		return;
 
-	/* FIXME: merge g_pat from vmcb01 and vmcb12.  */
-	svm->nested.vmcb02.ptr->save.g_pat = svm->vmcb01.ptr->save.g_pat;
+	if (from_vmrun) {
+		if (nested_ctl & SVM_NESTED_CTL_NP_ENABLE)
+			svm->nested.vmcb02.ptr->save.g_pat = g_pat;
+		else
+			svm->nested.vmcb02.ptr->save.g_pat =
+			    svm->vmcb01.ptr->save.g_pat;
+	} else {
+	    if (!(nested_ctl & SVM_NESTED_CTL_NP_ENABLE))
+		svm->nested.vmcb02.ptr->save.g_pat = g_pat;
+	}
 }
 
 static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
 {
 	bool new_vmcb12 = false;
 
-	nested_vmcb02_compute_g_pat(svm);
-
 	/* Load the nested guest state */
 	if (svm->nested.vmcb12_gpa != svm->nested.last_vmcb12_gpa) {
 		new_vmcb12 = true;
@@ -679,8 +697,10 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 
 	nested_load_control_from_vmcb12(svm, &vmcb12->control);
+	nested_vmcb02_compute_g_pat(svm, vmcb12->save.g_pat,
+	    vmcb12->control.nested_ctl, true);
 
-	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
+	if (!nested_vmcb_check_save_area(vcpu, &vmcb12->control, &vmcb12->save) ||
 	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_code_hi = 0;
@@ -1386,7 +1406,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (!(save->cr0 & X86_CR0_PG) ||
 	    !(save->cr0 & X86_CR0_PE) ||
 	    (save->rflags & X86_EFLAGS_VM) ||
-	    !nested_vmcb_valid_sregs(vcpu, save))
+	    !nested_vmcb_check_save_area(vcpu, ctl, save))
 		goto out_free;
 
 	/*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5151efa424ac..e08e55082e77 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2907,7 +2907,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		vcpu->arch.pat = data;
 		svm->vmcb01.ptr->save.g_pat = data;
 		if (is_guest_mode(vcpu))
-			nested_vmcb02_compute_g_pat(svm);
+			nested_vmcb02_compute_g_pat(svm, data,
+			    svm->vmcb->control.nested_ctl, false);
 		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
 		break;
 	case MSR_IA32_SPEC_CTRL:
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1c7306c370fa..872d6c72d937 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -497,7 +497,8 @@ void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier);
 void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
 				     struct vmcb_control_area *control);
 void nested_sync_control_from_vmcb02(struct vcpu_svm *svm);
-void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm);
+void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm, u64 g_pat,
+				 u64 nested_ctl, bool from_vmrun);
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);
 
 extern struct kvm_x86_nested_ops svm_nested_ops;
-- 
2.27.0

