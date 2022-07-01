Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D12562B34
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 08:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234644AbiGAGIH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 02:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234116AbiGAGIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 02:08:06 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801993EAB7
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 23:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656655685; x=1688191685;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=I9EuVGcNRbIrjMpFvjKbdkdEDvO3tG5PdvK41TTllC4=;
  b=Dhdwhs9eOdbyoOX6HfHJc32QupDmLLY11k9YIj8AoxjaacD5sVq0D9E5
   tGnTmsgf2D35XInVpZlwPQxbQZmXJlg35LCInV29dFcRQ2T/iSpArlcQm
   JHwCzAuVQgRMsWQWJVm3JU/qcsXPEDwhzMIru5fMnezc3omibSSzbAXw7
   AJeLZyTFGRvZa4tb6Ej9oaIt2n81SrpGrBRD254h+WdNODzuDnHPoX/MX
   Fb0RlP31BNGjh+UyFBK9bfPgXlh1VJwxGDmutlWZnm2SCY0q4+YDhfy90
   1W/4rngDfuGZvs5hNx4fr20l8Rf00q3ijhIMGB27xTJQ8cg/n5DDB1KC3
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="346550758"
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="346550758"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 23:08:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="648206412"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 30 Jun 2022 23:08:04 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 30 Jun 2022 23:08:04 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 30 Jun 2022 23:08:02 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 30 Jun 2022 23:08:02 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 30 Jun 2022 23:08:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hrXv8kdAUrCq3pkjEuHiTk/GsEywkrG2wq+0UYUCdmwV4TLLxD/RBVVshVVc/dkHiFoyNhbzM0VlP8U3O+DOIMBzvNoKHvpEPd6qvP5LbLcEWAxiNDbPmGhHfNMTxyVqH2nrXEcfPuZzRml54BlJf1WznpJPN5sx6vf6b8dnEXRN7QuV4pOiyvaDpmfOkgHywhn53XTVDGtTzbaVSwyB0/Y0Dek2LbeExSFIYyX94zt9Sy60g44EnSxgxrH7KS6qV0rOm15x7CyYCHbJOnGYyM6Cf/uOI1Oz4g257VTLI46cK//g1PwUO0LcTkPjg9Q6rE7sp3xv6+N2yFHYv9pw0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I9EuVGcNRbIrjMpFvjKbdkdEDvO3tG5PdvK41TTllC4=;
 b=fh7Pg+EYFOHN8Qc79ctCfq8FbyAjqVOi7gXOJKk9xEAhUVEmjka1Gl0whL0hz6pNlH5rOvjGWbn4AAbzcFyp38o7d23pfvbZfTR4ruU7StZHpd6qnuZSVWXuzTYZ3ES1h4ogVnqkn+JvA1VONWv7lQayLiSAlDcirWh5LwWWCpsBL1T/OQHP8TDwSA1t1PoXUYdxVoRZWlNmAKyFXIaL9LYpDRXIl/6r9JLa30i0oZ7gTOQWO90w5m5TICu7WWBrDV92/1iYEOjzQFNOeI5t579PHGfJDccK+XUqlbJWjhclqrfOeCAfOmyyT/5TRsmXs/FtMv0MhS3fsRUAxN9EGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN6PR11MB3485.namprd11.prod.outlook.com (2603:10b6:805:b7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Fri, 1 Jul
 2022 06:07:59 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5395.015; Fri, 1 Jul 2022
 06:07:59 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>
CC:     Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>
Subject: RE: [PATCH v2 4/4] vfio: Require that devices support DMA cache
 coherence
Thread-Topic: [PATCH v2 4/4] vfio: Require that devices support DMA cache
 coherence
Thread-Index: AQHYSpOCUIkD9YA9P0Wkck7HssDSt61peP0AgAARjAA=
Date:   Fri, 1 Jul 2022 06:07:59 +0000
Message-ID: <BN9PR11MB5276EBBA17A869C7489B41C98CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <4-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <b39e78e4-05d3-8e83-cf40-be6de3a41909@ozlabs.ru>
In-Reply-To: <b39e78e4-05d3-8e83-cf40-be6de3a41909@ozlabs.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 56447636-10bd-4f61-2e28-08da5b280cc2
x-ms-traffictypediagnostic: SN6PR11MB3485:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lWDZlGlcbBKySLAQf4zzBBgz7ZCbnhPAbWyNVZBPDZy1CcqXiGUawl9NWOkN079G1btyplcC0EVW5ORleNJp7oWRlFPYThSC49lvLSaK1pYaBI55piinFZBQLb1IXY/89NIHJ1Je8zG/dciOU6lPZtpd4Xd37kVs9w2ZyZVSpkO42vhhE6gBcn4tS77Lr1uPXuxVDwXSS48WtDZ/5WC3cmqkb5uS55T0ft7VTs1x98Z6mvSjyvtTXtIo77pLDdBx8++W2m5IdmPoq2eSYOd9tM6xGw/7O1g/cjPr8oJo1LnZdr5lEPGdoqnm5p4K1TpdNrkCrLBO4adAGmGQgSQWTGJ9YssHmm1v5hoD7w30YcxbvLTj4YdWcmVPNmMUfkCwIcjn4ZsZVbDXeJst60lWY1BNsnOPb+eagl0mebJADKRIUuhPQCiV6CwroxaFQ2tOBlpikXM0CjYys0hL+zeR9z7eq39EmgNOfZP0LB4Gb8Zcrb/hx49j6eFH+wOUo5mpm6GZ5cetbJSzaj/cOSb8bBqJOqQZF+XujdU9Oani9l+gYDsGkBeC8aStUR4hz2+Gau0nXgKMO0IfR0v4RxYbcf+Lk91Dhti6HN26/gqVEqp9tnT8OJnsrVGXnMwiISRMRAx/596rYbRaFeKafRCZ99x73wbQl3aBuvayPx5ISehdkLkszqORQxWLZXKKK0vVEMMKz5MJsy9PYSLrPSfffpVlhP5djAL5XtgA0CBCwCbGYzwtozPPe8bEo4sZt222uwY+sbLAqEIFdrJjlLvWnQ42X4EIcasEm044iPa7XZCs0jEltT6pPVxua5aMRfujoanYiVRVoTWl8BcpJHQNSw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(346002)(136003)(39860400002)(366004)(83380400001)(76116006)(478600001)(86362001)(316002)(54906003)(5660300002)(66446008)(41300700001)(110136005)(66476007)(64756008)(66946007)(4326008)(8676002)(66556008)(7416002)(921005)(122000001)(52536014)(38100700002)(2906002)(33656002)(8936002)(7696005)(71200400001)(82960400001)(38070700005)(26005)(6506007)(55016003)(9686003)(53546011)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dytYK2lUNkp2dzVyb0c4cUlYNTZhQU5aTzcva0N1YTlwdzdwMUlSY0FIeW9W?=
 =?utf-8?B?QVErS093T1hSdjlrVnRleWxZRDN4OUtYSkVpdGZBRjVBeXByalhOejlhSlky?=
 =?utf-8?B?WlNTTzVlNy9qM0p0MmhmbkVWbGNWWFFKUzBMTVJJaVNJUmMySXBYOWlaZE0y?=
 =?utf-8?B?NVBSWkZiWjlpYmlKUE9YUmw4SnpRL2cvZkc2ZlpwNTJtZWtjbUJnZUphZDBn?=
 =?utf-8?B?c01FU3VNR2lsYWRrUER3QkZxV3YrOGoyV0xuN2d6cmdqc0RXZmFOaGsrZmhi?=
 =?utf-8?B?MDcwUFA2UEhHSVR5Zk8zbmpCYnJ1YldaSVhGbWt0MTVqMFhtTytoRmVRSDBj?=
 =?utf-8?B?Q0VpV2lDb2QwRzRtZjhOTUdjaVZReFQ2MEY1TktTL1gzUndTd1B1TE9lNXdB?=
 =?utf-8?B?UHluNk5hdVRWalc4eHhqczJQdGZHaEw2aUtYVDlkY0d3Rm1CVyswaDZjeFh1?=
 =?utf-8?B?RDFpVlBva3RySFR1SHV3RWVRdlQ5elp0aXlETXREWGZIb0lPdlAyQTI2SlpN?=
 =?utf-8?B?YVFiMStTNmJyc3ZoQmMvUUE2cHJ4SEFqQkJLLzR6UnFSYk9QQnJQemJ3TFhR?=
 =?utf-8?B?Z3E3VUxrM3RTZFB0V01leDhuUW9mRWVRZTlVQWR3RHVrVlRSQjdsL1MyS0lw?=
 =?utf-8?B?bDVsQlhZK05FNkpLaHZmc2hVeEJKVUd1ZVpPTnNxeUpsazJwVDY4QlpFb042?=
 =?utf-8?B?MjBiZUoxb1FGdTVWUTNuek1iMTFrLy94QTNoazJuT1JhWWQvK1BNSGNURHpJ?=
 =?utf-8?B?QXlVdDFPNXBrc1Vucll1S2JPUzFDU0xZZnVIUzBWYVEzV252L0JhZkxOZFpX?=
 =?utf-8?B?c0pEaEJNV3JGUmszdzZCVS9iWStPUkdERk9rR1NxSEdiejNrNGFCZWZ6NUhy?=
 =?utf-8?B?NGUxYnBYTWNNbkduMkhaWXJCWGtTelFIb1ZXcXhIbnFjYWhsdEMvbGlKaDhq?=
 =?utf-8?B?b3hucURLWE9Xc04xcWp2VVVXYVgvMFY0ZWU0cXY1MDVnSWJveUNxMVBNSWps?=
 =?utf-8?B?Z0ZDYUFncHlxM3RaeHQ5UWgvODEwMzFub3dnVTZQQnllcW9UenU4R2pFR0N2?=
 =?utf-8?B?dkhaT2p4alBId0hKeEVpSlEwbkFpRjAxazZ6YUc5NmN6dmNCUTUrcGF5WjJu?=
 =?utf-8?B?U0hjTWZZK29iVUlzMW83R2RaTXd5VjBHbUw5SlM4bDBQRU5ObW94NFVkVnNt?=
 =?utf-8?B?TGdDVGZnQ1ZWYmo4a1Vwa052YU94RlUvUkNZWksrbnJRaWttalZ2ZzdTV2F0?=
 =?utf-8?B?YmNRSUpQZTRNK3p2dksvbmpRdVM4bE5hVUJ6dkxmK1FjOVJjR04zK2hTenJt?=
 =?utf-8?B?RmxoZDdJeVdqMUwvWmZ2N3E1U3RHZnNoZ2EvWlFHcEZhbjdHMEVIRUlSaVND?=
 =?utf-8?B?Y0R4L2FVSm1DT1pmRjNNRXgwdi9ZR2VxVStVcFNOS1pHNVhKLzQyZDVrS25l?=
 =?utf-8?B?NkZQVDU4U0FKTkpBQmk5ZklISC8xazdVN1Rha3B0YVROZUZSaitSZkZGNWlw?=
 =?utf-8?B?QWdFNlFtUmxZblVaa0RoVXNjamZSWUhCQ0VVNXFMdFQycmg4aElMOEVGN3Q5?=
 =?utf-8?B?djBpbXRGR0ZyZDN5U3M5UVovMW1JWncwbUlxeVJpSWV6cW1tQWNvdzBJd0R3?=
 =?utf-8?B?dWgyL0NTNTdJT0JodFlJZUZscHFldDMyb2RCYTIvaVQ2d3VHQ2lDNE1VR0JX?=
 =?utf-8?B?Mis5WFIzN1RJUERxQ2tkeTZnaU8zMGNnSUJBVHBxV2dnajdMdjNoYkJNaklB?=
 =?utf-8?B?V2lsSm4zNDNpa2tKdDBvMHltYktLYWp1eTBwUlNWYlRVNDR5QUN4a0REMUFs?=
 =?utf-8?B?TWkrVjNZSWVFTFFGM3RqMTE2OU4zaS8vZUgxM25VM1llbzEwNzJRWFJCS0tK?=
 =?utf-8?B?WVF5RDR5T05MUnRBV3g3Y1VlNTZuenRtQytZVjRXR2hlM1VSdkRYNEx6cTVr?=
 =?utf-8?B?R04vMGdEbWI1TlVwQWM5SElwSDJnbnVTZDN4WWRXa1g5K2VDMXRqR0RMWDlW?=
 =?utf-8?B?aXNXSk1MbFlCeWNUaFg2ZjhxU01DRUtwbWkrWHo0SFpsRm1HT2lsRW5FakNG?=
 =?utf-8?B?L3VKOEtXWHRDVEZVQWhjNWorMkhXTWUyaGVINXorR2J3ZUErUTR5QXZZWkM1?=
 =?utf-8?Q?bQYBrPlrI6NXjBDVtgMGKXjoo?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56447636-10bd-4f61-2e28-08da5b280cc2
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2022 06:07:59.6593
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1MgdS7uqLWVIiraVQSDqP0N7REmS/zFHjWo12afUsQxpiD2IzJwhgGCeubZfkqS8a80eeQ0DQpeUgXdG+xCGWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3485
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4ZXkgS2FyZGFzaGV2c2tpeSA8YWlrQG96bGFicy5ydT4NCj4gU2VudDogRnJp
ZGF5LCBKdWx5IDEsIDIwMjIgMTI6NTggUE0NCj4gDQo+IE9uIDQvOC8yMiAwMToyMywgSmFzb24g
R3VudGhvcnBlIHZpYSBpb21tdSB3cm90ZToNCj4gPiBJT01NVV9DQUNIRSBtZWFucyB0aGF0IG5v
cm1hbCBETUFzIGRvIG5vdCByZXF1aXJlIGFueSBhZGRpdGlvbmFsDQo+IGNvaGVyZW5jeQ0KPiA+
IG1lY2hhbmlzbSBhbmQgaXMgdGhlIGJhc2ljIHVBUEkgdGhhdCBWRklPIGV4cG9zZXMgdG8gdXNl
cnNwYWNlLiBGb3INCj4gPiBpbnN0YW5jZSBWRklPIGFwcGxpY2F0aW9ucyBsaWtlIERQREsgd2ls
bCBub3Qgd29yayBpZiBhZGRpdGlvbmFsIGNvaGVyZW5jeQ0KPiA+IG9wZXJhdGlvbnMgYXJlIHJl
cXVpcmVkLg0KPiA+DQo+ID4gVGhlcmVmb3JlIGNoZWNrIElPTU1VX0NBUF9DQUNIRV9DT0hFUkVO
Q1kgbGlrZSB2ZHBhICYgdXNuaWMgZG8NCj4gYmVmb3JlDQo+ID4gYWxsb3dpbmcgYW4gSU9NTVUg
YmFja2VkIFZGSU8gZGV2aWNlIHRvIGJlIGNyZWF0ZWQuDQo+IA0KPiANCj4gVGhpcyBqdXN0IGJy
b2tlIFZGSU8gb24gUE9XRVIgd2hpY2ggZG9lcyBub3QgdXNlIGlvbW11X29wcy4NCg0KSW4gdGhp
cyBjYXNlIGJlbG93IGNoZWNrIGlzIG1vcmUgcmVhc29uYWJsZSB0byBiZSBwdXQgaW4gdHlwZTEN
CmF0dGFjaF9ncm91cCgpLiBEbyBhIGlvbW11X2dyb3VwX2Zvcl9lYWNoX2RldigpIHRvIHZlcmlm
eQ0KQ0FDSEVfQ09IRVJFTkNZIHNpbWlsYXIgdG8gd2hhdCBSb2JpbiBkaWQgZm9yIElOVFJfUkVN
QVAuDQoNCihzb3JyeSBubyBhY2Nlc3MgdG8gbXkgYnVpbGQgbWFjaGluZSBub3cgYnV0IEkgc3Vw
cG9zZSBKYXNvbg0KY2FuIHNvb24gd29yayBvdXQgYSBmaXggb25jZSBoZSBzZWVzIHRoaXMuIPCf
mIopDQoNCj4gDQo+IA0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogSmFzb24gR3VudGhvcnBlIDxq
Z2dAbnZpZGlhLmNvbT4NCj4gPiAtLS0NCj4gPiAgIGRyaXZlcnMvdmZpby92ZmlvLmMgfCA3ICsr
KysrKysNCj4gPiAgIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL3ZmaW8vdmZpby5jIGIvZHJpdmVycy92ZmlvL3ZmaW8uYw0KPiA+
IGluZGV4IGE0NTU1MDE0YmQxZTcyLi45ZWRhZDc2N2NmZGFkMyAxMDA2NDQNCj4gPiAtLS0gYS9k
cml2ZXJzL3ZmaW8vdmZpby5jDQo+ID4gKysrIGIvZHJpdmVycy92ZmlvL3ZmaW8uYw0KPiA+IEBA
IC04MTUsNiArODE1LDEzIEBAIHN0YXRpYyBpbnQgX192ZmlvX3JlZ2lzdGVyX2RldihzdHJ1Y3Qg
dmZpb19kZXZpY2UNCj4gKmRldmljZSwNCj4gPg0KPiA+ICAgaW50IHZmaW9fcmVnaXN0ZXJfZ3Jv
dXBfZGV2KHN0cnVjdCB2ZmlvX2RldmljZSAqZGV2aWNlKQ0KPiA+ICAgew0KPiA+ICsJLyoNCj4g
PiArCSAqIFZGSU8gYWx3YXlzIHNldHMgSU9NTVVfQ0FDSEUgYmVjYXVzZSB3ZSBvZmZlciBubyB3
YXkgZm9yDQo+IHVzZXJzcGFjZSB0bw0KPiA+ICsJICogcmVzdG9yZSBjYWNoZSBjb2hlcmVuY3ku
DQo+ID4gKwkgKi8NCj4gPiArCWlmICghaW9tbXVfY2FwYWJsZShkZXZpY2UtPmRldi0+YnVzLA0K
PiBJT01NVV9DQVBfQ0FDSEVfQ09IRVJFTkNZKSkNCj4gPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4g
PiArDQo+ID4gICAJcmV0dXJuIF9fdmZpb19yZWdpc3Rlcl9kZXYoZGV2aWNlLA0KPiA+ICAgCQl2
ZmlvX2dyb3VwX2ZpbmRfb3JfYWxsb2MoZGV2aWNlLT5kZXYpKTsNCj4gPiAgIH0NCj4gDQo+IC0t
DQo+IEFsZXhleQ0K
