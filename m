Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB8141B31
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 06:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729607AbfFLEdz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 00:33:55 -0400
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:54247
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725280AbfFLEdz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 00:33:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t1IAPRsyJixiIDkuGc2CrGq3QqlHknmJalCsZSN7AaQ=;
 b=Wsh8eoz/6lrY/omXmsTwPCsz7twTJRVg6BfnsmojBhl7tcRbUjxk+voi6RLE2u7Qd8P11ODuZ7Ol/jcZwbU2QyAAUTaW1P1R2A/zybV43gMB69uWfNXwj8n5hOFYYoXNLs8zbVHh8hQZBANTi1irR0aREZjVIjz6/dDKAjqxFTU=
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com (10.169.134.149) by
 VI1PR0501MB2848.eurprd05.prod.outlook.com (10.172.15.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Wed, 12 Jun 2019 04:33:51 +0000
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::10d7:3b2d:5471:1eb6]) by VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::10d7:3b2d:5471:1eb6%10]) with mapi id 15.20.1987.010; Wed, 12 Jun
 2019 04:33:51 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: RE: [PATCHv6 3/3] vfio/mdev: Synchronize device create/remove with
 parent removal
Thread-Topic: [PATCHv6 3/3] vfio/mdev: Synchronize device create/remove with
 parent removal
Thread-Index: AQHVGj4q7+/NzeZHEUWGN8sRZjbLIKaK/b4AgArXHICAAPRRgIAAskuA
Date:   Wed, 12 Jun 2019 04:33:50 +0000
Message-ID: <VI1PR0501MB2271E9CD61064F5A552BBFB7D1EC0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190603185658.54517-1-parav@mellanox.com>
        <20190603185658.54517-4-parav@mellanox.com>
        <20190604074820.71853cbb.cohuck@redhat.com>
        <AM4PR0501MB2260589DAFDA6ECF1E8D6D87D1ED0@AM4PR0501MB2260.eurprd05.prod.outlook.com>
 <20190611115517.7a6f9c8f@x1.home>
In-Reply-To: <20190611115517.7a6f9c8f@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [49.207.52.114]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5e5fd51-19a7-454b-f78e-08d6eeef2b50
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2848;
x-ms-traffictypediagnostic: VI1PR0501MB2848:
x-microsoft-antispam-prvs: <VI1PR0501MB284848400E65BC48AAF47F8FD1EC0@VI1PR0501MB2848.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(39860400002)(376002)(396003)(346002)(189003)(199004)(13464003)(256004)(76176011)(14444005)(55016002)(4326008)(68736007)(52536014)(3846002)(55236004)(6116002)(478600001)(6916009)(25786009)(53936002)(102836004)(8936002)(53546011)(14454004)(6506007)(7696005)(99286004)(5660300002)(9686003)(186003)(229853002)(74316002)(7736002)(33656002)(446003)(66066001)(26005)(2906002)(66946007)(73956011)(76116006)(6436002)(66556008)(64756008)(8676002)(54906003)(66446008)(86362001)(305945005)(476003)(6246003)(11346002)(71200400001)(71190400001)(4744005)(66476007)(81166006)(81156014)(486006)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2848;H:VI1PR0501MB2271.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: K7/De5+DIInQJXefBJaF0zzTArGled+A+EedBWy7YrLW0jSvDR2ltefHaNs8dofMRIOu1Q6kGBDtLIGujODHzT8vz5+kCyWborJ7w/0kH8+Yj2cO5yKBqiARhWYFLcdDVSm5H7aLm8vhkyRg0gFIZcs9p59Lpdi0Ju6DZnd5HEq5VRMyzL1rFC5ESxFRsOoqixoTJZ98GAtT5bGISgMqg8GuYRPiQUIDGdfgvUCEjGm4PEoYSNeQCKNJoVbM/SYhgHcUatbKj0tt1DtpCvhTnH3w9/hX1FFVk9M6kfOO0K3Fp1QHZ8EeO2f2E3JkS9ZsrqxRKoAH7FLFaV+FFEcQpGKII8pQhAIyBRuX8UHKGrMoF2YCFXeqZYVYatIYXVHsVdOjnCC1xNREkk8vcuUiJAtzOdiIfgVjGBy8ctd4Gws=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5e5fd51-19a7-454b-f78e-08d6eeef2b50
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 04:33:51.0054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2848
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, June 11, 2019 11:25 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Cornelia Huck <cohuck@redhat.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; kwankhede@nvidia.com; cjia@nvidia.com
> Subject: Re: [PATCHv6 3/3] vfio/mdev: Synchronize device create/remove
> with parent removal
>=20
> On Tue, 11 Jun 2019 03:22:37 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > Hi Alex,
> >
> [snip]
>=20
> > Now that we have all 3 patches reviewed and comments addressed, if
> > there are no more comments, can you please take it forward?
>=20
> Yep, I put it in a branch rolled into linux-next for upstream testing las=
t week
> and just sent a pull request to Linus today.  Thanks,
>=20
Oh ok. Great. Thanks Alex.
