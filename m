Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 081077C6340
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 05:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376778AbjJLD1A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 23:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234050AbjJLD06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 23:26:58 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33247A4;
        Wed, 11 Oct 2023 20:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1697081214; x=1728617214;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=O6WdgSSDyG2tcIzFxtNr3MaZ3sSumOuDPpi+SnC1Ae0=;
  b=f79wC5EXjmLcbyw7C3aK96ICNDppFsTXeYotRD9y9T8pzIm+O+wlXIJB
   KOtF3QDRmH5LD5T6Q6mc6l5XgS4+g2x1Uo2wdewtGMa9T70BvRhiHqnYG
   osoZBEO1FFPN97GbD6/JXwCIHeyCZ/VG5s4UUDoa++6irNRdCiKhxa5ki
   mTMxpqUY8vm4suzPYHJykqrXVMAnHVvGcThCMARw9Xn/100Ra76DfwAxe
   ChSDBcFsXfkI7+61SxqmYin53RYVqeyy+dTAf732h0Pwge/iT+bzFT9wU
   m7AeKsfTuaioL8nLN30USGIUgmOg5woW5SfbNQzHYGBQlbeyfvHo1EaM0
   Q==;
X-CSE-ConnectionGUID: Njx+SYa8SdanuKTCEV/A+g==
X-CSE-MsgGUID: I2hau936Ta+XjXZYZM0FBw==
X-IronPort-AV: E=Sophos;i="6.03,217,1694707200"; 
   d="scan'208";a="358435695"
Received: from mail-bn8nam12lp2169.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.169])
  by ob1.hgst.iphmx.com with ESMTP; 12 Oct 2023 11:26:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eKnNXCnJyQXdcwo6f5QNPqQsYuymbZzc27c6bMoS50qiYbwIZhoAwPsE96Wsao/I4r2zudkC+Ga1CjBG0PBuwdU5sXV1LQMPxeTyOqRbQ2hxhCxWbBklZtr0ffMBzFcFG5DJGLWTVf2ISa4lc6SX6V0ckwYxKozit1F07b59750VCg1MvK6YH5Qnd0+BMRK9fvi+YDPS4gO/eWnm4ERJEqsrgvfSVKoNhLi6XKUx8jB5DBGda+Mqfcr+aMrihkHH39ziTMMd6vdt2vleAFUPjRFN+rgIL26oJ3WtoDsWP0FIf5HT6ufCoEapA6ttuveOaqVmGKteSvFffbemM6POng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O6WdgSSDyG2tcIzFxtNr3MaZ3sSumOuDPpi+SnC1Ae0=;
 b=m+dpFSLFoXopuSe4XJPwMuQdMMuE1bL/HkBaQraNMXSahiLJ2hlWHn7CxZ7+OG0laxsM/H7P3kOYEkgb0NQa4hF6+O5rc+/F8v+2aEWdZ2zGrXra3nX5oXIUXUxVQ6NG2rZftsvtUYRCGsGyvZY2SzCQZKeY4Z9baYi7ilKCUwTOUHwWAemu1U/zDzbC6AGsX0T8Y1QpJS/4fkaaJc5/i/ykID0eyFQYvKMPuIvAnSOMQPuTomu8gH7gniM2+qNGvam1E3et361xSvMHRq+5UI75hs/zqlwYa6HUGRCReZY6tnm65bv+eBY7r8eMC2m6gieaXW9hkCJ48FIF7VLAWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O6WdgSSDyG2tcIzFxtNr3MaZ3sSumOuDPpi+SnC1Ae0=;
 b=DHR1/YVMZ2o6XINEEssHh1wT3e+4LN5A9tOsxOUs0nvEnU7pBgVu1VdGY9Wy4S7NDYJbaP4v/avSOSU5ceST6asILxd958Bp2UH49j+iRrKWls/xIRNHd5npUjxxnZLlSHUUqxQOWOP2hhWdZ5gQ0oraOD9+s7ND3NylQBWm6QI=
Received: from CO6PR04MB7857.namprd04.prod.outlook.com (2603:10b6:5:35f::13)
 by SJ2PR04MB8485.namprd04.prod.outlook.com (2603:10b6:a03:4fb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Thu, 12 Oct
 2023 03:26:45 +0000
Received: from CO6PR04MB7857.namprd04.prod.outlook.com
 ([fe80::9915:e956:9ddb:3485]) by CO6PR04MB7857.namprd04.prod.outlook.com
 ([fe80::9915:e956:9ddb:3485%3]) with mapi id 15.20.6886.016; Thu, 12 Oct 2023
 03:26:45 +0000
From:   Alistair Francis <Alistair.Francis@wdc.com>
To:     "Jonathan.Cameron@Huawei.com" <Jonathan.Cameron@Huawei.com>,
        "lukas@wunner.de" <lukas@wunner.de>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        Wilfred Mallawa <wilfred.mallawa@wdc.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ming4.li@intel.com" <ming4.li@intel.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "helgaas@kernel.org" <helgaas@kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "zhi.a.wang@intel.com" <zhi.a.wang@intel.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "dave.jiang@intel.com" <dave.jiang@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "aik@amd.com" <aik@amd.com>,
        "david.e.box@intel.com" <david.e.box@intel.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Subject: Re: [PATCH 07/12] spdm: Introduce library to authenticate devices
Thread-Topic: [PATCH 07/12] spdm: Introduce library to authenticate devices
Thread-Index: AQHZ8jXtKGrfHZ2UIE+8VBy9oWOyOrA4KnGAgA1o+oA=
Date:   Thu, 12 Oct 2023 03:26:44 +0000
Message-ID: <caf11c28d21382cc1a81d84a23cbca9e70805a87.camel@wdc.com>
References: <cover.1695921656.git.lukas@wunner.de>
         <89a83f42ae3c411f46efd968007e9b2afd839e74.1695921657.git.lukas@wunner.de>
         <20231003153937.000034ca@Huawei.com>
In-Reply-To: <20231003153937.000034ca@Huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.50.0 (by Flathub.org) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR04MB7857:EE_|SJ2PR04MB8485:EE_
x-ms-office365-filtering-correlation-id: 08b36fdf-51ea-4076-d000-08dbcad30f79
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GgsS5BBkyinhlxTSRNseNLs6xcM7KhZvu6T1Fw+zi93DyJT0Qbw3wkNo0dRx6YdEfpmz1mbLUC9uWU6XSKNcqziDkHTWxe5G+RUrj/BBPK4Gyy59FtlyHzwQW3FuDDztOSSXQGySkamNoDY4sAhLx2Nb1rmNC8yK1SgMXQin14rxaVVX5EbJs1VC4c+rQE1LWzWyZSQWelx4/i1fsyYrETG2rNFDhRcmSNsRPkQc4lnfozTiVD0l+MuybzcJnOFVl9rtgMfTAa9OGd/fg1Ko3sz/KCLGfsBSqI9FwSxibMLeg/t1DhaiCyc7CdInn3lHAfKeS6E7Iv8Em4lrHtn2M7wXmvrb/FM1dDeRD5cwmi00f5mJ9YBova2sAOtcJYaeTHtBsTw2WatrjABXTtEu+G7wCv5x2LaQVb4SVELByNNHv+L6juHJuAuYQoBitpzDjxtYm/4RhLi+hypnPKzf4rjiB7glsiU6fUDynFZCRrsLayHIb7Q66cDnDieOHnZ+7mLszAqnNY1DTyxMAdHDVHJE7hu3vMVKe7pu71KxS2QcYTPs2GvKxSnGlNa1x5R9XhlbGJFpOTDI9jSeB/prpgkyIkFs8UjAzhFm4ovD2+H8Q4JHfoNfTt009gSFYcwjF9QAkQIyE1q0qJgZG1gcJA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7857.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(39860400002)(346002)(366004)(376002)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(966005)(91956017)(316002)(83380400001)(64756008)(66946007)(66476007)(82960400001)(76116006)(66556008)(54906003)(6506007)(38070700005)(71200400001)(66446008)(122000001)(110136005)(38100700002)(2616005)(6486002)(6512007)(478600001)(36756003)(2906002)(5660300002)(7416002)(8676002)(86362001)(4326008)(41300700001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S2hhQ01aSXdER1VIRlhxejhkcEJ6TXFJakxHTUJKWGtWYk9Ja3M2Y3JEVWov?=
 =?utf-8?B?cm5WNittMXNSUzg4a3RtYSt5QXVxMEVoTWJibUxSUXJ6bkNVUm1SMGFGYmlv?=
 =?utf-8?B?M21kWWxZZEN5cTZEMzJIYkhsYklNUlZkNXgxWlh1YlM5cDNSR0pqTHNuZ3k5?=
 =?utf-8?B?VmtVOHZOMWpFdkgrWGNrekR3ZEFoYkRkeGlXc3ZWWlYrWk15UFNjZXdKNTBP?=
 =?utf-8?B?WkNxTXBqU0IrVU1sdlZXSmMrbStKNjdIZTV0bS9tbkhMKzgyK2FWNm5TTTMw?=
 =?utf-8?B?SFZMbWpaRmtpdE96aTBvU3V1TmxrcUsxVUlvZVZLNkMwK0xSSmtTK0NZaHUv?=
 =?utf-8?B?WGVLam92elNRQWNUYUJrWUJzbDlmcStERUZHM2lmeFJuUW1CTGhpTUVaU3ky?=
 =?utf-8?B?Ti9nbnVJdDN6Vnh4OHhVcDBmYXZGU0p6WlBRMy90RFdmNHA1ZFZwMW9OamRm?=
 =?utf-8?B?eWRQeEIzNjFRa2tVV3l1cGRRTUFxeWNmQUlzcnhSbEpoY1BBQ29kWVp6ZkRv?=
 =?utf-8?B?eTl5N2lYaGtTdDc3dVRFRmpEeERzUEx0amI1SjNNT09KZzI5UnVPRGs5TVpI?=
 =?utf-8?B?KzljNXVoeGZ2VFhocFF6a2VwRmhMN0hTOEsxRFlnU2NsakM1TGlDbmlWMTB4?=
 =?utf-8?B?Z2kzb0gyMTJ2N2s0Uit4RTRFcnNpakNCNW16TGErdGdjQWhlZHVlQS9Pbkps?=
 =?utf-8?B?end6a2l3YmxtZCtDV29zUmtIL1ppd3BPRFlaNTNVYWJlL255Q2JaQjRtNzFB?=
 =?utf-8?B?U21GYVdXbEN1RW9XSExzOXI4TkVtc3dpS01vWm1NaG1jMnpIN3ZuazI2NElU?=
 =?utf-8?B?VitJeUQ5K1g3dzV0azhaWE1SVlVPOTVKN3NUb0RFVDVJU0lISnAyam84ZWRN?=
 =?utf-8?B?REpMSzVKdzFiR294VXJwUTlYbm52ZnZZaHUvTWp1dm5pcWhicUc0QmF4ZEFk?=
 =?utf-8?B?S3ZjNXduWVo3RTBwR2grK2sySTV3VVgxbWtJNDM3Mk9yQlNtWTRoeDVuTXRt?=
 =?utf-8?B?Nkx2SmQ3ZjZFSUdGUVNEeTJjVHkzNCtFN2Y1bjhQL0NmTkUxS05Hek9yOWtM?=
 =?utf-8?B?Tkp2L3FiYXRVYytnMGVhVzh2cmNHMk5SYXBVOEYzY0p0SzJxOWdld3RkVXJz?=
 =?utf-8?B?eHdTVGdQeHZOQThLQkJiK21tK0hlL0ZJMHovKzhMcW9WRHRoeVN4WWZydk1q?=
 =?utf-8?B?THYxS2d0YkZOY296TEZwVUE5SGZRdDY0NXZkeFYreEptdktwNDUzSUtOQnAv?=
 =?utf-8?B?czF1cGdGbXh6M1NMd0I4L0lLMWhpVDIrcGEweVI0Zzh4MHhqYW1jYXRNcVpO?=
 =?utf-8?B?Y2dmS1FQK0laK2tEY0Y4c3NPTGR4ZC9VUHFGdVUvbmVMQUhocUJhS1JJc1dW?=
 =?utf-8?B?Qng1WEMzcGxCYVJTYUZGMkUwUUFFVktJWGVrSk5IRVZVdnhmaS9NU29kOWcw?=
 =?utf-8?B?VWpiODlzSEQ4SnZvV0lmZWlYN1FBc1lBeUZYUFR3MXpYQVVxZHBwVk1qbFNX?=
 =?utf-8?B?Zm9XKzFwdkFjVUxhSjBleUdZaXl3ZXRYZ3J6SStQOTI1bGdyRVRoaGU0Nmxn?=
 =?utf-8?B?V2RYNWNoekVZelRjSWUyM0NRQ1dzaWRzNUV2Ris0Y0xnVzB1QTRtaEJQbTVq?=
 =?utf-8?B?ZHV0ZlZsRTNEWGd1QVBGL0FJWGw2OGZ6ZVVhblBvM1R5NVpHbk44YnBrbzRh?=
 =?utf-8?B?ZEJXYlBnaG13aEIvZ1NPRVVudmkyVThmYnBJakoyT3JOekFMVTdIb3JmWUxj?=
 =?utf-8?B?ZEkxcEllR0lUeHFhRGxObDJDdG56UEZlVlRkN3lmaU9VOUhJaWk0dk81Y2lv?=
 =?utf-8?B?elJUTUdWcXRiQlh3YldNZmk4dy9pekNoUmh6bXJrSjdUN1kyZXFYUEsrbGVx?=
 =?utf-8?B?cFpGdThDWkYxUEJ3UWpTR1NxTU1VMDB1dlkyTFlSR2dzcDloanNvTlMzZlJK?=
 =?utf-8?B?T0theHVRYkdGM1lUTkRjOEpQQnpRQ2xXeGNmUzdHMjN1c2pjYzlGNXhMaTRz?=
 =?utf-8?B?ck9WZEZ6SC9OL3I0bm1qdTZRSEgyNXlpQlFPSHIxdldEQ0NDcDVmeVliMTcv?=
 =?utf-8?B?dVJuY051a0o0WFJ5aWdyVTkwMzZlQjQ3V2RkdURGNzg4c0tTYitwd0JqS0FY?=
 =?utf-8?B?M0ZwcjIxQ0ZQekdLdDZtdzViM25udngxbUR3dlBheHU0Sy8xVDNTalAxTkhk?=
 =?utf-8?B?NGJ4eURJaVZkcC9aRnJZbzJhOTMza3FXZVAwVThKK252MWpQL3lpdEcwYnB4?=
 =?utf-8?B?YTFKd3h0MVh1SzR3L0dGbmZDUDdRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D46A9A8222673C4BB3F31EF3FCA30D26@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?T1F4VHhmNVpRTFFEaDR0bTlEbHlhT2lrOGh1cWZEU01oZFg5d0ZrRjdsc2s3?=
 =?utf-8?B?VW1nK3N2U24xUGpEclhMME8zMVdpL29yTTFBYndMT0I2cDE1ZHg2dWNvclMx?=
 =?utf-8?B?Z2sxZVNtYzdMOHl3WTRHcVh0YWJrZnJOeTBGMWM4d2FTSEpPQ2psU2tsV0dU?=
 =?utf-8?B?VThwUjZMRWg3MnZiRlhJY3lPaDdCdS9xYjk2Z1VmVWJqREgycUxjc0VBcmM5?=
 =?utf-8?B?Sm4va0tCaVRBV3Z5Wm9rZzFnQ1ZqejMxWmRsVzdvd3Q0RTJ0R09RU2hpbHpP?=
 =?utf-8?B?Q21GVXlReGxXYllqQTFqd0hCK2k0dzZoeExURGNCT0RzK0ZJM2U0T2krd29h?=
 =?utf-8?B?K0lpVGJtK2szdzBaWDA1NEYrZzM2cmloTDZFeTE0NklSOE95VXU3ckpaN05D?=
 =?utf-8?B?c3ZmVTZORXVWNXZrSGFQNSs2a2s2TWQrcXVqa1JOUTZ6MjJBS1p0VE1FdEFr?=
 =?utf-8?B?dVhzT2FiMkF1VHNUZC9KNnVhUWIrQWlTNWRteFpRQm02YlY5S2t1M0owaXRW?=
 =?utf-8?B?N3orOXRLUWtQdjV3T3JZeFplcVFrb0s2a1JyTjgxNytZdkQwM3VIQnpZNG43?=
 =?utf-8?B?cDQrZmkyNkVhU0J1TDBML1NoMkNwTGdSNmloNE1RRUJjRFA3THljVnE0YWkw?=
 =?utf-8?B?SUR0RkZWSUNmU2wxL25CYTJsS1BHTE5ya2YzY0M5eXgvKzZpdXJyNUxkNUFQ?=
 =?utf-8?B?emRIMEI0QURuR3FkUkxiejlmQTl0dFMrc3E2TFovc1RuS1V5NTl3eFRMcS91?=
 =?utf-8?B?VzgzdjFWWUdKZ0FFZm8wMmRENzcvcHgzSkN0dVAvZ1pXT0UxZGVmYm45ZjNi?=
 =?utf-8?B?NTZwNDdoSmM5Z3Y0TTFrYlBsMjlaZy9hTURCTkZJMCsxUWpCSUVzU3BiVVQx?=
 =?utf-8?B?L2RmT1lUNjdDZkhnUUc5OEVGa3NZY0hHb0xXa1lWQjZObFcwNVJwa3hXdFhv?=
 =?utf-8?B?UTlIbUN0QkFlZ01UNEtBS292U3NCYzJ2VnB4STV4MVJrYkI4ZkxmbWVyNW1y?=
 =?utf-8?B?SXpUWGh1ekV1VjZhWTdINVV1RExsRFhNVjdwT1ltMVRVTUJ1VVJSN2MvNm5G?=
 =?utf-8?B?SHFyQjlNM2VOWUE5bUhBK0lCTE1Wam9Oazh5VWlVL1QvNnZQK0YvQlpnL2k0?=
 =?utf-8?B?NWtqQ3VRZEhLT3ByaEQ0TXZoeUt4dnZMQmh3cFdYTXRxc2ZwQzFiR0x0aHlR?=
 =?utf-8?B?Y2t5T00yL1ByTkN6TVRST2Fpam8zdXBHbEFFRys2UjZNQ1pha3RjblAwcW5O?=
 =?utf-8?B?QzJMMHZoN1B0OWZ4L2VzUUI2ZHBSSmt5czUvWWNZWHAzZlRsa2pKMk1pMFR0?=
 =?utf-8?B?RnJGa1pkaVFRWW5NMHV6S3A2aGZvdzB3S1crdXhEME9vdWVHdlQzTzFoWTRk?=
 =?utf-8?B?aDJPWjIxL3ZlWXNrWVRHT1NLU25kTDMxazM2bkNkWkxDSW9DaDlQTHVQSzcz?=
 =?utf-8?B?K2dmV0t6d1htL3RPU3pXNCtTTlZjbmYrQXZRMHJOWElyYnV1Rk5zVW1VMlNT?=
 =?utf-8?B?amxVNStpUDR5dUd2UlVzTHh2a1VHRDJYL1QvSlRYOGpKQjRkZUE2QUpxaE9O?=
 =?utf-8?Q?5jRQ//+rH8ZATui15OGaQVdT0=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7857.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08b36fdf-51ea-4076-d000-08dbcad30f79
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2023 03:26:44.9300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zEByakI1NZSUjIhuYKi1a0wSl1+KeCwRot8HbYSv+K/H5FPxw+xwww/U4nASWQb69OkNRxoXyO5uq/FT0Z2bEyGzTT/kLCwATV9q4bUu88Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR04MB8485
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTEwLTAzIGF0IDE1OjM5ICswMTAwLCBKb25hdGhhbiBDYW1lcm9uIHdyb3Rl
Og0KPiBPbiBUaHUsIDI4IFNlcCAyMDIzIDE5OjMyOjM3ICswMjAwDQo+IEx1a2FzIFd1bm5lciA8
bHVrYXNAd3VubmVyLmRlPiB3cm90ZToNCj4gDQo+ID4gRnJvbTogSm9uYXRoYW4gQ2FtZXJvbiA8
Sm9uYXRoYW4uQ2FtZXJvbkBodWF3ZWkuY29tPg0KPiA+IA0KPiA+IFRoZSBTZWN1cml0eSBQcm90
b2NvbCBhbmQgRGF0YSBNb2RlbCAoU1BETSkgYWxsb3dzIGZvcg0KPiA+IGF1dGhlbnRpY2F0aW9u
LA0KPiA+IG1lYXN1cmVtZW50LCBrZXkgZXhjaGFuZ2UgYW5kIGVuY3J5cHRlZCBzZXNzaW9ucyB3
aXRoIGRldmljZXMuDQo+ID4gDQo+ID4gQSBjb21tb25seSB1c2VkIHRlcm0gZm9yIGF1dGhlbnRp
Y2F0aW9uIGFuZCBtZWFzdXJlbWVudCBpcw0KPiA+IGF0dGVzdGF0aW9uLg0KPiA+IA0KPiA+IFNQ
RE0gd2FzIGNvbmNlaXZlZCBieSB0aGUgRGlzdHJpYnV0ZWQgTWFuYWdlbWVudCBUYXNrIEZvcmNl
IChETVRGKS4NCj4gPiBJdHMgc3BlY2lmaWNhdGlvbiBkZWZpbmVzIGEgcmVxdWVzdC9yZXNwb25z
ZSBwcm90b2NvbCBzcG9rZW4NCj4gPiBiZXR3ZWVuDQo+ID4gaG9zdCBhbmQgYXR0YWNoZWQgZGV2
aWNlcyBvdmVyIGEgdmFyaWV0eSBvZiB0cmFuc3BvcnRzOg0KPiA+IA0KPiA+IMKgIGh0dHBzOi8v
d3d3LmRtdGYub3JnL2RzcC9EU1AwMjc0DQo+ID4gDQo+ID4gVGhpcyBpbXBsZW1lbnRhdGlvbiBz
dXBwb3J0cyBTUERNIDEuMCB0aHJvdWdoIDEuMyAodGhlIGxhdGVzdA0KPiA+IHZlcnNpb24pLg0K
PiANCj4gSSd2ZSBubyBzdHJvbmcgb2JqZWN0aW9uIGluIGFsbG93aW5nIDEuMCwgYnV0IEkgdGhp
bmsgd2UgZG8gbmVlZA0KPiB0byBjb250cm9sIG1pbiB2ZXJzaW9uIGFjY2VwdGVkIHNvbWVob3cg
YXMgSSdtIG5vdCB0aGF0IGtlZW4gdG8gZ2V0DQo+IHNlY3VyaXR5IGZvbGsgYW5hbHl6aW5nIG9s
ZCB2ZXJzaW9uLi4uDQoNCkFncmVlZC4gSSdtIG5vdCBzdXJlIHdlIGV2ZW4gbmVlZCB0byBzdXBw
b3J0IDEuMA0KDQo+IA0KPiA+IEl0IGlzIGRlc2lnbmVkIHRvIGJlIHRyYW5zcG9ydC1hZ25vc3Rp
YyBhcyB0aGUga2VybmVsIGFscmVhZHkNCj4gPiBzdXBwb3J0cw0KPiA+IHR3byBkaWZmZXJlbnQg
U1BETS1jYXBhYmxlIHRyYW5zcG9ydHM6DQo+ID4gDQo+ID4gKiBQQ0llIERhdGEgT2JqZWN0IEV4
Y2hhbmdlIChQQ0llIHI2LjEgc2VjIDYuMzAsIGRyaXZlcnMvcGNpL2RvZS5jKQ0KPiA+ICogTWFu
YWdlbWVudCBDb21wb25lbnQgVHJhbnNwb3J0IFByb3RvY29sIChNQ1RQLA0KPiA+IMKgIERvY3Vt
ZW50YXRpb24vbmV0d29ya2luZy9tY3RwLnJzdCkNCj4gDQo+IFRoZSBNQ1RQIHNpZGUgb2YgdGhp
bmdzIGlzIGdvaW5nIHRvIGJlIGludGVyZXN0aW5nIGJlY2F1c2UgbW9zdGx5IHlvdQ0KPiBuZWVk
IHRvIGp1bXAgdGhyb3VnaCBhIGJ1bmNoIG9mIGhvb3BzIChhZGRyZXNzIGFzc2lnbm1lbnQsIHJv
dXRpbmcNCj4gc2V0dXANCj4gZXRjKSBiZWZvcmUgeW91IGNhbiBhY3R1YWxseSB0YWxrIHRvIGEg
ZGV2aWNlLsKgwqAgVGhhdCBhbGwgaW52b2x2ZXMNCj4gYSB1c2Vyc3BhY2UgYWdlbnQuwqAgU28g
SSdtIG5vdCAxMDAlIHN1cmUgaG93IHRoaXMgd2lsbCBhbGwgdHVybiBvdXQuDQo+IEhvd2V2ZXIg
c3RpbGwgbWFrZXMgc2Vuc2UgdG8gaGF2ZSBhIHRyYW5zcG9ydCBhZ25vc3RpYyBpbXBsZW1lbnRh
dGlvbg0KPiBhcyBpZiBub3RoaW5nIGVsc2UgaXQgbWFrZXMgaXQgZWFzaWVyIHRvIHJldmlldyBh
cyBrZWVwcyB1cyB3aXRoaW4NCj4gb25lIHNwZWNpZmljYXRpb24uDQoNClRoaXMgbGlzdCB3aWxs
IHByb2JhYmx5IGV4cGFuZCBpbiB0aGUgZnV0dXJlIHRob3VnaA0KDQo+ID4gDQo+ID4gVXNlIGNh
c2VzIGZvciBTUERNIGluY2x1ZGUsIGJ1dCBhcmUgbm90IGxpbWl0ZWQgdG86DQo+ID4gDQo+ID4g
KiBQQ0llIENvbXBvbmVudCBNZWFzdXJlbWVudCBhbmQgQXV0aGVudGljYXRpb24gKFBDSWUgcjYu
MSBzZWMNCj4gPiA2LjMxKQ0KPiA+ICogQ29tcHV0ZSBFeHByZXNzIExpbmsgKENYTCByMy4wIHNl
YyAxNC4xMS42KQ0KPiA+ICogT3BlbiBDb21wdXRlIFByb2plY3QgKEF0dGVzdGF0aW9uIG9mIFN5
c3RlbSBDb21wb25lbnRzIHIxLjApDQo+ID4gwqANCj4gPiBodHRwczovL3d3dy5vcGVuY29tcHV0
ZS5vcmcvZG9jdW1lbnRzL2F0dGVzdGF0aW9uLXYxLTAtMjAyMDExMDQtcGRmDQo+IA0KPiBBbGFz
dGFpciwgd291bGQgaXQgbWFrZSBzZW5zZSB0byBhbHNvIGNhbGwgb3V0IHNvbWUgb2YgdGhlIHN0
b3JhZ2UNCj4gdXNlIGNhc2VzIHlvdSBhcmUgaW50ZXJlc3RlZCBpbj8NCg0KSSBkb24ndCByZWFs
bHkgaGF2ZSBhbnl0aGluZyB0byBhZGQgYXQgdGhlIG1vbWVudC4gSSB0aGluayBQQ0llIENNQQ0K
Y292ZXJzIHRoZSBjdXJyZW50IERPRSB3b3JrDQoNCkFsaXN0YWlyDQo=
