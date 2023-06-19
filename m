Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA10C7358C8
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 15:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbjFSNmE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 09:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjFSNmD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 09:42:03 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2051.outbound.protection.outlook.com [40.107.223.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF0794;
        Mon, 19 Jun 2023 06:42:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=giwtGSzTdoSrGK2tiE40gW1GMAtlqI2m8iIheNvK4UV9PgQfOcw8VyQV6BF9MYfPtYhtAgKXPeYS9VL3Zn9zsAw8ojuNtTMozSjjI+5qef6+FQmd4BSjOsKHNBc70qC07crlr59xMxPbEtH4vc7xD+QwO7LH1bN8VLZrG9DuNLMqYolRU7aNNcawvNVey2mXu3hqBAB7JA/7DPBcRc8CNnrl4BfjSLoJK3zNF4S6Fz56gnJfd21/IZGlHeSkdE7Ewh908c/rq8UlWjMbKDsSJcaamPbFR5t9aXzekn9Pyi1fv8IosPGTNRJSfXzVGYiP2rDknVq4A19Mza6rzWWSlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qGnBcvIuP137OlW3Vdh72aVuv4pTvxMhFh2RbpRrbbE=;
 b=honTqLgp9Y43tt3IzZ1d/kvVr0mSW/wpfr4xpZQ81Qw/Ol782y2oEVEFL5fWVuRma9SieZe7Z+YRCHhG3HKBDZD5/Eq+S9DTkU+SF5fr7FVS32XmRZPA34W3tPp1uIIBlmpxN14Bx2G6ZPKAgPoPCv7SShvYRRXtexzI8zFHtviJ82KIMuzFeuaD+VYhHGNQUHtrLcR8K1YaBx1ElSf63Z6X0QgSlsnaFzQk4+vJiSoiVPBSSrC+360lkUw0gzCncN2BshbcFeVbMiY7E+S/qyg0v/fGNt1SsdjcyYihuMHlv3Qj7oItn62uOnt7LFQ9L9ndpjjHhelwubKLLMwhzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qGnBcvIuP137OlW3Vdh72aVuv4pTvxMhFh2RbpRrbbE=;
 b=e0QIw8CT4Y3RdfiwUaLrRsT1Db8fKQFLMvey7EeMXQ7tZDiXbyH+jkgWs8I6wQWLQ6i75Xn0S3HQewe+sRQXFDJOjrpEWqXziK6sDpQ82DPp9ootmDdzo6iEFFDHuK94a3u6tUfYmVYAZac/iroQKteGOe9t4XK14RTsR5bmZL5ML0IPVyKX0YSXcsWKa4b22U5aIcMSybK6EspN1bGmxNEwK2MOrFL09mixipGAThtFKBL3GOt6DJ5c1+bgPKGQk+OQYP3BQGTg8WdIqCMP8u9aEi2jaIXS/ORcy+9UpqRIzNsoL+Ds9fc0QHcP/rdcMXrTk+iIbbUcBc2IWGVX5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4124.namprd12.prod.outlook.com (2603:10b6:5:221::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 13:41:57 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6500.031; Mon, 19 Jun 2023
 13:41:57 +0000
Date:   Mon, 19 Jun 2023 10:41:56 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>, iommu@lists.linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] iommu: Prevent RESV_DIRECT devices from blocking
 domains
Message-ID: <ZJBbJHevOa8mAdll@nvidia.com>
References: <20230607035145.343698-1-baolu.lu@linux.intel.com>
 <20230607035145.343698-2-baolu.lu@linux.intel.com>
 <5d0d6665-93e4-f61f-d700-008c0fcb4a2f@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d0d6665-93e4-f61f-d700-008c0fcb4a2f@arm.com>
X-ClientProxiedBy: CH0PR08CA0006.namprd08.prod.outlook.com
 (2603:10b6:610:33::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4124:EE_
X-MS-Office365-Filtering-Correlation-Id: 05bb2a6f-fa78-4b64-b149-08db70caf371
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FGcg/z9JeM29qz8U3r7QAtjjo+NOiNobo5ZpiYI1REVNyTjcm/ds+0TyupSt40w6+al4aIiaIRv70MaUss/TJruiDqKZouFmPZnSI1BcfJBvfvnsNxStp3UvVylyB5M8tQTqLBtwqA4f9WH8MJ6DbLwXQJRBtOu2Ipsw2LDikRPQEeGgC8eKU3dQjxofxqCs8FTAaAw19ZmPQnwI2hhvVxKITXtoohu6MQtBDZvtg0oJf8ShE3WBq4hgsfi8DP18YpeaeIjyaHla9UqXZS6XL7WtGfoCSHjeOO2MbC/j+VOquZkXkWyfqGwsLJUTgaEXPZbWGuHxyuv8p8peOOLTUcQKduvjOSQLQpfC5ZiX7A3fPJ1qJqz72obwZQ6lqmolFvW57PTlzDXp5NIDB8WfBCIQlzNlCqqLx5Ui3GP2uEOLd/kbWWJTKyX4ZMxTAgyoNVqx1EheC6+XYiN9VLkEPUGDN3C16AFzMeE/r/g82Gh/e8koA1Qb6NsaM7lyZ9RC9ora7Oqa2n32+0iT+8fawKSMoJBPssevav/skc+M01ro4qAZndw5j729jKIekLYW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(136003)(39860400002)(396003)(346002)(451199021)(4326008)(54906003)(478600001)(6506007)(6512007)(26005)(6486002)(186003)(36756003)(2906002)(8676002)(41300700001)(8936002)(66946007)(6916009)(66556008)(66476007)(316002)(5660300002)(83380400001)(38100700002)(86362001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tkL6+7vRepiu+zfUhS77rHWEhADrWo7ycJ5w1M31xNSrTBCQEcuwUMu+Ffjr?=
 =?us-ascii?Q?/KGz1XevPRVhjNQNk89m6BmW9xQVCi677JrA8MUGY3UR2rvUF33X3UKVN5Kv?=
 =?us-ascii?Q?oWz3V6Vi+nv/qN/pE53Yw3whwcf3rkVsLTAlac/mGQ0QrP/TcMCoedl5x3TT?=
 =?us-ascii?Q?x4UkXZGWlznWpYRdyDIW4YkSpYx3xaVLfNgqkIbUw7e6y0GQbHQesDDSZd+1?=
 =?us-ascii?Q?zh0ZANnxu/TOyE370//N/30jvkSBTmOvwi+KK82OzLmQkPCcLR2I0mXlaoMO?=
 =?us-ascii?Q?CvaICw2Y+E4B8TfLIxQWC9Cnf2qUCJi/z0sbVigbqLiDNsz14aA4PN00/+Tg?=
 =?us-ascii?Q?Y12o7wysxg3EAqMkPjcqAuQ8x8b4CEwEO8zimUSqJ7HUfQJl7FciWbs9xy6Z?=
 =?us-ascii?Q?Z0bN4yjMUx52wE4nXfBNJP7DjKTqPEusGWHmkkA8UOQixiy9pN5Gn4E3NB0/?=
 =?us-ascii?Q?TbQ70XFwL+CP1UXDjnXImj0U1d1HfDoz7h2VCtF60yCMnYNHvEzu0aA3b2zn?=
 =?us-ascii?Q?TOFqOQb1lAJFNgFoqxGI9T7wGl6Ra1Ejmva0DE2xfDkcOvS5JIiEHWJ4KoZT?=
 =?us-ascii?Q?NyLCqxkPcVrjQITk/P/6VWxG5wpP1JVszUj2PqflR0pxoYHoAR9abQ/3xtsb?=
 =?us-ascii?Q?jaLb7IUFjn1TMFdqspeAbuZGndqaRmHaiLNOy33DUvsjPsJq1Xv5sJpUglwH?=
 =?us-ascii?Q?a0G1gnQwTiyFVokAv6eJdHDW9CqbQXDKgU3RO3aVxbamc/SMWcdHiX3NDBBK?=
 =?us-ascii?Q?8OZlYQ8r5ZcqEawo+Xv3ts3x5nDKHZYvgMjFbMo6whckkRA2T92Zu3YiYY7o?=
 =?us-ascii?Q?DUCOacA1vwUgtW9U64g6pZ5cXXSgnADvTQsZ1L1CwJL19UgP1EneyXyUlDXW?=
 =?us-ascii?Q?WdX4yFkyDK9YN6oRBWIQI+/PYfEXCXootK5tvS0MFJRz1iMvjDgC/70ROKMI?=
 =?us-ascii?Q?jqvoG64i7mSfVM5w/2BOxx41YWTPSuJa5qCLOud4+8qoM8tV9/7PGTNaYgP0?=
 =?us-ascii?Q?/fIRhM5WsgRM9NbKwkUIkPDUwaQmWvFJ936VyJQdO57tjCAhnsd8L7hrUpR9?=
 =?us-ascii?Q?srHn8h/05+7Q3Uus+2E46mIDOjNAFcSbfr9dK0ovL3ZqujeG/Lh1aJTrV+bX?=
 =?us-ascii?Q?Zfh1nVs3so3cCA/UQ/jwuIdeakYGCpdPSn0pHMEqcqNSDUx7qbE3prsxJof4?=
 =?us-ascii?Q?i3qFjsVaEd613BesQZCvDfQ6p/uVaFuae5/4FYX5V3+eVpPToSdGOR6NKOwj?=
 =?us-ascii?Q?IODuWtpzoDjzOJlHVeNwvzN5oZOSLxxPBkCgHZGAj4PIQPe7J6I/tKOFbQQb?=
 =?us-ascii?Q?o9xL04LL6MoLe6bPeXNWuNKcNS/A5cLc1XSXb25R3DZOhz+bRqlmSKAcs0po?=
 =?us-ascii?Q?AjfaF/bAL9j44ckQrNNrTl2LyNE4kBTaLIbSc5vSsxjWlhuPygFH1kdA/XRU?=
 =?us-ascii?Q?f6XvfWjeJ1R5CHE2rWQEnAkv02qlCkQhGjVEx2nH1hdHds1MgIUYl4PyBtl8?=
 =?us-ascii?Q?qOHTG9/ISENEwI/i4yWzNLuWJrrmHprxX78aXAZIhOVYxs1xlmKvntLYMJT8?=
 =?us-ascii?Q?p6+yBQnm5Ws2uZikMFPEdektGqzo/B1aTCbCr16P?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05bb2a6f-fa78-4b64-b149-08db70caf371
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 13:41:57.4222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: if+WwYqhIU682rxeHSuhsnilLZhuqn+vG7OKtOXKW3LMWYUGY33Mb7uTEd7LvQLl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4124
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 19, 2023 at 02:33:18PM +0100, Robin Murphy wrote:
> > @@ -2121,6 +2125,21 @@ static int __iommu_device_set_domain(struct iommu_group *group,
> >   {
> >   	int ret;
> > +	/*
> > +	 * If the driver has requested IOMMU_RESV_DIRECT then we cannot allow
> > +	 * the blocking domain to be attached as it does not contain the
> > +	 * required 1:1 mapping. This test effectively exclusive the device from
> > +	 * being used with iommu_group_claim_dma_owner() which will block vfio
> > +	 * and iommufd as well.
> > +	 */
> > +	if (dev->iommu->requires_direct &&
> > +	    (new_domain->type == IOMMU_DOMAIN_BLOCKED ||
> 
> Given the notion elsewhere that we want to use the blocking domain as a last
> resort to handle an attach failure,

We shouldn't do that for cases where requires_direct is true, the last
resort will have to be the static identity domain.

> at face value it looks suspect that failing to attach to a blocking
> domain could also be a thing. I guess technically this is failing at
> a slightly different level so maybe it does work out OK, but it's
> still smelly.

It basically says that this driver doesn't support blocking domains on
this device. What we don't want is for the driver to fail blocking or
identity attaches.
 
> The main thing, though, is that not everything implements the
> IOMMU_DOMAIN_BLOCKED optimisation, so a nominal blocking domain could be
> IOMMU_DOMAIN_UNMANAGED as well. 

Yes, it should check new_domain == group->blocking_domain as well.

> FWIW I'd prefer to make the RESV_DIRECT check explicit in
> __iommu_take_dma_ownership() rather than hide it in an
> implementation detail; that's going to be a lot clearer to reason
> about as time goes on.

We want to completely forbid blocking domains at all on these devices
because they are not supported (by FW request). I don't really like
the idea that we go and assume the only users of blocking domains are
also using take_dma_ownership() - that feels like a future bug waiting
to happen.

Jason
