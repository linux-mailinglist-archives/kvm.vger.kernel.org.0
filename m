Return-Path: <kvm+bounces-14485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C94588A2C25
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:19:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88D6B284F66
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C09DA54BE7;
	Fri, 12 Apr 2024 10:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d63cMzGz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BDE548E4;
	Fri, 12 Apr 2024 10:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712917119; cv=fail; b=QPE1Ufq0TDiRcsi22H7Ver8H/C78y36AV9M1BU2q/6FSfUPlyuiqaqLnUhY6H7tAQoi9eA6t1gVgN2RZ3MzykOe0+SdD2JZ1CaI7ezLMbRhApBsY1SCuCpPmVJuq993iDvnhjpgu8xYhd87SyeItuzrgyypCcQpNYlnLL+2yTM8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712917119; c=relaxed/simple;
	bh=vsv10Re5ucHx25edWFU2BC2+BDno6+4qqJTCbwlg5r0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QRPp8wSGFcAA3h5L/QwcapiWJu8gpL26CBl8TqmOygTxXwWMEpQRqmaK1oYE4J/up/C/dqEVUlSzOZeNxvTSydZgAGsP22EJcQltIUKAbVvM9LtSJ0xbPWbdbRT3A+ZKFosrvzPYinHjofde4KcL7OasNfNnc9EcGNycvNphhXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d63cMzGz; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712917119; x=1744453119;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=vsv10Re5ucHx25edWFU2BC2+BDno6+4qqJTCbwlg5r0=;
  b=d63cMzGzeW95uRYfMLOKuGUipZBvG27ZyUfILcq/jqYQ5gUX12KCkv7C
   G23n7V4Wkk2x0G7ZgSBtASW/Vl8ZXVz15Kd6gINdC0hPi8fHHdBOKv+5p
   c/0cc2Jhx24Cgh1oBDHrBu8rj+bnN+1eFZrSgEhc0M+mUEm5/OoOj3YR6
   g9QcEfz/KRg5xZ3a08a3cghdvZHRuIiylUCrqn8qqTdLr5GBgKvwH7abK
   N8WzD3kN9sy7NS2TrrnuYTb3rb7+rcfci0QdyZKXTcHV/dHada1xrWqt6
   rQNRQKeOh1xT7e5J4L2ig+vhXPjxhw4A3Wh9bEzPc5wdJumrqROrCmM1G
   w==;
X-CSE-ConnectionGUID: FkYcAcKwQ36HDIl9loaxUA==
X-CSE-MsgGUID: 3EF4BHPKSlim3hCmfiXAJw==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="30848529"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="30848529"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 03:18:38 -0700
X-CSE-ConnectionGUID: Seof4BHYR0SBaJaexK5bHA==
X-CSE-MsgGUID: SYskY7RITMKIkpn6BoEH3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="25869167"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Apr 2024 03:18:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 12 Apr 2024 03:18:36 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 12 Apr 2024 03:18:36 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 12 Apr 2024 03:18:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UtHjh8n56rKBtHPsNwrhVDKyutViM585aVONgZDCmylVrzJsvPZuLlMR8Gnse0OO/DU/aBL4GEpUJzLQE0oUeXFpqlHh3T+Sps0W36w8pYcE5ns5zMVAEbf5/eFFLMn6y2bDwXrGA97H6w56BIaQHFC2IwV/uPPqItXAtPQffU+ea7hfXZHGuo/yy2xd9n2+K5mMyLTWSoIlB2Lqwtj7atH4Y4W80mR6qZ71pp2QF6BKnj3c14L/2A1gaxXVFKydo3cVYj4LWsAfUIcKYMQ3k0eh/AvdfXwuh8+semh7KcLej5fLSFjN+cwUU7bq3guu9QgYiy2a6NYEj2/5/XVS3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uy8qpfZItsqM68JWtfDHbjOvZ+w7VlckBy7Ed4F6UPQ=;
 b=hacB2ux2XF48lZRvsdV8l3uWNqUiOHzle0rPcPy5D2l21dE9PZ190CsLx4jUqfRRsHw63h09akdkq6X6VZJvMw1Zv4e+BhmKh6ScdNXpLszNnqfVrEfYD/bd6R1eLZYarH6uBi0JoOIJVTcERR4HmPUJKxaVZKr7ePtotRqr923XQdebixvrs2Wwo4GCm9hVlqoxVXSjNc3ByHdLF8vb12otga470cs0EjoK7Qat/uPxumDwr8nMVYjMVV0oVM9aVJ+wgyGvy6aNFtoEGO2W+/ODflB69kpYwUQSX8VLd0fjOP6929EE8/o4nbPIzkqLdcmKMAJUS+G3gd7Hh7LZHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ0PR11MB6720.namprd11.prod.outlook.com (2603:10b6:a03:479::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Fri, 12 Apr
 2024 10:18:34 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7452.019; Fri, 12 Apr 2024
 10:18:34 +0000
Date: Fri, 12 Apr 2024 18:18:23 +0800
From: Chao Gao <chao.gao@intel.com>
To: Jim Mattson <jmattson@google.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<daniel.sneddon@linux.intel.com>, <pawan.kumar.gupta@linux.intel.com>, "Sean
 Christopherson" <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, <linux-doc@vger.kernel.org>
Subject: Re: [RFC PATCH v3 01/10] KVM: VMX: Virtualize Intel IA32_SPEC_CTRL
Message-ID: <ZhkKb+lgPDNRsYXa@chao-email>
References: <20240410143446.797262-1-chao.gao@intel.com>
 <20240410143446.797262-2-chao.gao@intel.com>
 <CALMp9eR294v_2-yXagKR8HM_WbqihJ5JcRwD1NTGvJxsOFsnyw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eR294v_2-yXagKR8HM_WbqihJ5JcRwD1NTGvJxsOFsnyw@mail.gmail.com>
X-ClientProxiedBy: SI2P153CA0016.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::17) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ0PR11MB6720:EE_
X-MS-Office365-Filtering-Correlation-Id: e02d17de-2dbc-4150-435c-08dc5ad9e8fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: swh3ocQz1kDkv12bkfaQKcnWytJo662bXtfs8ZHrQew3GjBJMPNrTvzCYuW63T9TxvPPn5cvWAR6Zy545py2fQKGJ65+P3I2BytKNTIshMLpQ/op1M0XiTjso+9aX0muU1WbYssuJqSUTs86KhIECQVZHmzLPqMpa3ZE7bIvxQxrrwFenvy+43aGewvHyxcHoOgTIdtsxJUMc7hcGA+eAy0z4gZ+X5GK2fdgRvBLnMNOzSh4UbIsbiVPBige0vOMuTS+3NNZyHQY4J3UY7xVCgUouHrATkqrYagQBv9gA9jb4HDWtarg2s2rSAUknhN7IbIMB4O+xX5Wi4iTDw8TL0NBWBivKruDlDODs8cqWNRoAV3EJZfWEnUGZxymAimbpfHrLIAu3b6ylPn6ticTeCW01TWu8Mh6BBK4uit88NYfDvKX3+6UmVNSpHC0oyYokNkF3Y3lSjOceBXhRfdvHOhGXwTm4PQCFuzzCzGdN3rRNhzgoOo6q0OJ+T/aHTyNYmsH1M5AcEfdfj3R8QAYn2M/TDNwVOHkgDWLMDXxBlyzZ44elBQQz03El1t+oK/Zz6JZzNs8JgD935F19BORyeiltlKVo3C4j8cC55ALwkUv9J9RaBhHKSH/t5ORETHnZouWCevdmHIGIoSS+H8eTzRYpSefMqXU+tWWQH61hbc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SS9DZGdxZjhSRjVoNmxkamR5VWRKRUU5VjBwWVpVOUpTN3hER0ZyRjlxRmVJ?=
 =?utf-8?B?Mk80aEdFQ2c3NFFxWjEzZ0MwMjR0Y0x6dXNCTGlIQ3ZJTU5uRzJNcjBGWE41?=
 =?utf-8?B?TS9lV29rNWN0NkdVQlBuQnBjTGdzeDNFODlpMDhYSUVDV1lhSWplVHlqb000?=
 =?utf-8?B?YU9OdVVjTEs3dlFWSVVNdnFyWDFSUXEzYno4RlUxcEdQbFVIS1pKUnlkck82?=
 =?utf-8?B?WmtNdzZsZ3JuZUhUTkRPSVZWdm9WRDV3cDBqbEpYdlZrU1BXUFlCUVVNc3VR?=
 =?utf-8?B?RCswNTl2UGNQcXNPMElpdnBKVGNyWnp6cXdQZTBYdysvMER3QlRXdmNtZk5K?=
 =?utf-8?B?WHVJNUlSRjR6L0diZit4SE95dTlHWHp1em1oZWxkbG5xZy9IeUZDWXFoZHZN?=
 =?utf-8?B?bUoxUVJ1VUFnUEtlTzlISlAyaldPSTRSZjRTZ1pTOFU2aS84R3ptVW1lT3du?=
 =?utf-8?B?QkFhN0NJdys1aGVZamRZRkZkY2tMWWk2RDhVTS9pSXBRWFRON0FKNWNiS0ZU?=
 =?utf-8?B?a3paN0duK2VyMUZyYTVMK2tQd0tBYSs0dkZlZnpjOFFOMVN2dHk3QkxQUGNy?=
 =?utf-8?B?cjlTSHFPajQvVUxidVNMN0EvOUlhdHdPVXlkWi80ZkVIS3JFUU1kWkdMNnNI?=
 =?utf-8?B?UXlEVWZTN0kxb3R5T1cxeG52UEVKTTk4L24yRnROZUg4RXZsWXdZVTR1Ly9X?=
 =?utf-8?B?bWFRRk9WdUtLVkdrQWVRbzdVTEhHckIrWDA4ZTh3Smg3Mm5Ic0NTSVdQRkJG?=
 =?utf-8?B?Yk5vK1BnV3YxQW83eU5YK3VsY3R0Z1RQdmxRa3lPUkIrZk1JZjZWVVJXbGZQ?=
 =?utf-8?B?N3ppVWVWblhjUGlkMTEzMm1VaWYvQzhGQ2ltNlh5aStyU01jRjBocnNmV1Va?=
 =?utf-8?B?MUN6NDFmaW9ZdjIyQndVWHpPM3lrZUgxcUZ6NXJNOVBOWEhieUJveFZaS3BF?=
 =?utf-8?B?c05HMXlCeWtEdmNjNHFJTGV0TE9hcUlaWUxCNWg1cS91eTg2bHNpSjJ4WkFP?=
 =?utf-8?B?S1E5bVRpR2xKbUJuWE9aMklwaWIvalcvWGpiWnhEK25hcWFqelcvdzdkTW9F?=
 =?utf-8?B?L2Y4NXpmK0lKTFhnT3hoZGpzQTVydjZNUW9CM0xYRXYyYjFvN25PQXNvdCtH?=
 =?utf-8?B?ZjQrYUdiVWM2S2VvQ0ZQT3lPZllFQXlpOVFmN1dNTytTOXNSbGpJMlhnWXRT?=
 =?utf-8?B?NEpQVnBxeGYyRnBBU0VGM3JCUXhWSGExQ3ZBY2t5TUhoNVhRWDRVZ2dBSnRE?=
 =?utf-8?B?U0RnbWZNTlpXY2V3WGRhbGk0WTFNQmt2ZTdJaFp2VmtuZEY1MmZXZXByOTFB?=
 =?utf-8?B?Ri9pc2g1UEFSQ1hYUkJZNk51RC9BUzdUaG5sV3hPRTRIWVc1ck9sSGpJd29x?=
 =?utf-8?B?SUNXeE1jeDMzcWZCU2oyVVFxWGNLR1lwYjNkZmNYMU4vejZnL1QxRHlmYTQw?=
 =?utf-8?B?NHNBeFZmelFESVRpOVRGWHhTU0V1VXV5bk9NWGJpdW5ObS9yZGJ3L0hWL0hJ?=
 =?utf-8?B?bUVneUtuUTdrVW5mUFh6SUVoN2o2Vm9WUlNvNWZ0M25mY3B2UTF4WWZHVkpz?=
 =?utf-8?B?b1hXWjlMM2MzQytWWXpOZm0yaXVPOGFOK2VaWllEbER3dkhhaTJHbS9TcEQr?=
 =?utf-8?B?U1ZCazJkUEpGd0Fxckt0bytjK1paaFJhbVRFU3g3U3ZHbCtlODZhTjZEdjk3?=
 =?utf-8?B?ZURIMFZUL0NFblpQWWladW11UFR3UUFSVU1RNkZXcit4NW9KNW1ycjZyY1Fu?=
 =?utf-8?B?bkx4TThLZEU2S2hFb2EvanpseS9WSEw2TGFaRDUyUE5oM0RLRE9FbVIvNkxE?=
 =?utf-8?B?OXcybEJjVHA3d3FBaTdlcGZaQzRITm5hN1p1MTRiVHRXODRZMmtsbXlqeHJR?=
 =?utf-8?B?RzR6ZjMvZnRqZmRoNEY4d2ZhZXQrUEJFZnNMSURhYzd2Nm5yZ0swc1NhWlJj?=
 =?utf-8?B?RmtaSHgvSXBlV2Zmc1UwUXlGWWc2cW9pcjlvMi9jUTBPYUx2dFZHeGtpMENB?=
 =?utf-8?B?ME5LbjJaVEY4OHFKblZVZnVVcXZzemRCZ2FhZUtkTGppNnlYU0Z4RElwZkll?=
 =?utf-8?B?TVVFNzlHemJBMEZJZ2FjRG05UHd3K2lvNTZvSmtWMGhMOXpBRC9JeWtpK3E3?=
 =?utf-8?Q?DVS7MWNN4Q9p6yl92alaIqf/L?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e02d17de-2dbc-4150-435c-08dc5ad9e8fc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2024 10:18:34.3958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uTlCEuiIut1S3gXoeH1wYwxKLOQaZ4RuVr1U5pxYbI1QUMhsaYcdA63meDBVFRGWWwj0QmtFEUvsr/hgjr53ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6720
X-OriginatorOrg: intel.com

On Thu, Apr 11, 2024 at 09:07:31PM -0700, Jim Mattson wrote:
>On Wed, Apr 10, 2024 at 7:35 AM Chao Gao <chao.gao@intel.com> wrote:
>>
>> From: Daniel Sneddon <daniel.sneddon@linux.intel.com>
>>
>> Currently KVM disables interception of IA32_SPEC_CTRL after a non-0 is
>> written to IA32_SPEC_CTRL by guest. The guest is allowed to write any
>> value directly to hardware. There is a tertiary control for
>> IA32_SPEC_CTRL. This control allows for bits in IA32_SPEC_CTRL to be
>> masked to prevent guests from changing those bits.
>>
>> Add controls setting the mask for IA32_SPEC_CTRL and desired value for
>> masked bits.
>>
>> These new controls are especially helpful for protecting guests that
>> don't know about BHI_DIS_S and that are running on hardware that
>> supports it. This allows the hypervisor to set BHI_DIS_S to fully
>> protect the guest.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Daniel Sneddon <daniel.sneddon@linux.intel.com>
>> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>> [ add a new ioctl to report supported bits. Fix the inverted check ]
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>
>This looks quite Intel-centric. Isn't this feature essentially the
>same as AMD's V_SPEC_CTRL?

Yes. they are almost the same. one small difference is intel's version can
force some bits off though I don't see how forcing bits off can be useful.

>Can't we consolidate the code, rather than
>having completely independent implementations for AMD and Intel?

We surely can consolidate the code. I will do this.

I have a question about V_SPEC_CTRL. w/ V_SPEC_CTRL, the SPEC_CTRL MSR retains
the host's value on VM-enter:

.macro RESTORE_GUEST_SPEC_CTRL
        /* No need to do anything if SPEC_CTRL is unset or V_SPEC_CTRL is set */
        ALTERNATIVE_2 "", \
                "jmp 800f", X86_FEATURE_MSR_SPEC_CTRL, \
                "", X86_FEATURE_V_SPEC_CTRL

Does this mean all mitigations used by the host will be enabled for the guest
and guests cannot disable them?

Is this intentional? this looks suboptimal. Why not set SPEC_CTRL value to 0 and
let guest decide which features to enable? On the VMX side, we need host to
apply certain hardware mitigations (i.e., BHI_DIS_S and RRSBA_DIS_S) for guest
because BHI's software mitigation may be ineffective. I am not sure why SVM is
enabling all mitigations used by the host for guests. Wouldn't it be better to
enable them on an as-needed basis?

