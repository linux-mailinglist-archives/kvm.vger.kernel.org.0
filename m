Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B971B682F5C
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 15:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbjAaOen (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 09:34:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbjAaOel (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 09:34:41 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6946FE;
        Tue, 31 Jan 2023 06:34:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CiNbQ3M3qihoyw5atmk6uMT993TbXhAhT4aSFEMTNiY7oEao9J8iR2dKWCv8Zjnc9LtvGG0wZdFYa6UZsgrKWi1AM+SiOWt4SSs9R3Mq8kabzq5qhJDNTy8oh5mp3Bn9O6QehkdlLmK5a4WEV38nZ6H10BTVYxiulYDfrJF3z3f+XuQzWSnZj3Ih7X9Pt9wTrdI5wYEdTLpGqBx/GwO9u/IE981M86iJ8u7dOJmsnBgbS9qsRxLeVtrtayfdAt7SdxZZoc0rMd8o/DrHoRm653Fakb8pR8vXZz771pUKokFQ3HEeMPu1L1F8mv+fdJG1wWj+HXOtB63InTjfrv3bNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cun7hAgWQcETrPp51M+O76qP36WAN6kPyIwG/vlCrpk=;
 b=GJ2M/XyXFTY1d7s+G8pAh/Simi5PaL+NiRrnGs4sRz1hC5VgqoF+hyE5hrFe8KGE1a0RVLi/Hw8kL8PaIrmZDvBgOgP5HtvUX4vPb3cbCzhUfvRA+1xuGgFtmYWih9RBHZ90pprPo8+KUMAeSaam+FcWSNENQWJPD8/pRf2biWZM/Qr02oQfFIylCyXAmoaCW4SAlxhYcU9fQINP0AFbnjlzrufSjQhjR/xW5j+iDfEPYbXmVz99Rn2gylVm8ycVJ7etVd7p0PuiA0KKp1xd49USqALPaofDfDGd8sF3PI3Xxb5XVkL1wipptHEmrhdql4hU4UMnIP4C4qcjuZEJFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cun7hAgWQcETrPp51M+O76qP36WAN6kPyIwG/vlCrpk=;
 b=jVTnaeQdrYSf6M+n70QIX2wTVbADjCqp5tGICHn5CC5HnwPZ/mKs7TDYxlX5X1R2C1CKWSSe5KOUSSFMyvCmrInBnGDg0HLEz2sJDXAhayfoD2SC4byuhKTBi+H3ypv4jVHhLOD4P/IX0Oe0R/IAcB0F83m7TskSNMjf8M755LexiNzIWxsmGv/HO/D51wszs1mGE06xKU/b1OUYoJ7EJgEqDI59DqMfolpJ19sfuDLuDVvrDXUeimqtmVj7ol5cnFazecuBjI03kI6/dB1I0KBH3MGEgWlJoZp91UUsVkII5Wqf4NGgIaEB0dQ/FNZGcnVeOdUqM6XqV8RunSsFew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB6795.namprd12.prod.outlook.com (2603:10b6:510:1c6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Tue, 31 Jan
 2023 14:34:38 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 14:34:38 +0000
Date:   Tue, 31 Jan 2023 10:34:35 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Anthony Krowiak <akrowiak@linux.ibm.com>
Cc:     Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        pbonzini@redhat.com, mjrosato@linux.ibm.com, kevin.tian@intel.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, jjherne@linux.ibm.com,
        pasic@linux.ibm.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        seanjc@google.com, linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm/vfio: Fix potential deadlock on vfio group_lock
Message-ID: <Y9km+xezgD4ovjDX@nvidia.com>
References: <20230120150528.471752-1-yi.l.liu@intel.com>
 <67ec09bf-cb24-34e3-6ec4-1ae87b0738bd@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67ec09bf-cb24-34e3-6ec4-1ae87b0738bd@linux.ibm.com>
X-ClientProxiedBy: BYAPR08CA0040.namprd08.prod.outlook.com
 (2603:10b6:a03:117::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB6795:EE_
X-MS-Office365-Filtering-Correlation-Id: 3125bb25-216f-4576-bc61-08db039847db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6oyvGfqF9QAUFt/qDB4tjNE8WLP1XCpLLWSSHZfU0iatXPYEVRHUy6glWYEQiBzC8wLD7QWaoWmDxJutnK6scMXm32NSHcUuWwj5+MTlmx+Ev8qm0uL5ZI2yOv0FSZ6zbctojT+Bet9rZaz1U5x2pG2BPFYn/kpsmdDDNg0ctIwsUOLB6Aq9JiTH1zVvXcfHbSmnJFD/wqXS1leKuYXwQvPIOvwrxVo8IGZzaN8Hrljbs3MQBpiguAGvlw7EFuaI6Xe0Y/NJMCyFOjIiWPQtl8/o4k7fJk5izb27wDhvIcslZpVXt1melJBq2uy9wrFb5h4n+8vEd6amYHJISV3w8qJliRsz8Z2Rn3jmlKeEj8PlFhkDydR2Jt+BuYbrBBQqFp5o1UmZ0tSd1ggLIoj3eKMB/O88tfNHPYegOYv15SINd97vKGx8bynkqEIzXYH9yTiive/y8jwFrZWIop9iV8UZfpg6b2k50iE3EHOEYgG94vey+DRTZj8efncDpNSad8yNfSy3lvth6aJZYr/pi6EmECQ4xIV1GL1i18PtKwGRtqWasbiKV/hA+jZ6DUe1pSXEUrhCIG1shB/cDMmfJPSXfl92YhxPBSbSKELdgE1GBzMZVa0ZXWXdi+4CtXMlCE9sq8q1Bgsk4iRBjWVwD7fBbzbxuKLzA/2iXdwDQNz7QaBIDESesGo1hobgdUCX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(451199018)(36756003)(316002)(6666004)(6486002)(478600001)(6506007)(4744005)(7416002)(5660300002)(2906002)(4326008)(8676002)(6916009)(66476007)(66556008)(66946007)(8936002)(41300700001)(38100700002)(86362001)(186003)(2616005)(6512007)(26005)(83380400001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JmAruMNE2R6qQ7TbCH6MO9fP+00Kiav59LRL8I0ZEsnbuM2TqFdIhYQMtNDx?=
 =?us-ascii?Q?OSVQqKnuAx60aBegdStGJAqP1Sl7S28SnCFG2WGMqGfGUP4ypdIK5wjTM2VY?=
 =?us-ascii?Q?3bKHgMTwsuqMib2BXJX/AxNr9uKejoapKR2/1Ob8ZRT4KWZwmYEaWCJaAV3p?=
 =?us-ascii?Q?jOocAb/rIQKumBC0YmpBnQbX9HC0/pC9EZGAAIZAWF8yrXJPoIEyeE3G56K2?=
 =?us-ascii?Q?TnHZtuvdcCq+1045jRmQxR6gA/OQjKXHRcgLqWTj9XJPM0x2QIDb+vIfC8AS?=
 =?us-ascii?Q?D5c3mob98uiuipBpOeRO3zheqfRh4FvD6oUZXo/CyMZdnG7AX7R+5EuigZUf?=
 =?us-ascii?Q?VKraQnwkCXApjEeuRlodmU49zkdnEWES04uZHyDOCZF3uAmPeB9qDRRBPoYD?=
 =?us-ascii?Q?qui6YruRgrsSu/FloBOHU/cElKydyh7M6DPNBq5mxOkLdbyH+vWedvKKDB3g?=
 =?us-ascii?Q?U49I7OwO7X2Hfp+EwvObLveZr0dDu7f8rmrr1ZgcDXPcCeXNKrUeCyJsNMG2?=
 =?us-ascii?Q?+2DsB05rVC2AEtBxJwW1AaMBj7AH2fXsR5spprh259SDSNOIJFubNlzah1im?=
 =?us-ascii?Q?+ut9PvWeqLWFDMQ50ROsNs/StWJdmgNk3N2ueaS3qtkEfsPxkgDLN/IZMjM6?=
 =?us-ascii?Q?R9BWy1WPc4fSXYEPhO7qvc77vnNv51ODbGZ371seMQFjLGO3fYASNVuzjyfJ?=
 =?us-ascii?Q?ersHuVKhSO1o/cQTnLlrBtyRV3oRA7wNp7SA2HbRyAu+UAInSLIkywajy0pK?=
 =?us-ascii?Q?1ZYVtIzgES8SQq9U0j+EaKwzcnhRPN9tJXJtVVB5XnTuPKy5ndAO/V3J482K?=
 =?us-ascii?Q?UE5nqsPvfQeqodh/xY90tw4jx3l9IZ6N4wWId+JzjYH5GuoV50dzlhrpn3Xs?=
 =?us-ascii?Q?XLXPPZID0zzBbpLtajf/OCp1j9ZAAwf/lR7iu0Z905yp49sT1iwNTpSMiPL6?=
 =?us-ascii?Q?aG2qwK6AjB9B23NGMoSac1Iy2r97o3TLfi25+CAObwMPZE74glCmsqdExCll?=
 =?us-ascii?Q?he6Y5pWXIS+YUehvCF76OFVV9MgVru5L854+o2560NRWkGQUSFlcao66g00f?=
 =?us-ascii?Q?+r4bzHSFmJjbTsaf+9VuJAHO6aQcK20evGoPkq5FkyQ3/A5YiO2vkHLzFh76?=
 =?us-ascii?Q?CEabEx2nOJbtdnGbkgdjIHAhfjohhM+I1YUBQb5gXZD5n5UeB9zNtSBTXQYf?=
 =?us-ascii?Q?nKWiJDyaMzJh2vMAZB1g7ft/PXXHbXlm/tyEt/x0VFzfV+dl7XRQUe3yD7Yp?=
 =?us-ascii?Q?PAgzE4404wIDxAE5biF3HeL93NNSFoaeH2W2eOxAxyi9YO7P0hi0SsRbvreU?=
 =?us-ascii?Q?BM3YdnAMtAoUY9tiTCf+Ap8EAXPN7fW1wjuk2PRc2iMddDSeN8G//QQcNOs4?=
 =?us-ascii?Q?wY65vNB45AYGEHtCeJ6qmjnSDsqsDKvDehx6Sqhe+pHRz/LrhVmat438uEqm?=
 =?us-ascii?Q?jcoQpEcjZBINMNgwTrl/AzzcmshFQSN6jS9a4IMN9C+u5a9uZVoGce2eHghN?=
 =?us-ascii?Q?Xc/JEqymrNJbdscMprOEuwzZwmAI7OyNaMsxI6WPpum5RW7ia9kZinGXIQ12?=
 =?us-ascii?Q?XZjvI6YYjxSugEaHDjfgsxrzBpYSFi4p73m13QBy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3125bb25-216f-4576-bc61-08db039847db
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 14:34:38.0872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R5IDYHqH+jIpR9gKHSgMlCWxLO+ZL19hIFqW0s2QoJx23nGibBfHqc9LpR6yKq5e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6795
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 31, 2023 at 09:27:54AM -0500, Anthony Krowiak wrote:
> I encountered a lockdep splat while running some regression tests today (see
> below). I suspected it might be this patch so I reverted it, rebuilt the
> kernel and ran the regression tests again; this time, the test ran cleanly.
> It looks like this patch may not have fixed the problem for which it was
> intended. Here is the relevant dmesg output:

Well, it fixes the deadlock it intended to fix and created another one
:)

It means device drivers cannot obtain the kvm lock from their open
functions in this new model.

Why does ap need to touch kvm->lock? (via get_update_locks_for_kvm)

Maybe you should split that lock and have a dedicated apcb lock?

Jason
