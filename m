Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1221776E1C
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 04:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbjHJCfr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 22:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjHJCfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 22:35:46 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A24C1BD9;
        Wed,  9 Aug 2023 19:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691634946; x=1723170946;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YxETU9F2m6vwLPmpmivjYjaZVBzbu6gbAtPl+hai0tI=;
  b=fqy8TTWLdJXVtpo9ybt73yV2gP5Jy1TePFSRDgxtqbPpI6bADN2PJxi/
   R1i5sK79mNSiLtDLkosPORxLZYUoadkGPxIOFGrEMHtM3VAGPOHsENwVg
   2OcaHhW1auNoGr6G6eaaJe/crDf3drvSZ+jtDoB7qoY+lC1/fEoCA/jmQ
   dpHi19ElX2EvrqllZB/qzx/20QctYgBbpco9HlOo7/fcjBTfwVJ65zrFs
   R4n/PIe/UyLtqTp/7bPvSFPWQzC4xaLH5ZJfF3zixzN0YtU1zgIoamVag
   bUtPkafk9ZQS3U0nJHm3/PcUFV9deIt3wvflKuEevaZauXaHq6GST9AGg
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="437637452"
X-IronPort-AV: E=Sophos;i="6.01,160,1684825200"; 
   d="scan'208";a="437637452"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 19:35:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="846193652"
X-IronPort-AV: E=Sophos;i="6.01,160,1684825200"; 
   d="scan'208";a="846193652"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 09 Aug 2023 19:35:44 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 9 Aug 2023 19:35:44 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 9 Aug 2023 19:35:43 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 9 Aug 2023 19:35:43 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 9 Aug 2023 19:35:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hf1ZYo0Pc+zmx28P66KnAnfU1sIllr6WhP0wCyCPLKUxiiiTBdABI2jERCAHq0jvg7lDRI7jPValUpF7EtZyNfhcG/8oFsd+xsjEhZkKxvJnS6SytnhtHznQ4mxQaipAorw0cVmHMLy6EpXe7lPEmCow2ufqRMemAGuDtSsnLgD0qBVUA5kQh2AGBP1z+Gbr6mPSAXsrO1JDZCOEiLDgnSHM7H+LULlXRx6++ynAeocQ+NG4ln5pNhvamyteGPRMRZC3Z0qspbG1pr0Cg7W3WfjQX0m7k2nWFYGHzZJowP6oaKF5lidPuB4D30noWqDh7senJoV5EbNYgVie4oRsfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YxETU9F2m6vwLPmpmivjYjaZVBzbu6gbAtPl+hai0tI=;
 b=l8pW1oMR3qpgL/rLzBLy7/92ajIdo0l7FibAdqpTdKRhZnH0dtBUSun95RBXSZG3SbXEXz3Egz0ztg9s0wD04ielAgliolUbGIey9kHRHkpGdPkQ+p/AePjKJd5z2MFqRpHGa7IgL6vuyquSol/rm2I2gKyha1A9vQgYGtFhJXPJ4nTUWj7ritSD+v5FiaUEcG8V9NmkE7EnV69UwF5qFlmZGZBLDF0FNGMHt6fFvOMwIlphGpKKjhKE3DTkuBr0Za5zqBmd0g4L714y0Us3K3LfeZg7NtijrM+ZSLPVfyV8rS95bmi3WuRv/kbuh3iIWlhod1zbttwqoBA14m6bXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB7176.namprd11.prod.outlook.com (2603:10b6:208:418::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Thu, 10 Aug
 2023 02:35:41 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.029; Thu, 10 Aug 2023
 02:35:41 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@ziepe.ca>
CC:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 08/12] iommu: Prepare for separating SVA and IOPF
Thread-Topic: [PATCH v2 08/12] iommu: Prepare for separating SVA and IOPF
Thread-Index: AQHZwE5hR532wMNk30qvLyiBGXN6vq/YQ9iwgAiL+4CAAFj2UIAAso4AgAEJ0yA=
Date:   Thu, 10 Aug 2023 02:35:40 +0000
Message-ID: <BN9PR11MB527686C925E33E0DCDF261CB8C13A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-9-baolu.lu@linux.intel.com>
 <BN9PR11MB52769D22490BB09BB25E0C2E8C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZNKMz04uhzL9T7ya@ziepe.ca>
 <BN9PR11MB527629949E7D44BED080400C8C12A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <0771c28d-1b31-003e-7659-4f3f3cbf5546@linux.intel.com>
In-Reply-To: <0771c28d-1b31-003e-7659-4f3f3cbf5546@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB7176:EE_
x-ms-office365-filtering-correlation-id: 99c92bce-7110-4711-e341-08db994a7d23
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6GdsMuBeBgiqtlQgyTXJ9HLYD01XBHpmLdh/GCbxP3SMTPBTZLv33//PD36/Ddct4VW4vde1x86nFAsRoWBsh64N72Bf+VuMSfhU3ByafuwDmPuonv/yvd0L7YRx0VVrDRx1+W7OSYsU42uI/zt0ZZBylxuSFcYoYfDsmEAoy3NZK33+C9Afw1msGw00WxKCdSPRXfNOTwVmSXoaog3fUqhchJU0Tl3tfr/Lmr/iIythIw7DgCRrZ/qw8O7V/KiOza5rPYBovlYp0n3sgP8jj+DfXIBir+xEgDCqBinXdEeoZqGQNBoUOhS7lR3cnL+NJPi2uaH5KupTRrk0QwOvOz5GeoBCWqsBX7YPpibaQGaCAeUElpRsEEvuPc+tmyBhyGlWELRsNsTz9s4vN2fcUVSE0wmIC1cU2Y2bhmQUpi4LNYz/S+XdzYJikXTL/rYfUx8zB89nq2+oI4dp8V4xTrb/kRY7mfq0xmjj/kRYpI/vzCFeTQuqJY6J8tHXIjiYGoHcG26pA2Cm51ZFyVbfUD/ix1OKR6hWHBi59t7I/j46gfPhuihth/qpIelIAWfAFDUp9t9v+Vc6FRB9ml4sOjNQzH3BpdpJouL04d3NwGH6Z1E9FYs1W3u1SKCYxzdz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(39860400002)(366004)(136003)(396003)(451199021)(1800799006)(186006)(2906002)(38100700002)(110136005)(54906003)(478600001)(122000001)(86362001)(55016003)(7416002)(5660300002)(71200400001)(38070700005)(52536014)(6506007)(26005)(82960400001)(316002)(9686003)(7696005)(8936002)(8676002)(33656002)(41300700001)(76116006)(64756008)(66556008)(66476007)(66446008)(66946007)(4326008)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QlI1N2VMZlhYU2hJTVIwWUhiMUZabXA0eUxlZVFHalBjaE9IeGprdFl4RkZG?=
 =?utf-8?B?ZDdYaHo0aEgyMk1VZXd1VFhYbGxzTm5TY2x0SDdadllCUUJBTW1tdzVHbStR?=
 =?utf-8?B?d00wYXVERmF4YlZWa200a29hUDlza01qa1MyUW5OR3JMTUpTV25QVHM2WHYw?=
 =?utf-8?B?UUdmbHk0ZnI5bSt2Q1RvNTF6K05FYmUzK1A2WndBTVBtRTB4SHFNMzhrRzM1?=
 =?utf-8?B?bUU0YWdLNnpEWHBLVUtHdmpadzF6UFI0aVE0UE1FUlBZZndwTTBXQnFQbzhW?=
 =?utf-8?B?ZktjRDZNeDhXSlcyWDJmVFBpeFFTWVFSUUxKTWh3WHlhaUtJUTdKMXllTGVD?=
 =?utf-8?B?UWVvOVJDcEFxWVMxb3NIWVdpOFJKUk5YbUR6bjhhRStzRWt5S1JQUFROeDRK?=
 =?utf-8?B?SzlzeTZKMEF4MXhqNnJTU2MzU25JejE5QitPVXJZd2pHOVVUZ1BKc2RMZnlr?=
 =?utf-8?B?ZFF2ekhpRTRHRUI5MnBmcjlFa0NFOWlGZGpiUG1icU00TjlaeDVSZXEvTmhL?=
 =?utf-8?B?eG00QWZyU2h4d2JlUUFNR3pFbWlRRkNwMzZOUVNDTmxzSUlyTkhjcTFwOUlu?=
 =?utf-8?B?K1VCZ1lsaVdUOUU3MHB6emMyWG9kVXB2dlN1YnpSeWdnb0JOWEtjcThpeGxi?=
 =?utf-8?B?cWNzOXhvZFJhMTB5M2VNR0xaczVVQjZVOUJhRjdDckJGUmVTYTN2N3NQQ3Vv?=
 =?utf-8?B?QlJXMnBuVmF4WXc2US9rWVlsOXNpeW5RUXRLRDZSQnVwYnAyUDZaSy9FL2xh?=
 =?utf-8?B?RExhQTdCZzZJZHpJaVNIUFM3anB2RFF4cG1iVGlZb2Z6ejhZNEM2dnpwaThZ?=
 =?utf-8?B?NEJGaCs1TWtveTJqaHhlK2pWNmsvTCs4TWl2UkZUdmdZU1BmRUpIUC9XQis4?=
 =?utf-8?B?eUxVMnpldHRMcUgyKzV2UDlnK0ZLZ1djR29aVzg3L3pmNEFhUjZkbWMwWmti?=
 =?utf-8?B?RGplbjNjVUwwbjJQR2NKR3Z2VkpJL2tuZU1mZ3dBOVl5VDVubCtSUXkzSWhP?=
 =?utf-8?B?cU5GeWdRdUZRa1hxS09ya244RlN5cmdNSFdNYmVTY2h4eE5uY2M4dTB1Zk5o?=
 =?utf-8?B?eDNYcitFRlhpRitDMG9YMUJhRlRhT1ppQnkyMXJoWlRKa3BNcTdQUUJPcnVH?=
 =?utf-8?B?L3lpN3hWL2N2RnM0bnozeW0vdXFJcHkyZ25lMGI4S3p6eUxETVh5SkRDeHpH?=
 =?utf-8?B?ekFYcDVFcEg1VDYzYkp0N1QzcE1oRVhCVjB0bzQxMWdTQUd0NlNYRFJxOEhH?=
 =?utf-8?B?cGZBbzR5WU5FcGZDV1lyTWoxcDlwL2lORjVqMDlSRks5RkxtUVV2Ty96S2tP?=
 =?utf-8?B?ZW1DKzB6MUE1N3BpYU9Gc29SdVNhOEVNZUpFa3JBcE9HNUpZUmlLTjlaRzNx?=
 =?utf-8?B?U1BCZ1k5NDFrUkJJVzFqTDBYQ2tIQmU5VXVLTEsvR3hTdGJsQ3czdzdMYk9I?=
 =?utf-8?B?TXFhYUEvVE5xRmZoQUMyYUlNM3ZwTUpSOHNCc2ZEbG96a09DbTI4cW1lc01u?=
 =?utf-8?B?cW1KNnl6Wi83VW40QXhpTlBPNWIxWG9aV3RJNE94UDRYaHBub2c1bHowMElx?=
 =?utf-8?B?UnRCUTFnRGZmMDJEM0dlWTdkcEc3cXVWZzM2dFN5YXBPdG44TUlwRTd2b1pw?=
 =?utf-8?B?TXVoaldkc0xaa3p1RXdhclMvS1U4cXVlTmZXQlAzbzVYWmJsSy9DVHA4MXRP?=
 =?utf-8?B?NzhGVEdWQWVaZXQ2bngwRGx1UjJLckJCMGMwQStFajNoaG5obWJTZGJoaHRT?=
 =?utf-8?B?eDFGblhBSTc3YyswbEs3NHRPRnBmeVNteFVFSG4vZWxGN1M3ZGM2NTBKd0V5?=
 =?utf-8?B?MWtzYkVFRTFvV1l1blBMRnI4SlNyVmxxbE1VSnRjZTdrOXVuK3hSei9PNzNu?=
 =?utf-8?B?NzJsMDBYbWI4QkI0OG9BZzI0SVBucWNSVzUwazlqeWxLNml6UlVUMG1LcHUv?=
 =?utf-8?B?T3BwUm45emFPQWUxMzROTUQvaEY2dlVWei9XZ3ZiOFNZeHdMeGRzSXVxM3A3?=
 =?utf-8?B?S3Y0N1BOazJSVWxmT1pPTlNaR1k4cUFyd0pvWGFkRUFheXp0Rk85U1p3Z2RS?=
 =?utf-8?B?MXlXQ1RVRjM3UVpJaWlEM2VZYXNZbmdkWUFDNjhqbndmMERoa3l2Z1dPZlhX?=
 =?utf-8?Q?5aouf7zgu7tSibfPQJyCC7MzU?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99c92bce-7110-4711-e341-08db994a7d23
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2023 02:35:40.9167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ox+rCaoH+5r3h2XIq9UwWpCvL0TuEmsgSVN48qJQSL01RgL81Y24S+IMgugUnRqg2quQ2ly/6ym9XicHczzeEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7176
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBXZWRu
ZXNkYXksIEF1Z3VzdCA5LCAyMDIzIDY6NDEgUE0NCj4gDQo+IE9uIDIwMjMvOC85IDg6MDIsIFRp
YW4sIEtldmluIHdyb3RlOg0KPiA+PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0B6aWVwZS5j
YT4NCj4gPj4gU2VudDogV2VkbmVzZGF5LCBBdWd1c3QgOSwgMjAyMyAyOjQzIEFNDQo+ID4+DQo+
ID4+IE9uIFRodSwgQXVnIDAzLCAyMDIzIGF0IDA4OjE2OjQ3QU0gKzAwMDAsIFRpYW4sIEtldmlu
IHdyb3RlOg0KPiA+Pg0KPiA+Pj4gSXMgdGhlcmUgcGxhbiB0byBpbnRyb2R1Y2UgZnVydGhlciBl
cnJvciBpbiB0aGUgZnV0dXJlPyBvdGhlcndpc2UgdGhpcw0KPiBzaG91bGQNCj4gPj4+IGJlIHZv
aWQuDQo+ID4+Pg0KPiA+Pj4gYnR3IHRoZSB3b3JrIHF1ZXVlIGlzIG9ubHkgZm9yIHN2YS4gSWYg
dGhlcmUgaXMgbm8gb3RoZXIgY2FsbGVyIHRoaXMgY2FuIGJlDQo+ID4+PiBqdXN0IGtlcHQgaW4g
aW9tbXUtc3ZhLmMuIE5vIG5lZWQgdG8gY3JlYXRlIGEgaGVscGVyLg0KPiA+Pg0KPiA+PiBJIHRo
aW5rIG1vcmUgdGhhbiBqdXN0IFNWQSB3aWxsIG5lZWQgYSB3b3JrIHF1ZXVlIGNvbnRleHQgdG8g
cHJvY2Vzcw0KPiA+PiB0aGVpciBmYXVsdHMuDQo+ID4+DQo+ID4NCj4gPiB0aGVuIHRoaXMgc2Vy
aWVzIG5lZWRzIG1vcmUgd29yay4gQ3VycmVudGx5IHRoZSBhYnN0cmFjdGlvbiBkb2Vzbid0DQo+
ID4gaW5jbHVkZSB3b3JrcXVldWUgaW4gdGhlIGNvbW1vbiBmYXVsdCByZXBvcnRpbmcgbGF5ZXIu
DQo+IA0KPiBEbyB5b3UgbWluZCBlbGFib3JhdGUgYSBiaXQgaGVyZT8gd29ya3F1ZXVlIGlzIGEg
YmFzaWMgaW5mcmFzdHJ1Y3R1cmUgaW4NCj4gdGhlIGZhdWx0IGhhbmRsaW5nIGZyYW1ld29yaywg
YnV0IGl0IGxldHMgdGhlIGNvbnN1bWVycyBjaG9vc2UgdG8gdXNlDQo+IGl0LCBvciBub3QgdG8u
DQo+IA0KDQpNeSB1bmRlcnN0YW5kaW5nIG9mIEphc29uJ3MgY29tbWVudCB3YXMgdG8gbWFrZSB0
aGUgd29ya3F1ZXVlIHRoZQ0KZGVmYXVsdCBwYXRoIGluc3RlYWQgb2YgYmVpbmcgb3B0ZWQgYnkg
dGhlIGNvbnN1bWVyLi4gdGhhdCBpcyBteSAxc3QNCmltcHJlc3Npb24gYnV0IG1pZ2h0IGJlIHdy
b25nLi4uDQo=
