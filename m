Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC08778003
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 20:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234843AbjHJSLt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 14:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbjHJSLs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 14:11:48 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DC510F6;
        Thu, 10 Aug 2023 11:11:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f8sCjWxD6maaoxo6WFXoMxd7MLfEjFaDTPEqF9K8Dej3NgQ7zsSp/REARvPPTYJEYdrj5jrwcEIo6agOwX0rtnKvC1q2hxlTaTc8iIWsmKEeEFJuf2WyNrKjeUI2yfiojr8EhMLtmOnUc/mh7n6dfmM+gP/isjAFjF6D9GY1eckDt6KECRut2sbyn7sns/NQMYI3CANmoQh1alE7enIwOODuzm3+7xm0djMj3+P2GOhG4WYYVvB7r+b54jbMVKo4BVz/ZbseF9Inhe9xpARE16tIzj4y8YnFfogHsTFp74py1sMlHjVWaV20AJEjmYPOMr0/nZgTl5aFoT4GgDqPSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m6zDPQcGxObO4LeBmbr9zGzOVyZ2SORVtyrP9Hl+Fy8=;
 b=hOKCm3FYdmALQTPhq2nKmFBdX1XVPy+VXui9cDEPkza8GM708QB3qSJlfMjwE1rz7/WB/6H0JRnlNEbvaNz2ZiFAZU7K1e4DnR2lMk47sVRUwhLlxqXKWNfIpOH2WG9kx5ngLGxs1Y7zcsRIoCdHNGmUgNiT7Y2pHQp7uagze+ArC39QJqkjqNK4ZrWULUC4vptKgK2NdK27ysG3nxrYqN3YYMgpu+X9b5aFBzwx6rh0ieiyBVvZuQrT4fZj381UbJl0kL2GvbBdxxHsjoPaBs2Fqnby+yNNp1deHt+P/RUVYiVLua+AuSxiBs8ZeTBfZ6ahyeNZnH5gy2XoPJysHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m6zDPQcGxObO4LeBmbr9zGzOVyZ2SORVtyrP9Hl+Fy8=;
 b=CnmNOOSwB6GYTHciLnbNPMoE6GyGzOKfWKp8iDtzhp0AsaUVwnoMftrndMeniivYydXXaI4ovnGL8khvqhMspnQLSHKZhR7D2+z+39EbZBYE4Q612RoBSpgM+rV9ZdtRbajltkpYMMcCqbY+JoCa0AeCpBfZHBMVWiIZCzF2qVRQx1cPbkB6VCB3Ln31wBeNcNA58U9ktWjN58Ea75yRB858d0f3OIp/EQIPuQgAGYHDLJ8KBqMN0BVrdgiAHK9uDfKpBl8QUNK0dLDovmKCWaAo1t7F2RiXFiW7BQ290aLa8n4x3TouZ9vJUNz8Uii0aNUAl3MTIfMdM54EDJaK0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB6702.namprd12.prod.outlook.com (2603:10b6:806:252::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Thu, 10 Aug
 2023 18:11:45 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6652.029; Thu, 10 Aug 2023
 18:11:45 +0000
Date:   Thu, 10 Aug 2023 15:11:43 -0300
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
Message-ID: <ZNUoX77mXBTHJHVJ@nvidia.com>
References: <20230808162718.2151e175.alex.williamson@redhat.com>
 <01a8ee12-7a95-7245-3a00-2745aa846fca@amd.com>
 <20230809113300.2c4b0888.alex.williamson@redhat.com>
 <ZNPVmaolrI0XJG7Q@nvidia.com>
 <BN9PR11MB5276F32CC5791B3D91C62A468C13A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230810104734.74fbe148.alex.williamson@redhat.com>
 <ZNUcLM/oRaCd7Ig2@nvidia.com>
 <20230810114008.6b038d2a.alex.williamson@redhat.com>
 <ZNUhqEYeT7us5SV/@nvidia.com>
 <20230810115444.21364456.alex.williamson@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230810115444.21364456.alex.williamson@redhat.com>
X-ClientProxiedBy: YT4PR01CA0390.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:108::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB6702:EE_
X-MS-Office365-Filtering-Correlation-Id: 814b84b8-20e5-4017-204a-08db99cd418e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6+R6XidfrIgj376uHCr834TNI8LdHColsHFg8MrWd3ED+MAqM+he6UFx55F/45e36Z4riJLBYcwJWlVBZXv4jvPu4XO6fPUgj5M9ZmixaDF5xUuug8qZjPffW5G9cgNkC6YRDqYQA9sbaLe0cwZ7lRK246eTw5DJjhD5T+rtQS/QvD/pPh9HBexcD+kjkTobLWdVbuvPrSvjZDYoRS+X7R1j/insDSckgLfWkT3vGLxvWdo/pBcfDah035wiNvA/5uAKlzLe6wOyAnJKFVIsuowWvLRkJuMe039z6HKqBk8rJoVjCxb8V9uD3KANnSvVVPI6X2jltMQfgZep5dNZRMbUTF0//vTiyKEAD2Hl+/fzQ05PpzJIEsXb5or9zyQ8GalosLd5yySeVZx88xtH1jBclCHAiqUYDSH2qG2uD+6NvIPnMvY0+yHevPbBKYQrULfM7CuEwFHSO0DnmuojVxsM4GAllkQyOa5c2D/mQV3MXFE/8rRXA7FEdXD8m+LsR0CefxwXEnU3kCNUTc/CpfJfK9xhdCcsnZ/xa7+GEtgqr6ndayVq4P6e2su9t6ZpXwaGrE8CGqZ8e1GG/+RUG414WgV4Cr9hwGaSIcbKDwI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(396003)(376002)(346002)(136003)(1800799006)(451199021)(186006)(2906002)(6512007)(41300700001)(316002)(7416002)(36756003)(83380400001)(5660300002)(8936002)(2616005)(8676002)(6486002)(6506007)(54906003)(26005)(38100700002)(66946007)(66556008)(6916009)(66476007)(4326008)(86362001)(478600001)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWdRSnFkaTV1RXRFOExFcnYxQkM4M2JoNEpzem9rQVRkU29IQ0lsYk41bnNC?=
 =?utf-8?B?Ukw2MmVobHh2eldxNHVoU3c0Z2grdGFKZkMyK0loSk5JQUNIb2NIY2JXRVZ1?=
 =?utf-8?B?dXh4d3FHTWhScndvV1NLZjYwa1RVb1grd0lJQ29CMjBqVmVkVXl0OXgwVzFj?=
 =?utf-8?B?YVUxNE82S3ZCN1VvY0RkTUcxaGpTSlZORmtlSjNGeXR1Z3dLbnNMTVVueGMr?=
 =?utf-8?B?MlJlRmpndXlQMUlhWXdlMWZMaTNvcXdqVG5aODFiclU0UTFoQjJybHgzN3pC?=
 =?utf-8?B?aUk1c1NKMkVBR2FDWEZCaXRhWll0TWp3dUFpbis5MXJjUHlwamw2bnU1UmdK?=
 =?utf-8?B?Q2RTVHkwaWhqMXNDdEVvRXRIbktsdnFXZUE4c2NIZ0hwOVdpOHVPaHFNRVNk?=
 =?utf-8?B?eEhDaFkwRnpFMldWeHVjaU5LckRhSzhPRTFPRUlVQllrQk9ycFFvaHNrZGtp?=
 =?utf-8?B?TzNEMXJjY0haUTF4RERsbmF5V3IyQmxleHBHYzlhWFBpTFZEVkJkT1psT1Y3?=
 =?utf-8?B?b1JPTEdGd3VrRk5raWFPQmV3UkhGaEVwVFBsQkp5SkljRHJmOTRPWDJScmxk?=
 =?utf-8?B?ejFnNytWR0RQQUJhVFBKMGVCa1lqc3M5endPYWpiMUM5a0Y0R3V3Ni9KOTZu?=
 =?utf-8?B?aFVoSGFVcmI3dWhkdDVLSFcvOTJtMDEwTDVmSSt6YUFQLzlGaE1kTHpUemJJ?=
 =?utf-8?B?NFdwUHEyY0NiTmlHenNGaG1FbHNyQnBhaUc5NnUyWU5BY0ZKTTlIOHpDRlV3?=
 =?utf-8?B?K1dmb2R0UDdoUzl5QTJ5TXk1bk5DSFJETDllQ2hTQS82RHZ6OE9hbmpram9k?=
 =?utf-8?B?T1BQRjZBdk1DMkwxYkRSdE1ZUStQMnJ1NW5RTVRsTk1rREE4cHhubWRnOXpS?=
 =?utf-8?B?aXQ0dEJEdHpQNVNCK2xpUlEvbm5Sc1lXOFVkN3FRdFRiR2haTWNGUHBqdE5G?=
 =?utf-8?B?b1pqUkoxdjRrUFlDY20zSXpjRVlrblRUSjEyazk1ZWwrVjd5U1lyQUkwWURB?=
 =?utf-8?B?WTZqZ2xJUTJicWVSU3ZpSUpLWjdRRllIR1BSN0dGQ3V0L25sUGtLdzRBTUlQ?=
 =?utf-8?B?YVNRNzZhQzYySDNRSjA4cXFYTjRHK1BZYXBrUnVlcTBWVklxdHhCQTBzM25W?=
 =?utf-8?B?SGdVWHQxenJZRTFhczJkWFpZb1RtN285RE5VcDRwdnVTb2Jud29Mbkp0WEs3?=
 =?utf-8?B?bWtBQ3E0N2dxZExWTmthMlFHNlJjU3l3andhVlZJY1EvS0hpTjh4MnRUL1RS?=
 =?utf-8?B?NExYUlMwakwyeFQrdWZ3MzcxbVRtTkswMlhoYWZYNjMvNHZvSmNQUlpkUDlv?=
 =?utf-8?B?aGd0czhlTU11NXU0SklreHVtUnhCWEVyWEVCM2VtUklYNHB2eGFhWTkyYXpK?=
 =?utf-8?B?c3lYcFBBMmQ4MklnQlJoNE1ReEZ2bXd5SmdsOVZSRG9jUFBFcDBXUjZHR0Ja?=
 =?utf-8?B?WHJORkt1TktaZFgwdFp5REY5bUN5SWlPenlvTCtSajBjSUh6bmg5blQwemZj?=
 =?utf-8?B?YkZhMlAxRXNhRThISlhHRnRnaVI1bmxUdUZXUEtISTFDajVES2gwbWJVSFZP?=
 =?utf-8?B?MVFkc2kzV2w1OUZZYzQ4RGxSVEVmSFNrTzAxUFM0U1pMcHBJOVI4RkpzWmQ5?=
 =?utf-8?B?WEFLV2ZINTNBdE9IcXorWUpjWWJYMk1udzdsSzg2YXpqSERBWkM5amE0TnJH?=
 =?utf-8?B?Wmc3NXpDRXVuR21rOXM3K2ZEWnNSQ0lxV3pBaVduVCtDT0M0NUUvM1VxYUNj?=
 =?utf-8?B?OW1QRUExS0hrZUJuMER2NjFqRjgwU2xHdmtvRUpvK3kvdVBJOW9Pbm4vcUhp?=
 =?utf-8?B?RS9BeURHUU11TXNrTGNlQWdFTmtEZEtiVmpKbmlWTURjZEJjZWhBZ3R1VG5N?=
 =?utf-8?B?NEFBemsrWVBWeVNMTXBLZUltR0xaQlhFUXdBYlJIcURla0pPWVVXK3JxcENC?=
 =?utf-8?B?enhaUWc4Y3BIb292enBjVkloS3I0RmF0Uk42SXJHY1p4N3FEaUVXb3FCVDBZ?=
 =?utf-8?B?S2dmS3VKOE82d0pMeE5pZXdzYVNwMkFERytlZm42cnFQWGExdXZRZThYeGVS?=
 =?utf-8?B?QVRIdlVUbWlZRHJPaG0rU2xzb1JQNUhvcktYaGtWUlMyeldqWktHN2FCOXlC?=
 =?utf-8?Q?AzkQtc6aqOVKSOvSuqmt8M9I/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 814b84b8-20e5-4017-204a-08db99cd418e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2023 18:11:45.1854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lK/JpRXMJCN713lxwklaa7UNo+CVL/i8EzIf61wfH8uWXraBdrp+fGeq66yjxZp8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6702
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 10, 2023 at 11:54:44AM -0600, Alex Williamson wrote:
> On Thu, 10 Aug 2023 14:43:04 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Thu, Aug 10, 2023 at 11:40:08AM -0600, Alex Williamson wrote:
> > 
> > > PCI Express® Base Specification Revision 6.0.1, pg 1461:
> > > 
> > >   9.3.3.11 VF Device ID (Offset 1Ah)
> > > 
> > >   This field contains the Device ID that should be presented for every VF to the SI.
> > > 
> > >   VF Device ID may be different from the PF Device ID...
> > > 
> > > That?  Thanks,  
> > 
> > NVMe matches using the class code, IIRC there is language requiring
> > the class code to be the same.
> 
> Ok, yes:
> 
>   7.5.1.1.6 Class Code Register (Offset 09h)
>   ...
>   The field in a PF and its associated VFs must return the same value
>   when read.
> 
> Seems limiting, but it's indeed there.  We've got a lot of cleanup to
> do if we're going to start rejecting drivers for devices with PCI
> spec violations though ;)  Thanks,

Well.. If we defacto say that Linux is endorsing ignoring this part of
the spec then I predict we will see more vendors follow this approach.

Jason
