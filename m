Return-Path: <kvm+bounces-61991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C9BEC324DE
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 18:22:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DE3B3A6A0A
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 17:22:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E37FF330305;
	Tue,  4 Nov 2025 17:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QcKaDDsS"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010003.outbound.protection.outlook.com [52.101.46.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028FD337104;
	Tue,  4 Nov 2025 17:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762276896; cv=fail; b=giBbI4Y7hH9JuSl8ozvo2wtCIkCjoiKDoO93/aGPj4hxcqEHlHlePwGlqnPYt3jfgT8rihE6IVnt7ocRRzroOqifVY0khHp1whxrGAtvNS2DACJ4jzNKsG/4+h+kAr2Ey4tYoi/pGPE1uYBsYOJ1V5o1Epa83YYK/rrwYVoZSOA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762276896; c=relaxed/simple;
	bh=BaWCUII8KFPm8OgP01kgg0Tb81fAOtly/XPNjLrKrTA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DJeY+QcfWi5ExfHrRspAHMArBcT89VfViCeKxARkmlNaTyib79YrituWevxEHObS9+icfbBcdEsL6At17byYdLlyZROsM5CT4xvd3NsFsw+M7yWX+6EeT4vIf8iXQvHXjS/lRUpZ9vaZ3WjTxMKDn1A3OYhVhP78L45gSvDAgMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QcKaDDsS; arc=fail smtp.client-ip=52.101.46.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V23mR4tU2B0ymMIm8Ayj1gGMdzOSGcY9jrSiXYzQperHMd8FmtPiwnOd22syfFBYwuGaovUPyJCmIL704vu/qyaT86zZ1xg/CvHEfTJn2qKfy69LKlClySreA5Ccl7lJmlhCGdvy6fdnUqoYRM0SnXaXtgon81ExUGOMJ1J7UBXuyUlgmB2EG2ZRzJNJsHEnJOnWmViV9E0qolZNJ2NK62gbopiPRINC8Y7zOSDHV8Cf31j71Gqx/ccZfE5Gdn+dRa656dmvqggGaNCVyO2xxmCzGHP0bgeLoxkNm7V1t8P+5TBxksxb1ywRHwnTQuQdg6nRzUFKBqu61b8KJqjOvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BaWCUII8KFPm8OgP01kgg0Tb81fAOtly/XPNjLrKrTA=;
 b=JGN+/SVjX35M7qzIbw9/bNq8H9vsiLCJ33UH5aIUO60U8p/FhH1QXqaGszWRJ0IhhtspYurfL7Pc6izyFqLFgCIfKE9M2buJ+yklaCkc8dvQF6UuVmcBq2J8T8mQst9MfCSATlBRKnxCP6XHTdRPDIdInvuR3RfgG59/V65U3eNC3LF9rIEsAUHwsgj/2Pbi6RhEQBWbMzqEsl4rA6fE9Kqyx8kFqvhc6aZ+xGz+0SIP6nJ0w05BfYDfouknbqWSsoczZxPnlkoncwBgJZCDOkww6eO3LVRzv7/8cA39dOIiJ0cCgSbMjBMpQtCHWz5sTQTCz7dEyFL4qdbgLSpJ/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BaWCUII8KFPm8OgP01kgg0Tb81fAOtly/XPNjLrKrTA=;
 b=QcKaDDsSxDrzq4xPPBk7IvlOOhDPSDyBHGlYQu7OtXHmDpZDAPrUVVqiyIAhl7b4dYVtITe16LEqO+LZ1fqVI2aN0aUkeFsWxqRPG6YEMj3MqDR6787K6Ru2Zehqehvp//RkCxuLv104k4J8iM88YHewuOJHoUz5dKlmI+peRRic5aQWKpbikKlV5DLEYvyKrofoySU0qK7lLNZb40RQIg24jZQ51CDid6tloWUhXPIj3WzHoijDxdOroUehSDabytaz5a5OKIfjFwHyzcvNx6WkGOZNSx5B4oQvvCpo42LY05ye7d1iULALlElaEU3wzMVuWzNvFwqMJ/Uvrihlew==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by BL4PR12MB9477.namprd12.prod.outlook.com (2603:10b6:208:58d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Tue, 4 Nov
 2025 17:21:29 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%7]) with mapi id 15.20.9275.013; Tue, 4 Nov 2025
 17:21:29 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>
CC: Aniket Agashe <aniketa@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Matt Ochs <mochs@nvidia.com>, Shameer
 Kolothum <skolothumtho@nvidia.com>, "linmiaohe@huawei.com"
	<linmiaohe@huawei.com>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
	"david@redhat.com" <david@redhat.com>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"tony.luck@intel.com" <tony.luck@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"rafael@kernel.org" <rafael@kernel.org>, "guohanjun@huawei.com"
	<guohanjun@huawei.com>, "mchehab@kernel.org" <mchehab@kernel.org>,
	"lenb@kernel.org" <lenb@kernel.org>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "alex@shazbot.org" <alex@shazbot.org>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Dheeraj Nigam
	<dnigam@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "Jonathan.Cameron@huawei.com"
	<Jonathan.Cameron@huawei.com>, "ira.weiny@intel.com" <ira.weiny@intel.com>,
	"Smita.KoralahalliChannabasappa@amd.com"
	<Smita.KoralahalliChannabasappa@amd.com>, "u.kleine-koenig@baylibre.com"
	<u.kleine-koenig@baylibre.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] mm: handle poisoning of pfn without struct pages
Thread-Topic: [PATCH v4 2/3] mm: handle poisoning of pfn without struct pages
Thread-Index:
 AQHcRoOUWJnftWewAUixSPYj9sJbdrTWte8AgAHBIgOAA3w5AIADW2ZmgAIB0YCAAI6SAIAAgeYAgABvJ8g=
Date: Tue, 4 Nov 2025 17:21:29 +0000
Message-ID:
 <SA1PR12MB7199A46AD4CE574F5200A5A6B0C4A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251026141919.2261-1-ankita@nvidia.com>
 <20251026141919.2261-3-ankita@nvidia.com>
 <20251027172620.d764b8e0eab34abd427d7945@linux-foundation.org>
 <MW4PR12MB7213976611F767842380FB56B0FAA@MW4PR12MB7213.namprd12.prod.outlook.com>
 <aQRy4rafpvo-W-j6@tiehlicka>
 <SA1PR12MB71998D21DD1852EB074A11ABB0C6A@SA1PR12MB7199.namprd12.prod.outlook.com>
 <aQjy0ZsVq7vhxtr7@tiehlicka>
 <20251103185226.fea151c58ce7077b11b106aa@linux-foundation.org>
 <aQnXYsPR7zkV_ram@tiehlicka>
In-Reply-To: <aQnXYsPR7zkV_ram@tiehlicka>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|BL4PR12MB9477:EE_
x-ms-office365-filtering-correlation-id: 8c9f8999-81c8-4202-8959-08de1bc69772
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?jkl4ZX+YiQAW87TZAdx5tNg7vQPCxZLX9sGx5xxcB4s6hCqLVIrV886MCC?=
 =?iso-8859-1?Q?/8o8n2njaS6ZbTqdlCGqJqHvgg/ceib0uxyQgvQf1LAfEbM3HsEqn0jqdN?=
 =?iso-8859-1?Q?30vZBg3hjhZ4HAQvZtf/0fIyy7oaRuCTK8taurFM8IaD06idGFpG3HheNZ?=
 =?iso-8859-1?Q?vfdWLO26jYyOU9gkj20+oWwIjr95wtElmFTkfIJVr8NRFl2/VLMHNjZrLN?=
 =?iso-8859-1?Q?qSqyecWmMI8LdzhC9BaWuJsOxGQix6HRC0xJbD+rBe8FfdIkkudLb1xLoJ?=
 =?iso-8859-1?Q?bvkABTnyjJLU4+4vp3LM9krPvfLvVydFZ+qsUAPvWRx3uwIbKd9XBtFZic?=
 =?iso-8859-1?Q?+CvBrF2Yj0OwMzNFUC3x8sKeAUWabmh29Cpql8aOsGdkkldwzu8mYRIfBB?=
 =?iso-8859-1?Q?gRU1XtRoLU1Dq2pA6al11WhPOlIE8knpvQZrT4+RpL1YbaRteCnOIm0UXf?=
 =?iso-8859-1?Q?6bfyOad0Gl8omyVMpn956y7coGS7owQi8C8oLXxLVlkZAi4/eOKFjrwpWo?=
 =?iso-8859-1?Q?vmE9D2kUdcgTvQMMQUxgFJLb1J7U4ssnG6Tx73sxeaWYx5aKTwxvxttSNP?=
 =?iso-8859-1?Q?ICD9dxSWSkZo5TzgKbrNQl27XFlxnE7BhZ5sUQ4cu7CNUuYl/ZkMTU6PSy?=
 =?iso-8859-1?Q?VoKZVb4KCcbETX43vKI1ROWdZbroNtCst7AsjvY21sNEbyuD9BYlD75zVz?=
 =?iso-8859-1?Q?hN7lqf913MNctkNo670ARYPszDqkG4Ia/F6kuo/4JQboQ2JsrFFR2plfju?=
 =?iso-8859-1?Q?DFp0kQtRh38n/RLufsnt6pOFkHzyWxRpkSkqfqTwEpvl+2uGFugJQrXX+k?=
 =?iso-8859-1?Q?G6d/jazcNlsu3PQFqhQdnBIyRhjiw8mi0nUFlvmgcHIr81pPAwcwUYQGHj?=
 =?iso-8859-1?Q?0sxjP+YUkKVpnBHuRENkBcarX4QyOpXGNBvGU4EH5kU6+R72kvUYfIAAqX?=
 =?iso-8859-1?Q?WAHdKGsjFwXEFxF0msuKliW1YoXY6zfZOPTHw6S0oIpZLrMB/7kI81Vlx2?=
 =?iso-8859-1?Q?7Et8ziJDchguKVG7WWZ9LhSeLjKkwCSjaaCx+uXTiKJ+Uvb6o2Tj3gow2r?=
 =?iso-8859-1?Q?ySqEs3s11jLBzHFNDqsM4vZiB2sPIihLZ52aMii6SjngrVhekkkPmfl9/+?=
 =?iso-8859-1?Q?Hirjpe1S8U90QZIfSrhJ7FL4JQRZRX1YfzoNm665z069+MaThlOCaYkOXn?=
 =?iso-8859-1?Q?AGVgGRaFlzOdm365Xo5PzX3vMfwQAjaY5gpgLZ1i2F8oWWyhAY720tXibr?=
 =?iso-8859-1?Q?VpwbNFb56S8sL8PS9UuK9KAzjSDQirasZiDizebSBPPgkSegQLZqDT4Fq1?=
 =?iso-8859-1?Q?whiFaOwhSY3iksiVEx1s4FY5FQJjfseC2OJRgPZreZhMYlRY3Av9ZVQwFI?=
 =?iso-8859-1?Q?ecRwF714uqndNyannn7jd5hEePGRuMqIPQr3ukWzAo+jVxfHv0Br5ISDFh?=
 =?iso-8859-1?Q?RceiHoJXO4sfxxt99DKpzhZjL3sNcvG8V0s2CZPoYXfegH58/81PzC8Fet?=
 =?iso-8859-1?Q?aVKYFLmwQ5RQpTIlbUQlOXcW3m+h2ZvBoj4y1EI/AhLWpZwapaC/icbXpp?=
 =?iso-8859-1?Q?pHTDsgEU1WBHSjZRznziWZXkHBA/?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?/3SCakLceFm3DPRN6fjXg829gAeTh3t2pJyT+feYWs9gNV2jGZDAenyMLg?=
 =?iso-8859-1?Q?ARPA2EFjvM+rxBYRgXFEqv0JzwtYavezV7SgEJMDPE2NOAnYSdw4VsOm2W?=
 =?iso-8859-1?Q?LuROohs4PTgkjXUaf+c+Tv+/J+LbQCxJIaOHyUkjNyoGEcZW5ssnu6Lxv4?=
 =?iso-8859-1?Q?kEGVzL02aEE1k/qnJqAKzuphZg1khq88iYLl5WoJ6BsQoPGai/pa+/m38c?=
 =?iso-8859-1?Q?vfWCn//M8UJHFm0AwXkQtZRjWYiwt4P/eMcJ4uA8lS4y+cLhfTI0bgYimK?=
 =?iso-8859-1?Q?c6lUdg5z5VYzrteZfIe8l/83t++NI4hD2+zgWw+5ws51T+Ps4cQHxmjkyU?=
 =?iso-8859-1?Q?bOqKpefvxKD4n16d951lo5KHUr68C5NRoglb7Nyhy5o8IIyeFaAHPgcGAj?=
 =?iso-8859-1?Q?rej1oxFWlAN3OSDSGlUX4J4L0BkpRPWNizqOdFBEyRdJeHiDOgbMtT/Ok9?=
 =?iso-8859-1?Q?RgHAjDgroW+HDWtBhKymu0twnYxNKP1xBetK2ZnLyvv+6UtwnYK2QtyqD9?=
 =?iso-8859-1?Q?W7qkIXWoVNr01O1D1oBf6ts1C/TCSY58rQVxM4BFRbIko5lNjuytNZPheZ?=
 =?iso-8859-1?Q?vrJ5q381SUHYQ6yOIKXJpLltfsgAGhFYrJqEIXIp5JiASEItYT8KBO7fo2?=
 =?iso-8859-1?Q?eYdOLDddsRvC6Ku44rff95LY/Cbyu67/voRzZj2yD+jN8UKMUD+DmOHGUF?=
 =?iso-8859-1?Q?A7BmBgJZmHxDYhMvCiZxV+xnDWJI23o/PWqseqb2RDYqaFc10V532eMgHK?=
 =?iso-8859-1?Q?dg1kWQU0c2gjwUKBEK2RU8BO0i4KZgeN65T5jk+VbxxUdtNB5XoHX1EA+X?=
 =?iso-8859-1?Q?InGz/DaBGtJNU6Uyo6MzeTaGDDt2m93Df3M3z8emDLdWiBoDHflqULnKDm?=
 =?iso-8859-1?Q?yjoXAVHlNDK++1KEXhgoLi7DqKPvpA7Z9IzFasK/YIcPdnkQ6EJGqNcjYM?=
 =?iso-8859-1?Q?AGROv+Sc72vFEMX9+vNl9KeC95KxcngAX1K4U+xxHKW4aDfw4JcCuWChdj?=
 =?iso-8859-1?Q?ReIhBOnapO+zudTp+Y1cqNYKyusey5lHFDVgQo4ygho4OI7+L3B7YuJffB?=
 =?iso-8859-1?Q?hywsShJBH++LNYFsV4TQw+ZkrkZNVm5qsIo9fsht9f599H1RruFtwDHXy0?=
 =?iso-8859-1?Q?KDBbOYf9nEN2pIzQUPHVGUsXRLMycW4JxPGIsHm9tt9bsSu18aWmbSguK9?=
 =?iso-8859-1?Q?XyCrkJ341KtiWZGjxnauJam+4iHpzbSsEcy2syr6+bXs6uICJxk7IoAEVf?=
 =?iso-8859-1?Q?Ri0U7qaBA37bjg8+jwBeQLi0AmKG+im5HBckBblaTFLktxnHBubKRqc+hv?=
 =?iso-8859-1?Q?CAbGIxgPYl5gXugl+R7JraiNs5xOeErQI/8nSPvV17XP8wc9FRzu5PbooV?=
 =?iso-8859-1?Q?B/eg3SRx42Sr+o58qmqbrpMfzPAsE6PMJh0yJnIUcl8jZVDAKwYxXB45Iv?=
 =?iso-8859-1?Q?WBv+pXh6hvZBPguSqPdKfR4VyMN7sZCvqsC8tZGboI2LExy69uBWhipOHW?=
 =?iso-8859-1?Q?jeri9rrRy9u4tKL//2PbHHo1mf+Epby7q5FCQO92yhDr3aj8NmW8ZBUOZl?=
 =?iso-8859-1?Q?ICRrlHpw4JJbXDFQ62yQeHIB1eXWvt74mGCzmPcvxJpNUYt0AlSca1KkjR?=
 =?iso-8859-1?Q?akXFmGChFwCDo=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c9f8999-81c8-4202-8959-08de1bc69772
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2025 17:21:29.1508
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2PTWNQBN26MwNLj3jdjMGb9gdHgpdG/LKgPztnR87qSIUcY8Vdf6CRdxUEcLO7nXQHXm5aN6Pz7XcrDAHHxVQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9477

>> > > Hi Michal, I am trying to replicate what is being done today for non=
-PFNMAP=0A=
>> > > memory failure in __add_to_kill=0A=
>> > > (https://github.com/torvalds/linux/blob/master/mm/memory-failure.c#L=
376).=0A=
>> > > For this series, I am inclined to keep it uniform.=0A=
>> >=0A=
>> > Unless there is a very good reason for this code then I would rather n=
ot=0A=
>> > rely on an atomic allocation. This just makes the behavior hard to=0A=
>> > predict=0A=
>>=0A=
>> I don't think this was addressed in the v5 series.=0A=
>>=0A=
>> Yes please, anything we can do to avoid GFP_ATOMIC makes the kernel=0A=
>> more reliable.=0A=
>=0A=
> This could be done on top of the series because as such this is not a=0A=
> blocker but it would be really great if we can stop copying a bad code=0A=
> and rather get rid of it also in other poisoning code.=0A=
=0A=
Ok sure, I'll create a separate patch to cover that and do the one-by-one=
=0A=
process kill. I think separation might also have an advantage to isolate=0A=
regressions if any during verification.=0A=

