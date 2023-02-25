Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1E76A26A2
	for <lists+kvm@lfdr.de>; Sat, 25 Feb 2023 02:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjBYBqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 20:46:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBYBqW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 20:46:22 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D75564E0E
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 17:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677289582; x=1708825582;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=akmPBgaX+QX1sQsRxtVo712W6DuWILqw+XK3IT/0en4=;
  b=CQXZ1aALvjAzthXgKtvemD6HRonOdaQB/ve/GdXqN6morfWvWeb5I/Kc
   d69nyMvJN4NxknjtnwYog4YiUKkf49jCLoebPKmGE1wgUdDWknim3RZVh
   Yn427+mt1Fvsw6zHiCwcYke9iGJd26bCp/dweb2/+LUgB411S+co342o7
   UyQoLdMla+u4U6UzCbL9U4h0IP4db4kBe0mbzIwrAqnraCJebLFL28Mu3
   QlEPnfxfvt5J/3YXPJ8n1VQ0c32iRcZt/HrgTxOuRGpBWe9U4deurRv1+
   INBE9UGOdBWGIp89j8QPwgl1pVpVIyxcAMD5luIL9CTth4l0wlDrcIoiR
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="333624685"
X-IronPort-AV: E=Sophos;i="5.97,326,1669104000"; 
   d="scan'208";a="333624685"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 17:46:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="918611264"
X-IronPort-AV: E=Sophos;i="5.97,326,1669104000"; 
   d="scan'208";a="918611264"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 24 Feb 2023 17:46:21 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 24 Feb 2023 17:46:21 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 24 Feb 2023 17:46:20 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 24 Feb 2023 17:46:20 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 24 Feb 2023 17:46:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MQPH4dt3qqW/d0+XquSgHGW+RNjlh1qUizLuWUt0r+IUI0V83WBSKgQ4AFIyHiuCNcc5qYzCsJ1/hvky8MupfqDcMc6iB5C7IEr06ZpWiIXwKDVxoHkJyUkIuLv4WGygQoluQbWVzJxpxQ42uqkxxpsg/izHt7WyU3RVnhRVJWKgcLVTeSC7QQxNLvS0+OMx9NShVxX5Hl2cHI57F0EZBs4OrX3PrJ+n2cI6JFdqhSsHiI7qTzvViODsFLu8XCPNIgmF8TCWXpGQhaEClfPgicpudBtS+k8uEDhOmOa5SYSPnt3LBSNDNmh6lMJQGuBUjQQZ+ityLbJQ0D0t+6oEPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=akmPBgaX+QX1sQsRxtVo712W6DuWILqw+XK3IT/0en4=;
 b=RtTRvEfZyCqLSpwbeTHEmVHpWH9hIww0vOpvM2S61Cc0GU/tINuM1e7FqRIv5LT9f2NB+M6Cbi0r5IQkPQrJBl9uA5iV2G73YAbfrocT+QaecOoDJF6I5aYEA0b9BUeursEaPNkEDq2sC5N2FnQxpXxdVyjaIYQheimTtp1V0UCs3AaFTh7wXKD4J1eV5MlogLWbMCQqV4lCiHQnlHQLlvjwLYIs9yYDVHJ8nf0HAgbtOSu/PWiz72Ir0rGUdBOt/NaT77Lq3TEpAs/Fg2v9Pwi67N3NHmUOwsxFuomS9ToaUuZTOLJ9cOiRaT9SoinLWD0I1GnH4L6kxaiY2OFgqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 IA1PR11MB6193.namprd11.prod.outlook.com (2603:10b6:208:3eb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Sat, 25 Feb
 2023 01:46:18 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::7f91:b0b7:7b23:fa58]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::7f91:b0b7:7b23:fa58%7]) with mapi id 15.20.6134.021; Sat, 25 Feb 2023
 01:46:18 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "quintela@redhat.com" <quintela@redhat.com>,
        =?utf-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Mark Burton <mburton@qti.qualcomm.com>,
        Bill Mills <bill.mills@linaro.org>,
        Marco Liebel <mliebel@qti.qualcomm.com>,
        Alexandre Iooss <erdnaxe@crans.org>,
        "Mahmoud Mandour" <ma.mandourr@gmail.com>,
        Emilio Cota <cota@braap.org>, kvm-devel <kvm@vger.kernel.org>,
        =?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <f4bug@amsat.org>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: RE: Future of icount discussion for next KVM call?
Thread-Topic: Future of icount discussion for next KVM call?
Thread-Index: AQHZQfDqI9tbGvRklkm/jIyMCFf6BK7RmTE6gAABVpCADVW2UA==
Date:   Sat, 25 Feb 2023 01:46:17 +0000
Message-ID: <DS0PR11MB63732F34D2E6B924B35B2393DCA99@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <87bklt9alc.fsf@linaro.org>
        <CAHDbmO3QSbpKLWKt9uj+2Yo_fT-dC-E4M1Nb=iWHqMSBw35-3w@mail.gmail.com>
 <875yc1k92c.fsf@secure.mitica>
 <DS0PR11MB637307EE325932FC2F1AE7CFDCA09@DS0PR11MB6373.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB637307EE325932FC2F1AE7CFDCA09@DS0PR11MB6373.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|IA1PR11MB6193:EE_
x-ms-office365-filtering-correlation-id: 44178c03-75b9-48f0-8750-08db16d21647
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pb8f+PiVeKE4j3yfubJRYrsGJuGk4GNiAKRrOzhqNZhZUta3C4tFld/8HVq/G5I7poANxO9nB32+FlUuRQCXw503Z0E6EuyxQYhyownNGNdnN3TZAejDdfxynY1HwAuYTQKcRiz01XEZsCZPpcgK5gFOeP9eo7hE50Or6mEnmhsBUfvHXEX5YMgOuFtQarI4vEwsZ8zK84TasFDSK0NpPuVlK3b86GkPVieHOdKT0E4S49yPmzcJBt6ZMBhOHFLgDq4S8naDWC1F0KT+d68DY3J6Mn4c4gplkFctx2Q01r0n9DwoA4vMdbFXUgURt6fy7x/JhjBObUXWfyF4JS9w3gIml7CSxYNX1NU0MXqZyF7hBJjLnFirvNXP7Y8vwYHtvf8QOp+rEZ3dHj8Cf2ptH+JKdW5uKXfoK1t9jP8pIji2mTJ+lIbBgHJoJzBcaPuQs6/71K+apN3nstffQrlRdKEtjgDQvAFb72Txzp61HKTiPN75FYIAC5ziNQowfQQsc2wB8g9iq4g1eD1TtX4/VGkByGf7kphErDzyXFJhL+awj5JEGEPmUE+naS3Sg4zf3UJS5mvrqj5EyguDRpvu+cvyfsQji0RknAuJFFKkgO5DQcFFYiAz/a0YFui3rZLqVrxcXGXw0fsGkbDSY8vQoFUDyhWKU9YKiFq52cWZ010ErXCNtyNn+rFfoC0UjpIz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(376002)(366004)(346002)(136003)(451199018)(53546011)(71200400001)(7696005)(2906002)(66446008)(316002)(33656002)(122000001)(66556008)(64756008)(66476007)(966005)(41300700001)(66946007)(55016003)(82960400001)(76116006)(6506007)(66574015)(9686003)(478600001)(83380400001)(8676002)(38070700005)(110136005)(4326008)(7416002)(54906003)(5660300002)(8936002)(26005)(186003)(38100700002)(86362001)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K1JJb2M4d202Y1ZWM2NGNDlyekcxMlFZWTd3VU9ZZ1F3SUtwalZ3QVlVVFcw?=
 =?utf-8?B?TjBHNm83SWVNTklhazRmOGFmSnBrVW9JS0E3U3czN1V3UzdtMzF2bDBYV2wy?=
 =?utf-8?B?d3JIR0VzV29lUkxpYlRBYzFLV25SOWFydlpmOVFCamV6czNEdU1VemZKN25V?=
 =?utf-8?B?MTY5eWVheWFzWkgzaUllbnlSWVF0ZHhnUy9qY1ErQXNFS3U0bHRJZ09Vd2xC?=
 =?utf-8?B?enUxQ1NNdVRaa2VROWJXN0RESklaUzRnaTVhV3FhcWJ4dFkzNnBVRnpkcWVG?=
 =?utf-8?B?SGhWejFZZ0MyQXdPYTRRQ1R4Yk1qWjBiSDdzbDFBNHdvRXhyWE80UFdLQ1Nu?=
 =?utf-8?B?N0VYZ011OTY4eU9sSXlVYldSYng2THJIYkxybHdIKzdyV3Bqd3BIL2FMNEZr?=
 =?utf-8?B?VEI4NVVCaHVWWDFidlVST3BBSUUwdnlRSFVuOWpoZEtGNm44aHRqdkdQdkVL?=
 =?utf-8?B?YUVkMTNDTnhqYWZkS3EzM2ExTHFXK25IdklYRkxZaWVSNi9wTDFPTUozdWxP?=
 =?utf-8?B?SDBFclNWZ1NUZVZFZ1NWVXJSV0VOWDYrOURPaTM3UTE5VGlmalk4RHljOWNj?=
 =?utf-8?B?dmlMWWFEZ0ZMa2tkTGprN3VEQVRaMWJvQ3ZLVUFWWXQySHdZZWVvUzZyM3J2?=
 =?utf-8?B?MW5SNXdTd2xITW1EaUNrb2ZERTVrODlhK0t1ek02Tzh2RWFVWktlNDZhS29r?=
 =?utf-8?B?L3k1VEVHWGtNbG14UDM0T2F6UlZIaW5zeUZqOVBJQWJhS0phUFhONjVjTk1h?=
 =?utf-8?B?Qk83NENsbUJWWkQ3MHpFRW0wcHZ6cXZWZFhHWU5NOG85bVNHMFZlM3Rpd0hT?=
 =?utf-8?B?RU55WGVEVk5hRFRVRnVjQi9NVlcrbkMvWDVuYnluRDBUdXRjTXhjZFcxcmhK?=
 =?utf-8?B?S1RSUEtkeG9RY1ZEc3RlWVp2UlZNUFRIWW0ybzVlWEMvaDJVRFhoVjUrS1dH?=
 =?utf-8?B?Tm5RbGxpQUxqZW1VNzZOMXVxU1hQUVkxdzJhV0UxZXJtQUF6dWwydkpoQXQ4?=
 =?utf-8?B?Uk1GQXd2eFVvNFdKNFUwalVwQUlUc2FuS3hoNWdGYzNXMUtxaWZ1VkhkUjYx?=
 =?utf-8?B?dmdxYkZRZlBYQ29wbzY5dUZnYUFSMWlGSEpyTTBtWnRkNU5QRnhsbU0vd2wv?=
 =?utf-8?B?K2FBOVFEK240MnhHbGVzazBhNThnTU5wdk1NTDVjYm0xbWlBV1dKbDRiQ29l?=
 =?utf-8?B?WWUzVHo3Ny9sQWZBQUFJWnVXTUJjRTcxTjA4REFSQ3NTL01abWN1ZjdxSDk1?=
 =?utf-8?B?SDQrbnMvNGM4UktzZUI3SDBSODZESUZzcWx1TmhsOElNZGNIYVY0N0tJOWpx?=
 =?utf-8?B?Nmc0SkJuamhDclc4eURMcWliUnVZZ1hnK3VXZ0R3cGdFRVZMd29MMHh1Kytw?=
 =?utf-8?B?aTRONVZxQkxlOVF2UllJT3NpN0t4eXZCNHQrbU5hNXBIemdGTytLRy8xZStk?=
 =?utf-8?B?alVNSEwxTllPRytNNE5OZHorUHFVYXRKV2tGL2tVUHJZNXljWnZ5NWRpNkNC?=
 =?utf-8?B?RUZaMmw2aCtwdU1WT0QxRzY3QmVtQlg1TW1xcWxuWDBZbUNGUm9FSkR3NThB?=
 =?utf-8?B?UWhDRmg4OFJ1YTd6b3hmQVprbXJoL3pjQ3lzbU5rK3pTa3BqZmZiV3ZiTjlT?=
 =?utf-8?B?N2ZjRnpjQ0RlWEZ1YVdNNStjaFVINDNkanV5VlltenFMampycHQ3Qks4N3JJ?=
 =?utf-8?B?WXg2U3A1VFNidjkwNklERVhyTGpyRGVqT3N1bWd3RWVPVFREb1dQdVEyV29F?=
 =?utf-8?B?aWpYTitZVmE4WWxEUEhFMjlwbExJNU5INnZMNHdRV3g5T2llS3ZjZHE4T3Nr?=
 =?utf-8?B?dnl1WC80Qmt5em9HcG1YVGpDZzEvaEFxak51TEMwdDNmeWFNVDNqOVl1WUgy?=
 =?utf-8?B?M0hKcXhyUXBLREw3STV3bkxtamZmcjBiVlRwVktOR05ycHRTT0hyKzRSbW5Y?=
 =?utf-8?B?VlBqMVRIczZuOUJEakZ1OHk5MDFIaDlNM2o3TGhTa0M2c3VPbjRwUEN6cmRD?=
 =?utf-8?B?K1hmM2F5TU5pcFFwOHRCWTd2amh5SFVQa2lTcVp2Lzltb2FiY0QvNWJxS2NX?=
 =?utf-8?B?UHZWWFJtMWRaNTUxN0hKRTZqdkNYSTExOEJqc2pjZFhySzNTdUVLK2NkZmZn?=
 =?utf-8?Q?sz6s8EsYOKiWWunn+X0oibggO?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44178c03-75b9-48f0-8750-08db16d21647
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2023 01:46:17.5631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D/Bx3KYW5hgP1hiQlQcj31tb10/ho1wR1RTVcVhHNuLPzmcwPh0C+4K4Ee2lAoSKTE3PejLqxkTtP+nS3jTSTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6193
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogV2FuZywgV2VpIFcNCj4g
U2VudDogVGh1cnNkYXksIEZlYnJ1YXJ5IDE2LCAyMDIzIDEwOjM2IFBNDQo+IFRvOiBxdWludGVs
YUByZWRoYXQuY29tOyBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+DQo+IENj
OiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPjsgUGF2ZWwgRG92Z2FseXVrDQo+
IDxwYXZlbC5kb3ZnYWx1a0Bpc3ByYXMucnU+OyBxZW11LWRldmVsQG5vbmdudS5vcmc7IFJpY2hh
cmQgSGVuZGVyc29uDQo+IDxyaWNoYXJkLmhlbmRlcnNvbkBsaW5hcm8ub3JnPjsgTWFyayBCdXJ0
b24NCj4gPG1idXJ0b25AcXRpLnF1YWxjb21tLmNvbT47IEJpbGwgTWlsbHMgPGJpbGwubWlsbHNA
bGluYXJvLm9yZz47IE1hcmNvDQo+IExpZWJlbCA8bWxpZWJlbEBxdGkucXVhbGNvbW0uY29tPjsg
QWxleGFuZHJlIElvb3NzIDxlcmRuYXhlQGNyYW5zLm9yZz47DQo+IE1haG1vdWQgTWFuZG91ciA8
bWEubWFuZG91cnJAZ21haWwuY29tPjsgRW1pbGlvIENvdGENCj4gPGNvdGFAYnJhYXAub3JnPjsg
a3ZtLWRldmVsIDxrdm1Admdlci5rZXJuZWwub3JnPjsgUGhpbGlwcGUgTWF0aGlldS0NCj4gRGF1
ZMOpIDxmNGJ1Z0BhbXNhdC5vcmc+DQo+IFN1YmplY3Q6IFJFOiBGdXR1cmUgb2YgaWNvdW50IGRp
c2N1c3Npb24gZm9yIG5leHQgS1ZNIGNhbGw/DQo+IA0KPiBPbiBUaHVyc2RheSwgRmVicnVhcnkg
MTYsIDIwMjMgOTo1NyBQTSwgSnVhbiBRdWludGVsYSB3cm90ZToNCj4gPiBKdXN0IHRvIHNlZSB3
aGF0IHdlIGFyZSBoYXZpbmcgbm93Og0KPiA+DQo+ID4gLSBzaW5nbGUgcWVtdSBiaW5hcnkgbW92
ZWQgdG8gbmV4dCBzbG90IChtb3ZlZCB0byBuZXh0IHdlZWs/KQ0KPiA+ICAgUGhpbGxpcGUgcHJv
cG9zYWwNCj4gPiAtIFREWCBtaWdyYXRpb246IHdlIGhhdmUgdGhlIHNsaWRlcywgYnV0IG5vIGNv
ZGUNCj4gPiAgIFNvIEkgZ3Vlc3Mgd2UgY2FuIG1vdmUgaXQgdG8gdGhlIGZvbGxvd2luZyBzbG90
LCB3aGVuIHdlIGhhdmUgYSBjaGFuY2UNCj4gPiAgIHRvIGxvb2sgYXQgdGhlIGNvZGUsIFdlaT8N
Cj4gDQo+IEl0J3Mgb2sgdG8gbWUgdG8gY29udGludWUgdGhlIGRpc2N1c3Npb24gb24gZWl0aGVy
IEZlYiAyMXN0IG9yIE1hcmNoIDd0aCwgYW5kIEkNCj4gcGxhbiB0byBmaW5pc2ggc29tZSB1cGRh
dGUgYW5kIHNoYXJlIHRoZSBjb2RlIGJlZm9yZSBlbmQgb2YgbmV4dCB3ZWVrLg0KDQpLVk0gY29k
ZSBjYW4gYmUgcmVhZCBoZXJlOiBodHRwczovL2dpdGh1Yi5jb20vaW50ZWwvdGR4LyAgdGR4LW1p
Zy13aXANClFFTVUgY29kZSB3aWxsIGJlIHNoYXJlZCBzb29uLg0K
