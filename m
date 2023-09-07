Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7610A79753E
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 17:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235028AbjIGPrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 11:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245116AbjIGP3P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 11:29:15 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20611.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::611])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963401BF3
        for <kvm@vger.kernel.org>; Thu,  7 Sep 2023 08:28:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UertFvhdCLVSyitG/UHesJ8tUp2HWNdmBQFcwI35eG3CBw+gc4IXzsSQfidmSi+G98kgp1WA2rl/qKVD/eU0Q1Ny3itoahX2ovx0F/av943hHv2yP/94SfoMS6kIlegWHT+vq4WLpVsxI7g8sIquTIAt00AsNF7o/igwRsIG9J7LLlmcYM0WuUdjKm2yMVhAStepxyKSOgHoAJ2XSmTm+6XLlpg6NsRjkVwmn0tvOU5usCC6BGHvtrk8Td4IXjcZRRpUKRh25IhtIUACkGR0q/FcsFFYtoan28m9J92kII8IlNr1lYxTo/kO89LnRMfWI70OoN1ZWGgjWk/2YyfprQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HF57vorCQbKt/NWp5/25prdYVR4NUurlk8mCilezb2M=;
 b=mZvgOuB0/4A2MnkJ5cQLooLKvFbhq60Xnj3h8G0j2ZfOFaKSvmQcQqFPWn++FEll8jT5Ow9YkafEnGMhgrgn7Z/GaiIsfJ8GWT07dCSpUJiPLvCUscrpN04Z22XCDtqtKXJOgs9LnboB6Bdzcpcs/mUMyLwNpY5WKlDRTpraULUy/a+DLqFFXqqd/6+RdPGfcCUQy8HuvKKfpMS4Zz5yhmrwBXSIvbUsVn68iGecOhB7TCUA+be/zo9feBoEPA+NFHgN2fzb4LfN+67VeWFz+qOCemOQkYsQ1ioStF2ZkKghXmLp8rv4+I6xakX48oUMFn2h9U/ap6vKxBbb8BPP8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HF57vorCQbKt/NWp5/25prdYVR4NUurlk8mCilezb2M=;
 b=Zi7enVXnEO8mYetR6Mz2+QsA2Koc6WMKmC2wjlq42kpxFPaUYbqjiQJTtfuoL6uKbYih8Mj39d+DmMzQH5FdNxAPCd0F13YI+guYtx+MrxdOUNVH9Wwmy0RsW/UXXz3dUhF/Lu+LIr0y/7LOGbvn4+mijnvxdijnw/D4y9hkNcw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 SJ2PR12MB8184.namprd12.prod.outlook.com (2603:10b6:a03:4f2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34; Thu, 7 Sep
 2023 09:56:02 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::12ec:a62b:b286:d309]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::12ec:a62b:b286:d309%7]) with mapi id 15.20.6768.029; Thu, 7 Sep 2023
 09:56:01 +0000
Message-ID: <d230d9f5-53bd-8ea1-d4c7-717b0e8be9b9@amd.com>
Date:   Thu, 7 Sep 2023 16:55:52 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH] iommu/amd: remove amd_iommu_snp_enable
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>, Christoph Hellwig <hch@lst.de>
Cc:     Kim Phillips <kim.phillips@amd.com>, joro@8bytes.org,
        iommu@lists.linux.dev, Michael Roth <michael.roth@amd.com>,
        "Kalra, Ashish" <Ashish.Kalra@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        linux-coco@lists.linux.dev
References: <20230831123107.280998-1-hch@lst.de>
 <d33f6abe-5de1-fdba-6a69-51bcbf568c81@amd.com>
 <20230901055020.GA31908@lst.de> <ZPiAUx9Qysw0AKNq@ziepe.ca>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <ZPiAUx9Qysw0AKNq@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0028.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::21) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|SJ2PR12MB8184:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b3fd39a-2224-42cb-8dd8-08dbaf88a4a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 09qKP1w8DFWW714Nzvhqwh47DXyotezvFN3z1OkuPs/VVkp/hAoOyj/oPfWyZpSKsp1BBinOKCbLvuB7KdnExFQApjVFckT4xjXuRy8I62RhKEie9r2yGv1sV3PrYtlTuxBBrfJqkB3QWn0x1J63Df9BiBiNfyxWzl+1K3HZ1BO3UY1V8Q9C0pJA39dtjB1N022boagR9OigdRQ49DknU+MzWzeTAhnT+rNe13TALLn5SyoXaVbOPdUr/d+w2hpiX7MrlP+okgl2tIRLPCLXS4kkrTYW7t2MZICP3ltapOfw6qMyc3CICCiJ8O6yjU2gXWc5Oy8Qq2HMy8BbCNQDxr5LoSBcLs4Qb/p/H27t86zGGrfMl+eXm75Y5QEN4Mv7Dcp5VADsM65OnO+x+vItdzRYmnx/9smonMVTT9xghlrsybicZ97kWXY66hAXWvJ9RQHnlux6cTisLRhKnajdJeAWkao7gRDKgaVwaHIpEe8ufpr3LYhkRi/dPOSlt9JQmPusRJ1DqswPQcPu6/oBoWd9mdREUxJEEWeLHjXRdQkfxn7leyr+9PsyN7dKbbx5hl/xJnMaM7g6nkQquLSBcxkXd6eS7x8kFZ/uK0PXjcCfC6n9b75Ce1MwIOktu/LnRflp52Gdw66fnBZe6HOJoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(366004)(136003)(396003)(376002)(186009)(1800799009)(451199024)(8676002)(6666004)(6486002)(6506007)(53546011)(966005)(478600001)(26005)(2906002)(6512007)(316002)(110136005)(66556008)(41300700001)(66476007)(54906003)(8936002)(66946007)(5660300002)(4326008)(2616005)(36756003)(86362001)(31696002)(38100700002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MW1qQUlJMUVtbW50alVKQ1FOSjF3Nm83OUlDRWNtSjhqeWFPVjBlYUxoN2pw?=
 =?utf-8?B?bmwyL2VuY25YZUdKQ04rTHZGbFB3aWZhZndESG55U1k3dXB6N2dvbEt6Z0tz?=
 =?utf-8?B?UkNiVTBHTnFGcFFCRVJjRFM0R1dodDF0UFcwa3VlcFZ4cmh5a2l1Szl6MGtT?=
 =?utf-8?B?NFR0UmR0bEl6TWhLcjBOQmNsakpYMzhZaFZzdnRrR3BCMXJWaHRQdWFsdUxT?=
 =?utf-8?B?YkxEKzdGZEFVOUF0TnJmQWt2YzNLT3RpTC9kaE94YytZOUlhTHBDY1N6Rm5j?=
 =?utf-8?B?dHhQNm5UcEh5N215cjRPL3lHaE1oeVhUeGtzNVdINUdDdjRaYTkydXdBV2pT?=
 =?utf-8?B?d01VYisyTURYZGdJTU5SMldqL0NyQTd4ZTl6bVc0YXNXVHRObm1LVm1YYXNN?=
 =?utf-8?B?a2d4UWVXYzJ1NmxhWlgxRHZXVDJ3dEl5YlFlVnB6VFZJeEN2U2ZVc1E4R1du?=
 =?utf-8?B?WXB4RWgxT3hHa3UyN1VoR2JrZllKWWZRZTJjZ01MRGplOE4raituZjR4Q0s1?=
 =?utf-8?B?UmRtRVRkSWJUd2tRdkpNc3E2enRsK2hRM3pEYURrVVpObENsNFBwNG1kaHVS?=
 =?utf-8?B?Y2xTQkV0TW5VMndRMG9RT1FHMmE3dHRjRnoxQUltaklaM0N4YkxBUG9TUEdY?=
 =?utf-8?B?aS9tNnpncEtTdFQ0VENUWG41b1p4eHFYbWRBbFR1dXoxNVpzS3BCdGY1U0dK?=
 =?utf-8?B?bWpHK0p1VWdpWlhhMjkyNG1qcWhyWERpb0RXOVk0NFhsM1B1K0p1S3Y0REVH?=
 =?utf-8?B?NDBnTFVkRlVKZ2gxTjBaYllsWUtqckNXemdRLzRubEJ1cGdhVXRaYUFKeExX?=
 =?utf-8?B?MkYvUXpNK3hZbWkzUGo2QUFmQUszYTFEc2FIcW4wcjY3WjNyNy9xSk0vVC85?=
 =?utf-8?B?K0hJVlhobE5CMkFYWm9sbkNuVlFxYjRuRThHN05GVDcrZys3WjNKTHVHQm5i?=
 =?utf-8?B?WmlibExBY3BReXY5eTF5VWNFWGFqdFZGTVl4UzF4ZjhyYlBjaDFEZU5KSS9Y?=
 =?utf-8?B?TEhpYkpUYWY3eHlNdHdJT2RUMndJcEdpcEdneDBVV1o2OHUrRGhLbXlkTjk0?=
 =?utf-8?B?aVpKMmJ6WHR0bmNCcU5nWXlGcnlCUVZ5RFlCM2NrOVhQTW1oWmttRXk3R3Q4?=
 =?utf-8?B?Q1BNN0xiWk15TzdhR1ArajJTOUU4ZHJiaC9HU3FYTW1XYm5uRVFHWXZYY2wv?=
 =?utf-8?B?ZDllbFF2RlVsTkNreHE1R1h5SHFVQytRTENoWXQyVHlNS1o0K2VINnpGRXN3?=
 =?utf-8?B?eDhPSFVPZUVzcjBDSHJPTS9jdkt5dythekR1UVlRQ3VyM1BaQzVnRkJIVEYy?=
 =?utf-8?B?aVpJc2Z6bmw0TWhaTVJXMm83M2l3dGRXTUMzaVMwNWZNNFBNRk5Pb3VSQmRo?=
 =?utf-8?B?TXBWT21kVUNsZDlyQ0xqMVphcXJFVE1jSGlHNlZONWJNNkdVWFNCL2w1QWdW?=
 =?utf-8?B?ZWZPdXNvV2JBdUt4VHBheXV2QllnVlVMVVRwUFRRNGZUQWIrUXlVSHdUU2o1?=
 =?utf-8?B?NEU5Q1VUMHN6YmthZ1FJdzhsSnJkNjVqZUlFMUhKa0h4emtlTlV1MXJuYzRL?=
 =?utf-8?B?MWxZUmNLMmpOUDZNOTBSYXU2Vmw0QnFzblVQdndkSUFHZHo0bSt4U1BiRytH?=
 =?utf-8?B?elpvOWcvbmJaNHVIZ3dZTHhGdWgydWF0Mm5BQlFzTnU5eksyVW5odXNnTUxD?=
 =?utf-8?B?UTlEUjdKL0ZvQ0s2c3dtNGNqMGhJMEE0Vkl5VXQydkd6azdhUDRUUE9yb3Va?=
 =?utf-8?B?UnYrMVNzby92OGRvKzJSZStSME9EdDRncDlyeVJSbFVrL1VmdUZNcU14Unhi?=
 =?utf-8?B?bG80ZlY5cnIzVTJZYm8rNUtVRkVlbDBPQ3hJY2IwdnhCRzRXQ2JZN1lPWnB4?=
 =?utf-8?B?THhLVlY3Z2RMSkZGb1pCRysvaGpuc0R6Wi9KOTJYWGhFVXp4M0hTWndrK0o2?=
 =?utf-8?B?cDE4SXBMZ3ZTY1RBWi8xejJhcnc5bkkvK1A4Q0ZJSzZmWnA4ZWtJZzRIdWFL?=
 =?utf-8?B?ZzhKalliU1FjM2ttQTBXZ0swUjBReFBnd1BLUUYvbzd3Z0JiZGVpRjI1US8y?=
 =?utf-8?B?VENYZTdwRER3L2JRaFZGN2RDSU42NndQTkpDZmFvelkwdk92bmZxNzRCV2dJ?=
 =?utf-8?Q?bm15UHHrTx8pNJCmFRPsLfSN2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b3fd39a-2224-42cb-8dd8-08dbaf88a4a6
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2023 09:56:01.9049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9jTGwZVXz6YDLnmUG5MCJCuZjRuc9qU1mDLxbY9l4dq87EOeLeMsqEQnUxUFB6fL8Vwb+5s6MlY4MTSzha6VPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8184
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/6/2023 8:36 PM, Jason Gunthorpe wrote:
> On Fri, Sep 01, 2023 at 07:50:20AM +0200, Christoph Hellwig wrote:
>> On Thu, Aug 31, 2023 at 01:03:53PM -0500, Kim Phillips wrote:
>>> +Mike Roth, Ashish
>>>
>>> On 8/31/23 7:31 AM, Christoph Hellwig wrote:
>>>> amd_iommu_snp_enable is unused and has been since it was added in commit
>>>> fb2accadaa94 ("iommu/amd: Introduce function to check and enable SNP").
>>>>
>>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>>> ---
>>>
>>> It is used by the forthcoming host SNP support:
>>>
>>> https://lore.kernel.org/lkml/20230612042559.375660-8-michael.roth@amd.com/
>>
>> Then resend it with that support, but don't waste resources and everyones
>> time now.
> 
> +1
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Duly noted :)

The reason we introduced this change separately from the SNP series was 
because it is part of a different subsystem, which normally get pulled 
in separately. Unfortunately the main series takes a long time to get 
into upstream Linux kernel. So, this code appears as unused, which I can 
see how it can be confusing to other developers.

FYI: This is just removing a function to enable SNP support in AMD IOMMU 
driver. The underlying logic to enable the hardware still exist, which 
is part of the SNP feature enablement of the AMD IOMMU driver.

Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

> I've said this many times lately. There are other things in this
> driver that have no upstream justification too, like nesting
> "support".

Jason, there is no need to keep repeating and polluting this thread. I 
am happy to discuss and clarify any points of your concern on the 
"nesting support" in a separate discussion thread :)

> Please organize this SNP support into series that makes sense and are
> self complete :( I'm not sure a 51 patch series is a productive way to
> approach this..

We have discussed with Michael Roth (the author of the series "Add AMD 
Secure Nested Paging (SEV-SNP) Hypervisor Support"​), and he will start 
including the removed function in the next revision of his series.

Regards,
Suravee
