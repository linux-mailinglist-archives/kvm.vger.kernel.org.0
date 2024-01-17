Return-Path: <kvm+bounces-6365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BCDE82FE1A
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 01:54:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 10A5D1F268E9
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 00:54:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7FF7138E;
	Wed, 17 Jan 2024 00:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ls2HJzUJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092F2EC3;
	Wed, 17 Jan 2024 00:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=134.134.136.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705452847; cv=fail; b=fW3UyWyBbkhbCehHO76YgLRNMV6EXYaUsGTp8KGhOKVZq5ceaiPppeNy3GZHpoIQ+rnByO7huEKPkbvCuqI8l733FbWfNsr82mTE9kfznkGsizGuizT+EtIhVe8aiWU0GjGAqzpfrto/pLMCAgH2kcM6u/5y13S3wdO65fF/4qc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705452847; c=relaxed/simple;
	bh=OcUV8cKR8tJtcLcM7IUyIo6lnUzCKFV1+LObUJbnG9c=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:
	 Received:ARC-Message-Signature:ARC-Authentication-Results:Received:
	 Received:Message-ID:Date:User-Agent:Subject:To:CC:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	b=IRjoh2Yq35xwUu15KOgfzTlR27uXfPvdWnCKjhQO83Bfz84SaZL+ML71xvvXME3GBLNlQw35DIfZbzMdp4WWoFKq70rSNds9bB9lC1JdD23nCVpTvahlyAGlAcPFuR6hED8qi6y+k9fUizm3012dYru6RyAYqEhCrf+/LHDb9Tg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ls2HJzUJ; arc=fail smtp.client-ip=134.134.136.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705452845; x=1736988845;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OcUV8cKR8tJtcLcM7IUyIo6lnUzCKFV1+LObUJbnG9c=;
  b=ls2HJzUJuYWo+L8sdEXCcVE3DSRGarNVdYPW2ziltq40YJ+vd5h6TyYT
   BVuXU6dnTNYb05+RmGEQ0HVy3XNEILTEXkz6j2yP7ZvA94k7VrRzi6x9u
   Rc5+nKmrg4ZfR0tzdhX/uN8VVe6q35iW7I8Gkpy8aadwdCt/wCwN1qV+5
   8iZb6g1smwmoWbjRFiex4XVwocYArM3A5HIPmLpyDYUQp9/odVfvoMYmM
   MzjOuq6tDBdVBLy6jcLS6y5zmMb0Rd+7V+OGSfV1LAQJW0HsW649XB2UW
   yZP1CTdWtg1L9mnHc9pW3zP5ahrac/mXNbahUNN+AJLGotbEvcQY5E5oZ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="403787320"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="403787320"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 16:54:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="818340883"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="818340883"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Jan 2024 16:54:02 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Jan 2024 16:54:01 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Jan 2024 16:54:01 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Jan 2024 16:54:01 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Jan 2024 16:54:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lv3iDv/Kurv27lkXzStdsw9Mf8RtCdMgP10wiIj3qYyFLTRCaz36LYaOnudWlDB+EayYQuZXhh7KEDOccJ5mkJgiYy24FMBXmldMlDH8j8D/zUwiDioW1pTLQ3wREjpmtop1+MooyXTnZyvIrYJgI7B+gHSG6BKjZ5HGdc1nEn2cfkXdZOaqdaMI1J919k0luyupBp/H22LAtWxTFBdtxJSk4XBRDmbtaTu5KvcMNP19WREBcS/S+mLHSp4iF1yOCIr/sZImBx7bYZ9dr+pPHpsa/8AkZXzSODoul+2eaUDOgbKilFbmDi/1EoCu7bBeYHWeM6602KcQvnWugaSs0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fZ9mHnyH/139UFM6/90/50ArpzWuqoeNlbaH9wRnaQ4=;
 b=bwtNbF6w9IW2hjT3GY/rDmkxt0eKgm3YAZUl4HZqLil4FKg3WlSkKc94XQqb/I/fmIKu9EG8T2xenhpL8AhfxWQfHK0zGK+fSSLT7UvsYedZ0i1PlYvitSog4LFG4udku9glYW7KTsoDeZR8BKWIjHa6BEpC4ksnjZPA52MhQ9aXiOL1Nqfzah/bfeeffITNIBI6wz8oBdV8+s9riu+yPpHPkM+MuYYvm3T6EsnOBVhfhEZwt6VKB6LyCz6Ud/G4bpCnLMFC9uu6xbsHqXigsy2jHFlh59hQSpPCId1tqLkpE2QlOEUXxKJK1w4JhI81YpEYDPq3EiTWDpQ/o+/llA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SA3PR11MB7653.namprd11.prod.outlook.com (2603:10b6:806:306::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.21; Wed, 17 Jan
 2024 00:53:58 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1%3]) with mapi id 15.20.7181.022; Wed, 17 Jan 2024
 00:53:58 +0000
Message-ID: <26784552-f139-4b49-8b28-a56e2efa10ad@intel.com>
Date: Wed, 17 Jan 2024 08:53:46 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/26] Enable CET Virtualization
To: Chao Gao <chao.gao@intel.com>
CC: Sean Christopherson <seanjc@google.com>, Rick P Edgecombe
	<rick.p.edgecombe@intel.com>, Dave Hansen <dave.hansen@intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "john.allen@amd.com"
	<john.allen@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>
References: <5f57ce03-9568-4739-b02d-e9fac6ed381a@intel.com>
 <6179ddcb25c683bd178e74e7e2455cee63ba74de.camel@intel.com>
 <ZZdLG5W5u19PsnTo@google.com>
 <a2344e2143ef2b9eca0d153c86091e58e596709d.camel@intel.com>
 <ZZdSSzCqvd-3sdBL@google.com>
 <8f070910-2b2e-425d-995e-dfa03a7695de@intel.com>
 <ZZgsipXoXTKyvCZT@google.com>
 <06fdd362-cb7f-47df-9d1a-9b85d2ed05b5@intel.com>
 <ZZ1h9GW93ckc3FlE@google.com>
 <cf043809-430a-4072-b0fd-201cd469b602@intel.com>
 <ZaSQn7RCRTaBK1bc@chao-email>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZaSQn7RCRTaBK1bc@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGBP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::28)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SA3PR11MB7653:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b17b2e2-9452-4cdb-5f90-08dc16f6c95f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dfmaHBpB/70VpU9Jql7A/IY4yL5uYp9GuPnGuCLn8RDe/fBzmxVLT7njjT6vqWv7cMihrwrQxEgP8uR+Des3a3WgxNcwOFpH1SuBOVBrVmnj+d1kTvRKGEl1Ne1s7mO6Qd71P0EdOn6ALjS1oQZs9frbYmkIhPfdjF7HDAy6oK17fQrKAUXTZMef2Qhj0tF6Xs/OBr8Ds5INFefAt7rGJWeg18pMgTjh8ac5iYMpbjDyOeXYvP6YHFqsna1Lp5em5A8m4gUIHBonPsK0mL+THBmJK+RmBpaJAWrM2mwh+IWYC0WzXfhklq/zY+t98OtXSk53AzMablOOc/bs1W7EqPNk9kMQmsyovrIRg7B7UAMGqZaBFJHd1w38wpyGz5K1ffG/7wXrhBn7MRKzM7JF6rZ4CJc2hLC+8rqdnrdekNoEZLCY4A704GsynTereD9Ku3a30XzQ7Xgqx1wlVwvfC7KlVdYIqQr/nGQSWl2YLaO7SU76vRy/nQBJtzw18BJm0zQkStVG8KH0YOVPJ4lx26kA0bIGRsk7o9jZjGa4A4W/2kHD19OQpaQ5siI3L9OWzQoWEQLO6owSIZu1bERex3TVG647h6ggg3s4E6OrJZrt1WxtWnLbOFVavsJe13fIxwelUuEO5TYbfE6fvfrETQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(136003)(39860400002)(396003)(346002)(230922051799003)(451199024)(64100799003)(186009)(1800799012)(31686004)(6666004)(6506007)(6512007)(2616005)(53546011)(26005)(38100700002)(36756003)(31696002)(86362001)(82960400001)(41300700001)(478600001)(6486002)(83380400001)(2906002)(5660300002)(66556008)(8676002)(6862004)(4326008)(6636002)(8936002)(54906003)(66946007)(66476007)(37006003)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0ZQL0JySlZEUHVjeTNwRDBtWHRQRzlIZW9KaFVDOUl0SFkxNFl2ZGQrdVFk?=
 =?utf-8?B?MkFHYzM5SWlPYmJlZjhoV0dHZWlJZ2xha3ZkSEdPRmhBY1F3SVVMbVl5bC9p?=
 =?utf-8?B?alpRYmZOcUFkMWF6dmpjci9wVWZSb3JTRFZFZm5UT0VtUGRRS0M0SFNzY1VN?=
 =?utf-8?B?aUlGYVg3MExsa2tkYXVrRU5jT3RkUnlRRUozS1JDMWlHbC9hYTZ5bGdaa2Yv?=
 =?utf-8?B?S3hZOVdsNlB5ODBacFNJYVRnanZPc0pLVXZJVGhDZGZEcmtIVnpRcWlndEk5?=
 =?utf-8?B?R1d6YnlFWHZBTlNBdUtiM3pONzVGSFBCS2FsWURmdE05SVI5RzhJYWpDbFFK?=
 =?utf-8?B?clQ5RllyWGxvdUlLZUpScmNwTWo1Y3VTWndnSElra2FtdDQ1RUdKVzZDcmpx?=
 =?utf-8?B?QU5PdDhxMk1KQ2trYVdnU2dUbE9ZNkxtVkllYmJoRzJlQS8yNS9hWG50RlIw?=
 =?utf-8?B?RFR0aEJXbnJhaUNveE1Mc05JTHNCQXdSZXB4Q3phM2h3ZGx3NGNsRVhocndB?=
 =?utf-8?B?dXorTTRJN05ON3VKN0preFlhUXBFbTZKV25BUWJoYys3Y2hDS0NaV0dCWHRy?=
 =?utf-8?B?WDVXSlRnK1I5WTlTRm9Fc0VqRFpadVNkRmlkUTlZcTJUaXNiSkM2bWhpOVZh?=
 =?utf-8?B?c2s2WmE1eU0yYlB5VlZhSUZ5TkxRZTE0ZmpsWEFhZHNhSS9wN1E0YmxyQ2FF?=
 =?utf-8?B?aFBlSFN5WFBqbk5YYVJ2RWFueXdmc2k5Ritnek1lWGFjUnhSc3VVOGdwN2xm?=
 =?utf-8?B?a1MxL0Qybk15clE3UDNWV0lLaG04ek50MUF1WDlXdXczRmtvcEh4dU1pOHE3?=
 =?utf-8?B?MS85ZnlSaXowZVp3QXU3WHJ4aStNdWNvYjZ1ZWh2REJuektmNW5iU2Z2STl6?=
 =?utf-8?B?M1J3WGxoeHNsaTE2Y1JBcUh0NVRJVUE1dWprU2Z0WHZMY1lDUVdsWG9mRVBG?=
 =?utf-8?B?dUVnRTBXRUlHRUdDS3NBMzVWbmNTRjc0dFBKVXV3SWZqSGRRMDgxSzd5aExj?=
 =?utf-8?B?eDEvYXJXQUhpN1NqVDV2QnNaVWUyV3UzUDdjYU9lN3BFTThQVXhmVUFiTXZm?=
 =?utf-8?B?S0hhU3ZtMlNvL1E0U0NIZXFzeEZzdkZqQXZJTTF0WmFpVXlXQTlNVm96TzRh?=
 =?utf-8?B?Q2VrRGwwVk9QRzB3YlVvd1pqTmM1NitycE52TTZvcWpNYW44UndjMHFaQ0Vm?=
 =?utf-8?B?R0lFOUpMSmwwZkxKRlliRStWVStFWmY0YzNHQnExVUw4TkNVdFNoM1gxRVlE?=
 =?utf-8?B?ZFdxRndSQXNTTGdLMDRPOE14cWhNbU5DSGhzeEt3Snh6WTZhWG42V2ZhYWtE?=
 =?utf-8?B?bHJuWnQvVE1peHBVTXNqbW9UVlJMZlNpYnNORGFwVDN0cGVRU25oMmhVUGRp?=
 =?utf-8?B?LzdHNEpOSStGMnBPSVRYSFFQbWs0NW82SjVIMG9NYlJnaEk1ZGRZMGNEUkM1?=
 =?utf-8?B?V1Jsb1d5ZTdnc3MvZlZtSUhvcTdYSHpHT2xWTUxVdURHZU9wS1ZuOTJxZWJ4?=
 =?utf-8?B?SitET0dHam80ZEoySWdwZDlzdTI3TnRPeFN0V3ByakFKT2xIVUxxbm8vTlBl?=
 =?utf-8?B?QVk1cnJBQVhwRnZMemRTcGdicHlJUXVRTXFRWHI5ZUFwRXQ1U1lzR0g1U3Ju?=
 =?utf-8?B?YXBvUkRUcUZoczV1OFhZanVLZ2ZYcEVmU1F5aWVXQjh5dWFiT05TdEJvVVdJ?=
 =?utf-8?B?Wi96aldFNXdNTUlyK3lLOWcwQUtHSzBWL25kOHB5UDlDVlFDWnlEQ2JkRUY3?=
 =?utf-8?B?NXNLM1pSTHFOZVE2NnM0VGtiUEw5Z3llVWFqS1RUcUhHSFZNcVhrRWJxZTJC?=
 =?utf-8?B?Z1pEQ0NaSG15M2VZSXZFc2ViTy9sd1hvTlQwY2lEWmhRVmtGb0d6YW9BblY2?=
 =?utf-8?B?UDZLMUpQbHd1VTNBZHY5VFdlakdMOVhEajltOXhMa1VielcyY280OU5tTlFC?=
 =?utf-8?B?dGp5c0R4S3NsS2lNWjZaQWwyNnhIRUU4emY0V29rclhMK1NaNHZ0MUIyYVUy?=
 =?utf-8?B?RmFjNHJpVmJFYlJaNFZJcWtvUTFWN2hqS0RPMVVGZkxOZVFFYVozZFJpemdQ?=
 =?utf-8?B?NTJqSFgreXlvanJvS1FCRHVDMjRiZmFjUElLdGhsemhuK3p0aVhIQzFZN1dT?=
 =?utf-8?B?b2ZqekZTREhLK1BRUU1sdTBOYzZCSTRzcjFQOEsxUTZPRGwzVVc0dWVZU0xN?=
 =?utf-8?B?R3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b17b2e2-9452-4cdb-5f90-08dc16f6c95f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2024 00:53:57.9823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 76qifwwPnicXsOeUWFjY15UD/Xgr/93kYd1YjT61n1aolqp1jWXel+1+tI+WMe66EfmT7dcUahP7Z9csNuklvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7653
X-OriginatorOrg: intel.com

On 1/15/2024 9:55 AM, Chao Gao wrote:
> On Thu, Jan 11, 2024 at 10:56:55PM +0800, Yang, Weijiang wrote:
>> On 1/9/2024 11:10 PM, Sean Christopherson wrote:
>>> On Mon, Jan 08, 2024, Weijiang Yang wrote:
>>>> On 1/6/2024 12:21 AM, Sean Christopherson wrote:
>>>>> On Fri, Jan 05, 2024, Weijiang Yang wrote:
>>>>>> On 1/5/2024 8:54 AM, Sean Christopherson wrote:
>>>>>>> On Fri, Jan 05, 2024, Rick P Edgecombe wrote:
>>>>>>>>> For CALL/RET (and presumably any branch instructions with IBT?) other
>>>>>>>>> instructions that are directly affected by CET, the simplest thing would
>>>>>>>>> probably be to disable those in KVM's emulator if shadow stacks and/or IBT
>>>>>>>>> are enabled, and let KVM's failure paths take it from there.
>>>>>>>> Right, that is what I was wondering might be the normal solution for
>>>>>>>> situations like this.
>>>>>>> If KVM can't emulate something, it either retries the instruction (with some
>>>>>>> decent logic to guard against infinite retries) or punts to userspace.
>>>>>> What kind of error is proper if KVM has to punt to userspace?
>>>>> KVM_INTERNAL_ERROR_EMULATION.  See prepare_emulation_failure_exit().
>>>>>
>>>>>> Or just inject #UD into guest on detecting this case?
>>>>> No, do not inject #UD or do anything else that deviates from architecturally
>>>>> defined behavior.
>>>> Thanks!
>>>> But based on current KVM implementation and patch 24, seems that if CET is exposed
>>>> to guest, the emulation code or shadow paging mode couldn't be activated at the same time:
>>> No, requiring unrestricted guest only disables the paths where KVM *delibeately*
>>> emulates the entire guest code stream.  In no way, shape, or form does it prevent
>>> KVM from attempting to emulate arbitrary instructions.
>> Yes, also need to prevent sporadic emulation, how about adding below patch in emulator?
>>
>>
>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>> index e223043ef5b2..e817d8560ceb 100644
>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -178,6 +178,7 @@
>>   #define IncSP       ((u64)1 << 54)  /* SP is incremented before ModRM calc */
>>   #define TwoMemOp    ((u64)1 << 55)  /* Instruction has two memory operand */
>>   #define IsBranch    ((u64)1 << 56)  /* Instruction is considered a branch. */
>> +#define IsProtected ((u64)1 << 57)  /* Instruction is protected by CET. */
>>
>>   #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
>>
>> @@ -4098,9 +4099,9 @@ static const struct opcode group4[] = {
>>   static const struct opcode group5[] = {
>>          F(DstMem | SrcNone | Lock,              em_inc),
>>          F(DstMem | SrcNone | Lock,              em_dec),
>> -       I(SrcMem | NearBranch | IsBranch,       em_call_near_abs),
>> -       I(SrcMemFAddr | ImplicitOps | IsBranch, em_call_far),
>> -       I(SrcMem | NearBranch | IsBranch,       em_jmp_abs),
>> +       I(SrcMem | NearBranch | IsBranch | IsProtected, em_call_near_abs),
>> +       I(SrcMemFAddr | ImplicitOps | IsBranch | IsProtected, em_call_far),
>> +       I(SrcMem | NearBranch | IsBranch | IsProtected, em_jmp_abs),
>>          I(SrcMemFAddr | ImplicitOps | IsBranch, em_jmp_far),
>>          I(SrcMem | Stack | TwoMemOp,            em_push), D(Undefined),
>>   };
>> @@ -4362,11 +4363,11 @@ static const struct opcode opcode_table[256] = {
>>          /* 0xC8 - 0xCF */
>>          I(Stack | SrcImmU16 | Src2ImmByte | IsBranch, em_enter),
>>          I(Stack | IsBranch, em_leave),
>> -       I(ImplicitOps | SrcImmU16 | IsBranch, em_ret_far_imm),
>> -       I(ImplicitOps | IsBranch, em_ret_far),
>> -       D(ImplicitOps | IsBranch), DI(SrcImmByte | IsBranch, intn),
>> +       I(ImplicitOps | SrcImmU16 | IsBranch | IsProtected, em_ret_far_imm),
>> +       I(ImplicitOps | IsBranch | IsProtected, em_ret_far),
>> +       D(ImplicitOps | IsBranch), DI(SrcImmByte | IsBranch | IsProtected, intn),
>>          D(ImplicitOps | No64 | IsBranch),
>> -       II(ImplicitOps | IsBranch, em_iret, iret),
>> +       II(ImplicitOps | IsBranch | IsProtected, em_iret, iret),
>>          /* 0xD0 - 0xD7 */
>>          G(Src2One | ByteOp, group2), G(Src2One, group2),
>>          G(Src2CL | ByteOp, group2), G(Src2CL, group2),
>> @@ -4382,7 +4383,7 @@ static const struct opcode opcode_table[256] = {
>>          I2bvIP(SrcImmUByte | DstAcc, em_in,  in,  check_perm_in),
>>          I2bvIP(SrcAcc | DstImmUByte, em_out, out, check_perm_out),
>>          /* 0xE8 - 0xEF */
>> -       I(SrcImm | NearBranch | IsBranch, em_call),
>> +       I(SrcImm | NearBranch | IsBranch | IsProtected, em_call),
>>          D(SrcImm | ImplicitOps | NearBranch | IsBranch),
>>          I(SrcImmFAddr | No64 | IsBranch, em_jmp_far),
>>          D(SrcImmByte | ImplicitOps | NearBranch | IsBranch),
>> @@ -4401,7 +4402,7 @@ static const struct opcode opcode_table[256] = {
>>   static const struct opcode twobyte_table[256] = {
>>          /* 0x00 - 0x0F */
>>          G(0, group6), GD(0, &group7), N, N,
>> -       N, I(ImplicitOps | EmulateOnUD | IsBranch, em_syscall),
>> +       N, I(ImplicitOps | EmulateOnUD | IsBranch | IsProtected, em_syscall),
>>          II(ImplicitOps | Priv, em_clts, clts), N,
>>          DI(ImplicitOps | Priv, invd), DI(ImplicitOps | Priv, wbinvd), N, N,
>>          N, D(ImplicitOps | ModRM | SrcMem | NoAccess), N, N,
>> @@ -4432,8 +4433,8 @@ static const struct opcode twobyte_table[256] = {
>>          IIP(ImplicitOps, em_rdtsc, rdtsc, check_rdtsc),
>>          II(ImplicitOps | Priv, em_rdmsr, rdmsr),
>>          IIP(ImplicitOps, em_rdpmc, rdpmc, check_rdpmc),
>> -       I(ImplicitOps | EmulateOnUD | IsBranch, em_sysenter),
>> -       I(ImplicitOps | Priv | EmulateOnUD | IsBranch, em_sysexit),
>> +       I(ImplicitOps | EmulateOnUD | IsBranch | IsProtected, em_sysenter),
>> +       I(ImplicitOps | Priv | EmulateOnUD | IsBranch | IsProtected, em_sysexit),
>>          N, N,
>>          N, N, N, N, N, N, N, N,
>>          /* 0x40 - 0x4F */
>> @@ -4971,6 +4972,12 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
>>          if (ctxt->d == 0)
>>                  return EMULATION_FAILED;
>> +       if ((opcode.flags & IsProtected) &&
>> +           (ctxt->ops->get_cr(ctxt, 4) & X86_CR4_CET)) {
> CR4.CET doesn't necessarily mean IBT or shadow stack is enabled. why not check
> CPL and IA32_S/U_CET?

CR4.CET is the master control bit for CET features, a sane guest should set the bit iff it wants
to activate CET features. On the contrast, the IBT/SHSTK bits in IA32_S/U_CET only mean
the feature is enabled but maybe not active at the moment emulator is working, so no need
to stop emulation in this case.

>
>> +               WARN_ONCE(1, "CET is active, emulation aborted.\n");
> remove this WARN_ONCE(). Guest can trigger this at will and overflow host dmesg.

OK, the purpose is to give some informative message when guest hits the prohibited cases.
I can remove it. Thanks!
>
> if you really want to tell usespace the emulation_failure is due to CET, maybe
> you can add a new flag like KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES.
> for now, I won't bother to add this because probably userspace just terminates
> the VM on any instruction failure (i.e., won't try to figure out the reason of
> the instruction failure and fix it).

Agreed, don't need to another flag to indicate this is due to CET on.



