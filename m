Return-Path: <kvm+bounces-16132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D0C8B8B4F81
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 04:47:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D4991B212E8
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 02:47:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67C098C1D;
	Mon, 29 Apr 2024 02:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jac99/VI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A82E748E;
	Mon, 29 Apr 2024 02:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714358817; cv=fail; b=Cc+gSMrNlZmb9su1+nMOEFeWlG+v/zR1HTw8CmMghJ5aUCKnPhyqWjbQ6vU/ooL51n1PPe8f36CQnE8b+IJLcHUAoI29K7Av5kyE/+a6yGASkBfx4u6lGQdEN26i3NcQgSw6sk6orJVP97SUjdIjt9JAIZeGu7/E5qTEMpJbWXw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714358817; c=relaxed/simple;
	bh=WK9AMlIC/BlsSPk0xZ9CDS+f6XIYMAmdCK4hSGjK04Q=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UhUX54W7Cql8iWgnrVtgnz14qpViF1Fh5Q654Xz4qmtTdQL2zCXGKapyPNLKjxC+apeRf8gZ5fJEirVnOoo7R3P1T+HryaxNfYBv66nzIYQMzeSAHONIECd2k6Ky3NbkM75ziWmX9Wz927mz1Q0xDBiHUMJw42ikeMBldvQkUKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jac99/VI; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714358816; x=1745894816;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WK9AMlIC/BlsSPk0xZ9CDS+f6XIYMAmdCK4hSGjK04Q=;
  b=Jac99/VIDUsSpi76GeQ5LRJikffJ4CyJCWSxFDhCPthMSjjd6TmqN9Hb
   VxDXWSfqCUwero+Yz4GZG4nFB6t2R8dnlHSAItgC6xFHPtF5RQg4u4XSF
   7PfcxYGQd/ATLr+PtOmCvmp2G1qyMxiaGNDrEBZAd34kpcM03rtTm7dlo
   GgEwcvk0L2Zx2dMUhLr5WJWlctFiNUBdDGf4zegza10ThFdf/aGbnpmTV
   cJ7iWxZzJTjPYtCu3XtVOOcRolg/6p2l+2Xxf0teWUxIHWcHBS0gQ3j5P
   DXrU//i5sKWRv9idkRSlk6TRaWti+FlN8Nc6uYM4rTuQCpneyOWjx4nRw
   Q==;
X-CSE-ConnectionGUID: 70d5Ir44S1Coj/eci3WuZw==
X-CSE-MsgGUID: ydZ7R7QRSN+dCZLkZmVIIQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11057"; a="10119337"
X-IronPort-AV: E=Sophos;i="6.07,238,1708416000"; 
   d="scan'208";a="10119337"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2024 19:45:41 -0700
X-CSE-ConnectionGUID: cQDMjZKvTESfnCv68UuTuQ==
X-CSE-MsgGUID: lMQz/eehRLqlWYwmIGT2qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,238,1708416000"; 
   d="scan'208";a="30445125"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Apr 2024 19:45:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 28 Apr 2024 19:45:40 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 28 Apr 2024 19:45:40 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 28 Apr 2024 19:45:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IvxgVSKzUH2MSiQobQRWXhQCZLt+jgq6nTSGz1RobBKDLC7Ydh9m31oGLKxuihKiQhuOpEnM8q4n8VcLYI6NQhmS7qFvPAfaHZD/xF4vaEwLgpWLyn6IloRfFT3yfFbfXeo2sl1m2L0vb3PnMjg+AEOY63oVq7OQ3uybDJyqTdU1aOjzicu4W5IJFU+RtdpDl9Q/Hj1+bHCX2/HxHd+oOIvATmWdn1Dl2xoGGe89q2d0+eLQ+6fzGdBmzXNhS22rE6hML1wntEZ8K4Wd6vCszZ4N34/vkiMht+9x99aCvPIUjHOFSNuhDDaAwUGUVY93K98R3tFV8OESdhyvVlJmzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k3BXtgHKolQ0mixqKq+EyzL1oq5zt87McrMCAkT7Jtc=;
 b=Fh58ZO9UBhsA0K6QwvlMf5gqLLuf8TwrmRb2bSrSZQc/NTEVlpPCEu0OQctuDtUak2U2F5hoScTJZ5bACaXIe4sXsh7Xwa85iHA0bOW1dFENobgMxOSgiyn9rl30k5uhKtRxjtFjhLnSXuf0YUO6fKUESYHB1FQaiY3SISdgKKIa4Z5Dr6iYljkmpjiOd5RAaTn8KXeXc79NQEW1KrvC4Nd2N8P/pcwIZWjU/qS9PFSk93m9n0YA1hPTfR/eKXssGmq4MA39TY7N3bGxvajWnJmuM22xxf+Rg0omh2c6GZ/YDwEbPGWY8rJZ5KIJBYOszJNBl4zxne1InO8OKmKAnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB8250.namprd11.prod.outlook.com (2603:10b6:510:1a8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.32; Mon, 29 Apr
 2024 02:45:34 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7519.031; Mon, 29 Apr 2024
 02:45:34 +0000
Message-ID: <514f75b3-a2c5-4e8f-a98a-1ec54acb10bc@intel.com>
Date: Mon, 29 Apr 2024 14:45:25 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] KVM: x86: Fix supported VM_TYPES caps
To: Sean Christopherson <seanjc@google.com>
CC: Xiaoyao Li <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240423165328.2853870-1-seanjc@google.com>
 <4a66f882-12bf-4a07-a80a-a1600e89a103@intel.com>
 <ZippEkpjrEsGh5mj@google.com>
 <7f3001de041334b5c196b5436680473786a21816.camel@intel.com>
 <ZivMkK5PJbCQXnw2@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZivMkK5PJbCQXnw2@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0319.namprd04.prod.outlook.com
 (2603:10b6:303:82::24) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH7PR11MB8250:EE_
X-MS-Office365-Filtering-Correlation-Id: 03572aac-8a78-4f42-6b7d-08dc67f6718a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZEFzQlRpYnMyQTcxdWJYclRzLzhodDVLWVpzUlZWYWF1cUFmb3J0RnkzTk9D?=
 =?utf-8?B?d0Zab0hpYS84MHlrcExGRGFUam1LaDEzOG1KcEI5N0RqRHl3QlJJRDBJcnF3?=
 =?utf-8?B?TlZhc0NJYUVGUThCSm1TRVR6NU5WeGt2cUQ4QXFwOTE4QkFRTkdjTVlNRi8v?=
 =?utf-8?B?cEsvRkZRRG9mTjRtRUVGUmRNdVZMTGRYWHhXaVBIc2xLNzNyR2RjVy9KYU5a?=
 =?utf-8?B?c1dKaVFHV3c0d3FIaUp4RkhHWTBWU3lGdmlSb3Y5cTF0cVhjRkhrMGkvb2xn?=
 =?utf-8?B?anlFd3lJZTJ5anpJSjJsYTExdEJXQXJPZE0xU3Q2V2lxUGdOWnovbjd1RG1E?=
 =?utf-8?B?cm5ZTFJ0NTJOeFl5VUVHZDdHUVpheXlOSS9PazJWZnR1dDM2OTFCS1N3a2tP?=
 =?utf-8?B?dHR2LytCNHFvQ2dRTWFUMmg4bFcweW05bDNRUWF1b1F6R2VQMWs0NE9GdG50?=
 =?utf-8?B?Rk80azMxRUJUeDlDeGNLMDlOM0wrK0tvRDNIcEFoM1BjMUg3TWZkK25VNi8z?=
 =?utf-8?B?Tit4WUgvSEJPOE5HbnQ5ZlV2dFZUU0QybjErb0dPVmhTZ2JkM2tmV1gybGJU?=
 =?utf-8?B?R0pXTWpzY2d5ZDk4WnoxYUhTMFhBcW92VVU3YmVIS0FZS3FPQVNWRnlDM2JK?=
 =?utf-8?B?ZkdTZEpuK0E5NUo0eHJBL0p0aFhRTFVvbWR3T1puRE5sYjFqdXdBdlk0UExn?=
 =?utf-8?B?cHAzRXN6dlBnbjdYck1qbnRBWXJqakVra1U4RGp2MWdrZDJsZWYyT3pPcVp5?=
 =?utf-8?B?bDdJUGp1YkR5YnZSTW9zd2w5WXY4KzJnZXg0SjJMNWhhZkdua3hReFQvQjgy?=
 =?utf-8?B?d2MzMjlRWFZ5cW9GTU5PdnhDeW5HWjhDRFc3WUZ3Nk5yNWl3eEpkcHBCRWg0?=
 =?utf-8?B?QmhDYjlzdkpuV2E2bXlxUnV2MGtFREJwRE0zYXR4cHhFeTMrdm9kN3VFWFIv?=
 =?utf-8?B?Z2lzY0Q1MWNxM0E3aU5FR0d2c1pnUlhYTDFlSW9KOU1yRzN3bmRLZFpoR1Zk?=
 =?utf-8?B?OEpvOXplZ21KWmJWL0RDOHZmNTlGK1VScUUxZVdLZnh1R21sUlNZaktmT0xY?=
 =?utf-8?B?TUNRMGl0MUdUMlZxODJXa0RiRlFQY0JHZ2NvTEdva2pZU2RLTjlTY2VHU0ZJ?=
 =?utf-8?B?dWRJYkJQZE1WV3p0aFVCVXc3eWVhMFRWTXZpbW5LNFRVbUhGY0FUTmJXd1hi?=
 =?utf-8?B?cHAxc1FUQU5aNVMxWE16bFVBTk9tSGRWZHBNY3B4ak9GZEQwekJ6RFpTamxK?=
 =?utf-8?B?a045M0hHWW8xK3Bpa1ZTdU9RVFNJRnljQlA2VVBwdElOVGpVQVp0dEgvSGM3?=
 =?utf-8?B?Mko1cnFrTHZMZlBROFNtMmdhalBjVVgzQjdYSWtoUUtYTGRBbjhUZWpwTWtn?=
 =?utf-8?B?ZSs4NHlSQnpVQmNqbDV2Z0hMUTJ6VzVERDVNbkxrWnBQbGhoTXZHSEVzdW1h?=
 =?utf-8?B?ek50a3hEM1Q4NVo0VGdEaytuRDF6MmFFVmJqL0s1OGRpK2FoakU0dWhYamhX?=
 =?utf-8?B?NDVldVR5NC9BdFRodHprb24wOXlUdURJaks4SFhwOUhXTzVzYWxmQm81U3JR?=
 =?utf-8?B?Ti9GMlhiM1MyN1pNU2x3MUc2Rnc1QkZsZ1RnY1VxM0htb1dCcXpHOTZOSHlE?=
 =?utf-8?B?TndzYmVsZENSZnExdm92SUVEUndoOVE3cTdsOEVpdzRUNWVMTE8weEpmMndD?=
 =?utf-8?B?NUVzUm9jL2JXdGI2SWRqZisza0tHbXJsR2RUUW1SSTdqalp4SHl0Q2FBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ty9xeUR4Z2haN1ZvUUVHUk01Wlk1R3FpbFo3YUYrckpRU0I2ZDgwVEpXVTlM?=
 =?utf-8?B?T0RuQUpPZ1UyUlZYM0xEN3Vnb0FKVjJzZmFhRTYwWEsrdFA2NS9OSFpCZlYr?=
 =?utf-8?B?NjhDYzBncUZKU0gyNXl5Vy9zUGg3dlhINmVkV1Z3SzFiVjh1SGI4S1dCM2pr?=
 =?utf-8?B?VW41RGtJNWZ0bnF2VVliRktrZm9lSE85K0p0Q2FKTHMyNDMxN1VpZWlQYnJw?=
 =?utf-8?B?TDdrYjFrOXUrRWgzVlMwZDFLaXZ4aTJmN0lhTWM0WmloaEltRmVMVzJjaTJw?=
 =?utf-8?B?M0MvNUFqUlRrWlRqL3dJR2pGKzdLYnJwaklzTklkTEV0RXBZdHhlSjFQc1d4?=
 =?utf-8?B?TmlTWlRMYk9Fd281citzbXllaHFvQzV6azR4eGRXYkdTOFBDR01BWVdzSnRN?=
 =?utf-8?B?Q2trdi95NFowd1VrY3NCenp5ajVDdWE1S2J4SjFuMjhBMm82YldaUTVrTXQy?=
 =?utf-8?B?N2JhZ2hoeXJ5anFGRmErS1Jybjlla1pMWVIrMm5MWUR4SFo5U1NYZmhlYmdT?=
 =?utf-8?B?Ni94QVlPeGhIeTBGMjdKVHF2ZEFqamhQdndaRG8ybjJjbjFqWDI0YjNTN05P?=
 =?utf-8?B?RXpiWHNOc2dmUDZOVWFNckxlM01aZVQxRzE5aE5zSXVkZmJIY3FyRzA1aGhw?=
 =?utf-8?B?OTByYnNkQURWd093bi9aU0FhM2VGVVh4NVJkZFJSRURzUnAxMUZ1c0FoV2ts?=
 =?utf-8?B?aFFWR3BQcmxCQ2t4bDA5K0lkNGJXVUR6Q3RJS3l6NGVlbzh5Sm1rM2dTd1lR?=
 =?utf-8?B?Y0hsZ0Nkd3FiZmR4Vm9RWnNCakhYeG9kNFo1N1B1Ym5yQzUyTHU4bGxoSVZX?=
 =?utf-8?B?SDV3RHUwZlpRR29GQXV1ZStTSFlaMnRQNG1UTEdHMEI3TlgzZk40K21jcy9C?=
 =?utf-8?B?RWx0cGF2UFdDRHY3YmRvVzJ0U1E1TTVISFVnK2w0VWhhRGJSSi8xZ0FaN3ZK?=
 =?utf-8?B?bGVMVzRUcVphMEZ1SVVKSHhabFlBNnpBN0lwbks5ay9BZ3o4Ync4UGNtK3hy?=
 =?utf-8?B?TEtPZkVvelBVT1lQalpLb3laWDVZZVdQREtYS25zT2VpQW1jRlFacmVOYTIz?=
 =?utf-8?B?WmJwZkpjdENidFVuNDBKbzRBeGtSRFRtaTJPamxRNysyRXROOUtjd2Njbkx2?=
 =?utf-8?B?djdPTk9jVWd1a2FuZTlXSC9TYm9SSmxaV25jSTN2em1neDU4S0g4ODdkWVJp?=
 =?utf-8?B?Z0hSRlRzUk1id1cvVTNCd2FGZm5yYWJWdDZuU1ZpWGp5MzM5WmpwN2c2ak5j?=
 =?utf-8?B?WEQxbTh5L042S2RUMGVtWGVGYUczS3lOR1drcTJETmNZZXBMU3g4QVBLc011?=
 =?utf-8?B?dmVtUTF0NFloWTB3dVRhd0RFVlRmMFNUNXlEcDF3M2R4enppcGF4WDFvYVY5?=
 =?utf-8?B?TXNTMjhDdUU5enFMTXNJanlENEtEWHNiMmZlNnpJTDZUd1F1UEt2ZEJodG9n?=
 =?utf-8?B?MzZ3bGVXRjZ2Rk5ZWm9hOVplbXRmUjgyYmZYZW00OHV6NTZITE83U1MyZlZw?=
 =?utf-8?B?a0tyMDNscElKZ0dlbzFieDdBbWhOSG1memtScFprSEllbjRJRWlkekhIQnMr?=
 =?utf-8?B?MXVDekJkNU56THFKL1FtS2FGQTZnY2F1Q3lUMVFINmFianMrOEJXUkRrU0s1?=
 =?utf-8?B?SDNRMTlsSkRMWGh2WnFnYWNNeHBQa3JBckNDTE9rbGlKK1l0RHNPQ3pDL1Zm?=
 =?utf-8?B?SEhsc3h4TmUxZGhDQXFFbFpWcUhjQmNoMDRzMWdUQlJwYWFJS0JSNnR2VlVE?=
 =?utf-8?B?eVZxUFZpdmk5VCtidjJCcnhPMDFDMURQNU5ZNmc2aDlXRVFwbGtEQ1dEZno4?=
 =?utf-8?B?YmJnY0NydGNKd3FQK1pKbTJGSUtMQitiRHVQM2VwekFCbzNNRG9EK1RuempM?=
 =?utf-8?B?ZVBWZW42Z0xwbTd0WVhKOHRhMU1acmJhclIzeHcybUZhQ2dCQnpkdDl5YnQ3?=
 =?utf-8?B?S2ZaWmw2Q2VMTUZNdDdFMXBsRlZaTzZHZWVtNEc0NGNxd25PMVpQdkdYcDUv?=
 =?utf-8?B?L3F0bmEzSm4vRWdLWjZxNE9DS2FkVSs2RENkQ0ZCMjVQd0J3eTMzaXRxNkZT?=
 =?utf-8?B?ZjUrYjBuNSt4MW9BaFlNdmltNGZ5UHFySHFYR1YzUlJsc1NVSHk5MzV3OCt5?=
 =?utf-8?Q?BgYTSvppAFa8w251Zn7YTx1qD?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 03572aac-8a78-4f42-6b7d-08dc67f6718a
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2024 02:45:34.6694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5YKx9BCwpLGLYNcQeDThXRUnAXLkG9IWs8tienSJKvgy3jc8268J0YRNGyoZ8rhGmT5Y6tH1arzcT+ljAEV8Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8250
X-OriginatorOrg: intel.com



On 27/04/2024 3:47 am, Sean Christopherson wrote:
> On Fri, Apr 26, 2024, Kai Huang wrote:
>> On Thu, 2024-04-25 at 07:30 -0700, Sean Christopherson wrote:
>>> On Thu, Apr 25, 2024, Xiaoyao Li wrote:
>>>> On 4/24/2024 12:53 AM, Sean Christopherson wrote:
>>>>> Fix a goof where KVM fails to re-initialize the set of supported VM types,
>>>>> resulting in KVM overreporting the set of supported types when a vendor
>>>>> module is reloaded with incompatible settings.  E.g. unload kvm-intel.ko,
>>>>> reload with ept=0, and KVM will incorrectly treat SW_PROTECTED_VM as
>>>>> supported.
>>>>
>>>> Hah, this reminds me of the bug of msrs_to_save[] and etc.
>>>>
>>>>     7a5ee6edb42e ("KVM: X86: Fix initialization of MSR lists")
>>>
>>> Yeah, and we had the same bug with allow_smaller_maxphyaddr
>>>
>>>    88213da23514 ("kvm: x86: disable the narrow guest module parameter on unload")
>>>
>>> If the side effects of linking kvm.ko into kvm-{amd,intel}.ko weren't so painful
>>> for userspace,
>>>
>>
>> Do we have any real side effects for _userspace_ here?
> 
> kvm.ko ceasing to exist, and "everything" being tied to the vendor module is the
> big problem.  E.g. params from the kernel command line for kvm.??? will become
> ineffective, etc.  Some of that can be handled in the kernel, e.g. KVM can create
> a sysfs symlink so that the accesses through sysfs continue to work, but AFAIK
> params don't supporting such aliasing/links.
> 
> I don't think there are any deal breakers, but I don't expect it to Just Work either.

Perhaps we can make the kvm.ko as a dummy module which only keeps the 
module parameters for backward compatibility?

