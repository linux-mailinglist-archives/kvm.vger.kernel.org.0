Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2EC48A7C2
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 07:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348196AbiAKGgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 01:36:49 -0500
Received: from mail-sn1anam02on2083.outbound.protection.outlook.com ([40.107.96.83]:6179
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232940AbiAKGgs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 01:36:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OxtTsSfgZL7iQedr7rsqNRmqU9rYaVOF8QOmXHFrWiGirADKbGJCXakDlGml9ELFL9dhmAfvylQiwmboUQlIzYD0Enl5u7aP7vISnai7/IgK1IpQtkbtYsI4vf7o2dHIMG7aBzeTTePDYcRuowTtwC5vfHyQCikBzgf+xA4JMzHXx3OIzZVMYBAUjN22KW6m2RqRnejlG8FadRRNyPz156Kp71i/dAiPvZvPjcl86E9Omfnq0gyKcYEOExWLNqnPfUzm4JDbz6iPN050T45QDGzRxKnH2gU6HP8MjLVPUaB8ivh6lNCqibYLn2f++ZWk6wDe21cVqbLf4ZSUcvNIyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=twO5P0nuJHPKJbK7eBt1E7wxH4BdSFB9NaMcr/yTMsk=;
 b=SVC74mQSM+S6uVFKd+x1t+8su7l1wdORv8d/QTGGm9x7AILPqXLvF1y/NEAwGUpaoT3imVTlzMx4PYSqAoRFP0EprQiUBI9cpeFn9zAhqFwrxJZE7zsGJPzhzl3o5WpDaQpZVj7KRXEviZaJI5nhl0ePkThYidDKiTTWCLJYzAz9kJ3CIQq3zaH4J9x+pSgucw+s0Rgu/ohkgmGgfUzBTpX6o4OsS9fq/BDDfC7NTMTbTdZJa3JckcD/yQ/7ufkIBOytKT9p+2NXPQUuK0aPfro4bPcjp4Ozemgn4jpzuvQLLbn9ddaPexD8tMl5fy/Ty2WbKreMfl2qLJpUi3/Y/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=twO5P0nuJHPKJbK7eBt1E7wxH4BdSFB9NaMcr/yTMsk=;
 b=klYmUP4x70c6ZXbHp2UYC8e9Ykgk5QTp0sBW2QpgasbdGW49GmMMIOcoUK2Wp0I54GvkgSjR/Pblfu8sLqI4dyNab4MqGwcoW2r2V3pz+IpZrfQ7h1sHA2VY9P1j+AVPcxagtDFSaoeQ+hagqcrlyT//vNagpBpudSOZ1phrOsNN2cS9u/DUD9MMFeFlh/wdXTHWOj+1bQ5LcbqHkpPXydK3F3TuJxrSl5mIHpovFxyBJoxm7wCl3i2iL5yblcYVb+F130vA4l49wFYHZaBSRyYVCskI1QxyzV5NfQ6zqQ34H56GkRuCHwLf6hDEhJCApWvpaDAbmvtUgoYr3BbMUQ==
Received: from DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16)
 by DM6PR12MB3033.namprd12.prod.outlook.com (2603:10b6:5:11e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Tue, 11 Jan
 2022 06:36:46 +0000
Received: from DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::9031:757e:d174:3857]) by DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::9031:757e:d174:3857%7]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 06:36:46 +0000
From:   Kechen Lu <kechenl@nvidia.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        Somdutta Roy <somduttar@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH v2 3/3] KVM: x86: add vCPU ioctl for HLT exits disable
 capability
Thread-Topic: [RFC PATCH v2 3/3] KVM: x86: add vCPU ioctl for HLT exits
 disable capability
Thread-Index: AQHX9koEtqUfpyHZkkeby8KEcdrzF6xc3GqAgAABPgCAAI/ZAA==
Date:   Tue, 11 Jan 2022 06:36:46 +0000
Message-ID: <DM6PR12MB3500BC3ADEB0AAD6D20AC1B6CA519@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <20211221090449.15337-1-kechenl@nvidia.com>
 <20211221090449.15337-4-kechenl@nvidia.com> <Ydyda6K8FrFveZX7@google.com>
 <YdyediQZQPB7h/kU@google.com>
In-Reply-To: <YdyediQZQPB7h/kU@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 887825d7-c004-4eae-8c5a-08d9d4ccbd4d
x-ms-traffictypediagnostic: DM6PR12MB3033:EE_
x-microsoft-antispam-prvs: <DM6PR12MB3033EF842B41654D465C5E94CA519@DM6PR12MB3033.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nDDjNbnB1r69vsIlLVjMdkq3wi0N/ZjKoIsrAkbT9R/oonWCnUXgnvqt5gw6F40z/q3SgAtveSQ0wKrbXndIozPSaZspGwiKHrMsLoiN02Mm5yQUTF1Kt6KWlqVP0BxqHw22Sgx68wRmsVoNuYwYT/Zr0C0kTWvTW20wYHMEWJnjgHrkB0bi4FmQn+urFEw0uFkpU0OT45u7IY8iujHwEL1vd0Zk+MJ6FK2ZJ29hWN5Q60gxFv7ZcYA0MhxnQVnAY1+rVWxrrDrPE3N0TxGGXugdn1GJxuJdc/NNILBWKOf+FOKxijv7hC8ePj7rhGuTix12JSHVhVMkVpZEdnX/ivZ7SLYB3IBZQNb0BZgfmGAtj1Z8Y+vDmeW9Eq1QSUxDpjl9iUytOejfHvGkC1iPCNWyIsf9PwiheXBtrxJmTLm/PEIfng1JHYu8PzikNB9PMz+KkG11YXJ4QrMUXnscMyuY1QF7GKsG2guxEFxxdxW0Pt39FTxnZpFVngDf4t7z0fTuWt0xD6KWJd8JoHOP6PTdyiqLZrkLK7WhZY7Md7Uoiee33zCwotGc8cuDwCGlx+oi/J34nfkDvGyyBoCVCOmjcz7s/ULMbMk5rGp8aCPRFxiYixYdm4KqcjD+zCka5/QBvjDMgMq+RuR16mCfF+nPd2ah/cIthzNvdm0XChLqL9mo/YtwmOa4yWVB0D5HDQtfwFbxnNWKkaNQwWP15A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(316002)(9686003)(6916009)(122000001)(66556008)(66446008)(64756008)(38070700005)(53546011)(8676002)(71200400001)(38100700002)(6506007)(66476007)(33656002)(83380400001)(2906002)(86362001)(66946007)(4326008)(8936002)(5660300002)(26005)(508600001)(7696005)(186003)(52536014)(55016003)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WkuweyMYu8Kg5uFwe69ZzEA+Qr1b2BgOWsiPsyqMoLmOLtYLicBmkAODtjD7?=
 =?us-ascii?Q?zLHk7Z307ifcEpYzqT4KJh4ELElvdTxAYHW9fNIQb31tRqKiQgRkW2al2cSp?=
 =?us-ascii?Q?RBo6cD65nKjZ/PA+yz8orwZFGa+DEKFQiAtT3LDlMQen+ZUcGXE05Kkk2m2u?=
 =?us-ascii?Q?jQasXu3sGG39hH5pkMbHVSrO3nShhtJnUbLxbS3rsk5muqH11IGeT+h8DbIJ?=
 =?us-ascii?Q?SM3D14L4NBr1OqV81IaseJlWQHyEeyhyBlAEya7lrr6LR5fufcYBZJIy8TtR?=
 =?us-ascii?Q?BkN4NgFgbTvS+ii1+JaQQXURebN7+r8+pDhLzBCzqqnl6KknkjYasY3EsI5F?=
 =?us-ascii?Q?Kf3lslLJxykjz3eoXtG1EIHHKo/lVYIEQnNoGLwYGHUk3e7y6Yr2DEj1ZJjB?=
 =?us-ascii?Q?STDJgpTpScabndbPUZAsdWf09A/qRdq4waBvQu61cpkGMbNKtsVxrFWHhsqp?=
 =?us-ascii?Q?+2YugcBbb7tYex50zAKOBTdQB5rklRNydv/NooKRAGG8Bi3KQ6mnO2mGYRts?=
 =?us-ascii?Q?I1vAEB6PtxYTMqdIUhQ4KzIBBSBMOYR/BGH6MalI+ybQsAhn/QkI+lo0g8tp?=
 =?us-ascii?Q?ectKxx9hAMLesP14iZN3jBNLWb8FSq+bD0bwmrPYIm8nO4jSZGPJMLjmmHoo?=
 =?us-ascii?Q?cUBcyPetsobt6G+ASCK67GrWQqNo2SOsoT3H2gb77TyYLSH27kMVsQro+9qw?=
 =?us-ascii?Q?y2+ceKy5cl2+mnCcZhJ0zUpUmxxfM0sHkc2I44sBn0zA/Aw2MONZqCsUEW53?=
 =?us-ascii?Q?yWcN7VfS6ju5MzAA5qZ83FAbitTXIO5ZCrqIFhJ1MCxjWVH25vGCZkEaHoyC?=
 =?us-ascii?Q?Ut7EyNzLsbKRVxrptWiKnmxb3k05CcU5sh5SxgNiieDOw0V7ZN16qe1RrOVn?=
 =?us-ascii?Q?2Jm7a95EayGuz5yysp6sbOcbeiK1bqWxxmTETFhe0J9YxNEC3fFpZqdm6sGz?=
 =?us-ascii?Q?yLNFJK9d2MSMzgio/QOahDfSZ2gm5iVSQmhY3fe2TBhuVFSV/m2d/fnb8+no?=
 =?us-ascii?Q?dAYopFT4elf1VZS2nUf3kYgaw/0XQCfqp4dC5yekhLaXk4iMz6a9a5BGL1kC?=
 =?us-ascii?Q?k0LVfUIKYNDno9yvf6I+0lqKogKFbTdql6CTtibNC+Cnae4Mk0qudqe0XSS7?=
 =?us-ascii?Q?p9vK5WrWtsmkKYuIYKSZE3NUuimh/cR9mQccxZYmFkCt2a7C1q48rbhojS+y?=
 =?us-ascii?Q?IjP2vCyJ/OdupPAeNhxy+nAXTXxK6PDXwbs9TgguOs1U8MdOIuuTqIG+aM5S?=
 =?us-ascii?Q?inxPv2dRJiGETa2YsSRA15ROlSlpGFnOmKInqCoxfLK1GQNDSZ5NIFfDTazj?=
 =?us-ascii?Q?bAlv4vZME7uJiMqF9li82fJVJc1FQAZoOvooEqtwlYqIZwOYYACLwcZ6XevQ?=
 =?us-ascii?Q?Y8IOWPCLrgbLA7ictwNuxKNI2hIh3miqcIMKoot3DM+gvTuxgmQIudOW3BwC?=
 =?us-ascii?Q?+vQ9t7Q7l1Sfka8BI20qO1ma3K2r4kikmifkvVLMPZba0rpyytnnkkzwcTbN?=
 =?us-ascii?Q?srNWcM/du4P4OQJsHzkVbjGl63MjcPvxZSLL3uI1CB155M+0tLOqiAQUQpj5?=
 =?us-ascii?Q?c7ptS/W8zE/5o6bAonMotffauFPGyd1YkpHc/LhB0HzhvWa6Mb8noYqFdyoS?=
 =?us-ascii?Q?l4TW2A5zhr1qD7o9XS+kfhU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 887825d7-c004-4eae-8c5a-08d9d4ccbd4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2022 06:36:46.3403
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K3S38qy46bIS2kfPXhyFu2epdgYRxiEa4uKBx7n/F1sTQZXtWMHyggOUutsou4/fpN3M8PWj67A5fQkxg5rhjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3033
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: Monday, January 10, 2022 1:01 PM
> To: Kechen Lu <kechenl@nvidia.com>
> Cc: kvm@vger.kernel.org; pbonzini@redhat.com; wanpengli@tencent.com;
> vkuznets@redhat.com; mst@redhat.com; Somdutta Roy
> <somduttar@nvidia.com>; linux-kernel@vger.kernel.org
> Subject: Re: [RFC PATCH v2 3/3] KVM: x86: add vCPU ioctl for HLT exits
> disable capability
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> On Mon, Jan 10, 2022, Sean Christopherson wrote:
> > Does your use case require toggling intercepts?  Or is the configuratio=
n
> static?
> > If it's static, then the easiest thing would be to follow the per-VM
> > behavior so that there are no suprises.  If toggling is required, then
> > I think the best thing would be to add a prep patch to add an override
> > flag to the per-VM ioctl, and then share code between the per-VM and
> > per-vCPU paths for modifying the flags (attached as patch 0003).
>=20
> ...
>=20
> > If toggling is not required, then I still think it makes sense to add
> > a macro to handle propagating the capability args to the arch flags.
>=20
> Almost forgot.  Can you please add a selftests to verify whatever per-VM =
and
> per-vCPU behavior we end implementing?  Thanks!

Sure, will add selftests for per-VM and per-vCPU disable exits cap.

Thanks,
Kechen
