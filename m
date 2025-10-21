Return-Path: <kvm+bounces-60700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C4E0BBF7E0A
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 19:24:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 47F2E35831F
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 17:24:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECA203557F4;
	Tue, 21 Oct 2025 17:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BOFh7J1b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46F034F259;
	Tue, 21 Oct 2025 17:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761067160; cv=fail; b=ovw+LUwd8n3u9XuAlo2rWF7O/kok+JTuKKm5sAwavIROl8yPHbx8vsbRRPMGjP1dXDJbRpc2kgbu7YFWJ99ohYR9nXlC/ZJUkt7/6lxLyCLo2/lOHMPniOOVnw+58jZzik7fUpW06Za8dSkQLCzxuqDfz7slG4LEYRnz9ZDv6AU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761067160; c=relaxed/simple;
	bh=4az3NHJ2y/23eeSTe5OVwX4bdf4Vr/2sEl6jU2AW73s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gR3EGxYDPwW3tIE1OzLtv59g76HascUzGNxxD2JbtNfKTtQmfdzD0XV84L94/uX1l58gijDcsjCUHAOt4GRae2tgZu4I86wXPUBxKnrXfiZqofFgM0HJwP1cYAzSX30qcgxqhuLRHTqSCxd2ILX5s0eoWVcq2lnly67ght8priQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BOFh7J1b; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761067158; x=1792603158;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4az3NHJ2y/23eeSTe5OVwX4bdf4Vr/2sEl6jU2AW73s=;
  b=BOFh7J1bbIuVTMdAnlXEUc9hXFP2n0SifyK3G7bLU/lrwKmr4lvpUxXX
   WD/mY9v3K1eorCbZuVwL7do64Q6lSEVC8Kd9tfswtTk8YzAGR0i4yftwr
   h0aYe/lQjdI68K0QXcggHg3VVNmyQHeegl6shqcmePyEFkNptx864ETgT
   WM7Oe+lhh/BLdP9Y+DjTjQBVEx5CgOYozj98UM2ZrdNIlRoFJkxMpJy4k
   kgSxUJnfDYGvtcY2AowzZBSGGtYSTaZ2h7mSm2HzjZLKTjd8B+wLRm0jd
   5exRUGUDNqF4bGZ6VJ6HhTQq3MZNhnHcUkTLMQaiNn+xhNZvUxcLWRXup
   g==;
X-CSE-ConnectionGUID: jFnWF60bQZmrW010A7NC/Q==
X-CSE-MsgGUID: +9LseSJMQpK/VzvUd1p5ZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="62409369"
X-IronPort-AV: E=Sophos;i="6.19,245,1754982000"; 
   d="scan'208";a="62409369"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 10:19:17 -0700
X-CSE-ConnectionGUID: x4RnHE38RHy4K8o6PBIWNw==
X-CSE-MsgGUID: scv9OtqnQwWtsZJCTM8kDA==
X-ExtLoop1: 1
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 10:19:17 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 21 Oct 2025 10:19:16 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 21 Oct 2025 10:19:16 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.28) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 21 Oct 2025 10:19:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xWf23ru+kxZmrkas18L17UgYu7T2SE+aRxhs+gzPJct3N7AV1T3b8zOOEKXkX3C43uAF7xLLfdNz8vQwOzRdN0NAbn6QST81sFJhvZJQND0jDvodtRkSEqm4SmJY/+VthFCYuLvTAYuMBRJ6uCi+VbbUOolFb5k+vn04MxpgYSvVbX89zqCLbC7NOF3hWBj6SmM5JOPn7SN0cThu8cpJXq7JXMfDvIcVgGgxl+XryFPbyrvNKAQTOAoqifyZi21FYlvemNm3dilsY6Vm9vjatlY8IE8DmSLTmGQTrg1Q+t75CwkckORlUXAJ3EnquuVac0i4DdsJGfUBTxSveY591w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t+9xBgreifDlDSQrwHUpv3AcKUKe/s8ad4gc524H/js=;
 b=uVW/8GtknoJFsEesvBbdfVASj3ka5ft8MB2BQ099Ok46IupBcseOscolKFM9eSRjOXlbzZGIcPFtWxwCWBAfL5nYAIh1rln0pBspkbeAaO0LnbpGbeQj9TULvvJBdGSDehmqWkkQspc25+W1p0YwI3Klr+a8wR6aBkICyGn4TbWEAN3C/4XXNZjHFE7Zrrluxh0Y4rLad29YNaFe5h8E6dYutAqt3QgLiuTuPBoZW+qxHKoITOXuUZO5icR0B986UdEExFM+DZlvQV6u25WyW/3GP2EN8qYoiZHDTm0NvCgk2fa0gtMvijCwAUy2+GVcC29tSXdvgxgre3cinReohg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA3PR11MB9040.namprd11.prod.outlook.com (2603:10b6:208:576::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Tue, 21 Oct
 2025 17:19:14 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9228.015; Tue, 21 Oct 2025
 17:19:13 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Weiny, Ira" <ira.weiny@intel.com>, "ankita@nvidia.com"
	<ankita@nvidia.com>, "aniketa@nvidia.com" <aniketa@nvidia.com>, "Sethi,
 Vikram" <vsethi@nvidia.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"mochs@nvidia.com" <mochs@nvidia.com>, "skolothumtho@nvidia.com"
	<skolothumtho@nvidia.com>, "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@redhat.com"
	<david@redhat.com>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "bp@alien8.de" <bp@alien8.de>,
	"rafael@kernel.org" <rafael@kernel.org>, "guohanjun@huawei.com"
	<guohanjun@huawei.com>, "mchehab@kernel.org" <mchehab@kernel.org>,
	"lenb@kernel.org" <lenb@kernel.org>, "Tian, Kevin" <kevin.tian@intel.com>,
	"alex@shazbot.org" <alex@shazbot.org>
CC: "cjia@nvidia.com" <cjia@nvidia.com>, "kwankhede@nvidia.com"
	<kwankhede@nvidia.com>, "targupta@nvidia.com" <targupta@nvidia.com>,
	"zhiw@nvidia.com" <zhiw@nvidia.com>, "dnigam@nvidia.com" <dnigam@nvidia.com>,
	"kjaju@nvidia.com" <kjaju@nvidia.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
	"Smita.KoralahalliChannabasappa@amd.com"
	<Smita.KoralahalliChannabasappa@amd.com>, "u.kleine-koenig@baylibre.com"
	<u.kleine-koenig@baylibre.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v3 2/3] mm: Change ghes code to allow poison of non-struct
 pfn
Thread-Topic: [PATCH v3 2/3] mm: Change ghes code to allow poison of
 non-struct pfn
Thread-Index: AQHcQnTQsdTtPwE0dE6ADFK/CsyF7rTM1xKAgAAAnPA=
Date: Tue, 21 Oct 2025 17:19:13 +0000
Message-ID: <SJ1PR11MB6083BF0885BC19E715C1A96EFCF2A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20251021102327.199099-1-ankita@nvidia.com>
 <20251021102327.199099-3-ankita@nvidia.com>
 <68f7bf2d6d591_1668f310061@iweiny-mobl.notmuch>
In-Reply-To: <68f7bf2d6d591_1668f310061@iweiny-mobl.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|IA3PR11MB9040:EE_
x-ms-office365-filtering-correlation-id: 7190e753-c0ab-4d9c-ff28-08de10c5f4cb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?YZUBzGM1B/+pJ9jotXHHsvZw0aYx/ue6B9vWl6CFrk+Kamf+BehyIOqK1m9z?=
 =?us-ascii?Q?QZtVUm2PWN2h3zTKiFisnHJRZk0BiMln9XVUCW4mOKDxt254p2YbNyJG6XH+?=
 =?us-ascii?Q?Ems9zNPp67SOnQ+oIqHsrUgS0Yhge4N9v/fBngZshS6QSgy2HHfq41kUb9XR?=
 =?us-ascii?Q?ceWJkRZpsGcKI1lSduEoNnUpqsE0Z02qJR18fbI6hvbdPZR9vJ3LidnY+AR/?=
 =?us-ascii?Q?qbUYWSxCOG97whKlKS5Bl0avearXDyzI8yj9c0TfKTUiZoABE5dksh11mlE3?=
 =?us-ascii?Q?aOPwvaRmKxD6QVyvkQVXzMsed/AeUS9cZBZG5seD2qnLKNOFhB/o+5i2jeFI?=
 =?us-ascii?Q?Gz9AlH1KHbiuKtnc25wMffUBA8vbEyPJ+aDQPByofauQ4jucibbuFJGBudyv?=
 =?us-ascii?Q?SMoKQKJy/B0zoHQh4CvcsrccpvPaSgzoMy3U2hZklpfEF4pFGSh9qr84PwQr?=
 =?us-ascii?Q?0jltRjDCacNJdGbLIe9mq9h54FOXb2RTTrUk1cWWzZp+6fv6VIQ4etrqvNqK?=
 =?us-ascii?Q?ubIBV9lYrIBLiK/99Vm5dFHF3BV6b1TNBa7L0wMAScEJJ2xy5dO2fcvozPEJ?=
 =?us-ascii?Q?IMMxBlXRRHUZi17/2BxsD+YpWKblF/+g+WxX12RtkGoap/1cg9Ka4U7GegTs?=
 =?us-ascii?Q?cE0ZKpH5aCBhM2jvCEc1jL2he3huaJAEYA8l3iPfMwutHY2gx+VWM2/BOOLg?=
 =?us-ascii?Q?EdphZBBj0tM8iwgQLQJmoH3svhw764NDQ3uCT51cSMHoxybpZS/zKoPWtZUO?=
 =?us-ascii?Q?v8Lgw2ObStEPahJGo4Pr3KpAboJ9urXEVq0Cr/i3ghHkitXTacMpQkrDX2bU?=
 =?us-ascii?Q?7e2N3RI4IblmtJF7T0CquGhAWUHLFl4cKb0BQIDWz+RkiEY5e8IS3pTN5lix?=
 =?us-ascii?Q?6fo3k6QN6pg295d2qjyLklZHzsDf+5YCP78bxEt01p9dlRjh/bfQf6J6dru9?=
 =?us-ascii?Q?HO/1cL8t/6H96yNxZ2Q/O2SokUiK81sleeC15zlctr9RXEoIHnKXyURh3zH/?=
 =?us-ascii?Q?b3/ASYHAaWG1BOQsiKjS2smumh/FmSPOiAltEARCo9uVUEhVJsaZlaWxQBOY?=
 =?us-ascii?Q?uBO+nu14KaCxzZBbx8vvrQFvF6AfxfGwQDurvodwklRZ4BA+eXePtGVqsGtG?=
 =?us-ascii?Q?Mh0R/CP8b3eeN5PuHHOuCgLmUFE157+hZ15R9vavUVbyXX9fjv5PRW9aPKVH?=
 =?us-ascii?Q?ALEtRfkduHiGz/4Gc7TelQvh5qmi2RJg2LHvXDBEcJHvrELB+4O2r1sWP7sb?=
 =?us-ascii?Q?Jgkr3gPEkRf4DCZus23PZ5uIH9ldwB99KS0st5fk9DpGaVQ7uxzl1IZUvVw8?=
 =?us-ascii?Q?qpmYAYd9Rqs7Tj+r152YY76MTzTuT/L46wvwi2mFmm4hjuu0ay2l7jOpKys/?=
 =?us-ascii?Q?2e020XwIyUSiEiMHWXUM5h6dIEIphQmoGadRHEP6ascEMSJQ4KExVBp3GPWE?=
 =?us-ascii?Q?n+n9zHMwB+wTZAtbZMnmiOr/LZ0j/ltv/zMgysxx7HCBiEWjE5JU98xVEHmG?=
 =?us-ascii?Q?Hl+MzG9+xhldqZbwHo3OoOVccGB5h+5TlyQj5bB+SSbd/8HUhmrU2LiOqA?=
 =?us-ascii?Q?=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YrzWFBkjVR9jaYLQvPIfiegGT0QT3Z9aMVUoowjcpXX2lSm/NQIGOYmqbR/y?=
 =?us-ascii?Q?b16QrhzMyuwKGvbDF8oAqQu1nlOxpI/SAhAvP3Ii8udHpMz/D8CJdzmsYAWc?=
 =?us-ascii?Q?aZLRHPvU7kZeGw866sq5aCmud1/uY4iLLUlmt28VX92FdNl7bZCA5My1H+V7?=
 =?us-ascii?Q?RNZgTc4QVH/6fHj2FgjsYrvtoG/hsYYeB2xKFTyGycv/TkxogHGzhjhFGgNE?=
 =?us-ascii?Q?vq2569V+KQ33sT8V4fb98k6HpCbUDii7z0yBAFgEtBzU1s3J8x9iQG93ByIE?=
 =?us-ascii?Q?QqHEgQme1HXUVhsDYjoCMpHFhEI9KC206MkDUr2DH+BfrYXrQNQ+rjdZpyXf?=
 =?us-ascii?Q?ILhZpXIlunxV/eueZT1KbpwjqjgIFDLmVM+AWrAoCzH6b04gCk1NqmWmKl/9?=
 =?us-ascii?Q?aUW2IEzheMl9nQL5p6CwJt9/gB7NTOgjvBmZKCiJk/g33t9KBvWoJCYYQX0k?=
 =?us-ascii?Q?C31dYolRDW+XJzni7whclc4M9iGpNpPUSSbvs0r24XpCBib/8DQXVukxLHbL?=
 =?us-ascii?Q?TUDFI1WD19eKJwTCYb3dwREPXWlHIyqCMku1iUSO020KHhYH5+pdmgQN3Kz5?=
 =?us-ascii?Q?mPmwnZU6o4VxmNHsQSEd7JX5KFc2Gxp03BdLwExfKleT8BZ51VzK9I+taWS0?=
 =?us-ascii?Q?OTrdO4GdsuiTB055pIBal8elJPvIo30IGy00m6rPvd1IVCVdKYXi1QW3dheQ?=
 =?us-ascii?Q?YwVMDh2NmRva84cnnItuvEvGVR7XxT/xm//MAmJlyNkEC9+LtxRtFzvFmM1c?=
 =?us-ascii?Q?GmuaiIb2hPvIrw/bl0NCTHGHMUn7+SKk0B9oeWMl4mmpDtUfyWG8uPtGw/fz?=
 =?us-ascii?Q?Zi/xHQvlrrs4xDHzjPKWl+bLPrQ2LBjqUz2Z3uiToWM/Jc83BFLcfW/B9Q2M?=
 =?us-ascii?Q?99gn8+6IwcncJo537q+sbVvSK38uVk2L4+mADqgOLuQrPqztwNlaPF5rMQ22?=
 =?us-ascii?Q?fqoNPWDDHNTX+Rt6Ce1x9DYy7aLSiYD3Kh4JbED/miyLy663jTTyzpKmJ7Q4?=
 =?us-ascii?Q?EtP9iyD4Yu4nx8LSj7ecSs9rd+F7CHq57ILfy/ZNt2tLerZVyoDjzoYULUXW?=
 =?us-ascii?Q?yV9IMopbf2pR57ZlrZXZqrRL63Vk2h09iICfvGg9xwJ1wOxzecukdhSfT3v0?=
 =?us-ascii?Q?zFmNLpphnAVBoJiC2ZzuNJ8drak57FRFDH1kJ1iETcjKTwoSKymrSWgoYwSO?=
 =?us-ascii?Q?D9XWrfO+sJtNql1wwME7S6Hu0ZdhipQtkLWkpr/6yT62nHuT6PvSoD+xZGxZ?=
 =?us-ascii?Q?56WQPzN7JujkPN2GM6RMjKjEHrJw2/BOgepomxnrjhfJnZRkTFzwwg8FajB8?=
 =?us-ascii?Q?XmN5J2NirgnU1DK2xgTiv0ZUNc8JD+vxQhlqOtxIb04MQIrdtMrgyw3gnpyp?=
 =?us-ascii?Q?VnQOExRftx/+8eWPgWKqOkHsKHqIkgpY04llsFOxTdBp2OboLqpdyNRlIfap?=
 =?us-ascii?Q?V2naai6E4VsQrGmzbysSutelXl01u3O1YN91d3G+Z1LfiB74mOKWrAFqEsoo?=
 =?us-ascii?Q?bp0GeOmP+QzLexpen1vr3TgIFjVGB+ZzOzEIqO8uTSDcfemjuUV3yz2A2cmN?=
 =?us-ascii?Q?0sQ1hXjOiZ6i+XHst9w=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7190e753-c0ab-4d9c-ff28-08de10c5f4cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2025 17:19:13.4722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gTJGp8UwJ/UFGBiXSwY+t1jU63FZrdzYhtlYKe9igQHb7K231TloTWsq4iYpINdXnuVkb1PcWllMIfQw9p1qfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9040
X-OriginatorOrg: intel.com

> >     pfn =3D PHYS_PFN(physical_addr);
> > -   if (!pfn_valid(pfn) && !arch_is_platform_page(physical_addr)) {
>
> Tony,
>
> I'm not an SGX expert but does this break SGX by removing
> arch_is_platform_page()?
>
> See:
>
> 40e0e7843e23 ("x86/sgx: Add infrastructure to identify SGX EPC pages")
> Cc: Tony Luck <tony.luck@intel.com>
>
Ira,

I think this deletion makes the GHES code always call memory_failure()
instead of bailing out here on "bad" page frame numbers.

That centralizes the checks for different types of memory into
memory_failure().

-Tony

