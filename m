Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E307B53B080
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 02:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbiFAXR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 19:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiFAXRY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 19:17:24 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2079.outbound.protection.outlook.com [40.107.223.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10D61A15CC;
        Wed,  1 Jun 2022 16:17:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZfekCytYgomXVnkXShCzZ2QopIeKtyZS1psiktF/TkiMN1TM92UPTRSOtsw8MycQBR2k2P9WecZtoWe8Qw6Fe9RgZ/EReB0DQx38WW/Zq0KY3+LwtuXbWUjKV9ycPWa52xFWTHlzyI4rKLSLtz5JiL+B0dUxt0kbKCDmP5sO3FMFG/tTdDXEkEg2bES6aUu0DORVl2Pb4/PjUWiRA1WPTV1PVzclCZDAZxDEnqRQOWrIIb1PXdG/HTzP62jmswJRyeLXc2iZwtUdJkHq7GqJyLnapwX2ni5C7l+w0zJJWtTa4L0PXvHzuB5H6+r8szbn97GRA95HmPBogKfNBptO6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GPB7WwVmMpiLiRSEAmdXPsuWBZxYigYQtB3pm+esYDc=;
 b=Mu8C2KyhVNl/f0LslYOLrJrykIGkEnVj7UQma8qiglnqDySNXslMY0Mm5jTg3I38yK8v5hKkrP/wXNvntewvKiVXHVMOKvgh5iGCpFkqM05xlRSzlyaCsvaZs4SIL0Ju7/pkJyMgr8+uFVqA6BnXZkqWuaFI6cCJV6jXPrGcgDICu5+RpyVM+W9feuM8Xj5wcoEdgw4lXUtt+iTxAvXAz0EBI4/ZupXemDTStHhlgLLtFVDWh+FXVTuzCKKeXXem8theBlJRBGP5VaT3afMSqOvYWZVPYHzQ8V3ax5sjzPXVgmbumRHL4evxNfA/mWDfbjJx8G+42SObtImapep1AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GPB7WwVmMpiLiRSEAmdXPsuWBZxYigYQtB3pm+esYDc=;
 b=j4cf79EEyjiQwSKrSU02Hxr0cdAr5kJqPSIX8CVhfnOBlV2jk7plsr0C2ORJJH3Ic0NeVp/sa/pDKnw/5Cyu/jqD3UndsdooB3Y6LvifaWOr6Z2nHNIU0bu4TDjhUO5aKRUWFK5x2cjAQASPZMyQJBvtZxLYukvOeGl2JW+LS2JsaKQUpyZ0+Kb9GVQobjwWmuQ6tWAC3GnIpoClkYBP7xY4UOCMswEmnxjz7cB8+ockIrh6OAd5LwGQukhLoVVZ3prtiJ6y/pz736AFYlILnxPBgZY+DVYsqim/4OcvSPnxbx45VyLsshHjkbmCYe6YHAQJaYwCbAOF8tPQFZacMg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN8PR12MB2961.namprd12.prod.outlook.com (2603:10b6:408:65::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Wed, 1 Jun
 2022 23:17:21 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5%9]) with mapi id 15.20.5314.013; Wed, 1 Jun 2022
 23:17:21 +0000
Date:   Wed, 1 Jun 2022 20:17:20 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Abhishek Sahu <abhsahu@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 8/8] vfio/pci: Add the support for PCI D3cold state
Message-ID: <20220601231720.GT1343366@nvidia.com>
References: <68463d9b-98ee-b9ec-1a3e-1375e50a2ad2@nvidia.com>
 <42518bd5-da8b-554f-2612-80278b527bf5@nvidia.com>
 <20220530122546.GZ1343366@nvidia.com>
 <c73d537b-a653-bf79-68cd-ddc8f0f62a25@nvidia.com>
 <20220531194304.GN1343366@nvidia.com>
 <20220531165209.1c18854f.alex.williamson@redhat.com>
 <00b6e380-ecf4-1eaf-f950-2c418bdb6cac@nvidia.com>
 <20220601102151.75445f6a.alex.williamson@redhat.com>
 <20220601173054.GS1343366@nvidia.com>
 <20220601121547.03ebbf64.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601121547.03ebbf64.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR02CA0124.namprd02.prod.outlook.com
 (2603:10b6:208:35::29) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d57344bf-511b-403c-0bba-08da4424e116
X-MS-TrafficTypeDiagnostic: BN8PR12MB2961:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB2961514A5818C697D2D97FA7C2DF9@BN8PR12MB2961.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CoIO6tXD7u9OhcaCoYnpzO5FHtyGb4qQ1Eaiu4SPubUeS3V6w9aKwU39dPS0r0DhNrOxXwh+WGpr9n40aY6qfqoGL1CueUhuj29L8zFIXPTnymIl29FVFpN7F2Pz76Zkjkr87bG6ngYTF4uxtbg/b+qvfKHiAjmQoeIaYLJFOoRdkJGFBElW+3IR1sQ49NH7PH2DKb1vDuH/avBjY4b95tg+2l+YMkh9cj9z8Jc3vFssO3KxjMINhTk06sTojwAQyVbiYVo65a/jC6G0kwjYxu4Y7GFchSTZZMO7D24vyid9bZY9f3CZQlU2C4Iu2cE+6ZRrTEZ/wIJgMs0NKGOQlKUSs/dVmCbEKfO7TirRlI18DY0j1UkNmH2mnh1qwE5BXNBqWJa7wdhECKWBBCWNV5vMComr/EEh+v2qKCxZRotkqGlfONmVLTNdfG2lXOvMtjMp9LxruBMvGCO/eU+pKwfeKj1hpT5o4ExKuFFlqam0TsoDGY7No1xRvaT19fabUZUPy+GMDuqnQYhYZuFH/hPL2McgbBakxtAn/XeYZvG7S5NBlZUQt6YuChXdAO9Q7knS5r15DDZsAGE24tZL5YQKDL/k+f1kaeiTS9ngl9dXbC5RmInAjfiGCizEDuJB8QlCi9Q2FPLrdSqHzgXO6UL1uDtQshxKs0bmr3AG4jLm56RfKQRSx4L/H9EI4+uQdvXNB3kVJKyODr4Dc04Q+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(8676002)(86362001)(66476007)(66946007)(66556008)(316002)(38100700002)(6916009)(54906003)(508600001)(5660300002)(186003)(2616005)(1076003)(6512007)(2906002)(26005)(6506007)(8936002)(33656002)(36756003)(83380400001)(7416002)(6486002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GLkTqOdsaZt85s7EIPafH/pr4kvqL5CQ9Gko/a1cMzj/n8miiePsfwEjucbv?=
 =?us-ascii?Q?E5rgRHzHFwfJi3R16g8Fs9ZVM60EN4OfTYAXxsvsd8wOLFPVVJ8taFdYKr19?=
 =?us-ascii?Q?N7AFZWH0ag7Jf6FbBGHvZZ5k2iH0PD9mqKRJUtp2vEYnKmhpB5I1LIwglqSM?=
 =?us-ascii?Q?Hhh2pkoct/vtmR9hsNgKyh9ooCtkDSuyYuzDK7875L1HBRaZyylxcRU56dPV?=
 =?us-ascii?Q?Nv3PsZ7sq6hGoDtkt9ioONn0gEjB0xpXRBRhoDNf4UrY/s99RDjqDwGZUaCc?=
 =?us-ascii?Q?bBwP4yHVbwVAvU9JsTpWeglXsybdKJcIOOYz5OzG6xQ79cmvVfB0OUc505aO?=
 =?us-ascii?Q?EOKI5fTUFjVgco7crlulk0oXNR+RwYE1izm2aA+1sR69599/WH1qofdSoPjz?=
 =?us-ascii?Q?NGikVw+yb18PXiDojaIpQ3BgfjddQpP7ZOiBB+qEt6/TLVxdisWSfuDlBDMQ?=
 =?us-ascii?Q?MQVmXle2AKlAnlB2m9+y6hk3yyRRJQus7PuR1X94l7EUetEr4xMggOLHk2Qs?=
 =?us-ascii?Q?7I5l7Qx1QjWAemMqG4zKGbZO4pXEWBViDnzGJ7wSBVZN9wEF3GYQ8LE4C7to?=
 =?us-ascii?Q?d5u+X1JRKnzS+OLr5V2dP/f6rcsNsIcvpf9gcFNEtM1QI1+jgIGPnMEfcMpL?=
 =?us-ascii?Q?jV0Kpr6M57txb7vMY8bnDiEGmKtgUF/qJx8Sj3KNPooT+9lb8QRsg/r9C1Oh?=
 =?us-ascii?Q?iPGXioshh5QORbwyMN1rCGvyrKt1J/HuPfVfHyEixKayrLMuQejey4NGIMZa?=
 =?us-ascii?Q?U6+IaxiELBZMW3ORJSkxeLOFyLrOMqYqmMFcA7zJdQv61i3lSGY9DBNDL4iB?=
 =?us-ascii?Q?7y4kacUvcL7nwbi1xkF2IzCVuLA52HK0M94iOO4ONNZTtgEeD4ZBiDzxOTS/?=
 =?us-ascii?Q?o6jGTAoaHhYIwSleomZHVCh2saHsTSgCef19uMofyEYKLXYDZzXNZqDXjHYG?=
 =?us-ascii?Q?5ZhBZxvi4BlnkUODcm7ZGyGMLWmPmmL4pLaoCZLadq1fl4rvOIomSVh/IVrJ?=
 =?us-ascii?Q?YCVVBDyccH9EJy48VUbXErlDqg2LAY4lOl3x2YhE4aOQOpXE4gWjCS9eiu7a?=
 =?us-ascii?Q?EYcpo9QqU1ETNcJJkA2Mp8QPOleXK6AUkCm+R0COkzcWNdnjmgXKOBCkHHQY?=
 =?us-ascii?Q?kaw35Htp4Im9HyTljqlxUSXz53t3vKJJGQ5VyPJNgM6xq3Yzys66AOKUnTeB?=
 =?us-ascii?Q?O5XeAub8R0oDLnq/cGd5yLG4X+aNrqUYXtWTZHEdjkCDErEvjJoLiQsLbXV9?=
 =?us-ascii?Q?BnmU0h+jLirT83Sj9zUNud8Ihqi682+xkrIzWY/aroEGma5Sz2kcvFJm+SWy?=
 =?us-ascii?Q?KlhwOWCFCDljNgdmVCF0WIZw2n+kph7graRFd0hInRNIsR+ereudXEVu+GRn?=
 =?us-ascii?Q?7oM9gVj3VpjBuBy0w5pWk3ylzGI7JWXG6wW5lQxosLY1c1BfADGJ6z3YbbL+?=
 =?us-ascii?Q?IxsK0Obp5LNJmaT9sD6T9mD1fRULg2DS/8v81Oek4NfcblMP8iYt3Hvhv4XP?=
 =?us-ascii?Q?JBdp02x83enKyXOlwmmGiNEP+ciU160hRS4nNcDKVCltPMcOWfcZQ6Gbr7MX?=
 =?us-ascii?Q?HeIMaRcrMRPaLnZoqLBTOUPNKJ23smfX4F4Kt2+io6Uamv/p3FvIPv2847dK?=
 =?us-ascii?Q?kEqXfy39/gCF5w6eR2EqlmOoCMRRoUCEib8lr5IewdfnOIkayeAIjgcAkO86?=
 =?us-ascii?Q?uuz3rwrkLybMFCOhbR6wT0EQexY3Z7r71T+HNUw/3f1KYjqDDFGZuGzo5i3U?=
 =?us-ascii?Q?7em6LuxSJg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d57344bf-511b-403c-0bba-08da4424e116
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2022 23:17:21.4219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z3dXal2lwGJUs9dySq0xlsm/+Ny8LVu4l5MMiewlL5rHvYljLF3PtQz584ZbVpD2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2961
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 01, 2022 at 12:15:47PM -0600, Alex Williamson wrote:
> On Wed, 1 Jun 2022 14:30:54 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Wed, Jun 01, 2022 at 10:21:51AM -0600, Alex Williamson wrote:
> > 
> > > Some ioctls clearly cannot occur while the device is in low power, such
> > > as resets and interrupt control, but even less obvious things like
> > > getting region info require device access.  Migration also provides a
> > > channel to device access.    
> > 
> > I wonder what power management means in a case like that.
> > 
> > For the migration drivers they all rely on a PF driver that is not
> > VFIO, so it should be impossible for power management to cause the PF
> > to stop working.
> > 
> > I would expect any sane design of power management for a VF to not
> > cause any harm to the migration driver..
> 
> Is there even a significant benefit or use case for power management
> for VFs?  The existing D3hot support should be ok, but I imagine to
> support D3cold, all the VFs and the PF would need to move to low power.
> It might be safe to simply exclude VFs from providing this feature for
> now.

I know of no use case, I think it would be a good idea to exclude VFs.

> Yes, but that's also penalizing devices that require no special
> support, for the few that do.  I'm not opposed to some sort of
> vfio-pci-nvidia-gpu variant driver to provide that device specific
> support, but I'd think the device table for such a driver might just be
> added to the exclusion list for power management support in vfio-pci.
> vfio-pci-core would need some way for drivers to opt-out/in for power
> management. 

If you think it can be done generically with a small exclusion list
then that probably makes sense.

Jason
