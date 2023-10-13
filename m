Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821AD7C7CCA
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 06:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjJMEfi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 00:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjJMEfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 00:35:37 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2062.outbound.protection.outlook.com [40.107.100.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6EEB8;
        Thu, 12 Oct 2023 21:35:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TkhIMVDas+IED8/DZsNdx0sJILNknpRJbFIZdz5v5gCw78YHPG9WgoOHCAxAhdLNoVUXmLr+egWUgjs0ESiJxdIW1QOwQv5Bgv98BoRBJmH0uJpxfzUQG15Rekq+zCy+27p7tZlGJjpJxlOCzs7oyBKLSHINIZsQWM15DYgzPCJWkYAIk1R1fW7g+0TQIeR0T+hgjiCoS8ON7k6KNSD4LM8rTc/HJo8XWf02YvUsEuDCUNo4vtALXjVAq5X7IlKazys7FkqbbhcERSKIHkiApGp/OSM6VicGMEuxh832dOvGkamVOzjY3FizBfAbdcg2H/YYHz+BGPArBI9q2iCfxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4e3BfOPoEqakfZvpPFqQhOyiXjqtyKBaMQgfuj/7oEA=;
 b=At1JXm2oGFbLlSA4q+lk2CodW8O79TyhOWxVRgHrA8TSkp3s5CjZPhvOCqK8spP6Q8DNKrIUwQIKOW9IXOWdOtvxAYbwaJ6CcKgKFdfbIZmWUH1xZzKbfNUoYkcf1AsBh0+YQPm6gzNTLrrM8+LUDFdzfl2P8bwGautmeHf5iu+vFsZrnW8qRTIt5FmFNVvvvKoTh665ONB181jSKBejEqtdQsIl5EpslxxZgHmI/Y7c1o5yTN1z+jZerIyr544Th1UUcH75Zw2mXu3EiU0roDv9RGWbIk3oyRyBq7/M90hFWULPXO7NFIswGPTIpwnVOAJQhQxDctWYoIH7UXF4jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4e3BfOPoEqakfZvpPFqQhOyiXjqtyKBaMQgfuj/7oEA=;
 b=lyvARRfj38ZZ3qYsYW3FPKd6vi5uToGTNtIt1eIt3/9OjobNToZm9Hts6Rb1hkc2qJ9lNBnC1RWz8qLe9XFi7LE9p7razK1IgU+dMbgQlH7zklUoaCKHRVhf6lMRifLS+khW34kuF8x3Bz9AVev+m6teJnpWNq71RxW4kXPxLkizu4cTccCIY7WuVAtwpCy5rLOFYeAsTD5B4qgk9aIoO5IdMHdZeFrJSPYd5htxsAvTXNlgGHKzGhhXnywbHrNV8Sj6HXdwdsWl3AfiGtKn1MURUHNETwjdGc7s54H6cpXHZTaHpJ4/vtD+2XD2lRZi+vRM00FF5cdj6YqbWya6kg==
Received: from BY5PR12MB3763.namprd12.prod.outlook.com (2603:10b6:a03:1a8::24)
 by DM4PR12MB5136.namprd12.prod.outlook.com (2603:10b6:5:393::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Fri, 13 Oct
 2023 04:35:33 +0000
Received: from BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::8df1:6ad8:23c2:fb65]) by BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::8df1:6ad8:23c2:fb65%6]) with mapi id 15.20.6863.043; Fri, 13 Oct 2023
 04:35:33 +0000
From:   Ankit Agrawal <ankita@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        Andy Currid <acurrid@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Dan Williams <danw@nvidia.com>,
        "Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>,
        Uday Dhoke <udhoke@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v11 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Topic: [PATCH v11 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Thread-Index: AQHZ+VwZzEYyxKTXvkyqTl+ivQIWJLBCuJyAgAAv+4CAAPIcAIAAp58AgAKZ7wCAAAzEEg==
Date:   Fri, 13 Oct 2023 04:35:33 +0000
Message-ID: <BY5PR12MB37639B69034A05493A4F5FAFB0D2A@BY5PR12MB3763.namprd12.prod.outlook.com>
References: <20231007202254.30385-1-ankita@nvidia.com>
 <BN9PR11MB52762EE10CBBDF8AB98A53788CCDA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20231010113357.GG3952@nvidia.com>
 <BN9PR11MB5276ECF96BAC7F59C93B5E4A8CCCA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20231011120026.GU3952@nvidia.com>
 <BN9PR11MB52760535A35EB5EE710625B78CD2A@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB52760535A35EB5EE710625B78CD2A@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR12MB3763:EE_|DM4PR12MB5136:EE_
x-ms-office365-filtering-correlation-id: af002dcf-d00e-4d4b-11c4-08dbcba5d678
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xRhjhgDmMhuMlAgoG4nCdMQA8t8oaQSqvlxwB3YI2XVx434y3N61pnUXdWVsfLLDtTun8FUfYSyn40S8iEHOvPet1L2j10r1T0/d6e+d9M+l563MjurB2iQeMoZ+P3xb+0Hwr6eHGw+FSO3jz+ZT6eldh95oAPo/vYq2ggoGFQ+6690mXjRQiKZSxNADRKkgmTRhDZYCPdPhHKBGRYRXdsVX1NA9UP0HaeyFjXZ1ZS0k6awqcbTkgSbAw0n9od6DconyoW0a+qeWiivi6/nx6ogJePDj2i/CmzPr6E2LW4TA4TBnDQw8oUnyxpKx/bz6v/P1EUDuiS7lmJxwurSpSZrwlLDVa9z+m4uFTXUMaIufpVwQwm7sQ+tVeROl7b4DnaaGjPrzuBxSfgeqEVo3ywjrg07aAVqq4k21rhjDsY0kZ02BXb+3Rp8jG84nlio3Imz1cjDH5lYM+x7FT/kQOeYUjTgFPVNXP7TDZIZNw6a+XIRyAmDmYkiQotmaS35o1rtIq+0D3Uu3KoIfl1KIzYxKNffD4FUnPSh0uVSNTf4j9sVpMTMOWhnSgNWas76VK8JTPl5OuMG6Vrs+6HisFpceb6w9VZTi1+AH75FBKBRwWVpUhcZo3zl9YhpBnoav
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(376002)(346002)(39860400002)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(6506007)(7696005)(83380400001)(9686003)(110136005)(91956017)(55016003)(316002)(8676002)(6636002)(76116006)(54906003)(64756008)(41300700001)(66946007)(33656002)(2906002)(66556008)(66476007)(66446008)(38100700002)(38070700005)(122000001)(26005)(478600001)(86362001)(71200400001)(5660300002)(52536014)(4326008)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?PtmkP4AuypFmYCOCfFnWA3OnNeD2E/JG2l/N72a6OE7dgIaJO44ZQG9JVi?=
 =?iso-8859-1?Q?QjWg0BOk1xku5r6utr5JuF+/VPWugC15MMcdxEQOtjhrK0G5SLb2M/GCWA?=
 =?iso-8859-1?Q?SXSNimTaPY7XYE9WX/vEdlM/Y49o1mJHDmrhJcPQIfUK+0W6zKo69syE+0?=
 =?iso-8859-1?Q?knZst9P/ebYb+Ia2W773fMsUYiB+51iKC8dq/ty1/4IjXfXdamd4TqKQG6?=
 =?iso-8859-1?Q?CcscgVEOhmeS4HJi+9/JUbk9q6rMAr3fbcKViP92les2wQW4Bz9EwP1JCP?=
 =?iso-8859-1?Q?mpH8OOV0uzHt6ALaWgnsdaqePGcCO3xf56+HgxCDVCYbqWpjYjXCBXlRGd?=
 =?iso-8859-1?Q?9ZwjKrJdP3DRv17LJW5syAKd2tTJBhASbM+qhZnv6r4gdx3maUsB7/qc5d?=
 =?iso-8859-1?Q?bcoVlZdfjtrmfsdzP/r7Ph3OXU44Ih4P4YhsZqV6XY1qIaWglAvE0UIJqk?=
 =?iso-8859-1?Q?/2n3vFHaBdasairLIXB0sQhi9wdqTm4mB3sI4ffPNGxCTraIPvC9wWU9jm?=
 =?iso-8859-1?Q?VwuRP6/0DiyXBsliPyaA+sf2J0U6u6twLAKM7o/ht2mm2gqfqahPvCtXbW?=
 =?iso-8859-1?Q?7cFhOZPnwHeVzdK5CT2rir0Tc4nfGs7qNbqQqPf4IMjj0UAMCkIrWWNKuw?=
 =?iso-8859-1?Q?9MleYiHs2hTd59KaOSYuY9zCyczvklDkVwqFjc/LAyfEXz/LfuRrUASXEP?=
 =?iso-8859-1?Q?BnliweMyBu7k5g47FPuDe9wBYtt+R7ISejaRSDKWwjQI7GZjoXLNDJKhl5?=
 =?iso-8859-1?Q?6ZssRDI7DcQ/ELft+Gux+uPNpNa50kK6vBfVFMfP0KQPrCc3ls7mWM4rds?=
 =?iso-8859-1?Q?EeoQcxdbq1l3gz/xKX82/zyovFP+jG1MoDj9bHfuvESlZR4LtpmIkZUV4k?=
 =?iso-8859-1?Q?GwVwPQXxSPqAeUZDLDBHYLM0hRFJH2FxW7M6ZgLtxlgZZ5OaBbnnUrcr5B?=
 =?iso-8859-1?Q?tOZsoEwHlBK5iZiAuubxlNdlOY65XsR05wVhrJwS5yBQQe8shXL+lIABGL?=
 =?iso-8859-1?Q?+2SdTIEr2rKZWEIINKLW6PUmN5B2hcEhWr+wDErgT+5wd0cfFSJrTPR0/8?=
 =?iso-8859-1?Q?Mdvukd+BVvQaTrr6CFGtXaejHsQ10fGKOWmBvxkWU/PabpEjCzgCcBLxkv?=
 =?iso-8859-1?Q?KNRVnE5ov6wG+lVQsAg/fPQ+S60oogs6NPTYtPYWII2AuzR9YIjWrkDkHT?=
 =?iso-8859-1?Q?JvvSjPoq5wPcqwyy3gOwdFlRFxfCYg0kuhKFt/T2CihCbsnRZA9wBMOIS1?=
 =?iso-8859-1?Q?Nk+NIDA4fwziW4UYluMuiFgm2bQl8mqbkZ8kLSE7kM8s7xaWy2jcQ8yof+?=
 =?iso-8859-1?Q?XXn9l9nNywWahbeDpPU/qJWslMzQrRoH/VKwwMkeVfL3UK9vFf7Ud2bfmc?=
 =?iso-8859-1?Q?PHQawWXCGQoPB87HMl1r8pywtsVzatS19wG61rSgrdvHG2q4JaUbXoxtAM?=
 =?iso-8859-1?Q?MSX43OBwSui+Y5WHgQkZQOim4uz55CcoCtE8RGvClE2/l/GhEmMQqCYeWD?=
 =?iso-8859-1?Q?Yk41CDnWLaVLvNN8qFXzbzOVkwacIy7sZGM7YmiV8pSZ1nMaJ5vr5ly6IK?=
 =?iso-8859-1?Q?K4bQg9mw6k+EH9aybnhuCeZSkW9ElCCLQfjiETrBnsiDTDM8R4GYTIdznR?=
 =?iso-8859-1?Q?UU+RSQK/QNF9s=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af002dcf-d00e-4d4b-11c4-08dbcba5d678
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2023 04:35:33.0667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vTEvc7H/pksUWrxZuWSn7TI9A/89He3p9bqp0twgn9d61bzz2SgNiOiTTHQw+X7Bf1w+LO++muVtk7Z2ca4pSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5136
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks Kevin for the review.=0A=
=0A=
>> > > > >=0A=
>> > > > > PCI BAR are aligned to the power-of-2, but the actual memory on =
the=0A=
>> > > > > device may not. A read or write access to the physical address f=
rom=0A=
>> the=0A=
>> > > > > last device PFN up to the next power-of-2 aligned physical addre=
ss=0A=
>> > > > > results in reading ~0 and dropped writes.=0A=
>> > > > >=0A=
>> > > >=0A=
>> > > > my question to v10 was not answered. posted again:=0A=
>> > >=0A=
>> > > The device FW knows and tells the VM.=0A=
>> > >=0A=
>> >=0A=
>> > This driver reads the size info from ACPI and records it as=0A=
>> > nvdev->memlength.=0A=
>>=0A=
>> Yes, the ACPI tables have a copy of the size.=0A=
>=0A=
> So the ACPI copy is mainly introduced for the use of VFIO given the=0A=
> real device driver can already retrieve it from device FW?=0A=
=0A=
Yes, the device mem size in ACPI DSDT is kept primarily for the vfio use.=
=0A=
=0A=
>>=0A=
>> > But nvdev->memlength is not exposed to the userspace. How does the=0A=
>> virtual=0A=
>> > FW acquires this knowledge and then report it to the VM?=0A=
>>=0A=
>> It isn't virtual FW, I said device FW. The device itself knows how it=0A=
>> is configured and it can report details about the the memory=0A=
>> space. The VM just DMA's a RPC and asks it.=0A=
>>=0A=
>=0A=
> Interesting. Perhaps this message should be included in the commit=0A=
> message to help compose a clear picture.=0A=
=0A=
I will add it, yes.=0A=
=0A=
> With that,=0A=
>=0A=
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>=0A=
=0A=
Thanks!=
