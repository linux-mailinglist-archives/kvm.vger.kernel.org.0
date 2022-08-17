Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26D75597537
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 19:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241082AbiHQRk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 13:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241249AbiHQRkw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 13:40:52 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B843A222B;
        Wed, 17 Aug 2022 10:40:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTwMe+6adBDSX4+9C52nt6hpkY8N+HA60Ny9hgNJHkWj6JTmcLKPesceGdEQwmF/Dkf29sOs/ycaFW31Bkt6nGISM9OcZptTTC8iPFgklqeFmJP8G/B3KFU555FQyVSS3Vz6oqp3lmDKYVBjdpDKrXr1x7dfucTqvTzcn4V3HxEdU1bfqE9jwG9oqxGmTFrhz2xOdixWiq9YAjfNIlRmeK19SebBRkX1uh97CBZ2ket7V5bCc4JU7FJz6n0ht01Vgow7Yrv504bektRPVr47KKzBYt5UNI20tF52cQjMs3qcifyrrt8zXObL5+AxlWB6P2TKSW1/h7e+0Koa+PbCqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Im7GAjEaAOT7RfPBvhasbZ7Q4Ny9qtaU5Ev2KwBZjO0=;
 b=RPuotByx0J96p379oiv/yKfOHM8rXvQmtZbMROMcij94M5XqdHvYqPkvep4XVqgtJIlh2liWcEjZdi8UwyXMQKsmekOaclluSrKSa//C3kjnBbMOqlf4MvVukSAhs1Vn9OUk0B1+8ghoa3YJf8pY5U8vpg6kxiWHPQ+7EmTZTSGL5/36LFfKo2TStXE/+c7GEZf9yow7WAUAH0jqZ4dhwMTBV9QHZvuZBmZ/rYPW9ghEBto9alNcD4nDqdSo4duXko2iikPkC8gepaIG6DP1na4/yYA9POzsbj9bYDCaoOq5qFIGqmXEMh/m2DiyAbWwoj5Kti6zAt+9gFxpqthKlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Im7GAjEaAOT7RfPBvhasbZ7Q4Ny9qtaU5Ev2KwBZjO0=;
 b=DhrfYF3Gov1B8JjzjA9lYpb8P37YIwQluo+ZmBR1o7xXi0NkFZnw8NlfMAGGuEjfBial90sItUEjLCMHwBmP/5s+cf0JAhsKtqQvY5R86lUm06xPu+XCV82gX1LEzgQa+mRGQd7MlZQmXE9A2blrVQPP9u+va7gD42fM+oa7gGcb0Ntk/U7l/P67VYI6tFSpJ5aY1wFAe9nNIVXXOrNo8Cd/NJPT86krqcgzp8lHxLMDxXATRGWmCShH/jkZW+GqsJ4gC5g0/DQNIlaQFh7DsvIA9sG8D7rAPuRZ4u9Vrz15SdoSdid1+bitxOLX+v9+52Gx9akqNTU47GvNlrj1EA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB3690.namprd12.prod.outlook.com (2603:10b6:5:149::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Wed, 17 Aug
 2022 17:40:49 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%6]) with mapi id 15.20.5525.019; Wed, 17 Aug 2022
 17:40:49 +0000
Date:   Wed, 17 Aug 2022 14:40:47 -0300
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
Message-ID: <Yv0oH23UYbI/LI+X@nvidia.com>
References: <20220817051323.20091-1-abhsahu@nvidia.com>
 <20220817051323.20091-6-abhsahu@nvidia.com>
 <Yvzy0VOfKkKod0OV@nvidia.com>
 <5363303b-30bb-3c4a-bf42-426dd7f8138d@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5363303b-30bb-3c4a-bf42-426dd7f8138d@nvidia.com>
X-ClientProxiedBy: SA9PR13CA0088.namprd13.prod.outlook.com
 (2603:10b6:806:23::33) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba82f4e3-7925-4993-677e-08da80779f4c
X-MS-TrafficTypeDiagnostic: DM6PR12MB3690:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N2soas64CUrOBeGs9+J2pOeaPogmOm9b2ZW6yVB0ATY9VtyqvnXU7fiAyNec4+Z7srdUvz/WKrHYV5xHPpem6TREfIHEbfI19Pq6cdErzplMeeyFaToML1yCaykHEC6oWsvg8uXU81XRR2OFBaEcZRL5NP8mXhcmgdOeN8sZ9MNZqgU0Q0S1kjBb8cXJ+8TJqo3GHUE7OLHW+ZWIzFWy9DozVeyQecef8jQ0LSf6Y2ObQ2mAUrxQqUzXI7F2t2iTfz26EDN9AaMCXNcMJmdxuAA156B1ZlQmykeje009yVMBHxuG9JbybkoTalQgiZDkI1uBdGpzzyGDTtcLI1JkieKr9FD75DhsCHO0zXetQNgmHmIKawIalg+pW476F55VP7enWSOyDiv3zMPEeLJo+GreFTcKrr4dVl3f6AAq0zq5yudZrLfMU8QU/py3CL+BMM/Qf/SRGVcRzh7eviCMotGzZ3eesVj8j+ZOxh1d8BWIxeI/COIpkvuuptLu/s4T/y1LHxjdQQ/oBYTeN2CWHStwPzVZlmq8Z8v61Pl4LMtrsDqPCNVZyFGq0f0mTi9rFvy033LZw7/DUv5XC+NdbjE5h+N8TQatVIGuKDMWN/I7r0Lju/cGfAIMW5i7EWmxKpoPUq4p+I3lX6qRaEcp7FtWf1qRzVyiyTkT1MYAm3ooZxYR4L0IxAy1fQYw7KRlFxaAn7A46r927IpyibfnWDPrNg7fl6ca/0K2+uS6NeM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(83380400001)(186003)(2616005)(6486002)(478600001)(38100700002)(316002)(41300700001)(66556008)(54906003)(6506007)(6636002)(5660300002)(7416002)(2906002)(37006003)(8936002)(66946007)(26005)(66476007)(6512007)(8676002)(4326008)(4744005)(36756003)(6862004)(53546011)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aeFGS29bZU5IMbuEelVu27UQnLlRtN9j8oW0HQGzW2X0sutN0x4sW4Dr4/4o?=
 =?us-ascii?Q?S6df6vmq9s4z2bfYoTUP6l65R1xr7XVyGVe6fp9vDastliC/iw+IuqXFrhos?=
 =?us-ascii?Q?tNLbrLqOh891/0Pq1tHAlcRc6mU+P6q6VQBRwqtUAKFlIN+XJTPxhUhapI0q?=
 =?us-ascii?Q?vrszjzeYyfjRt2fDEu09yeUZ8jghbDpb8qcFXOFZyONPXxsHHGfi+1bw8hKQ?=
 =?us-ascii?Q?MSfNItZGvL7v7PDPes51OZPGAw9YmNpCQt+UQJA20iQMFlvLRE/rAwjsnfHk?=
 =?us-ascii?Q?KdSW3GDGPSclZho3wropWP2ygZwvbW1ACEHq+NsC8vfo/0ITCOhcDoQZyqNo?=
 =?us-ascii?Q?ZGJKc5Xuf4a5ovWrDcEhlSK9eyz8n4fpDJiSB5HV6hHpA0wRPI5ZF/Gt1S3p?=
 =?us-ascii?Q?CjdSTB3uHa5+2s1SCVwFffC9dSDZEwOmyGYgb+ptPwn4OrDC3Qerw9frp5bC?=
 =?us-ascii?Q?bzUCEeKZIFvUk4/55iYN/cB412L9IfSC+XsjHYmB1X+ZOSsnbW81yrf3VEWK?=
 =?us-ascii?Q?ZGREi9LdFK16Wy0mTqUqA6AkwpYHmWKyz8N+/+VRxjbKpsFxqhNKluVQ4yeI?=
 =?us-ascii?Q?KOvFwDKaQ9r78Bzg6XaUr28dC3hzS5H29WW0AXM4WkDJ/eiJbWIrzEmaIBXS?=
 =?us-ascii?Q?zYhDGkyWOZE9+jVScjBi1bjGCzkulvNBTAB6yQ8fKAyrVX2M0RDbQy7BGDgE?=
 =?us-ascii?Q?k48xGLDya1ShHmEty+Gnm0/nC1bCxjYVCb6XULE5nM+/u3gmEGJOlBY+hkVr?=
 =?us-ascii?Q?BDPdIZbOjBNYrKaj9avSvNILGItrt4/iaIE17x+bMMWqUhuazCgpoOSuvt9D?=
 =?us-ascii?Q?6EEBgnrR3CbYN6r/NinkVvqmAuY7v4cyjiHMJtmfzaVSodRjbNOSxcrE4yte?=
 =?us-ascii?Q?W0AI1tIrEgnojJ9RIr/kJwLERRpFcNRPKUiR8EUzwytAjzwRtjR7w4JwKH23?=
 =?us-ascii?Q?InclgZiZ2ZygKhmQEy4KESrNvcWV7gbhkScf+sZpDI3O0J7ktK333rwutkwf?=
 =?us-ascii?Q?p96W6nJmXan5uSVlFp0srKUot/ALCoX9o9/Wvd0xWjegUsnyK06qcx5zCZP/?=
 =?us-ascii?Q?AVaS7+53Ae2GwAm+K0rOsGEVMXHqEUGutaLltwkQ3y8Z0VbOcQjyWzdxAIyD?=
 =?us-ascii?Q?n1GzGESYZ8R5SkdtXtDd8KqSU9vC7a+9D+3dMXsZW4mZhjl5dc5KfIGG2Gtw?=
 =?us-ascii?Q?notOnBIW8OuBZxVPABI4EDG/lb6cDiheBicuej8MSM0odSgPImuz6Nc6cqkq?=
 =?us-ascii?Q?iGkXGs/XhkC5+YSvBIIF4Du11N6CEsKrp8Fnu10RRbKjNROPb5+HgLjrgq1g?=
 =?us-ascii?Q?bNkCTQODgDh7isTSBRY8d3cHcAdvd3auDDXkY9dXjj6yjXCtXj0SIsSG2IDz?=
 =?us-ascii?Q?28iOSfFT46qU6mNXFIlS+DZaMQnLwbTdVR9xByUzhImxh71QmR0dtqlOE9h7?=
 =?us-ascii?Q?/rOtYJR07BQTuqU3vORJde7ZXvZfYMdPUa45G6KEjXlKSE2VO/qPRPp+cJ6w?=
 =?us-ascii?Q?ZydE1oaghIbxXvFj65KpXRaw0e4IxmhRFCiIgIyJFH5p/49Qibi3gQ9+G/96?=
 =?us-ascii?Q?/Ex3ESOh3HniLjLkfSJjGUsuLqC5dWFCkAJluRuq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba82f4e3-7925-4993-677e-08da80779f4c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 17:40:49.0249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zlMGPwn91Dk7ZjMVDozgAhO/KHzfpm5lq25KcbN2pCskGtydgcyQIpiwiKU4VovK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3690
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

On Wed, Aug 17, 2022 at 09:34:30PM +0530, Abhishek Sahu wrote:
> On 8/17/2022 7:23 PM, Jason Gunthorpe wrote:
> > On Wed, Aug 17, 2022 at 10:43:23AM +0530, Abhishek Sahu wrote:
> > 
> >> +static int
> >> +vfio_pci_core_pm_entry_with_wakeup(struct vfio_device *device, u32 flags,
> >> +				   void __user *arg, size_t argsz)
> > 
> > This should be
> >   struct vfio_device_low_power_entry_with_wakeup __user *arg
> > 
> 
>  Thanks Jason.
> 
>  I can update this.
> 
>  But if we look the existing code, for example
>  (vfio_ioctl_device_feature_mig_device_state()), then there it still uses
>  'void __user *arg' only. Is this a new guideline which we need to take
>  care ?

I just sent a patch that fixes that too

>  Do we need to keep the IOCTL name alphabetically sorted in the case list.
>  Currently, I have added in the order of IOCTL numbers.

It is generally a good practice to sort lists of things.

Jason
