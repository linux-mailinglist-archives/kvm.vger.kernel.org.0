Return-Path: <kvm+bounces-61567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DFC5CC224B9
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 21:37:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 790EA1AA0DBD
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 20:34:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F0AD33E365;
	Thu, 30 Oct 2025 20:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bg5c6o33"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B582933E357;
	Thu, 30 Oct 2025 20:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761856365; cv=fail; b=kabzXSWB4SQo6RmyF3Em3QJ1B/cz8lRkn1RxKsF9T/822MatQSedi3FKXl0O7w4GBpqOOqzc6e5No+8YygWYPNil20G+L4kRUFgkNkx8KyJpsTYoboSOy0TRGJEjVn9Y2Mpi9kkiLGOYS9I+RmxcBDg2nzhWPRslmgH7Zpr6ApE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761856365; c=relaxed/simple;
	bh=C9d2xKjujHx0B+OppIS+1LcFq8RqiuhQmvGsgTLgUXE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KIUBKaPRfEMtQpXbdkjal5TeQliGRUTy0l4xS0TxGafMEe0G0s4c9UtPYiK0AjGPpolepXEZ3mrJz5If2nNk6UCnYVgyngW6dfhi0eE+TFmBuq2fBMbsTY0HD+f49/PTPrWw0LX+kn8MoOCXcw5AUGYwyNUNLeT57EQi/FbEBSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bg5c6o33; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761856364; x=1793392364;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=C9d2xKjujHx0B+OppIS+1LcFq8RqiuhQmvGsgTLgUXE=;
  b=Bg5c6o33CXJp3dHlvyg9PSYkXzVgrJSd30VTkaMmaD+TxAFUpr0SfmRZ
   PAarJ8nwIutH+RrthDRhsWVScDwRZ+8l0MvBAbsNZQ/KSyj1d+lRfmZe1
   ARen3nIpswFHa+d2YiepVUkdPD1SGMxFTfQEh4w0fk5EiOjeERqfOCcHV
   yWjSAkbcpOfqmt6rZ8YXvrMN1Cj2D+5Y1dmTe5YCu7eRIATn5j5DBDOEU
   ISj245a1zgfD20zkSm5bNS4UHUwVN4nbtvFpAuuKpKaysmChvTC0lQld1
   kRJxLUODqA9/yVdNcBcJx1DZXwtmKl60J4orvIuzSbjUn6HwGNI+UXtgq
   A==;
X-CSE-ConnectionGUID: Uo3nYaMWSBu2IBwupIyHOg==
X-CSE-MsgGUID: LS8XAgYZSvW9KiTV0W0e9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63916840"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63916840"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 13:32:44 -0700
X-CSE-ConnectionGUID: OpZP7mPETECbX1uOjmr9Bg==
X-CSE-MsgGUID: aURaAqFpSW+2UhyxmQiyWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="223284204"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 13:32:44 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 30 Oct 2025 13:32:42 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 30 Oct 2025 13:32:42 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.48) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 30 Oct 2025 13:32:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ffmrs50gJ6Chnthi+rbZQhPIyx+dOSPxMOHykk9ywII7KGG5QFr+fP81BgsdaT5G6xm8EUh6TcvY8Lu4OxvyqtWqq5eVrP3OWOcdgiE2auTH6oyHakZZWsWrew/wLmbuxn3LN0MGUbl6J1tLfRYTXQT0Lo1xVzfsGsyEkGeFN1SYvaUVvVX+yQM29PYmQgodiANFirIvu7w2DNkjSN4/BmzzyOR9BL2TbTw/4GnFq0GJ+nYyG3TdMUMdUaJHpDvYY+Q1ORufhMx6zL2A3Rz7IgjWwArKuO4nQ6dNtee0N5EjSdg7G1HKpGKs0wgxQ1jtFapIkpibjZA5D06vTeIrFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cweSNgu0ErXAmrjfAUxhpYFBfRjRDgZK+ft7w71BUjg=;
 b=Bp5iaHqXJN/Tdpfji6NqUAzJHxS1PIh+a4hs9V4vw1BwHqV69mnNqMMLME/WZbbTZaMiym/zEmWyVmvk8DuqfKhmpT6F+fspthydiz/MbFFZmNN77bvIlK8a2ADXCNV/S86LqzCM9P1c8xZiobtz2sQcfpBX6kx+s3+iaW16+CagdTW+otnfK9mWLhMSucD7yQyHFyL3A6OpZiCTrZhfN3anomXbJD0p8fyS/JhK8SuJjuEd2meSG1SfCOgoca69FhxwRJTfsRqatxzwSIuH8oyVnuF02lQzwbghYMp2/Q7HXraFMHGFtEFEJDNIz375/Ic8+nTwCaPPY55jSUdjjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 CO1PR11MB4817.namprd11.prod.outlook.com (2603:10b6:303:98::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.14; Thu, 30 Oct 2025 20:32:39 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9275.011; Thu, 30 Oct 2025
 20:32:39 +0000
From: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
To: Alex Williamson <alex@shazbot.org>, Lucas De Marchi
	<lucas.demarchi@intel.com>, =?UTF-8?q?Thomas=20Hellstr=C3=B6m?=
	<thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Kevin Tian
	<kevin.tian@intel.com>, Shameer Kolothum <skolothumtho@nvidia.com>,
	<intel-xe@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Matthew Brost <matthew.brost@intel.com>, "Michal
 Wajdeczko" <michal.wajdeczko@intel.com>
CC: <dri-devel@lists.freedesktop.org>, Jani Nikula
	<jani.nikula@linux.intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "Lukasz
 Laguna" <lukasz.laguna@intel.com>, Christoph Hellwig <hch@infradead.org>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
Subject: [PATCH v3 08/28] drm/xe/pf: Add minimalistic migration descriptor
Date: Thu, 30 Oct 2025 21:31:15 +0100
Message-ID: <20251030203135.337696-9-michal.winiarski@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251030203135.337696-1-michal.winiarski@intel.com>
References: <20251030203135.337696-1-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE0P281CA0033.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::20) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|CO1PR11MB4817:EE_
X-MS-Office365-Filtering-Correlation-Id: 679ac218-d4a9-42ca-15a2-08de17f37840
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Vzd3T284RDkxRTJ2STBWNzZRbG5CeE1MWmlISStjWXRBVm8yalpidmUrc3p4?=
 =?utf-8?B?dW9ZQUJiaFdtQ1ZtWkRNQmd5WXZEU2NrTzA5cjgzeTZ6N1I0L0dkd3VseENw?=
 =?utf-8?B?K3pMbW1IL2VKbnNiYnlFQ1hJR28xcTAyVXlSU0dGUDRHSGZHcWFDaUk5T3lY?=
 =?utf-8?B?TG94QXJiQTVlWVRGSWdVKytmbDEvZGlNb3ZkaGZrTE16cG1KUjhnRFZ4TXFY?=
 =?utf-8?B?MDExNXBUc01uZ2lpU1FtSDFnb295WTBFQnJjWDZCTTBiT2M1dTVEd205bmF6?=
 =?utf-8?B?OWJ6OGZQc0pWbkxodVV4TWR2ZU9lOHIxek1XNEFIN3Bybk1zUmZQUXZqeDZj?=
 =?utf-8?B?ck9HMGVpejNxMFRIaVkrdkxaMmdkdElBa2ZIN2d6UXJ6eEY2bzdnZSt1d1hB?=
 =?utf-8?B?YkVTUjJiVUFLUEFtbjk2MTNEbzB0TWdUdk54emVCSVV4RExCTFZiNitJdW9Y?=
 =?utf-8?B?ZDg3bUN3TVdjS3IxRFMyNjFqM2xHOVcwRmpiTDZvdzlCZGFLdFVNUUJBbW5k?=
 =?utf-8?B?VVRZN2xtN0U5VU02VFp1QXp3bDUvY3FkQTFBNElKSXVVWXFpUnV4dmQxWmVQ?=
 =?utf-8?B?bGRDSUw2OXQybkFxdjNFZEhqbWsxQWNqcjhGMVJyZEZxcENhWFRDeUxIYkRP?=
 =?utf-8?B?QjZrVWNwV1E4WXk2emt6YUI4S3lrTjduQ0Qwd2oxUzhFbHNqcU5Ub0dzOXND?=
 =?utf-8?B?T0g0bm5iYTZhNmxHZjlwZGlSRXJoaU1Rd3NNOTFTaGYwMUJ2L0hZU2lEQ3J5?=
 =?utf-8?B?cG9IMEFwMHBoTnpvRUt6dkgrQ3B4em5iTXdxTlNtQ096ejA2UGM3bCs2QUR0?=
 =?utf-8?B?aWxPODRmd2M2L09YUm5ueWxDc0k0Vk03REhqMUxmRU56dmkzLzZMc2I3dXRW?=
 =?utf-8?B?UUNjbm5GS3VQWWduTlE4VVJCMEV5SmkxMkpnY1AyRXhZQXBVSFlKc1BjUUo1?=
 =?utf-8?B?QjBIZGhUTGZQVnRxMmZRU3F1RUQ1dzhvTVJKUnlxN3dNYWtGQUpQZVJoMzNv?=
 =?utf-8?B?a28zV1ZRTUxEb2k0aXRLczlxM2dHY01lNVV5SlZQVTIwenNwZWhBWEUraEwv?=
 =?utf-8?B?YTZuYk5pMDIxRjMzUThwN1pBTTJobUlpWU0yWVVtMmJKUmMwVFpkWjdiRXBl?=
 =?utf-8?B?YUxXNnBrT2Nxa1hhZGlvbnB2S0FQYTFJNVlnOGNkM1luUXJGdUVPSGJXZ1dp?=
 =?utf-8?B?Wnc4TDRVakZvMGJ1akVPcHVLbmQwMXBFYkdueERyR29VTjJRcFFIYWVIeXlj?=
 =?utf-8?B?VzliSUJBK0o0VGRVTDRoRW5kNjR5MzJXbUZFNHpGdTR3QWZNNXhuQjRtUkZW?=
 =?utf-8?B?eFBvUy9KSmlISnVLZ2thdk1oTmZFbWpsVGV6L3ZmYjJWcmRSYWpZZmtPN2ox?=
 =?utf-8?B?enFsTWZYWkliUEExK2RzcGowV01SbVIwNVkzaWU5UEtUY3VRTHBwdGRpbHZG?=
 =?utf-8?B?S1I2RGExci9pRitRSEM3SUdkRFJ4K0hWaEhwQW5PaUZsVEV0WmNjWTFOSHpq?=
 =?utf-8?B?ZThEQS9uWExoUVFILytacTB0YVVSRTN3S3N2Qm1UMGRSblE3SUpiV0RQOHds?=
 =?utf-8?B?dGw1WG9wd1QrM2RSeTg5QUh1RVd5alZBNytmS1drc3ZVL1p0RVBvMWl2VzJT?=
 =?utf-8?B?dmpJSUhYRFh2aU8rYmlhWTZDTHdKQzRiL1VZckhFTUozdW8wdmQ0KzhXUmkv?=
 =?utf-8?B?TXRqOEMvZmxjSkkzNC9jQTZ1ZjI2RWYvTUJrc2ZiTVFjNEZFOWEvSFNZczRF?=
 =?utf-8?B?SkNiSi8zaStHWkkvZENXMnBER3NOMzJ2ZVFYaGRFbGE0YXZPRFQwS3ZQN29V?=
 =?utf-8?B?UGwvSWNGcE45Unl1Q2RlYmJ4eVhLUnBJZHJuMng4S1Bvdm03b2w2N2pOOWFM?=
 =?utf-8?B?OEpTZFVlMHFmanYxdUdQVVgrckZHYjFkdnRRL1MvaER6U2J2aTdLSzh1OXN6?=
 =?utf-8?B?bUdrRUVnM2RxelhqcTF2UTI0bzBSeUllMElsaUNDNXZnYlR5Q1VCTmozY0NZ?=
 =?utf-8?Q?BfGNA8G6A8a6+ESHSbeMRhfpWtSSXY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFdwL0FyTUJEM1JERUdUZ1hNVlkxanJ1MVBNeXM1YTBMUTAwWnZDOS9icTZ6?=
 =?utf-8?B?b1hicEpSTWtRd1RpQnF5RVJZOGp1TXhzZWtNM3RlMFloZmc2SGl3aExDWUN3?=
 =?utf-8?B?VzdBY2tPcW4yWlN6cWluVE14SDk1NjA3KzArMHR5cXV3bXdqWWFjbWsrZ3c2?=
 =?utf-8?B?NklWWEFWOUlhRG81UStjdEYvMFp3Qkc3U1hKSWxONWl6M2V4NHQ5UmEwTXFM?=
 =?utf-8?B?a2dOWm5NNmx2YU1pK0tVZmVvaTcwT1Y5MWJFWm5ZRXZzU1VSbXVSbTZITUpn?=
 =?utf-8?B?RDFSZ25WdkFZellnVzNSS245amtGc2Q0aytDN3E1TlE0bkdqT2pyaTJpOG9x?=
 =?utf-8?B?MERramgyR1NQd1Bxb21teHlvbERtYzFtZVkvRVhTanM5UFZTc242L21Pc3Fy?=
 =?utf-8?B?RnZ3QXNUS2FwV1NSRzlJckdJajlLSW9RdkVrcnowMDhNRCtlV0grUU9UdUVx?=
 =?utf-8?B?cmJQU2Z0Skw4Z0NtQi82a054Q2RuenlFMVJWaTZ0ZlBhc21NekwvdUtpUW9a?=
 =?utf-8?B?K2R4V2EreXRTRHZCZ3ZHREhLQkFTazZGT3hBWmdiVkJpWmlMcmxBNVVFMmE3?=
 =?utf-8?B?N0pYN1hEODY4dVZwSVlXWlhXdjhvbmxWejdBcVBqakwyWXJRREVpcGJlNlFk?=
 =?utf-8?B?a2ZvRUlvc1FNRWFZNGJGRDNGUXp2Yi9BWWZUS0RCYThBTjZaYlY2V2ZSTWhx?=
 =?utf-8?B?VnVmVmdhMjJobmxmVml0NjZ5eEpBaUVma0ZMelhmR2hXMGEyWTlReCtESm9T?=
 =?utf-8?B?bGFlQW5jTC9Bd2FiRzB5SDV4UmZNVXA5cHMxMEsvcmZFd1FPWWc4M2hqSHBu?=
 =?utf-8?B?clppMUEyNkhrQ0o2Ny9OM2pqQkN5VHJPWmxaMk1VM2c0alpFb3NMdGZpQk92?=
 =?utf-8?B?OWZCVTVGSzRjQi9uVFJnaWVBcnM2K1JUSVE2dG82L2g2YlVjY0pscmZwNm1u?=
 =?utf-8?B?eFQyVERiV1lXNEpXdXo0aVNHSlAxL1FXZ0ZPRklpcXdDem9JMXFTT2lySjE4?=
 =?utf-8?B?UjV4R2xPMER5TnRYSXVST3FkOHBaZWtWNk44OXpQNmNsUC9QeTRtNEg3YkEy?=
 =?utf-8?B?d1FiZVQ0S0ZHMkFvRDBQb0VkdkJZYUsrNC91TjNQSjlpM2tUbFVudmVZT3V0?=
 =?utf-8?B?aEhaL2plZUJ6UllDQUtmWnVaOFYycXlGMzcrTVl2UEZBWHdpRW9WR0loNWdo?=
 =?utf-8?B?aERKZkVmaFRCbkwvSjFuSDRNMGdDZXFTR3pWdG42eEs0cDBnTFN1Mk5uLzRp?=
 =?utf-8?B?V3o1eHBpV3dXUGxadm1TV1Z4SHlIVHhyNmJjMXRsWjkwNDZ4RXc1OWdlQ1ZR?=
 =?utf-8?B?a01QYkRReDh2UVpsRDVlbUloZHNrWWlaSVJLcVgrTndWTytBWFI0QVpERFVF?=
 =?utf-8?B?VG1YYTdWcWdZS2NZQVBvZURSWDlzNE1hVXFURlE4dHJLOFpnNXZYYVJBeDlV?=
 =?utf-8?B?V2dkZ1hzZjk1T3A5VnpQN0tNNkZEbCt1QmZxNWRaQkE0V3Rhd25WWTlJOFgv?=
 =?utf-8?B?c0NhR2Y0WFEzU3FMcDRobnlsUExWYWpVQTNPMnNQTmhaTlFaSWhmM2ZjSEVi?=
 =?utf-8?B?a0xUL09INEhya0pVM0d2ZGxaTWxnZUV2NmJ6N0R4VUg2RFlVSWRBUDJ6aEhK?=
 =?utf-8?B?NEFrSThZZ1FUUjN4QnBwZGpGenNjc01OTFVnOFNxdDNDRHVqTE1KRWRDMnJV?=
 =?utf-8?B?TjJ4bUNvcWcyRE9maFNmYjl4YnNRa1FNa2VqQkxZUEtpS2hTUnJacUpzS3Rl?=
 =?utf-8?B?MVhpV1Zlek9iMTl6NDlnU0ladzNxUk9HQTN4V1UxNVRTMWlMNHdLVk5zT1Jx?=
 =?utf-8?B?bUZjcXBkS2szWFQ2UzJ3V2JTOU5wNXB5K2ZPbzZWUzFxZFJCRHl5cUR1cXF1?=
 =?utf-8?B?S0hLTjhmVFhoVXIwS05wUDVMVG5NZVhpU1pkbGY5K3llLzYrazNVbnZYZFlH?=
 =?utf-8?B?QnI2ZlRkdWxJRnpKUFVhTGN0Mm8vNjNZcldJcmYvQ2IydHRVVlEyc1ZoKzJB?=
 =?utf-8?B?cmFvSTZnRWx2QjBRRXlNdGNHU0VnK0ladFJtMnZjYW1EKzhvVnhwbFFwUU50?=
 =?utf-8?B?UzUzQWlFWWJ2N3EvM05lbFE4aUJXL09icHgvRmFQaUhDWEJqa1E1NnRIL1k0?=
 =?utf-8?B?QTVMYm91WGJkWFg3N01abzVGakVvVzBkOFB3a2FwRlR4QUpSVUpUUllrUncw?=
 =?utf-8?B?R3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 679ac218-d4a9-42ca-15a2-08de17f37840
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 20:32:39.7112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ATmEVP71jXpfiPYEx+tID41iI9ws8ryrbKiCNjq/b6TcitS9BAAm2soX+1Kwtt8kjamifMH7BunL1fI+K3ARufzWTyEGgAD+rvxEuyja18=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4817
X-OriginatorOrg: intel.com

The descriptor reuses the KLV format used by GuC and contains metadata
that can be used to quickly fail migration when source is incompatible
with destination.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
---
 drivers/gpu/drm/xe/xe_sriov_migration_data.c | 89 +++++++++++++++++++-
 drivers/gpu/drm/xe/xe_sriov_migration_data.h |  2 +
 drivers/gpu/drm/xe/xe_sriov_pf_migration.c   |  6 ++
 3 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_sriov_migration_data.c b/drivers/gpu/drm/xe/xe_sriov_migration_data.c
index a3f50836adc81..18e17706772fc 100644
--- a/drivers/gpu/drm/xe/xe_sriov_migration_data.c
+++ b/drivers/gpu/drm/xe/xe_sriov_migration_data.c
@@ -5,6 +5,7 @@
 
 #include "xe_bo.h"
 #include "xe_device.h"
+#include "xe_guc_klv_helpers.h"
 #include "xe_sriov_migration_data.h"
 #include "xe_sriov_pf_helpers.h"
 #include "xe_sriov_pf_migration.h"
@@ -383,11 +384,19 @@ ssize_t xe_sriov_migration_data_write(struct xe_device *xe, unsigned int vfid,
 	return produced;
 }
 
-#define MIGRATION_DESCRIPTOR_DWORDS 0
+#define MIGRATION_KLV_DEVICE_DEVID_KEY	0xf001u
+#define MIGRATION_KLV_DEVICE_DEVID_LEN	1u
+#define MIGRATION_KLV_DEVICE_REVID_KEY	0xf002u
+#define MIGRATION_KLV_DEVICE_REVID_LEN	1u
+
+#define MIGRATION_DESCRIPTOR_DWORDS	(GUC_KLV_LEN_MIN + MIGRATION_KLV_DEVICE_DEVID_LEN + \
+					 GUC_KLV_LEN_MIN + MIGRATION_KLV_DEVICE_REVID_LEN)
 static size_t pf_descriptor_init(struct xe_device *xe, unsigned int vfid)
 {
 	struct xe_sriov_migration_data **desc = pf_pick_descriptor(xe, vfid);
 	struct xe_sriov_migration_data *data;
+	unsigned int len = 0;
+	u32 *klvs;
 	int ret;
 
 	data = xe_sriov_migration_data_alloc(xe);
@@ -401,11 +410,89 @@ static size_t pf_descriptor_init(struct xe_device *xe, unsigned int vfid)
 		return ret;
 	}
 
+	klvs = data->vaddr;
+	klvs[len++] = PREP_GUC_KLV_CONST(MIGRATION_KLV_DEVICE_DEVID_KEY,
+					 MIGRATION_KLV_DEVICE_DEVID_LEN);
+	klvs[len++] = xe->info.devid;
+	klvs[len++] = PREP_GUC_KLV_CONST(MIGRATION_KLV_DEVICE_REVID_KEY,
+					 MIGRATION_KLV_DEVICE_REVID_LEN);
+	klvs[len++] = xe->info.revid;
+
+	xe_assert(xe, len == MIGRATION_DESCRIPTOR_DWORDS);
+
 	*desc = data;
 
 	return 0;
 }
 
+/**
+ * xe_sriov_migration_data_process_descriptor() - Process migration data descriptor.
+ * @xe: the &xe_device
+ * @vfid: the VF identifier
+ * @data: the &struct xe_sriov_pf_migration_data containing the descriptor
+ *
+ * The descriptor uses the same KLV format as GuC, and contains metadata used for
+ * checking migration data compatibility.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int xe_sriov_migration_data_process_descriptor(struct xe_device *xe, unsigned int vfid,
+					       struct xe_sriov_migration_data *data)
+{
+	u32 num_dwords = data->size / sizeof(u32);
+	u32 *klvs = data->vaddr;
+
+	xe_assert(xe, data->type == XE_SRIOV_MIGRATION_DATA_TYPE_DESCRIPTOR);
+
+	if (data->size % sizeof(u32)) {
+		xe_sriov_warn(xe, "Aborting migration, descriptor not in KLV format (size=%llu)\n",
+			      data->size);
+		return -EINVAL;
+	}
+
+	while (num_dwords >= GUC_KLV_LEN_MIN) {
+		u32 key = FIELD_GET(GUC_KLV_0_KEY, klvs[0]);
+		u32 len = FIELD_GET(GUC_KLV_0_LEN, klvs[0]);
+
+		klvs += GUC_KLV_LEN_MIN;
+		num_dwords -= GUC_KLV_LEN_MIN;
+
+		if (len > num_dwords)
+			return -EINVAL;
+
+		switch (key) {
+		case MIGRATION_KLV_DEVICE_DEVID_KEY:
+			if (*klvs != xe->info.devid) {
+				xe_sriov_warn(xe,
+					      "Aborting migration, devid mismatch %#06x!=%#06x\n",
+					      *klvs, xe->info.devid);
+				return -ENODEV;
+			}
+			break;
+		case MIGRATION_KLV_DEVICE_REVID_KEY:
+			if (*klvs != xe->info.revid) {
+				xe_sriov_warn(xe,
+					      "Aborting migration, revid mismatch %#06x!=%#06x\n",
+					      *klvs, xe->info.revid);
+				return -ENODEV;
+			}
+			break;
+		default:
+			xe_sriov_dbg(xe,
+				     "Skipping unknown migration descriptor key %#06x (len=%#06x)\n",
+				     key, len);
+			print_hex_dump_bytes("desc: ", DUMP_PREFIX_OFFSET, klvs,
+					     min(SZ_64, len * sizeof(u32)));
+			break;
+		}
+
+		klvs += len;
+		num_dwords -= len;
+	}
+
+	return 0;
+}
+
 static void pf_pending_init(struct xe_device *xe, unsigned int vfid)
 {
 	struct xe_sriov_migration_data **data = pf_pick_pending(xe, vfid);
diff --git a/drivers/gpu/drm/xe/xe_sriov_migration_data.h b/drivers/gpu/drm/xe/xe_sriov_migration_data.h
index 7ec489c3f28d2..bb4ea5850e5c0 100644
--- a/drivers/gpu/drm/xe/xe_sriov_migration_data.h
+++ b/drivers/gpu/drm/xe/xe_sriov_migration_data.h
@@ -30,6 +30,8 @@ ssize_t xe_sriov_migration_data_read(struct xe_device *xe, unsigned int vfid,
 				     char __user *buf, size_t len);
 ssize_t xe_sriov_migration_data_write(struct xe_device *xe, unsigned int vfid,
 				      const char __user *buf, size_t len);
+int xe_sriov_migration_data_process_descriptor(struct xe_device *xe, unsigned int vfid,
+					       struct xe_sriov_migration_data *data);
 int xe_sriov_migration_data_save_init(struct xe_device *xe, unsigned int vfid);
 
 #endif
diff --git a/drivers/gpu/drm/xe/xe_sriov_pf_migration.c b/drivers/gpu/drm/xe/xe_sriov_pf_migration.c
index 8ea531d36f53b..f0a0c2b027a20 100644
--- a/drivers/gpu/drm/xe/xe_sriov_pf_migration.c
+++ b/drivers/gpu/drm/xe/xe_sriov_pf_migration.c
@@ -175,9 +175,15 @@ xe_sriov_pf_migration_save_consume(struct xe_device *xe, unsigned int vfid)
 static int pf_handle_descriptor(struct xe_device *xe, unsigned int vfid,
 				struct xe_sriov_migration_data *data)
 {
+	int ret;
+
 	if (data->tile != 0 || data->gt != 0)
 		return -EINVAL;
 
+	ret = xe_sriov_migration_data_process_descriptor(xe, vfid, data);
+	if (ret)
+		return ret;
+
 	xe_sriov_migration_data_free(data);
 
 	return 0;
-- 
2.50.1


