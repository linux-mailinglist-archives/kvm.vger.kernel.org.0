Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3330C7D5397
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 16:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343518AbjJXODc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 10:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234097AbjJXODa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 10:03:30 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2071.outbound.protection.outlook.com [40.107.220.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D9CD68;
        Tue, 24 Oct 2023 07:03:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R8/EV+2UeUTQQqpGlothLebXYiLJ3z/gAlV4P+Q9tUI2bmzUfMbKRprq4NrFgA2V7fNBYRFGxFleq3NDDJs8HxvKryaOuWYNAbxVlXd084/xx65IA8eK0lF8wVOzgLVBlrFA8W4kMUhDj5aaszHNDW8AWfYMj/3b1Vnf8HLXtzrhYbC3pAGYas+N0vXCck26O1Z4g5aI6OkQO6JXTXij7soyfEyLRGzWT6ZSpnclbwpkF267IRJBg0UUnOGJm6ITbfbDPaFHrPY33ywjzQdHDCDYGAU3F1CVlW/1kcWJXUvdWyWx2w0wkRqbmUX6jBy0GQfALLN7lJr4CjQotFpi2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2g4/kPI6j9Lz3blsf7Sb00bsSfAaAj3YIui5dbWdrxk=;
 b=TpR9LJYo85UFS4q1mk/X+2c6xDb2imEBhths5FiP3A27No323zlcHHyleyUky9dy/72ooy69msWdJldjUF02QqpmPG3W0IT5UhrE7FNj6pv5ZooUKKNYxv2A8hLl8iOBb5LrRJ8i+ewZaH85fO/cGYHFble1exvjd1swaYAuCLAZerT/0XVdJV/KNbWWq5BiSQUHZRULLgbRDO7SG66URifwjAsQjKjKd/slqqBdQwb3hrwBh/aAN7QZiJ9NVrsDSM/LK8S3jr47LAfY/z/A1P7X/GHabBicKE7r7LDARtN2k/rvWNwLBjFwWzYXsRRZvSLDQkhNa1TzBXlcIa/hvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2g4/kPI6j9Lz3blsf7Sb00bsSfAaAj3YIui5dbWdrxk=;
 b=Xg76u5Vuq3h0cq9xqFFoD5t8J7I7VvjUCasUg+4as/cLNh9EoOf+dqSWpw2RtitrZNv8iern70mJxXvckAJWEAmu12td1xh63xoQl+Z+5Qv+sFTIGtKcNsghhRyPGXFGY013p4eeaw+URtaZ0KAECrbM7EswJuAeE6EuaalgGLC4Uy369BN3ObBrIlYDJs0P8qgaoOKVnNdSCDKpvrJLF5WTaEmV+FWizfYoFNi3IcEE+IdEOO2Ja34db4g9zVNxARto+H2eocxB5uWxcTotL+rHfpuoBVkyhbb3CROsA913YQ3WShyaCc0So15qoxcHKTDEXEXGhxoQqOQvR7TCTQ==
Received: from BY5PR12MB3763.namprd12.prod.outlook.com (2603:10b6:a03:1a8::24)
 by SJ2PR12MB9115.namprd12.prod.outlook.com (2603:10b6:a03:55c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Tue, 24 Oct
 2023 14:03:26 +0000
Received: from BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::84:dd27:ba92:6b15]) by BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::84:dd27:ba92:6b15%4]) with mapi id 15.20.6907.030; Tue, 24 Oct 2023
 14:03:25 +0000
From:   Ankit Agrawal <ankita@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        Andy Currid <acurrid@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Dan Williams <danw@nvidia.com>,
        "Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Topic: [PATCH v12 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Thread-Index: AQHZ/4T6dPreO49caEWsaHN/ceuQqrBOmsSAgAi/5YSAACTLAIABhTmt
Date:   Tue, 24 Oct 2023 14:03:25 +0000
Message-ID: <BY5PR12MB37636C06DED20856CF604A86B0DFA@BY5PR12MB3763.namprd12.prod.outlook.com>
References: <20231015163047.20391-1-ankita@nvidia.com>
        <20231017165437.69a84f0c.alex.williamson@redhat.com>
        <BY5PR12MB3763356FC8CD2A7B307BD9AAB0D8A@BY5PR12MB3763.namprd12.prod.outlook.com>
 <20231023084312.15b8e37e.alex.williamson@redhat.com>
In-Reply-To: <20231023084312.15b8e37e.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR12MB3763:EE_|SJ2PR12MB9115:EE_
x-ms-office365-filtering-correlation-id: efb93b18-de2c-40ac-77df-08dbd499fdb0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QveY4kxJYCwAAFRInPjbsWXsZdry2fLfKPMs52isgjKPieC6VyiYyRosY2Jvl/7rnZ1Zto8uHkzbAWkJYHyWz0ckEkJlBbaXwoea0jSFLgVtqwjDCyUCNIFCERhDIV+ny50+6WPQdi3ZUn8cFjsrYKQpq7pRqGFKHW1UbsVq8h+ZjOOjRQt3tfSVl4PIBovjW+EQUVrl9FIOLyHT/2KGYVzfYvEPvHzKO2KOZaoEe4XwnChQRLzNiogV11LbR2mZAI5KVNPq/seILEjh3X458rM0WHxb4Is+Q39RRqOD2t5qbSs/9e1wo4oXUeCyVZsdGgZISgR3xNbN4ZVh8B1v6YnR0nnrLiJfS1FCLj6KVWSUH4zSIXIP5xEGunXaK8R4l5XeHImBWyu4GVYQRbjk1M5aqjDXuiokvy/Ku//khWcHsMeyWrlbDpO3whu7YdeI3B7XDKVAR4Nl9D5FdvbzPIcQgy9nyw0JunBlyB/H4igEzSLq68ULMGGP1ELSOT4+LxTEO5zD4a+mPNxp0sElSe2TWvbKGqWP3YW1ufl9w/ghmQXYZSVZB3shUcPDEPdb8UU7glQDkfJsefg73eCSIEDm0hQGVwI9th54pe4lyeMiddN7O790RpXcYsjZl+/M
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(346002)(136003)(376002)(366004)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(6916009)(38070700009)(2906002)(55016003)(5660300002)(8676002)(8936002)(4326008)(52536014)(64756008)(66556008)(316002)(66446008)(478600001)(33656002)(54906003)(91956017)(76116006)(86362001)(9686003)(6506007)(71200400001)(7696005)(41300700001)(26005)(66476007)(38100700002)(66946007)(122000001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?9Irtlqp0ePZFyknEK7iNjt4/eLwgisrUR/GnFfXpE6FqAJSmEB6GhnQaZ9?=
 =?iso-8859-1?Q?gm9GoTcs7uL6KwjqfpAQ+Le99zJQbcXnXslFaPIcepocYmQkNn8RsYjtuA?=
 =?iso-8859-1?Q?y2AiqtLfhQhAQw14Der/mM3QvSmtpraRaEc74AXiLvK4XkehWl6wgLEbDJ?=
 =?iso-8859-1?Q?kN/cdyV7j8PwGcf4RkRLs+rZWQY+SA0ZCCCqdiZJIOXhIdDgVb/OUBUXVa?=
 =?iso-8859-1?Q?4WvG0hRciMOwq+Dw/lgY9lm4mIMCfPzcm+Z/ZQQqIeOHE7XeHhDQvjrj2v?=
 =?iso-8859-1?Q?rVnRNS6xqrACCDNtEx8sNJYx62RvPRSyNDmhlybGpmhk4XPZJoEr3yuUdK?=
 =?iso-8859-1?Q?aMrD1SklQeH63M5mJy0d5YgykBf52iQ90+UR8ycmGfqEeWxtvmYnbbCSyL?=
 =?iso-8859-1?Q?zzcrbN6U4cq2/uuafTlrnxZ/qg3jSHxVRh4+NmNIFgWsnlkhX0DnPvWXn0?=
 =?iso-8859-1?Q?d8K0N3ni30jvXbah1AX7/mMXAx5Klf7xyCCR/zlL4Gw3wVz9m8IeK/DeyU?=
 =?iso-8859-1?Q?sLKDZaBKycA/B2nGgjtqxceMqu8+L5J5wX1fqBhHFW0FyO1RKGS8iYMPp4?=
 =?iso-8859-1?Q?dw+6JIEtBVqCKlnK6/ZXyIRoQl9tsE5UScaUBKUhiwqmV4h1yjgY9Ko9PQ?=
 =?iso-8859-1?Q?Qhs+pbYB4Q2fN0qlH7mQt8TtSCAcJxbexer82ZY46UW/PTghZ7E1S9QIr+?=
 =?iso-8859-1?Q?nHVjErRxmtIBUDUqRm3p+8DDw+kG9pA8mnFq6/cj087k8jN0EEie/NqASa?=
 =?iso-8859-1?Q?/nkcgW29099jI5ybk8cAHMPKSdx5eC9NwPemb1yNyAxmlQP7B8/5LXntSI?=
 =?iso-8859-1?Q?4ylE3400qMJFhV2yhfcZVFPdIJv7ttxQYVCflJ5NteTM8fOCgTY/++xuId?=
 =?iso-8859-1?Q?+TVLbjKVYyta4RTGU9+1MHl3xTOUkd6YSute3nd48WbUZnq3NAMZqVs+lo?=
 =?iso-8859-1?Q?CKI68YV4CfwG8UAfh2uPSeg76oPvzTBHx+LV+YHpTmbZeVj6wI8DjVIck4?=
 =?iso-8859-1?Q?9/8sCyW9N5F+q1O21rGFWbZYLOfFk/Z3PumyU2g4+pUAq0YT8CcBTGqOFq?=
 =?iso-8859-1?Q?YUv5UPjLNOPfL+9hoUkBSoESRCM2CuYyy5b0mHiPbN2MpJgHqQ5sHTxwmM?=
 =?iso-8859-1?Q?pNfJvuZ+JUyV9FX7E41s1OnQD316ki7xojkHJb+QYunTZ8o9oCHSY6Yey2?=
 =?iso-8859-1?Q?bCwmlySCgL7AUmXtcAzo9jlGi5Amncn0d5VAMpnxFDGN1IaT0+BOGtuu/F?=
 =?iso-8859-1?Q?pd694vB3CcxbSh2o50OWT/F1UgzUKa1oYOyKBklSreaTFHfVSPOIWBqS4n?=
 =?iso-8859-1?Q?elc2nK6Q5JKexJhRNSTyrS0k1DMg9NQafgvEVTlzgax+qtHlUZEJvF663D?=
 =?iso-8859-1?Q?aaR4tLTB1J6PRQ/PuSgR0nEveHPcufqVvXjwUIx88DByYpNQVtsmnUM/1n?=
 =?iso-8859-1?Q?/GLcFScrdfr6kRA7drPRalxeutX1AuQc3BiJBtwM1W4t7SzEQ3ZdTznroT?=
 =?iso-8859-1?Q?gl3lbv5h75yMPwic69utmuQ8s+qM+7p/uA/sZSUeI6o5ObprSySydClCst?=
 =?iso-8859-1?Q?s4grD2/5KL0PEZnHepgyLK2+iIKnYzrcDTDqtfqKWUS7ktXNefe8pvM1rr?=
 =?iso-8859-1?Q?pV14W3C4Jym/A=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efb93b18-de2c-40ac-77df-08dbd499fdb0
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2023 14:03:25.3840
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C1tMaqkO15FdIlQxujXdkwynim++vZTNa7k+7PQcLkaXnMWwhz8fh1CJh+a22lXm9pWEx+iZuMx2sLzjOlq/XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9115
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> > After looking at Yishai's virtio-vfio-pci driver where BAR0 is emulate=
d=0A=
>> > as an IO Port BAR, it occurs to me that there's no config space=0A=
>> > emulation of BAR2 (or BAR3) here.=A0 Doesn't this mean that QEMU regis=
ters=0A=
>> > the BAR as 32-bit, non-prefetchable?=A0 ie. VFIOBAR.type & .mem64 are=
=0A=
>> > wrong?=0A=
>>=0A=
>> Maybe I didn't understand the question, but the PCI config space read/wr=
ite=0A=
>> would still be handled by vfio_pci_core_read/write() which returns the=
=0A=
>> appropriate flags. I have checked that the device BARs are 64b and=0A=
>> prefetchable in the VM.=0A=
>=0A=
> vfio_pci_core_read/write() accesses the physical device, which doesn't=0A=
> implement BAR2.=A0 Why would an unimplemented BAR2 on the physical device=
=0A=
> report 64-bit, prefetchable?=0A=
>=0A=
> QEMU records VFIOBAR.type and .mem64 from reading the BAR register in=0A=
> vfio_bar_prepare() and passes this type to pci_register_bar() in=0A=
> vfio_bar_register().=A0 Without an implementation of a config space read=
=0A=
> op in the variant driver and with no physical implementation of BAR2 on=
=0A=
> the device, I don't see how we get correct values in these fields.=0A=
=0A=
I think I see the cause of confusion. There are real PCIe compliant BARs=0A=
present on the device, just that it isn't being used once the C2C=0A=
interconnect is active. The BARs are 64b prefetchable. Here it the lspci=0A=
snippet of the device on the host.=0A=
# lspci -v -s 9:1:0.0=0A=
0009:01:00.0 3D controller: NVIDIA Corporation Device 2342 (rev a1)=0A=
        Subsystem: NVIDIA Corporation Device 16eb=0A=
        Physical Slot: 0-5=0A=
        Flags: bus master, fast devsel, latency 0, IRQ 263, NUMA node 0, IO=
MMU group 19=0A=
        Memory at 661002000000 (64-bit, prefetchable) [size=3D16M]=0A=
        Memory at 662000000000 (64-bit, prefetchable) [size=3D128G]=0A=
        Memory at 661000000000 (64-bit, prefetchable) [size=3D32M]=0A=
=0A=
I suppose this answers the BAR sizing question as well?=
