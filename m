Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB96C623218
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 19:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiKISLP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 13:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKISLN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 13:11:13 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5C41FF90
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 10:11:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtBQ7cWq3OMA30Ky2RJRmcHNiPn9eQMijsX2m847+Tji++67Zji49IO4ic0sfq9ZMMwpUprxo9hkARgp5GfjyogBT05H4uJRDLN8XLhRDIAXKORR03HdTR39cX8YjZZFHqHftZDptYdW98VZlMNohhyReguZqg/qhD7/1+i9XgwLOieQWUnf/9UUgmFwVlUMpkRVdHdXnolYXwXnTOc4QsR5lRTzw8c1FmkAj/okQqozhAKQQ1ndJmiMw9NF8jYildw1EIdquSoviJe3qt3WZiUQ4s6Gop9ryjwCG7k+zPekQGFCMmeFRtqsrqSApbKj55wClhh84LbMuC4lmJy+Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BytGt4PQbSo5vx7cXToOm6kESpwauZKwiJki//PShnk=;
 b=P+fZ/E/eXhEX+e6U2m5EdoRgAggXjbLHIiLj5p/daF7CipJuVnwcCEuP+AWduJ6yx1B15qdBiflcHosOd7nj5LxEN47t4GWXqP1hTwZE+VisF3cONngkQ3myI/FxD7QE8vUUT2lRu3TAVu7v6IVuH9eZBJJ0uo9S5YbY5GuNkPGKvZsiRtqqipgz5uRI6XWtQHaLF4o15C2qDrLVjaGpqCzlhXXeDVyA5sHLT8CJRTPx7r4UPxMRl2vCNR8YtgQlmCNHy/AOrWV3NQePVJigHnAfnyd9c2cJVOcXTfLV1QN/YV8evNaKUpKwnGVhdcmW8RvJWbvAlf0HN8DDpJvfOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BytGt4PQbSo5vx7cXToOm6kESpwauZKwiJki//PShnk=;
 b=jUlzmqoTgGtHeFJzEoMTsneT9gxAoI5nsvPpjBQTKpY6EHujQ1tb45I9Ij3cTgXR/oWfZ22ot+r0cr4Mebq8k7c8zv1527fesJbt0OOfwZIrg57kfBGSrnuxWlrilOWe5RF8jhIbPkmdXMlF0rfixLXoVcTqqpTgiG6/XeR9vwzFur8Ep5VVwKHI/Yy+jsMqIKVdDSFkoWMqt+Q7UxPjfGdpjmY8qyPXD03Rda/zUlmjzv+J+7VOYDJo+f0YCtHE3XxNz9MmxDEyWCRn2Z964sEmZqGjYhuho24o3z1MV2aiD98pU2zb3CbZtV3faj9gC/iBgHWQChvjjXlgQPzmqg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL0PR12MB4850.namprd12.prod.outlook.com (2603:10b6:208:1c5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Wed, 9 Nov
 2022 18:11:11 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%7]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 18:11:11 +0000
Date:   Wed, 9 Nov 2022 14:11:10 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, kvm@vger.kernel.org,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        shayd@nvidia.com, maorg@nvidia.com, avihaih@nvidia.com,
        cohuck@redhat.com
Subject: Re: [PATCH vfio 06/13] vfio/mlx5: Refactor total_length name and
 usage
Message-ID: <Y2vtPpeNPoED2Crr@nvidia.com>
References: <20221106174630.25909-1-yishaih@nvidia.com>
 <20221106174630.25909-7-yishaih@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221106174630.25909-7-yishaih@nvidia.com>
X-ClientProxiedBy: MN2PR04CA0010.namprd04.prod.outlook.com
 (2603:10b6:208:d4::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL0PR12MB4850:EE_
X-MS-Office365-Filtering-Correlation-Id: 6388eac1-f7d0-43e4-cc79-08dac27dc83b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dD6VrEXqI0+X3tvd+zAcfjrYlmPoCoPo2L4iQB+WhF40aqWQg/cUDQnvPT4F+kQ+bNWWrAC09euGEF6tyZE2nmWhnejhfCCRs4yRRgtmwQ3YTvNQ0O8P0/OoqRa48IaIXxAgShdMWq5M08IDHyDBeQTBpQ+1oSWuTKLJcNoJdWtXUdeOga8UkbeW5Jr4RTnaMuORZK+9Jmg1kCOX9a+vXjE9lYiP71/MV5+J6wKRHVXNm8Xor9vxPEMWWZUOOd6C2aB0qfJe7T/iO6vanLuZwHrMtd3Q0dlTsm/yThub6QHxcDpTBWCCXHb2G55JhVYqABiukPgQdsuTi3AjODveMcOhFAXzFFR6hMB8DnuIMQhTfq07WnEyzqeqcQE8IcvaVhKXTuApYUi5BRtjp57E4mQckm8IhcI2kgA0qJBFSwbrXu+h8C/ZjJNvCjcSzvEQ0XZYom7Q8qGYEsK82pLPS26+0HGlPMKR9GS0j4O/9JCCcaEk5JeZ4rLgpMSf75+uz7NFyxvFHBnDuwNkVrzxDnkKQyHKl+sMFal8Nj8SDq3HZfjFDuzWDc9YiYfJodtyF3heTdYZezs5Tv8FOme5CDHYFwT4FYJvLiVLa4eYeq0MPe4gfFs5zcfEcrLQoMwd3f/S6/jtSjbQKvSBIsyqUvgu8AkQq/dtkybkqEkCV4RPaOmjh2rwdf+VK9FVbOhU5rMxHknfwXM4JdoWa+hdgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(451199015)(316002)(6636002)(2906002)(8676002)(36756003)(66476007)(66556008)(6506007)(37006003)(66946007)(4326008)(6512007)(26005)(186003)(478600001)(2616005)(6486002)(86362001)(38100700002)(8936002)(4744005)(5660300002)(41300700001)(6862004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I8Qd8PfJJKIJtcFA2NjGf8RwAhdaRuzSQoTzeS90W4xwEnzbE6yhT4nqZxxH?=
 =?us-ascii?Q?T8MWN4im4I8TtGIxXPgMScTpgT0Ujwp+SACYMIvIIYhSIjCDrq6Rdz5FXTFd?=
 =?us-ascii?Q?kLI7fHbW1g9wIouD9okxGVX3kONjJpmD0a71G0ok2y342MsVNoHZmK66oOL+?=
 =?us-ascii?Q?qJi/bBi83zQ3tYhTsMvxRo84VCqreF/aHKArwqe+RGprFS/PSyZ4aU0rHY0n?=
 =?us-ascii?Q?tkKvNpmVHgeSlNHh2gHR4DS+rK18hUdUvP7szJoiYJYnjU3KdeIZ0iPzunh+?=
 =?us-ascii?Q?6kpbl/Io8dzK1hZdEy1avO0Q28tv/kL+uJGSlm36iebYXIksAgggaFRrrn73?=
 =?us-ascii?Q?wC2YQa3qTNdQuUJmcYqFXL7qzRNAuH+POYl5pwKEX3Nnf4Ma+KoqZZHb2oKa?=
 =?us-ascii?Q?otIpb5g1hP2aV/G8f0DqQPHfeXqOhjaDZkHDoL4XiCDEKe29nCRgVjCPvu2C?=
 =?us-ascii?Q?G7OzGL+rvqf6xhpf+/Urb9QAowxLAHZYKaZFGIe88dkxjbk9TdVqAenHPCXc?=
 =?us-ascii?Q?wfWzd2Pg0jJwcNCltJts1K7BdhLQ3I2/b7aVgKKgAfLGERXw3aZpZeF+A3Tc?=
 =?us-ascii?Q?sYfRZr8RE8kwwWUwbYKmr5kpo7LtKC3SQqliTqXfyxaWlvTW/ARcsp7GURN6?=
 =?us-ascii?Q?PsNa0khzssNfafLtn+Dm1Og0k6RS4vt5O0JGod19eO6SIvN7SQ8sUMNHFnP/?=
 =?us-ascii?Q?miZC47IGJEEmoj2q3g73xcTFnjoK8yZ1Blekiq7Wcs1C+LBLxmTZZMWRPekf?=
 =?us-ascii?Q?NLfHprglo5uQbsRO0Ptt8QFAMVaAGM/gVNz2D4TEARnhcTjZqpbNaDx94gB4?=
 =?us-ascii?Q?1Nmmth3bWCDiJ5XkqmM9HpfyxITfDjRVID1NGuthx10sZPAqGhX4VeWNHGLv?=
 =?us-ascii?Q?NHvaJv73Xpk5pgnSFUHfyfZToWhRrIy9rkSAHzrxkO2w+G1du0AmqduOIUcT?=
 =?us-ascii?Q?pWrsN4MnMCTDjb+5IawubDT6Or8VTlFY3vSNOkYOLpMaC/P1oG6yCSXEdrIp?=
 =?us-ascii?Q?CPvgG1AUak+GpsgVLhbvFhV7L0YXUceausskg9q5JsKxAaOjXltgO+q4YWQM?=
 =?us-ascii?Q?9dbVGigqdGSyorHjM0OKX0V2n/6GPzOjenrXb1vSAx55RJkl+NgIAmdWuWiY?=
 =?us-ascii?Q?4t6R9FMHOnXxt8/OeOd6nil7/FXgv3p83WhryJZC9NfpkqdxbRXCh4zpXJ03?=
 =?us-ascii?Q?LsLUc+6tvJmYpdDCbrOF7LUB4ZCj3+6Anti4BxFLCQfD8AHvgR3SfJnxb7uP?=
 =?us-ascii?Q?RiQLVAIr22JvlIehwtsQ1PGanYSU6KJ7LEaml/BBzQmfQ7KpGrhZySayqfja?=
 =?us-ascii?Q?fKbJwKnqVLyFu1xBovSeJntSExNahkqKDaCimykuEurXFZhSiVGBB/+0mORD?=
 =?us-ascii?Q?ua+p9me6Ew5FhAauNHmYllv3BFn4hnx4R+eoXngtqYjBK/V+dyw4eYg71sDB?=
 =?us-ascii?Q?s85blch10ww44NtFZ+WsNYhBvppXuoLGL5fk22qO/YKDA8bopR8VOzdZ3gxV?=
 =?us-ascii?Q?KgMTZDdIAcrHlW9PVffNfi5JhKs6Bdw+rmAyAvCANVEXbs6Ayb9mhhFu+JO5?=
 =?us-ascii?Q?EzC/VoNsoXEWAaljzOo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6388eac1-f7d0-43e4-cc79-08dac27dc83b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 18:11:11.4127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8PoQHiL912keqxkYZTjxvG/B2ExUgQVTgTRzHuMSRvUEISQgpABZPQ2EbD8nFWww
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4850
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 06, 2022 at 07:46:23PM +0200, Yishai Hadas wrote:

> @@ -1047,7 +1045,7 @@ static int mlx5vf_alloc_qp_recv_resources(struct mlx5_core_dev *mdev,
>  	if (err)
>  		goto end;
>  
> -	err = _create_mkey(mdev, pdn, NULL, recv_buf, &recv_buf->mkey);
> +	err = _create_mkey(mdev, pdn, NULL, recv_buf, &recv_buf->mkey, 0);

This seems pretty goofy, a 0 length means use the length in the
recv_buf?

Jason
