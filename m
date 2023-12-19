Return-Path: <kvm+bounces-4760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E18C681801E
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 04:11:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57FA31F241BF
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 03:11:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4665253BD;
	Tue, 19 Dec 2023 03:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hquB5yDA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041AE5232
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 03:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702955468; x=1734491468;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=zqiClj6bKiy3KE9AOe7Qo7+llpdW2uE2sMMHnnamjBY=;
  b=hquB5yDAvSnaUztICOGNx4pP+aLmtufHvjf2TYq9JNQLC8DhCTBiOvaj
   RrRbCFPO4DtB7E6mTenWuJnHsX4PrTljj7+zgmr4yUlb9Vmbf1amzKsyC
   b4oiEkbdRaOVw7jc0X3FoqDOXFn+OaxWuY0g2st1SGHHKfNcpi4H+9uWW
   7yAyNQ5gBrKzAMsbhHq7d2iguICmfzCPcIxkOBnb3cY+h0c1soQ0E7aYG
   /TX0UUfCQ+DwV1dutH6eB6dKIOuR/JerxwdtKHGxLzPeQzVGITGggDCjG
   xvtHlMykn1IibyxbgIX/+n9JxUzkdeMN0bFVekKlaFyvnJEsGn/Wd602T
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="14289776"
X-IronPort-AV: E=Sophos;i="6.04,287,1695711600"; 
   d="scan'208";a="14289776"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2023 19:11:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="949022888"
X-IronPort-AV: E=Sophos;i="6.04,287,1695711600"; 
   d="scan'208";a="949022888"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Dec 2023 19:11:04 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 18 Dec 2023 19:11:04 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 18 Dec 2023 19:11:04 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 18 Dec 2023 19:11:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kfWxkoyENn2R8rBBpgc4SN6BTAWC6MqTYkeNJFBcMXOrop8Ivy/yQAEgYGGCJfVjghH5kDoTwKLVs2my4+gIRMc3awdYuZYz0EeYRvLUMsCGKsBkxFbwjB97R7wCaWevboSlau3dDJk+4CWsw5zMRXsUXAFNm5FYcEgQyvkbeE6KXec5Ssp7u2w9NJRrZBs19zO50vSrccMxdNcMQxhV6KLtWCR+/RQaKywP8euMrVvB2SkKpgXUjAIK11vFYP4N9Q0WuCpdugGf0/5QwmVKDzIqxMMahkFrRAzayd5wK6FMLVChO3LuIdlyZLh++DbHK9zZ1+fhXGfSFGQEjmaubA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S0NESPakWNpGnwc/JIQVMZTmQAQzH/NswUgHrrh/NKA=;
 b=hhz6Aaz20+QLBVtZmys0TZL1mnGtoMZfURRUwCzjtJZ9lxOKNLc4DbyTrShtnFG40KkIDNM6bT6To8v6G3ikN7xljJHR3MI6juIRLLoDbAPrkigZwmu/w4mD3WuHzeXcOnpagldcE55ZAe3163fIurpEBriaTCI6mwxeguY/4m7artI/t9xFZwVY8ONTk+nip1nQFsmDZw3VqSIeZrDFbrDdcnT00vXW2NVfpoW5/yc+eoKjnSVsZx9broAgsxl0+UfAGV5Usl4hGUUAWOgKhshVoHWJBSt29VseEff6ARYJh3/cwIQn0mYnpLfrMWdiQw5iNVDPf39obZn/blQyMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY8PR11MB6914.namprd11.prod.outlook.com (2603:10b6:930:5a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Tue, 19 Dec
 2023 03:10:57 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::66ec:5c08:f169:6038]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::66ec:5c08:f169:6038%3]) with mapi id 15.20.7091.034; Tue, 19 Dec 2023
 03:10:57 +0000
Date: Tue, 19 Dec 2023 11:10:47 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Tao Su <tao1.su@linux.intel.com>, <kvm@vger.kernel.org>,
	<pbonzini@redhat.com>, <eddie.dong@intel.com>, <xiaoyao.li@intel.com>,
	<yuan.yao@linux.intel.com>, <yi1.lai@intel.com>, <xudong.hao@intel.com>,
	<chao.p.peng@intel.com>
Subject: Re: [PATCH 2/2] x86: KVM: Emulate instruction when GPA can't be
 translated by EPT
Message-ID: <ZYEJt2mfMLVRZRZw@chao-email>
References: <20231218140543.870234-1-tao1.su@linux.intel.com>
 <20231218140543.870234-3-tao1.su@linux.intel.com>
 <ZYBj1SSFgj-9cCeV@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZYBj1SSFgj-9cCeV@google.com>
X-ClientProxiedBy: SI1PR02CA0048.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::11) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY8PR11MB6914:EE_
X-MS-Office365-Filtering-Correlation-Id: ee09eaa4-3065-44c5-624b-08dc00401dc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mDhommnvl0MGG4hsMP52VUwgSDvcfWtmADJIYgOC17HIhpuBt8apYuTL0Dh7/HiK8PJqIAnJDsGF33QQQu+AVDX5pHtpBb1VdSVsPi3aARUR/Wo2n1JRewkLm/71Yf2/DcC6j6P5Ri++6BC446poSdzORoUGKiyWOWUgUyOpy2DLalYCxsMKhXpVBh1ivbI8E+yqgpVYlV2A4LpPSEc97i9A+5M9ENgZ+J90ghnE+at5ldVm0apCYrci6qqmZn+C6pHgbHc1MIP/h2RTUXhOT0274EKd1StKxSdwCDheGLJztkCOGvC0jifVaK9QCKHl/SjiRZ38yvMAZBAYwmWEeC6CXt+48+J3rKhWmK446yiRtXIOW/xTt1voUqA0yrojRUzjuEjo3QHXRJjmZ8aqS4Fq97NM270DLT7/ZHFNWqv3GJflEA2+isqQOJ7XKZSTIBqxLfVkn7rHNoaST4b97B/Ng0bLspN+bsAJrFozdC0xpcfolwFCEnW+UYC2hFKTDEMkLm1Z5ElpBfNNd5leV+Vy3V3lxgh/q67zfSjUMYHaTbf8n+xUCknf9Qk3d/gB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(136003)(366004)(396003)(39860400002)(376002)(346002)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(5660300002)(4326008)(8936002)(8676002)(6506007)(6512007)(6666004)(9686003)(6916009)(316002)(83380400001)(66556008)(66946007)(44832011)(2906002)(66476007)(33716001)(38100700002)(82960400001)(6486002)(26005)(478600001)(41300700001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?48EQrRWI8X4lcuoDlq/jOVYHIkTuvkLsOyHYyxdDHWxIydGXTNy8kfI5Yyl7?=
 =?us-ascii?Q?rRKCVtWhd2bQcsQNIJTGfOK267zgYT/mCKEjpKAUKQlOieQDT3vuOTiRxVwu?=
 =?us-ascii?Q?pm9I2X+BmfAqkHG3mGNQzdS6MJdf5VOwdpOcBhmd19qGtHgFptifmCkbdUNu?=
 =?us-ascii?Q?qE9KLakuBs2JjzYqu4JVKer7YLCLUcotiUV7G4uGwNlnpPG+R0pNZ76A6fFW?=
 =?us-ascii?Q?5Qz5Tf6NiHENylSxyEUCloxJILxrRAtm/IA0G6V1AaaZleKUcVCYZ141YJwZ?=
 =?us-ascii?Q?n0hFfQvHgjPvulCLyHFwcNH0zEO6kXiJ85eG39gJZ6n+/8w9Q2/lv0FrhrAf?=
 =?us-ascii?Q?TJUk22Ysj1g31MGeKaWkKtnkcvHk8NUt3lUZI7xrT4AUwtAisdueLKJvVyuC?=
 =?us-ascii?Q?OW1ITOHtTnBSWx0liGzNOiNpb7PnF/k4Hhg3nA6gX432gddWXu5YwhS7Nrr9?=
 =?us-ascii?Q?TKMBZXFsOxE7tIGtauYshXssGaEXQfeh7j8j8VPynBojT3YluIo90wpt7GmC?=
 =?us-ascii?Q?Bi1lPauMq0iHShtkQ0ClpiQEZrK4potnspkslEwkUyrchzkYnOTqC9cvMEyl?=
 =?us-ascii?Q?kklRsYtRArUCo9UgWOZwyRkgh0mJt82mQJkvQ1QhFNy0XPR0yLuFXdUxofvs?=
 =?us-ascii?Q?eL/nXi5mEKKqRc3GMINaVdYil+6F7ZSY0bB4ljG8GEhO/HdZJZSUvM2jkGI4?=
 =?us-ascii?Q?rFSNyzePrtyWKpAmHQyX0F1V3H8N8rMMji4wBpTsuPqnMfjF/ttVljpfW66z?=
 =?us-ascii?Q?3FQakSEoO1jBymbuW6UmT8JRS6+/ifZyUHL5fPf5VX6J5bWEhTeZTTTvkydZ?=
 =?us-ascii?Q?WgRn1fdHTi6NZWdfwSpLOZLwmBRUudC/W697B5O3NSwHdHoUyK/hZsvKFioK?=
 =?us-ascii?Q?OF1k1LKAWfo9Ejozg2gAj0kd5AqlA0U/iefq0JUkVbAk4tvwzH8gqRep5mRP?=
 =?us-ascii?Q?ydX+19IcYvqxRb5Xu48JWNMoC+WpBb/HBXdbhWfoL+vEf/VyEkEIF/QB1II5?=
 =?us-ascii?Q?sPGHTu2YUyRi8y4sVmr0/ceQarYCMWAjYfc99Rz/7zM7MX7FvaV/zezhfA17?=
 =?us-ascii?Q?Qsx1rng0jwKXZv7/vGxrs+cVpz1L1XylatKw86GgLUEiz6/yvIgMuouD328P?=
 =?us-ascii?Q?M1IH97mhFld6j+kEn+KbgPuThJ97qpzfD6r+l01UGD5+Z8z0EgsqRAT/yD87?=
 =?us-ascii?Q?4XBxIH5tU2/wy9n65HapwTcXvry7SzZQGHUR5aYoV3AGdyfEVCwL5IqEjLD3?=
 =?us-ascii?Q?174QzYBNdb0UUszW3Bqs6XDhbTa1qnq4LIWTQo0g7msUqGTywGZP13n2x4ws?=
 =?us-ascii?Q?gIUBcX6YNg0SLTFZb6IzbeDDVqthkqGRqN4M8s/rY53Runl80Lyv5WKAYf7e?=
 =?us-ascii?Q?OP5KcLGk6qDcnj0oj3kDI8BxYScwG82ZrviubsIALgweJOUHbUFnnFutjzoC?=
 =?us-ascii?Q?GEvFxM4w3CRp+W7etSdIJ7FqmOjwYOIUDmuGEt9KJTXpX9rm8afN4l+7iSTb?=
 =?us-ascii?Q?bJ273jnUtfxxm0ekgnkwxz2MjtbqxdamDxbrcaVIaXPzQPp0/S/qWGAObM8W?=
 =?us-ascii?Q?U4kZ1o83emWN9xxD6MAjCzDlfgeiRirp5sdZU+sG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ee09eaa4-3065-44c5-624b-08dc00401dc9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 03:10:55.8948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uNS3cBPPvqTmJ6eFASEuQixxloS5o3AlvFL1V2kpxUsfT+fjjIC8YgIaHGitF+Jsct+93J7TcGzkS4gsWm212A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6914
X-OriginatorOrg: intel.com

On Mon, Dec 18, 2023 at 07:23:01AM -0800, Sean Christopherson wrote:
>On Mon, Dec 18, 2023, Tao Su wrote:
>> With 4-level EPT, bits 51:48 of the guest physical address must all
>> be zero; otherwise, an EPT violation always occurs, which is an unexpected
>> VM exit in KVM currently.
>> 
>> Even though KVM advertises the max physical bits to guest, guest may
>> ignore MAXPHYADDR in CPUID and set a bigger physical bits to KVM.
>> Rejecting invalid guest physical bits on KVM side is a choice, but it will
>> break current KVM ABI, e.g., current QEMU ignores the physical bits
>> advertised by KVM and uses host physical bits as guest physical bits by
>> default when using '-cpu host', although we would like to send a patch to
>> QEMU, it will still cause backward compatibility issues.
>> 
>> For GPA that can't be translated by EPT but within host.MAXPHYADDR,
>> emulation should be the best choice since KVM will inject #PF for the
>> invalid GPA in guest's perspective and try to emulate the instructions
>> which minimizes the impact on guests as much as possible.
>
>NAK.  allow_smaller_maxphyaddr is a bit of a mess and in IMO was a mistake, but
>at least there was reasonable motivation for trying to support guests with a small
>MAXPHYADDR.  Fudging around a QEMU bug is not good enough justification, especially
>since the odds of a hack in KVM fully working are slim to none.

The changelog is a little misleading. Even if there is no QEMU "bug" and QEMU
sets guest.MAXPHYADDR to 48 correctly, guest __can__ set up CR3 page table to
access GPAs with bits of 51:48 set. In this case, KVM still gets EPT violation
and needs to inject #PF to the guest (by emulating the instruction).

