Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE5C793BC8
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 13:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbjIFLvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 07:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjIFLvf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 07:51:35 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A980A199;
        Wed,  6 Sep 2023 04:51:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CsOLvJzA6PrttPqt/lr0F9e7vaWglse+Al5S2Cw7KDORua/1fzR3y3zt2yQuCB8M4p8vuWRF63vVy5UlSMtAcQEraWV1naQ13LAZD7Ln8Y/8hJbfsCtS9EU8eZwpLmyLBoXYXtkeQOkRDk1o5r89xDNQZxTK4Q7fqwqoctDoCFjpojyzbPpvlZPSA+6IG4/5oPs+Pep1L7si8db8LbHzMXpGLcG8qYK1xYCgk0aea2wwKJeDd8AFf74LL6QQzmTqx0tHHvVXrB1BpvGHBQSkiys9W3e3Oxe+5+HXr7uQkpZMBBmw7lAGTddZn4aIO7358hGWSGq8/RyUknsWU8Jjug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fhX9WRZRrtqKghTCnZT5/KVmU51XMJKs6wbAn2PNJ3c=;
 b=i71kOBQeNlrbdPmvqAPYcXWbT29qWzR+2qwphQ4BB159H8DppRCUNQaGg8/rQC3lpaKwBHTZorTUsyuOGhAjcx3YgpWBdk8PfU3TUPznbHUTROoQKGVkm0uZjlLI6ay5Jo4nhwyyYyKp/i9PlI7VaMOFv1atf2F4roOZrjSQLe42xzPXfORwV00z5rl1/ojphZnitG50SjT/K+i6dc0wSUIUSQbt9hN4nh/4q2oo4gnyFbYahbEjP8N1McMoIZfNaU5neQfdbhUyxUwBoLLIKnMB47u+e/7r8H54Yc5oRTxKwoo8kpkqhFeILvMiSEBaU3UzNdHfcGpEpKbYvdNm7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fhX9WRZRrtqKghTCnZT5/KVmU51XMJKs6wbAn2PNJ3c=;
 b=fD7m5cKxC2LAbkPl+e7dAzq8PDvrHQSIuARDMrXOfPVcz1LHPF5/wFQUhj6ouqZhRRQfxzeKJ01jpCpd0dJxPMQgTQ/2bq8cNmhIaCBLHy6zMY1nc8fIutyHsm3GxxywtHsQ80cZvzSaLTprP/4OM7xVLULZ6vhgfZgLFfD3jMIpmZbcB2JLK+F+petaLR82sUzeEapAFV6zN8tgvuxIvNAJY7sGbZ35zL08ZdTa9sWmvxga5WJb9ZRdo7/9I6ecNHWA0d5wYEBgtlEeGJEuaq3ARKz0iTfx5buNaEeRcg0E2T68bdwqdpuVsQAhkKnVvvFzia1Bergzeo44xtfbrA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS7PR12MB5717.namprd12.prod.outlook.com (2603:10b6:8:70::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34; Wed, 6 Sep
 2023 11:51:29 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%5]) with mapi id 15.20.6745.035; Wed, 6 Sep 2023
 11:51:29 +0000
Date:   Wed, 6 Sep 2023 08:51:26 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        saeedm@nvidia.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, kevin.tian@intel.com, joao.m.martins@oracle.com,
        leonro@nvidia.com, maorg@nvidia.com, cohuck@redhat.com,
        'Avihai Horon' <avihaih@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH V7 vfio 07/10] vfio/mlx5: Create and destroy page tracker
 object
Message-ID: <ZPhnvqmvdeBMzafd@nvidia.com>
References: <20220908183448.195262-1-yishaih@nvidia.com>
 <20220908183448.195262-8-yishaih@nvidia.com>
 <9a4ddb8c-a48a-67b0-b8ad-428ee936454e@kaod.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9a4ddb8c-a48a-67b0-b8ad-428ee936454e@kaod.org>
X-ClientProxiedBy: SJ0PR05CA0207.namprd05.prod.outlook.com
 (2603:10b6:a03:330::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS7PR12MB5717:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d50e76f-a97a-4d32-ad1a-08dbaecf9b83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h6k98Z0YrsVvUExH02WTWt/RfnE+S0qu12GWBl9NneTxeHA9Dluxa8comtbvt0dPJ4Kgyk2D69MUiOU7pznuGrk7x0AmWj4YoXfY3gAcsXHM8YM7Fj8CGWghwpi/B3ui2hiPusqZrETcyHkQP52wmX9C3FYCgXcuByfqbi9YeT7PM40938GBqAwzaH/CjeYDg8xXG3IXqO/FtULBysowP6of6GVx6RX1l6xijXfIdBsfU/a9dNNf7Lksb/0axJwfLrpnzO+GbfAQF6wZmgbV3NEchUlVmblLS7qsPuuAlh8Th8o1/dh37G9n9BCBOr3crLJi/AmqInRjZQ/c3tGGHQk07BpuFZapEf2GOzHonee7EfZhB7bThlE/9L1dtwpY1NaAI2UkbwoPQcgZgKL0SfSYQJDxCitQpqlc2Nff7WJUydJ4MtRsHuzYzRBMHyMKZo4+5U1G8HOGCcrwBche9/txaV/usoPFQ8At3UVgCbtb5jPoqwDh2R8x8SyAO8XgVLnKV7S9LEGIqD7vMNcRjufVMYMJzGCRBcgJi4i0nsl+UtJjvQNkcP0ntuc0bnlY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(136003)(396003)(366004)(39860400002)(1800799009)(186009)(451199024)(8936002)(8676002)(4326008)(66574015)(83380400001)(478600001)(66556008)(66946007)(66476007)(6916009)(54906003)(6512007)(2616005)(26005)(107886003)(6486002)(6506007)(6666004)(41300700001)(2906002)(316002)(38100700002)(5660300002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bzgyUUI1a0Z5T29IWjZQM2RkTExWT2Y1dkVDMXliT2NXOTJNQS9oTkNrc3FM?=
 =?utf-8?B?SUZTSUowUThuSmtaaDdtSmk4YUhEYW9uWjhlcnhqTDFNS3M5QzZsaFcxRmZr?=
 =?utf-8?B?ajZvOHEvWnZCaWJUcnNIbG1IUldzbHpTNysyWXp0REVDa2hVRUJDRHZMN0Jp?=
 =?utf-8?B?R2EvVWZUUk1pSXFFRjhET1F4ekNGbHNaTzdZc3FTZjJYRkxnSVBEdCs4c21C?=
 =?utf-8?B?V2VMYVB0eVVUeDU4dXZmOU5HRlFRM0o1TVp1QldlSnkvR3Z3bENYVnNaVEVR?=
 =?utf-8?B?aFcxdExVcldYNGNwVXpHdG1FbXNoblJwQTV3cDgyem02UWR4cjdEMFk0WHdZ?=
 =?utf-8?B?K2YyM2ZJMVg2NVhhM2J3VGp1blJqRTVscXhNVEtKb0s2bWFqSkhYblhqL1RH?=
 =?utf-8?B?Yy8xcnY1RmF4TnBTanQxbFY2R0VMbjAxaWNKMy9RQ2M3K1VBcTM5UE5lK0Zk?=
 =?utf-8?B?eU5pNXVGNS84djB2WXI2TFZWa29ZelhxVGhOVlJWdEJOMk0zTUlDbjlaa3BS?=
 =?utf-8?B?K2VUb0tiOVkzdkRYcGJjNzNQMkFxMkYyc0ZLSEg1ZHJTNjhvNUw1NEVIVG52?=
 =?utf-8?B?ZGJrSGVjNWtjZHFVd0dONEpiOVRFUER0SVRSWEtSOC9KUHp3TFBCNkpQaDJ4?=
 =?utf-8?B?RjJLbHd3TWNTSVcyZ0J0NkJBMEt5QXBYSmhKWTZxTFVNcjZEcDBIdGlBWnBh?=
 =?utf-8?B?OHpialFoL01pRWlmeVNWSjdraFlJZWJGMnVYeENYRW9ndUhVMWJrTUpJSTR0?=
 =?utf-8?B?M3dvNDZtd2FRNW9qSVZqVFFaZGFoNWZWcXQ0Tll0VUJtSFJDM0tsZXlqVHkw?=
 =?utf-8?B?a2xYQURFVEdYWWFsc2d6dW1lRmZDcURHMGVQSGlLVTRKV253Sm5kV3hCSkw2?=
 =?utf-8?B?aG9FR01rUmJpODcwaG9QVzdFMFBOSUdyNjl6NUR0MHErazRGUTRSM2VHc2ZD?=
 =?utf-8?B?bW9EWEs4LzUvU3QyaTl5Yk5rWTMxeE10S1pEYTlLL3NEWlN5blhuZ3hyTGJR?=
 =?utf-8?B?R1Fkank3ZGRoemtxNG1DUE9IVmFnUXhIbnR5aUJWT0w1MS9jdWw5ZlhRTVpJ?=
 =?utf-8?B?STNTVUNuYnpFL085NDRGUWlpSHhsc1ArN3BZNmdFSFM3NitsWStaVnFVUkhl?=
 =?utf-8?B?c3VzZ0JTNEZFM3FQVnF1SFZTOFpiWjNtRzZjdWhFYXNYTWp6R3JXOG8welVw?=
 =?utf-8?B?Y3JTL1NoSm0zcFRVTVd5Y0VSeXBXNXZOV2x3Tmw3MEM1Q0pMY3FWTGZ1M0Va?=
 =?utf-8?B?M0Zwb3N3c2dHdjhCWDBNU3JGb0Nnc0ZPQXhDWHM2L3VFeW5NMkdzejlLcnFW?=
 =?utf-8?B?MUFwdVAvUCtLZTdJSjFWaVduZlFHeHpIbkY1dkZLWkxWYWorK0lPZEFvTTQz?=
 =?utf-8?B?ODdvd3p6ZXc0clRPOWQ4a3Zpa2o1VVlhamZWNU41Z3BBdG9sTkdPWCsrYjhQ?=
 =?utf-8?B?ckxXKzVDeU1zL3pvZ3NJSzdkMnlsV25zc283VFdNdGxhWlJTMnl0eitwdE5H?=
 =?utf-8?B?QjlPd3cxN0xIajZtQXJ5TVJnZHBHTDJJdEZCUXZ3VDY5MnN4RVExTVBGUDZS?=
 =?utf-8?B?OFlxOGJWejVDK0hQMUdaZGF1YzlyZ0U4RXJjcEFXeExSVTZodEtKZGZ3aFBN?=
 =?utf-8?B?dU5RZlU1RjQ1Q1RYa1Jyc3dpVkFqVzBmd2d3Z0c4QnR6ZTVBM0V0UHVJRHJv?=
 =?utf-8?B?M2FCRW5hVXVrcHNPWDFTYzNUcXQ3WWlQTlhDQjZ4aW4rR2Zxd25rdWFSRzZF?=
 =?utf-8?B?OFNwb2xzeGtRVVVNbThTZ1JUOEFnSzRNR2g0MFlIVytTdHlLNHBiNGIvdnNY?=
 =?utf-8?B?Vi9tR1VEanNEdVJBcjlGY2g2MWJKOXMvVmN5UjRQVzBwc1JlTTREYjBNYTlU?=
 =?utf-8?B?MEhUc3R5MlVuU1FjOHhTeklXZlJ5WlFBYmlHUzZxUzVzV1cxYmxZZGl3Qk5L?=
 =?utf-8?B?NXJIK0JKeCtXQVVETis3c3JtT3lXeGF5d21heUU1SjdjWWQxUTd0c2FHWHI1?=
 =?utf-8?B?SWg2YUV6WlBRMkNMc3hQWXAwQXBsMy81NlBHOS9sSHVvQ004c1NVS2FnYXJL?=
 =?utf-8?B?bFJNOWd1TGVZOHpHc3dQNGJITlBIVjY2bHkrN3ZPZUVGdm0wTzBMeEluaVJM?=
 =?utf-8?Q?MVzcq3zIOvu+md5mUontxGCqZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d50e76f-a97a-4d32-ad1a-08dbaecf9b83
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2023 11:51:29.4954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mClSgkplXYy1PsbwpEWHTI1BGOOv8dZetKtThrfFGSlh43eM7z9gUcDTk2vqj5x7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5717
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 06, 2023 at 10:55:26AM +0200, Cédric Le Goater wrote:

> > +	WARN_ON(node);
> > +	log_addr_space_size = ilog2(total_ranges_len);
> > +	if (log_addr_space_size <
> > +	    (MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_min_addr_space)) ||
> > +	    log_addr_space_size >
> > +	    (MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_max_addr_space))) {
> > +		err = -EOPNOTSUPP;
> > +		goto out;
> > +	}
> 
> 
> We are seeing an issue with dirty page tracking when doing migration
> of an OVMF VM guest. The vfio-pci variant driver for the MLX5 VF
> device complains when dirty page tracking is initialized from QEMU :
> 
>   qemu-kvm: 0000:b1:00.2: Failed to start DMA logging, err -95 (Operation not supported)
> 
> The 64-bit computed range is  :
> 
>   vfio_device_dirty_tracking_start nr_ranges 2 32:[0x0 - 0x807fffff], 64:[0x100000000 - 0x3838000fffff]
> 
> which seems to be too large for the HW. AFAICT, the MLX5 HW has a 42
> bits address space limitation for dirty tracking (min is 12). Is it a
> FW tunable or a strict limitation ?

It would be good to explain where this is coming from, all devices
need to make some decision on what address space ranges to track and I
would say 2^42 is already pretty generous limit..

Can we go the other direction and reduce the ranges qemu is interested
in?

Jason
