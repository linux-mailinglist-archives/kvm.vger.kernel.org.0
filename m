Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0355E51C829
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383152AbiEESp5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385935AbiEESp1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:45:27 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2044.outbound.protection.outlook.com [40.107.101.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681E36D877
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 11:34:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iqfDHmO44xF+Eh6HIXxC7otsS50wivHO4CGWteXRpcFZsL5xoxgDf2gLDMcd/ZR4clH0upwrDVvBtje7p6JwlCxLyWa7T+srC33JKvTwYgqbZKD3zGdSuuiFbbk8FRttu1pmbryUjYN9h3/bTWbKnoLwV1E7T76kCe55aEwuzxkUJy0J73EWtcBgExO46xKnoW2uWIcTPFe7NuUYvjw2oNkQ7MJBpUFzvvyYRP9AH5cMua3mt3ca/5JFpBYAan8g6ZJT4vRZkVcIFiNd8PpGfS6jmN4iQWynfzD2JMlfBwgo6AamBAAp3tZkRwfhjY7S5xjodxrsCdncqpCwtdHZBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+GF0f1+q8GNsigTXW1uxtF/gInc6kHjTjZULAfSA38I=;
 b=lVFuZnjEyFIHiThOGyFpnNqwB07rZtT0HvjGBAUTKdvtayBO38EeUrx3GOI0eVqMNsG3ESHmSHYEr8TaIuX60O0jVJvuU2cEj70v7wYgXGW3YR8W8jFhiMbfYo2xwBMmOwpnPOsHQAhGyt6KwEiHpdxm7jyKe2vSOSZqDoXRFTba6CDvI0QYBABQTIMzdFf7rOPpMuz96vjxVbxORRPWKScEf7tLGK+RMcDa0/lfJMR0f1LZXQZ9bCOIvegj6ngjmf+KObNnaKmlmRstWJt59kdwT/rbXZysE8OMrSd1I4rk0dMFvxjOu/z7A6HtMoCjhoTfmJlfZiiUl0lhdLvsEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+GF0f1+q8GNsigTXW1uxtF/gInc6kHjTjZULAfSA38I=;
 b=IzAa2vEypH1+v774WTv/2gT0iK97BnYzj4KqaUxrtcrUh6vCT7MkDm0crs4psvOt7Yj343kGPF7/PXYap7b68t9IZlJab4wwq4NYo9TBWeyUIXOE5959tXakpeKBV35Oleuyx3KK6ou6b9ja8U7H3q1wk9I/k1GRtQoNoaSL2pWYRyZ5V/Nf/yoWyfQ0x2j7uY2G3OPQx5LET1ZDjouBANwSlhOiBYQTt6tg4G2eECzxZwaWXAfIN5csBoXaQT/orbEbvKtGvkPXoKhIw/O/Ut5v0/e4JNc3TYsttepSrhHbkMNOwap4SmBLfbbYL5iMsgXQ0oSovy8EDddx1fZUGw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SN6PR12MB2816.namprd12.prod.outlook.com (2603:10b6:805:75::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12; Thu, 5 May
 2022 18:34:22 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 18:34:22 +0000
Date:   Thu, 5 May 2022 15:34:21 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH v3 1/2] vfio/pci: Have all VFIO PCI drivers store the
 vfio_pci_core_device in drvdata
Message-ID: <20220505183421.GU49344@nvidia.com>
References: <0-v3-4adf6c1b8e7c+170-vfio_get_from_dev_jgg@nvidia.com>
 <1-v3-4adf6c1b8e7c+170-vfio_get_from_dev_jgg@nvidia.com>
 <20220505121047.5b798dd6.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505121047.5b798dd6.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:208:2d::36) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a30bf55d-232e-4cd5-10dd-08da2ec5dfc1
X-MS-TrafficTypeDiagnostic: SN6PR12MB2816:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB2816B050331FB3D96C9CA459C2C29@SN6PR12MB2816.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: finlt9JH1uXb2PJyiZzfOvKonrbrasNtfdkAUjPbgvBhESxzfZM/42WS9sVQYjQedcacofhuknixOBKa7pIBRUtmgZqDRAX+e1QYWU2oGkjDdPAtnLDZH+o9uiWgXKqIUDliQZ1S1wq3ZBKl5EJspTuPeK5R6cpU1kQYS5xQ7jgMEKuyVjQ7Dln4ZEFtPLJnyPwcBGhUg5h8ITLTyxIu49Sp0J7CysUn93+REjJgvx3IsldYDc9bez4rglOKXQljuJKX+z8PpYQEyu1NafVqBY0Hj9+pKy3CseGzMynfteKGBXwV3aY9w9bg3BFIMHenJU5IHHAskUY6OjgXKtWbvADNDnwZu4kRX2PmTTEdLOq6qoNNCc1PKpZyUAX6+BOWEAhh9rBaoJr8KJAldvrJIKvhIoD6Dtg0KUWW1occqlx5XO7OCRbzdRSNjqh2Zm3wwTS4B2i61bAzxuj6i6Sc5dPBfrM9SFe44bKC49arZ34SjQ5cI9AZs7Lc3yfe5SnEcWvH4QjDZEhduTkL/YZ7dk5rT0RY9duztCYSeoxD7dYiJbdfn+6qBz+gLWSPByAKRqbpue6kao0zL1I8Up7ujK8bdqYvyLEsE6Ds6MvXLRJ7a9p4CaGhLucat8yyD85ffLFduqxt24oyY/Du+rRnAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(107886003)(2906002)(4326008)(38100700002)(83380400001)(6916009)(316002)(54906003)(86362001)(186003)(2616005)(1076003)(6506007)(6512007)(8936002)(66556008)(8676002)(66476007)(66946007)(26005)(6486002)(33656002)(36756003)(508600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+Vc4wsFLtwaiX49C2Pwe+KzPkwXPotoFVnfMIvFGqLcKMRpO5h6i1v1luk1N?=
 =?us-ascii?Q?flI7vIl2TK0n9tliJuHZ5ym/w2GVyhzbl794G8hDrxF45Odu362w2vfvrgZ2?=
 =?us-ascii?Q?xC8P0u9l84yg7SfOMJ6/RVRwalyTvcnpCufxZNIK/mBz3MFMv9HtPiE+icTi?=
 =?us-ascii?Q?jczkQRjXBzqCSEBOadmz7cSSwBBH1kPagjpw1YNk+jl+mWATdhw/n6ZQPtB3?=
 =?us-ascii?Q?q97SnB5j7lExb4XW3n1+X4iaKzv1TMglBeVBk6YfZ3EtFj+YsOe/1w+volTD?=
 =?us-ascii?Q?1pzREBPbUC0/GVoxH84l7XqikbqNiO8stuHYf+DAm7qB/hg4iEeaBuQ5W/nO?=
 =?us-ascii?Q?e5GZeDuQw0K9FYUzhfZKN6Y4XBNr5DZLhkWXHZNGXQei82LdGlfKx3eCeHjk?=
 =?us-ascii?Q?LS7l6M4Lgr04mfeapPSUwCM2rlNrLKaWEXRJgOe4NhkBJdC8K0URFlC1Sg2W?=
 =?us-ascii?Q?WnPRdlP7d2OGdM8LHLNoQkkNGzgDyFq/AEYNs7rFvmn6lSM4FWy2MApYeF/d?=
 =?us-ascii?Q?TdRrn1hoH4V7Mz5hYDJAIBPFHY3To0WFT8SIxNgGI/E+LdCc2jyUWjoIk7lM?=
 =?us-ascii?Q?sNzs0xfa/n2+CAV02ROAgsw8kA3Szty6yl0+1jfbyrNgwY/7ALhZGYfummMB?=
 =?us-ascii?Q?Fd5dzoaeEqluDMBGPZDuXhpV4+A7Wm73xO6oCkg2kKb6RHVwE9bj8kC9RPio?=
 =?us-ascii?Q?Slc23Rqge9ck5hvMYZqNs2XB/FM7hYWBDOZAzLMI9p0lhBiG2xpwl1VAUIOo?=
 =?us-ascii?Q?18ft86hIhH2aqP/74vd1ZTzj7gRDYOg7h2tQe1JX4KDg95e3YYiDWPUgryma?=
 =?us-ascii?Q?sxaCcWdhSJBEAhFbT7qqUjH4Aoq3oR46GfgLi02zDcDl6j5rC09X8l/Q4Wxn?=
 =?us-ascii?Q?9AKI0Td20jr06ZIRUdif/HD4/D3HEYo3LEOdt84UtTUqU1QdGd0+SJKEXeRt?=
 =?us-ascii?Q?DTIXJq057wuepDvQ2xHr6o4IvIx97NsLBUh+/z4+AjdgkFByelU1j6drT5kZ?=
 =?us-ascii?Q?hyuz478XYsDTLECqhqs1y7LGW0H4XxAUdADOpedK4OcXmhl2oZadZT+2Zr3A?=
 =?us-ascii?Q?OvOnlgYhpwy3KYCZpUqWfMFX+if2C1eJ6Y5AYEXCQ7fa37VhlzJBoA+iVBB8?=
 =?us-ascii?Q?BcimHQRUE9lWhl5cbKXj9PcBkhPnq4O5SsHp7/WfuHSJempu21DjQTuJPptr?=
 =?us-ascii?Q?ln//+NpX38t2dC9ao4ZGF6++SEGHeLp9n+YymQ2kikYA85AbmwM0ql/P+qqW?=
 =?us-ascii?Q?x5LYB2JFMoBAwx2aeHJ1aeH2Wne5G56NQeeVgPPN6Lpm9gYYZLAuSOntnhRX?=
 =?us-ascii?Q?m059N5Gx8gMi7KIM4TUTUzP6O1bzJfzYyEwQrLBUZSncU1onwJeMYn/cWJi9?=
 =?us-ascii?Q?rFUN741DOgV17aq64Ta2qzJviBkx1YPsLUhfpApdYuBLQIrhni6g3Iy446HJ?=
 =?us-ascii?Q?rKHsitPM5xGwvRE61mUvMXMAEdUUeKuebSWigVIsO6A4aH6y0WWFmVHjU7VI?=
 =?us-ascii?Q?Cx7LKZmov6RtHtdeRE/tUIU+kOYz/cJgNnV81DIn/FcknufK8WYhYD80ieIf?=
 =?us-ascii?Q?lnmflOFQ3wppNOPvagKVV+BUKACz3lgsFGEfyzL99TIdb+CC7ADqDQV7bykn?=
 =?us-ascii?Q?sW8w5qcx4I4jn7niR9tBmU3804x6wjS42jmGDw/7u79lYKyuiHBjpKKuRgbv?=
 =?us-ascii?Q?778To6yJHxe0h+PxyDUEmHRBwhQpCke7rRk1IN1PcPQ/ssD9eTouTi7+abtX?=
 =?us-ascii?Q?tiNphWPIjw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a30bf55d-232e-4cd5-10dd-08da2ec5dfc1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 18:34:22.5159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F1e6khN+K6jQotX/G+Ex04PAEkrLC/eyrP+JnurqELL0hETZjEAnaBVSLvpoH11b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2816
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 05, 2022 at 12:10:47PM -0600, Alex Williamson wrote:

> > +	/* Drivers must set the vfio_pci_core_device to their drvdata */
> > +	if (WARN_ON(vdev != dev_get_drvdata(&vdev->pdev->dev)))
> > +		return -EINVAL;
> > +
> 
> The ordering seems off, if we only validate in the core enable function
> then we can only guarantee drvdata is correct once the user has opened
> the device.  However, we start invoking power management controls,
> which Abhishek proposes moving to runtime pm, from the core register
> device function.  Therefore we've not validated drvdata for anything we
> might do in the background, not under the direction of the user.

It is just a guard to make it obvious to someone testing the driver
that something has gone wrong, ie in backporting or something. 

It is not intended to be protective against drivers that are actually
wrong and installed in the system.

I added this because I felt a driver could silently be wrong and never
hit a PM or AER callback during some basic testing to catch a crash or
whatever.

> I'd also rather see the variant driver fail to register with the core
> than to see a failure opening the device an arbitrary time later.

It still permits a driver to be wrong, eg all the drivers are like
this today:

	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
	if (ret)
		goto out_free;
	dev_set_drvdata(&pdev->dev, &hisi_acc_vdev->core_device);

So a WARN_ON inside register_device will not catch the mistake, as
this is the common pattern it isn't as helpful.

Jason
