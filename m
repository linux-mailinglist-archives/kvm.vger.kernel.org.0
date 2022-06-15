Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2735854D30F
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 22:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348559AbiFOUws (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 16:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344323AbiFOUwr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 16:52:47 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2056.outbound.protection.outlook.com [40.107.236.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A591707D;
        Wed, 15 Jun 2022 13:52:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ozr3woLt25mrKTUWzYQhXDGFXUmrZKvWK1WMCHJFcwMiZeLDvvNWD6IZPdD5s02c2ArOE6lCyQbL1+/PCEK+2glJv+cInUTLLZZhXo4hYmTXr5GYSlKueyMQqUwFb2ssDO4Lg2JVokMONSnluGceVf5oc2Q+cQq32lERlstvwjPakAd4NCvrxM+OWgLvjPVp0/UZpz41sjms5bCc4WAK9gUK5VRLhr7V5tJOd2pPbL2mr4M1m/sn81PI2HdNARBvsV4lzABnAvZRKtR+uThpaAvTsVMb2WGCL1k5EKtl0UApiTO/IPgri+I2qKnaJc5m9FPo5WvgPVRqkpej11v0nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rYGjzLYqPIgKZNPGALob8X7H2DD3GRynU4uIR48jSxE=;
 b=m+gJo/m/1L9ncwNe9MZuvFMmIqZOnaMhgM2xHjzM5238mP5583AtfaHudNCrdYBm0RAN8W+6O7MlWepbgDAPcHm4zscFjiPbRJKifWK8WgQh/CB3QEp8VJj11f1P1xATMJv6/61yLYKuXxz2u5yy5bzgg9D53DMbRJlJ/YKskAq/rtd8pzV9pvW1biVT6ZucqdPQhOAimzdhFAoUTDG4ziL/i/n/VHRwHauSR/q4yAeMiYExjZ7lItbdSipmtO8n81nMFZoPH03jFyFQHnPw7lLB/L7BROOtYfDSBYNTpaRbendp6mcpSVPdhNfgKb/gRluvzsaMI+77L1vNmLrmng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rYGjzLYqPIgKZNPGALob8X7H2DD3GRynU4uIR48jSxE=;
 b=C+55YPssEJ3y8whZhnbGU+obhgeUtE7QioI5BXFKQhPpbvGRi28abEOzGuf3VBGz7iybVrJC50iIqcXBmPimooXGtaXArFjbkfsc768+i0rykamhOheFrLnRdWcd7LRbcJjZzsU8F3p5BIHNe34MGSnHY2XWtdEd94nU/JOtyj4FfBqtig2dHkvuwQdegy1RmC7ga5DRxz1P8sb5j9/DI+niSADgdbOqMD7F51qJae9h/EPGQlwvHoGZYARtkq62RSr1CSJboYXrP08IKaWOxJqYuWCM8v8cC1XosqkkjOBaHKYxVy0rhD2/CLE98jHheXXyi7xl+LBEhYvFs3iEuQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by CY4PR12MB1847.namprd12.prod.outlook.com (2603:10b6:903:11c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.14; Wed, 15 Jun
 2022 20:52:44 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14%7]) with mapi id 15.20.5332.022; Wed, 15 Jun 2022
 20:52:44 +0000
Message-ID: <0dfe9d62-dd2c-d889-7415-1ae05953f8b6@nvidia.com>
Date:   Thu, 16 Jun 2022 02:22:30 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 12/13] vfio/mdev: consolidate all the description sysfs
 into the core code
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org, Neo Jia <cjia@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-13-hch@lst.de>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <20220614045428.278494-13-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0037.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:81::7) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cecd7841-259d-4fbe-c707-08da4f10feb7
X-MS-TrafficTypeDiagnostic: CY4PR12MB1847:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1847A21C15AB1FB9924B6EC6DCAD9@CY4PR12MB1847.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5vyBhLlRpcifSR9c1Hfwswp/yUXftNZKr9Glr2vES1hcMxBRCKsREhNO3a5Grr86P6fdpn7DvCf4pXAEvcPpotSHfIsT0MSyQjmPlVMMZXTH26r6jT3NDcQNqCySrs0kUOT0l/OJodZf0mpm8YvqyoR7dtpUlGaGGUo2U50eHZW5IFrXUZajLnuKHiClOHrHoHBvSD33gF/onfpYC+YtRClRNuhj5qx7HOCA4RJAPxKS81DJNNsmDEyfC8wmSpyBbr1QJNxV5+s9L5O4F3ROtwoANGP15hmvVD7tZCVVUxF6Giq8LbCnwY865xa1lyNBN8NYICJ9Wa1zpQ5Xxow8w9EYxsg7iK97sOtoSK72IG0xCkZMBCOsEaDqTAP4bTazmeYBxSpPfmo3LK24sjoc8kF33+xlqW8Rib4WDA/nKmT3MMODSwTn27SGVbKLRERU0IRmAN5r5J4tM0d9ObFAearLYh1GjpH6eSKrgKeCBlz3577jLS8IH/FMauuazA6/1Fx6x6C7qmDi96jcSgmsrHyMQCbx2hQEIB7qzGGQTVhQyjfXnrP0eg3JolA/XLMBB50C7jI3oA9g1FfKUt+R0het/zKuC/c6GPmkFh1i1hEsbPUTKYfPCqHrOKVI4jxe62EWCAILrL5Sh5qkE+HD0+P2CQVImHPCQE9N7N2Ic6gltTuiyg+zPr1Rjf8j8JNSJusFd/EGpl28c/YwZ2hPzT8khfLHbSzAG0tm0ksLoKg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(6512007)(316002)(26005)(2616005)(2906002)(186003)(36756003)(7416002)(6486002)(31686004)(38100700002)(6666004)(110136005)(4326008)(6506007)(4744005)(53546011)(55236004)(5660300002)(31696002)(86362001)(54906003)(508600001)(66556008)(107886003)(8936002)(66476007)(66946007)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cTE5Wko0ZlE0dlhoM002Y1RmUmRLRkpPOG9MYlhXN3NhN05BZXRMaVd0bzlr?=
 =?utf-8?B?cFdrcGdsMTNMeDhnWDlPUG04dnBnNmc0T1Z4TFM0S1doRG5VeU55U0EyYXRw?=
 =?utf-8?B?MW5nSlV3alBRWkM3T3dnRjl2N1FWOXYyWlJMVmwrRlYwS3llY2ZwQStTbkRu?=
 =?utf-8?B?L0VyMlh2N2RXcDdtZFVKVzZuQ2tNbklNN1VTeGZ4Snh5NXhobThFdTdWQzlj?=
 =?utf-8?B?VGI1Sm9PajN5U25KQ0w3RFNVK1BpVVNwY2ZYcHJ3dmVnSjBhczAyQjBVbkdB?=
 =?utf-8?B?T2k3S2U5bEJPU0hPMlozdk92KytjV3QvM1VHQk5ERTV4ZmFWblpNZ3ZEN1FU?=
 =?utf-8?B?bFZSYkdRRDdLb3Q4K2tmYmlRQW02VkcyalVPVlRPenNSc3V3VXVXUlc3d09R?=
 =?utf-8?B?VWpjSDY5UTgzbzBUNEowY3BVWDFtVnRsMXplYWMyWnRHMzV0TUd2dHVLMmkv?=
 =?utf-8?B?ODVqazlCREhPZ1ZVWlFadmlCT0VwN2NyTDZZMHFreGZuQ2lxR1c3T1pQbmxT?=
 =?utf-8?B?aFl6UFNua2FLdHlMZS80MUp2YnlBS2lWQ1Zzc0RSaXJBcXlXVnBZMUVqVU9l?=
 =?utf-8?B?NVlYZjlhZXZiRjBKNGxyV2Y1cE9janN6SkRldmlXTUYwVW1kczhlMkJIV3VO?=
 =?utf-8?B?YUhtTkZQY1ZBUFpScXBFN0luMXYxQm41bU4zM3VvMlhvVEg4R1BPZFNFZzZE?=
 =?utf-8?B?R1JqSHRHYzZIcGVoRDE4QklXSDV4NXRYYlZWZ3AyckUxRlZNYnhyODYxbE1y?=
 =?utf-8?B?N0tHd0JjM1ZTaUxqQnllUkt3K20xYy9VTE5LQW12OFFVV0RnbGR0ZnJkVmVL?=
 =?utf-8?B?TjZpSHlsMXMrbWJmM1o0Q25BK3RVemVDa1pVckgxUVNXSHdnZnVRLzUxcmVv?=
 =?utf-8?B?dVUyMjVIMmM5NHVsVk9XWWFKZlhPUUVCTlAvM1VmVzNyVG1NUXhNbXpWL1pM?=
 =?utf-8?B?ZXpJb1pmWnNaZlhyaG5Ra3laRGxOVXFZblRMZGN3RDZDSnNRWWd2Kzk1SklB?=
 =?utf-8?B?T0JsRzF3RlFNMnNvOFkxVnpMSWwyd2x3aVFxcUt6K09lRG5ubTQ0R0hUaXl1?=
 =?utf-8?B?Sis4clB6OTh4NnJOVTJraisyVnJ4c0k1STRuRXpxb0YxcHZqWm5JcjB0QzBw?=
 =?utf-8?B?SU5tY3RpZkhBSG1pcWpzR05WYUFVNWNCcGlHY0JleU9FR0hVT3lISUFjMXVT?=
 =?utf-8?B?WG5abmx6UkpxcVdiUVBDaFpMLzdpN3JwMWRPSW52YTV1V1BjMGFiMlFHbXh3?=
 =?utf-8?B?bGdzNTFJYWhRUkVGZ3RmSFNvQTVKSktiRjdpSGJYak1NdnJJeXhJRFF2VmJ2?=
 =?utf-8?B?RkZScXBvVW82eHJvVis0TGoxcUNDaVNXYmVSNDBaelhFVlpDeUJkUFhRT1ph?=
 =?utf-8?B?cGx6U1BJTjVnMHdYczZiajA1dDM0alF6clJrOERJNi9LdjN4Y0V1UUpMdC9J?=
 =?utf-8?B?MXo3SHZTUDRRSHhEang3Vk9Qc2tkNFBxWUZ1VTN2Qys1NHlPNUxkNXpYUkJI?=
 =?utf-8?B?WVgyWVByZW9KbTUzenRZaU1nb3h4MTg0VC9lSVhSQkNnZWRSZE1GSVprdE5w?=
 =?utf-8?B?L2ZoRDR0bGlWcTBiWWJwZGxneC92Wmkya0l3Z3h3cERINDZXdkUvVjNobGZH?=
 =?utf-8?B?QlR1Z1J0bCs3VzErYzAwRzVCNFp3YTAxcVBBMTJXTXBiejlBdDhGNG1wenU0?=
 =?utf-8?B?SDVYV3h1U01tQVFpdjFsajdCRGtFUkd3aTFPcDJyZzZyeHI5ZXlMcnFDV1VS?=
 =?utf-8?B?UGdwQTloSUwxN2pYU0g5L1hWTjlQcVA5eDFkQk1hNUtKenZmQy80cGs1Y2Rt?=
 =?utf-8?B?YUs0dHFGRGgxQ3B0eXlvdXdOaXNTR0pyMm5sWVhyQ1d3Y1h3T1NiNmNvTWxv?=
 =?utf-8?B?UHg5anZPTkxQdERxN2xQYi9NbkRGaWdGQkc0cnBTTmZ5YStYYlI1bVM5WElC?=
 =?utf-8?B?THVZSklTaGp0RG1IVVRqRkxDTVIyd2lLbE5GNTFES3RweERNWEhMOVE0Q292?=
 =?utf-8?B?eHhTWnE4T1JWNVNzSDgzMmRBS2xRbHF5MkJ3NnN1RStha3I5S0lVNFNiYjUz?=
 =?utf-8?B?QzNLWmVHMkx5SlNyWTdwRmlkUTVCR1h1T09zTXRZbGJaRFRDZ3hBcDdxK2JD?=
 =?utf-8?B?dUl1SkxQSS9mWU84VEIyd1VaZXRzYTgxN3dJMCtGUFhyWlNYTEJsM2NoZDFR?=
 =?utf-8?B?aTJ6MmIwUXBxWlpjNFNBWlAyQWtXOGpJcmNLOTU5Y0JWY0xHMS9SYjVRWUV0?=
 =?utf-8?B?aDFoMi8wTFpxbS9Ma2JkdHFtRGEvWG9EQ2ZYakFkYlBtNG1IY3l3RmpXaWdu?=
 =?utf-8?B?NGZRdHl4bGNqWkFmRkg1WnlRRkNHcWtNdlhnT0lHbWJ2dFBVTjV4Zz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cecd7841-259d-4fbe-c707-08da4f10feb7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 20:52:44.1326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8s7/ms/g6tNWMMONfpCDQcAxF3DBb3GB04ed3bO+ywV1EZTQ8bQy9T2FyM4FKO8KqMNhjvW/XKBnWXmlo2hHvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1847
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/14/2022 10:24 AM, Christoph Hellwig wrote:
> Every driver just emits a string, simply add a method to the mdev_driver
> to return it and provide a standard sysfs show function.
> 
> Remove the now unused types_attrs field in struct mdev_driver and the
> support code for it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
