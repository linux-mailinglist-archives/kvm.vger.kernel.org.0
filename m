Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 039727AA534
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 00:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjIUWss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 18:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjIUWsr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 18:48:47 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2041.outbound.protection.outlook.com [40.107.95.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEA491
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 15:48:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NUVk/FVNe9GXUOifgwKrz0p8oaFR4W0J3+ICaloEACvL8skgVAuQzIpbOwv3bktbRyW1slPZKj0Ik/ZNIoCUQfn9m6Mk8jiJAmuFMghSWm6Vp2ZX5uXzqtr7EUKQBprLf6h3vYi2E27eJsGsnqhSSDbti3rMPgjv3VWHJm20yGzQ7O1XGWiTPiz92NLs77jjvvSYw/U/dByfOtXQgEDum9MqiUyhD72BtDGDE8Os7D+TVXuisVw7FzhLtdgGTA8FUPOdGFnQXW9nkW+NQNQZ6MzJ4CHoMBd29gpgTipydLU5a5Pf0/wQExSUXTCAI0pcdgAKlD1XcVxCl4IvThYVvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lW62Q13ETOl84yqJnpzpB0td3GD+y2SCIyPCiPMbdOo=;
 b=MVBfD+XF3GrCZQItntk/hUr68HYzU1EWDcuo9qMGzvLG22hs7vbti1Hxr2GLvz+cfJKdRcvZTSow+6XHEa45HJH2bG6GR2UI3tPE4Mvf0yx90oTnBKoL4qMrN+xsUT7ZBnWeajA/XFUyz17eqnrBZ0KdxKb1Q6L0mQMwslgZY6UtcAthx3bKd3SItCiXDhfLEBBA4yuamj0uZ8pqwRHi1E/TKAZXXRxpM8itSlJTKvv93/eqGCsYT4Bt4XOa+w7Uhhe5bTTJbtR5fCi3ei6FxrBJ581P5a2Ysnuf7qmfUnK2516EXZrdtpy2uuc96vxc0FQlHNgw3vZ2anh1dNNW5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lW62Q13ETOl84yqJnpzpB0td3GD+y2SCIyPCiPMbdOo=;
 b=re3h1TjGVJzK8T47D2+RggTpxoa7ecDBC325++Gse48+Hs/an6A9a8uYo+ElCTa4jucap7UlWRrDJXikbaKbbe+8+QPcHYA7csFAXwMQMkbLWfx/FPy6/RncbHyvwEKokzzbz1aGjx0ao+pYAbXmJVkO79P0hOob9eW1I981q4pIq1txv4vKT2JPraJbCJBX9ND52TcRq6+qZtFM8ie3qQxhmoVPnYoE7uo4cJQsGSU9usn8NbpGbSobtXMrZJaRp25NGN7f4IKQenoC/APvN9MELAPNUHaRlmV+AJD8KWSOXVP+IctjLS1BeLTPbaTq7d2rvFgEcHWxfq8FylqWwA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS7PR12MB5838.namprd12.prod.outlook.com (2603:10b6:8:79::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Thu, 21 Sep
 2023 22:48:39 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Thu, 21 Sep 2023
 22:48:38 +0000
Date:   Thu, 21 Sep 2023 19:48:36 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230921224836.GD13733@nvidia.com>
References: <20230921165224.GR13733@nvidia.com>
 <20230921125348-mutt-send-email-mst@kernel.org>
 <20230921170709.GS13733@nvidia.com>
 <20230921131035-mutt-send-email-mst@kernel.org>
 <20230921174450.GT13733@nvidia.com>
 <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com>
 <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com>
 <20230921155834-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921155834-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0187.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS7PR12MB5838:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c1cb1e7-901d-4bdb-4b02-08dbbaf4e543
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YP5QcVmRw7yslCu/WdgzYJ29scZnf25YaybZ1RBfShfEHYL6zPNP+7C5jaa7o1dwptY2EZaJDGa7XLONHUWVVGnzRiAzMMhvvPPo0yj/Q+FDAuIxS3ZCgVqbTUl/UEZvzeRb1HenwgSDil8lLVo9aLdwpnr79lLK2gRV/tv1/GKtpxBJYyAqLNLwOFLZICoTP3+H9YLQ+0hqSiT2fcdEv5hTKe/WuImW2Dg85oc0pLxqAo/X5OJjTa+XcwMlCo2s4hnCtSKd/511dnhX18VjGjYGXPbOrPKMvl6dgjD9jnmoAE32MYVrA93mzqTIzy/a4Pv5FBzHTcDH9ruMJ4m4XTIYXsGI3WAHhbNpN93ILl79QWnJvLq+1HGr5jvDFALtHzOlES+2Rmj7tOHg9ZrLtwoLr59i6SfvXXJYhSbdtW63+4/JEy7sWFKLzfGSSWGeXzTNxvXSCmo9lgWKhjpG3Car/fdnKp3bDySIoQqAvmKZlD1xuElcN7qDrl/WOdiHOMdwO5/vub8nFOVXQ9eo7M0AHL/tISg9FuLdjkLSScRVWnjugW7B+ygShjxtlAop
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199024)(1800799009)(186009)(6506007)(6512007)(86362001)(2616005)(66946007)(478600001)(6486002)(38100700002)(107886003)(1076003)(26005)(66556008)(66476007)(2906002)(54906003)(6916009)(5660300002)(4326008)(316002)(41300700001)(8936002)(33656002)(8676002)(36756003)(66899024)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8ZQe3m3lAbKIjT1m/dcUVW+BIt+8lOI/FUlaaoW2eYM//6yU3Z6H0nuDspx0?=
 =?us-ascii?Q?i0uyZPU+MN2uweMcoeD9Uu2LVfmTwdZWVNFUEO0XPOaldkjsMMPRnMXOSN+x?=
 =?us-ascii?Q?hBoLCh2+tVj+b8SHuCLa8ZDLagrom4yKc0tM9gwuYbkQFZazTLovHWQXUfc8?=
 =?us-ascii?Q?K7B5duFWo5RPnXQyEtgFcnsbx1r8GWQugmVaQuLEzNJWJ39KTIXmiBO7qT78?=
 =?us-ascii?Q?L0PyG6pgQWqMCgujU7mIzkV1qd3jwvucO3dBBV2IWtEpCKpk5i0i3hmAREnW?=
 =?us-ascii?Q?pqr/IJdfY7ZDy+LhTaqNfP34XjtukMLxOV1if4pOZw8dioLKGw3zuCxlEgPM?=
 =?us-ascii?Q?2bdZ7XDp07IKEF4s+4a+LszoEqu+bYBRw0pp2vsb5tFJhrxLTBQrW5owpPEV?=
 =?us-ascii?Q?JSId7ap645pIsJZmF7TCDU3/7XAXFTA2By9otWGfBaY6VtSKI0pbi2+GI6MQ?=
 =?us-ascii?Q?P2LLJwSw5Y8H+u9bfyxdSIRVHVLHsPL+8LHwv1o+QLBHkOdG43pgWQevmtXC?=
 =?us-ascii?Q?HsdrrAbdjhwJYrNNSn4MEXX55eJR7I9BQosMXtx6DlNEKMDwGgMe9q8XpXsU?=
 =?us-ascii?Q?tqaKBPQdqPJ9zZDO0HX65HvW0iLqnWYL0I5s4Cojf2Fjq+h8yOx6/QR7sDuB?=
 =?us-ascii?Q?Ow94M0LhQAekU1vzA9jisPeWhy08BVFp7KqPV4bYgIN4vOVnQuyTc8UpLuc6?=
 =?us-ascii?Q?UWptv27xS3TMPcPSxeFOps4USSNVY8yKmDww3ta9fIGTMqzm3n5n/5fwFWTW?=
 =?us-ascii?Q?2JuojxfNkqzzfRlZ65s4aDsG0ulkP5ytJYGGrKtbbcpZcUGOt7VXbSuaBI9h?=
 =?us-ascii?Q?K8z2zwXjLXgI9LcTzeMKUv/1RwAPT0yNZP+2bs1Z78cognQ4ZJW0zCAP3eIF?=
 =?us-ascii?Q?K2H4dNcsLbAVG8wTheNjXv53KqRnnq5fzF/Ys5o+2FDjd+ijmmtGbh3wO4pr?=
 =?us-ascii?Q?jkk1uu49P0PjZQ/wXnq/++mlMersqqIzviCv0IlH0TV3sa9glIWSuh2MVEbe?=
 =?us-ascii?Q?GqymujKmi97FLQXYo40DGkWRYIZXOVrIGbudZVuxo0AAmGuQks8QA/QnWrKM?=
 =?us-ascii?Q?7jZ8vNEC7u7qMrbidcpSrGQeZPNCNT3qshgTeM5DUalppeRvG9BkzPS0NdvO?=
 =?us-ascii?Q?VdSH1p/7BXeCfVNL/rRZtRhAkkz0z/SJzTVaUG28g97iylxRi2nn2ll60U78?=
 =?us-ascii?Q?rWbhQHWHGAPijV5/RpK/q152vsb/c1pSmXi7oJ2GqRvvMfeOvOZKtf6DI6X6?=
 =?us-ascii?Q?XfFx/iP44W/myWD0SU3wFYCBvsUHlorLXcpeBUQ9CVFxciZlS9mAOffsxd0E?=
 =?us-ascii?Q?rUQRjWgZIxuIBSFgN7EGzZomdxVwt4Gij207sV9k0r6CECBvj+c2m+60pThy?=
 =?us-ascii?Q?tMgnaaKxpqxjTtTIRaDNGmmqdGWyr5AiB0aedcSxsqRLfHvE/tsQQikVEKzN?=
 =?us-ascii?Q?rZmrvUfZqMP4mVHKmMJat39gHf54IUVbw22cmhX0f4U92IXKKFKHqo107TBT?=
 =?us-ascii?Q?1T7FXTGPQkQMlkKgeQ7oa7NZfRcvV59r7sm6lQhv9QhOboqy1GkyWQhMOavM?=
 =?us-ascii?Q?5eaBWnjB0l6rahnbXveOSh2v4olyj0lmiMX5jVMB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c1cb1e7-901d-4bdb-4b02-08dbbaf4e543
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 22:48:38.7222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q1VCDfataHnTaPx9MlYcl876lerdAqG28Yvm5PXAsElSkn9qLjHp5p1ZBVs0W4we
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5838
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 04:16:25PM -0400, Michael S. Tsirkin wrote:
> On Thu, Sep 21, 2023 at 04:53:45PM -0300, Jason Gunthorpe wrote:
> > On Thu, Sep 21, 2023 at 03:34:03PM -0400, Michael S. Tsirkin wrote:
> > 
> > > that's easy/practical.  If instead VDPA gives the same speed with just
> > > shadow vq then keeping this hack in vfio seems like less of a problem.
> > > Finally if VDPA is faster then maybe you will reconsider using it ;)
> > 
> > It is not all about the speed.
> > 
> > VDPA presents another large and complex software stack in the
> > hypervisor that can be eliminated by simply using VFIO.
> 
> If all you want is passing through your card to guest
> then yes this can be addressed "by simply using VFIO".

That is pretty much the goal, yes.

> And let me give you a simple example just from this patchset:
> it assumes guest uses MSIX and just breaks if it doesn't.

It does? Really? Where did you see that?

> > VFIO is
> > already required for other scenarios.
> 
> Required ... by some people? Most VMs I run don't use anything
> outside of virtio.

Yes, some people. The sorts of people who run large data centers.

> It seems to deal with emulating virtio which seems more like a vdpa
> thing.

Alex described it right, it creates an SW trapped IO bar that relays
the doorbell to an admin queue command.

> If you start adding virtio emulation to vfio then won't
> you just end up with another vdpa? And if no why not?
> And I don't buy the "we already invested in this vfio based solution",
> sorry - that's not a reason upstream has to maintain it.

I think you would be well justified to object to actual mediation,
like processing queues in VFIO or otherwise complex things.

Fortunately there is no need to do that with DPU HW. The legacy IO BAR
is a weird quirk that just cannot be done without a software trap, and
the OASIS standardization effort was for exactly this kind of
simplistic transformation.

I also don't buy the "upstream has to maintain it" line. The team that
submitted it will maintain it just fine, thank you.

Jason
