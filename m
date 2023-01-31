Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1388368377E
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 21:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjAaUZp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 15:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbjAaUZe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 15:25:34 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C1A4392D;
        Tue, 31 Jan 2023 12:25:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sv+iW8keHnV2qkN5GLC4ltP/QiI67LKmBXe1TNW1hXdNjwJrCm8Vh+Wplqh9Lr1EYPgUs05YNOkNymySEmYKpbNKDAXLgy2uh+Sdhq3lNt3LO5wcDElK8mDjwPd9sQJrmBnBflIFkjeflD/29EE9zcJ8W4VMSuEVlIUW32MEzRedjP8PAkf131zjzbaN5eH9ZP9WgGJFnB8oAxxPRU25++QgR/9HnVhq/la+Hx95YARDzjj0ivmwqGlLqTo1eifYZsyHPgdRhhdQ7obytvjn3+XjnZlQUgOLB84O7BdBHk52/iILsZaTtYmzdsf34GxM0BX9ArIxSR4PlbDuWD/ENw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xRUtnIZcaJ1yRdWaakwW2etm91jUrtQjbJjbdM+er3g=;
 b=NfVYHX/eL/OKq1BFnVnwhfujS4ydt4KLxrNMhk5uG6FBdwFMwTfA+PfAmno1a5y9v7TJirUjuVgd9ToCgpdf0EfLyh66KEYk/coIAGghitiBvWiE+Yo4Lods90gd1WD9VhutdEcfsrIUq/lTbVNCJYGVXkvdVmGeYeON73pS5w1LZjIOXMXQ2QJyMqA1u7OGmYkZmYvpH5xVgAhUcL5yC+uCbKFKdHxB34iFZ6xYOcG7gq21ODcxoQ0XPlO9qJSMhfK57yTt+/9Gaha2L6Efk2UO6416TnIc/WHOZ5c8Y9oZARD63+rkBe7vBi3sqcbRHzn5LwQIW3SOJe8Bq2Y3bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xRUtnIZcaJ1yRdWaakwW2etm91jUrtQjbJjbdM+er3g=;
 b=DE3U8G2xQFjVPb4Vjfy0hC2Ld2IktrXyiONVZ6BC4IL53P2dhojf5dr56u3eoFNbwcLfAfN1xQ8k8EX/EHCFFPzAIffBqrUEuCORL2mXxbScJ6mF9RLXYk0AI9on+sx4ZfzScOGVk0DLfi7MlMl5Sab2aKtCQek+8Q3g7gj94eflAuwoTweCBV7X1/QWtFXiBKZyxOrBoNmVvhDwJXFvti2f9lHmn4fCdffASUsntHOBDH0ZPzbaLKqA4aA+tfQLQ6A0C+6XYxl5rFDK5GwKsHrLL0xKT3aCJnT9ar599WBwg1REexoBZnIOWNsX47hpN3t6zYSLfbaKp/yoPmg77w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7372.namprd12.prod.outlook.com (2603:10b6:806:29b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 20:25:32 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 20:25:32 +0000
Date:   Tue, 31 Jan 2023 16:25:30 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, pbonzini@redhat.com,
        yi.l.liu@intel.com, cohuck@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com,
        akrowiak@linux.ibm.com, jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, seanjc@google.com,
        kevin.tian@intel.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: fix deadlock between group lock and kvm lock
Message-ID: <Y9l5OmCRGYZM2nPy@nvidia.com>
References: <20230131200635.44227-1-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131200635.44227-1-mjrosato@linux.ibm.com>
X-ClientProxiedBy: MN2PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:208:23a::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7372:EE_
X-MS-Office365-Filtering-Correlation-Id: e66afa24-e4a8-491c-b82a-08db03c94cf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a5cCI/ReQA6KL5f7naTwhQwfO88J6BcFD291Ll1Yy8CH8yo0BDTNAxkJfydQ3zHK4Mg2yTOy66/mRRFK/TO5350MlQqwz/UJgCADbMiVNFNVE4HpTzpxxNa0BcPm3svERAAis+zsc/k7t+NpajbZ1VhCvWBcRl+nDQcwpc+uxbxTarvpsC+fp/xD8zp7fbSLzQ5rO/BFvel/cSpIT/iVEuKeXJgNFqac1CbUOlKxBrTZ6mPLWl0VncasCmogXzZaRMSQdjaXbJ0vjqmjIurh7KJwDe0GnZoSf8b4rhZ6Z+hFxulpjpl7fTH5slBS+bYAkm+RW6kPPOpk2RzhL0hGGeAwsnsPrD9ckC2DrzgxFUuyQyrygqL3h0LziboE+ubmnRWziMe0lJUqKFIA+bPaongo80NwXS4gxtSZmp5RZp+SuiXk+Qy/To3lnCYNfiTUlf3mmKH4D7MrefjJ0/hyg4LaDk1JCf31sPPlMRtTsR0cSE1BrfINI7U1+RJYT2FPKdddAaxvD4bWqyFpJkjZWMbz+mw69pLVkROQyWCa4+S3tmNSXPknxn6FvdeU3L3Awf0RXDHb7EOBsypb55Gu+US8cs0wYMLOwT8RBb6OKDI5X8ggrRLZfsvaDt3ejdUd7mCduVwvEB1oayfHSk+fTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(451199018)(38100700002)(83380400001)(36756003)(6506007)(2906002)(7416002)(4744005)(26005)(66556008)(66476007)(2616005)(86362001)(66946007)(6512007)(6486002)(478600001)(186003)(8936002)(6916009)(4326008)(316002)(41300700001)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0GjSC7zIVdGDGR0UNwkGfpbuYK9AnPKZ8b9gd4K3KTBrSgfgg4zlJkn0S7ea?=
 =?us-ascii?Q?hyBZIHXJYhWWkjNHV1OsNM/MwarFICPZ+/tqhinzJSKqdxipXOXiRzzyNb2q?=
 =?us-ascii?Q?DfRn38QRjpWASn6lN37tFsykQpct7mVjBRlpgakWUXEiPn/6RX4q+f+ZBx6v?=
 =?us-ascii?Q?qOadO7BtPIsj7V3M32RRHgBqV0vvQQvzaE/cRdzz7fI98JVVdugTADWE8s5G?=
 =?us-ascii?Q?caf38ck4zYv94xZojqjr6/irtJcfhnSs49Je3x08Ubpa55B+TmOlZPpA0zIn?=
 =?us-ascii?Q?cyVlAa921VN/zRvIAehVGOhOI8E8yfFBDcgvIW4i1LF3GonpHwA4LhdXWcU/?=
 =?us-ascii?Q?nAmAWvSMYlA5/2plt/0BSPDlE/5sH4SdYYhRULR1jADqq8BYt1baiNUL0IXV?=
 =?us-ascii?Q?5SwYklZo3NkxKY189yWHYde7Jb9dDYbAEnR03O3E3QMfLm8+kNgRyeUhB1u1?=
 =?us-ascii?Q?K3Yjm2zx16/gjDInqLOeWCIdnJMSGD2U/91NsHXCWAWZC7EJlc93dWXrYEax?=
 =?us-ascii?Q?Dmctm/zKiED5MFEQQVqOtv6rF4qwWUHbiMWeL2J4xFVjNDEEbbQcX0tvr2p4?=
 =?us-ascii?Q?vEI1DraiIzgK6ybssHVcBB0FVDPIXeygvvHy+fzcDDL3XzdvgsCOWRcUULXS?=
 =?us-ascii?Q?rsJViWI/h/DyLCk8PbHPOYK1qyls4hLsnmqxpiPPd4WxxaSAfa2hm+UVe97N?=
 =?us-ascii?Q?3HEBeS1PZ4yAfb6KgbmW5t6knOGo5g/e5izzovxson0pYbWaQD3a3E32Wvbh?=
 =?us-ascii?Q?xFf6sVlXgpVKLFNi/8WIVvfpeZBR3aZkSSRDcHn8dnctDq3P/Hdf7q0Dp+AM?=
 =?us-ascii?Q?z7lI0vvJG1AAVsjZDfmXUJd5YsjeJB9V0CKB/++05uFIXZSmhHdWcbNBPbtZ?=
 =?us-ascii?Q?ztjLChEQuHpGEeXWzaUb7mZSejBJz3EOSqR36SIcgMDqtfzV3X936XyZY0jr?=
 =?us-ascii?Q?K3+OhkedRmexybsm1SJ5pfIrv4W1gAS8Hk0HOfY8rYQoPkEMz6w4dLC6c/mJ?=
 =?us-ascii?Q?Jqlzs3WbID/VI1Mbvw3HeDvFjf9dbrX4SwRf2NLr37biQOdbEutLIJNYoz9h?=
 =?us-ascii?Q?BW8m9DtY8jeGLw1D6mcnWKyKjE9DgILKkVetgYZet0HVUXGoXZb7/TEFHYkO?=
 =?us-ascii?Q?9nwBQtZ6DQzgXmufQqqrzWNGnM76WfG1fo68py9Mmjumny3yo/glSW9RcfOm?=
 =?us-ascii?Q?rlvW2JP91YAgdzu6zmfyrWh4YOefEKyOwC6WMbDHd9tHoz4X65d8M26/vvHk?=
 =?us-ascii?Q?AdSNMuXwStqz0FKWzWmf7I+5JxW4IFBlnFZ99wnWhXXM+Gwc4/AujMabSPn5?=
 =?us-ascii?Q?DMNW9F+I9o12ZMMN8oMb4qkie9ZqGfjsByicV2Cf/mEYJW4NdQ8VCp68XXJP?=
 =?us-ascii?Q?Fs4/3cn2t9a1DXWCLWRX62MigYsy+eWZs9RjkIOEQvMoH9a66AmKS1uYhHaD?=
 =?us-ascii?Q?BKVYX0vydVEKkzn1xIX81XuA/PDzU36ljWxhP55dpkUNof6bM3UunAGlVYko?=
 =?us-ascii?Q?eiAD/k+kH55amdp0EoA2kO74ywl/Gi0feUCAHBVGM3cyfjzt+BZ44pK51n45?=
 =?us-ascii?Q?GjQm6T0gE9MOoZW3Ma+7/4OzkGTC/tk0DxQNyUzS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e66afa24-e4a8-491c-b82a-08db03c94cf9
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 20:25:31.9675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZR59IwsbFxbhXGQ3Pn60ncaOIqjp0bmw/wK3D8xtbd2ORf5pA1fuPJCgd/mRmkBM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7372
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 31, 2023 at 03:06:35PM -0500, Matthew Rosato wrote:
> @@ -799,13 +794,14 @@ EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
>  void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
>  {
>  	struct vfio_group *group = file->private_data;
> +	unsigned long flags;
>  
>  	if (!vfio_file_is_group(file))
>  		return;
>  
> -	mutex_lock(&group->group_lock);
> +	spin_lock_irqsave(&group->kvm_ref_lock, flags);
>  	group->kvm = kvm;
> -	mutex_unlock(&group->group_lock);
> +	spin_unlock_irqrestore(&group->kvm_ref_lock, flags);

We know we are in a sleeping context here so these are just
'spin_lock()', same with the other one

Otherwise it seems Ok to me

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
