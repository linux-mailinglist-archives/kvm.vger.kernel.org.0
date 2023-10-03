Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42F1B7B7449
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 00:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbjJCWwJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 18:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbjJCWwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 18:52:08 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AFE9E;
        Tue,  3 Oct 2023 15:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1696373525; x=1727909525;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OvwOYlU9BUTdV4HPPUn+yT60kExiSk6Id48G+Ae92nU=;
  b=MYXzS9+XJ0b9OXXvlRLwk/z86haDPiGtpJGBE7brbjUHlU+cjI12DlHi
   qJfazXzccXuUxpJIX9byJFGHbpxKF9JZRSo2ueYSBUSL964/ZgUsZfbM6
   c+gyAKFE1DQnv3wc7JVyV83kEdczMnQXcreQg2YGM5Ab+7O4GBQvDEheK
   SFrIBvEPrLo1MR8wBM6ouGdDCnoxwfls25AUxUz4Xr++utvhE+Iw5NtXs
   5lfo59lDaVn5ja9EMnmA0dVbSJrha3Kjl/t1MGIyxgcgArfMIfg0fjXSr
   E663hHvbKFN5zfyIPvob8X4MwT80D5ropiKuh8V6dteX8YG+VMOiCVap5
   A==;
X-CSE-ConnectionGUID: /NBe/MfLQ+GvXORzfqjjnQ==
X-CSE-MsgGUID: 2HystPZyTguQ3prXpZVZKw==
X-IronPort-AV: E=Sophos;i="6.03,198,1694707200"; 
   d="scan'208";a="245922888"
Received: from mail-bn8nam12lp2172.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.172])
  by ob1.hgst.iphmx.com with ESMTP; 04 Oct 2023 06:52:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D06JCL84nN1RvwKlDk+dS6q6nR6GTjV6egSjzrPTaQ4Kr0M2ZShMVtuYEvF8i0+0kZ7JP7v/JqmeA3FDQKpomsT54m8PQk6S6XiHT5WZf/uBMZqv4GYgcGV/l/yE6tgzL2Kk2bxRSosEhK+DnDNFqn3xdwvPzOuhGgck2i9bICvkBSDIsn4WhLvgA8CLXE5vgfRT/ZjxOdQLfEr52IvoJaDdR3PaPZXQDmFKJqa3kgfHcuN/Lx2POXSc2nCIxX3Og40hZHVKFHbXQ94cJN0Csnoh5SFYRMFje7L9fNiHCvmHL/WbjL9xLJQ81hImiXMpw5sOe2xB4+6bfBRyAHGVbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OvwOYlU9BUTdV4HPPUn+yT60kExiSk6Id48G+Ae92nU=;
 b=kAy4+iLGjjgFTJe+bS3K3cqnOeNbh7ibzVkCbhBs35SdEi+NfUWEjujCOLE77xC+b6ez04rtrRW6+e/GJ192sRBNlNQOmT/H+fXhCJDwWtyTvdrQE26qMhw+C1Vd71s0OCC7Lx/9xYU3zVyl1aZk8Emc8x1dw8kg0elipxb7qxm7eZptz6+ClzN73zOxcryImVQBd0j+N+zJ+CtP7SmS8Kz/X29N/l6rw6xwQQyl/4n/ciFcu04VPHF9NSQfJTwFg71Bjs6tM9dnEmbYqIs1t+WEOegvagMC0Ai5Ohs98Dx8DHZ+q+mKLSWKxrlXy8t+83MlklDCJ4xgHmSBr4lAtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OvwOYlU9BUTdV4HPPUn+yT60kExiSk6Id48G+Ae92nU=;
 b=yhRaH2EARm/5rx6L/887QrOulvGPaWnQre3+l2tdsEnK+IC0yOE5YNyd/eG0BOFGHxWMPJgvkANadP/w1oAmjBSMXrLVVfdIHS9wTi8VKw++24reCRKfj5XQtwVDhLN/c990Gsx7IBXCrTeJw4m0pZqjFXc16LDWV6BX3DvXyKE=
Received: from BN6PR04MB0963.namprd04.prod.outlook.com (2603:10b6:405:43::35)
 by MN2PR04MB6751.namprd04.prod.outlook.com (2603:10b6:208:1ea::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.20; Tue, 3 Oct
 2023 22:52:00 +0000
Received: from BN6PR04MB0963.namprd04.prod.outlook.com
 ([fe80::45b7:3d1d:a02c:eabe]) by BN6PR04MB0963.namprd04.prod.outlook.com
 ([fe80::45b7:3d1d:a02c:eabe%6]) with mapi id 15.20.6838.024; Tue, 3 Oct 2023
 22:52:00 +0000
From:   Wilfred Mallawa <wilfred.mallawa@wdc.com>
To:     "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "lukas@wunner.de" <lukas@wunner.de>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ming4.li@intel.com" <ming4.li@intel.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "helgaas@kernel.org" <helgaas@kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
        "zhi.a.wang@intel.com" <zhi.a.wang@intel.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "dave.jiang@intel.com" <dave.jiang@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "aik@amd.com" <aik@amd.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "david.e.box@intel.com" <david.e.box@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Subject: Re: [PATCH 02/12] X.509: Parse Subject Alternative Name in
 certificates
Thread-Topic: [PATCH 02/12] X.509: Parse Subject Alternative Name in
 certificates
Thread-Index: AQHZ8jNgiJnZKrSUTEqqYHtYrT316LA3w7AAgADwV4A=
Date:   Tue, 3 Oct 2023 22:52:00 +0000
Message-ID: <300b7f594274ae17846a6e6e798d09d1133acfb4.camel@wdc.com>
References: <cover.1695921656.git.lukas@wunner.de>
         <704291cbc90ca3aaaaa56b191017c1400963cf12.1695921657.git.lukas@wunner.de>
         <1d44be7b-c078-4b3c-50c1-61e15325fe5@linux.intel.com>
In-Reply-To: <1d44be7b-c078-4b3c-50c1-61e15325fe5@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR04MB0963:EE_|MN2PR04MB6751:EE_
x-ms-office365-filtering-correlation-id: 536a3db5-94af-475c-f29c-08dbc4635ab5
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aY5d3jSbiutRMQr687/k1gDI6e0uNPgzSTjLSIxiiJOHJskfBeaGW/fNpzvx3h3/pFpL9IvrwKZuQ0249JcR/qs+poiGAzGF94rVSNFmhzzArX3//wlGSx09guny6Ip9Vr2wV1NUcygTRI3HsvQnyAJNPjWa2nknc2oIlQbUIfvD5uFvYJONeinwmHDbQO5UdA51aSZUejRvOdID99Q0EaAxwrn51B9r+In3KI00BQH04+rx4pOSsfxkm0NXgK5wqNN8CXBwD6bnyLLmylSUy3qR81TaBt3hjFaZHPyAv7kaD3E+6DShyUK6QrJkK5QbdZgMEPYMTewDdd/XM7cTzjjDcfkBmJGW115fFzL+OpnbQA7l7Z0pLaBE1EycRJh4rB11blZ4M5rAMDXsWJagEdP10u0ukWGK50B8u5feB8++Pd+Fz0zonRQbPqimE1m9nZern+jTiZxWybLCSglaPhWnbXwqw+ybc7DlXM1fZZHWXdhGrm5n1Lh9xll8XobBWNIrSTpnuInCHiWHYq/PzcE3qOzzC5wYoPE+chMksBNbohXxKcbBMusxn8ZJOAq0XpVKEb2eh2w9j/o19LaCugKw93O7q0IfwJaqSD+XD3pwNCBC4Ijb5re1c+h58jw3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR04MB0963.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(39860400002)(346002)(136003)(376002)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(83380400001)(44832011)(5660300002)(2906002)(7416002)(38100700002)(71200400001)(6506007)(6512007)(82960400001)(122000001)(478600001)(86362001)(6486002)(36756003)(26005)(38070700005)(8676002)(8936002)(4326008)(76116006)(66446008)(66476007)(91956017)(110136005)(66946007)(54906003)(66556008)(64756008)(316002)(2616005)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MHo3N25FZkRSYm16cmdkWTVpK3dHa3k1eVIwVC9FeHFIV2RrVTBBdWlVbVhz?=
 =?utf-8?B?M3Z1VkZTSFpVNnRNZ25NY2J3eFVGMHRqb0Z4L1FPVlVPc3dCcGgyakI5K3M5?=
 =?utf-8?B?OXlRakJ5K01la3ljLzhCWmdGWkx5UWhpRTZpand3MmF3M1NxRDNKQ0dvYVhO?=
 =?utf-8?B?QWFUYUlyWUFTWE1lanA0a1RzRHVwZUk4NCs1czQvQlJmbm5NVS9BNGFWd3Vl?=
 =?utf-8?B?Vk5BZ29DYjY0dktDSUt2OUNNZUN2cld4VmxzMklDdE5PMHRlcXZVWXFmZkFv?=
 =?utf-8?B?VmZxK09PTHRZRGhuSk9TakRMSXRBNjViUFdTNjVzUFVIL2sxWGVCc3lVOFBQ?=
 =?utf-8?B?b0RjWGFBMVJjTmVWWnlmQUZqeWFTam9OZGlyanRWeXBhR0k5SDF0SWhXZVVk?=
 =?utf-8?B?MXo1SWFhdDdJYzIxc3JkRllab1J3REkxdFYzOUpPaERXVUJxbnJ3MFpmbURT?=
 =?utf-8?B?M2lUVFNzZVJ4VldxUm05Tk1EamZ4UU1iUTBIQ29lS3VvWHhsVnZac1VDVyt4?=
 =?utf-8?B?L1Jid29IZGhJWmxucmFhbElmM0xJaTQxajVqTk9OOVFHSXZNWmxobEc3akpV?=
 =?utf-8?B?bDlKN204L3hVZ3kxUTBlZ1FOa0NsRUNrYzNyTHl3R1IvNEdRZEE2cHhMTmZW?=
 =?utf-8?B?UkNBYlc2VkdvUC9VWldKcS82aUJVYjlWNUkwMWc3Y0V4OERLVHptMTJHYUkx?=
 =?utf-8?B?Z05MZGVLb2hscGJUOWgzaUdQVHBvdVFpVm5nZDkwYzhQMUVFc0FmUU5aVUVo?=
 =?utf-8?B?ZXJCQXhHcEFLNFpmT2daanhFZnRiTk1RMjcwTEtPWDhIbnNJNGhiZ21HZFls?=
 =?utf-8?B?TUtYU0hsemFEZ2UvUVBZWkw4Ujc4OUtKQnVEYVVjOExzaDc2TytXZFdjMWpL?=
 =?utf-8?B?Z0pReFQwbHhhRXZxRGNheFZlMU90elZPL2Z5SGhtQWJPbWlISldCK3RiNlpH?=
 =?utf-8?B?YzNwVXA0ZG9RcW9uUFliQlI3UE55bFU2eDlSenRVbWlhNndYT2pkaDhFMk9E?=
 =?utf-8?B?eG1SNkVHem9zcTY3Nm1pcU5hOHF5ei9Oc01YSDZXcnF0VnkwVjd3aVNHck9D?=
 =?utf-8?B?bWtxbW11M2t2ZDg0YUQ0OTd5cnpUazQ3OENVSUY4Nkd3RG1IQnJiSFVqMkFy?=
 =?utf-8?B?TTV2MU9qWU1XdHFreFdFTWdlT3lwaG9ZTUpwVkVtVzNEeWNraDl4Q3FjN3Jk?=
 =?utf-8?B?aFNiOFI2TkpJN3h5SmhtYjFkWVJPQjdCVGlyZy80Mk0zeUlRNFUzdldRbHRE?=
 =?utf-8?B?Z3dnTUtscWp4aUl3Mk8rMVJidE1kYytBUUprT3hoY1ZSRThGbzd3S3ZYREVD?=
 =?utf-8?B?VUpCeHJPMSsyOC9rcFpVcGE2MUFDcS8ydDV0NVd6Y0t5NEt0ek81RUo1M2Vx?=
 =?utf-8?B?V2tWdkhUai80V0o2b2ZTamtTT2drL3RRZE9KQ2lCdWl6UmJXcHdyU0Y3OTF1?=
 =?utf-8?B?RkNaYmlBaUU5WnNkV08yaW82WTVGcEVKcm4vNGl4QU5FcFFXMjVRdit6cWR5?=
 =?utf-8?B?MVlSb3hCK0NHUm5VbkN5ZTVaWUk4NlZzVTB1aHdiNGV2M1BFdWxqOFJWN0ZE?=
 =?utf-8?B?TTJqNndYZFcrbzRoS2N1RGluZ2R1WWZkaW80azZrRHFNRFVDWDc0MGF5T25w?=
 =?utf-8?B?ckgxZ05QRW5YckxOQlB2QlRqRXdMNnJyOXV4T0JNeTUyQzFMd05ta2hucXRM?=
 =?utf-8?B?OWEvSVo1S0FtOWtCanN1TXhOT2IrVW1DVDNxM1hTOTd5ZXFuMTRyWkY2aG9o?=
 =?utf-8?B?THk5YTNpL0d6bDd2RUdTL3JUVnRZcS9OZWdTblR4M3NWbHZXQXhhMjFwQ2d5?=
 =?utf-8?B?akVsUVczcko1Mkl1cXBpQkNuUG05TUtjMTdPYnVGbjNvR0JOR0U5aFoxcE80?=
 =?utf-8?B?MEc4VmZ3S0Y0eVZOWk9iR1RnQVllZmsyZ2ltME51ZEpyOXBid1dCTGNQeUFE?=
 =?utf-8?B?YVlSZlcyL2RMTUxDMnVzcXJhNHZDQ2Nab29yQWY4SkgwMlhHWVZEOVVYLzJp?=
 =?utf-8?B?YjhhQlRXbFRBNkZrVURWR0ZzQVFYT294bDRJK25kVEFBUm9CTGlsQjVtVUph?=
 =?utf-8?B?T0p6NEl1bHREYlFLQmRYc1k3R1BRWkdHZ0Q4aUtleEIrcUVId3VNTCsvby9Q?=
 =?utf-8?B?S2JyaGFGenhJVDAwZHpKYkxLOU1KZEI2V0RKMlBJR3pKUm9aVjNnOHpnMG9n?=
 =?utf-8?B?V3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE19D76DC4DECB41B86ECC79BE4AB382@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?bUlucEl5MmRMY09GNThHYXFrZUZ6TlhJWlZqVWpmZld1WXJsMkpabWRIenNs?=
 =?utf-8?B?Yml4bmQ4T2VWbTlXUDl2R1UxY2h0eExhdWxDVGY3R2VWb1dXenRnZ25CK0E0?=
 =?utf-8?B?ZnNqTU9ZLzExSUZkZXRzb1FFcStqSU5pMGhUcmtQNTZRSzMvb3BUcElmVHpr?=
 =?utf-8?B?Mmxiem55OS9CdkJabkdWSVRGTUQ0d3prdDZPeHlTS3ZRSFlpZXV6Y3QzMjA1?=
 =?utf-8?B?TlE0eGUybUlVOVc1T3pOM0Vpb1RQT211bTNzOFZDYkNrSE81Q2hiNW4zZS9r?=
 =?utf-8?B?d1BmUFZydmtYN1pjOU1MTGtlQkpGbXdOQVB1TEM4b2hHY01nMFZMQTMwZ2lT?=
 =?utf-8?B?L3FEV1AxRTZxOHNGQm56N1FtMEU4dHY5UTN1QzN5aWI0YlZkOXdQTVM3WUJN?=
 =?utf-8?B?REVOTWU4VzUyU2ZIc09FcnV5NVo5dTR1Ymp6L3k5YmlBcUdIR084WjRNYXZ4?=
 =?utf-8?B?VmpiV00vWmlYMzJsbUQrdE5wSUJNSG0yclZxeGlOUDdlYTVPTUlRY2ZFb3E0?=
 =?utf-8?B?aCtaNTJBdlpCOUt2VFAyK3FEYktaVnh1M2xZZWJucVk3SjhRRExTdTVEMXln?=
 =?utf-8?B?Rmd2NEdQYThNNDE0UitWdHZER1prMU5aNFVESWcxQmRHd0Rkd0tQRDlDdlN2?=
 =?utf-8?B?bTUzNmF2M051ODV0VlAwaklnT05ieGNjSlozZkhWaEFOQmFwcnlVbnkvL3pF?=
 =?utf-8?B?RStYd2daWVhjUnA2Wnk0WTdnYU53OG05eHcrenFSbVFnbFRGbW9GQXBRZHlR?=
 =?utf-8?B?emhBMG1hUURZUVZPdnQxT2s0a3JHWUxYK1k1ZWo1M1FObDRwOW11K0s1aDR0?=
 =?utf-8?B?bmsrbjEraUs4am9xcjdyT1RPbGxJbzdkTjRTYkhjNThoN3UxSEdZV1ljMG1u?=
 =?utf-8?B?ZEdHeG1LNkZZcUxnTFgyUUM1WlV4bTNoNTE3N1NyR2I2Rm1rU1BYSHNKZTl4?=
 =?utf-8?B?YXFWM1VmMnlLVjM3dWxja1N5QVpzTU5wTVg0SFR4MjdjRitqdDRlWG9uZ2hv?=
 =?utf-8?B?NXdkWlhTQ3lMZ3JmVHR1dGs4ODJvU0NwVUowRGNWdTZ3VWhGbkNBakNJa0dG?=
 =?utf-8?B?aUJBR3ovSS9IMldsekppRXVhZHdiN1FRalcwdDg0MjBrVmFyd3ZuckwrL0NY?=
 =?utf-8?B?eldSakxJQ29mMWhadkQvZkgwUWxnaXlweHNuR3o3K2ZXNkF3SkF4TmVpSFNt?=
 =?utf-8?B?K1dkRU9iclpLRFpwRzZodTdON3Vzdm5CaUh5cnppclZsakFmUUZUNm1zV01X?=
 =?utf-8?B?ZmdYYWw1TmQ4WnVnWi9FMytCdXVWbmdnUUtZVmhuOEJuY0piSzI0dkg3NmN2?=
 =?utf-8?B?UmRzQjFrYnpVTFRrSDZwU2F4N3NxQ3R1M2lCRlluUERwbEd4WVZaNDFMT1lU?=
 =?utf-8?B?aURoS3hTOWV3WkhJYlVXUXRpRWdPdTFzbTBSMGxqQUZwRVJrcU5nckl1UmpO?=
 =?utf-8?B?K1lJSUw5SnFSdjhpeWlJM25QWFpGeWpzdzNadVdVMEZ3S2NHQUlFZG5BSFUv?=
 =?utf-8?B?ZTBJSEZ5UjlMblR3b3JhZHRjRy9xamhNYlpDQnRUVWI4bGZwM2d0K3dGMnNP?=
 =?utf-8?B?SEd0TS9PUGZrcjY5ck1HUG9qTTBaMmdvQTQ4NjVDbWhIRktGbktSM3Z3UWcv?=
 =?utf-8?B?Tmp1QjhJK1p0KzlBZkxEaVhDMmk3eFE9PQ==?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR04MB0963.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 536a3db5-94af-475c-f29c-08dbc4635ab5
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2023 22:52:00.5651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nCQDc+gEkanoRq49fRpMa/dg9M2eOXt/3etikoCrfnbGINMD7VrjbSI+IPGmyb0nyKviUflwRIME4wL0FjsWqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6751
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTEwLTAzIGF0IDExOjMxICswMzAwLCBJbHBvIErDpHJ2aW5lbiB3cm90ZToK
PiBPbiBUaHUsIDI4IFNlcCAyMDIzLCBMdWthcyBXdW5uZXIgd3JvdGU6Cj4gCj4gPiBUaGUgdXBj
b21pbmcgc3VwcG9ydCBmb3IgUENJIGRldmljZSBhdXRoZW50aWNhdGlvbiB3aXRoIENNQS1TUERN
Cj4gPiAoUENJZSByNi4xIHNlYyA2LjMxKSByZXF1aXJlcyB2YWxpZGF0aW5nIHRoZSBTdWJqZWN0
IEFsdGVybmF0aXZlCj4gPiBOYW1lCj4gPiBpbiBYLjUwOSBjZXJ0aWZpY2F0ZXMuCj4gPiAKPiA+
IFN0b3JlIGEgcG9pbnRlciB0byB0aGUgU3ViamVjdCBBbHRlcm5hdGl2ZSBOYW1lIHVwb24gcGFy
c2luZyBmb3IKPiA+IGNvbnN1bXB0aW9uIGJ5IENNQS1TUERNLgo+ID4gCj4gPiBTaWduZWQtb2Zm
LWJ5OiBMdWthcyBXdW5uZXIgPGx1a2FzQHd1bm5lci5kZT4KPiA+IC0tLQo+ID4gwqBjcnlwdG8v
YXN5bW1ldHJpY19rZXlzL3g1MDlfY2VydF9wYXJzZXIuYyB8IDE1ICsrKysrKysrKysrKysrKwo+
ID4gwqBpbmNsdWRlL2tleXMveDUwOS1wYXJzZXIuaMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCB8wqAgMiArKwo+ID4gwqAyIGZpbGVzIGNoYW5nZWQsIDE3IGluc2VydGlvbnMoKykKPiA+
IAo+ID4gZGlmZiAtLWdpdCBhL2NyeXB0by9hc3ltbWV0cmljX2tleXMveDUwOV9jZXJ0X3BhcnNl
ci5jCj4gPiBiL2NyeXB0by9hc3ltbWV0cmljX2tleXMveDUwOV9jZXJ0X3BhcnNlci5jCj4gPiBp
bmRleCAwYTcwNDliNDcwYzEuLjE4ZGZkNTY0NzQwYiAxMDA2NDQKPiA+IC0tLSBhL2NyeXB0by9h
c3ltbWV0cmljX2tleXMveDUwOV9jZXJ0X3BhcnNlci5jCj4gPiArKysgYi9jcnlwdG8vYXN5bW1l
dHJpY19rZXlzL3g1MDlfY2VydF9wYXJzZXIuYwo+ID4gQEAgLTU3OSw2ICs1NzksMjEgQEAgaW50
IHg1MDlfcHJvY2Vzc19leHRlbnNpb24odm9pZCAqY29udGV4dCwKPiA+IHNpemVfdCBoZHJsZW4s
Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAwOwo+ID4gwqDCoMKg
wqDCoMKgwqDCoH0KPiA+IMKgCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAoY3R4LT5sYXN0X29pZCA9
PSBPSURfc3ViamVjdEFsdE5hbWUpIHsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAvKgo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIEEgY2VydGlmaWNhdGUg
TVVTVCBOT1QgaW5jbHVkZSBtb3JlIHRoYW4gb25lCj4gPiBpbnN0YW5jZQo+ID4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIG9mIGEgcGFydGljdWxhciBleHRlbnNpb24gKFJGQyA1
MjgwIHNlYyA0LjIpLgo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqLwo+ID4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChjdHgtPmNlcnQtPnJhd19zYW4pIHsK
PiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcHJfZXJy
KCJEdXBsaWNhdGUgU3ViamVjdCBBbHRlcm5hdGl2ZQo+ID4gTmFtZVxuIik7Cj4gPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRUlOVkFMOwo+
ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0KPiA+ICsKPiA+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBjdHgtPmNlcnQtPnJhd19zYW4gPSB2Owo+ID4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoGN0eC0+Y2VydC0+cmF3X3Nhbl9zaXplID0gdmxlbjsKPiA+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gMDsKPiA+ICvCoMKgwqDCoMKg
wqDCoH0KPiA+ICsKPiA+IMKgwqDCoMKgwqDCoMKgwqBpZiAoY3R4LT5sYXN0X29pZCA9PSBPSURf
a2V5VXNhZ2UpIHsKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLyoKPiA+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogR2V0IGhvbGQgb2YgdGhlIGtleVVzYWdl
IGJpdCBzdHJpbmcKPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2tleXMveDUwOS1wYXJzZXIuaCBi
L2luY2x1ZGUva2V5cy94NTA5LQo+ID4gcGFyc2VyLmgKPiA+IGluZGV4IDdjMmViYzg0NzkxZi4u
OWM2ZTdjZGY0ODcwIDEwMDY0NAo+ID4gLS0tIGEvaW5jbHVkZS9rZXlzL3g1MDktcGFyc2VyLmgK
PiA+ICsrKyBiL2luY2x1ZGUva2V5cy94NTA5LXBhcnNlci5oCj4gPiBAQCAtMzIsNiArMzIsOCBA
QCBzdHJ1Y3QgeDUwOV9jZXJ0aWZpY2F0ZSB7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgdW5zaWduZWTC
oMKgwqDCoMKgwqDCoMKgcmF3X3N1YmplY3Rfc2l6ZTsKPiA+IMKgwqDCoMKgwqDCoMKgwqB1bnNp
Z25lZMKgwqDCoMKgwqDCoMKgwqByYXdfc2tpZF9zaXplOwo+ID4gwqDCoMKgwqDCoMKgwqDCoGNv
bnN0IHZvaWTCoMKgwqDCoMKgwqAqcmF3X3NraWQ7wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oC8qIFJhdyBzdWJqZWN0S2V5SWQKPiA+IGluIEFTTi4xICovCj4gPiArwqDCoMKgwqDCoMKgwqBj
b25zdCB2b2lkwqDCoMKgwqDCoMKgKnJhd19zYW47wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgLyogUmF3Cj4gPiBzdWJqZWN0QWx0TmFtZSBpbiBBU04uMSAqLwo+ID4gK8KgwqDCoMKgwqDC
oMKgdW5zaWduZWTCoMKgwqDCoMKgwqDCoMKgcmF3X3Nhbl9zaXplOwo+ID4gwqDCoMKgwqDCoMKg
wqDCoHVuc2lnbmVkwqDCoMKgwqDCoMKgwqDCoGluZGV4Owo+ID4gwqDCoMKgwqDCoMKgwqDCoGJv
b2zCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBzZWVuO8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgLyogSW5maW5pdGUKPiA+IHJlY3Vyc2lvbiBwcmV2ZW50aW9uICovCj4gPiDC
oMKgwqDCoMKgwqDCoMKgYm9vbMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHZlcmlmaWVkOwo+ID4g
Cj4gCj4gUmV2aWV3ZWQtYnk6IElscG8gSsOkcnZpbmVuIDxpbHBvLmphcnZpbmVuQGxpbnV4Lmlu
dGVsLmNvbT4KUmV2aWV3ZWQtYnk6IFdpbGZyZWQgTWFsbGF3YSA8d2lsZnJlZC5tYWxsYXdhQHdk
Yy5jb20+Cj4gCgo=
