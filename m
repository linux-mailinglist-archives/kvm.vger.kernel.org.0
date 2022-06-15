Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5DB54D0D3
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 20:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344237AbiFOSV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 14:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235304AbiFOSVz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 14:21:55 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2048.outbound.protection.outlook.com [40.107.220.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E7E544F6;
        Wed, 15 Jun 2022 11:21:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F4a9aKKCaDPAQgIKDxp7r4z2i4SXcwSFk/i9IcKIDAQOdhm2QiSvqIiJd7TDiJ0DVUEizxIBDKRga1PX+felJlpKKTc2Imabe4trFKMAdlBiTU6oM7GzfbFPpZIt5GK7Lf1RBKDezHHdfpd6pyYJ0ejWFbDR/ZjMZovlGDJ7t5u5spMfNy7V45v8H8D6pSip7HYiTZud2TLZiJMU7++fcppyGDxPckvYBVKoXz+U5ZYR66a6g6BqlqzXRClscDmPamq8BqACoUWh7UIDjeGZaRqPY1Vr7KhU9RcAnSGVfFyeACO2DyctoEzuDC+Glaj0jeeWA+IGFibk39RAeX8RGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=16NcllNhshOWBZDssPVg8X7a0B1e5cRcq333y2PvZuU=;
 b=CULarb4W6nekoXyY1e8SYH/KrZSiodegi1kVXUdGHBIgGuhMcJgtJ+8W66T0jjnRHhSvd12OKDtQ0pUHZn1xmUmKQvjbxpBPcih6gDHXg9ZYwRSnRTHRmIxO6aKg+vupL4kuKsHt3IpTdCQ5q4p9Ck9ijwV+WgaKqvayE6wcvxzbxI7vuHbITe0W+nIiWN8c1qOCMs/+2Aq+yxZ6bZxRvHPEJj00Gdo7WK1MxZmxFBWHutbOLiK1iFj2D6CT5XF+ki8cRb+CcsxBc2scbK6x3BpnPgXz8tfo9M0vZhEjltLIyRilxcAEhtj7L1gLRV8pvWP4zCGU7nHxyjSDwqoMww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=16NcllNhshOWBZDssPVg8X7a0B1e5cRcq333y2PvZuU=;
 b=C+a3CSsWxDwSqBuRaqsQWnUOhCEttfoe4VKmIiKlcH6/qG1HohivS3FaxKnF+hMgA+kTcp7NzSYh/v11a8UUhm/owIHHNmNjmplSBmlYUkyCUh0HiNDRdTWgNsUhKI2ISl56oGn7ObeLpllypn+UBn+bMp8/TlErGwHELjfiBJYkPGH1v1fwt4Oe32xORA49x9C5ipLTVLLvUyyHGERfg2e5bVkrlhI0xTrERrEj17X0sEhBX9OtXMdkQz0e3NIHQ9opDn4Qp2EhDbDU8pjlfUwpBQHSdYOIjGHtlFEcceysmXcSXFl0Hi0aiR/coFREpH2QqEH6WFPiHls3vBxVVQ==
Received: from DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16)
 by BN8PR12MB3156.namprd12.prod.outlook.com (2603:10b6:408:96::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Wed, 15 Jun
 2022 18:21:53 +0000
Received: from DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::d450:aced:134c:78ae]) by DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::d450:aced:134c:78ae%5]) with mapi id 15.20.5332.022; Wed, 15 Jun 2022
 18:21:53 +0000
From:   Kechen Lu <kechenl@nvidia.com>
To:     Chao Gao <chao.gao@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        Somdutta Roy <somduttar@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH v3 7/7] KVM: selftests: Add tests for VM and vCPU cap
 KVM_CAP_X86_DISABLE_EXITS
Thread-Topic: [RFC PATCH v3 7/7] KVM: selftests: Add tests for VM and vCPU cap
 KVM_CAP_X86_DISABLE_EXITS
Thread-Index: AQHYgFW05l6dlnrEPEaeZiMoTvE3oK1Py00AgAD6S2A=
Date:   Wed, 15 Jun 2022 18:21:53 +0000
Message-ID: <DM6PR12MB3500F48AD42562C7DB7A3DEACAAD9@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <20220615011622.136646-1-kechenl@nvidia.com>
 <20220615011622.136646-8-kechenl@nvidia.com> <20220615031407.GC7808@gao-cwp>
In-Reply-To: <20220615031407.GC7808@gao-cwp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8567fef0-5e29-4c58-7dd0-08da4efbec37
x-ms-traffictypediagnostic: BN8PR12MB3156:EE_
x-microsoft-antispam-prvs: <BN8PR12MB31562A0C33A274B0961DEF92CAAD9@BN8PR12MB3156.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q4ZM5ocK0RsjXubeg2z7hLvZLJSbRQY34p9QGPUvgHLSomFFVnJxB7ZzGS50uzIKfzSaMBgI3NlZt4KnxsITW3VphVL7+1uQXbEYTk4jXWZppALIXxqwoR9ZK66c15K+J05/4qV+l26zBh+XxvoLcQnPPRxjM3/r+X02/CPz5n2U6G/5raxEZlaGZVPP7YALQhgKqUFboAJhVOW49s/kgY7l9uS9AOQf6GBDOsnBRlIL/mnOeUy85hJ5ncSqhcDcqi2tlk5IXQlwaokNIGATZ9GzJH8YFiGI/E55wJXvHtZ9qFSjhkLjGbZpT02hzqlrlelo5c/RDNinre6MJaatBOBfxP2AYZM73enQgy5CrfeIZEUiB3Q62UyqORoZQv7Xd92d/AD4G03oDg2vuxGA8gjfZa7TsQ4CM8GWtwfz7VH2g2PxcAO/MDKLKU8SBSPVicmBSajxlr8muRDOvyoTrKDWs+2FY1UlrHpi/dims8ydYQZXzsJV4l9MWw1G6yyS723fQ3YSK94Vzynx13pfZ8FUTLAz+fCgSbsLiskyy21DS2JF2RyxYuYYWRH5b2mfZTX0jFqIbE9AbofZllvLepAgSo27XELv/vc9oY5t4DzBa6ulqQd6ak5qRXn/z91sYmJY47J0a+09rIODniomL88NYHR4LIS7K8NcikFMc7miv55Fa7YRB9dUtcl3kw+6YMcy+geIAlE2SGYlZdObCA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(38100700002)(316002)(55016003)(122000001)(6916009)(54906003)(186003)(38070700005)(83380400001)(52536014)(26005)(5660300002)(8936002)(33656002)(4744005)(64756008)(66446008)(8676002)(76116006)(66476007)(4326008)(66946007)(66556008)(2906002)(508600001)(7696005)(6506007)(53546011)(71200400001)(9686003)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fLTEybJjv6+dL2qnlVaechPxudw7pX+sVG9xgkKjSMM5UlFtwjLZJhqQ199Q?=
 =?us-ascii?Q?PWiDklIeApNZ0UG4TUtR6I5iA1/PjR4VpkcgoP4/oabBYgJP2GWNQEFZEsON?=
 =?us-ascii?Q?A7qZDOtuyGqWyNieymBPEzmwY7k8QqDe+YG7+vzWpy+VEjG9wC1KRzBiyDQn?=
 =?us-ascii?Q?6YC4uFYTzrP9qpZMFokF12pPfHDqnlbliZ8CKlVLvrFHhS2Go4ICnbmxrjyQ?=
 =?us-ascii?Q?kx5eF8MQbaZ2D8t4SiHoS8dj4ehQVlXJcxli0DTaY22RZFBBtDHIhvLsUAYD?=
 =?us-ascii?Q?MJG2pvDR8Utbs3bKivwvygxCGbDKWPwiJH7FNvnT5V1AqG68EkUkKuhCykUp?=
 =?us-ascii?Q?dbk+s2VeOQYfZVxGy9y/9zQ6vJCx50p08Dv5WsoBTMBmmGYqb1sfBDzHI2nV?=
 =?us-ascii?Q?xyshLQF/FkO9NNZDegns4bOnEJwJ4HlTGYYOpE/NuuxJX1XWhJpoGkCupgZ/?=
 =?us-ascii?Q?twcPAHWiUMBtVn0QSAL41PRfl0gfDwo1vIXP4ns1nGHHcEdlmKoQ5bVjGf21?=
 =?us-ascii?Q?K+LGLz8S624DQlovtCvtlvHJ+N6J/IOc+LnMgauSSbLBCwPgRfXJ3EP1I/QJ?=
 =?us-ascii?Q?ZEOAwLwAi6X78HSdEvzTuCK+dlST5BqsMM2vllay0Mkz/KYa3JdETcwWpJiQ?=
 =?us-ascii?Q?APfT4RIUK6ITyMBbX9Cv7zNCzoIMcaMsqcDVgmXRqW+mUF+KTCBbw8LRMueT?=
 =?us-ascii?Q?Yksc3BUhqYovn+gD/BAnaoUy/WkvxlxEFnb+Dk1686oW4LX7zLshkYf2CZdJ?=
 =?us-ascii?Q?u6DJAB+10qCv/c/YfxwzU/u6OO5SG0TVG95aED1z1f+Tb9X2S4URZjcf/BtV?=
 =?us-ascii?Q?X68wvL3qX96umMS8aDF8e9uUHiMw3V5ukGho2BHQi1ZUuLX9NaaG/mvgG0dq?=
 =?us-ascii?Q?ohBO6izFPTtkNr4yGx62RDtCTfeISSyZTQtBk1ucaZfoEzIUoIWdSYU8yhQ4?=
 =?us-ascii?Q?T1kgiXyZYq4HPz0i8ljzETxf8cOuplE0wteZYPNYjaAv0aRyXk6xMQZ+fgeu?=
 =?us-ascii?Q?y0IPBhh1K2ySmmcR1sobjJdJWc+TnOwlJOBb6YUPN+wZWng/np3paMHx2Um0?=
 =?us-ascii?Q?uoHBsYpGXHMokCj2kBJqBN6kum8JLntCC6UjL0RYV9Vq9qwo/5A6rHlGCDVe?=
 =?us-ascii?Q?bmsrjgMFILADCFrWUL5Es7Uo2KaNFm6Me4IQNo2IL8OWZqi2asa08WaK4yzX?=
 =?us-ascii?Q?D//G5UnJS/dhaB1VcGfae+u8bKVf0NA8Ey8+4Iyzl6si0wQsZW+4TQQdUXml?=
 =?us-ascii?Q?LJ5XrzdnqRRahLNBsQO7bTAiuSCDvXIFB1fruCB2IFDdDtSJWZI/gDLFP8r9?=
 =?us-ascii?Q?KhtihFlGV+kG1GZiMdFJ1Lco7vmKPyrEAi67I9lX4xqMYpnu/LvQYJ8yEyI6?=
 =?us-ascii?Q?KoChmkY5woCibCTwzJwpaipRbAclX0+Qsap9JtsqkpltC1WQeRv6Ppbbuumb?=
 =?us-ascii?Q?BWvhTo9W9PP4BvVLJHfj/wXSRV6fCPhM5vnO6YtEeBLqxHfeyrVca9BuZn12?=
 =?us-ascii?Q?oiRLr/kfXsICRWnBlZqtVJr2UeGSKrqAi0HopD9HKfPQOl9jyu4W4bjdhQp5?=
 =?us-ascii?Q?waKjpblY+lbLXcF4cf5I/ZAPduU+T61Lw0q2c0W6CoeXK2s17Mo5GoeiFx/K?=
 =?us-ascii?Q?Hqfk7hZqDpYZpebn+1oMs49jCOccsDEVH7nPO16FHvTR7tINtuHZPdICfAOc?=
 =?us-ascii?Q?qWNtvkRJLzXHuEEBCMdHNDWtMHCvKWeJeIgYXw4FLHfGhCptaPFc3lgWzFz4?=
 =?us-ascii?Q?6sAmYiP1Yg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8567fef0-5e29-4c58-7dd0-08da4efbec37
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2022 18:21:53.2851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mAb8eqW7q4b99m51iSWdXUm5elOpVDTXJYJq2zcFoIxbaxlBkqSxWEENW90vAugNz1sY9jrycAPebt18LOr3vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3156
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Chao,

> -----Original Message-----
> From: Chao Gao <chao.gao@intel.com>
> Sent: Tuesday, June 14, 2022 8:14 PM
> To: Kechen Lu <kechenl@nvidia.com>
> Cc: kvm@vger.kernel.org; pbonzini@redhat.com; seanjc@google.com;
> vkuznets@redhat.com; Somdutta Roy <somduttar@nvidia.com>; linux-
> kernel@vger.kernel.org
> Subject: Re: [RFC PATCH v3 7/7] KVM: selftests: Add tests for VM and vCPU
> cap KVM_CAP_X86_DISABLE_EXITS
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> >+/* Set debug control for trapped instruction exiting to userspace */
> >+static void vcpu_set_debug_exit_userspace(struct kvm_vm *vm, int
> vcpuid,
> >+              struct kvm_guest_debug *debug) {
>=20
> The debug argument looks pointless. Probably you can remove it.

Makes sense. Thanks for pointing out. Will remove it.

BR,
Kechen

>=20
> >+      memset(debug, 0, sizeof(*debug));
> >+      debug->control =3D KVM_GUESTDBG_ENABLE |
> KVM_GUESTDBG_EXIT_USERSPACE;
> >+      vcpu_set_guest_debug(vm, VCPU_ID_1, debug); }
