Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A7273B6C7
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 13:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbjFWLuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 07:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbjFWLuh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 07:50:37 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579842955;
        Fri, 23 Jun 2023 04:49:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cBuLVLjBasYGTBcAChu+T+kuYyHit0n8G/+r3duQGmOysK2MzsB6EgfPyMiHejfKEYEuVUd+vytWnt3JutAztUruANxaHbmFnFNYyhDX8VPsgYcOTLFh4t1m3t0SgKF1sHguOa/HdD8eqFTwIvawB7eROLP1rOkaOwe7jG/DlJbIPnONBrFaaFSk0R/Gn+5B5hxXMLzvIkkgbt/o3Cc1sXH3/ncckRUxhvdqjJbqAyeJpntw6994Edi5ccVg5QkagvpGyss0LmUwS+gpwm9vwAUdPPDzmiFOGUTFuSUf+hkJ3j9OnnaN663AdoF3tsAGcf6C5bzO+Sb0YYFKbyUdnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=itBa3XzAyOu869DQvHaYTpESeaW6E6cOcLpjNDG17SA=;
 b=AGe4ogewjMOMuy7M7qiRkpJrJROesyEH2ZoXR6NLX/uRwEbRLqdY2rKnCAVHB7X4PHJRsX8gJwOOPL83Fd6VxqTj3TfAxI+dQoclEiAoeZi7Zj26c9hxOMCWBt8OfNc/GEl5fJaEZPOr27YN2bJ26O96zTJvsniwWpJmTtx9lcfpbnhmE/oCykbLviNZhEzXMlV059/A4QHc5p8GB94OP8a3m3uPJ9Fa1NXNL+V9CLX1nhL8bOZjdQEapIij/Z75uuibC/DNXAnlNAjxsUJNNcIFKPmHPTHHSEjW4YT7E7Pm7TPAxNo/1ypa9cqyiWH7JeNuhAJK9HogVfGTvhM4Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=itBa3XzAyOu869DQvHaYTpESeaW6E6cOcLpjNDG17SA=;
 b=tlc1yQuZIeRjoGJ5BJOeI8Uc37j6XNhatu91wbBSm5vCgUr943KeCMOs/B4Bds8qElH+GD8FUPdVbZvt+Rf/Vg6q8i43yYUMpYml5Mi+lk4TD7HvNdJrTSFkp/kd40tq8y9UQ5O9B/HNG32dipbck0/XjRpNHTtpVMS7FL/iYRmgsinYjU9gbFwiHNsbIJWpiK3EbspHO6pK3pqI6zOzKJwYhIewHroJYSJTekhAXmjsMmuJp0JIrCJAg4U49P0epHiYHhiz54qxDU4zU8ABvbUEruA+P15/5+1RrZ508m3wuttByFbTPNKw/XN+ngkaUMfhmGSxvLnQK+k2YZrVcw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA0PR12MB4496.namprd12.prod.outlook.com (2603:10b6:806:9b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Fri, 23 Jun
 2023 11:48:00 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Fri, 23 Jun 2023
 11:48:00 +0000
Date:   Fri, 23 Jun 2023 08:47:58 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     =?utf-8?Q?C=C3=A9dric?= Le Goater <clegoate@redhat.com>
Cc:     ankita@nvidia.com, alex.williamson@redhat.com, aniketa@nvidia.com,
        cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
        vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
        jhubbard@nvidia.com, danw@nvidia.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Message-ID: <ZJWGbsaMzHvqqewi@nvidia.com>
References: <20230622030720.19652-1-ankita@nvidia.com>
 <46a79333-12f6-229f-86f9-1e79bdba7d11@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46a79333-12f6-229f-86f9-1e79bdba7d11@redhat.com>
X-ClientProxiedBy: CH2PR15CA0012.namprd15.prod.outlook.com
 (2603:10b6:610:51::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA0PR12MB4496:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cafa732-9e6d-4ea3-1a62-08db73dfb20c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UUHfqmIfQYJdm6DxZ944MeK7veKpRHJHrZHYdHLqNO4+o0cawrUE1FE3itMQs7L2AW4nulG+C2d+wmb9OdLvDWpeAcdRsKc0I66JwVAiR2R0XI6kJDPSBe5NkErS8JggMiZcUSSKSEaaK81onuvE/9Zw0QFBoVxXdcIKt8xGg9gCQhiYVEd0AjQTj5gDmAorYciCMD4iA5MJd1YWPPoX5eXCYwSHz9sk8VabKxHZ7y/MXrAbqNmgh5vtgqMBz136UGwRs9t+cbAfHiTvaTkkZkJr4DFal/hFIFyzOGAjWYnmxQWIRAw3e9g4g0ibtCIzpEzW1b/FkU92WJkrLB8TJ3SJjMIt68/EnlHvpCK4ieVYhL0NQ6twhubs/4bl2nsbtTTJrJzqndR5s2ZRNqX1IjGiZcrjPOsxhMwuyYMcfqdxMUP2B3tZ9UJH0CYNeYH3gX8pHUL03VlhrLJsvmgxyl0pyGJ7SVS4lEuBr0jj1GTl2eYiPaR2pmHuiJmlvuXrhorLXBZH5DZ0XtJEqHcpXw+VOUO6vtpAEIUVcSXeXNf5VaMsuRjE6uMWU30gDVpO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(39860400002)(346002)(366004)(136003)(451199021)(4744005)(5660300002)(6506007)(2906002)(26005)(6512007)(8936002)(8676002)(186003)(41300700001)(83380400001)(2616005)(478600001)(38100700002)(86362001)(66556008)(6916009)(66476007)(316002)(4326008)(36756003)(66946007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXB0WEg3NitqS1NDcU1YWHZNOHNHTFlkTlR3amk1NUdjaVhIREE1WVplTEto?=
 =?utf-8?B?NjhpeW1Pa1FDSFR1bHY3S3dMK0VJWHJTaXZob25iVjNWb2xSTFdaNFFPRGRm?=
 =?utf-8?B?YlBrSkNPT214alZ1SWxVOHorci9XY2tvYXk1eUpXUVBDTWhGT1RsL3V1WW00?=
 =?utf-8?B?NXhFemZlRWduUE1IQW1XN3pLc2pBT2ZYRHhCemI4VWJISUNGL0dHakRybGdq?=
 =?utf-8?B?RFIreXY1czE3LytpaGVJSkozZHJYUnJGckdkcUxvaXk1V2o4K3U4cWtpZGhQ?=
 =?utf-8?B?bVA2Unlma0NIVkIxNVl0by81anBPcmx4blovNDZjRElrOGNMWVNTa2tFRlpN?=
 =?utf-8?B?cDZWbzdWNG1YNHhiS1BPbGsvUGVXb0NIQ3RRTklkVENpckVVYkNYL1liY0x6?=
 =?utf-8?B?ZlRqcTR2NlIyb3ZnejZmaTVoOFU2bGJQeFlSYUlYM3lDVERUeExmZ1dJdzhF?=
 =?utf-8?B?QkdjOWdkZHJ1VWc1ZXdUVlZuT1RzbVhOL3RZOUdTZWpPTjN2RUs5OUlNRjZ3?=
 =?utf-8?B?RmJjNll5a2xxbUZoU3d1M0FIZmx1amZHNTlRUnFsMlVSME5RNGMwNkxwbTZ4?=
 =?utf-8?B?VUk0SmtNMVQ3WnJRVXVjZ3Nndjd3L2Jab00wT2IxT2VQNWwraDRzZlo3VzQ4?=
 =?utf-8?B?RmFGeGpRai9nd1k4clhTcEtGODJGUDlZaTk1cnFvczQ0dW94dlZGUThXdXdP?=
 =?utf-8?B?RWVwVjFiZ3pGT3ZpWjR6YjN0RS8rQ3lyVlhiT3QwYmdLQ0Y5aEN1cUtnbjV6?=
 =?utf-8?B?Q0huL1JyVEQ0Y0x3SHlCM1hiemd5cHNjRlhYcUp6NHJaRkRPY0M2cGw5V0tn?=
 =?utf-8?B?R1BOaHFYU1hiUDFaeGdCM0JhMy9UVHhNcjJCNDR0d0tPWTFjcEZ0MFp4TW5l?=
 =?utf-8?B?N0RqQXlhcndNOG1razFpczBDNHJmLzVZUmRyWk42ZERGSmdpdGZENTE4VFFK?=
 =?utf-8?B?QVI1T3l2eTlMeEdwNm1QdjZJdEh4dXJSTEdUMjkvN3VuSVJlRnFyUUtWTUNF?=
 =?utf-8?B?Mkt0VmlNcWhHWlhpakRzak4zcFd5b2xRWktSZzdCZTl0STU2bEJRUjBTTE8w?=
 =?utf-8?B?OWNEZWIwS0IzcmZxK1VmN0RWK3JhOTU4cDdQRFhGc013Z0kvdk52Z2pVcC9W?=
 =?utf-8?B?YW90RlowRmtialBLaGY4elJ1c3ozUDdQK2lqamJDNit2ME5yWkRNMFBvdGJX?=
 =?utf-8?B?Rnp4ZHcrcE5TUDRYQStGR0k5dGVoZVE5NGxGRjFhU2xkRzhDTzlIWGYxYVNh?=
 =?utf-8?B?bDNZRE91N2dGcFphY2pyRVNlaUNPdFdCUVkvb1VydTQ0dWo1N3VyTVdTNnAx?=
 =?utf-8?B?U1RKd2M4d1pETWtRYmVhWWJ1blR3OFN3TFBvbWJIWms2L2lUZTE3VE9yU1Vu?=
 =?utf-8?B?YlZTZ1J1U0ZYaXBiTmFnYWdBdGlUQXhBejdFT2gwVGR4bi9QejcrSHZTVHZx?=
 =?utf-8?B?MDJJTUcxVWJ3UjlONHhhM2ZPR2Rjd3FWMlYrNzNZcnhONWxvY254dXJEdW5m?=
 =?utf-8?B?OUtpSitkT3dTUHhtRnJkUlpUNUs2S2h0emNGNFRPbEhJMlJKNjVlaVNVWm5u?=
 =?utf-8?B?TkRlMjE0V1RMWVg5cnNST01TMm03MUlsU1BiV25xa0NPaXdtN095MkhXVTlP?=
 =?utf-8?B?bWx2MHFuY1RiaWZyVTJwczRzSUg2cUpqTy94RTZucHFGN2VXbllkR1BUMUVP?=
 =?utf-8?B?R2xYNGZQeGdzQTN2Ymp5NTN1bWkweEpsVlI3STl6S3pzKzMzdyszTWJBcHRL?=
 =?utf-8?B?ZW42SDBIaFZzcHpLSWNVRTk5UTByaURXWW0wTXVTMHoyM295dnR5MlgvUVY1?=
 =?utf-8?B?dlFWS2M0Vk9UMVM3dDczVUdzRStkdUFUWmhRejFTRFUyMUV5c1Bjb2EzMW8w?=
 =?utf-8?B?MEx2MTQreERaQi9pTDRCQW9UMnV6NWg3M2lMeEd1TlMyeHM5ajExaE5zUjFU?=
 =?utf-8?B?TVZHazZ2TjgzUTBsT2FYY2EyVWZHOURFcmVTR3F5TTQ3WG5hMmxCWGpiZFps?=
 =?utf-8?B?dDFRMStMeTdkRUdocWt0MVhFOThER2VjSGlYZEVyeTI2WU5Yc1hTeTJPOGNv?=
 =?utf-8?B?ek1jcHg4cVpsVUlRajVFTk9sVlZ3Mk1na2FWZzQ5cElDeTBvbzlNdm8wOWE5?=
 =?utf-8?Q?WazPaw0BsCR2DFRX/fxBZA64K?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cafa732-9e6d-4ea3-1a62-08db73dfb20c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2023 11:48:00.6449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YcSCAD75zXBihjJELshw+qQyCXzVZY79Q8IxW+TquQnbIC6z9Eg64GNuJYtgfFQZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4496
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

On Fri, Jun 23, 2023 at 08:27:17AM +0200, Cédric Le Goater wrote:
> > +	req_len = vma->vm_end - vma->vm_start;
> > +	pgoff = vma->vm_pgoff &
> > +		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> > +	if (pgoff >= (nvdev->mem_prop.mem_length >> PAGE_SHIFT))
> > +		return -EINVAL;
> 
> you cound introduce accessor macros for nvdev->mem_prop.mem_length and
> nvdev->mem_prop.hpa

Accessors are not the usual style..

> > +static const struct pci_device_id nvgpu_vfio_pci_table[] = {
> > +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2342) },
> > +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2343) },
> > +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2345) },
> 
> It would be good to add definitions for the PCI IDs.

The common form these days is to have a comment with the marketing
name, we stopped putting constants for every device a while ago.

Jason
