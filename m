Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A0E52A10B
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 14:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345698AbiEQMBk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 08:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346352AbiEQMBX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 08:01:23 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2062.outbound.protection.outlook.com [40.107.236.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7272403DE;
        Tue, 17 May 2022 05:01:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=epX0ArgfEn8Jv3DapfO6lzXI1W9Omq7e7704YZ/zXRxN5De5l4iZyBXL2mG/Zl7Kcwpljdp3DUXR07avCsC+CjAK445heylYzzMg2cou45AcXHfTFov2xhHSGTSo+15JmBoUML3lrwruw96NFKvt4dAp2N30vbc4iFcUOLdeOG6cXkLV6xfewaylwptv9wdKpbGtT19vD8iWR2OOqYUdrvgoSAHr2cbyBjVpD99yZJsRns87k1RNkurXF6nB2eb4gxJgBNbZLVCU3iBLEMElMQ92xHofB+gQrBSfdOOg41FXtQMkdCW05QDxEfI2tXdbU6O0sGjABMtEKXcv097TIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e15/Vfv+/l+o17HK9zvaOr7RLLrFBjxHQSAXcpN6JjQ=;
 b=VfRf3PU7OpXl3bl8qZwO36xcY4U8fCqpVqPgwp8hKtDzOhvl6wAfsXtvcmP9U+WaDKu7O38aOBWHPZNIyM+RnV4edG1nDO/R2IsRjZM5rhBkP4O739UvIfUVW2yugJ9f66np3xADlByzqtyhxGxzioEIOPUmSrxip6u8O09mzxJteQl4TKR2R7UxoaMcBF7Cgu/C9jbpFbqrkHoWsCCtVt3w3CqC9KGI+w18FFRjz018vMFlvnpNnogbFnW+XrgQ2zKZ+vxxKBRo7IxRrcknZQ+v98c17A2ZBfFk7wYKbZPyVueOWZ2GBXJFshH5nAm4uTeCKN9NLcT/oUs/tZ4zRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e15/Vfv+/l+o17HK9zvaOr7RLLrFBjxHQSAXcpN6JjQ=;
 b=OMZ4s6VMoIp6SrzqYAk490sSYC8BGpykiz4hX8dOTB2FBC9KU4kxkWZTRNudqPC7EmHMnboO/c6vzR7OcxewjcE4O3aXUfBj5ejldya8kcBF686SX402TesNwjnZWemxnEbPQ4vXJBGZMoSXiek4k39rBUX48KOf59qO/PgStOCOUl4TuHAm6llQ8DwQ5U/OFxOSsc3R+BmassQGsTQNxwHD2NpY+DWJjcanOZubCoAS7W3qmSCaTmrN/jLbitxRIaZQTTA6APkOjgw+Ou3LkxqSSY7LfX/mu3jVbEG1p2dK7nCXfan8BgxsSpO64HaGNngUwvag81T66sCjqjPz2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BYAPR12MB2693.namprd12.prod.outlook.com (2603:10b6:a03:6a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 12:01:12 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 12:01:12 +0000
Date:   Tue, 17 May 2022 09:01:10 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v7 17/22] vfio-pci/zdev: add open/close device hooks
Message-ID: <20220517120110.GS1343366@nvidia.com>
References: <20220513191509.272897-1-mjrosato@linux.ibm.com>
 <20220513191509.272897-18-mjrosato@linux.ibm.com>
 <20220516172734.GE1343366@nvidia.com>
 <YoM+3z6+9yMeLMJn@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoM+3z6+9yMeLMJn@infradead.org>
X-ClientProxiedBy: BL1P223CA0007.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::12) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d4c7c51-988e-4b7e-3e08-08da37fcefdc
X-MS-TrafficTypeDiagnostic: BYAPR12MB2693:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB26937098EBEBCFA0EC689E0BC2CE9@BYAPR12MB2693.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yzQ2a8wvRTgH79hRB/lClggrVlDuhnYQZuxmeWsNebFUyN/GEWIyI8lJV01rKarR8V5QmLaYs/PE5P8ScGwzeHcmnkpHBiUaHcjiccIVr3wGiJh9tyohjIDiAIzvATfaD8yIuZ/CcPceuJZdJcB3Wi4I7WLzby7TvACZtSyakKlpaHXNUKDl7ITL/fq88ddiOvWXIXP0YKbD0OsfZow6XQDnXXbXuFpjdplvxI+B8W0unUajSCbD0aAQO6JT6hVG0aFHbqJeYyGRVJi9lLJkV8OypMYzoKuMc0WAQC3lMbP+cVfExm+RIjEIZfLL1j4I5EgXxn+uIGM/HdlbJ3FtvlWoTO0KCO4yYvPsNwHaizs0yXO+4GZNDoXPzY09bR6pmXriTZV2U7cycoSlfZI4s8aUL0HWrBo1lcLs/2GMtEKOvE/S2BTk8wAOKXKjtrt+Zb29qoB8xrg/XsWbxeUzPvvsBmd82qE6N8x1aSBd71GSkTmh64MnsFPOdOOzl1Itj99AThRNPaeSbnYh42Enhh4f4xFwqGbsu/MQZUBLfzLwMC1R8AkPRgSxwtLNNPMbw1kuZpjAQvC2DgWb1XaHvJAztUNgYwdt605nRRtq/iDSTEOBHYMMsmjyicclafwyJWe261O1RYWyCsAH78dPUdPosURhiKbdIYEwPCfITgEkZvVpxBJYlIjKG+gWkWau0Mh1wwYOD5oXcDxTv2c8gHtoO/W1YG1FMjV+T2GzcUs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(66556008)(66476007)(6506007)(66946007)(4326008)(2906002)(38100700002)(33656002)(2616005)(83380400001)(7416002)(508600001)(6486002)(966005)(5660300002)(6916009)(6512007)(26005)(186003)(1076003)(36756003)(86362001)(316002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XbniLP5N1UU3Csb/HcpxhcCaC+BCdIzQGQ/b9iG/LStXoDD6Ws8CBzgzJZVr?=
 =?us-ascii?Q?MF6xEqKbULiDPp2lp6m3NA1UaQf5PcP1XbNFbG8YDZMj6ewQstyIOx9CLObY?=
 =?us-ascii?Q?BHHdcTMQkg1NbbSz2Th7uY523SFGP8CYAxAvIuRHW9Aw9WMz2hn9tbBIYQHQ?=
 =?us-ascii?Q?p7M72kgIV8UqjkK3K3rSBCjn/gYkJV3WKh0RxCOeNiOQjS4jhJPgECr1UJuz?=
 =?us-ascii?Q?o7GmiEZ7VpCp1o3/E8amfng4cdlE/+FyH5y+uAjdh8K5qwr/w6shUNmGyDFr?=
 =?us-ascii?Q?1R/PzENSXlNljNRn7Yuyy5FgqeqbBg82ESG96qvcUJplSAv9+Vras+UEWVBX?=
 =?us-ascii?Q?vx+rPmgKjuJaZQHLcvHkMlRalh3thjacXr7C4hzZxVQaiqyeSpVh3VmRT50C?=
 =?us-ascii?Q?5NvG+JTHSDRpwu2tAVKMRoV15QRQ6OvHkBNEDKxD4SPiTNcJxpAtvNeY19iJ?=
 =?us-ascii?Q?EXXJvTKc0CkVXcxczkHKOP6hoJ5iuLlUHp9aTheyxtJxFEqkNaWo0mIywiDN?=
 =?us-ascii?Q?1KboflvwrmYS3i4lnGuNXtzrvYt6pxVY1W/sYjNUp0ScbaiuuEc8ppcu8vog?=
 =?us-ascii?Q?as3aQXSNbjxn+H/lFVxpZPCvJWwOuuOoXa9gnSCIXtrko/cP6T7EOp7XPjMm?=
 =?us-ascii?Q?Z31A49h6xQw+g9KWi+M2WZVuXp0ZQuz2QJQC91p1ye7iYE6AuYqydWXEz1SH?=
 =?us-ascii?Q?GXTuP6CMWspKf48nt/nEbhUYs4o+4mq/RXwMLLvBmNSweIyfp9ef7YS45xLt?=
 =?us-ascii?Q?XJ9Wf66+IryauGoslc2u3FoYRd9sNG8hqxVZBymrNy2Z+tlFvnvui+MM0Ffs?=
 =?us-ascii?Q?AtDRV8JBqeFSE+Tm7sJ8jRtCUHh0XO9AM3BzCdqWCpaCzmXKGKwioHOZQjxR?=
 =?us-ascii?Q?NMJgMzZJDoXfmrqHSUQgHqouoOGrLsb5jf4pjCwcBIyAmviTjKFrTsfiEFIh?=
 =?us-ascii?Q?zk3PjmZnZQk3n9NQ20FJ+u4QFrVgGmmelhZRqTRdOM6y3rzBsG5PNUUQINl5?=
 =?us-ascii?Q?kRj8RVOU/ocdiWZczsK7MFUfqLx7KNX/ydYoFvkWo6Xc78K3+iUYK0UasHiB?=
 =?us-ascii?Q?TTMWX2deTzvuTxFrnJkkFvZn78ffbK2lyKHdAKLGGjRB9nZX+fRu7MCIyghX?=
 =?us-ascii?Q?gL65nS3qatjSBJ1h1dJn9R3YvxS+lHRckuIdHECYfCY7zptPPC1gCjgbr7YF?=
 =?us-ascii?Q?eu7aJSssl33KMztACjJw6vn4DsVOMOkVZ69MBK8eesYFlBPY248N48+K1tiH?=
 =?us-ascii?Q?guOZcm2A9UH3/o6dKx2EQbjBTtyYmZdab1F5YfJkP2Bj/ePxU00rY+u+019P?=
 =?us-ascii?Q?S98igaeCABqjGzsVjKwYl1cMhzlKB1ggOymxkp7g6IAjLfgYYg39cVK36jHc?=
 =?us-ascii?Q?vcUe/K12wJVGG7+aNY/9YgTXEitz+ws7x5aFhjsWKqCJ/QFfw+oqEHPAtitI?=
 =?us-ascii?Q?h/lhQF30pSV4XWtEaaqIODnW/N13TTcgnFyosu3d2S8gfdO63GA5JRpXMF/E?=
 =?us-ascii?Q?FQiivsSfeeY0TUxL/3EJkCk30J64YBrzOVtgBLXUCmXQIC0Yu0gDmBlJK0fX?=
 =?us-ascii?Q?US2kvobWnBvdqsfo7n0QlUYZhmegWV77a4anwXbdA6u/P1t/1km32icYaYEU?=
 =?us-ascii?Q?Og91UKwY/kJMB+qf6caOko13A9FrxUY3UsHnBzus1tzcdc5Q2YDXFuJy8eu8?=
 =?us-ascii?Q?BYj4exzHGrOwy8IWuZM3BS8/ZLuWiODDjBzRQ6n3eBVWAyhe5dzRCZ7EZztQ?=
 =?us-ascii?Q?sM05PkuZpA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d4c7c51-988e-4b7e-3e08-08da37fcefdc
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 12:01:12.3551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zlAH+dQ6v1nACd9T4mjuZs9sM9FZd910ygUETfYTPxVftOX/FOvOeWzuORQjY9th
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2693
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 16, 2022 at 11:21:19PM -0700, Christoph Hellwig wrote:
> On Mon, May 16, 2022 at 02:27:34PM -0300, Jason Gunthorpe wrote:
> > Normally you'd want to do what is kvm_s390_pci_register_kvm() here,
> > where a failure can be propogated but then you have a race condition
> > with the kvm.
> > 
> > Blech, maybe it is time to just fix this race condition permanently,
> > what do you think? (I didn't even compile it)
> 
> This is roughly were I was planning to get to, with one difference:
> I don't think we need or even want the VFIO_DEVICE_NEEDS_KVM flag.
> Instead just propagation ->kvm to the device whenever it is set and
> let drivers that have a hard requirements on it like gvt fail if it
> isn't there.

I did it so we didn't uselessly hold a ref on the kvm object, but
maybe that is not relevant.

> The other question is if we even need an extra reference per device,
> can't we hold the group reference until all devices are gone
> anyway?  That would remove the need to include kvm_host.h in the
> vfio code.

The device does now hold a reference on the group fd after this patch
series:

https://lore.kernel.org/r/0-v2-d035a1842d81+1bf-vfio_group_locking_jgg@nvidia.com

However the group does not hold a reference on the KVM, it has a
set/remove interface toward KVM and can have its group->kvm pointer
NULL'd via an ioctl at any time.

So, the semantic here is that the KVM is captured when the device FD
opens and then is immutable for the lifetime of that device FD even if
the group FD's KVM is reassigned or removed.

And I realize that it is all botched, this needs to check and respect
the open_count which requires nesting the locks..

Jason
