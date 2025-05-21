Return-Path: <kvm+bounces-47204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ABB7ABE883
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 02:23:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DE641BA724A
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 00:23:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B86127081C;
	Wed, 21 May 2025 00:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jlOLvMdc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5151D1804A;
	Wed, 21 May 2025 00:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747787000; cv=fail; b=pC3z0vTOruHlzTk5uVIm6Sl128P8rGR8eCnMc42YyfQ4/H4LdISnLjSJnflFtdxu5FIsCY1mKn0towFrGhkgX8qQWLDaix2JKny7GZg94PW+kMr70FkujetnDv0oopoFg5ohH8DSEjZoEdBc18xdebtZy26gAFbdn8dsidbl5f8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747787000; c=relaxed/simple;
	bh=O1fu0PnUcOXeFFJ9TcPMHWW7vlMPgR/fN2j1vYxtyeY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GZQ5tIRzbUZTB8wBBWg/8Bfq5bWpV93zdFGEzKgOKLD8AH4OGk5LaBT9e3uU9Acq5194x+46+8oVunCJKX79h3aYzVs+7mImF5fpNtL6JesUP3v+VerSsKxgQYfiGKK6Ly+TTJ15KfEJc+L+9JsVp4GyhgUsDPWXdK8e9EPAifQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jlOLvMdc; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747786999; x=1779322999;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=O1fu0PnUcOXeFFJ9TcPMHWW7vlMPgR/fN2j1vYxtyeY=;
  b=jlOLvMdcE7yDVKQv2mmzoJhxpQfG4z72bn1oWO6XAyclLcv0hMd0hlzW
   L1soxL6Yo/NgUsXEyPqdkwraJ1JlcfmkeObI87X4r+HobPHFTYVF9p4Ai
   fx6YEtFlFdrwpm8D84chgLgcep076g1Ufv7Rh9RS8MvtSGBgHhSjU8P6H
   NCKFMGCm0j1FFB9E7GoHMkpC96TToCMX/lPVPDqBSMH9dkiOC5fhqLf3d
   /d09PJ8SGDYH8ecC/SH1ufzhDatKpoUKHNdiDZD2ouqJUjT8GerSsmRcc
   r2/AbH7b3IV6h3l+cpdpx18pmd0EreuhD8tgf4qJ7pakYXE0fc5NAFrdE
   g==;
X-CSE-ConnectionGUID: DMNk3JCDTN6TcwLJCzI2wg==
X-CSE-MsgGUID: znXxUquERMSyW5wgFJrK9Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11439"; a="49806971"
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="49806971"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 17:23:18 -0700
X-CSE-ConnectionGUID: qQIUxFx+SbGxiJ1C1JXlvA==
X-CSE-MsgGUID: DPmHbUV+ThaaeN8JVOg2Ag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="139721367"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 17:23:18 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 20 May 2025 17:23:17 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 20 May 2025 17:23:17 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 20 May 2025 17:23:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=icc7pRz6GLmlVJK8WvC8ENq5RdJtKPmFitz3AMitOMwCChp8ZnG1dasVVMpodEwTyYbibmwx+eQedy6WbSl4/cGtcvU1NjZX/2RULNjJk56jdSDE7dyGODdVYG6Y3B9aa8W4f5QM1KtyQaxpNPCeTAMbQfsg1nHcESud6gh81ZPy0riT1EzmN5pWN/37GHZPSHao9IJQ+QIR1Ry3NI7CAlvhlO1ngFVxz0naYRI57le4C/Mo2WhfDp8Jg2RREfSTaJGbHcEsn/vPJMxf3X3reroWLm853G9Bf+xbeaED1mBch0uJLu/OKJyNHPRxOkDOTbLrhxT/1sx8ZCLSfAh8kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v9gb376SaHy7bIbwXaEBixSlFZLGBxPkWFO2h1GU/JE=;
 b=OMtWrwwLohln+LxrZmN72X9cxsMgN7i/flttdzs+JLnM42iy88ASNsQAC5WxzixP4yy89pC5cVLYSMdXzURJIEPSlQuR6vDv2C9/eKStBnzB0fbTC456n35Dn4puLd/NhDZKgcvDJsf9UP+3WKova5thiItiB5Zj4lNfJIp5og3gdlWIbUObBUw0rBmBese66J9n0dQUOhkhZ42TiGYBTU8osG91/UADC2IbbA5+oWhf8rltfu4h2ZQt0iKCvKTZs55G/PJkUmEWOZh8BTxaQEfSZGI42Dx7Y/U/SDru2QKRERsqzctVYjRW5qHXBSU2VPC9Bhu8inNhee05I4KGhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY5PR11MB6116.namprd11.prod.outlook.com (2603:10b6:930:2b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Wed, 21 May
 2025 00:23:14 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8746.030; Wed, 21 May 2025
 00:23:14 +0000
Date: Wed, 21 May 2025 08:22:57 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: Ingo Molnar <mingo@kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <tglx@linutronix.de>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
	<rick.p.edgecombe@intel.com>, <weijiang.yang@intel.com>,
	<john.allen@amd.com>, <bp@alien8.de>, <chang.seok.bae@intel.com>,
	<xin3.li@intel.com>, Aruna Ramakrishna <aruna.ramakrishna@oracle.com>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, Eric Biggers <ebiggers@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Kees Cook
	<kees@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, Mitchell Levy
	<levymitchell0@gmail.com>, Nikolay Borisov <nik.borisov@suse.com>, "Oleg
 Nesterov" <oleg@redhat.com>, Samuel Holland <samuel.holland@sifive.com>,
	"Sohil Mehta" <sohil.mehta@intel.com>, Stanislav Spassov
	<stanspas@amazon.de>, "Uros Bizjak" <ubizjak@gmail.com>, Vignesh
 Balasubramanian <vigbalas@amd.com>, "Zhao Liu" <zhao1.liu@intel.com>
Subject: Re: [PATCH v7 0/6] Introduce CET supervisor state support
Message-ID: <aC0c4U6tsVif+M4H@intel.com>
References: <20250512085735.564475-1-chao.gao@intel.com>
 <aCYLMY00dKbiIfsB@gmail.com>
 <ed3adddc-50a9-4538-9928-22dea0583e24@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ed3adddc-50a9-4538-9928-22dea0583e24@intel.com>
X-ClientProxiedBy: SG2PR01CA0142.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::22) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY5PR11MB6116:EE_
X-MS-Office365-Filtering-Correlation-Id: e3197bb3-4c00-4585-d8d2-08dd97fdacab
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?R/iW6G8jk7V16teINxmhNJsTVhxw3aHyomCCaT+vgiaGDFujEUsjrVjaSfbS?=
 =?us-ascii?Q?G91hidqabkF5ndjm4c03ljtG+1nVaHmoCI8PPvcKSXhmET37SxotBjDipdI7?=
 =?us-ascii?Q?2h6KpliIxRd9YHH80fFEMaGk+qKzUBCeLJWG/m2ZjMagoXVKD0jew9Fq3fs0?=
 =?us-ascii?Q?pounAJkryF0lFtOlopyAhWBwcaVKG9jUxiwBPouEyZ8vHHLHdGh1n0ykQBo4?=
 =?us-ascii?Q?3jDdMAg2eDwfGmwewn64fnJ1Ue/R+xKVWbvmGqweuM3b38767G+EJP0fSOET?=
 =?us-ascii?Q?tLx+vB9zUU8Z7W51FGHVgbl8OlpUkNBAP6zY0Q5U3NaHjU8Lv48MOGGaF63Q?=
 =?us-ascii?Q?LRds7/SKDLts9f3Zf87Gp52/ktSoyESUx+qNCBA2M3uhRSpBR8NsoS3JKcDh?=
 =?us-ascii?Q?PWJXCfgJb8IcZzg8ttbWrguxkClf49eXakeIWhjAF+exUibHXmdipq4l1bNm?=
 =?us-ascii?Q?cuzD2dmSrx9iEWxGjN1X9bcroBbHc6GaCV3nFYt61FVV5F1+ctRO8KOWABWy?=
 =?us-ascii?Q?j57xxtKTN+kwK9nYF/f0xe2VE0HoaRHF7PryXUdIHtM47jjNLz069gwT2yeu?=
 =?us-ascii?Q?XX7rEZq6NaKtzLNwRwoRT6Fuk54/IDOQyvBdnpeKh4dGr+tW2b/sWvZHOi87?=
 =?us-ascii?Q?DcXTPOvitcrg8bJ9BWnhcOpX2ChY8zhkuO15xTTFAj3uKZ96a7oBFWNm50Fy?=
 =?us-ascii?Q?R9ccw/U3Y++/R6HWcJFaWHgMP8FTSBCXs1vBLhpOFoLfqLaJAgaPHaU7CPln?=
 =?us-ascii?Q?QvdJbxxB0aKCZEcB3V2Pd9uklTqRnZ3rnuObWfdyw6pnD6Z8k9ibCauMNQBh?=
 =?us-ascii?Q?xPdQ0b5bHtu2M4RCqUvE84bjppEaToafBwbi8mSwUrHBa2hKgkvUMp6HtIVt?=
 =?us-ascii?Q?WONePdQxd5xpZFukszIJ6JwdLPTb96qONwnJsh0+YZT+2a2S+UUHm2ILhQa4?=
 =?us-ascii?Q?981FR9Ua00m/Fm0HjHAfa2dlerAjm7Z521PwodY6gFpn/LxaK5igkOhkZkTI?=
 =?us-ascii?Q?p861q6ss9AkOrbCOdu5OrSNSu1mIK4vk/wvuaTyy+px5HIODhKjb9lZCuT1h?=
 =?us-ascii?Q?DxxGetXr1VbkJPJoyUplWk48shhhT+dfqqS23dwfafhCiaQtfHRIHAwqZieV?=
 =?us-ascii?Q?OVuelqtz1onu7sMZIAenBpMSJDejnNUOtSRC6yRP8bdZ2YG+2LZoVELJsXYh?=
 =?us-ascii?Q?NXy4gVLUcuCHGvZr9eXrLRGnvzl4o/v7DrdT2zjK/y6vf9bzV2bNRYh8t2jH?=
 =?us-ascii?Q?vRqp/gPNrl7E/9G4+/++ruCg1RbpnFkF3d7SZQxRJ8MRGv8t2rY0FvYvCc4M?=
 =?us-ascii?Q?sMpAG8AmM2iutTgLX/k+6yWhTrSylIAPS2E9pcJRA8AL0+1NITslNKSHyTQQ?=
 =?us-ascii?Q?qk/clY6sZ4ZxvOS1k5l+4vAd+lYf+KwRocHxNEYiX45PMzIQBC948jjZkuza?=
 =?us-ascii?Q?pCmpItZiTcc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HxkD2GDTx4JjzKA8kkt9BBU0Kh/v2SwB/ZzqqWMjUPCA7kxSyJQJoa8k1Uik?=
 =?us-ascii?Q?w97YfetfVuqORfkPIt1bbMixt5JioZQHe0MW++cExyaHDN7NcGL0M/17q6q0?=
 =?us-ascii?Q?h3BM9eBpA0PVSLZIgFMEP+KxQt+2GuTeKjcnN8pUsZuW7+bgN1EURYx7xdcB?=
 =?us-ascii?Q?vBkt7Ocg+frTIAsKtoetveYPxMp37uWAlGr6vFNrzh7DEP5lc/qxQqC0/+ui?=
 =?us-ascii?Q?rodkA3aLNLgIDikeAzvUBWEfqykvCgtHO3q4wbp9zgtW31TQQnbe+Y0sA0PT?=
 =?us-ascii?Q?xNClFgp1zywhjrEhJJtGZVLJhzGi0gIoGcf9YzPjsP/gEGlIhHM6eSWMlch5?=
 =?us-ascii?Q?9DlU8iOB2Lnz2Wp5cPZ1t4Bk+D+aQIaw016A2Nc90g3KXw32ozgUEzdnOABf?=
 =?us-ascii?Q?9cmke6rE7Z2JoWmXb0s9jxIcar/3+z5T93jICxVM9LwWBQWV/4guv/MVtXhg?=
 =?us-ascii?Q?hd5nQd7WDGcc/0BD3HR3izm4NzDtKif4tZmyKw4hoW7YIK/VKZ46Vaq27YxK?=
 =?us-ascii?Q?VF7debOAhDvssH9Cx1oaAVkFPqMixWRU9hyagkCPycXy3hWYVb0Fe+dF9+NB?=
 =?us-ascii?Q?FJ+39mih5HsqSLY1VSAtvjB4yjCZPKhsKUNUtyd+A1Oto3zcKyd0CX+n0Ylp?=
 =?us-ascii?Q?qSIQs2CZ/YNBKKj/FItXHhOqvleS6griL+vtUJnTv3k+9dbYksrg+pfFs+D4?=
 =?us-ascii?Q?fvLUHYCJxMSqy1SOWifKSkNItgK2eE/CiZqEPZx7O2uxMeJtIVD8fWSw1++D?=
 =?us-ascii?Q?AX6nwEPraWis0UoWyp8C/ms5jDSlLBS0L60Zn1j7X/qrYgc7F5DvCBuEu6Ki?=
 =?us-ascii?Q?VFZh4sFgiYx4983IbKFSfIYuP8Io5oGlpG9ZhuoOdgNJer0b+HoeCqG8tXvU?=
 =?us-ascii?Q?lobo58BN1wSqukh4Z8UMuliEScyzNSJtib/TP21hbwkHWq4mLeGAMRdQDsgv?=
 =?us-ascii?Q?CQqoYbxnUF3sXewK4SJ324bUhwCYZySDN/BKlUstTFAcd8FSrwoYEOA2Be03?=
 =?us-ascii?Q?r+Db4B8tCzqe0369D4aovouWwm+8sqASzSRyJOFVgEyX50SCtqnaVAk5h8Mz?=
 =?us-ascii?Q?QNcsXX+heb7W2tT6tM40DFJwKJ6nKbmZDP7vxQbMOM24o/THyZ4SI0umTWpD?=
 =?us-ascii?Q?ApUJxoAhgFc0OEGytk2ZYa0ChMjKFviyJUhi+DjrWgmVYLADXsK+izzeY/0f?=
 =?us-ascii?Q?Ds+pDPt7xUv8ZC/k6AtNC9tgf+C4QWSC30zVfT3i/Z2utxLT7RfzEwnaXyyg?=
 =?us-ascii?Q?iQ8aM6KZll3aL5mcOl7M4eHWo2PLKfWPHKKrAl1Ooow3qZtLTtjm4sET6QVT?=
 =?us-ascii?Q?TwQPlG7mlcZvRVP7gfal4uA4PJaAAglc3YaWcWQofyrR3zG5xMNpVCSE2D5C?=
 =?us-ascii?Q?bKc0zGj2lqm40o+bKshrrcFIAdrZ/LCQrM5uGupQQuB/n+xbBhDexEGxnk+Q?=
 =?us-ascii?Q?fhiFLtAiAgc7fU8pIVi5gK6QcWhd7gUwkBoGhTuZ+3hD/uRI2gBmkmQ+Zo79?=
 =?us-ascii?Q?DLUku7BwPVzayUnVGQ94vsz49ieGtWRZ3SjVAGz9Kx1GXRZXzzPBpOZiBXQW?=
 =?us-ascii?Q?ASs2AO365iPCizcylhEt+w6AOipc1AEC3AOcsEQT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e3197bb3-4c00-4585-d8d2-08dd97fdacab
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 00:23:13.8801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gy9NktpsRqCuW421Ged8OnrDkMjOJyQkBh+1z7nMi4u1LUKnyYWrdbRzLj1uAvx6+pzuYoex6jEhS44BydHG+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6116
X-OriginatorOrg: intel.com

On Fri, May 16, 2025 at 08:20:54AM -0700, Dave Hansen wrote:
>On 5/15/25 08:41, Ingo Molnar wrote:
>> * Chao Gao <chao.gao@intel.com> wrote:
>>> I kindly request your consideration for merging this series. Most of 
>>> patches have received Reviewed-by/Acked-by tags.
>> I don't see anything objectionable in this series.
>> 
>> The upcoming v6.16 merge window is already quite crowded in terms of 
>> FPU changes, so I think at this point we are looking at a v6.17 merge, 
>> done shortly after v6.16-rc1 if everything goes well. Dave, what do you 
>> think?
>
>It's getting into shape, but it has a slight shortage of reviews. For
>now, it's an all-Intel patch even though I _thought_ AMD had this
>feature too. It's also purely for KVM and has some suggested-by's from
>Sean, but no KVM acks on it.
>
>Sean is not exactly the quiet type about things, but it always warms me
>heart to see an acked-by accompanying a suggested-by because it
>indicates that the suggestion was heard and implemented properly.

Hi Sean, John,

Based on Dave's feedback, could you please review this series and provide your
reviewed-by/acked-by if appropriate?

