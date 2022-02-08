Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633194ADB19
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 15:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350914AbiBHOZc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 09:25:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbiBHOZ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 09:25:29 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8813C03FECE;
        Tue,  8 Feb 2022 06:25:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YhoXAyshfsJ0j4RredlepLs1N6AuOMAWXvpX0DcF61mvyjwe/MyqcSCZcFddKwrB6yv5bo4DEU8XcvyIn1Hiv9nkb2THq6qUai9AVelq8oOw1sxdi1KdzFya3CK6+ZsTu0ZjXGIJBR/H/6u1o/O6Am06hwK55cQ/L3Gh1xIrgUccQzim62O83gdHFtn4PMElkfaQjzYHHA5M+ccOE5/Dxb62lPuIdlf5aVQIDrna9v9cAzo0FdHTuSPlGGW/C0L/duIQmDT7Rl3gJjRMj+cA7IQv28ShcMwzFi7f/wW2UJIqlq6X8DjYOBrTbUUGE4Uv0uVa3sqRP1lblYB/FK26yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EyW/gbT74Ej03+W8Ptt+7HFbZ8syWo955rGIjHdQOX4=;
 b=GQOVxjZz/bV+xt12DUdnUiesrsIKrPSeRP645Zu7j92n2gzRkjbNwlaP6GmuCX56YHkLF36efUlQQ/vXaBcMASFiV+59qBdYH7dY1p0zyd5XGFmfiOOARWqcCiYu4MQGF+MonCc0YE4iNbdklxDcewpW3mFamvxRFHRk3wEUT+B9VrnLidJAtGeKlkv3V8rPIh20MCcp1W+fTqS6taCAvkG+IMbZ1KATHeXIdArHSdA+5sRG+V+JS3wlRJG/88NhPQSmUPsegOZySwGNPewQvjkJMRogp8MaRpIarNJsiIIPuPB/tqNF7/S+yCv/MPXVfdDOg84ylDrPzlow/uV34Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EyW/gbT74Ej03+W8Ptt+7HFbZ8syWo955rGIjHdQOX4=;
 b=OQlmjjAflzl5jSk05xUrLDbLuepcyXnACbelGSINcBVehY8oeIwvxAUjYomD5iL7/6u/S35DttJWfa6/mk3TqULoy+eBV04cYbuF0NN8UTdx/7A3GkyqD2wxhjHkCG/msZWgn7zdHfbsmScTgGHFMuARHIpvEbqFqAwzjM8yKGoVi/t7zKt+easSW48bZ5rSXXQQHZobwgAJbV5DOJBl1UDBU0izqq9Zj352Z9ENjXFH9UUSm6RrSgtKncBrfArQpkSsXSoSDMTBzoD1meQPznMiG9LIgnxIWd/0EVj3A0F3xfcNazEzP+2IupFpg6zi1T/UX9BEL8TtLlEPyBSxOA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB3386.namprd12.prod.outlook.com (2603:10b6:5:115::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 14:25:27 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.011; Tue, 8 Feb 2022
 14:25:27 +0000
Date:   Tue, 8 Feb 2022 10:25:25 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, mgurtovoy@nvidia.com, yishaih@nvidia.com,
        linuxarm@huawei.com, liulongfang@huawei.com,
        prime.zeng@hisilicon.com, jonathan.cameron@huawei.com,
        wangzhou1@hisilicon.com
Subject: Re: [RFC v4 6/8] crypto: hisilicon/qm: Add helper to retrieve the PF
 qm data
Message-ID: <20220208142525.GE4160@nvidia.com>
References: <20220208133425.1096-1-shameerali.kolothum.thodi@huawei.com>
 <20220208133425.1096-7-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220208133425.1096-7-shameerali.kolothum.thodi@huawei.com>
X-ClientProxiedBy: BL1PR13CA0213.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::8) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb235078-df42-4a16-fdab-08d9eb0ed9e7
X-MS-TrafficTypeDiagnostic: DM6PR12MB3386:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3386C3F52F5ADCE0F74AA1D5C22D9@DM6PR12MB3386.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HMG+v3caNkOiapFN5715t16D4am6DF6UkVtCdpesoQ4uS1fJhiQoX9xvJMjtklcyqtJZUJBNUWZSzNPbtS7rPyU3GCOU2PwSQy1aR3ngtS7NTs8w8DxN+GE6gDEZxWQRO32rY89/KeKUO9w3ib+tnmeCQtp8R3GeH+UW2Gw6BO04SFL6GqsBp+1VlKjBL4u57hZe2nj06YNNNPiZ1teqfj+uyBeZgR/otNp4/FvtU8Suvk0jarB3UaT4D/+Qel3RpTwbp64/Ui8RkV4zKBiG+tKMZoyMll/1gHoC4ie7w8BbXiQroH8yuf8DtXyspZgedR7tHUwKXSPjoexP4bKZK5iRplByuT5QQ/PVz0wUhZGyJIwT4LZ9vgLmcv7iJBH0RO9HJPd6riwOAbMV79595Xg1ykvWJX2GHLwtCJ8PY49N2ctmOZflFUyAW1kdvhphwgCzWoRlhqs0L1bH2TbM5pI1wDNKgmMUpJfGRSvKZaYklsbxgITbsYcGD2l9p0fy8hpsm0iK4f8EoGbSz5Uh1OBJ4pVqf7ztYBwcjkcCV+tOJBWq5T9o09g6jqfqF/wDELufOc1oxn/7s29ZXLmoVWjf2zS9UA1nG4WsC9pd/LP7dDtyeYpl30RO9b1FUn8EA5Kt9ZlyVbEIh6DuGwWbRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(33656002)(6486002)(36756003)(8676002)(316002)(26005)(66556008)(66946007)(66476007)(8936002)(6916009)(4326008)(186003)(1076003)(2616005)(6512007)(508600001)(6506007)(86362001)(5660300002)(38100700002)(2906002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a7NdD92z9giKuMUZlFN+KRr+GBoHBnG3Pp5NjwuBX/ycxKG42tQkvKvN7gCi?=
 =?us-ascii?Q?B9bf9eFIxkvYnA/eyCPwEnvEbFcydcalMRDC3BUPXaBzJgMf3IUmKdgpYsUs?=
 =?us-ascii?Q?Y5c5UnDfMWzYMYQBk+izHszlabvIGIPkEb5Z+ET0obYVFjxPo6ML17CIoDyr?=
 =?us-ascii?Q?DRPx7UB0xNm618pmfthGNoUEn8Ab5e9QH2gIahjVLKg/9Nuop7yS+KrSLB+9?=
 =?us-ascii?Q?5glJP+Aux342Z2eVURqZRY6U6CEAVfrtw0DsoiFjZ3jXaRC00+zwmigb4p/y?=
 =?us-ascii?Q?VHaZR+z88m9umj+0f9RgKmkKH7PXfW+p9SudaUUe9sqGunQrsgDE+kP+xZRg?=
 =?us-ascii?Q?ByZrudtOXwM1DTDhfr+5IeR6KUPqAKh9ItMC7W4KMnl65CNTTY35qwOmuvuc?=
 =?us-ascii?Q?EroAAU52crzH1enpQq6zZSLEQjwtYzpr4rTyrpvfI/5qa1dAPhBJJBs+61+w?=
 =?us-ascii?Q?7xZDWKNsNpNP81yLrZr5B61TmxLFXt2WqD+7Yvkjd1C8pAbuJhhkVDHhhOOn?=
 =?us-ascii?Q?eA5ehhVMtzIPFsP8CjWMck39ZTxtbCJCbqWUKeZYdgEId0wZKORfvUsd6qxY?=
 =?us-ascii?Q?oNaELpQQXVhEsbUgrtqJMwDkjnGFI8isG8Rr0y8TiB0fw1dZ1IeriUgNpKXV?=
 =?us-ascii?Q?qPwreJIjMz6lhgrCWSjJ5H5C72iHoQLQ9OpyFYtSfDkWNIT11nYTdsaqOUqo?=
 =?us-ascii?Q?HV0oMLli3ViTwAcHM32MmGsfC+Z8zXMibkMpvOLN8Ti8/6lO/I6Q9gS7Fc4C?=
 =?us-ascii?Q?9pwfYvRFTGv+rkV6TyUJTVX1no1BOYd6v0sYw2wu95JBYTrRElXSJWwp7qgw?=
 =?us-ascii?Q?T9rdrTcVqd1OtX3S18uhbCsBUdWgFqddTpC8C9iIUpljZ9QIiAFAoQ0ve/mU?=
 =?us-ascii?Q?vTXDaLYbyoYzmd2vCALnsim11Moy07nUYPTEM+c7x1V4OHMVN9Hd+7ucYl8A?=
 =?us-ascii?Q?bH29EP0AsQiIFMJigFqwC9kOYWtou7N/g3MBywxbQOFjZGxb12HBfPsrnd00?=
 =?us-ascii?Q?ywKJntllnKkSIGmgkSs+eTQtBWxHEFCmb62we7wDcG6FPyTs93z+rZwGZ94T?=
 =?us-ascii?Q?V91cm+WZ9KjwSYl9pqBX2/+YNtwVMCgrVVeYMrYsvofI+VAMIa3AcHpDLpHP?=
 =?us-ascii?Q?0Two3uZ2baRzOSXFiL5kp4DnsnSMVK4hqZx9C/Yo3uPjnQK27yOhW7vC75TC?=
 =?us-ascii?Q?2MXBOOi66sJz5sowG4+MWngx6wPw92yTEfcGOxhzKzlQQzg+jhycRPEFQsid?=
 =?us-ascii?Q?8Xoo+XUZlOOBhM7VKW9QbGze/Wb84jGILKguhOaWYxIdb8Q5cLU/6KpH2Een?=
 =?us-ascii?Q?EDoxy2y1mSYQ9q6QOaSl2RGAfY/8eimf6do0zUJVYrx405UQ9YM1a+fgkWMr?=
 =?us-ascii?Q?iaXda+I3AwYs6a6i2vnEdqzS35NswOYlIA3BzZ+XfVKcu98nA041A6YN5LJ7?=
 =?us-ascii?Q?tq+jCN4saqs7TmYwZFPVrqjdRuxLEtf+IHlP7i+cJ62uzF9v9qsIK/4ZnQgP?=
 =?us-ascii?Q?bGFsyBZ0mnxz5aOQ+RR3FbV3ROX9ISG3EjMn4DEwovtTJkClt4US7HqobKMy?=
 =?us-ascii?Q?nRPLX20vQLsQaxwE1Dk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb235078-df42-4a16-fdab-08d9eb0ed9e7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 14:25:26.9140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NEv9wR92Bn1qkGOdKOYz2EE5G0Q/l11tmL9rw28xdpa46Mdor4CWuk1xyTfCf+YV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3386
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 08, 2022 at 01:34:23PM +0000, Shameer Kolothum wrote:

> +struct hisi_qm *hisi_qm_get_pf_qm(struct pci_dev *pdev)
> +{
> +	struct hisi_qm	*pf_qm;
> +	struct pci_driver *(*fn)(void) = NULL;
> +
> +	if (!pdev->is_virtfn)
> +		return NULL;
> +
> +	switch (pdev->device) {
> +	case PCI_DEVICE_ID_HUAWEI_SEC_VF:
> +		fn = symbol_get(hisi_sec_get_pf_driver);
> +		break;
> +	case PCI_DEVICE_ID_HUAWEI_HPRE_VF:
> +		fn = symbol_get(hisi_hpre_get_pf_driver);
> +		break;
> +	case PCI_DEVICE_ID_HUAWEI_ZIP_VF:
> +		fn = symbol_get(hisi_zip_get_pf_driver);
> +		break;
> +	default:
> +		return NULL;
> +	}
> +
> +	if (!fn)
> +		return NULL;
> +
> +	pf_qm = pci_iov_get_pf_drvdata(pdev, fn());
> +
> +	if (pdev->device == PCI_DEVICE_ID_HUAWEI_SEC_VF)
> +		symbol_put(hisi_sec_get_pf_driver);
> +	else if (pdev->device == PCI_DEVICE_ID_HUAWEI_HPRE_VF)
> +		symbol_put(hisi_hpre_get_pf_driver);
> +	else
> +		symbol_put(hisi_zip_get_pf_driver);
> +
> +	return !IS_ERR(pf_qm) ? pf_qm : NULL;
> +}
> +EXPORT_SYMBOL_GPL(hisi_qm_get_pf_qm);

Why put this in this driver, why not in the vfio driver? And why use
symbol_get ?

Jason
