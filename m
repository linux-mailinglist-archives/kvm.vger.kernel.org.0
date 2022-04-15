Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD362502975
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 14:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344553AbiDOMPn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 08:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240499AbiDOMPd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 08:15:33 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2085.outbound.protection.outlook.com [40.107.92.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6EBBF945
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 05:13:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EZ//d9F9rK35Lt5vyrDfYAS5UFfxK86n3ZcMu2GknOzJ1qIBQV9xNBqWz25JCGZBNqzMLl/zhVOym3X4ZkM33ooF6w5O5hmjF2G1UtXpqOT2bFn5Y4v3KxjrdBSRw6h+97kWoLaN6PYvHs6MDChheLifeCgyQrvKwBcB9xsFwS/wFaWx1ydaXsg28eyxJ5Txa89ZdP9Ji1Y7lZVNTRa+BhGXugHJfxrtd1OfyxV1K5W2xjmgCfqMtsGW191qrGrB/BqVCrUx+Bzyxue/+/N8ebOhxIT+VgF/ORdiTcLWToa3ykTk08cqemY56bWLb1Fwx20B8BcNZ2a8KT3MVVcVVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=llqXPkGF83i4VDi58WcqI4SD5J9tip2Mehbxh0kadDg=;
 b=e8bY0ARd930mlAwLHmDKbxl5H5YSr94c6g7N0mQLmqrXflfgA7ZO3iLUUBzTwKVToriF8iXOnoW+53B1PrlMkZRNUjTLA0uh3pUhtD7mLQwXyGFqjYma8niXYaOFOZ7GphdcRMviYJNbQgfuY339Zbrer+0YrSe9eQ1OhpMh1zaWrdEsIPKY2RfIUTHYHmMRTyshMtyngBXvIKzomO2Z9EMFbVuCPHbhIMd+MM6EeXlBoTrQINdXW16NPU4Roywul9o+SCd5mMK+InMir3zAmOYSBMYmzDFAklrZ9kvKE9RsM8k0FriWQF0o7IUxK3iX3aRNeIjO81K+SG0oFa494w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=llqXPkGF83i4VDi58WcqI4SD5J9tip2Mehbxh0kadDg=;
 b=UJnqJ2eeh/ig1jXdJ/2s4C2BUjzUfbX0B/33f1oXOG1eNJrIWHiHZ7s2ej8PSlJSabas9ysZG9eFdzlWQxvPVHP4hguh6tLjQu2+HizIXtSqSYlhjxXzKMHV37hjNLO8z4geFrKC4XZhogpup15cYYSlYZiDilwWvzVddiROkafBdzClRwhH1UH2nkp/CFlMAogrQPxGEu44UTKlU739LbBKj8JgE4H2Pfe3o7R9e+GJLIUVqozESIFNCGvVWwWz0xT3fnSsXHffpGLiZ6uK4iaoTyI/I3YDvftFiXB1GR7nDp4TLqaEjRV0UE2sxsoitIrUZU0cBlVx8OA8JDzdOA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN8PR12MB3458.namprd12.prod.outlook.com (2603:10b6:408:44::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Fri, 15 Apr
 2022 12:13:02 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 12:13:02 +0000
Date:   Fri, 15 Apr 2022 09:13:01 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH 04/10] vfio: Use a struct of function pointers instead of
 a many symbol_get()'s
Message-ID: <20220415121301.GH2120790@nvidia.com>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <4-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <20220415044533.GA22209@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415044533.GA22209@lst.de>
X-ClientProxiedBy: MN2PR18CA0016.namprd18.prod.outlook.com
 (2603:10b6:208:23c::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: becc9c57-dee2-473c-c8fe-08da1ed94a10
X-MS-TrafficTypeDiagnostic: BN8PR12MB3458:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3458C377E0EF407B936C37FBC2EE9@BN8PR12MB3458.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j0v+qhw8vFrN92vEhaQ2nw4ey38zpzDWhL5BO3Asdg9+xeD64MFpl4J9G+EowzRCLtDJ12VHjKGlvBgsXZ6Dgn/CRqardiDR5lFElGJWbCB8eXDt4gShdw02k4lefXP4uo1dSlTNzFy/nTI2y/HJMTGofAdk5Fw5vuDt6r5EUBHRiyIDgkFfCcOB2IWyUHwEvBCwnJbgZKdzDBau1foYCwWydcr70Me5H/gQzy6BIdTTJiEmHCNfbYPA88jofwX+l5chVuMDGXCMO4Sfp/EnTkiubajkKI4+h4KxPDpElZ4zDWEQk3h6Bc2KwhmPiGm/VRcafHPtRzaBkk5AvtML2dOmJc9pwGggXJyMoWjRRBXnz28sIZyyM1/yS99fh0g0fdvndw0pGxaSczY+YMZQwSQSnYqkpUGJ+R90GRjDJshcwJy1lFNLnIDIK43h8PPKbcIJVr/YWznAHo2uG8l9RLR7CaSK8xbbVjSSvBrXlyIRDgSobc1F1aNpwiZD1rOZagUYYP0B10aeM4Xw2FjM07yyG5gtALqFcykZXoltVazfegff2EMtnxveVwGQU13X3Az610fllksWGOlh6jH1jNRzBpjZr+BHZO0lF3vpwOI5EjMLreG1K6zI+CfXDKPIUO6slLAclIUWHKMSFzxwUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(66556008)(36756003)(26005)(83380400001)(316002)(86362001)(8936002)(66476007)(1076003)(6486002)(6512007)(6916009)(186003)(6506007)(54906003)(8676002)(2616005)(4326008)(33656002)(5660300002)(508600001)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7j6hYP/Hji5gQ+gkbbxsO0WSsxxrajH7ZDmIDw7TiHA+OZOxEpJo10PMG87k?=
 =?us-ascii?Q?bsFbk+71N/fqWG8YIFUPK1TI/eoiqhIEVh15m6WHEUSkgsy+jAhrOfEpoDsU?=
 =?us-ascii?Q?VaX12bhiibWkh/tRyjIJupL2LiyxWs4CIzeMhZGCK3ZZFME+dHiQPYKDlWN5?=
 =?us-ascii?Q?EwMx4NUEMQ29qse1E2Xh5qdSLR+am50g4yXWPR1zbHxuhTSWwgvcP1pX9GE2?=
 =?us-ascii?Q?It7VKdMjQlCMU3Mvf5unsQ8RfCMq1Uq3EGpammfCS5LTeFsimAwNE5Dg8Z1A?=
 =?us-ascii?Q?ozk49GEnMWe2PXF+9Cye/MQfAV31zRxyyRmFjQXw7fJzVumRB2JxIu9wTeG3?=
 =?us-ascii?Q?46EEnOQb2u5JyOZ/yYgxGWRxwAiY/gjpWal/jR4t1CV7f5cHAamExi0kVlV0?=
 =?us-ascii?Q?ZxP0+/0RvTOJRba7pIlzj5pymh+S4p+++pCHutmgBjrGotXn8PObiSw5Sr7k?=
 =?us-ascii?Q?3SblTXq+beGC0c/+8ELC0bd6CB8rxJy8IwZJaLOlHJqIF0aFgbQHEK7GgrQ2?=
 =?us-ascii?Q?71oDgVxade2UP79CM9gnocszGM7yaS5oZo/z8JCxCpxv4mN1JtC9cBDYr0D5?=
 =?us-ascii?Q?+eJtp/1xWDbGuINpLmp7dLZaPf4Hek1ozqJbZWYvU2bLM2P7+JVzWK0Ep3DO?=
 =?us-ascii?Q?25vr+GNM53AhtB9GtqMSegABeV6rNAiEHfB4SKOoqwhg2w1hHn+mds36tG5w?=
 =?us-ascii?Q?lCVdNBQoHHUIWD5YSP7PKtcimXHQfgvcXmdv120ASWeecCeFAMr6N40tndCq?=
 =?us-ascii?Q?PYJRhSwjX1/VegM+4efEZ2gd1q3G+8E4ZM0vi9y8wd0748pW3vnTxDLVzNMf?=
 =?us-ascii?Q?cadVfJSWT37zXdXdOA9FRIIrhdcUJpSt/TJO6rBqDy0vIc+Ams0G+hlwcQkk?=
 =?us-ascii?Q?jUtOxHGgVMmOcIm8dC4sreK/eb3deZyOOsJuELcZJMFYpAFl3MNKdluEwPqh?=
 =?us-ascii?Q?pbifKu6HDvCG0H/ZbGIqX+mLUXkA6Qg2eWyVwYkw8IhvysV4bneTukI2otF5?=
 =?us-ascii?Q?lqT6Na5/OVaZDukPdAf2TZvXN6fmzVnkE8G776NHdUP6+s2LH+dIdt/NrwgT?=
 =?us-ascii?Q?Zb9fvEjeHkDo0m7V5lVWPbipiK/kuJqOXGgaGyocjTDCnPfH6adblU/5EUnE?=
 =?us-ascii?Q?+t9N3aKxnA06sncjV4xezTaVWp5mxS5hGnlsahtMKKcbTqk/87/5HrU//h2+?=
 =?us-ascii?Q?lEv+sgm6ztHCzH3T8OFXj42btp+JFzUIgjs1iBXKxh2004P9J3lQrggFtR9P?=
 =?us-ascii?Q?AtfWSyQGzLk2jhvHoKwWV8Q/FLDT7nG/9upgsb9FvFe99YyVihQJHholvOuq?=
 =?us-ascii?Q?tcsw/7GXhzEoCGtaQIR/tlyvKrcy/bw+eA5cBiizfdOx9SqFdOVod5z6b4jh?=
 =?us-ascii?Q?tQGxl4oVuhFbfJ0SbqmeyCmgjIBffciV9J/md4m+/xP9DLCstfXCKjtWdJ/o?=
 =?us-ascii?Q?BEJthzB5UcwkfpoMPTtPHp8opJJ/j4iolRaDQZMuR9qlorroknYGXUSbhE9G?=
 =?us-ascii?Q?9gT3YH4nnyuodFEgLNiRaDbel7y9gkfoH/8q1lKZHqqv1jnSqyjFnCv94sec?=
 =?us-ascii?Q?tS2ghl/EnlowZf+mC4s/vjR/ISkA9EoVzrRz5GnhcHS86d7wi4QcJSZ8bwJN?=
 =?us-ascii?Q?7loML0V4oHgfdhtgno8lCfNDw+j9x/nDaAkZOye8h+NSLBcaz6a1f/zQ+zsl?=
 =?us-ascii?Q?d2J/ASDZY+uuXzgyrUM+SkdYW8I800z2TtweQNrQ5gqSCZVYaz4fgZZha9kh?=
 =?us-ascii?Q?nckh9YChLw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: becc9c57-dee2-473c-c8fe-08da1ed94a10
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 12:13:02.6946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X7UWCCSQbxJUN1VDeSWBUAc6Gujz6OHbmOAYIBsLVpLrj9Yi8mN7FP3u42cPgRw7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3458
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 15, 2022 at 06:45:34AM +0200, Christoph Hellwig wrote:
> On Thu, Apr 14, 2022 at 03:46:03PM -0300, Jason Gunthorpe wrote:
> > kvm and VFIO need to be coupled together however neither is willing to
> > tolerate a direct module dependency. Instead when kvm is given a VFIO FD
> > it uses many symbol_get()'s to access VFIO.
> > 
> > Provide a single VFIO function vfio_file_get_ops() which validates the
> > given struct file * is a VFIO file and then returns a struct of ops.
> > 
> > Following patches will redo each of the symbol_get() calls into an
> > indirection through this ops struct.
> 
> So I got anoyed at this as well a while ago and I still think this
> is the wrong way around.

What I plan to do in future is to have differnt ops returned depending
on if the file is a struct vfio_group or a struct vfio_device, so it
is not entirely pointless like this.

> I'd much rather EXPORT_SYMBOL_GPL kvm_register_device_ops and
> just let kvm_vfio_ops live in a module than all the symbol_get
> crazyness.  We'll need to be careful to deal with unload races
> or just not allow unloading, though.

This is certainly more complicated - especially considering module
unload - than a single symbol_get(). How do you see the benefit?

Jason
