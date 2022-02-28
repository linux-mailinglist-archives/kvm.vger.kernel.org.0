Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D225E4C702E
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 15:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237434AbiB1O6T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 09:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237419AbiB1O6R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 09:58:17 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A280BC13;
        Mon, 28 Feb 2022 06:57:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fHNsAyBpwA8L79zTsJYoD2FBRaWQKLe9aESa28imlgfyRW1oNX9T3vth7U4VbuIuFBk8gYpDWhk85AA4ftDGg+oA0porS6eBmcGKKRQCSNkd7IM4fMR5hWPplby5cTQyy+DENBJPD6r2qu4E1upcXS1omjea0L+UmZ0j/JEau4BCx1AtGlYqUL3ueNx4Fhxg2/KRl9vNrXCzyGfkc0H4SmEXXz5eKGH1iPM7a/9JLzB3pO5YxJhnzmPFUDzdl9eiBbZzWUxNiJYPRejH0d/Do+s4kk6AMUJqE+TB+G8uU5xA8KZeP0EGYPZu7G1DOc9aQ4Az7iRxnsPo6dUAosUTUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FukeVZ8TyX0us+rIetfXWapX1YaVSsEggt01hyYQxec=;
 b=WjKQ5tehR4fMu+NkeNAtyZI//tJeS5AWJ07Tq8KtuXBEUBoQMZ/U+1zFoVSxFCeZPBkKCYoAtzDtHnLmKZakEaniqzNYIQWprmzkPgrp0CzJSNjLJfpMp0Vtq06BGnCyE9gMEXSQnEFNGP+1UTp2d96be3cXiA2Pu2pVbC/Z92qpzTo1out051CS99OhVh0wot/DdEfvtTYf+sovwYjiFSPLJPCwlba8uOSDnbH3t/fPN4ef1tiOp+lN+2IhXJYD6pu+RrArGTj6DPLowzz3lH2XsDkQo6pcZKifiOkxVqT0zg/rU+czbgYV/thLMheFyJ/3pXuxnzhpv6ORVowRiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FukeVZ8TyX0us+rIetfXWapX1YaVSsEggt01hyYQxec=;
 b=T0r642A1fPy3eY+rJmtPSmAp35zST+j9d6XtxXSBGWZ/uqV5ogS78Ai/TwdolyCcQ2Qy7BT9oX4ckKCXsMKCvwvpXKuF9NTvVjqQQpQjkbqGc0ARG6sjEqqY9kfRuP/4q3qijKtF8fXPNCIsiLrZRIR1BvKK2l0PPb9lwh0Ro86WFwiHBYUucbd6PnfRHC3+sGeO/FeUacFUu1T0dp1QxQ/MTI+2jSGYILlnMBRNsEf4ng/dGmzXCnHLsd310/jLTqC6riDhbCYLAEKQ0Ggfd5+kdxE0LiMAjNIi0eI+lwTWOLxbctVuii2+DBxgW2Rc4syzerDX4W6uUkUO08gH1w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4762.namprd12.prod.outlook.com (2603:10b6:5:7b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Mon, 28 Feb
 2022 14:57:32 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 14:57:32 +0000
Date:   Mon, 28 Feb 2022 10:57:31 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, mgurtovoy@nvidia.com, yishaih@nvidia.com,
        linuxarm@huawei.com, liulongfang@huawei.com,
        prime.zeng@hisilicon.com, jonathan.cameron@huawei.com,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH v6 09/10] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220228145731.GH219866@nvidia.com>
References: <20220228090121.1903-1-shameerali.kolothum.thodi@huawei.com>
 <20220228090121.1903-10-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228090121.1903-10-shameerali.kolothum.thodi@huawei.com>
X-ClientProxiedBy: MN2PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:208:c0::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34d99b89-c462-4bd4-ee44-08d9facaa5c1
X-MS-TrafficTypeDiagnostic: DM6PR12MB4762:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB47625A0934C75DA89D06C433C2019@DM6PR12MB4762.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cYW7fra1rIBGQWo1iwMg7gCqjNCOb480hFb2dSau22CDCqExsiwKDCSUQAw89SXuFhSoIKq4J3FYUJ4T+BLqZyZvZmE27DH664IqcMeYowoCNx+e/gt/g6mWJ3bVXnkl9F51pokMx8f8QR6nnFqDzNQoEDVG43Y+k+c4bNnbLNAt7Ecnq/JytUPt9h0CIX+WwaZ2j7wnHhX2W7Yo7N3HUNgvZMpcCr16lVwPdKm6mV3S0Z20IYOleLf7M8Auiyy9918A7K2MgCZQl1kvJJeQ0Ku5WNdKSxDeh83VaqaHQna9S0GdLuZTZznDFw+myDj1mN1bUjEdvxHD2uH8kjcG4dZsb1lRU52kLWJV+WQ7ZAVQHKcZ3/qn8oOdu7hMupIHA5t9ENONk5s2teK5AxdUbY4NTjMPq6IT0jDe5DiHbpzYTNTbnYaf/NFCVOXZiIjCgd1DaJ5EKKyeiFOrBuL+Pu9DIZDQXnxFo1sG1ciSVf8M74MskLYrw/GX/hddYVP0NfCbY9X7ORDyo5kSbtvvUtgX18BDGdvpD6nsksh1yjdffLCOeqxx2CWTwxqhKhL4Nd38Vq4Iix4QfuoVQ+HfQLw8xlnoSGjA6sE5AZsSb/CES62ucVKaXN352E3adKeT12k7zQCKQSZaHY7GZ9yGgxpy8WzMBWJ1fYimoDd/YGtoi0qW6PdFDgirPB34a0E6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(66476007)(186003)(26005)(86362001)(6506007)(4326008)(8676002)(1076003)(33656002)(2906002)(2616005)(5660300002)(8936002)(6512007)(7416002)(38100700002)(83380400001)(66556008)(6486002)(36756003)(508600001)(316002)(6916009)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T0vsk83EOteUnGa2mhSDgkrhkdXGUu3zFq3Kt1LWNxAm3orKAxLyM3N4lMf0?=
 =?us-ascii?Q?6PKZzP0gOHjMeLkxEikeo/ywnKeJvoX2l3cPtHVEFmEYkNIfP+MWh3GG3D17?=
 =?us-ascii?Q?Jz/vzoediiDTmvbKcJ2sxC0cYD7xY4fst15meVdQnmda0EpCr83APmTTLud+?=
 =?us-ascii?Q?iKRTLZNciTfZFfVka2WnPalm8jY+rL1rwNb577e8NwGBliAjul+drzGsPllL?=
 =?us-ascii?Q?7HQoJzXOptXN50kkb4hM9Bh5UrGJ4RzvIRukvojJaDqd1x9To3mAnsQ1zEJm?=
 =?us-ascii?Q?AYRPILAsl3hgt6wovF1tDY0U3GdFLDVa/pVoMzmJ0vy9EzV0Puupe+EL6TVZ?=
 =?us-ascii?Q?n8/EMoUJXnjrjqy7Ih0oR28NK5UrBcr+78g09IfToS9cVGW5ErNf/sQNpCes?=
 =?us-ascii?Q?8Cz2vVIJILciQ797C3u9mrXeZX+0Xbk5TdYAwCcEoyk9pubWNbku1ZlNpQlo?=
 =?us-ascii?Q?t7aoOuAHRImJNdtf9WA1s8aHL32SSDIkr8K7DvO5gXyA2qaoJ4moqVU7EtXS?=
 =?us-ascii?Q?BxLIRR2FzmMUXoVqph+x76p3rMLCUhlqTGu8fVeZ7I6tUZlQlRU3u0vRewPd?=
 =?us-ascii?Q?evH8BniJ9rO8DYDbGYXoT+cx3lWIb59Dy95ROXRZeoi2enz1W8RC63nZkevn?=
 =?us-ascii?Q?dr0NGZWZ32+QeIe2tgLJzOSx1025EBA796WDPuxZBwTCBgMLnjZY+y5Eh/Tg?=
 =?us-ascii?Q?1up01vuSZGnW/DVFmHoDf383+S9/pP4NCNKSiYSMO8QV1nTVAN+XBWa/VlBd?=
 =?us-ascii?Q?kB+q/uii/N8hji8Ls91sRg9pF/zFHr1w3gR4mRcTV0CmSiAArGEeqOZMJ2L2?=
 =?us-ascii?Q?rabJivGazNsLImEKLXoT8BG2/f8ekqM1v1u5b4SAdfs5bLFNf4Qk8M/BTENN?=
 =?us-ascii?Q?hNr9QPtpTzLpnWZSsZ9zikXUbGRUNQqA6HySHoQKugPFkZowPCuuFWLKNtrV?=
 =?us-ascii?Q?SBWiIe7d9wT+b829FJ/PsBM22xor2P87zeqhf/WNY2eHo7Ip45M/xKQ8euHv?=
 =?us-ascii?Q?F3mzUqGr/lxh8WATdZbmvAXRwh/a0D0BPCJYExgRSBv5IunLd+MHR4KZX6E3?=
 =?us-ascii?Q?00iC7QKSBXy3wmj4017uvC/Dt7yWF+yze11+DyP73o7frhpjVvB5S53GWggn?=
 =?us-ascii?Q?4j9ChHJu2e4wBSrYFoY4PfeNodAJcYHhx9DhG0uZady8+0OLTUESpBX8VsrS?=
 =?us-ascii?Q?emB76S0701zmowg7PcS2wWdfKJU9IJ0fHwYNqk8sXJyfv8IbQj51YnvQU3k1?=
 =?us-ascii?Q?Ns8H3XxX8dJBjFrf7U8D3H+UBdPBkY5qy38HLI+zUpTsrjrDiFAns1U5ySzc?=
 =?us-ascii?Q?vYaO5MMl6oGj0QDTIPILVINhEahed6cDB/0wD0HKl7DMeeZil7S5osoaBP1Y?=
 =?us-ascii?Q?/gKzIRNKeY32z0bGkcmnWUFjG9Hi4SFppiTi2dRTQEzqxnTB9QxUROdTgllT?=
 =?us-ascii?Q?1QYrmIxMfOmlnpCc3mqDtrSKGuWq+TYTXt9lY2P6cnWC3Y/pJDey1pb8A1F4?=
 =?us-ascii?Q?iN0F0pTuosMuUgMk8PBbyiRK5yAlciGU1g5mPkqc9OhKCZbJGlybzDn9OHvY?=
 =?us-ascii?Q?Mnw8VjBS8QVOAzzdm30=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34d99b89-c462-4bd4-ee44-08d9facaa5c1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 14:57:32.2486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mm9ap+vihqaeOz2arWgb9YP1dm9jQ1doFTnhYoob/FfUOE4ydUY5N6r6UeMoudcu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4762
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 28, 2022 at 09:01:20AM +0000, Shameer Kolothum wrote:

> +static int hisi_acc_vf_stop_copy(struct hisi_acc_vf_core_device *hisi_acc_vdev,
> +				 struct hisi_acc_vf_migration_file *migf)
> +{
> +	struct acc_vf_data *vf_data = &migf->vf_data;

This now needs to hold the migf->lock

> +
> +	if ((cur == VFIO_DEVICE_STATE_STOP || cur == VFIO_DEVICE_STATE_PRE_COPY) &&
> +	    new == VFIO_DEVICE_STATE_RUNNING) {
> +		hisi_acc_vf_start_device(hisi_acc_vdev);

This should be two stanzas STOP->RUNNING should do start_device

And PRE_COPY->RUNNING should do disable_fds, and presumably nothing
else - the device was never stopped.


> +	} else if (cmd == VFIO_DEVICE_MIG_PRECOPY) {
> +		struct vfio_device_mig_precopy precopy;
> +		enum vfio_device_mig_state curr_state;
> +		unsigned long minsz;
> +		int ret;
> +
> +		minsz = offsetofend(struct vfio_device_mig_precopy, dirty_bytes);
> +
> +		if (copy_from_user(&precopy, (void __user *)arg, minsz))
> +			return -EFAULT;
> +		if (precopy.argsz < minsz)
> +			return -EINVAL;
> +
> +		ret = hisi_acc_vfio_pci_get_device_state(core_vdev, &curr_state);
> +		if (!ret && curr_state == VFIO_DEVICE_STATE_PRE_COPY) {
> +			precopy.initial_bytes = QM_MATCH_SIZE;
> +			precopy.dirty_bytes = QM_MATCH_SIZE;

dirty_bytes should be 0

initial_bytes should be calculated based on the current file
descriptor offset.

The use of curr_state should be eliminated

This ioctl should be on the saving file_operations, not here

+ * This ioctl is used on the migration data FD in the precopy phase of the
+ * migration data transfer. It returns an estimate of the current data sizes

I see there is a bug in the qemu version:

@@ -215,12 +218,13 @@ static void vfio_save_precopy_pending(QEMUFile *f, void *>
                                       uint64_t *res_postcopy_only)
 {
     VFIODevice *vbasedev = opaque;
+    VFIOMigration *migration = vbasedev->migration;
     struct vfio_device_mig_precopy precopy = {
         .argsz = sizeof(precopy),
     };
     int ret;
 
-    ret = ioctl(vbasedev->fd, VFIO_DEVICE_MIG_PRECOPY, &precopy);
+    ret = ioctl(migration->data_fd, VFIO_DEVICE_MIG_PRECOPY, &precopy);
     if (ret) {
         return;
     }

I'll update my github.

Jason
