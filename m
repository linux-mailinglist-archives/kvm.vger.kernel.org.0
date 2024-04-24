Return-Path: <kvm+bounces-15810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2684A8B0C50
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 16:17:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A86D1C2332F
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 14:17:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5184515E802;
	Wed, 24 Apr 2024 14:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sgbCbdTZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDDB15B12E;
	Wed, 24 Apr 2024 14:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713968243; cv=fail; b=kGsEvW77yxtrEV/vl/Owut4W/Ts28xsZ6JnNkJgJtLs6mp+ckA0BNWWtm+NdoWwJXFwe+kctERC5sUrgnPfgtnNefgGFzkLiCbGx2OMuI2fkn4LV9/X5+YJ0Cb8608ztIFOQwVICHG00CFmrN3sXiT+TwnmMuupfYiuvUuHI3ZE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713968243; c=relaxed/simple;
	bh=gpvTpZDWQHs6LGyqRRxw1JdOfoEemGPRobijj4ZM+J8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pfhE9jdVivbfGa6Abh5yhkmNirZrf6Tqrj1tOMRC73C0SDhbgstdRTYB5fNKHY1NkWAk16NrsinsOMOgxaF9a2p6MbIc/yQpiQ2EwBTDsGfveWVBzJs06vgDiUKpmZ5rYqocXjDKrXXobuDRbTVEhVIb0fHRKRMToxkTjViwZME=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sgbCbdTZ; arc=fail smtp.client-ip=40.107.237.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ONg/Sbd/b8bI5bBTOOyTFREJ9JFw30G3zapXZbnsz5d7Q7O/IobUt3isMQwEzeIFzh4n+7+iP0wSg2RHXUxYbNicYzaZXwEwcn3gS8GoH/s0pBzSjeavAnX33Jlgl3XiWsWKvjhYv1jwZo+CaULxEn/qoK6N5le3uVf7LIIpxT5HzyIzYaAxf0MrSzF4nrPG3TYihC2c++Rh6a72TwYCSURFA3hMtwRz3i5mxHIX48lm8qfoi25r+sqC+RyRCvFj1/n3uWw22Cj/gT+rmAL5ke5h/UttouFWLHibgV0dj73GoaFF4gTZ81+LhiGoc8KRLQFxwgPw27zZ7pF5/gqa7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TMB4FReo5ZMvq4wrsU2uEW2d2KRkjJR3hiIEt3AGgV8=;
 b=T8KhbPWV7fLGSsA1u4FU0Bxj1cfPnG6ar5y6nxgd43NTlBmFcGj+pwlSbetZPczPiCqXmS0jVcw8B8yDh2olWOLAQRJUfqP2cjvoTFbbCFgc9WHdWgRznIVw2Nj5EWm5h9i6FNCLGLv63uRjpYhh9BWjSxeWCIb5TJaqp7LlqTZiSSDOs6Tc/T/za05GRRdVLmxeJNs2ZzN5gCFj9M/MRlz03DvYviSQptsscuDfc3Wk8pRAniaA4ySBGtmt5ZeKHO/C3EBE1B+HBQddPKy5G7Xpfgi1Qi2xxvwP4bPQGT4eiTF86wgJ4qGiS9RM1hSuEyWRH+Lia1//JbYmCd/AHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TMB4FReo5ZMvq4wrsU2uEW2d2KRkjJR3hiIEt3AGgV8=;
 b=sgbCbdTZUqQqSIq5uDIlbyz8+vW3jtZck5x3Ygc4l7w3bgd6kiLUuMBN5LvHmxEtzizd++C1eYJOl9P44f0VnFINDcJiFV9GhPXJggah4AbJ3/RGTYpYfD/OKJzF96a0ZTTYI0T86hWAAA7+vEhF8hyEZa6bwB2QGE9+qt/EkQ/HvnN0TFkunCgjCVSEaiKn38e5xe60zbJXkFv31k4PEnafcx4TfdwCgz7inDx7KHhst+ad/12ZwhhOk3J9Mkgot+EYmo2YSm9OVw2e8UAMYf3IxO+yPfg8dnqUtc/Te1eUXVly0AE8EB/dkNck/R0FOdiStXSRUhn2O2zw2BqifQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by LV2PR12MB5872.namprd12.prod.outlook.com (2603:10b6:408:173::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Wed, 24 Apr
 2024 14:17:18 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.021; Wed, 24 Apr 2024
 14:17:18 +0000
Date: Wed, 24 Apr 2024 11:17:16 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Zeng, Xin" <xin.zeng@intel.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	qat-linux <qat-linux@intel.com>, "Cao, Yahui" <yahui.cao@intel.com>
Subject: Re: [PATCH v6 1/1] vfio/qat: Add vfio_pci driver for Intel QAT
 SR-IOV VF devices
Message-ID: <20240424141716.GO941030@nvidia.com>
References: <20240417143141.1909824-1-xin.zeng@intel.com>
 <20240417143141.1909824-2-xin.zeng@intel.com>
 <20240418165434.1da52cf0.alex.williamson@redhat.com>
 <BN9PR11MB52767D5F7FF5D6498C974B388C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240419141057.GG3050601@nvidia.com>
 <BN9PR11MB52768D9ADA48E18CB99BCB768C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DM4PR11MB55029F7EACB6EB257DCF37BA88102@DM4PR11MB5502.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM4PR11MB55029F7EACB6EB257DCF37BA88102@DM4PR11MB5502.namprd11.prod.outlook.com>
X-ClientProxiedBy: SA9P221CA0027.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::32) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|LV2PR12MB5872:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cebf64b-17bf-45b2-aee1-08dc64693fd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0QOvST9+zef/F0E7ef8qaZ3ln2W6C0TGkPQGs+6ifXVcgLZtevAPdHkOZip4?=
 =?us-ascii?Q?AHILiMw0xwit0kFitTHX+I9BoVVm/BLL+mHD0u17LerPhPV552GoR1Vo6NBY?=
 =?us-ascii?Q?ih5xwVnSc7n70o6azW1FdYojp29bncIfxlOpoYNauDwdQp5xkHYxMIjqLlYg?=
 =?us-ascii?Q?yU/hHVkFBQuw8KvVP691PQlk7W3MHsy5AKsGlt+Q+2aUNVK1iU9ziTy42RVh?=
 =?us-ascii?Q?gCtrYmX0wOv2ZHQEjhcLSArxpPiJw4sh6VzUzyAa/WYVjNP0B8b/CJmL6c0T?=
 =?us-ascii?Q?X0wKNWpiNT7wtfIX81iGiBoV1IYxUz0oK9Ef7ujZ6VVMjQvRYq7VVP7J8nkx?=
 =?us-ascii?Q?WYIFqL80iIv4Kcepoye3EFxvuAfiOQr4DFUr/NyTvLKPUiuN2zOCPKbTj//+?=
 =?us-ascii?Q?EBBMSVfQL7/u2SxjzsiF8wJ0zl+UjG6hzHW4wUgPb3RO+XxqfjdFDUZ7VCyk?=
 =?us-ascii?Q?DEcdiAn4z/XVzoK5ugV9/nfSVddEAZhKcx0vStONclN8BxDSU5eyCMADDLiV?=
 =?us-ascii?Q?jgIc6UduGDbK4hmmQ5Ae6VY+T0hDKmoSCTFXsS2ugP3GNk3bLOy1ZGS/x7p8?=
 =?us-ascii?Q?4GB3VaSuXxxysobdixZE7PCXxqkTzej07XwFisRYRJLrnXd8Kw1UF7LjzwoF?=
 =?us-ascii?Q?NI+Xr5zUR9hL4UWPNr425W+o9kB0CsgbOUBuamdGyKBU0O4dnSST/atjFLPR?=
 =?us-ascii?Q?0kA+IwDJ0nkvCGfgad/1KmWdU6PNiybhH317GRYoOZ3sJmKQiQblXiLiYXPv?=
 =?us-ascii?Q?gn33tZCEamyw4+HQy6qeRPZrsAWidbagtfzcLyCDeTqJFX2MQlViO5zgtkFu?=
 =?us-ascii?Q?DnylMQKjc++3eGNTQOWx0V9dcgKu5dmO8KhOMkeQL1OjpS9bCLSGe4mRa/or?=
 =?us-ascii?Q?vwpE657DobEr/pyK09mZSjQtxQzaVnI5Is+nx3SS8vWlM2Y0OZHjFnk4NYPq?=
 =?us-ascii?Q?JU7fqfAekD96N3zLSRzt39UsTvY+HUYD5HS0sIYi9tYMkv71P/T5d64gcro8?=
 =?us-ascii?Q?kecz1PY1eXSpF6P63ZjDhiv8flAZzvO+oCKqvIh6YwOlm453ONjX97n/xTfv?=
 =?us-ascii?Q?GjHItRrBurKsxBzg2jcHtYqSlIUG1b0d4eLVZmDtQlAuFbausTXa3mUev6sl?=
 =?us-ascii?Q?U9YD+DnAe0zKqRpFUU0AOfxCZdt+36twK7jbhS6HpvxOr14VsTbwyBLUVals?=
 =?us-ascii?Q?pOYaM3fwuHsk8pDoVpqsv8jKzXoVHJkApwiROLGX5zh3+szwnEeM1MgSF9tT?=
 =?us-ascii?Q?CBLNQ3o4G3Yd6v0dk0YoNSznsjZxZQ0NjSMdBg4k3A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WX3CJob6p/yEGk+97C77HT3PdcflYuUQGe57NCYapj+k+3B+r6b0u3jAP+QP?=
 =?us-ascii?Q?IyynX/efAQ8pjNveC5ggT7TjKDRmVbMFGpZcTCzO2M820hy/HxIFmq4e1YL+?=
 =?us-ascii?Q?ToM81eXp0WEW0FCzsXNPXPGA4lCXvFcFTBT5ZshcFAH14bja8dzn9zoEQRuH?=
 =?us-ascii?Q?1lYin8ZQZJbxzx+anS+rYUFb3mNCy8cJRh0b/u119dRAyy1bQJ3BU1CZaCne?=
 =?us-ascii?Q?tgAHjHwoVGaI6ecS2MuYvuSZEIYVINP6oXz5o8r0PRjhtzT0Zv16oemkGOu4?=
 =?us-ascii?Q?qwHgW5zVZbURUiPWKSxeb34CLs7HX4XKav04sBvn0nhjQOxzQ7IEjqFMceGP?=
 =?us-ascii?Q?M/xvvhY5haOwxhWUdarNCH5MDSIkzKA+tmi4cGNl2pHIW+BFb9Xodd2/HBZz?=
 =?us-ascii?Q?dhLNR/mOvWrm8RhnhrmPZJd7dZG6wp8pzcWp9/Y00gssPQdIjTBwGHWRCv6D?=
 =?us-ascii?Q?PPxQ3Qc7+dVms6w/av41ETtTgU+zPajZffV1VmLMsi9TybkXpESdhCz80OYg?=
 =?us-ascii?Q?9tmQKFlEhY/JNkK34HmJDXEPYTYE2F15bQ0VmGaMU6E/dXPvZQNLSb6++iKL?=
 =?us-ascii?Q?hZYdtlh27nV+jncVIeLZgKIlSgCEYYdik0QXvcw6/pyddMC3FnUsSVEf0nJ4?=
 =?us-ascii?Q?iBvdW56Yu/iWCHnouvZGuRoKW+oNt9whm0JcESExeiV3/n8BriHVGkWKCYzI?=
 =?us-ascii?Q?TVGbOkN7Y7vh3C/blvQduRzq0wMWzBLxjYQ+KfEabSF9+8kKqN1EvjNJl+12?=
 =?us-ascii?Q?4dxFpyUX7N1cHlpRoBwJig32EWDbbN/PBiTDJ6ShtEH8i5eccGJD/LopLJ93?=
 =?us-ascii?Q?KX/RsNNdp7D/89k9IO+OZFW3iDbce1pdSumclfkzcN8A0JQ0ZrC/m15weFom?=
 =?us-ascii?Q?QOX4sBb24ypBWeJBzbotqptVNG6/+PybXCZ5q6gJGff4vV/vRwqtzajsa/NN?=
 =?us-ascii?Q?nhCFCcpPSIaJoU40BWMtV4+UaIAYGsipYSpp4QdZevqAAIR2nPXcxW8wxDJG?=
 =?us-ascii?Q?MAszgh881D0JYdUNwnZ0TPsoITBd9R8FMmQNxdK0iFTGPbaCKgVXHWWtTH8M?=
 =?us-ascii?Q?AunN1XbLyPD0iYrnfydcgmYARR+38VRLfAtjW4brEyJ8qNbpm5C4KHcXhNmh?=
 =?us-ascii?Q?Q2/LI6C3+Bhbq7LrublxvWfRZduR3TC3wvJY9u8A6klP4GZq3G0LU+J/KCK5?=
 =?us-ascii?Q?aDTiOLCIwqGp6puPpTVeabQJt3ufJml679TcmtGEeeZ/cNdLcBprsBdlQuI1?=
 =?us-ascii?Q?96Om0gVePEuuqV5bSi2pJk5eU+cPXO0P5RT/yqL5kGw4OVqlosLoAbDJ+d99?=
 =?us-ascii?Q?PTlaiR9tk03JvjXq8Samh2ySSUD+N88Fk5za6piiiP7QzuTLSejmbZFaZuHi?=
 =?us-ascii?Q?sdBYmyFQkjz7wbb1hh5qlFgImAPU7XkTRMox4Y0qmLOAdYE1vJ6NcKIGQo9b?=
 =?us-ascii?Q?SshOwqr5OpbG85TzuXuRygKaWEKJKI/jB4gE4eQax7qKCZ4oAEY61NveJ72K?=
 =?us-ascii?Q?7Cj2Vu5fNeJBlsvI3H4eNjKklns3hvHMeu+vekjT1QOiYVnJbb4wi9Txq+vh?=
 =?us-ascii?Q?4L+wimQaICjL5YxnaJFOINSBja+XOluc0DBVb/j4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cebf64b-17bf-45b2-aee1-08dc64693fd0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2024 14:17:18.5995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YvYLGA1pZWFLJKtM/hV/dkUjnbbWECrjEEnVrC6522ncyQNkBnJ5X1VzPqKjSpUV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5872

On Wed, Apr 24, 2024 at 03:34:19AM +0000, Zeng, Xin wrote:

> > > Like if it halts all queues and keeps them halted, while still
> > > allowing queue head/tail pointer updats then it would be a fine
> > > implementation for P2P.
> > 
> > Yes that really depends. e.g. a queue accepting direct stores (MOVDIR64B)
> > for work submission may have problem if that store is simply abandoned
> > when the queue is disabled. ENQCMD is possibly OK as unaccepted store
> > will get a retry indicator to software so nothing is lost.
> > 
> > I'll let Xin confirm on the QAT implementation (for all device registers).
> > If it is like Jason's example then we should provide a clear comment
> > clarifying that doing suspend at RUNNING_P2P is safe for QAT as the
> > device MMIO interface still works according to the definition of RUNNING
> > and no request is lost (either from CPU or peer). There is nothing to stop
> > from RUNNING_P2P to STOP because the device doesn't execute any
> > request to further change the internal state other than MMIO.
> > 
> 
> When QAT VF is suspended, all its MMIO registers can still be operated
> correctly, jobs submitted through ring are queued while no jobs are
> processed by the device.  The MMIO states can be safely migrated
> to the target VF during stop-copy stage and restored correctly in the
> target VF. All queued jobs can be resumed then. 
> MOVDIR64B mentioned above is not supported by QAT solution,
> so it's fine to keep current implementation.
> If no objections, I'll append this paragraph of comment in the driver and
> post another version.

Yes that looks good to me.

Jason

