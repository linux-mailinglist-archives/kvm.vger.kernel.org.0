Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A448653ABE9
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 19:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356327AbiFARbA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 13:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353270AbiFARa7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 13:30:59 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2076.outbound.protection.outlook.com [40.107.212.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3AF78EF8;
        Wed,  1 Jun 2022 10:30:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K/xTX4g/ggVmcGKjQBpryYBIoSgLqQCR2gCt4fJ2U5gQXPxosjZy4I+BcjTgec3Di683S7fJ71KdEpTIh4dxLnHggu52A6p3GBFF6rrij20IUZjW3NotgqGN5jQuRB7Myfw3KJ78U64cwM5yIKpecEIA8YM3Ko9mi1bUcd+R/J9ksOsrghKFEmnOiV6Atu9Q8DuuDFZr1P1aN8oghmeLHkvOJeU5lNvKLyxHiTo/yU8QF/FsY5UawAGvEe8CO/WFaeYPppei9vJT+0EMT2xgWe5A5hH8Ej1BU8n1kVZ+UgWjmOLyFp7G07Dc7Zw9Yl87iMx6u54anZmh1UHs7KllOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sNcTJlpk/H0IO6FS7H2a2NXhh2FuUQUkqJktPPhQIYE=;
 b=KveG+u5jo0azIYBO4WGZkhuvj9ogNNW/0zQt/WhGLSJftwMWdOvjJeRZ5fAy5Cec5HjWkhpahE0zsTh1eWWqjBfyeAx6IQq+WMK/iXNz+bHDGwneQqQxSg6vgl6FYuJwWEgKCOASLahCw1hbMhlLXM/Di/EdlK6CjHZjv6Dc51MDUSlqBHyW90u8LZ2PWWIY+KfpQfX9SboUSJr4RM7zWAjTAaweJdQzJimW79vGC3jso+3dLyniOQZWkJ7fzsv6/Aj+/z0RQ778WGzaGpXRRawyls4o/9AJqDS9XPPcXwBi8PYO4d1taXsrNdSPHSpaytSsglYuswwbtLF5BH1oqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sNcTJlpk/H0IO6FS7H2a2NXhh2FuUQUkqJktPPhQIYE=;
 b=OHzmhx+nKzFWWJhYQYDp1V63A29TMH2IcnBRbmlYfI4HNmZDll58svjGF8bAdp8QtMQoZhCD+U+ti4orgWp+6yN+l7CjvLOsyI/FEEBH+kgDI8maif2rKGIqq6Nh8twktySnlxtA6HrJNMB20jlFQt/6xBYP305Zy8+5SwvsgZD2HyQHiq+vigDyM42oVQJgipVkZE5Yn+WcPNky3c+hZ+PqnISXnohFblNtW+SAkgC/3RymO9khFWBNqSSEK93OLeoaAr1VeFsQn9uqxMN7lTSxSqz7L2y37mV2B5Q6r8gMBA0fyrBhxVRlccg+pYq8y3gEPAtMZ3gbE7ONzZuJ1Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BYAPR12MB2677.namprd12.prod.outlook.com (2603:10b6:a03:69::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 1 Jun
 2022 17:30:55 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5%9]) with mapi id 15.20.5314.013; Wed, 1 Jun 2022
 17:30:55 +0000
Date:   Wed, 1 Jun 2022 14:30:54 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Abhishek Sahu <abhsahu@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 8/8] vfio/pci: Add the support for PCI D3cold state
Message-ID: <20220601173054.GS1343366@nvidia.com>
References: <9e44e9cc-a500-ab0d-4785-5ae26874b3eb@nvidia.com>
 <20220509154844.79e4915b.alex.williamson@redhat.com>
 <68463d9b-98ee-b9ec-1a3e-1375e50a2ad2@nvidia.com>
 <42518bd5-da8b-554f-2612-80278b527bf5@nvidia.com>
 <20220530122546.GZ1343366@nvidia.com>
 <c73d537b-a653-bf79-68cd-ddc8f0f62a25@nvidia.com>
 <20220531194304.GN1343366@nvidia.com>
 <20220531165209.1c18854f.alex.williamson@redhat.com>
 <00b6e380-ecf4-1eaf-f950-2c418bdb6cac@nvidia.com>
 <20220601102151.75445f6a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601102151.75445f6a.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR0102CA0005.prod.exchangelabs.com
 (2603:10b6:207:18::18) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5ed12c2-c2f4-45a6-3e55-08da43f47bec
X-MS-TrafficTypeDiagnostic: BYAPR12MB2677:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB2677A4667F3C1BB653F35B21C2DF9@BYAPR12MB2677.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FkmjBnlmN0tHk5ajN9DDLlUCsssADylAR56vuxEl7sA0dw2P7bI+FhyXJrixe3+CrvOHGPXQES1I1faWRMPIuRS44XU4VFW0+OkYmRTZHoj1LWpzYRSl9VI3e1M5XAZz4ygcBh6onNXal2DgXt4+82eRblGHwYcz98TcC6/Ff+LjlzAkijq3i7idsI3XRj5dic8iCYuAKrA22ZpDqYyIDYqlP37efFkrxgE2PnjV7xRutUX1AFnoijHJdihLMiSqi92VWgvxMVi/01cpqeqwX8U/VfH/Sp3A/Z7MXZxiKTyj41wK2sI1cH8i3nXyjbpYm7zmWq5z/styDOZQvj2SdAGh2eToHRMU86vwh+PHuerxZdFxRe0xf4QvlBAON8BkmeEIo8ZPBgx3MIWVtlbxGLBDBVIuX5ZW28txMNBtAXO8R2gt3UY1sbHQJY0hCtP1axmVRebzV2mkr1ACcV9+R2FKHigFE+8t2x0RlhUQn+C+ZzgsTqaqGiHtTOjHuFvyVXzInzHjyjewOnOfodSC5z9EWq+qyG98LrfLEjPi/kS7hUetckvIg6I+Nf12hABOmNqqwCOpdHssY6ZapU21EYokrQcJJz0qvuRpHAkiTBzORszGhaTXEggBeYDfFmHIx3Q6rM6nO8UiLQSXAPiuTOEGwUu6c9CzNCqcXA8L+w8g7ECiYWM94stGsFcgstDK2LtRd4pkdeZDrssrhsJoCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(66556008)(6512007)(2906002)(4326008)(6506007)(54906003)(6486002)(508600001)(8936002)(5660300002)(86362001)(7416002)(33656002)(8676002)(83380400001)(2616005)(1076003)(38100700002)(26005)(186003)(66476007)(36756003)(6916009)(316002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KsuwPF6k0Gk2w8l6XA3gVmKKtEoPZfivgpdC9xCTOz3duO6+jrA1jaskVdlu?=
 =?us-ascii?Q?GpewiUrd29Ut2OD+xSR9KcUBDHbaE2+mbYJormyQ/zN1uOGetYrnFEca0zpo?=
 =?us-ascii?Q?b4Ldx6Ct6QVHrFLGhKiL+7W9XHKCsh0ajEYhxcpoPNqs8ZxYo+Bd4tpBSHfX?=
 =?us-ascii?Q?zWDz3dZeEUzxIinC39/J4GOOF9AI5Seznc7gA22pCN9WoHXE3K60/lmovXgr?=
 =?us-ascii?Q?xEMLRwESZRGZtllEJyRiSAvd5gK7PKal/NBVBYF9VaiNgS6YcJ33UNMuLrxt?=
 =?us-ascii?Q?9UpjTRm8AwipdoQFQ+Io/OTOouETHdjgnuJBnBJ/PakkoiHh9DnzHw5Th5n5?=
 =?us-ascii?Q?V5OhCK9PFFS0nzhwbSEP7wdIvdBzoU9nGRR+DDXd2XMFUWZMGaOG/9sHeTV3?=
 =?us-ascii?Q?jlU5pQ69n3ISLcPNlmcIE0FWn2oQvr9pqrcAwK4TDoOiTQR0+8Np+HGeDzb5?=
 =?us-ascii?Q?K6M8WhagJibo/EmSXK6IDnL6jPlJOKmFjrg86rmQ38qqnWWeuOdjCb8QRfA8?=
 =?us-ascii?Q?SDU7maQZHnKGjofs0gHnuUSlxLNH9msB7S6NGs8qUKexv+9kVPaUf1y08Xyi?=
 =?us-ascii?Q?pIuKc0QEmFrU0kpjspY6rv9HFlHyLNGKuXA70+FSimRTr/ON33pDDhxlkMsw?=
 =?us-ascii?Q?U8ACgvXf1gxknrC9n/PcwQFYI55U+qiNbvQLClSolSrNjfqgc+kF0TOsczn/?=
 =?us-ascii?Q?qiqExaKoAiT/FxTHD4ELJRJvvb32ojWNWcZ+8Zpxsrfs2glEACA9zknE3KxH?=
 =?us-ascii?Q?45E4DKyVrDR0FkrxJ5dquDgTyYrtzntBUNqXiqPDa+o+Weoro3Csmo0D1cGq?=
 =?us-ascii?Q?WJfx70ZaFtr/yQDoyNH8Als08NGn7Zhcoeo4zd9KoBzfHW4K8tDFdBVu27zw?=
 =?us-ascii?Q?vVo6qYDmJycm9Xqq0XwQO/Bl66lMoT+o+hiXCZj8SVwv6+svC2+TpqVce0n7?=
 =?us-ascii?Q?CVvv245sdJYuyfB2pYACWTE18r2hVcLeVh2MLox5pjxeDBjjhSRhfquclSIG?=
 =?us-ascii?Q?jcE42CFwq8j5cRw73B0Rg32s/cGQn9m2lf3EAXqNuT1di79RaELpuYpjDjgJ?=
 =?us-ascii?Q?pCIR2zekDWeYCdD5FpWuGGqXlW3ZaPw3QCTiYwExpGWEZyakdSeDORjWK/hz?=
 =?us-ascii?Q?AFRi2UupEeXQzt2IJgRgJyr8VjJbcXr6A7utOyq/Gq5exSaONgQXeTW2TjIU?=
 =?us-ascii?Q?KuzVIoHiVU8ELYRAa4MT5QJ1GuA9lfDxw/F5kyg2D+Y3iBJ7iI4DF+gJ1ItA?=
 =?us-ascii?Q?yLLOlzvKvSFu/jttrf928AB5YERHXIW6Vpq/2gr3dDvIRtVJwK/Tlqi+LiKw?=
 =?us-ascii?Q?78OvLoeGVTvwBm9RBC6IJCM/CoblTLI7aVkzzLkgsL9YU/PQcj+lfxgYaG8h?=
 =?us-ascii?Q?sl+RtWJuTA8bWVnt5Lv1EfNxlfR8VuBCKojQBDPdaRpInsSXn78aR4NwW94s?=
 =?us-ascii?Q?WHKpLevrxslaztcTaH/EXDDqOU0hrsyCQ3Loqo5vjwzlPTtESRXit8DXmDJ5?=
 =?us-ascii?Q?GpA3CYqFKUiduhKrPV4sGi/O6VTq2OfHMzmU2ANQ5TnpluRnrA70HtxDM0Sl?=
 =?us-ascii?Q?9Wnnd2+yfmQS/57EZ3azAYJ/9conSKowgxnEvTxQ8YllCZAJuCTllrXCuInL?=
 =?us-ascii?Q?kVJmJUvOyER7lqSF91v/z8BOXUirjbY1e74tF7xxC2d30LOYZf0zpuohcL9X?=
 =?us-ascii?Q?Tf4YUNTZidVxkpQgms5D0xYq6yV6iuNyE5w5tcoBZNx675xQvd8SS5ItDhfx?=
 =?us-ascii?Q?1FwarTq+QA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5ed12c2-c2f4-45a6-3e55-08da43f47bec
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2022 17:30:55.8225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: efltRMaVMycoogPM/4gUWnWzlSetA9L/SoDKmyevzPmyO+EDNGRbWRXgToesi6we
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2677
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 01, 2022 at 10:21:51AM -0600, Alex Williamson wrote:

> Some ioctls clearly cannot occur while the device is in low power, such
> as resets and interrupt control, but even less obvious things like
> getting region info require device access.  Migration also provides a
> channel to device access.  

I wonder what power management means in a case like that.

For the migration drivers they all rely on a PF driver that is not
VFIO, so it should be impossible for power management to cause the PF
to stop working.

I would expect any sane design of power management for a VF to not
cause any harm to the migration driver..

> I'm also still curious how we're going to handle devices that cannot
> return to low power such as the self-refresh mode on the GPU.  We can
> potentially prevent any wake-ups from the vfio device interface, but
> that doesn't preclude a wake-up via an external lspci.  I think we need
> to understand how we're going to handle such devices before we can
> really complete the design.  AIUI, we cannot disable the self-refresh
> sleep mode without imposing unreasonable latency and memory
> requirements on the guest and we cannot retrigger the self-refresh
> low-power mode without non-trivial device specific code.

It begs the question if power management should be something that only
a device-specific drivers should allow?

Jason
