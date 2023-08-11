Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C8B7795FF
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 19:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236799AbjHKRSv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 13:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234215AbjHKRSu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 13:18:50 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2064.outbound.protection.outlook.com [40.107.101.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF660E58;
        Fri, 11 Aug 2023 10:18:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HLcPl39lFk/mMpJCliL64f/yp8V5aUMSM3VxhUV9wWohPyn5NcmX+aJWRzFtFsUsVhKVQVAsRWMr3c6oDENVaWxW/A79qbKMeFXJMMyXo+obcoQ2eLPw2hN9JkXVSeLkzkPz7c3kP1OvAU92TI+R2OCU5IwM6O0Xn6yZLVWjq3FafJMUOfzAf1XLU06tW/HlvlWq8Fl3QmNF4zIIth+RLpV7YXbphoYvccJvw38GVkh7dxeMAbTNneE7t5qIViZKvZ5FqQCvlJZ+HTdzV9EOhaRxSMR6a+zvAK1XFGx5ZX09IPnUA/PPebRz93yRXIaFu+10AvsyEkE15PbNdmkeEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8QA7Cdakmehf15R0stMu9UIr4WvJTUDE2XACZ8bPttg=;
 b=ecFcxmwdrdCl/9Tip8ItFDaRIz14f1yPyk1mjU7+X3rrMDrs1Q7h8mRuAUgOs2Vw24hZ57meok0aMBLiUnhuDAJRwk/H9btShNpKKd5Y2ltw/ACoYSsRu/OG4n4cH/wMBgUIk5i/iOOKcGlcRwO/RbFHYKyXcvUIkV+uLBLLuQqJuCwZgGTAYYxIgqJqUPMJorldc+tZ+LedA1/fuybLePJtxkEYIRAp+gtjHFeocPnui4R6mX1gUYHZTGjcLTFFZXwPxayaVrOyk5/R0npMM1F3/bNk1exfZ9Zt5GWd6nUjRL40mNj1ADYUqo8zLgK5pLZT5d/5ftMb0fx6lmbCug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8QA7Cdakmehf15R0stMu9UIr4WvJTUDE2XACZ8bPttg=;
 b=bnybg+Jq+hHdANZCu0RCvNntQHAOcRNyyZiB3wZfWWaR+d/yiRwddnAGIXJMjIIqiNXnG4LkGk1srtQ2p+QdKrGR3WoVQO5ek3lPAGLUCryT5hFGHA2WSi2dqvRdPQXV3PRNOGtXwdHn+gVTHs2vXuIIB/IxZgfTJYy13hQxpliW9J+ZzjPm93XFW/yE1lwL9xvkMAZQIz7i5hDenzZmZvZYMwYX5qPQPxBl0PJAvmXfvhdvN+sxtIOb4mwPYsR3dQOmxgsWTE5USVVBGpZcCXEJpb79J5QFdeVpWG0Wziptecywwarx4EppU+wsUic0hZb1+qwpwzdfjnlypwVwGQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB7996.namprd12.prod.outlook.com (2603:10b6:8:14f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.20; Fri, 11 Aug
 2023 17:18:47 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6652.029; Fri, 11 Aug 2023
 17:18:47 +0000
Date:   Fri, 11 Aug 2023 14:18:44 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, bibo mao <maobibo@loongson.cn>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, mike.kravetz@oracle.com,
        apopple@nvidia.com, rppt@kernel.org, akpm@linux-foundation.org,
        kevin.tian@intel.com, david@redhat.com
Subject: Re: [RFC PATCH v2 5/5] KVM: Unmap pages only when it's indeed
 protected for NUMA migration
Message-ID: <ZNZtdKXslPlKYRWY@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZNZshVZI5bRq4mZQ@google.com>
X-ClientProxiedBy: BYAPR07CA0009.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB7996:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a098585-2acc-45fb-9441-08db9a8f0595
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /8cydHtunO83yG5N2jEl6pvAbZ4yqiiol0rcnoPmziH2vQWkGAPDq4AT+8FuATuQoJy4cBdmFOjEphxTeZq6C1XPDlAzVua+WMuzbdbeyuxjpMtbjUlv7nuoN3lPOavhd9eLUd6Dp0qQyRNcnAOraGVOZ4nnLfccrex2HYfd+Y/Ny/sBX5hn5H04sWte1LLD1sjSO+Ve5f1PvMKFIxQQ/fPVJ5vNPtbWnsYPzmnIVgELLP0xii9pZpCwGFIISf9qwRAoQcXSXFYeFe6tuzq7GdiyJHCUrnAeF1AivdJTOMdjUQ4eZr5nBQduHE3n1uKjkQiwB7LViyvXlVO8TaMGW8hzJ6syotKsQBnAPvrq0vX1ZMYnquW11E6brEIJzKSxY+ZDghvcOPuZ0+iqzizBM/bHyKMgitT3K9Rc8nbefHXk2NbQzKwAPIo5XVeTyhkHmeXIAzeO0xjFab9//IzLQ7jNS122Reem3GgQWxBeg7NtP2i0pRi5Hzk9uX7K8nbPss5zJAOZOP4HChR7WT/nm5JRA3htDRUil0tVeVC5YK8V5AimLB6rV3TL5A0Qu3Z6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(136003)(376002)(396003)(186006)(1800799006)(451199021)(6512007)(36756003)(86362001)(38100700002)(26005)(83380400001)(4744005)(2616005)(478600001)(6666004)(54906003)(2906002)(6486002)(41300700001)(8936002)(316002)(4326008)(6916009)(6506007)(8676002)(66476007)(7416002)(66556008)(5660300002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sxmH2pOeS2O/JhSsU7dKglxDOfK5Q0j0OEON2h3pFTPNq0pNSVd24e6fp9vf?=
 =?us-ascii?Q?4ylD8hl/qSk0ZaHligq4sm5/5WXQX2R8mG8NuDqfggr7uH5Hjlm8DNZzYn0v?=
 =?us-ascii?Q?Y7lyt7W6wf+2fiG4VH6Y0cQqBhJCMzwPYwHz4F+s6noiz54zUKC/d4X7nL8r?=
 =?us-ascii?Q?FwO8TMpoCwOSRCOEVLJUuePzKItv9ueFjqQvuD/zaqxpAmiPp7dKzKHwAZN8?=
 =?us-ascii?Q?jvS+2kJe4mpEX01cS/BSg13BPEbNZz2WpHpG4MOa08g6YXZkzCgugpzz8l7a?=
 =?us-ascii?Q?mceRpXPB+1GM/VjsOgf9uh580eJaeGcfQ819oU8J5qKUp7Q4Uk91OFiVuKiE?=
 =?us-ascii?Q?79dJbZI72H3xsayjfRFuVWG732V5ZUQWF1dwKT4GVXhMM8Wb4X2F7llCZ1uM?=
 =?us-ascii?Q?PCWxVd+GY9nfDU+0rVzIirf94US2xNChA4fVFXWQFeEILyDj43rpkHM83L7t?=
 =?us-ascii?Q?NnVLHzUOitf4WXKVjTHsCDzgWaazCpyaP7n7ApQSv/olAsp6O4b2IN5g2CSW?=
 =?us-ascii?Q?h6/B5HJI4nV10epIiTeiTfSc1Mssk4dfBTCyqiIXfUmflU1lTy7Bk3uzdv2o?=
 =?us-ascii?Q?axbi05rRB5i/NV4xYLLkEPcqp5ZqufWvBikO7PL2iOvKuO/1nobFaeU8yTsu?=
 =?us-ascii?Q?7uGnUoIWQ75xKDMkQBPTq76dhVlwWNObVWH7hMbzPjkriG8hiIWGWhbVYmVM?=
 =?us-ascii?Q?6MoWIcop9U0fuzAIacNRwyc/tmtt6qPVbyCwgK9giL/rvj+nWgen3A5g8MpO?=
 =?us-ascii?Q?CyefCoD/JADSH1Ntl2Vhm59AzoRnUDx7wy810iKWHge+l0cDxwC8V1zoLJZo?=
 =?us-ascii?Q?Cp+R+TuwiKBGNfHfuRWYuCFOmIRtMymaRHrQqTDu+kMpx+eoCWZfz7iWwRgg?=
 =?us-ascii?Q?zyKo1bSG8RMjDIuE4p/54GZKeb+RaaC8157WidwJ9eDTEZs9Qqeg3O81/cRU?=
 =?us-ascii?Q?75nC6xkH7U9YMmFtboeVtB8Shnn0kF3AJYdnFPXDYTFMadGDFvk4oc2o0f63?=
 =?us-ascii?Q?cbqmgYfY9kQzphsEwpXKOilfZMET2U6cXWhsqAvGk8xWBhaF5odE4QU32r9y?=
 =?us-ascii?Q?6VW9oBNK6jRuf2KiXUzzUgLpZuBxrrABsPqv0Y1CxbgeNA8snkJvzXI4BLdx?=
 =?us-ascii?Q?3okl2fFtntO1SVPfBSnrds+2b1h2m2KmCrYe79naP3LHrTB+K7tsW3J3xJ/r?=
 =?us-ascii?Q?S2s2lYB5mFG2zF7btkc7JkCdBHuxU8dzQfi/ibcyyULZ0QApF4WTvgbcLLQk?=
 =?us-ascii?Q?KLv0OY/0rA3XSDi/PIElvglt/zHwHOWx348c1dDXh5uxhBMEaz8NBPIkffUg?=
 =?us-ascii?Q?ERVI33YS+P5qRDi7FdU+mOxL+4h3jO1P4urGKeyzBEkf15lodBsxi9uT1Edp?=
 =?us-ascii?Q?RlKpLX5y0zh0Ie/58lQm+PXXcgOClxheJ/HpGVeLqLaMSxeQufNpVcB6Kj7q?=
 =?us-ascii?Q?KmMelAP2RHVwAJ7mnwUPBYBlhyKxOH+zorxsNNwkcHII0lSRLyKFwykcl7FD?=
 =?us-ascii?Q?zJ1gWrVe4xZWbaFSpsaT7dofJZE/P3786HnTWlz6nYvlGVed9qUOMpkh1lvb?=
 =?us-ascii?Q?ACQCNDOUKcL+VGGCJ8zM9QsN8E1YhRINYGrHE76Y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a098585-2acc-45fb-9441-08db9a8f0595
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2023 17:18:46.9227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T461Xfy+2gWZ1kaA+U//ML/vIJxcnrYF1gj35oWIbeP37DsSfRp3Plgr2hWaV5vE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7996
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> However, *if* it's ok to invoke MMU notifiers while holding PMD/PTE locks, then
> I think we can achieve what you want without losing batching, and without changing
> secondary MMUs.

No, this is not legal.

> +void change_pmd_range_notify_secondary_mmus(unsigned long addr,
> +					    struct mmu_notifier_range *range)
> +{
> +	if (range->start)
> +		return;
> +
> +	VM_WARN_ON(addr >= range->end);
> +	range->start = addr;
> +	mmu_notifier_invalidate_range_start_nonblock(range);
> +}

The 'nonblock' entry point is advisory, if it fails the caller must
not change the mm.

Jason
