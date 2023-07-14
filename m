Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E57C753CBC
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 16:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbjGNOMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 10:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234555AbjGNOMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 10:12:06 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2EC12E;
        Fri, 14 Jul 2023 07:12:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ReL0EI9z9VvxTiMXvJdA37yjzNeoYFD38nXbXsPsAlRKu6WsDqW/+0ZDDbffM9FJv0U0R5iQc3njBIpTAUQxnBA5ZIBU1ANWGTEkAhgfuXLjBCaRy49XH3uDTz9lnIuZKz7Z8g7lRBAND1ZTJ228MadivVwilBjiIcaAlf44xFJoAhFxzJkSiJDDvl0GwMF2Q1tQlnSRRczqt27bN0VDnHum8/zV3spfu2Y19HwcfUxLoER9YQNFzU0QW4Y4e4vZ9XRXyNKAGs5dtL6tVn7c2Aev2AP2c7Qieyv6vugmCpU/OYu94e4GMPb0G+Uh31MavEHE3js1a6j2OKKDjvD7KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VqJKOs71JPYcP0YY6emfOKpEfMlf7J8+4zO1PDy6QyY=;
 b=KctrgBxi36RsYIIeIuceJGLSbw+mcGEN7IOBrMpPZxruM0El8pZGp2YPlv/0wS1aiFdWV8XX0oqgedGiYI5RjwGMiqfwG5wF8pFOACKfO9AxLnMV1ovWbYD9DEEg70jFotLDQHipzTxx5t2tQ4L2ETyjPk+it5Q0cM10k5CBkfxp28GEAjlKdiyUNlce27n03DE4eiMt06Vc27rrb1Jx52AqlCEA9N7VAfrzkpH8fA8QagxwbrRRvZwZWcWZZBNv3ljvFl5iJMbusPY+idrX8HobjbpjajoaueS/IfB1XtlqVtvh0+6C2Fq09ZN53qKQtpK3s0S8UizOlznMHz3BWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VqJKOs71JPYcP0YY6emfOKpEfMlf7J8+4zO1PDy6QyY=;
 b=lLH39kH5YiQQk5KrdjEzcpXha2GTJvIn3DQm4P6aRjP++dMm6B/QiSNqAUjC6lHBBK6iL5xyZSPpMQYjjDOXVU35P/KkAY89HRpXAtuEE+xOwFAyb8Es7JtyClEEqeV7EsGY/+Ttl+Af4qAFn+erMtPqdzDVdvnf0bXMkwBHVshK+iXhRtlJ9rttjYJ87uTANgK+S1GbDzCGf4aL9dHmyuT+xdRbYP91f06hZurUpfAWMDORfRASjhqqFk9XgW9PsfEBhS3UmWizWMpb957lILutJErV9u+jDxW53iahN2+Pzfzhid9GQ95EpmVtNave2O2w9Ryfw16r/V6iWuDB4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB6948.namprd12.prod.outlook.com (2603:10b6:806:24f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.27; Fri, 14 Jul
 2023 14:12:03 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::69c1:5d87:c73c:cc55]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::69c1:5d87:c73c:cc55%4]) with mapi id 15.20.6565.028; Fri, 14 Jul 2023
 14:12:03 +0000
Date:   Fri, 14 Jul 2023 11:11:59 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: Re: [PATCH v14 19/26] vfio: Test kvm pointer in
 _vfio_device_get_kvm_safe()
Message-ID: <ZLFXr1pbdl24sUyM@nvidia.com>
References: <20230711025928.6438-1-yi.l.liu@intel.com>
 <20230711025928.6438-20-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711025928.6438-20-yi.l.liu@intel.com>
X-ClientProxiedBy: BYAPR08CA0072.namprd08.prod.outlook.com
 (2603:10b6:a03:117::49) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB6948:EE_
X-MS-Office365-Filtering-Correlation-Id: c1dbbae5-eef6-49bd-1543-08db84744bf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wkgWG4L1houMYrL0DkADrpsJnJ0AY/Zb8DF5S139Q3XYgt1/WiJwP9PzHYcYhbGBYEbh1IYWW9pogKtDgESNivHQtqb6Ym3/xX4GUbytdm3+YIOq6p4IeC8GcY73/8m3qO02QvBLoQXApprR4cEMM+4Uwb0LFPMjx/VaNz5az9VbnnZnK9rLKGAKLJ7XU4j5OE7/KY4dWBvzXbseM2U/1hIcN6nTUclkwJKnyS90c467id+Fa5vesz4319vtzmhNIyaF8R1Fa8xdujTZqN9SvB6OTwLA0Jat6z5csO+olaDQAT+HgZ+Gxtr5p0DCnyuxzf02mSnk9Uwht8zbVUvLL8T9BbZcR0/osbCeeI1GnuROUnEgAuROZZF7GOcgd2PNSmvG9a31zYVbvhEau5tdLqXELtUsOUFeWzwV5VYF6qVTUj6ZKUTPfjKawHnwmRD43A65A1YQQTJE7tHUyfmbHycp1zzCyLjZwZPRfEjlfwG8RzBEcc4GVWb9Oi9QUCfco1j/YPsk3OxBExNATvvawk5ue8ZamUUycp78iAJVlufO0G5B8e3c31ocE5j6Ybny
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(366004)(376002)(396003)(39860400002)(451199021)(41300700001)(66476007)(7416002)(4326008)(66946007)(66556008)(6916009)(478600001)(4744005)(5660300002)(2906002)(316002)(8936002)(8676002)(6666004)(6486002)(6512007)(86362001)(26005)(6506007)(186003)(83380400001)(36756003)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QC73B79YeLAvf18/gPr5v62Qu6fnkot/Ihuj/+4SqPId7D9YzXuy1cEgTsNp?=
 =?us-ascii?Q?76Yvul60QC9/tk0VmL+hKbCnfoZYAGFj8XSSOKnaZkLiwCNHq6Ygtm9eV/RQ?=
 =?us-ascii?Q?bG4l+M1k1oFM/AFQilOgx7jRFFo6w21x3JF7lqOIz3ZGZ9XPPjY9TTpIkYk5?=
 =?us-ascii?Q?nucothNALOeZdS9rEF0Hj+LR2EGIfS64LF2ACFZreEJGMFQOe4tNow6DAn5s?=
 =?us-ascii?Q?rkCFWQm0UQCRGrad7fQaKGTrs14/zrTqZUf0NeQ6FYsV8MSOYO18Kp/ah5Y3?=
 =?us-ascii?Q?/Br0d5omy1tpYvYPT6J1sRvzdLbef0PjSptG/VBEyuAPZTJpdDCtv4ybxvds?=
 =?us-ascii?Q?7divEOezt+Azd3RooMFlQ/J/yYlGHzo1oSWY5qloAS5gjd3RV1sAILdMqjN4?=
 =?us-ascii?Q?o1YYJoEl4oztsMsn5upxMK+GGv4Cy7BGaJfDzYR3u62ywokqPCmomYkxLAmq?=
 =?us-ascii?Q?mAZ8MCX0jO+gl/txeedZTda2R2cudCuRqRq5jzHdQJr3gLaaTaqb3om2wjad?=
 =?us-ascii?Q?64xFl4a1Cq+b5GJSEQMaGIn7mQvRMn8RE+g0SUYd0E8Uq/yEW9FEH+beUPgM?=
 =?us-ascii?Q?NiIq73idDbC6W/rXsJbROgqHYXwggq1ytwjtRS36ed4BK1z9AJ6+OGSpZn1v?=
 =?us-ascii?Q?l4dd0YhDsLgUAFLe6TtXnUBGth1PKr+xShh4ScQ11sxy33QWOO0kMJDFx7p+?=
 =?us-ascii?Q?lC94VZugnEwjPnBf03Rf8NfwZQi6JkXSjs7dScmZ0TxIjSQcC4BG24bzsP4W?=
 =?us-ascii?Q?Y05JEBOHDPYG35NXkOg4diEsAUbRN9gCZhLIh2sE42Osn8/yG3momL3hqnoe?=
 =?us-ascii?Q?iLirYiRIJJrPetqIDVGXFWKKKT3kJrOCnljZsu9DcBDlHx58dgx1mMZCOZFw?=
 =?us-ascii?Q?w71M07SB2zfTKizo17WGIzVwbZ9QvMs+co3irAaqaYUafq6KM7lnysq1u+aJ?=
 =?us-ascii?Q?R55Z2kbGjckEOLDZnSUVqzdxFxixL/+MG7YuHE4+97vUF2gZIEAFsvQ8D4Dl?=
 =?us-ascii?Q?xQkBrVYIZzXdV3VUqd+IAkzfm6V91H6bn7zFx89mz65fVO39W6q9VPpVfv1g?=
 =?us-ascii?Q?ZOcbjL3IGqchq3qf6xOnu1FWNtMyFh2efdWzL2aJCRSwVl083JzBYMd7zSoy?=
 =?us-ascii?Q?tqiZ6srH5mOKv2NeRRw3IJ/JHFERbxqevVgkynjNXVTu72ydZYENqlirL9JW?=
 =?us-ascii?Q?2w56ffl7K0dVNrW36qDuxtRv/VagMz5DS3lydz2PV/XeMpHIi6ekCxrC8GLb?=
 =?us-ascii?Q?9vSwjMnkfbLWGh9pZj7ir4xj+nCxronhxbEqHdG7F46nj91ZfVFg1lJfWXNW?=
 =?us-ascii?Q?TCe8GYDxFkzbTDAjbHlstRkhZ9E3WFtWoF8+8twusEC7G6iIQkvbfNPiSgw6?=
 =?us-ascii?Q?nzPe7PHwr2TUK+kXSYcDSZRwlPs9jC2e13PXrt0E/VYNwEF0rntl7BmIfbWF?=
 =?us-ascii?Q?skgC8X6hw9gOM1GZ+rZysJPz0oPfM6z5AXXBr4bjsFacYaOpR/rYWxKkfmMG?=
 =?us-ascii?Q?Sg0Kr+QXP91zwEzBQxowwOQkCl1j1IwPwGn18sGbw4LwIqDD8ZSe6sVCL3WW?=
 =?us-ascii?Q?v/GgBEUeWw7t+KDvXSDlccKrQ9UTJBGOhJI66pSP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1dbbae5-eef6-49bd-1543-08db84744bf6
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 14:12:03.0859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R8QAhQ5kH1y5988SIGJ9RAjLCgEdfCPaZ+bgnDAr+u4mvd01fkRpxO+2FMUUwudI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6948
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 10, 2023 at 07:59:21PM -0700, Yi Liu wrote:
> This saves some lines when adding the kvm get logic for the vfio_device
> cdev path.
> 
> This also renames _vfio_device_get_kvm_safe() to be vfio_device_get_kvm_safe().
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/group.c     | 7 +------
>  drivers/vfio/vfio.h      | 6 +++---
>  drivers/vfio/vfio_main.c | 5 ++++-
>  3 files changed, 8 insertions(+), 10 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
