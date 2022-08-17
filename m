Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 177F159703E
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 15:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239669AbiHQNx2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 09:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbiHQNx0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 09:53:26 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2087.outbound.protection.outlook.com [40.107.243.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC083419A4;
        Wed, 17 Aug 2022 06:53:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aQgVOJSj0UH9A5LOIwGFGweZCLt92V1WvemOAsx1PoaMaaO+iaZ6JydtAEZ6Lj50/vBeqUKJ2P+/+c2A00Wq7aPZFpNsB3P6/VbzWmUISyc2ucq5Yq3qtaaQQ9PopPG/h7zYUeKxbrMXwwr+n/Of0Tp7z513g6uXXlqEWlks6EgVwDjPjiRUfUq7s+8sfNCnpV853l1DEmpcBXA74wtsDha2S/U8d5G6+nbaXbCEHG+FBrSBAdth7vh6hcfMYv2HS4TnJSoL+FEH4JdQWwLm3UI1FnR1pL6R43WPPo8l5NeIY5AxL32HKDbRB+ksixq9GeOiOF6iDUni+D7WtLp2Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4geboXIWR9JY9IaFfpuXVZG69iCDrKe4rreTQjT4+Rw=;
 b=dJBKnYQdQ8wyWIMpETuY4LrQNq0ewd1aYLJayJllv9x20EO95TCYlfGF/DEZ6XrLx/5aRoOjz/UsSMcF853AqGu15WEdhJIGKNKY7wJ2fZfO+DykGtFFDDv5Kxo8Hl31a3TLgE00xQX3jEgevINDK+qgBeITSlecRQvU+JjKEICngHObJETXF836I/tVgz/9CwegBpJI4+L7oyhkT2EDVAFdWdIA6uvgzvZsmTHLqY6V8DQGjexfkNenr5DeHkgykd7w4VmhSN7g7xcIwxL/dJ165/xGcSfr9wOh4bDGlbvsotyHKvlRrlhvmdfWbSekFucZNvCjSg3XfX4+uX5w4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4geboXIWR9JY9IaFfpuXVZG69iCDrKe4rreTQjT4+Rw=;
 b=RgcVxP22VRVW0RpAoRbqAhArYxw21eCUid3L55uqs/cbWMb8D9K5c0PoD/dJIQds/pKw5cmnQF5L8MearnKNJ6fEn21M/qignMqAaDbwS4/6ze+ST0tPSCklhnjG2JZdEd/NNNdwqe3sP743KjtA7Hp/yRXw9C48nf1vvsQ2AMrog8TSgAP9tmvbCSdjTpUD6eo6k2BFz61Le66ABXThOmbA97sDpuhI0GTnx2wAcDwyM1Khk3ca7qEqVFKTdwiFssX/YQuapyNMqZ9TK+X0eANR/VXsihWlYO5MJG+L5nAASr+yKecNxQ/ioFAsmRJMgQrx4OAy+bmTN+w0MMwQYg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by IA1PR12MB6284.namprd12.prod.outlook.com (2603:10b6:208:3e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 17 Aug
 2022 13:53:23 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%6]) with mapi id 15.20.5525.019; Wed, 17 Aug 2022
 13:53:23 +0000
Date:   Wed, 17 Aug 2022 10:53:21 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v6 5/5] vfio/pci: Implement
 VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP
Message-ID: <Yvzy0VOfKkKod0OV@nvidia.com>
References: <20220817051323.20091-1-abhsahu@nvidia.com>
 <20220817051323.20091-6-abhsahu@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817051323.20091-6-abhsahu@nvidia.com>
X-ClientProxiedBy: CH0P220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::11) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a58efcf-5007-44d9-b3bc-08da8057d9a8
X-MS-TrafficTypeDiagnostic: IA1PR12MB6284:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q8CsYJG/MWcDDDAEkMJnStePHWQyIsXTCuHae/WeCNh1y8+oHmQxL8kNctC2bdjI1aX2/aQPn76siVy4sFFk9iEgSEeT88iWfgFU2/94HvCm/ulID0Bc/2DTXgY4pf57buXgYZUzk9AjSRsk51jjU6fGx6NqZFQLZIcL0dubzGe/bSu5OppDpZTnC2ef3tp+Nfl4unayxVJjqezxCsah7SWHRkhJ6tL2Nq3J8MOSxv3s+F/AaZj+buCXqeNOEA8sEAhGPEoKp9ZPfO0U9JsMr/Uj65V5hDnJ486oVPFLSadi3QZoSvVUndTCkiCQ6b76cOn6mq6ErOhn2W+pUCyEsRI0dNsyOfVVZ0RY5hD1ZGrVUYBYtqP74byHTJWOuq/ZuXwmV2w6e8z39GkQPEqEjX8lNvWHSHNidQbMfQBtaHHDVEKyYukhVGTIYl45w8VU5pmGsiPLTsOpHO6GJ6ONNuNdX/Y/5gd/432mNI3x2PaZoQSYj/sjJ3+6z/BXCAxGZoFuuhZoCP+p9faEYaWVW88JMkvG8ZX3JeB/fHc3f7r8avy4Vmg9fPLhObmedlIO605Nb5BsnP12UEdqLgDLMwWB3k8NN1bTcqp2N+v03/OA8VkZRAiwHb3Lw56ginF8of+IbOnIfpXNm9vASx+DwUrXzESUPkQVk+w+YtbkEilHXzXcZXiQY0wZSJFNY02HIFbNYfK+6pv9lFaxiVsndc11NpMsh92Iok7Crne+6+c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(376002)(346002)(136003)(396003)(316002)(5660300002)(38100700002)(66946007)(66476007)(186003)(66556008)(4744005)(8676002)(6512007)(6636002)(2616005)(2906002)(4326008)(26005)(37006003)(54906003)(478600001)(36756003)(6486002)(7416002)(41300700001)(86362001)(8936002)(6862004)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/k42N+COW6wSB8jGby7vmMs8JnHnPfe0Hj8MD2w5BFak+pKCvEFKu6DqFvkp?=
 =?us-ascii?Q?g5LbrsTCP7Vv72+g8eZbIzEht/QYsSsWTwPXCfT6QNDiL2wK6aM/3sCrnOpl?=
 =?us-ascii?Q?qWOBC0GpEs8lnOsXtFHwqORdhk1EJ061Ggf9ERE5lZcMU26QAiUxRE25fxU5?=
 =?us-ascii?Q?5OFldyWjPy4YJv47wwB7IdSpnteh176JXBQccx8EwviCV5EvW9xPucon4rJo?=
 =?us-ascii?Q?nIEFKSJqsiSBYWUxaz7TYoQGLQY6HXdVLxuZvAdlIFw2DA6Zh+/XYOejOQOB?=
 =?us-ascii?Q?QEl5rYZd7FAn8J+0POCH32iX1uncHqdZPXYwnoLjrDj18X82IOd5YHVJ36bU?=
 =?us-ascii?Q?jPxig7eIYeRt9LMI3zNopoT/T0R8SxRS+T3wXFbUDaoIYHIeStzuXFoVrhUO?=
 =?us-ascii?Q?jNTKnf8tEYvjjX5jgLKxA8AYSFKzuIjX51Yuzl3ZOgN0cR4T5lqO3jwJijpF?=
 =?us-ascii?Q?234S1UDHd32Z5tA4p/oSnYw8/ISTOiojRCIUY+f8FtCBui4lSZxOnhhMUW+k?=
 =?us-ascii?Q?wOrDBMb3QRf6D4kD50aZfO7Q7ai4soSii62VvRrquwMICokzDZMSoy7ILtoP?=
 =?us-ascii?Q?2BQDb1S2fx+YX5qqZlSzUUsYV8oLQKDvaxpY/1i9Rmaslko1FAV4tT1zpiDW?=
 =?us-ascii?Q?9Ayu4pEjB8GUTa9lQsmlDnRjVz3fb6k5OvffsXCOhAIA3OSEMMCGUnD7dBXG?=
 =?us-ascii?Q?d0tNchvI0/906VXoCcRe+Qrdq/XTUZ8WqvWqfvzQCmglbD0p8Aqqrcv5vxc8?=
 =?us-ascii?Q?0VYzPoM0HTG67lCwuykwMtVG23qvkcva58PSy9NweVrv8ez9mX/tPNS+Wx5s?=
 =?us-ascii?Q?cRkvXnWgUPqiwq+UyOgV9N6IZT/BytDQVL9KhEo1la9GKhsE2kXUAqnmA0Mz?=
 =?us-ascii?Q?XJundfTAG6ppFmR5vdQo03v0lJbdkRUYCxqSWXoRhbGUmBCy9Bce5ncV9ZO9?=
 =?us-ascii?Q?7LaeJ1XlL89KYf+oGc8XELH88pbwZEkvE0lTGYv8eu5HFouPGP43kBnoglTP?=
 =?us-ascii?Q?IeFrFfTSQgHb5dE85rv+0Nz35pA8irdwqPFhnxS28eOte7tTO8DPign+LvU/?=
 =?us-ascii?Q?8W55bj+d9cccOOKCWzr8ou/pkcsdS/xMxJy1HzgNQ0OwjFgsv5GyagvhWQbq?=
 =?us-ascii?Q?aBIVX5a0EkLtBwnd/ZpQ0mZ6KzGOBVNnP8i5ELcojiTyLJzUGh3lWPDezrOV?=
 =?us-ascii?Q?WZJeb3jzZVuzAetCcTu4CbYetAIHZ1BdBb6Yn9umJFNcFmM1gN6fix5uLBfP?=
 =?us-ascii?Q?Tq7++DROtvsVyWFfCjuPcC+9gFMcVAZAFC48pb3JmSKosGQowogAbGGMsR6c?=
 =?us-ascii?Q?olkn3zeIwfWdoghMMVNQVDWslDORet+mDVLbcafRSgOYy+Y85oBLSDIBE1Eh?=
 =?us-ascii?Q?XImd9GojS7/kHFwRch5NBT0JghuXpTZh1yOW1ZKYxOPBVw0V4NsBMx3PbrgK?=
 =?us-ascii?Q?mtIEFGSGpWfHaaWNlAiDVmHdeosi5D5FM/gIn5GbeD0GTAvEyyi9hPbynzEY?=
 =?us-ascii?Q?ofnoSd+xvNdRlUKopH8w2MmS5d9rLYc6srZZ7Ostqs1HNtXycrax8hmpKuM3?=
 =?us-ascii?Q?G7cI1lNQJB3+pTLN6rAg30F+jkmE40Px0AyX3XIA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a58efcf-5007-44d9-b3bc-08da8057d9a8
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 13:53:23.0130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jeIj06HsnGnLkeo1tdDt0fYMWav4my0a7n93wt9btIdSfgxtnnA6OGJk07GCVRvn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6284
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

On Wed, Aug 17, 2022 at 10:43:23AM +0530, Abhishek Sahu wrote:

> +static int
> +vfio_pci_core_pm_entry_with_wakeup(struct vfio_device *device, u32 flags,
> +				   void __user *arg, size_t argsz)

This should be
  struct vfio_device_low_power_entry_with_wakeup __user *arg

> @@ -1336,6 +1389,9 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
>  		return vfio_pci_core_feature_token(device, flags, arg, argsz);
>  	case VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY:
>  		return vfio_pci_core_pm_entry(device, flags, arg, argsz);
> +	case VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP:
> +		return vfio_pci_core_pm_entry_with_wakeup(device, flags,
> +							  arg, argsz);
>  	case VFIO_DEVICE_FEATURE_LOW_POWER_EXIT:
>  		return vfio_pci_core_pm_exit(device, flags, arg, argsz);

Best to keep these ioctls sorted

Jason
