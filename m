Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D2144DEB6
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 00:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234538AbhKKX4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 18:56:20 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:25482 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234515AbhKKX4T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 18:56:19 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ABNU2Gw017941;
        Thu, 11 Nov 2021 23:52:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=g93UjdTSPBDHyFb34fq2KgFUmvcpEFPZCOE68rA3tD0=;
 b=QTAbyJWbu3mV+8Cqssc298OYTLLhfuSMbSebcgUAk9FDirVRmwcPKp+CC5QIpAVNfzQH
 3XgSMyt04Ihy3cW4/VDLpoeNK7L26EWJIKIkH0L2LjagdE9qCAYiNyAw0TuibJ5nuDky
 EWKwkdF2H50eWSGNghZUWykSlIPTHc1Xefp8vuzgYW3oVTc2O2jWZcybm4MuJVBKkSrP
 FxclBrHK8qTfrt/uixVNtxjw4KW4ilCVFFjE4AYBDjAr3Du9uo3MVNjyf2neKPLtFypt
 h79TKGrnHuLdacALKb0xnmY3e2DzJq9VSQN3P0kCgeCv1LPBmM/1azTllmdFpyNVVDnv WQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c82vgmreq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 23:52:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ABNom22143662;
        Thu, 11 Nov 2021 23:52:42 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2049.outbound.protection.outlook.com [104.47.51.49])
        by userp3020.oracle.com with ESMTP id 3c63fwthch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 23:52:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VHOsaBlxoh/iCfqq0Gw1n5RTWF/8lU0A3jEETJbp0zx00Er/XOcIdnAiABOR3WTT6P1lNnUIG/llsHS8qujKfQntUVUeNp7+rFjRltP5x157eXSNrKH15y+3zPrT1L2g6XeFUgpKEuyFftw9K/lOSCOSjecO0FDLpd1cgY5qRiydOHRSF+egJYvTNKNXVf2yfL1X+Uzj5n2RBx10tdS4NhlLZsi+lQAnqPy4lyb44+zfHCapifu9BMppYYgEdBC2KANrsMonnbn1Jdug9C68RzgvM51/TwGgragse8EQON0SoO/vEP0FyKvV0TsQOKpOtbhOpPjcR3dhgPw9w69+pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g93UjdTSPBDHyFb34fq2KgFUmvcpEFPZCOE68rA3tD0=;
 b=h24vfVqc0eEsGKl50pjE6aVkFntu3ZMMpawr0ITBX8uaWxc00sFUCscefIN5m9+6EtC7diDSade+QWkxjaYoak1P9H2E7KwdCbWeODuTiSjanzn8KqNR3MZHdoYxZJjpRoG4EyVQ2uu1v50a/WIpjnlXav4XRUyu2HODtNk6Htw5yrd3a2zpjp7Yi6woIprZlK9KFFse0A0AyeDQYwud6EZPioraEELs/cRme9rG8dfKQSPpmCmLb4Cfke0cVlp6KHODx6fCQV5F8ZrRIWaZaG8A3HFSeJYUiXE2rUyOMpipht5wkZJeD5iJdlPtFe0lfDauMsF5zd1L/5h9SxXV+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g93UjdTSPBDHyFb34fq2KgFUmvcpEFPZCOE68rA3tD0=;
 b=NHgRPCuzluxvGS5lmAhjbvvbxvoEGzZf0aqTNqjmJ3L5fX6pQb9g5Yl9AuEy3Byly3ZlQFRd+CKuNtMXCxhaESR6f9FjA+gdiARdEcJl/Av2vrxCOgUj8j6A+f+cnddh5aTv8k3I3rezrw/CD+KzrI+HXfZghVczq44pBG12LcQ=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH0PR10MB4938.namprd10.prod.outlook.com (2603:10b6:610:c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Thu, 11 Nov
 2021 23:52:39 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6%6]) with mapi id 15.20.4669.016; Thu, 11 Nov 2021
 23:52:39 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 26/30] KVM: Keep memslots in tree-based structures
 instead of array-based ones
To:     Sean Christopherson <seanjc@google.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-27-seanjc@google.com>
Message-ID: <5f5c80ce-9189-def3-9c50-d5a504925253@oracle.com>
Date:   Fri, 12 Nov 2021 00:52:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211104002531.1176691-27-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0059.eurprd06.prod.outlook.com
 (2603:10a6:20b:463::34) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.219.146) by AS9PR06CA0059.eurprd06.prod.outlook.com (2603:10a6:20b:463::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.19 via Frontend Transport; Thu, 11 Nov 2021 23:52:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0222f454-67d7-4287-2e09-08d9a56e57ec
X-MS-TrafficTypeDiagnostic: CH0PR10MB4938:
X-Microsoft-Antispam-PRVS: <CH0PR10MB4938A901F2ABDB9A9740D5E3FF949@CH0PR10MB4938.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +7ZhH1sTLyQAkcCwIyxEtM0J1yT4wkxfvWJ/oxejPD9WN9NHdjRw0DoX9fvJNFksNNFUHCRjrWlgLM+fZVUDVkEbEKjptCVCbSZDfu5cug4HOz5AcrosMLosmgbsWVcLSBLmCk5233TkbUL8prAIDhiGp5agQJrQbpOnlVTLNqg6euau2mfholxVeEjaiJ+TLnUnYrHgkjJz2JdpCVr3pYRs9a8Vzm3V1yTVSBI3ZQ/fCmDODYDVskXfASSvDYVOQkHNtGSwl3mPznySh8ztvHOiS5I6WekrpnDr0/AVVtR/c/DdCTJe8zcs+45rXYvc0HZaRSiURYDHwXrg90XwdERRybY4ZcEAF51w11ggpunSTGmFTH9JXmEAm5zL9g73jMMruqm2IF5zE45TGJzYPl52mXboyM0eD40CZoPoiSL7FIs8vwbRygVTS+/SNJOeO5PTJ06lZLSTxAOJyLch9k4Y/ct0SvMr+vvrBGPS/MDT2OYYtA4mg+33voo6DdUfQGah/f9G46wLbzRU9nxSsOiKdLooTts2JXte4pej+yNuw0z+RF3n38l9efBVqFL9vBB+nq8OYBZs8s2NAfeyorxvfC48EyHkCQ39kvRAhiTx6v7V2wYwPx42tNzQyx2mW+WnlIxPKPxqdb1arWDS+M6S8KXg2rP+Mv8xmmE8thzHvb/og/usj6n539Y8tqnBTFd57WOwYxPccVvyL2bB4FyDRvAMomqqLs8Bt6vEUj4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(86362001)(36756003)(8676002)(6666004)(16576012)(5660300002)(2906002)(316002)(38100700002)(956004)(83380400001)(6486002)(508600001)(7406005)(4326008)(31686004)(26005)(2616005)(8936002)(6916009)(186003)(31696002)(54906003)(66476007)(66556008)(7416002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V1l4V2hoRzE3YWszNGFjYUxLeXU5MVRPSzYrS3FGRThpV0xlUzRJeEozU1pN?=
 =?utf-8?B?clkrdmJFdmdpV3ZmNERhMGg0dEhMNW9EekpRRXVYZjJ2NUZmY3dVYThlY2xJ?=
 =?utf-8?B?T09lL2hFV0NnOXVYcTZkSVF5VmNseXJ2blpjVEpSak05Y1haem5FbVVvNXBU?=
 =?utf-8?B?Uk9ZVGRtVnMvd1kyU0x6dEoxU3dLMmk5cGtHaWVWY0x4TlRjMVRsaVFGWlFw?=
 =?utf-8?B?NEZiY3NqbjcwS054ek5sempGN1hlUVNoUmZoTFNrR00wOXZ0TkloZEdmTGtQ?=
 =?utf-8?B?YldzSlROUk53TVRObmlEVE5mb1dIbTFLSk12MCtGTHA0MXg0RmpWV3JPY1p6?=
 =?utf-8?B?U0daYWpzYUNEY0VMTHBYMEtJNSt0dmlSVU15Mi8yNVBYTGV4MC9ORkVVVExC?=
 =?utf-8?B?ak1ReDRkelhHalFJTGRvTkp6Sm50cHJnemxNWitxR2FIYmRCSHJ3ZlRCblNB?=
 =?utf-8?B?d1h3eWUvK2pVbUIyN2poYlZ3cVZGTjUvY0JFY1pkeVNibEVkMTk2OE90OWVH?=
 =?utf-8?B?V2VBZnZZQzZlcVd0c0MwalhteldkWGZ3dTlJMHFxU2k2TTZaVEZHRmpxQmw1?=
 =?utf-8?B?ZVlWdmU3RVdNOVBxRmpsdnlnUmR4dE5PUWhpakQyS3pEZGVWc3BvM0RCYUk2?=
 =?utf-8?B?MWhpdjgvMFdySUQ3ekhvZ0hnLzN1VmJGY2ZKT2tFaWZrazltOCsrOWJGdTRq?=
 =?utf-8?B?WHp1NC9DYkNJYm5tTHM4YmU1OVlOeVM3L2tHQjRtOVhESXovekE2cHY0ZHZR?=
 =?utf-8?B?aHdqTEFLTmQxU1dkNHFQUFNGQTc5SUNyQzZUZXcxMTdCUDBqQitPUTUrZDlz?=
 =?utf-8?B?RzNjU1l1eEk4d3BKbFdVL0ZhV2dOMDJYSjBCdWY5dTczK1BuYkdRNEQxYXJR?=
 =?utf-8?B?bHJKSnRQTDA5M3dYVjZERmZwU2YzbVNuTTBld0REYVZlN1FZV3A5MktBMXFD?=
 =?utf-8?B?ZGtJM2Y1MXdYWXBkUmsrd1VCNjF0aklGenc1ekh1VUE2V2VZTHFHK05QMEpo?=
 =?utf-8?B?OEV6ZHJFZW81UUYyWVhBbjRQVUUzald3YlNGUHJFbzNqbXRHWURXbk5IWndE?=
 =?utf-8?B?WmNrRnRBMnl3ZlBXSENlNkcxbWJqd1RuNGpxYnZwMDRQRURsRlhvRHJCVkwz?=
 =?utf-8?B?Vy9IQUs1UzF1aFZlYlhiVFdJK3pkbFdBa2pzOFVNemp6NmtGME4wT3d2VFh4?=
 =?utf-8?B?blg1dmRIT2htSkNTcG4yRGNGN29hVHpQTHZlUDZhWkhxd1A0Rmp6SUEwNER3?=
 =?utf-8?B?cGpHalRqS0JnRWpYSnRiMWVIcnpBSlQxU2U0QUNwZkpLWmxuR0Y2N0JHajZv?=
 =?utf-8?B?UXpXbmI2U0xKTlZ2eXAwSGdrbGV4ZUdac3ZsRGxoLzB2UXhPT1gzSFUwMXdH?=
 =?utf-8?B?MGJrVFZxT2hFaUNwaytsV2xPU3lRMXB5aUg1NnExNTB3TG1GQi83YjFHcmYv?=
 =?utf-8?B?NlFHdENYTG9KYldTQmIxNkYxMGdzR2ZJRXRFNWdnUDNwWCtHZk5TbmRyd3Mv?=
 =?utf-8?B?ZFEvS1l3amFjdlV3cjF1c29ldFFHZHFjbVZ2RW1rQmlXMEpZRXNzU0RNVmFr?=
 =?utf-8?B?QUMyR0xKR05WblFCVVc2SmV4YWgyU3pLNGhVU05NWHE3VzRLZWxubCtDOUxM?=
 =?utf-8?B?S3BUZUtsclRnSXgxMWR4Mm11SDhFU0Z2WjZDbnB2VkZtWFRSNTBNczhqTjgz?=
 =?utf-8?B?NitkVVB0U3NWNThvS1hwSGl3UTYrWGh4UklPRHFCSEdtOEZ3M0FoNU42eUNT?=
 =?utf-8?B?Rkx0VE9RZ1lVS3FONHF6ZWpOMTE1ZlV1RjQ2M3Baa3U5bUM0UDVZNUJvbXMw?=
 =?utf-8?B?cmFtSUtXbU5mSjUxb2x0MXphdGZUcHN1eS9uTVdnbWJ0ZjR6bktBMmMwaTFm?=
 =?utf-8?B?NjF4RXRmeFA3dUFrWjJvSWM5MVBVWXE0MWd1SVFhSnVqSDZGbEZsWHZ3bVVl?=
 =?utf-8?B?L01oRUdUeDZYTlU4RnR4azBoRmVOalBkZG9tN2RuMXk0N0haYjdJWE1FMXlt?=
 =?utf-8?B?OXlnNDd1ajZ4SGQyMWxKRFVkZVFZMU0rcG9hNTZQUjE0M3QvL3RkdmZJS1VW?=
 =?utf-8?B?UmM1YTQzK3lPYkltNmhiU1pKQU8vclkvYkVsOUhFTmU3a29USitrOGZvQ3Qr?=
 =?utf-8?B?RHJlOUJ1Mlo0clpMN3RiZzFTY3Q4cmdvSEdhR0szcUJaUjVHQS9BQjM0VE41?=
 =?utf-8?B?UUY0TWZmbk1EMmJyd0pEcXBjR2U0aGsrb1BhOXhKNlllUGQ0RTRUelZaT083?=
 =?utf-8?B?aVRMZ08rN2FCZFJwZHRqMndUTU1RPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0222f454-67d7-4287-2e09-08d9a56e57ec
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 23:52:39.7043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7cYsNv09hODslUa9qSm7GMdhjyqfr6/QxJtkYvdpgyWdz55h5I3NNuHpj0zFrn2DOb0yIdzz0+mFrtIbxfvhD5hgYZEzLwybMZFUDA1gPtY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4938
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10165 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 bulkscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111110121
X-Proofpoint-ORIG-GUID: 87gtt0JB_oTHaNj4EaWDudfpUiCjpca_
X-Proofpoint-GUID: 87gtt0JB_oTHaNj4EaWDudfpUiCjpca_
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.2021 01:25, Sean Christopherson wrote:
> From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> 
> The current memslot code uses a (reverse gfn-ordered) memslot array for
> keeping track of them.
> 
> Because the memslot array that is currently in use cannot be modified
> every memslot management operation (create, delete, move, change flags)
> has to make a copy of the whole array so it has a scratch copy to work on.
> 
> Strictly speaking, however, it is only necessary to make copy of the
> memslot that is being modified, copying all the memslots currently present
> is just a limitation of the array-based memslot implementation.
> 
> Two memslot sets, however, are still needed so the VM continues to run
> on the currently active set while the requested operation is being
> performed on the second, currently inactive one.
> 
> In order to have two memslot sets, but only one copy of actual memslots
> it is necessary to split out the memslot data from the memslot sets.
> 
> The memslots themselves should be also kept independent of each other
> so they can be individually added or deleted.
> 
> These two memslot sets should normally point to the same set of
> memslots. They can, however, be desynchronized when performing a
> memslot management operation by replacing the memslot to be modified
> by its copy.  After the operation is complete, both memslot sets once
> again point to the same, common set of memslot data.
> 
> This commit implements the aforementioned idea.
> 
> For tracking of gfns an ordinary rbtree is used since memslots cannot
> overlap in the guest address space and so this data structure is
> sufficient for ensuring that lookups are done quickly.
> 
> The "last used slot" mini-caches (both per-slot set one and per-vCPU one),
> that keep track of the last found-by-gfn memslot, are still present in the
> new code.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/arm64/kvm/mmu.c                |   8 +-
>   arch/powerpc/kvm/book3s_64_mmu_hv.c |   4 +-
>   arch/powerpc/kvm/book3s_hv.c        |   3 +-
>   arch/powerpc/kvm/book3s_hv_nested.c |   4 +-
>   arch/powerpc/kvm/book3s_hv_uvmem.c  |  14 +-
>   arch/s390/kvm/kvm-s390.c            |  24 +-
>   arch/s390/kvm/kvm-s390.h            |   6 +-
>   arch/x86/kvm/debugfs.c              |   6 +-
>   arch/x86/kvm/mmu/mmu.c              |   8 +-
>   include/linux/kvm_host.h            | 141 +++--
>   virt/kvm/kvm_main.c                 | 809 ++++++++++++++--------------
>   11 files changed, 524 insertions(+), 503 deletions(-)
> 
(..)
> +/*
> + * Replace @old with @new in the inactive memslots.
> + *
> + * With NULL @old this simply adds @new.
> + * With NULL @new this simply removes @old.
> + *
> + * If @new is non-NULL its hva_node[slots_idx] range has to be set
> + * appropriately.
> + */
> +static void kvm_replace_memslot(struct kvm *kvm,
>   				struct kvm_memory_slot *old,
>   				struct kvm_memory_slot *new)
>   {
> -	/*
> -	 * Remove the old memslot from the hash list and interval tree, copying
> -	 * the node data would corrupt the structures.
> -	 */
> +	int as_id = kvm_memslots_get_as_id(old, new);
> +	struct kvm_memslots *slots = kvm_get_inactive_memslots(kvm, as_id);
> +	int idx = slots->node_idx;
> +
>   	if (old) {
> -		hash_del(&old->id_node);
> -		interval_tree_remove(&old->hva_node, &slots->hva_tree);
> +		hash_del(&old->id_node[idx]);
> +		interval_tree_remove(&old->hva_node[idx], &slots->hva_tree);
>   
> -		if (!new)
> +		if ((long)old == atomic_long_read(&slots->last_used_slot))
> +			atomic_long_set(&slots->last_used_slot, (long)new);

Open-coding cmpxchg() is way less readable than a direct call.

The open-coded version also compiles on x86 to multiple instructions with
a branch, instead of just a single instruction.

> +static void kvm_invalidate_memslot(struct kvm *kvm,
> +				   struct kvm_memory_slot *old,
> +				   struct kvm_memory_slot *working_slot)
> +{
> +	/*
> +	 * Mark the current slot INVALID.  As with all memslot modifications,
> +	 * this must be done on an unreachable slot to avoid modifying the
> +	 * current slot in the active tree.
> +	 */
> +	kvm_copy_memslot(working_slot, old);
> +	working_slot->flags |= KVM_MEMSLOT_INVALID;
> +	kvm_replace_memslot(kvm, old, working_slot);
> +
> +	/*
> +	 * Activate the slot that is now marked INVALID, but don't propagate
> +	 * the slot to the now inactive slots. The slot is either going to be
> +	 * deleted or recreated as a new slot.
> +	 */
> +	kvm_swap_active_memslots(kvm, old->as_id);
> +
> +	/*
> +	 * From this point no new shadow pages pointing to a deleted, or moved,
> +	 * memslot will be created.  Validation of sp->gfn happens in:
> +	 *	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
> +	 *	- kvm_is_visible_gfn (mmu_check_root)
> +	 */
> +	kvm_arch_flush_shadow_memslot(kvm, old);

This should flush the currently active slot (that is, "working_slot",
not "old") to not introduce a behavior change with respect to the existing
code.

That's also what the previous version of this patch set did.

Thanks,
Maciej
