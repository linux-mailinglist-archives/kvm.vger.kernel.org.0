Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647024B49AB
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 11:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344325AbiBNJ6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 04:58:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344377AbiBNJ4K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 04:56:10 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384D26CA5C;
        Mon, 14 Feb 2022 01:44:30 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21E97JbQ023929;
        Mon, 14 Feb 2022 09:43:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : references : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=BLwc1m7Z5zDCcHweH36cK3g7xOEvLAHpux7IZm0MI4U=;
 b=u5/qQOWfsBQXzA43qLeN3lBUJIiDHPmQyWOGm3p+D9SGfSXXqVALGpSDmqqm4cQnFCYE
 ZAm2PCRiPWmEv0f8Kiy9Ke43OOj8jaB0RSLP7ZBTH8ZDyeHygrgtQ5inWGMsbfXI2aRL
 o2HQnc8a7jW6zFbSrxpPUj/SVYSGew8241OV/X8GZbOPapvtl3O17Xm6lsMg3VMpQXGB
 PT5hZpe8lTCVGu533njQG+3n/PQKafSulrV647AEecG6sEU6QE5cyPcgBDGNzVgP1plP
 w3b1Tw60WOnkOZbCBFLua0DC54OVnCG13VgDLB+vPgWNfUbzMr+Pd2ZsIRnE4cVG777A mw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e64sburap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 09:43:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21E9a21M133517;
        Mon, 14 Feb 2022 09:43:23 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by aserp3020.oracle.com with ESMTP id 3e6qkwd3ga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 09:43:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=juHAv7bAalLxG0V9n/rOfSnd0wCxyCaGI0ZuuxlVcW9QZdmY0D6otclgH65bmvYW+YAzkt1CX2DSfcJH7si23INXO6gXM5rZwUgm2HMNcSnDQ1U08v5jCf0nFsHdUqUfARpRb1HsVC7zz3M6cCWS8v0gAOlEuoRy+Bcotmkgnxr0X5eMsciJE1gCXypC/u1W6IsM6DQPoClh3Q6cCop+FV0ngJKFC5CjO+GFgvvzl9NTHeBnqcCFj84h7TVBZRKPdkW7EyBPo0hMZgCfBPo/1kjfmTQgIeJ2QkP/5cV/vbl50PLEY/IBk9ntTwFdQ9NKZhTk8+WufC1j5rzdFWskig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BLwc1m7Z5zDCcHweH36cK3g7xOEvLAHpux7IZm0MI4U=;
 b=FACsppYXIQ7zE4S/5SQ3benEoiCHjsblm7E9FO6b1ziGxPKxahqaRrVvM7jKWRhh2WRBkNsBULb9j+EbXnflUMkS6g5WNh/Sztqj9qdluvI6AkzYaN6XfNAow9U4jEO9y853V5vRsEXNN4f+Ey+HPDEO8MasbamZriy6ArH6dMENcfVuE/KQb79I9YxyD04YhwpG4VoT47pVSFyBRceUn0UBaProrv9WldFXfZnV6LFlv9NraURZDjBx+TlIoA1VGAuBDjpwVvLhrqN1TLYEVKF7fTJuACXEe+ruIIsqVN2RSoVA8N8U4S2Gt2D8uJjzyPaEjgBD4C6YFSnwvPJjvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BLwc1m7Z5zDCcHweH36cK3g7xOEvLAHpux7IZm0MI4U=;
 b=IhPzSDfNCk8LwPy3D5GPXIj3OLTSP4Z1GYqg4+a2Wi9OC147EfDTuzhBpwhDFJu0Os/z0pmd6qEOjl12PXo61fWH6hC+c0SuXJ3KhK6rg1sGFc3Tq2KYbjzkRch+0v6OzkH0W9Pfp0eVAciQ0Te5XcqawnHgRmCiUCgP/A5pvrg=
Received: from DS7PR10MB4926.namprd10.prod.outlook.com (2603:10b6:5:3ac::20)
 by PH0PR10MB5594.namprd10.prod.outlook.com (2603:10b6:510:f6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Mon, 14 Feb
 2022 09:43:21 +0000
Received: from DS7PR10MB4926.namprd10.prod.outlook.com
 ([fe80::e429:a820:ef6e:98d9]) by DS7PR10MB4926.namprd10.prod.outlook.com
 ([fe80::e429:a820:ef6e:98d9%6]) with mapi id 15.20.4975.015; Mon, 14 Feb 2022
 09:43:20 +0000
From:   David Edmondson <david.edmondson@oracle.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Leonardo Bras <leobras@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 1/1] x86/kvm/fpu: Mask guest fpstate->xfeatures with
 guest_supported_xcr0
References: <20220211060742.34083-1-leobras@redhat.com>
        <5fd84e2f-8ebc-9a4c-64bf-8d6a2c146629@redhat.com>
Date:   Mon, 14 Feb 2022 09:43:14 +0000
In-Reply-To: <5fd84e2f-8ebc-9a4c-64bf-8d6a2c146629@redhat.com> (Paolo
        Bonzini's message of "Sat, 12 Feb 2022 12:02:14 +0100")
Message-ID: <cunsfslpyvh.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/29.0.50 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0238.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::9) To DS7PR10MB4926.namprd10.prod.outlook.com
 (2603:10b6:5:3ac::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7355c0e0-1be5-4fa5-892f-08d9ef9e6f97
X-MS-TrafficTypeDiagnostic: PH0PR10MB5594:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5594304F991BCEA5B24B5CCC88339@PH0PR10MB5594.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mBASfE8Cq8T2ua3Dk1q7Un/laL1oRk04cBJQDY7RJqMbamfil6AzVRDfaHGWSBg2zoQ4ugFe8VJbX7Y0ea2iOslvkvEx1ok1U+c29o8uxVFwyZNo2m6u0EpU0vp9gWBq6Uj+1x3rWaZ+R1cuMNEHeurkEJJ+VpXxQq3RMkrRGlWWNeW8nCYbtDx+y7pvulYvJ0sJQsW+xIFUP4Nfa86x9bGaYloFmUZ5mTonTJbZnhju8OLdMsADaxHcNAiawJL1latsf+IVJLeyMrxKBREOwENsZBWRZ6nGwPzxFjE/nzIH4OhmHkefJ6HXZVxouO/iIPlMRIxn/bzDFs10xcucC2cEwfTWqCb/6MFDMVliByX4i2z7oA8e5Iq/SUsjIfM5MRZAKy3dNGaENeKybz/whZaADMCUUEtosKysnx5T1fAQX9C6HRWepUkBPxftzLKUZKLzK+PG0XbWf5MUxyo3dlym6PAvhBwipTjIfJS57OXQqfuRFfLNYBd1nEfa5TuRo48O5HOrX+UWIHpviN201vRKP2WbZnPZW0Y+GKBd82FdNfrcrLErGnvKBCYFZ4klVQ5ApyvMXENgpX3sZumJnKOBEA35QtEx7Fmt3Gai0xqlFhSqgf9QT9is52pf5L0PTYRp3lLVv/1GS/WtqBlJpYvIgxQEBfIXGqHiMErnj/lhfulYtcutAgZ0Y4B9G1iXZVuZiclFXz2QEv2D6jlFQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB4926.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(52116002)(53546011)(6506007)(6666004)(508600001)(4326008)(8676002)(66476007)(66556008)(66946007)(38100700002)(86362001)(54906003)(316002)(6916009)(36756003)(2616005)(83380400001)(186003)(6512007)(44832011)(7416002)(5660300002)(8936002)(2906002)(4226005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aSwbMnqwcwld5C77p7fXedzgFEFwHAW9ZR6wPjjQ2bNbkd7DTZOKZQzEwM+z?=
 =?us-ascii?Q?pJYeLkDNKwEXll8BeRN9IQyBkZodz9Mo70TVUOit2mQV67I+mHNnx9o9+mFH?=
 =?us-ascii?Q?uP1Qh3rhkos8Jwpw/t6CbUGxgXFTWtfvPgd16Oil6yKAytDoXGe8M8vG9lcx?=
 =?us-ascii?Q?u3e5fSHKsybCqslHfbV8QvjiEVo8KlVlcjIwvWHG2+v5iSmu8FkLAwgUAcN4?=
 =?us-ascii?Q?3u7ZdHGwHDxpWTuUbL0XgySFoEsclOTptks/OyUDucIhpOMwEU/+GtpzDpMB?=
 =?us-ascii?Q?7HWl1/1EiUGC/j6jR1CCRHhTWeF7mAp4Mzj+zN0G7ZDBGFpqPY03z8DA6QAp?=
 =?us-ascii?Q?MXJOUxc0M9do0ROrAsQIW16Cqco5Al6fwg+qhxQ5Mg1VaJLAwVP88VSNTH1x?=
 =?us-ascii?Q?EIY/Olwj3iogLZzOSaxRXJIwlrb5KDiF36zHG+68W4u2ctKFc7xu5Hgj7D81?=
 =?us-ascii?Q?b/aelUZl0to6+ccSUafgvaZwhx4p+WLLOLLmprV78/Ku2sni6ddenGCC1SUr?=
 =?us-ascii?Q?QWcoZzXfed5hlZKu6sU0ydW9P53rLToQTjDo8kon3A7fB904Tfal/5cc1wcM?=
 =?us-ascii?Q?6zXPs3LD0wnoxH/jTNJgBWebPhBFsJoiJYrs8DkrzyZRI5UIIdpCYkn8mChq?=
 =?us-ascii?Q?t7uLstTHPnCRgTWcraS5vi7JwBKtb8Kuv3nb0ADf0xiNrjMTTDIfTn7PF9bE?=
 =?us-ascii?Q?ZVSfYosZZZy/oSSkqwNU+MKt8tgtwSmGBjWcP5Oc1glJcQUV+B1IWgm0sxMT?=
 =?us-ascii?Q?44Nro3o7s/09652QQ0Pdw4Oh2IxCojzoZFhNZsFXNxUz04+5OH/WY0FO0cUs?=
 =?us-ascii?Q?FvfdMRtRaZB8rkTWHHvIVgpy5QhmhWUgNdi1qizaXei5IXpEw44w5/Ww2Zp6?=
 =?us-ascii?Q?LZqofpP1JQo9vqWPjHRla+fKhjGWtZmTBYACjJwdkURmOHsv8fUMcreRhorD?=
 =?us-ascii?Q?VjrkSLv97CZKywFzI3FKan+pqam1VllFZ6G1Ju1aDS2q1IX6N/rsH0nl8nFQ?=
 =?us-ascii?Q?Dcow9+ah4dtVwVUwZXoy+pOkk5lvdBUV0Ms55zEsdBr21JoQInSFbrflb+pP?=
 =?us-ascii?Q?o1iYo8QNoO1QoW4+NvKurdj6yyQFWKbXpkzB2EZP4SDTj2CPCAoPX+Ci508U?=
 =?us-ascii?Q?mxmqQNyX0BiTcN47TMFuRI4DY8gPUpcYjnWS5Hf4QWkOGg77u1cWZ0OO+uZu?=
 =?us-ascii?Q?T735ljSu9DLKIsYKjOj0kSpv1tuHvPmiFt7e5omVxkk1a4JMD+v3j6flI4pT?=
 =?us-ascii?Q?UsHs7nCH+ayO1FAyI3ZTO4sZ5leVAu5z7wlRuU7+6piMlwMp0qeWtFJ9PDKu?=
 =?us-ascii?Q?a4YihGrfn6r5gWFuWAJpf6wvvVCZHLmOxwy16V+O/NX0aO8mVeUUVj07rGa1?=
 =?us-ascii?Q?cuOBuF33cnn0t+pGK2BISM9EULInSM0p/QeR7Gncu4nZ5Fs12qDxk75HXIRV?=
 =?us-ascii?Q?+IX5a0/cC7kfVXCnW/yQzyxQerP5vxra/0Tj1ey7dDEapRyFaJT5tSMRnthP?=
 =?us-ascii?Q?AHW3tZwESKqtxEPHLeh2ql9J8RA0OOoSEYQPku23U6qC31z8DnkarBL0Rvor?=
 =?us-ascii?Q?zHojH7IMQND+NHG0e1gwJy9giMxP+kzBsMg2vqm/oV0SF/wXVOc/lpDgXTxk?=
 =?us-ascii?Q?eCTv9c+OHGTdEnx/y6spXI6tFfHF4Ey5HlKLlxzWO13q8WKcjC+EmTh4Gb9g?=
 =?us-ascii?Q?lustZXotBFCecREsSAkT0YEaO5k7AqRO025ul0wnlo20PWhM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7355c0e0-1be5-4fa5-892f-08d9ef9e6f97
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4926.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 09:43:20.8668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XVPljKDA2QRG1mrcPmkLt25Ko5D3oQVPA4nrYc4/q35cK9L4nNhISgRm4uKATRg9M6kOP2GDol+ccqnofzqV7rEP/59zL8Foy/EH82bU5gs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5594
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10257 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202140058
X-Proofpoint-GUID: SzYcF728pxJ2qWtdaI9WTs8PPd-jUiOn
X-Proofpoint-ORIG-GUID: SzYcF728pxJ2qWtdaI9WTs8PPd-jUiOn
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Saturday, 2022-02-12 at 12:02:14 +01, Paolo Bonzini wrote:

> On 2/11/22 07:07, Leonardo Bras wrote:
>> During host/guest switch (like in kvm_arch_vcpu_ioctl_run()), the kernel
>> swaps the fpu between host/guest contexts, by using fpu_swap_kvm_fpstate().
>> When xsave feature is available, the fpu swap is done by:
>> - xsave(s) instruction, with guest's fpstate->xfeatures as mask, is used
>>    to store the current state of the fpu registers to a buffer.
>> - xrstor(s) instruction, with (fpu_kernel_cfg.max_features &
>>    XFEATURE_MASK_FPSTATE) as mask, is used to put the buffer into fpu regs.
>> For xsave(s) the mask is used to limit what parts of the fpu regs
>> will
>> be copied to the buffer. Likewise on xrstor(s), the mask is used to
>> limit what parts of the fpu regs will be changed.
>> The mask for xsave(s), the guest's fpstate->xfeatures, is defined on
>> kvm_arch_vcpu_create(), which (in summary) sets it to all features
>> supported by the cpu which are enabled on kernel config.
>> This means that xsave(s) will save to guest buffer all the fpu regs
>> contents the cpu has enabled when the guest is paused, even if they
>> are not used.
>> This would not be an issue, if xrstor(s) would also do that.
>> xrstor(s)'s mask for host/guest swap is basically every valid
>> feature
>> contained in kernel config, except XFEATURE_MASK_PKRU.
>> Accordingto kernel src, it is instead switched in switch_to() and
>> flush_thread().
>> Then, the following happens with a host supporting PKRU starts a
>> guest that does not support it:
>> 1 - Host has XFEATURE_MASK_PKRU set. 1st switch to guest,
>> 2 - xsave(s) fpu regs to host fpustate (buffer has XFEATURE_MASK_PKRU)
>> 3 - xrstor(s) guest fpustate to fpu regs (fpu regs have XFEATURE_MASK_PKRU)
>> 4 - guest runs, then switch back to host,
>> 5 - xsave(s) fpu regs to guest fpstate (buffer now have XFEATURE_MASK_PKRU)
>> 6 - xrstor(s) host fpstate to fpu regs.
>> 7 - kvm_vcpu_ioctl_x86_get_xsave() copy guest fpstate to userspace (with
>>      XFEATURE_MASK_PKRU, which should not be supported by guest vcpu)
>> On 5, even though the guest does not support PKRU, it does have the
>> flag
>> set on guest fpstate, which is transferred to userspace via vcpu ioctl
>> KVM_GET_XSAVE.
>> This becomes a problem when the user decides on migrating the above
>> guest
>> to another machine that does not support PKRU:
>> The new host restores guest's fpu regs to as they were before (xrstor(s)),
>> but since the new host don't support PKRU, a general-protection exception
>> ocurs in xrstor(s) and that crashes the guest.
>> This can be solved by making the guest's fpstate->user_xfeatures
>> only hold
>> values compatible to guest_supported_xcr0. This way, on 7 the only flags
>> copied to userspace will be the ones compatible to guest requirements,
>> and thus there will be no issue during migration.
>> As a bonus, will also fail if userspace tries to set fpu features
>> that are not compatible to the guest configuration. (KVM_SET_XSAVE ioctl)
>> Signed-off-by: Leonardo Bras <leobras@redhat.com>
>> ---
>>   arch/x86/kernel/fpu/core.c | 1 +
>>   arch/x86/kvm/cpuid.c       | 4 ++++
>>   2 files changed, 5 insertions(+)
>> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
>> index 8dea01ffc5c1..e83d8b1fbc83 100644
>> --- a/arch/x86/kernel/fpu/core.c
>> +++ b/arch/x86/kernel/fpu/core.c
>> @@ -34,6 +34,7 @@ DEFINE_PER_CPU(u64, xfd_state);
>>   /* The FPU state configuration data for kernel and user space */
>>   struct fpu_state_config	fpu_kernel_cfg __ro_after_init;
>>   struct fpu_state_config fpu_user_cfg __ro_after_init;
>> +EXPORT_SYMBOL(fpu_user_cfg);
>>     /*
>>    * Represents the initial FPU state. It's mostly (but not completely) zeroes,
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 494d4d351859..aecebd6bc490 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -296,6 +296,10 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>   	vcpu->arch.guest_supported_xcr0 =
>>   		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
>>   +	/* Mask out features unsupported by guest */
>> +	vcpu->arch.guest_fpu.fpstate->user_xfeatures =
>> +		fpu_user_cfg.default_features & vcpu->arch.guest_supported_xcr0;
>
> This is not correct, because default_features does not include the
> optional features (such as AMX) that were the original reason to
> go through all this mess.  What about:
>
> 	vcpu->arch.guest_fpu.fpstate->user_xfeatures =
> 		vcpu->arch.guest_fpu.fpstate->xfeatures & vcpu->arch.guest_supported_xcr0;
>
> ?

Sorry if this is a daft question:

In what situations will there be bits set in
vcpu->arch.guest_supported_xcr0 that are not set in
vcpu->arch.guest_fpu.fpstate->xfeatures ?

guest_supported_xcr0 is filtered based on supported_xcr0, which I would
expect to weed out all bits that are not set in ->xfeatures.

> Paolo
>
>>   	kvm_update_pv_runtime(vcpu);
>>     	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);

dme.
-- 
I used to get mad at my school, the teachers who taught me weren't cool.
