Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9982973B864
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 15:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbjFWNHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 09:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbjFWNHW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 09:07:22 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0012129;
        Fri, 23 Jun 2023 06:07:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jRIQMfjSq6m7q7+nlkT2MUvcHQIY2c4yPchDmx8yXzrlVIWo1nTQeYr0+F1K1q0kzkPTD889z8TBpKKiGrTqx9FG72lDCoQNk/Of3ihd3ckgd9M+kn3VrFv3RoND7paAMPFXWX+XnqQfPZ0qfUYbtQbLGlNcLc+AC+4mnOVhsbFnPOFgKBMboBhRghEORodJcZH5nYTeBdswEefisCbticoHVYLZe7uhixRiL/+yCe44CiMRhPBFBjBKxQjaxMm2RjKmKNG+TOE09t7o6eqROclnaWfsa1NHqLgIzHlSt5d9h4ASOZOv+kt9JL5oKfq6bts88lUg1rbkKaZohmVbbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m1T4XFi+Blae8gHWJLFXceGHyPipylcPB/eKg+BLnyc=;
 b=YVRcVS/bcAc7fZwW2zVZgQhOYK6hKJ+TW1OyTnxe6WnMAPwt+rfvJQYYusnzmf8Db2Iea1F4rypkq1IZSTxPCGLHqIV/8S7Cj86eyGP9hL88OFMun5tDso42SRskxLnqeD7D0BPZLYjtHRSdR2PeWFNFcXmK+0dxS/tGe8LN+latYAWbpqoXwP0Sd+NtNqkN4SNGrdayvRBAcvzWmKaj/5gsEU7o2pBZBdLD6iPig10jtOf4S9geitpEZkNuMBS1zpKJYRai2trtfdAR4IJKaV+AGtIVv1RTgV4+b0vmve9sBXnafUzJRVaocmBrijX8eAqS4oBPtq2pklF2TLYr3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m1T4XFi+Blae8gHWJLFXceGHyPipylcPB/eKg+BLnyc=;
 b=WqVSyGXtLvnL8hNhHoHeqhJdiVjF4uo67jPfUHSNSALSKK3KmB68/WxDdDs3vWB9yYXYBWUtvr8grMXmuc/vHBekNB0SDP+1DMn/fIm55N3k+USZrtXWqOMAsamPAVPTMysS16gacmxmzOIoZSJZcgW96LmKRDZjWAd6B06cwlzpP97r4ARFFloM1vTYpmZGuZ0AxMfnezFZGiXFdGGKWdwd6Xv5xIrohz84hMpnngeN19MpQr2EPKMhUgd69RN37wesj6nB2HxB8uA7sVpZ3ouAPaSrGW1XKjERY76o+MopZyv0+yoqv2myTYHjS809dMZSZIFXfMYb7dMCqR1uQw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6966.namprd12.prod.outlook.com (2603:10b6:a03:449::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21; Fri, 23 Jun
 2023 13:07:18 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Fri, 23 Jun 2023
 13:07:18 +0000
Date:   Fri, 23 Jun 2023 10:07:15 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     =?utf-8?Q?C=C3=A9dric?= Le Goater <clegoate@redhat.com>
Cc:     ankita@nvidia.com, alex.williamson@redhat.com, aniketa@nvidia.com,
        cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
        vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
        jhubbard@nvidia.com, danw@nvidia.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Message-ID: <ZJWZA8ogUlGegx2C@nvidia.com>
References: <20230622030720.19652-1-ankita@nvidia.com>
 <46a79333-12f6-229f-86f9-1e79bdba7d11@redhat.com>
 <ZJWGbsaMzHvqqewi@nvidia.com>
 <62dcff6b-852d-4a85-dfd4-0ce1f324602e@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <62dcff6b-852d-4a85-dfd4-0ce1f324602e@redhat.com>
X-ClientProxiedBy: CH2PR19CA0020.namprd19.prod.outlook.com
 (2603:10b6:610:4d::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6966:EE_
X-MS-Office365-Filtering-Correlation-Id: 22c1f7a4-c776-4041-c3bd-08db73eac569
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: otydpx0l2F4M46elcJifBZWCK5VZoJBwPNhs04rkHGhZDY/y/W5rbig4SDKk+1isZVkCvnxoTtt376AccyiJ3K/x8/B1j1TbXaUF6tWcove8599HFuyymBYJK4w43fzoYUWJjnhd5m9KFadz+ykk+XOmq8W5GEyZb4K2AqdoRIHN3waLqf9oIPOsLn2/L0mcywxbA3Z72Y6wGhyqTGt9CnApK6JwIFEWyoXah+w+YlG+n65Od1OTGqiWGtXMW/1s1F9MqPrXuJr4Bw581lkd1KU6+vmlBQnMUTDPwZunhDD6p7zEU3CtlJq1+dj08TusQJeMFvhuagBT5nytzJBmbOEsv+vaSiCBMZaaQRjAtZpiKpPRe7CoUG1hpDMwWJnZFoyTjaSB4bo5jsyfNhDON512814I79LQaXTnsQONaIYG5Y08VPqZ7Mol8uhh9ju/R1Ewj85KweL9gniR3TegqgGbkjp3GNkAXat6QMjsQPBOMYEF7Ujdw+4GrBQXlv5zOGLhZMKja0JvowQb2ufQ4N8+ZGCtfHNSWS+KRXoEZywy59jtp+sGETpcB8qkV6DU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(396003)(346002)(376002)(136003)(451199021)(36756003)(478600001)(26005)(4744005)(2616005)(6486002)(8676002)(6666004)(83380400001)(53546011)(2906002)(6512007)(5660300002)(66574015)(66476007)(316002)(66946007)(66556008)(6916009)(41300700001)(8936002)(86362001)(38100700002)(4326008)(6506007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3NOSmpjR0k0QjNQK291SEVrMDRMVlBsckEzMTUyVWRmK0p3UU9QWXIwNGo5?=
 =?utf-8?B?MlVWN0xXZmVwMFN1YXpVMC9ZSk1KL1d6ak5HZ2ZqUFoyWVZYM0RwQUxSUkc0?=
 =?utf-8?B?R3lqYm5HSjNXTnBmM0hDOXpyZkVWYjdjSGZaS0tIWXJEYzJhR3VkeXE3S1Nx?=
 =?utf-8?B?YStNWmVJSXRocEc5Z2pZYnVZbm1Dai9Fd1Zvd3pqYTZQSUEveVFaTUdIK0Yv?=
 =?utf-8?B?T2d0UmFHK25kTXh3Tno5MDd4TWttRDF6NWZzQUc1WFFKTHgzSmgvSEZHdTd0?=
 =?utf-8?B?MHZySTgvTWhHV2RRY21CTU1YWkRZVzBlWitHK3pscHJXL3F2TDdMdkZ4NEdT?=
 =?utf-8?B?M1RVTElCOTZIWDhSeGdPUXU4bVdIbTZQWk9hWDN4WndOelJqNlBnTHRzRWxC?=
 =?utf-8?B?VXRUUUpCSlFsRG1OYi9IS1YyY1lEV3BndUozYXJyeHlqblNDUTBSb3lGaTlB?=
 =?utf-8?B?NDRpM2paWkE5bzYrZjFaRmMvcGhaQnhkSDFwKzIzcUNITUFWbkdSczVCTmJH?=
 =?utf-8?B?dWx2TzlQYjlTbkp2V3lDVmxKVit1WFViMWZ1MS9LRmwzeUJORnhGbUMyYjZz?=
 =?utf-8?B?YVVrS1NjTGhNTE9nV1MxajkzOEFVczB1ZDFVT3lIcFhPR0FFaWgxYklNMG5R?=
 =?utf-8?B?RmZFazZZQzdvTE1Vdld0RmRPdTcxSk5HaWNuSm9ObURuNWhrcGtmUFZQRkFV?=
 =?utf-8?B?c0EzZzgxaStySTl5ZHdnZTFndVZ6Z052MHdWcm52d045azUyQTVnVi9iTlpy?=
 =?utf-8?B?WUJ0UHdmUzU1ZFo5eHVFSllTcWt2LzRkNnIvZFNjU1E0clpNNFcxQ09BYmJ4?=
 =?utf-8?B?MUllSmZPVUdFbi8zckpnVnp1M0Y3SlliWTJQeGxzYjh2ZGxjSE94SjNOSFJv?=
 =?utf-8?B?UUdhRjVyZU8ybzhzZXlxT053WllwUnJmUi96WndDcGpBdnlBVzBjZzhkQzVm?=
 =?utf-8?B?bnBPZlNLRU9rVGV6aFpFTkV1bWlRREFpaEZHYUNqMHZ3NzF2MW9EOStFRG0y?=
 =?utf-8?B?ZFlWYkFORXJJZHBNQ3ZjUmwzdE9vTEhBV1FzVDkyRWVUWWJqQWpTUWNmeHVs?=
 =?utf-8?B?d2pLSW9oYU9kbzFlOGZPOW8xYTNFcVMvNlNGaFNSS1lKUUJVY2VJZTFRMG95?=
 =?utf-8?B?WG5iditOSVVlSng0UHNDVURERzhVSVI1TlF4cjE3ZVNya0hpYmU4R0tsQnZE?=
 =?utf-8?B?MVpWd1hnY09lWElCSjg4S1Bid1FIZmEyK2Y1RkpKY3pQRVB4T2Qzc2d2dS9V?=
 =?utf-8?B?WUFDNEFaNHl4VG1lRzd1NHl0VWNTdmZJR2F0a05YdEd4aTNwajkyRVFtRWIv?=
 =?utf-8?B?elBjL3JyOXpVdU8zdWNWWWZ5cVJNVzNvZlNtOVN2TlFVUlcxZlFKRHFDc05l?=
 =?utf-8?B?MFFPcGNuRmZzSnBFMVlCMGpZdzlGNzJpRmp0MWNWQUhOeWk0VE03Vjlwb2px?=
 =?utf-8?B?Y1lOSFlsOWlDZWVIT1lncU9PYi9MdWtKVXU2RHI4Nm9KdnBtOENQT01WT1Z1?=
 =?utf-8?B?Y2lpMjNWSUZ5cEpkZFdPTElranNGWlNtRVFmQytBcG1NcjhNSnEwYytpSUZQ?=
 =?utf-8?B?dG5VbFpVbHRlcGtYcXdJRWYvUzVLV0t2R2pRNTd2OVlvdm1HRE9Vc2J0dVhJ?=
 =?utf-8?B?VG9VWFl6NzNTUFNVSUF0M21NSmpzeTFVUDdFbUI3Y2dBaFZvVzBkWlo2cFRX?=
 =?utf-8?B?WTZidHZMbm8yNDVBWGVyN1o5cVIxclNJbXRnZkJ4Q01wVEpBL2VTdTQvUjNF?=
 =?utf-8?B?Tkd6cTVvYW80REM4TDRmTDA2eFQzV1VRVGNucDgvSWMvME5Fb2RhRkZpd0Yz?=
 =?utf-8?B?SlVrVmlhVlZDQTg5WnZMVk9majdaMEZyaGdGa1Boam5LbW8zU1VwNEJNU0VE?=
 =?utf-8?B?UjhVWExtOUNsVHhabG41QkhMemJEYnpHV2EvVXJTVUl0V3E2ZVc4QlpVckdv?=
 =?utf-8?B?bWtqU0kvTmtSd21JOHE1MmlhMGNqVTNYdVJNbXd4RHpYSmlLNXMrZEVWK0Ja?=
 =?utf-8?B?QXAxSElHbXV4SG1IRHEwVjVPTjluNWFydG11TVpXNlZ4ZFJ4MjVpWGdhMGQ0?=
 =?utf-8?B?bUFOMzBrc3BvV1Uxc1ltVDdHN1RiNU9RdkdxWkhuZnJXM0NjaU5pMzRhajZF?=
 =?utf-8?Q?8ckE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22c1f7a4-c776-4041-c3bd-08db73eac569
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2023 13:07:17.7740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KdooQB7f7ppTDj6ytcvvUG+dxNBP1bGa5vebNsDxMZSZDqu6y1Om8J1upFWyXgzY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6966
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 23, 2023 at 03:04:17PM +0200, Cédric Le Goater wrote:
> On 6/23/23 13:47, Jason Gunthorpe wrote:
> > On Fri, Jun 23, 2023 at 08:27:17AM +0200, Cédric Le Goater wrote:
> > > > +	req_len = vma->vm_end - vma->vm_start;
> > > > +	pgoff = vma->vm_pgoff &
> > > > +		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> > > > +	if (pgoff >= (nvdev->mem_prop.mem_length >> PAGE_SHIFT))
> > > > +		return -EINVAL;
> > > 
> > > you cound introduce accessor macros for nvdev->mem_prop.mem_length and
> > > nvdev->mem_prop.hpa
> > 
> > Accessors are not the usual style..
> 
> I meant something like
> 
>   #define nvgpu_mem_size(nvdev) (nvdev)->mem_prop.mem_length
>   #define nvgpu_mem_pa_base(nvdev) (nvdev)->mem_prop.hpa
> 
> This is minor.

Yeah, this is what I thought you ment, I'm against this kind of
obfuscation in the kernel without a very strong purpose, and if you do
something like this it should be a static inline function.

Jason
