Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 222F54D9F66
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 16:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349415AbiCOPyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 11:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343807AbiCOPyT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 11:54:19 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D95B1098;
        Tue, 15 Mar 2022 08:53:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TdXI7V+fYlh3lxlXZmt8XsvR2Ua0vqMT+wE44zQsbd0hzV/wnWuvRnTZ8kVpNLIzwCWaUfdiMsNGqytUQfPmwDLBSw5BnxSn37oBTvRizSoF+jWWUEaiOI3Zy2cbzTafbg+0hMYJ9jbVbWMVgIJTAjDf/3MgXczKCIFiNEYxZWLCqeyhuIMEMFX9hG3/BHvT6RLSLEsaWZ29bWbRG24m6jiy3PXEiWfqZRiWPuPpClIacvwS+cHookbJDo6WmFelTwXCqmmlArZaiIC9CK27+V/yyVi6QFUCFizFTr8H8QBas4FXxpQy26/qPe4PtgeQ98HE20KDIcngOMGUj6cx8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LTM96XFO/0LmNGQnCDe2Xt97iXmT5/IWzhbSRsmJuRc=;
 b=CgNKzoVjyrk8QDngEe6KhNOc+ytVNVvT7+0pCs7d224MS5NOZd+KPlWwrWtaHVVtCQTIlPeBkzqwjX5AlQH1ibwVxyifrabHDAsOUpLenfHfB5P+Ag7v9Ig0guF6CeYwsuVmYE+anjR9/T7inbhFY/330ouNyM/HVDxOx/YJQaQSEbHLYkJaTUmzMsoaxOOLs+1+x42FRQ+1ygcSszk0FRM5AFXtBSe0SMhEWqvUD+lc4hOabvEoe5Jjt83L62LFe3VTIvwfEWE/A0rWuu47vJcLIoLEmfqRlZfZeSEdOi/Bviyq65fSOarNSDXCp05ftF+qQuYBbE4ocbvADa4F6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LTM96XFO/0LmNGQnCDe2Xt97iXmT5/IWzhbSRsmJuRc=;
 b=oxcyUk27oZMxBctAuQvv5UV+0/6GEWv0LwJvFn/Ocwh9+SzLZtBPKlJ+dNLopkAf5qko7i+uFyPm5/XU16/GIot6JqZzzGpFFFHe1NcGzhhi5oJHT19wueZ1ehcrk6TQWNsZLy0aIrSxrTxzfoa3Cq1gQ3/6SD2sKTfVZ1zSwHKqq7Fe9cHOllSg4OrWw6PXeKtesSq25OOy+9r7Jj7n1m8s8F0YJwskk2UA9OFFq8zSE1EpTeZJhsN9cauNaMOrQlFvKrOf9xw6EqjlrLkbzXB4JsJVUdknGZ2oQKgyV0jsip91nx8H+IY/mwcdU92do+Aj6p+zFhwKRx/bXCajyQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SA1PR12MB5671.namprd12.prod.outlook.com (2603:10b6:806:23b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Tue, 15 Mar
 2022 15:53:05 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28%4]) with mapi id 15.20.5061.029; Tue, 15 Mar 2022
 15:53:05 +0000
Date:   Tue, 15 Mar 2022 12:53:04 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, yishaih@nvidia.com,
        linux-doc@vger.kernel.org, corbet@lwn.net
Subject: Re: [PATCH v3] vfio-pci: Provide reviewers and acceptance criteria
 for vendor drivers
Message-ID: <20220315155304.GC11336@nvidia.com>
References: <164728932975.54581.1235687116658126625.stgit@omen>
 <87a6drh8hy.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a6drh8hy.fsf@redhat.com>
X-ClientProxiedBy: BLAPR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:208:32b::34) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 376e4519-5051-4f10-8656-08da069be4b5
X-MS-TrafficTypeDiagnostic: SA1PR12MB5671:EE_
X-Microsoft-Antispam-PRVS: <SA1PR12MB5671E5BBB362C59B12201517C2109@SA1PR12MB5671.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +toLMVLUmXGT5nI/PcFLiHHrnOaArG6fmlwM9zB4RVoOAEX2hbzKjZ2Lyac+oBy53mCJOzJZ+mTUMluKisxmEPlYvEUmFMMTs+auHrm7wYsW8gvk0qkOOckm5SggwL+58yshU6gWemZBhJYm+OUVeYnKqJe48wGI50vipFiQnS9UPz4vHVJG8/bQTJ9B5BhSP8upJ7PhtAMU2QXGnRfSbPHHS+a+s43um/zS00xCsT9Fj4YbA7vH+x9i+xSwpvNne1lny/H0/H8ZBqPI7dpgwWHByI4kXKe4QMaeYJxpPsfzlBr9B7p6UsZgltM9Q8E6p2r4CKb15ZifAg8huNi40z/yDk5EX45xGSftxKXj/Wr5Qx2RzMnHPS1zKeldIMz0mTHJcqY+jISLLg8w85Lgu+QHJ0cgmA65ru92XMEUBli6juGMrTK1sRtQgEvwxn38JSYJI5wGhh4vEv4klVWqwNxFO1cUIYZvrwXjU7eJXR2KnjPZM7JnmASFY1W/1GAQHSr2P+mDVzvmUS130czvtTqebltT5L9tv/GPmLRmzRNI+vGUzBB6NXQI2q5v5CaJ44J4J9LNG6UbV7KNjrwfUGb91MQ7lACKClDrE2fBPrB98gVbaJOsVEPvgsaPHdPv86wXUVAUaQTK4gwlJCqlSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(2616005)(6916009)(186003)(38100700002)(8936002)(83380400001)(5660300002)(8676002)(6512007)(26005)(508600001)(1076003)(86362001)(33656002)(36756003)(6486002)(316002)(66946007)(66476007)(66556008)(6506007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WanPxfu8lZ3iEZXlaFyx6DFHEItDuo+9doD6cg0X5brXQsmOHjNTuxhzC3Xw?=
 =?us-ascii?Q?kQE3JhOQ8DQKFN3jhqKdw8pbMfaYuGSNXjfGd0557b+3K2dA1Ve/q9mR+6XE?=
 =?us-ascii?Q?83W8kCk0J61slp6UYnCFtCHaMORYByaYJwgztS5BkNrjwNakif3HpNYyazKH?=
 =?us-ascii?Q?TjLodF4UtFjulnaFKQoNhpyI2mX9Y3P/jtGdcTRjRJx7kZMRk79wSTsJU3Ll?=
 =?us-ascii?Q?WzOFwRUXRFr3wBUaWaLda9+twpsshqQPcqQb/2/Rb8dfhDX+TD9p9S0+Inm9?=
 =?us-ascii?Q?kDOBzpPEaCtjWZ9LJoKcOhjnIAZBBIRQf9aG2p4C+2jX1MPDVY4KwTFn3wBQ?=
 =?us-ascii?Q?eds1X7Gl2R3jpD4zoXksEI9TmKeS86kMdaLa7aLUWY0yJ7JL6zNHSWJy2IIo?=
 =?us-ascii?Q?Sp7JIqUYWwkidHGrLL++qlG3j1QI+aD0t/c/AF2FM5ny49irZ0f6v3I/Xc4R?=
 =?us-ascii?Q?8CyMVxHS0XmN9AVszjlOyGOFMA+RwFTDrtDH6ofwayHF5JQmF55If6canv1q?=
 =?us-ascii?Q?5TxbBox5JsWS9w7bBjgq+sboeeorSFE+5NMgYf7YTwUM4YuWXSxUG3Df0KLS?=
 =?us-ascii?Q?kehqnAbwRDgZydqTdp83ZDnyVN3UVjtUKADQ+A25tk0x+XDB+2X0cp08QmKt?=
 =?us-ascii?Q?n5x6nkNB7T+ovb7+WBqUSqNB3PvQcD9RBz8YZ7twADGwbT7MyyW5OfaLdPtl?=
 =?us-ascii?Q?vZ61DXfsU4DBSTYeFgidCxjC/ZwlpFuiZvjp6e9Qedl5epaq+4SxCskh0C9+?=
 =?us-ascii?Q?ZK2/n7PIvBGd2FxYu7HdvmVZbcp4jvoHxFUc1PRBwIE3bEmy3Qu2mE8prrCA?=
 =?us-ascii?Q?HTTkMOEhUYaM36qettF+rH9i20++tISvfYKDNlmyBSUhegkMNxMPWl4wOUR2?=
 =?us-ascii?Q?opNPanjsdJ+zmBQ0UijHE9/3OgWVPia4nLAvaNBdq2u2V1eC9BEtriE71CCT?=
 =?us-ascii?Q?yg5ik1HxxspcvuKzc68gbLDbcAHpaH+jbNJpE53mJib440Ge6lGdpn2rR8KF?=
 =?us-ascii?Q?AjchgxiKq0q1z22GXLiTCdIaDlhUQXom9DBHsp6qbB6DK+TIq5yHyPGb6EpG?=
 =?us-ascii?Q?5RcktTdjbxfj+Kpe7s8XdYZEZeuAzkPE8treX8tGh83auDD0skjSovqUhCh+?=
 =?us-ascii?Q?UOb1E62UQbRiI5VSQCAkS4jnC8YGV4GiHyVbZ/W/S9kDOpTKxr7x/oq1f4JL?=
 =?us-ascii?Q?wjCKQBG/l39gCyW8U1Z1Amcq3d5XTmA2ziHsc5bYL463Yfmu6SIvcWfNCjST?=
 =?us-ascii?Q?AIKDM2DctR4MZzhaPagR3EslloAqG+pU2QGj6VRhfGpS3I0iEic3h2SFAQic?=
 =?us-ascii?Q?/x1B2nj6qtUUvCIj3QQ3GkoM4PwYP1ttAhiHZ863K3HLS5pBD87q1M7zZGfq?=
 =?us-ascii?Q?BozGt8ZzP8iH+aWKKz0rmFfoGGjC5EOdkYl9UzNCvfxHtcJFoe77f/m7pgx+?=
 =?us-ascii?Q?rcTa7JJyyR1/CZbyLvsVjWCw+84TAoPi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 376e4519-5051-4f10-8656-08da069be4b5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 15:53:05.5176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W9rmIGQw6uSVJg+gE0g0MW3S7kxOB9sbAHJniO1cPC0q5HuJIe/4/90AU3cQdwGI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5671
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 15, 2022 at 10:26:17AM +0100, Cornelia Huck wrote:
> On Mon, Mar 14 2022, Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> > Vendor or device specific extensions for devices exposed to userspace
> > through the vfio-pci-core library open both new functionality and new
> > risks.  Here we attempt to provided formalized requirements and
> > expectations to ensure that future drivers both collaborate in their
> > interaction with existing host drivers, as well as receive additional
> > reviews from community members with experience in this area.
> >
> > Cc: Jason Gunthorpe <jgg@nvidia.com>
> > Cc: Yishai Hadas <yishaih@nvidia.com>
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Acked-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> 
> (...)
> 
> > diff --git a/Documentation/driver-api/vfio-pci-vendor-driver-acceptance.rst b/Documentation/driver-api/vfio-pci-vendor-driver-acceptance.rst
> > new file mode 100644
> > index 000000000000..3a108d748681
> > +++ b/Documentation/driver-api/vfio-pci-vendor-driver-acceptance.rst
> 
> What about Christoph's request to drop the "vendor" name?
> vfio-pci-device-specific-driver-acceptance.rst would match the actual
> title of the document, and the only drawback I see is that it is a bit
> longer.

I agree we should not use the vendor name

In general I wonder if this is a bit too specific to PCI, really this
is just review criteria for any driver making a struct vfio_device_ops
implementation, and we have some specific guidance for migration here
as well.

Like if IBM makes s390 migration drivers all of this applies just as
well even though they are not PCI.

> > +New driver submissions are therefore requested to have approval via
> > +Sign-off/Acked-by/etc for any interactions with parent drivers.
> 
> s/Sign-off/Reviewed-by/ ?
> 
> I would not generally expect the reviewers listed to sign off on other
> people's patches.

It happens quite a lot when those people help write the patches too :)

Jason
