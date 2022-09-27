Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C185EB766
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 04:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbiI0CLg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 22:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiI0CLf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 22:11:35 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01olkn2019.outbound.protection.outlook.com [40.92.99.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F536A2A8A
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 19:11:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M2bMBLlAo4uj32IVFbbgAgb+qagjEZdJJtZUp60dFn8M4Y5fDwUiLzzPbYvuDPGK/14A79Zvv8PMAsexgMTnE4332j4Mu8n32o5yfMAPrXcxFhFiosAyZLYytK+GCBjJHFAOlfCgnDGM1ol1Ll7oORQr7mFQA2tuDxwwt/jpk9QrO8iIsi6ZM+dni0HA87dq/q0GnY7+mGZkxFZyeJs+BRXNlpUfMi4u+l25eut83lDB1gnUh6p4MKF2/iJvg3+DDLFkVDNpygFW/HRyJgv2tKjnxVmhhUQQTbydk2AJ1t9XMqYlu9TmRHuv12bDeDxOKf6M/B9GtJ6CTSE7F4SQ8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UDY4+LTi0PDN2TuCGruIoEHyLEOW7nAW2UV/QpdiK5A=;
 b=fSpuxdBd179uPIbRGCPt71qJ6RRXhBQIgm37igWkrm3BBRVYQ0RzE91iEtikS0niFWuUfvr2EW38ZVILWpvCFSuVLf7U1RyfMvThyqE17GCxfCvtMi4tkOYNz7koE1C3MxmNwKoNoDH4Ra4Obsf8y/5Xg9D0zIsVFP0gOizbVLZGygTrnQCzqJuuHli3NmZkJvFOaaw1oC84J0Y/9nLx/gjkMMCsNimxw8oZ8+rc1wuCX5CKBnLGA6Qf8If8jbYYxp3WQA0yY+SFjU7Z7tL6SFuJSWSJTPe6SSObO19HTZWnZjQtOX+2IVkHR1QNm61NbICRxZ4YcXNH75ETlrTwgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UDY4+LTi0PDN2TuCGruIoEHyLEOW7nAW2UV/QpdiK5A=;
 b=Vwsj0hYN3DGj0G2fz0D9epSy0ftGbsuyEEp3HZisuoYpnyouRlzyIv5+q5S3FLcVBcLz+MvE+1812dZG/p+ecOeeuQnUWPZSLm2IvDNDmZCgjbRp+vYgoTiZazqLl+LKt9+YgO9ma7U20sq5MGvF8p33M/cLq4SkJ0Ygvq19Sc36WWpBYfuxjUS8pl4G75VShNkeYooYqnTe01Tl4DiImggAi+TEi8hGRo6113Qy6mZajQ09lMjD+luVGpH1Ml/FkA01kGuaq4umfEzd7mUnMOqhVFIQC7w6SaTsE+WI13lPt9KXoxcMTlUb/I0jRuKtyXs9ySxb57olJBGpcj6T9Q==
Received: from OSYP286MB0103.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:83::12)
 by OS3P286MB2309.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.15; Tue, 27 Sep
 2022 02:11:32 +0000
Received: from OSYP286MB0103.JPNP286.PROD.OUTLOOK.COM
 ([fe80::8b83:8fb9:2676:a925]) by OSYP286MB0103.JPNP286.PROD.OUTLOOK.COM
 ([fe80::8b83:8fb9:2676:a925%9]) with mapi id 15.20.5654.026; Tue, 27 Sep 2022
 02:11:32 +0000
From:   =?gb2312?B?1cUg1PPT7g==?= <zeyuzhang07@outlook.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: 
Thread-Index: AQHY0hZuJhun8EtH/0WR/xyW0wTBtw==
Date:   Tue, 27 Sep 2022 02:11:32 +0000
Message-ID: <OSYP286MB0103F3C4A1666B0A83D36B42B2559@OSYP286MB0103.JPNP286.PROD.OUTLOOK.COM>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-tmn:  [u9W2ZB5K5fybTAhSjp1ostFaCtm5J1Z8]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OSYP286MB0103:EE_|OS3P286MB2309:EE_
x-ms-office365-filtering-correlation-id: 3aa550ec-2a4e-4e79-ca88-08daa02d98e9
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sY8iNkU+a4BAsdBjY7BXLCPmK2Y4ZHAQ3hY+M0as0uRhobSJwpdo7BxTmbopTzsY7DCJ9YSmb4ziItPlvwR7/MRc2DlSH8QNrhRu9u2TGnbg9+Rrp6zuMOYhnNla9Mf/6zUJhl/FdxeTlWWl2zlHoDpPOYw8NhHaUFswgan+TXQHU/mK5iwBX7CEUH43poUJtle7BIGM39ssBnT+9EeJu189DQrtEVAa5QMf3Tn9ox64aTzMk+7qAYAKwMnJlJTZZ1dQBVTKF7t0k2T3p34eyOCZN+FnB/4q5YPrn4SZD7g/G7Ntar0/neyjY5YWxDK1Y2zmZ8gP2827wdeCpX4nXb+tBbaIzbYNm+itSARMJkbrIIy2WsV2RNBpxy+6j8qsxRluCj5/4G9rkWoKj+rX/X/3wuCuNVBy6/9obIfdLrUxQjewqq0aGg949vS1urHGqkFE7sFfGF+VQuFUPet0ihvVMUn8MXLS6cqmHWpVpSLlCoOXKF7Ns+B1ePGS6e20gyxharNZ30uuYJDq2uS/ldTMTdfksXYHdLj5OjeKdoOuBN4hwJpMGbIPz1U0i5Bm610Bfmq03guK24b53ciM+JeRWIgu9FinodQnVVbVu8uAUMkA4cV/nrVyeDMLW7ZFbafodmZjZs1jTnLnYfm08w==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?bjYwejdHejlIY1B0a0E4bmFtTWNrbkRDbmNFVGhQWG5FKytCeTc4K1h4M3I5?=
 =?gb2312?B?WDhIMGhyeWxGREJGYUVnL1Zod2VabDZIWVZsRjBTaDBIQWFXM1NzcW5hclJJ?=
 =?gb2312?B?dUU2VmZoVEh3SXMyVUJNZmxVZERVVkdsUlJqV1o5bDhhQjk4bDgxK1RiUGIw?=
 =?gb2312?B?Y0M5b0JvKzdvM1Q2UjNzMTNUNVZJa1BWRzY2K0UyMmFLUCtlVkNCeVI1V2JU?=
 =?gb2312?B?U2psVjJibmIwM0pLaXFRbDdhNDc3N2VFSXZWTVlCMlZ2UHBnZDBUaEVQQS9R?=
 =?gb2312?B?NVpHS1V6WVFDOHNYbGRSOGFVM0FzeVBiNHJ6cTBURWNhandzcW9tUzZhUW91?=
 =?gb2312?B?UVd2ZHZHV0VBQVlwVkpCK3VRY2lkWWZqcHpwTU5YVFBJbzB4UDE0N3czeUJm?=
 =?gb2312?B?TUsvT0NDVTg5dHEyc1k1Z0JORWNteTFPcnZuZHNzWWR0NDNPSHpGOXpNQ1Ri?=
 =?gb2312?B?Q2IrMHRJRVNueFBqYTk0SGd3RkppZERKTWlyYnoyQ0oySU41RFM5ckNoMEV3?=
 =?gb2312?B?R05tdkgySEpZRkoyMTZMNFVBR2RpUkZiWVU5VEFwZzQ0ME5KdENwWDZJaU5p?=
 =?gb2312?B?NUNCR3RiWHVLbHRRTUR0SXh5UHJ3TWliWkIrZndydEsya243SFRPZFdQemdC?=
 =?gb2312?B?UVVZbThQUGdvVmRQYmFESWxRS1JSUHBLek5sZUlhNXBpdVFHYzFKOHFGVGs0?=
 =?gb2312?B?MHZEUjNDQXJyRWxaRjU5NGtqcVdWZUROY1p0clZHRkZsYzJCSlh0VWlxWUZR?=
 =?gb2312?B?REtEanFGNERCcHQrWTN5VzBFOGdtYTRqQW1iaSsvMGpXOFFCMUVsclZRVVR3?=
 =?gb2312?B?UkRQczJ6QXVCUEdUTVE5WXJqTk00amVrRzlpSzl1SVhHRGl3Ui8yR2ZPMkFF?=
 =?gb2312?B?Zk5kbUJtQU5ZaUdBQmR0eXk4K2lBMVdtTGhWSDZ3bzZiZXBSUVN3UDZoMWU4?=
 =?gb2312?B?REVob3U3R0lDSjN3WjZ6aVRBbDNsV0x3ektXUXVuZGNad2Q4Ui9KeWxnSUZk?=
 =?gb2312?B?ak8yd2plczZ2QlNpZjJBSU52RDA5NUhwTlhpekpjVGFsc0lZcGpYb0kyS1c1?=
 =?gb2312?B?amZaMjdhTmc5bTNrUEhsN1I1NTYzWXJXQlVkaUQ2OE1icmhtR1RYOXArNXBr?=
 =?gb2312?B?Ni81NFc3OU1nRnAyTkUzaTZFNzZLQ2s0OTVUSkNtWHdxcTdUYWxNM05JYTBK?=
 =?gb2312?B?cjFhRFZobGhaTXF1WGdPVGM3b28rS3lISjlUSDVhZG5xQnAyR0lraDZJZXhi?=
 =?gb2312?B?ak44eE56NnFiT1k4WnVCWmZEdDI1NUhJQ0hXOHBhbmRYU2pBa0pDQU1teEJB?=
 =?gb2312?B?NHIzQnVESHN4VnJKMjAvUlNJZE5SbnRuQmN5OThzWjAvc2Y2TzZVZU1FR3dT?=
 =?gb2312?B?a0VaclJpK0drS281dDZZTFUvWGQxTWpTZzhETkJyM1Y3ckNCTkp5N0VIazdI?=
 =?gb2312?B?QjNVTXcxSll0VlpVUGNQZWF0ZmZpdWl2NmhBczBlOGNQMDhxUE1tZzBiU3gx?=
 =?gb2312?B?SkNpbjg2ZERGQUVtMWZROVBiRXY5YXgzYld2TzlXRHBtdWxlc2pGbURKVFRX?=
 =?gb2312?B?M2xmV1duNzhrbmRaRXlUQmx0ZFBLZ0hnaVp4eXkzZVA4MU1ic1k3NlMwUDZo?=
 =?gb2312?B?VkRid0ltUDhGUlQyenBNVmY3YWpJd25qQWFQdjMvakRNcUVUZmRNWi9XUEJQ?=
 =?gb2312?B?bWJwSTk5VnBVNE5VSCtpYi80OWpDSDYrQmF2cjhYZ3R3SEJhOHE4cUFBPT0=?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSYP286MB0103.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aa550ec-2a4e-4e79-ca88-08daa02d98e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2022 02:11:32.5621
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3P286MB2309
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS,
        TVD_SPACE_RATIO autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

dW5zdWJzY3JpYmU=
