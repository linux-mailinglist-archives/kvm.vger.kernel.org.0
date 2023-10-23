Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB547D37E7
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 15:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbjJWNZV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 09:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233297AbjJWNZD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 09:25:03 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7704610C0;
        Mon, 23 Oct 2023 06:23:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YRAkq1BpoM+MND8Yqrx7CaeJVKJPh+JQ2SLZBNRYoDlLJGOY6Ka3aSJwy+ATnmBTBGEfUBUNCII+aQoysTllqJADKxulURLKSuHuEtTxk71JZdNq/t8HCoGl2J79gXpJ3U3cRxNjjLPgt1RYXZlMd7F5IxwngaJ6vShgCtDluxc3iiGsDldvtWeiAIGX4jY5EcwJdSzcCPgE9tzOy/ZNdR7L3o0C2Cq2xqMc9O7vOm+JZD02XX9byXd6YxdYilosgvDNMBuc4kdOL0Qzjsb3Uhw/uLTpIKkISkx/Eo24eVaVgwy8lkainurlBZDBqkfHGnoFbDgFLTuFFYLjOaB+1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YtLp5aZjVv5QKCK3gPvzx9CECyi9uK9ETCi+jkNeOMY=;
 b=kwGtWNhf4AnySbt2gGuJsb3042fCxVr4eJDSOyl7cyuxRrxZrXyM25rbdPVke2n6wE701PwatVtT9DEXZFeCZLTJwb91tvnWwRIba7Q9z7eW3/DTL1cTkMxvhYbcOH3Hg9YqB2OZaCuBLFBLzD3A59CeSF/0K8TT8CVS9AIm74twA4WnQxZiqo6O9fuQE8gePt+fIqi/INTUcyoSuG1y5LDKyk9wiefyhdijliY6miprhCfHLZJz+QfsLk8+T2U/KH5lAi57bUjQxjkB8jCYwms6vksPZc+Uin3CrDo86pZgWAHKG0/orZur5grLL2Egx9iz8YdOUJ/WMrbsw7v9/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YtLp5aZjVv5QKCK3gPvzx9CECyi9uK9ETCi+jkNeOMY=;
 b=UCDcHOMCsM/H6UMg5Imum2UiQmkcdQhzBTCXMwOWk5vlppuz4FprgX43qzgtwXh84d4T3JqhbzSyv4g0QcUAtCU3P1klbD5RMvC8Wd6qgvv5VqeF6gR7U7H6cZt8m/IKakVAadCVktTPop0MEbwDBmMTXv29+HGwIOri8SNjRULw7YGydsvcReUPBSliPM6gAkTiQpvHV6rAhG2wBHoFdYSq68IAyY69+uAV+9HOBt6UAGTlTK7gsNIzDBFVO0NV/KR5asqiyeqeeKC7d2jkZKwL6ABZOztqULJn/eocMgBOthTikQ8OhyeHYHkg9vFaDLsg9L1ZN2CS7rwMXng7UA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5088.namprd12.prod.outlook.com (2603:10b6:5:38b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Mon, 23 Oct
 2023 13:23:07 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Mon, 23 Oct 2023
 13:23:07 +0000
Date:   Mon, 23 Oct 2023 10:23:05 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        Arnd Bergmann <arnd@kernel.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Brett Creeley <brett.creeley@amd.com>,
        oushixiong <oushixiong@kylinos.cn>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: mlx5, pds: add IOMMU_SUPPORT dependency
Message-ID: <20231023132305.GT3952@nvidia.com>
References: <20231023115520.3530120-1-arnd@kernel.org>
 <20231023120418.GH691768@ziepe.ca>
 <a16758d6-964d-4e46-9074-4d155f9b3703@oracle.com>
 <b3f7ecb1-9484-426b-8692-98706f7ff6d4@app.fastmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3f7ecb1-9484-426b-8692-98706f7ff6d4@app.fastmail.com>
X-ClientProxiedBy: DM6PR08CA0039.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::13) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5088:EE_
X-MS-Office365-Filtering-Correlation-Id: 877930c3-5389-4819-4a9c-08dbd3cb31e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rlJhw4sJFRfStBl69ih5QL5a5rkLrERIQeuFj7BeofHTA2juHQLlpEqPslMX6247wNYutxqMut73/8+S7WWxFJKWijzQzzOrNsgFoIpn1dvFbTxaUezAHFMlct9xDpZpECDtQ7L08N8BrwWOBwINaLlsJR9XIauXm3fPcBIN7Tlq6yiqL2iZ9igK+xoZRFjzK9zEwg3wFwSd6/UMTGf8rXHV0GqBMshQE80R7fjBwX3GITvO8yZb1GBftDNjnqvIv9W/8GGJkv9K7Ru3kop3BYpVJAETNpf+XTG1zpYLKc9Yw0i35ogf9E+ntZcpRy37hq3n59EgyDhCWUA25TVDxVK8NhqNk97IxDQ056mxW/N7MdGEiyoFs4F1zWQ6g30xxhumGHNmrskqIsnzma5s5oQi/9Vdq3a4CzHzMesOTesz76E9Iwk3hnlgwF08LglhBPqIj33t2jy0xxrnnG8hP3Dg8ItXuNwGXPzqiLqp+8iH6Vy/jSd7AzFGMF0g1zVcWOrSjCUViKHVR7f4HR1+6xxspn5Td3Q5jxqBDoRRGOZcuE+bhRik0v1sN5e3RPe9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(366004)(39860400002)(396003)(346002)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(86362001)(316002)(2906002)(5660300002)(6916009)(66946007)(66476007)(54906003)(66556008)(478600001)(6486002)(8936002)(33656002)(36756003)(4326008)(41300700001)(38100700002)(7416002)(6506007)(1076003)(53546011)(2616005)(83380400001)(26005)(6512007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ipfaSGVL0iUVNPnhBVocrh8xkmptMsVKxALONL1mfWX8/ei2Q/2zt/v3B5MJ?=
 =?us-ascii?Q?NasXtXLK0rR5F1Sx72+3fYPVvflJnMDuCqAt8b7hPWn5vqdnAmwNCixnCOlv?=
 =?us-ascii?Q?Yn1gd8f1Ht0lScWA5kDFfSZB4Itx7mEtoUS+azDYZyauGMXc6gpcQAdPB2sa?=
 =?us-ascii?Q?JeSNMMEd6vT7ZqX/0xqPFgoVCkoFwYLL8xABiFyD9VEHO1hEO/jxCcRE7+Q/?=
 =?us-ascii?Q?uAu5MpBwg9u3uWdHIDV8LLvWCvZ0RAOZZyTYbePMMIkftM2qwB5OuLz5tjSX?=
 =?us-ascii?Q?hR7NCxnYu2F5VQqL5we75OjmZvCVkQCU6VBuVx6jhv3ZyINYppNFPDOgTY1N?=
 =?us-ascii?Q?a/WSsB9QTyr/ZwFLK4ueqFZPmC9Et3Qnb6++G6BejvCBZ8RfKhbtMNrYB5rD?=
 =?us-ascii?Q?xBRgEhEBbow8u6LzCv8BKPnj4Ub8G4q5dyWipOnzqcbVxiB2aiHT2AMU40dj?=
 =?us-ascii?Q?//y/7eAaTspCTWDeLVaHET4cgjgjmvgB3fohns20/armHJQbZwW1e+mJSVMJ?=
 =?us-ascii?Q?pQTFc7sJ/2dBoTz/RRjFlhzNNSRVK8RpB09beOqgEAHWOC/TaVayjhgBySZl?=
 =?us-ascii?Q?cpHLk8tCqXWiCX65dEih4RpeulvmpDRlfXR1/DqL9oFnsuyD9GuE7Z6jnsY0?=
 =?us-ascii?Q?48l1nDx7IX+3sLS98tlv5qGy8bB2d2XDotso/pDYKOr4SHVqqMLFRQQAK3A0?=
 =?us-ascii?Q?5EWK94K+Cvx+RBH0yWFgQmBhTHtc62FdlERYtOVTM6x2f+WVfYvMp3gg82cR?=
 =?us-ascii?Q?5+Pc363KPwiLVjxo0OeZUYVMeF4U/IBkBHBVyVJPp53zqoy69kxpZB+tfASL?=
 =?us-ascii?Q?lL/ZttW5mmMF6+aDAnc0m1GjzQQXKEoCwYTSgxZujPD1bLnASlzBZu2W2QNL?=
 =?us-ascii?Q?P/q4BjG4YSia5FgSqw+uzZRRR/GBXckgU2F0zC187aDBH/NFfHLOaALTMV0X?=
 =?us-ascii?Q?Bkn4Aw55sMa1TnIj38l+mAl80PhDmQaHxnF44u2/HG8Pd01bA6+K8ZeM+Ttx?=
 =?us-ascii?Q?E3Fu0Eb++9pku+YKi0RM8sB03PxZ/Y1cbd0uvO4dYvwna1koMDCJvEhFOWT3?=
 =?us-ascii?Q?cju1wt0zqNhEsVu+oIhdopHSH2FEi2O6YsVkqdOH07lq/7d1+Gsmoh7LnWA3?=
 =?us-ascii?Q?sc0ZVE2+ro5wBWsh+w40/1JEkDeEwMsr/0gttM9yz8coxSaJTMU+6vM+G+UO?=
 =?us-ascii?Q?ir4wfCmGuvXu3o/vr47VPAsUrfQudJUii7Gcb0Cl3Qkxl0l82KQRHhpFGbQ1?=
 =?us-ascii?Q?pFrhxlebQxZuNw7NEeDMDdX2Zs0xXo+0ZpiItxOppS+7CSve7/AuyZkR7RBJ?=
 =?us-ascii?Q?HO8K4SrZ/ODzlPJwVU+9l+HqSOo8sikHMqNpr8WrBaGf342tJg/ForW0PfiG?=
 =?us-ascii?Q?Hu4y3hUwcEN7AEj8KeX9iHbQNsdo0mzWV52j2FBWI3xHibfDoa7QDyCrfFwI?=
 =?us-ascii?Q?QEg0NEvAPK+7rOYBGLeK0QRxWYzWTDSOgUtQ9TV27qkLaBFojMxX8YwsvMr8?=
 =?us-ascii?Q?f40N1Ri5E9l3xpbIh753CCcxtMw7P0gPi9mM326i07+I03I+yO1BEZf0tCgc?=
 =?us-ascii?Q?avFE0j57LQDu5reTclc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 877930c3-5389-4819-4a9c-08dbd3cb31e8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 13:23:07.3630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GNwcKLJ0e939ZsXmddTSjnx1LOo1vaHFp6iI2l0ch/FRzLnoAIMOZKnyF+jFuhwG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5088
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 02:55:13PM +0200, Arnd Bergmann wrote:
> On Mon, Oct 23, 2023, at 14:37, Joao Martins wrote:
> > On 23/10/2023 13:04, Jason Gunthorpe wrote:
> >> On Mon, Oct 23, 2023 at 01:55:03PM +0200, Arnd Bergmann wrote:
> >
> > Right -- IOMMU drivers need really IOMMUFD (as its usage is driven by IOMMUFD),
> > whereby vfio pci drivers don't quite need the iommufd support, only the helper
> > code support, as the vfio UAPI drives VF own dirty tracking.
> >
> >> I think it means IOMMUFD_DRIVER should be lifted out of the
> >> IOMMU_SUPPORT block somehow. I guess just move it into the top of
> >> drivers/iommu/Kconfig?
> >
> > iommufd Kconfig is only included in the IOMMU_SUPPORT kconfig if clause; so
> > moving it out from the iommufd kconfig out into iommu kconfig should fix it.
> > Didn't realize that one can select IOMMU_API yet have IOMMU_SUPPORT unset/unmet.
> > I'll make the move in v6
> 
> Are there any useful configurations with IOMMU_API but
> not IOMMU_SUPPORT though? My first approach was actually

IOMMU_SUPPORT is just the menu option in kconfig, it doesn't actually
do anything functional as far as I can tell

But you can have IOMMU_API turned on without IOMMU_SUPPORT still on
power

I think the right thing is to combine IOMMU_SUPPORT and IOMMU_API into
the same thing.

Since VFIO already must depend on IOMMU_API it would be sufficient for
this problem too.

Jason
