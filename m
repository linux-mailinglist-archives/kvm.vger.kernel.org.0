Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8541B52D094
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 12:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236860AbiESKbu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 06:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237129AbiESKa5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 06:30:57 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2062f.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65166C8BCE;
        Thu, 19 May 2022 03:29:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=htKDKzwKBfkkrABzv3dmBZkGXer/OTfXmwB3Nf50+uZ39jHlwACjKKWaKlsWaJMuZDecMqf/iiRSrgS9MicnlgwItvQ5udI8AemSm40q8QJUcf8nIT7AzOzo4ht4tVB3t4pS51Djw7s72LSovgEpCGbP8SRO/PurFq3kFCB0tTJNgSNkxTB/SfK8FDQCpcZrJM7UMQjdRfPFDmI0e8aRsuR31gG8a8C7DUuCNes9v82Sh8mg+y18gCiVBHeltid+sDR+nzI4WUeMPDSIxXpUN1xahAMSYX5mJxP7tO4BRuWgLfSEDdESKSTENUcBSfwlcSoTEapQjgQTBvZSZKePXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E7xtrI65y/XnstcNqjo15Lv/mecDev8hTEr2s2bxrHs=;
 b=jMzPXIS3ps/42qAB5/BipMH8E/43gTXvwNaaZuIN+TxU1BiN4mZs4oCnkh1UoDUIF4xP3sZfKRkVDiKvRmEuGoUgn3plueqiiJLPO8MAc/jcd4cAvzHudVMu3KiwA3kQhkbz4hIut8hpj67aI2Qan3FvYObkHi3u7TvmlOGc2RW39B1+yyTABadiKVzttcCXhoi/A9BUorDx72RSBTzKBE2FJz5dk7iW8V7IvSwCbQdqrIEc4HaMA94HphHqGsV8zVKrwIbBw716jlHUvsoSxnY1q7Ph4lW2PZPrnd3rmCjD4ybRCGabp0cXDMSrUPHNes4jZxrTkhGV8JB42mVQwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E7xtrI65y/XnstcNqjo15Lv/mecDev8hTEr2s2bxrHs=;
 b=QBd4vGE18ij4tukAvewhnGdaCNK1Fr4pwDh/o68ntuN5HbBIQFfSXWqdMiMm/f7+GnpszF5YaxAMXwCjrDoz/qmNRmbvXHdRMdgbt4KE5hxD4k8BsTRNnLUeLBLCh6TDzN/8FS3xGD7mX9Bs35Wmlq6ACOnA6aKDzBWJx0K41jY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 MN2PR12MB4991.namprd12.prod.outlook.com (2603:10b6:208:a4::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.14; Thu, 19 May 2022 10:29:27 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::8c27:b470:84f9:82b8]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::8c27:b470:84f9:82b8%7]) with mapi id 15.20.5273.016; Thu, 19 May 2022
 10:29:27 +0000
Message-ID: <3a04387c-817c-6fb1-a16f-f5cb27895ea4@amd.com>
Date:   Thu, 19 May 2022 17:29:19 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH v5 16/17] KVM: x86: nSVM: always intercept x2apic msrs
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
 <20220518162652.100493-17-suravee.suthikulpanit@amd.com>
 <92fb7b8962e1da874dde2789f0d9c1f3887a63dc.camel@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
In-Reply-To: <92fb7b8962e1da874dde2789f0d9c1f3887a63dc.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR02CA0136.apcprd02.prod.outlook.com
 (2603:1096:202:16::20) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2337d74-eec4-42d4-3fd3-08da3982738e
X-MS-TrafficTypeDiagnostic: MN2PR12MB4991:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4991DC40975FA415C437E5A8F3D09@MN2PR12MB4991.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sCjr4zItCc1e8AOs82ewBYx858MS3mH9hSrJ2WKu8lXQukb+th3zsE1niYTsCVggC3ObaUKtNBpCJvhYRjEDCiGbLoRDqRLkVEBXKR3BJjpNuXPlcCa18HuyVpF59YtfCZD9wUi2dmLtw43EfoXSt/wFBR4qI5UJ8JKQoMlufJwPGLfIGjKiG7yCLcEcOS6ptz1kSCM33uhtaQqwZiUgC9o//II1fR6W2cPBktw418u5EM25/K1CMl90hW0ne0yjVKnFJzweGUrIoSsNgch6MgoFL2U51RKJaVonbrG1SLEuYZ//vOSG3srd0hF5k0yxI8S9/NrSGI4jXWxrrMpnlvxJU9XGAGNqEt++Cvuk9o1ySIOv6CL30KZZIcClOIRUbLuYXoS6aAyiIYb55Qd/bDCyrYb1+zde7DvuBke1LbyPWOJ0N3Un3Qi+jD5VjSTdXCW9VEj2X76XGJCix9N3mXKqCbxmC5gpHcJovEvv9YO9N0Ggg61HNap2/N6Y0mYbjNzG3JOoFwn+S9hD3e9+XyHbExlIRm/nSN8Lwv/AX1k7BgfSRYcvoRiFn7p64aceGdE6fM1Fo9Lj7nhzHDheHg/tbIiEJd5GW9/YIJliUrZN0Dk6zLjjfUYr743vu00EUQPVOpF0/ZuQR+3bIOpuece2LMzNbPRBeGuO9bb++eLCmuZOusFhauwbSLPCV72pvRrx4o5HyiF+W1GfuxZcaanNDoe5ZA9xKFAR9YNPRgY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(83380400001)(6486002)(508600001)(6666004)(6512007)(26005)(53546011)(6506007)(2616005)(186003)(31686004)(31696002)(316002)(86362001)(4326008)(8676002)(66946007)(66556008)(66476007)(44832011)(5660300002)(36756003)(38100700002)(4744005)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVFNN1RkUmxmVHltOW84bmdJNTdHQ2g2b0dRbjI0R2FKQStNaldHOWQ1WUhw?=
 =?utf-8?B?RkhERHc0REEycDVhUXhLSFR6ZUgyWkFpWlJXQU55RzFtSjFzMzJoUU93eTg2?=
 =?utf-8?B?WDEzZ0xsOVl2bnFVVCtRNXRWTlNxU3UzS3Y4c0podlVZKzJMTUNMRWYrT1pK?=
 =?utf-8?B?dXo5a1pBTSs2c2VGRDNnU0pQS0NXUHZjTG1WdW5Xb3pYQUJUeEd6MUFDdTVl?=
 =?utf-8?B?TUMyZ0JyWHdqS3BEbHMrKzVabFJvWDgvVVRabUgyQXhaRnFCc0JYVWd0Snp0?=
 =?utf-8?B?STNnWXcvSnZUai9mWEEwMHlLaTZMczc3bDhxYkhKdnEvNXFOZ1ZIVVlTUVFF?=
 =?utf-8?B?a0piVVZ6UVBMRE12NlpVbU1hR25CL1Z4cmRDSWVZbnJ4aFNwREx3YUZkajlN?=
 =?utf-8?B?R0lTNUp4K3Q5NStRZFkwVVhOdEpkWUUrQ2RVKzBycGFMWGdzN2F4V2tNYnlk?=
 =?utf-8?B?dlRpTTFMQXRaNnZQbkF2Z2k3M1REb2R2VThEMGQ1T216QXNBSXNrQmdwcDZz?=
 =?utf-8?B?MnVuazVKaVNWTEwxZCs3Rm9EK1k0SlVCZ25LWDFsakhFeHBoYjZ1ektnSmNt?=
 =?utf-8?B?Qm9wQlhuZzhxY1c1azVydW84ZkhsS283VnlxYVJCT2FIaExiK0dpMjE0eHZG?=
 =?utf-8?B?YVZyVTFkY2FhOTdtRE1uSi84S3NKV2NyeHEyekNEVzdld1FmMXNEQTliK2d4?=
 =?utf-8?B?SDFLR2RudmhsdUgwVjlQZ0lkdGlrRkhTVDFkN0w4aldnTnpaVGQvK1BpdXB0?=
 =?utf-8?B?Y05LdjVqK3lyeGtpdHdPSm1kdzdQb1I2YjNUUmx5bzdvazBNOWY4RForVHhn?=
 =?utf-8?B?cWhxTVJORVo4QmF5QmF1WFlmcTRvMjAxWGlhVDFOc3B2RTQ2UWFQMHV0d2Qw?=
 =?utf-8?B?cHlZQkZqT1IvWWRZMFlCbll5bUlLWElZWU5ib003ck15bGhicVQya1BkVjlG?=
 =?utf-8?B?aXBIc2dXbFZpempzbk1oRkhzcUpTampndTVFQkFWNE1GUDNEbXlmU0ZDR3hz?=
 =?utf-8?B?THRLY3FBRmpSdURwL3hQWGlWR3hrUVRMcE53a0lobmxXWnFVWVpVZjRxRWNs?=
 =?utf-8?B?SDFUMkkzV3R6QWJueWkyRW50WitvUVhSVnZ3QVdQeWxrZUVVODNMQ2xyTlBi?=
 =?utf-8?B?OFg4TDlvTkZIMVRJR2tHT05LenVDa3U3TjdGMDY4YzNUNVFZbEw5ZHBpUFAx?=
 =?utf-8?B?c3N1bmlXYk1NY3N6ZlZwZEZqT1FmSlVBYWFNdDAxTS91WnZmZ1ZKSjFOaFdn?=
 =?utf-8?B?LzdvSHlEMUxtcDh2VlZsaWxVd3kxam9GWjl3S242djJNektNMy9mVlBLelpl?=
 =?utf-8?B?RVlIVTFHSDc3WXo4UVVHekxuajJSWjhZNlBvN1hzdFBJK3V4SnJEejZCbDVX?=
 =?utf-8?B?RUFXa1dZTXdmSkRpTEZJYW9yOFJIMVBqMVdSbEo0R0trR0JHamZhUEZrdE1W?=
 =?utf-8?B?Z2VWek85V3hnOUFVN2ZtNDJkMnJ4TXNYSmhmWlBaa2o2VjdhUjhGbHNIUWE1?=
 =?utf-8?B?UU8xVHg3YnU0Q0tCU2V5OHJIb1daZENYM28zeHFweUpEKzkzT1lXU3Y1MXdn?=
 =?utf-8?B?R2xTaW9zOVphK0NnUlpUT0U0ZUpPMXQ4V3pGMW5GU0pNZ2E1ZUFBM21GaENF?=
 =?utf-8?B?SlVDOW4rRXhnTEdEWEhaenBzOFd2aWF0bi84MEs1VUhFdUovTmdWWmdvNmRG?=
 =?utf-8?B?UHhhK2xWNGYvUkphL0Fwa042UVNXQkVDRU94bHJmRzNsc2RGZ1pQK0gyeHo5?=
 =?utf-8?B?NlQyMVAxKzArUi9uYXpCSTVZa1NjSmNuNUJ3WVU0WUhrYTExR09tdGk2SzIx?=
 =?utf-8?B?VEh0dmxyOFhUaHZISTVRb29Felh5blI3SXBxYm45bThkYjdzY3EydFhTK3RU?=
 =?utf-8?B?ajdHUHRSbkhYSE9VeXVNcUlrMXQ2QzBxRTQ0Q3VZMFQ3RHB6TlBSRDFoM3Qy?=
 =?utf-8?B?Nm5LYjNrSWVHcGxySVQrajFQKzJGcFlJL05lcFhWa25qVnE5U2hiZGhDS2Zx?=
 =?utf-8?B?RDQyMWJ2Nk5tQTA2T25aSE5EZDJYTWhPUWYrdS82OTYxT3IyQ25xbmxkQUJv?=
 =?utf-8?B?RHM2UUJmYzZwQitrRk56UG5PdDJXcG5OOWhWWlpacHJkai90QnQybEJDQ2lM?=
 =?utf-8?B?dEE5ckt2UE9IVEJzS2ZrSFdMcU9TS2ZjbWNOL3hTV1E4OFk3V0lOMW9hbDFT?=
 =?utf-8?B?SUQxd3pCK3BEUmRNK1lYQmdwR0IyVXFIZitIYVhGMGZ0eXNzcnNOYmNKbEdM?=
 =?utf-8?B?V0hEQWU5SzBNWWEvbkR6eFRXTC96b09UZ2Z3OStFL1F5bk1ScGNodGxTOUpY?=
 =?utf-8?B?dWNwRS9uUGYvMXZoaE9mWDBuYmlmRzhrbDBUcDQ2RVV4K0RCZTgxUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2337d74-eec4-42d4-3fd3-08da3982738e
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 10:29:27.6861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2R3FFYRmrxTDQnR1NUqiYITiTl3yJlBsSCL1Zrqicac57kF6k6QxHUeJCCoebWqMs2Z0gMounUhoGEL4sg5d2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4991
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/19/22 12:18 AM, Maxim Levitsky wrote:
> On Wed, 2022-05-18 at 11:26 -0500, Suravee Suthikulpanit wrote:
>> From: Maxim Levitsky <mlevitsk@redhat.com>
> ...
> > Just one thing, this patch should be earlier in the series (or even first one),
> to avoid having a commit window where the problem exists, where malicious
> L1 can get access to L0's apic msrs this way.
> 

I have sent out v6, which re-order the patch 16 to be before patch 10 per your suggestion.

Thanks,
Suravee
