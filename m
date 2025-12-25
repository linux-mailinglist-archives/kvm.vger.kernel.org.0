Return-Path: <kvm+bounces-66685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E85FCDD806
	for <lists+kvm@lfdr.de>; Thu, 25 Dec 2025 09:30:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1D4563009860
	for <lists+kvm@lfdr.de>; Thu, 25 Dec 2025 08:30:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A9EC30BF6F;
	Thu, 25 Dec 2025 08:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C1ilgiAz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEFF757EA;
	Thu, 25 Dec 2025 08:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766651447; cv=fail; b=HNtYlL7AaZ4xKiCl+SxPeszszOriKBCVyuPwZ6aMJs5/sLhZqh1XvO2BmWkWJsLgPypufQnROoDO4B9sqKYzPAJkwCKFBab1g4IEINx4sIOqcDmKletgkQY0/S2jMRa8m0Ki4KlTZua9lkPAr3ijOlmMlnE6bfaitAoFIjrOpQU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766651447; c=relaxed/simple;
	bh=lsBIMGuVLCI9duASjsk9PpfnIW6jFMLc/spOFzaQQP0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YuGlGmTeRtJ23w35UAMexEwilkjse8RoRMjmnT6RRrw425I3LtQRNohMoPRrGXjFfcZhgBYPfbIDBD64CC1/ptnI6joqmnbLl2vYCU+avvS9eqszhK1jhZsviLGBqk3DUHTfUP0b8ijLp0WqweQkkSE/fgAqri0b1l5mJ7RG56M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C1ilgiAz; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766651445; x=1798187445;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=lsBIMGuVLCI9duASjsk9PpfnIW6jFMLc/spOFzaQQP0=;
  b=C1ilgiAzeBq32BcKGDBiXSO6PdQKwAMB0ZwYH2vee+fvv88LhFjxcUUb
   DaexqXTIxLsfqePENmP1L3J7AAZfob3RMDQ2WqSqQhk45UrX40z1SJhOc
   9JNhlL+F9Q369HmcQzmrRpGGKXVSNtTjBz7kzMC568mhWkBDnxZvDK65J
   lGQ0XItD7lzb9c+E6qawL7lZ599KFxFY9gN+ekze6trAL9oFNqOWvV5Zp
   xcV0owd5PAGrrJhLWY1DObAfP/1vrJc2Z1fxsLoZVmr08dqo5wgR4YGV3
   KHdjnixGWtmGhnXLmXtticoKkfqFWGUpuCMI8BXfMPp8eIEfcbeqNamzm
   Q==;
X-CSE-ConnectionGUID: 7Cy+/bQbSG2eHgAp0tyE3A==
X-CSE-MsgGUID: DD5ExZ4wRd+BgmtcD2U7pA==
X-IronPort-AV: E=McAfee;i="6800,10657,11652"; a="72087243"
X-IronPort-AV: E=Sophos;i="6.21,175,1763452800"; 
   d="scan'208";a="72087243"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2025 00:30:44 -0800
X-CSE-ConnectionGUID: kEs+VEcvRxCYlUIqzF//dw==
X-CSE-MsgGUID: eJQDtcBCQMKyit36Ny3BYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,175,1763452800"; 
   d="scan'208";a="230839832"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2025 00:30:45 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 25 Dec 2025 00:30:43 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 25 Dec 2025 00:30:43 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.49) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 25 Dec 2025 00:30:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=huaQez78vyJ1vrytsuvMpV3scv52gY1GVk/nPK3YdQ3e66G1PMhYudH/cI0x/BzWZUuWwrABTF2vMp515TXAEd6dOp1Qy/4j4KCbz0ufG/9tYIO0Zqcz9C9ae9o51s2hyVtGEj/HBUQDn3xLM3bnT1AO964Zrx91r8sJp1qnjf7fZPI4NDd9n21c7mZV6bBO2dDz1mBC+9cxMYhLTN/xFatQjOMHTSJfRjoS1MUB3jsHnKMGsNPzbJ90S5LY16DaEi6PrxgwAUA4kGEhMAYPaMcKHxpeLr0HZ4Gk/++PSsWXIjuAHQrednVyNwlfnBRcEnFNVhgO1cu5ACNl14zKBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QvvGo017EJ7dK7WKhukq9EH9hN4/j1/J7SfBSDg/GcQ=;
 b=GL+Yh5x28nP9ts+Qx0NGfTK/Ths+9WwTScgkoqjbSY3nFSCryDi748pBFQqqWrEKKR+RAFzJGJ/5rFZ70Wnc8dtHltM64swcnMXoeHwOoud5OL1mh89ZW1rSGGFBha/UqpU8LSJuMXIckiyWBRK4xm7JogrP7KfzPGv9oB0f1vkbl9EUhwrK45bzG1py1GOCvJE7URZ7alLGholnE6xHKdxmwNQcoRA/QL/GrJhczDj5MZECTmC4LNWNoctc8NbJR+m+fDAznDq+V8B0AmlcVAdJCc4N95PoAA2OZKhvLtANWbF/D5JYDtPzFXodJrALJx+tfhSDosPriwMaZkagoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA1PR11MB8199.namprd11.prod.outlook.com (2603:10b6:208:455::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Thu, 25 Dec
 2025 08:30:40 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9456.008; Thu, 25 Dec 2025
 08:30:40 +0000
Date: Thu, 25 Dec 2025 16:30:31 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Dongli Zhang <dongli.zhang@oracle.com>
Subject: Re: [PATCH v3 06/10] KVM: nVMX: Switch to vmcs01 to update SVI
 on-demand if L2 is active
Message-ID: <aUz2J/cK2PN/n0of@intel.com>
References: <20251205231913.441872-1-seanjc@google.com>
 <20251205231913.441872-7-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251205231913.441872-7-seanjc@google.com>
X-ClientProxiedBy: KU0P306CA0079.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:2b::8) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA1PR11MB8199:EE_
X-MS-Office365-Filtering-Correlation-Id: 2251ed93-5863-49bf-d998-08de438fe315
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?DarlWejgs4JX0vYeLg5S9hi6a9E9aBpvLRY+9cWfm1hlCLtAhY5yCKYpRAxN?=
 =?us-ascii?Q?fka07nU6wcEatlj4akmJ9Ieu9UsPzi2J6cuojUrWb0aZFHm+k747TX47YsTv?=
 =?us-ascii?Q?X+pYT/CYFwguKJ1pwshk5Wp5fpf3O3okQ1Zl6rWy7EGvV9LfHcbDs0QKQaS0?=
 =?us-ascii?Q?3Y2hzf5bZS1REs6fw0mbg9qdTsaKOQ0KIQGTyVrGmLh8s0izo10MAfXdS0m8?=
 =?us-ascii?Q?RwE0noU78SYjBNj9L+K7scn4wk2LX75phA4bL6EW63DS+Wz9nXwi4vBBMDJ3?=
 =?us-ascii?Q?yb9MzWp9GuvZKSgnI8wDFqlaRHOfUvgMlHSJyKgDUw0ivZ8eaty1RV8OU90v?=
 =?us-ascii?Q?NkfOONe5aD3dWh47T8gMQLlgRLsJBIJjfpWFK+6Z9Y57MdxTAnNfMEHaDb22?=
 =?us-ascii?Q?9zMu4WiOKud+i08rdryj/h4ybEMmrQM0HkSuq0vE3pI42211+DNrWhWy1H83?=
 =?us-ascii?Q?H6Qo9PMnQarupO+sPEIZ+Dv9zvOcF3IpU/8bHBDrgUsRVuYYpRb2XSYwxogS?=
 =?us-ascii?Q?srY/LQcO19thwMSMOkci4KcrwG5wx6fh+KWuw9nV2CBnBMsssijwrgjt/Vcg?=
 =?us-ascii?Q?ItRleby8WVaqGsR5r3XbOllgk2/IntdXGodwuR7G91t7twfrT3vVeIcZMrc1?=
 =?us-ascii?Q?U7Ke9YQH/ifCvPtQ5bKjRbzsKYf/3HDqx/NxAjCAq+NYcgZmdu14NL8Dy96m?=
 =?us-ascii?Q?BihMAzc1bk7VeukjAV3KB8UsskfpplhV6IH9zVArMp4kQd6Xsjik5FhIeDmg?=
 =?us-ascii?Q?91srZPvAzzxrU4saPA0VZq1uX54DwtWqybUCoDV0LR7cYy9ylNRFy+jA+D39?=
 =?us-ascii?Q?KgXaqAjaWGn57NalfZ9o4qpMaTrnJlZiSUrdXuEhMdy+5fBVUYLjXmE6amz0?=
 =?us-ascii?Q?XwkyxY7Oi0SvI6clF14pJpyGV7KrKZYDhPl9wt8GROj3sdZC3DDB/KH6PaAu?=
 =?us-ascii?Q?qficUiVYvGOYbFpNKgfu/UoKUUDddW7OzMjkwE3TqcQ7DWX9ycLqfhMwmZWJ?=
 =?us-ascii?Q?efyMqItgAYWpZB51lps5P+lI7ael+Q4SyfO6MjvTdEU726Zh2q1XqUzQkDYp?=
 =?us-ascii?Q?rZ4M0813b4BMnbXH8Dlc7sskbK3IFZVzM3X4L2SvvGCg019vjp8r/0DE0Nx0?=
 =?us-ascii?Q?IqKn47PYwuhuqHOKgmhFBoM9DZ2MlDVZ1zt9wnTyRMeJFlc2ysGP6pNpCd6Z?=
 =?us-ascii?Q?KV+EN1hC2qfQ+KU1Hs9IPPOs10oJpr/9xAzIfQZEj2QYI3cCtOQcOVPejLUW?=
 =?us-ascii?Q?kPQEjFfQzufnBso8z/9gA5duat0KTyJSFzD7/5piLEulQZJ2HNx3rrU69E0b?=
 =?us-ascii?Q?oXbrNeJlnJmB1ThSaGpj2UpUOBxTtWBvusDQUCEAcluXw/f2OVc5qgLts2FY?=
 =?us-ascii?Q?VWBB6Ok9cNXXc78aQckntmQblgh49YBEzHAOZuvB05wXs3LTsyN5zmJLxaGn?=
 =?us-ascii?Q?VXbaJ8o5cZGRqtu5wfAJTPRPed3Zcxknfz7uVpbCW86xOQlLOPTq1Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4c42f4Ug8Smz+y2xJCmRrSeuodpY492JqYNPjRBsq6O3omYdlpZneCFmVqek?=
 =?us-ascii?Q?nXjRZ9+3hTJSz9AqTnyrwyteUbvuqNLdoTDZb1MEXFKTLME0P8a7YbdeuRer?=
 =?us-ascii?Q?+xDZFQbXOIqSr/xQcRuIeb8YJ1VwydVc3AwuwvSrDjnpxKMk6/EXh6WslaQM?=
 =?us-ascii?Q?RK4vFow0ARY4fNUPoq8+xSC1SKQ/Ff+8OM2Kwc/6t3oDva2KTEp5P9jQpaPW?=
 =?us-ascii?Q?gaIpVPykS/X8HsevrHNYmV+AWPYDk/KRCouh4kfQj17VlvyjG3aoNXZ4usCU?=
 =?us-ascii?Q?EH1WWfONJCDz8BAbACIoesPeF5arER8QefaPtdij6rfeSM49NncLM53PIDHS?=
 =?us-ascii?Q?19g9ZIVRTYe+AXhL/qj2ICG87yu9ICBk7dGBMm45GlTzEB6Ks6McIvB1N7WS?=
 =?us-ascii?Q?Egicrw5hHp40IcxcGvHJuMEm5D1yolB895XNxyj7RLCTg1damh7GiIzabv1M?=
 =?us-ascii?Q?S6SHqkCDB1dIX9Z/iZ+/4z3baJHTswT+tpY/PBf8wzPZOyEC/7qZGJ+evnJI?=
 =?us-ascii?Q?orMGsK/do2NFAKR6wj5C0z3exsAOFeL8pgHtSAE/JWmiKi+kbI9YJFm4yQlu?=
 =?us-ascii?Q?kOsdWuMi3UXyN8f0pXk2oprT9hxRepESwmOWmSlL+Gbxug81uKkpLkLPDbYj?=
 =?us-ascii?Q?TNFs2UT15nYSd8Q7z6C0UkMZ5RvyV1OX8bSUygTppPH2X48ZCydeNkN0Ssq1?=
 =?us-ascii?Q?yzlwROY6KF1Utn1UcBHfAXtxuv0g7ok0SCsXWkeMZtFfBP1ZoQsc9FhFTHAy?=
 =?us-ascii?Q?H7oKf5um+ncLVMXo7/zmU2MyTpibj36j5QhYBXmtsDhtIu+MpmSUstUUz0zx?=
 =?us-ascii?Q?NXMP9t4nCM2OlWLREZTRFMNgiPDgqQwRX9Rl5ZqAidmYjKG178bLxRPTZZv/?=
 =?us-ascii?Q?BXXphTzIm1YVPKlzZDDf0IlA7Ji2v/MvvGzsxw1M5ypKxRVxeaPXT8IUY7ER?=
 =?us-ascii?Q?DZ/EwtKxf7FrWFDywlF8+sXPjzbDbjY/YT0+eEScFa5o+FtAXvr7Y4gGQsLb?=
 =?us-ascii?Q?9C7ePyN+5sniEHLlVRaY5kD/vnAMlB21RC+Tfw786IPU4BY6jWsIH6FZ0d+l?=
 =?us-ascii?Q?gYhzphpLcwkzz0s4dm/kONxkQGMLlZqXMxXLWcZMgHZQT/OfFNpDZ5I2Nnvc?=
 =?us-ascii?Q?TgMWxBwjkRQnsg+69h1Clp19QyfGB/5NX2ZKSpeHV1GjwY9XZwiiMF5Mk8c2?=
 =?us-ascii?Q?mavDW+vEiTJnHMJlp4YSg7zu5/8s9Ke86dNlLeu0ZnGpj6I5LwXEKs0jjZab?=
 =?us-ascii?Q?04PRamfAp8qeNEaVUD0WYDUCpC8NDVsMHUSdbxQEGe5QGc/7A01VA2hpdWyO?=
 =?us-ascii?Q?dQb4rh0RzoAgqmgNeN82urRsx3AwUzAXFWl7b2Gx5SG7BaUStJMsC5JHS6f4?=
 =?us-ascii?Q?bpYv/3oyeOOUpWSqMEtAH9F08A7NYCdhYbGCMM82ZtR+iEaOFIHi9ug0kE5+?=
 =?us-ascii?Q?suIeGnXeeH3bA1srLr/914PlsldVLNt7/ZgMQHd0gYJcLkoV1H0GVuJk4yhx?=
 =?us-ascii?Q?5TKXF9vSwCmCXUNvMS/qXp3f1w7ytSiG++1KSyB6N4W4IOAgPZED9690h3Ue?=
 =?us-ascii?Q?Aw8fgGfJvflNSW/l3S5thYS6lZ3w4dZTEbv82gvAF02RaofuRuygeQ2vVUEA?=
 =?us-ascii?Q?1d8JTF6CgifzPVfm9XL8GJWcZJvwkHgBvV2WrEyp7EmiolAOzRROcD5ECp1F?=
 =?us-ascii?Q?Uf1fZ+aIccjn8f7Dww+fovi80KyqSoW1bPAaS8YP4q+u6oE7mmjB5iJqezdd?=
 =?us-ascii?Q?+rtnb/l69A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2251ed93-5863-49bf-d998-08de438fe315
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2025 08:30:40.4282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WL6sS1krKbKVSO+I77NyOWh0wUNN36yD9+txNTm5C/eqaaSbVZZcYZQex5+0Sws+Rj+ogjq7qIWv53vPOykhdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8199
X-OriginatorOrg: intel.com

On Fri, Dec 05, 2025 at 03:19:09PM -0800, Sean Christopherson wrote:
>If APICv is activated while L2 is running and triggers an SVI update,
>temporarily load vmcs01 and immediately update SVI instead of deferring
>the update until the next nested VM-Exit.  This will eventually allow
>killing off kvm_apic_update_hwapic_isr(), and all of nVMX's deferred
>APICv updates.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

A side topic below:

<snip>

>@@ -6963,21 +6963,16 @@ void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
> 	u16 status;
> 	u8 old;
> 
>-	/*
>-	 * If L2 is active, defer the SVI update until vmcs01 is loaded, as SVI
>-	 * is only relevant for if and only if Virtual Interrupt Delivery is
>-	 * enabled in vmcs12, and if VID is enabled then L2 EOIs affect L2's
>-	 * vAPIC, not L1's vAPIC.  KVM must update vmcs01 on the next nested
>-	 * VM-Exit, otherwise L1 with run with a stale SVI.
>-	 */
>-	if (is_guest_mode(vcpu)) {
>-		to_vmx(vcpu)->nested.update_vmcs01_hwapic_isr = true;
>-		return;
>-	}
>-
> 	if (max_isr == -1)
> 		max_isr = 0;
> 
>+	/*
>+	 * Always update SVI in vmcs01, as SVI is only relevant for L2 if and
>+	 * only if Virtual Interrupt Delivery is enabled in vmcs12, and if VID
>+	 * is enabled then L2 EOIs affect L2's vAPIC, not L1's vAPIC.
>+	 */
>+	guard(vmx_vmcs01)(vcpu);

KVM calls this function when virtualizing EOI for L2, and in a previous
discussion, you mentioned that the overhead of switching to VMCS01 is
"non-trivial and unnecessary" (see [1]).

My testing shows that guard(vmx_vmcs01) takes about 140-250 cycles. I think
this overhead is acceptable for nested scenarios, since it only affects
EOI-induced VM-exits in specific/suboptimal configurations.

But I'm wondering whether KVM should update SVI on every VM-entry instead of
doing it on-demand (i.e., when vISR gets changed). We've encountered two
SVI-related bugs [1][2] that were difficult to debug. Preventing these issues
entirely seems worthwhile, and the overhead of always updating SVI during
VM-entry should be minimal since KVM already updates RVI (RVI and SVI are in
the the same VMCS field) in vmx_sync_irr_to_pir() when APICv is enabled.

[1]: https://lore.kernel.org/kvm/ZxAL6thxEH67CpW7@google.com/
[2]: https://lore.kernel.org/kvm/20251205231913.441872-2-seanjc@google.com/

e.g.,

---
 arch/x86/include/asm/kvm-x86-ops.h |  1 -
 arch/x86/include/asm/kvm_host.h    |  1 -
 arch/x86/kvm/lapic.c               | 24 ++++++++--------
 arch/x86/kvm/lapic.h               |  1 +
 arch/x86/kvm/vmx/main.c            |  9 ------
 arch/x86/kvm/vmx/vmx.c             | 45 +++++++-----------------------
 arch/x86/kvm/vmx/x86_ops.h         |  1 -
 7 files changed, 22 insertions(+), 60 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index de709fb5bd76..69aa64aa9910 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -84,7 +84,6 @@ KVM_X86_OP(enable_nmi_window)
 KVM_X86_OP(enable_irq_window)
 KVM_X86_OP_OPTIONAL(update_cr8_intercept)
 KVM_X86_OP(refresh_apicv_exec_ctrl)
-KVM_X86_OP_OPTIONAL(hwapic_isr_update)
 KVM_X86_OP_OPTIONAL(load_eoi_exitmap)
 KVM_X86_OP_OPTIONAL(set_virtual_apic_mode)
 KVM_X86_OP_OPTIONAL(set_apic_access_page_addr)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5a3bfa293e8b..de57a90dac2f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1824,7 +1824,6 @@ struct kvm_x86_ops {
	const unsigned long required_apicv_inhibits;
	bool allow_apicv_in_x2apic_without_x2apic_virtualization;
	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
-	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
	void (*set_virtual_apic_mode)(struct kvm_vcpu *vcpu);
	void (*set_apic_access_page_addr)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 7be4d759884c..b0c87fa68f2a 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -715,9 +715,7 @@ static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
	 * because the processor can modify ISR under the hood.  Instead
	 * just set SVI.
	 */
-	if (unlikely(apic->apicv_active))
-		kvm_x86_call(hwapic_isr_update)(apic->vcpu, vec);
-	else {
+	if (likely(!apic->apicv_active)) {
		++apic->isr_count;
		BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
		/*
@@ -761,9 +759,7 @@ static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
	 * on the other hand isr_count and highest_isr_cache are unused
	 * and must be left alone.
	 */
-	if (unlikely(apic->apicv_active))
-		kvm_x86_call(hwapic_isr_update)(apic->vcpu, apic_find_highest_isr(apic));
-	else {
+	if (likely(!apic->apicv_active)) {
		--apic->isr_count;
		BUG_ON(apic->isr_count < 0);
		apic->highest_isr_cache = -1;
@@ -781,6 +777,12 @@ int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_lapic_find_highest_irr);
 
+int kvm_lapic_find_highest_isr(struct kvm_vcpu *vcpu)
+{
+	return apic_find_highest_isr(vcpu->arch.apic);
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_lapic_find_highest_isr);
+
 static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
			     int vector, int level, int trig_mode,
			     struct dest_map *dest_map);
@@ -2774,12 +2776,10 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
	 */
	apic->irr_pending = true;
 
-	if (apic->apicv_active) {
+	if (apic->apicv_active)
		apic->isr_count = 1;
-		kvm_x86_call(hwapic_isr_update)(vcpu, apic_find_highest_isr(apic));
-	} else {
+	else
		apic->isr_count = count_vectors(apic->regs + APIC_ISR);
-	}
 
	apic->highest_isr_cache = -1;
 }
@@ -2907,10 +2907,8 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 
	vcpu->arch.pv_eoi.msr_val = 0;
	apic_update_ppr(apic);
-	if (apic->apicv_active) {
+	if (apic->apicv_active)
		kvm_x86_call(apicv_post_state_restore)(vcpu);
-		kvm_x86_call(hwapic_isr_update)(vcpu, -1);
-	}
 
	vcpu->arch.apic_arb_prio = 0;
	vcpu->arch.apic_attention = 0;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index aa0a9b55dbb7..6242c8c7a682 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -127,6 +127,7 @@ int kvm_apic_set_base(struct kvm_vcpu *vcpu, u64 value, bool host_initiated);
 int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
 int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
+int kvm_lapic_find_highest_isr(struct kvm_vcpu *vcpu);
 
 u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu);
 void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data);
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index a46ccd670785..73dd74efcf9a 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -282,14 +282,6 @@ static void vt_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
	return vmx_set_virtual_apic_mode(vcpu);
 }
 
-static void vt_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
-{
-	if (is_td_vcpu(vcpu))
-		return;
-
-	return vmx_hwapic_isr_update(vcpu, max_isr);
-}
-
 static int vt_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 {
	if (is_td_vcpu(vcpu))
@@ -953,7 +945,6 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
	.load_eoi_exitmap = vt_op(load_eoi_exitmap),
	.apicv_pre_state_restore = pi_apicv_pre_state_restore,
	.required_apicv_inhibits = VMX_REQUIRED_APICV_INHIBITS,
-	.hwapic_isr_update = vt_op(hwapic_isr_update),
	.sync_pir_to_irr = vt_op(sync_pir_to_irr),
	.deliver_interrupt = vt_op(deliver_interrupt),
	.dy_apicv_has_pending_interrupt = pi_has_pending_interrupt,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ef8d29c677b9..e7883bf7665f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6957,45 +6957,20 @@ void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
	read_unlock(&vcpu->kvm->mmu_lock);
 }
 
-void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
+static void vmx_set_rvi_svi(int rvi, int svi)
 {
	u16 status;
-	u8 old;
+	u16 new;
 
-	if (max_isr == -1)
-		max_isr = 0;
-
-	/*
-	 * Always update SVI in vmcs01, as SVI is only relevant for L2 if and
-	 * only if Virtual Interrupt Delivery is enabled in vmcs12, and if VID
-	 * is enabled then L2 EOIs affect L2's vAPIC, not L1's vAPIC.
-	 */
-	guard(vmx_vmcs01)(vcpu);
+	if (rvi == -1)
+		rvi = 0;
+	if (svi == -1)
+		svi = 0;
 
	status = vmcs_read16(GUEST_INTR_STATUS);
-	old = status >> 8;
-	if (max_isr != old) {
-		status &= 0xff;
-		status |= max_isr << 8;
-		vmcs_write16(GUEST_INTR_STATUS, status);
-	}
-}
-
-static void vmx_set_rvi(int vector)
-{
-	u16 status;
-	u8 old;
-
-	if (vector == -1)
-		vector = 0;
-
-	status = vmcs_read16(GUEST_INTR_STATUS);
-	old = (u8)status & 0xff;
-	if ((u8)vector != old) {
-		status &= ~0xff;
-		status |= (u8)vector;
-		vmcs_write16(GUEST_INTR_STATUS, status);
-	}
+	new = (rvi & 0xff) | ((u8)svi << 8);
+	if (new != status)
+		vmcs_write16(GUEST_INTR_STATUS, new);
 }
 
 int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
@@ -7037,7 +7012,7 @@ int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
	 * a VM-Exit and the subsequent entry will call sync_pir_to_irr.
	 */
	if (!is_guest_mode(vcpu) && kvm_vcpu_apicv_active(vcpu))
-		vmx_set_rvi(max_irr);
+		vmx_set_rvi_svi(max_irr, kvm_lapic_find_highest_isr(vcpu));
	else if (got_posted_interrupt)
		kvm_make_request(KVM_REQ_EVENT, vcpu);
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index d09abeac2b56..ab7349e67809 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -46,7 +46,6 @@ int vmx_check_intercept(struct kvm_vcpu *vcpu,
 bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu);
 void vmx_migrate_timers(struct kvm_vcpu *vcpu);
 void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
-void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr);
 int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu);
 void vmx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
			   int trig_mode, int vector);
-- 
2.47.3

