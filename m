Return-Path: <kvm+bounces-49144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58F09AD622D
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:08:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 947C13AB30E
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:07:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA47D24A041;
	Wed, 11 Jun 2025 22:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QXESU1PP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336911E9B28;
	Wed, 11 Jun 2025 22:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749679676; cv=fail; b=LTxL3Z11R9SuhPFTTEFicKce1QwU6r4VhHrmHN0pTq4Lnhv2TVcsmLsUy0lahiqtyzuzgS22urAu8EluoVdhtJcv+R5CRfiQSQ28Huq8vJL0uqCT1emSP9kcpaPNl22XDi9odEJZxWPKEigZlusI86tu5x8I34CBwrHg/kHYMgA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749679676; c=relaxed/simple;
	bh=1hACRujv31MfI5Oqeb1IF579czcHCoC5EHmBbhcdKFg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KxrTSmgLpiXtLL4j8jYr2+p7UdGwOFYfJ5NOXs3XIzm2o0znmznke6ls/FUOelA/3Z36VbFTaAMVh0+mApuNeSjEv6P4uRpdIcG4bSuZk+pyLClXJJUTzUzz0Aap17n+I0mcNhDghSHn8yNHbtG1sXunBepR6VHupaLCMl5FKCM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QXESU1PP; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749679675; x=1781215675;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=1hACRujv31MfI5Oqeb1IF579czcHCoC5EHmBbhcdKFg=;
  b=QXESU1PPRxIHxJDOgYJX0RwYsrf6XZAQWXyZuoE+nEecafD5dhAPNpbB
   f4mj5BFUS3XDA/qAT5fcVXrayfHnY6CMuH+LI2kKlyJTYyDIj2FVGiPnu
   y056oAddWeWhucvOk7Hfh1izwfGLbPqKAYlwZsnuQKx7q+rxk7ueMqFDq
   ElNE+iybdvb4vyVV3OY0V7tM33z0UIf9EPPZg+/pT5GPCgcZnMQWu6lZ3
   Z9gUaaIrCc+y5WiL7ESLuZlK8Geac6L/JpkvLI6U2YB/bVDhQ2suR2Zl5
   9kgFGJ3+S1+DJ7ndIJ1dKUdcLa4ExRTv2aQmhsnz77orT/8k0rGOFjst5
   w==;
X-CSE-ConnectionGUID: rHo1HCijSlCP/yDJXZLDIA==
X-CSE-MsgGUID: 3xE7PN2TTUqqPOuRIpdFqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="62119088"
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="62119088"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 15:07:37 -0700
X-CSE-ConnectionGUID: HPWe6ePQRxKcF4RgNP5yDw==
X-CSE-MsgGUID: vm1Ojz8BTByV/pCyA4fwSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="148229760"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 15:07:36 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 15:07:35 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 15:07:35 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.40) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 15:07:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tvnqZGNjGethG1pZVxWa7M9K+Yk10SFYA7GGQ0uDVYSwUPQWVjihNP5ZED8vVY5KF5KO/Gcis41Ab2b1k22wzZ1bIC5G1338bGAqjh9bpfSgVYOdN0jd7x2wVs7jwG/i663PfrduxaOc+nlLpE3tA8WVx6/TV3GfrLWtOo+k2nRVcmbIuDpV92AqyFTgLwfVGc4z9xn+Ico6OalWF1XO+fMD8GFH+JpCPtP/87GgZkkSb/uBdP5V9rbZDnNbPtENv8sPzJFYJgMj4Ku/dk97ctLprL39ReXZWAflL5eFX2rsw1AfaOusnd6LUQBBxB6BLDLt7puuaceHTaqeyk9ypg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uNarKoDDK55XDLxiXAD45YJxTLGvIECNt6uGAYmln5E=;
 b=mnIn4pVzqyLhJC2QXl6YkschOhl3opsnBmDDlzf597Rua3vnycyvn1h1vqFbo59f8p0o/lazWdVNFO9qkmfENOGDcUZYji1SKcTfvVfCv7tlH7QFSzRlZnq22blpOoI47hjh+mRXFC3IQPJHPh7A0GDCleY9fYesSEJVVV5nx8Kt9aqK5HUa3AT1quOWaeiFpuPv9wo+XKzQFDk8ZsNHE3EBai3dAnf9H2BSGVhvSqELbyB2TOMGa/PyCTLk05ISiHUC+K2FELrrSwnfb+kUnGksrCGKe5JlOvfgF1NveS6Lp+YqZ7k4HL7Luoq7/vAkVtnTMkqRtsLoXGY7R2WUqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by SJ5PPFC35D45AFD.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::853) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.21; Wed, 11 Jun
 2025 22:07:32 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%3]) with mapi id 15.20.8835.018; Wed, 11 Jun 2025
 22:07:31 +0000
Date: Wed, 11 Jun 2025 23:07:23 +0100
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Mario Limonciello <superm1@kernel.org>
CC: Alex Williamson <alex.williamson@redhat.com>, <bhelgaas@google.com>,
	<mario.limonciello@amd.com>, <rafael.j.wysocki@intel.com>,
	<huang.ying.caritas@gmail.com>, <stern@rowland.harvard.edu>,
	<linux-pci@vger.kernel.org>, <mike.ximing.chen@intel.com>,
	<ahsan.atta@intel.com>, <suman.kumar.chakraborty@intel.com>,
	<kvm@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] PCI: Explicitly put devices into D0 when initializing
 - Bug report
Message-ID: <aEn+G7GfSJ0kTntx@gcabiddu-mobl.ger.corp.intel.com>
References: <aEl8J3kv6HAcAkUp@gcabiddu-mobl.ger.corp.intel.com>
 <56d0e247-8095-4793-a5a9-0b5cf2565b88@kernel.org>
 <20250611100002.1e14381a.alex.williamson@redhat.com>
 <aEmrJSqhApz/sRe8@gcabiddu-mobl.ger.corp.intel.com>
 <e4047149-ddfe-4b70-991c-81beb18f8291@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e4047149-ddfe-4b70-991c-81beb18f8291@kernel.org>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DB9PR01CA0006.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:1d8::11) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|SJ5PPFC35D45AFD:EE_
X-MS-Office365-Filtering-Correlation-Id: e1efeb92-aea0-4c76-b125-08dda9345cc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?1gfHokY9F5k38nCkNcXJu6+M1xj9DlRElNn0fk44h6sLdS7rG3n88A+r0fTk?=
 =?us-ascii?Q?goWIzUFhY78hrl4vtqmKt73golcDrkdkNKaFugSM7x4vxLVz4R0GyEgHlN6m?=
 =?us-ascii?Q?uygYxXYwTE+piNZMAMs/5m/PhXjmf6RD1isMuAbhLjKmP+YmfQibf3iorDq1?=
 =?us-ascii?Q?UX4bRl71uNsmPHAuEIyqn3yU0LZu3pG9IaMTpeIC5Ww93m3CAYmXamu0+yfU?=
 =?us-ascii?Q?ekTBTils+wfkFmAMI22KJuRtnJ/YBY8ungZCDLMrTT74LbmMUHilQbOijD06?=
 =?us-ascii?Q?S8HnO1Kud4zqHpvU7v8ErUgNxoJywSseln0yNmGRWfWkdOP/61poGUfFw/eF?=
 =?us-ascii?Q?Z0S+MPMxFVn0rrxeyysstDhOmm72kixfE16Ypu+LLJN3s7rIQJqlFIm+hlOr?=
 =?us-ascii?Q?I7TZyJtFQodJP0xxI4FsJWiKdmQTcla8e1LaVLg66KyBuNITX7mYOeixYx9/?=
 =?us-ascii?Q?bNIf9gLKlPlxbP5DprbPViAOa7254x1hNqEoXPZe3TV8Hz3SZO1Cq5LatO+x?=
 =?us-ascii?Q?LeAtaTOh8JonxYF8UAGvR2aD1fQ6wUZc2owGWa1mvqxeHmhYiFwMhC3aO+nL?=
 =?us-ascii?Q?ThRL1JnqaPwwDSQd7caLcMW8jEZN7y04dc1aM9DP1xzHm+QlidKL6gYOGwJy?=
 =?us-ascii?Q?q3Zr8E7Ln/zLwKchrx3qxJMeC9t7rEhtt+/T+odtwWqCajc510OpJd2gKKOt?=
 =?us-ascii?Q?VdClS04T1ezIRC7eCj78w32R8Xtnqzyvv+cab57+X4N3xAWWR4K4lV6CXnO5?=
 =?us-ascii?Q?1sjX1ZUy6NRNTvTh7q18hzohSVJ0SaQ64Z+EqxBkxNA5tNNWQGmDgF04/FV8?=
 =?us-ascii?Q?N4U8lcDBhvd2zKLRSozfpHKq5NbiqnfCf9iq2xLli5Xy+MxpmnuC4t6Fiq5e?=
 =?us-ascii?Q?tyyE8IWTwOfyXrUeMWdNV/elukFKxEkpUWFN8pZIzvoH3wzt7wRQA91izJaQ?=
 =?us-ascii?Q?7y4e9vqaOpV/BhI7LxJqssPm5yulYu7rVG8IJs+Nu1Dizo1UTzpaF0SrSJN1?=
 =?us-ascii?Q?wc9hp4mvVwGYunTwA1V321VnlGIsyIJf0k/+pZQJKoGFe5adPCY5xTx7iJZo?=
 =?us-ascii?Q?VsHWYrKglgmXt32m5pl+wAALMsQ+ABXTgCae0TYpb46AAxdDBlbCTgjVMWm6?=
 =?us-ascii?Q?jHjLeqZLNK4tH4B2YdidB2LWFoCTSGU6IgPIsl9vBHtn4FG4QPPsU/w/o1NN?=
 =?us-ascii?Q?NFKYp67++Pis8cAG/j6hH3u9aYUdcoQBI0LKnwCw7Dgt1UudLQUzSLLLNfpu?=
 =?us-ascii?Q?gZWXKxZLIMH8fu5L6cV+LpMfi70a8n6mmd4pQSnv/3XbZMq86QeGDInqnxEs?=
 =?us-ascii?Q?J7bs/aQ4hBFr+krkBcLEBt99Z40dIhthem4E2XtFyjJiLEnyAn5Wmf+QlIez?=
 =?us-ascii?Q?TEgHTTP0DLNbaRftQ9K468ptf3d2d1zpBD9GZ2JlG066D5fzVkn5sqFQBIg+?=
 =?us-ascii?Q?qYoGhGZn1Ts=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9+R06xPL8/4AgcB+4Rf6gC9ZsXeS6+zQxbOP2ng1e2YZjlQGl+jbEqakEsnL?=
 =?us-ascii?Q?RCDNd7hEtMdkN6i1bw+XZ7SIRZ0eIhhxXjz3YCLX3McBLPo8ctfKH/O7xTfD?=
 =?us-ascii?Q?d9VK1SZpNcIWVbZAdiDk0iEliEAjJXA/gnCWPB+RhrqRToHEGUjIBtJqVrk6?=
 =?us-ascii?Q?8HK8dKvPti56Rv0nK+AnujLmE4COoXU/VfbOlB9o3iJsFqLqHHWl+PHzTwQ2?=
 =?us-ascii?Q?YV1LWuT3/yIVoK2cQSQDYJgvgR6efzwlTVj85xXVsUok4VynuRyQf93DJEB4?=
 =?us-ascii?Q?g2sYk/QlUiwUuqO5bSZceY6jPcvPt9o9Ie5PrwDU1axlzplW0F+F3MP61l/8?=
 =?us-ascii?Q?DBxPJ7O2nVaD+pCTGH1prr+VO5gSqPkjeDtvzZUX2fYYQtSw3Y2DHkVjZQoX?=
 =?us-ascii?Q?1WZw/uyPM80YUm+YT4mZwzRfN7fmIlBVoi5uv3ziOsICge3c53L9GjkVMqBj?=
 =?us-ascii?Q?Fwi3/JMyhgB7iM0R5nxorXuAN4lPtCRFjkdxbnotcC77BT0JY1IMiFwt3p2j?=
 =?us-ascii?Q?9gDM8UIFYY9uH5dPOE4yKcPOaCb/WOG79W792aSzY9+uHWA7jpAfAqePbZbh?=
 =?us-ascii?Q?5yvuQNRi3U0qufWihgQ0XCiiTqoPID+QZ68J+Z09+S81dfEqbuF3f8HvgEH4?=
 =?us-ascii?Q?6VVczRB1a94aJeDO3sMwkU+5r2RZRjz3KqYvvrMaSF/f/+Bp802CqIHZuv8u?=
 =?us-ascii?Q?QMcPRN1nA5JolD+J32bJNoeZjAdDx2XCpmCbEVt3yUveKt7T+r5rygmtBXZd?=
 =?us-ascii?Q?9yWUGUXExV6niDG1tU9DVNKO1YJsfh0cbOwZmk4HHDCDB3+J0Z+6A03/Dycc?=
 =?us-ascii?Q?25TD6gp3TsfPi0G7bt4+B2O/QLom1w4RPYXQR9HZxa3YV4zvVXkl7IfDKag0?=
 =?us-ascii?Q?H4xwUm9M94TW28jwRZcgbK9ysak14kZ85OethbDT41oCexJR6WMqbEqBjcj0?=
 =?us-ascii?Q?mWx4MHKIti7uCap0UvSr8OFsLrPAK8Gp0FOia8NwBQLNGNRULzGjTtVCZjXf?=
 =?us-ascii?Q?LXA541jPQggdfGrszHoNtPxmno6yjioA4+fLBOfBHib/em+lysoXtp/tsuFs?=
 =?us-ascii?Q?HXxaLE68NnozNZrkAmZho15juXLxfUzMpcG4kkwJkpQ+FursE7N+61K86ega?=
 =?us-ascii?Q?ZXySGMomSdYCmENbsZeHO6JBMfNS5BFQol7ZqqembTT6vcjmkv7hA5GIWE0a?=
 =?us-ascii?Q?GYyqAyMTiAglvSYUhKfFI1td9fiI4FAsiPzMSdsSgz0lEOHrPvbC0gh17Kqt?=
 =?us-ascii?Q?jVYrJ5dbORft8Rwn7iBQEQZfnuBP8adDru1IoHifI0FHNk/uIjR3ICLGkSw6?=
 =?us-ascii?Q?7r8UIfa1PkCBfPv1m2bFqtXqvTF1mqSHnQwu3JYk2F/F+5msKwsOL4w3XvR8?=
 =?us-ascii?Q?iiNa/n2ah/2BTHiLahEIcKclUcDxwnrYM6NLOEG5DzvJeHbiHqHO2bjb689z?=
 =?us-ascii?Q?vsSU/KbwGoR4F118vJduXb4Dcu2aEQs02kBuLCZMesbqOrkDk418Poh8+JRO?=
 =?us-ascii?Q?xdUwcMZfvVX32Kp7Q5naeO8oOjdNZmZuSqYsAclgaCVf/zENQBj0sWqQUytx?=
 =?us-ascii?Q?GBZw9DZRV9wawqfXUi7BJnsWvn0eDBp5g+/U+Agerp5bqwuVVIFkqHD4V5MQ?=
 =?us-ascii?Q?vw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e1efeb92-aea0-4c76-b125-08dda9345cc0
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2025 22:07:31.7872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ycWgD6IXAcZuXhNLpN3m4OEVrBDL13bQ6FeEEljlfIlPQcObHsWr5ciG1zheJiQn9KtxlHSG8fQSdUK5uuR72MhhW3sukfATAmOcNvGnVeU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFC35D45AFD
X-OriginatorOrg: intel.com

On Wed, Jun 11, 2025 at 01:45:49PM -0700, Mario Limonciello wrote:
> On 6/11/2025 9:13 AM, Cabiddu, Giovanni wrote:
> > On Wed, Jun 11, 2025 at 10:00:02AM -0600, Alex Williamson wrote:
> > > On Wed, 11 Jun 2025 06:50:59 -0700
> > > Mario Limonciello <superm1@kernel.org> wrote:
> > > 
> > > > On 6/11/2025 5:52 AM, Cabiddu, Giovanni wrote:
> > > > > Hi Mario, Bjorn and Alex,
> > > > > 
> > > > > On Wed, Apr 23, 2025 at 11:31:32PM -0500, Mario Limonciello wrote:
> > > > > > From: Mario Limonciello <mario.limonciello@amd.com>
> > > > > > 
> > > > > > AMD BIOS team has root caused an issue that NVME storage failed to come
> > > > > > back from suspend to a lack of a call to _REG when NVME device was probed.
> > > > > > 
> > > > > > commit 112a7f9c8edbf ("PCI/ACPI: Call _REG when transitioning D-states")
> > > > > > added support for calling _REG when transitioning D-states, but this only
> > > > > > works if the device actually "transitions" D-states.
> > > > > > 
> > > > > > commit 967577b062417 ("PCI/PM: Keep runtime PM enabled for unbound PCI
> > > > > > devices") added support for runtime PM on PCI devices, but never actually
> > > > > > 'explicitly' sets the device to D0.
> > > > > > 
> > > > > > To make sure that devices are in D0 and that platform methods such as
> > > > > > _REG are called, explicitly set all devices into D0 during initialization.
> > > > > > 
> > > > > > Fixes: 967577b062417 ("PCI/PM: Keep runtime PM enabled for unbound PCI devices")
> > > > > > Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> > > > > > ---
> > > > > Through a bisect, we identified that this patch, in v6.16-rc1,
> > > > > introduces a regression on vfio-pci across all Intel QuickAssist (QAT)
> > > > > devices. Specifically, the ioctl VFIO_GROUP_GET_DEVICE_FD call fails
> > > > > with -EACCES.
> > > > > 
> > > > > Upon further investigation, the -EACCES appears to originate from the
> > > > > rpm_resume() function, which is called by pm_runtime_resume_and_get()
> > > > > within vfio_pci_core_enable(). Here is the exact call trace:
> > > > > 
> > > > >       drivers/base/power/runtime.c: rpm_resume()
> > > > >       drivers/base/power/runtime.c: __pm_runtime_resume()
> > > > >       include/linux/pm_runtime.h: pm_runtime_resume_and_get()
> > > > >       drivers/vfio/pci/vfio_pci_core.c: vfio_pci_core_enable()
> > > > >       drivers/vfio/pci/vfio_pci.c: vfio_pci_open_device()
> > > > >       drivers/vfio/vfio_main.c: device->ops->open_device()
> > > > >       drivers/vfio/vfio_main.c: vfio_df_device_first_open()
> > > > >       drivers/vfio/vfio_main.c: vfio_df_open()
> > > > >       drivers/vfio/group.c: vfio_df_group_open()
> > > > >       drivers/vfio/group.c: vfio_device_open_file()
> > > > >       drivers/vfio/group.c: vfio_group_ioctl_get_device_fd()
> > > > >       drivers/vfio/group.c: vfio_group_fops_unl_ioctl(..., VFIO_GROUP_GET_DEVICE_FD, ...)
> > > > > 
> > > > > Is this a known issue that affects other devices? Is there any ongoing
> > > > > discussion or fix in progress?
> > > > > 
> > > > > Thanks,
> > > > 
> > > > This is the first I've heard about an issue with that patch.
> > > > 
> > > > Does setting the VFIO parameter disable_idle_d3 help?
> > > > 
> > > > If so; this feels like an imbalance of runtime PM calls in the VFIO
> > > > stack that this patch exposed.
> > > > 
> > > > Alex, any ideas?
> > > 
> > > Does the device in question have a PM capability?  I note that
> > > 4d4c10f763d7 makes the sequence:
> > > 
> > >         pm_runtime_forbid(&dev->dev);
> > >         pm_runtime_set_active(&dev->dev);
> > >         pm_runtime_enable(&dev->dev);
> > > 
> > > Dependent on the presence of a PM capability.  The PM capability is
> > > optional on SR-IOV VFs.  This feels like a bug in the original patch,
> > > we should be able to use pm_runtime ops on a device without
> > > specifically checking if the device supports PCI PM.
> > > 
> > > vfio-pci also has a somewhat unique sequence versus other drivers, we
> > > don't call pci_enable_device() until the user opens the device, but we
> > > want to put the device into low power before that occurs.  Historically
> > > PCI-core left device in an unknown power state between driver uses, so
> > > we've needed to manually move the device to D0 before calling
> > > pm_runtime_allow() and pm_runtime_put() (see
> > > vfio_pci_core_register_device()).  Possibly this is redundant now but
> > > we're using pci_set_power_state() which shouldn't interact with
> > > pm_runtime, so my initial guess is that we might be unbalanced because
> > > this is a VF w/o a PM capability and we've missed the expected
> > > pm_runtime initialization sequence.  Thanks,
> > 
> > Yes, for Intel QAT, the issue occurs with a VF without the PM capability.
> > 
> > Thanks,
> > 
> 
> Got it, thanks Alex!  I think this should help return it to previous
> behavior for devices without runtime PM and still fix the problem it needed
> to.
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 3dd44d1ad829..c495c3c692f5 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -3221,15 +3221,17 @@ void pci_pm_init(struct pci_dev *dev)
> 
>         /* find PCI PM capability in list */
>         pm = pci_find_capability(dev, PCI_CAP_ID_PM);
> -       if (!pm)
> +       if (!pm) {
> +               goto poweron;
>                 return;
> +       }
>         /* Check device's ability to generate PME# */
>         pci_read_config_word(dev, pm + PCI_PM_PMC, &pmc);
> 
>         if ((pmc & PCI_PM_CAP_VER_MASK) > 3) {
>                 pci_err(dev, "unsupported PM cap regs version (%u)\n",
>                         pmc & PCI_PM_CAP_VER_MASK);
> -               return;
> +               goto poweron;
>         }
> 
>         dev->pm_cap = pm;
> @@ -3274,6 +3276,7 @@ void pci_pm_init(struct pci_dev *dev)
>         pci_read_config_word(dev, PCI_STATUS, &status);
>         if (status & PCI_STATUS_IMM_READY)
>                 dev->imm_ready = 1;
> +poweron:
>         pci_pm_power_up_and_verify_state(dev);
>         pm_runtime_forbid(&dev->dev);
>         pm_runtime_set_active(&dev->dev);

I tried this change and it works.

Thanks,

-- 
Giovanni

