Return-Path: <kvm+bounces-17521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 083478C7247
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 09:53:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7BD901F21798
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 07:53:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10AF76BFA7;
	Thu, 16 May 2024 07:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b8Q5QMxJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EAA282EF;
	Thu, 16 May 2024 07:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715845988; cv=fail; b=CUyjXn9MM8BRVGXn7kQlEsguHOaLJbeXY0UdETVOuj99nrzPm0/7dAbRuhX/0811OAE6rAdT2MQIRSKTV/FYWOfcftyWnWh3C953vrZMN4I2NaJaaRLX3bJaQ8q6Mx9ZFsakm2SDRgQioKzaj+BGEktAnM7q39scB949flWF15Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715845988; c=relaxed/simple;
	bh=ZHkvPfUrFLgPEPeZjlEa/agA2nrvWe6xE325HEYtv4g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TfOrrCcakWcSRC/J3enz4ICevgzQuYrWSt0kv/5wcchOBVu6ZwaQ31Pkc8ncfbIl3aNmFuoFvPc78vkOxQMMf4nThDuepug4kwrub3Z3TMsIUh4oxskxJ+fqY5x2J1NjUgxx62IfhgdK7HGe9yGGEtj0RmMvhH5d1R0/TLu+2Cw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b8Q5QMxJ; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715845987; x=1747381987;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZHkvPfUrFLgPEPeZjlEa/agA2nrvWe6xE325HEYtv4g=;
  b=b8Q5QMxJsLRGKADPh2yN1wlwlOM1y4Ggbv5r6esqIKk3FHKZMkIU/SSS
   EszIyMYjdtwazskVMzrDDgEGtQnQJlGfHMB2q+d1KSjdCOC0U5pflMA7a
   vSLYjePFTY8jEl84WevzJxYA+NvckPQtFAkvAy8c/KMshkB9Kqlpt3QB7
   MEqTWG2I8CqX4mL+x1vuN45/O6J7/TRLDFKHRbbLk31HNCYHsVNg4Ofi2
   P6PsuWLzWkjjqbEoQzu8SZkZhG4KiUSxeEiqTD86NPE0vSTq/kyaTD5N4
   P0rqIEjiLb3s5lhnWJdJQMVW4Ey3J9cXnaNoG2F96QdLBOz8/IfckocBv
   Q==;
X-CSE-ConnectionGUID: kjEXwtDbQY2jI/Z578PtKw==
X-CSE-MsgGUID: WD8hjQKySIKpWM1lXxfZxA==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="12120930"
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="12120930"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 00:53:06 -0700
X-CSE-ConnectionGUID: C7UHlozjQtqvaM9F1i97+Q==
X-CSE-MsgGUID: qgjcA7SuQvG+Hf9fZrKwcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="62550064"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 May 2024 00:53:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 00:53:05 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 16 May 2024 00:53:05 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 16 May 2024 00:53:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I6rzqqwXDD2Vz7E4ER67MgLEuPvPoqkVduLlkRvALrVcP6InNzz/nRE3dyOUdD8yOk117CCHxYdxwwtCWuJrpsKrZFYwvbPrkNqMrRWa9ykxf2xW/7XdmobiB0dOrZTHVN1WXj4szyJQjeDoySc1M3S6QVqr0Nd+ernkvdZMGTlG35O9f/w62cSaqO9PpUmYDRdS/RbY40XC0RLds4o9HJpDRIY2DXfNSGdpvGB5Oe7Pnr9XHjg4k0MuJ1LfNDUEoVkJC6F7L9AkUk3yRmh3UHRnbF3m3B9CRN2tOESwTJWjLGq8JRaCTTfDSmU3uKNr503DiqXhMHzR66e1C4W2Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZHkvPfUrFLgPEPeZjlEa/agA2nrvWe6xE325HEYtv4g=;
 b=Gco+mC/InSPzg/ynAfjJ2j5xnyi4V/SvTR5FoLkpGtvrSckrOtwpQeG4Abrd4gE+ntiT8wR72cHbk0UDsOYixmNtzVDU16oCczSrrX9rf5bBGtGt1QTcYCu6anEY9ZtdL++gj0yG9TT3tl48BUljq2Vc2LWNaavBE1CjOnBr6v6TVz9tnorR6tbeskh4wFoGcy6qk4DV4W0XgBaUafdLS108G3BLjB459XnKPFG3ioYK0PCgwakvuyENYbyIXtZBUhZR5NZnMSoHewrU/JaOFoLYhFwb2kPBoNoByaV/NhcCoQI4NfRBs942Pq6k+dEOzD0ypbyKTJaEhpycwEmNtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5102.namprd11.prod.outlook.com (2603:10b6:a03:2ac::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Thu, 16 May
 2024 07:53:03 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7587.026; Thu, 16 May 2024
 07:53:03 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"joro@8bytes.org" <joro@8bytes.org>, "will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Thread-Topic: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Thread-Index: AQHaoEb1yTw+2+R5T02uRFeJZuQMNbGPN+OAgAER64CAAGvrAIAEE0QAgATA9BA=
Date: Thu, 16 May 2024 07:53:03 +0000
Message-ID: <BN9PR11MB527606B1387E3CF37F5442F68CED2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062138.20465-1-yan.y.zhao@intel.com>
 <20240509121049.58238a6f.alex.williamson@redhat.com>
 <Zj33cUe7HYOIfj5N@yzhao56-desk.sh.intel.com>
 <20240510105728.76d97bbb.alex.williamson@redhat.com>
 <ZkG9IEQwi7HG3YBk@yzhao56-desk.sh.intel.com>
In-Reply-To: <ZkG9IEQwi7HG3YBk@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5102:EE_
x-ms-office365-filtering-correlation-id: b17a2be3-763d-4e5d-951e-08dc757d371f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|7416005|366007|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?9pK+87iWwWvmE5GX/UmWqD3fIICy9L0WeTF+Ct3Zzwo4LLgvt6hEPEHdn2lw?=
 =?us-ascii?Q?rf5RvvLvDOi1bcg3mjgdMAesDpk+GnAq3cSRAmvIC8GqtJC4qlRpIyg9yxyK?=
 =?us-ascii?Q?6aG2uvtdrxs11MAs+j3pWIQ6adBfTAbFuzXuoTJq7kne5QALjukXIxpEArgS?=
 =?us-ascii?Q?Xu8wlF8R2kV9DVlL3Kb5tOGFqCVOn80T6hx1DhIXdLkvNzSI0WLzmAlJN78I?=
 =?us-ascii?Q?Qmetr0ALyJPEp6aRbErvmGqYyMwAyeXbuKpLRs50/Dulum7WBeshFTxefybJ?=
 =?us-ascii?Q?GgB7hd3oPa6Ed36AEtoMzrF0pAVx5PJfXwsT8lSpLYD6xaIW0xJ/3rqM8vTZ?=
 =?us-ascii?Q?HkpR8HUHvT+Jh1xF+UtNvbKrHueSfQs/+1yRp3Af1MWNyEmbXq7/QGlQbeeE?=
 =?us-ascii?Q?joLND96mbPkkhH2vOhdCZ2QczsVNigjOiT654ckI2weDPohuL2WkOUiAMYQw?=
 =?us-ascii?Q?5RGNra4AWumH+crXAFD2eMeXhhArGzU6hudDFuno4IqK24FzehgMrI10FXtH?=
 =?us-ascii?Q?PFdPW5KW/ypaFAH/71NR62nPp15to/XY8FmRkL5v1RWVa52dmuh1xPIRwz4u?=
 =?us-ascii?Q?BL4bGoWaNgmQgLLiFuAJSKuqLbX01Ycu4c6TGkHWsxsuvxwchUq5MMh1Y/VK?=
 =?us-ascii?Q?mhuUa4nhd+qwiXBsqlmrHhjYzYdn8LL72+VJVjWVjEZjErs5nAQ1oh4Gt0PM?=
 =?us-ascii?Q?aqhCUjBZdTOFGkGg3kF/ae68EsGoFZwU7joDOFUpQ9HAKOmwzLk4JjuYl9nC?=
 =?us-ascii?Q?eFhOtwvcuO57wOcY37FMOcB2g+rSjLqFox75vt8fEWwM95PBEwUadBrtGQ1U?=
 =?us-ascii?Q?Bx9MmOu2/IHHHUQ8No04V+GoN65KkqstY+C02nAhWBxboQk5JwqnfmM3blYI?=
 =?us-ascii?Q?uHaX378orff9qKwpNFxYYANzoriLG2U5wGCsbuZ3biroypJNPsDpLZfnfHxQ?=
 =?us-ascii?Q?LDYCw2uk/jfcG6P4KCtzlWyXW5oFShgiOI4sONsuLn4WKIqMvV+wCSDuslaX?=
 =?us-ascii?Q?lBUWUY+sePz4Vpe9FuOuJyAhFOaVqS3inNpQRM7FWfPSDkfFuifJR0XA9CR2?=
 =?us-ascii?Q?soPtfqRMFBq77BJbfcqc8dhD7cjmBcn6RVO2EDPxwoFA+/zPKZ8CF4+jv8Br?=
 =?us-ascii?Q?o2ZqDhlGRE4HEHhlB1//ar8sFcKIROUuSzXYbQXCLj0d7ZTFygy3oPV1pMwj?=
 =?us-ascii?Q?Bkpf8hyM8ASU7G/Mx+117JVEoO+0tohv34uf57kjX/37vyuvaPCjxufUpsOD?=
 =?us-ascii?Q?3+EZ0xWlObTIm6I21AXhLAtS/nFgcYXqUVMQVmOfrdty55OhvgUWD0o6qCXK?=
 =?us-ascii?Q?cfUiZq6lbQBOshRTNPB6h3ZMn9Ww0YrcjF+36Vya2W6qfQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CSky3Wa7YdxnUTbilivQz84oWRYt2I8qq6AhhQQpRVu6MgxtE6sBk2V8IW9R?=
 =?us-ascii?Q?dUeNq55alPEMMP90gbnFad/nL9mmiTvwbeJDOvADhbjjodZ1owY2axJ/IZ35?=
 =?us-ascii?Q?UyHu3PuSoEemXY3nByrnF5PuCtsW3cnFdHwuIypi0TZeQqCERxjywb1FFApS?=
 =?us-ascii?Q?0VXDdDFWgaxDbGLl/DHGLIb5N4S4/3sBPss8FBOuKeXiUqGYEt/nkFlOmjXW?=
 =?us-ascii?Q?XnfuMqGjMCAKDXG/MDUMbo+eXQhmlPajatsFDjnNcJguRaB1TsFgFIqGxxdU?=
 =?us-ascii?Q?sv1gERM643O0W+8bi70Fq1N2vKQsU8UtLhsJtQfGrUDF5brkRQNhJ2nlhsYQ?=
 =?us-ascii?Q?BGSjzoc01sNiYWrbM9XibYaiSIGiCxwSxCXROeVh2bpz8x/5nCqtq84Aw8Pc?=
 =?us-ascii?Q?fhyw0ZnMcC9accSqQVavp7jQtqb8/fHNUQ1hDptVNFlDCNDL+JLMZtuqGx20?=
 =?us-ascii?Q?5UfTlIVxAub+zFCBFVZm1hSNhnVlZQ20hq6GVN7seT2nt6dv7V+Sp38Cls68?=
 =?us-ascii?Q?mG97utowlY8t2KCVCHJowv+U0RJ28NuJcEC1O3guaI8ASVFfc8dsVZ1ik5SM?=
 =?us-ascii?Q?DizSibLbzKNu8oy+dIEjhu8Wuk7jnx72orErZ3o0VRE3GxVH3/JQCsPfzhOP?=
 =?us-ascii?Q?Mvb2+6qbCPxDxaNVw+sD1GBRV7lbcqt3RnoB7qDORqI5N/IM+xlNp26VKojb?=
 =?us-ascii?Q?wIPAkNqPIdCsWHrTUxdIAsxG7EAxbkJ/p6XWV3QavgYRKTX4gWT3k6erfPZQ?=
 =?us-ascii?Q?omZvo1DSyvceldESpLYHZQn8EVYanmbSczUAqBp3UIEQoBEQOQMuY2IT7d2Y?=
 =?us-ascii?Q?7gqCa3D7XMvfNaddO0JEfKe0FE443bls6p/sSrZMa6wbioKcXWWIW8PVdLJ4?=
 =?us-ascii?Q?NXWMKh+OduWxujmfNR+Kx3c7skfab8QFqIZ2y3qY6q6gNN4BmZTAy2AT2PN6?=
 =?us-ascii?Q?P94rft9Xb79ojdStUBinG+rMclKSMsAa6sOH0Bpa42AnC1+fIUUDFlojQVV9?=
 =?us-ascii?Q?w8QA0ZrIZ2IB2fUJ1YcT3OSAGUigKgm5McSRZXTNLcfHwATd4+HcO8kF6E2n?=
 =?us-ascii?Q?g6bjEk5J6mMh2fR2247NKHeTw9h/nUGq2Qoa+epSi1qqUq4osRHSNu2Yyp/j?=
 =?us-ascii?Q?j9hcb9fJ+K/y1eByL73w8oWDUx0IVjSwGldKj2shbwFp6yWyA3fVDcYkU+v2?=
 =?us-ascii?Q?kJvRNWmZK+Gi/OqDJ0ODFLslCiv6O0NuRZkggdQiqChQmCSYInn+2VJqzKqw?=
 =?us-ascii?Q?Pu7gW8cSxczQbB+1HXI/i5Q3CWx8ZhPJB2iCLOYxDg4KQxqEbX9V/DSel79f?=
 =?us-ascii?Q?47MB54/qN4q3iIUKb8I5YpqP0DMUD7V5SC/oTOzZSw8SDqiFEHC1LGyM5V+3?=
 =?us-ascii?Q?VPaFzqYZxrvUGnSCIu0bo1VsCsgGlS4qXStdaVQeatdu8Hch2xp+tuCq1gIu?=
 =?us-ascii?Q?M3VOauz3z/ZXaKbOxfxqSv7oS7BaA6W4bKW5a1bAw/urtC3fDRB4U2gd9eEn?=
 =?us-ascii?Q?qzoEbrJctmSBWEk0naqxm5arxH3VHPh2X1iBbTr5BiRk1+gpGqjw4BajrujT?=
 =?us-ascii?Q?6jwux9KNTSVx9UB9TIhB42B7sIHG4na8XOOIzCfU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b17a2be3-763d-4e5d-951e-08dc757d371f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2024 07:53:03.5669
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cg9BRET59dQb6SzI0HvB6EIV9bFNepwtGWRHOQbcediMYFogPZ1GgQ7x0LIuX89yYlIigmni6sipI7VxtJ30Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5102
X-OriginatorOrg: intel.com

> From: Zhao, Yan Y <yan.y.zhao@intel.com>
> Sent: Monday, May 13, 2024 3:11 PM
> On Fri, May 10, 2024 at 10:57:28AM -0600, Alex Williamson wrote:
> > On Fri, 10 May 2024 18:31:13 +0800
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > >
> > > The dma->cache_flush_required is to mark whether pages in a vfio_dma
> requires
> > > cache flush in the subsequence mapping into the first non-coherent
> domain
> > > and page unpinning.
> >
> > How do we arrive at a sequence where we have dma-
> >cache_flush_required
> > that isn't the result of being mapped into a domain with
> > !domain->enforce_cache_coherency?
> Hmm, dma->cache_flush_required IS the result of being mapped into a
> domain with
> !domain->enforce_cache_coherency.
> My concern only arrives from the actual code sequence, i.e.
> dma->cache_flush_required is set to true before the actual mapping.
>=20
> If we rename it to dma->mapped_noncoherent and only set it to true after
> the
> actual successful mapping, it would lead to more code to handle flushing =
for
> the
> unwind case.
> Currently, flush for unwind is handled centrally in vfio_unpin_pages_remo=
te()
> by checking dma->cache_flush_required, which is true even before a full
> successful mapping, so we won't miss flush on any pages that are mapped
> into a
> non-coherent domain in a short window.
>=20

What about storing a vfio_iommu pointer in vfio_dma? Or pass an extra
parameter to vfio_unpin_pages_remote()...

