Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196A768023F
	for <lists+kvm@lfdr.de>; Sun, 29 Jan 2023 23:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235410AbjA2WXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Jan 2023 17:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234659AbjA2WXi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Jan 2023 17:23:38 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6DE1633F
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 14:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675031016; x=1706567016;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lJEauYsdcCoeZ5dUMhAqQE1Pi+pdqqdzY1rYWc81ZCk=;
  b=rDdjEqlNPexC0G/zXZ/svo1e5NF6KyOVzzoF1TpJSQH9COQYnaCpZIrb
   dGzi12xZmwNHMOKxtjJ7dKyxCK5SjKTMRr5rrI14AMtnpEPmsfKJxkWyA
   IhgAxq9Hpg8Bx5iJfNJJiiVkgnum17jkUe13j5+ujUlYu5uxlQyZD9B1s
   dvo3gwAYcQlYeD6iCvze/3RYFV9ji75LeSztshR8PymIWWF8ub9kks9H9
   iKXUT4gylORkAxhcQ9xRhi1I3cgr65cs0+4ePX/6JamTjg4UqYUoO+mzc
   Awd/As9cpxSY3FThKBxnbHx8ZMMQIqFzGsKr3rLwbGfqucz7Esv7/zHM7
   g==;
X-IronPort-AV: E=Sophos;i="5.97,256,1669046400"; 
   d="scan'208";a="220348892"
Received: from mail-sn1nam02lp2049.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.49])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jan 2023 06:23:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wgc51Cj6ZaNWg6yLF3PO1RjU/Y5M7BVmYx3ch0YuBB4oYq00G25yK3ebW3JlayvY9iFRlaXJhc7/DxwtQUTjqk25L+XH2Z/8QpANc3t2mFn/kkYk8XpP761OX9c5h8opTYuECOlmjKE56bIwCL/OUQZSDegKVmqG2oBFeiRwdGN3XliedeX04w8vuLZiqrZVsRUYHbWEK9FQNNq/xJiIz8kyAQbXWcN9tZIE4+RPAHjHmHmV/2y1SHfT6JcOFfCPKwdS7G9UelYE8aL26B/D/aKoKR+udgSn7nVxm8eePnbS97zjF5iUlhqZA7g1HjkjXX32S05Rts4R+ABQ4f7AYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lJEauYsdcCoeZ5dUMhAqQE1Pi+pdqqdzY1rYWc81ZCk=;
 b=RKtH7hB/QKlAagRM0BbVElflS7a28UNUUBiAsKLCpso01eP8Sp9SeJ2XCa/HSYUGUTspSJJEGTZJ0ApNGFVn/hg0kQChXMr1gjj2o7iybhLLe7K7yd8qkqFmZUQtylZNLR4cJJ7iBSzrygfVBF1pHxuJLfssZbOOPUeZs1F1bkWd0CwcyntgaqidnNmZxJZCNP/9jlVbOb7jkP4vcMG5RwIJ/h6vstwsH5r5mPB+uM3rxsmkcdJ5Hsp/m+vvNJjYEadvKG/1GsOj0UEWiNXqftrsG+rEwQiIXo7chxVJ1kKrzD1vfeiDwok96JBs1Qd0J+wJr6hc6ACOXaeFZxTn0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lJEauYsdcCoeZ5dUMhAqQE1Pi+pdqqdzY1rYWc81ZCk=;
 b=b7hS4SOGE1/quAjKctWetAsQoe/zVTGv62clqA+po/Ew4ec/KpCY4SKL83eI+MrYkruMClbs1skBV6OKHoRLhHL6xCawVz0uRUIQHPqeVnWglMuucPzfZzyomDuG1CRQozKZeW9dXRDtQSHOrvQ2zo38CHeX4Dd/McCCGwFZP3g=
Received: from SJ0PR04MB7872.namprd04.prod.outlook.com (2603:10b6:a03:303::20)
 by BN0PR04MB8189.namprd04.prod.outlook.com (2603:10b6:408:15c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Sun, 29 Jan
 2023 22:23:29 +0000
Received: from SJ0PR04MB7872.namprd04.prod.outlook.com
 ([fe80::3534:2f3b:3e73:759]) by SJ0PR04MB7872.namprd04.prod.outlook.com
 ([fe80::3534:2f3b:3e73:759%8]) with mapi id 15.20.6043.033; Sun, 29 Jan 2023
 22:23:28 +0000
From:   Alistair Francis <Alistair.Francis@wdc.com>
To:     "philipp.tomsich@vrull.eu" <philipp.tomsich@vrull.eu>
CC:     "frank.chang@sifive.com" <frank.chang@sifive.com>,
        "dickon.hood@codethink.co.uk" <dickon.hood@codethink.co.uk>,
        "qemu-riscv@nongnu.org" <qemu-riscv@nongnu.org>,
        "palmer@dabbelt.com" <palmer@dabbelt.com>,
        "lawrence.hunter@codethink.co.uk" <lawrence.hunter@codethink.co.uk>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "bin.meng@windriver.com" <bin.meng@windriver.com>
Subject: Re: Fwd: [RFC PATCH 00/39] Add RISC-V cryptography extensions
 standardisation
Thread-Topic: Fwd: [RFC PATCH 00/39] Add RISC-V cryptography extensions
 standardisation
Thread-Index: AQHZMWea8ZKsLuYthkqktGn/KWxyGa61+YkAgAABMICAAAMVgA==
Date:   Sun, 29 Jan 2023 22:23:28 +0000
Message-ID: <606a3bcc7c7428d2504d2c60055e76255454c558.camel@wdc.com>
References: <20230119143528.1290950-1-lawrence.hunter@codethink.co.uk>
         <380600FF-17AC-4134-85C7-CBDF6E34F0E2@getmailspring.com>
         <ad8d999b4e972aa0ea4a276b3d4d8dc355c2d435.camel@wdc.com>
         <CAAeLtUC5p=k4XiXoZxEA6qnLHpmjnuKT+6WUaskbt=uYB1XjrA@mail.gmail.com>
In-Reply-To: <CAAeLtUC5p=k4XiXoZxEA6qnLHpmjnuKT+6WUaskbt=uYB1XjrA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (by Flathub.org) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR04MB7872:EE_|BN0PR04MB8189:EE_
x-ms-office365-filtering-correlation-id: f3c6c4b0-3206-407e-82cb-08db02477253
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0veRH/5N+evMPMeIxHyQ8UVc7ptMrKYjXIC6skL0CDnEF7wMy4ZYentP/3+PqS7Gs9KX4XKJgETFMaptVo4PpycLh52sAR7BMOR4BkaA4eJ3l7isWldniUVHYN1GT3IaWwboUp6eTcs38zlrnPDNNF5BKjp0maPZn/XDBwQRpg7RnxE+zysLywQdZ6Qhy8sLSq02orZ+H8bsa9+KB9YGKsKEHSzVp6czCvtsQ/rUBNbu/eQgEJzRtCateoqVMrukmN2xhvXaKBvHTlbUsI6WzEGKRxw+0d47X9OUy3f0VtHuRlH7bksV462eQUrs1cVNGLcbeIVj1GVv/e+Kmb2N/vNLC7Ir0mF8La12KzEQK4YV9Sev3n3+iW2dnP7sZwLUO6vN5lkNAa+84ZmYFhAwAaTTQSfVH4YkEztquAP8CWQluDGd+W2ps+bCieQuXcc6FxRyezscuH8hg1vUr0tr3C/Nyfj0c4b6ChAEr1mam0xLydKxoI5+gjdcfb82q8W5zzY0r97h04EfzleJ8ASJRXCDGdNzK1GflOoMV4O+AE26buyszBpvjT6+sm1iy3RHrCQZa4N/4CTLtZP+GlQfsnNNbhuYoDJcvseVtSsCR14iOBEgnY8EDsw5BQ6cWYbku12VpFqStDIAdzRE0CnUa8qIGQe0HmMHcDAvakt8/H6CxS3NbKleyQeFIoRMtOxuZE0O4ymKODRCyxBOCZpSbNdXrnIEVPBt2x4Kem8BY80=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR04MB7872.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(396003)(376002)(366004)(39860400002)(451199018)(2906002)(5660300002)(36756003)(82960400001)(122000001)(38100700002)(186003)(6512007)(2616005)(83380400001)(66946007)(86362001)(4326008)(8676002)(76116006)(91956017)(6916009)(54906003)(316002)(66476007)(66446008)(66556008)(8936002)(6506007)(41300700001)(64756008)(38070700005)(71200400001)(478600001)(966005)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YkNFbTNjUDA5TFRIMTJ2cVdqK1VYYnpmdmRQd05DUlBybktBNDd0cDlQZmg2?=
 =?utf-8?B?WnJoTFdRQ2l2SXJnMlBQdXNhTVVTbDQxa1JVME1CeHBEMXdQYzg5RXo2YmU2?=
 =?utf-8?B?RU55c1dhUnRubk9wWGNVRkVjakhSL0RVWlp0UmpzamE2S1pING9qYmxsa00x?=
 =?utf-8?B?Tk1wWC9JTTVGUGpnYVNTckEwZG01Q0tNWk9mTkc3UjdVWTZrTjBmaUVZOUVh?=
 =?utf-8?B?YUdRL0tOZTZoa2JwalAzR2Via0trZU95NWE5K0MxOEllSkl1RWF0RkhOcktS?=
 =?utf-8?B?ZU8xeTBoazVoQVBUcFdxR3Q2cHdReW1DZGNTUnNTaGFuSnlvRkQ3ZEdGd3hz?=
 =?utf-8?B?R0pZd1FpQ2U4c083QWovTGVzOVdWRnNpTWJMS2p1NkJMZDZXeW5KR0JkcmZh?=
 =?utf-8?B?dFU0VGNjWGwzQmg1cExwaFprYmVTd3MyMWxPNVB4aE9yY210SGduMVhvVUZo?=
 =?utf-8?B?VFRIN1Q4WTUxT0Fjek1vR2ZXdm1ubTMvRTVERVVMMlphdmFrUVhSV3NHa2di?=
 =?utf-8?B?cEhmUVVrTVFEbW81U3FyUG1VbGpXRE5ZL1NRQVp1ZWlsejd5MzRabnp0dFFl?=
 =?utf-8?B?cDVveW40RElxUk5GM1kvVEFNWUFzWjNaeHVmVmFaSXdEOWhkaDdMMitqV0xC?=
 =?utf-8?B?dHpNRHhZZ0FFQkJrWSs1VjgrMzUwOXVQeHBUNzNXNmwzSE9YT0lON0FucnFz?=
 =?utf-8?B?d2FYcE11RzBBL0JHQXFqR09rSlo3ZG1hVHNGSUVSQnVTQ2tBOTJOSWh6TEVQ?=
 =?utf-8?B?WCtLTHA3T1drOUZnczdtZk0wRmhVK0xwZmFkdS96a0pTSkhhRFUxZFpsc3BE?=
 =?utf-8?B?SUN3dGRHcHk4WmtvRnlOUDFsRzlCeVNUMUZ2WE9CNUV6cjlac0F2RU1TOUtR?=
 =?utf-8?B?MTNBZ2NMN2lRV0RNb21GZWY0VE1NTXJCckhGby9UMjY1S05hbXdnNU5wSWRo?=
 =?utf-8?B?eGVuRzRLMzRua3MvclgrVStVSjlzWUVLQzMrMml6cUo4UVBkNTlQSDVjZHdt?=
 =?utf-8?B?OWFlaHhvVzV4ODN6SlJvSnpDejg0TXpJMGVwYU5EVGRCYnNpT3JXQTN2Mkh4?=
 =?utf-8?B?L0k3eENGSzFIeVUycVZvSitpbGhwUmtpVjZvd0hxUkFUK1ZpZlVaeWc2QS9i?=
 =?utf-8?B?c0hrV2hxamtpTUxqc1cxV0ljNTEvRmtuL0Z6QmFZTWQzKzhNUTRIZFFqVTc5?=
 =?utf-8?B?czhRSno0SGJzOXprY3FiN1l0K3hBOW1mNTVreUNVZ2g2cVJXUFB0V3pqRmpW?=
 =?utf-8?B?NFJUWGR5UUNOektRbnd5cURha3EwZFRIM1oyRzRLVGlxWkRKRU1Bc3ZhM29G?=
 =?utf-8?B?amNCc3AxekhpYkphcWUxMDVjOHNBOHNENktqQWRrblBrYUFUdFVVQ1pFaCtY?=
 =?utf-8?B?S0pKVitnK1JXR0ZkdzVsOXBRNFA1VU5yb1NDTlkxTnhINHZhakpMcEh6OGdM?=
 =?utf-8?B?NEdsbTVqbVMzeEhaVjRaSmxLZlV5UUlaNlh2M2tYS0tPTTVRVVR2Z3h6bEtt?=
 =?utf-8?B?WGg0cFREN0xrTVJENGlGMkhISDdGR2t6cEVrd0RySVQrUFFmS2pQT2lhNE1w?=
 =?utf-8?B?SjZ4U1BWbGNjdlgrZlhrOFZXV2hkTnZHcXJwaitMR0dHTmNRSEY3Z1QrOVJO?=
 =?utf-8?B?SnBONTdiYkZGcDZlWTl4emtHNExyTzNCdy93SWY4RURPVDhlNTZ1UVlyT283?=
 =?utf-8?B?eDR2UUYwaDNPNXQ5S0RzOGQ0VGtIajhjTS8zU2U5eXd2TkpoaUNrR3lWRTZr?=
 =?utf-8?B?R2wrRWFGUWhuSlRBLzcrbE11TjhuVGlGREkvRjk2ZHFlbHBWT1MzR2VGYVZ5?=
 =?utf-8?B?UHppUWJBWkRsT292cUVJeTE1R2M4SjlrVkU4czBvbjFqMUd4dWFyTGVqNlNr?=
 =?utf-8?B?SWlmb0lwT29hWkhYRlRqRFQ4UFlEMnFWRFlZc2hpUzRzdGF5MUlCS0lwZm1V?=
 =?utf-8?B?UDQ2VjdvQ0ZpdXg0Q2Y3WS95dytlRy9VdTc3ZTBXWTNYc29Db2EwcHZNTWQv?=
 =?utf-8?B?T0VLSWRzdEdmYnVZRXlIWDNZN2JscCtzZksxcGxFZkFxbVBnNTgvWmMvY1Uz?=
 =?utf-8?B?WFBoK3NJZHhINmRDSTdGNFFpRkNxd1JMb25WNWFqc1N0Q1V0Nm9OUGZBeEpa?=
 =?utf-8?B?N2ExWFVlVTZFa3l4ZkVYQ09LZzcrMXBwcUhQaVpIbTkvOUdTL0orWEEvbjdv?=
 =?utf-8?B?Ry9YMWs0ZmVIVU52VXBSaGNNZVBhaDB6SzJhcEg0YXVTNXpuYkdITkExdWRh?=
 =?utf-8?B?TkZaYUhOeWFQSFA5ZjNRTnRNdEZRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A00BA0F2923D1D4794EBA7906D504C4B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?aW1lY1d4dGRIblhVY2NvY0lGUGp2RzVGSEFTTkVOcnYrdzVYZHJzWGkvK2Fk?=
 =?utf-8?B?UjBhVFRVMXVTb2Y1ZU1GYXNLK0k2TVFBQWpmcDdFN1NIK1NYVk9SOFMraEpn?=
 =?utf-8?B?dVdsRnpTeTdUaURFNUFwc0g0STBYU1VUdS9hWXBaRHZ1Snp5UlRoRElyU2pR?=
 =?utf-8?B?dHhiVHJqQndLOUw1STg1Y2h1TS8yTmc2bnVmVG5lV2RFK1o3UWNhVWR4S2hm?=
 =?utf-8?B?anBQODlnWnkvWDFiZFRkaklsbW5sazAzNHlHaVFLWHJUSndLMWcrK1dXZU9w?=
 =?utf-8?B?RUowZzR4THZsQVpTWkc4REh4bmpqZDJKdVI2L3pGN3dCYTdCZ1pJcjN5ZTRn?=
 =?utf-8?B?RS8vbGRudmtEQUZFL1I4V1V3MmNGRlpSNHpnMUNKVlY0d0UrU2MwZjd5N084?=
 =?utf-8?B?ajR1dHBQdEw3MmxvNkhVaFhES1F0NGFMcFkrS095aStKSXBJKy9WQUs5M0JJ?=
 =?utf-8?B?Tml2akY5c1hpeTB1YlRrKy9NbW1BNnN2Qm5EZEJ5aGd6UXFUOVBJdTBQS2Rv?=
 =?utf-8?B?b0pLS3NoTmNDR0xkUFBnTjF4eG5TUDhBZmo3c2VtRGNzRlp5VitlRFU0UWNj?=
 =?utf-8?B?ZWRZc2JsRXZYbmFWRjRvSUNpeUVhTVZjSWU5b1BLK1phbEV1UG5NSWl2ZWVm?=
 =?utf-8?B?TUlUVnEyeHN6WUJaaE51QTF4VzJ2WkhHNmp4cnBLRC9SM3hBNUtOYUFCV3Ny?=
 =?utf-8?B?TVUrSUVGdEtqcFNkb0FleThlSkcvQlR1Rm1ZVkEwRVJMdHNLS2VUOTZaVWkz?=
 =?utf-8?B?STVkZHlJVGJGUkdST3d1MWxMcUJtUkZOMks1cXo4cjlGdDU4UW9OSlBHb09X?=
 =?utf-8?B?djFFRnBxUmJ3MFhBbEEwVnNObmEyWUdoeDU4b1lYNU9uSENCaER6K1M1UDVM?=
 =?utf-8?B?RjUwczBDUnRjaWczZW1CK3BZcnZXNVd3MW53a2NrNkZxa1AxUW41cjVZN2F1?=
 =?utf-8?B?ajhXT0h3VUtSQzdFak9McW1CTUJHNkRZbG1lVk9SSmhDZVg3MC9WbVZFMGhq?=
 =?utf-8?B?UTB5Yktxc1RiajB4OFVZNDNnTENJcW9mbUFvZU41b0g2LzRNRkRuVzVEZXRB?=
 =?utf-8?B?a1RySWROQ01yWnc4eGVtc3lLMnVZa3hNWU5ySHF5RHdCSlB3aG0vd0FLNzdP?=
 =?utf-8?B?OVRuUFBTdzJSdmtrMWlYOCtqdTZibXQ0am1yNUdWaGlmTml6S2t2a0kwZnY4?=
 =?utf-8?B?REFYTWY1U0JHZm5ncmxucUppditzU0FUb3p0TkdReVRoOWNhU3lFSGxTTUZV?=
 =?utf-8?B?RVdmeFhBNHZ0bDllcmVSc3ozSENneVR6VlRxSUo4dXZhcXJRSzhHTTVRTy9k?=
 =?utf-8?Q?QP4bt6aVIl9PWTGqX+VUMsnpjalWHF1AMU?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR04MB7872.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3c6c4b0-3206-407e-82cb-08db02477253
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2023 22:23:28.6753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cIsoG5DS3tPMCJVFai1uP5qgZiRs6rlxyutT12nBQWMZflUXHhDxHIQdoTrges3L5iNcPO3IWHwyOQzPjr/6Zo6FQaVcVPQ+btxqfag7rv0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR04MB8189
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,URI_NOVOWEL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU3VuLCAyMDIzLTAxLTI5IGF0IDIzOjEyICswMTAwLCBQaGlsaXBwIFRvbXNpY2ggd3JvdGU6
DQo+IA0KPiANCj4gT24gU3VuLCAyOSBKYW4gMjAyMyBhdCAyMzowOCwgQWxpc3RhaXIgRnJhbmNp
cw0KPiA8QWxpc3RhaXIuRnJhbmNpc0B3ZGMuY29tPiB3cm90ZToNCj4gPiBPbiBUaHUsIDIwMjMt
MDEtMjYgYXQgMDk6MjEgKzAwMDAsIExhd3JlbmNlIEh1bnRlciB3cm90ZToNCj4gPiA+IEZvbGxv
dyB1cCBmb3IgYWRkIFJJU0MtViB2ZWN0b3IgY3J5cHRvZ3JhcGh5IGV4dGVuc2lvbnMNCj4gPiA+
IHN0YW5kYXJkaXNhdGlvbg0KPiA+ID4gUkZDOiB3ZSd2ZSBub3QgcmVjZWl2ZWQgYW55IGNvbW1l
bnRzIGFuZCB3b3VsZCBsaWtlIHRvIG1vdmUgdGhpcw0KPiA+ID4gc2VyaWVzDQo+ID4gPiB0b3dh
cmRzIGdldHRpbmcgbWVyZ2VkLiBEb2VzIGFueW9uZSBoYXZlIHRpbWUgdG8gcmV2aWV3IGl0LCBh
bmQNCj4gPiA+IHNob3VsZA0KPiA+ID4gd2UgbG9vayBhdCByZXN1Ym1pdHRpbmcgZm9yIG1lcmdp
bmcgc29vbj8NCj4gPiANCj4gPiBIZWxsbywNCj4gPiANCj4gPiBUaGlzIHNlcmllcyBuZXZlciBt
YWRlIGl0IHRvIHRoZSBRRU1VIGxpc3QuIEl0IGxvb2tzIGxpa2UgaXQgd2FzDQo+ID4gbmV2ZXIN
Cj4gPiBzZW50IHRvIHRoZSBnZW5lcmFsIHFlbXUtZGV2ZWwgbWFpbGluZyBsaXN0Lg0KPiA+IA0K
PiANCj4gDQo+IFRoaXMgaGFzIHNvIGZhciBiZWVuIG1vcmUgdGhhbiBhIGxpdHRsZSBwYWluZnVs
IGZvciBvdXIgcmV2aWV3LCBhcyB3ZQ0KPiBjYW4ndCBqdXN0IHB1bGwgdGhlIHBhdGNoZXMgZG93
biBmcm9tIHBhdGNod29yayB0byB1c2Ugb3VyIHJlZ3VsYXINCj4gdGVzdC1hbmQtcmV2aWV3IGZs
b3cuDQo+IFNob3VsZCB3ZSB3YWl0IHVudGlsIHRoZSByZXN1Ym1pc3Npb24gZm9yIG91ciByZXZp
ZXc/DQoNClVwIHRvIHlvdS4gSXQgd29uJ3QgYmUgbWVyZ2VkIHVubGVzcyBpdCBoYXMgYmVlbiBz
ZW50IHRvIHRoZSBnZW5lcmFsDQptYWlsaW5nIGxpc3QsIHNvIHlvdSBjYW4gZWl0aGVyIGdldCBh
IGhlYWQgc3RhcnQgb3IganVzdCB3YWl0Lg0KDQo+IA0KPiBOb3RlIHRoYXQgdGhlIGN1cnJlbnQg
c2VyaWVzIGlzIG5vdCBpbi1zeW5jIHdpdGggdGhlIGxhdGVzdA0KPiBzcGVjaWZpY2F0aW9uLg0K
DQpJdCdzIG9ubHkgYW4gUkZDLCBzbyBmb3Igbm93IHRoYXQncyBvayBhcyBpdCB3b24ndCBiZSBt
ZXJnZWQgYW55d2F5Lg0KDQpBbGlzdGFpcg0KDQo+IFdlJ2xsIHRyeSB0byBwb2ludCBvdXQgdGhl
IHNwZWNpZmljIGRldmlhdGlvbnMgKHdlIGhhdmUgYSB0cmVlIHRoYXQNCj4gd2UndmUgYmVlbiBr
ZWVwaW5nIGluIHN5bmMgd2l0aCB0aGUgY2hhbmdlcyB0byB0aGUgc3BlYyBzaW5jZSBtaWQtDQo+
IERlY2VtYmVyKSBpbiBvdXIgcmV2aWV3cy4NCj4gDQo+IENoZWVycywNCj4gUGhpbGlwcC4NCj4g
wqANCj4gPiBXaGVuIHN1Ym1pdHRpbmcgcGF0Y2hlcyBjYW4geW91IHBsZWFzZSBmb2xsb3cgdGhl
IHN0ZXBzIGhlcmU6DQo+ID4gaHR0cHM6Ly93d3cucWVtdS5vcmcvZG9jcy9tYXN0ZXIvZGV2ZWwv
c3VibWl0dGluZy1hLXBhdGNoLmh0bWwjc3VibWl0dGluZy15b3VyLXBhdGNoZXMNCj4gPiANCj4g
PiBJdCdzIGltcG9ydGFudCB0aGF0IGFsbCBwYXRjaGVzIGFyZSBzZW50IHRvIHRoZSBxZW11LWRl
dmVsIG1haWxpbmcNCj4gPiBsaXN0DQo+ID4gKHRoYXQncyBhY3R1YWxseSBtdWNoIG1vcmUgaW1w
b3J0YW50IHRoZW4gdGhlIFJJU0MtViBtYWlsaW5nIGxpc3QpLg0KPiA+IA0KPiA+IEFsaXN0YWly
DQo+ID4gDQo+ID4gPiANCj4gPiA+IC0tLS0tLS0tLS0gRm9yd2FyZGVkIE1lc3NhZ2UgLS0tLS0t
LS0tDQo+ID4gPiANCj4gPiA+IEZyb206IExhd3JlbmNlIEh1bnRlciA8bGF3cmVuY2UuaHVudGVy
QGNvZGV0aGluay5jby51az4NCj4gPiA+IFN1YmplY3Q6IFtSRkMgUEFUQ0ggMDAvMzldIEFkZCBS
SVNDLVYgY3J5cHRvZ3JhcGh5IGV4dGVuc2lvbnMNCj4gPiA+IHN0YW5kYXJkaXNhdGlvbg0KPiA+
ID4gRGF0ZTogSmFuIDE5IDIwMjMsIGF0IDI6MzQgcG0NCj4gPiA+IFRvOiBxZW11LXJpc2N2QG5v
bmdudS5vcmcNCj4gPiA+IENjOiBkaWNrb24uaG9vZEBjb2RldGhpbmsuY28udWssIGZyYW5rLmNo
YW5nQHNpZml2ZS5jb20sIExhd3JlbmNlDQo+ID4gPiBIdW50ZXIgPGxhd3JlbmNlLmh1bnRlckBj
b2RldGhpbmsuY28udWs+DQo+ID4gPiANCj4gPiA+IA0KPiA+ID4gPiBUaGlzIFJGQyBpbnRyb2R1
Y2VzIGFuIGltcGxlbWVudGF0aW9uIGZvciB0aGUgc2l4IGluc3RydWN0aW9uDQo+ID4gPiA+IHNl
dHMNCj4gPiA+ID4gb2YgdGhlIGRyYWZ0IFJJU0MtViBjcnlwdG9ncmFwaHkgZXh0ZW5zaW9ucyBz
dGFuZGFyZGlzYXRpb24NCj4gPiA+ID4gc3BlY2lmaWNhdGlvbi4gT25jZSB0aGUgc3BlY2lmaWNh
dGlvbiBoYXMgYmVlbiByYXRpZmllZCB3ZSB3aWxsDQo+ID4gPiA+IHN1Ym1pdA0KPiA+ID4gPiB0
aGVzZSBjaGFuZ2VzIGFzIGEgcHVsbCByZXF1ZXN0IGVtYWlsIHRvIHRoaXMgbWFpbGluZyBsaXN0
Lg0KPiA+ID4gPiBXb3VsZA0KPiA+ID4gPiB0aGlzDQo+ID4gPiA+IGJlIHByZWZlcmVkIGJ5IGlu
c3RydWN0aW9uIGdyb3VwIG9yIHVuaWZpZWQgYXMgaW4gdGhpcyBSRkM/DQo+ID4gPiA+IA0KPiA+
ID4gPiBUaGlzIHBhdGNoIHNldCBpbXBsZW1lbnRzIHRoZSBpbnN0cnVjdGlvbiBzZXRzIGFzIHBl
ciB0aGUNCj4gPiA+ID4gMjAyMjEyMDINCj4gPiA+ID4gdmVyc2lvbiBvZiB0aGUgc3BlY2lmaWNh
dGlvbiAoMSkuDQo+ID4gPiA+IA0KPiA+ID4gPiBXb3JrIHBlcmZvcm1lZCBieSBEaWNrb24sIExh
d3JlbmNlLCBOYXphciwgS2lyYW4sIGFuZCBXaWxsaWFtDQo+ID4gPiA+IGZyb20NCj4gPiA+ID4g
Q29kZXRoaW5rDQo+ID4gPiA+IHNwb25zb3JlZCBieSBTaUZpdmUsIGFuZCBNYXggQ2hvdSBmcm9t
IFNpRml2ZS4NCj4gPiA+ID4gDQo+ID4gPiA+IDEuIGh0dHBzOi8vZ2l0aHViLmNvbS9yaXNjdi9y
aXNjdi1jcnlwdG8vcmVsZWFzZXMNCj4gPiA+ID4gDQo+ID4gPiA+IERpY2tvbiBIb29kICgxKToN
Cj4gPiA+ID4gwqB0YXJnZXQvcmlzY3Y6IEFkZCB2cm9sLlt2dix2eF0gYW5kIHZyb3IuW3Z2LHZ4
LHZpXSBkZWNvZGluZywNCj4gPiA+ID4gwqDCoCB0cmFuc2xhdGlvbiBhbmQgZXhlY3V0aW9uIHN1
cHBvcnQNCj4gPiA+ID4gDQo+ID4gPiA+IEtpcmFuIE9zdHJvbGVuayAoNCk6DQo+ID4gPiA+IMKg
dGFyZ2V0L3Jpc2N2OiBBZGQgdnNoYTJtcy52diBkZWNvZGluZywgdHJhbnNsYXRpb24gYW5kDQo+
ID4gPiA+IGV4ZWN1dGlvbg0KPiA+ID4gPiDCoMKgIHN1cHBvcnQNCj4gPiA+ID4gwqB0YXJnZXQv
cmlzY3Y6IGFkZCB6dmtzaCBjcHUgcHJvcGVydHkNCj4gPiA+ID4gwqB0YXJnZXQvcmlzY3Y6IEFk
ZCB2c20zYy52aSBkZWNvZGluZywgdHJhbnNsYXRpb24gYW5kIGV4ZWN1dGlvbg0KPiA+ID4gPiBz
dXBwb3J0DQo+ID4gPiA+IMKgdGFyZ2V0L3Jpc2N2OiBleHBvc2UgenZrc2ggY3B1IHByb3BlcnR5
DQo+ID4gPiA+IA0KPiA+ID4gPiBMYXdyZW5jZSBIdW50ZXIgKDE2KToNCj4gPiA+ID4gwqB0YXJn
ZXQvcmlzY3Y6IEFkZCB2Y2xtdWwudnYgZGVjb2RpbmcsIHRyYW5zbGF0aW9uIGFuZA0KPiA+ID4g
PiBleGVjdXRpb24NCj4gPiA+ID4gwqDCoCBzdXBwb3J0DQo+ID4gPiA+IMKgdGFyZ2V0L3Jpc2N2
OiBBZGQgdmNsbXVsLnZ4IGRlY29kaW5nLCB0cmFuc2xhdGlvbiBhbmQNCj4gPiA+ID4gZXhlY3V0
aW9uDQo+ID4gPiA+IMKgwqAgc3VwcG9ydA0KPiA+ID4gPiDCoHRhcmdldC9yaXNjdjogQWRkIHZj
bG11bGgudnYgZGVjb2RpbmcsIHRyYW5zbGF0aW9uIGFuZA0KPiA+ID4gPiBleGVjdXRpb24NCj4g
PiA+ID4gwqDCoCBzdXBwb3J0DQo+ID4gPiA+IMKgdGFyZ2V0L3Jpc2N2OiBBZGQgdmNsbXVsaC52
eCBkZWNvZGluZywgdHJhbnNsYXRpb24gYW5kDQo+ID4gPiA+IGV4ZWN1dGlvbg0KPiA+ID4gPiDC
oMKgIHN1cHBvcnQNCj4gPiA+ID4gwqB0YXJnZXQvcmlzY3Y6IEFkZCB2YWVzZWYudnYgZGVjb2Rp
bmcsIHRyYW5zbGF0aW9uIGFuZA0KPiA+ID4gPiBleGVjdXRpb24NCj4gPiA+ID4gwqDCoCBzdXBw
b3J0DQo+ID4gPiA+IMKgdGFyZ2V0L3Jpc2N2OiBBZGQgdmFlc2VmLnZzIGRlY29kaW5nLCB0cmFu
c2xhdGlvbiBhbmQNCj4gPiA+ID4gZXhlY3V0aW9uDQo+ID4gPiA+IMKgwqAgc3VwcG9ydA0KPiA+
ID4gPiDCoHRhcmdldC9yaXNjdjogQWRkIHZhZXNkZi52diBkZWNvZGluZywgdHJhbnNsYXRpb24g
YW5kDQo+ID4gPiA+IGV4ZWN1dGlvbg0KPiA+ID4gPiDCoMKgIHN1cHBvcnQNCj4gPiA+ID4gwqB0
YXJnZXQvcmlzY3Y6IEFkZCB2YWVzZGYudnMgZGVjb2RpbmcsIHRyYW5zbGF0aW9uIGFuZA0KPiA+
ID4gPiBleGVjdXRpb24NCj4gPiA+ID4gwqDCoCBzdXBwb3J0DQo+ID4gPiA+IMKgdGFyZ2V0L3Jp
c2N2OiBBZGQgdmFlc2RtLnZ2IGRlY29kaW5nLCB0cmFuc2xhdGlvbiBhbmQNCj4gPiA+ID4gZXhl
Y3V0aW9uDQo+ID4gPiA+IMKgwqAgc3VwcG9ydA0KPiA+ID4gPiDCoHRhcmdldC9yaXNjdjogQWRk
IHZhZXNkbS52cyBkZWNvZGluZywgdHJhbnNsYXRpb24gYW5kDQo+ID4gPiA+IGV4ZWN1dGlvbg0K
PiA+ID4gPiDCoMKgIHN1cHBvcnQNCj4gPiA+ID4gwqB0YXJnZXQvcmlzY3Y6IEFkZCB2YWVzei52
cyBkZWNvZGluZywgdHJhbnNsYXRpb24gYW5kIGV4ZWN1dGlvbg0KPiA+ID4gPiBzdXBwb3J0DQo+
ID4gPiA+IMKgdGFyZ2V0L3Jpc2N2OiBBZGQgdnNoYTJjW2hsXS52diBkZWNvZGluZywgdHJhbnNs
YXRpb24gYW5kDQo+ID4gPiA+IGV4ZWN1dGlvbg0KPiA+ID4gPiDCoMKgIHN1cHBvcnQNCj4gPiA+
ID4gwqB0YXJnZXQvcmlzY3Y6IEFkZCB2c20zbWUudnYgZGVjb2RpbmcsIHRyYW5zbGF0aW9uIGFu
ZA0KPiA+ID4gPiBleGVjdXRpb24NCj4gPiA+ID4gwqDCoCBzdXBwb3J0DQo+ID4gPiA+IMKgdGFy
Z2V0L3Jpc2N2OiBhZGQgenZrZyBjcHUgcHJvcGVydHkNCj4gPiA+ID4gwqB0YXJnZXQvcmlzY3Y6
IEFkZCB2Z2htYWMudnYgZGVjb2RpbmcsIHRyYW5zbGF0aW9uIGFuZA0KPiA+ID4gPiBleGVjdXRp
b24NCj4gPiA+ID4gwqDCoCBzdXBwb3J0DQo+ID4gPiA+IMKgdGFyZ2V0L3Jpc2N2OiBleHBvc2Ug
enZrZyBjcHUgcHJvcGVydHkNCj4gPiA+ID4gDQo+ID4gPiA+IE1heCBDaG91ICg1KToNCj4gPiA+
ID4gwqBjcnlwdG86IE1vdmUgU000X1NCT1hXT1JEIGZyb20gdGFyZ2V0L3Jpc2N2DQo+ID4gPiA+
IMKgY3J5cHRvOiBBZGQgU000IGNvbnN0YW50IHBhcmFtZXRlciBDSy4NCj4gPiA+ID4gwqB0YXJn
ZXQvcmlzY3Y6IEFkZCB6dmtzZWQgY2ZnIHByb3BlcnR5DQo+ID4gPiA+IMKgdGFyZ2V0L3Jpc2N2
OiBBZGQgWnZrc2VkIHN1cHBvcnQNCj4gPiA+ID4gwqB0YXJnZXQvcmlzY3Y6IEV4cG9zZSBadmtz
ZWQgcHJvcGVydHkNCj4gPiA+ID4gDQo+ID4gPiA+IE5hemFyIEthemFrb3YgKDEwKToNCj4gPiA+
ID4gwqB0YXJnZXQvcmlzY3Y6IGFkZCB6dmtiIGNwdSBwcm9wZXJ0eQ0KPiA+ID4gPiDCoHRhcmdl
dC9yaXNjdjogQWRkIHZyZXY4LnYgZGVjb2RpbmcsIHRyYW5zbGF0aW9uIGFuZCBleGVjdXRpb24N
Cj4gPiA+ID4gc3VwcG9ydA0KPiA+ID4gPiDCoHRhcmdldC9yaXNjdjogQWRkIHZhbmRuLlt2dix2
eCx2aV0gZGVjb2RpbmcsIHRyYW5zbGF0aW9uIGFuZA0KPiA+ID4gPiBleGVjdXRpb24NCj4gPiA+
ID4gwqDCoCBzdXBwb3J0DQo+ID4gPiA+IMKgdGFyZ2V0L3Jpc2N2OiBleHBvc2UgenZrYiBjcHUg
cHJvcGVydHkNCj4gPiA+ID4gwqB0YXJnZXQvcmlzY3Y6IGFkZCB6dmtucyBjcHUgcHJvcGVydHkN
Cj4gPiA+ID4gwqB0YXJnZXQvcmlzY3Y6IEFkZCB2YWVza2YxLnZpIGRlY29kaW5nLCB0cmFuc2xh
dGlvbiBhbmQNCj4gPiA+ID4gZXhlY3V0aW9uDQo+ID4gPiA+IMKgwqAgc3VwcG9ydA0KPiA+ID4g
PiDCoHRhcmdldC9yaXNjdjogQWRkIHZhZXNrZjIudmkgZGVjb2RpbmcsIHRyYW5zbGF0aW9uIGFu
ZA0KPiA+ID4gPiBleGVjdXRpb24NCj4gPiA+ID4gwqDCoCBzdXBwb3J0DQo+ID4gPiA+IMKgdGFy
Z2V0L3Jpc2N2OiBleHBvc2UgenZrbnMgY3B1IHByb3BlcnR5DQo+ID4gPiA+IMKgdGFyZ2V0L3Jp
c2N2OiBhZGQgenZrbmggY3B1IHByb3BlcnRpZXMNCj4gPiA+ID4gwqB0YXJnZXQvcmlzY3Y6IGV4
cG9zZSB6dmtuaCBjcHUgcHJvcGVydGllcw0KPiA+ID4gPiANCj4gPiA+ID4gV2lsbGlhbSBTYWxt
b24gKDMpOg0KPiA+ID4gPiDCoHRhcmdldC9yaXNjdjogQWRkIHZicmV2OC52IGRlY29kaW5nLCB0
cmFuc2xhdGlvbiBhbmQgZXhlY3V0aW9uDQo+ID4gPiA+IHN1cHBvcnQNCj4gPiA+ID4gwqB0YXJn
ZXQvcmlzY3Y6IEFkZCB2YWVzZW0udnYgZGVjb2RpbmcsIHRyYW5zbGF0aW9uIGFuZA0KPiA+ID4g
PiBleGVjdXRpb24NCj4gPiA+ID4gwqDCoCBzdXBwb3J0DQo+ID4gPiA+IMKgdGFyZ2V0L3Jpc2N2
OiBBZGQgdmFlc2VtLnZzIGRlY29kaW5nLCB0cmFuc2xhdGlvbiBhbmQNCj4gPiA+ID4gZXhlY3V0
aW9uDQo+ID4gPiA+IMKgwqAgc3VwcG9ydA0KPiA+ID4gPiANCj4gPiA+ID4gY3J5cHRvL3NtNC5j
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCB8wqDCoCAxMCArDQo+ID4gPiA+IGluY2x1ZGUvY3J5cHRvL3NtNC5owqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoMKgwqAgOCArDQo+ID4g
PiA+IGluY2x1ZGUvcWVtdS9iaXRvcHMuaMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgfMKgwqAgMzIgKw0KPiA+ID4gPiB0YXJnZXQvYXJtL2NyeXB0b19oZWxw
ZXIuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqDCoCAxMCArLQ0KPiA+
ID4gPiB0YXJnZXQvcmlzY3YvY3B1LmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHzCoMKgIDE1ICsNCj4gPiA+ID4gdGFyZ2V0L3Jpc2N2L2NwdS5o
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqDC
oMKgIDcgKw0KPiA+ID4gPiB0YXJnZXQvcmlzY3YvY3J5cHRvX2hlbHBlci5jwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgwqDCoCAxICsNCj4gPiA+ID4gdGFyZ2V0L3Jpc2N2L2hl
bHBlci5owqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqDC
oCA2OSArKw0KPiA+ID4gPiB0YXJnZXQvcmlzY3YvaW5zbjMyLmRlY29kZcKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqDCoCA0OCArDQo+ID4gPiA+IHRhcmdldC9yaXNjdi9p
bnNuX3RyYW5zL3RyYW5zX3J2enZrYi5jLmluY8KgwqAgfMKgIDE2NCArKysNCj4gPiA+ID4gdGFy
Z2V0L3Jpc2N2L2luc25fdHJhbnMvdHJhbnNfcnZ6dmtnLmMuaW5jwqDCoCB8wqDCoMKgIDggKw0K
PiA+ID4gPiB0YXJnZXQvcmlzY3YvaW5zbl90cmFucy90cmFuc19ydnp2a25oLmMuaW5jwqAgfMKg
wqAgNDcgKw0KPiA+ID4gPiB0YXJnZXQvcmlzY3YvaW5zbl90cmFucy90cmFuc19ydnp2a25zLmMu
aW5jwqAgfMKgIDEyMSArKysNCj4gPiA+ID4gdGFyZ2V0L3Jpc2N2L2luc25fdHJhbnMvdHJhbnNf
cnZ6dmtzZWQuYy5pbmMgfMKgwqAgMzggKw0KPiA+ID4gPiB0YXJnZXQvcmlzY3YvaW5zbl90cmFu
cy90cmFuc19ydnp2a3NoLmMuaW5jwqAgfMKgwqAgMjAgKw0KPiA+ID4gPiB0YXJnZXQvcmlzY3Yv
bWVzb24uYnVpbGTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoMKg
wqAgNCArLQ0KPiA+ID4gPiB0YXJnZXQvcmlzY3YvdHJhbnNsYXRlLmPCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoMKgwqAgNiArDQo+ID4gPiA+IHRhcmdldC9yaXNj
di92Y3J5cHRvX2hlbHBlci5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMTAxMw0K
PiA+ID4gPiArKysrKysrKysrKysrKysrKysNCj4gPiA+ID4gdGFyZ2V0L3Jpc2N2L3ZlY3Rvcl9o
ZWxwZXIuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCAyNDIgKy0tLS0NCj4g
PiA+ID4gdGFyZ2V0L3Jpc2N2L3ZlY3Rvcl9pbnRlcm5hbHMuY8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHzCoMKgIDYzICsrDQo+ID4gPiA+IHRhcmdldC9yaXNjdi92ZWN0b3JfaW50ZXJuYWxz
LmjCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMjI2ICsrKysNCj4gPiA+ID4gMjEgZmls
ZXMgY2hhbmdlZCwgMTkwMiBpbnNlcnRpb25zKCspLCAyNTAgZGVsZXRpb25zKC0pDQo+ID4gPiA+
IGNyZWF0ZSBtb2RlIDEwMDY0NCB0YXJnZXQvcmlzY3YvaW5zbl90cmFucy90cmFuc19ydnp2a2Iu
Yy5pbmMNCj4gPiA+ID4gY3JlYXRlIG1vZGUgMTAwNjQ0IHRhcmdldC9yaXNjdi9pbnNuX3RyYW5z
L3RyYW5zX3J2enZrZy5jLmluYw0KPiA+ID4gPiBjcmVhdGUgbW9kZSAxMDA2NDQgdGFyZ2V0L3Jp
c2N2L2luc25fdHJhbnMvdHJhbnNfcnZ6dmtuaC5jLmluYw0KPiA+ID4gPiBjcmVhdGUgbW9kZSAx
MDA2NDQgdGFyZ2V0L3Jpc2N2L2luc25fdHJhbnMvdHJhbnNfcnZ6dmtucy5jLmluYw0KPiA+ID4g
PiBjcmVhdGUgbW9kZSAxMDA2NDQgdGFyZ2V0L3Jpc2N2L2luc25fdHJhbnMvdHJhbnNfcnZ6dmtz
ZWQuYy5pbmMNCj4gPiA+ID4gY3JlYXRlIG1vZGUgMTAwNjQ0IHRhcmdldC9yaXNjdi9pbnNuX3Ry
YW5zL3RyYW5zX3J2enZrc2guYy5pbmMNCj4gPiA+ID4gY3JlYXRlIG1vZGUgMTAwNjQ0IHRhcmdl
dC9yaXNjdi92Y3J5cHRvX2hlbHBlci5jDQo+ID4gPiA+IGNyZWF0ZSBtb2RlIDEwMDY0NCB0YXJn
ZXQvcmlzY3YvdmVjdG9yX2ludGVybmFscy5jDQo+ID4gPiA+IGNyZWF0ZSBtb2RlIDEwMDY0NCB0
YXJnZXQvcmlzY3YvdmVjdG9yX2ludGVybmFscy5oDQo+ID4gPiA+IA0KPiA+ID4gPiAtLSANCj4g
PiA+ID4gMi4zOS4xDQo+ID4gPiA+IA0KPiA+ID4gPiANCj4gPiA+ID4gDQo+ID4gDQoNCg==
