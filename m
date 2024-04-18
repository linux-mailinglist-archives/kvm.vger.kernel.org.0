Return-Path: <kvm+bounces-15111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1DDD8A9E41
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 17:22:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2101D1C21196
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 15:22:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92C4616C858;
	Thu, 18 Apr 2024 15:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GpGLMkIt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87F416C688;
	Thu, 18 Apr 2024 15:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713453735; cv=fail; b=qC+flCFngvWZw0M4r6Bv8uCSvuYRgKCRWOtqB3SY6Aiq6am2c2pXqEPDLAhNeyrWQZFsUwkByAm+53HSutCc4NDwRWsIM41BHgrY6FJWzzi7bKGvWJA3H3qR2E557tuAslN5z+51PuexZqOZOj6ywCZV4qWeKTGCyCJ5pg+UIZs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713453735; c=relaxed/simple;
	bh=C2i/Wy6/wNgSSEoBTbi8TZ52Cv3W2rAtaU8ntuCe08g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AN07snx8axWihFVb/XolBHtAXVdB8FTl9dJEEHALh4H3k6N30OWK9tnoUdeUhit1sfYcDYdw7VGkqlPfLLQUqfS7VmjWS9AfuXd7UF4ZgflTjyxmQZM3/dOo1HRx8UVcn4pPMRqHyohOiGxVBc2cpkZXXVxOoDIt9OnQNtvpjMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GpGLMkIt; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713453734; x=1744989734;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C2i/Wy6/wNgSSEoBTbi8TZ52Cv3W2rAtaU8ntuCe08g=;
  b=GpGLMkItqAv7lDf9FsMq4ggPbK3PhYikCbU/sKdsTXwlbef1Kc3LTyg+
   WRrTbcEI5OmBT0RNNDFdYxvISEEeaPOFR9aUvfpieK475/fVPMGcUauEk
   qaMlU+VALDLDEJEaEbgAFdTBDTVuZW/ySifg/6zsjGExU7KR1Kwtohe6c
   kCYN8GQ5loZ7MzfuAu1zAOFO0ogf5NDI+fEhWfh0Bk5aYHPglcNr8/NaL
   54N9B86w+uU6bLEcWLN4UJAdegIJy7X86dcf7pDaeUEHoYPXOD+26FBuq
   hfdrKomDESB5qgpiUjy12nxbEXITRo/puIoR38jCSMXwM8F5gfL74EgG1
   Q==;
X-CSE-ConnectionGUID: kCxcZHPxSGa+4OKFfea5Zg==
X-CSE-MsgGUID: 54HVv2UIRly+yJhJBIAKrg==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="19568933"
X-IronPort-AV: E=Sophos;i="6.07,212,1708416000"; 
   d="scan'208";a="19568933"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 08:22:13 -0700
X-CSE-ConnectionGUID: yJqtLjV6TPuOqnIZWzX2DA==
X-CSE-MsgGUID: QtWn0dZcRgmyPGNS2IVw/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,212,1708416000"; 
   d="scan'208";a="23102074"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Apr 2024 08:22:12 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 18 Apr 2024 08:22:12 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 18 Apr 2024 08:22:11 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 18 Apr 2024 08:22:11 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 18 Apr 2024 08:22:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/EK3wMkdMIpjS5rT7V5lOlsvNcs2cGlGuqoTnoC9YS4maQqvkouhDBgYHRwZDru0DZNXFRIhcjprvmkSecHypl0yXhjTX4jcdfyMPs4SJ2MVyrEfcSJ5/SqLe7tYjO8B+h5XJhsEaLG5440xKnhotCYeK2a+7gYhO3QcGGUQhG85FhTzG9GLALI/psu/TTfT+l51uo21/NotjuEEjqY0JEYUt3fype7joZaG7DaQc7Uds1wjN8H6+DcQcWTu8MtHkqzEEpovZOQoT5/zS/N4BoGtj56kSCPRvbD1g0Fs05Z76tkRODr4dseYmfRH7LaOvfTSuWNEGXUlnJsPG3hDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JnbcuCT6pCYvJ5sFWG/+eJozyyoC6W+COAHYcrNYfJc=;
 b=MudIWS+nJUXJ9M78PjhARIjaYjSoBVQIu0cVTpXwKFw3Ab57BMBRzaEnLOTXbxsqGap9BnEwQvW8+E9jQ+QkxosmgYcK2lWSh2VvIdjAytRkpslONmm5HSkx3h+656m9GCqPaIaFSgsvp9v2KReYaqmmWn4dlsa4RTRL958BShXLHEfyO1d/lQ2o/jSxSlfh+vVI2QCmW39ulnjxn8kpXXM1YhdRwAfUuZfUmfMsz6TQ6FKCtg0DJ9UB4fnJb1OVS//qc3g+AshgpIl1/jA0qo5Yr1oqvkpcllr4flDn+aMR7D+1zp3gEVbwLQr+0+9KyFKcpnyGLUeU04/bXy7brA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 PH7PR11MB6008.namprd11.prod.outlook.com (2603:10b6:510:1d0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.39; Thu, 18 Apr
 2024 15:22:09 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::55de:b95:2c83:7e6c]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::55de:b95:2c83:7e6c%7]) with mapi id 15.20.7519.010; Thu, 18 Apr 2024
 15:22:09 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: "Wang, Wei W" <wei.w.wang@intel.com>, Sean Christopherson
	<seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH v1] KVM: x86: Introduce macros to simplify KVM_X86_OPS
 static calls
Thread-Topic: [RFC PATCH v1] KVM: x86: Introduce macros to simplify
 KVM_X86_OPS static calls
Thread-Index: AQHakNiYqtvKEMFbS0SvTLh/C3Jv+7FsplwAgACN6vCAANskAIAAAkcQgAATVbA=
Date: Thu, 18 Apr 2024 15:22:09 +0000
Message-ID: <DS0PR11MB63736F3EF472087F84F0523DDC0E2@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20240417150354.275353-1-wei.w.wang@intel.com>
 <Zh_4QN7eFxyu9hgA@google.com>
 <DS0PR11MB63739BE4347EC6369ED22EBADC0E2@DS0PR11MB6373.namprd11.prod.outlook.com>
 <ZiEnIFW3ZQhDwdZ-@google.com>
 <DS0PR11MB6373B4170ECA01D31830CA20DC0E2@DS0PR11MB6373.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB6373B4170ECA01D31830CA20DC0E2@DS0PR11MB6373.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|PH7PR11MB6008:EE_
x-ms-office365-filtering-correlation-id: 65e81b45-07a2-4190-fb37-08dc5fbb5092
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: =?us-ascii?Q?2W3ZMsQ3pvMEWptivF/hwa9pPWDoLZ+eCBlkQA1R0lryxFznsKK4pO+sI5fj?=
 =?us-ascii?Q?7uqYsWOmf9OpTfwl8fAqxhn6R4hsaz1pUtC5XyUCJovxqBVXb3cgwmCdrsbO?=
 =?us-ascii?Q?Giy+WTFPHVj08dJpTifD8x1d09LeOJ/jlgyNHua51RUdRk/RWeS5v9OsmZAC?=
 =?us-ascii?Q?ldUW+49tU5LT2G8l9J5Q7jdtKij9NApx5LL0EukP6jC7bvqsdshrDJCu+mDh?=
 =?us-ascii?Q?1QPO2ireFcDuUakGwvoy3wdoQScMhGBNgiSPI0a0L/rIkNahQzUTiD3FPl+0?=
 =?us-ascii?Q?o7cAMLkrA79ge2Vx4iRI5STWHQyFmSqrAccrXP+3/+q+UabbpIozerwt2zRk?=
 =?us-ascii?Q?KWvSIdXbr3xeho1bB7/YAKGbIzm1wznKLN6OSaMoFp/WgGl/jrY/uoVp4pcl?=
 =?us-ascii?Q?Kw2qVHXZetg9+1Wwjvu37EUtSKcGR7Fz5+YnMFfjQHTxO3NvFh7BYkRJP2sI?=
 =?us-ascii?Q?gCa3Vmhbxg/bFm034Nxb9hmtjDWVMetIuUwxHuPDPcxQz58WNR4cok7AzsBj?=
 =?us-ascii?Q?pZ0903KKUUfTVln6wukouJ0ok+Ac4e1hQM1zZKmk+jAeFmKaWBw7U6Vc5yft?=
 =?us-ascii?Q?BJx2cTEF/7clvz1Ars/FFN52MfcEk6i+qcb/1MnJ0nEcOn6tKYS0Xg8z8/kX?=
 =?us-ascii?Q?UOw+EkQnNN/9xKc3+hhuijBSgIR6R+mtgwcmqwnlrEX8KK3CoPz7xIj2pUso?=
 =?us-ascii?Q?6XscAb5c57ZAUOB0D8IGlJrDT9KHKfkOiDDNuwWhrA1On8FZF2az4tMM3JQS?=
 =?us-ascii?Q?4DwJDgNRkqbrtKEFGjdmft0FUh8S65Q+dgcHQRnjPiQXqnr4pMT0E0r0F0ka?=
 =?us-ascii?Q?9kMSK2OcTZh0M8PsQE+bfeYN2kMaRinreNGnydP8CiHAkowqrP6lG5oi+xhL?=
 =?us-ascii?Q?a7k12BI8CfVLYAV8+/lyXAYZqe1aZe3wXYNt+jx1KI634Njixu+R3bitD1tG?=
 =?us-ascii?Q?/WBHVhWo2v/RBfFHw9a+3IsHKR7+Lk/H4RR+/wo0jLePKMkLJ6XFDsilfSNF?=
 =?us-ascii?Q?PaQeO8v6vDJofXeiZoR9MrgR5X+0i5lU0Eelr5kewTFRnk1DqCw+/WUCrjgm?=
 =?us-ascii?Q?UnQa54iD90akRqR0hbTD0i5Hyi2ut0/Bfvvu4cgPk2/YJvfZYhHEkhhQrPLp?=
 =?us-ascii?Q?Yo5DMy4h+3SGAf3yof/W1VtC1ManTBbkd0xnec3xDxd3TTTGgxQHyEwIkZ3F?=
 =?us-ascii?Q?Nk3J5cDSYNih/PSEsLTEf9LxxU5uon2WVkJXF6vC6nswuMH69ltaevYfRnJe?=
 =?us-ascii?Q?VCbGBwpYOmXoHLOYaDTdoDsuJNycbq1JgJgPKtpVUN8W7Y0CjUrSBDjJ4hva?=
 =?us-ascii?Q?D/Q0RqAzjO0bJfFFcfjYYAKjtzMLGDheJ09O+Noptv1Pow=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ef7IZGtJg4jV2psroufNJMIsaZCzDrAa9AUAarp4liyaZ8Tdm4UxIPyPC5VA?=
 =?us-ascii?Q?RI5l+ZXIJeVecTS/QZawIdmITJqHdFBKNqcq3VFv2LyuqWigawl/01rS1zeg?=
 =?us-ascii?Q?1++/R6LAy/MnbABoTUk45eLF2I1Ih9r2IF2uvC2I3xdiKclfZirDPyyxKdIH?=
 =?us-ascii?Q?9sM/9y8/eQ3i5SOQyYDLC/qaijSv5G1Pcztyuo+as9rlIGVneuS1X/qVdzo+?=
 =?us-ascii?Q?SCI4WiTQdaDbuC57x36bTblaCNCJ3OhEcEE6r+wnT3+hD94fp+6WHXzrguuY?=
 =?us-ascii?Q?udHpZ5L/nR9QW8Svpm2dG9QkB7U/COY4ZJ/g0jEkBrZxVQes0XsnQPuVH4YN?=
 =?us-ascii?Q?XJFXffMyKI5G1+7nmOW/Sjwx1OzXzenkrdvNdIxXrYDtgUHFa8hAn7n5fiX6?=
 =?us-ascii?Q?iw8HS9N+UJx5U/aFn/h4HKGo6hyehsfqvXPUT3St2AC6kzaEqa2cOinVRJqi?=
 =?us-ascii?Q?7Xzk6qoc4GJ+bKrzWCygusl/ftAgzJDNCNpBoc0CYnbvXUe6RO/JZSEhpoHZ?=
 =?us-ascii?Q?OYru+UHge4OzNish8kx5dJwgtfPRawXZF5WV5wsgMdxwdPA1Uk1MNCsqWwCD?=
 =?us-ascii?Q?YZ0rKisMV8NOGhurAnz2h86f/3s/E69DiKXfL/iobriYqkxgd0b6wQGYv6L7?=
 =?us-ascii?Q?A5IHgZxfgQfzQegfXAHijN8EN9o0PGVVbGq3/1kho5PSKh+L4nkxxgC9UCwh?=
 =?us-ascii?Q?Ro181j7+ts8LU6Vt88AXm4cUdJuefuAuOLqdSz1YAYaWptshLg7LzJkgHQAF?=
 =?us-ascii?Q?IVJULbu1kbJ6rkkiPIXgrEHAksfFMPmOuxIRQK3bxO8QWYMStGFNRiQtnWQR?=
 =?us-ascii?Q?tvSpcNvJmbfOtMuni279TdKQ462rm+G06078TFNckXABV0hz+Ngn/MI0NLk9?=
 =?us-ascii?Q?1Clcfwd4qkKm6EBVTqUK0BPDBPfZejJmKqdciYK0AfkHDzaJLeuCesboj6ux?=
 =?us-ascii?Q?uZLqMf9bAqDMMh5+XlZolSa9Uam5giVIdaSQVUE/x2NGn+XpoQwBx+CS8gNL?=
 =?us-ascii?Q?sYtHZkoQk+24zzq7OrHMC3V67BhXHB5KSfF0hW39zR/J2lPdv0xD7PdDC93U?=
 =?us-ascii?Q?nbsV47ZZC782AeWbtXHiGVbBtOgAYyRF0Fp65ugbGVdd3tIndUXcS8IIciqg?=
 =?us-ascii?Q?shK9U8buw0z7GPiwKXzXx9vnzM4osEUkFKq9qJyaPoomXIXanrCPe9+xEUw7?=
 =?us-ascii?Q?HDGdjlME5xGvV48JMQl3o0KtlqPe6qwxjOt/Id2IuHsGsxp8i+BmWb2ZzQqI?=
 =?us-ascii?Q?dWTkoAUDn2jkFcyqpZQ0uht0WPfsRpVkvYDUHElOI8EHtVn7RiDPiF3+e9Ln?=
 =?us-ascii?Q?v/gZWgEmi40gJzvBlOVeDq7x0Hi6YNTEiE61gyyhTUave2m0cwjEQzVgZzar?=
 =?us-ascii?Q?+WSczxOLRBzzfMV3TQ6NG1LM1Ga0Gear13RWkK7xYQX0wDpHyvGNXsgOZjlX?=
 =?us-ascii?Q?+6TZ1y7vyrDA05Iyg1hv/4VqoFHeNMqVk+FO7m2hciYvmVUdnEQKOshWmmTA?=
 =?us-ascii?Q?HUlqbI2u6EbpK/Fou0gzvKbelL4qH7ny/EfIARW2AAaZFQYMkbR49eFs7w?=
 =?us-ascii?Q?=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65e81b45-07a2-4190-fb37-08dc5fbb5092
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2024 15:22:09.4941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wdlY+3whIJR7bkCUlxShWLME72HQozkSyM0dwf5U9XzZiN3kJ4FamdG5GSACwZ8Kxe9yB8Y16QkZLGtBVr6oUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6008
X-OriginatorOrg: intel.com

On Thursday, April 18, 2024 10:20 PM, Wang, Wei W wrote:
> On Thursday, April 18, 2024 9:59 PM, Sean Christopherson wrote:
> > On Thu, Apr 18, 2024, Wei W Wang wrote:
> > > On Thursday, April 18, 2024 12:27 AM, Sean Christopherson wrote:
> > > > On Wed, Apr 17, 2024, Wei Wang wrote:
> > > > > Introduces two new macros, KVM_X86_SC() and KVM_X86_SCC(), to
> > > > > streamline the usage of KVM_X86_OPS static calls. The current
> > > > > implementation of these calls is verbose and can lead to
> > > > > alignment challenges due to the two pairs of parentheses. This
> > > > > makes the code susceptible to exceeding the "80 columns per singl=
e
> line of code"
> > > > > limit as defined in the coding-style document. The two macros
> > > > > are added to improve code readability and maintainability, while
> > > > > adhering to
> > > > the coding style guidelines.
> > > >
> > > > Heh, I've considered something similar on multiple occasionsi.
> > > > Not because the verbosity bothers me, but because I often search
> > > > for exact "word" matches when looking for function usage and the
> > > > kvm_x86_
> > prefix trips me up.
> > >
> > > Yeah, that's another compelling reason for the improvement.
> > >
> > > > IIRC, static_call_cond() is essentially dead code, i.e. it's the
> > > > exact same as static_call().  I believe there's details buried in
> > > > a proposed series to remove it[*].  And to not lead things astray,
> > > > I verified that invoking a NULL kvm_x86_op with static_call() does
> > > > no harm
> > (well, doesn't explode at least).
> > > >
> > > > So if we add wrapper macros, I would be in favor in removing all
> > > > static_call_cond() as a prep patch so that we can have a single mac=
ro.
> > >
> > > Sounds good. Maybe KVM_X86_OP_OPTIONAL could now also be removed?
> >
> > No, KVM_X86_OP_OPTIONAL() is what allow KVM to WARN if a mandatory
> > hook isn't defined.  Without the OPTIONAL and OPTIONAL_RET variants,
> > KVM would need to assume every hook is optional, and thus couldn't WARN=
.
>=20
> Yes, KVM_X86_OP_OPTIONAL is used to enforce the definition of mandatory
> hooks with WARN_ON().=20

I meant the KVM_X86_OP in the current implementation as you shared.
If we don't need KVM_X86_OP_OPTIONAL(), the WARN_ON() from KVM_X86_OP
will need to be removed to allow that all the hooks could be optional.

> But the distinction between mandatory and optional
> hooks has now become ambiguous. For example, all the hooks, whether
> defined or undefined (NULL), are invoked via static_call() without issues=
 now.
> In some sense, all hooks could potentially be deemed as optional, and the
> undefined ones just lead to NOOP when unconditionally invoked by the
> kvm/x86 core code.
> (the KVM_X86_OP_RET0 is needed)
> Would you see any practical issues without that WARN_ON?


