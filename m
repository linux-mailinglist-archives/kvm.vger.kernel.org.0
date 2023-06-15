Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1E6731CC7
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 17:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344597AbjFOPeU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 11:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241727AbjFOPeS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 11:34:18 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB11295D;
        Thu, 15 Jun 2023 08:34:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oR8vbyopcEc/YVFTEJ7jYGie4g3p5OtH9YIU557znb29akM71DFgqObI8I5UHMxff+AORmodfk08GJBk+kQ3cxHL0ePj7PuRDF0igk9AeIhwbgYu4lFBAUxP9VwCLV2jjY/K6buJyubvgob7aH3XS2q2y3hi0oLTP2uUbgOIq/9Y7NqlPhKoNT/nLwgDy4MpVeeFEslu8oYNvCc4aobouQ7U5VUFIdL+cykuQM9qgGDblA9WkQGlqxLkNAt2CwRvOB2q3OoAvXtNwze7VjXO5qRXTsDhTuSTRaqpYeAU6bJpDTlQCGSmkrpiEFFBZQKyhmpwM3iDCnjdvR1T5ATaRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=17lc7gb0gKtNIMZQz3E2esJYQLRUEgI12KEVxt4Rky0=;
 b=XYyPTIuF6RsUjYcRQxpVoI2wskDpGog5zFvJG+bDwdO4YskqZ2nrI2RiorArJLV/n3YyqjGQIalQ2Dczj1CdrlgKYMTBzlX/94kTsVjYw8yZNVYINP6lARePNiNXN1x2vHLGY+8EKRt8j/kczhrwKjpo1YiznJ5DQZirAv+qE6abYPDKyT5ZWeyGdYUvLGPRBG9Cvm25C/I3aZ9QupHhAFXBS5v09rdhyNU+umJn6QOKhWzMigPxrMmDPh829//28t8WXKVFZZmthQ/CWB38UDGOUtgjCveSntx8ttLQBRoqwi0mM0Cv3KXkoGdZjYpa64La1HQIMZ7VHMlW+aruUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=17lc7gb0gKtNIMZQz3E2esJYQLRUEgI12KEVxt4Rky0=;
 b=EIYkTfL4jszwf2apjzeTK9l5fFy4WpyJECBG70T0D5TCPYEdvtC3h1S3h7BobntY22D9r5o+HYxTEQFFYYpREn4ctrovoHqpPr5Q0jIq0cKJJy5RuN4fJyGlV2133Cr0kMbc5b6bieE4sao1y013whkCKrhGbHq2D/NVy7PXcos=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by DS7PR12MB6357.namprd12.prod.outlook.com (2603:10b6:8:96::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Thu, 15 Jun
 2023 15:34:14 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::a2ee:7100:47ad:1476]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::a2ee:7100:47ad:1476%4]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 15:34:14 +0000
Date:   Thu, 15 Jun 2023 10:34:09 -0500
From:   John Allen <john.allen@amd.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, weijiang.yang@intel.com,
        rick.p.edgecombe@intel.com, seanjc@google.com, x86@kernel.org,
        thomas.lendacky@amd.com
Subject: Re: [RFC PATCH v2] x86/sev-es: Include XSS value in GHCB CPUID
 request
Message-ID: <ZIsvcTB4w3Hyv4rk@johallen-workstation>
References: <20230524155619.415961-1-john.allen@amd.com>
 <20230615115255.GBZIr7l2XNKau16ayl@fat_crate.local>
 <ZIss1TJ3ra+dZKOg@johallen-workstation.lan>
 <20230615153051.GDZIsuq0qx2GQnO3jV@fat_crate.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615153051.GDZIsuq0qx2GQnO3jV@fat_crate.local>
X-ClientProxiedBy: BN9PR03CA0167.namprd03.prod.outlook.com
 (2603:10b6:408:f4::22) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|DS7PR12MB6357:EE_
X-MS-Office365-Filtering-Correlation-Id: aa29987c-2837-4941-5a73-08db6db5f984
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d1pJpu3bhThXSOzOLrg9D4XbegKDJviTojS9YXLbaZkSxsJErTY1CN2LD1Hgh2Kt06JuNI4jcKFaeewpZbeqMc9dhf+YOZpGCxdy81N+cS1yLCT5qg8NTeCcC2AvShQM70nCadJxEv3cE6cXD10MaWg3a/HUQiiC1XMBkWWClFk+fqg9tYijaDLqrZrpQX5a27S8Fx3JHlgmWVmzbg9xg51pxoLsYCWL+kauX+joPM7h2MWavBEFCfHcureISvxm4S5zeh6ASVKaSzZtV2hzxkmq0FepnS2YxJeiGEa3RHtEMtM2REFR6RTwQvcshZYxWuOfNAfdlP4rlR7SGI209neoZFLI8Nhnf0qVJMjnIsOFuHevam67t3bBxY+iz79rpWBCbBciBh4k/Qn1Hkdtl8TSHfYvb6vtROxpwOkRO39al8xXhC3X1YXYKpk8B/YZyDF1R591HFR0MRxpTeEqo3+HLfPTrSzpXBymlVF3Q0C2QidwPnDi7h1azP/to5+JYUxRNc3XHU+EP3dDpoLmUCbMOZgbXIFpvRVQFJBMB5vMrZDThFsfSlUnYRe0OXTc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(451199021)(6486002)(316002)(41300700001)(2906002)(9686003)(6506007)(86362001)(186003)(4744005)(26005)(33716001)(44832011)(6512007)(38100700002)(5660300002)(8936002)(66946007)(8676002)(66476007)(478600001)(6666004)(4326008)(66556008)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dCYu6Cy8rWOmJOco+lF/Dr6PYKTmSAw8ZfyORB4J/ZQ0LyizV5uvgyGruW8N?=
 =?us-ascii?Q?+30mpB47+HbEsYCSgO4WyVmc0UiJc07LQsTCoPerPZOJl/Y3QIOtNTOEZplY?=
 =?us-ascii?Q?AkAv9OI6EN7mwz6UryOuwh6DYEc9P1HZ1VSSa4ikTR1qeFcmiP75wF2A3Xvh?=
 =?us-ascii?Q?8uzELZAGvfV61qRQOpxW39mqZFDl7jfm3eZyT0mI+3o5s7GQx5I2aMpphAQP?=
 =?us-ascii?Q?HY7WJCbvcHmYsgJ9o3z09YjGdbJALqJ+4K7SrZ/J4diF05qiwgjloDQNszR+?=
 =?us-ascii?Q?WNaYXoLIqm9w2LvkVj3TZVEHtsPqrsPyXaEBOqsjsBXnnBJMl/rm2yfzdBCx?=
 =?us-ascii?Q?+P7MQ/PF6uYx+aEUSte0tzqHQ8rjlNu3e/px5FrJUi43tuVDU/SCBl8vnYD6?=
 =?us-ascii?Q?SL4x9TAn5RLtfNC+uTUNCCYS7x3mQ737NNxPyemgmtQpCkitytCgnDDoXZci?=
 =?us-ascii?Q?oh9MMwOPsditsZd/RKNPGE5nsM3ZGs9ElTEcf7gpGj1s1WV/1HPnLXgpSJyT?=
 =?us-ascii?Q?Eegjd1vByLORvmMvkNZHmWn6bERPVkxL/zGjALvp7y99UeTYZYPfZUzNrPhl?=
 =?us-ascii?Q?hOfATTpdlRAurkCw/Y/vtPCpUl92DeEmy8hE9RL6WprsoalK3QX8yaNU7jFr?=
 =?us-ascii?Q?oscxe+mVhPp7zbHfSvdBfv8BhNRO7RgxTVA3aF5V1k+LBJeM67W29XhmXiwM?=
 =?us-ascii?Q?4x71VLFR8LmyE666ncxpwni3cil/0qinVdYdJgO9vdiofaeiAHqdy5KGVn1k?=
 =?us-ascii?Q?oL5NToWqOZkrVdmDBU+eXkbO3Oi4j20MEDN8iwBVROdjSIX7MACsAtYhOV+b?=
 =?us-ascii?Q?tx+QGPdlSkI+vPKyYPVZu2TFrZxzkZsYIsIAkqu5XdVCFLcvnOL4BDm60fbd?=
 =?us-ascii?Q?0k/N06bj/NKzBSdVEVrYdKduzzy6nnnpXFP7vqG1i2KM6946mLjXOwWPQ+AN?=
 =?us-ascii?Q?jtAc3O6PAB0hXLfwkFr7Uo7nGQ+trXm6Jlv1YU3dlmYCzDTNvmpmr0mH+/tY?=
 =?us-ascii?Q?HNjxMZ39UATR7UF/xRVuJCQNbKYjeDvaoNjVMdlZFgR30n+5e7v/Majs5VX2?=
 =?us-ascii?Q?9pguvvacbbNxOtEQGGOujPdMJIxvegcfKH/Qu+6wjjMoAtm5SzmOGKxUrrGU?=
 =?us-ascii?Q?Z5uogTiq2ZBjB57RNzUBXW2CzWnv3H58yBr6UlEX0chCRLxBd15M0wYqbNGE?=
 =?us-ascii?Q?ZGWMxp5HPxmUFl4NE50nk+7TXRYpM/VJdult2NVYKODL30mvQkhh9JJEVcfX?=
 =?us-ascii?Q?6W1ABifNKU88eRbjNHIu4oXRM2/cDjQ21lxWCmdBC38LEy8ZBqX648o2+GLU?=
 =?us-ascii?Q?iSxKlETGQoxHKE8zNe1bLgwKDqV/J7QIL8oQGgBqem9lb665Xe75rJD6g4ME?=
 =?us-ascii?Q?K/H4a08x21LrbF2SiK47z4aR39LeHIBs49/sFHtDt6koBrAczdBOmAZwUYLo?=
 =?us-ascii?Q?WEuYiRVzmqnUam0lK49QJXsL/jPPEJgCxWGk6+yJQsQ+173fmvbL/MjZbjjc?=
 =?us-ascii?Q?r0Iv0mk/3tg91cjQsI4KJMXunHkIK/jYg+j2EteWK7b7SVOSctVBMC4ePLSa?=
 =?us-ascii?Q?W21Cb3WKdKAMotcIy1VV0Zv6rWFFXVtfdRgObXje?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa29987c-2837-4941-5a73-08db6db5f984
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 15:34:14.6826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LZPrOh1phNswBCYngDNRE8py1fsDud0l5HyfuYPUtpuQNVYa68FB1PuL7JPW0cqTjw0NYxSYFTfFOx+cE+yOpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6357
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 15, 2023 at 05:30:51PM +0200, Borislav Petkov wrote:
> On Thu, Jun 15, 2023 at 10:23:01AM -0500, John Allen wrote:
> > How would you advise that I handle this entanglement in the next
> > series?
> 
> Send the *whole* and complete set to both maintainers - KVM and tip
> - and they'll decide how to do the patch tetris.

Thanks Boris. Sounds good to me.

Thanks,
John
