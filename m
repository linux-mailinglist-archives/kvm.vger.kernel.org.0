Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F21660248
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 15:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235167AbjAFOdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 09:33:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235045AbjAFOdD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 09:33:03 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2069.outbound.protection.outlook.com [40.107.94.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7FA80ADC
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 06:32:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CLanhUV4vxEDYUMTNcEpunKnt74NQCnyur+aWBfZo0T26E6JSAY4/DGpCM1DzpCDxf8g6FsyWSXx64rnDnYliaV8yT1fWNEiJ2SPm6ApdXStopkj6P+ICzsiO5MyYk2kADsTD6rIbz/bvaXkNZKIZKWPMxBZm48gj0iEvijFwmy7vKBO7Cf0H97op5zihceCBCpx8hIZ2YplggriqqwQrvnvQQuJkkR8B/vHBwbDvZo3QscoElGVvK5jORu5/B1S7SYM/sAdL/D1CGPsPfh910Ri86slUW1Yz49OtjdQmsTyeme6rg1zyutpH6oxcFHQ1JTso9xJG3RB+duCXDg+Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t2ip+AUrhjq6/NEV7b170qlUPHutWbZXcAj78Lu8G8g=;
 b=DOHWp43esdRQWP5uO9uJizEs6Bdp7Io4TYitRUAIBEcz7kDmnvg0hbhKTqZQWs9AZOTF0g02osLLdOhmSFvzAREssFezakSoB3zTlQDknHVQ+SC7xz4FJTtigUKsyJqlgN7YX11UT9JR4BhGXhHx6xb/tdKNo7eAuACjZ/aU7ZII4RlmBiAWkWQrg8qo8BZRy5roQrMAfSdDE/HdUh0sdOt8ex7BMbUX/WxKdMHuBJQJ8JosbqfIfUjJJ/exWvdCVArWAiFAXnTnsrD7T0RxEye1FxFs5S2d3lwgZB1l9nLw5KkwGnSt5emgOyRI1SDU6i0a/dzj+bjrveKcFlX4pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t2ip+AUrhjq6/NEV7b170qlUPHutWbZXcAj78Lu8G8g=;
 b=i1EF8nLgWkwaTl+LZ9Qfhmr940dj3HTzVMq7EkIk5BmfoGZv9otRryR9ZmvC6fiT4DXEBfkVdhYBe6uGyt1AmJGS9xXub8SgcTFI9ibmY1QU9hQOr1K9UjNz1+YCY8zisCh5EQJMSDjdhw2H7JtaLI2UGzQOQWJ23VDjKE6aavbHcyseLVlU6fvAqtzRMiIR0braqgfkthOdDJjfTZZJvYqMN2mZ50LPK5QbHDJAUHHoDSu5AjOR4F9u9g9YbeVGFk0oQZs7/6sIaHyXtodnC59McyUSKQI+Y9F9g4Ej77DChoy/d1KOwMDWY/HCimk8HyovjGs1J9j2wp+rg6KvQA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB6939.namprd12.prod.outlook.com (2603:10b6:510:1be::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 14:32:44 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 14:32:44 +0000
Date:   Fri, 6 Jan 2023 10:32:43 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        cohuck@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com
Subject: Re: [RFC 05/12] kvm/vfio: Accept vfio device file from userspace
Message-ID: <Y7gxC/am09Cr885J@nvidia.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-6-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219084718.9342-6-yi.l.liu@intel.com>
X-ClientProxiedBy: BLAPR03CA0161.namprd03.prod.outlook.com
 (2603:10b6:208:32f::8) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB6939:EE_
X-MS-Office365-Filtering-Correlation-Id: bdabceed-0c0c-4fb6-a133-08daeff2dfa4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FipLG4oX7qsbAEz99uj6FLQp7KBCgoiNk0CfJDIIoMLFxhUxez25cd4cE7yS6gmtVi81/BsJ79XqPMbeGY3f4FbUUu0TAEUjB61fhF+sNVrJMRkZ+bM4TlXrrf7J9GvYPqhndbUyKMcpSbfz5ifK+rDiireIQfq8Gi5Cd94lhYMb1zfnHTsNeeio5FfXqQnBTUptYlZhqvCI7Aqfc/wKK4/lqMEIx0fi9FoM9tCzvmxjEnE+bt/Uv2yEo/jcunmWnEoDpbFPPDOc/oQ3B/m3tFJW3BrMsrx4BbV6zS4Wi3oFJYcSgTfF106tI8mEl4sqmwjtj4IOo0NwUSmeZRJbzvMPm9K4dHzZJ/TSCpp28RwUPnfVWM3SGSRIssr7sUf4G5YPcSZpbPlpCVlv/JtVR++AuG7ZzzfK6fCEMCIEA/MO3bMlOk5J3LlRRyjGj8xlblJoChWU7AOD7Qbfhgz9OmGFFwOmcrv6UOmPRAvp2TpEXU9kxnniJWcwwW+BtgUDmsaN7tgsTBGpJ2IhKDnv8PSKFcd/3qb7OUkmdli0HtU4eySvIf3Ukz6Py0Z4gSGuBZq9lJlwmBT3u1s9x16LXlwbImp9uv/nTpaasMc8PgCFtEWqtZyobntzHwDg3l68nWqE4YqmxBsknUtZhOrnLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(396003)(136003)(346002)(376002)(451199015)(26005)(186003)(86362001)(6512007)(5660300002)(4326008)(8936002)(8676002)(7416002)(83380400001)(66556008)(66476007)(66946007)(4744005)(2616005)(36756003)(478600001)(6916009)(41300700001)(316002)(6506007)(6486002)(2906002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nxGAeUMDonIcUUtKep3M9ijmqd8Gvvdi+gERnSaVvPLzPyYwCoIL9JNtk9as?=
 =?us-ascii?Q?MsZIaecprN2/snbq/xnV6FPTjaHWnBi3HL0DiEGkSClsnwLfpJuD5WfX6ANh?=
 =?us-ascii?Q?DmlkcqeAKyIfoNlL3+of7sBcwM0t/ONvP50RmF/+lVoClul+hLtTkCAkI0Ag?=
 =?us-ascii?Q?zKuhHoG2rNYNuNLezg7ozrI6/nlct3fDf0zmbOBuYrPdc8rQtJ7lc/3/iMa2?=
 =?us-ascii?Q?vL0XvAjjzQso+GN9B74K+ULv7Wzr69tBtcJm3+fgkL20lH5mbrZRSj5Jo7X0?=
 =?us-ascii?Q?ABvzTGmVbqbhS8pJTWU8p1GwSgLY1qWdb3UMECuJHBYr6KGw4Rp3FOtlZSWI?=
 =?us-ascii?Q?8AirkcZDm6qZh8LpqXhW2BYwcfbEzWZsGBBaMAoNft3iLQGIxmx501YVpuhs?=
 =?us-ascii?Q?+Tt6ts0djXLwFgvvC3C/snVomU4enQVxGdkRwSAgQqu3g/tB7tSWFaQv1vtV?=
 =?us-ascii?Q?4rU0hza2kT1Y7wnPfjujPkJq464GMVLLo0aipC7kC3bf7PKrrqvSR92v444p?=
 =?us-ascii?Q?r4yg/KY0KMxZffDHKSqZKTbL9DrOq7zmWIpbMlQOLF0Rzi/v1RTu9s48rBxs?=
 =?us-ascii?Q?nROkCriEl3o3RiL675jBwFv4T1uI0lyARSxYkCBksR+ePuVRnm2SBwqfglri?=
 =?us-ascii?Q?iqXHLAuZj9lR/RRNDsrYXW27LImam7r3WP3XhYwKNNoS6MoiKScqc53oTW6+?=
 =?us-ascii?Q?Aml2ZF7A2gXdijRmSOMnU4UMmHK04zggLSKkX+Oye87EI94qIRcgZRvSoXSB?=
 =?us-ascii?Q?np1n3alV0TgzcWDWwGjORVE5zjhQLyAAdmIY2URe7WgFSQEC84gCvil0s5YY?=
 =?us-ascii?Q?7AkoDZqnop6nj+iZ4FTL/CSDmisgEdjMo17ZKei/U18famhvJvfxmhiwogzN?=
 =?us-ascii?Q?3VobAq1dy3J8AdGrmX3usy1q2IpPk3TAmTq1Pts3bG6IfjWp18XwMzS42VD3?=
 =?us-ascii?Q?5h8DjIoatCFrqWr0osQwOzdQbnQh8SsW1BfPi7mGYILOkvFOoaPn8jK2Fz/y?=
 =?us-ascii?Q?fxvtD85D1rzzD0QCZ1QM+PiTzGO7igUc6MFUIMl8TRcr/nofXds+pnd5Tf5J?=
 =?us-ascii?Q?e7Hx6RvDfPQxXu6Su1jrdFX4mkbKAiJcze73Rp0DjfhcNVgT4JvF+sed+6v9?=
 =?us-ascii?Q?aGPGRMUWyhtxgKpvnswlqwWcUGmtHObP/fooMfysQWC2D/oR6M8w7pIdB9Zb?=
 =?us-ascii?Q?ph8e84Sik4CYwfD+1uh+zFwHLAJQ8XDDqd+jB+00zqz+4Rpyb+Jfdcjgnv6G?=
 =?us-ascii?Q?G4bfGsQPHi/pPjOOiEmi3h8qiHLFEvw5q/HtM8dJBVNzQX6E033ArZSr9WHa?=
 =?us-ascii?Q?9ZKnxZIhrYbXMTmnuY6mXIQqiKJwvPVA1VHtaevlYWwwHNQiFJa/zAUmCOLV?=
 =?us-ascii?Q?JtWeOCW9Lso7m2tGeUQkGZQPadsoAmStihDaNGpQnAwNDSydQ4hC6+Hryft6?=
 =?us-ascii?Q?gOccEV66k48ZAlY7JFuNoC9JiPQYJPdagORvdBchSx2ttBEXg6NNljaA7cK6?=
 =?us-ascii?Q?kVrvKn00HiOGf0lW3b07kBh4hqI8s0VtdHoFdSf0PUgyc1sM/ROUmVYPMOCR?=
 =?us-ascii?Q?nhXOOhsmZ+cvgiqBDhM0P44viKZOCfYzKEmFy8Pj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdabceed-0c0c-4fb6-a133-08daeff2dfa4
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 14:32:44.1453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: owU7leAk49X37ko+O9d+XDEf//Szy9PJqO920AQwEzPFmHmdr9ODlf+/0e22C5mn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6939
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 19, 2022 at 12:47:11AM -0800, Yi Liu wrote:
> This defines KVM_DEV_VFIO_FILE* and make alias with KVM_DEV_VFIO_GROUP*.
> Old userspace uses KVM_DEV_VFIO_GROUP* works as well.

Do we have a circular refcount problem with this plan?

The kvm will hold a ref on the vfio device struct file

Once the vfio device struct file reaches open_device we will hold a
ref on the kvm

At this point if both kvm and vfio device FDs are closed will the
kernel clean it up or does it leak because they both ref each other?

Please test to confirm..

Jason
