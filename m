Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25037D3725
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 14:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjJWMs3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 08:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjJWMs1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 08:48:27 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2066.outbound.protection.outlook.com [40.107.102.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F300A4;
        Mon, 23 Oct 2023 05:48:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gvJDNAoiFaOQfAElohcOh48yPTod3aL49L3wz7nwkGYl7I9fsgWRirZdMo7vcwlxExFL/tiYVWCrHKT2rWxF6/4kbgZ3QDYjxuPzLd6VBvTgEHfhMoSmGefp0/ojM+TlZ2eBAMAcQ1BNOwIod0qaqp+w4pUQ8kg3tOtNXyx6+GYrd9ZjJI/v3M8TVbjVEtY7DqQHggAC8pffBKq8/XivZb9d72Syoh0q9x7kz6fMezlWrOnHBxkUxxOQw8S/RzM3E05ekKDK9mfEY7ANHZuwNqsLTYMDE45Vw1dCznpc9BaDjtnMYXfBzY7UaeX2AmCQP6e3YCksUEs0qTL89fmHpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/nzWLnsO7Qu+VSMOBGaKUNElFHXwRkUc1ciIwl62B78=;
 b=Zshvstt4vCQ7CA/6+RJSRrkLcCEuJ52lgUO4FSNgPuAAZ+0EbCReIwD5FANFy2XzVtqKERJYWtgPKZlxgpGGezzsxitzuQOQv4r32nGx/vXZTJspjj7cKKjUlyuiIba4YF4TNOYP02HjtiJLMy0JKXST4abEGG6bcVdKBcOiOZ+kQKJOdj61WpXauVXoVmDWkrbi+6/Y4zgu8XMl9uJMUW7nzBH5mYx2Ih4xn5DAdWYJemX15c8peYVmuV9p5HjUmu1H2WNC7FTaG08f+38vOnQQ2NbQvjle7E9c2OFQTzhHwNp7KxTOxppo4bv97D3uo9McAJtHOU8SeuY/S2J1Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nzWLnsO7Qu+VSMOBGaKUNElFHXwRkUc1ciIwl62B78=;
 b=kD+ukr9S0L28apvc1ZWGo0OE/SLEu/MtKIKiYELy/Jeac0dQtUCgpQG5no20s0s8skt0eM+ZsZdxncOmPHyZlanPuCjBX2M3OWDv6UezquOaryKm0Ys7PhxRUG0ouG8qfb0Mr7nI9ScGwq0p5VjOHrQ0Ge6yyRBVRGvhJfZ+E1JBSSn/oF4sd25V0d7pURvKm2vWPAjfXodhICT5zJX+N+hM56a5XzXopXGlPe+ELQwdxxSrnUz8MJfJJCIRJDXPfyh4QsEPAXO9MErr7RwpxqGZQJV8idPp2xcLq20FZm9jmO+0wg+piLDuL4ju5HovmFC7jylLF0HxDHhoc7v1gw==
Received: from BY5PR12MB3763.namprd12.prod.outlook.com (2603:10b6:a03:1a8::24)
 by MN0PR12MB5955.namprd12.prod.outlook.com (2603:10b6:208:37e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.31; Mon, 23 Oct
 2023 12:48:22 +0000
Received: from BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::84:dd27:ba92:6b15]) by BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::84:dd27:ba92:6b15%4]) with mapi id 15.20.6907.030; Mon, 23 Oct 2023
 12:48:22 +0000
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
Thread-Index: AQHZ/4T6dPreO49caEWsaHN/ceuQqrBOmsSAgAi/5YQ=
Date:   Mon, 23 Oct 2023 12:48:22 +0000
Message-ID: <BY5PR12MB3763356FC8CD2A7B307BD9AAB0D8A@BY5PR12MB3763.namprd12.prod.outlook.com>
References: <20231015163047.20391-1-ankita@nvidia.com>
 <20231017165437.69a84f0c.alex.williamson@redhat.com>
In-Reply-To: <20231017165437.69a84f0c.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR12MB3763:EE_|MN0PR12MB5955:EE_
x-ms-office365-filtering-correlation-id: 9a78ad40-1a9c-42fe-17a9-08dbd3c6571b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 23bNNaQfBgoRnL2Z12NaqFSAotY/+gjo8HHvEjUqpqQYP4Etf+6WWMU2CgIqtKjm+WgIx72xy6YviQyRBvPKOzFHF4IcPYrviSq5IqBsQ3616m0oVcUCbytNq0mMb6KAcb20fXasdDOg0/B0Gr3jwbKI5r6Hlx60+kDZHJ2ix6QyfBFF0X6kZMmQ5AEMpPxbTYokyfWWlq1chgFozUOYhZ04Y8Hu1ugr4B+JZob1b5olzvk0789EtWJl+LgDWxriYWSHjP/uroGTysPsyeCN2v4UIZMUcURHII2pDy+1XMOgkkf1UIvhmYEzyjz3qJKz4fibsd5lOHTWixg+Ia1w6lZyt3DnRGd4b9WCwxiRaPwbYZeUvdBQYmMTBWUckkbUspX+GZ72WXMepWrRVHnuMohR3sTI0my7sY8bEy+MLrPX5amVcDxZPcy57Z4j2liB7nwWJ+E/Fejaak07oP10E7g9ksnaqOXxeRVUoro0rETyN4yH/VQfBHTZ0h1u2k846xnywdcApdXev8ndEV3ZKw6y+/rL95k2lfpPY+wcBV/N+LNGYa/ZwFtPmS2siVTidv3dturCdQwIBcf7rw87VGzFRzYFXMODkj4lod1ZKbZPSQ/wenfuv0tsYUFD/YIE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(346002)(136003)(39860400002)(376002)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(55016003)(4744005)(2906002)(38100700002)(76116006)(66446008)(316002)(64756008)(66556008)(54906003)(66476007)(122000001)(66946007)(6916009)(7696005)(6506007)(91956017)(71200400001)(478600001)(9686003)(41300700001)(52536014)(86362001)(5660300002)(4326008)(33656002)(8936002)(8676002)(38070700009)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?ghPH+k+kNEb+IaY7SzU/g5stGPtmczaZcPKIoe/nSbeV3+PAHLUIH0b79Q?=
 =?iso-8859-1?Q?H56mpWDsE80rHMw7nMvoifDnLkBe6fTgoX7QbkIQGrepIfna3vonfh9qjl?=
 =?iso-8859-1?Q?Lg96rsBRkAod4Wm1S7m5sNipCwtXHimrDJUPmUDDILsUVNZZO8R5E+oYSG?=
 =?iso-8859-1?Q?ni5gZm+TNsDs/j6kTX9PandQ5jdEQQyQZDGi0H6hjgKDrtF7ckuB5VMgf5?=
 =?iso-8859-1?Q?nSwQoDZSZPxR9nNNSaux6CZ31UENPikt8VnbJUqqQuhB6WVQ6/+7GfG3Nl?=
 =?iso-8859-1?Q?6eoRPPY4VbMqK+m9wDUc5SvZFlqy5e3sCsx62ns2AQMS0WpLHe/YnbOHuJ?=
 =?iso-8859-1?Q?SsA1HCIaFKmwmIgDuzVpGOlqWl+0l34x/aLuxya+rVVOc8agiU2TEXiqMj?=
 =?iso-8859-1?Q?f0Bt95m9YWGYCFHm5hMOsfGkSnn73b2WYxGit/0QpbNRktOaAlCTlL3duV?=
 =?iso-8859-1?Q?QkJPESTRu717bg2aPjsfr9tYqqpAvmspMC+REhhJhC+qdFW3yUsRsZKTyh?=
 =?iso-8859-1?Q?KUlvkbtj/yszf9WGxaoy/qYsb3h6aUL7nxulRskOtmD/8b5+2FRl7GMcFv?=
 =?iso-8859-1?Q?6Rj+IwaHsWIpKi7GOWTvO96Y9My4cSFlOzjcZdx72XYtplmcKtznxIbyNK?=
 =?iso-8859-1?Q?myWkanPVRLASkU/4JyvOKMI12pBOF4bpiEUIdH1MpzicXY3nNEc89DHx73?=
 =?iso-8859-1?Q?HK2r/K9sIRFhHPq4tw91YOYClrxs5v5eEQUAwTNivKYjAAn7RYCXfX/AOM?=
 =?iso-8859-1?Q?t34E86DsEM8XU+ZtMV2yFLElv04pFZrLsKO+Kft5YQ5Ts+AQpu17Yi6rG6?=
 =?iso-8859-1?Q?b8oVHaJtCHR8Kbt4QCEqqKUKnZxgOofs3eveQBvRb2BBRKHdU1cML1NWYX?=
 =?iso-8859-1?Q?O7Smbm34tF27gVHDLYQbBiwVhUYZkrNpt2pTJWnjEInoyumxFEMrJM2GrC?=
 =?iso-8859-1?Q?Kw0ShwgQTw8y+zvHQUm/FVfXEBX6bvMGgKOXBqp9D5s+uBN2xBsJUZOOnp?=
 =?iso-8859-1?Q?lx3CE3hde3tr3g8dH7XeUAMIIKM30ERnhuoBqM8xWh+EjmnRwGQeGuxShn?=
 =?iso-8859-1?Q?udUBggNXK92yAQP/yX5H7OUZQvJQe5jlCErmK/4MPVDh683mgk505UV88f?=
 =?iso-8859-1?Q?xw/FPBPyNRFgU7I+E3leR7pmxfcdw28dbqB8O9XcCxKrT0jR4H3Wc+G9Hj?=
 =?iso-8859-1?Q?NZrE6qGTcnVlbUl1WjWfIYcNIq2KL17LulwGZZYrMC7a9JoaqFJhqTIAIx?=
 =?iso-8859-1?Q?WMhrUm85pTUlM9lZUFJIz+eCQpcl3vTU/4qyV6iEOpm84JYEmlU4pwRgMp?=
 =?iso-8859-1?Q?vXq5Dh8Uni0VbDYL1AETGoyL6VKjm/TPE1FM+hRhSetLYF86aQhePzBjNu?=
 =?iso-8859-1?Q?qwRTEvKybwfJbsokxzCfLE+APUEBNTO5YaIs37HPy1HK8aymvUp1jGmnDF?=
 =?iso-8859-1?Q?RPHk18FwSczZrAIgsGExzmV6ZcQRZvBzqqpFxziQeANbL3IIp04liNTlKd?=
 =?iso-8859-1?Q?USG0PlWnPtwB8Ivdxp4ZaF1nUD5zYfObohcBXmQA+GtAVdReubjjztvUD2?=
 =?iso-8859-1?Q?zxCUJ2OIlVlRuFo3WJ4FKACqX0S/HjSObnHwMU9haplEoklKz7DjOsjHYz?=
 =?iso-8859-1?Q?UsnMX+s6DBMo0=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a78ad40-1a9c-42fe-17a9-08dbd3c6571b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2023 12:48:22.1173
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GksjS7Op4R6Weo5XaR5SKBx9Fxh8Zd5i9I8BOcEFeqG0UUjbFbbW32lwDpSFdmya60ts6Tjq7j/O7F9mLdvViw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5955
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> After looking at Yishai's virtio-vfio-pci driver where BAR0 is emulated=
=0A=
> as an IO Port BAR, it occurs to me that there's no config space=0A=
> emulation of BAR2 (or BAR3) here.=A0 Doesn't this mean that QEMU register=
s=0A=
> the BAR as 32-bit, non-prefetchable?=A0 ie. VFIOBAR.type & .mem64 are=0A=
> wrong?=0A=
=0A=
Maybe I didn't understand the question, but the PCI config space read/write=
=0A=
would still be handled by vfio_pci_core_read/write() which returns the=0A=
appropriate flags. I have checked that the device BARs are 64b and=0A=
prefetchable in the VM.=0A=
=0A=
> We also need to decide how strictly variant drivers need to emulate=0A=
> vfio_pci_config_rw with respect to BAR sizing, where the core code=0A=
> provides emulation of sizing and Yishai's virtio driver only emulates=0A=
> the IO port indicator bit.=0A=
=0A=
Sorry, it isn't clear to me how would resizable BAR is applicable in this=
=0A=
variant driver as the BAR represents the device memory. Should we be=0A=
exposing such feature as unsupported for this variant driver?=
