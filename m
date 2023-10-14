Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B73607C91A4
	for <lists+kvm@lfdr.de>; Sat, 14 Oct 2023 02:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbjJNAC1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 20:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbjJNAC0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 20:02:26 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6470AAD
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 17:02:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L7pSZPEmOSK/beRYoqlt8Rk551/JMPKE5dkSOgVjOMJ7iCwyaZVpLjisVXWVaYtkDYv2skLJCeAfRJcSgg023cDPphyB/+R/ul6JsEH+28arF8ssv3JA/wHgzstbCvMOJx/xRDw1phKuefdNiH7B/9bZHnrN50Z21TB2sXuWFvhkxRJZJZlPIFSV4MKGw9FwK7KTQLNkAjC7scvqN4WU8iN8ShVpLjYMQC4gI5ovRegwKqUki8X4KE1EvgNiEgcduNEAmT1+2PqnyiKkWxjHOsyo7WwcfwB4k3lpXRTCqqcbKjnHgtW2/+a4K20k1BR8/cOP+udp35/4heTobXJikA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BwQ7He6DjGhWHQgL9psPPa6uOOV7Qx4dSdyPsx0Q3NM=;
 b=NbHGjnR7Ma2gOhxUxnvAMEGp11WflpleJPKWYpnomCwwkHE6hqHOR4UDwb5fYBLlQpaRamIdUhRMhr2ItdixidkmZS+WC7wMKR6oB3mJ6IZnMNcqL93yzWVUvzXIyx0nMQ0JVvzzJLIjFgniaK+tWzf0OnlznbD89b0EqkTeXHadMLHqEkkK4ZDneRHhbP+sslk72/NcBkkILURiqdwdFbGImFnt0jG7KWTjjfoR/0dNgGiRFstXPw+yvOVLrkw+TCR3AsY5ebaolAyt8+uHbI0cwyzy/XEqFRiE61hijH2huFpI9yiLswoOVXpFH9YYhD6DAgPAwNZeZrxVNVnmJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BwQ7He6DjGhWHQgL9psPPa6uOOV7Qx4dSdyPsx0Q3NM=;
 b=CFHzUtGpiODXDJ9qIsWQrC6QTL54b9X6DEbIaAd+az3q1yiCa4Ich1HOMRNNo3mF8wgZtKmCkTl6u/+uSbkPKfmg7ABLWXApwD0IuTdEl61yXiH9u+PtM6kU5e0Sp7+Lp07fFoNwGhJMuIZOui1Cr+nyNcGSguyLCd1arzGHed/aOeSPaEAYOhDntpkl7Zcsk5cPFPdYoyggT3bZ8G0+xwE3i1INfIpgEQvsRqccgElxxeBLEOy+ariRWPVEdrgsFqV5Kt8zWSJvsSOl/an3gCpT6wUHSxSPAnwdO+U+ExBhCpgBUAs4N1oY/GpcOvVkN2f1opAzZsQcvhZeFCovBw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BN9PR12MB5339.namprd12.prod.outlook.com (2603:10b6:408:104::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.47; Sat, 14 Oct
 2023 00:02:22 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.046; Sat, 14 Oct 2023
 00:02:22 +0000
Date:   Fri, 13 Oct 2023 21:02:20 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 02/19] vfio: Move iova_bitmap into iommu core
Message-ID: <20231014000220.GK3952@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-3-joao.m.martins@oracle.com>
 <20231013154821.GX3952@nvidia.com>
 <8a70e930-b0ef-4495-9c02-8235bf025f05@oracle.com>
 <11453aad-5263-4cd2-ac03-97d85b06b68d@oracle.com>
 <20231013171628.GI3952@nvidia.com>
 <77579409-c318-4bba-8503-637f4653c220@oracle.com>
 <20231013144116.32c2c101.alex.williamson@redhat.com>
 <57e8b3ed-4831-40ff-a938-ee266da629c2@oracle.com>
 <20231013155134.6180386e.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231013155134.6180386e.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0440.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::25) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BN9PR12MB5339:EE_
X-MS-Office365-Filtering-Correlation-Id: a9fdda53-e940-48c7-3501-08dbcc48d6e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v+jizkutBBftb9DEy8cPqmiZDbwcDc/mOaiT+rQgXR7/+5MQX3wpxoQwIreuUVoe3kHbsCh82rHJc5OxRJsU3Co0x5wNTXuxAXW/Rldp5NgsE2hVdsYjsu5tSYteuDq4Cf6q9XLhvKScyyyfYj0/rOUtNRaPPK5wCAdzOhyYmJ0WDfMy7goeTmJhcFsuzHZj0ow+Fh1n5kxzEmZMK8IIkbgh90bs9HReCeiFWtSPgIT1s3JMbrYmKi/VXkUrG8oCPRy3kuDB2wFeziFvgXujT3i5mUg52HbOZu0HhU8B/nIXjPEatu9HuZyvZxxG68JOvh8wzx0qaxUgcyi5zgzyLvxVjaiIRd5ByRnaBiFSKvaAXTDS02P/gB/joYtQhbkZ9c0SVnoWHhdZFome7CQGvZa7GiKx+ScODQlgN9Zz7ABCxavH+1yXN/FX2pYkA5kmU1XBdOFIYCGGgf6PswgCblAHJLa328TXRwGzK4n9ZSVK6c9ALlXd39aDw1BEEVAbXe0lM/bSm4YZHcKqKN6ZNCPPfL7Ut8jvUqIWsRB5J5DQ7JMMdQ8fa3VqopWyIyrk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(396003)(376002)(136003)(366004)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(54906003)(66556008)(66946007)(478600001)(6486002)(6916009)(66476007)(316002)(26005)(2616005)(1076003)(6506007)(6512007)(36756003)(5660300002)(7416002)(8676002)(4326008)(41300700001)(8936002)(2906002)(38100700002)(33656002)(4744005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YYFe0MiB94Jtb37C+n9xdC8hg92i7ScvwzEeZYX3Ocf0y8sD8YJF4IGr2m9Y?=
 =?us-ascii?Q?5aNo+Ab04pF9lTsq0Vxz0yXWU5Lzj8Rd3YvA9dUafhuNpM6UyV26HxffrOve?=
 =?us-ascii?Q?hfaF4R01k8U4ih9oAAPgqkCSl8su4iYLB+Rn878REPr+HemCQBSGBhLTv0Rw?=
 =?us-ascii?Q?aeByXao+wU7/wBaAGtA+xFZsIsYLV8ZlmdrioLezCkbs/z5QndnZiNLlUG0R?=
 =?us-ascii?Q?7tF7d6Up9DZo/IHWNMnjBwZIK5dT++teDi/h2FESdttRaTjJWLm2W57xTy+V?=
 =?us-ascii?Q?6BzVU613LiJHK/PbTcJDuV+eY2ho9nVmGiepTLyyJMJsmvk6K56uqTeAZiYn?=
 =?us-ascii?Q?iZKx01mDyBrsYJbECnrOkHe4NGTzWlRAkvCTkwra+vVrFDfUTtgw/yrRiWJ5?=
 =?us-ascii?Q?kt+Yn8UPG0Q+Ae4pq1n4VpSHKNLDpPO/Ea26azB93Md2Vi8QNbUNov03+5xU?=
 =?us-ascii?Q?f70doFnlADYj67Qt9hOO4k99D1O8rcamqE8N87pnYW//LtgELLMBO7TcsSqb?=
 =?us-ascii?Q?ou4Mr/E+/Ajh+S92+UwWwGR4pdah0THPTT+1wRmRTLvsZO/l8Ygu5Km+i5Nf?=
 =?us-ascii?Q?ORDJDKcATqiP7uaHokE1jykTAMb2iaCoUoE4A3tWtlVePLqSOG73VDgWrcdd?=
 =?us-ascii?Q?T2hWGPTGG2yyIDf73NJH0Gj2JKhJckgWkw4MtkPBLAfaxMFUKZTeBNWPUShd?=
 =?us-ascii?Q?1apP8yUreazkygW6Qyi9NMnagak1LjmMf9jRw4A2ymyHCBrsGXn4e0CxrsQQ?=
 =?us-ascii?Q?Jr1f80wBAgYJGh7ewMSD3rAWtfKh/nMw4WJdQIsV7xLgDdWqXJy7yrr6gb1O?=
 =?us-ascii?Q?eQvFxldwf2oLux3L5n1i12fDyVDUWahiXfSuTJ9uwbVvysM1sdOlbaLcZ666?=
 =?us-ascii?Q?cGioPDORUNpg4e7NDWuFeo+gvVP3jUJRSNVBjwCZ/gex2jvH5FVW1KB2XqZD?=
 =?us-ascii?Q?Ut60+9BDIVUKo3//14AdoFUJ1+re0t+bdOSj6XV8WtnTScvZoienR8fV40g1?=
 =?us-ascii?Q?XfwNFwG2Bq4xdlpbWexy0xgi7MwzbBvSysB9vQa31liBvV3DpA5fNZ7xw6Bl?=
 =?us-ascii?Q?o23TuRXtSKHRJTVAeJjf6zc0Q3AytiybaaQLw9JyiJnjzjJjJkHZuluEfk/t?=
 =?us-ascii?Q?rqCv6MYhcM3i/p49p0j3VHZ5BzouUOtpHiYGF7uxvjXlknI/k+uNSdTdvirU?=
 =?us-ascii?Q?ugqHugFBMiHXBg18GaG6pX6NwZAwA0K9QKyhvsVV4RKdnFp3h0xuNDeWqcHU?=
 =?us-ascii?Q?F5yjHOQ3cizon8EibNMr5wAt0TBnV89hV2jrHCDTm76ZgU5C+W6bNmCraHE6?=
 =?us-ascii?Q?ntRu4TXMAU5UG4u/pOHigcKARHx4uE1GQI8B5Ar4H0ZdYNItK8SDw73XCvkk?=
 =?us-ascii?Q?gsAxdPQZdeSI7n7IOxQTlQ7dXSgMWbrlIwBluDaxDtGkI4o2QkYkAXNtcV0w?=
 =?us-ascii?Q?8mld+XbJMya01Yq2sV/TfSq7yPsj/u0ofPFMwrrSr1I24stdcYgscNDmkzR3?=
 =?us-ascii?Q?VUlkGAvT4mrAQrWbBN3WlDLFu9Q/cCumsaUiM0DEXQgI9JdYsPjQ66S3zo8S?=
 =?us-ascii?Q?2CLx1/4RDihirJSe3ZTAyossuHAJeqe9vuCj+Hlu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9fdda53-e940-48c7-3501-08dbcc48d6e5
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2023 00:02:21.9229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QN6kfDFpTPCu64omGZz5XV93Oh62M3/PzSysDSHta7y/jzPn3Zs03KAkbSlFW5We
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5339
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 13, 2023 at 03:51:34PM -0600, Alex Williamson wrote:

> I think Jason is describing this would eventually be in a built-in
> portion of IOMMUFD, but I think currently that built-in portion is
> IOMMU.  So until we have this IOMMUFD_DRIVER that enables that built-in
> portion, it seems unnecessarily disruptive to make VFIO select IOMMUFD
> to get this iova bitmap support.  Thanks,

Right, I'm saying Joao may as well make IOMMUFD_DRIVER right now for
this

Jason
