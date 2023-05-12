Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 267E9700515
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 12:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240584AbjELKSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 06:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbjELKSk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 06:18:40 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D2ABF;
        Fri, 12 May 2023 03:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683886719; x=1715422719;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XH3G/S82jjpoRyERqbKQ/8zkXzblEjLndphALXBqwF4=;
  b=fHRANIfB/hj1m+MuD9dqDwU5XUSCUKmszqKeEWBXsZtaQJIwh+biKjOf
   Tx82L7TQH4Ua5BWtt36RekA/RHGhIwVUENHiBx8aH4WZSJZeY8bdmgjVy
   gZ1gfiSy5qE+zGKc9IC7gjQ2h7UgNlDteTklISkdJoEJYTMkAbkSgFVVs
   f1Zz7S1oYsKCWpYmAx4pKGe7xtblFMpNMNEelJrCSQT/Y63J1cajDIw+D
   MqtkiQ/b20c7CDk0NfYDUVWNabRXMBHoU30tEVCm8TOG0QeAbHpFmZXCs
   oNDcWVQjHG7HHkONnfCMPCSlp+WLu2DJclyJ01AhM2Dy/b58WX1f5j63K
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="353004922"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="353004922"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 03:18:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="874351656"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="874351656"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 12 May 2023 03:18:39 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 03:18:38 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 03:18:38 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 12 May 2023 03:18:38 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 12 May 2023 03:18:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mREZJZDuWJGHt1a16LCNmjZlDU5ZuYKa71tvt/uICbRL41Klw2KBuSsRHl4HHvVpv96/59Z/hX9X/zPfQQf1gA1lr3BzUSlg7ODUIW5P73tsZB4XoQMcXdUU2kn7fZ3Rpc51FtYBLReFxxraeHEN5d6LrdqvUpW1fp4DksVyCpFw+Mf24NfsWpNssvVyeN5xOl3pmvXggIp+WJSDX2njHYPqzYZOH9E4hFa4cq8Lljs+z97Ht3XvTFFRxCmLnw+axOlVxHn75POhyNIRU/15cYqCuCVs/v1j7QcSergouOvFmcmKgvRR1EpHsaq221wbP7b1frjzdN32Z8NyHhqJOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XH3G/S82jjpoRyERqbKQ/8zkXzblEjLndphALXBqwF4=;
 b=RxUdScxCPGTxO/J2OeVrcFaXzyMTNrD95FBKX+mIufMIB2S4A9yBIcX6tC1Htqyz0wIbofcQuKJteS6iGbuq3NF8Lqfj1b+KJ59lIlSx+uH28fsgOBZjTh+hKG0/oJuiajFCzf/1o6CcLMoIAxz/CTiVhEQzJm4PicnGipkks2CdOGTp0NEYLav9oh/a3Nc9TmgZ6qC7u2Ox3G069nEsJTgeR66arYbBEb+5bKCdtxnrhEe+JkjiPl/eWgnLqtOodi369AwM2EjCb8ie05Cc0YJ+zyNN3F0ucXR5U4ftjO6oglYQDwodUy/NIpOvY6TxWozQpgj+PIAyEStkwJwyMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB6713.namprd11.prod.outlook.com (2603:10b6:303:1e8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Fri, 12 May
 2023 10:18:36 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6387.023; Fri, 12 May 2023
 10:18:36 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "guoke@uniontech.com" <guoke@uniontech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haiwenyao@uniontech.com" <haiwenyao@uniontech.com>
Subject: Re: [PATCH v2 1/8] KVM: VMX: Open code writing vCPU's PAT in VMX's
 MSR handler
Thread-Topic: [PATCH v2 1/8] KVM: VMX: Open code writing vCPU's PAT in VMX's
 MSR handler
Thread-Index: AQHZhGEUYJysSDFfmUK3Z3IsOe/R1q9WbXOA
Date:   Fri, 12 May 2023 10:18:35 +0000
Message-ID: <a6007433b0be75237a3afb8c2e213399e6e00e49.camel@intel.com>
References: <20230511233351.635053-1-seanjc@google.com>
         <20230511233351.635053-2-seanjc@google.com>
In-Reply-To: <20230511233351.635053-2-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB6713:EE_
x-ms-office365-filtering-correlation-id: 69dfff35-e2b2-4c56-d829-08db52d23f29
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RCYdx57KH8CVkVPp1krCkEdtBrmTq/uIb1iCMgSIiX48JOo5v6qcmbpN0dJ9gkOtpyhOfmPa9ffcCFRDakFbjszCL1WNvd0jNGAT0HHcKUtTeaIMwdHsrbL3vxv+9hcYBvqY0XTNFuT1LWcDYAwV2XdXxSsrNF/f6JTTSJZVeURSexdtRE79mSWZEM+0xxeAxPMBhVHWhssr9I/pl6Y0zQeliatme67JS3QbPaW3w7Yt1ADcz9H7fCivxrtChx+OHnf5VijF7RR7g7oUZ2I+KkBUSUJWsU7f0y8k80DZkog+MP0j6jaOnFVSvmHBRUqpvfbvNKifkrCZqm42ngbBk7Pypc0M4LXepOy68zmZRcLa9E6cFAeSzGkT7gPBs5GdzwGvLySrwmnrCvYfkAPpOMtJ6vNwNwp4vrrTTxI5SMcKyb0fLnW0hxDbgYP9CElNPomeuw9J0QFiBxpUL8I6jBovigczT6jUPeTC+AoEVsxnPh6jLDsm4yLAncp0iY1DHrTeIAPNwU+bMvFjex9MPlMu3D8fXkvFyYM6EAli2+E9R0E9FZyatsG2Ey40vKGrqp2UPu2sU5iao0Egb227qc2C3fhj8QvVQkG6jPyyA7Jt+mUQvXiNLlmRYthhEtpm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199021)(2616005)(4326008)(83380400001)(26005)(66946007)(66556008)(64756008)(91956017)(6486002)(66476007)(6506007)(76116006)(186003)(110136005)(71200400001)(316002)(5660300002)(54906003)(478600001)(2906002)(86362001)(38070700005)(82960400001)(8676002)(38100700002)(122000001)(41300700001)(36756003)(8936002)(66446008)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QU9KSmhVNmpKQTE4TnB0VzR1MFlBNjBka0VDc0dGTzB0anZXTDFJellqN2wr?=
 =?utf-8?B?ZVpCOGZWQm0vWnhsb0hyNVBVN09vWCtVWVFPL1E0Yjk1UFdGdGQrSVEwaWd0?=
 =?utf-8?B?aFdVWWkvSUQ4QmhBYjE5a1hPM2JMMlhmSFhZcktrSzM0eXBmanU1dVhRRUgv?=
 =?utf-8?B?VTFEbURSd3RpbS80KzI3ZU5HQ0p3WGlWZURqSEFlUWVpcTJ5SHdlTjhWSWVn?=
 =?utf-8?B?MnYrU3lQMEFSMlVGZjZzcmQzSWZUcHc4dXY1S1RIMWpPSE1RQXhGeXVPRzBw?=
 =?utf-8?B?V2ZJMjVaM2U2Z2JCZEgyKzc1clhETXdkY3o3VUNPZmZzc0NlaVhpanlWcW5Y?=
 =?utf-8?B?YkJCbTVhYVJTeHhZNkZRcTRiU0NaWkpzWGdtOGtVV1AzMmNPVFBnTHFZR05H?=
 =?utf-8?B?Nm9WVS9IdWxxSDYyMU9uWkhNOWpGTnlic0hQbGFOMWh1dllMUlJlTmdPdzZO?=
 =?utf-8?B?WUM3cFFCS1dYVkczNVF6TUdGMitvazl6TEdheHliOGRaaXowWU82OVJDdDFC?=
 =?utf-8?B?am9iZFNla2E5VGdhKzVmT05jR3Fac1ROMW9PV2hRT1FlMjIvdzdXZis2K0xR?=
 =?utf-8?B?dUNERVBaNFRuQUNjR0d4VWpObXM1M2NZRGh2M2ozNmNUY2xMVjFSL3huU0Na?=
 =?utf-8?B?VjV6dDRGaGJxRXhKNDJ2azdoYktTMFZKekpnNUs3R0YwWEdrVHJzVTdaTm9j?=
 =?utf-8?B?ZE0rZmlkVkpUeksva2Q5dWh1YmlwTDZLcEVIUnhFM1l5SENQQWxUeGdra0dm?=
 =?utf-8?B?akQzYmZKbXpvZklCek5YK1dWMTB2S3BSN3hZOVZnRkVhNW9nRUVoeXo0aW42?=
 =?utf-8?B?WEFPcExNbDEzdnp0RDdDZERnTmsxYk5SMFYwMCs3MlJrRC9mSktDeWNSSFls?=
 =?utf-8?B?UThsVWk1ampIVWRKakJuR2hNaDl6L1EzNHBwZ3B2VGs1WDBGVFU2NXdKUVQ0?=
 =?utf-8?B?TVBFdXFxZzQxVWNwVVVVcmZvbmlpNlJiYnJnTUFFVlY0ekQvRkRpUGtDNjNG?=
 =?utf-8?B?Y01vcloyZmthNnI4WW9CUGpPem5EMmNwbnF5NmVaRm4vRWZoTjQ5NzNwaUV3?=
 =?utf-8?B?VXVKaElheEYrb2VwWDJydWVLOXBGMmxDUUtHUGEzd3YzYjZzQ2JxbUFucWJP?=
 =?utf-8?B?M3VVd3ZseTlmSjBOVXd0U0VadmJoM1RzQjlaM1BzT1pXNEQvU1l2bzZmV1JB?=
 =?utf-8?B?WTlEdWlndFRLck04NXE4eG1IY09nUHBLdE00eWJGMmJoOUl4WTNFd3RSUzls?=
 =?utf-8?B?dTV0ODJERXkxQThLY3dGT3BhQWFoMUZaM203dHljWS91Mm9EVUpXc3M2WjlV?=
 =?utf-8?B?Y2pLTTVlRlVtOG9udHZTM0hwTXBYbm5wRktPN3RpL0tCSFZUcjZ2V3RuZmdW?=
 =?utf-8?B?RGxaUjZEbnZ0UVNRNXZ4aWpNTVFPc0VTUFhrYmdYWWhpQVB5aG5xSUtNOUUv?=
 =?utf-8?B?MFZIVmFGR0UrVDUxaTdJNHRSaVNmZ3RBZXNFQmZoQkhhRFJSclpjZ21FeVNz?=
 =?utf-8?B?a3cvUmVpQlhXTlFmSEZoNkRndnFUSHpSTE1CQU04THZvb2F3eVo3WWpVTDUv?=
 =?utf-8?B?U2wzUXJFYWhLVGZTVi9HcFdycmJyd3hwVFlLYXo0VnhrZXZlZE5IUlFyTnhR?=
 =?utf-8?B?K0dDVXVRNkNhZ0RiZzd3YVVkbEcwclQ2T0dFRlRYY3VuRkZGUFFkVU1HRmh6?=
 =?utf-8?B?cmttYWhnNGZFdkJFdEMzMlNyMWhzazhaeGFkS3lESUJRS0FzeVZIa2FDT3dR?=
 =?utf-8?B?c2c5UlF1NTROOVoxYlFvcmFKUmt2UlZvc1lCTEJJZDN4UFhiOVpRVEhFQzhS?=
 =?utf-8?B?RXlES3lvdkZnWEV0YVU5cHBZY0RzNnVhYVR2Si93bEVhS1RSaGNYZFd2Tm1U?=
 =?utf-8?B?TzVoYm1ZbWppMDk1eHllU0NEK1BmM25LbElkNitnVThzb3RKLzEvTHJSY1Jh?=
 =?utf-8?B?eDFpWGp1UkJHSnVGWEtBNDUyZkViYVdhZjZEeXVJbDQzaUhONE4vUmRJZGE3?=
 =?utf-8?B?TXU5VHY1WFNlUUZ5T3VXNTJXM3lsYW56dVVwVERiWTFjeGdqbjZrVHozTXpy?=
 =?utf-8?B?U2s5aXpIUXMzekNYMlh5L2czTG4zMVhFekxUNG5JOGxxRVkvRFVRYS95RHRO?=
 =?utf-8?Q?PlZD7/HfFnriChF+qIiFzSG8D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0A39944A5574184585983A5BA7BBA8F7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69dfff35-e2b2-4c56-d829-08db52d23f29
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2023 10:18:35.8963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tBJ+6hTJu6U28OQsBFHQfUdlZdvPYEzPlAV8xLuny9A45SlWofdxpf4/WMvcL9Ifq/w79wEIHoX5KdCkHKmzBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6713
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA1LTExIGF0IDE2OjMzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBGcm9tOiBXZW55YW8gSGFpIDxoYWl3ZW55YW9AdW5pb250ZWNoLmNvbT4NCj4gDQo+
IE9wZW4gY29kZSBzZXR0aW5nICJ2Y3B1LT5hcmNoLnBhdCIgaW4gdm14X3NldF9tc3IoKSBpbnN0
ZWFkIG9mIGJvdW5jaW5nDQo+IHRocm91Z2gga3ZtX3NldF9tc3JfY29tbW9uKCkgdG8gZ2V0IHRv
IHRoZSBzYW1lIGNvZGUgaW4ga3ZtX210cnJfc2V0X21zcigpLg0KPiBUaGlzIGFsaWducyBWTVgg
d2l0aCBTVk0sIGF2b2lkcyBoaWRpbmcgYSB2ZXJ5IHNpbXBsZSBvcGVyYXRpb24gYmVoaW5kIGEN
Cj4gcmVsYXRpdmVseSBjb21wbGljYXRlZCBmdW5jdGlvbiBjYWxsIChmaW5kaW5nIHRoZSBQQVQg
TVNSIGNhc2UgaW4NCj4ga3ZtX3NldF9tc3JfY29tbW9uKCkgaXMgbm9uLXRyaXZpYWwpLCBhbmQg
bW9zdCBpbXBvcnRhbnRseSwgbWFrZXMgaXQgY2xlYXINCj4gdGhhdCBub3QgdW53aW5kaW5nIHRo
ZSBWTUNTIHVwZGF0ZXMgaWYga3ZtX3NldF9tc3JfY29tbW9uKCkgaXNuJ3QgYSBidWcNCj4gKGJl
Y2F1c2Uga3ZtX3NldF9tc3JfY29tbW9uKCkgY2FuIG5ldmVyIGZhaWwgZm9yIFBBVCkuDQo+IA0K
PiBPcHBvcnR1bmlzdGljYWxseSBzZXQgdmNwdS0+YXJjaC5wYXQgYmVmb3JlIHVwZGF0aW5nIHRo
ZSBWTUNTIGluZm8gc28gdGhhdA0KPiBhIGZ1dHVyZSBwYXRjaCBjYW4gbW92ZSB0aGUgY29tbW9u
IGJpdHMgKGJhY2spIGludG8ga3ZtX3NldF9tc3JfY29tbW9uKCkNCj4gd2l0aG91dCBhIGZ1bmN0
aW9uYWwgY2hhbmdlLg0KPiANCj4gTm90ZSwgTVNSX0lBMzJfQ1JfUEFUIGlzIDB4Mjc3LCBhbmQg
aXMgdmVyeSBzdWJ0bHkgaGFuZGxlZCBieQ0KPiANCj4gCWNhc2UgMHgyMDAgLi4uIE1TUl9JQTMy
X01DMF9DVEwyIC0gMToNCj4gDQo+IGluIGt2bV9zZXRfbXNyX2NvbW1vbigpLg0KPiANCj4gQ2M6
IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogV2VueWFv
IEhhaSA8aGFpd2VueWFvQHVuaW9udGVjaC5jb20+DQo+IFtzZWFuOiBtYXNzYWdlIGNoYW5nZWxv
ZywgaG9pc3Qgc2V0dGluZyB2Y3B1LT5hcmNoLnBhdCB1cF0NCj4gU2lnbmVkLW9mZi1ieTogU2Vh
biBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQoNClJldmlld2VkLWJ5OiBLYWkg
SHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQoNCj4gLS0tDQo+ICBhcmNoL3g4Ni9rdm0vdm14
L3ZteC5jIHwgOCArKystLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwg
NSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5j
IGIvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPiBpbmRleCA0NGZiNjE5ODAzYjguLjMzYjg2MjVk
MzU0MSAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPiArKysgYi9hcmNo
L3g4Ni9rdm0vdm14L3ZteC5jDQo+IEBAIC0yMjkwLDE2ICsyMjkwLDE0IEBAIHN0YXRpYyBpbnQg
dm14X3NldF9tc3Ioc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3QgbXNyX2RhdGEgKm1zcl9p
bmZvKQ0KPiAgCQlpZiAoIWt2bV9wYXRfdmFsaWQoZGF0YSkpDQo+ICAJCQlyZXR1cm4gMTsNCj4g
IA0KPiArCQl2Y3B1LT5hcmNoLnBhdCA9IGRhdGE7DQo+ICsNCj4gIAkJaWYgKGlzX2d1ZXN0X21v
ZGUodmNwdSkgJiYNCj4gIAkJICAgIGdldF92bWNzMTIodmNwdSktPnZtX2V4aXRfY29udHJvbHMg
JiBWTV9FWElUX1NBVkVfSUEzMl9QQVQpDQo+ICAJCQlnZXRfdm1jczEyKHZjcHUpLT5ndWVzdF9p
YTMyX3BhdCA9IGRhdGE7DQo+ICANCj4gLQkJaWYgKHZtY3NfY29uZmlnLnZtZW50cnlfY3RybCAm
IFZNX0VOVFJZX0xPQURfSUEzMl9QQVQpIHsNCj4gKwkJaWYgKHZtY3NfY29uZmlnLnZtZW50cnlf
Y3RybCAmIFZNX0VOVFJZX0xPQURfSUEzMl9QQVQpDQo+ICAJCQl2bWNzX3dyaXRlNjQoR1VFU1Rf
SUEzMl9QQVQsIGRhdGEpOw0KPiAtCQkJdmNwdS0+YXJjaC5wYXQgPSBkYXRhOw0KPiAtCQkJYnJl
YWs7DQo+IC0JCX0NCj4gLQkJcmV0ID0ga3ZtX3NldF9tc3JfY29tbW9uKHZjcHUsIG1zcl9pbmZv
KTsNCj4gIAkJYnJlYWs7DQo+ICAJY2FzZSBNU1JfSUEzMl9NQ0dfRVhUX0NUTDoNCj4gIAkJaWYg
KCghbXNyX2luZm8tPmhvc3RfaW5pdGlhdGVkICYmDQo+IC0tIA0KPiAyLjQwLjEuNjA2LmdhNGIx
YjEyOGQ2LWdvb2cNCj4gDQoNCg==
