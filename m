Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D057C0132
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 18:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbjJJQIL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 12:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233759AbjJJQH4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 12:07:56 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0969186
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 09:07:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Le/ZBu79W8QCPVzIkD2qLfrHgFcju04DCTc1sIymmiL1LDgnlrpZBjQtdTaXUp5w9vwtVFdgePaqB9AvGItAb5LHCAOSgZCLk/puX0DVZ4EMXzFfcTfvvYL4tyecqG1xqMfnUvPr8xs9o+KnfEcVKucUC8lNfuxl4vfEb51X4NqhJTvvrfsk7kaDueKAjTT7rgTZRhgSNoHdr50JCbEqV47+DbaAoRrzNV2ltIjnXlj1UDhnN8f722hlFgQo3BcYhWKA2IY8xoIn0Xd4/3doIVkF420DEVyAFdYoCxA/LdCxkDXZ/+NpnT8EVQpPjr9+wsQ4drBmGvO6dY4nH8ri0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HBKNkfo/sfLOmoxcoiTMK6xKIffELuOdRcwEum+dNL0=;
 b=OspUfmmwAOYX/V2T5c2qLBBgkNQnY/McGafbVIYJFUK4VHIV/o9B1D2997Swth3j+KYktsYfygkXV2VpLd354Lc9mbivsowhBYWZwZdu9cM16vG0PdgeN1cky6VdjETY2p9Z3fEbxMYDMDXr6vtVAC1vnv2pg6cbjca2S6wV+Jzpt/7z+bftBwoR6KCfx9TttqTMKOizMDnboP3z9R66zcb5Ar/iVsVqziQRiC+W2BosI+OWwBpYf+xtQumbXSgcU3EpLKf96LI38AT5CStl3Q66Ek+msqxlH6DM6giqfLsl2AaNArAqRWxGqT+Y3bXXkn3lDhFYBvpLECYmvx7dWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBKNkfo/sfLOmoxcoiTMK6xKIffELuOdRcwEum+dNL0=;
 b=UUWLFc/9WhMn99LdJIq9xivQvKP2Kdxr10adEZGEDIsFA5AaAdRm5/T7vSDP0XM9pR+4wyTzMh8jYGUUuY+2qjnkW7YcQ46YurxQUrKz4IsiPR7L1t0p/7nu2tRJSd0h0u6CnD0M01DZ7MOHr/XZsrPTYzVEGxfo0Gvl7GHL664SQcyYCEYT5+Qpwmm4V7pn3oUUcbWUBtsF3wDkHBAXEDoecrBTNmQc4eKS177ImqBAxEZc7Y2Wf5zAa/dZGLtnNysYubVQVdD2x470CFWDeKY1EmxZnWGZ9H4G2Ruzc4uMOU0eboAVtx/wILG60AdT6nmjBQ4vNSoKw3mBaj3xvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH0PR12MB7816.namprd12.prod.outlook.com (2603:10b6:510:28c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36; Tue, 10 Oct
 2023 16:07:14 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.032; Tue, 10 Oct 2023
 16:07:14 +0000
Date:   Tue, 10 Oct 2023 13:07:12 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        alex.williamson@redhat.com, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20231010160712.GO3952@nvidia.com>
References: <20231005111004.GK682044@nvidia.com>
 <ZSAG9cedvh+B0c0E@infradead.org>
 <20231010131031.GJ3952@nvidia.com>
 <20231010094756-mutt-send-email-mst@kernel.org>
 <20231010140849.GL3952@nvidia.com>
 <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <20231010155937.GN3952@nvidia.com>
 <20231010120158-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231010120158-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: MN2PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:208:d4::41) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH0PR12MB7816:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c908e4b-698c-429a-dc89-08dbc9aaf760
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i+khX3VqgEYU9FWozIp2sVf4/deYwfrdwkAB2oH+YnWrvgiI5JUu6q9+8kkWanqImmhV4Bl9+WIIzx9bXBZnUH+cIviC9ujtFYLcUFVcYwvanEPH9RfOGAzF2HG5s3NSry7TQA3BVgdXT95bf91igdK2YDfZuJUvEN1A6/d/C84mM707mJ1n1x4StmxXMyPlQuRpEqTQxWmVadyhv5iWRxRkylTdmQ+cuAqs1feYfymAGINXQFNkAD3xM04vasiw3aHPgFLlRA/GYfBL6Wxv8s+Sg18GUU4xWRgXlR2vc1QRGs0fjbNX1gI1PHPWtBb+UGlBwZZcHRi4Ze8a0JKWty6IatJROj6psb4LTAd0DImqseig2knTweJFGkEFCk9kRS+MVDk20GwF+pcfyWGkQRZ+AVaD4GSRL0moiU+sgNkn7VLxEZeqgXpebQdnsEC1G70pY12tdgko1MFEUnDrHS7a0VHN/C9kytrNcJVIrX+FdxdOKwWKJjQQW7WEGfbZiPuHdvMOhTUvt4k0wJ5rMedhEspM/rrhWn886Vj6mUjuG8eAmNfEfbcLZwppq+oI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(346002)(39860400002)(136003)(366004)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(1076003)(26005)(2616005)(6512007)(8676002)(107886003)(2906002)(478600001)(6506007)(4326008)(54906003)(66946007)(66556008)(66476007)(41300700001)(6916009)(5660300002)(8936002)(6486002)(316002)(38100700002)(86362001)(36756003)(33656002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+czG97aRxpER8g7gRHgK3MAkpG0lgsoT5K7Y44VbDGcrBOt3AKjX3/ahhHE3?=
 =?us-ascii?Q?Iyhccv3H947u6FGyr/W9AO3og0mjfVZbEIJ5NIbGl5Z5VYcpULsIab5SC8wL?=
 =?us-ascii?Q?rcrYc9V7pieZiziLpBf1JcIX1zH4QPz80pAgatleTOXp66a9fBIFAn53i5mL?=
 =?us-ascii?Q?XeFwMPSJrhNDIV+w4RVbjjOvReL1zzTBPIG0gmosQn96FZ2zIW5Q1URoY9LP?=
 =?us-ascii?Q?W034PiPddZvkCktFycVVnuwIViFBiDzp7gT6Av+LOL2OTON4VQ9CkpwenyPv?=
 =?us-ascii?Q?4X+eaMkuDtsTCmnKPzRXTV98NOMa0MXjMZApVC8PZzTFgglUUQ1geH1i4X1z?=
 =?us-ascii?Q?BRkEDDP0BT/GqmIeyxF1fvOOfiwrliJx15l4OOZVh2v536XlvZYm967ZiRwm?=
 =?us-ascii?Q?DlluMHQmbCBdoqRgn2ik3C1hqWQYnrfm6aE4vNS6tq0Kpi0qBvluNWLzof6I?=
 =?us-ascii?Q?ClHUOE3efkzqZlO8SaTFI01d4TNyBvllzz28QqfXrd6877HKI6fg4HsX3GyF?=
 =?us-ascii?Q?3UmbDttd9zxUpjmrKxwe0DYMntJacNva4VWFT/z70v2S2qh8x7K2xdQ8FeXT?=
 =?us-ascii?Q?cgUqq+vmvm1waLHo9x+Q4ZO9BeHKlaQY7eT8eKYxJfSAt4wSk1M4ssv6a8q7?=
 =?us-ascii?Q?bU0UwAz2r3CPKNmviRyCxNM/tiECkhnY2J/ywmPqA3v3eetmIKAdbL+jRyAs?=
 =?us-ascii?Q?s2S3fw4eFg7nAigThZ1c5iCu0Zps742FWU21SbUun2vFpV1fT/q0DLDEq1nr?=
 =?us-ascii?Q?/WfPxR/jHe30TPlcxS2t7u7fGe7d2dsdop9sOaqv8h2lCxHk33eESVrR/Bxg?=
 =?us-ascii?Q?YVV5LdnZeHBfC8cV57/LkUrzVpXkLRCPUNpEAXIsYEDofR9POIu9HG7ZvDfT?=
 =?us-ascii?Q?zCbnejvJuXFEBZ7i2QBWfXEzlf5wsBTrolXsBt7eYWLp1zfTaWRiPjposUI6?=
 =?us-ascii?Q?rTSEkN0dkIXwtN/l/3UZ7bqltB+wKeFc0KK1Ei5EaFBWsdcOl9W0fgBv0tAj?=
 =?us-ascii?Q?5fwaJ8rQsA6TKHiVbwA0JIWvi9y0ju/3RxB4DeBnsizxgUjmsahD/7i/TFeS?=
 =?us-ascii?Q?xQ3CnBBhF6bqFrUbQC2IXtpuM/o2fYlja+n7ihHKjrxkVMqGO1gK32zbyKQ7?=
 =?us-ascii?Q?Q9L2EjSkAfqdQENJOtrIsapeKo+XziZ1aV5tkHMCzrZeX24ZnCP/SQZonpOD?=
 =?us-ascii?Q?fnN72Bn6UMOlaws6MjPDggHISLWFKi1HZ8oeVEtfjWe6LfZFVt5aJ/SKVvuO?=
 =?us-ascii?Q?0zNebeW6wf1PaIbpadVdbk/Ws9AbhwLfx/fPuA+HUTW1tTTd0cfwllMcszYU?=
 =?us-ascii?Q?q+6vhz5cwI8FFidv2QXpccSGXMiD7gM7y57TETWll7xyhJnFX2YDD/1PzZwK?=
 =?us-ascii?Q?8ZH6DYc9/O2DocMc8myx6oR8Bi5fDHUbsM1moiLnvqyQdlHR+6FooV+PyZGb?=
 =?us-ascii?Q?RQmmYJQW/jhMCUKPta8NpXfHDophCmIcETc7kjUhEtvyhyByXz55+BnOKQyx?=
 =?us-ascii?Q?/b2mh6fbUdU6x3nvYXCaOb5jkxWTxqRpipGddUhYswHyJOHDkqR8XmcbSaXW?=
 =?us-ascii?Q?f0H8zqcsauP8I09hgIeOks7eTpw9OTnIYu7owDWg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c908e4b-698c-429a-dc89-08dbc9aaf760
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 16:07:13.6230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PTUiAPLx2yzOvgokR1WWKYuGq0Qk69xoGU2nKvvO3AIttxBWhVY8ByqEXtarBlRe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7816
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 12:03:29PM -0400, Michael S. Tsirkin wrote:
> On Tue, Oct 10, 2023 at 12:59:37PM -0300, Jason Gunthorpe wrote:
> > On Tue, Oct 10, 2023 at 11:14:56AM -0400, Michael S. Tsirkin wrote:
> > 
> > > I suggest 3 but call it on the VF. commands will switch to PF
> > > internally as needed. For example, intel might be interested in exposing
> > > admin commands through a memory BAR of VF itself.
> > 
> > FWIW, we have been pushing back on such things in VFIO, so it will
> > have to be very carefully security justified.
> > 
> > Probably since that is not standard it should just live in under some
> > intel-only vfio driver behavior, not in virtio land.
> > 
> > It is also costly to switch between pf/vf, it should not be done
> > pointlessly on the fast path.
> > 
> > Jason
> 
> Currently, the switch seems to be just a cast of private data.
> I am suggesting keeping that cast inside virtio. Why is that
> expensive?

pci_iov_get_pf_drvdata() does a bunch of sanity checks and function
calls. It was not intended to be used on a fast path.

Jason 
