Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A1A73D349
	for <lists+kvm@lfdr.de>; Sun, 25 Jun 2023 21:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjFYTXh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jun 2023 15:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjFYTXf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jun 2023 15:23:35 -0400
Received: from MW2PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012005.outbound.protection.outlook.com [52.101.48.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1F4EA
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 12:23:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bpF+ZgYoaZqK6iGIzUeTP4fnvSH8ZObRdDUt/RWFrIsGSYmfsSmdKgzLHCN5ke2cIHYEd/4Z/Dm+Bgc3XhsrxKFYe8x49hjUbgwrRtfGJAAVv421v2TACaR+Fy61O9wX0eVHrFLHb2mLcl/jbF4iB4l2hTf6HV10fyzSGCXDnRZEWu8vM90zF6Ag6/SIZClDl0WNUA8lxd+N9Wn0qa4buC5raJBY7ZcPLWVZyz0ij9oPRuUjkpKluslENEpZJM1uUrxczc7efpDpqbR1lhkW1iQvNPwsq5xdZIJFlPKXoR5hQblyU4jsL02iagTFAUSefZ4H+od6P4j72Q/z67ZclA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=703AAKO84LjDIDNM4nQ+X0Zwd5DO/upgnuWk+qPlWdM=;
 b=JPklN1G7QSnu8o6rZTIIioVVqzsm5CsdrakmqqpB6FuIZ+zV88731dwokgkMEojWwlkchIXjsW8xbVijZy6NEpmF7WYYIx3c8viiBPUnzB2Al82XTFJ/9pkG7mhTOnje0haGNzoCfWpsUW3PzlmJkd3o3EnkZMdx7E6FD/AYOd5/9iWqnhEGnV1KmlnmZf6nUy3fiZ4rcx0ctmYrIN9/+/6VB9D3XBCPBO0snwr/hvLGyAOkg70vV6LgqZ7i66JvdGJLeJ/gQ6EFKeT9A77vCO7HK0IJ60CQdLTf0m/E7HJ1eWYykYDN9IQakSF/3IOJKf6lYaivS59CSckDupKZjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=703AAKO84LjDIDNM4nQ+X0Zwd5DO/upgnuWk+qPlWdM=;
 b=RZjliXp5KQdMI3Q3gIcYZgrM060azQ+cZsJQUh/jGLaY08iaDrEIBJFhttYmKXtvUWStfZaLMbImJZmZ8xgK17O+l6EJAvIvxJbJK95/CkW+q2/K8284f9vnVFInaVe5KY0I7xprbzJxisvr4/ulyZp1LAkUk/69j2/hq7jGQPo=
Received: from BY3PR05MB8531.namprd05.prod.outlook.com (2603:10b6:a03:3ce::6)
 by IA1PR05MB9431.namprd05.prod.outlook.com (2603:10b6:208:42d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Sun, 25 Jun
 2023 19:23:32 +0000
Received: from BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::45c9:cdc8:ff01:5e8a]) by BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::45c9:cdc8:ff01:5e8a%6]) with mapi id 15.20.6521.024; Sun, 25 Jun 2023
 19:23:32 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Andrew Jones <andrew.jones@linux.dev>
CC:     "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: Re: [kvm-unit-tests PATCH 2/6] lib/stack: print base addresses on efi
Thread-Topic: [kvm-unit-tests PATCH 2/6] lib/stack: print base addresses on
 efi
Thread-Index: AQHZoL4GR0tbe9IzCUa1j8E5iDa5Xa+Zx4OAgAIsAoA=
Date:   Sun, 25 Jun 2023 19:23:32 +0000
Message-ID: <9A5C31E0-E1CB-4986-BCC4-7516E171569E@vmware.com>
References: <20230617014930.2070-1-namit@vmware.com>
 <20230617014930.2070-3-namit@vmware.com>
 <20230624-9983c4a6d41751719785a95c@orel>
In-Reply-To: <20230624-9983c4a6d41751719785a95c@orel>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR05MB8531:EE_|IA1PR05MB9431:EE_
x-ms-office365-filtering-correlation-id: b27ed961-3b6f-4bc3-c1e3-08db75b1a9f4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FnNxuFUSZJnmu1URE+atTOnUWZOeHv/zH1W/jNf+ZoNqxJHVnN5A17BAnCyKV4NZIBn9LX+DMGVN+Dtfk1/gX0LI6oKziPbZIg4k7VGgcMhPz2BCkqyIOXdM8zEAmcm2X4Xpbznxd1F2IA3WA4pB8mGAbpdWEFuDYUqxC+oPdC/cHnBsfWeBY4sBHbN/z0ZPAu8CDRaLFcwyWVJje5uAe1kJzo8XGS2X9+frI1+YdMyl7FUAmWE6hoR0dnxGLpOMPMWH6ZkLANlt5FPaIkR62A9HmsoY2oymmehrr+pnLGvPKp0O024sAlOQO8hnto9lGgmpUMxDM5ojChzqLDgwlxW6Cg+xx86cr8JJG+LdT5E5TI788GgC93475P2T1D8KwlLtTgDo8E0EHExECrw5qSwpMY0P/uxOIR+bEPK5ebRvrft0drea9JyA//zKPLbNlcHZqz19jG24SyJirZCo/GVOLj9BaRYTuNzQjpfihqmPXRfpjoeAMp0CLr4ImwskE6WQmRPFFzK91ZfMExnFLHmR8Zveoq0u8JwKKqMtZ+jM3gwnwt6Nx2hYDNkU1ZzzvJ72AIB3hZEhP6tTxF7ykWGEcHLjry1Dmlg31XcVFFbNI0GHmg5+5w7PwDEJUsFLPH3XdabvvxkVGxUCf27mtyYoHNQkjhGcFMqf1RV1kvtIIZoS5PhX+jr5nTw3UFtpqRGC/DcNjrToipY8U+VM6g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8531.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(376002)(366004)(39860400002)(136003)(451199021)(5660300002)(4326008)(76116006)(66946007)(66556008)(66476007)(6916009)(66446008)(33656002)(64756008)(558084003)(478600001)(36756003)(316002)(8676002)(8936002)(2906002)(54906003)(38070700005)(86362001)(41300700001)(6486002)(53546011)(6512007)(6506007)(26005)(186003)(38100700002)(71200400001)(122000001)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?828sGltOOpLOIZHJlvq5AGbO+g8nUwFbnpb1wXWa+zn6NwMPmVfHpm5bQ7IX?=
 =?us-ascii?Q?kHgLc7AyOy4fYque3qyHzY6MMkXcoTbnIoguEdahziG+c84dgsl0w1sjPO09?=
 =?us-ascii?Q?vHBGpThF53WaoJUOPuTjbS1Vp+Rurl7frbMcnoTgVfo4rH+SHVZzUIb1b3ot?=
 =?us-ascii?Q?ZV+lEd82mKvJglupf+lezledfLzYHK91Rtsg9yZqZQKiWgvI5v6IWBEn8NrC?=
 =?us-ascii?Q?lsuQVdipLx3muarATPU67/XYlW3fkA2Nnw6CWv6JML1T+rowsd50x8wBY8il?=
 =?us-ascii?Q?BCSeK1I7yLvmYJ/TE+Z1letG9VWBPUUV4kG4XZM9inMToVa1TTnHBJa3AeUc?=
 =?us-ascii?Q?2drd3RSnK2w6fqqJdD/oHEKA1Fe9Es6Nja6yBrjmdeTn993H60XUgjM4/YYY?=
 =?us-ascii?Q?VDImIutOHl/L1q5ELEN7l+PpmCJ1/fqVcp9PYDNrNU9oImmOlAT9PZizOa+c?=
 =?us-ascii?Q?tXeNdoaqGwFNXweh5PrcxZ2GEBGvvPnl0CLEN5cfF8NLNiqyzoJnT9b5tpQ8?=
 =?us-ascii?Q?DUqCtgiT2L4vCChE956wiUl0Fc9hK7nSMPpZ7wPOU6StbgvFoaOtchAXZfwY?=
 =?us-ascii?Q?5aW/hyrTHZ716vl+g87ZioJu2tPLVGM4MkT/fpRwdr/IUK/5SfBScNQ51L5t?=
 =?us-ascii?Q?YqkJ0Ox6OiwELp+k+Xa8JVPoQG3TdTkHv40QH+dESmcgr0OEloBrvnZIjOIg?=
 =?us-ascii?Q?15bDwCG/3oKGc2ze/DGdMXR2dtsGFJuZZzqRnJKDfEfPS8M8Etkxu9sGyYGN?=
 =?us-ascii?Q?xyGGTs+6Rcc3L7hXoyh3W4sF74cE3AzL/uLEeYiYEgONdAM3vN2zViPNOKis?=
 =?us-ascii?Q?BUVhJwVKi0H6VAxA6u61iksgYMUt0DEmUvE861jo7FME4QqdCPOrp1vNWD/o?=
 =?us-ascii?Q?uMztRF7HqAQ0XzFye91EuyEgzLqJh/W0+xIVZyhakDaQ7T+dcW88bZ0VsKLq?=
 =?us-ascii?Q?bTB3sWoJZr8A0e06SV6oKsiO7vxgE6f/VgnnjGxa82k16KP3lr/iMEwWO8Dj?=
 =?us-ascii?Q?wH/WcIM3eCtfGKKEvpwPGPtD5D/+TAjHzR+dycY9Qn1jNvMlyUxAtVfJtOJc?=
 =?us-ascii?Q?UPPiQM7WAXx+BsnFpnmRGc5j2u/6GTmwoyChuv/vRd3nIlvJTQjxLLP2vblU?=
 =?us-ascii?Q?6VCh1jbt/g50ygGi3/PRu/ofEvnk8mIUnDIiKoSZFD6sPgKcbaetL+iuSk3v?=
 =?us-ascii?Q?zVDB5c3BW3P/V2OwbWjcSW6Je0G0KB/lyC535NV2GVMI0hUXGJyHz14K56YT?=
 =?us-ascii?Q?zuzAZz1wI6hEnTut5boOyYA9nRCqrSuECEjvGvkc7V/rcjrYOuFbSMqBcXN7?=
 =?us-ascii?Q?SfL4r/LY4rYgy9kc8WWRV9gjMsRHvRuE38R5OHJJOBFDywNTc6G5U8UqQFWY?=
 =?us-ascii?Q?d7hinFwovgeN78bVtyieXEz+0G3WcsqzHgn2vrV4qtHX9ABrq1Z8/Co5IO0B?=
 =?us-ascii?Q?6o3qeYNj925tvQl9SHTJpvd4JLvf2U7zoOMEBoSJPwtdz84yulry+n2HHWms?=
 =?us-ascii?Q?RekVey7LqUZkqtKNe3Vu7c/LbYkxZhMYz3BqzuPQevsljZb+OoY65i+YUDmH?=
 =?us-ascii?Q?taaTr2Q30zoFBBPZboMFoNjiRS8KKTEyWtU/upq9?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BC896C175E1DCA4B9BE55396D69A0127@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8531.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b27ed961-3b6f-4bc3-c1e3-08db75b1a9f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2023 19:23:32.3939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OE3Pj8nfHypHmkVsrLhfG9MIktkf+lAo69S9fTNJ4T9jU6pD3eVKz4eqAeGHSgLNj/Gni5bQmnO+jvecH/xwjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR05MB9431
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jun 24, 2023, at 3:13 AM, Andrew Jones <andrew.jones@linux.dev> wrote:
>=20
> We also relocate when building non-efi arm64 unit tests, so this should b=
e
>=20
> #if defined(CONFIG_EFI) || defined(__aarch64__)
>=20
> Or, we could create a new config, CONFIG_RELOC, which gets set by
> --enable-efi and --arch=3Darm64.

Will do. Thanks.

