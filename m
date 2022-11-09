Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0083D6232A3
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 19:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiKISir (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 13:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiKISip (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 13:38:45 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2051.outbound.protection.outlook.com [40.107.223.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87051F036
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 10:38:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7+W5wbk0/F0sQ+SMWU3aOtE2lvoebBgLGJ5qVgfBYONI+5Hl3cH+/qSfAnUTqGrPmdtlIrqNlM2KhFiECvt56RFvJMMtjv3pcTD0Gygp24lFnuGKZPpKAJppT/9tkksufERsruv0Ie+lJ3IXlcwkAMZUPcb9NcYOZb4YSEpnynK84BI1K3BbmxKpr3xM61Pa97xn1Vy6sjCmKexZJ4IwFBRC/9sSkZ14hsOLw4N3O7PSpzUmN1C/QwYXqlVZCiu170MDWMdUqUJGVs4Jo1GEhw5tkX8DCCcX5JokSLlrjMqDq0bvb7CnLqe+NBs+TsZuv6udQyXficLDlaB6qSBAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dJbQ0gc4VG5tLu1GszOIabJwE8Zd5sfNuDy9FRFN6Tc=;
 b=Fzrg+5ghPHXMEPVL0O/BqXuZL/lUvaljPNkD+eer5DFDWz3xGSdPPIXgw2vcrQKXcPJXa67eOWneYiPGmZveqoNWK1FPWKGVxN5JBurN5S7n6yIa4reTFJyoPhEMeHwIaSmQ5R/a9aOv46UrWSplPySQJCgCdIkkHN1aAIqz/2700iswrapNBO1WF2Ou7iV/eBJztChJiGw68JQMZPq7xyPGNOHdcgOde3KPf3GK4djd0EmNJcNigXLqemAPSy2K085BPhiXNuhHYUJTUe52qVgf7CjpwNzDW4dxTGZheuusM6DhAB7YzOBq2T2VvnpPdidzUJdGMPIOqrwaVIrd5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dJbQ0gc4VG5tLu1GszOIabJwE8Zd5sfNuDy9FRFN6Tc=;
 b=VsXD8Ot0umyxHfJPvoM53cIQDb/DgbY2qmCoREuK2fi2kHdjfVDt5bzVvgqPyCn8ZxuFl5HKClzuIIuE2VWqhSbhVGD7Gz76d08ZMrcq/4xcxKuOmE0FkUpd73e2BQ1SkS/vmIMhmA2WSvXwnao9Ei5Cq5Ajlqfw846cH5LJbHg73H6sFSCnOg3kO+s65eBCD5CBeqiqv9iN8Z2SKp64vGrB+sf6BknnMvh3Uj4rYc3ovT/E1XoUnTx2jKaR3GY6Uvrfh0byL+o4AdPow2K+JU6UGMemAgo6kW335vROnqCpDWy0oeAmi0wyp9nG5r9hEsWlo60pUlBV53p/oZWcgQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6601.namprd12.prod.outlook.com (2603:10b6:208:3a3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Wed, 9 Nov
 2022 18:38:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%7]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 18:38:42 +0000
Date:   Wed, 9 Nov 2022 14:38:41 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, kvm@vger.kernel.org,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        shayd@nvidia.com, maorg@nvidia.com, avihaih@nvidia.com,
        cohuck@redhat.com
Subject: Re: [PATCH vfio 10/13] vfio/mlx5: Introduce SW headers for migration
 states
Message-ID: <Y2vzseOPAX2s4SmN@nvidia.com>
References: <20221106174630.25909-1-yishaih@nvidia.com>
 <20221106174630.25909-11-yishaih@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221106174630.25909-11-yishaih@nvidia.com>
X-ClientProxiedBy: MN2PR14CA0005.namprd14.prod.outlook.com
 (2603:10b6:208:23e::10) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6601:EE_
X-MS-Office365-Filtering-Correlation-Id: 2784a501-21d0-49b7-500a-08dac281a058
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n4Dxv+itiDnqRItAhoNvreLuxVDREGEIsDSC2p7Y+YUyR49luYa1m09PXjutxNTpTJ0QQdMBTnVcqSYDcmxWqK0eMlCzm3z+Lf/SnvFjxd0rIiRf9knvj4IPfxQHw6UsDojtfVHT5gBbjvu6uliul4Mcft6xibc/XL+7ndBtX6xtNdl+0AFctWPLB96mJZmT+pvPKPmBlYBZVXvbFT/iFXCJTVn1C+dUM/asRv+AkrZpp+LH5quX/BuVZMQ9LVv2vMQppgEeDClWJMBMGuBpJwNe5SrmApHcJMX9OnE0Jg2gkembBhtItEbg5qKYesnXIDgaiuMitfFp9pMk3lE7k1YbLr2HabHW5FHfj6RKyT9Q9ozB56rXbTgqXrlW3pE1lCFiqvpsLBx8dO/dvQoNIkJl/L7KtAwmPb5lsfPBBjksHYtBIJgE+FyrgSRFXPOS1DZJ6K2/mjxcKqTuwIL5KBwDM7vEuueTiQOcW+Y2fDJoXjRAnAu56EYl6fx5T/2WCbd3agHzRccgdbdTdwxsIXg/UXU5+wgn+luf14uAD4h+gAhOxVRBPfLeZYRW434Rwga2fFr42sSCR0W9KgxWxJvkNf0viV7Rr56AboOX5sf7x/G8/pQG9a/fBC9iT+hE1vyeBZ+qRIpbQCnX2vyz8opjANbh034QUunRDpJJKBKHnju+MDsQHGySUxwUIICYPqqAF4L1u+6lA54zsGp3nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(376002)(136003)(39860400002)(396003)(451199015)(66556008)(36756003)(66476007)(4326008)(2616005)(316002)(38100700002)(66946007)(186003)(37006003)(8676002)(6636002)(6862004)(2906002)(41300700001)(5660300002)(8936002)(26005)(6506007)(6512007)(86362001)(83380400001)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6GRKvUKKJmsmlK4WUsSPtolFH/Vm3tVJSm+6Zurgfsusm2jjGrlfuceJIPfp?=
 =?us-ascii?Q?CvYZ5ycXiz9kG64BIYqULa84GDomrjWj2ACu/7cpS7rJAbMiWaXAyAz0WtE2?=
 =?us-ascii?Q?EaRxwWhaTrImBzrgJqTwcaj5f172sM/pADuyeQ79QkvA+q5lsyRzEVBKUpPb?=
 =?us-ascii?Q?XSA6KaPz5sX4FcmMAyJXv0hPbO1bE84LBip3yiKA8NVdApskqn8ai1uoR5JW?=
 =?us-ascii?Q?PEmaGwWmpO8CWo1UyRY9JEXnwUAzCibnIETgoITnFsZsxpHGIEp43waM3SHs?=
 =?us-ascii?Q?nwHiypQjcD0qGaLyUykxJpazHO5MWtxXTjr4WM7z1XmEImArVY/z13x9ozv2?=
 =?us-ascii?Q?exWdle5WvfMd42W6nYCCZ2eSX2ZTGmLbzrJK8IbHjLXFgE2ksWOh41sr3rdJ?=
 =?us-ascii?Q?Wbts1glUmi/tV6Kd0pRkVDFKRcj2tVP/SSUiDbB3Xp+oz/OuCpAfmf5SWfV9?=
 =?us-ascii?Q?wGyuFCbMtGi9MZr0ZbaWVvigpo9jTp9eQPzLGThlupj61LKZC5CGlXvHWMbm?=
 =?us-ascii?Q?Nykhnb6A5Ye9F7Ob9nthclhlIG+zzU8hQ6D226ke2fs1BjlfydzB4jP60X42?=
 =?us-ascii?Q?Yp9ouAaXQlWOrP4n+Rl6uCSJlJ5kdj3gAneLUEJqbxHwkPdGtlEXmMWHWug3?=
 =?us-ascii?Q?MbL8v+ClI8RiPGNzDNhV5byozE+8P7dnj7oB4o75B6Jj51vxG1TU+nhJ2dv9?=
 =?us-ascii?Q?chlctXOsnymSvesDRggSjxeib2gMFOrAAPHnkXpI6uId345HBN5q1fp4LFug?=
 =?us-ascii?Q?PE0wKoTkLHF3saVwMS/gh/44vz2WqC+Ks5pQ90ZsXtMaaVV7BE2z4imJ6g/r?=
 =?us-ascii?Q?lasT64ia1yoVZYkuBJE5hzmtyQGEHmJiS2cg0uhqxlY6uLjJpbb49a7d8I7E?=
 =?us-ascii?Q?jyGsrPI65fbYLSOnQfTrNT/KseNrxlTJKpz/bcJpyOlIltsMsob2aWvjCQeU?=
 =?us-ascii?Q?gRxdos8NFsh7ognBaZXkbwl5CGHhXt0dqo+8NCUzcdRwWpKk8Fs1yFRQIuiY?=
 =?us-ascii?Q?TYPYleIZ7VsVWNDlXnYeWx0WRx3oJVz0O9VVTl9fqOzZydG0ysOrsa5YxsDq?=
 =?us-ascii?Q?+Ss7BnAHElcvyB/yQSEtZM3IGSKi7pNbrpx0HHAloSIj/Sj0sJIjISrAExpa?=
 =?us-ascii?Q?Dlz+K/sYQxyPz/fLShYyXXa+hfmBR6QrZOmOzwbJdQD8G5IkALXCfa6xjIHQ?=
 =?us-ascii?Q?MKPdlyx0BqirB70Zi2FV83dJzZMqwIKZWMECEnXC3CVTfJmzB8cmlctMzC0k?=
 =?us-ascii?Q?zbls4Z3HwXWraoEUM4Ni+DgXB+EwUQGHkzJNJTYEyhNGX4k1h6+hWPNsQYKC?=
 =?us-ascii?Q?Ea1p055LKEmiP6yP6pa+O2TwdNBXCNfy/FQWng6PU5yXyYw23Jxi2dSMv+c0?=
 =?us-ascii?Q?eWC0miQzZGu7VlHdwk2gylHoDEz9BoprmvqSEuCH5D+e4M44PJyxA3Ha7lwO?=
 =?us-ascii?Q?+K3Z095zYvzqJ0sbSrYPim+CQedzCjXEw89Bswex9FVYKsAs1bksklnD8pt6?=
 =?us-ascii?Q?OjIEUqldDQJ0xwNvBu6LmvFUiBg9wwhOxLetfnuhun8TceBBbdrjUmLphUdw?=
 =?us-ascii?Q?2a/2Eib3gl0fsM0A8Jw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2784a501-21d0-49b7-500a-08dac281a058
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 18:38:42.5089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RSxgRk29aJXEvY/eyJjpXegmxkDvURI95RTVoZssRvyJjb6e84LvTYdx7oSAowka
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6601
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 06, 2022 at 07:46:27PM +0200, Yishai Hadas wrote:
> From: Shay Drory <shayd@nvidia.com>
> 
> As mentioned in the previous patches, mlx5 is transferring multiple
> states when the PRE_COPY protocol is used. This states mechanism
> requires the target VM to know the states' size in order to execute
> multiple loads.
> Therefore, add SW header, with the needed information, for each saved
> state the source VM is transferring to the target VM.
> 
> This patch implements the source VM handling of the headers, following
> patch will implement the target VM handling of the headers.
> 
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/pci/mlx5/cmd.h  |  7 +++++
>  drivers/vfio/pci/mlx5/main.c | 50 +++++++++++++++++++++++++++++++++---
>  2 files changed, 54 insertions(+), 3 deletions(-)

This seems very awkwardly done. If you are going to string together
sg_tables, then just do that consistently. Put the header into its own
small sg_table as well and have a simple queue of sg_table/starting
offset/length chunks to let read figure out on its own. When you start
new stuff you stick it to the back of the queue. eg when you get the
incremental stick on two sg_tables to the queue. when you get to the
final stick on the final sg_table to the back of the queue. Whatever
has or hasn't happened just works out naturally.

There are too many special cases trying to figure out which chunk is
the right chunk.

>  #define MIGF_TOTAL_DATA(migf) \
> -	(migf->table_start_pos + migf->image_length + migf->final_length)
> +	(migf->table_start_pos + migf->image_length + migf->final_length + \
> +	 migf->sw_headers_bytes_sent)

And make all these macros static inline functions in all the patches -
they don't even have proper argument bracketing..

> +static void mlx5vf_send_sw_header(struct mlx5_vf_migration_file *migf,
> +				  loff_t *pos, char __user **buf, size_t *len,
> +				  ssize_t *done)
> +{
> +	struct mlx5_vf_migration_header header = {};
> +	size_t header_size = sizeof(header);
> +	void *header_buf = &header;
> +	size_t size_to_transfer;
> +
> +	if (*pos >= mlx5vf_final_table_start_pos(migf))
> +		header.image_size = migf->final_length;
> +	else
> +		header.image_size = migf->image_length;
> +
> +	size_to_transfer = header_size -
> +			   (migf->sw_headers_bytes_sent % header_size);
> +	size_to_transfer = min_t(size_t, size_to_transfer, *len);
> +	header_buf += header_size - size_to_transfer;
> +	if (copy_to_user(*buf, header_buf, size_to_transfer)) {
> +		*done = -EFAULT;

A function that has errors should return a value, not something like
this..

Jason
