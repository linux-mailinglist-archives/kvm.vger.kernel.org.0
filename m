Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA1474328A
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 04:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbjF3CI2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 22:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbjF3CIY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 22:08:24 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5B435A6;
        Thu, 29 Jun 2023 19:08:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LLIq1MbjT4WQKQdryHHGPNa0pbhFo0YZ+EBT0GwpPtBX4z6r0nJPOW1Cdd7fYChowAoRy6DYZ706JtGHJaHF/5d/KyaUTK9J+WvO57rcyx4lEmrav2C0wYoDCymCWRDjR9NS8OLlvBIhDSyITlKbnd/eGWvKjjHk0ulkWLH15UiVvvx0IsyyTXJz5XI1/zz5rEu9o6AsrLejB55ShfsnCXr4wTONSnd2g+BZLY5nCXmtlayxLRwqu12I6jBME/M5w1TytameyqVQFEMuAOQdUaGo0t82giVXeX/2kxFDdBHKCNtl0OhkGiluLoo1xdOx1FDDJIz89+YhC4RqXRLayw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l0PkVR79Vk5YAJXni/8C21MeD4nfRGNHVZ3tHA7dJGc=;
 b=Af4fB5JUFOiRspEh9wKl6HD9F2ZgEmg+qO3Dc2fA+Z3VvR/JStAL/p82Ad1E8UVd1V5XjNFW2PXQeFoItcWtyVOj1/OTvux0D6998EpCpG3+djwV8Ate1SdPBgBNLmwg79QNo88ECBkywzSEEJ2rYlhh6qx8FyqRFivIe+GKxrsKljRiJjGhd1Ih4MAlBnr03Z9TvH+jOG7ZbcnWhQJq8heKV2pTyhAdU3PvRtDjM5t7o/Oo6bhw0dy/H0GBJXG/mMF96TbhWYkzPP5P15uvvZMh29O2t6uvOTcg6zN7XnJH21ZSFOuTc/7vhgPqTeKnHzdlvhx0eSjFSerN8vvL9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l0PkVR79Vk5YAJXni/8C21MeD4nfRGNHVZ3tHA7dJGc=;
 b=k/02jlAI1jt0OKAPEPhZgamNnVr/josW9nHVzP4p9mCkmwlPTiu1kYh5ATjgLGaXslU6fvSYEHu/OdKklXLrxkntHS8eGkIgxmEF1aR9rGJON+QyL7zhWeNZRuR8rqL8MkyvL/u23eGbsIPyVdths0flwqH9FrZUFm+VBFRlZco=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 CH3PR12MB8581.namprd12.prod.outlook.com (2603:10b6:610:15d::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6521.24; Fri, 30 Jun 2023 02:08:13 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::ff22:cffa:293:5cef]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::ff22:cffa:293:5cef%3]) with mapi id 15.20.6521.024; Fri, 30 Jun 2023
 02:08:13 +0000
Message-ID: <4338da4e-300b-12f9-609e-d4b1d69eda0b@amd.com>
Date:   Fri, 30 Jun 2023 12:08:04 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH kernel 0/9 v6] KVM: SEV: Enable AMD SEV-ES DebugSwap
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20230615063757.3039121-1-aik@amd.com>
 <a209f165-b9ae-a0b3-743c-9711f5123855@amd.com>
 <6c5d1e74-0f6d-7c9d-c4e7-a42342ca60aa@amd.com> <ZJWqBO6mPTWyMgMj@google.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <ZJWqBO6mPTWyMgMj@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY4P282CA0008.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:a0::18) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|CH3PR12MB8581:EE_
X-MS-Office365-Filtering-Correlation-Id: 35850acf-9bcc-44f2-7f72-08db790edc19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z7P/2rmEmi8shoa9SujkDeh5capyOWCE2B9IfeVieT6DTqnE6G3gbEbSlD/b7Ms3DfIWcRLahg1w4rTKVnHi2kTmIZA35M6S8/YNrTMCXymmNRUEyDc4pj9SIZpf7zI30vDdtMFTkOMRIQtpYW59Gva8mWxN0ulC5NvV5BzXNRvtOrtW4eUzf79IPQdvm8HS7MJjApwhdarYXotLVfZ/7nGhdu755IFswZ0UGpAY4xOzt+qX+RZuVTLavcAr/Xf/KmpSZSunDPnMEDUSOQNVybZrrCIGLIo9owjLMc7qI1y8mugMVGE3EJJz+h95A02xGD6eyCxhBud6z6zHsNRcyG8mFwygSMJQFHYbVTF8B6ZfxNgvjyKTL+KDIOuDNMTc1z4ddISywbzygks9ASvF5QLx/Q7QJCVROLyx5IRMFpp9mE4sxmoQ9l2l/hB8OcUw7bkyHKsVFiKP3kOv2IqLzSAtntzo7btF30Fyw28af/MFAhgv3xEHxZVAv5KcPKOfh9E6P9VjA5otBllmEnS9zIptGuy1/qJFxpwIS5bwa77TKEG8S+pWpHaDVqL27kpAmjj4+ugdSAQNVRqthdtLutb/fxohyoj5lwX2clbJ027HqvREUT9DbD3eXtyRkFT3xUVsZBkOW09zpot9y24xhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199021)(31686004)(6666004)(6512007)(186003)(26005)(6506007)(53546011)(6486002)(478600001)(2616005)(2906002)(31696002)(4744005)(83380400001)(4326008)(6916009)(66556008)(66946007)(66476007)(8676002)(5660300002)(8936002)(38100700002)(316002)(41300700001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VUlJVkpBSGIrQjFWb1ZzS3BuNXNvQmhaV3VtNjdScG9XYVpwNVpPN0dYSXQr?=
 =?utf-8?B?TGJ1S05rNDZyQXgvYXVFTnV2S09OcGxyYTZyK0hMOGVtaGE5bVU4RTBOa044?=
 =?utf-8?B?dDQ2ZGFUbng1WWVCZXFSWC85NEdqc1FQdE5WNXZSdlRoYmh5S0pZMUhKRDJM?=
 =?utf-8?B?U2JqWWVRa0E1SE9HL1RZeHVOVzVUTlFxMUtMUkRNWFBlMXM1cVBqZEhhMUdC?=
 =?utf-8?B?R0JwTVFIVU1jZEJRSDkwT21wa0ppWjdxcURCcFJuSmJGWHFoSXcyRVhJcS9N?=
 =?utf-8?B?YUtkWDNKRW4rN2NabC84N2g0UmhqSXA4MmJ1UzNJVnFqSEptWFFyR3RlTnJ2?=
 =?utf-8?B?VW0xM3dSekpLNHIxaFBDRTE4ZE9rMlpIQkRUL3hjR1pQcUM1QjhFR0NWUW5x?=
 =?utf-8?B?YWEzVnJ2SWVsM2JCQzBTMnlpbldLdHhGSUl3Z1d5UGNXbURvaGcvNks5LzlX?=
 =?utf-8?B?ZElUL2lHUnpwQU9HblN1aGJoMFVFSVh5RHBjdklTcHpOSENvOS9ScjBKdkMy?=
 =?utf-8?B?eWhubnJUZ1MwMlMvV0JDdk9DOWpValdIV1YrWUNVbyt5SkgzTmVHSWkxbUc0?=
 =?utf-8?B?YWl4RVozQjZNWmdDL0RzVFFyME11bUpyemwvZS9Ed0cvRFJtbGoxS0JrV1hn?=
 =?utf-8?B?cENvODMvY3lsYUlUN1hraUpwa0QzTWlVZ2FXcVBHMzU4UFdtd1FaWGplMERj?=
 =?utf-8?B?OWhOejlzMjREa2RFWDdLcG5Da3loWFRiYnIyQTdKMzhkeTEzeUpJOHZGbU1i?=
 =?utf-8?B?UHB2d2lnMmcvcDN4UktGbnBqdDNuMVk5dWFCNXVxTjJJWjhvZ1pmQnNIVFcr?=
 =?utf-8?B?aURzY1B5ZzYyNng5TjBkQlN1a0dWeUV1UVJWMnJMZzVYa085cjNMbWpWNFJj?=
 =?utf-8?B?V0pCa1Nha0xNalVycXJOakNaWm9jcTZyTWpFZ0xPVERKSGw5ZTFKMEZqR1hn?=
 =?utf-8?B?cENpOTFUajJ1UkUvbUI2VW92VlFPOXpkakhvQ2R0WkZPWHorV3VTL1Y4OXFm?=
 =?utf-8?B?b3pIK0w1czY4aElQenJYR0h4Yll0ZHR3Q1RxUXNITUFJWWVJczB3VVlVUnZV?=
 =?utf-8?B?Q3dKNFV3VmdSeklSU3J1ZGNsbUJ1Z1FHeUFmN1M5MkJwT0FRTnRFZ2oyMnUr?=
 =?utf-8?B?MTdRWUUwK29nYStPRHdoM0U2RHFneGg0R3hqOVJ2QVlzaHEwRkE1Zkp1TmZE?=
 =?utf-8?B?S3dtdUY5bWQ4Um02QUhrbFY4TTJpUkhhVlQ3S0tGUXV0alZtbXNDSmpwMjhM?=
 =?utf-8?B?ek9sOFZGL0pmbFpvZnBSSE5kNEwxSy9IYjlab0NJMHV3SUJOYStTNVRpWVVn?=
 =?utf-8?B?M1NVS1JqcitVQU1xSERacHVmSWVMVHZOZmNUdDR4QUJCR3o4QVRyRUl2MWdS?=
 =?utf-8?B?WWFQYi9uTzlObW5rcGZ0QjBXbkNpYW93K1JHcGlwa3BEZUZMSmFsamYzMGRI?=
 =?utf-8?B?aTBaRXVrLzdQeWZ6WXZiaTVmbm9ZYnJvSGNxNjREcUdrSGVrajc5VzRCMDJr?=
 =?utf-8?B?ZWh4ZzcvaThEbjB3ZEl5SzM3aWFydVVEbkVsVGNRUitnQ3BXbEozalJvRVc1?=
 =?utf-8?B?c2ZubDZrTGN0MkhJc2JXVzVubENrZGJvajdGZTRaYkJET2o2ZDJ0NWg0Y0RZ?=
 =?utf-8?B?aTBFSFU2TG5ld1pnM0RyMlR0MlZUbGc5Q3pMWW1YdGQyRi84clBlczkydmdN?=
 =?utf-8?B?dnREL0g0OFQvZldQUWpUNTE4OFR2aitHR3kybm1XcTkxRXhEd252WEFjVkI0?=
 =?utf-8?B?ZjZ1US9CQXh5RC95YU5adUNYd28vVkxXcnMrSGtNOExxN0c1ZFk4TGxNbXpO?=
 =?utf-8?B?Z3hwWGRMSDBuM0Y2TTc0N2JoWWtvaE1uUkUwdEdNTWJYc016UGt5QzJieDQ2?=
 =?utf-8?B?ek1EZ0VTNGdlMWdISVpSRTVhSmVPMnJicmFYUXYwendjUk56RzFXcDNzS05P?=
 =?utf-8?B?eXNEbjNFUm9TRGtjQ0hqMkdFTXl2MzNXYmZWUTlmbklEdUs0ZjEyNTQrS3dF?=
 =?utf-8?B?TkZVOFAyYjNaSExZaTJQRWExOGpBK3FMY1ZLa0o3dVlQaFg4eFdqNU5DQ1o1?=
 =?utf-8?B?QWFsazVldEM4cHFLM3QxQ1J0Qk5yYzFnNmEyYWJBUG51dUhnRlFtR0Y1NS8z?=
 =?utf-8?Q?OPEqbIZeWION8wnrmsCYeEozd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35850acf-9bcc-44f2-7f72-08db790edc19
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2023 02:08:13.6381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XMWYomSmYHOOHPiv3aOVVDSCu0FXGGW51PSD2eBAozCi5Eiq5gA8N4uBYP/nv3rapYzR7Noa88CnWeRm4Tv5bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8581
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 24/6/23 00:19, Sean Christopherson wrote:
> On Fri, Jun 23, 2023, Alexey Kardashevskiy wrote:
>> Sean, do you want me to repost with "v6" in all patches or this will do?
> 
> No need on my end.

Cool. My colleagues are gently asking if this is any closer to getting 
pulled or not just yet? :) Thanks,

-- 
Alexey
