Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F711777F4F
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 19:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbjHJRnJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 13:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbjHJRnI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 13:43:08 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2077.outbound.protection.outlook.com [40.107.243.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C02AF2;
        Thu, 10 Aug 2023 10:43:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LoHyukL1w+/wYPAxge/XG3cgjTLz5CI6RQumO0CnGQzuN23awyTs4ylRVzoliUn8eFnPKAZyG7jyeiEIMYHcQossT5XhsWASIrWwXB41/1VOCaU7xV36Y2XMXgpo19PSLYNGUX2Cjs4OGd8ukLznAFwz2/KbFD+bKBKDpBl2Dk6JeSdNLiz0kQeA2Mz+Cw+jmZwAhSXrQ/uRXFY29mOXneKEt5s2ggUqZ09j9Oxh/EZE5qqjSTpwBXXJY/V4pqS0Hie/Q5v6OJh/SV02gofXVSPuN6OyXZImwV+RWEawQGDypWHS0+vo7PrIplKEUVXqrQrzMBwcmbjuHQeN2eua1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uzZg5FU8T1gAXXToU6csih4thAbBDil2LYur4B+RhfA=;
 b=NEPt5EiFpYCq3Rk2GYMhmP4kKFM/CyZiuNFifFOZE8k4Pe16NwxOTKiYQWAHagAOEfTsX4Qlgif0tkN0jIR1WqwWGnKATQkF1S/3hpUHNcgugWDeSkbj53e7ei76sGU2sL++4zAmXnVlOYg66pdFMAv5o46XzNSVYmGiWGDqSLqg2esarSp6Yc23Yyp2N9cZdstiYdPDw0gnYH6eQ1kn87CWwVdoPzezvbryowuqiEw8X8SHrOKVQuuarcjONDX9TneqwT50zOww6K7SMXgTjF4V5sl6TpeBhkqglL+ITwlrA95YTu8hMN7PwxJCytf3CaXOBRY2p/1+C70fifZYYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uzZg5FU8T1gAXXToU6csih4thAbBDil2LYur4B+RhfA=;
 b=dIFPN4jsDLk0LcP6YXSx8FH1wtut4Y8L7Ch376lH+ZTHYZ2l7YGxA+O6iJ1qIlqzD4pvucTwv7y6A3Q20Zt7mwR5buoKvweETP4jRUg3/aVYV9o/jrSBuLAtvE/uEZrTV5EBUPKAsMPYt3cSej3bLVrLcKUU6wEHqzmD+JmyOy34TOh92J0Dwq3A1vsYlVCT1wy0+TGIHBkb9/1l8cZ34+ESvrDPmu0uDIFb5HM3cqC6XnuMCxGBQC2LS+bhh7nZy7ED6tfwBGMZ0152Et2gfBwoEfU/tBYuJR3W/hGF5NjN/xDoMM9Z4TaOZcGUcrTyw2mgji/BidMn4Sl9uNJjzA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB9273.namprd12.prod.outlook.com (2603:10b6:8:193::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Thu, 10 Aug
 2023 17:43:05 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6652.029; Thu, 10 Aug 2023
 17:43:05 +0000
Date:   Thu, 10 Aug 2023 14:43:04 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Brett Creeley <bcreeley@amd.com>,
        Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "horms@kernel.org" <horms@kernel.org>,
        "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: Re: [PATCH v14 vfio 6/8] vfio/pds: Add support for dirty page
 tracking
Message-ID: <ZNUhqEYeT7us5SV/@nvidia.com>
References: <20230807205755.29579-1-brett.creeley@amd.com>
 <20230807205755.29579-7-brett.creeley@amd.com>
 <20230808162718.2151e175.alex.williamson@redhat.com>
 <01a8ee12-7a95-7245-3a00-2745aa846fca@amd.com>
 <20230809113300.2c4b0888.alex.williamson@redhat.com>
 <ZNPVmaolrI0XJG7Q@nvidia.com>
 <BN9PR11MB5276F32CC5791B3D91C62A468C13A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230810104734.74fbe148.alex.williamson@redhat.com>
 <ZNUcLM/oRaCd7Ig2@nvidia.com>
 <20230810114008.6b038d2a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230810114008.6b038d2a.alex.williamson@redhat.com>
X-ClientProxiedBy: YT4PR01CA0347.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fc::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB9273:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d83a227-3e40-4c36-891b-08db99c9409f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x7AFIOwqSiJllDIUqBEtJBbiFPufEhRSVrkbM2LQigTsRvzsCVQM0HfWphHNGA5ifrbx5JCGo7+FriB+81MTsLTXFYxm9NSGQHNlapGDbSREobD2CLuamDUV9mnc2kaHXz4xI17C6Kg3bfUSGOg2OGUUhm9J7VCxlYUyRGv/GTSkBemfDTGGZFRsWrcb313QxVAhW12+Dr8WybGJrE7jQjDugDGwqNI6j+1CT6W436u3cF4GIMhl567Pyj/kk+qzEAE3MPnvtiWYZaBRbIrKdygloSrI+OIzbp+9rfor8ZlrFIaTJOKsPDgkLCfr9ieNGDbqFiWXSx4TeBvj4ViHSyM2pEQoxInzrwX/nRDZFg7lnK4h6Z57rEXPorGiNhkDPCjQe01onEYhz2MLiNU5vRYfyMlzceu+HTUf7LWBemj85Kwd0V0y0aaMq2x2egkSRwuxjQGgg27uRfwyy5vpSOSMHE+X+8jW2FMnGMCkMFDeJhMZURmw+iztIDuvuY/+AGEoUD28PFiyBWoAj1teVVy7MhOM3U/Mrpety8EZfnZoYEaExNu3BinuvJN8UbQa+D23GGXLR14EhBZybTLxHAV602t/qXQKeK2qukF0SnY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(39860400002)(366004)(376002)(396003)(186006)(1800799006)(451199021)(5660300002)(26005)(41300700001)(6486002)(8936002)(8676002)(316002)(6506007)(36756003)(66476007)(6916009)(4326008)(66556008)(66946007)(4744005)(6512007)(7416002)(2906002)(86362001)(54906003)(38100700002)(478600001)(2616005)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zlk0QUtQTXFEdVB6bzhCa0ZrczY1dEMxa3VGRDVPRFV0UmhOMFlTdGRQelRX?=
 =?utf-8?B?NFJDUU5DTHdOcGhxRmlhdzg0YzVqTGh2ZU1qV2tFakZFZmxqdHV3c2h2Nm9r?=
 =?utf-8?B?QUhXUUlyN1dnWWtleXIwVEdnQmpxdEp2YVEzMTg4T1pHdVpTRWVYSkMxQ0dm?=
 =?utf-8?B?QmNXaEdCbHUwMmVuWXVWWHFuQkh4UjBZdW5QZFlJcGJjYlI4SjA2QVFHQ2Y0?=
 =?utf-8?B?R1NzbFJOck5MN1dzMXN1dHpjcHdoSjIrbXBMUXJ2N2daQi9nN0NWdDZPYWpm?=
 =?utf-8?B?L3lOSTVacE1odXF3T3hTcExEcnhCVldpS1g2N245cnFEdFZ4cXFqdHZ6cnlq?=
 =?utf-8?B?NHVHclE5QVQzRXpBZ2ZIditabktFcDNXcGR4Skc3MHc3RHp0ZStWNVB2NXdB?=
 =?utf-8?B?VkpyZWh2RjB1TGNlNGZyd01yYkp1UFh2ZVI5aUNQbDJxd01hWHcwOXBNdlhy?=
 =?utf-8?B?d29qZmdVc3o0V0hFWjc1b3AzS1JzWHk5aDYzOXNFS0VOZnpxSUN1d2ZyZTM0?=
 =?utf-8?B?aU1FaXBTY0d1WU9qS0JLeUM2V0UwVnVEMjlzZGVldXBQVEVOQ0NNdXcyNmIz?=
 =?utf-8?B?d0M4SzBlR3ZLTmFCekZlQWRjWEY2eEp0U0VKekJtaHNwL1Z0dWVNOWtRWHAw?=
 =?utf-8?B?T0JzcnJreEV6QUREWi9MNFc5SGEydUJ3TW9ySVQyejNOQUtQZkhTdWFLaFVX?=
 =?utf-8?B?UWZHUWoyUVJzejF6bzRRYkpibTBFRTA2cmFncGJPNm1XLzk0NXkvSjQxYnli?=
 =?utf-8?B?UDhrQloyaERqOXJnQ2hSSzdwL2VrcWloeFg3VE02a0hweUl3RlJLOWp3ODN1?=
 =?utf-8?B?bEI3cWlncGwwZFlack12R0Q0YkJlRVBDcGxkRmhSVDVrZFlWNHJoRGxCa0pr?=
 =?utf-8?B?MDVKUjIzUUxJcjBDcjBCUjNVckczRUhPeUpLVy9DTnc2eklrRndHTEtmYWNt?=
 =?utf-8?B?dS8wd2xRM0M0d2N2anFpMmRHYm40TEVtV2VyVlJCYngwdEZBWWZ4eHc0b09y?=
 =?utf-8?B?bUd5V0NoUTl1akZTUlFGb3VsQkVhZUY4aXU0SUNRYVFVK25nYzJBZ1NEVUJo?=
 =?utf-8?B?ZEN2bkpCTGYxQmQrNHNpZVc5OE5lL2dZV0VaaTJJVUJGbFcxL015Y1QrRXd2?=
 =?utf-8?B?bHR4c3RraDVsNGh0MlpIZU1RcFE4WHBlSlN2WjdBdVNNQTEvemMyV0JRR3Iy?=
 =?utf-8?B?VVI5cXBWYThUR1hDN2orOWc5YzVleXFCRjJWNU9TUXJNUXhoMzdUU1NmS0tv?=
 =?utf-8?B?UFlHbmlGZWRxVzZiV21GMkhNSE5YYVg0L1dxZTBna2IvREhuNWVGdlgwSkd3?=
 =?utf-8?B?YkdEOEtONlR2VEJRSWZtZVRpb1FzZCtXanR5aWVxM1c3c3J6RFNWMDhtUTlh?=
 =?utf-8?B?QWR2RTMrMEQyUDNXWjUyaHRTQ3Z6bHJkZGI3dGVnOUU0eWRyclVKSE1mUlBN?=
 =?utf-8?B?QkoyWERSS2VKUkEzVUFMWGg5cm9nNG9GaElHRVhxRWVyYytha2FkVDU0eTFo?=
 =?utf-8?B?NEMvUkROeXVRQWo3TGFVVHpIdXRqci9uaTNnYVNCQXB3N1dGT24zWlk0NXRQ?=
 =?utf-8?B?dktETnRjVEprOUJaSjJkaGJ3QzNCaDRwRjZOa2huNnhYUWVPZERVWi90U0VS?=
 =?utf-8?B?eW1nWnRQRnZBZjF4VmJDcUNza0ZSeUlHSnJpMEVlbmdEMEQvUkt3MENIZzNG?=
 =?utf-8?B?Z0F3ZWlIUVNpZ1NwejJDeGU4Wnl6SlFFSkVNdlcxa3lWSzUyb05ZN0cxZWt1?=
 =?utf-8?B?Y0RCQlBSaE1vZ1B6NTRhTHZld3pzY0ZGQjBQbzhQU2RRZW5DaUllZGVza21L?=
 =?utf-8?B?MjB0N0pNdWtMcmphOUxvSG83K0NtL1oxUUR0RFdwVHloYTdqM1o3dTBYMnVK?=
 =?utf-8?B?VXovSnR1RnliTzhFdXJYOFlmdGxydS9EUkdLbHJ1eWlZQSs0cERlVGR3a08z?=
 =?utf-8?B?ZnlsTmd2U3VEY3lEUnNxdTA2RWlzS1ByZXdZQkhSVTBCdlZ1cW5yWEExRkNI?=
 =?utf-8?B?eU12bEhnRWhlcVZMcTdCOGNBZ0xDeExGcXRQSmNwUW5HUHRlWjNVZVhFUVhF?=
 =?utf-8?B?Z0NtQTZYRTFBcHJ3TFppZC9JMnlIREJ1anZMZlpIQVlpTFNwSEdtVExuRngx?=
 =?utf-8?Q?ox2FmYzl6TOPVgKZ0osXgYnfo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d83a227-3e40-4c36-891b-08db99c9409f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2023 17:43:05.6093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M1/n2Ofmk1qW14YB/LdJRSsDPYX+a7GbQV7SQ0M+Ns9SqbKV0aJJVOXnd3ZFDm1j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9273
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 10, 2023 at 11:40:08AM -0600, Alex Williamson wrote:

> PCI Express® Base Specification Revision 6.0.1, pg 1461:
> 
>   9.3.3.11 VF Device ID (Offset 1Ah)
> 
>   This field contains the Device ID that should be presented for every VF to the SI.
> 
>   VF Device ID may be different from the PF Device ID...
> 
> That?  Thanks,

NVMe matches using the class code, IIRC there is language requiring
the class code to be the same.

Jason
