Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66BCA625D23
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 15:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbiKKOel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 09:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234589AbiKKOec (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 09:34:32 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC1D5B5BD;
        Fri, 11 Nov 2022 06:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668177270; x=1699713270;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4ygzOMi23HMfHTqPtQCYLSBkdFKNLNhf+lrK1Ee473I=;
  b=QgNkJWouFy9xV2QL+J8KDj2Op/hLzr5hJ2ujyaZAeRsiH6JaXrmE5yE+
   Fgt2DsYGciViXN6Vi/ae/JrtoiW3syTsXnaBf4njNXtyHNTA6VROp5ABR
   qkuciP9DzynlURzljfst+N7I1Mjl3fMYpBEI+eUYT+2Rdk6z1j398LgDR
   g/Qmqwfr4nN74O+KJoMTc4SlHIlvTaM3HMq4N5xL2efZHzqavhflBbDdE
   AslCaZaENroDt5A3Ut5ofy56W6VxUkEnxtHA5DEmGf4GtqwEFMkaR6LhI
   MjNSoQKedg+WU7i0lpziQcg2uYHXOpE7FnoZBdvlwoDv1oXFNcxZ/yx+a
   A==;
X-IronPort-AV: E=Sophos;i="5.96,156,1665471600"; 
   d="scan'208";a="183119818"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Nov 2022 07:34:27 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 11 Nov 2022 07:34:08 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Fri, 11 Nov 2022 07:34:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mgp5jLkgWzcvk6ncDpglN1U5XW1DXVXaL6SvOVtun1KWbtR4jL+Y54+BxzTtX0ZD1kK2Oip77Fgxt0PY51nEsRrc5GH89IpxlAFsPaHeax5vmRpI8DVTI0YZnQO98PlVvZMaPOzn9ONswUXXjqCs7/1dapGSjIM3fTnEuFz/V0FKIEwAnjSXxM2adcSpnlFzfcvCcMisLWFWOiI49DR/tze5YIINPdVjoxVgF3sRpqaq0f7QebSDBFDAyR06G+285epwgpTUjCqXcKMF37Uz1FeiYZCJ1nO9Gghr1Ck3QxXPdFwX8/9q0CdJPYDWucWSMTXwaxk9w7uZDVCsWwJHbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ygzOMi23HMfHTqPtQCYLSBkdFKNLNhf+lrK1Ee473I=;
 b=NzIeaWRn2Nw8y1juZtj48vwpyJ7RiVFiAosd0mNgF0QHyxEgFrloS229gNKikVNmhGU25euQ+Dd8ukHJd3MFs+FTezg2NbijrqTw9Z/Mi5Z3zPh0N6dtY/5pkOMcWmvq2yNCW7IxHZ6UL/+DFdvib2jFIsx8VSu9RVhZ+btxAZWdYnhk9WdYkYSJOzoJuYv3CV78oXlpqXJZFDLNP/3V4WJSB/fzKCRo67VzfLMaU92TShznR/IOga/s9VeEeHRjRj9kM4V1pst2lPPf1jL9xZHq04C4u4tbr9IIZH8+JMuyHQwXshsUenYxeEppT/LYkA7G3ahUQfnW5qzcgt2PDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ygzOMi23HMfHTqPtQCYLSBkdFKNLNhf+lrK1Ee473I=;
 b=SmH5B25ItgodBGtlw5V6EIa+jYbbj4A5wTIGTnR4XB7SIJhi3vYMyglUZbx51YM8gckej07uaBux0SkrvLbSliL7IVU5Nnsgnmt/9PhZe4OVYZu8be2MKIvNxEP4QRXSgFwVqtMz123DuEFe3mBOE67GaNMFw9b2rhdVFil1kF0=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by MW4PR11MB6569.namprd11.prod.outlook.com (2603:10b6:303:1e1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.14; Fri, 11 Nov
 2022 14:34:02 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::6a0a:e787:bf0d:83cf]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::6a0a:e787:bf0d:83cf%7]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 14:34:02 +0000
From:   <Conor.Dooley@microchip.com>
To:     <bigeasy@linutronix.de>, <Conor.Dooley@microchip.com>,
        <jszhang@kernel.org>
CC:     <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <anup@brainfault.org>,
        <atishp@atishpatra.org>, <tglx@linutronix.de>,
        <rostedt@goodmis.org>, <linux-riscv@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <kvm-riscv@lists.infradead.org>
Subject: Re: [PATCH v2 0/5] riscv: add PREEMPT_RT support
Thread-Topic: [PATCH v2 0/5] riscv: add PREEMPT_RT support
Thread-Index: AQHYvWTJWdidtLbFYESs6cM+7jS71q3KyLAAgAFXEYCAAAVoAIBuFNKAgAAAhAA=
Date:   Fri, 11 Nov 2022 14:34:02 +0000
Message-ID: <ea0188d3-3886-6cb6-6811-82e4ffd992b8@microchip.com>
References: <20220831175920.2806-1-jszhang@kernel.org>
 <4488b1ec-aa34-4be5-3b9b-c65f052f5270@microchip.com>
 <YxIAmT2X9TU1CZhC@xhacker>
 <ea5cdba4-7a79-56b3-f8d7-7785569dedd6@microchip.com>
 <Y25c626x6UPRtscs@linutronix.de>
In-Reply-To: <Y25c626x6UPRtscs@linutronix.de>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5154:EE_|MW4PR11MB6569:EE_
x-ms-office365-filtering-correlation-id: 0eeba87c-b900-4de9-d275-08dac3f1c750
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 76a2u4D6rJ7WD/ptNEf8XSUzyCuA+UEU8cAo90w7qeQ7oR0nyyATkUSD9L68/ytXw4sbQ+Rja0woXJ+40UZ8HQFG5VPnSgWS0qZZf/bo/RnLSWCF+EqLEztUC+nUDVK4+rzTEAro2xWZA5Trgm/anH9bF5/HbkchTsDy+phPc7xaJT0yx1NRKQDJ/qlWxeZ55LiDgsXNrRkQCQpozR/YonFfAyTixkVApaf8bLjz2c5UsepWOIRsUTe1TYHTcmPjuJlJcM3AcSQXPwRCI9WD6zpsPsQ+F9sY0mOW4JayMxe8B0kiNocUZ+fquM7KWT5HKo7WgMrZqrcEcKMfRuKA3mX7bK7sXLj1GykVWvdlm+Vy4X5193xKKXwDtqdzUmwMVmCJfKRZSVL103zmAe0ZeptyGwdDjB+gwP8BVxSn2ohqwiBL/4Tgc/fluGfMB0vaTit002AySzbz+3T2euxmnCnq2pD7z948g7IM/Zh2U1kPWSPwufl+BmxqKF2zcICISaEFNmIFM6DSUZsuC7vo+r7vy9w5S07gq1nyoR+kj2YX+MfjwQ95+rKjVnQ3hyi18iM2eGrQmSVyyieSIyeDmQkEGX3UNiSoTmSHEHX/EKW2bcaD62vwIHcveFQ3VWwHHR+OXmN4lG+iFvchBe5hEIOOPtVkOhRHrXSmZwPbKhAgf7GykclXYZH02hECbhwtDhrKr5qnekrewYWU7tfRmupSY7MvWcgG6vRCW2fiBMVhawOG/Gc+0IcKHBJrC5Ue62gDss97o6WmAi9eP2HXET3SPk5k50dZR6t6Vcioa/ZktqHI2Qh/jHTeholQOmsYnJKvXfcg4qXP8RlKL0RzGA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199015)(41300700001)(31686004)(64756008)(8676002)(4744005)(66946007)(4326008)(66446008)(66476007)(66556008)(76116006)(5660300002)(110136005)(54906003)(316002)(2906002)(478600001)(71200400001)(7416002)(8936002)(6486002)(26005)(6506007)(6512007)(38070700005)(53546011)(2616005)(186003)(83380400001)(38100700002)(122000001)(91956017)(86362001)(36756003)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S241SU0rNFBIRy92ZXhVSjMzb2RlaEF3c3BzTUhQR1djcXA3SVVnK1R6K0FU?=
 =?utf-8?B?RmhyVVp5TnkyMEVsbUFjTlJzenpwYmVjSmhtY3ZzVTQ2akVKODArSFQ0RUNQ?=
 =?utf-8?B?SXRnSXlxV1VzYWZFRTVHVVZGV0NCVVp0UlI2US83Q1l6S1J6UFI2c2NKYVRI?=
 =?utf-8?B?TGo5K0xwZkZGWkowc2YxaGpUYVdEdEZzSW42QXlXbXBaVG4yT3VYemtpbGdI?=
 =?utf-8?B?MlRkUndBdzJvcmJybU9TcGdoRENDa1J1bFEzaU1zSUxBQk1ReXZLQzJoOHh3?=
 =?utf-8?B?RW95U0lmeGFISzRZRnEzRk54UXROdXJLcFg4bGtkZDcxZ21iNWNOTk5xNCti?=
 =?utf-8?B?Rnp3cHRnKzl5WkdLeHhBNnB3TFdYVXpNZ0R1WXZkQlNBNnhOaVAyTWM4empU?=
 =?utf-8?B?U05rWkdFMWE2WG5IL3VEYXUxbUx0SjV6Z1JhNWVGUWpmTkFqLzBjNmc1cCt2?=
 =?utf-8?B?aUlJUmlCQ1dldnBPYldQT0VQSkQ3OHJ5Z0FzRDlHZExkdk1CdFIxTS80dHJh?=
 =?utf-8?B?eTcvekNWMmdKU1RMS2E3YW1yU29YQjN1Sk56bkFHejJ4S3owalhwamJtTWV3?=
 =?utf-8?B?dkZvK2NJei9QQ0ZpUjlUQnJyeUpSRFJBTWl5WkZkN3N0Q1hpVTNSVzVyZVh5?=
 =?utf-8?B?VFd0Y3Q0ZGc0aExKemloaENZODQzTytXMHkyNjdQMnNpNkhFTkhHQzVSdUNJ?=
 =?utf-8?B?QWhuWWVFejhXOExxOXVoa0loVlBsYVZSaHlBZS9pVGthWDQvR3BraUU5eDQz?=
 =?utf-8?B?SzhwSHpsaXhHTHhjNFBnd0ozU2JXVlFpVDNpUndUVHVNUkRsdlRML0tOWjYy?=
 =?utf-8?B?NUs3QTJLeHZhanR6QkZGZmFZelNUSTN5WFNBeEJwajUxb2F5dzMvK3pBNGNW?=
 =?utf-8?B?QXBZTW53SzRnYms5VjR3Vy9nMlJwQi9lc1dkRGxHUEVablZmV3MydnNMMUtu?=
 =?utf-8?B?SVh1TnFLaWJPelBDWVBBQkMzUjhzdWlSS0p5L0ZnVXdaVXNtUkZwN1I2dnFN?=
 =?utf-8?B?TElqaSs0R2RtbnpIUlZ0bjJRSGdxMGtwVzJFY2IxeG81MExmdkdPWHg3VzVz?=
 =?utf-8?B?NkNzZTBid0R1cEcwR05zMUJkcENUbVhJS2hacGVsZG5nZEVtS2ZqRzVESjVL?=
 =?utf-8?B?bFFPRHlwbWE5cW8yN2puTG5CenI0bHBVVmlOc1hma2dkOEMzMmN1WDc0cEN5?=
 =?utf-8?B?VGJZbjlkQXJwSXB2aXAxOTQ0akpKRnJ0cnhKRzRJNVV2ZmRmOEZLNkxtTk96?=
 =?utf-8?B?YW1uMUVpSjUyZDNSS3orQVRMUE5iKyt1YklsczBjeXFZc3FZeUY2TUpMRm9P?=
 =?utf-8?B?bGdBZE8yZE4vMCtabFNWOEV6WGVMTkY5UHRDRWI0MjRaTlVQUG5xT1Z5YnlX?=
 =?utf-8?B?cUd5WmZOa3dHWHZhSk02cjd2Q09LUU41ejhtZVlucWh6Uzk4S3psR1AwV1di?=
 =?utf-8?B?Q1hTaHRKeGJRWFFPY3RkWGlSMk96dmhrUDNRQkwzbkFpYlFyeTJ3cW4waElp?=
 =?utf-8?B?Z0RRZW1LMFVnbUtMK3dDcDdhL2dDRzhrOU01TWF2TnJRb0ozZGpCTGVNNzBm?=
 =?utf-8?B?TTZsK3dZUEFhUTJOM1AwbitRZnlLRjQ3dWRYOWtSOGVEQkE5WHBMOTNsZVBL?=
 =?utf-8?B?dlZha0lTZFpjV1pMbERZZkpxVEZWVXZCRWlVaGVmOFVDT2packF0Z29aR21t?=
 =?utf-8?B?ZGJ6RDNUQWZac2JjQmNVZUt6Z1o5Rjc0dEhCWU5kSGpqd0VxbGJHdldHNUxy?=
 =?utf-8?B?angrbm0xNmwvSWhRSnpWNy93TnRHTDMreFhxait4cmUvdmFWR2kzamY0R1Fy?=
 =?utf-8?B?cnhIUUNrdGFvSk9aQVdkcldvQTBzVStJTndqVDFXZDNwc3JnZmR3VWZienQy?=
 =?utf-8?B?YzdUWXdvWnM1TUlZUlphaFRFckd3aTVDaHVxSVhFS0JkVVJRakJTU25BbmR0?=
 =?utf-8?B?cFRZRktkSGRrOXZoOTJuUTQ3MlNhMHp0cTNURkVkQWxXdzc4dHg2Z1ZTN0l3?=
 =?utf-8?B?TUMwNDExZHBFZjh0aW90V0FmMG9PL0RXUi9QMXNrZlhqRDRJZnFlY2VoNGgr?=
 =?utf-8?B?ak5qVGZzUWZWSkt5QTFxMkl4VmtrcWJ6VC9pZlJWd05Sb3VDMm50QVQ4Zksz?=
 =?utf-8?Q?cPn3QYeBkjLS4AlySEFSuZApk?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C6E6C4396324F4EADD015E2433E7BBC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eeba87c-b900-4de9-d275-08dac3f1c750
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2022 14:34:02.4218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zqMB6WX3nMrtOzM4WFsA7aUm6rJmxAYYQg1S8NsZogWBzMhgOXLVnUgAU9t7yFudA9yCn3NBp9WceSHgO2HcMcdc9AwDFxW/9LWZv39rEKU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6569
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMTEvMTEvMjAyMiAxNDozMiwgU2ViYXN0aWFuIEFuZHJ6ZWogU2lld2lvciB3cm90ZToNCj4g
T24gMjAyMi0wOS0wMiAxMzoyOToyMyBbKzAwMDBdLCBDb25vci5Eb29sZXlAbWljcm9jaGlwLmNv
bSB3cm90ZToNCj4+IEknbGwgZ2l2ZSBpdCBhIHJ1biB0aHJvdWdoIHRvbmlnaHQgb3IgdG9tb3Jy
b3cgJiBnaXZlIHlvdSBhIGZ1bGwgbG9nDQo+PiBvZiB3aGF0IEkgc2F3LiBUaGVyZSdzIHNvbWUg
c3BsYXRzIGFsbCBvdmVyIHRoZSBwbGFjZSBmb3IgbWUsIGJ1dCBJDQo+PiBjYW4ndCB0ZWxsIGlm
IHRoYXQncyBqdXN0IGtub2NrLW9uIGZyb20gdGhlIG90aGVyIGlzc3Vlcy4NCj4gDQo+IElzIHRo
ZXJlIGFuIHVwZGF0ZSB0byB0aGlzIG9yIHRoZSBzZXJpZXMgYXMgYSB3aG9sZT8NCg0KTm90IGZy
b20gbWUuLiBjb21wbGV0ZWx5IGZvcmdvdCBhYm91dCBpdC4NCkknbGwgcHV0IGl0IGJhY2sgaW4g
bXkgdG9kbyBsaXN0LCBzb3JyeS4NCg0K
