Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3367D6BDD34
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 00:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjCPXwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 19:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCPXwh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 19:52:37 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFA3DC091;
        Thu, 16 Mar 2023 16:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679010756; x=1710546756;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pTtPl3uzY0hnS5pt7pR3ZhSP0AHMjEf6waK4ZgFlTjY=;
  b=XD/mzLbxJ4hiEoJZ51OCE67p+nuy3xThEBguuXcQcmP1NO7k8RT8b338
   Vrx/MSbjNuY9td9IFYHQAgqhZX25X0B1nGuz4yws2aNPWX0q/KkUXeyte
   6ccSSpqaxtPscVdkJaUXCW1yl/ELgxOCqpPmtZS+EY8IsQIfzNqeZEfdv
   mIn6Eu0Ev+VXhKKLVMTR4d2yP6zHqnkqgYpk7tFR2RaAPLgKshyOTYYsg
   zLl0QBf+el29ECxLLIjufE1jvPosAEsh1tD5tEdU1jWseTsQc0oKI4HPr
   OIOM40xq1ehFHN18JwoE635E9SKZKl6czRC9mqwOIYe4TaqWx0l6wzZwE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="321993241"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="321993241"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 16:52:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="769151735"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="769151735"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Mar 2023 16:52:35 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 16:52:35 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 16:52:35 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 16:52:34 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 16:52:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=erfepD+J2+gVs3+3bwu/OBh/SRs4gIOJ+V5Hu0krGBp6CMoEkE/vbQCVHeLIouJ40446Dyc8MhSzQzSiYqkd8nmKFpMG54CF740tfrAZFRb3gfJnF20fakd2bmeNE3n/Nr5GCNfHZtqpf1br7Db8GBmf38gjhhoaD4amGO879dtvL673R62zovisG+gjQV7A+ZXs/iWbcC2MJnEDfhxaUAonwkWHZtuXYszHAzApD/fizurbizJrV5N99Q2oJugY3RbfCMDaDLOqltpZC5QpkXAs5B265aOg4sSmORZj7sRcp7lHBgyt8QMogUz3q6dOCBxRdwoH5epytzFtxxFqWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pTtPl3uzY0hnS5pt7pR3ZhSP0AHMjEf6waK4ZgFlTjY=;
 b=ZAFOVpUgTZqFwCXUSCdKUbEfSpGIitbCFjgQ3jQ3F5ZiATQAopGl5ZJCTIye3Ho3soY8zG5QjBLoIfRwC3634A/f0PADSRmWPdyiy/SrDAhUll0HPqj6rbrV448NRukmHq5PagDqLeCDx716WrB8O2ZqQgi+gLOxSHTgBcdadghou4C+he1tuZjgHEmIc5D2+tyafOVQGfGgYHXu3ewymzq/gsXclPoGEQfYO24MLsw5DOsZaf8kVaHB/mH24FQnAt8n44HA5uqWWiQkhPWTT9vzeStu50/+3FH9PD8kkw/iGbiiEx+TKsZ8dPZGv2PyPndN/0VibY8mp2xczGlKAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH3PR11MB7795.namprd11.prod.outlook.com (2603:10b6:610:120::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Thu, 16 Mar
 2023 23:52:32 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.035; Thu, 16 Mar 2023
 23:52:32 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH 0/8] vfio/pci: Support dynamic allocation of MSI-X
 interrupts
Thread-Topic: [RFC PATCH 0/8] vfio/pci: Support dynamic allocation of MSI-X
 interrupts
Thread-Index: AQHZV4EkZaZAGPPvtUSaSe7HIBZWbK799WQAgAAcbICAAAJeMA==
Date:   Thu, 16 Mar 2023 23:52:32 +0000
Message-ID: <BN9PR11MB5276C1DE988777A97FC5D2A78CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1678911529.git.reinette.chatre@intel.com>
 <20230316155646.07ae266f.alex.williamson@redhat.com>
 <4d72821b-36a2-70c9-ee58-f7a21b13510f@intel.com>
In-Reply-To: <4d72821b-36a2-70c9-ee58-f7a21b13510f@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH3PR11MB7795:EE_
x-ms-office365-filtering-correlation-id: 9084e603-e794-4053-a855-08db26798274
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D+ftqh7nL1xjLhODcmiyNfsD1Gn8ptoFZ2N69CdbpOP9TYkyuzea0VWFQQj6OFH4x0P7AqXN6PHxVLPfxLo9T3dF/f/ElfObODiPg8fi5KBr9TvjJtdnLHKupuZNqTyvncf+Nw7Uau1ghYoamoojduqSAhzLTPDRp9tFbvtJiKAM2aVGoO+A3XnD17KNsxBuUUQzzD7JYExhBZCJ2ddEkm9LWF7TssV9QN/ukaR22OdegOO0qu7btYbjt4IcGAhC4Ft9vtYhasbtWwx2D0XomVHFQK7iYJNWp8Icpr8O2BDcU28xTafh7FcgBrzaB2ZYlLzz1O7+/DRZCiiUCmMr2RGbV7zwmKZaQNk/DGJ+Dp8ftX1RxtXwBqXEmX1KTj8Sg/P/EJc9SoItgJjGJvhIgH0YBJfME5/AYshAszzjdMyDWN1Uh0SSBUx/Ol6MBpaAj/KZd0EnMrdWj7dKg4RBsErI0WxmRaAYcJ9v5bkvJT09YzowLAS559afMOOHkpvuTC78fHvCKt/K3XkQCJgvYQNz/KBcH8b7NxqPzV4W2SYuQRpb3SjTeTODWvYM7K8GUQ2EEqEgn33BT9DW7NOBM1fFd5vIdrmtbqIxAbPfWgjpFb4VQr7+r5AOoooFbHx1S4ei8nS694ZUWJJt60pbFsGDhq5e55tzXuRgkXx6Cyt+Rp84pAei4EzNHvfyVSK93bF4ub+KDhiwe9DYn9u0kQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(366004)(346002)(39860400002)(396003)(451199018)(76116006)(82960400001)(54906003)(478600001)(66446008)(8936002)(66476007)(66946007)(41300700001)(66556008)(64756008)(8676002)(4326008)(55016003)(86362001)(38100700002)(316002)(122000001)(33656002)(9686003)(52536014)(26005)(71200400001)(110136005)(38070700005)(7696005)(186003)(5660300002)(6506007)(4744005)(83380400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VStlRGFYQVo3ci9RcW5BenJ5MnRwa3JFVUFLcm5qVDBFaDdjSlFMTzdjR2xK?=
 =?utf-8?B?U0tHMFB5MC9DY0R0cGZQRFMzaTJySWR0MnZWWWdUd2wwVDFLN3VyUENpNm4x?=
 =?utf-8?B?bmhmSTdaeVpCNld2dW50MXdDQ3I5SGg0TGsxWlpqOUpHRldBQmY2cWprMEc3?=
 =?utf-8?B?VWRuWmhzdlNWYzlPTzgyTE1Ib09sSVVBSVBVVlZsbGJVcmVhT0RxbU5pTVRt?=
 =?utf-8?B?TUNYWllGZ3VFdnJ6NjJDVlBScVpYRkRCdkZEWjdVR1RlUmErSTcvK0pMQ3dD?=
 =?utf-8?B?ZlloYXZ4UjFZV3Y3NUNBMzFKTE5wOGpuQUIwL3B2bjJOMjYrVEtIUnZjZ3I5?=
 =?utf-8?B?ekpIcm85VTlORlFSbDdodit6RVZpckVhTGp4UXQ3K3VDcHNxMFcxQ01WT21j?=
 =?utf-8?B?SkRFUS9xTVRGb2JvQytQUFhlVnFQR1Z6RmVmOFpwNC8wZWIralViTUhGV3pJ?=
 =?utf-8?B?TTROQTJtV3VBeUI5TzRSWVlPYVlicnJlNE5BNk40K3pwUUt2MkkyYlozcnFr?=
 =?utf-8?B?Vk1LRUpFUEdNbk03NVhBTUI4aXVqcnVkeU1JSy8xZ0dXSUo3Y1dHZ2NFMGhP?=
 =?utf-8?B?eTI0S0sra2xtYlFCNWVSK29kdXdLRVVpNGIwUzVwZjZCRDg2azE2KzJSb1Bo?=
 =?utf-8?B?T1p2V0t6VUxSd0Y3RkFwNGpLeFNpTzJJbGlnVFM5cjFFQmhqa1Q0WmdrQy9y?=
 =?utf-8?B?QUx6N2c0eXM3ZlNEVUJIZE1EYTlSaDBWZS9VRUlsUlFQVkVOVzQ3c1dLYklB?=
 =?utf-8?B?NGlUcW93N045WCt1NkF0TjVqWmcyMCtXV1QxQ1BsdGI3YzNVUGVoTkNrTVF5?=
 =?utf-8?B?TWgwU01Yb3ZPejNVZ0RFUVNQOE9ZVnQ5ZHBjMHVKb3dNeDlJdWo3NjBCM1Ar?=
 =?utf-8?B?M1B2UkwzNlFWTjhyRmt2aXFKV1JQdDg1NHBaQnEydVlvREZxaHRBWFBBNUZF?=
 =?utf-8?B?MVdyRURjNG5NTVREMXp2bjJ0bjJvS0dKQ2o3dWVVa0V6Z3Zod2FDRnFIQ252?=
 =?utf-8?B?OU5qamlxUTdaL1psVlZtZTdJQlB1Y25NTFVyTk83dHJIVFlhSWlLbWRxUXpX?=
 =?utf-8?B?bTVzZm1WZHJybWdvQ002MkpWbU9ybHdESGcySGJkSGRkVklNRlIwTlg3T3BV?=
 =?utf-8?B?WDF3M25QOHZmN0xpZHRmdHh3WldVTlIvT1JqYitZMUdrbDdQZmVyV3NUZ3hh?=
 =?utf-8?B?VDllSnk3cDZuU014MXpqM01QRWFHUnNVS25QTzVicUk2Zmp4M1Jhc1M2dTBS?=
 =?utf-8?B?QnErbml2YnpjMGZ4ZDBlT2Q4bS9mK2NkaHBVcTNQMzU1Y05RbHFNeWRRUXVr?=
 =?utf-8?B?RVBDZE9mL3Urd2YrYk5tdU9KNC83ZmtKOG1CbHo4dUNxWmNHd1MrRCtZc3Ez?=
 =?utf-8?B?clpNWjFPYldGYVVsVy9aeXphaEI4YndsOXVOeVc5VXhLTkhzZEFBanJ3YnBW?=
 =?utf-8?B?Z3ZnZGx0d3lUa21hNzNvTktGRWVTZ2t0TUVjYW11WERYK2RSZ2tLSUlZSDVN?=
 =?utf-8?B?V0dXNGhXZ3dOWmZUdExkRGEyT3loa2RpYUNQZ3Ixaks2Rml0MU1STm14Mzhs?=
 =?utf-8?B?NFN2bDQ2Z3duOENjTE9aT1Rpdm5lYkhhN2dhbmxFMGZnMUFka3ZTR1l4NW12?=
 =?utf-8?B?Wlh1LzA1NjNuM1hrTDlQcmplUDhEWGlzNFFkSHN6T2ZBYndmR0NrbHhSUzZH?=
 =?utf-8?B?b2pHUVZRSlhVSVp4ZVdDV3REMFh6NHpyTTUzRWMwbUZWbkdWdGIzMmJxOFlo?=
 =?utf-8?B?eVE1cm1SNmVuSm5YUC9WWVRqcnVXNGM3YldSLzg2QTdWV3YydHZGNHhza2dw?=
 =?utf-8?B?N2ZFcnJDN1EvZzYyRURCbXBSN2E3emZWK3Y4MGdHVi9tOEo1MXNZNTdKWnJ3?=
 =?utf-8?B?SzhhQjAxWi9OcFdrc1FoNHBjTFFBY2VrWXpodVByOUVGYTl3L1o4TE5hS0s0?=
 =?utf-8?B?aU5MSlJKa2E3cmxLS1FvTnJMeWpuaVNRRVNlT2k2Q0ZmM1M1bDcwWUNwTDlT?=
 =?utf-8?B?aDlHSE9HbWdndGsvUlZPVGp4STJVWjlKRVJ4QnNDNC9pNFA0TFRqTHhqSG1I?=
 =?utf-8?B?NzZZdmhIdDFzS1FRRjZ3Zi84UTdUQ0Npb0RJdEJJM0dqVkE0MUZPQlhlOENC?=
 =?utf-8?Q?4cdvHA3uKGwcjLxo0Kxli7aKx?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9084e603-e794-4053-a855-08db26798274
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 23:52:32.4170
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BJiJTybKeooz8qR1jRGvfwZruzOLGlxhs4XCJtSIF3mU6nwAQyZRzBhtKdQNyU/TRmzumcas5KTVlHb8Zz7AAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7795
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBDaGF0cmUsIFJlaW5ldHRlIDxyZWluZXR0ZS5jaGF0cmVAaW50ZWwuY29tPg0KPiBT
ZW50OiBGcmlkYXksIE1hcmNoIDE3LCAyMDIzIDc6MzggQU0NCj4gDQo+ID4gQmFzZWQgb24gYWJv
dmUsIHRoZXJlIHJlYWxseSBjYW4gbmV2ZXIgYmUgYW4gZXJyb3IgaWYgd2UgZXhwZWN0IHRoZQ0K
PiA+IGRldmljZSB0byB3b3JrLCBzbyBJIHRoaW5rIHRoZXJlJ3MgYSBtaXNyZWFkIG9mIHRoZSBj
dXJyZW50IHN0YXR1cy4NCj4gPiBEeW5hbWljIE1TSS1YIHN1cHBvcnQgc2hvdWxkIHNpbXBseSBy
ZWR1Y2UgdGhlIGRpc3J1cHRpb24gYW5kIGNoYW5jZQ0KPiA+IG9mIGxvc3QgaW50ZXJydXB0cyBh
dCB0aGUgZGV2aWNlLCBidXQgdGhlIHBvaW50cyB3aGVyZSB3ZSByaXNrIHRoYXQNCj4gPiB0aGUg
aG9zdCBjYW5ub3QgcHJvdmlkZSB0aGUgY29uZmlndXJhdGlvbiB3ZSBuZWVkIGFyZSB0aGUgc2Ft
ZS4NCj4gDQo+IFRoYW5rIHlvdSB2ZXJ5IG11Y2ggQWxleC4gSW4gdGhpcyBjYXNlLCBwbGVhc2Ug
ZG8gY29uc2lkZXIgdGhpcw0KPiBzdWJtaXNzaW9uIGFzIGEgc3VibWlzc2lvbiBmb3IgaW5jbHVz
aW9uLiBJJ2QgYmUgaGFwcHkgdG8gcmVzdWJtaXQNCj4gd2l0aG91dCB0aGUgIlJGQyIgcHJlZml4
IGlmIHRoYXQgaXMgcHJlZmVycmVkLg0KPiANCg0KV2l0aCB0aGF0IGRvIHdlIHN0aWxsIHdhbnQg
dG8ga2VlcCB0aGUgZXJyb3IgYmVoYXZpb3IgZm9yIE1TST8NCg0KSWYgbm8gcGF0Y2g1IGNhbiBi
ZSBzaW1wbGlmaWVkIGUuZy4gbm8gbmVlZCBvZiB2ZmlvX2lycV9jdHhfcmFuZ2VfYWxsb2NhdGVk
KCkNCmFuZCBNU0kvTVNJLVggZXJyb3IgYmVoYXZpb3JzIGJlY29tZSBjb25zaXN0ZW50Lg0K
