Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F06657BE11
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 20:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbiGTStL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 14:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiGTSi7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 14:38:59 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2079.outbound.protection.outlook.com [40.107.102.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102577391D;
        Wed, 20 Jul 2022 11:38:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aLEKU9OMxZUlZfpaEHBCKnkJzFlMRPGERPGoIHc8hMoQD9dQMsIiUUzCw5sCei+1+V6Hf47D6yX+qUZd3HeNXwtGLINZBHzE8F95SLObTUJn02o/4G9J1RQYj6S2Gr5ns+HV8AwgJzTap8NoBPmwD0UgqT+DPloAED3W9MrRkpwIbtupUffeP5DCwThLttr8B6Jie4OagKcwNFWRKqSKs9tPm5dutgwa+WuEQ8hpYQBga7aIUseXdECi8k/QtoEtzUSMsP+RWJgsjqpej7/9ukm8VOywPdoHH1FEKOgkzt95688AzHLkMMefEs/E9vKH8cfZdgzRdBlVGrglLvg9WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wq+T35A5U2OJWEAhIlCZp0xVArV18RIBgkQksENlbaA=;
 b=ffpVGZv03fZTqZCrbG74g2/g/yOLWLmmMg4MP84NNd15SRgyXszLrOwnb/ipBkNjKzs4wHB+B3skkDaUTUJn3/Chq2nBuS0PopRbs/ecEAJyuzSj3Fx+COREp88en2h6nmYZAFIiaWIB4GX6g87Dj47OGgDGVkIhY18VVGxKYlLlXQX8VYAGCkSPAo7BeMg2OBnV6770NA1FhtVzQ3kTqv6ddTcI7TRHz6k5ZjnnGwCL8HW04jDQOiO8l1MWlm6REkRtG9s/qEvl4LPQ3bcB6DcbTALIkQ+4lnVktDC1bHPHB7ZhTit2LNmFrgAdBFsQG7+kxCJcZ4fi0YsMRHmIUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wq+T35A5U2OJWEAhIlCZp0xVArV18RIBgkQksENlbaA=;
 b=qP00+7GRxthoQBfQj0kow8l0YfYHYfPB9RS5K9M57hYQGi4oFYaE4khuYiwFEYkp4ku8oKhCUIU59Zu4MdWvaUyzCeaD3bV9eR2q8547t2DNUrYmfDSnS1ffRUFh5bf/Cun3sO1lK0g/sKFY2fjBKOVjzXRcOzXx+UujGKKrs0QCsoa7blOXyKTOGp0rmtqdRREhi98493Do6T6Lj8kZ83lBCkVKFdiBe7NoOt5mUuUK/WfOwyT9RK00m1t2iLf2gbrLfKzSz+12/joc8UNidrZeftkKKCXFaCPlg5hHukLK5bol3YRkH/imeY/a4FwFl2jQfol4h5bNYuIaif2a8Q==
Received: from DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16)
 by MN2PR12MB4566.namprd12.prod.outlook.com (2603:10b6:208:26a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Wed, 20 Jul
 2022 18:38:46 +0000
Received: from DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::9479:3bdd:517e:1d54]) by DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::9479:3bdd:517e:1d54%5]) with mapi id 15.20.5438.023; Wed, 20 Jul 2022
 18:38:46 +0000
From:   Kechen Lu <kechenl@nvidia.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        Somdutta Roy <somduttar@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH v3 1/7] KVM: x86: only allow exits disable before
 vCPUs created
Thread-Topic: [RFC PATCH v3 1/7] KVM: x86: only allow exits disable before
 vCPUs created
Thread-Index: AQHYgFWpO+aVuW3IJk6V/XCp8vu9Y62HtzMAgAAKSYCAAA2QUA==
Date:   Wed, 20 Jul 2022 18:38:46 +0000
Message-ID: <DM6PR12MB3500110A9D2AEA90E93EC6FCCA8E9@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <20220615011622.136646-1-kechenl@nvidia.com>
 <20220615011622.136646-2-kechenl@nvidia.com> <Ytg3kHHdft8IqIP+@google.com>
 <YthAMfGD3nHtrOg9@google.com>
In-Reply-To: <YthAMfGD3nHtrOg9@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3259d03-1c3b-4211-3367-08da6a7f149e
x-ms-traffictypediagnostic: MN2PR12MB4566:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OzNcWgWySsjURD7WzlvZRmrLC9i6Funv2U31aA/QIWOekzHUXvnDiVWrta3es+r2918XWHov2DSaMhNBRF6JXRhmKbjdN+6d0EA5+ATvejBjyZ0kzE6AyAENfF6yTHZSz/vCM4bIzADWparxPJc37YWqSm6E+nRydxj8CfRbG+TfB5z5w0lz9UiYvzu03IEuYxo1cksuhGZ4CI2jO/lPZUabUB+FpXxw21HagRjozS+jrNYKxxDRVOvQSnK2Yu8OSRCfDDE/9aARYrJeuLN7LCTDp6NmTn68fLnX5kb/6kcLWbaiMR44PCRfmyzZYRFN6WHACO1qToUgHqpfY41LyrrnaSjFUNVEZaiAW6vApuKgn3Q+Lkmv22EKXXKrVtCJuRHWvvaA+0GlDu+dckGv+np1hZzbic3ixBB1YFgBlK2ZEvTLcNHMbiZdi74sJ7sULdgrGDmuZFkFCuoEdx4EBCvBPvGdoOap1pz/FnuVQjr7xduk94t+748VwgX6gkjIGs95ExGUoL4QgtMS3Lx28U0KkM1ag2FRQa3KjpZOI0Z2I+4wH4kn/dxd8pcEVBchy26bTou75QuOkZxLe92i8QrB7mYO8FkTqTmFhzjesIzfUYpHhxhC021djZUTLKhB72OtA4L9GAISGNRhILyFmnAjIhdG/LOMOD3l2xC2mJlYXhOeaRWiT7i0mSRbR5Q2Sl0CF5jzhFEbrIAog9x+0Eb7uUPs7E+WX1Ri19Ea+xHrVKYHPjzOA6fWDXer/Puag11Ui5mbCVnXgpmw93ZYjxp3A7jOQgGSwiuNbI3KSr8+kO2lhNUfwBIVATT2zDnY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(186003)(122000001)(83380400001)(66946007)(55016003)(38100700002)(38070700005)(76116006)(8936002)(478600001)(64756008)(9686003)(71200400001)(8676002)(316002)(4326008)(53546011)(6916009)(86362001)(2906002)(66556008)(54906003)(26005)(66476007)(7696005)(33656002)(5660300002)(66446008)(52536014)(6506007)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fzqQRRSudmkONxKZM+1kb8WasoHSMem1GY2OCWFf2l9+qR3xgUw1dkFpuWke?=
 =?us-ascii?Q?YPsrsheOHdgJjoYEt3Uq/Ef6Ptx5jqEfpgrDShnz9ZJPhrVJjKjI5P9VyWnY?=
 =?us-ascii?Q?Hz5V3b+f2gx+l5zIU2GqjHONdgUyMhsdTOlPRP76mqzyphQmEG4eGrsZaRR3?=
 =?us-ascii?Q?TEfYZwGLAU570R8jnszdD8K3UNSO2fiaOkxNVmc00reEu2gefi/5r2gfBc8e?=
 =?us-ascii?Q?HVgAAJhGHAyG3AYtHXCgBJaccDh5Scg5VLyuhTnq9u7kGGp8adjNy0rZ6fBl?=
 =?us-ascii?Q?WR+jydKdO+A9P3jIFSSRl/0nFpqPDHf72fzj+0QQqM38TnwlHnZAwYG6i74R?=
 =?us-ascii?Q?Q04KtWtLYOc65E9RwshX14uKGUgRkMulISFDaXXiyKxWoONVayTxIcV97GbT?=
 =?us-ascii?Q?qF82VuKn8g0B7gxbgUAFszMnkxv6rhiS4yOKmm+vabViO7Rw1jfRME5e3v6O?=
 =?us-ascii?Q?bHOpHreWpAP3eSiu4wd/Q3hFcO+DMwyB5JWh6XB47hegaxJKb/mRKj6xwz4g?=
 =?us-ascii?Q?boH8coU9cKkbTw+ekkMehXZHE61y53beBXOaXHpOfhjDHTi4XtROs7bYDJVd?=
 =?us-ascii?Q?zCcAO+BTrmJXSNGLLQgUwk13oAJrn6rPX6tNc0y2tTIWAb41g18g5OwT3Cq3?=
 =?us-ascii?Q?q20xOB+/DsPBuXM5AZPyRakvqUwkcwxzCh+0xSm6+urdjDbFyj98lr0Kwr9Q?=
 =?us-ascii?Q?5kzN8ZCu13gHrJ8SXd9/xA8iapntqDp5XxPPLPhazK/VmvhjoOGpmjmUviQL?=
 =?us-ascii?Q?7prgkPvKCqPphUMRFW4Rb/3Q2HuALOqcKoCPmsPyaPYtkovt1Zx62wKMIPiK?=
 =?us-ascii?Q?rPutsi5Qml5ZrKuz31Rh6pQSIyQi/pgZOmeJ94GPLnzWvn4tY8ph6RDO9Wie?=
 =?us-ascii?Q?SQeOToYGWyht9MGjXLqvkS+ONgkiz/1XsFV1wP6Wq57YqEZB8zgJ7FgWleK5?=
 =?us-ascii?Q?FDb7b7D5ut1UoqOADvKnLXOk57zzuNUt5XeLGWRKdoWO1vqsyW8uQnXuoAqP?=
 =?us-ascii?Q?RSAF/Yq7XSz04OoJo0LU2nMUKXA83vHKbP+W1U44CwwyLorB+UD5r1edUw2i?=
 =?us-ascii?Q?eVAn1ZSzP1Mm1CNl47E8SgBMIIoh2ujDNdflCu4p9BbBnIelYyduMnBpN1Cb?=
 =?us-ascii?Q?NSCjlfoai4YO1UvTs3n4MfHzCMTW3xrNeQEYPcuwc3Na59x/Od3vTXivBD4V?=
 =?us-ascii?Q?4fyYNWOmL7+783dtT8VRipiPsk0WV9BU7oYq7Z3acEHzbsScIopOpe36E8ss?=
 =?us-ascii?Q?PhUCBUuLSPnG+437Vj7rlz0sfAYVeXg18U4X+hIMOcJby7egtbGIl+xLUlPr?=
 =?us-ascii?Q?Y/GTE23VhGWjw3cRaMgKrcJqMTLswecamNYdqPQnexw2EERzq31PoKFaP4/S?=
 =?us-ascii?Q?lwljetR3MYFPUfyHMARWZ27Bc8Y7if4JE8Or4hw/LPQVIv5uvOd6mBP7svRP?=
 =?us-ascii?Q?HK2lU41xVtff9u9VsrmUywPKbhbjJihQ6SVLKO2hx4MtNaxCS6/JANTqZgiW?=
 =?us-ascii?Q?PSP8XZaZf9ZNCRwdRrftmZIznLd/SDcKE7Fblay5BJMLPm284GOgQxSrnmU2?=
 =?us-ascii?Q?hUTrCap73IL1drrUOzO/2Ug7xLRIA7LfYmWZVu9V?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3259d03-1c3b-4211-3367-08da6a7f149e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2022 18:38:46.5493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9iDJevM4wlEzcyICNSNlcaxjaFuWWxIIXqVx+DmSxscrfKqFBJGxJ7yEglePw8Nmcq/VY2n4EF0iFNKJO9nS7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4566
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
> Sent: Wednesday, July 20, 2022 10:50 AM
> To: Kechen Lu <kechenl@nvidia.com>
> Cc: kvm@vger.kernel.org; pbonzini@redhat.com; vkuznets@redhat.com;
> Somdutta Roy <somduttar@nvidia.com>; linux-kernel@vger.kernel.org
> Subject: Re: [RFC PATCH v3 1/7] KVM: x86: only allow exits disable before
> vCPUs created
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> On Wed, Jul 20, 2022, Sean Christopherson wrote:
> > On Tue, Jun 14, 2022, Kechen Lu wrote:
> > > From: Sean Christopherson <seanjc@google.com>
> > >
> > > Since VMX and SVM both would never update the control bits if exits
> > > are disable after vCPUs are created, only allow setting exits
> > > disable flag before vCPU creation.
> > >
> > > Fixes: 4d5422cea3b6 ("KVM: X86: Provide a capability to disable
> > > MWAIT
> > > intercepts")
> >
> > Don't wrap the Fixes: line (ignore any complaints from checkpatch).
>=20
> Sorry, I didn't see that you had sent v4 already and replied to some v3
> patches.
> This one still holds true for v4 (very minor nit though).

Sure:)
