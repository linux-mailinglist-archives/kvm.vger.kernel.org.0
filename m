Return-Path: <kvm+bounces-22765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D6A1943119
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:40:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DAA6FB23858
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 13:40:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 183D51B29A8;
	Wed, 31 Jul 2024 13:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g/PFa5Pe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="X5WpxkL0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E8B1B3734;
	Wed, 31 Jul 2024 13:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722433171; cv=fail; b=OYoz+6+QSKdozsS3ZSUJovIQSBNPYfkgyqII1aeORS7pc3E/4sxkFFqBBX5j571Wr2uUvSXJgpED1kzdPHix3esZKindJkfLrkf0rzuBUaeZhz9KJgrfbqn0E+9EKF/mWm/h0+RT0Eo1+35du3FGzWT9dO8/Re0JjgG5ghn/u40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722433171; c=relaxed/simple;
	bh=bckyV1v35dy0L1Bc+MwXkN2npdsf+f0irnCrm3pUjWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JC5HZCjWY4aECTq78JAZG9CgKIq97fIo6+cEggA+dB5c3BUsA/fgb9ivrmhj1LbmDok2K3JK/jbH7kmc7fZyRiGY6/N2g9MIo0KvEHIVVEOHUHc6CSyEbc0MIvAiziWoDi2R/IcW2sVD6Dw5OVnnM5KiXqnyPHO0uTNxgOTFd+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g/PFa5Pe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=X5WpxkL0; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46V7tWUF001360;
	Wed, 31 Jul 2024 13:36:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	date:from:to:cc:subject:message-id:references:content-type
	:in-reply-to:mime-version; s=corp-2023-11-20; bh=C8v9TIHecKKef7y
	5ak4VhRLvV+nGx4QxODv7XbMNBMk=; b=g/PFa5PetZIxL2ZDlsk3WQJFNOJdB6x
	Hhzw8iOy/agOMN+tMjZdq1b93Tr5DvW2y84v7PipXxBX8v5yGkfrEhVJCfYHPrWD
	mnl8h474BcOcijx1A/nuxGjcJPVZYX7XcN6yUWq6yX+LCp5L0SBoABk0eOUNt+Yv
	5VS+Vj2yYQrOlLEKIhjC74nkthzfct1uGN3WXILQileEIWozd13bmq1uKldy09uQ
	Dcz1/E1ftEEQvrG5HHDAyYJAO6LcNtiAnf7mwMmUc42jgevPIvihClsdwZ0CQjID
	YobfcSVq8gZRvRpYIhRfY6zGW7GgAJFCtXCIboMCKTD+tzPAOezSNFg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40mqtaqcdq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jul 2024 13:36:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46VCZBdu005876;
	Wed, 31 Jul 2024 13:36:24 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40p4c1gc77-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jul 2024 13:36:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=efiTCiV8smO7hL3D3uRVJb7qaVcEakbseOXAPFDZe5fZHzda/+ivOJbzuEx2EfWpRfzhCJFNi0R+WAnb3AdcPfPp1tWgBTYH++yn/RUxaNEy2aKdY1CSmLpxDawAcLah4BGSPNLLS1869qB85KYyESZxCvqoeL7F7I/XIKNGQinzlXCVIdW9aR7Ds1+20HK4K9a196w3n3LQe21g3cvOGLFQMLaIHWOZRLyTlTbiUjt0315JydqyGc/kvMr/QftFcypMnST0f5vaoo6a+9+U/1VQzz+98uBGc1FhOQidwZyMgh/gbbLf2adQfRfNrocegIU6WoLE1CiswWWrAqARdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C8v9TIHecKKef7y5ak4VhRLvV+nGx4QxODv7XbMNBMk=;
 b=Vw0lBolNA8EUMCAC+XjaZT37FUdlsA0DpwaIFUn7dS0PRDXgVPI2itrIlo/MKL8RjkKp5JrMqvFnUsjdS7Qc1cdxAiQ0SS85X0fnNL00wHjNYSOxxpLPmG8x0JQb3rfAn02Sum9yn9NG/JYjLMfVVJaV9gojIolxh/Q77kuQHX5hDoDYbecTdAhATF6/58rJdL6CZuNaem2KK0Fu3zUhIamWL6uC54eIahRUWupKfjNW6LOmYM+acmPA0heBwGXeupUn1TyJ6a0EYkUbIIqhlmXmauYn+xX2p7xqDh0o9J6T9I4tyJIEFkrHLVz/5aKx6BHwUR6CHEJ/cMb0asr/yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C8v9TIHecKKef7y5ak4VhRLvV+nGx4QxODv7XbMNBMk=;
 b=X5WpxkL0gxHxgMeDhcHZRPIK2Sc5ea5qkuyCKMdAw85FQxxOM9A4g+RtOIkaPWPVbrwMteuJ84bIA8HTGnqkOeXRiPFF36eAteO+hF0Ul6IeLaZTt7z1AhVUgcSholx65B4Dv7apyqV8OdSmjchEfNdT6kTYvRVb7JYiqqbBWzM=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by PH8PR10MB6479.namprd10.prod.outlook.com (2603:10b6:510:22d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.21; Wed, 31 Jul
 2024 13:36:15 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90%6]) with mapi id 15.20.7828.021; Wed, 31 Jul 2024
 13:36:15 +0000
Date: Wed, 31 Jul 2024 09:36:09 -0400
From: Chuck Lever <chuck.lever@oracle.com>
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Jeroen de Borst <jeroendb@google.com>,
        Praveen Kaligineedi <pkaligineedi@google.com>,
        Shailend Chand <shailend@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Przemek Kitszel <przemyslaw.kitszel@intel.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>, hariprasad <hkelam@marvell.com>,
        Felix Fietkau <nbd@nbd.name>, Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>,
        Yonghong Song <yonghong.song@linux.dev>, KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>, David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Jeff Layton <jlayton@kernel.org>, Neil Brown <neilb@suse.de>,
        Olga Kornievskaia <kolga@netapp.com>, Dai Ngo <Dai.Ngo@oracle.com>,
        Tom Talpey <tom@talpey.com>, Trond Myklebust <trondmy@kernel.org>,
        Anna Schumaker <anna@kernel.org>, intel-wired-lan@lists.osuosl.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-nvme@lists.infradead.org,
        kvm@vger.kernel.org, virtualization@lists.linux.dev,
        linux-mm@kvack.org, bpf@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-nfs@vger.kernel.org
Subject: Re: [PATCH net-next v12 04/14] mm: page_frag: add '_va' suffix to
 page_frag API
Message-ID: <Zqo9yV+DskSMPmas@tissot.1015granger.net>
References: <20240731124505.2903877-1-linyunsheng@huawei.com>
 <20240731124505.2903877-5-linyunsheng@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240731124505.2903877-5-linyunsheng@huawei.com>
X-ClientProxiedBy: CH0PR04CA0089.namprd04.prod.outlook.com
 (2603:10b6:610:74::34) To BN0PR10MB5128.namprd10.prod.outlook.com
 (2603:10b6:408:117::24)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5128:EE_|PH8PR10MB6479:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f3f40b3-b1da-46c4-e84b-08dcb165c038
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ddR6LsE5J6JCaGOPOa4fJcvIK1e8c3pnauhSUKfTyQinq7etZ95vMf+kQvZb?=
 =?us-ascii?Q?ra682nY4yJF9PE7I+xwllUXe01aHz5deUciDlbogFXjmhSQLcsHeC98auDoL?=
 =?us-ascii?Q?mAXevQKD87OUmZlf1Nf5OZRVU+cs99FFaNJkWQMjtDBd5cd/u3qv0L35DcHm?=
 =?us-ascii?Q?gfMDmpFaY1IlOmI8I6i7bJTvvBwjNcF6ImUVYyq8tBklgaA/eZRmh/uA7Y71?=
 =?us-ascii?Q?vDGjUdP7qzO7AT+Z/I1+8KIXtu5k3RXkCuEmzI0QkmhqzMvqK0ed5lDG9S8E?=
 =?us-ascii?Q?KdqIu2dT9/RNDqLbIbiqy7onpEmS49Wkao4QEAO+iI/2us+BV3WgefWNoYZd?=
 =?us-ascii?Q?W/7GoFAa867sjpmlMnkxoZJ+eFL9LKu0rP0Aen3dwv2qtb1usM0025TspKqS?=
 =?us-ascii?Q?kUlajiwTa7SrK3HGSyVMe1C2A5lzrVO0ZhMIlwLLsw428MGSry0FDGx3NnCX?=
 =?us-ascii?Q?j3Q607lMigoEeGXxkxIOu42ergqH4DXXUzrjQIXfD5dfgFXpPNNNAJqqxnza?=
 =?us-ascii?Q?JN2vAIrXJ2WtTY6cHj/GIx1vjX4LVXiEbcl8hVHIBMYoia+pYLPDN+ERyrsJ?=
 =?us-ascii?Q?laTvvdF9Y9CYqMX1osPgRhftCRHdTkfAsi+KY3GRp5MOeT64bFXVPxs3i2QA?=
 =?us-ascii?Q?qcqMmf9Pax9v/03I/omMXPDAqG8nfB+nIu78zScDWXR4PC2kL2PIIRmLibUW?=
 =?us-ascii?Q?F56n3n7IUjajUkPCtAmWXSAg+Se6BAAV4epGFzNNXrVmMNZORKisoXecsWTR?=
 =?us-ascii?Q?f+VoodBCPr2MEGXScFw7vo1z3eZEpsWKzA5pzFVxJMMqZOuiMQkambPhGqgr?=
 =?us-ascii?Q?XHDfU3MYNtEZPMD4MQWmF3tHa/s9mcciRGmZdusPRHhpw5kvlc4hL5YHAZMB?=
 =?us-ascii?Q?8/ItJ4QOvdme7zny4+Jh0oORaB/WimiOAtbl4aqSNp69SeJJ9YdQpXZehT4z?=
 =?us-ascii?Q?affYeg4+bKJ/oIEQbpqfdRxst7jH4BpCt6t8gXV6KlaCc9nZb7pbkxXUaMrR?=
 =?us-ascii?Q?DfH/gleGQWsGv2PwnNwtvRLGRTQFcPhkNj4uNdnqnAb2Q30l/zu73gTdX6VB?=
 =?us-ascii?Q?BiQVbWT3VNdFPznN+1mMJSL/9Jxu/EjmXkH5LP6GSqKqXkV5F4qC0JDUmc4g?=
 =?us-ascii?Q?Xog1xXpp+rZImTOyAU8iMYmmfXP+j0el1BT8acnWTBJacSfB/nfm3kjmrvMX?=
 =?us-ascii?Q?Z3+erUNuznJqtnielJitEyyKHVmA9eGYcUORKttP2f+e1nMlPM313RBFt5SQ?=
 =?us-ascii?Q?cRdkrKrUjoR/InUMfL001fvBG19oyg9hbqrOqZHIRowGzXuQKMInD6BRbimO?=
 =?us-ascii?Q?qxlX1onnH+yqt9jwHlbeBqVi6tuMiT14dtdX7CdDRGnGPg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ko/FrdG2DCrIetkYFmvQSPYkp9zlFP/wdaLlk25yqvybA+pSXP/zSEy12R6U?=
 =?us-ascii?Q?GP064q8iH61bTEla6FFbu56bVW1ly24iIJ1fbd7SYOHLqwZHVsPyw7j4lmmS?=
 =?us-ascii?Q?xyZllOLW9URnkpeNLq54H3KneAQw9lxxKkJtf/QaTgg/VBe5dATMuqnva/hS?=
 =?us-ascii?Q?feMgzMJ0yRu5f+e+TFukW/8bGrK6qeX6zmBzFKzh7RbvVmHVGCl2WlUvdk5y?=
 =?us-ascii?Q?FR9DBMuGVDz2VEhe3Y7sYOPK4iZk26obERq8nM8gh2vlvO4cBfY9kilFjJtn?=
 =?us-ascii?Q?yUaourDUOzs7dvYClxRPTLvs3B6tk98oH4vznaaX99/XE6PH4on83hJ4Mj/K?=
 =?us-ascii?Q?crmqBj1uI1ry5+4pKZ/MS7k3bwlUq/zt+OgOw2Jg9XgyV9HunsnIvAJ3pimh?=
 =?us-ascii?Q?D5Sk4gKMLRDOkGcCCTPOM84D5PHlV/xR2D9dF/39VLBcsYhBItjDsRxCbaTt?=
 =?us-ascii?Q?l4wC5LF9f2kI7bGtb3HED6v/W1hevmXAR30GEi/OiPaCq8RtFexng8wX7xT2?=
 =?us-ascii?Q?IVSP1ayDld1Z1mA1a0DyPowTWvtA6OXAF79hNQnq01BwIte0tzDtnED3DTfn?=
 =?us-ascii?Q?2DX2mD8U31CDE1fPVaGM0UkEAm+Lnct/T58voVIJz8Dv2rLkENU5c4Byp5yF?=
 =?us-ascii?Q?wpkhk7opO9kIUvLA9tVmFV0dnupS31Gv6X9X8ozZ1bGaDtdlnjqi6X7Wt0ty?=
 =?us-ascii?Q?gsAXL5gLZgahPi/XvKHJnR5jtRCnR8y3C4oSFw3Ib3S7KqVKfe86bwSQKe7z?=
 =?us-ascii?Q?LLGEQfjfNaU47xqvCse3tTkHSGX5oBAKEgLgd4xb/dh0fjb0Dx5wqqENgKGE?=
 =?us-ascii?Q?P5hx4Ev/Dr1xVGf+X4dg2VK66AHLmGhV8koaDuAXLw8ajHwnNmX5r1yeBsmG?=
 =?us-ascii?Q?lhoAhJmraUivkXiAYVUdj8Xd3CiAhs/T8UqrOzZKj7m03EQdzJIuNGMLjgT1?=
 =?us-ascii?Q?VGYoe5Zn2/5eEUVivAQzRuf5SMLLF03/O81Lra5X6Gh/BGo/bCVu0QHwRZar?=
 =?us-ascii?Q?G5pBZQv9q8EL/FP/hQHoqMH/Kbd3KeNnhhjvi09lTM0zMO6vOFm3yUSBV+iW?=
 =?us-ascii?Q?rxTqbPU2NEvs8BPs8zAnUGk6wXq6OcsXKbOlRE9RCT+1JKnJg0ka+mp6R889?=
 =?us-ascii?Q?uLqgF4e4VN+/MqqGaGW7zkBQ8XkdaK4blPOc4AFa9kiiAKCGgJun72tZoknP?=
 =?us-ascii?Q?4FuwBSQMrfH7nBhPhoVIc69qDlBViwkFdcGviV2dCRZOeFHZ6Qc3Ehe8wveq?=
 =?us-ascii?Q?3DgaRrujRJO2u5DFA1mqJTCYiUlYjKggNTWMkeNmoNyX5S+3mvG2yztRcbig?=
 =?us-ascii?Q?fAW3RRKQZ90PAKqvvS3BMGxnmBfnjMZy8f+1jzNssPq052rI6EA/9C+YSvKL?=
 =?us-ascii?Q?FmE1vgOvXODCbdtHsKn+JqNrMgSpZZaic0MOAQq2dPGB9GfnS0nS283ybjlN?=
 =?us-ascii?Q?JlBFvFBn4KPgcXXC4XtBUMYXLdlJGVxLw6v0E4NNQN4dAM4QqibkPSQz79L5?=
 =?us-ascii?Q?eQ7iSBkaa67GWsK/cHBCdTUBVvAQMdCQTo3HXXa+JfZWM6pzc4DfpzM2WHqt?=
 =?us-ascii?Q?On3eUqTALWahQ9d3gBfJzb1zWOy8AmN1wjR4H3io?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ViUGHVn2fYX1WJT7XDc2MuDDWUgHsmz6qcPNdJWTJkAIpT4+mj7l3R8dHzU7IF3+rBl5tsR8iMkpgtW3qVmDm/bxmigMfl7TKfz9QLX4EHwLnrz0Lt2m6KrX8DvVQ+YS/9j1JC1f9iNaF8VdCTUfMKZ4sTJza08I2JTTF/5GDjo/pUXhVBVgWNw9fzfjeCnMN7Q9NyAaJ81PFAA3HJEzwLh2LnRdmMsnEkCFDvh33r+chE1QWXFX+zFP8U2X0RebaL2xz8BrZyhPM0Ub8IKPPRC4DWmMJWeqKYi7GjCj4xgCScI3K4FChDrLOElc6U85nz9tpvY4FGiO3QccE3OUkR9OdMLqNdPpC8P5Sz291s0aFv/loCyPIzg4jr0a4oOkwpaVsglvxCcjPp9hOFc7lJWFfNjBfb/8VkUBrbTCFTjIAqaOTHzN7FukAAj9Mqdx1OaCyTjQrz0J+S8vDTZoROTKUaJ6RgRJN9q403bFGV0En1/AWvZ7wOYKjetkOJw5mpVRraUEnTm+eLemhn13kLGZFvQldsqRlQDOpCTUitJK6I5legM4Y7bLvPsMAnVHP+2CjvNxflbPcOSuziN1gB6TVcJYLQvzwi5lCh0xN0w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f3f40b3-b1da-46c4-e84b-08dcb165c038
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 13:36:15.6740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mmC8ZESTdXTXBZJ1kr6KyqNWTWd8pQf2BPB1ZLCx5YiDVEeTFQlGcjQ+pPklVi/oWhyc1q+Wxm03s8Qjww9Abg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6479
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-31_08,2024-07-31_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407310099
X-Proofpoint-GUID: LEw7MwTVpowNM2Ppu5KTxRLyc_l0AjjT
X-Proofpoint-ORIG-GUID: LEw7MwTVpowNM2Ppu5KTxRLyc_l0AjjT

On Wed, Jul 31, 2024 at 08:44:54PM +0800, Yunsheng Lin wrote:
> Currently the page_frag API is returning 'virtual address'
> or 'va' when allocing and expecting 'virtual address' or
> 'va' as input when freeing.
> 
> As we are about to support new use cases that the caller
> need to deal with 'struct page' or need to deal with both
> 'va' and 'struct page'. In order to differentiate the API
> handling between 'va' and 'struct page', add '_va' suffix
> to the corresponding API mirroring the page_pool_alloc_va()
> API of the page_pool. So that callers expecting to deal with
> va, page or both va and page may call page_frag_alloc_va*,
> page_frag_alloc_pg*, or page_frag_alloc* API accordingly.
> 
> CC: Alexander Duyck <alexander.duyck@gmail.com>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>

For the net/sunrpc/svcsock.c hunk:

Acked-by: Chuck Lever <chuck.lever@oracle.com>


> ---
>  drivers/net/ethernet/google/gve/gve_rx.c      |  4 ++--
>  drivers/net/ethernet/intel/ice/ice_txrx.c     |  2 +-
>  drivers/net/ethernet/intel/ice/ice_txrx.h     |  2 +-
>  drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  2 +-
>  .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  4 ++--
>  .../marvell/octeontx2/nic/otx2_common.c       |  2 +-
>  drivers/net/ethernet/mediatek/mtk_wed_wo.c    |  4 ++--
>  drivers/nvme/host/tcp.c                       |  8 +++----
>  drivers/nvme/target/tcp.c                     | 22 +++++++++----------
>  drivers/vhost/net.c                           |  6 ++---
>  include/linux/page_frag_cache.h               | 21 +++++++++---------
>  include/linux/skbuff.h                        |  2 +-
>  kernel/bpf/cpumap.c                           |  2 +-
>  mm/page_frag_cache.c                          | 12 +++++-----
>  mm/page_frag_test.c                           | 13 ++++++-----
>  net/core/skbuff.c                             | 14 ++++++------
>  net/core/xdp.c                                |  2 +-
>  net/rxrpc/txbuf.c                             | 15 +++++++------
>  net/sunrpc/svcsock.c                          |  6 ++---
>  19 files changed, 74 insertions(+), 69 deletions(-)
> 
> diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
> index acb73d4d0de6..b6c10100e462 100644
> --- a/drivers/net/ethernet/google/gve/gve_rx.c
> +++ b/drivers/net/ethernet/google/gve/gve_rx.c
> @@ -729,7 +729,7 @@ static int gve_xdp_redirect(struct net_device *dev, struct gve_rx_ring *rx,
>  
>  	total_len = headroom + SKB_DATA_ALIGN(len) +
>  		SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> -	frame = page_frag_alloc(&rx->page_cache, total_len, GFP_ATOMIC);
> +	frame = page_frag_alloc_va(&rx->page_cache, total_len, GFP_ATOMIC);
>  	if (!frame) {
>  		u64_stats_update_begin(&rx->statss);
>  		rx->xdp_alloc_fails++;
> @@ -742,7 +742,7 @@ static int gve_xdp_redirect(struct net_device *dev, struct gve_rx_ring *rx,
>  
>  	err = xdp_do_redirect(dev, &new, xdp_prog);
>  	if (err)
> -		page_frag_free(frame);
> +		page_frag_free_va(frame);
>  
>  	return err;
>  }
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
> index 8bb743f78fcb..399b317c509d 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx.c
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
> @@ -126,7 +126,7 @@ ice_unmap_and_free_tx_buf(struct ice_tx_ring *ring, struct ice_tx_buf *tx_buf)
>  		dev_kfree_skb_any(tx_buf->skb);
>  		break;
>  	case ICE_TX_BUF_XDP_TX:
> -		page_frag_free(tx_buf->raw_buf);
> +		page_frag_free_va(tx_buf->raw_buf);
>  		break;
>  	case ICE_TX_BUF_XDP_XMIT:
>  		xdp_return_frame(tx_buf->xdpf);
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
> index feba314a3fe4..6379f57d8228 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx.h
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
> @@ -148,7 +148,7 @@ static inline int ice_skb_pad(void)
>   * @ICE_TX_BUF_DUMMY: dummy Flow Director packet, unmap and kfree()
>   * @ICE_TX_BUF_FRAG: mapped skb OR &xdp_buff frag, only unmap DMA
>   * @ICE_TX_BUF_SKB: &sk_buff, unmap and consume_skb(), update stats
> - * @ICE_TX_BUF_XDP_TX: &xdp_buff, unmap and page_frag_free(), stats
> + * @ICE_TX_BUF_XDP_TX: &xdp_buff, unmap and page_frag_free_va(), stats
>   * @ICE_TX_BUF_XDP_XMIT: &xdp_frame, unmap and xdp_return_frame(), stats
>   * @ICE_TX_BUF_XSK_TX: &xdp_buff on XSk queue, xsk_buff_free(), stats
>   */
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> index 2719f0e20933..a1a41a14df0d 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> @@ -250,7 +250,7 @@ ice_clean_xdp_tx_buf(struct device *dev, struct ice_tx_buf *tx_buf,
>  
>  	switch (tx_buf->type) {
>  	case ICE_TX_BUF_XDP_TX:
> -		page_frag_free(tx_buf->raw_buf);
> +		page_frag_free_va(tx_buf->raw_buf);
>  		break;
>  	case ICE_TX_BUF_XDP_XMIT:
>  		xdp_return_frame_bulk(tx_buf->xdpf, bq);
> diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> index 149911e3002a..eef16a909f85 100644
> --- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> +++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> @@ -302,7 +302,7 @@ static bool ixgbevf_clean_tx_irq(struct ixgbevf_q_vector *q_vector,
>  
>  		/* free the skb */
>  		if (ring_is_xdp(tx_ring))
> -			page_frag_free(tx_buffer->data);
> +			page_frag_free_va(tx_buffer->data);
>  		else
>  			napi_consume_skb(tx_buffer->skb, napi_budget);
>  
> @@ -2412,7 +2412,7 @@ static void ixgbevf_clean_tx_ring(struct ixgbevf_ring *tx_ring)
>  
>  		/* Free all the Tx ring sk_buffs */
>  		if (ring_is_xdp(tx_ring))
> -			page_frag_free(tx_buffer->data);
> +			page_frag_free_va(tx_buffer->data);
>  		else
>  			dev_kfree_skb_any(tx_buffer->skb);
>  
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> index 87d5776e3b88..a485e988fa1d 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> @@ -553,7 +553,7 @@ static int __otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
>  	*dma = dma_map_single_attrs(pfvf->dev, buf, pool->rbsize,
>  				    DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
>  	if (unlikely(dma_mapping_error(pfvf->dev, *dma))) {
> -		page_frag_free(buf);
> +		page_frag_free_va(buf);
>  		return -ENOMEM;
>  	}
>  
> diff --git a/drivers/net/ethernet/mediatek/mtk_wed_wo.c b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
> index 7063c78bd35f..c4228719f8a4 100644
> --- a/drivers/net/ethernet/mediatek/mtk_wed_wo.c
> +++ b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
> @@ -142,8 +142,8 @@ mtk_wed_wo_queue_refill(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q,
>  		dma_addr_t addr;
>  		void *buf;
>  
> -		buf = page_frag_alloc(&q->cache, q->buf_size,
> -				      GFP_ATOMIC | GFP_DMA32);
> +		buf = page_frag_alloc_va(&q->cache, q->buf_size,
> +					 GFP_ATOMIC | GFP_DMA32);
>  		if (!buf)
>  			break;
>  
> diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
> index a2a47d3ab99f..86906bc505de 100644
> --- a/drivers/nvme/host/tcp.c
> +++ b/drivers/nvme/host/tcp.c
> @@ -506,7 +506,7 @@ static void nvme_tcp_exit_request(struct blk_mq_tag_set *set,
>  {
>  	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
>  
> -	page_frag_free(req->pdu);
> +	page_frag_free_va(req->pdu);
>  }
>  
>  static int nvme_tcp_init_request(struct blk_mq_tag_set *set,
> @@ -520,7 +520,7 @@ static int nvme_tcp_init_request(struct blk_mq_tag_set *set,
>  	struct nvme_tcp_queue *queue = &ctrl->queues[queue_idx];
>  	u8 hdgst = nvme_tcp_hdgst_len(queue);
>  
> -	req->pdu = page_frag_alloc(&queue->pf_cache,
> +	req->pdu = page_frag_alloc_va(&queue->pf_cache,
>  		sizeof(struct nvme_tcp_cmd_pdu) + hdgst,
>  		GFP_KERNEL | __GFP_ZERO);
>  	if (!req->pdu)
> @@ -1337,7 +1337,7 @@ static void nvme_tcp_free_async_req(struct nvme_tcp_ctrl *ctrl)
>  {
>  	struct nvme_tcp_request *async = &ctrl->async_req;
>  
> -	page_frag_free(async->pdu);
> +	page_frag_free_va(async->pdu);
>  }
>  
>  static int nvme_tcp_alloc_async_req(struct nvme_tcp_ctrl *ctrl)
> @@ -1346,7 +1346,7 @@ static int nvme_tcp_alloc_async_req(struct nvme_tcp_ctrl *ctrl)
>  	struct nvme_tcp_request *async = &ctrl->async_req;
>  	u8 hdgst = nvme_tcp_hdgst_len(queue);
>  
> -	async->pdu = page_frag_alloc(&queue->pf_cache,
> +	async->pdu = page_frag_alloc_va(&queue->pf_cache,
>  		sizeof(struct nvme_tcp_cmd_pdu) + hdgst,
>  		GFP_KERNEL | __GFP_ZERO);
>  	if (!async->pdu)
> diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
> index 5bff0d5464d1..560df3db2f82 100644
> --- a/drivers/nvme/target/tcp.c
> +++ b/drivers/nvme/target/tcp.c
> @@ -1463,24 +1463,24 @@ static int nvmet_tcp_alloc_cmd(struct nvmet_tcp_queue *queue,
>  	c->queue = queue;
>  	c->req.port = queue->port->nport;
>  
> -	c->cmd_pdu = page_frag_alloc(&queue->pf_cache,
> +	c->cmd_pdu = page_frag_alloc_va(&queue->pf_cache,
>  			sizeof(*c->cmd_pdu) + hdgst, GFP_KERNEL | __GFP_ZERO);
>  	if (!c->cmd_pdu)
>  		return -ENOMEM;
>  	c->req.cmd = &c->cmd_pdu->cmd;
>  
> -	c->rsp_pdu = page_frag_alloc(&queue->pf_cache,
> +	c->rsp_pdu = page_frag_alloc_va(&queue->pf_cache,
>  			sizeof(*c->rsp_pdu) + hdgst, GFP_KERNEL | __GFP_ZERO);
>  	if (!c->rsp_pdu)
>  		goto out_free_cmd;
>  	c->req.cqe = &c->rsp_pdu->cqe;
>  
> -	c->data_pdu = page_frag_alloc(&queue->pf_cache,
> +	c->data_pdu = page_frag_alloc_va(&queue->pf_cache,
>  			sizeof(*c->data_pdu) + hdgst, GFP_KERNEL | __GFP_ZERO);
>  	if (!c->data_pdu)
>  		goto out_free_rsp;
>  
> -	c->r2t_pdu = page_frag_alloc(&queue->pf_cache,
> +	c->r2t_pdu = page_frag_alloc_va(&queue->pf_cache,
>  			sizeof(*c->r2t_pdu) + hdgst, GFP_KERNEL | __GFP_ZERO);
>  	if (!c->r2t_pdu)
>  		goto out_free_data;
> @@ -1495,20 +1495,20 @@ static int nvmet_tcp_alloc_cmd(struct nvmet_tcp_queue *queue,
>  
>  	return 0;
>  out_free_data:
> -	page_frag_free(c->data_pdu);
> +	page_frag_free_va(c->data_pdu);
>  out_free_rsp:
> -	page_frag_free(c->rsp_pdu);
> +	page_frag_free_va(c->rsp_pdu);
>  out_free_cmd:
> -	page_frag_free(c->cmd_pdu);
> +	page_frag_free_va(c->cmd_pdu);
>  	return -ENOMEM;
>  }
>  
>  static void nvmet_tcp_free_cmd(struct nvmet_tcp_cmd *c)
>  {
> -	page_frag_free(c->r2t_pdu);
> -	page_frag_free(c->data_pdu);
> -	page_frag_free(c->rsp_pdu);
> -	page_frag_free(c->cmd_pdu);
> +	page_frag_free_va(c->r2t_pdu);
> +	page_frag_free_va(c->data_pdu);
> +	page_frag_free_va(c->rsp_pdu);
> +	page_frag_free_va(c->cmd_pdu);
>  }
>  
>  static int nvmet_tcp_alloc_cmds(struct nvmet_tcp_queue *queue)
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index f16279351db5..6691fac01e0d 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -686,8 +686,8 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
>  		return -ENOSPC;
>  
>  	buflen += SKB_DATA_ALIGN(len + pad);
> -	buf = page_frag_alloc_align(&net->pf_cache, buflen, GFP_KERNEL,
> -				    SMP_CACHE_BYTES);
> +	buf = page_frag_alloc_va_align(&net->pf_cache, buflen, GFP_KERNEL,
> +				       SMP_CACHE_BYTES);
>  	if (unlikely(!buf))
>  		return -ENOMEM;
>  
> @@ -734,7 +734,7 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
>  	return 0;
>  
>  err:
> -	page_frag_free(buf);
> +	page_frag_free_va(buf);
>  	return ret;
>  }
>  
> diff --git a/include/linux/page_frag_cache.h b/include/linux/page_frag_cache.h
> index a758cb65a9b3..ef038a07925c 100644
> --- a/include/linux/page_frag_cache.h
> +++ b/include/linux/page_frag_cache.h
> @@ -9,23 +9,24 @@
>  
>  void page_frag_cache_drain(struct page_frag_cache *nc);
>  void __page_frag_cache_drain(struct page *page, unsigned int count);
> -void *__page_frag_alloc_align(struct page_frag_cache *nc, unsigned int fragsz,
> -			      gfp_t gfp_mask, unsigned int align_mask);
> +void *__page_frag_alloc_va_align(struct page_frag_cache *nc,
> +				 unsigned int fragsz, gfp_t gfp_mask,
> +				 unsigned int align_mask);
>  
> -static inline void *page_frag_alloc_align(struct page_frag_cache *nc,
> -					  unsigned int fragsz, gfp_t gfp_mask,
> -					  unsigned int align)
> +static inline void *page_frag_alloc_va_align(struct page_frag_cache *nc,
> +					     unsigned int fragsz,
> +					     gfp_t gfp_mask, unsigned int align)
>  {
>  	WARN_ON_ONCE(!is_power_of_2(align));
> -	return __page_frag_alloc_align(nc, fragsz, gfp_mask, -align);
> +	return __page_frag_alloc_va_align(nc, fragsz, gfp_mask, -align);
>  }
>  
> -static inline void *page_frag_alloc(struct page_frag_cache *nc,
> -				    unsigned int fragsz, gfp_t gfp_mask)
> +static inline void *page_frag_alloc_va(struct page_frag_cache *nc,
> +				       unsigned int fragsz, gfp_t gfp_mask)
>  {
> -	return __page_frag_alloc_align(nc, fragsz, gfp_mask, ~0u);
> +	return __page_frag_alloc_va_align(nc, fragsz, gfp_mask, ~0u);
>  }
>  
> -void page_frag_free(void *addr);
> +void page_frag_free_va(void *addr);
>  
>  #endif
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index e057db1c63e9..8d50cb3b161e 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -3381,7 +3381,7 @@ static inline struct sk_buff *netdev_alloc_skb_ip_align(struct net_device *dev,
>  
>  static inline void skb_free_frag(void *addr)
>  {
> -	page_frag_free(addr);
> +	page_frag_free_va(addr);
>  }
>  
>  void *__napi_alloc_frag_align(unsigned int fragsz, unsigned int align_mask);
> diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> index fbdf5a1aabfe..3b70b6b071b9 100644
> --- a/kernel/bpf/cpumap.c
> +++ b/kernel/bpf/cpumap.c
> @@ -323,7 +323,7 @@ static int cpu_map_kthread_run(void *data)
>  
>  			/* Bring struct page memory area to curr CPU. Read by
>  			 * build_skb_around via page_is_pfmemalloc(), and when
> -			 * freed written by page_frag_free call.
> +			 * freed written by page_frag_free_va call.
>  			 */
>  			prefetchw(page);
>  		}
> diff --git a/mm/page_frag_cache.c b/mm/page_frag_cache.c
> index c5bc72cf018a..70fb6dead624 100644
> --- a/mm/page_frag_cache.c
> +++ b/mm/page_frag_cache.c
> @@ -59,9 +59,9 @@ void __page_frag_cache_drain(struct page *page, unsigned int count)
>  }
>  EXPORT_SYMBOL(__page_frag_cache_drain);
>  
> -void *__page_frag_alloc_align(struct page_frag_cache *nc,
> -			      unsigned int fragsz, gfp_t gfp_mask,
> -			      unsigned int align_mask)
> +void *__page_frag_alloc_va_align(struct page_frag_cache *nc,
> +				 unsigned int fragsz, gfp_t gfp_mask,
> +				 unsigned int align_mask)
>  {
>  #if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
>  	unsigned int size = nc->size;
> @@ -130,16 +130,16 @@ void *__page_frag_alloc_align(struct page_frag_cache *nc,
>  
>  	return nc->va + (size - remaining);
>  }
> -EXPORT_SYMBOL(__page_frag_alloc_align);
> +EXPORT_SYMBOL(__page_frag_alloc_va_align);
>  
>  /*
>   * Frees a page fragment allocated out of either a compound or order 0 page.
>   */
> -void page_frag_free(void *addr)
> +void page_frag_free_va(void *addr)
>  {
>  	struct page *page = virt_to_head_page(addr);
>  
>  	if (unlikely(put_page_testzero(page)))
>  		free_unref_page(page, compound_order(page));
>  }
> -EXPORT_SYMBOL(page_frag_free);
> +EXPORT_SYMBOL(page_frag_free_va);
> diff --git a/mm/page_frag_test.c b/mm/page_frag_test.c
> index b7a5affb92f2..9eaa3ab74b29 100644
> --- a/mm/page_frag_test.c
> +++ b/mm/page_frag_test.c
> @@ -276,7 +276,7 @@ static int page_frag_pop_thread(void *arg)
>  
>  		if (obj) {
>  			nr--;
> -			page_frag_free(obj);
> +			page_frag_free_va(obj);
>  		} else {
>  			cond_resched();
>  		}
> @@ -304,13 +304,16 @@ static int page_frag_push_thread(void *arg)
>  		int ret;
>  
>  		if (test_align) {
> -			va = page_frag_alloc_align(&test_frag, test_alloc_len,
> -						   GFP_KERNEL, SMP_CACHE_BYTES);
> +			va = page_frag_alloc_va_align(&test_frag,
> +						      test_alloc_len,
> +						      GFP_KERNEL,
> +						      SMP_CACHE_BYTES);
>  
>  			WARN_ONCE((unsigned long)va & (SMP_CACHE_BYTES - 1),
>  				  "unaligned va returned\n");
>  		} else {
> -			va = page_frag_alloc(&test_frag, test_alloc_len, GFP_KERNEL);
> +			va = page_frag_alloc_va(&test_frag, test_alloc_len,
> +						GFP_KERNEL);
>  		}
>  
>  		if (!va)
> @@ -318,7 +321,7 @@ static int page_frag_push_thread(void *arg)
>  
>  		ret = objpool_push(va, pool);
>  		if (ret) {
> -			page_frag_free(va);
> +			page_frag_free_va(va);
>  			cond_resched();
>  		} else {
>  			nr--;
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 83f8cd8aa2d1..4b8acd967793 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -314,8 +314,8 @@ void *__napi_alloc_frag_align(unsigned int fragsz, unsigned int align_mask)
>  	fragsz = SKB_DATA_ALIGN(fragsz);
>  
>  	local_lock_nested_bh(&napi_alloc_cache.bh_lock);
> -	data = __page_frag_alloc_align(&nc->page, fragsz, GFP_ATOMIC,
> -				       align_mask);
> +	data = __page_frag_alloc_va_align(&nc->page, fragsz, GFP_ATOMIC,
> +					  align_mask);
>  	local_unlock_nested_bh(&napi_alloc_cache.bh_lock);
>  	return data;
>  
> @@ -330,8 +330,8 @@ void *__netdev_alloc_frag_align(unsigned int fragsz, unsigned int align_mask)
>  		struct page_frag_cache *nc = this_cpu_ptr(&netdev_alloc_cache);
>  
>  		fragsz = SKB_DATA_ALIGN(fragsz);
> -		data = __page_frag_alloc_align(nc, fragsz, GFP_ATOMIC,
> -					       align_mask);
> +		data = __page_frag_alloc_va_align(nc, fragsz, GFP_ATOMIC,
> +						  align_mask);
>  	} else {
>  		local_bh_disable();
>  		data = __napi_alloc_frag_align(fragsz, align_mask);
> @@ -748,14 +748,14 @@ struct sk_buff *__netdev_alloc_skb(struct net_device *dev, unsigned int len,
>  
>  	if (in_hardirq() || irqs_disabled()) {
>  		nc = this_cpu_ptr(&netdev_alloc_cache);
> -		data = page_frag_alloc(nc, len, gfp_mask);
> +		data = page_frag_alloc_va(nc, len, gfp_mask);
>  		pfmemalloc = nc->pfmemalloc;
>  	} else {
>  		local_bh_disable();
>  		local_lock_nested_bh(&napi_alloc_cache.bh_lock);
>  
>  		nc = this_cpu_ptr(&napi_alloc_cache.page);
> -		data = page_frag_alloc(nc, len, gfp_mask);
> +		data = page_frag_alloc_va(nc, len, gfp_mask);
>  		pfmemalloc = nc->pfmemalloc;
>  
>  		local_unlock_nested_bh(&napi_alloc_cache.bh_lock);
> @@ -845,7 +845,7 @@ struct sk_buff *napi_alloc_skb(struct napi_struct *napi, unsigned int len)
>  	} else {
>  		len = SKB_HEAD_ALIGN(len);
>  
> -		data = page_frag_alloc(&nc->page, len, gfp_mask);
> +		data = page_frag_alloc_va(&nc->page, len, gfp_mask);
>  		pfmemalloc = nc->page.pfmemalloc;
>  	}
>  	local_unlock_nested_bh(&napi_alloc_cache.bh_lock);
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index bcc5551c6424..7d4e09fb478f 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -387,7 +387,7 @@ void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
>  		page_pool_put_full_page(page->pp, page, napi_direct);
>  		break;
>  	case MEM_TYPE_PAGE_SHARED:
> -		page_frag_free(data);
> +		page_frag_free_va(data);
>  		break;
>  	case MEM_TYPE_PAGE_ORDER0:
>  		page = virt_to_page(data); /* Assumes order0 page*/
> diff --git a/net/rxrpc/txbuf.c b/net/rxrpc/txbuf.c
> index c3913d8a50d3..dccb0353ee84 100644
> --- a/net/rxrpc/txbuf.c
> +++ b/net/rxrpc/txbuf.c
> @@ -33,8 +33,8 @@ struct rxrpc_txbuf *rxrpc_alloc_data_txbuf(struct rxrpc_call *call, size_t data_
>  
>  	data_align = umax(data_align, L1_CACHE_BYTES);
>  	mutex_lock(&call->conn->tx_data_alloc_lock);
> -	buf = page_frag_alloc_align(&call->conn->tx_data_alloc, total, gfp,
> -				    data_align);
> +	buf = page_frag_alloc_va_align(&call->conn->tx_data_alloc, total, gfp,
> +				       data_align);
>  	mutex_unlock(&call->conn->tx_data_alloc_lock);
>  	if (!buf) {
>  		kfree(txb);
> @@ -96,17 +96,18 @@ struct rxrpc_txbuf *rxrpc_alloc_ack_txbuf(struct rxrpc_call *call, size_t sack_s
>  	if (!txb)
>  		return NULL;
>  
> -	buf = page_frag_alloc(&call->local->tx_alloc,
> -			      sizeof(*whdr) + sizeof(*ack) + 1 + 3 + sizeof(*trailer), gfp);
> +	buf = page_frag_alloc_va(&call->local->tx_alloc,
> +				 sizeof(*whdr) + sizeof(*ack) + 1 + 3 + sizeof(*trailer), gfp);
>  	if (!buf) {
>  		kfree(txb);
>  		return NULL;
>  	}
>  
>  	if (sack_size) {
> -		buf2 = page_frag_alloc(&call->local->tx_alloc, sack_size, gfp);
> +		buf2 = page_frag_alloc_va(&call->local->tx_alloc, sack_size,
> +					  gfp);
>  		if (!buf2) {
> -			page_frag_free(buf);
> +			page_frag_free_va(buf);
>  			kfree(txb);
>  			return NULL;
>  		}
> @@ -180,7 +181,7 @@ static void rxrpc_free_txbuf(struct rxrpc_txbuf *txb)
>  			  rxrpc_txbuf_free);
>  	for (i = 0; i < txb->nr_kvec; i++)
>  		if (txb->kvec[i].iov_base)
> -			page_frag_free(txb->kvec[i].iov_base);
> +			page_frag_free_va(txb->kvec[i].iov_base);
>  	kfree(txb);
>  	atomic_dec(&rxrpc_nr_txbuf);
>  }
> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
> index 6b3f01beb294..42d20412c1c3 100644
> --- a/net/sunrpc/svcsock.c
> +++ b/net/sunrpc/svcsock.c
> @@ -1222,8 +1222,8 @@ static int svc_tcp_sendmsg(struct svc_sock *svsk, struct svc_rqst *rqstp,
>  	/* The stream record marker is copied into a temporary page
>  	 * fragment buffer so that it can be included in rq_bvec.
>  	 */
> -	buf = page_frag_alloc(&svsk->sk_frag_cache, sizeof(marker),
> -			      GFP_KERNEL);
> +	buf = page_frag_alloc_va(&svsk->sk_frag_cache, sizeof(marker),
> +				 GFP_KERNEL);
>  	if (!buf)
>  		return -ENOMEM;
>  	memcpy(buf, &marker, sizeof(marker));
> @@ -1235,7 +1235,7 @@ static int svc_tcp_sendmsg(struct svc_sock *svsk, struct svc_rqst *rqstp,
>  	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, rqstp->rq_bvec,
>  		      1 + count, sizeof(marker) + rqstp->rq_res.len);
>  	ret = sock_sendmsg(svsk->sk_sock, &msg);
> -	page_frag_free(buf);
> +	page_frag_free_va(buf);
>  	if (ret < 0)
>  		return ret;
>  	*sentp += ret;
> -- 
> 2.33.0
> 

-- 
Chuck Lever

