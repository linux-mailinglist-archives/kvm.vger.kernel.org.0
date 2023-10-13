Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307A07C8BEC
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 19:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjJMRDh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 13:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjJMRDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 13:03:36 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE11095
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 10:03:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cjDnpUp5VcD5hQywT25Jz31VeKyMg+BZi1a1Zn4UPhQzTStorZHhx5TQykLTEWaKv4C9Y/2VqbVbBuV36mqBdq926Coy4jT82u5wSr6474jWbQNK8oeMUd0pjqSSRI1IYuHJcbN16RMVHRE1atbvET6Pbp/BjhT6aRtajMhOjDWW6D+vGm91Gz1/li6+Scs0/wUAZNAFNs/dbLIeXQsrq+9xed8uMCKjsBJoNOIaX67o3Y4aM6zdvMqaUFCfQxjq+uOrewzSwzN2z4yi8Qrvzq/Li5Mmb0msYhA6JRlrWgh9lpauN8bZU2/n8BkIbR3ftw7cnwVfZPhjlvP4LJu50w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TNuW1gJHDfBIsNLzBBdv4DE6t7IzVAsMDQxgZqHBvug=;
 b=DVYg8vmslbnZxSDl367kjGaGCKwZLvQ3pyGw4WIGOw/iMCPsuYUwsSbo8RB2tbWLTxsQ59bZFS998sRHG+ATxU/KRc9hhilByMo0iBGvXdBvEIIuJphk0B5HuiuJ6Q+8wSmde+t08Rz0ZCQua3gOAPOgqw+q1mDLnEGcbv/NohuH9A+MDmo4gtQwcB5qnxEwt6Y8vw29hZ6V01YngUEXmD4RyPEYqDBg3Hbcp+QoiiU0/UUFo9jatNGgkIgSnoa+0rxKtKjHWFzWR4kBQzHAQpZvedmHJZQCHGnosGO8iAiy7bwAtaGhqxHf6lxBj2FAdW0YwKStbmTOU1WPpHpqJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TNuW1gJHDfBIsNLzBBdv4DE6t7IzVAsMDQxgZqHBvug=;
 b=ctTjfzIayaJx+Fc/OAGKKtZner55g6QXRpxp+EpaJM8mxfynDW0Yprr1JAF4Vfdnsw1edc2obBJ4ZmTzGSHp2ZgU04K0qaGpNblJQASut6lr9eMTN9f21bramz8BOBAKvP90oeeantHd5VfzXPgZr/ZgyBC0jQbqqFAS/eUlzlgeoMtp1v4SCNBVpT01Gfhefzry5HQzl2AMV85hTVLBvqEzEDENkUCWQxPfS1OOQGsmbSNeH+leAndKralRqwtNtYb7K867FgDwQQLRICiKK26w3TE412i5Dr/gsXMek7tW7mxIPcK5Ka/KhTf9EAbj7lfZTZbYoybNJyBm5Ll6CA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB7373.namprd12.prod.outlook.com (2603:10b6:510:217::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Fri, 13 Oct
 2023 17:03:32 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.046; Fri, 13 Oct 2023
 17:03:31 +0000
Date:   Fri, 13 Oct 2023 14:03:30 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 10/19] iommufd: Add IOMMU_HWPT_GET_DIRTY_IOVA
Message-ID: <20231013170330.GH3952@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-11-joao.m.martins@oracle.com>
 <20231013162217.GF3952@nvidia.com>
 <f4b5bc41-4a56-4e41-b3a4-1f7c77989d78@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4b5bc41-4a56-4e41-b3a4-1f7c77989d78@oracle.com>
X-ClientProxiedBy: BL1PR13CA0300.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::35) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB7373:EE_
X-MS-Office365-Filtering-Correlation-Id: fec92bc8-1c6a-4435-34ed-08dbcc0e53d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ozVworCXcGl8E7WuzvqOFoJCKXfcVEd3R6uViEYdkXxGxSEt49iaxMEET+ydjXov5YWXgL7IuPrz7/RrzwudJfpdrK6SrxHfdjn3gOS7/2ZFHKBbJUQOdgten9LhpFHjQG65WdfCD12fOIktxuzp3dRpaC2i4/VXVyQmpkSKhoJJWCG/l8TNzDLwW+EhkMJvRdVi1f2KSMzdAZ0/cAlYB4Z3XhVpf5IbXC2ZI8UPvvNCjJI6Qrv5mjkys8ESb/vWjD0g0fILOx3NiZxT72eCsDxWDa5NN/T6TuvLoaPiJsZgmmaAgzWU1VNqVXa8hobuXLHTFWbbMHijf1YDjrJI+cIuj1HEX7zjS8gyC+BsNdfSlAw+Ewx9/AhzmHXVcnP2XKDRW4qRH45RJOcUrqHnuPA5I0fzGF+XIAqi7PJONhmh3OqXsUDyinQODvUg1TJzLHRdezYdBhBUTBy/XEvcPT3q792o3quG8qYvvJna9mjZWIedwmW4D4QGv00RR71MR9W5RLUM57m0KNn5oVx9MVM0QpdZIItzuXn6LfgyLce7F7gqLh359gDawLkW9TWRe8uhEtscspSQIsz01xS9IlARyNEqrRkzSPVtU/AVTs0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(376002)(366004)(136003)(39860400002)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(6512007)(1076003)(2616005)(6486002)(316002)(6916009)(26005)(38100700002)(478600001)(54906003)(66946007)(6506007)(66556008)(66476007)(4326008)(8676002)(5660300002)(86362001)(8936002)(41300700001)(4744005)(2906002)(36756003)(33656002)(7416002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yQPeyE/szqvkiY6G4y4Qm74cTotNnU3GYB9iRPWmfR4sHNMCh6nA3JYNzVQ+?=
 =?us-ascii?Q?VCgqNGom0ir+T/P1UGdMWdYnyuzX5EDQMdEe3tNcDojvCJTUqGGlK6nDb5c2?=
 =?us-ascii?Q?jGJa7Nhf6r/Pv1SXCHKpHhWWN7MXUxW3ktMxu3GBLaOy0d5ghU0hTQW8+4RE?=
 =?us-ascii?Q?YdNoMd7alLX1VxtjywZ1TK8CEz2UEMPBj26FIkUai/ZfYQJUOXbT7HTpCiHa?=
 =?us-ascii?Q?MCq/pc7TUzQSfJTAEJ8UIvXlOlLiE4IiUrnZKOtmWth9T/4C9YkL7WAZ8Up4?=
 =?us-ascii?Q?pUpwRWsr6lGI8vXpfdPWX0v4b8D8PlE4V61DplwJsyGd5wv3SsLJt3DB41W0?=
 =?us-ascii?Q?2xp1GvIVUjgF8x7ir/JBLUqOvFXrcryUvbRn0yFq+ZlOX9/oS3VlVKV/+Sbk?=
 =?us-ascii?Q?hai2ntan7rEHhIU4gCnnZYouLhsJORS41D0RoGbrrooKVm8ArMPhzkZs6q9D?=
 =?us-ascii?Q?DqvqbEJUx69B7X3mOzMiDjU8kq41hnAef12OOI7RvNstP87O+ZaveW51BJ7O?=
 =?us-ascii?Q?Of8CMsC5oGj747qlN7kIAbEPS6JDPEf9HC+4woxO4lR/ZPczT4moKjuVRcFm?=
 =?us-ascii?Q?/nhMy12i1WsYTMkjihRFLktfix3I5TwNkRE+reVapcipCJGk76YiJte1SK/U?=
 =?us-ascii?Q?v7Ac8U6M27iqDkxL2IoYh1wL10pm6T3N0ADReeMikt+tcPjxY5x2jhqsooMC?=
 =?us-ascii?Q?tADAr6glaNCVS7Qt9wUSuwnsoL0z1MBeJrEbx6BgscqHMnPI5h8nI6RTA0tf?=
 =?us-ascii?Q?zB/sOzO8uoaUAaMQX13s4IpvJllSFix/Q4ohBFcN+iO5t0ZtLyddVZOsl5oH?=
 =?us-ascii?Q?npvUPsh/eAJSeINjWYdkXp5LwskjkGvV7sEAG0vIT9vgR2oE2pIY374LKHtM?=
 =?us-ascii?Q?7ZgGFRbpwo6DnM7DS3Zv+K9bToVUk++H94mrmS6zwz9PFdujgXJivcbJ/3JF?=
 =?us-ascii?Q?uoqfDnD1TwFvwYkPz/9j58lNG+RSxcEh5xnsRkDhWGQC449LpL7ZHti/FQIl?=
 =?us-ascii?Q?GMnsO08veQO2atte4+IT5msaZNcuSVIS+aM7G21eb+JiR8FE+LA6/SKPe5A7?=
 =?us-ascii?Q?svvxVhyGFJuPFQ+nb3xbvMPwXU/1NoLuRPrXs91zTFbA46I9AUcGH8tqbEcL?=
 =?us-ascii?Q?iIpA615jlw8eAWEQOO0TmYQbC2oOhuo0KH4n6hm7Tmvf6Z+pcEcLSxaYhE47?=
 =?us-ascii?Q?T67DFhJA+QqKz770NigR/+nUQptzOXHfZNvLe8CYTbbUSQtoLgpYWsHQAUWv?=
 =?us-ascii?Q?fti5D6Q42Y+AUsEIARhwPbGJMYlXTpGBUNEovjA349fmAYr8ssS+zCTlTmWh?=
 =?us-ascii?Q?hoWVuZCFsEwyn3F/IZ0i/VBqSstYKuVh7rSY+gN248OPecBuSIo+4pOiISyZ?=
 =?us-ascii?Q?uy/dCN7+uLYVXZzZoVg7EuJ2Q/h6ZUKN4L+PDNlev+HHW73MOTp5+QO1TvEW?=
 =?us-ascii?Q?B9/aqxelsJOyl0dBegqYCzO6II3mrPZvNIVikvwGdlAWwfEY0Jfojj7CpucP?=
 =?us-ascii?Q?xx3uo/QDkMY7KpW4A/xZyqyy7cq6yEAKR2PS8wJGTKOhWfqJy9eyHj5cRm+0?=
 =?us-ascii?Q?Elcy0QI3hnYW2+C4DLeOuhyB4dD0sPNyKi4mL4dw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fec92bc8-1c6a-4435-34ed-08dbcc0e53d1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 17:03:31.1976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zAeuSc7xBunYH+CC43jLzsH1UqL+3V5mzdaVxqHoRNOL1jN0NGKGyp0wnsS/4G92
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7373
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 13, 2023 at 05:58:43PM +0100, Joao Martins wrote:
> > I can sort of see restricting the start/stop iova

> There's no fundamental reason to restricting it; I am probably just too obsessed
> with making the most granular tracking, but I shouldn't restrict the user to
> track at some other page granularity

I would not restrict it, it makes the ABI less compatbile if you restrict
it.


> > I see you are passing it around the internal API, but that could
> > easily pass the whole command too
> 
> I use it for the read_and_clear_dirty_data (and it's input validation). Kinda
> weird to do:
> 
> 	iommu_read_and_clear(domain, flags, cmd)
> 
> Considering none of those functions pass command data around. If you prefer with
> passing the whole command then I can go at it;

Compared to adding some weirdness to the uapi header, I would prefer
weirdness in the internal code

Jason
