Return-Path: <kvm+bounces-11376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A1818768E8
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 17:52:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CCBF1C208DF
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 16:52:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2163B1CFAC;
	Fri,  8 Mar 2024 16:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sgEowgLW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2076.outbound.protection.outlook.com [40.107.220.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4A4179B1;
	Fri,  8 Mar 2024 16:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709916765; cv=fail; b=TkzaQxwsFEHub1pRlvFb4SQDwhuHX400VcXgY9PNErDrWVx0CaeCxzrnsyI/XyPJmkQEC0/JwLa32VBhgQEqD+BKK5G1PlcHzBbUtTsM1S1bFGg0Nz7yR2IYpL9/bLw1QaXc6YSnltTLG1G/CoonDQYUQTMvx8+Z7vQCZjOFnxw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709916765; c=relaxed/simple;
	bh=ND1ZDL2nH2hQR6V8DzT4YAiKmBwDYGT8znlt9PVpzzc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=C/1ED/qgy8ZkMHxDMLvMlBs4n8q91wo4BlAM+oXDBTzJ+J2gJZkQ0OtAG/ZPs7BEZLUoPdqEM2Nu6i+dn5srxmZT4C+K2+A45j/+lLHV3YYzxnS19qS6ejhH2jEsyORusiBGBSXiMdq1OchVIHugRl9hNywpqZfVqZkZG872ErM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sgEowgLW; arc=fail smtp.client-ip=40.107.220.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmak2JhFsExQL+x/UVymj5f95G63UPImrAXwSk4E1TUyfF68ZNXWY+Lf+XmTCh6MI9qoyuvG/h4Fw3vFnvzZHxSXxl5HF+vnPoKO1B5ThbGimaWc65hPfYwW8fjx4hUCYTSwVLMThH45AUr0EAgtPyMX0hpMRBjKUxsqxaclq8DKMM80H2rrTjfjQ2vdLbVgfqnpqnmWUH6Dc9UwFXr5rxWvKYeaSEgS5J+xVG/ER1u74OlHk3z7Ds7O/KEYGbWCD3oZDzRdFNbPyTGn519RlVhBoDQSAm9+hyISRXunxbxV8WGwveBJlCNDqjvpsjlwUXtkur1fvkW6P1LDFKzMcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yozgr54+N7OPj5Vx9Pm3yQ4xZXKAT/012iRB+m81R2Q=;
 b=C7xu/vWb73qYSYywhPdTv28ZidlreNNI5rgMsMP/f9/+YUcUhDA0mJbxJg/+a1c/7VzeAzMjD+2X1o6gQEAqtTwQahMf/WdqA0kakWrUqZYrqFNigWghFK41joys8QJh3T/kc/sGoP5jRhTK8Fl0+jkpbmd6hjQwryfI0ceCY3f8bywhqRsIL2ovI5hp/lBFwvI9KUg4MGxWpn9oLHnuQMEAT8U002IeNuF/VtzfuorEA2mz3xRCYjEfVNY/PQUtSr8RMN0A9mYBMZxCbzM3bzdmuSLPte/jAQTmJdO37Hk+MHcSo5KvilFOfJLdJ5+JycitiOi5WLkskyZ0qKd6Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yozgr54+N7OPj5Vx9Pm3yQ4xZXKAT/012iRB+m81R2Q=;
 b=sgEowgLWcMZvHSg2pA4VfQVO9rPmDr5LcL976kphDZmx6BXHqvbxUWqp0TnB5K2A2UJNzgSZdjaa0es5KRnrBSKMt7EaFBB67qbKJK41/yqEvf/lcZyBxnRCZEJE77qoM7HRlWKsu+LsjXShSV76PEhUWN4ogww5q3H5cU9b0sFrmKgXbNp39TYLlSNgAtM6NRgr2RecjipKV9bXYf4X9xQnAun1aIEBjPjZUsOOLcsbF77R1GhLUvSnA9PzuLGcE4goP+i354LEqpcXp0EDvfzpCoSdD/xG3rudaavmbR5qfHn/Ai3SVBa81KS0ktVZH1ecZcWsvDVujSjRZGhCUg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SN7PR12MB8004.namprd12.prod.outlook.com (2603:10b6:806:341::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.26; Fri, 8 Mar
 2024 16:52:39 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7362.019; Fri, 8 Mar 2024
 16:52:34 +0000
Date: Fri, 8 Mar 2024 12:52:32 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Xin Zeng <xin.zeng@intel.com>
Cc: herbert@gondor.apana.org.au, alex.williamson@redhat.com,
	yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com, linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH v5 08/10] crypto: qat - add interface for live migration
Message-ID: <20240308165232.GU9179@nvidia.com>
References: <20240306135855.4123535-1-xin.zeng@intel.com>
 <20240306135855.4123535-9-xin.zeng@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240306135855.4123535-9-xin.zeng@intel.com>
X-ClientProxiedBy: SA1P222CA0186.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c4::18) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SN7PR12MB8004:EE_
X-MS-Office365-Filtering-Correlation-Id: d4d9d062-d8b5-420a-1379-08dc3f9026fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zzGhYtrJCbh2TMoXjTowoDatfufXTJiPk8z9PlwJmX/jt+cXBGSq5EzFk2/+AB+eJFjvXt103xfwBXePVZTwDIAav2LTuomMp3w7d+t2+jNrKDpUQ86BpTtJ3q5uxoKqdmJ02D0y2yZzUnlTTvtFCzLSNdZj/WvmwSKv2JORUAn4d7B5hXmw7RdriuMs9qSLnyOOEwNV8XN77rTe33l51Ktc/+VGcliti0MyusSTebHMjOjB98jwITA2ccUtEs5IcmocuT36t3podhIN4UTR+I/Pg+OR5DltXG5VKNqqB2Q9bpJiXCJasz/KG9SBvImeURsGPd6cihR5BdiN8lAQc9RLS0JVawlZGF8MF8Vj3kC8K6jeFolzX3GYY4kHof4kB8tXiOGnwbKjMb3AeWTD+7DrZ2J7Dqn1Y3G7MTqerc67Ign5FnD7/92JqfcWnFyLjP8MWLSiAFSEBbv8V1w6B3mwApfY716VVqjW81fXBUEfa5GpbKpIZLyTm5XecYHyiplxZHZjxfJXhQnWAOoZ38SJn64vgsp0qRWHGOLNpZQvo25dKtYdFmp+0QgfiLoLnzfDtj9nuxEq6jAn1lCVaPBAu/3vzgZVyyiaafEuxUyEDBtV2C5oGh6M+UeP/YiDdAhSLVhShto8rQjMq9IjawWXI3/5L4rgJBfvl8MxARI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VTpKBRNgDw61b5fOn/1kvkMT68ogEcqXmCwPJwyutAiP2yZRFwygP5TjqoTY?=
 =?us-ascii?Q?7wL/6Ny/p8bChP6sH5IPzbk+H5lr23/LGV/L3Q3bE8OgEf+tFny7rl/NLiGq?=
 =?us-ascii?Q?TrgWrvFjo5G9Xxkti8JaU95ZPj2We2Le5y5/B8BHrzSDPyutDMEkbsuKW+d5?=
 =?us-ascii?Q?zIFeI/YULD9TmV5DXNPg5jr6Y6s1+R3LFAfoaLjM3GH/HBRaV5ooz+a6o6JL?=
 =?us-ascii?Q?fAFBK/7xez/j+76jBP93tzZjsk1PEgv3+n5U2W5XjVDr7q/IdXqYbSAJ7LyG?=
 =?us-ascii?Q?W/6oqD44ydcaoY06s9O48u7y4ZsLW9qAMRm8VcZ0OZMcLjA+ulJsWdF9YJal?=
 =?us-ascii?Q?gbp39utt/dhwiwr6eby2AE8L7M8RuypCzoGHUD0IXoynT9lu0gTVu5f3PdU7?=
 =?us-ascii?Q?UhZZ8PxepA/f3E3jUQHIfTXrE1hym5qOI6E6nXmqgL6Rm61Kl+fkxLpE+opJ?=
 =?us-ascii?Q?qhclrbJonXIDGiXRVKPYJiyGgPNkHGPBGtMvtR4UbgJdcAeoVgy+Eg9OPKIJ?=
 =?us-ascii?Q?KLu/iuGq3DTmqik51rg03f9beMC6jOWpuM7fs8G7smgwm8ka8Gds8wNLqTxF?=
 =?us-ascii?Q?gg8HHemU1XkiOuAL57z4dV6bi7L2iWjmReYIon0lgEHyW18pZn/O/V7wWyOJ?=
 =?us-ascii?Q?2WFMolufIn0OnvaJaSKSt8ozLXr7sxIKBILnfJrk5N8MWSNJMlJ+9GRJ00GO?=
 =?us-ascii?Q?I50PXwJJpYS1wxbNSoCXkg38KDdIJO11GYOoA/RBZjTvNOjcJdBoVQ9hqlW3?=
 =?us-ascii?Q?A6du0PyhrH5J8cigteTafLGOmpY3NEYeish4FBqznNz0fmvq9kIJQW0lx5vu?=
 =?us-ascii?Q?2DdRoKkuktuioYq/nZVq8RNsD4qoe9G2TW7UGz7/sMw3vzRlhYdqL3GU3jZp?=
 =?us-ascii?Q?QSgxmXeuLzOJY1+/CrJi3nkVHTD9Qpi2ziIdHu7Lv5XrRUJS3b0YE6KnsWlI?=
 =?us-ascii?Q?R5voHfBjH0yFGwhOfibwtqWy0kATYY1fsp9AhNjMzLabitdA8TRG0eQHgdI6?=
 =?us-ascii?Q?Ufg7xCEo/1ao5XVgoqHruzZSevDCbSoIl0lTcfvTlZq5JL589eC4e5ZftkmX?=
 =?us-ascii?Q?EQpJRZOThGsuV+KDHOJOd8UfB07pcDVbCXfJ7rhsaj/3lhfjVHT76uhMdJP0?=
 =?us-ascii?Q?RXx39rJC0sx9lGOeFutVtEVfN7MaW46SndUR6iw7pKKB2GnnOzo+ARqp8XK9?=
 =?us-ascii?Q?QWR41riCILpKQsW/MRunGePH4PmSE1nzDUh+GaQQ3izanTr19RlGNqsDvbax?=
 =?us-ascii?Q?IBV8BVE5pkzkOamhmNdDFyPy+Ks/hb1DI7+gFNR3Kj3MEhkjy4g2kXLs48wN?=
 =?us-ascii?Q?ZuK8XKB0QHWM35LveXvuBbhxA2QOkR5eNE5HheTqrrwabteLKu9q38IfQQU5?=
 =?us-ascii?Q?t4aT77OhDKLvJRKqPHQC5203LcZg/CaA/pj6sEx452V9f6Bgy+7ToQc5uT4a?=
 =?us-ascii?Q?UmJxAPGkfcjho+5I1W/J7/EDZBHj6KvSCsIWwJ6VAUPLyQVDPygLrwvMziFn?=
 =?us-ascii?Q?zupLemhStTHI9Dw3+yplJ1Q45iyeGsPlWs8vesrXAziQ0doWZ54LsfonKHOq?=
 =?us-ascii?Q?7+WwmfLGyCEu+udszUoZs/WZ5S1rSjocewGQCp7w?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4d9d062-d8b5-420a-1379-08dc3f9026fc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2024 16:52:34.4639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VrVOKEmN2REhKZqt0sUu/Vt4dAaziiFIxzP3W//DYt4ZhCJtRN/b5cjkt3CuK77E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8004

On Wed, Mar 06, 2024 at 09:58:53PM +0800, Xin Zeng wrote:
> @@ -258,6 +259,20 @@ struct adf_dc_ops {
>  	void (*build_deflate_ctx)(void *ctx);
>  };
>  
> +struct qat_migdev_ops {
> +	int (*init)(struct qat_mig_dev *mdev);
> +	void (*cleanup)(struct qat_mig_dev *mdev);
> +	void (*reset)(struct qat_mig_dev *mdev);
> +	int (*open)(struct qat_mig_dev *mdev);
> +	void (*close)(struct qat_mig_dev *mdev);
> +	int (*suspend)(struct qat_mig_dev *mdev);
> +	int (*resume)(struct qat_mig_dev *mdev);
> +	int (*save_state)(struct qat_mig_dev *mdev);
> +	int (*save_setup)(struct qat_mig_dev *mdev);
> +	int (*load_state)(struct qat_mig_dev *mdev);
> +	int (*load_setup)(struct qat_mig_dev *mdev, int size);
> +};

Why do we still have these ops? There is only one implementation

Jason

