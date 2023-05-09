Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F676FD2C8
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 00:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjEIWnt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 18:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjEIWnr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 18:43:47 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2066.outbound.protection.outlook.com [40.107.93.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2E45276;
        Tue,  9 May 2023 15:43:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N6mH0ZJ9XCOOov/1TY+vqbwdDYXWvYiTuUbWK6oBwGPWSl0wPOaIHHxP7jHTZ8QpehHa8bM5IJiDH4HSWnP+FgnZoRUYbYXxjQsh4UvanZpvypD6lUlYWM1OfLu+Er+ugVb0rsACIX7ySzAj6Ucf36L7w4w0T7lyTqRyFhZEhSE3NlHVnRor+IfCfGzYhghXc87X6wCa+00M4mCdyV4j03j57wrzmIDiht0nByvvJGuizT3Wg9ZtTiRsCse5GDwqgioXIrlnXNvLvX92zKT52rt2/jkRD/n0TrPZg5AI7v65Ss0AtLMpIZLSeqKCB/KaOIGUqkaHP+rosJrIjRroIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tuCe2rg2aOu+63zaLDEIbiut7+6COLosQcWhLIKfWCY=;
 b=kP6v1WelI9vx6esJK6mkCF91R0U//pmgB3Hk2QjAcGj8gAVmxpz9uoKMbSSD3MnHniD4/JzjZbymJpj1Wvb7t44BuHS7/+zHyriQykQ3SphCpwhUN3urMb3ffxpoNCL1q8ITJG5Pf26Wr5pm2ASnHCIjlTEp9/0tcG55jq44JDKazuZP4c25wefJfLeVzNvsOZbOJkpeGikX4mD7XHIAErjW5fR383fuGI+SiNTVK7u9gQADKM7zAlRYmzaKU5PewFpGKdhrLVy8g/ptdpgNEeG2Q/PXJC4DVneYiX09CnN551gQldavP/j48W7pD92udOTWFmJpnD/jb7yxHtORzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tuCe2rg2aOu+63zaLDEIbiut7+6COLosQcWhLIKfWCY=;
 b=s9HtZmSv4ONA/z/6Eh4Is06YAIuhna7rsHPKhqoHp3YowZ0dolkf59++Sv4suREhXty8JoceMawUWvJlnPraE/dxBPv3xButMsnEtHxpKpDPR3PdzMNGCuf36jB454em251NAkD3JH2vR6gtkAW6xmoj1kvxFs3WMnGNoNYqHzGcWbwOFxuzaSkxsmNpwY3aozZOYBHrdrqvDF2EGVoJoazKHvN/oHoKtIZadqsv2e0XKTgmMUk9A5eW/2Ejf80IEFXohWoaHLjN6913cqkeGB9ZxWEwgjv/RH5MjfcbtEzIajAqvH5v6nCtKIVpfLp0WjHEGFYoSxiYHadvBJ+67w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA0PR12MB4495.namprd12.prod.outlook.com (2603:10b6:806:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Tue, 9 May
 2023 22:43:44 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6363.032; Tue, 9 May 2023
 22:43:44 +0000
Date:   Tue, 9 May 2023 19:43:41 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: Re: vPASID capability for VF
Message-ID: <ZFrMneCMKuCtu7JF@nvidia.com>
References: <BN9PR11MB52764BE569672A02FE2A8CCA8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52764BE569672A02FE2A8CCA8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MW4PR04CA0234.namprd04.prod.outlook.com
 (2603:10b6:303:87::29) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA0PR12MB4495:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b7ab7a6-876b-4a22-918c-08db50ded80d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bm+xm1JNyARjLtfZxnbgmRnc4o8uxHAPSw7ZlfK48HoLbCkQzki5j8AidDOJSjMqMi51fmJM1yMtXfro856LAgkuMHMi8W3SmotJH6hX0Tsu/sG+2/pt1LcmBPUj9X7z4nqwxJBKTzJnIKJKvUX6wNITXKwHcoFq+HYhJEuknmjudhYh87w82Q7gHQAp6lZEDmMfZCCCRqx0uSGN9LwUem01OyeN0BIlxHGLsULDQkEUobIg+TpzKPFnqbWg/qtkybvsJN9GJlZk5ybvS26ZwGahsSorExUCWRICJUVS7iPsgP1Ym9EO8Ba5lp8QGz3bGDOFYz7eTK7jA3fzO6brQcREypGZwRyYnaa2GXlZu/9yA0+b3TagAiWzfVGf6k6MNHz1hxZX1xbDi2vFqQGkQNR4gxd5DG7XzYlgOL7daIHgx0m70AgJkqBeH3JChlN7LKHjaDAGR0RXPNp4RwaPQVy/R49Ds1BqcRccwMok9L0+juAENC9hASXYjNvF9DSu8BFlpvp7utv8zT0S2wgMid/+r8bPQTydtGfilCyttNlsXK+zx764UZ6Yp3AT1SK+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199021)(4744005)(54906003)(8676002)(8936002)(41300700001)(316002)(478600001)(2906002)(6666004)(66476007)(5660300002)(6916009)(66556008)(66946007)(4326008)(6486002)(6512007)(6506007)(26005)(186003)(3480700007)(2616005)(36756003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FnOLKWzzCxBM6itAWtfaJ6QtlT/RsiqRBkPRSn/vvWdQZ7aQPlA9pUdQU13x?=
 =?us-ascii?Q?UqwcZ2zSD5iDukmCfdwLgiCk7mjWOGzT+JDPxTCGzDm8iXXPO6P/ZF3Cbb9C?=
 =?us-ascii?Q?V06w1EEd2Zu7V+wtLIM+dY8Cj2tlpQN7G7trHKOyAZM7ZSd0gnlL7q4fan5L?=
 =?us-ascii?Q?fMKrxkfw/T0/gMJnR7bGP6yQGbxz2TYRVW1TC97PEM+IcbllNxUFmXu5/EKR?=
 =?us-ascii?Q?8CPjC60Z/lNvOvjkYV31Z9JVbRFZZik0WbdeD5k+63MAhljHINPxXGRDBrSu?=
 =?us-ascii?Q?jGNwm959HJMoxOXCWDtQKZVnyG+bKiI0I9MEcIzMZmAAcajgXjrIc/dt061Z?=
 =?us-ascii?Q?26ICIXveJvbSHAQvv+jHLlPmqySLZKOGX3OslM2H7msbN/s4MtYnRkDojSU3?=
 =?us-ascii?Q?4SWuoqdbmxPsypP+b7pGPLxNm7TyaXRmyZiQkLXjNPx8ASBrFIXM5AyxgQqK?=
 =?us-ascii?Q?NU+LKLQ1cmZ7daPbvqp1iBDe2PPFHHVb9sMF3I0TCSZ0vlG6/bM4UsyfqA1S?=
 =?us-ascii?Q?HafVKQ0R1wDgURBoC6d7EjYnS+foHdNidrIIy3a7Pk5QeZ+O77+eoFYsOhgV?=
 =?us-ascii?Q?z2q9rZI0MRFwnwSq/4IIwziHfiiZYoUidJozpi3Li0Q/3TCHwXE1J1c90i5Y?=
 =?us-ascii?Q?BGDFaWoitq+qRS80gQJaI8bvFlMUSqEYGioX9cWNZENvJzdxhALku8FUQ8m3?=
 =?us-ascii?Q?P9+OTrOKtqL+p4lPlZ0rpOYwO7Pxr4OEtkQnnIuilJQpXVVB2tYJZ1CwH9uJ?=
 =?us-ascii?Q?oFoQaGkWsS4074csgmzwGZAa8MorHVZ0ohGWSl61oZXxbxB/59BFzZYYR1O6?=
 =?us-ascii?Q?/fULv1OuMfyfsP3yyZbhWdOdIfTGW05DnAfZqkq91NXMomLFS9LINMHqS4qf?=
 =?us-ascii?Q?A3sEbANpaGiNmpI/jy1nNbebQKXHFhu9sWqPkfKXrN/aXFFnKSv6RQ5EnCsJ?=
 =?us-ascii?Q?a3szMNNvWpvmabGebFh/yGdfYDObjfwL2NmGd1h/8+qO652mx5mjVvb8VB6n?=
 =?us-ascii?Q?nnVj358P3nbgrBnVGNp45TW93O6ItekZ3oWcQ5q+4qjZfuyHCmzpYeGDwL5n?=
 =?us-ascii?Q?qSZeb9mgg8fYtwZBjlKfQxwRQQaTkREp5EuABQk+WzJ7m2k9q0bIFnj8KI3d?=
 =?us-ascii?Q?e/BhgkLZlU3tbXtidr2Jle2hF1Nv0GC5UKyu8drkOMF7OW0iQXzw+zLvJtGD?=
 =?us-ascii?Q?zzO6sKrqoEvnEwaD7+l52OxrULliBj7KxfYC3W1XkjFRh2KZSnW3lnq2N+Hj?=
 =?us-ascii?Q?G5DqKQpG6xZzGAQw5w80oi/FPUfnX0RlfHJHeVi1BEiKfuLNMP8QtgD0tYpV?=
 =?us-ascii?Q?XVbyr8kPvP0ueA4T5/iEOdTOuYQ1lMNr0HAaRFQuPahipFWXIJ8kUOyq/r/P?=
 =?us-ascii?Q?6Sv0wqDkaBlEQRLR51FgvHtmPn/enpS18t0wIrUctXvX3Bv4fqdSHm+pwhJw?=
 =?us-ascii?Q?9C3eewIa1n4J1rZveEFGAWQ0TrIYlAgsG0p3qmprjogYIGIg/siXyizDr/gW?=
 =?us-ascii?Q?N/SUacX4tS3YTFumcvNdi28oul3620BjdQorONOUoYDYO9iI+NEkFYoh9sKc?=
 =?us-ascii?Q?7QuNqKsvwE/U5ncSvnc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b7ab7a6-876b-4a22-918c-08db50ded80d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 22:43:44.2554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: htTmKqK6+0gmTSVYo2CM8QOIDWB3CzTqA1CxFeP+PVngFJGx38v1EBmNTNR5Ed9H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4495
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

On Tue, May 09, 2023 at 08:34:53AM +0000, Tian, Kevin wrote:
> According to PCIe spec (7.8.9 PASID Extended Capability Structure):
> 
>   The PASID configuration of the single non-VF Function representing
>   the device is also used by all VFs in the device. A PF is permitted
>   to implement the PASID capability, but VFs must not implement it.
> 
> To enable PASID on VF then one open is where to locate the PASID
> capability in VF's vconfig space. vfio-pci doesn't know which offset
> may contain VF specific config registers. Finding such offset must
> come from a device specific knowledge.

Why? Can't vfio probe the cap tree and just find a gap to insert a new
cap? We already mangle the cap list, I'm not sure I see what
the problem is?

Jason
