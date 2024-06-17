Return-Path: <kvm+bounces-19768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 792C590AADE
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 12:16:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C7932839DB
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 10:16:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D65ED19409A;
	Mon, 17 Jun 2024 10:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="am1ggSSK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381AD1BDCD;
	Mon, 17 Jun 2024 10:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718619387; cv=fail; b=h5xF6GPTXHgdYl3w3aGY/VX682rNko3XXS1vr/K9XTrXF0eZD8uAavuZCrmIsRZsbM0zABKSMWuSqhaSoq6+qXhbvpDuZewzFUva2B7cjKdjEgOfH/ntrHC36yH/cWKMl7ewlEmrQAhZZi2gLHq9IbfUwFeqcoJoBnlitSuSMCg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718619387; c=relaxed/simple;
	bh=X4PTUSP0EDAvH4kmM/7/Q1Z5FRa0bytZNIW/onxL/6Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Xr43F5PMWfySizY47Lnc9jA4OfwCEWAK+0NxL8ioCI+xvj38lxc+BcicSPim1iWz6gbFT7qwPiQNVLRG2E+rU1g/Nk4QfiNu5ykdAQri6CVJVtHlaqZ4AI3trcgKjfuCGz0d73pPyzBlDsM23DzOSWBitV1y8rlSSdeCoiNJmQg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=am1ggSSK; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718619386; x=1750155386;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=X4PTUSP0EDAvH4kmM/7/Q1Z5FRa0bytZNIW/onxL/6Y=;
  b=am1ggSSKJIxoGdgKo2CAIYw1cmmm+5tzOB2XSXPyOOZ5jR9fbYMx0yiU
   Kmc8480MCV3AzC7b/IRKCx2UvCxDK8HiJNeG2mbH8248xJZpYk49Oxho/
   iV8diNFp9PBuvXBq/hn1+GKJ2Ju6zgp86HLXc54T3vkB6N+ZcKNRI1fq8
   fOAX9yTk7OUbXNzQYZtFzSsbAw98Ug7j3TM6TyYXeu4h3wKFKTFfXkYgk
   x7nQHL4TM7yLVqFf0Qfla5zVVRn2Dy8+vZBc3P0IZuCVSqtYOn/Sivj43
   Jxu74MAdWPk1X9CeNe3soMH0bnQ9mknwUAFZZ27ZnXYvDj/oQjZTLlrqy
   g==;
X-CSE-ConnectionGUID: X/zBdseGTiOqGi3sJm0zmg==
X-CSE-MsgGUID: U4BvUHgwSfqX9eycmgLKgw==
X-IronPort-AV: E=McAfee;i="6700,10204,11105"; a="32909023"
X-IronPort-AV: E=Sophos;i="6.08,244,1712646000"; 
   d="scan'208";a="32909023"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 03:16:25 -0700
X-CSE-ConnectionGUID: rtaKra2CTROR1BVlnVbeMA==
X-CSE-MsgGUID: LqZ+Pa0QTBixTUEl7r4LUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,244,1712646000"; 
   d="scan'208";a="72354770"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Jun 2024 03:16:24 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 17 Jun 2024 03:16:24 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 17 Jun 2024 03:16:23 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 17 Jun 2024 03:16:23 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 17 Jun 2024 03:16:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZRgC9ljDEFV1jkC0oFN99XCwvODkymge5/8/1zznM9nPRylXrR6QnT/Pgxv29hJia6Z6LgQ2kV3vhFAy4ZR0FcHTkGl2fRIcZz0OQtup5uh7+hYOJp/m1LgKLzF3ZtUYrZCypy/ogOahi+GGqRFE7R/lJ9fHz/kHXhnn63iE/I3v6ItJCAKDXEtM+LKvqpTIJO6rJPFW8dHiZXPsczX2sK8thFeoClceSI7bttAycpLBJfjSUiCR+R16Phumjm3foIFKdH9Qh3n3MKqluMX/emduY4qr6YwMsJ0cCm6r50DcIO10CuYC94mf5+3zrVcsJ1ZixrAr2UcM1a1kjlhjBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1NY/g8wXIuwHlE7sZgm3J1oORroGjEpJX3YNR0kHRTc=;
 b=HrEq7aSMatojqKO9e6tyKgPSoEnZuTRKsbWyuno9Kd3hOoCIomisYKmSDpGMDaRziTMhe5CSCsmIrRoVwthRHSwzA4uP7/DWyzlzmgTyz/Sf4V6NWpRZLwe+tPD9+ByJWNysbpEpcTXweIUnqn6o4pLvczAVYOwdmE5ODmoceCD1rbzY5KyjCgfPn2mPPL2mRET5KZinoHMCwDa41roN3yB7GbmoQUkXnPuTTTVQzDPecUPKfPW/Bd0co3tT+x2hncebOXDDC+XiB1MEreUzQkFSyTN8g34iQfsX40QNaxgOOImVCyvkCuFdYG3pNaEdd60wxOKA/9Gne19RsnW/0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BY1PR11MB8007.namprd11.prod.outlook.com (2603:10b6:a03:525::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Mon, 17 Jun
 2024 10:16:21 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7677.030; Mon, 17 Jun 2024
 10:16:20 +0000
Date: Mon, 17 Jun 2024 18:15:14 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"sagis@google.com" <sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "dmatlack@google.com" <dmatlack@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>
Subject: Re: [PATCH 0/5] Introduce a quirk to control memslot zap behavior
Message-ID: <ZnAMsuQsR97mMb4a@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240613060708.11761-1-yan.y.zhao@intel.com>
 <aa43556ea7b98000dc7bc4495e6fe2b61cf59c21.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aa43556ea7b98000dc7bc4495e6fe2b61cf59c21.camel@intel.com>
X-ClientProxiedBy: SGXP274CA0010.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::22)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BY1PR11MB8007:EE_
X-MS-Office365-Filtering-Correlation-Id: c760342a-5e72-4c09-a30a-08dc8eb68897
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|376011|1800799021;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?1Nxv/5Kd0ReDH1S6HnJ1pAo5u4T3me3omYVguJJTiP5q+GG21d8jpXx2Bt?=
 =?iso-8859-1?Q?K5VBlIZouGN5MDBBMnIO1rRzg1hRB34nfWV3ZZC1vLM50a+BzzVux7pu1H?=
 =?iso-8859-1?Q?SicOIgJ6xf/S4VBWs5wp3E0QDtcxNprMd8lVA3EpgG0NrVzP8lUlnCDcCg?=
 =?iso-8859-1?Q?IckaUtY00T4O1YA2ov75EuD2ZNYfPFK2frIM8JtFyqJEbpBAIRhcy2DXyk?=
 =?iso-8859-1?Q?+j0ivQj1v39M5AWEcyhntPT9D9DfYg5KGlgdlKPkUJ+/NbXNkKn/CdDDlT?=
 =?iso-8859-1?Q?UefSvOl12E5siRXe4MTASJpbEJk3HZuXhyfa4uYIpuQig/H8OyAUmuPZF3?=
 =?iso-8859-1?Q?iFdrgqPZEiQzm7IvMSq8gyqsNyPxVH+JZCB6zT9k602dh+mkTz9RGfpDCi?=
 =?iso-8859-1?Q?GEJ+AbFIEo/npZz5+Gn+C47klF5DRoqmTHI68fdj0ZbbqRuJDh3ZgJRmDP?=
 =?iso-8859-1?Q?1LIcZdKJTyUTiTO4Bx4prby8+unZmzWDxCFB5ICD+EinAxoJtuKFYxkE18?=
 =?iso-8859-1?Q?b3IQvwTqDGVvF54rCFjozndYFou3qq+0E676TgCEsj0j19N7DmZoSoVAFF?=
 =?iso-8859-1?Q?BRi0HHBu+9V7pA/CbS7y2vMzW1NPohP11S9yUcQc42EMTawPJ6/WL/y2Bi?=
 =?iso-8859-1?Q?y72278uDnds4+13q0PXr2z4BHwBSqKJn9AEEiLmO8R/swZdP26ijYPVNfj?=
 =?iso-8859-1?Q?1NyuLR/hMQBlGrNfx6RDoGwTogOiz8Ak/lmnJ1/J6YZHBq2NmN7wxStpLq?=
 =?iso-8859-1?Q?X1wRwPUcDscHFC9KGwVu/bVD5byzFX4bkEJrafA02CT3CGKBNcTrvrvUCy?=
 =?iso-8859-1?Q?LWlAcETs0ILBzktR2DBEiPayKEAeQ+m5gzBfld4h7c05km+Th26vCdzjYA?=
 =?iso-8859-1?Q?60WS+9DdfihnUMvZxwzb1AS4I0hd3X49fh9MecPnE8UBCDPdJB7naYhKbO?=
 =?iso-8859-1?Q?uIlLFujqowGEXk7y3K8M5rSwQoi9hW2qur85pCGBld7nlEQkw/oJSqB6cN?=
 =?iso-8859-1?Q?6XbWbiwOt5l0+kbvawrlAn4yAheKMuDHTD3vTxuISk04EuPMcjqhRX5xJP?=
 =?iso-8859-1?Q?eumCJN4aZitTEWj1cpMaaiwTcpv92YKYJLHMboJZz4B/ABwfXGNrZbyhd7?=
 =?iso-8859-1?Q?OmMQxM7ok/bevrDB9LQ85rNqbFPr5jJh7zRYr0qD0gHYNzuWn8ZChrP1Ic?=
 =?iso-8859-1?Q?XI6LAusRul6uUFpOkR4CYQlLWXvvuSlcKPiAzTHQXJEOue0QDm08ZBmUt+?=
 =?iso-8859-1?Q?XhSMYP071o2m6OEuAGs3M7mZ1euHmPjN69y/eFbDwhQ1hb1nmQRtfdmZJq?=
 =?iso-8859-1?Q?AmukGkQwH9hYAhyhpgQRDbeABGGI4HYbjXB2OKdKuFWBQv47q9XkBY39+O?=
 =?iso-8859-1?Q?JNwsjrtXvT?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?7avG1Hi0GeWYn8f/Yrud2Hq/HPqsz+oOS9cjnrJ/OLXbzFuLoxeajeIt/7?=
 =?iso-8859-1?Q?3U8WmwvQd0d4DQg7OvyHYkUW/eItAee+nOr8efU+y4+ihMu8HnRQwt1KaY?=
 =?iso-8859-1?Q?Su81pR1wmK/Kp2zXJ71wd7jEaG9ykR3mjaDX7UD+iEolP1o6f4oJX7TMfQ?=
 =?iso-8859-1?Q?gX8XHzW9fan2TO3NMDWe8OBY7E8Qm3+8nVbdMT35MzX201VbWXNQmlNEsA?=
 =?iso-8859-1?Q?bIVhslMQx/2ztDJ3wPU62eY5uhcgE6G5eFGxXdKFTjsnxfZ18oECibP4t4?=
 =?iso-8859-1?Q?tDi5FvIc+VcuRchzjCDHwK29mcDFJ1UeO5pxVaHAuO4tOfV50B9kiBr/b/?=
 =?iso-8859-1?Q?X++dO8zF46elEGmMjSRzJ9ZK5y32Yf9EPnQkS2lsuL7zeWZwdS6Cx1TkR2?=
 =?iso-8859-1?Q?wmfEY1yUI2MRgc8lUMI4EFLkKt7bshZRhXPvY2uJ7ORJjyibCTDTqbEMhN?=
 =?iso-8859-1?Q?RjIGQhXaAxIMoJucuRN3JVw3hcCN7Cri3uXg6AwLnMhX7R/R1Baspu4u+w?=
 =?iso-8859-1?Q?V9DUm3E/2y3alvwvWNKxCbjxu32h1GfqlCGtCk9HjhxgQ4b+4uIwfyqsu2?=
 =?iso-8859-1?Q?oF0KBb3bayKt182f5lbrbvCLKGBpz+M1WRwVZUOHZOMl8qaE50leO8PWvL?=
 =?iso-8859-1?Q?cZwGRoQwMOvrZDxJgL0wCc1NGTt7BmIVHtj5Ig28Z8qIPsLMOA84c37psU?=
 =?iso-8859-1?Q?Dh/8FNbQHixXWNsZtqD3t1Aweq1wW2f8tgKi9qnk1pwo88EMNdWSbBBe1G?=
 =?iso-8859-1?Q?UqdUHSzVLTaloQSRSFgyFiHC20iovKUj1ycAr8rmwqF6Jab2XhE+vGzTNH?=
 =?iso-8859-1?Q?7vl8NkY2WAKm0zfzfbaXjtAIqIKGoo8A/T6btKb3vg/KVe3GHK8WEeYQwO?=
 =?iso-8859-1?Q?hO50dDOJi7dcDHv2oKCvPjQeItdO5oLWOh4bJQhHIh1pAi3CVRe1fTYoQX?=
 =?iso-8859-1?Q?6KaqxMvZGr2YY2pi41Vl8iuaSEbmqove8xq5YOnBsNkTzx0uMmmPPLGr4V?=
 =?iso-8859-1?Q?bBSdDD9UumMp6ACRsERSV10l7b6ST3JvedSdoiVgokC6ikaaMQjJCtH3j0?=
 =?iso-8859-1?Q?5R1GmfYukxL8sTag1qve3LVZfhFOt93r0jzaW47HL3O38vcQAj0N94NilQ?=
 =?iso-8859-1?Q?ee+2uuKoRTV0/LV9WmmyAqIMDY/eXIB2UyiRRtVXVbj/MMV9U05oTYLUYG?=
 =?iso-8859-1?Q?hcSMf+zTz25lim0ydIHtEeA4kRzZKaHm0phB7O8auc1XmxfvzG6fuysd/0?=
 =?iso-8859-1?Q?AGhmslgx3Pod3Kqh0b9AKd8vi0AoJTEltT7yNUO9x7XTdrLsMfdEqh+TdZ?=
 =?iso-8859-1?Q?bn51X7dXOfk851iOBf4YsgBy6/FoF6KQUtFhY1GMev3WRWv2IUL15vQK5X?=
 =?iso-8859-1?Q?49iHF78DE+CHE3QeSxdMymQd6zW+oFp479OVDtXJGoN4u285YzabmLmeSk?=
 =?iso-8859-1?Q?sZAF3v+LaoyqcEbfabwJqrNRJ0bRCs3b+3tndEGlrHCaaKQ4C3x/Hszozo?=
 =?iso-8859-1?Q?Rr1h4Q1dfsBUD/qvSjwUcYgjNvqJxc8IJMZiUay4Om/idDAcgB4jEm21wi?=
 =?iso-8859-1?Q?deGZ3tfzMnMrMfgdjqZN7qF2B1UY3xZDXaZ5prMFHJtAXJHG3UgSDtxm/7?=
 =?iso-8859-1?Q?wQ0fe9Lf4D6XBsehn4sdHSJ7RUUrEXDyIq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c760342a-5e72-4c09-a30a-08dc8eb68897
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2024 10:16:20.8367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dESCFz1x4ZEortxT3kARH2fkXHIAhHMH9pV6E11DNXfifhbfsQnjMy/Reu+sv5QuIIqi+poJGprdsUXSgmHIZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8007
X-OriginatorOrg: intel.com

On Fri, Jun 14, 2024 at 04:01:07AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2024-06-13 at 14:06 +0800, Yan Zhao wrote:
> >       a) Add a condition for TDX VM type in kvm_arch_flush_shadow_memslot()
> >          besides the testing of kvm_check_has_quirk(). It is similar to
> >          "all new VM types have the quirk disabled". e.g.
> > 
> >          static inline bool kvm_memslot_flush_zap_all(struct kvm
> > *kvm)                    
> >         
> > {                                                                             
> >    
> >               return kvm->arch.vm_type != KVM_X86_TDX_VM
> > &&                               
> >                      kvm_check_has_quirk(kvm,
> > KVM_X86_QUIRK_SLOT_ZAP_ALL);                
> >          }
> >          
> >       b) Init the disabled_quirks based on VM type in kernel, extend
> >          disabled_quirk querying/setting interface to enforce the quirk to
> >          be disabled for TDX.
> 
> I'd prefer to go with option (a) here. Because we don't have any behavior
> defined yet for KVM_X86_TDX_VM, we don't really need to "disable a quirk" of it.
> 
> Instead we could just define KVM_X86_QUIRK_SLOT_ZAP_ALL to be about the behavior
> of the existing vm_types. It would be a few lines of documentation to save
> implementing and maintaining a whole interface with special logic for TDX. So to
> me it doesn't seem worth it, unless there is some other user for a new more
> complex quirk interface.
What about introducing a forced disabled_quirk field?

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8152b5259435..32859952fa75 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1425,6 +1425,7 @@ struct kvm_arch {
        u32 bsp_vcpu_id;

        u64 disabled_quirks;
+       u64 force_disabled_quirks;

        enum kvm_irqchip_mode irqchip_mode;
        u8 nr_reserved_ioapic_pins;
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e4bb1db45476..629a95cbe568 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -565,6 +565,7 @@ int tdx_vm_init(struct kvm *kvm)
 {
        kvm->arch.has_private_mem = true;

+       kvm->arch.force_disabled_quirks |= KVM_X86_QUIRK_SLOT_ZAP_ALL;
        /*
         * Because guest TD is protected, VMM can't parse the instruction in TD.
         * Instead, guest uses MMIO hypercall.  For unmodified device driver,
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 229497fd3266..53ef06a06517 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -291,7 +291,8 @@ static inline void kvm_register_write(struct kvm_vcpu *vcpu,

 static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
 {
-       return !(kvm->arch.disabled_quirks & quirk);
+       return !(kvm->arch.disabled_quirks & quirk) &&
+              !(kvm->arch.force_disabled_quirks & quirk);
 }


