Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23A5A4CB372
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 01:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiCCAXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 19:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbiCCAWx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 19:22:53 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2082.outbound.protection.outlook.com [40.107.95.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204931029EF;
        Wed,  2 Mar 2022 16:21:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZyNOnct/VF/oB+D6Tl0DZPPRkdRa/ok9leqHishEd8oWzfedo8pTtCQ1KuotmZi824d+dszoV+zq67AYJddoKhjJs6yvcT3q/sTNesllL3os4LJJbGQk1dpjefQyr35YR1+ywfqKoJvA/IsxkJY5S6yLd/4oyjRhfiUjmKkgHVu7ZgtTjxjzFckLPbujHQ+r6OL4hBau0/R8t4nweqp04Z8dsMyngy/La4zAoxYs+XGdBabnz6HVwSJn4nLC4c5xtDzpFT+D3FnGhayoPYY3KPrvLRmYbumvyziH1hjO5Ji2+J72GPbKbTk/UDn7BHgyWL8HqX5CVzL5IifAzKN2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YqaQITaTVdcnjb1jq3P8vdhtiJhahcMtBaR3iEavRV8=;
 b=LPf2+bL7H1+7vdd1vvzeLSICYSONUFLSCJUU+a18EVSpr6luEWh3hADBqWRVmocUNBgXplP353PZLq5j+XpHreGFcuaUmsPj/5pc8BDM9ExtpKjHYOdMbEX++Js5XXP5G5DUzyohqa1YygbrEGg1i5mzqn4i4n9PaCh5IYECq00tFs0MueleKhZcTS2cJoszCYWXh/6b89JKGBcKeTHrfTfcgAnXK/dex2zzbjuc4SRCDg6iW16I5EhMozR1sHJMlj64lqIh6dS82DhJGUmILNQMdHYSqA4FhbOoVj8LnXBlUi85pFyfkAwBzH1FQMbNAx47pTQbmsb3K8IxMgbgtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YqaQITaTVdcnjb1jq3P8vdhtiJhahcMtBaR3iEavRV8=;
 b=c40/VJQlWn0uumPyHRt/OWfYVPIfDPgHZoQN4kjqwMrvHI4eo4ouWi2mkj37E5KXRdAk5T7WaSOT0bR6+VqoUBWfE26NkLdLNJUQSM4qt63uk3Qk3tSX1Hsq7asMAA5KEd2NmGAWP9QWAlLiXw12Cntc/yJlCqMILI4OK3+pK4vcZ26XQSEOkggafDgNWjhCd3Bsis3A8f2ObHKP3uIsDgyAzOd1DcBdc9FoslRsZvkEnRQ5innRVEaWeSuX9lNSoy1PmxAgGsvQv/pqDS/WAKjNDHXpqa+jO/NgAo1iLJKBj3GXzO26VvcQahm6mExb7LVBZgjrxj1sOxulwqiPdg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN8PR12MB3298.namprd12.prod.outlook.com (2603:10b6:408:69::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Thu, 3 Mar
 2022 00:21:44 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28%4]) with mapi id 15.20.5038.015; Thu, 3 Mar 2022
 00:21:43 +0000
Date:   Wed, 2 Mar 2022 20:21:42 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        alex.williamson@redhat.com, cohuck@redhat.com,
        mgurtovoy@nvidia.com, yishaih@nvidia.com, linuxarm@huawei.com,
        liulongfang@huawei.com, prime.zeng@hisilicon.com,
        jonathan.cameron@huawei.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH v7 09/10] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220303002142.GE1026713@nvidia.com>
References: <20220302172903.1995-1-shameerali.kolothum.thodi@huawei.com>
 <20220302172903.1995-10-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302172903.1995-10-shameerali.kolothum.thodi@huawei.com>
X-ClientProxiedBy: YT1PR01CA0118.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::27) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 335b7694-9ced-47f5-5d49-08d9fcabcbc3
X-MS-TrafficTypeDiagnostic: BN8PR12MB3298:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3298E3C909430EA893F6B86BC2049@BN8PR12MB3298.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rzXKSHUhrGre1qfqXopXAUukX22rGRP59Eaf7iI7J2ndr/DvFmruK7Dvz5yHdRzgRjju0ZRFYqXxQkTYdwFG45cv3IM9F1Ys4RaYhkIkSSS/VtXpsMriIJzXZRSbvPgQuVSMGe/UXlj+6B19JPABVV+Q+JSohxUKLJ2efoFxyrAmZRwexTBj9KQ4RSG4iEK75X6CYUhXLo7PZjzYEcq+jUMB5+/Qbzn4X04P1bUW8gsqgRz0mmDiR5uAXT/5N72piLPlvyKTqDtUWC9n68kMTgmTBY+2IwmNTHefkFrUxyU0XYJaYG/jgPFa1qiZDkGtLMY58kPY9ED6xeElRF+J91+me1qLpC5YhWbE4haK2YELjEXR+X0QbLZgQzHAmSkVIu234kgv0RlmD/XmR6AAsInywJ3Sr9yDELSTjF5l0yR3z6+sU6srtCZ00d7Z5qA4deSAPlvWX8U8jHqMNlQ/hS02ysFT30iHHprwaQ1ifMDt66ZAxUZXX7GxrZHYosgzcspEol5gBc87/Vt4PbKp/e8oe+eff7kJZ2GvHTnxzxRiEdh+SyrXd/3FgMpvHfPMbwgSWeWpIOyYtN/DpExlzBH/L6XM9FKJDyGwxBJvxuZvEQV85HJfmZE19+QYKZ1zM+RmYON7/hAmXQLkGtKHlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(1076003)(316002)(8936002)(26005)(6916009)(186003)(38100700002)(5660300002)(508600001)(6486002)(86362001)(6512007)(6506007)(66946007)(4326008)(66476007)(2616005)(8676002)(66556008)(36756003)(83380400001)(2906002)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ER2Olk9VQ509wkG5ixhjMTRsVJfh7y94XuOz3yhlbnH1P9QerY3Nz/rUIeoi?=
 =?us-ascii?Q?SJzRZ7Uw9V/wjbo7dQiptY4xqR5Kvvdy3t9RCxsxQ6xZrxmCfgclFSf38FC9?=
 =?us-ascii?Q?R8Hs6HCeZbg/cnEflMv4DW9VP4VbzQSY+4XU4vtgNRncN4Ku/plH+Jd9Zldn?=
 =?us-ascii?Q?FfFlxpcexzLkyhMN4eQtm4MNosHIahEJNAdapicu2Jj35uLoE1IHzsD2xzGb?=
 =?us-ascii?Q?r2dcQo8yDlOvNdNiVN9RmriColCwQBKbU55TrY4YG3V3WtLa13lncvrcN8Cc?=
 =?us-ascii?Q?uIbXHBmJ7SkgLqONKhlqSejNnDnekg2uMD0HEfauq9x5th4Trt8cF7giA+YI?=
 =?us-ascii?Q?5inKrMAU6BPEk0ddGcEANMaRY9ojpTXqcYRe0uUUC2p+peseM7JEVB+2QS9E?=
 =?us-ascii?Q?+CimGl5oLVTTxGHCJ66WPJatWiUNtIPnAVYtc3QGLYsWfS+pdG8FYkRjNMCZ?=
 =?us-ascii?Q?35sPwgJYOUgDku3xkkm/1zr3MlXp34Jqw9rO7P2TOrYI+YJIF67Nca+U910C?=
 =?us-ascii?Q?IobiCWwjTa0AB6QZHIdNdyeYoEfm/H1huEOgQdQgm0r1Xu9vkrYHh1rMCYuN?=
 =?us-ascii?Q?DEmLtVEv9TiBDc3bl7bANutC30UmDCghNm85R/yHysAvH8BHhDd4FXRn3G/h?=
 =?us-ascii?Q?nAIfhYkSIBC62/55JlSbnH17id1CAf+NEjoRaiE1D6LAmtUR6m0Haap5KJSi?=
 =?us-ascii?Q?1PfjqfuDkJof/JA8kYKzGhoOcGn5Yvv2d9P9ZGwRSdX0kso9TMEwm54Z5Trc?=
 =?us-ascii?Q?f0T0J/qVmZ34uX5l37u7lltJfReE09HpBqRNTy5l0Hid2D+JM1+CKzsVTcWu?=
 =?us-ascii?Q?jZw1+aufgILWVxCCOnDGSlbqphMJeQ5pSyzqj75y3i+VJWXGRa+oZh/wyr51?=
 =?us-ascii?Q?dXQAjpap48t2jqwl7vvE6NtTnT/ZKw08ZmOEP/gzFUY3vggbhdQ/iYXa3lJz?=
 =?us-ascii?Q?jDxhj3pxEyzynZJBRVdtiu/kS3I333vNcaBbUPJ0Oh09bWYlAuSx6aYOwXlW?=
 =?us-ascii?Q?cQodMrUR7Urab4fESV3OI9OgWh4rvKYrzY4tX60rNZ7sCvDGfLEytyEhUzlZ?=
 =?us-ascii?Q?wVIW3+FMTxS0KBVWk6E80CHpdpCo0Dxbd5kO2/dK4cnNAAnEbt1DSSqHBCSF?=
 =?us-ascii?Q?8VnS7WwsJPhIZp+sLoGSS7M6AwFQ9kyk392PXSQJOiH7HahtVvn2HKjctWQt?=
 =?us-ascii?Q?OXLy58vvKRg84d5qIlwKMh/IVHcnHmD9D0dEESvJ/Af6au9abARVhv40jlc1?=
 =?us-ascii?Q?3xV7ReVSBQxpjdvElAAluL68QYonM2FThvVzBYVw5ciou9H/If4siBkilbWw?=
 =?us-ascii?Q?LflFl01KM5qBcD8rlDmn7K0AKB9ASo6NhQMxf49tbipL9P9ogJ9kFM8gR+Rs?=
 =?us-ascii?Q?tkDI0sTRTsjLzRAcisVAAlxdFbEHEvkFJfVmCVwmX3du1wTqWhBLvfyTRzC0?=
 =?us-ascii?Q?or3eKaSvmJtJOs/Pto67wcgeH0s5UYOX+0s+knIawRYLk344XUsO4lEOwlid?=
 =?us-ascii?Q?+xgjI9nIT8gZ16oc1nj8iwfLk6XQYXIua4JZlwBCVcx9UHsHhF411maiMEKG?=
 =?us-ascii?Q?5OpQuAOoTJDhetcNed8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 335b7694-9ced-47f5-5d49-08d9fcabcbc3
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 00:21:43.8732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DWg6taomUxjq4OrA5V5befOCZRvaCHMeSfyDUoumgShs3ST3mN1+FhpRIKVf10l5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3298
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022 at 05:29:02PM +0000, Shameer Kolothum wrote:
> +static long hisi_acc_vf_save_unl_ioctl(struct file *filp,
> +				       unsigned int cmd, unsigned long arg)
> +{
> +	struct hisi_acc_vf_migration_file *migf = filp->private_data;
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = container_of(migf,
> +			struct hisi_acc_vf_core_device, saving_migf);
> +	loff_t *pos = &filp->f_pos;
> +	struct vfio_precopy_info info;
> +	unsigned long minsz;
> +	int ret;
> +
> +	if (cmd != VFIO_MIG_GET_PRECOPY_INFO)
> +		return -ENOTTY;
> +
> +	minsz = offsetofend(struct vfio_precopy_info, dirty_bytes);
> +
> +	if (copy_from_user(&info, (void __user *)arg, minsz))
> +		return -EFAULT;
> +	if (info.argsz < minsz)
> +		return -EINVAL;
> +
> +	mutex_lock(&hisi_acc_vdev->state_mutex);
> +	if (hisi_acc_vdev->mig_state != VFIO_DEVICE_STATE_PRE_COPY) {
> +		mutex_unlock(&hisi_acc_vdev->state_mutex);
> +		return -EINVAL;
> +	}

IMHO it is easier just to check the total_length and not grab this
other lock

> +struct acc_vf_data {
> +#define QM_MATCH_SIZE 32L

This should be

#define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)

> +	/* QM match information */

You should probably put an 8 byte random magic number here just to
make the compatibility more unique.

> +	u32 qp_num;
> +	u32 dev_id;
> +	u32 que_iso_cfg;
> +	u32 qp_base;
> +	/* QM reserved match information */
> +	u32 qm_rsv_state[4];
> +
> +	/* QM RW regs */
> +	u32 aeq_int_mask;
> +	u32 eq_int_mask;
> +	u32 ifc_int_source;
> +	u32 ifc_int_mask;
> +	u32 ifc_int_set;
> +	u32 page_size;
> +
> +	/* QM_EQC_DW has 7 regs */
> +	u32 qm_eqc_dw[7];
> +
> +	/* QM_AEQC_DW has 7 regs */
> +	u32 qm_aeqc_dw[7];
> +
> +	/* QM reserved 5 regs */
> +	u32 qm_rsv_regs[5];
> +
> +	/* qm memory init information */
> +	u64 eqe_dma;

Am I counting wrong or is there a padding before this? 7+7+5 is not a multiple
of 2. Be explicit about padding in a structure like this.

Jason
