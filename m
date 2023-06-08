Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724D67282BE
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 16:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236047AbjFHOcT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 10:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233268AbjFHOcR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 10:32:17 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2057.outbound.protection.outlook.com [40.107.102.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDB1198B
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 07:32:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZyznT3quhNvvgGjhfIWnHiIp+1iZV20hSYj9+uvJKGy1ipEl3GZs5Y7Q8Eehhtp6CEiqKFsqitcwZd92UIbCk7JbHiE9RDQhz50+WYOF/46GLsE3CSCx60zydI/Zb/SamNBCHXum0+LoZ/f//15rEzodDBZbE7ohlWi+UUZmJkdyS1GLHAkyABVKU/ytgE5fnd9IEGNf0dRdc6SSL1n0lC6yqZTJfycDkOkeokv+9CclTWUu4V06mb7XR4trylJyb8Rws/bH+nGHVQ3I2ljm0DvILWmN1svOKe33A+si+cQQBjIHLIe16XrccLoaJTcFClt5eXBEKGRSB5AGS7d2GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w5L6SCOEOoXIKzGv7S+ysdrN3+jn1VYShpHAfwENHs4=;
 b=IENZRul96QhuwvfLzAAOBTkc4zvcEUKwMiRyGR18nfxlvlaU7wIyMEo46yvoao8DLR9X7VINWRC2ZLnY2AzFA7e18MU3MGzwrfmkLxseg8mfLGOBQSzgxNfnzDPfDHE83Vq5SiL4emsu3T/p3URvDfuookPm01bFvdvJ8aTXpfGfuf5bDQLAyGAtg5M1C+LdVPA/5lyl96FHyGeGUZ8vPekSR3iqGrpPWHgDAKOFY9mbgN9m2ICy2oX5Y8uxoFtsmu7uZtq2timJQzWc4iPRbGDwWWjXvAPDE2PCmAxpXc1e7MzTSEsrtv0MYJ3WMhgRUwtDpmUCYToQIifQ0sHPlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w5L6SCOEOoXIKzGv7S+ysdrN3+jn1VYShpHAfwENHs4=;
 b=wq9yaPTL+K60PGmBhVO3SpGtQ40wjPdzbK/PbHuGnryqbzV4RFb4XCmJlUN++tnLsYuNriTngRwwhKtf4Cjk7qdVywGxefHfHk6zbR8o9xejk8+WuN5fy4HuG8DI8U1kZWESbsksoMKydphO1cJy0ruZwlCNN34Ob6XiNGSofvk=
Received: from SN6PR12MB2702.namprd12.prod.outlook.com (2603:10b6:805:6c::16)
 by DS0PR12MB8563.namprd12.prod.outlook.com (2603:10b6:8:165::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 14:32:09 +0000
Received: from SN6PR12MB2702.namprd12.prod.outlook.com
 ([fe80::da02:b3a3:7f5:22e1]) by SN6PR12MB2702.namprd12.prod.outlook.com
 ([fe80::da02:b3a3:7f5:22e1%4]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 14:32:09 +0000
From:   "Kaplan, David" <David.Kaplan@amd.com>
To:     Lukas Wunner <lukas@wunner.de>,
        "Kardashevskiy, Alexey" <Alexey.Kardashevskiy@amd.com>
CC:     Dan Williams <dan.j.williams@intel.com>,
        "Giani, Dhaval" <Dhaval.Giani@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Kardashevskiy, Alexey" <Alexey.Kardashevskiy@amd.com>,
        "steffen.eiden@ibm.com" <steffen.eiden@ibm.com>,
        "yilun.xu@intel.com" <yilun.xu@intel.com>,
        Suzuki K P <suzuki.kp@gmail.com>,
        "Powell, Jeremy" <Jeremy.Powell@amd.com>,
        "atishp04@gmail.com" <atishp04@gmail.com>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
        Sean Christopherson <seanjc@google.com>
Subject: RE: RE: KVM Forum BoF on I/O + secure virtualization
Thread-Topic: RE: KVM Forum BoF on I/O + secure virtualization
Thread-Index: AQHZcpVL2ZVB/KzJW0K/FsVF0lT/0q94FEGAgAVH5oCAAutWAIAApeoAgABVs7A=
Date:   Thu, 8 Jun 2023 14:32:09 +0000
Message-ID: <SN6PR12MB27020315DA2843E089F0EA199450A@SN6PR12MB2702.namprd12.prod.outlook.com>
References: <c2db1a80-722b-c807-76b5-b8672cb0db09@redhat.com>
 <MW4PR12MB7213E05A15C3F45CA6F9E93B8D4EA@MW4PR12MB7213.namprd12.prod.outlook.com>
 <647e9d4be14dd_142af8294b2@dwillia2-xfh.jf.intel.com.notmuch>
 <d1269899-7e74-f33c-97bf-be0c708d2465@amd.com>
 <20230608091202.GA962@wunner.de>
In-Reply-To: <20230608091202.GA962@wunner.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=84eac5ad-81b4-4934-9cf8-1617db76e2c0;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=0;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2023-06-08T14:18:45Z;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR12MB2702:EE_|DS0PR12MB8563:EE_
x-ms-office365-filtering-correlation-id: 9ce9ee50-857e-484d-721f-08db682d2470
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yER1I2G9tTZEzBM+fznW3GexfVDEFeZnB+uy8wM/4fIZ5FPxLABeLSUu3425Z0kMgz4g4+vHqHXrgasUe9GH0rn+LcgeRIk2klpmJMt5IhWoSHFKMLZu0GAw3H774YxcuRJr0U3+xT8vCOTTYkxf4vTdupxgliBIzqTepVTUpWE894ReVnFJNMdfWrN5kgvgsNmKOnj2zZ/5IoXO7MiqIVOES0cPlSyQLzNIrk5RbUiiNIE7x0o/W598M4JRvX1LB2Jx8vzE5mPWXoDKvUD4e3CojU7sWatwMTVxSunCPDlZ2Gpy+Kj1cHbRJ8m4ihVNPuVMbbUgHDc5dBFoijBrAZRZPtbAlcrdIgFTz4lsVAKxDP02bQlR0tX2SQyKlTRNjKwEp/ZOQSFIbJ+IcZ2/mIOat2yZkdDjrgdLSMfSEYLYeUim5jzBeuqdj1fInKWVtOqKpjC1xYLzXQGC0Hzo8YUdyBbyrU9JIGCm8I1GpVFJliD25TyrvnbKeKOUc9Qjn/HWqdrzeTdsuZ0PXaHDBWdKdxYrNN1ZU20ThTtHY21WgJ+KSXFdnSDfrKDGH7q9QUSYzoIUxQVDty7Oz3xQ3d16oSOyi+XeFr3n4Xye/Og/x3kMFbeCz50d9yEwnHNZVfotM/Osm+i0WY2VJmjrHw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2702.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(136003)(39860400002)(376002)(396003)(451199021)(38070700005)(8676002)(8936002)(54906003)(966005)(478600001)(55016003)(41300700001)(316002)(5660300002)(52536014)(7696005)(110136005)(26005)(186003)(7416002)(4326008)(76116006)(66476007)(66446008)(66556008)(66946007)(64756008)(71200400001)(66899021)(9686003)(53546011)(6506007)(6636002)(83380400001)(2906002)(38100700002)(122000001)(33656002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yQSJUBVQR5iMvU95TB6KSIpWi7V5LqGdc66lyPNQEYNy76GZuhWIVYrs1j/L?=
 =?us-ascii?Q?Y6d24dItxEHoMX1K9N343WI2G3PYDfkoISupbT/WLkVbQtYmUKfxBQX0Sxwq?=
 =?us-ascii?Q?9AQb3okN+qw+eivA7N5sLgvzmDAKJ0TJlwmqol8g3kGRPIDZsoK2iRnPeMqa?=
 =?us-ascii?Q?4fE2CVlgy0V636VpgxRR0BOsk5dXnzoX/m9DMQ06Cj/iCx5J0kWDvFr/Rnwq?=
 =?us-ascii?Q?Rs43nsT/nkfggkH0eYdYe2nsi4xnb2taxE43U2ktKltWrWLsENX2prkWKjIz?=
 =?us-ascii?Q?DphIZSvSdGAMiwITc5Zf+yEQDxAV1viNesyUD2EqtZeUhNooZwJnq0v5RJ4e?=
 =?us-ascii?Q?6WVQYqWVo+eZnlkHkjt+hkvci9vz/aPrzog4gx/WIdjkHUtAGhjRgzFE9HvS?=
 =?us-ascii?Q?6L/q3dtaSjYCXPIglYhyBgavGMQjzti5wNujklBg5YgMGwr/MzzEufIvn4b4?=
 =?us-ascii?Q?+Wld4UCuvL938/dKGi5tAJZiSBRRhK7nv728HzxqnVDgwNYECtndugO/ePMh?=
 =?us-ascii?Q?GzzTyLXQCaR22VN/sAk6UO+p+Pu9/+ikbn+NvPQUBNlShUfdV8Y4lIf1Wjgg?=
 =?us-ascii?Q?zq0mb6p4zcZTCG3dAC2feKqnj7h9t8BhRBL8RMsePtz+GOnRmPw5JY+x37SK?=
 =?us-ascii?Q?VXzPQvQ7mRa7xXsg/hf/LIAgtTMurcTKTkuBLaaoImd2TiVHnWPGQLgyuLHt?=
 =?us-ascii?Q?GuMETjxxbaTfveZRePioS59CMJmwM5fUwAnQZF6LHrANi7oIs+/ESfkgXc/W?=
 =?us-ascii?Q?tIEdNrCLRPp4u7i0Mt1Uv9ZZ4XbCdWziT0x+yeyWm9G8unqH9K5yJXtVJAtc?=
 =?us-ascii?Q?1/kkTiJRTAVO4ARI7eAHnHJbFY0llI1g7fZifv4pvzHFnLwNMd/EbkqB315D?=
 =?us-ascii?Q?Nzs82lmYNn4GJFS3Rxw+WaplpgZAmxzP0EnhMYUtrjoJz6h9s8qGg9/XRbjd?=
 =?us-ascii?Q?84ggEQB+Ois9e4L0Od6sq1LYOeFFnq9i7/aqCSZk1vUIR8A7fnVownk8U0xN?=
 =?us-ascii?Q?gREGPOry0HBUQWlJpIcYSjmA2GwetnSPe2BLqYimefzNrzTZOgI/P4Wx8ce4?=
 =?us-ascii?Q?VJzv4MwlqkYOzqIL/MMt0B8aB0GhBrHPLhiyKC20u6XFrRGPf9FkO3XZ8aTk?=
 =?us-ascii?Q?UjwO5RLR+wacmIRCoyeMzcwR1RaMiGblN6Q7OPtM1dwEEPfEk+ZMRh03g9Wi?=
 =?us-ascii?Q?dL6lOIE6QhNLj56nk3N5TEWTKOllCd68vCrPvZAR/bDgtIG9Idk3WF3aH+Qe?=
 =?us-ascii?Q?hqaQz3YluJZu7hummm+vGqRpW31Rz7fTioa53b4oLsJYRoByLAfkLYq1LLoo?=
 =?us-ascii?Q?VF/TKB5ZIiHqJosjV7TaSxepV/Br5TIMANKZ4jLIFhFdiralFH1Er40V595n?=
 =?us-ascii?Q?tZo5fC2jvmCNf0bSvJRpJ/Sct0MGpUFrdwF29EYS3sZat2SwvRhrqIkcNt3F?=
 =?us-ascii?Q?HmqXs0HfHsalz5/ANKFXGam9gEx6zkGVaaiqQJ5MCOpA5zIwxMAlf3TJVXxC?=
 =?us-ascii?Q?XFSptyjeQ6krNMi4DqmxaT7fxRAvUN521M3a8O0D5cv3GuOuIgKx6K+x4b8c?=
 =?us-ascii?Q?1Sc9TCtDXg8yaqIWtZY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2702.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ce9ee50-857e-484d-721f-08db682d2470
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2023 14:32:09.7165
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QJWRB3wl+Hh9EvRjEkAoCLWZd/7+0puVjBu7e9AjhCZQXi/0rQVh+8LB3gCZkDgS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8563
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]

> -----Original Message-----
> From: Lukas Wunner <lukas@wunner.de>
> Sent: Thursday, June 8, 2023 4:12 AM
> To: Kardashevskiy, Alexey <Alexey.Kardashevskiy@amd.com>
> Cc: Dan Williams <dan.j.williams@intel.com>; Giani, Dhaval
> <Dhaval.Giani@amd.com>; Paolo Bonzini <pbonzini@redhat.com>;
> Kardashevskiy, Alexey <Alexey.Kardashevskiy@amd.com>; Kaplan, David
> <David.Kaplan@amd.com>; steffen.eiden@ibm.com; yilun.xu@intel.com;
> Suzuki K P <suzuki.kp@gmail.com>; Powell, Jeremy
> <Jeremy.Powell@amd.com>; atishp04@gmail.com; linux-
> coco@lists.linux.dev; kvm@vger.kernel.org; Jonathan Cameron
> <Jonathan.Cameron@Huawei.com>; Sean Christopherson
> <seanjc@google.com>
> Subject: Re: RE: KVM Forum BoF on I/O + secure virtualization
>
> Caution: This message originated from an External Source. Use proper
> caution when opening attachments, clicking links, or responding.
>
>
> [cc +=3D Jonathan, Sean]
>
> On Thu, Jun 08, 2023 at 09:18:12AM +1000, Alexey Kardashevskiy wrote:
> > On 6/6/23 12:43, Dan Williams wrote:
> > > Giani, Dhaval wrote:
> > > > We have proposed a trusted I/O BoF session at KVM forum this year.
> > > > I wanted to kick off the discussion to maximize the 25 mins we have=
.
> > > >
> > > > By trusted I/O, I mean using TDISP to have "trusted"
> > > > communications with a device using something like AMD SEV-TIO [1]
> > > > or Intel's TDX connect [2].
> > > >
> > > > Some topics we would like to discuss are o What is the device
> > > > model like?
> > > > o Do we enlighten the PCI subsystem?
> > > > o Do we enlighten device drivers?
> > >
> > > One observation in relation to these first questions is something
> > > that has been brewing since SPDM and IDE were discussed at Plumbers
> 2022.
> > >
> > > https://lpc.events/event/16/contributions/1304/
> > >
> > > Namely, that there is value in the base specs on the way to the full
> > > vendor TSM implementations. I.e. that if the Linux kernel can aspire
> > > to the role of a TSM it becomes easier to incrementally add proxying
> > > to a platform TSM later. In the meantime, platforms and endpoints
> > > that support CMA / SPDM and PCIe/CXL IDE but not full "trusted I/O"
> > > still gain incremental benefit.
> >
> > TSM on the AMD hardware is a PSP firmware and it is going to implement
> > all of SPDM/IDE and the only proxying the host kernel will do is PCI DO=
E.
>
> Sean has voiced a scathing critique of this model where a firmware does a=
ll
> the attestation and hence needs to be trusted:
>
> https://lore.kernel.org/all/Y+aP8rHr6H3LIf%2Fc@google.com/
> https://lore.kernel.org/all/ZEfrjtgGgm1lpadq@google.com/
>
> I think we need to entertain the idea that Linux does the attestation and
> encryption setup itself.  Reliance on a "trusted" hardware module should =
be
> optional.

In the SEV-TIO model, the AMD FW implements TDISP/SPDM/IDE but it does *not=
* do the verification of the attestation information.  That is, it gathers =
the attestation info from the device but it is the guest software which mak=
es the decision on whether that information is "good" or not.  Until the gu=
est accepts the attestation, the device remains outside of the TCB of the g=
uest.  How exactly software will make that decision is an open question (is=
 it dynamic code in the driver? Is it checked via a static manifest? Someth=
ing else?) but I want to clarify that AMD FW is not making any trust decisi=
ons on behalf of the guest here.

>
> That also works for KVM:  The guest can perform attestation on its own
> behalf, setup encryption and drive the TDISP state machine.  If the guest=
's
> memory is encrypted with SEV or TDX, the IDE keys generated by the guest
> are invisible to the VMM and hence confidentiality is achieved.
> The guest can communicate the keys securely to the device via IDE_KM and
> the guest can ask the device to lock down via TDISP.
>
> Yes, the guest may need to rely on the PSP firmware to program the IDE ke=
y
> into the Root Port.  Can you provide that as a service from the PSP firmw=
are?

There is not one set of IDE keys per guest/device pair, that would be impra=
ctical from a HW standpoint.  Instead in the SEV-TIO architecture, there is=
 one set of IDE keys per host/device pair, and traffic from all guests flow=
s over that same stream.  Internal logic in the AMD SoC does access control=
 to ensure that only the correct guest is able to generate trusted packets =
to specific MMIO addresses on that stream.

So what happens is the AMD FW sets up the IDE stream at the device level, b=
ut then individual guests can be bound to individual TDIs.

We have more details at https://www.amd.com/content/dam/amd/en/documents/de=
veloper/sev-tio-whitepaper.pdf.  Jeremy is also doing a talk at KVM Forum n=
ext week on this.

I'll also note that we understand SEV-TIO is not the only potential use cas=
e for these technologies like SPDM/IDE, and there may be bare-metal use cas=
es, or other trust models.

Thanks --David Kaplan

>
> What you seem to be arguing for is a "fat" firmware which does all the
> attestation.  The host kernel is relegated to being a mere DOE proxy.
> And the guest is relegated to being a "dumb" receiver of the firmware's
> attestation results.
>
> What I'm arguing for is a "thin" firmware which provides a minimized set =
of
> services (such as selecting a free IDE stream in the Root Port and writin=
g keys
> into it).
>
> The host kernel can perform attestation and set up encryption for devices=
 it
> wants to use itself.  Once it passes through a device to a guest, the hos=
t
> kernel no longer performs any SPDM exchanges with the device as it's now
> owned by the guest.  The guest is responsible for performing attestation =
and
> set up encryption for itself, possibly with the help of firmware.
>
> If there is no firmware to program IDE keys into the Root Port, the guest
> must ask the VMM to do that.  The VMM then becomes part of the guest's
> TCB, but that trade-off is unavoidable if there's no firmware assistance.
> Some customers (such as Sean) seem to prefer that to trusting a vendor-
> provided firmware.
>
> Remember, this must work for everyone, not just for people who are happy
> with AMD's and Intel's shrink-wrapped offerings.
>
> We can discuss an _OSC bit to switch between firmware-driven attestation
> and OS-native attestation, similar to the existing bits for PCIe hotplug,=
 DPC
> etc.
>
> However, past experience with firmware-handled hotplug and DPC has
> generally been negative and I believe most everyone is preferring the OS-
> native variant nowadays.  The OS has a better overall knowledge of the
> system state than the firmware.  E.g. the kernel can detect hotplug event=
s
> caused by DPC and ignore them (see commit a97396c6eb13).
>
> Similarly, the CMA-SPDM patches I'm working on reauthenticate devices aft=
er
> a DPC-induced Hot Reset or after resume from D3cold.  I imagine it may be
> difficult to achieve the same if attestation is handled by firmware.
>
> I'm talking about commit "PCI/CMA: Reauthenticate devices on reset and
> resume" on this development branch:
>
> https://github.com/l1k/linux/commits/doe
>
> Thanks,
>
> Lukas
