Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53B3F7D7227
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 19:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbjJYRPR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 13:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjJYRPQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 13:15:16 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2049.outbound.protection.outlook.com [40.107.220.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BEB132;
        Wed, 25 Oct 2023 10:15:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MqGMeFf1ZeIveuOkymIcgdfLqp1ZKHVBUVHQg0OgpOV04oXdasulRqaDFK0iR031m1Ukl4qQJ3Q0l8eOM9Cx04U7G3iYhxEWhsVq+u/s0rUgQpadrj5ELkcvH44LNvqzTyOFuZbkdpX8EvrQDUN0TCjJNPxppoufcNAB+OqWt2zapmOXngbhB7osG5s1jCYSlU1ZPEANUrUoV+jf8quOinxSnJGSEHzrxWuH/4QpO4TX2bPwiE+hlW5YVtsIsiU7Ra27Rjvz0HfQdRSbRzIDfyMdJeoY88GSHVMwEypID0zbjf+LPmPnR4uyLantuGGBqo4A5ILdjfGU1nTOZ6wOTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D7iTYyEdd0ux3kcOnZA4tjXsg2EYTYcZLBS/h2/vivw=;
 b=UBIHCH92twrrY9O8K7UoMOAS8Aisgy2hgXlSDOUnoKjiWDEq/fQVNkwIuZab8Y6Qh1nZb2Co/eqUifhQn48obYcOSDEigaAIKP7/5WoRZeM3YHT1ggztiK4KBuIYmTBbdMqi6cTBmFhFigHiJAAh3OnAUcFazPWMKaY/7hyUYgQdf2jLgE6uLnMhjfpO75qSx0Zq65A5iRhe7tcS7Kqs6S1b9BrjTtnoopX08NM6yp4G15UgSyDC0na1ebcU6wrkhNU+94EH/PIinE5V/fvlxdIpH8YcUVW5drNuVtH6Io7tJMUhjENET/MqCsFQKJMqm8m9iDFHhjatVYiO/Funrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D7iTYyEdd0ux3kcOnZA4tjXsg2EYTYcZLBS/h2/vivw=;
 b=ggA6QeWdr5P6KpCwf43Y5UKXVrJlaYd5VR1xxMEJsObOCxYHYWDPnQNyqTjiifL1p4aZpRrwWCwqww3/HGcC85T/h9leTKke9K0GQ1K8J4HT6X8iKVKNpniFdxMkzE1D7O7Y6nNb+z/9QuQ+yVXpNa7IMvB2K2wzJoPg3woJbGG1mknIDfkq1WhA6OwnRx6M2nyRh9/g3mcGzAg5B+ky3Vl5PXaGdq0QeY1tf8u/wo32dqgCjTaEtveiNVDUwt1YOXYitQ6WEZI0Fb8ou2Wms4X0zdpiKrvfXG/7Cdo9dygT37d9ZwJwrZ06I5tFN549OX4MFNv0acab+q9/Ccq5kg==
Received: from BY5PR12MB3763.namprd12.prod.outlook.com (2603:10b6:a03:1a8::24)
 by DS0PR12MB9323.namprd12.prod.outlook.com (2603:10b6:8:1b3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.19; Wed, 25 Oct
 2023 17:15:12 +0000
Received: from BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::84:dd27:ba92:6b15]) by BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::84:dd27:ba92:6b15%4]) with mapi id 15.20.6907.030; Wed, 25 Oct 2023
 17:15:12 +0000
From:   Ankit Agrawal <ankita@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Topic: [PATCH v12 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Thread-Index: AQHZ/4T6dPreO49caEWsaHN/ceuQqrBOmsSAgAi/5YSAACTLAIABhTmtgAAJHQCAAS20AIAAOkSMgAAn94CAACslEw==
Date:   Wed, 25 Oct 2023 17:15:12 +0000
Message-ID: <BY5PR12MB3763ACDF0C7AD7C8094C91CAB0DEA@BY5PR12MB3763.namprd12.prod.outlook.com>
References: <20231015163047.20391-1-ankita@nvidia.com>
        <20231017165437.69a84f0c.alex.williamson@redhat.com>
        <BY5PR12MB3763356FC8CD2A7B307BD9AAB0D8A@BY5PR12MB3763.namprd12.prod.outlook.com>
        <20231023084312.15b8e37e.alex.williamson@redhat.com>
        <BY5PR12MB37636C06DED20856CF604A86B0DFA@BY5PR12MB3763.namprd12.prod.outlook.com>
        <20231024082854.0b767d74.alex.williamson@redhat.com>
        <BN9PR11MB5276A59033E514C051E9E4618CDEA@BN9PR11MB5276.namprd11.prod.outlook.com>
        <BY5PR12MB376386DD53954BC3233AF595B0DEA@BY5PR12MB3763.namprd12.prod.outlook.com>
 <20231025082019.14575863.alex.williamson@redhat.com>
In-Reply-To: <20231025082019.14575863.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR12MB3763:EE_|DS0PR12MB9323:EE_
x-ms-office365-filtering-correlation-id: 1bb6af8c-4270-4472-f2dc-08dbd57df29b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O7lm4qS+wZ0vkfVaJCMKXLM0N/OY0Z3nxAwt2VW9/cBYr4pyUeIY6yp5F9KTRJ4kztHV7YngyH7d38Spb00ZF2bcFtyQNzq1iPN+IibkLgWTtmzZ6ylcOzNIzhEXUukElOepO5TPYk7vBmcTCCi315LNvA+8YrGyc0FOrZCIA1pncDVn+1LkywoIfMbaXbn6STlZ6gpZ8YBFX2XHkJgtev3vigug1Ue3uynJBgqnZV/8MQ48QMAPXuHp9944Zz8NgQRlzPAO8fTMBJAh/dnEE6ebsV+8pnrD2JYfdjW/iwavy4XZ8tAo0ggvhaOOONJvbFUUpgJakieQ1AE+RxnMvXv5GNEVIn6AYtVyjjtjKFGyqOnmaKLu+KmarUdDvEPAIY4DVKzoEhn1bbdw6phHckWA8l9M+wJTPElTMvwg5RSvntz1yrMlttD7GHNrbsz/xy8gJYhi/HIJ1R2LlREIfexOS1DJ+Yvaaiz3ybqxq/nQJ3fm108DoTRRqIjQ0IUEzt0IXzBihkHtDQp+dV8Z1H4Mrgkh8TAI0yRe/T8kjPJXP98/tuMd4dEZXSb/YeNe6nheVFm2Krikb2k96c0qM2WSIJ1ZwSI0B3rKGbgioIG+7NBz/sM76BnRYL1hQFBQmgEiNtDWpLhj5Np2aapT/joeZAlovyvzaa6P21jgk3o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(136003)(346002)(376002)(39860400002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(2906002)(5660300002)(55016003)(52536014)(83380400001)(26005)(38100700002)(41300700001)(122000001)(4326008)(38070700009)(8676002)(8936002)(76116006)(66476007)(9686003)(66556008)(54906003)(316002)(6916009)(91956017)(66946007)(66446008)(64756008)(6506007)(7696005)(71200400001)(478600001)(33656002)(86362001)(966005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Km870qLPGgxsOowlH/oWhlhYTT5LMOT+6dCyxaeIY1qymwFQqLZqCPIGMX?=
 =?iso-8859-1?Q?2eOGIK9yW33yHVzeAdpewsqOlQekqZtzPetSfwUSUBLlur0qYrXLT7YfIW?=
 =?iso-8859-1?Q?d8pnZRkJ8eK1bQnlWCM4nxoCBeexS1kllRQkS0QHau82urps7VwK2LuEEs?=
 =?iso-8859-1?Q?PQT+kBF4sfplqIZayd9T7vIFYvtZMZZEV6yimzjTG8lDVefBXbNOgh1jZ1?=
 =?iso-8859-1?Q?/myUAXCfspOzy3lAEifJ4INEfsCE4/zehXLEVas2wSvJqqoo9TsB+3c2+u?=
 =?iso-8859-1?Q?I8Hn8Wd0TTCQA2/6nH/tk3sbUvSm0KRVr0qJBBidgrGJxheQ4zIyvZUrcp?=
 =?iso-8859-1?Q?HJGdMosuez7V0F6Nd/mIHyc/d0vS71QQH3R1a46MS4SnFsjvngV0HTYsM1?=
 =?iso-8859-1?Q?8CGN7dsbCwwCRIoCiE8f6RcxyqX5RcoHVU8L2hs563L9LUEnsCYJOhnBoz?=
 =?iso-8859-1?Q?nnmrC7OukNOH78/a/nTj+xqiiFLH64PhQ6EfRiJ4pmxPZrY1EYch5WmLLv?=
 =?iso-8859-1?Q?smYI8zmgX7Oqq6eHUxiAXQjLngVf7S8YqT0dZzq3lSuW5M7oDdZkMbKfrE?=
 =?iso-8859-1?Q?scacKxJyWj9c/9SkY9IJcnh58wWNy+yTc3iYoA+xsPkIaZ/I+QcrwFXzFu?=
 =?iso-8859-1?Q?p/Goi361zPsq312dYpB0R0g9CI281zYncMmFiUSHU7uJsoqmUbaJ1c4B5W?=
 =?iso-8859-1?Q?rqeaipxBD91TLz4dOgvsKzdH2zZ2HVsbdl5mIsWNgiimlNrCbnIkqL7Et/?=
 =?iso-8859-1?Q?wthtDXc8xKuCxbZozwol7MHX5FKzf3J0uf76sYVao2ULnTJMTHKRQBm6J6?=
 =?iso-8859-1?Q?utSj4PZUn3fxWAHcfqEjOknO0Fsd//KsZV7CVqaIEgFDwtZ8bdB4eaK9O7?=
 =?iso-8859-1?Q?Rnhi4pvMUORPutwXTDJBvyGdQ4eRS1RI5ckX+OazIoXsK4Jt1l+and4Klh?=
 =?iso-8859-1?Q?vamljJNZwGQ7CowCIG277BbOaD1updAZ/zMeAauEpLd62sTUBgQx7upOcx?=
 =?iso-8859-1?Q?RSMqdTp51nA3HuRuh+lR6WjKFhkMZs4J2073gRJrapvlbKdZN3C+V9LTKB?=
 =?iso-8859-1?Q?mwDLvMZMnL2Id01MEm8ieaAWVOxpysJLFSDK+fbPQj1mGsUH8LUM8VXc8o?=
 =?iso-8859-1?Q?iA//fEMC4bhq6vHZ1GEX/tx2drKZy8NP8xerD8uTfQ0iyTQTN4r4xm2w5y?=
 =?iso-8859-1?Q?T/GMf7/duc22kNaISWZsi0xXK+4Hes5zCqU2AIn9Cm9U8efe/DFoMzhp/u?=
 =?iso-8859-1?Q?5rGUM1Uacg5k5VVMCKSkJjnNJqHIC+1Hz7QpzOPhLIekCtXCuEYlicOP5w?=
 =?iso-8859-1?Q?vl+ff43KjZ1F5PBKTtlkLRCoY2D7j1YRRbY65bYmBgYMfmpGKL5G9K8M8O?=
 =?iso-8859-1?Q?hWdWi/E5eN0TrLC1X/8ledJL9lYLLkzWI9sraUEsMfYhizdFkTGTDVMox/?=
 =?iso-8859-1?Q?K5UxYyivSEDKGk6iLc1fima/KPXOaaf5W/PACZqPOTjw0qlGhx0UHaGIS9?=
 =?iso-8859-1?Q?LzJJdgd6mnSC1E+gvMBe/dDctGaySyrSFvvMWPX+aYD0Xkg9RLdHDtgd0y?=
 =?iso-8859-1?Q?2fafcQc9mb9KF3kKn5KTrORFhBg2FAOPEIa0+W58dpR/W8c+X1BpYO2LMQ?=
 =?iso-8859-1?Q?CKhjZObOb8ckg=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bb6af8c-4270-4472-f2dc-08dbd57df29b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2023 17:15:12.0551
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H2bNaY+um+mfA/6ITTbRLqrSif/TnIbBeooLkzmDZRptH0NN5jgRknNkm5Cbgqsy82Wpg1FyFmtqTPYe1hah/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9323
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> BTW, it's still never been answered why the latest QEMU series dropped=0A=
> the _DSD support.=0A=
=0A=
The _DSD keys were there in v1 to communicate the PXM start id and the=0A=
count associated with the device to the VM kernel. In v2, we proposed an=0A=
alternative approach to leverage the Generic Initiator (GI) Affinity struct=
ure=0A=
in SRAT (ACPI Spec 6.5, Section 5.2.16.6) to create NUMA nodes. GI structur=
e=0A=
allows an association between a GI (GPU in this case) and proximity domains=
.=0A=
So we create 8 GI structures with a unique PXM Id and the device BDF. This=
=0A=
removes the need for DSD keys as the VM kernel could parse the GI structure=
s=0A=
and identify the PXM IDs associated with the device using the BDF.=0A=
(E.g. https://elixir.bootlin.com/linux/latest/source/drivers/gpu/drm/amd/am=
dkfd/kfd_crat.c#L1938)=0A=
=0A=
> In light of that, I don't think we should be independently calculating=0A=
> the BAR2 region size using roundup_pow_of_two(nvdev->memlength).=0A=
> Instead we should be using pci_resource_len() of the physical BAR2 to=0A=
> make it evident that this relationship exists.=0A=
=0A=
Sure, I will make the change in the next posting.=0A=
=0A=
> The comments throughout should also be updated to reflect this as=0A=
> currently they're written as if there is no physical BAR2 and we're=0A=
> making a completely independent decision relative to BAR2 sizing.=A0 A=0A=
> comment should also be added to nvgrace_gpu_vfio_pci_read/write()=0A=
> explaining that the physical BAR2 provides the correct behavior=0A=
> relative to config space accesses.=0A=
=0A=
Yeah, will update the comments.=0A=
=0A=
> The probe function should also fail if pci_resource_len() for BAR2 is=0A=
> not sufficient for the coherent memory region.=A0 Thanks,=0A=
=0A=
Ack.=0A=
=0A=
