Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0002A49C95E
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 13:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241140AbiAZMOv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 07:14:51 -0500
Received: from mail-dm6nam08on2055.outbound.protection.outlook.com ([40.107.102.55]:24577
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241137AbiAZMOu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 07:14:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WwiZ2h4haLtHnEGDP022SOQSi4sW2R/bvLNz9sbZT1slKL3TXUfFZiVBTzr73ACdcQ7060eztE2EzHiDZY0gyNDAjFA2/G1tbiE8RwQ9Hy/UOPAkDk5H4rzNXXPyCH2qN77juPSBkfB3eS2jwPpSpH4c16muv2jdGdMvSuggjql42tqTKtcKNCyFGAg8mPP+FPJjyh6+8m660vU6rNgZFfcV//RjHT5IPzx1TdChKCBYhZNv92gBQWGGflyajrf0/1fe/ifQzV9ZTMILyVZKfUBUYkaG4r1pUgTx4vRortqAKWijRI6n1Zlr3zO1qz/f7JqHVksZkiAkEMDrcERAYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fw2pLIkerqUB0GoGXRtMC3ek2MZpB4sNlBY6cL2ayRs=;
 b=n03Ddbn/6PJEKRuEp+AOWSN5AQAX6wDdkzb7FM/7VXRtIceRoOBerniReaYZhku186zCIxxyTNDBTLSEgYx4AfQ6Pp05/PFpXO+seqq91qA7VvUeuW54M5ETDxR99tGjTZy4krrqzeaqPff1M1RibD2Pb/CFGf3K/Ho8pn6qL97Bm3rfCChmXjYgtg46hFz3+K41FPDABAecb7HSHqCvwjN52kqE+urO+LQhEOus5ZLUwZ0Zt2Cw6mBdZFvMi+336CFaix6qPd2rdvQNFvWaGvqG6GFaM50Ckvi01DwxwSfO56yIZ8gAwrQbYmKDYsQCNnTZvqg7GlUY9uL9QkVw0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fw2pLIkerqUB0GoGXRtMC3ek2MZpB4sNlBY6cL2ayRs=;
 b=RRr0MXFsDfXX48zOuc2K3Bmkg95zphm44D141A6Ff0zcNiYI/OZmGoJ2kSdztr3w2V+S7xW89f8BcTuiRGiH4JuMVdE4JT/nka+ONZpcWPGOdRf3ZjKgG3cV8cemaCCDCrt32C7/TFBPPcg+vPBFRy5pL/PCcZxASJoMavuHLyrQX1Osy5bxrkoA9Yoz6qqGWL2p95wWXS+OCRxjFc4sBrIJWdnxteUkELqi4nZH0rETdE1KG6FvVUT+nKJhrHJhmgNlFo04bpfoESXS9b1StSgbMatXKZGKDp8WmoeyyogSNaK0z91Voyv8BArhbXxS1W3S3uXHNooHFWcI+Ayj8Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB2944.namprd12.prod.outlook.com (2603:10b6:208:ae::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.13; Wed, 26 Jan
 2022 12:14:48 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4930.015; Wed, 26 Jan 2022
 12:14:49 +0000
Date:   Wed, 26 Jan 2022 08:14:47 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Message-ID: <20220126121447.GQ84788@nvidia.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
 <BN9PR11MB5276BD5DB1F51694501849568C5F9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220125131158.GJ84788@nvidia.com>
 <BN9PR11MB5276AFC1BDE4B4D9634947C28C209@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220126013258.GN84788@nvidia.com>
 <BN9PR11MB5276CC27EA06D32608E118648C209@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276CC27EA06D32608E118648C209@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0429.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::14) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b331982f-47d8-4e71-16ee-08d9e0c572c5
X-MS-TrafficTypeDiagnostic: MN2PR12MB2944:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB2944B08B51E9556CAA3A9938C2209@MN2PR12MB2944.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MtDM8W0D2MdmXmDL9QVZlMz6J12Ch6Uc5lbmD6xkkHLL09lTSL8Cje0ZL2DOIIdJaGR+zfXXSrPzFEWUc49ErsO8cYKxxcUeEkxaE+ncVV+P4b12LAMe1Kfi8DuZ9lr4RTF9Nyl+/FrlYra0ZVdvZkEMsRT+NxCB3cm0SOMbS6UcmL5MZ+yPNkGM54dVzY9gsUwfGhUxsfduTeju0Lh+GR6q43oV0Gtigi+CCvieQld/tzeF5Ujrzkjmg1zGXab8gIOARXZ6mrhRUwzf5NCxTG4BAZKTl9DSWzKrh6raMxyOpKUX+C7JFp/jEax+9PpgxGMw2uOmu0AF2Le2ttiDxtRQXNVDxZjijbmYB30HDWJ1orWjhsUvXSS/ZQOLAohq8fvDQYvUnPPJgTECzWvhKftDQQKNvZ6H9cWjmA1bHhzSbhfiktacmb5+ArMQVvr2N5Ijd3SEQoiiLXnlKzh+H53r6S3juocG8FQ04ZUheWRL68F6VUHV0HlS/RJf5Xwqvz0sxuvx+9q3aicV5+xaxVbA22Gq9HIXTK5LPOAhgjRZ1mWgfKPY5lq01OHNqbwIC7Q4HKgRKGvhNIQ3Atm+pa9InZXQG4tx6Mh8dXRlL6Sgtj0ajaD4zB6XNMt/Ywdp+Etw4QtJFW9Mkp845M98VQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(186003)(6916009)(33656002)(6512007)(83380400001)(2616005)(1076003)(2906002)(38100700002)(36756003)(8936002)(86362001)(5660300002)(6486002)(8676002)(107886003)(66476007)(316002)(66556008)(6506007)(508600001)(54906003)(4326008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mjIP3v8e87GYs2xzYcmFcbcF3WQWUMkS6vOiB27dp37wRQNjLT/jmnA+vpAY?=
 =?us-ascii?Q?wNdfF8nlogwLmjuOaW9qrkrtWTrFXA02LrmrmZrYjTYzkdeUSghunoZIvxIF?=
 =?us-ascii?Q?D9ne/IHyTD9jD0cMdgi+9BnaxO53Z+1rWXzthLEjXDj0/6KXO56SZFKuP5PM?=
 =?us-ascii?Q?qqaYIHqdP+mgxWcXKbNfNzs2ydDywEOcaY12wbgZRC/AOsO05+ix+v911keS?=
 =?us-ascii?Q?gLDemAdA4raDX9p0hK1gYUZSLRzKTqFYpFU0F3r2GB5rki46BGkBR+33oYf6?=
 =?us-ascii?Q?V0OCndxRcv9rmQ5/OiEn41ClRGqO6IaQr6X+Npn0oN67aJGt6EoRC07WFTBY?=
 =?us-ascii?Q?qBR/9z4ZkRs7iFS/8ncMpzQc6UE6x6USn4A8SfR1i361r/zhYeDVdCb22lju?=
 =?us-ascii?Q?NeatFf8T9w1fpiiRZIfb04bKnGNvgqhWE/m6OCktHuHNWvi0JM+Ugfuhpx+z?=
 =?us-ascii?Q?LCPD46T2NP9lA89HTEI0yHLd6zxZrL2gVLNWTMxk+BWWV2uPWkHdFMqJC4/x?=
 =?us-ascii?Q?8njzZdmDRGEHSJyKHAg1aCbJlXAQT09b3h6veRNisKoVzcOb4FSsv1eHMR6w?=
 =?us-ascii?Q?U0c4ft7HcMDnzTuqyeIGsnzB8fRMd4W1ViQESfo1oMIIZCwEUfkyRgIJbjQX?=
 =?us-ascii?Q?xKBpe6sNbFgLUklOIKLTMpCVssU1KEk0QgMCmfhEir1WzoLfTNde0OxOP4Eb?=
 =?us-ascii?Q?ssammEBMTXdt1onUeerd9bpzQQA3FMhjDtgTc4NQIjAuRTd8IBWNU7DfCCdg?=
 =?us-ascii?Q?ogr0IGamF5nT48iBkxp9zW3gJLMcspcZ3VkjcCFRkE+6YXDmQTAkhneetGC2?=
 =?us-ascii?Q?Tzz82mSo/XbFnUeJH1okQKZMkPi4yg+O2YG0h/1KIa+MDfYLfo5dV75cDe1S?=
 =?us-ascii?Q?4S2izPM/vqtjxgdlF8hGbtUDKjmHPf2a+AkYVSOOSGgaGMVOPkVB0L4SDUqq?=
 =?us-ascii?Q?oqWvIvCepLgdww1nC7G06o81J4LxhuuV/3sUWc3PPX3WT8mUKfo+B/YaGFxp?=
 =?us-ascii?Q?8+Vz1CnabfiLotKl8ztOfcWeTIZxgy0K1Sw7vDAbJ/ulliUxWsdEfib+M1rN?=
 =?us-ascii?Q?eJvA1poQ3pr5q/vKVygdPtO4f4s4xKEdYpE7WGCMLlmuEeaeIJhZNFFzrzBQ?=
 =?us-ascii?Q?c/+RribUr6W+xPD+fEvW9saSqQUw1gUjdDpDsH2hdAk1ZlDBwEXSC31031yI?=
 =?us-ascii?Q?6GSR600swP2ilF30rJtXqLva3MJGkh0NO35Lma/Kqe3qMhXmkaWv683xVEZ+?=
 =?us-ascii?Q?5zdnir0SD8590jUb+H2kSNi+q89wJcC+L7jXlQ9MbsIvHsJYdbRDzkPwNxVX?=
 =?us-ascii?Q?zbCS+Gflp3tUBfXDTlKi/XOpqq9rYOnRLauMK+DbMKI6NPQ+MDN4V/bDxYCM?=
 =?us-ascii?Q?ew1ZO0OwXTMzaZXwT03RE744DMmoZ8HMPOmvzWCH0LYkC9rnAi5PETNR9Pnm?=
 =?us-ascii?Q?nn3JxpTPOB8LI3DiJ2tDoeYy3gT//qJEDXiHLAJhUvsytvCrHcG+RLQgFcub?=
 =?us-ascii?Q?morQCluHKU/OYnFNfKpsBWyFnARYItZDkziFOmi5YCFxWNyV0Mof820QtT92?=
 =?us-ascii?Q?IPx6UpbJ34hIbE9dsHc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b331982f-47d8-4e71-16ee-08d9e0c572c5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 12:14:49.0208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gz/ibnDaX6KADz59YTk8VV19PlYsRP/dWEGgrWfLN3ciXZniIuQJMnXYJP9O+IHr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2944
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 26, 2022 at 01:49:09AM +0000, Tian, Kevin wrote:

> > As STOP_PRI can be defined as halting any new PRIs and always return
> > immediately.
> 
> The problem is that on such devices PRIs are continuously triggered
> when the driver tries to drain the in-fly requests to enter STOP_P2P
> or STOP_COPY. If we simply halt any new PRIs in STOP_PRI, it
> essentially implies no migration support for such device.
 
So what can this HW even do? It can't immediately stop and disable its
queues?

Are you sure it can support migration?
 
> > STOP_P2P can hang if PRI's are open
> 
> In earlier discussions we agreed on a timeout mechanism to avoid such
> hang issue.

It is very ugly, ideally I'd prefer the userspace to handle the
timeout policy..

> > with the base feature set anyhow, as they can not support a RUNNING ->
> > STOP_COPY transition without, minimally, completing all the open
> > vPRIs. As VMMs implementing the base protocol should stop the vCPU and
> > then move the device to STOP_COPY, it is inherently incompatible with
> > what you are proposing.
> 
> My understanding is that STOP_P2P is entered before stopping vCPU.
> If that state can be extended for STOP_DMA, then it's compatible.

Well, it hasn't been coded yet, but this isn't strictly required to
achieve its purpose..

Jason
