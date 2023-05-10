Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 625916FE4E5
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 22:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbjEJUPf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 16:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjEJUPe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 16:15:34 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2063.outbound.protection.outlook.com [40.107.101.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA56C173C;
        Wed, 10 May 2023 13:15:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y+MoYbePaVDas495hrGd0R/j56cHe54Be4/0bAT4Kj4KNFTLdUzt6qSbogHnfAi8k8+my5obRjjlcXMyVyGDvpBE1tvO60kwWPrB8DhdpcCVnylkQgVO8NMQgOm3TTHRCYzEiMZfSy7+fN+AudKjF0UVanIF8jw0JciMx8iZ8v6RSEcFhobyeyWq4q3KDpJOkWvphU04zYyNExvwXG00+71qVQa0qfiJ9fk2v2UhjD/bNcaVvw5cTN5KRmDd8IaK8Kp5K2IslhmbpAxjLDNyOX9Z0SGymDK1EWiH8xkG6buQY9GMWVGqDSrm07rYC+g8hxNqOwkr82NRrJ+PKpHzPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5QB1Tz46KLEMzmmQmOqxbo1G58ziZyYx1FlLdS+q+O4=;
 b=QiadJ9zvkoqX4SKSeBOZQo/1BwiytiGcD8ktUAhrKvwBaL6jh4oalaqo+vSNpel9tYgC8qDWGkgr7jjlTyHUsJ7KyOyFkaON6idqHptyUXyCi7EHPs6WM1NqVTPWIqKHa3qwtKtyGLZ6xLaBh8wf5+JefEX+4Ls1AUNWk10AIoVUPoTr0JhzFJFyXLP3qs+36bNW1JrVEeQjQASrak1KCIb1tnbL2nLIi14ewXQHdL7FVCGXa5WEVtB6pCgrdCaZ39CImJ13KL8siJhVBi1Yvq08FDbJTIy/MeSGd0ZYT9YvibYtJQYrP2+TM8CARWyzdVzq8qH636ntoHJbVl5xKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5QB1Tz46KLEMzmmQmOqxbo1G58ziZyYx1FlLdS+q+O4=;
 b=hFZrUgCKwcH2WRrp2Jlxo78DZt9FVtH0sdp4ReG7boJ1moiAfR5cG9hFPW4FnmHqyZCCSaJGbAzbXGadHU2nmRR1BEThFKy+iLsguoeu3FicXe2a1EUOlU5gX/ZB0Vm2ujkoTWoOtrVlmVEpJjG3+QvnQB/RztBTYouyYZHCZ3rFZFABFlBObhSBLMXzOXn2GQoYnfW2Xt9hVmD+tff4lWmkjQUzvHOFbciXiX8Kn6ENbUsm3rgFCt2tVmMwztSRw2Q7HaZ0gtB+TGO6YzdGAKiB0BIoNzZMS285Kgke3uZsp1ngSxZIzANcjztnFosBh56PiR0b1LHr646Y4Zvlng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA0PR12MB7577.namprd12.prod.outlook.com (2603:10b6:208:43e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Wed, 10 May
 2023 20:15:29 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6363.032; Wed, 10 May 2023
 20:15:29 +0000
Date:   Wed, 10 May 2023 17:15:26 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: Re: vPASID capability for VF
Message-ID: <ZFv7XjRYXIsDT1uq@nvidia.com>
References: <BN9PR11MB52764BE569672A02FE2A8CCA8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230510112449.4d766f6f.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510112449.4d766f6f.alex.williamson@redhat.com>
X-ClientProxiedBy: MW4PR02CA0005.namprd02.prod.outlook.com
 (2603:10b6:303:16d::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA0PR12MB7577:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f7cdaae-bac8-43d5-a316-08db51934ca6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vgsVZh455vOknG9IeQNtyMa2Cu2Uiqoje6U+42HXAjEsX/UBwZ4r2dZC97Z4RaKECxSY9LfDtkiSmVy6Ia8bEfuB2j+xUUmMYbz3DlyPMwvxPfhsPZ2VILFhKKMrpZY8cPTNRMM6CoZaFmYXSepC9A8SKfCQHzo8RTwvqcmlz/slm73xvnw4KOfsS/Pod0lhYX7WpOWM4+MJW8i6bJZEiN5FXPQFfKD2IZNaDvA5zuUoOUsE7j2wac7r6/EiWMLpRjZ7UTi11VYRV7Sl7RJAzOe8+FC5v0XeLhFDg4zajpnaRPEhgOrrXm/HWKkaf3LDNYtegkRof+0SxZkkxtvRF3gjEbp1Wwkhxkw5dTWfAceKecx3JQuxnjpxgtmuxYRQ7TgOcsm7aC8wr/tSImOxxTVmgFAYglXNV7PD+vT7iLWe+1VQ824QxvYnKDHUkSsshlQPKlg86WJt3LEjts29mB11J2nu/m/eNj6kDs4E5xU/Q36sirCGqCmAxlqDmRh/jmd1nKSbCjEsZYI2No4ci20o/1PV3DrF+7c+QTd453zC6hvFJXvVvuv3Lg4us5tLzAoQrWxaLjsA6zOHUWliIDWyYEdd4RaES+2aaLWsoqM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(136003)(396003)(346002)(366004)(451199021)(186003)(2616005)(2906002)(4744005)(3480700007)(36756003)(38100700002)(86362001)(6486002)(8676002)(8936002)(316002)(6666004)(41300700001)(5660300002)(478600001)(54906003)(4326008)(6916009)(66556008)(66946007)(66476007)(26005)(6512007)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U596+cDR3JVxSd3wUzW/AA6DS7ne8rlVu+cq7VeZlX/8s+4o+57UsbBdQVsM?=
 =?us-ascii?Q?M0co/9MDHpnbPdeobGEAmjpaBisNk1A2Z5/SwIzmqrY3EO3VBGES/E+anfwm?=
 =?us-ascii?Q?IFNzDbJvd1a185Z8mcABoie4UJsAK3oVt6StWgUWT0qgU55NC3jtSDRR4dRK?=
 =?us-ascii?Q?7BAUI43UtrbRCBjmjQIW6KPqQVnMGvlbgXVDmvsDkvaRyBltC/azn5TxZP7x?=
 =?us-ascii?Q?jqom2djaddtSSaAqhthbAUefDB7i33COkQ/bCVta6FeAAj8+UC/lPWtoJ4o/?=
 =?us-ascii?Q?pNrA5sURLI1rSEuCzmCrXJKN3NEBMS+EAnMia+tYykmXkaFU4BlVJ5abT2xT?=
 =?us-ascii?Q?M2qBNizmoHBBkJM3MmMyKG2KI+glBTzz/USaRaTof6aCAD68v4mUEBIpdhtu?=
 =?us-ascii?Q?OX8n1WKTvrivMWd9kpBG8o3aumL0ODAANwFjMnDRtlSuUfYVg+4PV4OeaeUH?=
 =?us-ascii?Q?TrWU9xwbB/zaZavK93gbFeSLh6bRZpsHH6eHT8R3yf+XFjguuN+s9ic81dBw?=
 =?us-ascii?Q?eCbd1BS5R5YjeMWMnYesQvdMpObNGZ/j3J+WYz9oloYYxzWKV1HL2xg0n0s7?=
 =?us-ascii?Q?9K6vlC9+inmIfvGMy285wjUI6jFRZSrPCk+5ZLI+8NRKuHY4elARsbuuLT5M?=
 =?us-ascii?Q?afCdbuGb6h+ml0jMni8L1Ph7wRr2MoToYHGExtxOYvnOfzsTgOE6pGXfEMc2?=
 =?us-ascii?Q?ZnR2+HLJTo/g2Y1EIBPY+aW3y3WQprUvgSi1s6s77nVSdtsLxjX7+Av5ICFb?=
 =?us-ascii?Q?taPsrxRfCgpwIHBd2hVpw6kyqg5lHXFFKzVAh8sP/+qHX/LqbMIewbFrwMwE?=
 =?us-ascii?Q?lraGvamw2lq9/dVolVUsWN5VtLigExVIPOnZSsUL6//7zHOUD3z4Bc5ouvCp?=
 =?us-ascii?Q?4T6gxMYUiVdNRk6BXr5KkP5m94Swy3WnAXrI/UYZLIJz/KPlyJy4AUzOANSx?=
 =?us-ascii?Q?skHhzPaoUHGKY5JmTbOtVJ3U9d2ZlerSe/R3f5SI0L8XsFf9MmFffkoD+oA5?=
 =?us-ascii?Q?7v0uRwlT/eQl38UNk2y34AWks/Hr+bFjY2AXCr31b/o1NQf5g6eXF03GYmM+?=
 =?us-ascii?Q?hibxmmo+PR/dpmjHlIKpdct0t7GeQTWpko5n3mlJRwmxlEYPyVb5aUOzIgdC?=
 =?us-ascii?Q?XE+yIsUg8sGj15Ki1O5/i0c/9VKyab4D0hLrN6EMQmBprsVaEFskLLzDygRh?=
 =?us-ascii?Q?dTbF/xBvCaGlYWsolOc+i1OSOkJy0lR8xX5EdjTgG5IlKoFIiM7rlgejMxN0?=
 =?us-ascii?Q?QSjPdgZ0Ev6uxj5GGjmBdaNAGVjmmPjSvjV4t3VTHWttTxXBOzoT6fYfPxqx?=
 =?us-ascii?Q?TQ7Ro4lNzXhAeUE5yrPgdAj9GvUlubU/0IGIwcD3oWmSr9zC+gvRPgwEU8g+?=
 =?us-ascii?Q?1nZdWL/eBhzBqZUPRjWdXiF6VREc8YI2IhBK6bjEMK/CZuGvMytnalOEtQb1?=
 =?us-ascii?Q?VJwXaaMqMjDYCLbrm2RnokUls5X7n8Hf5Hs2z6/khaUEEHRZRwyZaMLkY/tj?=
 =?us-ascii?Q?1jsth7mB3s0ET1sfbB6Lupc4mqZnAdcJD6Ond9dR8LVjoHnQc4qtWoAtX8/D?=
 =?us-ascii?Q?QTjqifyerEt8X7Dfanw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f7cdaae-bac8-43d5-a316-08db51934ca6
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 20:15:29.2973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I2ZNWtFeoqfBkr2CjdBXiC8HVupALKxdGigdkdyBaoPdj6vr4/0eaFeN0NncLBo6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7577
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

On Wed, May 10, 2023 at 11:24:49AM -0600, Alex Williamson wrote:

> Is this capability really intended to be mirrored by software to the
> VFs or do we need to expose the PASID capabilities of the VF in some
> other way?  Thanks,

The VM definately needs this information, but not really the control
parts..

If we don't put it in the config space then we need to feed it through
ACPI which would solve both problems I suppose.

Jason
