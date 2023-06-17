Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473A8733D81
	for <lists+kvm@lfdr.de>; Sat, 17 Jun 2023 03:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbjFQBwS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 21:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjFQBwR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 21:52:17 -0400
Received: from CY4PR02CU008.outbound.protection.outlook.com (mail-westcentralusazon11012001.outbound.protection.outlook.com [40.93.200.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7AE3AB8
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 18:52:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZRgX3U53iREBBX5g8llTaep3gH7eHV1QXOR+mRkE+kPBPHopGnfbi1U/jMMaPfc6g6lElADE31LEFs2MEgW9dcvwdIpbUW1P8MEtLdQCrzFAGP3i7fsBCwUwUTyER/duOQ72U+gc8cdO8USYbiD8qp8zM0f+yL8v74umerKa1tiJEvSfBSCmAEzsbdNVzhaACTS6ej8D/aeUxMGPt56xvvv06XdjwX378BG+pzBBNLj/8Ebf+Qx48GXtPNiaKM+WOeFX2qw348NOcz4TaH2mReAJuug+nk2kr1RS8rW8Gz1ZmRjkPTFe5bzM2zlxj0Q64fHwqw5JBLOODF1H9NlY+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=txlbpfncO8rB3QOcX/VJT+CRZcsl7oOJPj1MK4oBvyg=;
 b=HQtjTO+ALBGpwgZi0vJuwm5MnE4j38W2D4vA9KH60aKX+RmOBp4C3MDIV0tYBplAiFsbqo4cf0izyt1saRVrQPjOmt+DgNcXEbHJVcnxALD3mHbHRb7aNVZ2WK7j7nKSE20cxUGcus0dgWTWUOo118S4W51m8RbbfS2xub7z+Fdqvb2qO4iYFf67otk4dn77wyZ/DSGRSQuROLwAD4n2BEYMcCuJe0bPdVF/twDrhQfR5/cFsA5jFrZ6eGtLnqkD5cnr7T6eyAy3Px7/B840IPPrLAhhQJ9G4mdNKHGFwuRD0PpGxSQqq4RAGljyclW3LZ3QwH+Y/8mymSxeQ1Nu+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=txlbpfncO8rB3QOcX/VJT+CRZcsl7oOJPj1MK4oBvyg=;
 b=xqo2Mt4ZmKeNJdwULki4JQs2qanaITLjouju9H0saD42FMcLrNeo88YDpMjKjBNY1nHTDeEpFVOQN+3nDZGCL80DTvc1ekZV7Gi1NKUf8vjq2tPqCgw+bS63DuQU3fqFLIvxaF+hdD45oY82CM7gXqug3n4cqR2niCp646mxGEA=
Received: from BY3PR05MB8531.namprd05.prod.outlook.com (2603:10b6:a03:3ce::6)
 by SN7PR05MB9261.namprd05.prod.outlook.com (2603:10b6:806:26f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.36; Sat, 17 Jun
 2023 01:52:13 +0000
Received: from BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::45c9:cdc8:ff01:5e8a]) by BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::45c9:cdc8:ff01:5e8a%6]) with mapi id 15.20.6500.032; Sat, 17 Jun 2023
 01:52:13 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Andrew Jones <andrew.jones@linux.dev>
CC:     "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: Re: [kvm-unit-tests PATCH 6/6] arm64: dump stack on bad exception
Thread-Topic: [kvm-unit-tests PATCH 6/6] arm64: dump stack on bad exception
Thread-Index: AQHZoL4LOiB8/aauukytYwf8UyR8cK+OOyIA
Date:   Sat, 17 Jun 2023 01:52:13 +0000
Message-ID: <651794A2-0FE7-4F9E-9C4E-60D48C6D19A4@vmware.com>
References: <20230617014930.2070-1-namit@vmware.com>
 <20230617014930.2070-7-namit@vmware.com>
In-Reply-To: <20230617014930.2070-7-namit@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR05MB8531:EE_|SN7PR05MB9261:EE_
x-ms-office365-filtering-correlation-id: 42617142-096c-435d-0221-08db6ed57887
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V9lTkiHO+hLIQY9UJufsX8UnyjnaC7pOOwCj+jdcUr9IMLAddl8C/NrRBG4tH6xT4lUzIElGpNhCVfHEGhjuMzm7Rsr6XljxHu3cKGwKkGAIryQReeipfAXnvuW4XN9EVBiFRXO6PyVazKdKnx0AGXNyHrzFdJcVetwb3Um6dF21/wFX9J2U4r2t05fzdSGxUAVROJ4zc57w1x8tfXB6safdq6vYj7PLnJ0pWkbw2RwKvQlsPhFlS0PPjUFYPKY7MF8S/OrntPfitMiqTfWjpyfQoND1x+M8RGKuOfZayhE+XP7pj7OKshVdsaoLT/misNajq8VTIJHRY3zmwMNyQ6JWFiFWHvvn5yqnC9d1NNuOU0Eb3aTkEmif7NI9BA7RfCM6AJQLctQnjPBm2eb445e3EOQ1aSgzIqXl7Uo/wD5ypNsDwENHv09B6SG2pUrpXy6H6qdUOYAMxwhXrFozMVGhbDu0HGulh0FJqoE6fHLywMwwSBjAbhR7rL6ielcQQI+z/XORV7jiSjAbEUBKVpW1XQZRL9TSmSYU49aWY6nszdJ3EwGVUmjBhBNCbFiJmQkz8i+Vr8Q2+C+1eRN/rP2X4vVdWC0CMtfquecOfjehnSTrtKPeDg1J+FbSaZB/s56hPbwHO1k5Fzhr6eLZ7w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8531.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(451199021)(6916009)(26005)(5660300002)(41300700001)(53546011)(2616005)(186003)(6506007)(558084003)(33656002)(6512007)(36756003)(316002)(66476007)(76116006)(8936002)(66946007)(4326008)(66556008)(64756008)(66446008)(71200400001)(478600001)(38070700005)(6486002)(8676002)(54906003)(2906002)(38100700002)(122000001)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uMSMxMmhqJxDvIaJ1M0IYEFs+dzYmtb54l5OdxDmfXTFlQ9A/bv1ZKiTjvY0?=
 =?us-ascii?Q?uZ9SMgwBOWiyaGyEiApsq7Ce7id14GJcxBmlkYH/SE4xJtaYA5ICVMVwXz7C?=
 =?us-ascii?Q?nUZpeLX/mzDjbKWKCRY1fd8a5KWd+K3KFBkm9JOU3dptq26zINg2rDklNYgN?=
 =?us-ascii?Q?s5bf128XcHSOvdz99xpIutVKz+pUe5WCS+cxuqaWm6G5dOwbe11qUh19mpfR?=
 =?us-ascii?Q?pJ0J5Nv7LVO/5whV+cfqno7M+oj6M8GbBTniAEAsEEpyo1uKbdpIjcFUuiy5?=
 =?us-ascii?Q?ivXPjqB/CvG9KDW4A+2wjEjIAyZvPFuqBW0G4eF1537AezHbHmDQj6EXpaYu?=
 =?us-ascii?Q?dP7pQ2qTuC/hPmSD153O+gilRoW516sDUxbzLoQJLlgmCHIb3MqYzXJnYrSu?=
 =?us-ascii?Q?KTGSl2R+DskK2M9ic1HCinw0nPVvWD4kq7zhN2gc+LiUy0NpWDHoqDS026Es?=
 =?us-ascii?Q?XwDxJA4EmaSLh74URqdnrCKIAr/mRP6gBi+6HNLSPa7p67L+1VsB61VtzaiD?=
 =?us-ascii?Q?Dp26yXP3tN/JxNGNW7m9JMglPUqehuQzRI2xBgljh58L7+aJt4L06fxYbJwY?=
 =?us-ascii?Q?5oLYoo6pWyzHXAZW/vhY81oWO58XiniZrLtmpNSAhB5E0uOfdFX0ARGhplSG?=
 =?us-ascii?Q?PAjFHkILHtHDtSW8+/uWMOGhBtD5s+f2skWcAdL2w5qymECYTgt0opwLWHEZ?=
 =?us-ascii?Q?fd1K741Bc1iZY9iaepCp/R3QLlkd7LYZpAAAivPke/PqFdqae6k7eQX3TlXz?=
 =?us-ascii?Q?hI1u24MRc6cKYUAuYLFeekTCCLG0JorAwAiqe70Fa0BqawXm2hwI4E1DmHjQ?=
 =?us-ascii?Q?7E6NoPz+dv83nZJj7TmlHBpaplkyAzIfW+9z5U7ztCupdGQH8sIGaEwlmxEc?=
 =?us-ascii?Q?+9H7CnV4evg6lfsb+GW+PDptUkgPm3FL7kBfowGgoxBMeuD0t+GTnS3bZep+?=
 =?us-ascii?Q?lAYaXsrit6oq0Kd9gLKQSHHvzU3W2vGbqOr8LWGMpUSzWzyXebJlnRjIe8D7?=
 =?us-ascii?Q?1OGM2KJhSBPyE/QJ///5E3M0qLhyohaFYrJlM/9uD2Wn3GEvQ19QDTqCEJ80?=
 =?us-ascii?Q?3PkNMaVaGzton7P3xQM0/+ZksoKPfBQNeU92MpD0CcnoWpuU9pA9zlKhGwxs?=
 =?us-ascii?Q?gqEm9RLF+5T03xYm4L1q/xQfk45uMqht2HAuyo+wh8cHD/tGpH/2TnbZLg+P?=
 =?us-ascii?Q?3B++LaP9bE+DSaSTJOiCrPDeZJXs6heJlh6YWvN5Dmiq/1anlgsJ6bqS6Yqs?=
 =?us-ascii?Q?61PEgu0nZ6hoGRAsqFYMsRcou95G1HREQSG8r/gPwgetwH/SSjS1Fj5bhLPH?=
 =?us-ascii?Q?z2519gThQbifMiV+NQR8a2M1rMFrNdctC7av3GJG6N7uCpD+2Hdlv5x+Tu1I?=
 =?us-ascii?Q?v19kcgno7SBd440B8iXW3VKclPlK9LhJm5Ghb4gNF3iihFHmZlE4FfWYlGpM?=
 =?us-ascii?Q?mrK6dOOi9pMFbymPhQebMbKtjmFZBmpPpgx2YhixmwO2FKrQ/gxDgQyhKR7Q?=
 =?us-ascii?Q?Mw7HyJYCla8K7plygs2f1virimsYkTMhfamN9pDvhn2D2jLUCHUhBedlIx1o?=
 =?us-ascii?Q?w1PJ7zyQfrUR7kdcQSi8aF2p3K5/Jpk2uEGL/FPK?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4258E6C0B15B3149AC8AB20D4F67EBFE@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8531.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42617142-096c-435d-0221-08db6ed57887
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2023 01:52:13.1728
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D6xBaDvYFbyoy7MDLtjtn+rMG6MQTzreOi2Lv7yBx0wlgYRQVBKlXeAfMwfjZ/YDqLQCiSHi58uq5cwUomNrVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR05MB9261
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jun 16, 2023, at 6:49 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
> From: Nadav Amit <namit@vmware.com>
>=20
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>

Ugh.

Signed-off-by: Nadav Amit <namit@vmware.com <mailto:namit@vmware.com>>

