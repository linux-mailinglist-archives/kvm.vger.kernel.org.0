Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E72D4B52C7
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 15:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244516AbiBNOHK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 09:07:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354935AbiBNOHH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 09:07:07 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2059.outbound.protection.outlook.com [40.107.237.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C4F4A903;
        Mon, 14 Feb 2022 06:06:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iF/vwQwXEcvWgEGD1WDPdwlb/bg1Lk3BikMV/XmPR8J6v97Cw7YdQaB+zfx1vtYoc5Pppj62eqIP4qhCfqo8KL6pphelwReQKWuSjDnbrhAjNihyV2/xTgEzkjCq4Jrw4qox+/FdgsIWB1/8WAMXrhfW6A+UnKGzM0mOp7LuvD55kN6bpWGRgr+uZi4kvQrVSmglF9NNX0PATZ63thuXilFjRWwP5U4DJVRvu3mBW88XkJvgzVETEmHcaIpox5oE5nJczm/TbWikPz4Or7Hey8NLX1+ZBlPpBqi4PGBCgtaJlWUZE/V/wqqpA4NSSTu9HboUDgXJWdO8S9icqDEtHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ML0KmvW2m5/xHUs2C77q7muIhD11k1seF9IStJBtAJY=;
 b=mbswfdZO4jO89pdmNwWHTwcNrOaolZdxqOGeWtc7iemgP+hrtLD8nJxBxzVg3pKtdPTpfhGsHFmtJVudgRrageX2q8e3zUHfbxR6/DaeCtJXiLo+uURcPeiAPvswhhHAg1KwHnthjdm8yRyJ28Z2b0hsBDuJZ3esCNXQAp2uIFTZxTRHXpSFNMEG9NkIySVovRb4J1OXZjmOOJg2S8YM/pR3usthqzc3U8rCOZ2qUDc7wgx21YkLRtEth7DrEyIsV4GRoMp1d9eiUX/Ypw4oLM9YTGTMdg9mWTJ02ur3/fyHByITm/8UDGMinAF+f4e2Yz0vMRmyrkXlQAC3s0HUAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ML0KmvW2m5/xHUs2C77q7muIhD11k1seF9IStJBtAJY=;
 b=HvVhFwK7ZZj/0yXqVmjuXRJ4Zdk4G/AISFXUO+LWxTzwI5oWtcVC3Jr9Kdk+OBeQEH452pdBv3hdxFM5c6Ikkzwi7y6F6KHtOsdeSkIa3mn/Cg2252q9GV+VeWe0oJnf+mGY1XpUGWTlL/UxU1GJ8G264rbvxjPDqu4vkgylPJXNxpFhfG5r9FAwJCZ/sazNLL1IKgr88WZt/2xj/wagosmRDSEveUcGrOhQ7B5UWm6XPnU5ROiquQEtwCwhH79qyJvRitU+SekZX7rxgeInp5xdwsM3J/aXRistndswQBEeJMQWBZZ7qt2w1zDS9ISlvDJMOl/UfvXTh6Z05pWq8w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4828.namprd12.prod.outlook.com (2603:10b6:5:1f8::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Mon, 14 Feb
 2022 14:06:50 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.019; Mon, 14 Feb 2022
 14:06:50 +0000
Date:   Mon, 14 Feb 2022 10:06:49 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
Message-ID: <20220214140649.GC4160@nvidia.com>
References: <20220202170329.GV1786498@nvidia.com>
 <c6c3007e-3a2e-a376-67a0-b28801bf93aa@oracle.com>
 <20220203151856.GD1786498@nvidia.com>
 <e67654ce-5646-8fe7-1230-00bd7ee66ff3@oracle.com>
 <20220204230750.GR1786498@nvidia.com>
 <0cd1d33a-39b1-9104-a4f8-ff2338699a41@oracle.com>
 <20220211174933.GQ4160@nvidia.com>
 <34ac016b-000f-d6d6-acf1-f39ca1ca9c54@oracle.com>
 <20220212000117.GS4160@nvidia.com>
 <8338fe24-04ab-130a-1324-ab8f8e14816d@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8338fe24-04ab-130a-1324-ab8f8e14816d@oracle.com>
X-ClientProxiedBy: BL1PR13CA0341.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::16) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 770765b3-bd54-4f95-f043-08d9efc33efa
X-MS-TrafficTypeDiagnostic: DM6PR12MB4828:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB482802EA0B14646DF5126612C2339@DM6PR12MB4828.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wTRjD4iB5OwbPqVMtbxucZu13xNT030Vhw+9436ip7QyaKRE4ZRuq/tjo2dKA5CON4BtXWF4hbj2hGZDSt84rMk72xpUKkmWp7ng47yajxAaWEJYGljJRYGSoOdWOa+ULRCI2JbCuQq6DNVkLXA/nUSs7/7kG8oj096v45zl62u2ZwSe6abnc1lY35HFbKH9in8ZuT05sNEmtyXroDO8vFC7qvQWvJdEh83JwY5UxzLtbdaA9yTJCo682gQr/lWtklst1T802CASJUD+v99/h+FddNWFsR/wGGNNQ3iipCHxW+o/u0zvzfVQUuMSAXM01Vk9r5LCVdgrss4yMgQJfWHYD3cwSSoiP8RWtfiflW+ceg3u9+USx4WkQkDMfo/Pz5w2BMvcJgLSRUJGhdIQXuRQk/a3p2erbXuqcfH+6y3dD0j1Sb4Z1NpHZ0rc5nb11DCzeya4gdNzcQse45qPU7w9Fk0lXlzlkmeiz5HYRGAY6C583iNCxMIe6vGDkGLs7l+RBgHqKUtz9M0Ty2KuPXpwvr4nVji43lakQtz/XpTeNrYogPYztwNuRk1rup0YMf7QOLQZJZTBlT0raKvRz3SrAAj9HuVq6RqjqEImL+zX6Q31xPlp0Zr/bvsm2b/S3NMMmbJxFU1i1EtWQlKxWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6512007)(6916009)(54906003)(26005)(186003)(316002)(6506007)(2616005)(6486002)(83380400001)(86362001)(2906002)(7416002)(5660300002)(8936002)(33656002)(508600001)(38100700002)(66556008)(66946007)(66476007)(8676002)(4326008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nRPJCV3TqviaTIkAdOsr6+XFrUSJ2XLMKzhybOd2bRCFkwPd/SM6ZVFh8NY3?=
 =?us-ascii?Q?6omNL7VVWAqlxxSo91aDf4AlhqSXc86E9VyPuloIjGKwXDedUL9BHc95QWFh?=
 =?us-ascii?Q?0AVMfyrxYYE/qkfsJMcoU71McJkN4AgWehfpFbSua9kjGN0si7dHIYROVcC2?=
 =?us-ascii?Q?15Q0lTzl7RVA1B9Se7ijWukyIvo63WrYKZdEu50NaNEg+jRho/QoPwkcrELj?=
 =?us-ascii?Q?wMJqt3j2wb1B7H2H5lg+7AiyMwVBl/6GLa+X93kK4HUALv41/yN+ewjWMlMV?=
 =?us-ascii?Q?bGr7YuwcBn+1+e7RyT4DAHJ0/y7VF6hKbD8NzFU+5BarPUMH7yqaSp8Ek+/n?=
 =?us-ascii?Q?8jbNI3RGv5pf8iTGnzJ4sKWn2R7hBaphRy8xONTrN25uNKz7K6Tlz02f9rzc?=
 =?us-ascii?Q?L91CoKilSTzTtZyNOXvHhqde6F2lkdthd4W5iSt7hQAa7iz+rCOldr/H/Lgq?=
 =?us-ascii?Q?9NyadBy59ysJ2+iv4CVYEm7q/EkJrwI0doIfIIHzutkBJMvTjKpXLXnIs2e2?=
 =?us-ascii?Q?jULLvF8i367K9IsFfsq+jJaIkleVOK2iGBcqvGOu16qCLjXf7OuAMc70Chia?=
 =?us-ascii?Q?SSQvF5LOVnlN7383GBfev2TIaloiUFtCivZZZXJF9d3Pf6/RGhcT9qsH9ab9?=
 =?us-ascii?Q?u0K4mBUUlRQE+jiWxZUfOPreB61ZbudiUZhPlI/sfY2YmunS5LAKWWRj/ZBk?=
 =?us-ascii?Q?jfTd3CsxRRygTgKjTLA6DoBIplsRA+0E0fGfNB2IcDWWr9muPyfTJYrT2fOU?=
 =?us-ascii?Q?8A17unQgC58yP7LsvKIndyTBjJAPtz554pVIQFgSSGSuyb/cAcG+NM+O0wJC?=
 =?us-ascii?Q?Zmh8odpXL9OpxdyD8p7fumZ4EMIN59KQ/xN5wTZMPyYML5vcQb2sr2Fu+vwM?=
 =?us-ascii?Q?MeppLZFs0yJ2eZUeStQ4qdy3oPwkSmh6TQ1yoZDJnFGND1Vzm/WqTo+pRQEQ?=
 =?us-ascii?Q?t59K/cpfkkZY8Vo21HmrOb/q9SciMS+C8U+kXd3QY3CbyH4o7h7eXMEiPMEa?=
 =?us-ascii?Q?KMFDgpECwBNs4rMYumPvT2rJNm/D1l5taBDQyCsOKg6I6OCub3EmDDj9CInI?=
 =?us-ascii?Q?dikAE6deWagF44mBeH44FD2mcvyKbtwiDZWfrMzlwhGwLla/+ALvtH+nyxzg?=
 =?us-ascii?Q?HxYhSmCcXidNIFT44yvYAtxXUL1rcwVCuCgkXKdppE09u3k41n6VXj+dD6Vn?=
 =?us-ascii?Q?+uL0YDSMwwby6epzEsYPMOpIMk7pdJK9Ie9TiU4J574lrALkChPLvUHSxXH2?=
 =?us-ascii?Q?OYQVDrC9Oo1wEjwjdQndzq++9lKlacELHtYV0lezABsYJfOlizCCjl+x8yJq?=
 =?us-ascii?Q?p0ID0HhKrpfogouGjc0y0da172TiNLwOuWuluRe3pPZT4wqb/hrviIGmenyB?=
 =?us-ascii?Q?bEsNrbZxHD7/xPj2GXbL5I6FzpQvEbhOuXLf2fx2KaNs9F+CdCCSx/NV/boo?=
 =?us-ascii?Q?nCA0bhzqbOZo5Gh7eIWXQETwb+6AueflZ05t75BmJ7VNNsQO3IVspQ3XQi5p?=
 =?us-ascii?Q?2pV4EN4oRpk5fOuTgXx8+aM/D+uRlg+Ut+7Lv1Fzj2Hv/iRiTg/dh9/EfPPB?=
 =?us-ascii?Q?JskIGU8PKPGuTbxyEgs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 770765b3-bd54-4f95-f043-08d9efc33efa
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 14:06:50.5023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ChxyaZyk7kNcuZJHfpH9/U1JttM+a4AX8SrmKUpTRZJtSfl1YmkQeY7w5kMbypgg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4828
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 01:34:15PM +0000, Joao Martins wrote:

> [*] apparently we need to write an invalid entry first, invalidate the {IO}TLB
> and then write the new valid entry. Not sure I understood correctly that this
> is the 'break-before-make' thingie.

Doesn't that explode if the invalid entry is DMA'd to?

> When a non-default page size is used , software must OR the Dirty bits in
> all of the replicated host PTEs used to map the page. The IOMMU does not
> guarantee the Dirty bits are set in all of the replicated PTEs. Any portion
> of the page may have been written even if the Dirty bit is set in only one
> of the replicated PTEs.

I suspect that is talking about something else

> >> I wonder if we could start progressing the dirty tracking as a first initial series and
> >> then have the split + collapse handling as a second part? That would be quite
> >> nice to get me going! :D
> > 
> > I think so, and I think we should. It is such a big problem space, it
> > needs to get broken up.
> 
> OK, cool! I'll stick with the same (slimmed down) IOMMU+VFIO interface as proposed in the
> past except with the x86 support only[*]. And we poke holes there I guess.
> 
> [*] I might include Intel too, albeit emulated only.

Like I said, I'd prefer we not build more on the VFIO type 1 code
until we have a conclusion for iommufd..

While returning the dirty data looks straight forward, it is hard to
see an obvious path to enabling and controlling the system iommu the
way vfio is now.

Jason
