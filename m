Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA145FC7FA
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 17:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiJLPJc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 11:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiJLPJa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 11:09:30 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2060.outbound.protection.outlook.com [40.107.95.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B7FAE201;
        Wed, 12 Oct 2022 08:09:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g2KTZU2ekbDP7Z+dkt6TH3GZvBUTl4+enBGb3fIq29/FAFFUOPE1jHlP+Ur89IsKaealYyffPssQBqXPPBhsgLeLrgY1JzGp6E7RQt0CPUXWeiN+KzTZj9tzzuD9IsvD75+uJVsI/T8dAipf2GRh2juSovStgOc0JIczfkT18EYRIekwXWVm1vcYCs88X+pUw8HMsZCeCGa9If7Y9gp4XS2UJNXS+TjPSYRxdw8SG0XLwDMyZvKUkDiCUOuAFdYNiK06e1Vepwc3NpBg1IZWvXJ7mTnrH33yXaj4O438GkChL9zbH19/tEm5VaaNGqRH7KivZqxLE7b9ODjwxcl9EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LjxRwfrgFaIV8pRSRAvFC30xNGkYSyK21v8mLWUrfHc=;
 b=K0yNOdpDHyS+C/inzqRu3PAkRqV+TleZyRz3GuTuXH/FpSOhWaerjZKI13FUMKTJaOUt83Y+1MjWpbUG8pnZZWufZ0KCq8h+9w2OFB+0/GE75t1dbYQUKdjSECXDnSryQ9lJ+s+sNkMWSQj14S2+3WPcW83EQmG/Poyuo530iowlB0jr6jV0VTld+j+M08tJr2Shcc+BfwvSw2VLoAU8vrjISWq9kc+AM3mF75fdmTo24UDYSEH8oKJTqROcCy9rqk/BavpL1bBcklplbGxKRw/xFUG1FX5TE23h9xnTsjE24U5Te8qefZAQEhoLaQiDfEpWHQ1cnkrM0MEPC549yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LjxRwfrgFaIV8pRSRAvFC30xNGkYSyK21v8mLWUrfHc=;
 b=CKYmg59Bgt0I/jhvPYTF10/aegvzMSKnNxSPWydiZJXWL4RSH1k8SpzoN9zb7T/pbUMfpDcuArkBZpBBy+FCHFIbLqyegyPNZSYr82zb5gyLWOWcZUTm9KCfa6XNQ3FVq6RvogvpNNYNNxOl35P5PrqaIyam8ZL/Yo0O2fuJZvg=
Received: from MN2PR12MB4358.namprd12.prod.outlook.com (2603:10b6:208:24f::12)
 by MN2PR12MB4503.namprd12.prod.outlook.com (2603:10b6:208:264::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Wed, 12 Oct
 2022 15:09:26 +0000
Received: from MN2PR12MB4358.namprd12.prod.outlook.com
 ([fe80::a094:c6b2:d306:d7bf]) by MN2PR12MB4358.namprd12.prod.outlook.com
 ([fe80::a094:c6b2:d306:d7bf%3]) with mapi id 15.20.5709.022; Wed, 12 Oct 2022
 15:09:26 +0000
From:   "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     "Gupta, Nipun" <Nipun.Gupta@amd.com>,
        Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
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
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
 domain as parent
Thread-Topic: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
 domain as parent
Thread-Index: AQHYwfdzMPgE56itm0GRwc9i4G18eq3T9LKAgDbLT4CAAAON8IAALkeAgAACWFCAABh6gIAABiXQ
Date:   Wed, 12 Oct 2022 15:09:26 +0000
Message-ID: <MN2PR12MB4358277977C1B7E0BC214AC789229@MN2PR12MB4358.namprd12.prod.outlook.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220906134801.4079497-1-nipun.gupta@amd.com>
 <20220906134801.4079497-5-nipun.gupta@amd.com> <87h71juxuk.wl-maz@kernel.org>
 <DM6PR12MB30820EE430405FF50C7F856BE8229@DM6PR12MB3082.namprd12.prod.outlook.com>
 <MN2PR12MB43586084670E14691920952889229@MN2PR12MB4358.namprd12.prod.outlook.com>
 <Y0a65a9leWXpKfTo@ziepe.ca>
 <MN2PR12MB4358A871519748CD7A6DB7A089229@MN2PR12MB4358.namprd12.prod.outlook.com>
 <Y0bRZTP9Kc6mdCiu@ziepe.ca>
In-Reply-To: <Y0bRZTP9Kc6mdCiu@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-10-12T15:09:25Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=5530b5b4-e2ab-48c5-9c06-cae6fe127b4b;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR12MB4358:EE_|MN2PR12MB4503:EE_
x-ms-office365-filtering-correlation-id: 88a06061-9060-4d51-4735-08daac63c0f3
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /J30APAAFYFR6fm0qqZXgZZuEIz+B4Em2AEHr2Pmzhz1tUjkIX7E75rD73V3CODUcYdC0Q5LD15mA4bfFB+okBFC1J2KDS+EfvWzn7tGBA37/nmA4pPtVlfv1Kn9KgzvnfoOE85QTRi1+MDKr0hjAimjeZzp9C71UDEj1EslDUjPN2EBjoh9w03gh2e1qsC173Xztr3EoVFcp7jHCFrsVvYvP5gL6/6J63r4cTJC+hDE74sWhv6yEhfY8POLf4l5EYcI6vKGM/0WY9GtMyXX94YdUss9+jw+vpxS8NrJ0WiGib5t3ZkWwXAckN52//iD+fUauTjz70J2NVduE5i5ykrghpvIsaDosK2Av0AyJmqBKRIds2HuVwkx0/moJLlq0XvW6XAvO4ZZ9kR5Y6V3lG+ZbqLN5io1JhRtPr4rbPbGsWHQ/uUEMTeSfKhh5iLoIApgQPMBe8iqK3bOLLfeDNYKEs1M8/8VcT+NG/buwWqLksZP1+T9oyoe0/ewr8QJ6ORoq9pE9KWgwea+rS8umeGszu4nfWiG+CWpasm1NseFWyYboKrbb7bXR3S3Scgqj4Jt8vp5Mq13vHkId7/nIjeUYxIG3zRDgyO27lrCptD1Gy8l5vjG+vK24qZzqZ5etgh+yo6TpKrVtsUHvFFkFgJfehp4DACAMc28ANYX9BVqr0mnXq7Ncs9AUCmlNwGzpMw1YzG3fsUECfyMdPfflIehh/MWvDtIUxp9Wnhv0FLBTXCnccLPvepP+dxsw4EZBqWvt+fZWlVk2n6Zzg09OA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4358.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(451199015)(7416002)(33656002)(38070700005)(38100700002)(122000001)(6916009)(55016003)(316002)(54906003)(8676002)(71200400001)(76116006)(64756008)(8936002)(66476007)(66446008)(2906002)(5660300002)(66946007)(41300700001)(66556008)(4326008)(83380400001)(7696005)(478600001)(186003)(53546011)(6506007)(52536014)(86362001)(26005)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LnyMoXC+C6Xi860AttuKRV42vjSdZQvEdtQ42tP8MS+L44WcJAoZtzCHD5Te?=
 =?us-ascii?Q?XIVGvjwRQ9bOL2MdD86ucGrZ3PviICBGzuhxx0y3cMb03hkx9WbPAErcYDoE?=
 =?us-ascii?Q?8BX35pyDIWwkIbf2ZVhjnAKxSp149izjpDN/IX/BnUkarByQwy0NDlrLvtzI?=
 =?us-ascii?Q?Fi6UOWKg/nCwiF6DbsBUUIQ+5+78BETAYZtRHBw4m+o4EiUntasqSh3XXXjN?=
 =?us-ascii?Q?URIuVmjLbrAl6WiH8eL89IK1t0ZeSirFOc8qLJDFzLgIuAnow+jzQEjXD2Ey?=
 =?us-ascii?Q?mapQqW664k0SdmI+LQry5m8TXeLrSuPKmJAwNwqfES/eB8TKe9mfvRRlGK/m?=
 =?us-ascii?Q?hgvC+l7dUzIRsQfKE1jQJoKxhKFqoOl+1WucUrLqYOzCGXLF47ezupQ80K1Q?=
 =?us-ascii?Q?1sbA4gzulVJawUOnuyzt1GWqNfSuzvWXYgbP+mUse5DS8QtV/5lfi4HQD/Nk?=
 =?us-ascii?Q?SjF2JjcumQAxxqwFGQztmaZo4HFyhTG07PCYQ0sSUNe1GxHoNIeY1BfIfGeT?=
 =?us-ascii?Q?W5CFSa/81JpOHtPan1/zZ2YnE2zIo/Pg53RRR0MvC+HwZBBg/flhJiMekma/?=
 =?us-ascii?Q?B3tManU/nFbxUdvSw9jNcvNqV5y866zT8shAo8ISOAI8LuY6qh+qCj09upWx?=
 =?us-ascii?Q?jcSIYYJjHbGLXXTxK6uyrPtNZSF44AtGeX+WKSXyacxP1+A0u0QH2WncwPLM?=
 =?us-ascii?Q?x9L1ALF4tdh5Jtx+RL8/0WlvDljscsboj8ChcpAHsS7mqfwFhJImuju5UICn?=
 =?us-ascii?Q?QXLPHJkdmEgaqts0rngvOpDPjB+OcrboYhfo+h/mZ7JdQoG7ioYZnTx3zflO?=
 =?us-ascii?Q?5nr7kWUtAV2ObAz1IftgBgHlczjQIgllDiIcpskpdtyPZBVExwoDTeRvmcws?=
 =?us-ascii?Q?Uk+xOT8o8giK8Kqd+pLmYb9Z/UP/pg8kq9k1YAuIReXSDgNuhydz/jbHeGQ8?=
 =?us-ascii?Q?w/YlHtd8px6xlMIxMHvYdsWzX3Fr9GYqOmEH0VkI4w3ds+W7niBXGj64vQbg?=
 =?us-ascii?Q?r/g4Ypl3cdrEh+E4N34mQCl1LmIVIH92HwQq7ad6BkwcQnm5Iz6gBD6/Yo9Y?=
 =?us-ascii?Q?4G+iH9elEA/WDVFPr3xK1s2S20vOlamPwpVM+aMy0kI0u3gE4TRU8/lJZBT1?=
 =?us-ascii?Q?LJnEN7tIl6HIQ3OIIkSsZUbQc2xFuSstA6BsOFs/2E2U3lYeeI1cu4Izc6UY?=
 =?us-ascii?Q?OWavsBhkIcqB3VmQebJx+1JyiND/xQwHyzceht4OXlc7dwgq60WSiZLllonP?=
 =?us-ascii?Q?fsa2ABDvYWynWxB5Z64JdxngSfLd3YzOiIsHn0+xtQI0PUP4NO3TsfmIo3xW?=
 =?us-ascii?Q?vjP67GTqRf5zvbc++10EYFZWvYMsHDPCqHyIdNBIPoKmXVSzFKYvU+AC8Gjd?=
 =?us-ascii?Q?XgO3DXCizKSqkLyQhQhvFnanos5UL/pTRSsq4y+JDFjaHse16i412nYg7Hzo?=
 =?us-ascii?Q?1VJ0w/h31Jdr7fFhElKLkYoKZ3UTPd1XXygndvEZiKEdSLbFBfIQUW6OTYGZ?=
 =?us-ascii?Q?6CxCIvbRW3JTVgkMkbazDmuEAMruKMuY3qu1OvPlXBHAMxtTBpU03z5XXwRJ?=
 =?us-ascii?Q?Dac18QSetTLTy5Ti5Q8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4358.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88a06061-9060-4d51-4735-08daac63c0f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2022 15:09:26.4474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2GoQILclajSjZ1lkVNQmP6/taRzjUY4IGG7T7aAo78eHW28cWDj1JOorLpLh2HWWspo5xMWi2yCIIrYL8CzB6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4503
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]



> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: 12 October 2022 15:38
> To: Radovanovic, Aleksandar <aleksandar.radovanovic@amd.com>
> Cc: Gupta, Nipun <Nipun.Gupta@amd.com>; Marc Zyngier
> <maz@kernel.org>; Robin Murphy <robin.murphy@arm.com>;
> robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org;
> gregkh@linuxfoundation.org; rafael@kernel.org; eric.auger@redhat.com;
> alex.williamson@redhat.com; cohuck@redhat.com; Gupta, Puneet (DCG-
> ENG) <puneet.gupta@amd.com>; song.bao.hua@hisilicon.com;
> mchehab+huawei@kernel.org; f.fainelli@gmail.com;
> jeffrey.l.hugo@gmail.com; saravanak@google.com;
> Michael.Srba@seznam.cz; mani@kernel.org; yishaih@nvidia.com;
> will@kernel.org; joro@8bytes.org; masahiroy@kernel.org;
> ndesaulniers@google.com; linux-arm-kernel@lists.infradead.org; linux-
> kbuild@vger.kernel.org; linux-kernel@vger.kernel.org;
> devicetree@vger.kernel.org; kvm@vger.kernel.org; okaya@kernel.org;
> Anand, Harpreet <harpreet.anand@amd.com>; Agarwal, Nikhil
> <nikhil.agarwal@amd.com>; Simek, Michal <michal.simek@amd.com>; git
> (AMD-Xilinx) <git@amd.com>
> Subject: Re: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
> domain as parent
>=20
> Caution: This message originated from an External Source. Use proper
> caution when opening attachments, clicking links, or responding.
>=20
>=20
> On Wed, Oct 12, 2022 at 01:37:54PM +0000, Radovanovic, Aleksandar wrote:
> > > On Wed, Oct 12, 2022 at 10:34:23AM +0000, Radovanovic, Aleksandar
> wrote:
> > >
> > >
> > > > As for GITS_TRANSLATER, we can take up to 4 different IOVAs, which
> > > > limits us to 4 CDX devices (should be sufficient for current HW
> > > > use-cases). Also, it means that the address part must be the same
> > > > for all vectors within a single CDX device. I'm assuming this is
> > > > OK as it is going to be a single interrupt and IOMMU domain anyway.
> > >
> > > This is not at all how MSI is supposed to work.
> >
> > In the general case, no, they're not.
>=20
> I don't mean that you can hack this to work - I mean that in MSI the
> addr/data is supposed to come from the end point itself, not from some ki=
nd
> of shared structure. This is important because the actual act of generati=
ng
> the write has to be coherent with the DMA the device is doing, as the MSI
> write must push any DMA data to visibility to meet the "producer /
> consumer" model.
>=20

I'm not sure I follow your argument, the limitation here is that the MSI
address value is shared between vectors of the same device (requester id
or endpoint, whichever way you prefer to call it), not between devices.=20
This in no way implies that it is unordered with respect to device DMA -=20
it is ordered and takes the same AXI path into the CPU cluster, so the
producer/consumer semantics are preserved.

Thanks,
Aleksandar
