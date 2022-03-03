Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CED14CBE5A
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 14:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbiCCNCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 08:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbiCCNCQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 08:02:16 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2047.outbound.protection.outlook.com [40.107.93.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DC218640C;
        Thu,  3 Mar 2022 05:01:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WjKkW6iJVAz82U8CAucmzy8bm/dLlWe7YT2eEfF3XgM9aq57hr4BbcZ25E5dYB8fJPt8ti1tQ2+bbm/19x+6WZq/wjKT4Z6b/kZTN3uAIzsCsW82KLPT7wlmZKazsUp8uv/8S1Nh4sftot2WdAMRzFXxYYVxQTEDut2kYWPaWAy8YxZ3DZGQtCZ+tZvNI4ir+T9XbMnMPsl8nxxc7FNFQH268cgh/8hnviMy4mnMrFgMhwAMS6GeZVGB03RGAuz28lidz5K47vgtNZfwThd0VIZ27+e6QCi6mEbKgb4kpdlzbPRtk167NWY+UDLjTLBjggLDiyXymHG1axgomK9y7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yGin43IgSCPMvWlC3s/qZbjuxVeTb1m7icdlrlsjKKo=;
 b=chNFiiUK4GZojm1c/XRwy5NjGxhmnHtdDFqrrCC4thn0EK429o5kHduAn2H0LFpxBRk2hWCODsaKX3nNFQum1SaI9wMoaV1HiGM9u1rBg7COEBKaizy0cIb8ic8bbDSyHC0ReZt4yxqDb3R5wQYqwEBhH7kGP6OqOxA55xAszh8e6BRRGY7J5pqQc/fn/c+bN9jzJ7tbhWkNaJemncjskVIkceM+W6QeeN4j7t6bT3kvDVZoqTb35SZUBr5TuzViVk7t6Xo1Nb488zRBHmxeNIqfS6W4O0e4rBEZhzPoJDqvob0DkxVZOHReUC6MBUUT/XCgy51rggt54fS1Vc5OPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yGin43IgSCPMvWlC3s/qZbjuxVeTb1m7icdlrlsjKKo=;
 b=ci9v+VhVabHCg3NM6SlTzYKc0yxMbOQZcYWJC8qo6m+hfOIRmLQRSuW0p3uO5DnHD8aENjsEmQzsXHNzBUb8EckOuBpNW5LSXkhhf+xZXztXa0Sb8p0sW1XeE1CbVPhlmaSgzfioD3E37qL2cJGUON7TchgJDd7HTDiP+gNW2BLPV9s3S2uKOqEVx6E2WmBNW8Dni4TSkeEKqzXJPosjyGjWH4EHQu7BbBp+LsPU7p/vcP4BuwXc2TIe5n9y18VTDv9V+SqxriATXh6z1reIPeYeG1XRZ921KgsNetuJQKzHtfjcsq4iS+zSYbDFPkzXBQaJRhoMEzX2e7oaUun97A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4793.namprd12.prod.outlook.com (2603:10b6:5:169::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 3 Mar
 2022 13:01:26 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28%4]) with mapi id 15.20.5038.015; Thu, 3 Mar 2022
 13:01:26 +0000
Date:   Thu, 3 Mar 2022 09:01:24 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        cohuck@redhat.com, mgurtovoy@nvidia.com, yishaih@nvidia.com,
        linuxarm@huawei.com, liulongfang@huawei.com,
        prime.zeng@hisilicon.com, jonathan.cameron@huawei.com,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH v7 07/10] vfio: Extend the device migration protocol with
 PRE_COPY
Message-ID: <20220303130124.GX219866@nvidia.com>
References: <20220302172903.1995-1-shameerali.kolothum.thodi@huawei.com>
 <20220302172903.1995-8-shameerali.kolothum.thodi@huawei.com>
 <20220302133159.3c803f56.alex.williamson@redhat.com>
 <20220303000528.GW219866@nvidia.com>
 <20220302204752.71ea8b32.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302204752.71ea8b32.alex.williamson@redhat.com>
X-ClientProxiedBy: CH2PR15CA0018.namprd15.prod.outlook.com
 (2603:10b6:610:51::28) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2fc510b9-e951-43ad-d7fd-08d9fd15ed22
X-MS-TrafficTypeDiagnostic: DM6PR12MB4793:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4793655B68F904FCAEACB2F7C2049@DM6PR12MB4793.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EhdDhi/0m3rm8RLU9mkaNwThuRsRkXyR7JG9Fel1LiTq8gKKhOeYPTkMH/R1QrcqgM2oWi7iPy3aZqXxpanInbbMD6nAyIFlkKmMkGOlbfed1fU2ga/5Dz8X6J1RWAUM8I7z1Wbn/N4YsVMZOpA2Y2dQcJCCdbtkuygVoN0EgbYzpgdAWEwLz32t3j9U6zvGNzeDpL3cCM9BifGkpqeS3Ds0jwRS12r6pk3SYsXbOTkw0+4Rx/CM3EddTgeSSw8DXQjLYu0AaQmq4T4rMNNEqEwY5L2yOX4ULHWsF5QF/c8OYhyWCleDR97M4BbXWL2arLlZAIlNjbRBKqJ1zgHY0Pe8jQqEViC4jUH50/l4PvBON6+xEepQeJNw4T/ceplAXpGP3QuBorwVmHgnkYYbKxs8yaSC/M5cOjtP3mImRkLcsufSB5AsXTTAuXhv/rs0mkUlpeLkzWsVXywqkzCZgD1m2slO6tWXp+ynMetDgegrntDboBHrB2hnlqD6HAF9OT4L8ppDbtFC3rUuTC0E3uTXQSBBlYnhf8r0IFgQvmKxMIF8okGGuWmQnr7K6kcuWNyJUDq9mQZkVm1O/gD6CsVJlwkwzmUG+yDyERihfBOLTmgbBgi6eYOHMpmQgVITRAVrVPGsIJqDjeip3nUeRYByYUvvkdZzq9D1Rv3Xjlw/okWuTDe60qqg7sQ8h1pu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(6512007)(2906002)(8936002)(5660300002)(7416002)(26005)(186003)(86362001)(1076003)(83380400001)(2616005)(508600001)(33656002)(6486002)(316002)(6916009)(8676002)(66476007)(66556008)(4326008)(66946007)(36756003)(38100700002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cQ1eA2ooIZvpW3mbrh7qG3tW/hewNTkSkewEjGMYflxSt8IjKruagelzEA5d?=
 =?us-ascii?Q?Y7gAkh2Y0U6BJHu3KWkFLbgU5rXnreXo45nBss72UOPqGNSQnij0Yskh+A9Z?=
 =?us-ascii?Q?SKInOVGFbQSjlaCShsQ9jYvOi80ODG5GY+OYM+R+9cLhF6aU61Zlbm6ymxOT?=
 =?us-ascii?Q?I5P5kAVMcXLqp855Srb80WQZq18isAEqeQjvB+RlBoLjbh2a77vrVvR9x8NN?=
 =?us-ascii?Q?T9/V+2PT52xjV8suoY3sR7aQZfkbSIjLIKwgzcSgwOi57Q3wuHufyGEcoeuE?=
 =?us-ascii?Q?fkewnuj9O5U+sT1416E2J6t/ZCLQCsBXVox79hZzpifORhFuWDTsM8rzWGj+?=
 =?us-ascii?Q?E9vahT12hDyEkdliGdlGtBlqIQU+sIkdhPOki7QidkiIEg/JtxiHc4mX3wJ8?=
 =?us-ascii?Q?i4kvRRRVy92UxnYmt3GO/pww7rqkjA1ne6vv4Ho9WBrT3HEHChIITH+v4Kky?=
 =?us-ascii?Q?sJOinWgJzK5fl8PZkfBXbiqTWc4mONbT0CGo5lCvpD41PfBtVOs9jb0NF8j8?=
 =?us-ascii?Q?XW+IaxjTRRPMK3/GlWGMwRHxswm6dKo4iDoVsr3IkY4RwiWJPoSvlN9dFFQe?=
 =?us-ascii?Q?IiXwlyzejY7sdYuUCDZYkf7d1x038gHRHGOMPNJZGj0gVJTNwxYeui4ysOAX?=
 =?us-ascii?Q?aas1duVLYa0DtEnfdx6AaO/EaDex5y40V2JgYAl3qre83szb4X77eZUuWyA4?=
 =?us-ascii?Q?W1DwDtZcA9i7G7nO1zxM+pq0GSzkmr2WzMe0reBk02Nkh10zlwc9Wp2ecgjK?=
 =?us-ascii?Q?S3szchxO+FAa+M5W9G1omec8OM0IPlaCOt+ZfFwvwtd5OvmtwxQCWEUAOb5H?=
 =?us-ascii?Q?pIwJxXuhp1hP/it9IUTkV0bhDVy296n5fxzCf/9Fjv5Hnn3m8rmbqCfFJP8E?=
 =?us-ascii?Q?daplLbeenEQkyElAQdp+TySwlo/EjF4NYZ/L2DBQ3yA4CZAq1h9VuPuX/XVd?=
 =?us-ascii?Q?8xo79Q0erMZuUB4zh0GJv9b6cAs8l77pBT6dh+e/OTietB3DToFCJYMg1C/f?=
 =?us-ascii?Q?01N4H6KiL2TMpmjvoIf/Y2lS0vCsgtK4nPV/9dVru8sTOlL+gj545ssoIij5?=
 =?us-ascii?Q?Tr3IFPsWaqATAZTd6786ogHq6nSsBVmRwtg6zP1dixlOIGE2rJCyN0GcIxTt?=
 =?us-ascii?Q?YYOffQNeABuxDZ/a3/S9dNGdj2+SCbZHI770VEqHmfnBlb9dbggk9bt2ksS5?=
 =?us-ascii?Q?kRzey9/Q7vYj86PCfaxWaEUfyXuOKBos7J63IpMZMVDysOMcjxfQXdlXS0i+?=
 =?us-ascii?Q?etAn+Kq4dcIYd7d7HQhS9LOMyFPmcMa5EZT3GlN3I7gFlLAAZbUCWn4c2xTK?=
 =?us-ascii?Q?TPMOz0QmmsKfHk8HlGcHPc2KFPTiNmnqj0a1cL0l+VYMkUesjv+POtTBxPhp?=
 =?us-ascii?Q?UWGXKUsEWobw2plDyooC6i7WpdRmjfQW0v9Sd2hbbhS1YFDYePaqqcK5YO+I?=
 =?us-ascii?Q?FlgFKY6HMvpWh1kehtsN81IpkDw6cCGBWYJBl8qcpqOhjMCxcdsWu+7R9PW5?=
 =?us-ascii?Q?In40SISzghLJ+nLYtzlKRErWR0d9ld5drXQuVgRQV4sCcnzyCEFjwhsKeGDe?=
 =?us-ascii?Q?uoiQ/QSE1CLb0SXWUYE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fc510b9-e951-43ad-d7fd-08d9fd15ed22
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 13:01:26.5978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RdXVri3M/pvZf/xNk+dPveVzZkwQT7FKkKWJSaKqmO7m7z2lKbpb61KyiByQLEJS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4793
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022 at 08:47:52PM -0700, Alex Williamson wrote:
> On Wed, 2 Mar 2022 20:05:28 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Wed, Mar 02, 2022 at 01:31:59PM -0700, Alex Williamson wrote:
> > > > + * initial_bytes reflects the estimated remaining size of any initial mandatory
> > > > + * precopy data transfer. When initial_bytes returns as zero then the initial
> > > > + * phase of the precopy data is completed. Generally initial_bytes should start
> > > > + * out as approximately the entire device state.  
> > > 
> > > What is "mandatory" intended to mean here?  The user isn't required to
> > > collect any data from the device in the PRE_COPY states.  
> > 
> > If the data is split into initial,dirty,trailer then mandatory means
> > that first chunk.
> 
> But there's no requirement to read anything in PRE_COPY, so initial
> becomes indistinguishable from trailer and dirty doesn't exist.

It is still mandatory to read that data out, it doesn't matter if it
is read during PRE_COPY or STOP_COPY.

> > > "The vfio_precopy_info data structure returned by this ioctl provides
> > >  estimates of data available from the device during the PRE_COPY states.
> > >  This estimate is split into two categories, initial_bytes and
> > >  dirty_bytes.
> > > 
> > >  The initial_bytes field indicates the amount of static data available
> > >  from the device.  This field should have a non-zero initial value and
> > >  decrease as migration data is read from the device.  
> > 
> > static isn't great either, how about just say 'minimum data available'
> 
> 'initial precopy data-set'?

Sure

> We have no basis to make that assertion.  We've agreed that precopy can
> be used for nothing more than a compatibility test, so we could have a
> vGPU with a massive framebuffer and no ability to provide dirty
> tracking implement precopy only to include the entire framebuffer in
> the trailing STOP_COPY data set.  Per my understanding and the fact
> that we cannot enforce any heuristics regarding the size of the tailer
> relative to the pre-copy data set, I think the above strongly phrased
> sentence is necessary to understand the limitations of what this ioctl
> is meant to convey.  Thanks,

This is why abusing precopy for compatability is not a great idea. It
is OK for acc because its total state is tiny, but I would not agree
to a vGPU driver being merged working like you describe. It distorts
the entire purpose of PRE_COPY and this whole estimation mechanism.

The ioctl is intended to convey when to switch to STOP_COPY, and the
driver should provide a semantic where the closer the reported length
is to 0 then the faster the STOP_COPY will go.

Jason
