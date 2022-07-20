Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1EE57BE47
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 21:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbiGTTLW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 15:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiGTTLV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 15:11:21 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2042.outbound.protection.outlook.com [40.107.100.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DE1564C3;
        Wed, 20 Jul 2022 12:11:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IvG2pdbVk+UbbZ5hrnjbsJiwp90Ti5tTr5jbOekgY+23Ay07jgVy68iMIhWGZCuCH90OJapuv6fkmj9ubsq7CnnWoUk13HG8TKQvNHK42GXDSN9lzC/SLvewXG6AjTH8xVcbS3vvVMSHlVt651HvXegquipK1pCDShkDQrS8hjAt0sd2xPYnqLeGq56oSKzC2XJOjjy/EKl7ozjjDxo3+PqggaHi2Y0Ebak2xYBKDhKcn2RT0iK/WXORcGMk7JjseQUukdjqIKealApPHHXQSqp0HNOzHS1ASrOdHHC2Q+CHaJ5PNSSGXiwMjpiVLjDwj6TUl1yVrE8BJdtL7lVROg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WAQ6JhO42N+13rhRl/sH13Opvq6T0JYweZ9Mx9iOI+M=;
 b=ifidYm0ynEDn0+s4NcWWsRSOeTJE09EMScbQCMG8JSGJasNEbCmPhjfpXqGeknNCnkTNgzbUGKEh1sQXKRoOGqjVIgiMCmkhPDnhMf/BidtL2PF6MYMP7bbK5UOAzK5FTNKYk+5SslIsIj0X/r7sgBFKkhuO0Do2UMHqLSVQLDxFoch2KGbOESsUsasb9ncBoOLh7q/sbAtmQIh7zw/x51hh3Ep+5PhnZysbUp5GLJs1GzyRrJ8Rhbzg8HBq0HkGMxJAlnYVe1jRSLcnyI/FlTdFAyieMprLzztM9SN3Kyrq/KVpFdEmwbaSrES5ZzN52qgB0AlYUatCvsUDbbeniw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WAQ6JhO42N+13rhRl/sH13Opvq6T0JYweZ9Mx9iOI+M=;
 b=c8mOjlaZSPIrV40VLmLEQnShm4isonprpPN15dcD5SGzh4xUjv8MiwDsHDWOkFWxXY+Af1V49uCAlaoaip2zfTQWioorRsGiA4LrTU3cjAvHVG5jmrPC7vzqYNMb81gDR8FC8vaL6PlnL28bH+7WvY/6djizerlxnPyrviqsX5fikjyYtZTS2Dpr7IA8CoZNifEqddlqrGeJkR8/xtdM/HERAlCdScBdSM93kVhGJxFoh5n6HYYhZ3Hf5XHQdXKf1uwk7mk6X7mvdKXAhBkKsjHqB65fiaL80/fCUTJuonhcx9shTtYya43u8hT5wrlT/L++ROQ+3/dFze3iXUcUHw==
Received: from DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16)
 by CY4PR12MB1382.namprd12.prod.outlook.com (2603:10b6:903:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Wed, 20 Jul
 2022 19:11:19 +0000
Received: from DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::9479:3bdd:517e:1d54]) by DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::9479:3bdd:517e:1d54%5]) with mapi id 15.20.5438.023; Wed, 20 Jul 2022
 19:11:19 +0000
From:   Kechen Lu <kechenl@nvidia.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "chao.gao@intel.com" <chao.gao@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        Somdutta Roy <somduttar@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH v4 6/7] KVM: x86: Add a new guest_debug flag forcing
 exit to userspace
Thread-Topic: [RFC PATCH v4 6/7] KVM: x86: Add a new guest_debug flag forcing
 exit to userspace
Thread-Index: AQHYhdK5aqHflcCxi0GPdL5WahEIoa2HqluAgAAhbxA=
Date:   Wed, 20 Jul 2022 19:11:18 +0000
Message-ID: <DM6PR12MB35006C181165FE3C09E6DCAACA8E9@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <20220622004924.155191-1-kechenl@nvidia.com>
 <20220622004924.155191-7-kechenl@nvidia.com> <Ytg1/zdSPYQ2lYS/@google.com>
In-Reply-To: <Ytg1/zdSPYQ2lYS/@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0559dafe-7d06-4834-bcf0-08da6a83a063
x-ms-traffictypediagnostic: CY4PR12MB1382:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p8QGnx713GSgY986KxRH9k201onpb/32tO0+dwQB+6Xyq6ySp5bYMZq/sidJESl41RZt9sBSpiCNvYKouMHw2bnWkFXzrXprbDqHdQuWszNBs5zmj61k7MYd28A5jJe1VK+mcnAAObeyN6YuDbJSXYafGTOQxUy2t0WhgFliJ5EZEnzzn1McfRiqXcljX4E11ss3XsatTK2w60HkC0whaJ/0cL+H7d6kgnm/mmSqY/r04AGu9TWKn9O5UJAGU8nk+CCxY8sb2M9KKYu5/rqCu7Qj5lvjoe59MmbfHWzK6fObldmCFpACOxxQmmeWgu3wt10d8U0jWmwgacQr6whozUIYodzzOkVTTqwcclGcgNDHrm82oUH9YZzrr/caoaoviBBOeiR9vBW1T7sAEZmLcBWzbKi3zPR1jqKSUL58wyqpu+fdW4GRhqyXbcLKB6hAVNOXTrGDAs72Yd0g9PlYpwWt4CdwSYM0GKHhlmucSGfA/85T4JsWA7OY90UrsVNrnvUH/oasyyq1OyeFpe9qumBMufo7+FdxauawFkKdTGpBgdEjVhGB7+CLoYwrYapxW78oM1SX0VYavP8p6mbZHdZ/tmh2lGHczyPPaItqLz4+00a352F+C4o/7/1wiTl3b7x5FGDDYYsS1TQDAFGKwjabAvVsIxFhm0qvHq7mp/1diQYrQde7i6cUoOwVkw19DGAQEV4Bc3Nv9Gi7XV6tYyCTWtl58m2as7Xd6vkXy+PxJzVV/pChpApa36lwJDVpWdzz63UyhiFISdf6eyzhITfORtmfOLIfkdHme75sbQJKyOjtVS8QzwHP+s60R6S9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(71200400001)(38070700005)(41300700001)(86362001)(7696005)(478600001)(6506007)(53546011)(9686003)(26005)(316002)(6916009)(54906003)(186003)(83380400001)(66446008)(122000001)(8676002)(66556008)(66476007)(4326008)(5660300002)(2906002)(66946007)(38100700002)(55016003)(52536014)(64756008)(33656002)(8936002)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Wmu+n4ApAmax5SrfHA5yBx5P9XwPtaew082Hk+ILzWyvt7L8WrikJHbQdaLW?=
 =?us-ascii?Q?6lyMtrsgIVPnNoq682rgfC/658ydex0Aq5VP6ArfyaHLcOijYystsaKcgMad?=
 =?us-ascii?Q?tFi2z8fIyQKPIfItaK9slRDcBecqv6V1Ufzu2xztLYj2+p7bVRCJwY/7dFjI?=
 =?us-ascii?Q?sYQfeiRrnrn8n+CoJlahcgs5Xf0eqNFeqjNK61LTqu86y4e0l15uR5fBqee8?=
 =?us-ascii?Q?bfllA5g4/t4kzLLO9NAGBwdzivpggFKsEEEEzYVFtGzwmA4kGmgwqUQJ+k34?=
 =?us-ascii?Q?ZxhmwFbVqZiurWgEzgJ/mn83k3ua+GxKfVhKtvNKPnPpPUIJZ5KKA3ln/xY2?=
 =?us-ascii?Q?hM4TtXEk15nVT22kdi0/MEHgYNJQw4IVI6lpm9FvVrQdwRj52EKmfdrsKox4?=
 =?us-ascii?Q?LBpefhoEqPx4SzMuavtu6irVAivsoQmvPVO9v59KsgD8HOrARk7IGmQie6rG?=
 =?us-ascii?Q?a7UMgV99lixGnWv0srl40j77g+gMnqJv28BL57fgyysDTyMkXL0BZ9WjFJ6g?=
 =?us-ascii?Q?JRyvcZ3VUmbD495EEOF3AHNAGZc7AmkiJjx3KO7zZkw/QojI/VOMqcoWWBFW?=
 =?us-ascii?Q?t2MnXgVaDjVMk/qp2MOS5pZprpEjIKnBNpV4u3GC+Mg9uKmeygi4UiAS/I9F?=
 =?us-ascii?Q?AwaOoFk6ywit9GTOI2/TipHc5ONqPWk0n8FLcZA8n9i6LVhbE2LBCQoKNY1f?=
 =?us-ascii?Q?7d2iZN8MCZyv93J5AxE+oVvPO+7nmBMZLrxCXRGYBva1tETaCoYUd4YiX2PX?=
 =?us-ascii?Q?Tj0KiTSRd/FdD5jRyBaKDaAmTt9EtxsB6Ovr+BzWMr9lJdKQb6ZibythJ8/p?=
 =?us-ascii?Q?/vkBxKBC2jsnkVARb5Vrk8QpaxwymKrotSUR3domRC4njCgJwqTZE2GTcS2/?=
 =?us-ascii?Q?bDHllnlYVPze3iLmhx5iiLqnflYTFHYi/X4Hx0tdSR/50sBDnXHML4BDL2a2?=
 =?us-ascii?Q?d5RcpHY92nOq96ICPz+15JfyKfbPjWicjIQWYFUH+DOW0ws6UxXX8tJUJXXO?=
 =?us-ascii?Q?UjTDrMgDjKNt6PVs1qDr+3Q/uG3ch2+iCqYZLXodD4GoH1nn1hS/R067bYOz?=
 =?us-ascii?Q?Pjy0Z54SiTlcfbIJdLpcc2Nk4zfzZ7tCPWwQpLDsoZbteSjGu9U5qeRaTUaC?=
 =?us-ascii?Q?9HwR2Q/ihCfA14sQ0BsUUVVcD4LPvkYneLeyfhX3FZluvlVu0rfUOfC3JmEO?=
 =?us-ascii?Q?b30FZkjwWenkMPWKs/vsEixpPIECxZHs0h6OP+WftFCI2RQ4UtccSyIwq7Yp?=
 =?us-ascii?Q?Ote2Ub6GLAIUY4sThLNmtyZrLymLSEVHj5XXvOIYv4iuIU3kZaD9QnQSlsuk?=
 =?us-ascii?Q?fVi5AcThJU7ebBbpwfA2n3XgHMq+8Phy/VuoGRwTqmjBODPdKDS+AK8g3EnY?=
 =?us-ascii?Q?enM+6TWLQs606DbIkHQ3nEe6gNNIqrw22OcHdM+FzSTlGlAyLpGLs8X3pGiQ?=
 =?us-ascii?Q?jXjY3AszzSgoRFdudX7axE3yKBBIKxPhmq5ZZP8soRHM6vHTKTQKB8HsUHWm?=
 =?us-ascii?Q?7Qqh9Hdc8dI6qWgF6h87b8wnrqN17WsY7u1lI5zqUlb53e+euzd5UzU4wvTS?=
 =?us-ascii?Q?Ww6CEXZJ0oYCPVKfU3DvEulrndOoeShlAc+aVAP5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0559dafe-7d06-4834-bcf0-08da6a83a063
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2022 19:11:19.0341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DHF0iVbN09W4K2A8gdJTfoZT+myHB2bxHx0MHJ8wySISbr26N0ZgMOOGZoH+U/G/O8G94gZpezYL7GQRwMjXBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1382
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: Wednesday, July 20, 2022 10:06 AM
> To: Kechen Lu <kechenl@nvidia.com>
> Cc: kvm@vger.kernel.org; pbonzini@redhat.com; chao.gao@intel.com;
> vkuznets@redhat.com; Somdutta Roy <somduttar@nvidia.com>; linux-
> kernel@vger.kernel.org
> Subject: Re: [RFC PATCH v4 6/7] KVM: x86: Add a new guest_debug flag
> forcing exit to userspace
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> On Tue, Jun 21, 2022, Kechen Lu wrote:
> > For debug and test purposes, there are needs to explicitly make
> > instruction triggered exits could be trapped to userspace. Simply add
> > a new flag for guest_debug interface could achieve this.
> >
> > This patch also fills the userspace accessible field
> > vcpu->run->hw.hardware_exit_reason for userspace to determine the
> > original triggered VM-exits.
>=20
> This patch belongs in a different series, AFAICT there are no dependencie=
s
> between this and allowing per-vCPU disabling of exits.  Allowing userspac=
e to
> exit on "every" instruction exit is going to be much more controversial,
> largely because it will be difficult for KVM to provide a consistent, rob=
ust ABI.
> E.g. should KVM exit to userspace if an intercepted instruction is
> encountered by the emualtor?
>=20
> TL;DR: drop this patch from the next version.

Ack. This patch I introduced as prerequisite for the patch 7 of implementin=
g the selftests for KVM_CAP_X86_DISABLE_EXITS. But yeah, it's not a good pr=
actice, I will try to think about a better way to implement the disabled ex=
its testing.

BR,
Kechen
