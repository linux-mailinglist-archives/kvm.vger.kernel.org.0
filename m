Return-Path: <kvm+bounces-5653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F5C58244A8
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 16:09:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A964AB252EB
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 15:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CC5923776;
	Thu,  4 Jan 2024 15:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gO0hqheU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F38249FC
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 15:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704380921; x=1735916921;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=BcWH3TdD9y58KRio7Wi6bqWArTj+thTkc9FD7GmZr6I=;
  b=gO0hqheUTUucCkg1na+Vaj57M1h17YIXh92R/EA+oD8/s2jL6/4KEvWM
   jD9Bei1KvKI0PVhRehZB60DkX0R/nUyds0ivEZtTfIjbdYlS19c66QQWw
   FNXE53o0vsNuyPW4/+LHVt6plZh3NUk5y0hFAFwk5dTEOjIIaGBOZVpMm
   aio8W5zzrsgc8cjSYAifHtxaBpCctmeVN9bke4kuau9gI5BuwOMKjTYLk
   stDiVJ602Fa6zoBM58GWZS/ycCYnf8xXnly0g7s8chjzfuJnlnEtwYeYW
   SrqT350/5E/4h40Vo+Vb3UIz5aDRSUP5kwsAF0T4xjPZuqf3KI9myQEXC
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="10661880"
X-IronPort-AV: E=Sophos;i="6.04,331,1695711600"; 
   d="scan'208";a="10661880"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2024 07:08:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="773542992"
X-IronPort-AV: E=Sophos;i="6.04,331,1695711600"; 
   d="scan'208";a="773542992"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Jan 2024 07:08:04 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 4 Jan 2024 07:08:04 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 4 Jan 2024 07:08:03 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 4 Jan 2024 07:08:03 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 4 Jan 2024 07:08:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sh1TaTx2NS7jyq6iRn5PqF6MGGdFA9FdLLSgfoibts9i3HaVr8uhNqclk4fS8A/l9jlG9reKg566abT88Yt8rFFJmnFqmEgUSYL0vNH6GDEvWQ8wiRjbh/RL1DanezQeM7tWsziWNm8QRY3e25sFRqqp9H8Cpg5pXiASn0b9Yt7nGzHkdNg2OU37XZGrRujXC+UJfs8iZTO7EjR4J7AKxwhlAa086ph1OYI3fMKri2hCneR12CcON2g/grdqYmp1m7pt01mHgosypNAWrQx8hy1vAVf8iNRyddOHr2QjLWlDGg+XMpOZwY5X+ZeeO2KAWaql8mQuZMvIOmnxr+puxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0yEIYG62DuSxyhntcjNRXkMaa6YbohNxK9NZIz4AWrE=;
 b=bYX9gGXHrqw1iG3hrT1aH+6MR9B0rP2rQ1ftsrm24GHyYPbKEDRLix77/0id81cAyYFeXagLOj3pdeTF+zixY8Te+IxfU3/WECxhPkDY5dFyizSnahpA1SCqkVdwFiEKDs42NTlEqODp/9Q+dQzK0UtBJVyik0eVQ0Dl7Oxg5fzwk7EVmZ409xsCucXQYM3gasils77gJ4Mgmhzr8qFS5nbobceaNhqyGGayKQnACURV+BCwqUa0wiecuf4leWPYCKxBHuJiTzQ7ig5OxdUYlXtWwEXMrGJlM5VRfdJ8mnKaDuulBVQXBgmkWIlwt0axelEMJIeXFwMjwOZF5bgQ7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM4PR11MB5343.namprd11.prod.outlook.com (2603:10b6:5:392::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.15; Thu, 4 Jan
 2024 15:08:01 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::66ec:5c08:f169:6038]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::66ec:5c08:f169:6038%3]) with mapi id 15.20.7159.013; Thu, 4 Jan 2024
 15:08:01 +0000
Date: Thu, 4 Jan 2024 23:07:50 +0800
From: Chao Gao <chao.gao@intel.com>
To: Jim Mattson <jmattson@google.com>
CC: Sean Christopherson <seanjc@google.com>, Xu Yilun
	<yilun.xu@linux.intel.com>, Tao Su <tao1.su@linux.intel.com>,
	<kvm@vger.kernel.org>, <pbonzini@redhat.com>, <eddie.dong@intel.com>,
	<xiaoyao.li@intel.com>, <yuan.yao@linux.intel.com>, <yi1.lai@intel.com>,
	<xudong.hao@intel.com>, <chao.p.peng@intel.com>
Subject: Re: [PATCH 1/2] x86: KVM: Limit guest physical bits when 5-level EPT
 is unsupported
Message-ID: <ZZbJxgyYoEJy+bAj@chao-email>
References: <20231218140543.870234-1-tao1.su@linux.intel.com>
 <20231218140543.870234-2-tao1.su@linux.intel.com>
 <ZYMWFhVQ7dCjYegQ@google.com>
 <ZYP0/nK/WJgzO1yP@yilunxu-OptiPlex-7050>
 <ZZSbLUGNNBDjDRMB@google.com>
 <CALMp9eTutnTxCjQjs-nxP=XC345vTmJJODr+PcSOeaQpBW0Skw@mail.gmail.com>
 <ZZWhuW_hfpwAAgzX@google.com>
 <ZZYbzzDxPI8gjPu8@chao-email>
 <CALMp9eSg6No9L40kmo7n9BGOz4v1ThA7-e4gD4sgj3KGBJEUzA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eSg6No9L40kmo7n9BGOz4v1ThA7-e4gD4sgj3KGBJEUzA@mail.gmail.com>
X-ClientProxiedBy: SI2P153CA0006.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::22) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM4PR11MB5343:EE_
X-MS-Office365-Filtering-Correlation-Id: be5c914f-d9a2-4327-e91b-08dc0d36f15d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8QiSa+IwwQGC1gQsT6PqjlJ9UfQVNDSlK8ePZWcIT21Gl+L6sbReLK0IVfA/3oCjkaa0F4lpv/D5kmJ1w2SAQZzPMYxwzGEULmenqlC0LWqxGmKPlb1kgkTIkGlONwsO23G0lnOrAr5y8MSudodQ7rUFlAYM4cURkcid+s2AH8kpK/o5rpOdLlwLuHSKyrdCxvJ2wD98MXoVXbS+uWSKlK0hqSX3/MIIhhJV6BBrZo8XuWgRJEVb49U5Smx1VkSV5UwKjeyWWqbj6ZiWQf+puDg0+J8nAq/OJR3fYH9SgUJFXeHmmZTsHmFH39A0YoWnvA6NhzEl/47B/9YgMcCzskWk3zdUoneAt1y8Uh+fTSVEM/bxEWpzY2Y2yEFbzP2J9/qWsO9anye+1E35dgk97T2EnIgNRnInK7Y1N1ZVr6haKjswI6vPpt8m6VejqQ+B0un2LrJUUAOS/VQvxZn5Q5P2ygQhixA3E+w7Yeh0NUhwmpFO+nNt+PQ0WzaOBlKzGAIT5iGx1x/fQJrZ0tf7dgNUoBnhiISqg+hyCvCTs2CR/Tde88R5sn9dgRvJLtr/1KuLBm/UoLY1d9agyUytCLf9QRpE+mBlV/GTlEizuQY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(136003)(376002)(396003)(346002)(39860400002)(366004)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(6486002)(26005)(53546011)(9686003)(478600001)(6506007)(6666004)(6512007)(83380400001)(2906002)(33716001)(41300700001)(66476007)(66556008)(66946007)(316002)(54906003)(6916009)(44832011)(8676002)(8936002)(4326008)(5660300002)(38100700002)(86362001)(82960400001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGJuaXdKd3YxeTFNalFMQlF3QTBLaG1iSUZrbk1rNEFWQkQ1ZGR6QmVsMllB?=
 =?utf-8?B?NG9UR0RqT3QzaTh3Y2kwcU5lZHN6N3hiRURlNTBoNnBBd3UvK2pnQ1FqUXlX?=
 =?utf-8?B?YTRtc2dYN0lEZm5Ock1kTzc5bjhrQlhVb3czcEV4Wk0vVThHM2RDeldzaUZs?=
 =?utf-8?B?amFma1JCVG4xbExyemNtMFdOb1F5QjgzaGc2Mm1iMENVUUZJaEJubEdYejd2?=
 =?utf-8?B?Y1hjUHlBbXZHZXAvMWlHWUkvcm1EZkJIelVnc2hjRVJoVlcxWmJ3UzlsSmVo?=
 =?utf-8?B?aTF4NUg0Vi9aWnQ2QWozRTE1dWFvc256OHJuOW9LbEpsRXdINXZEemJTcm5w?=
 =?utf-8?B?cnVJUjRmVlpkakFXQWVqNFJ5dDZvUkxPSlRMMW1JaGxIV1FsNHBHam1ZSEYv?=
 =?utf-8?B?TC9CQkhrU1JPNno3VEI4YmpRTkk0ODRiMkNlZ29iRVh2dGNxeUVlRmc1Z2lF?=
 =?utf-8?B?UC9OaDBZRjdNZXJIUFdrQnc4djJ4emE4VXJ3elpsYUwvb3llM2sweFNrN2Q3?=
 =?utf-8?B?ZW1hbFhwelhqTnpnL1d2NitPalR2OUJscml0TDhJdnlrVnlFRDk3YVh5UnJK?=
 =?utf-8?B?MXFHZlJSMHNpd3NKTVVHUDlMSWxQM0pNRGkxSHV2cDJISzkwSVlQVnA1MU9D?=
 =?utf-8?B?T3VENUxCaGhXbnFZUklHTjQrbTZNNE9pc3pORnpMWGQ4Q0F6Q0oxK0FrUldW?=
 =?utf-8?B?QkJ5SWl0dzlscGRDWGpGbnBGcGxld016Y0V0aXRPVkEyd09QVUxnSkhheVVH?=
 =?utf-8?B?a3hVZWRmZUVmdno3NkhjUjFJbDR6dXhYaFNFeDdmSkRBUWlLejNYOUpJU0J2?=
 =?utf-8?B?RW16QlAvRVA4Rkh4eVVwWEtROGpoUmxVRGxYZTMwSHV1TjNyeUZQNzF1eXVD?=
 =?utf-8?B?c0tJemkwUVp2dTY2d2tSZ1lmQlZnYTRNQ1VyTFZveGJzK2FoTjdYY3M3VUgy?=
 =?utf-8?B?Tzh2aDAwZDVjdlcwQWRwRFdiTUFSVlRJdTdrWXE5SzlHa0NYWlNPc3l2bDJs?=
 =?utf-8?B?VzQ4MmptSTlNTXZ0M2lCUExlVWs5QmxSVExKaEVBV1BmZjkwMWhvTmtDMFJn?=
 =?utf-8?B?UGlaNDQ2cGQrck80SXlZMEpaY3BOZ2Q1UWdsWWs3eVZZSWNZTHBKeWhLM3dl?=
 =?utf-8?B?UC9LRVhJbU9OZjl1ZXpMUDZxcTBySDRhSTdrdGtnejNaYkhnVXJYR0gxSWQ5?=
 =?utf-8?B?ZHo5T3YzNHNQdFdSQTB0MURPU2VRajJNN2NpSFBLSkFSN2Q1VVlJWWtHWUpB?=
 =?utf-8?B?VnZWb0QrZ3luMXp1WEdZc0RqVS9rVTNqeUpZNklHN1FoQ3k3RjZRRFpEREZE?=
 =?utf-8?B?R05Zd2poTEpXZXBQSVdweExTRUUwSnpiNkZ3SlQ3Y0hrejhsbHNZZ3Fxa3dE?=
 =?utf-8?B?UUFucHVwUlpCZjYxamx1SzRVdjlXV0xHK21EYitWZDRtdDdrR2t4ZkJjbFhx?=
 =?utf-8?B?Nm12UmtMZklOeFNTZVBGcG9Fb0FzaVJwRzU2b1pwc2VDcHBab1NkVXp3QlVn?=
 =?utf-8?B?Rmk0RmNqa2sxUVQ3UHFCL29pYmlqeVZ2cEZ0RWxCTko3M0tOQmgzeG9SNUlK?=
 =?utf-8?B?TUNiTitKVUNsWkk0Z0FpRjhsajc5M0VnTWFBdnUxaGhqUjU1a2VXQ2ZrL3Za?=
 =?utf-8?B?OGx1cmxiZVdibGNjMi9ObXY4QS9ST09OcmRhQjlaSGJHWUhWekN0YnQ3aTY4?=
 =?utf-8?B?WjE4R05uK2Jyc0IxQWpoUGhWb1BZNVZyaitwdStZelhIMm44NjV3SkE4VEow?=
 =?utf-8?B?b1J3aW5Ic2kzRWxOeXRJREU3dVVGSFVNNkFjUS9FUy9JdThsZDhqMWFUTTMx?=
 =?utf-8?B?Q2pzZ0pUT3N1RzlkMENwRUxYL3hrMEg3VVhjNXQ2ODczOXBGYWZKT2tDVjZq?=
 =?utf-8?B?ZGJxcEZMaVZSUzJ5bXpNWnJoa2NYaWpjR21IMFlDS1VIeWwyZTFtTjVqNmFW?=
 =?utf-8?B?QUU0RFpNdVZZVVcyb2xnQnV5WEZ6ZjZnNEFnS0ZITGtCTzBiUkJEMUFoTFp3?=
 =?utf-8?B?M2MrL1J6MUdYcE1GaEtCVWg0MXFwUy9QNlk2VWdINW5nOUlXT3VtOFA3aENx?=
 =?utf-8?B?WER2bWpGS2ZCbmtGdmViemxUamJjakVhUmZobVNYeEtNdWdLTFBMNDZ1OHha?=
 =?utf-8?Q?3kIF+xaMK8fP6z10bynRXUDrD?=
X-MS-Exchange-CrossTenant-Network-Message-Id: be5c914f-d9a2-4327-e91b-08dc0d36f15d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2024 15:08:01.0195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uuWTDeFQ+PZ5A5vqQ8ubHiDL1H6Vd66auwRFgRpK9mCwXo4os3FvfCiNB+Z2RNRnVHkgYFDAjCp1raz+DP3eYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5343
X-OriginatorOrg: intel.com

On Wed, Jan 03, 2024 at 07:40:02PM -0800, Jim Mattson wrote:
>On Wed, Jan 3, 2024 at 6:45 PM Chao Gao <chao.gao@intel.com> wrote:
>>
>> On Wed, Jan 03, 2024 at 10:04:41AM -0800, Sean Christopherson wrote:
>> >On Tue, Jan 02, 2024, Jim Mattson wrote:
>> >> On Tue, Jan 2, 2024 at 3:24 PM Sean Christopherson <seanjc@google.com> wrote:
>> >> >
>> >> > On Thu, Dec 21, 2023, Xu Yilun wrote:
>> >> > > On Wed, Dec 20, 2023 at 08:28:06AM -0800, Sean Christopherson wrote:
>> >> > > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> >> > > > > index c57e181bba21..72634d6b61b2 100644
>> >> > > > > --- a/arch/x86/kvm/mmu/mmu.c
>> >> > > > > +++ b/arch/x86/kvm/mmu/mmu.c
>> >> > > > > @@ -5177,6 +5177,13 @@ void __kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
>> >> > > > >   reset_guest_paging_metadata(vcpu, mmu);
>> >> > > > >  }
>> >> > > > >
>> >> > > > > +/* guest-physical-address bits limited by TDP */
>> >> > > > > +unsigned int kvm_mmu_tdp_maxphyaddr(void)
>> >> > > > > +{
>> >> > > > > + return max_tdp_level == 5 ? 57 : 48;
>> >> > > >
>> >> > > > Using "57" is kinda sorta wrong, e.g. the SDM says:
>> >> > > >
>> >> > > >   Bits 56:52 of each guest-physical address are necessarily zero because
>> >> > > >   guest-physical addresses are architecturally limited to 52 bits.
>> >> > > >
>> >> > > > Rather than split hairs over something that doesn't matter, I think it makes sense
>> >> > > > for the CPUID code to consume max_tdp_level directly (I forgot that max_tdp_level
>> >> > > > is still accurate when tdp_root_level is non-zero).
>> >> > >
>> >> > > It is still accurate for now. Only AMD SVM sets tdp_root_level the same as
>> >> > > max_tdp_level:
>> >> > >
>> >> > >       kvm_configure_mmu(npt_enabled, get_npt_level(),
>> >> > >                         get_npt_level(), PG_LEVEL_1G);
>> >> > >
>> >> > > But I wanna doulbe confirm if directly using max_tdp_level is fully
>> >> > > considered.  In your last proposal, it is:
>> >> > >
>> >> > >   u8 kvm_mmu_get_max_tdp_level(void)
>> >> > >   {
>> >> > >       return tdp_root_level ? tdp_root_level : max_tdp_level;
>> >> > >   }
>> >> > >
>> >> > > and I think it makes more sense, because EPT setup follows the same
>> >> > > rule.  If any future architechture sets tdp_root_level smaller than
>> >> > > max_tdp_level, the issue will happen again.
>> >> >
>> >> > Setting tdp_root_level != max_tdp_level would be a blatant bug.  max_tdp_level
>> >> > really means "max possible TDP level KVM can use".  If an exact TDP level is being
>> >> > forced by tdp_root_level, then by definition it's also the max TDP level, because
>> >> > it's the _only_ TDP level KVM supports.
>> >>
>> >> This is all just so broken and wrong. The only guest.MAXPHYADDR that
>> >> can be supported under TDP is the host.MAXPHYADDR. If KVM claims to
>> >> support a smaller guest.MAXPHYADDR, then KVM is obligated to intercept
>> >> every #PF,
>>
>> in this case (i.e., to support 48-bit guest.MAXPHYADDR when CPU supports only
>> 4-level EPT), KVM has no need to intercept #PF because accessing a GPA with
>> RSVD bits 51-48 set leads to EPT violation.
>
>At the completion of the page table walk, if there is a permission
>fault, the data address should not be accessed, so there should not be
>an EPT violation. Remember Meltdown?

You are right. I missed this case. KVM needs to intercept #PF to set RSVD bit
in PFEC.

