Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6249680223
	for <lists+kvm@lfdr.de>; Sun, 29 Jan 2023 23:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbjA2WIe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Jan 2023 17:08:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235278AbjA2WIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Jan 2023 17:08:31 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEA71C322
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 14:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675030108; x=1706566108;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2UqPStyFknRlG7vu9Nc6o4H4unhTGcwA3GBmLkBtotc=;
  b=bmqrvGrrvTGyAj5Sh7mnv1YTeIX6fE8dpBiSD/+hExFufAoVYKBkiG7h
   taaYMuQhW5uxk1uP+qLHJIpgM5MlK1R+I0apkal/0k202paQB8LRuxmWa
   oMc0zQlzE0yW6M5VUDhOMLeQojCQNBRBqq71fDF0YPTQwIjo+ou50aymH
   9UMAPWyta6KbhUOjkt9BZFgOZuo4D5sCDqaJK1FzXO3ytVlmEblG+xK/k
   5caY2+IKic9n0gTws5jM1Tu7YqAqqlKKlUUWaxGm6mx3+q2/GxB+8/NNS
   C3gc3f07rwCXE/ikXQv4lMTeGsFMuu5eIcL92jr0mitTVzw61e5D45S7+
   g==;
X-IronPort-AV: E=Sophos;i="5.97,256,1669046400"; 
   d="scan'208";a="333992305"
Received: from mail-bn8nam12lp2177.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.177])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jan 2023 06:08:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z8mFJKFsuMxPKgtpEaRCvaAjexgwDyeW7TaDfwz71qNFhF7fHVeg+PH8gF9ufqLAp+ShGj5E87Xxek6eOtyykZBKFdN/20Fk80i19WaQQU+FZmZZYV2I7u+gYe3akC8yd27gTK6uGFVAzhDO5Ew1geplg9pS9FBqh1Rkjx3LZGw+O8FFIqKkQxGofToV0AYBeUoFbhxYim12BX7QY8lBg992g5Ki2Dm1dsla06PVDs8qA/FODk87IyMK9tmE+cc0aauDwgjfMdlETp3lkS7RCaCTQWgiEwLyAp/spE4p7RftP25hXgkHMQCwvxD+zsOerjPmmmOaxSCXWnSzSfTzXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2UqPStyFknRlG7vu9Nc6o4H4unhTGcwA3GBmLkBtotc=;
 b=IaeIL7AkrBV+iVDQEM1RQO0WUfwQRekLqkO3Yj8Ai0twYFgzWwPirZRQwX/Miruzt58ur8WinmWfDfAsqRcMfwPVvYqnjdhGFBtWgpTCYgsOdHRKbYbUEDsT4ThHJTbr48FLokTK6QWvYMZkPJ4nyOdFrY6m00p2ekiTYt8OjpSBUp92aOhAFtq4h5iX/hqgAQPeY5zbCdAHf6dc6JjPO9uysSTqoZHAUrnGwx2lilMC05Dk+t3T5Khlsnr5eSxDhCm2+2rfGZxUZsVFrVeO1Ch1VnEwdWgGSynVcoMITxiXS0l4YR66ZxZxBwLJr32t7Rq8mydYXQhSfvIdi3QBoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2UqPStyFknRlG7vu9Nc6o4H4unhTGcwA3GBmLkBtotc=;
 b=rl8j3DLWm/pStPxE/8iOSrC+e0Ck80mqTPARyYuz8g/vo21TqL30mntfgphvo4Y/DSB4qthIFBM0td5id3lqyh0Xvm5TlLNHe9Y+kxF7IdM1aMebKd/DpsqMKv4gpSk1zdASPi3siU9ArdV2AGWZwaUAT1u7GO5sU0GnGj2hm48=
Received: from SJ0PR04MB7872.namprd04.prod.outlook.com (2603:10b6:a03:303::20)
 by CY4PR04MB0617.namprd04.prod.outlook.com (2603:10b6:903:ec::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Sun, 29 Jan
 2023 22:08:12 +0000
Received: from SJ0PR04MB7872.namprd04.prod.outlook.com
 ([fe80::3534:2f3b:3e73:759]) by SJ0PR04MB7872.namprd04.prod.outlook.com
 ([fe80::3534:2f3b:3e73:759%8]) with mapi id 15.20.6043.033; Sun, 29 Jan 2023
 22:08:12 +0000
From:   Alistair Francis <Alistair.Francis@wdc.com>
To:     "qemu-riscv@nongnu.org" <qemu-riscv@nongnu.org>,
        "lawrence.hunter@codethink.co.uk" <lawrence.hunter@codethink.co.uk>
CC:     "philipp.tomsich@vrull.eu" <philipp.tomsich@vrull.eu>,
        "palmer@dabbelt.com" <palmer@dabbelt.com>,
        "bin.meng@windriver.com" <bin.meng@windriver.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dickon.hood@codethink.co.uk" <dickon.hood@codethink.co.uk>,
        "frank.chang@sifive.com" <frank.chang@sifive.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Fwd: [RFC PATCH 00/39] Add RISC-V cryptography extensions
 standardisation
Thread-Topic: Fwd: [RFC PATCH 00/39] Add RISC-V cryptography extensions
 standardisation
Thread-Index: AQHZMWea8ZKsLuYthkqktGn/KWxyGa61+YkA
Date:   Sun, 29 Jan 2023 22:08:11 +0000
Message-ID: <ad8d999b4e972aa0ea4a276b3d4d8dc355c2d435.camel@wdc.com>
References: <20230119143528.1290950-1-lawrence.hunter@codethink.co.uk>
         <380600FF-17AC-4134-85C7-CBDF6E34F0E2@getmailspring.com>
In-Reply-To: <380600FF-17AC-4134-85C7-CBDF6E34F0E2@getmailspring.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (by Flathub.org) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR04MB7872:EE_|CY4PR04MB0617:EE_
x-ms-office365-filtering-correlation-id: 25731f79-fc00-4e0a-eda6-08db02454fdf
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t2mcze4L7/lai2RFL+c57Wuy9uLkADAqttjNGj9WuSJh9kGRvcFZIahBrP2AM3w2OB0ad7QCEMFVrMb7gxkKdE5T0m5Cl2NLXJKs1eWdXFgCoeWmP3egbNHJvLFk6UatT8FWRokIMyV8p3EkJ47oYcaIywGlA6NwdCGLs1un5vDyaGKFJUGFsxqhYD+3l2A08S2UjZlNcZ9XMOkQeeeE0GUFKJeu3DVRQN+6DLqbZ6sCOeQMpic0hOSNXUttQ3jnEPz07fdxlshSbzaxMV3qzub62XCeM8vGFYu0iQ7HxNVw1bOsM2LejW10wkOu4bUnL3PArsoz0PcToFKixmjolxJHAGeMu5LwQVDZWWKMVcG4Hlk2T17uelvgBIbeVOy5897Gf3CWem76hx1WkU3t3v6C9SfZId8K98UPE4PrRvg9lSk+GksnywYKGwSnTpgk5HUxSQcoZuuT99Q4+Uu49WDJsLT08F10tbVnSvckwqPXFQljP09bfG1B1CBpfdbNSYR5ikf8SgDH2Uen4g1qVIM86avyNUbakM33JlPBKwLa7i050EM+Smu3SRd+dFS0IkSdKejVDdXE+q+hqXyF+J05Ez5YN01ffg3cAqGz+oxp9Vh0zNWRJJjjY4bLdqnzCun0S8xzeVMHMTO1qS3xciSgpiXYYibpqrbRlG9g2tqgPdAFmJVEJunwTET0gQbR+IcP0tHi1jQBrNyppyFJJ7YFEUhHntzdKLF2O54zdmg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR04MB7872.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(366004)(396003)(39860400002)(346002)(451199018)(5660300002)(8936002)(41300700001)(2906002)(64756008)(66946007)(66446008)(8676002)(91956017)(4326008)(316002)(54906003)(76116006)(66556008)(66476007)(110136005)(71200400001)(6486002)(478600001)(966005)(6512007)(6506007)(186003)(83380400001)(86362001)(122000001)(82960400001)(38070700005)(2616005)(38100700002)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RFNweGh2L0UrNmxtY2dtSUQ3dVR5c0lKZ0gvUUZpTXcvM05mNWZ3V0F1bW1k?=
 =?utf-8?B?S3BSZ2RlY0dVdzg5b3ZFNVVVTVYwVDN6VFpLVFhpbksxVTNIeFdFSHErc0U1?=
 =?utf-8?B?MFVQMithUFNRUHAvZnZjOXR2TCt2cGt5K1JSTXpUU1l6Smp5R0xMUjBib2t4?=
 =?utf-8?B?b1RWYzBhK3VKVmMrVEwwRVlvUm4zZkx3OVQzMEhxREV2NWdNc01QaDE0V2k5?=
 =?utf-8?B?MkswSldHRVNCUXVtRzB3N3FtRHVmT3FVRkYvRzk4UU1aZklqam1UdEppSTNR?=
 =?utf-8?B?YkFyWVhqajNQWG9vZ1N0Mzl3TlVRYUhpYjNrRjlaT3k3RVZTUmxIM3h0SU9l?=
 =?utf-8?B?bnNWbGlxaGRTTm90VTlnM2RyS0U3NExyUjN2bGdjdmNVVWdlMXV2WGJEandM?=
 =?utf-8?B?QjdIbFVxVVowOVgxdWEwdENBK0YydzJFRW1wMXVXMk5NYWM1NDZsWWRaRTV6?=
 =?utf-8?B?UzBVTWR0TE9pQmZkV25BTlBNaTJNZ3kydzJyalM4a3pjRlBIUnBoV1lJSkpS?=
 =?utf-8?B?bjlianJFUTdmanQ2aGxXdWd1VEdMb2tCbFhETm1KTncyck9EUE5YMHlWZHA3?=
 =?utf-8?B?Y0RJTHNPd2owVXQwUDJHWUtRRytpR2xFc2xPTmxUZGE4cDBZRmNicHpRNlli?=
 =?utf-8?B?MC9CcGwrQnVTbHJXZVczZHdCYjZrUHpjSUxpVzVxZEtEWng2bFZVOTVuMlRF?=
 =?utf-8?B?Z0N0OHhMZnUyUDNlWURYOXUxaFUwcTloV0l4UURhVzBOdTNOTzlZa2ZmbGJ2?=
 =?utf-8?B?Z2hUY3J2Nk96U2hmNG9SNmZVNzFqb2NQUDdLRjZCYlRBZWJPZlNSY2c3NE5r?=
 =?utf-8?B?NXVMVy9FOURGUkhnVVFBZ3oxM2lSbVNqbi9LVkUzRkdJRHFWbm45bS9BOTJx?=
 =?utf-8?B?eFBIT3JlekU3NDF3NHNIUzlZSSs1WXJJVXFQSGEzY0YrNWJ1MFRDaWxVMjlU?=
 =?utf-8?B?SWhlb3dRaitBL21ORDdKNkRucjZCTkltYVRCSjNtVWNJMHhVbDNHQkU4bWtI?=
 =?utf-8?B?aHpxODFmUXdpN01PZG1seFYzdkV4QWkwWVZHaEZ0RmhEZWhjbnMyTmx6U0dV?=
 =?utf-8?B?VGIrRkZ2MEVua0piZGk2Yi9pQWNqVEtMVXdTY2I4eSsyK1FnblJnOVJaVVBu?=
 =?utf-8?B?M1hjKzI0RFpUK0M4NHh5c0g2Y20veXRhMVN4SFUxamNZUWhvNGViRVhYaCtk?=
 =?utf-8?B?NGlNZ3AvdkxRMTdLbWpqV0hyY3Zxc1hrTnQ5bXRnRzkveGxKSGN1bEpiaHU1?=
 =?utf-8?B?Z1pnakFsaEt6YlhVL0JYYlIyOTdZT0NXK0ZPWHkxOEt4cWdBejdPRHZSMG1n?=
 =?utf-8?B?ckdhQ2ZVUHNhdDNsU3dGSDQ0Q0pCaThONWU4cXNqMG5CN0M5aXlMYkZBOXpC?=
 =?utf-8?B?bkN4ME95RTNnc1dQc1Q5N0E3RUhjd2NLYmFMeWRuU1VrMWgzZDNpN0hld25V?=
 =?utf-8?B?MW9sSVZUN1J1V0JNWmlPK1Fic2NPUGpvNk9DRzJGU3Z5RVlxTHhMWTBwRXhX?=
 =?utf-8?B?SE1hMWlqRTk3MGgzUURMaXVnZWQ1U2dvcG5MQnh5WERSYlU0dTFrQ2h2K25J?=
 =?utf-8?B?SVBmS0JTdXJISHo0UHR3bHYvRURMckFrVnE4dSt4ay9zcVljUFgvWWRZeDda?=
 =?utf-8?B?WnhEVXZVdFpMY3lyeUR2SGZkcEtGU0xEZ1NQUXVrSWl4SStwdkk4RU5Kdmlm?=
 =?utf-8?B?TGc4QVhab1czQTZoOTJpb3ExMUFPSXJmdzIvbFRZSEptbTZ0SjZUVWdCNlN3?=
 =?utf-8?B?U2VMcStVZmlJMURxZHlUOHRVUG1nOVBTODc4b0xqaDNDdXduQXcyT1dRQU1L?=
 =?utf-8?B?QkQ5UFpBemEzWHVnTVVpakcxKzhMK3RIVk5rNldqbzVSMFV1Qkl0dHZIRExR?=
 =?utf-8?B?eUU0L1l6UEVsMUo3NXo1b3JYcnNSVzRIUC9jY3c1RFlZdXRKMjdobGVvOFRO?=
 =?utf-8?B?dGs4b0t5OUhOTFZSaWZ4Tk9GakJLQkdRT3poY0dHWVp4UzFIbjhlcDdDdVJL?=
 =?utf-8?B?QW1Qc1lFblhWUFU0OEtnM0dSMXZJTzdSdFVqd2RqdlVCYzllcjNpR3poRHB0?=
 =?utf-8?B?UUZudlNpLzI1YVRRbEVUa3BBcS9xWnVOM1lFdUxtREM1MlFGTnAyNDNvSXlC?=
 =?utf-8?B?Nm1SR3EzMTdBWENWY0VTMGZ2T1kraEM4ZXBBWXl6YjJUMGN4YzNidUNHdmJJ?=
 =?utf-8?B?V3A5K0lOa09qczJGVHZWbkFCdjBhZUlHQWJHRUpLOVU3TFFBR2VVUjB6SWt5?=
 =?utf-8?B?YTJnVy8wTlB0QldzRHRVdzUzSWtRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E80374E3B6C1B4B89A294593951E8B6@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?N0NXeW5nOWN6OCt0VDArYng4MVRLaGRla2t0ZFcvWWNMM1FLMFFkTVR6UnhL?=
 =?utf-8?B?TVNOdTlCTk1nNm0wR2tVUDhCUjVTem5pa2JYZW1yTmpMc0phSlEyWFdFRmlw?=
 =?utf-8?B?dGxXeDY5VHpWT0xoLzN4QWZJdWJQYkJEeE9kaFZTVmtCaG52dHhNNGM0aTdU?=
 =?utf-8?B?eXBFUTZpS2xwV3FSNnM2bU9sVFd5eFkrSlR0NzZyNnN3ZElBa2J6K0U4bGxr?=
 =?utf-8?B?YWFGcUNDKy9uWCtjbGp5b2xuaGZRcEdtc1N5aUhDNG01bTVEc1ZNN2phSkIw?=
 =?utf-8?B?eGRTak9lNlUyeURHSmZGS200K1hSeW5WOE1YSkFrMnhJQmpQSHJPUkJ2RGha?=
 =?utf-8?B?eTVpNXBwUFA4UVd4RWhiU1V6MkNIVk5td1BhaWtXVjhuSXc5MlRub0k0cGEy?=
 =?utf-8?B?bCtpTkg2QjJXaVc0dUF6dm5IQjUxSktMQXoyWGhSdHJYazQxSTYvTGVGY3Rz?=
 =?utf-8?B?d25lc0h5eCt0RzdVQWYxQmY2SVpNS0NzWHppMy9wMVVEeTRGL29ZZnlaYklm?=
 =?utf-8?B?cElUZ1hCam1mYm0wSW1DUngvaHpSS1RWSVFKc2JYTjAyUmxGN1gwc1Y2Z0d0?=
 =?utf-8?B?Tk1qb2hjZ2EzQlp3cXk2NzJXeHdQNERKOTB1VlNpS2ZQYnBSMlpEWTZJWUJO?=
 =?utf-8?B?TVE0akNLWnBFMWxmQkdtTlh6OU80b3l6Nnd3N2dmYlZmY0RPSGlkRzJuT3d3?=
 =?utf-8?B?LzBLZWNiRGw2dmZ5NVdCRWJGbnFFVCs3ZjFVZ1RDMVZVclJVTW9WelBwZFZn?=
 =?utf-8?B?TTJ3aCtoTzZXNVV0Mmx4V21zWStWZzhKMWtIN2hLdEsyK1BhV09zdnpxWEtl?=
 =?utf-8?B?NEFCL1N4eTBSZi80WnB0dWlacVdhUUxmNFVOV0FnQWVUc2RmRXdFNGZTTnlG?=
 =?utf-8?B?TU5EQXpYZWEvelVmNWZycmZHMEFVaVY3TlFyNFgxaVQwR3M0R3IyVFBoWFN1?=
 =?utf-8?B?MC9sQ2h6ekU3QmxvS1diRjQ1MjNLNDJoZUEyNFYyK0RDclY0aGhtOTdmN1ZH?=
 =?utf-8?B?bVRJVVJVaXJmcE9UYlV1dG0vQ1pGdnpTeTFLQ0daN3E2SkEwOGFSRzZyUUJs?=
 =?utf-8?B?ZEJnRytad0Y4MUFKZzRCQzFETXhLWktNaFdnUjZWWFJMenlWcngxUThZK0E4?=
 =?utf-8?B?QVBvbk1Wemx3Z0kwL21RNEhUdWUxS2drVjBOc05naW1LVVNzSi9Mem5sYVdW?=
 =?utf-8?B?ZVd5L253SE52L1BJVzJzajRPYURyU2g3a0dPRjFvOVczL1IxSk1OR0ROcGp6?=
 =?utf-8?B?N2dacHVvdktpQTlCUXJNZjdPTTFGdm9pZXIyeG94YkQrNDF1dXIyUENJNmp2?=
 =?utf-8?Q?Lxm6oB1adVXbmERuxdoaCNU/umC99norKP?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR04MB7872.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25731f79-fc00-4e0a-eda6-08db02454fdf
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2023 22:08:11.8819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5UfDKjtvq8l2kwq2aWHsZ9ydyuw855wMsYo6e/uYcrHKZLkkQRodKZ58AHkp7p5VYSEcJxytmMLNgG07UGpF/5HkSF3kbOir7BT+3Bvz4RI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0617
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,URI_NOVOWEL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTI2IGF0IDA5OjIxICswMDAwLCBMYXdyZW5jZSBIdW50ZXIgd3JvdGU6
DQo+IEZvbGxvdyB1cCBmb3IgYWRkIFJJU0MtViB2ZWN0b3IgY3J5cHRvZ3JhcGh5IGV4dGVuc2lv
bnMNCj4gc3RhbmRhcmRpc2F0aW9uDQo+IFJGQzogd2UndmUgbm90IHJlY2VpdmVkIGFueSBjb21t
ZW50cyBhbmQgd291bGQgbGlrZSB0byBtb3ZlIHRoaXMNCj4gc2VyaWVzDQo+IHRvd2FyZHMgZ2V0
dGluZyBtZXJnZWQuIERvZXMgYW55b25lIGhhdmUgdGltZSB0byByZXZpZXcgaXQsIGFuZA0KPiBz
aG91bGQNCj4gd2UgbG9vayBhdCByZXN1Ym1pdHRpbmcgZm9yIG1lcmdpbmcgc29vbj8NCg0KSGVs
bG8sDQoNClRoaXMgc2VyaWVzIG5ldmVyIG1hZGUgaXQgdG8gdGhlIFFFTVUgbGlzdC4gSXQgbG9v
a3MgbGlrZSBpdCB3YXMgbmV2ZXINCnNlbnQgdG8gdGhlIGdlbmVyYWwgcWVtdS1kZXZlbCBtYWls
aW5nIGxpc3QuDQoNCldoZW4gc3VibWl0dGluZyBwYXRjaGVzIGNhbiB5b3UgcGxlYXNlIGZvbGxv
dyB0aGUgc3RlcHMgaGVyZToNCmh0dHBzOi8vd3d3LnFlbXUub3JnL2RvY3MvbWFzdGVyL2RldmVs
L3N1Ym1pdHRpbmctYS1wYXRjaC5odG1sI3N1Ym1pdHRpbmcteW91ci1wYXRjaGVzDQoNCkl0J3Mg
aW1wb3J0YW50IHRoYXQgYWxsIHBhdGNoZXMgYXJlIHNlbnQgdG8gdGhlIHFlbXUtZGV2ZWwgbWFp
bGluZyBsaXN0DQoodGhhdCdzIGFjdHVhbGx5IG11Y2ggbW9yZSBpbXBvcnRhbnQgdGhlbiB0aGUg
UklTQy1WIG1haWxpbmcgbGlzdCkuDQoNCkFsaXN0YWlyDQoNCj4gDQo+IC0tLS0tLS0tLS0gRm9y
d2FyZGVkIE1lc3NhZ2UgLS0tLS0tLS0tDQo+IA0KPiBGcm9tOiBMYXdyZW5jZSBIdW50ZXIgPGxh
d3JlbmNlLmh1bnRlckBjb2RldGhpbmsuY28udWs+DQo+IFN1YmplY3Q6IFtSRkMgUEFUQ0ggMDAv
MzldIEFkZCBSSVNDLVYgY3J5cHRvZ3JhcGh5IGV4dGVuc2lvbnMNCj4gc3RhbmRhcmRpc2F0aW9u
DQo+IERhdGU6IEphbiAxOSAyMDIzLCBhdCAyOjM0IHBtDQo+IFRvOiBxZW11LXJpc2N2QG5vbmdu
dS5vcmcNCj4gQ2M6IGRpY2tvbi5ob29kQGNvZGV0aGluay5jby51aywgZnJhbmsuY2hhbmdAc2lm
aXZlLmNvbSwgTGF3cmVuY2UNCj4gSHVudGVyIDxsYXdyZW5jZS5odW50ZXJAY29kZXRoaW5rLmNv
LnVrPg0KPiANCj4gDQo+ID4gVGhpcyBSRkMgaW50cm9kdWNlcyBhbiBpbXBsZW1lbnRhdGlvbiBm
b3IgdGhlIHNpeCBpbnN0cnVjdGlvbiBzZXRzDQo+ID4gb2YgdGhlIGRyYWZ0IFJJU0MtViBjcnlw
dG9ncmFwaHkgZXh0ZW5zaW9ucyBzdGFuZGFyZGlzYXRpb24NCj4gPiBzcGVjaWZpY2F0aW9uLiBP
bmNlIHRoZSBzcGVjaWZpY2F0aW9uIGhhcyBiZWVuIHJhdGlmaWVkIHdlIHdpbGwNCj4gPiBzdWJt
aXQNCj4gPiB0aGVzZSBjaGFuZ2VzIGFzIGEgcHVsbCByZXF1ZXN0IGVtYWlsIHRvIHRoaXMgbWFp
bGluZyBsaXN0LiBXb3VsZA0KPiA+IHRoaXMNCj4gPiBiZSBwcmVmZXJlZCBieSBpbnN0cnVjdGlv
biBncm91cCBvciB1bmlmaWVkIGFzIGluIHRoaXMgUkZDPw0KPiA+IA0KPiA+IFRoaXMgcGF0Y2gg
c2V0IGltcGxlbWVudHMgdGhlIGluc3RydWN0aW9uIHNldHMgYXMgcGVyIHRoZSAyMDIyMTIwMg0K
PiA+IHZlcnNpb24gb2YgdGhlIHNwZWNpZmljYXRpb24gKDEpLg0KPiA+IA0KPiA+IFdvcmsgcGVy
Zm9ybWVkIGJ5IERpY2tvbiwgTGF3cmVuY2UsIE5hemFyLCBLaXJhbiwgYW5kIFdpbGxpYW0gZnJv
bQ0KPiA+IENvZGV0aGluaw0KPiA+IHNwb25zb3JlZCBieSBTaUZpdmUsIGFuZCBNYXggQ2hvdSBm
cm9tIFNpRml2ZS4NCj4gPiANCj4gPiAxLiBodHRwczovL2dpdGh1Yi5jb20vcmlzY3YvcmlzY3Yt
Y3J5cHRvL3JlbGVhc2VzDQo+ID4gDQo+ID4gRGlja29uIEhvb2QgKDEpOg0KPiA+IMKgdGFyZ2V0
L3Jpc2N2OiBBZGQgdnJvbC5bdnYsdnhdIGFuZCB2cm9yLlt2dix2eCx2aV0gZGVjb2RpbmcsDQo+
ID4gwqDCoCB0cmFuc2xhdGlvbiBhbmQgZXhlY3V0aW9uIHN1cHBvcnQNCj4gPiANCj4gPiBLaXJh
biBPc3Ryb2xlbmsgKDQpOg0KPiA+IMKgdGFyZ2V0L3Jpc2N2OiBBZGQgdnNoYTJtcy52diBkZWNv
ZGluZywgdHJhbnNsYXRpb24gYW5kIGV4ZWN1dGlvbg0KPiA+IMKgwqAgc3VwcG9ydA0KPiA+IMKg
dGFyZ2V0L3Jpc2N2OiBhZGQgenZrc2ggY3B1IHByb3BlcnR5DQo+ID4gwqB0YXJnZXQvcmlzY3Y6
IEFkZCB2c20zYy52aSBkZWNvZGluZywgdHJhbnNsYXRpb24gYW5kIGV4ZWN1dGlvbg0KPiA+IHN1
cHBvcnQNCj4gPiDCoHRhcmdldC9yaXNjdjogZXhwb3NlIHp2a3NoIGNwdSBwcm9wZXJ0eQ0KPiA+
IA0KPiA+IExhd3JlbmNlIEh1bnRlciAoMTYpOg0KPiA+IMKgdGFyZ2V0L3Jpc2N2OiBBZGQgdmNs
bXVsLnZ2IGRlY29kaW5nLCB0cmFuc2xhdGlvbiBhbmQgZXhlY3V0aW9uDQo+ID4gwqDCoCBzdXBw
b3J0DQo+ID4gwqB0YXJnZXQvcmlzY3Y6IEFkZCB2Y2xtdWwudnggZGVjb2RpbmcsIHRyYW5zbGF0
aW9uIGFuZCBleGVjdXRpb24NCj4gPiDCoMKgIHN1cHBvcnQNCj4gPiDCoHRhcmdldC9yaXNjdjog
QWRkIHZjbG11bGgudnYgZGVjb2RpbmcsIHRyYW5zbGF0aW9uIGFuZCBleGVjdXRpb24NCj4gPiDC
oMKgIHN1cHBvcnQNCj4gPiDCoHRhcmdldC9yaXNjdjogQWRkIHZjbG11bGgudnggZGVjb2Rpbmcs
IHRyYW5zbGF0aW9uIGFuZCBleGVjdXRpb24NCj4gPiDCoMKgIHN1cHBvcnQNCj4gPiDCoHRhcmdl
dC9yaXNjdjogQWRkIHZhZXNlZi52diBkZWNvZGluZywgdHJhbnNsYXRpb24gYW5kIGV4ZWN1dGlv
bg0KPiA+IMKgwqAgc3VwcG9ydA0KPiA+IMKgdGFyZ2V0L3Jpc2N2OiBBZGQgdmFlc2VmLnZzIGRl
Y29kaW5nLCB0cmFuc2xhdGlvbiBhbmQgZXhlY3V0aW9uDQo+ID4gwqDCoCBzdXBwb3J0DQo+ID4g
wqB0YXJnZXQvcmlzY3Y6IEFkZCB2YWVzZGYudnYgZGVjb2RpbmcsIHRyYW5zbGF0aW9uIGFuZCBl
eGVjdXRpb24NCj4gPiDCoMKgIHN1cHBvcnQNCj4gPiDCoHRhcmdldC9yaXNjdjogQWRkIHZhZXNk
Zi52cyBkZWNvZGluZywgdHJhbnNsYXRpb24gYW5kIGV4ZWN1dGlvbg0KPiA+IMKgwqAgc3VwcG9y
dA0KPiA+IMKgdGFyZ2V0L3Jpc2N2OiBBZGQgdmFlc2RtLnZ2IGRlY29kaW5nLCB0cmFuc2xhdGlv
biBhbmQgZXhlY3V0aW9uDQo+ID4gwqDCoCBzdXBwb3J0DQo+ID4gwqB0YXJnZXQvcmlzY3Y6IEFk
ZCB2YWVzZG0udnMgZGVjb2RpbmcsIHRyYW5zbGF0aW9uIGFuZCBleGVjdXRpb24NCj4gPiDCoMKg
IHN1cHBvcnQNCj4gPiDCoHRhcmdldC9yaXNjdjogQWRkIHZhZXN6LnZzIGRlY29kaW5nLCB0cmFu
c2xhdGlvbiBhbmQgZXhlY3V0aW9uDQo+ID4gc3VwcG9ydA0KPiA+IMKgdGFyZ2V0L3Jpc2N2OiBB
ZGQgdnNoYTJjW2hsXS52diBkZWNvZGluZywgdHJhbnNsYXRpb24gYW5kDQo+ID4gZXhlY3V0aW9u
DQo+ID4gwqDCoCBzdXBwb3J0DQo+ID4gwqB0YXJnZXQvcmlzY3Y6IEFkZCB2c20zbWUudnYgZGVj
b2RpbmcsIHRyYW5zbGF0aW9uIGFuZCBleGVjdXRpb24NCj4gPiDCoMKgIHN1cHBvcnQNCj4gPiDC
oHRhcmdldC9yaXNjdjogYWRkIHp2a2cgY3B1IHByb3BlcnR5DQo+ID4gwqB0YXJnZXQvcmlzY3Y6
IEFkZCB2Z2htYWMudnYgZGVjb2RpbmcsIHRyYW5zbGF0aW9uIGFuZCBleGVjdXRpb24NCj4gPiDC
oMKgIHN1cHBvcnQNCj4gPiDCoHRhcmdldC9yaXNjdjogZXhwb3NlIHp2a2cgY3B1IHByb3BlcnR5
DQo+ID4gDQo+ID4gTWF4IENob3UgKDUpOg0KPiA+IMKgY3J5cHRvOiBNb3ZlIFNNNF9TQk9YV09S
RCBmcm9tIHRhcmdldC9yaXNjdg0KPiA+IMKgY3J5cHRvOiBBZGQgU000IGNvbnN0YW50IHBhcmFt
ZXRlciBDSy4NCj4gPiDCoHRhcmdldC9yaXNjdjogQWRkIHp2a3NlZCBjZmcgcHJvcGVydHkNCj4g
PiDCoHRhcmdldC9yaXNjdjogQWRkIFp2a3NlZCBzdXBwb3J0DQo+ID4gwqB0YXJnZXQvcmlzY3Y6
IEV4cG9zZSBadmtzZWQgcHJvcGVydHkNCj4gPiANCj4gPiBOYXphciBLYXpha292ICgxMCk6DQo+
ID4gwqB0YXJnZXQvcmlzY3Y6IGFkZCB6dmtiIGNwdSBwcm9wZXJ0eQ0KPiA+IMKgdGFyZ2V0L3Jp
c2N2OiBBZGQgdnJldjgudiBkZWNvZGluZywgdHJhbnNsYXRpb24gYW5kIGV4ZWN1dGlvbg0KPiA+
IHN1cHBvcnQNCj4gPiDCoHRhcmdldC9yaXNjdjogQWRkIHZhbmRuLlt2dix2eCx2aV0gZGVjb2Rp
bmcsIHRyYW5zbGF0aW9uIGFuZA0KPiA+IGV4ZWN1dGlvbg0KPiA+IMKgwqAgc3VwcG9ydA0KPiA+
IMKgdGFyZ2V0L3Jpc2N2OiBleHBvc2UgenZrYiBjcHUgcHJvcGVydHkNCj4gPiDCoHRhcmdldC9y
aXNjdjogYWRkIHp2a25zIGNwdSBwcm9wZXJ0eQ0KPiA+IMKgdGFyZ2V0L3Jpc2N2OiBBZGQgdmFl
c2tmMS52aSBkZWNvZGluZywgdHJhbnNsYXRpb24gYW5kIGV4ZWN1dGlvbg0KPiA+IMKgwqAgc3Vw
cG9ydA0KPiA+IMKgdGFyZ2V0L3Jpc2N2OiBBZGQgdmFlc2tmMi52aSBkZWNvZGluZywgdHJhbnNs
YXRpb24gYW5kIGV4ZWN1dGlvbg0KPiA+IMKgwqAgc3VwcG9ydA0KPiA+IMKgdGFyZ2V0L3Jpc2N2
OiBleHBvc2UgenZrbnMgY3B1IHByb3BlcnR5DQo+ID4gwqB0YXJnZXQvcmlzY3Y6IGFkZCB6dmtu
aCBjcHUgcHJvcGVydGllcw0KPiA+IMKgdGFyZ2V0L3Jpc2N2OiBleHBvc2UgenZrbmggY3B1IHBy
b3BlcnRpZXMNCj4gPiANCj4gPiBXaWxsaWFtIFNhbG1vbiAoMyk6DQo+ID4gwqB0YXJnZXQvcmlz
Y3Y6IEFkZCB2YnJldjgudiBkZWNvZGluZywgdHJhbnNsYXRpb24gYW5kIGV4ZWN1dGlvbg0KPiA+
IHN1cHBvcnQNCj4gPiDCoHRhcmdldC9yaXNjdjogQWRkIHZhZXNlbS52diBkZWNvZGluZywgdHJh
bnNsYXRpb24gYW5kIGV4ZWN1dGlvbg0KPiA+IMKgwqAgc3VwcG9ydA0KPiA+IMKgdGFyZ2V0L3Jp
c2N2OiBBZGQgdmFlc2VtLnZzIGRlY29kaW5nLCB0cmFuc2xhdGlvbiBhbmQgZXhlY3V0aW9uDQo+
ID4gwqDCoCBzdXBwb3J0DQo+ID4gDQo+ID4gY3J5cHRvL3NtNC5jwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqDCoCAxMCAr
DQo+ID4gaW5jbHVkZS9jcnlwdG8vc200LmjCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgfMKgwqDCoCA4ICsNCj4gPiBpbmNsdWRlL3FlbXUvYml0b3BzLmjC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoMKgIDMyICsN
Cj4gPiB0YXJnZXQvYXJtL2NyeXB0b19oZWxwZXIuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCB8wqDCoCAxMCArLQ0KPiA+IHRhcmdldC9yaXNjdi9jcHUuY8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgwqAgMTUgKw0KPiA+
IHRhcmdldC9yaXNjdi9jcHUuaMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgfMKgwqDCoCA3ICsNCj4gPiB0YXJnZXQvcmlzY3YvY3J5cHRvX2hlbHBl
ci5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgwqDCoCAxICsNCj4gPiB0YXJn
ZXQvcmlzY3YvaGVscGVyLmjCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHzCoMKgIDY5ICsrDQo+ID4gdGFyZ2V0L3Jpc2N2L2luc24zMi5kZWNvZGXCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgwqAgNDggKw0KPiA+IHRhcmdldC9yaXNj
di9pbnNuX3RyYW5zL3RyYW5zX3J2enZrYi5jLmluY8KgwqAgfMKgIDE2NCArKysNCj4gPiB0YXJn
ZXQvcmlzY3YvaW5zbl90cmFucy90cmFuc19ydnp2a2cuYy5pbmPCoMKgIHzCoMKgwqAgOCArDQo+
ID4gdGFyZ2V0L3Jpc2N2L2luc25fdHJhbnMvdHJhbnNfcnZ6dmtuaC5jLmluY8KgIHzCoMKgIDQ3
ICsNCj4gPiB0YXJnZXQvcmlzY3YvaW5zbl90cmFucy90cmFuc19ydnp2a25zLmMuaW5jwqAgfMKg
IDEyMSArKysNCj4gPiB0YXJnZXQvcmlzY3YvaW5zbl90cmFucy90cmFuc19ydnp2a3NlZC5jLmlu
YyB8wqDCoCAzOCArDQo+ID4gdGFyZ2V0L3Jpc2N2L2luc25fdHJhbnMvdHJhbnNfcnZ6dmtzaC5j
LmluY8KgIHzCoMKgIDIwICsNCj4gPiB0YXJnZXQvcmlzY3YvbWVzb24uYnVpbGTCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoMKgwqAgNCArLQ0KPiA+IHRhcmdldC9y
aXNjdi90cmFuc2xhdGUuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
fMKgwqDCoCA2ICsNCj4gPiB0YXJnZXQvcmlzY3YvdmNyeXB0b19oZWxwZXIuY8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCB8IDEwMTMNCj4gPiArKysrKysrKysrKysrKysrKysNCj4gPiB0
YXJnZXQvcmlzY3YvdmVjdG9yX2hlbHBlci5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgfMKgIDI0MiArLS0tLQ0KPiA+IHRhcmdldC9yaXNjdi92ZWN0b3JfaW50ZXJuYWxzLmPCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqDCoCA2MyArKw0KPiA+IHRhcmdldC9yaXNjdi92ZWN0
b3JfaW50ZXJuYWxzLmjCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMjI2ICsrKysNCj4g
PiAyMSBmaWxlcyBjaGFuZ2VkLCAxOTAyIGluc2VydGlvbnMoKyksIDI1MCBkZWxldGlvbnMoLSkN
Cj4gPiBjcmVhdGUgbW9kZSAxMDA2NDQgdGFyZ2V0L3Jpc2N2L2luc25fdHJhbnMvdHJhbnNfcnZ6
dmtiLmMuaW5jDQo+ID4gY3JlYXRlIG1vZGUgMTAwNjQ0IHRhcmdldC9yaXNjdi9pbnNuX3RyYW5z
L3RyYW5zX3J2enZrZy5jLmluYw0KPiA+IGNyZWF0ZSBtb2RlIDEwMDY0NCB0YXJnZXQvcmlzY3Yv
aW5zbl90cmFucy90cmFuc19ydnp2a25oLmMuaW5jDQo+ID4gY3JlYXRlIG1vZGUgMTAwNjQ0IHRh
cmdldC9yaXNjdi9pbnNuX3RyYW5zL3RyYW5zX3J2enZrbnMuYy5pbmMNCj4gPiBjcmVhdGUgbW9k
ZSAxMDA2NDQgdGFyZ2V0L3Jpc2N2L2luc25fdHJhbnMvdHJhbnNfcnZ6dmtzZWQuYy5pbmMNCj4g
PiBjcmVhdGUgbW9kZSAxMDA2NDQgdGFyZ2V0L3Jpc2N2L2luc25fdHJhbnMvdHJhbnNfcnZ6dmtz
aC5jLmluYw0KPiA+IGNyZWF0ZSBtb2RlIDEwMDY0NCB0YXJnZXQvcmlzY3YvdmNyeXB0b19oZWxw
ZXIuYw0KPiA+IGNyZWF0ZSBtb2RlIDEwMDY0NCB0YXJnZXQvcmlzY3YvdmVjdG9yX2ludGVybmFs
cy5jDQo+ID4gY3JlYXRlIG1vZGUgMTAwNjQ0IHRhcmdldC9yaXNjdi92ZWN0b3JfaW50ZXJuYWxz
LmgNCj4gPiANCj4gPiAtLSANCj4gPiAyLjM5LjENCj4gPiANCj4gPiANCj4gPiANCg0K
