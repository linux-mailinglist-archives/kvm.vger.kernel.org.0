Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD6C52E323
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 05:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344869AbiETDbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 23:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiETDa7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 23:30:59 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C43A167FE
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 20:30:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EM+hPo+Akb+EW7GV44Ln4NQt9TtrAcBImmoll2I0wiDTd4tZxYA0YpMwhzLIb7KvrpB57QcLkuYFlYxSmBqkMj0X8yASzpjxAdwd+29V+cpLNwb+0sRYlWPTvHqBokfBuqoliWyT6bqEXsacDRtBJeTUrt3d7lrj9m9o4q2IygE1IGCmyPFcLYJxbRH2amke/wbP6/z7XZS3AL6esZtwmrbJYcuJ2nJoFbCrFgMKkjHkD15qe5qGobUgGFH8ulYm8ljPO6yqVqLjvX/DtmMxIaNcqt6QLgIctRCalVz3vmNj7QhCHcLOmDWSc2KDkwYj6nMhvo14lLPY1B0qYT2Asg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q/WklhcN2+QnaZEE5vKxvMbHsBV1Rk/N0sC5gtIV1/8=;
 b=hPmR1cLBXm39wzP7eFsjB84soCbyvHBRXmOG1fWF0ln/TcbMC1tW+eliGAtCyv1DIac6DR6GOvjyDktlMkT2C1Cxx3PG62nTZnUdHubyQlYMkHX3lw2cLHcCBbbSrvJ/3py59F02Bu+r1v2egyR9Hqg+qu7TDEFOkB5KtVqGzyaqHRuc7N7mJvIPtOTAL8e5thZ5v+19ckHhEYpa3n6s5VqcENMhFh4e/AufPyxtwrEQzfRKPp/ILVVEbKFt+lEdqfNB7WVdOrA43Ckb/agKZIbW4yN18KV1dJkyQFOK3CRXTXjzcs6nt8Y/gyEPWl59msiV6gZ9v41hpWuJ1ikAng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q/WklhcN2+QnaZEE5vKxvMbHsBV1Rk/N0sC5gtIV1/8=;
 b=j2s7C2+i3B7Q59e8jtsojjJQZ+3GOHOWiCTqwNj1pTL2csGrUZPctb2DlzWmKgqL4LB2g99N2IlQtvBzihQlIQsYNzghJYiGSW6x9VP/iH0mWDKizDoPdQ0eNjiM40AZWf1A1Sv/K1YpS2Yy/mLTwLcRGpXKHzzlr6o1DrzPiXs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 BYAPR12MB4696.namprd12.prod.outlook.com (2603:10b6:a03:9d::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.15; Fri, 20 May 2022 03:30:52 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::8c27:b470:84f9:82b8]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::8c27:b470:84f9:82b8%7]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 03:30:52 +0000
Message-ID: <7e0d22fa-b9b0-ad1a-3a37-a450ec5d73e8@amd.com>
Date:   Fri, 20 May 2022 10:30:40 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
Subject: [RFC] KVM / QEMU: Introduce Interface for Querying APICv Info
To:     qemu-devel@nongnu.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        mst@redhat.com, "Grimm, Jon" <jon.grimm@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        Wei Huang <wei.huang2@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0105.apcprd02.prod.outlook.com
 (2603:1096:4:92::21) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90f6b351-aa4d-444d-f2f4-08da3a112438
X-MS-TrafficTypeDiagnostic: BYAPR12MB4696:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB4696FA367B57C72AADD33256F3D39@BYAPR12MB4696.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w4G87EhZ6Qu/uqItxzh9U5aQXIry5lKmg0eSUOuRZypj3lEiHmUJL7VTxi+p/SXH44brtp7zVSEooAKg2Ec2LZLyXgk7CRcHvrfHLm0xob3wgL7VK7gt3kG9f45t2yVamiZ9zRolJaA5VYBU+5TOwlRvmcWcQ86GslqFgQitbs5D4shoPcn7af++7E8Uzwyd0p1voPe+RWsPxC2yl9NuzzBpulaj/zoxyRALigN6xV/IWtVEE7CADQCNab/q4un7084MWDa0aNszRq9y0zxqztzgqtrwniFDB9yuREe0JxSI7HbEJgpAcPtHyPPZVndUcVKeXtSw1K5hLOoX9x6FQEh+ULDJmpdTskKEACmoRc4yLAZbdMa9MfesOzrVbwlOi/fmZtfK5qJf0dKg07vEkGcge1HtoEF/qjfwK2t97Ri1O0LJrfDylhfEUPk3xekgxX0xE0n0EW8PiGbkZmRjrI+Fq3VXokavQtsmrHG/dQoXlmdFaXG04DFlBR7FNO9f6LxY/ctWXQnViHRDHtpKm8UdAYZDolByQV/k8z1C3FSDWiHkpXd9gXIL3qzPX/AEKBuBFv0BRa320LdWLlqeJmHhfpQsNe9lRyaTFism1Ar8QJxupvLeGcIdHOnk9ARY/cmH7ZZV6Cs5k5BcWCuOcxjqSvrlx1LvMfcOEN2HraVxRt1vphZgC3KWGQbkboNjXnRPaJrZ0Ruk7u51P7zVN6+bj8AmsudHwYzXxa0Dt3ve/MtiWFgRUOJE84z+yKmp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(38100700002)(6506007)(2906002)(186003)(6512007)(26005)(2616005)(4326008)(66476007)(8676002)(6486002)(508600001)(86362001)(54906003)(6916009)(66556008)(31696002)(316002)(36756003)(66946007)(5660300002)(8936002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?anhUZVFabmlsTWFDTEVJS3BKQ0FJbElJSk5kN0tHS1drRDYybWdLcGU4akU5?=
 =?utf-8?B?OVlvc3JlckprZWZSWVZRVEE3em1MUm9PdHlvTERVaXhaaDBrZmFmMFY1ektL?=
 =?utf-8?B?ZDNXRDZjZ0ZXOWVUUHQvenJ4K2w3bG9FZXcrSFFjcWt4eEx6M2ZDQytOWDRE?=
 =?utf-8?B?V1F3OW0vM1hjR0RhS0FHVitQRml3SVRTY2IrWEwzNE1RaFk0cW85b2ZhS0N2?=
 =?utf-8?B?cDdFZ0treTRFSkp5V25aMjlPMzViSm0zVmRNQXRaY3NtRFR3RHBjY1Rhc1Aw?=
 =?utf-8?B?TnRkRUxEYm1TTjVKU2UrQ3BjL0ZQdFJ0VVg5VHZUbU12aTFmeCtHa3ZhVnZu?=
 =?utf-8?B?UDdWUi9pbDQ5c3JkczFYbXRXY3JCWEt4cTljSlRyODJBN1IwekNFVWc0NERz?=
 =?utf-8?B?S0pmaVdKa0QwRlBCekpoSnZib05LYlFGVld1OC93VWZjWTdJWHE0MHZrYk10?=
 =?utf-8?B?clcwK3M4cnNaSTZCZ01nWWNnNUI0MFBhSUN0SVVHbmFMTGZNSWFPTTFMbTNL?=
 =?utf-8?B?SVF4enlCRjNmS3NQZmtaaW02V2xBb2pscEJEeHRQaGxRQ0t0WGR4UXJwakhF?=
 =?utf-8?B?akZMQ2NqcGJJRjV5VW5HTGtCbDBBRzVlQU5PcDdJbVBCaGF2ZzNQQ3ZIazNv?=
 =?utf-8?B?WCtQVkJ4YlJqRnR4TW1heW1vNUxOMFJtalVaR0ZoOFBseWo2a3Z2TlFIN0hZ?=
 =?utf-8?B?TDZWbG43R1NuNk4zeEdJZW93cUdLdmhvNUNLK0lKaWFlSGR4UWxXb2hrYkFM?=
 =?utf-8?B?cUpmVUtrbkNFVElESGZaTW5abjZJZUJvMzhQV3p5cjBQamc3enJ0VGhKcDA5?=
 =?utf-8?B?TzNCUlRVREV4OTVYNE1YN2JKRVVwMUZ1OUZ3enNBckt3YTRXRU1UeUZjWFQr?=
 =?utf-8?B?UXRZcWNYR1NHN0NOaDVraS9xMGl5SUI4T3ZqeitwYThBUmZ0cVpPcDhjOW0r?=
 =?utf-8?B?Q2dUNWZmSVpyL2UwRTgwRUxlK211MFJuWHlzUE5weUlMd2pvNFM5VE1oZGFH?=
 =?utf-8?B?RE9tQjdLMFhMTDNtcDBadnN3ZEtrdnlXdWsyaGhoVnovemlHOG1JRVdMYjdm?=
 =?utf-8?B?QkhHK1M5THJaclVDUFN6SmVpelFnQlYvV25FTGNoYlRkYkpuS2IrR3dMeFZV?=
 =?utf-8?B?SWl2YndzVlg3N2RZSWVjQU9YVndWMnhBTmtFTTJXYVhSbUdqdTE5U3JQT1lK?=
 =?utf-8?B?SFhxN05wcFZUVStjV3djenRhY0VpcjNCc0xHblZHdkY1eVZja3NEOGs0YWdW?=
 =?utf-8?B?VEpzY0NUWm5VZjg4cWpJRXN5NUFrUjhPZjVBRnd6QlZEKyt3dFJwTEtjVDF2?=
 =?utf-8?B?VUFGU3cxb0RtWmdBZ2dLYlRaUHczZ2F2SkMyd3pmdDBwaU14NUp4S1cwSHBM?=
 =?utf-8?B?c0k5WWdIbnhobXk3UUd1U3JMMVZUazUvNnd2ZDVzV0xQVW12c2hqODJwMFdu?=
 =?utf-8?B?V29HUmJLbTJkSTYra3BQSGMyeWNVeXlUUXF4UjJya3liL3BWWnJ0YkN3SEha?=
 =?utf-8?B?cUFyZ3hXWXd6SktHWnNHckNnbEFrS3JpaUtTdjZuMlRVQWpRRWNtTWZVT0lh?=
 =?utf-8?B?RzNuSHQ4dnIxdUovRldqQmtaVUlkRE45cnJzTTJYWFl3MERwZFcyOFlBRGhV?=
 =?utf-8?B?T29sTmZ0Nk96UkJCTDdXTkdpNm9HNk9hTHpuK3ZNYlZudnQxWWh1REFsZStx?=
 =?utf-8?B?Y0VRNWNtVGpNMEFyRWpHR2xMcmhmV2llb1h0K0ozNXd3RjhBR25TVEpIZnZO?=
 =?utf-8?B?LzN3aUNXaUFVZjE3WU9hQW9uKzhJVWZpL25Sb3laaHM1NUtHaGxCSmx2Q2JE?=
 =?utf-8?B?OHY3eUtlZXVSRkliS2h1Q1Evc3RRQXBCSndaZWpZVUhBZmlkRGpSczlTRjI1?=
 =?utf-8?B?TlJRS0RjVk11bmZlMEFCT1NsY2ZodWllWlZTS3NGdEEyZzhDdnY0aGs5UGNL?=
 =?utf-8?B?dEoyUC9zRDNWQjk0ZnUydk5JTklEd1VhRi9GTUxqSVViZ1ZOVTBBbXE1Umtw?=
 =?utf-8?B?L2NWeFZ1bnIwbzVZQnd3Sm93NFA5dWZJSjZnNUZyVUJtWWdNQ3hEUlprZjA1?=
 =?utf-8?B?Vk5vY2ExelNvWElaVlJLVTc5V2tBMWZSRCs2Uk9QekJld0hHNE00Z25xOGNY?=
 =?utf-8?B?MHpZNW16bS9iVE8zNGpwdEV2dHIxdjVOdDJ4aWdGNjFOVDRKYVQ3R1g1OXBZ?=
 =?utf-8?B?aE95V0JOblNIVU9IZXZMTUs1eW9DWmtBb2FROWpwVHdHd3pmN2NQSnBxTHFo?=
 =?utf-8?B?QkdTK3ZBQUpzK1Zxa3JQSlR3MVl5Ukg2Rm90ckhySEJrNmVhQ1Yxbk01WUw2?=
 =?utf-8?B?RGtwSURSVFd0eG5LcTJXUVFrMWY3aEp4V0htdWtEZ29Qc213Rm85Zz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90f6b351-aa4d-444d-f2f4-08da3a112438
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 03:30:52.6506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IA/zhc6jrnrtqKHGDr/Qw/RIEowRrESDGb9sAwOxc27rDfiRZbKfpPREjYuTGeGxN+SBUXvl1Mi4vUiMbwYrXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4696
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi All,

Currently, we don't have a good way to check whether APICV is active on a VM.
Normally, For AMD SVM AVIC, users either have to check for trace point, or using
"perf kvm stat live" to catch AVIC-related #VMEXIT.

For KVM, I would like to propose introducing a new IOCTL interface (i.e. KVM_GET_APICV_INFO),
where user-space tools (e.g. QEMU monitor) can query run-time information of APICv for VM and vCPUs
such as APICv inhibit reason flags.

For QEMU, we can leverage the "info lapic" command, and append the APICV information after
all LAPIC register information:

For example:

----- Begin Snippet -----
(qemu) info lapic 0
dumping local APIC state for CPU 0

LVT0     0x00010700 active-hi edge  masked                      ExtINT (vec 0)
LVT1     0x00000400 active-hi edge                              NMI
LVTPC    0x00010000 active-hi edge  masked                      Fixed  (vec 0)
LVTERR   0x000000fe active-hi edge                              Fixed  (vec 254)
LVTTHMR  0x00010000 active-hi edge  masked                      Fixed  (vec 0)
LVTT     0x000400ee active-hi edge                 tsc-deadline Fixed  (vec 238)
Timer    DCR=0x0 (divide by 2) initial_count = 0 current_count = 0
SPIV     0x000001ff APIC enabled, focus=off, spurious vec 255
ICR      0x000000fd physical edge de-assert no-shorthand
ICR2     0x00000005 cpu 5 (X2APIC ID)
ESR      0x00000000
ISR      (none)
IRR      (none)

APR 0x00 TPR 0x00 DFR 0x0f LDR 0x00PPR 0x00

APICV   vm inhibit: 0x10 <-- HERE
APICV vcpu inhibit: 0 <-- HERE

------ End Snippet ------

Otherwise, we can have APICv-specific info command (e.g. info apicv).

Any suggestions are much appreciated.

Best Regards,
Suravee
