Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5FE5A9D46
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 18:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbiIAQmM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 12:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233452AbiIAQmK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 12:42:10 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2BC74DF1;
        Thu,  1 Sep 2022 09:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662050529; x=1693586529;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/OOJf/IbuVmCXNoMeeMPjAzrIBVmDkkOgYDzXOC2FjA=;
  b=nKZxRLmIdQnjBozgGE8RU0YHXglIGzO3c7P8asZiuPZOZYqBtAI5/wC6
   3//etUUrtzwa9hLmINcbl9TE+XE3N5xxJQyMGHjyw2kL1kg3Q+eyYkN6h
   IWhRR1A0Sl81zL3P52RFbKSx2BCumuX4W1LHztzPolHxRiZjoZxd5t1bR
   JR572+M7P1wShdbrkK99WJTSFo5skBJfJWg6J9CC0xlHX9NZnEEkl1AWw
   XbI3Tx/sgR1krt4QGMj2JYC7rlzcegbeNij2BsDJVMs40Agy1rAulfvCU
   sfb5EA7M0g+8WbWdXLq0hFB2Npsw0Ar/kyw6weU6RiwwyxaUBBIUyKgKG
   w==;
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="111788135"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Sep 2022 09:42:07 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 1 Sep 2022 09:41:58 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Thu, 1 Sep 2022 09:41:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VTBnWIuuyjn7s1UC3lnP7TTfBTSrtigl0Vgghb3d33FKiOEElS6u4OsM4B20urXIREa6xZ7PlFHlLcA5sDPY4niwFqNGN8Qg7VytYLC7IaplLotrr/j04mGqH9nKJVQZNVuJQODCyJmdFW1y3QeK/xuxb2+erY43ojHzryGqhYmVIY5DyyZ74RY0ZQj46GIgk/Gf9xDF2APzWVNfYt5OXScKz3nur1kOdjq0ZmAhMjYWSaE73v3SsAO49dyWAODKkx+F1UnNctFxtLQKQ92rMNWpLF/nXcjoZbKze7MWKqpB5WziYbk6j70vGzGY5/1+AcxgiqZLSultK1oxgHpOJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/OOJf/IbuVmCXNoMeeMPjAzrIBVmDkkOgYDzXOC2FjA=;
 b=Q8h6m572I3WNTmePUvQJ5rJPFIIxOEko+k65XqgsRWpHL0j8Bcejc7es0EMeCZMPHUsPqm5kQhKaExeXFfPPBQEiGq8CTrkkGHkMB6jQrno90vVzVkhmuTznDfO5/S5xfqCq9bwjYATf2MAFTMfZO7VY960PzMlxJQNQbUe5xpa+z6V1Nt2H7XPswxmzc0FekILXhkVXVddYGP/XIvMJgWLqgEJDase3GwufeGY9FWsc0l0TBz3V6zeb5Jt2mV3SeiuQFPmGZHkdLhj+3ErlZwOVuDZSlnx8sIoz+Ak5ZtnPXch6s1hKwpZnraBvbdd7u23uKTTDIkQGuqqTbWwE1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/OOJf/IbuVmCXNoMeeMPjAzrIBVmDkkOgYDzXOC2FjA=;
 b=McIFnrjxA9s3dzHk3YbXKEdivEdE4Zhua90OZslcvZdoSMZ1iJEpGsqL15YDwyn+LhWKnlcteB2f3AdKYfDH8W6QBZn4vMSVBamXockbCfLbq4M0wGl0/VbgSO2SdNyqTunu/udpIoc9FTT4MLn03IJa5bIfFtFf/E7j55avA1U=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by SN6PR11MB2925.namprd11.prod.outlook.com (2603:10b6:805:cf::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 1 Sep
 2022 16:41:53 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::545a:72f5:1940:e009]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::545a:72f5:1940:e009%3]) with mapi id 15.20.5588.010; Thu, 1 Sep 2022
 16:41:53 +0000
From:   <Conor.Dooley@microchip.com>
To:     <jszhang@kernel.org>, <paul.walmsley@sifive.com>,
        <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>,
        <anup@brainfault.org>, <atishp@atishpatra.org>,
        <bigeasy@linutronix.de>, <tglx@linutronix.de>,
        <rostedt@goodmis.org>
CC:     <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>
Subject: Re: [PATCH v2 0/5] riscv: add PREEMPT_RT support
Thread-Topic: [PATCH v2 0/5] riscv: add PREEMPT_RT support
Thread-Index: AQHYvWTJWdidtLbFYESs6cM+7jS71q3KyLAA
Date:   Thu, 1 Sep 2022 16:41:52 +0000
Message-ID: <4488b1ec-aa34-4be5-3b9b-c65f052f5270@microchip.com>
References: <20220831175920.2806-1-jszhang@kernel.org>
In-Reply-To: <20220831175920.2806-1-jszhang@kernel.org>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f27817b7-cba8-40a4-3df4-08da8c38dffe
x-ms-traffictypediagnostic: SN6PR11MB2925:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MVZoOgicjx4zM/guofublhxjf24irPKvIP3KhQMSYOq8MtDSE1Mqt59hAG+u78DHjMy9wWgem+9L0IlbbU58ve0ZUSHBHZSeEKLXF1JCGvqVlJSOTrrLfEXZtXr3kBO5zwKlO63hYKIxBJ2s870j0/9bv8LHObF2RKShqgHQdPWDX4rmUCaSgtG6W3oVoROnLwAPzoEU/cH3w1CfNUkpKYYPGLzAbYTJMLkLPedMusHvTMK5dBWXCnUt80Jr/+D9PGm9J0kTJabIXV7844p6GX2ozJNg0USjTBTMBJ8qvP35f/+pDCmG/vENcmiciV0X5S1cg5PngdAT+N/0toqZ5Zu7fWkG1XqFtBzCFkn8Ir8WgrdxBfpoqogUtB3k2DtdxAhmyDhEiL1ZYI7QB+yJZNu0SuyE7QsjH4gwN2JEmK7can3ThjVIS8h0Ibt2/cmhheKmCYEXwTxc6FX17bIVN4o9F6OXXqAKg3gg1PwEuR8TxGuiF5pxd1ILp2Gs7Atw65fm0aIF25sMpHlJGta7iRyRgJLp4W7MlruA26Vx8p+5aWqRGN3Hms9yEgV28/5AbLN+G36JzxdPlIDO8fAaeTt4f7DcF6kxjs69bCP4pb6UnJflqyuTvRk3Znan5GEUZzz8et1MCUqGVyfuPmGEvaDV6jepirmeCNk2EmDOzyqmgBZlJTFWg+g8pIfCBAOiGdP/vLRoBOKlnlN7JVwwnB4HhYd0oGjIxShqdjRYKKtwd0y+c1/IFpIZ3uLiD0BEfaQeaJlVLOUlE8zggllJ2Bj1ySJEAfN+CHBIKl7O+08U3dmQMirfRbugigcqPv8kRnhF9pSEzblcBHjrJFqCg1G+McrrvyRYY9EXfyF9M+4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(376002)(396003)(366004)(136003)(36756003)(83380400001)(186003)(2616005)(38070700005)(91956017)(54906003)(316002)(31686004)(966005)(71200400001)(6486002)(110136005)(26005)(6512007)(31696002)(2906002)(86362001)(53546011)(6506007)(5660300002)(7416002)(8936002)(41300700001)(478600001)(66446008)(66556008)(8676002)(66946007)(76116006)(4326008)(64756008)(66476007)(122000001)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y29adkxrYUVLcGl3bDNLajhnNXoyendhSTRvTXNpa1JXZ3VTL0Fabjhic04y?=
 =?utf-8?B?WUVoQUJMMzJSMlhsQVlOLzNvQUhKY3ZnNzVQcTlxUWUzdXVOSkpUTjE0TU15?=
 =?utf-8?B?dVU1eGgyM0p1MDBQSnhTSGNIaFU5OXhibjBBYnFhRkVQQjBjQzVBU3RUQjNn?=
 =?utf-8?B?Tmp2Mm9IU2c2QWJYTXJGSkxYSlg3aS9mSzNEeC9yZC9GSVVXWGRIbkVwY1hZ?=
 =?utf-8?B?U1N5TWl2SHBNNEJDeGJFWUZiTVpCUHdyTzRTZjNHdlE5eDFQM0tNcFRrK0pP?=
 =?utf-8?B?SUErOCtPS0F6aGVtUlA4Uno0bnFYeExyWTh4S3E4NHdiVGgydTR1Q2FUTGJB?=
 =?utf-8?B?N1R6VTQxcVdpUWlUcVNoVFhuLzdqN3ZIV1ROUXM2T2lPa0U4VUhCUUFUZzhx?=
 =?utf-8?B?NW43YkpnVFRWMTdtRE1wZmpaZnErb0FQL1dLL0tYaEk0WjdodjhucVl1VTZN?=
 =?utf-8?B?MGlVMWFJYklROXZLVW9VS3pXZjBJOC9wUVFSRnJ0TDdFNDh6Y1ozM0E2WW5I?=
 =?utf-8?B?SlQzS0k4cncrOHF3MFNqeGdSeFJGL0tqSUxzOWhCcVIrU3FNWE1oSUFUWUJy?=
 =?utf-8?B?SjdYNHp2dGYvcjBVL3V3a3NwOVFvb0U1NmRQdVFGbTNpdkladUlEbExuOFI4?=
 =?utf-8?B?eWg0elNwYjRtMEpWSnZjMWVOSUdydDRvUWErWElQdzVsUlNYVEV3YURCRU8v?=
 =?utf-8?B?WnRITTZUd09wS0J2RGVrNXBOeXJCSFdjdWFkL1dJZzVoT0VqbUdUSklpQ0Jj?=
 =?utf-8?B?NmlleXZpR1hEWTlyZ0xBMm5LV3NONGdpd0xjR09tMStWR0RSaTlvK0NDcEgr?=
 =?utf-8?B?MDlUTm0za2tsaFBLeG5xWmIxUUM4UUY3dnU5ZDVWSjhMTWZrc0NXZXcxTnhE?=
 =?utf-8?B?R0VLUDdCS2FQeGc5Q3c0STQvaitRN2VEZGF2Z2xXd1BuRVM1NFE2M0VwaVkw?=
 =?utf-8?B?QTZyRndyYS9uT1RFUjR0NEpaZ2tkMDJoV01hZFpuVk5hamZwZVFidEdHUVJH?=
 =?utf-8?B?a28yVlduSU9XU0ZWQU9TMGQ2bnRLZFpxQ0lsWU50ZlRoY3JXMkRleGdCVUtp?=
 =?utf-8?B?MGJSdVloMEgvdDNSZFJmYXR2MXhCS1JvR1NqZVJWWU04bU5oU011Y28xUTlY?=
 =?utf-8?B?Q1JUVUxwMUM5c0hsdUNGbnFFRHBJTG1tRk1wZjRXSWFGK3hKQysyL1QxZ2Rp?=
 =?utf-8?B?MUw5VkFVV1ZzdkU4bSsxdDg0TTg2R1hENXJ5cjV0NTZ6RGZzUVNpL0plQU1N?=
 =?utf-8?B?T3Q1Z050ZTgyRU1yd24vdEFUY2VRL3lDRWZMcWVhSkV3RTYvNE13LzlzUHdW?=
 =?utf-8?B?N1JhVnF3MGZrdDl6V2hhY041c25hUVJYY3ljWjVPbUE5Yk5VQXIzZXR2MGV2?=
 =?utf-8?B?QWhYQzA5WW5LSTVaZ0hFWE9zdmJ0WjNpYUtSOEJJV240d3JHbVpkelRyWndx?=
 =?utf-8?B?eHhwdFY4OUlRd3FWS3BBeGpvRWgxeDI5T3Ztd0ZkZkovR0JpK1M1dk5abFZH?=
 =?utf-8?B?NVdJQ3UyaHJobzdFSUpTVitsclFvd0dmYzdPdWFwUzdYNVczeFA2cDF5Wlp5?=
 =?utf-8?B?M3dvTlBFZzZVNEpIc3VnVGFnaGxsaER0dEhkd1VHOGZReXFtaVdnaU1JOFJ3?=
 =?utf-8?B?Z0xVejVoNzFlUmFtcXBIc3BxWHJGVUo2cTFLN2pjWEtoSERvUkt1R2lzUS94?=
 =?utf-8?B?Ni8wVSsrclo4MEpVeGg4RndWQ3M5dTZCQmFpdlgySERoNnkxSy9zN3Zja284?=
 =?utf-8?B?QW1INW5qRFRJNDdyanZnZmt0TmJoNmJ6R2d4RGVDU3dPUk5CQUc5QnBSYXd0?=
 =?utf-8?B?ZUdsNGF6cnVGTXdJUHFCYXRNeXpDOGxjZzBwY01JR1R4bDQyVWdYbW1ydm43?=
 =?utf-8?B?WkN5SFdOVkJObTJ3QzFRODB2Yy9HYi9JdFBHempnNU5sTzdnYkNCMzlseWlw?=
 =?utf-8?B?WC8wWHJXRUJrMVA2eGpGaHlYcWprb0NCWDUrOHc0OGVrL25SQnZaQ09vM2Zv?=
 =?utf-8?B?SjNVRVUwcGJYNG9EUzF2Uld5NVg4bWJmV1B5bEI0MEh1YmFEbzMzYVVjT05H?=
 =?utf-8?B?QjdNZ0dxRFQ5NXdoalBhaDNOOGY1a0hISS9YOWVKYnRUbHFLSE5NU0tlTFJk?=
 =?utf-8?B?MWNmQllCTXFKeDBuWEZ4Wm9OL1UwVHdvUktwZjZqMWdlTk90aEg3R3RNanpj?=
 =?utf-8?B?L1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <100FD227D367FC458DAFCC4097D47609@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f27817b7-cba8-40a4-3df4-08da8c38dffe
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2022 16:41:52.9916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhCF0NuxkSPYAdLGggwD97FeIeROhGrf0zdXu2nY0a6nP8lSI5Lpc/M9FUZa5eZqOt40h9GmoNqGS3CDYpRpgW7mSzTS60nyzLBS4QxCaPQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2925
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMzEvMDgvMjAyMiAxODo1OSwgSmlzaGVuZyBaaGFuZyB3cm90ZToNCj4gRVhURVJOQUwgRU1B
SUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25v
dyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBUaGlzIHNlcmllcyBpcyB0byBhZGQgUFJFRU1Q
VF9SVCBzdXBwb3J0IHRvIHJpc2N2Og0KPiBwYXRjaDEgYWRkcyB0aGUgbWlzc2luZyBudW1iZXIg
b2Ygc2lnbmFsIGV4aXRzIGluIHZDUFUgc3RhdA0KPiBwYXRjaDIgc3dpdGNoZXMgdG8gdGhlIGdl
bmVyaWMgZ3Vlc3QgZW50cnkgaW5mcmFzdHJ1Y3R1cmUNCj4gcGF0Y2gzIHNlbGVjdCBIQVZFX1BP
U0lYX0NQVV9USU1FUlNfVEFTS19XT1JLIHdoaWNoIGlzIGEgcmVxdWlyZW1lbnQgZm9yDQo+IFJU
DQo+IHBhdGNoNCBhZGRzIGxhenkgcHJlZW1wdCBzdXBwb3J0DQo+IHBhdGNoNSBhbGxvd3MgdG8g
ZW5hYmxlIFBSRUVNUFRfUlQNCj4gDQoNCldoYXQgdmVyc2lvbiBvZiB0aGUgcHJlZW1wdF9ydCBw
YXRjaCBkaWQgeW91IHRlc3QgdGhpcyB3aXRoPw0KDQpNYXliZSBJIGFtIG1pc3Npbmcgc29tZXRo
aW5nLCBidXQgSSBnYXZlIHRoaXMgYSB3aGlybCB3aXRoDQp2Ni4wLXJjMyArIHY2LjAtcmMzLXJ0
NSAmIHdhcyBtZWFudCBieSBhIGJ1bmNoIG9mIGNvbXBsYWludHMuDQpJIGFtIG5vdCBmYW1pbGlh
ciB3aXRoIHRoZSBwcmVlbXB0X3J0IHBhdGNoLCBzbyBJIGFtIG5vdCBzdXJlIHdoYXQNCmxldmVs
IG9mIEJVRygpcyBvciBXQVJOSU5HKClzIGFyZSB0byBiZSBleHBlY3RlZCwgYnV0IEkgc2F3IGEg
ZmFpcg0KZmV3Li4uDQoNClRoYW5rcywNCkNvbm9yLg0KDQoNCg0KPiBJIGFzc3VtZSBwYXRjaDEs
IHBhdGNoMiBhbmQgcGF0Y2gzIGNhbiBiZSByZXZpZXdlZCBhbmQgbWVyZ2VkIGZvcg0KPiByaXNj
di1uZXh0LCBwYXRjaDQgYW5kIHBhdGNoNSBjYW4gYmUgcmV2aWV3ZWQgYW5kIG1haW50YWluZWQg
aW4gcnQgdHJlZSwNCj4gYW5kIGZpbmFsbHkgbWVyZ2VkIG9uY2UgdGhlIHJlbWFpbmluZyBwYXRj
aGVzIGluIHJ0IHRyZWUgYXJlIGFsbA0KPiBtYWlubGluZWQuDQo+IA0KPiBTaW5jZSB2MToNCj4g
ICAtIHNlbmQgdG8gcmVsYXRlZCBtYWlsbGlzdCwgSSBwcmVzcyBFTlRFUiB0b28gcXVpY2tseSB3
aGVuIHNlbmRpbmcgdjENCj4gICAtIHJlbW92ZSB0aGUgc2lnbmFsX3BlbmRpbmcoKSBoYW5kbGlu
ZyBiZWNhdXNlIHRoYXQncyBjb3ZlcmVkIGJ5DQo+ICAgICBnZW5lcmljIGd1ZXN0IGVudHJ5IGlu
ZnJhc3RydWN0dXJlDQo+IA0KPiBKaXNoZW5nIFpoYW5nICg1KToNCj4gICBSSVNDLVY6IEtWTTog
UmVjb3JkIG51bWJlciBvZiBzaWduYWwgZXhpdHMgYXMgYSB2Q1BVIHN0YXQNCj4gICBSSVNDLVY6
IEtWTTogVXNlIGdlbmVyaWMgZ3Vlc3QgZW50cnkgaW5mcmFzdHJ1Y3R1cmUNCj4gICByaXNjdjog
c2VsZWN0IEhBVkVfUE9TSVhfQ1BVX1RJTUVSU19UQVNLX1dPUksNCj4gICByaXNjdjogYWRkIGxh
enkgcHJlZW1wdCBzdXBwb3J0DQo+ICAgcmlzY3Y6IEFsbG93IHRvIGVuYWJsZSBSVA0KPiANCj4g
IGFyY2gvcmlzY3YvS2NvbmZpZyAgICAgICAgICAgICAgICAgICB8ICAzICsrKw0KPiAgYXJjaC9y
aXNjdi9pbmNsdWRlL2FzbS9rdm1faG9zdC5oICAgIHwgIDEgKw0KPiAgYXJjaC9yaXNjdi9pbmNs
dWRlL2FzbS90aHJlYWRfaW5mby5oIHwgIDcgKysrKystLQ0KPiAgYXJjaC9yaXNjdi9rZXJuZWwv
YXNtLW9mZnNldHMuYyAgICAgIHwgIDEgKw0KPiAgYXJjaC9yaXNjdi9rZXJuZWwvZW50cnkuUyAg
ICAgICAgICAgIHwgIDkgKysrKysrKy0tDQo+ICBhcmNoL3Jpc2N2L2t2bS9LY29uZmlnICAgICAg
ICAgICAgICAgfCAgMSArDQo+ICBhcmNoL3Jpc2N2L2t2bS92Y3B1LmMgICAgICAgICAgICAgICAg
fCAxOCArKysrKysrLS0tLS0tLS0tLS0NCj4gIDcgZmlsZXMgY2hhbmdlZCwgMjUgaW5zZXJ0aW9u
cygrKSwgMTUgZGVsZXRpb25zKC0pDQo+IA0KPiAtLQ0KPiAyLjM0LjENCj4gDQo+IA0KPiBfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXw0KPiBsaW51eC1yaXNj
diBtYWlsaW5nIGxpc3QNCj4gbGludXgtcmlzY3ZAbGlzdHMuaW5mcmFkZWFkLm9yZw0KPiBodHRw
Oi8vbGlzdHMuaW5mcmFkZWFkLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LXJpc2N2DQoNCg==
