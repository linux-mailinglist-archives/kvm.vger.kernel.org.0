Return-Path: <kvm+bounces-16820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52A6A8BDEC9
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 11:48:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08E9E281E68
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 09:48:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9113156F20;
	Tue,  7 May 2024 09:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U3E1o1Eo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40B1156C71;
	Tue,  7 May 2024 09:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715074861; cv=fail; b=LKuxKCldu033XOVPRWcTGGwN+ovUoIYbZtLCU69sEwWWazRkNKL2Al2la4I8dTZwiLtnRajsyBclDhkQh0etyeIw1N1z+6J4QnJpDuuHDVN06Z6tnPtQrn0TwyfWsXur91zx8itwwBbdbeAynDW8d2m45wCueC7kFnwCqLjtUJw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715074861; c=relaxed/simple;
	bh=xkYlDFL3/H4RyRJAKkFbOczHRyYHNFtZyQ8LA4TKPGI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nIZWvTECQIHdkuRj5h1ARgv1fGrcpwMV3J35NVbi2wZajT2yRvG40Ftb1uxkfcKj8uCtn1qInjd7XlQjybxhVN1u20EeAi5Xwi5/EIzQRnqcL+gLNK52X0yqT0phYEXE7JLr3Gpbz295l2/73dxgWyoezD1QOmjpKTE1/T88uHE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U3E1o1Eo; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715074860; x=1746610860;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=xkYlDFL3/H4RyRJAKkFbOczHRyYHNFtZyQ8LA4TKPGI=;
  b=U3E1o1EoveryXAhBNUWB7iRpOJOFJVgSZNA16rZdDGQ6CBzhtEpjJ+e3
   sV3CKBuAKLvUPQCbREKxqY8TOT+UJcVE6/04Y5+PJ2SB1Myi+1mZgMa3G
   mDGNJxcRkEfCh6dlN6T6w0L6wboT+zI9lD1q2TQllb7P5U99+dQf+WljW
   SwZrhTTgAYbMdJ6Zz18NLKbCfjoU1P964cVUXFE4o1eYdYhsGT4rzXaMp
   ks/jLo1vKylSMagfo9CNiMPOry7UAZtoNDZi88sXYZ3wNJMcvJopNAGK5
   bQ3M8/u02RlyVEdXLEI4YQy+mywzKT2AowaWiHTTRbgPPKnkVzl0hkQj9
   g==;
X-CSE-ConnectionGUID: Kbuq6CCQTfu9wLAufolOBA==
X-CSE-MsgGUID: 7JEKpLW0T8ub23I0WdTsqQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="11396799"
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="11396799"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 02:40:59 -0700
X-CSE-ConnectionGUID: vNS3HGSoQO2mJs3IV6a2Pw==
X-CSE-MsgGUID: LEPnDtUDQnK0dstOKcBrzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="51658922"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 May 2024 02:40:59 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 02:40:58 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 02:40:58 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 7 May 2024 02:40:58 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 7 May 2024 02:40:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fORmU6qHyKwUV59gnoB4PvRSpHf8pP1/saN5ATX40mlu6fOUv7oSxlW2l8f3Y827aG2Rn8kjPZOsMNuHKltkgunnkPkw4n3cktmHx8H7HcZyN2+2SES1HkbKyQKKoW5MeaL+bMobQE8MiKQsdahM/tx4sjfEIOA9dkrQsWl7FzXyK0vJz9aZvXMIGU/T4Oq9hVSrJ70cyGA4NVdHd7Mmo5ZTAp24cWL8/33MAkXz9FS06w51Jox00Cu0LgTFHKxXrAerh2pOa0dp75tsLyJUwDz3vIDb2EbwK/F4m8tM1Y5hm29w5RC1lT6ptwNYljVtvhrz3yBra+vEvP5x4rN93w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rJ5FtKxSsLa5odrF9YOb7h52xuhA4kxfEc8kcJAM5uU=;
 b=L25kFVZEzWwpeHz3hDPTlc/82hhY0bHZPN98ny+BRKPswJV0MrpFCCrc8gVARKsbej4LrTJFK9zi0JumGLXo55NG6/8KQuIxmkDuy2IYRPaJAy33pwxw69eH8PowmkUOyxgpa1EaqN4hYYEcAweWEag5MKGXDvOf8wC7ZAVurHxpuxZD88dLT/mnpCiEpwbPkriAP4EpLmfpBL743XV1oteRYU984TbREsS8VMa1j61hwurtxueA03ELNDUX5xBBa/1q0SZ5eu1lB4VVOX1tR2RUb98CN9vnDw+NCxFcYoUsjdZUxqQReDjyhzzOig5IcsF3EJkieahxaAA9oOO5hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA2PR11MB4796.namprd11.prod.outlook.com (2603:10b6:806:117::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Tue, 7 May
 2024 09:40:56 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 09:40:56 +0000
Date: Tue, 7 May 2024 17:40:12 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"joro@8bytes.org" <joro@8bytes.org>, "will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 3/5] x86/mm: Introduce and export interface
 arch_clean_nonsnoop_dma()
Message-ID: <Zjn2/E+Jmo7jYmDL@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062044.20399-1-yan.y.zhao@intel.com>
 <BN9PR11MB527617EAB9BE91A730AC25A28CE42@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527617EAB9BE91A730AC25A28CE42@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: SI2PR01CA0014.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA2PR11MB4796:EE_
X-MS-Office365-Filtering-Correlation-Id: db38ee78-7f70-4fc9-1d8a-08dc6e79cb7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|7416005|366007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7VN07LEV5ZZCNvBxrPaX/FpVV2TW2XL/4gSQfeOn3L7sapLiKuTyxV/X3aee?=
 =?us-ascii?Q?tsj9fov/IAvTIwPflfW27S8uf5arTb0eRqWzXkuA/vqhIbJPzbBF3EOok72o?=
 =?us-ascii?Q?8CcMJ+1wx6BC0ikXNZ7Y7Fc6kDT6EUupxdXEkvbUdumUAEiZxdV7sAu64Os0?=
 =?us-ascii?Q?vTbG4Ss5b79hx+6odWl5VkcyRjYV7Y0YQKTvoXNeTSddYVLUvs8H5QrtfRZW?=
 =?us-ascii?Q?xTKgF0777hZdz4alwKzjnQCWSUMBbBQLSVARwyTDCUrRlWCMQ8UUNQXuJM5R?=
 =?us-ascii?Q?N6XlpiUR4/GpG8/TuZqcxdEEwk32KJdIXHVAfArBpuBcUGLM68uedkLZZVRY?=
 =?us-ascii?Q?vndAredOMfpRZbTDqskh3myLr4XUL2sXAmjWodo0WJTmc5z1cIsFrEK6RJBE?=
 =?us-ascii?Q?JqgmVSS7Xr5z/P2eC+2PgS5VMTMPOM+EPJcbC+A3rvTQuv3g9683wb8umiKs?=
 =?us-ascii?Q?G3wHSepjXRy3a+IrTVpjdPCmUj+s2Wziv4uz1gu9mpd23rVeQ6+RcR/41guw?=
 =?us-ascii?Q?Yve5EHfBpVwm1RsDXCQqkS8A1RVFcL3ECWfMQaux2cN/i32Weq4X7LDeyKuw?=
 =?us-ascii?Q?whVhbX8ck8nNOrt76c8w5j58kO1y4gLkPf727gsqA2A/oKoZtXhW7L5h76TK?=
 =?us-ascii?Q?kPfmXHKpd23CCCDkXRP+PbcNBoNLwJ8940tqt8ypslrXQb7HzyaVNIddOWhq?=
 =?us-ascii?Q?jZ4blT5Cm019jGcL8MiMVfRbfyp+RGVGnpwMBN3+esIy6qEJFBTxuYiyfIZ6?=
 =?us-ascii?Q?GZrAUkVIwGFb2+VgKueXJ6DzN8Hw+cGLmMRmzq4HNhbeB0SgAgJMbYuxNI8x?=
 =?us-ascii?Q?nv5ti6LIomcXMCVkzAI9YGbdWVKIjbaKlYCzdDApccHtaSmWZUkrFtlROIGS?=
 =?us-ascii?Q?UD/xI240DmzWSyA4mV7kyKaHhmFvsjmoARFdc+EB/VPPlP0nmPUYH2cOL/xf?=
 =?us-ascii?Q?zSji2JtRkadz/pLXUWE7xKhucf9XVYWt6sl7yexEUy7Repg6Vva0JcriebPW?=
 =?us-ascii?Q?lMPi0gg/IRh7PEQjiCFoTtqNqM/w80DdfaCLZx4GePOvsx+TAk5pfryikgEQ?=
 =?us-ascii?Q?eM6D4OvTqv2A23dQHWcQsnFT6DK3s2IR1WGTxiEv72G0CMTA8irE4mSwEnZZ?=
 =?us-ascii?Q?0tMSXwE5y8IYzR+uQ89t4JZZJVu39s+bclyAUDbwMzGCEOCLT0BtND6pBDFb?=
 =?us-ascii?Q?oWjIj/eowdQZqegf8GEWB7L/tNggcpwZnsP0Q8tnpz6m38su33+/IdwhqSYv?=
 =?us-ascii?Q?DICWTtoheQoodGQKpXQd4VtoVvMJk4yScUE9CbjhPg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?erxQZhkZ0SbMlpRJYt8OSvek6ft1kJQsrmK/4ORv60XzXmTXyhx6XQaIlKPZ?=
 =?us-ascii?Q?MdUAiVjQNOX1M2cacKwMQLo2s4ZUYD3ypVg2yOLzPH/ssF7+vJBKl6BXgeKP?=
 =?us-ascii?Q?Z4cSrx9Ud15XszlpDwtwb2DTIydMGACSSudaxUegh+ChbumtIqlNVD5/n2/i?=
 =?us-ascii?Q?0nKrZpKUID0aVWdgCEV6/YTEqC9H9R3VEU9EJAokhj+LcsK0dU6OBNy8pi40?=
 =?us-ascii?Q?vEjqBatobRjNhBIbUdeOuIcOZmXJV3mkg2lRCkjpsLA1rTwrC3R8BzKBTz1i?=
 =?us-ascii?Q?jbeiJf/N3XhA395hbrMDYwTtKEz0xCdBG1CUC0PJKo125/dSWyMG2Blf2kiZ?=
 =?us-ascii?Q?xmSr3SnmtvOTUaGvUFPb+0sjRjD/wfnaUMW6sarERPO6b+F9NlrUtG0PxX1T?=
 =?us-ascii?Q?FOx2Gmukq5qJ8g3ETrTs2pc1yGAT4pl0Sh7HL3zPPLv//nq4JMcrBoXBflVg?=
 =?us-ascii?Q?ueL7G9kouEK5wKGE1jJINRZs1WYF+xfTSpA7AZVkjk+uhzP3yErp3mV0Uhny?=
 =?us-ascii?Q?Cj3yFJF8Ib44WASS7FwwJ0qOOAagv+pk25zkzrQbK/h2V90bhneOHBW1zU0W?=
 =?us-ascii?Q?5mTD34B/nRBa22QwWAALhXcHNCnoD9akiqpuOSUZfEqA3rPZx/8TPLOa3niW?=
 =?us-ascii?Q?D2sIsdXKmYYuE9n4K5j600J3PUIJQ1Iqe9oKIQrt1A0/E4mMR6zOQwKLtITj?=
 =?us-ascii?Q?Oy1oLcQLgPsK6raOK3wFh28C9zaciAtf7lrP+ajMaTIvSMcBz6Hnvs2rVkyX?=
 =?us-ascii?Q?Ask13hr2A2v9xYBejF/VBDP3EWF+k2ShtCy96xkWpC322XCze4mhHttxJqTw?=
 =?us-ascii?Q?W781dL16oTpP3DxfbbSzdtPKMkECu0RWW5ornj1e0RsplI6iNjGf8JkLu7xq?=
 =?us-ascii?Q?Dq2tI6NXcR/9R83LEZLwpcsCoVA2eNPHrVlFf8CWD2+UYmacCgLVGd7f78Jg?=
 =?us-ascii?Q?tbx5vYA+rwxN1wYQL0QqifBlsygCpMirYdBbVHSa2utvr1KWV8HpewAHxxsd?=
 =?us-ascii?Q?7aFtxWovOTGoyuYofC91Om8tbwLCwwEu1kE/2M8T0S+iNzKbeN0vvuHMrYgk?=
 =?us-ascii?Q?ki6caBqZXbMHSKE57o5TYeVuOT3UZtrtv7jKJUiux/MCx5hb1IfVI1god9X/?=
 =?us-ascii?Q?Z5Jp+lk2ST77edQQsFjGtMJNqDuang7aJBwvADd41xesKqJFcVPKF/+eq4be?=
 =?us-ascii?Q?x3a5vbK23vCzaPupsAn/oqnxlSrLTPYBZqcw70LfmBHUmg67c/LWc0u+U9fr?=
 =?us-ascii?Q?0IiXzeSxs49BqvfwZy8/0ZWtppj7Jz6yUbGe7xBDIqGYIE8D+R35eqNEyqwW?=
 =?us-ascii?Q?wHAvaVmvstsCMBMxt0Y/AWJsULZr2JBKUD9Jr3z6NETVoAqjZ10a5rrxggsv?=
 =?us-ascii?Q?8LsGPuPlJ02RJS3CTL3SiaTNjIMSfqwioupigbjhb+mouBedLiPGUOZR0Ro2?=
 =?us-ascii?Q?OLCEgXIsMS5VRynM8Pvls/qv5RcrQr+MIgqgRg+di/umNTmLwj85iVBqteFm?=
 =?us-ascii?Q?iaTGV20Ja8JnI/BhojAvFpAAsWSmusn24LFXSJB2bXRbJZ78kKMblRE6e5tb?=
 =?us-ascii?Q?nt7H6Kb3j+onp/NbqsouOJyc430Rh/+nYSI6Y7eO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: db38ee78-7f70-4fc9-1d8a-08dc6e79cb7f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2024 09:40:56.4909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9FAK6fPgvXCP4aBTl7PqPwcdL0PIBI5xUnlDE6C7c1ijwQM/6B5oUmv5ZkchHeNUSYJ2Jem0WEHnQ5BERttglw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4796
X-OriginatorOrg: intel.com

On Tue, May 07, 2024 at 04:51:31PM +0800, Tian, Kevin wrote:
> > From: Zhao, Yan Y <yan.y.zhao@intel.com>
> > Sent: Tuesday, May 7, 2024 2:21 PM
> > 
> > +
> > +/*
> > + * Flush a reserved page or !pfn_valid() PFN.
> > + * Flush is not performed if the PFN is accessed in uncacheable type. i.e.
> > + * - PAT type is UC/UC-/WC when PAT is enabled
> > + * - MTRR type is UC/WC/WT/WP when PAT is not enabled.
> > + *   (no need to do CLFLUSH though WT/WP is cacheable).
> > + */
> 
> As long as a page is cacheable (being WB/WT/WP) the malicious
> guest can always use non-coherent DMA to make cache/memory
> inconsistent, hence clflush is still required after unmapping such
> page from the IOMMU page table to avoid leaking the inconsistency
> state back to the host.
You are right.
I should only check MTRR type is UC or WC, as below.

static void clflush_reserved_or_invalid_pfn(unsigned long pfn)                  
{                                                                               
       const int size = boot_cpu_data.x86_clflush_size;                         
       unsigned int i;                                                          
       void *va;                                                                
                                                                                
       if (!pat_enabled()) {                                                    
               u64 start = PFN_PHYS(pfn), end = start + PAGE_SIZE;              
               u8 mtrr_type, uniform;                                           
                                                                                
               mtrr_type = mtrr_type_lookup(start, end, &uniform);              
               if ((mtrr_type == MTRR_TYPE_UNCACHABLE) ||( mtrry_type == MTRR_TYPE_WRCOMB))                               
                       return;                                                  
       } else if (pat_pfn_immune_to_uc_mtrr(pfn)) {                             
               return;                                                          
       }                                                                        
       ...                                                                           
} 

Also for the pat_enabled() case where pat_pfn_immune_to_uc_mtrr() is called,
maybe pat_x_mtrr_type() cannot be called in patch 1 for untracked PAT range,
because pat_x_mtrr_type() will return UC- if MTRR type is WT/WP, which will cause
pat_pfn_immune_to_uc_mtrr() to return true and CLFLUSH would be skipped.


static unsigned long pat_x_mtrr_type(u64 start, u64 end,
                                     enum page_cache_mode req_type)
{
        /*
         * Look for MTRR hint to get the effective type in case where PAT
         * request is for WB.
         */
        if (req_type == _PAGE_CACHE_MODE_WB) {
                u8 mtrr_type, uniform;

                mtrr_type = mtrr_type_lookup(start, end, &uniform);
                if (mtrr_type != MTRR_TYPE_WRBACK)
                        return _PAGE_CACHE_MODE_UC_MINUS;

                return _PAGE_CACHE_MODE_WB;
        }

        return req_type;
}

> 
> > +
> > +/**
> > + * arch_clean_nonsnoop_dma - flush a cache range for non-coherent DMAs
> > + *                           (DMAs that lack CPU cache snooping).
> > + * @phys_addr:	physical address start
> > + * @length:	number of bytes to flush
> > + */
> > +void arch_clean_nonsnoop_dma(phys_addr_t phys_addr, size_t length)
> > +{
> > +	unsigned long nrpages, pfn;
> > +	unsigned long i;
> > +
> > +	pfn = PHYS_PFN(phys_addr);
> > +	nrpages = PAGE_ALIGN((phys_addr & ~PAGE_MASK) + length) >>
> > PAGE_SHIFT;
> > +
> > +	for (i = 0; i < nrpages; i++, pfn++)
> > +		clflush_pfn(pfn);
> > +}
> > +EXPORT_SYMBOL_GPL(arch_clean_nonsnoop_dma);
> 
> this is not a good name. The code has nothing to do with nonsnoop
> dma aspect. It's just a general helper accepting a physical pfn to flush
> CPU cache, with nonsnoop dma as one potential caller usage.
> 
> It's clearer to be arch_flush_cache_phys().
> 
> and probably drm_clflush_pages() can be converted to use this
> helper too.
Yes. I agree, though arch_clean_nonsnoop_dma() might have its merit if its
implementation in other platforms would do some nonsnoop_dma specific
implementations.




