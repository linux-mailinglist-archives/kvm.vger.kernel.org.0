Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD0515B2F0F
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 08:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbiIIGdC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 02:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbiIIGc7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 02:32:59 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2051.outbound.protection.outlook.com [40.107.101.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A325612FBA3;
        Thu,  8 Sep 2022 23:32:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PJLuKmyA+8xHTWdPbVforSAJLxAUJTRgnBwzUQVzb9q4sK+WJKKjaL4JBytln/8oc6qt3A9hjLhZ5jmhUsBu4F6X8ZQvxyHQAuNPE5GPwQovEoyGWMFBBFImv+tYYPkg2MMJKPgi7QsYl/qck5ux70J3dnYjjKg9M8kOTDJB7FkK1CFyu6HsC1d1DXuvsBbJ510K06leJydj7U572IM0AlnCtt3nSc9WSlQXgjtDQSrD9zOMvs/0WLxaBzJdDCAXyXa+jsYYFYGpqpXGY6ZeC73GELtCu8D5/BU48vAzfzMyMCBYsrEiSjHZUo0MIh8NIcjb1+T6vv69IVpzuooPjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QSRQKWmzEX8KUN0inT0jtl6hfMmA7GEiRMsBBu3qpOc=;
 b=izcZWcPm+sYZv3yH+sqJ7shkFOuQU1cSNMRTw9me8aMc7RTxWU88SnJL8YOp5TpR9T89D0KqaHxDgdVUPS5QBnWb+8060c9+PoZKNpBqDIs+AFXqHyc3ZPwTMJH/bjVVS/kwHwSjTWSav5ndgEa7rS1jlK2bTI9TQYD5eYp0Kn5dlYg6DwNfkEdXK90imEqEJzn1b9rjuEi+nuIKugyvD12Ke8HUluiNy6Ys6jUVapeD5hg1DsTvW2KNCTav6H3SCUBPZ/70vAVyNfMEQN/C0o0jZDpO+Wdpvx4s54AlnLV/N7eNzuRsc/z8W1jQTbEkrontmDqqSuGddAXnagHyrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSRQKWmzEX8KUN0inT0jtl6hfMmA7GEiRMsBBu3qpOc=;
 b=s6VRxgw4RBBDeL5S5x7k/8damgyubWEuRk1Ck/Y9kxjGb7z5ULeu529O/dhSn0wwKQC1+Oe5gOKdUaqIQDEithsMU6ytuNxshQZn6s6+VmNFCexRtzz1rp+1PLJm+ylTgwPKlq+4w/c+1bsgaeNsVfcLlrQh8N90Zz3+E3hzykk=
Received: from DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12)
 by CH0PR12MB5265.namprd12.prod.outlook.com (2603:10b6:610:d0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Fri, 9 Sep
 2022 06:32:39 +0000
Received: from DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4c82:abe6:13a6:ac74]) by DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4c82:abe6:13a6:ac74%3]) with mapi id 15.20.5612.019; Fri, 9 Sep 2022
 06:32:39 +0000
From:   "Gupta, Nipun" <Nipun.Gupta@amd.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Gupta, Puneet (DCG-ENG)" <puneet.gupta@amd.com>,
        "song.bao.hua@hisilicon.com" <song.bao.hua@hisilicon.com>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, "jgg@nvidia.com" <jgg@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
 domain as parent
Thread-Topic: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
 domain as parent
Thread-Index: AQHYwfd0JTWjzcxYd0KhDb1ncGWS4a3T9LKAgAFC20CAAGNkAIAA5oJA
Date:   Fri, 9 Sep 2022 06:32:39 +0000
Message-ID: <DM6PR12MB3082C642F8948236AE42E07DE8439@DM6PR12MB3082.namprd12.prod.outlook.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
        <20220906134801.4079497-1-nipun.gupta@amd.com>
        <20220906134801.4079497-5-nipun.gupta@amd.com>  <87h71juxuk.wl-maz@kernel.org>
        <DM6PR12MB30821367EC37FDE33DC47A25E8409@DM6PR12MB3082.namprd12.prod.outlook.com>
 <87a67aueg7.wl-maz@kernel.org>
In-Reply-To: <87a67aueg7.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-09-09T06:32:36Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=5ceb8ef2-e88b-4a36-b3aa-702033e716cc;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3082:EE_|CH0PR12MB5265:EE_
x-ms-office365-filtering-correlation-id: 2f8b207a-50cb-4792-930b-08da922d1781
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JB0Ps8ajz5tqpC2paoFXlej0p1JmJjSI+D3cB9c4OfbrVxSu8VouUI76jqSYJUqsz3eTSFWIS0wQiuYETmH9U4GSdXjwltrHu2qPWcAlbkzWLCeP8SGy0TIwjiLKzr6RdwAgIg5GUjXiYLp1/iX+OtR8GimYQAQSDcJbkyVlCkwWH4kVZzS5uSeHLkUAWoRToKDKSLNr5Zg2AxC/HpsqevahytWwrd8EJjd8nuSu139dk1yyMw9MCpG2R3tZesFEAObeat0F92C7RlxC4I7B3UTJa/4dM6M0yBDPxXfMmhX3HpIFyWgacQUYUI2c1M0qA1Q3koEWeDn0CAIJnhX4rF7FbWQoSEenzZPHTsOiw2utYnFDEXbCZdLsMAeSg+eB4zjvKXLXWtgKUpLHKDenOVetVohQOnflDr5YxAvCnEjsFr6YECNY1+Jj1iJQ06CA2tXtr/25HJWvds0/BacE146NrEmbj3M9GVHAtweuT5Viy8FbK6HPcTJq4g4TNhlOeLdl1g/1HcTmwOm5aG63/yHyuL4prSSo84mvBbcH/tOaLiPTpJDlM3CIK/NvS6GOLOrvJFbvDcGLDFiaEShkucP4hq+KFbil+Ap+2Z6fQ5XSKYUfS53KtS8WkH1TYsZCGAmP99n5Nq4DgkctuZ7gLkJMXJEOOGf5SmndwQ1/2bgI525XxVQA+RKfWV9FvvxUgT+mzu1m7c38uMgkfzY67mH3dRtQVb1YiBw0mV6PUYWv87EulZ8ML2PyH9ZoY2XNMxGQblABxZXc4rSc0msbcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3082.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(8676002)(4326008)(86362001)(7406005)(41300700001)(52536014)(8936002)(7416002)(5660300002)(26005)(53546011)(9686003)(7696005)(2906002)(6506007)(478600001)(54906003)(6916009)(316002)(71200400001)(38100700002)(186003)(83380400001)(55016003)(122000001)(38070700005)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ue4CsNqLkAjjQfNtkQT2ccBZAX+W0Scgxil/IesuEcJTCg2Jir0Eh/kv2NTQ?=
 =?us-ascii?Q?jOQp1YSNM82Q2/IQRtaGFL8H6bEqMeuL6hrqWd1YVTSUto4St6hdjalx0HO3?=
 =?us-ascii?Q?vfKR/oWWSyMZkXe2YUP+nkWQpTjgEtDMKgL8DhzUVQEUuefZKcp7pE1E/ZTw?=
 =?us-ascii?Q?AYJng9W4ZBVe3FPM9uQd/jdJrCZBmCWh1hZjVvLWNa08rybEuRh7E/QY/lTU?=
 =?us-ascii?Q?vRT/6MV2YFX3njbFEwzkfbLoXuey4/DHbEJBiM8VVuSZkX0GQIkGm2ob4+e4?=
 =?us-ascii?Q?lpmzNykfFBA+pXgXBszfVBHvxIXPz3u1X0kJv96bY3Hy0AaLIclqxqt6aom2?=
 =?us-ascii?Q?WkDlyJU0vYeo/S0hxnVwkvwcc7pZ9hjknXaiwEkNV9T9jlCWUehfJ/kwfzi6?=
 =?us-ascii?Q?I+crG6gZ94XmhsduQ372PglvdqEt6IWSF/nweLI4zasXBedOZzTOMlEGV58l?=
 =?us-ascii?Q?EQWTGDeZqJHfD9DhAzjTcRHgIbYBJc37ATwLeHDrEcaydO13OuBpBd33Ziie?=
 =?us-ascii?Q?g4NGTyLU39RHE+lyvd4QHhP8/5JQ73B1ljsNSFKYvu68RuhIQDiJFLZziUVn?=
 =?us-ascii?Q?tKUn3fqviAua2YyICjkhwrsOxtrltmrqEDg3DZ3tVVLaddOry5Ol+Dnm73JM?=
 =?us-ascii?Q?+HYqV8gxF4VOrsq/FbQh7yOoG2uUL1hzjcSf66VmD13lNHCv9lFF6LX8ZM5R?=
 =?us-ascii?Q?yWpTNzZ7IP3LxUWrm0XHUSFx5xLjzn9e+zUJS8X6wfTjkEJslp4e3HgcGVh3?=
 =?us-ascii?Q?W7MUBKDXP9G7lnhsPuu+3tuntlmmJtntzPjyk6/s8hWU/rYV5np8f5nAdXum?=
 =?us-ascii?Q?hpp4LDYwuDk0cZT/Dm0sEOlxRZDh055dgeDOX1cVgp2d9zlJfgi2A6ibznKK?=
 =?us-ascii?Q?BtWxnYRab4iSwWSuPCxC4n1vZzhpdFr53PiapwiYAbjApR99WNZsfLPOyDn3?=
 =?us-ascii?Q?yuJ7xgdcFxreDjAbn9H7V3H2HqI/OJil3wv1mg/a3iIsJuHqCEiEhpZmB8gG?=
 =?us-ascii?Q?7qP87LYQXDrHWIcjZsYTAaKSTb+OWsjjBNUSDlY8o3DZ9JFuHlHXd2Ax+gt9?=
 =?us-ascii?Q?9UeHFim119jE1UlB15J6qak62foNvZY03tXSuhog3xGb0kAy3RZfLEIqBtl0?=
 =?us-ascii?Q?n9SsjOZrc9EAOU8dr5L1Bu0gsNZfWj37tJM6A+TPobVI2JdCSN1vR8M1ulDg?=
 =?us-ascii?Q?JWeXRJZi9eCiaEqxfy8wKl4NnUf9Dqiim58va1Y3kGFZL6UlePBVmgLcBCZn?=
 =?us-ascii?Q?BOmiKKHcyqjdng5fzuWj27+zTBkdUGoPVI32lQC8Cvz2/UTcHASRXDsk43QY?=
 =?us-ascii?Q?Sy9Zz3tMHUqwWnKyLE+KryzL4XnkgCoHDwIWC+iGHjTQ4OqFvF9eeowWnSUl?=
 =?us-ascii?Q?R9uXuOwa5XGbjwxiwi4jKt50E8GTL+iV9c2EtOrizrLpIHTVPsjmzsJRZXZI?=
 =?us-ascii?Q?GX2sZOziNOFhMribAOYqdgqNfd+J911LqDCaixySlzyJial3X1TQ1oLeIo0w?=
 =?us-ascii?Q?IlcghXrWIcyxNHSWKP3o6EprkUvzhE7I75x526wejr5rQRlbfqMq3zBB0dya?=
 =?us-ascii?Q?34zhSgrN9g1CuZ5XdLE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3082.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f8b207a-50cb-4792-930b-08da922d1781
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2022 06:32:39.1585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 74hsKhiHTqZaIBHNgHe2MkCByXIlSZWnvs9Cmg1Atb4YwW5wU6Pw9GVkW1XITtpq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5265
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]



> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Thursday, September 8, 2022 8:00 PM
> To: Gupta, Nipun <Nipun.Gupta@amd.com>
> Cc: robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org;
> gregkh@linuxfoundation.org; rafael@kernel.org; eric.auger@redhat.com;
> alex.williamson@redhat.com; cohuck@redhat.com; Gupta, Puneet (DCG-ENG)
> <puneet.gupta@amd.com>; song.bao.hua@hisilicon.com;
> mchehab+huawei@kernel.org; f.fainelli@gmail.com; jeffrey.l.hugo@gmail.com=
;
> saravanak@google.com; Michael.Srba@seznam.cz; mani@kernel.org;
> yishaih@nvidia.com; jgg@ziepe.ca; jgg@nvidia.com; robin.murphy@arm.com;
> will@kernel.org; joro@8bytes.org; masahiroy@kernel.org;
> ndesaulniers@google.com; linux-arm-kernel@lists.infradead.org; linux-
> kbuild@vger.kernel.org; linux-kernel@vger.kernel.org;
> devicetree@vger.kernel.org; kvm@vger.kernel.org; okaya@kernel.org; Anand,
> Harpreet <harpreet.anand@amd.com>; Agarwal, Nikhil
> <nikhil.agarwal@amd.com>; Simek, Michal <michal.simek@amd.com>;
> Radovanovic, Aleksandar <aleksandar.radovanovic@amd.com>; git (AMD-Xilinx=
)
> <git@amd.com>
> Subject: Re: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
> domain as parent
>=20
> [CAUTION: External Email]
>=20
> On Thu, 08 Sep 2022 15:13:31 +0100,
> "Gupta, Nipun" <Nipun.Gupta@amd.com> wrote:
> >
> >
> > > > +             return;
> > > > +
> > > > +     msi_domain_free_irqs(msi_domain, dev);
> > > > +}
> > > > +EXPORT_SYMBOL(cdx_msi_domain_free_irqs);
> > >
> > > This feels like a very pointless helper, and again a copy/paste from
> > > the FSL code. I'd rather you change msi_domain_free_irqs() to only
> > > take a device and use the implicit MSI domain.
> >
> > I agree with other comments except this one.
> >
> > In current implementation we have an API "cdx_msi_domain_alloc_irqs()",
> > so having "cdx_msi_domain_free_irqs()" seems legitimate, as the caller
> > would allocate and free MSI's using a similar APIs (cdx_msi_domain*).
>=20
> Why would that be a problem? Using generic functions when they apply
> should be the default, and "specialised" helpers are only here as a
> reminder that our MSI API still needs serious improvement.

We can remove the wrapper API, rather have a #define to provide same name
convention for alloc and free IRQ APIs for CDX drivers. But both ways if we=
 use
#define or direct use of msi_domain_free_irqs() API, we need
msi_domain_free_irqs() symbol exported I hope having export symbol to this
API would not be a problem.

>=20
> > Changing msi_domain_free_irqs() to use implicit msi domain in case
> > msi_domain is not provided by the caller seems appropriate, Ill change =
the
> > same for "msi_domain_alloc_irqs()" too.
>=20
> What I'm asking is that there is no explicit msi_domain anymore. We
> always use the one referenced by the device. And if that can be done
> on the allocation path too, great.

I think it can be removed from both the APIs. Also, API's
msi_domain_alloc_irqs_descs_locked() and msi_domain_free_irqs_descs_locked(=
)
can have similar change.

>=20
> > <..>
> >
> > > > diff --git a/drivers/bus/cdx/mcdi_stubs.c b/drivers/bus/cdx/mcdi_st=
ubs.c
> > > > index cc9d30fa02f8..2c8db1f5a057 100644
> > > > --- a/drivers/bus/cdx/mcdi_stubs.c
> > > > +++ b/drivers/bus/cdx/mcdi_stubs.c
> > > > @@ -45,6 +45,7 @@ int cdx_mcdi_get_func_config(struct cdx_mcdi_t
> > > *cdx_mcdi,
> > > >       dev_params->res_count =3D 2;
> > > >
> > > >       dev_params->req_id =3D 0x250;
> > > > +     dev_params->num_msi =3D 4;
> > >
> > > Why the hardcoded 4? Is that part of the firmware emulation stuff?
> >
> > Yes, this is currently part of emulation, and would change with proper
> > emulation support.
>=20
> What "proper emulation support"? I expect no emulation at all, but
> instead a well defined probing method.

I meant proper firmware interfacing support for probing.

>=20
>         M.
>=20
> --
> Without deviation from the norm, progress is not possible.
