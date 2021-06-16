Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977613A8D86
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 02:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhFPAg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 20:36:29 -0400
Received: from mail-co1nam11on2086.outbound.protection.outlook.com ([40.107.220.86]:46176
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230244AbhFPAgZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 20:36:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ldQyrAHKcbVui96zD85uzUJP9KhBosF2Ld9VStD05txYAqLB5g19zqmhTNM67Gv2UypYqRkJFfAcAgFa/2OBv0F2zgMW1qmTV3vauxTPO4gy7328AElX6Mt7KnsW1a597bq9IN8Jf6/AvtdsRJFZ/nKYWqb/EVoELm5LMkaTsF0iYa3MwQ2XSxQBtiWQ/VOCsxnOOzopLfsoDccveouLDzEVGiHoiE9YDWO/oHKpwo6cAs0Z+2OYO3Nbp5DH1PmfGuGktOq2Gds2GA0yX264ubgFMJr4GzYPqJjITnsUC8030X3tYqeaX2YgNDcUnrQlf5bSelllSEUb+9iKL9WEpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIuiMfxqLvs+U4bb7BtIJOcXJcos9Fkhy4j6n0V8aUE=;
 b=IP6YrFG+KyytLwMDxrYF8DVdQK8/gvgMcCNh4WOAI4PFBhl/kot5DBJHm7AhB9YFTJt/g9In6S/4ofbF3QmxtSVkFsE1Dd/v9vHBZlk9EVnal1SbvXnXEj4EXN/6NGYo/WaokZF9KEDU5ubapaw5tzEuDiuRzS0SXOcZ3op/3SxaXj9WJRmtwc23LnRcd6l2LxegaUfFQjYJr9Jv7h76V1MfP9SChQo/2rwFteEprWfu9+eYwehyWD1I3c7nDe7J8NYp0wteBR1uyL04RUyeH5RXNOudC8dahaUa4I326YVvgh9Wpg7cLfAqegK9CkbGNaNYwxNsguuldtVKBqZ8Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIuiMfxqLvs+U4bb7BtIJOcXJcos9Fkhy4j6n0V8aUE=;
 b=n+NimqvCmcKvqr5FnbfWIx7+Kfwg4JRFWy3QftbplOsmqkBfyowelH/l0UovHmJo4Ux45JyC9ZFtijKcDHdCyTQkk+ZwEC25ujVyldK5AHAu3meMI24X598/GHSkR68Gex3IBMGowaIToXY4L+Cy/pF+0I94XuggX9r7fnMDRu6WJg5KRIN1REkLURk7MMpdHe9dEjP/yRXUWiRj04oLKQvbaAQu12mcL0pZUFJ2w3gMftqjC0c+iCaY43eXGseyXD3yIySsLmLo2R8NLrCJS4QS/tj80kK2K0tIxM/tj/n0HvndHIm5ZB1/DqQsa8TgNl97MEJr0DLKkiZsjaZNdw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5336.namprd12.prod.outlook.com (2603:10b6:208:314::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Wed, 16 Jun
 2021 00:34:19 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 00:34:19 +0000
Date:   Tue, 15 Jun 2021 21:34:17 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        aviadye@nvidia.com, oren@nvidia.com, shahafs@nvidia.com,
        parav@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        kevin.tian@intel.com, hch@infradead.org, targupta@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, liulongfang@huawei.com,
        yan.y.zhao@intel.com
Subject: Re: [PATCH 09/11] PCI: add matching checks for driver_override
 binding
Message-ID: <20210616003417.GH1002214@nvidia.com>
References: <70a1b23f-764d-8b3e-91a4-bf5d67ac9f1f@nvidia.com>
 <20210615090029.41849d7a.alex.williamson@redhat.com>
 <20210615150458.GR1002214@nvidia.com>
 <20210615102049.71a3c125.alex.williamson@redhat.com>
 <20210615204216.GY1002214@nvidia.com>
 <20210615155900.51f09c15.alex.williamson@redhat.com>
 <20210615230017.GZ1002214@nvidia.com>
 <20210615172242.4b2be854.alex.williamson@redhat.com>
 <20210615233257.GB1002214@nvidia.com>
 <20210615182245.54944509.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615182245.54944509.alex.williamson@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR06CA0020.namprd06.prod.outlook.com
 (2603:10b6:208:23d::25) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR06CA0020.namprd06.prod.outlook.com (2603:10b6:208:23d::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Wed, 16 Jun 2021 00:34:18 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1ltJVZ-007I1n-L9; Tue, 15 Jun 2021 21:34:17 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0860dd4f-b979-49b9-95a9-08d9305e7a5c
X-MS-TrafficTypeDiagnostic: BL1PR12MB5336:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB533625D6DB515FE8475F8C33C20F9@BL1PR12MB5336.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cj0izRTBe5oRGRI44720ugFDuM/NVV1kNzpWX+DRjIlZP5gxbmEV9K/TpLe4sRh7bxKRzu7nQGlVQBJTi5Z6BH36b9fTFFIo/pEEopAfHgXV/Zzjb8tcoiEaW/G0PdDlRr18apUTIjIhGpJFsrQ8b+wpUd+dihTfTn13zCKbppl37JcJPM+idExypmBfLGuzctTX8YcIcI1K5+vA0TkaFDXrTUHdUOesb+ocxhYep4A+ooj3w77U0iYL54ZSJNk/JffhoRzG7pHQ+q3MkKfxo8TREdkREPEldMEs3wgAfLYlSA6MNdUvwmkaJYFLavsN+Py139buV240J+XkUP5/IUwc4dyX+bVO/lHcS8GmljHlQdDuI4V9f73DexZD/IVCKX8xT8tZRph4KDbMMLZmFwYwLLXbRL7v8SWPYHKMeqVIpKul9T8fMcLonsqumbEFOlh+/6jKmQXUI31hafj2MVbVvgExUP9pn1E1itXTEdCyL3VOr33sZenlXin6Nhe49cEIZBjQvmkiXQ9Ez3QBSThZeTI+z0oP2VGZXNflAqSk3GRZHbG8AM9ivkk6Uzvpijyp2wH44jkTTiiCbdavIqsVlAJNb/4LD32+pskuYzU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39850400004)(396003)(136003)(346002)(86362001)(4326008)(2616005)(316002)(1076003)(6916009)(5660300002)(426003)(33656002)(36756003)(9786002)(2906002)(186003)(478600001)(9746002)(38100700002)(8676002)(8936002)(66556008)(66476007)(26005)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?10XeRuutPU0HspKcRIRLT51LlxV4k9qw7RwIXVoLeV1WDmO+KiRj+yNF4qYb?=
 =?us-ascii?Q?eFdkVqVOeurhZ/9MYBwjSe9LVgL1gZbuay9hU5znpgRbXTXUsZ9e2BCXcBKJ?=
 =?us-ascii?Q?oHKAt4h3eZv5ngFneM911PiisW+d8cmBiSAu3plhu7U17Gd5ozxZsUGht91K?=
 =?us-ascii?Q?+ywkF7A7ghUSwb1V9NNTlNE9SuBDB7RCaKkMYxc83eJoRGdS6//SeD4oDGFA?=
 =?us-ascii?Q?wVq2fIvE1HHKHNaBpO6mzaFU+hUqtd1BozpDk1pySbE+6mD7qPmio7+oYUN7?=
 =?us-ascii?Q?i4yIfmDN2Qn65+nx618V35RaigduqPURwm0bzgRSUVJczrTUWlGTtAy38XmP?=
 =?us-ascii?Q?C/9qeBCXScTwXIKWbxunHAbX3NLrZKC90Rzmd/TQgM8Idg2pmok5G9re5Aop?=
 =?us-ascii?Q?VfA6OWF+f+7rVr9owaXLcW+wSOS/ULq+5gWoAAmmcx0uNW7yG8DyJdPMONI/?=
 =?us-ascii?Q?NsVGd8ayDZIy4Nb6vUIOlaC6Ix9ka/lNLEeOqlAkEKYGrbSE1zh+eNzVZzoR?=
 =?us-ascii?Q?Juv+6g3n/1PhWPRn99lH5cb4BfeXlekM0D4CEYI8siPAWXIAtrZuPXw7DaCR?=
 =?us-ascii?Q?FTSGd3KIIcd6hkNGbqgAM+OKuBNN96IOT1ayrSUqQEt0cs947gGxlMBFSoKZ?=
 =?us-ascii?Q?60VI3GS3lKqvP1RTkmdXmxQjN88Ej6p5R+qSskuiq4sR0WUknKseRSHbz4ch?=
 =?us-ascii?Q?GRTmsolcKfaWJx6nbmrpV3dzc4nFgycoehYzUf7UC4UEMZoKnfI+sExYvEvV?=
 =?us-ascii?Q?/uUvOdDttBjeQqJ92VJiLzmU4h8ijuQauhCd3RkNVWjjpSyNNQvBnq+S88Vm?=
 =?us-ascii?Q?jghAjnW9PDU5X5j6zfC6oJL6VxRw/jRXCE9LApgxwWJSLRIKjvzeQilPL0MA?=
 =?us-ascii?Q?Fkle7tvZRCScx1Px4dELOcsX0PWpULc02mB5pzTZMyFFKPvq3KBoXSOfxw1R?=
 =?us-ascii?Q?LtfTEeEw6tavsGSh6jRuzAA3ZrcgoU+vdo/U3FvsBj2GdkMI4fHRxK2xrIcx?=
 =?us-ascii?Q?rsCxRxOr7wAjh+zzaMaNKvcqgRfztujYsCGAW0nJlrZD+OiLrs/03zetZ8sE?=
 =?us-ascii?Q?1GcWcQB58ky/Yv7UGK/zq6kHFkUG7iUIbLB0+N713vW+RPMkp0pvc+XNAKdD?=
 =?us-ascii?Q?kSKinDz514or4U9NG6asxX/FVkTLvnjy9+CnyGe98zDYyNDVdd32CaJyQ/sn?=
 =?us-ascii?Q?/FlN7IDaOyUE+SYH3E4DFGAVsZm5DIqTxAMEenEp5iESoMcIH/9QOZLOErrg?=
 =?us-ascii?Q?WHsVEgs3oSzhqRVQTG4rdKQIqvOfYsJP1XLSt/SebpI+rGqQNlusrASRt8O4?=
 =?us-ascii?Q?TxGrMFSQtQH1jjrTyZJMVNrX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0860dd4f-b979-49b9-95a9-08d9305e7a5c
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 00:34:18.9534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fpO9G58ba1+3xKrRqK+BKo9nCQkIhHQSzeQoTMnyO2sMzBvnUNmj5JWOYJBf3BLr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5336
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021 at 06:22:45PM -0600, Alex Williamson wrote:
> On Tue, 15 Jun 2021 20:32:57 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Jun 15, 2021 at 05:22:42PM -0600, Alex Williamson wrote:
> > 
> > > > > b) alone is a functional, runtime difference.    
> > > > 
> > > > I would state b) differently:
> > > > 
> > > > b) Ignore the driver-override-only match entries in the ID table.  
> > > 
> > > No, pci_match_device() returns NULL if a match is found that is marked
> > > driver-override-only and a driver_override is not specified.  That's
> > > the same as no match at all.  We don't then go on to search past that
> > > match in the table, we fail to bind the driver.  That's effectively an
> > > anti-match when there's no driver_override on the device.  
> > 
> > anti-match isn't the intention. The deployment will have match tables
> > where all entires are either flags=0 or are driver-override-only.
> 
> I'd expect pci-pf-stub to have one of each, an any-id with
> override-only flag and the one device ID currently in the table with
> no flag.

Oh Hum. Actually I think this shows the anti-match behavior is
actually a bug.. :(

For something like pci_pf_stub_whitelist, if we add a
driver_override-only using the PCI any id then it effectively disables
new_id completely because the match search will alway find the
driver_override match first and stop searching. There is no chance to
see things new_id adds.

We have to fix this patch so flags isn't an anti-match to make it work
without user regression.

Jason
