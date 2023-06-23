Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70EC873BCBF
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 18:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbjFWQit (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 12:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbjFWQis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 12:38:48 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 684BB9B;
        Fri, 23 Jun 2023 09:38:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ELbt0lwPC6D2M4LmVVVdCa1s3za+n8f2Jw79Q9TvwBms62znBx0AUEcITKbdEaCJkd12pqKwgGuSt0BaQmRkYD1aPsb3aQaEHGr1oAo7DpGZFMdZQGL2fwRZ37gLXIN2flgNS0mfwngR1PrZdoVKT2MXOHVUD6oI6kAJhMDAl9UiPqqiDyMd4EgO51qWaWbpD15XuYqUDUedaLSDq19HZtJU84svflsBe/a/pbPp5YgjgXfdXnLb+ymHzqxDPsMY/npDc1qrU6lEPiNSBgkxxzKlhMlVY8pRFXFjPWyquHO8qv9PDwrHPzijScbXm2Y8/pwNJBfrrVARC+P/wUCFOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qcRjeimoUKtZns525pG8mVV3zrCHtdr82RhFAM+9zEI=;
 b=CZ7Ly2evq6LZLQooAfHUFYJ8eTwkSdYorjpnZv6a188GEueo/8e4XlJI0nsQqrxwaAPuTcmx1RmH/1F8AC7dcEhpD3kpwEHnvLjsrm43q7B0AU5I9jiDbe2nwBf4XqYSfFBYzHWmieMacnq0bjqH6h6znygDdIs2LvTTnFZIz9GwCkPsfcAVa4krwgfzrPEPWRCfsOTGu638dK0lnPtfIj/ZxK6sPKKw9q6g4vwfUkpOzrOjAbdFy6AwHSypXGuw05g+uQW+vBOuQuvXZ5ksDmoivigcdXk4qOi/+9d5UijtFsOcf9b/GhN5RUdH4iA+Jb3ALBExq6rHItDZNCrGJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qcRjeimoUKtZns525pG8mVV3zrCHtdr82RhFAM+9zEI=;
 b=Y7wGCQIruZrLbaBqcjLibYSUZ9/KgMzAe51wqVbeywqAEq4nZoXir5bmeOl8iijmpES3lVSWaau+fyFk1WQ9z/qNScUdGTqtOStAt2BcgCaLtNN7Se1jCULe5fLIXWGyrAnd3ml5WwWbGPWoVAFCzQ8mQs/fqajO43Ae/P++LUIhu2ZWsvtmNlkEIfLtucPTFKTD475uBu5PFFRcbGuFIxa0u3PH0O0znBG679ry1ok4R4DbqptDgsb4WmMkQP4U4aK7HAskEXEldCLC9SDWjg3bJc2P8oSrxQsrcB3tBpsT/akRmGviZoeG3LHEHAwx6BrbuDAilYlJhdvhmE/a8g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8333.namprd12.prod.outlook.com (2603:10b6:208:3fe::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Fri, 23 Jun
 2023 16:38:45 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Fri, 23 Jun 2023
 16:38:45 +0000
Date:   Fri, 23 Jun 2023 13:38:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     =?utf-8?Q?C=C3=A9dric?= Le Goater <clegoate@redhat.com>
Cc:     ankita@nvidia.com, alex.williamson@redhat.com, aniketa@nvidia.com,
        cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
        vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
        jhubbard@nvidia.com, danw@nvidia.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Message-ID: <ZJXKk1csyLTfIRmm@nvidia.com>
References: <20230622030720.19652-1-ankita@nvidia.com>
 <46a79333-12f6-229f-86f9-1e79bdba7d11@redhat.com>
 <ZJWGbsaMzHvqqewi@nvidia.com>
 <62dcff6b-852d-4a85-dfd4-0ce1f324602e@redhat.com>
 <ZJWZA8ogUlGegx2C@nvidia.com>
 <4b0f4def-e2bd-b7b2-7c70-1df741780e1c@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4b0f4def-e2bd-b7b2-7c70-1df741780e1c@redhat.com>
X-ClientProxiedBy: YT4PR01CA0410.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10b::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8333:EE_
X-MS-Office365-Filtering-Correlation-Id: c3b5a676-aecf-45e4-7e53-08db7408502d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x0o3FaQP3HQdkvqHKyYaJEUszA73X0MIjDMlhJ0fg53FFklpYoShkhVSDytuH0PrLIEr1yrC2aX82WHW58gvjEbUVu1vIdHW7yNCQjN/9DdHT9Vn6kC39VR7UI+B5ujy2PJ2xp6SqmddO+DaHyt1RygVL1PouhQ7jg/MmTzTfmkdst7ilG6H/46CdWYzvMHf5VMRPukps4O1jY/AvvoVvZ16MIp/AEwBnxXPq/eR9cY3D/wpxHo7EjIcQ6+TLEbRwmJekTm9yqpFq2NruwNDFHLqqNNhXjCEGmePcTpH239B83Mw4bEnFZlGefMKrVNYh19Z5noLnGYNDqNQITdld6hTnv+XRjAZNfFOg2rqT3ekMPRps99IW75Hm2ELr3ObAnFgAOwDdi8zVCjWj8xu+9i6GzYRfxoQWHEu1KcgAYaZKooyb+BQ7yllCxDwWjjH4XgeVcTL7rUn2CQgClhq/FpnxEiwYGhQZtOrxqwIxp4+0sxTsot+q4olObHbWHiqUcb5PXtdW4EziCVst6WZLNigFtRz3ram7MJbG/SjLKcdK6a2M6W0Y5oXhe5I1HxV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(366004)(346002)(136003)(396003)(451199021)(478600001)(36756003)(6916009)(66946007)(66476007)(83380400001)(66556008)(4326008)(316002)(86362001)(6512007)(26005)(6506007)(66574015)(2616005)(6486002)(38100700002)(53546011)(186003)(8936002)(5660300002)(8676002)(41300700001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?em53V0hyTitNUG1Ta2xPL1RTbkJRVXR2UU05azVPSmVRVC9VY3FOZmVpaXpz?=
 =?utf-8?B?OWZOUEVPZTRTYkpUQjhKcGxhYzd1N0JkSFBhTWd3NmZLaHNXRUdxQ1AyUHpT?=
 =?utf-8?B?dUhmTEZrcDUyQXlhRWtiUGxTenpHaFAyNUFSUjRMRTNZT1hCNk9BaEVwNDd1?=
 =?utf-8?B?WGFFTWJ6bWhXSDViY3hoWGlkN0g5aXNaMS9uZ0RxMm1iVjk4YXliZTc5eU91?=
 =?utf-8?B?a0VGZXQ2RjRzY1ovNUZ6L01NM0JqWllSaWJSVWtQOUsxRWhZbFpxb1N4Skp4?=
 =?utf-8?B?OEwyWGlpMzJmMkZBdHhrZXduZUNXalMwN0MvY2hGbEMrVWs2TzRESlhPampW?=
 =?utf-8?B?blR0TkwxZzRxZ3NIczdWQ01SRHYvMkVVTU01YTZLTi9xT09zZ1dvV2RubVlU?=
 =?utf-8?B?SllVSXUxVTNBZUVZdm9iZVJmaDNFbVgrcWxxWVNzejRvSlk5Q1A1TkxKbU5G?=
 =?utf-8?B?UUJnS2hRTVBMZjRUV3lNZ0x2cmw2MDV6N1U2YllmU3loUEdjQzduTktRcGxN?=
 =?utf-8?B?NEtVY1gwZ0ViSFpXZ0VQMU5ycmZzN0VJenFZdDV3WUN2SmpWVTRHd1hmOEo0?=
 =?utf-8?B?ZzgvTi85U3puZUs4dFFwREtWaWxMSExUZWkrcGhOZ01oM3AxbmVkMkpDU2pJ?=
 =?utf-8?B?a1A4OFFiU09oM3o3bHBXWnkyMExmWWhPOER0ZGNqSVlwbzhHSGRkbVBlV212?=
 =?utf-8?B?Sml3SmlDWVlScFYzODk0VEE2ZU01T0NYTjUySnIwWWhzaFo2dmFpUXVTb2w5?=
 =?utf-8?B?WFd4VTlSQ2s2alltSk9PYXZmQlNTZXl3YjUxdCtnNjBrNWV3d1RNWFFOL3g0?=
 =?utf-8?B?L2t1T2dITmMrWEttQnNiaS9XbnNmbENLTjJSZk14VHEwZml1L0RaY0g2Qkxy?=
 =?utf-8?B?NUJFL1hRQ2pNLzZHS0N5T0hMbVNCWEJyS3dPN0JlWDJFU2Z6Wm1HNWJzQnNp?=
 =?utf-8?B?THk5NGpDcHVqTzc4d3o5ZUR2b0lXZUdMdDkyR3dHOTh3aWtkTHJwSTIzNlF2?=
 =?utf-8?B?LzBYSmdzOGp3MTE3M2RHWEhPRHdTRWlOVjAxL3NqOFN1VzdJb1ZySnVxbUd0?=
 =?utf-8?B?L0kzemUyb2l2cnpLeXp6SFY5TXJ2Nkg0SzR1c3dnYW1IUlUxRHI4VHE4WlBa?=
 =?utf-8?B?Z1hFUTZWUlFqOUdjK3hORm1Pd0NBY1hSbTVibzZuYWtiL3VlUU5VQzk5Mjkz?=
 =?utf-8?B?K3FqUlVNSEJtOWQ5RCtYdjBJOTJzYlY3WmJXdjFITVVuajNDT3VVTmUreG80?=
 =?utf-8?B?aU56ZzhHcnppelRhM0NjUnhNK3VFM2pFR0NPeFVuWkZEeXBkZkRsVHJMVlhi?=
 =?utf-8?B?aFV4MUtONm5hRGlBQnowSmhGY2JnMjJQSmZJR3lYNnA4dEQrRVpNRTR1akty?=
 =?utf-8?B?WndySzRMQVkwNC9yeFlNcHlKMHVUU0FFN0FjaE5YcmV3bDBVUnd0NlpMQW5r?=
 =?utf-8?B?dVA5cXFTOEFyd0JCbGIxMmhpbXkwTFg3ZWVpQmE3aURiWU1MYnVkeGtYTlky?=
 =?utf-8?B?VXdpbE9PY1RCSGhDVFI4RklmbmY2OEcyQXJTa2pQVUVjaUJQbzFPTVI3b2o3?=
 =?utf-8?B?Mk5WVWw2Vk0zSXFpbFFCaTlWc2J2QUhUVC80cHVzY2k3a0ppSUprVm41dUZJ?=
 =?utf-8?B?eklnMTJ2WncydzJMeUJkNUg0USsxaWZJTnZob1h0QkVjV2k1ZmFVSXlyZ0ha?=
 =?utf-8?B?RWhUT3Q2ajVBNjJ2Z1RaNlN1QjBsRnI2ZUErTDE0QWVuSlZxNzVEczFvUzl2?=
 =?utf-8?B?UkxidU91NDFmMkZJSGkyblYvQXRwUGIvRWVTMC9JdjNHTHgxK2htSHhTbCtM?=
 =?utf-8?B?cmVaZzQwSjZ1NVZNRGVFWGdDemVXNnFDVUJNd3pOdUhabXhsZWdaZWRkSUFN?=
 =?utf-8?B?YzhDLzFrY0FFdnQ5d3dMUkduL3hZMllSLyt3TndQZWNaM1lPUk1seFhubGov?=
 =?utf-8?B?Ym8zSHp0QVlWdW40NCtUVU9oS0g3QjN6QlRFcXo5ZDB0VFN2QUJIT1NQcEdn?=
 =?utf-8?B?MGIydENHVFdueTEveENuU1FSMm9MaytVOTN2aUdpZTExQ0V4c1hwbGlGa2No?=
 =?utf-8?B?b1JYbDFoWDhzZkVBOXJxeEFLOVRjRGhtRTFJQjF6dXRNTWNlZjY5MUROVUJo?=
 =?utf-8?Q?CRzGeNyRGDv1/b1AkrQT4Nb7K?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3b5a676-aecf-45e4-7e53-08db7408502d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2023 16:38:45.8014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kwxavs5ew2e901TGyxCBWRP9EwTh+SGV4FITEZKrdzGdhMIEmhL/HZp/b1iXwqAk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8333
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 23, 2023 at 05:07:37PM +0200, Cédric Le Goater wrote:
> On 6/23/23 15:07, Jason Gunthorpe wrote:
> > On Fri, Jun 23, 2023 at 03:04:17PM +0200, Cédric Le Goater wrote:
> > > On 6/23/23 13:47, Jason Gunthorpe wrote:
> > > > On Fri, Jun 23, 2023 at 08:27:17AM +0200, Cédric Le Goater wrote:
> > > > > > +	req_len = vma->vm_end - vma->vm_start;
> > > > > > +	pgoff = vma->vm_pgoff &
> > > > > > +		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> > > > > > +	if (pgoff >= (nvdev->mem_prop.mem_length >> PAGE_SHIFT))
> > > > > > +		return -EINVAL;
> > > > > 
> > > > > you cound introduce accessor macros for nvdev->mem_prop.mem_length and
> > > > > nvdev->mem_prop.hpa
> > > > 
> > > > Accessors are not the usual style..
> > > 
> > > I meant something like
> > > 
> > >    #define nvgpu_mem_size(nvdev) (nvdev)->mem_prop.mem_length
> > >    #define nvgpu_mem_pa_base(nvdev) (nvdev)->mem_prop.hpa
> > > 
> > > This is minor.
> > 
> > Yeah, this is what I thought you ment, I'm against this kind of
> > obfuscation in the kernel without a very strong purpose, and if you do
> > something like this it should be a static inline function.
> 
> OK. We could drop the intermediate struct attribute instead then.

Yah, if the struct isn't needed for some other reason

Jason
